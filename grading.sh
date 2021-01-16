#!/bin/bash

correct (){
	echo "  ✓ $1"
	score=$((score+1))
}

incorrect (){
	echo "  X $1"
}

score=0
total=0

grade1 (){
	POINTS=2
	echo "1) Checking - Make a new change to a branch (${POINTS} pts)"
	total=$((total+$POINTS))
	BRANCH="alter-readme"
	git checkout $BRANCH > /dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		incorrect "branch ${BRANCH} exists"
		return
	fi
	correct "branch ${BRANCH} exists"

	if [ -f editor.md ]; then
		correct "editor.md exists"
	else
		incorrect "editor.md exists"
	fi
}
grade1

grade2 (){
	POINTS=3
	echo "2) Checking - Move a branch (${POINTS} pts)"
	total=$((total+$POINTS))
	BRANCH="A"
	git checkout $BRANCH > /dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		incorrect "branch ${BRANCH} exists"
		return
	fi
	correct "branch ${BRANCH} exists"

	if [ "$(git log --oneline | wc -l)" -eq "5" ]; then
		correct "branch ${BRANCH} has the correct number of commits"
	else 
		incorrect "branch ${BRANCH} has the correct number of commits"
	fi

	if [ "$(git log --oneline | head -n 1 | grep -c ^95cbf4a)" -eq "0" ]; then
		incorrect "branch ${BRANCH} has 95cbf4a as the last commit"
		return
	fi
	correct "branch ${BRANCH} has 95cbf4a as the last commit"
}
grade2

grade3 (){
	POINTS=3
	echo "3) Checking - Merge a branch (${POINTS} pts)"
	total=$((total+$POINTS))
	BRANCH="C"
	git checkout $BRANCH > /dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		incorrect "branch ${BRANCH} exists"
		return
	fi
	correct "branch ${BRANCH} exists"

	if [ "$(git cat-file commit HEAD | head -n 4 | grep -c ^parent)" -eq "2" ]; then
		correct "The last commit of branch ${BRANCH} has 2 parents"
	else 
		incorrect "The last commit of branch ${BRANCH} has 2 parents"
	fi

	if [ -d branch-B-work -a -d branch-C-work ]; then
		correct "branch B and C content have been merged in branch ${BRANCH}"
		return
	fi
	incorrect "branch B and C content have been merged in branch ${BRANCH}"
}
grade3


grade4 (){
	POINTS=3
	echo "4) Checking - Merge a branch (part 2) (${POINTS} pts)"
	total=$((total+$POINTS))
	BRANCH="E"
	git checkout $BRANCH > /dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		incorrect "branch ${BRANCH} exists"
		return
	fi
	correct "branch ${BRANCH} exists"

	if [ "$(git cat-file commit HEAD | head -n 4 | grep -c ^parent)" -eq "1" ]; then
		correct "The last commit of branch ${BRANCH} has 2 parents"
	else 
		incorrect "The last commit of branch ${BRANCH} has 2 parents"
	fi

	if [ -d branch-D-work -a -d branch-E-work ]; then
		correct "branch D and E content have been merged into branch ${BRANCH}"
		return
	fi
	incorrect "branch D and E content have been merged into branch ${BRANCH}"
}
grade4


grade5 (){
	POINTS=3
	echo "5) Checking - Prepping a release (${POINTS} pts)"
	total=$((total+$POINTS))
	BRANCH="G"
	git checkout $BRANCH > /dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		incorrect "branch ${BRANCH} exists"
		return
	fi
	correct "branch ${BRANCH} exists"

	if [ "$(git log --oneline | grep -c ^99cf213)" -eq "1" ]; then
		incorrect "Branch ${BRANCH} does not contain the 'change text color' feature"
	else 
		correct "Branch ${BRANCH} does not contain the 'change text color' feature"
	fi

	# passed-qa-also.txt  passed-qa-too.txt  passed-qa.txt  should-not-be-released.txt

	declare -a FILES=(passed-qa-also.txt passed-qa-too.txt passed-qa.txt)
	for FILE in "${FILES[@]}"; do
		if [ ! -f branch-F-work/$FILE ]; then
			incorrect "Branch ${BRANCH} contains the desired new features from F"
		fi
	done
	correct "Branch ${BRANCH} contains the desired new features from F"
}
grade5

grade6 (){
	POINTS=3
	echo "6) Checking - Commit early and often (${POINTS} pts)"
	total=$((total+$POINTS))
	BRANCH="H"
	git checkout $BRANCH > /dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		incorrect "branch ${BRANCH} exists"
		return
	fi
	correct "branch ${BRANCH} exists"

	if [ "$(git log --oneline | wc -l)" -eq "3" ]; then
		correct "Branch ${BRANCH} has been squashed to 3 total commits"
	else 
		incorrect "Branch ${BRANCH} has been squashed to 3 total commits"
	fi

	if [ "$(cat branch-H-work/my-awesome-new-feature-that-i-have-been-working-on-forever.txt | wc -l)" -eq "10" ]; then
		correct "Branch ${BRANCH} has the required contents"
		return
	fi
	incorrect "Branch ${BRANCH} has the required contents"
}
grade6

grade7 (){
	POINTS=2
	echo "7) Checking - Tag code (${POINTS} pts)"
	total=$((total+$POINTS))
	BRANCH="K"
	git checkout $BRANCH > /dev/null 2>&1
	if [ "$?" -ne "0" ]; then
		incorrect "branch ${BRANCH} exists"
		return
	fi
	correct "branch ${BRANCH} exists"

	if [ -d branch-I-work -a -d branch-J-work ]; then
		correct "branch I and J content have been merged in branch ${BRANCH}"
		return
	fi
	incorrect "branch I and J content have been merged in branch ${BRANCH}"
}
grade7

echo "Final score: ${score} out of ${total} or $(echo $score/$total*15 | bc -l)/15"
