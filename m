Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9SV7G006829 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:31 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	WQFw8DliAPXhAGjr for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:29 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKMr-0001Am-8s
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMh-0005Ve-6m
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/18] xfstests: include test subdirectory support
Date: Thu, 26 Jul 2012 19:28:04 +1000
Message-Id: <1343294892-20991-11-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check               |   43 ++++++++++++++++++++++++++++---------------
 tests/generic/group |    5 +++++
 2 files changed, 33 insertions(+), 15 deletions(-)
 create mode 100644 tests/generic/group

diff --git a/check b/check
index d6dccb5..bdf764a 100755
--- a/check
+++ b/check
@@ -36,6 +36,8 @@ here=`pwd`
 FSTYP=xfs
 
 SUPPORTED_TESTS="[0-9][0-9][0-9] [0-9][0-9][0-9][0-9]"
+TEST_GROUP_DIR="tests"
+GENERIC_GROUP_DIR="$TEST_GROUP_DIR/generic"
 
 # generic initialization
 iam=check
@@ -78,11 +80,15 @@ _setenvironment()
 get_group_list()
 {
 	grp=$1
-
-	grpl=$(sed -n < group \
-		       -e 's/#.*//' \
-		       -e 's/$/ /' \
-		       -e "/^[0-9][0-9][0-9].* $grp /"'{ s/ .*//p }')
+	dirs=". $GENERIC_GROUP_DIR"
+
+	for d in $dirs; do
+		l=$(sed -n < $d/group \
+			-e 's/#.*//' \
+			-e 's/$/ /' \
+			-e "s;\(^[0-9][0-9][0-9]\).* $grp .*;$d/\1;p")
+		grpl="$grpl $l"
+	done
 	echo $grpl
 }
 
@@ -284,7 +290,7 @@ END	{ if (NR > 0) {
 
 	echo "" >>check.log
 	date >>check.log
-	echo $list | fmt | sed -e 's/^/    /' >>check.log
+	echo $list | fmt | sed -e 's/^/    /' -e 's;tests/;;g' >>check.log
 	$interrupt && echo "Interrupted!" >>check.log
         
         if [ ! -z "$n_try" -a $n_try != 0 ]
@@ -362,7 +368,12 @@ _check_test_fs
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
@@ -375,7 +386,9 @@ do
 	# really going to try and run this one
 	#
 	rm -f $seq.out.bad
-	lasttime=`sed -n -e "/^$seq /s/.* //p" <check.time`
+
+	# slashes now in names, sed barfs on them so use grep
+	lasttime=`grep -w ^$seq check.time | awk '// {print $2}'`
 	if [ "X$lasttime" != X ]; then
 		echo -n " ${lasttime}s ..."
 	else
@@ -386,7 +399,7 @@ do
 	start=`_wallclock`
 	$timestamp && echo -n "	["`date "+%T"`"]"
 	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
-	[ -x /usr/bin/logger ] && /usr/bin/logger "run xfstest $seq"
+	[ -x /usr/bin/logger ] && /usr/bin/logger "run xfstest $seqnum"
 	./$seq >$tmp.rawout 2>&1
 	sts=$?
 	$timestamp && _timestamp
@@ -405,9 +418,9 @@ do
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
@@ -425,7 +438,7 @@ do
 		    then
 			:
 		    else
-			echo "$seq `expr $stop - $start`" >>$tmp.time
+			echo "$seqnum `expr $stop - $start`" >>$tmp.time
 			echo -n " `expr $stop - $start`s"
 		    fi
 		    echo ""
@@ -444,18 +457,18 @@ do
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
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
