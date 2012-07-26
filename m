Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SMmD006784 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:22 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	UTWRLqOlF2XVNCB0 for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:19 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMh-0001Ah-6D
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005VM-3R
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/18] xfstests: clean up and simply check CLI option parsing
Date: Thu, 26 Jul 2012 19:28:00 +1000
Message-Id: <1343294892-20991-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1343294892-20991-1-git-send-email-david@fromorbit.com>
References: <1343294892-20991-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The option parise in a messy loop of option parsing and actions on
secondary arguments. Turn it into something much neater and esay to
understand rather than a mess of temporary variables and tortured
logic...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check     |  414 ++++++++++++++++++++++---------------------------------------
 common.rc |   19 +++
 2 files changed, 169 insertions(+), 264 deletions(-)

diff --git a/check b/check
index bccdc08..df962ae 100755
--- a/check
+++ b/check
@@ -28,45 +28,35 @@ n_bad=0
 bad=""
 notrun=""
 interrupt=true
+diff="diff -u"
+showme=false
+expunge=true
+have_test_arg=false
+randomize=false
+here=`pwd`
+FSTYP=xfs
 
-export QA_CHECK_FS=${QA_CHECK_FS:=true}
-
-# by default don't output timestamps
-timestamp=${TIMESTAMP:=false}
+SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
 
 # generic initialization
 iam=check
 
-# we need common.config
-if ! . ./common.config
-then
-    echo "$iam: failed to source common.config"
-    exit 1
-fi
+export QA_CHECK_FS=${QA_CHECK_FS:=true}
 
-# argument parsing first - currently very messy, needs cleanup.
-_setenvironment()
-{
-    MSGVERB="text:action"
-    export MSGVERB
-}
+# by default don't output timestamps
+timestamp=${TIMESTAMP:=false}
 
 usage()
 {
     echo "Usage: $0 [options] [testlist]"'
 
-common options
-    -v			verbose
-
 check options
     -xfs                test XFS (default)
     -udf                test UDF
     -nfs                test NFS
     -l			line mode diff
-    -xdiff		graphical mode diff
     -udiff		show unified diff (default)
     -n			show me, do not run tests
-    -q			quick [deprecated]
     -T			output timestamps
     -r			randomize test order
     --large-fs		optimise scratch device for large filesystems
@@ -80,258 +70,181 @@ testlist options
 	    exit 0
 }
 
-here=`pwd`
-rm -f $here/$iam.out
-_setenvironment
-
-check=${check-true}
+_setenvironment()
+{
+    MSGVERB="text:action"
+    export MSGVERB
+}
 
-diff="diff -u"
-verbose=false
-group=false
-xgroup=false
-showme=false
-sortme=false
-expunge=true
-have_test_arg=false
-randomize=false
-rm -f $tmp.list $tmp.tmp $tmp.sed
+get_group_list()
+{
+	grp=$1
 
-# Autodetect fs type based on what's on $TEST_DEV
-if [ "$HOSTOS" == "Linux" ]
-then
-    export FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
-else
-    export FSTYP=xfs
-fi
+	grpl=$(sed -n < group \
+		       -e 's/#.*//' \
+		       -e 's/$/ /' \
+		       -e "/^[0-9][0-9][0-9].* $grp /"'{ s/ .*//p }')
+	echo $grpl
+}
 
-for r
-do
+expand_test_numbers()
+{
+	# strip leading zeros, could be considered octal.
+	start=`echo $1 | sed 's/^0*//'`
+	end=`echo $2 | sed 's/^0*//'`
 
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
+	$AWK_PROG </dev/null '
+BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
+	| while read id
 	do
-	    if grep -s "^$t\$" $tmp.list >/dev/null
-	    then
-		:
-	    else
-		echo "$t" >>$tmp.list
-	    fi
+		if grep -s "^$id " group >/dev/null ; then
+			# in group file ... OK
+			echo $id >>$tmp.list
+		elif [ -f expunged ] && $expunge && \
+				egrep "^$id([ 	]|\$)" expunged >/dev/null ; then
+			# expunged ... will be reported, but not run, later
+			echo $id >>$tmp.list
+		else
+			# oops
+			echo "$id - unknown test, ignored"
+		fi
 	done
-	group=false
-	continue
+}
 
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
+_wallclock()
+{
+    date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
+}
 
-    xpand=true
-    case "$r"
-    in
+_timestamp()
+{
+    now=`date "+%T"`
+    echo -n " [$now]"
+}
 
-	-\? | -h | --help)	# usage
-	    usage
-	    ;;
+# start the initialisation work now
+_setenvironment
 
-	-udf)	# -udf ... set FSTYP to udf
-	    FSTYP=udf
-	    xpand=false
-	    ;;
+rm -f $tmp.list $tmp.tmp $tmp.sed $here/$iam.out
 
-	-xfs)	# -xfs ... set FSTYP to xfs
-	    FSTYP=xfs
-	    xpand=false
-	    ;;
+# Autodetect fs type based on what's on $TEST_DEV
+if [ "$HOSTOS" == "Linux" ]; then
+    FSTYP=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
+fi
+export FSTYP
 
-	-nfs)	# -nfs ... set FSTYP to nfs
-	    FSTYP=nfs
-	    xpand=false
-	    ;;
+# we need common.config
+if ! . ./common.config
+then
+    echo "$iam: failed to source common.config"
+    exit 1
+fi
 
-	-g)	# -g group ... pick from group file
-	    group=true
-	    xpand=false
-	    ;;
+while [ $# -gt 0 ]; do
+	case "$1" in
+	-\? | -h | --help) usage ;;
 
-	-l)	# line mode for diff, was default before
-	    diff="diff"
-	    xpand=false
-	    ;;
+	-udf)	FSTYP=udf ;;
+	-xfs)	FSTYP=xfs ;;
+	-nfs)	FSTYP=nfs ;;
 
-	-xdiff)	# graphical diff mode
-	    xpand=false
+	-g)	group=$2 ; shift ;
+		group_list=$(get_group_list $group)
+		if [ -z "$group_list" ]; then
+		    echo "Group \"$group\" is empty or not defined?"
+		    exit 1
+		fi
 
-	    if [ ! -z "$DISPLAY" ]
-	    then
-		which xdiff >/dev/null 2>&1 && diff=xdiff
-		which gdiff >/dev/null 2>&1 && diff=gdiff
-		which tkdiff >/dev/null 2>&1 && diff=tkdiff
-		which xxdiff >/dev/null 2>&1 && diff=xxdiff
-	    fi
-	    ;;
-
-	-udiff) # show a unified diff, default now, keep for backward compat
-	    xpand=false
-	    diff="$diff -u"
-	    ;;
-
-	-q)	# "quick", no longer used - always quick :-)
-	    xpand=false
-	    ;;
-
-	-n)	# show me, don't do it
-	    showme=true
-	    xpand=false
-	    ;;
-        -r)	# randomize test order
-	    randomize=true
-	    xpand=false
-	    ;;
-
-	-T)	# turn on timestamp output
-	    timestamp=true
-	    xpand=false
-	    ;;
-
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
+		[ ! -s $tmp.list ] && touch $tmp.list
+		for t in $group_list; do
+			grep -s "^$t\$" $tmp.list >/dev/null || \
+							echo "$t" >>$tmp.list
+		done
 
-	[0-9]*-[0-9]*)
-	    eval `echo $r | sed -e 's/^/start=/' -e 's/-/ end=/'`
-	    ;;
+		;;
 
-	[0-9]*-)
-	    eval `echo $r | sed -e 's/^/start=/' -e 's/-//'`
-	    end=`echo [0-9][0-9][0-9] [0-9][0-9][0-9][0-9] | sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
-	    if [ -z "$end" ]
-	    then
-		echo "No tests in range \"$r\"?"
-		status=1
-		exit $status
-	    fi
-	    ;;
+	-x)	xgroup=$2 ; shift ;
+		[ ! -s $tmp.list ] &&  ls $SUPPORTED_TESTS >$tmp.list 2>/dev/null
+		group_list=$(get_group_list $xgroup)
+		if [ -z "$group_list" ]; then
+		    echo "Group \"$xgroup\" is empty or not defined?"
+		    exit 1
+		fi
 
-	--large-fs)
-	    export LARGE_SCRATCH_DEV=yes
-	    xpand=false
-	    ;;
+		rm -f $tmp.sed
+		numsed=0
+		for t in $group_list
+		do
+		    if [ $numsed -gt 100 ]; then
+			sed -f $tmp.sed <$tmp.list >$tmp.tmp
+			mv $tmp.tmp $tmp.list
+			numsed=0
+			rm -f $tmp.sed
+		    fi
+		    echo "/^$t\$/d" >>$tmp.sed
+		    numsed=`expr $numsed + 1`
+		done
+		sed -f $tmp.sed <$tmp.list >$tmp.tmp
+		mv $tmp.tmp $tmp.list
+		;;
 
-	-*)
-	    usage
-	    ;;
+	-l)	diff="diff" ;;
+	-udiff)	diff="$diff -u" ;;
 
-	--extra-space=*)
-	    export SCRATCH_DEV_EMPTY_SPACE=${r#*=}
-	    xpand=false
-	    ;;
+	-n)	showme=true ;;
+        -r)	randomize=true ;;
 
-	*)
-	    start=$r
-	    end=$r
-	    ;;
+	-T)	timestamp=true ;;
 
-    esac
+	"$SUPPORTED_TESTS")
+		echo "No tests?"
+		status=1
+		exit $status
+		;;
 
-    # get rid of leading 0s as can be interpreted as octal
-    start=`echo $start | sed 's/^0*//'`
-    end=`echo $end | sed 's/^0*//'`
+	[0-9]*-[0-9]*)
+		eval `echo $1 | sed -e 's/^/start=/' -e 's/-/ end=/'`
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
+	[0-9]*-)
+		eval `echo $1 | sed -e 's/^/start=/' -e 's/-//'`
+		end=`echo $SUPPORTED_TESTS | sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
+		if [ -z "$end" ]; then
+			echo "No tests in range \"$1\"?"
+			status=1
+			exit $status
 		fi
-	    fi
-	done
-    fi
+		expand_test_numbers $start $end
+		have_test_arg=true
+		;;
+
+	--large-fs) export LARGE_SCRATCH_DEV=yes ;;
+	--extra-space=*) export SCRATCH_DEV_EMPTY_SPACE=${r#*=} ;;
 
+	-*)	usage ;;
+	*)	expand_test_numbers $1 $1 ;
+		have_test_arg=true
+		;;
+	esac
+
+	shift
 done
 
-if [ -s $tmp.list ]
-then
+if [ -s $tmp.list ]; then
     # found some valid test numbers ... this is good
     :
-else
-    if $have_test_arg
-    then
+elif $have_test_arg; then
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
@@ -339,24 +252,6 @@ then
     list=`echo $list | awk -f randomize.awk`
 fi
 
-case "$FSTYP" in
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
-esac
-
 # we need common.rc
 if ! . ./common.rc
 then
@@ -370,16 +265,7 @@ then
     exit 1
 fi
 
-_wallclock()
-{
-    date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
-}
-
-_timestamp()
-{
-    now=`date "+%T"`
-    echo -n " [$now]"
-}
+# Ok, time to start running...
 
 _wrapup()
 {
diff --git a/common.rc b/common.rc
index 2ffff41..7d5a66d 100644
--- a/common.rc
+++ b/common.rc
@@ -161,6 +161,25 @@ then
     fi
 fi
 
+# check for correct setup
+case "$FSTYP" in
+    xfs)
+	 [ "$XFS_LOGPRINT_PROG" = "" ] && _fatal "xfs_logprint not found"
+	 [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
+	 [ "$XFS_CHECK_PROG" = "" ] && _fatal "xfs_check not found"
+	 [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
+	 [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found" 
+	 ;;
+    udf)
+	 [ "$MKFS_UDF_PROG" = "" ] && _fatal "mkfs_udf/mkudffs not found"
+	 ;;
+    btrfs)
+	 [ "$MKFS_BTRFS_PROG" = "" ] && _fatal "mkfs.btrfs not found"
+	 ;;
+    nfs)
+	 ;;
+esac
+
 # make sure we have a standard umask
 umask 022
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
