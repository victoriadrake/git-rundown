#!/bin/bash

dir="$1"

# No directory has been provided, use current
if [ -z "$dir" ]
then
    dir="`pwd`"
fi

# Make sure directory ends with "/"
if [[ $dir != */ ]]
then
	dir="$dir/*"
else
	dir="$dir*"
fi

# Loop all sub-directories
for f in $dir
do
	# Only interested in directories
	[ -d "${f}" ] || continue

	# Check if directory is a git repository
	if [ -d "$f/.git" ]
	then
        echo -en "\033[0;35m"
	    echo "${f}"
    	echo -en "\033[0m"
		
        mod=0
		cd $f

		# Print branch
        s=$(git status | head -n1)
		echo -en "\033[0;36m${s:10}\033[0m "

		# Check for modified files
		if [ $(git status | grep modified -c) -ne 0 ]
		then
			mod=1
			echo -en "\033[0;93mmodified\033[0m "
		fi

		# Check for untracked files
		if [ $(git status | grep Untracked -c) -ne 0 ]
		then
			mod=1
			echo -en "\033[0;91muntracked\033[0m "
		fi

        # Check for unpushed changes
        if [ $(git status | grep 'Your branch is ahead' -c) -ne 0 ]
        then
            mod=1
            echo -en "\033[0;92munpushed\033[0m "
        fi


		# Check if everything is peachy keen
		if [ $mod -eq 0 ]
		then
			echo -en "nothing to commit"
		fi

        echo -e " "
        
		cd ../
	else
	    echo -en "\033[0;37m"
    	echo "${f}"
		echo "not a git repository"
	    echo -en "\033[0m"
	fi

	echo
done

