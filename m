Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 5D21C7F5D
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007464 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 09/18] xfstests: create tests subdirectory
MIME-Version: 1.0
Message-Id: <20130314130611.8429C53DEAF6@polaris-admin.engr.sgi.com>
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
Create a specific tests/ subdirectory to hold all the tests so they
are no longer need to be in the top level directory. This patch does
not move any tests there, however, and that will be done in
subsequent commits.

The tests/ subdir will have it's own subdirectories for different
classes of tests. Initially, there will be a per-FSTYP subdirectory
for filesytsem specific tests, and a generic directory for tests
that span multiple filesystems.

Each class will have it's own group file to indicate what groups the
tests belong to, and these will be parsed appropriately by the high
level check script to build the test list.

The change in parsing results in the test output also emitting the
path to the test as well as the name of the test, instead of just a
raw number. This allows duplicate test names in the sudirecotries to
be unambiguous when the summary is written out.
-----------------

Signed-off-by: Phil White <pwhite@sgi.com>
---
 check               |   26 +++++++++++++++++---------
 common              |   40 ++++++++++++++++++++++------------------
 group               |    5 -----
 tests/generic/group |    5 +++++
 4 files changed, 44 insertions(+), 32 deletions(-)
 create mode 100644 tests/generic/group

diff --git a/check b/check
index 37d1d2f..dea63d7 100755
--- a/check
+++ b/check
@@ -97,7 +97,7 @@ END	{ if (NR > 0) {
 
 	echo "" >>check.log
 	date >>check.log
-	echo $list | fmt | sed -e 's/^/    /' >>check.log
+	echo $list | fmt | sed -e 's/^/    /' -e 's;tests/;;g' >>check.log
 	$interrupt && echo "Interrupted!" >>check.log
         
         if [ ! -z "$n_try" -a $n_try != 0 ]
@@ -175,7 +175,12 @@ _check_test_fs
 for seq in $list
 do
     err=false
-    echo -n "$seq"
+
+    # the filename for the test and the name output are different.
+    # we don't include the tests/ directory in the name output.
+    seqnum=`echo $seq | sed -e 's;tests/;;'`
+
+    echo -n "$seqnum"
 
     if $showme
     then
@@ -188,7 +193,10 @@ do
 	# really going to try and run this one
 	#
 	rm -f $seq.out.bad
-	lasttime=`sed -n -e "/^$seq /s/.* //p" <check.time`
+
+	# slashes now in names, sed barfs on them so use grep
+	lasttime=`grep -w ^$seq check.time | awk '// {print $2}'`
+
 	if [ "X$lasttime" != X ]; then
 		echo -n " ${lasttime}s ..."
 	else
@@ -218,9 +226,9 @@ do
 	if [ -f $seq.notrun ]
 	then
 	    $timestamp || echo -n " [not run] "
-	    $timestamp && echo " [not run]" && echo -n "	$seq -- "
+	    $timestamp && echo " [not run]" && echo -n "	$seqnum -- "
 	    cat $seq.notrun
-	    notrun="$notrun $seq"
+	    notrun="$notrun $seqnum"
 	else
 	    if [ $sts -ne 0 ]
 	    then
@@ -238,7 +246,7 @@ do
 		    then
 			:
 		    else
-			echo "$seq `expr $stop - $start`" >>$tmp.time
+			echo "$seqnum `expr $stop - $start`" >>$tmp.time
 			echo -n " `expr $stop - $start`s"
 		    fi
 		    echo ""
@@ -266,18 +274,18 @@ do
     #
     if $err
     then
-	bad="$bad $seq"
+	bad="$bad $seqnum"
 	n_bad=`expr $n_bad + 1`
 	quick=false
     fi
     if [ ! -f $seq.notrun ]
     then
-	try="$try $seq"
+	try="$try $seqnum"
 	n_try=`expr $n_try + 1`
         _check_test_fs
     fi
     
-    seq="after_$seq"
+    seq="after_$seqnum"
 done
 
 interrupt=false
diff --git a/common b/common
index 821ea59..b41d4d0 100644
--- a/common
+++ b/common
@@ -21,6 +21,21 @@
 # $Header: /disk7/depot/linux/pcp/dev/qa/RCS/common,v 2.52 2000/04/05 18:24:51 kenmcd Exp $
 #
 
+here=`pwd`
+check=${check-true}
+diff="`which diff`"
+verbose=false
+group=false
+xgroup=false
+showme=false
+sortme=false
+have_test_arg=false
+randomize=false
+timestamp=${TIMESTAMP:=false}
+SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
+TEST_GROUP_DIR="tests"
+GENERIC_GROUP_DIR="$TEST_GROUP_DIR/generic"
+
 _setenvironment()
 {
     MSGVERB="text:action"
@@ -30,10 +45,15 @@ _setenvironment()
 get_group_list()
 {
 	grp=$1
-	grpl=$(sed -n < group \
+	dirs=". $GENERIC_GROUP_DIR"
+
+	for d in $dirs; do
+		l=$(sed -n < $d/group \
 			-e 's/#.*//' \
 			-e 's/$/ /' \
-			-e "/^[0-9][0-9][0-9].* $grp /"'{ s/ .*//p }')
+			-e "s;\(^[0-9][0-9][0-9]\).* $grp .*;$d/\1;p")
+		grpl="$grpl $l"
+	done
 	echo $grpl
 }
 
@@ -67,22 +87,6 @@ _timestamp()
 	echo -n " [$now]"
 }
 
-here=`pwd`
-
-check=${check-true}
-
-diff="`which diff`"
-verbose=false
-group=false
-xgroup=false
-showme=false
-sortme=false
-have_test_arg=false
-randomize=false
-timestamp=${TIMESTAMP:=false}
-
-SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
-
 # start the initialisation work now
 _setenvironment
 rm -f $tmp.list $tmp.tmp $tmp.sed $here/$iam.out
diff --git a/group b/group
index c9b733f..484bed5 100644
--- a/group
+++ b/group
@@ -1,8 +1,3 @@
-# QA groups control file
-# Defines test groups and nominal group owners
-# - do not start group names with a digit
-# - comment line before each group is "new" description
-#
 
 # catch-all
 other
diff --git a/tests/generic/group b/tests/generic/group
new file mode 100644
index 0000000..4e01f0c
--- /dev/null
+++ b/tests/generic/group
@@ -0,0 +1,5 @@
+# QA groups control file
+# Defines test groups and nominal group owners
+# - do not start group names with a digit
+# - comment line before each group is "new" description
+#
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
