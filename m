Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 1B0727F53
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007456 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 05/18] xfstests: Redo option parsing
MIME-Version: 1.0
Message-Id: <20130314130611.6A23953C7F62@polaris-admin.engr.sgi.com>
From: pwhite@sgi.com (Philip White)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Phil White <pwhite@sgi.com>


This is a rebasing & resubmit of a dchinner patch.  His comments on the
original:
-----------------
The option parise in a messy loop of option parsing and actions on
secondary arguments. Turn it into something much neater and esay to
understand rather than a mess of temporary variables and tortured
logic...
-----------------

This required some deviation owing to the decision made in patch #2 of this
series.

Signed-off-by: Phil White <pwhite@sgi.com>
---
 check  |   39 ++++---
 common |  383 ++++++++++++++++++++++++++--------------------------------------
 2 files changed, 174 insertions(+), 248 deletions(-)

diff --git a/check b/check
index 9a5b256..bad2e4d 100755
--- a/check
+++ b/check
@@ -33,19 +33,9 @@ export QA_CHECK_FS=${QA_CHECK_FS:=true}
 # number of diff lines from a failed test, 0 for whole output
 export DIFF_LENGTH=${DIFF_LENGTH:=10}
 
-# by default don't output timestamps
-timestamp=${TIMESTAMP:=false}
-
 # generic initialization
 iam=check
 
-# we need common.config
-if ! . ./common.config
-then
-    echo "$iam: failed to source common.config"
-    exit 1
-fi
-
 # we need common
 . ./common
 
@@ -63,15 +53,26 @@ then
     exit 1
 fi
 
-_wallclock()
-{
-    date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
-}
-
-_timestamp()
+usage()
 {
-    now=`date "+%T"`
-    echo -n " [$now]"
+           echo "Usage: $0 [options] [testlist]"'
+
+check options
+    -xfs                test XFS (default)
+    -udf                test UDF
+    -nfs                test NFS
+    -l                 line mode diff
+    -udiff             show unified diff (default)
+    -n                 show me, do not run tests
+    -T                 output timestamps
+    -r                         randomize test order
+
+testlist options
+    -g group[,group...]        include tests from these groups
+    -x group[,group...]        exclude tests from these groups
+    NNN                        include test NNN
+    NNN-NNN            include test range (eg. 012-021)
+'
 }
 
 _wrapup()
@@ -276,7 +277,7 @@ do
 		echo " - no qualified output"
 		err=true
 	    else
-		if diff $seq.out $tmp.out >/dev/null 2>&1
+		if $diff $seq.out $tmp.out >/dev/null 2>&1
 		then
 		    if $err
 		    then
diff --git a/common b/common
index 0723224..2553fe9 100644
--- a/common
+++ b/common
@@ -27,13 +27,55 @@ _setenvironment()
     export MSGVERB
 }
 
+get_group_list()
+{
+	grp=$1
+	grpl=$(sed -n < group \
+			-e 's/#.*//' \
+			-e 's/$/ /' \
+			-e "/^[0-9][0-9][0-9].* $grp /"'{ s/ .*//p }')
+	echo $grpl
+}
+
+expand_test_numbers()
+{
+	# strip leading zeros, could be considered octal.
+	start=`echo $1 | sed 's/^0*//'`
+	end=`echo $2 | sed 's/^0*//'`
+	$AWK_PROG </dev/null '
+BEGIN  { for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
+	| while read id
+	do
+		if grep -s "^$id " group >/dev/null ; then
+			# in group file ... OK
+			echo $id >>$tmp.list
+		elif [ -f expunged ] && $expunge && \
+				egrep "^$id([   ]|\$)" expunged >/dev/null; then
+			# expunged ... will be reported, but not run, later
+			echo $id >>$tmp.list
+		else
+			# oops
+			echo "$id - unknown test, ignored"
+		fi
+	done
+}
+
+_wallclock()
+{
+	date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
+}
+
+_timestamp()
+{
+	now=`date "+%T"`
+	echo -n " [$now]"
+}
+
 here=`pwd`
-rm -f $here/$iam.out
-_setenvironment
 
 check=${check-true}
 
-diff="diff -u"
+diff="`which diff`"
 verbose=false
 group=false
 xgroup=false
@@ -42,7 +84,13 @@ sortme=false
 expunge=true
 have_test_arg=false
 randomize=false
-rm -f $tmp.list $tmp.tmp $tmp.sed
+timestamp=${TIMESTAMP:=false}
+
+SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
+
+# start the initialisation work now
+_setenvironment
+rm -f $tmp.list $tmp.tmp $tmp.sed $here/$iam.out
 
 # Autodetect fs type based on what's on $TEST_DEV
 if [ "$HOSTOS" == "Linux" ]
@@ -52,242 +100,118 @@ else
     export FSTYP=xfs
 fi
 
-for r
-do
-
-    if $group
-    then
-	# arg after -g
-       group_list=$(sed -n < group \
-                       -e 's/#.*//' \
-                       -e 's/$/ /' \
-                       -e "/^[0-9][0-9][0-9].* $r /"'{ s/ .*//p }')
-	if [ -z "$group_list" ]
-	then
-	    echo "Group \"$r\" is empty or not defined?"
-	    exit 1
-	fi
-	[ ! -s $tmp.list ] && touch $tmp.list
-	for t in $group_list
-	do
-	    if grep -s "^$t\$" $tmp.list >/dev/null
-	    then
-		:
-	    else
-		echo "$t" >>$tmp.list
-	    fi
-	done
-	group=false
-	continue
-
-    elif $xgroup
-    then
-	# arg after -x
-	[ ! -s $tmp.list ] && ls [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] >$tmp.list 2>/dev/null
-	group_list=`sed -n <group -e 's/$/ /' -e "/^[0-9][0-9][0-9].* $r /"'{
-s/ .*//p
-}'`
-	if [ -z "$group_list" ]
-	then
-	    echo "Group \"$r\" is empty or not defined?"
-	    exit 1
-	fi
-	numsed=0
-	rm -f $tmp.sed
-	for t in $group_list
-	do
-	    if [ $numsed -gt 100 ]
-	    then
-		sed -f $tmp.sed <$tmp.list >$tmp.tmp
-		mv $tmp.tmp $tmp.list
-		numsed=0
-		rm -f $tmp.sed
-	    fi
-	    echo "/^$t\$/d" >>$tmp.sed
-	    numsed=`expr $numsed + 1`
-	done
-	sed -f $tmp.sed <$tmp.list >$tmp.tmp
-	mv $tmp.tmp $tmp.list
-	xgroup=false
-	continue
-    fi
-
-    xpand=true
-    case "$r"
-    in
-
-	-\? | -h | --help)	# usage
-	    echo "Usage: $0 [options] [testlist]"'
-
-common options
-    -v			verbose
-
-check options
-    -xfs                test XFS (default)
-    -udf                test UDF
-    -nfs                test NFS
-    -l			line mode diff
-    -xdiff		graphical mode diff
-    -udiff		show unified diff (default)
-    -n			show me, do not run tests
-    -q			quick [deprecated]
-    -T			output timestamps
-    -r 			randomize test order
-    
-testlist options
-    -g group[,group...]	include tests from these groups
-    -x group[,group...]	exclude tests from these groups
-    NNN			include test NNN
-    NNN-NNN		include test range (eg. 012-021)
-'
-	    exit 0
-	    ;;
-
-	-udf)	# -udf ... set FSTYP to udf
-	    FSTYP=udf
-	    xpand=false
-	    ;;
-
-	-xfs)	# -xfs ... set FSTYP to xfs
-	    FSTYP=xfs
-	    xpand=false
-	    ;;
-
-	-nfs)	# -nfs ... set FSTYP to nfs
-	    FSTYP=nfs
-	    xpand=false
-	    ;;
-
-	-g)	# -g group ... pick from group file
-	    group=true
-	    xpand=false
-	    ;;
-
-	-l)	# line mode for diff, was default before
-	    diff="diff"
-	    xpand=false
-	    ;;
-
-	-xdiff)	# graphical diff mode
-	    xpand=false
-
-	    if [ ! -z "$DISPLAY" ]
-	    then
-		which xdiff >/dev/null 2>&1 && diff=xdiff
-		which gdiff >/dev/null 2>&1 && diff=gdiff
-		which tkdiff >/dev/null 2>&1 && diff=tkdiff
-		which xxdiff >/dev/null 2>&1 && diff=xxdiff
-	    fi
-	    ;;
+# we need common.config
+if ! . ./common.config
+then
+	echo "$iam: failed to source common.config"
+	exit 1
+fi
 
-	-udiff) # show a unified diff, default now, keep for backward compat
-	    xpand=false
-	    diff="$diff -u"
-	    ;;
+while [ $# -gt 0 ]; do
+	case "$1" in
+	-\? | -h | --help) usage ;;
 
-	-q)	# "quick", no longer used - always quick :-)
-	    xpand=false
-	    ;;
+	-udf)	FSTYP=udf ;;
+	-xfs)	FSTYP=xfs ;;
+	-nfs)	FSTYP=nfs ;;
 
-	-n)	# show me, don't do it
-	    showme=true
-	    xpand=false
-	    ;;
-        -r)	# randomize test order
-	    randomize=true
-	    xpand=false
-	    ;;
+	-g)	group=$2 ; shift ;
+		group_list=$(get_group_list $group)
+		if [ -z "$group_list" ]; then
+			echo "Group \"$group\" is empty or not defined?"
+			exit 1
+		fi
+		[ ! -s $tmp.list ] && touch $tmp.list
+		for t in $group_list; do
+			grep -s "^$t\$" $tmp.list >/dev/null || \
+				echo "$t" >>$tmp.list
+		done
+		;;
+
+	-x)	xgroup=$2 ; shift ;
+		[ ! -s $tmp.list ] && ls $SUPPORTED_TESTS >$tmp.list 2>/dev/null
+		group_list=$(get_group_list $xgroup)
+		if [ -z "$group_list" ]; then
+			echo "Group \"$xgroup\" is empty or not defined?"
+			exit 1
+		fi
 
-	-T)	# turn on timestamp output
-	    timestamp=true
-	    xpand=false
-	    ;;
+		rm -f $tmp.sed
+		numsed=0
+		for t in $group_list
+		do
+			if [ $numsed -gt 100 ]; then
+				sed -f $tmp.sed <$tmp.list >$tmp.tmp
+				mv $tmp.tmp $tmp.list
+				numsed=0
+				rm -f $tmp.sed
+			fi
+			echo "/^$t\$/d" >>$tmp.sed
+			numsed=`expr $numsed + 1`
+		done
+		sed -f $tmp.sed <$tmp.list >$tmp.tmp
+		mv $tmp.tmp $tmp.list
+		;;
 
-	-v)
-	    verbose=true
-	    xpand=false
-	    ;;
-	-x)	# -x group ... exclude from group file
-	    xgroup=true
-	    xpand=false
-	    ;;
-	'[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]')
-	    echo "No tests?"
-	    status=1
-	    exit $status
-	    ;;
+	-l)	diff="`which diff`" ;;
+	-udiff)	diff="$diff -u" ;;
 
-	[0-9]*-[0-9]*)
-	    eval `echo $r | sed -e 's/^/start=/' -e 's/-/ end=/'`
-	    ;;
+	-n)	showme=true ;;
+	-r)	randomize=true ;;
+	-T)	timestamp=true ;;
 
-	[0-9]*-)
-	    eval `echo $r | sed -e 's/^/start=/' -e 's/-//'`
-	    end=`echo [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] | sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
-	    if [ -z "$end" ]
-	    then
-		echo "No tests in range \"$r\"?"
+	"$SUPPORTED_TESTS")
+		echo "No tests?"
 		status=1
 		exit $status
-	    fi
-	    ;;
+		;;
 
-	*)
-	    start=$r
-	    end=$r
-	    ;;
+	[0-9]*-[0-9]*)
+		eval `echo $1 | sed -e 's/^/start=/' -e 's/-/ end=/'`
+		expand_test_numbers $start $end
+		have_test_arg=true
+		;;
 
-    esac
+	[0-9]*-)
+		eval `echo $1 | sed -e 's/^/start=/' -e 's/-//'`
+		end=`echo $SUPPORTED_TESTS | \
+			sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
+		if [ -z "$end" ]; then
+			echo "No tests in range \"$1\"?"
+			status=1
+			exit $status
+		fi
 
-    # get rid of leading 0s as can be interpreted as octal
-    start=`echo $start | sed 's/^0*//'`
-    end=`echo $end | sed 's/^0*//'`
+		expand_test_numbers $start $end
+		have_test_arg=true
+		;;
 
-    if $xpand
-    then
-	have_test_arg=true
-	$AWK_PROG </dev/null '
-BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
-	| while read id
-	do
-	    if grep -s "^$id " group >/dev/null
-	    then
-		# in group file ... OK
-		echo $id >>$tmp.list
-	    else
-		if [ -f expunged ] && $expunge && egrep "^$id([ 	]|\$)" expunged >/dev/null
-		then
-		    # expunged ... will be reported, but not run, later
-		    echo $id >>$tmp.list
-		else
-		    # oops
-		    echo "$id - unknown test, ignored"
-		fi
-	    fi
-	done
-    fi
+	--large-fs)		export LARGE_SCRATCH_DEV=yes ;;
+	--extra-space=*)	export SCRATCH_DEV_EMPTY_SPACE=${r#*=} ;;
 
+	-*)	usage ;;
+	*)	expand_test_numbers $1 $1 ;
+		have_test_arg=true
+		;;
+	esac
+	shift
 done
 
 if [ -s $tmp.list ]
 then
     # found some valid test numbers ... this is good
     :
-else
-    if $have_test_arg
-    then
+elif $have_test_arg
+then
 	# had test numbers, but none in group file ... do nothing
 	touch $tmp.list
-    else
+else
 	# no test numbers, do everything from group file
 	sed -n -e '/^[0-9][0-9][0-9]*/s/[ 	].*//p' <group >$tmp.list
-    fi
 fi
 
-# should be sort -n, but this did not work for Linux when this
-# was ported from IRIX
-#
-list=`sort $tmp.list`
+# sort the list of tests into numeric order
+list=`sort -n $tmp.list`
 rm -f $tmp.list $tmp.tmp $tmp.sed
 
 if $randomize
@@ -295,20 +219,21 @@ then
     list=`echo $list | awk -f randomize.awk`
 fi
 
+# check for correct setup
 case "$FSTYP" in
-    xfs)
-	 [ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
-	 [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
-	 [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
-	 [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
-	 [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found" 
-	 ;;
-    udf)
-	 [ "$MKFS_UDF_PROG" = "" ] && _fatal "mkfs_udf/mkudffs not found"
-	 ;;
-    btrfs)
-	 [ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
-	 ;;
-    nfs)
-	 ;;
+	xfs)
+		[ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
+		[ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
+		[ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
+		[ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
+		[ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found"
+		;;
+	udf)
+		[ "$MKFS_UDF_PROG" = "" ] && _fatal "mkfs_udf/mkudffs not found"
+		;;
+	btrfs)
+		[ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
+		;;
+	nfs)
+		;;
 esac
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
