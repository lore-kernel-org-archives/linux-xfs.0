Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 8DF147F51
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx9007459 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 14/18] xfstests: remove -x functionality 
MIME-Version: 1.0
Message-Id: <20130314130611.A163253DEAFB@polaris-admin.engr.sgi.com>
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
Now that there are no tests in the top level directory, the exlude
group functionality no longer works (-x group) as it cannot find
tests to build an initial list of tests. Rework the the exclude
group implementation to operate correctly on the new test locations.

Also, swtich from sed to grep for exclusion because sed has problems
distnguishing the '/' in path names from regex control...
-----------------
This one is mildly different from the original as it modifies infrastructure
which remains in common.  In Dave's original patch, that had all been moved
into check.

Signed-off-by: Phil White <pwhite@sgi.com>
---
 common |   43 +++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/common b/common
index 1c6a08c..4732a66 100644
--- a/common
+++ b/common
@@ -56,6 +56,19 @@ get_group_list()
 	echo $grpl
 }
 
+# find all tests, excluding files that are test metadata such as group files.
+# This assumes that tests are defined purely by alphanumeric filenames with no
+# ".xyz" extensions in the name.
+get_all_tests()
+{
+	touch $tmp.list
+	for d in $SRC_GROUPS $FSTYP; do
+		ls $SRC_DIR/$d/* | \
+			grep -v "\..*" | \
+			grep -v group >> $tmp.list 2>/dev/null
+	done
+}
+
 _wallclock()
 {
 	date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
@@ -69,7 +82,7 @@ _timestamp()
 
 # start the initialisation work now
 _setenvironment
-rm -f $tmp.list $tmp.tmp $tmp.sed $here/$iam.out
+rm -f $tmp.list $tmp.tmp $tmp.grep $here/$iam.out
 
 # Autodetect fs type based on what's on $TEST_DEV
 if [ "$HOSTOS" == "Linux" ]
@@ -109,27 +122,33 @@ while [ $# -gt 0 ]; do
 		;;
 
 	-x)	xgroup=$2 ; shift ;
-		[ ! -s $tmp.list ] && ls $SUPPORTED_TESTS >$tmp.list 2>/dev/null
+
+		# Note: behaviour is dependent on command line ordering of
+		# -g and -x parameters. If there are no preceding -g commands,
+		# this works on all tests, otherwise just the tests specified by
+		# the early -g inclusions.
+		[ ! -s $tmp.list ] && get_all_tests
+
 		group_list=$(get_group_list $xgroup)
 		if [ -z "$group_list" ]; then
 			echo "Group \"$xgroup\" is empty or not defined?"
 			exit 1
 		fi
 
-		rm -f $tmp.sed
-		numsed=0
+		rm -f $tmp.grep
+		numgrep=0
 		for t in $group_list
 		do
-			if [ $numsed -gt 100 ]; then
-				sed -f $tmp.sed <$tmp.list >$tmp.tmp
+			if [ $numgrep -gt 100 ]; then
+				grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
 				mv $tmp.tmp $tmp.list
-				numsed=0
-				rm -f $tmp.sed
+				numgrep=0
+				rm -f $tmp.grep
 			fi
-			echo "/^$t\$/d" >>$tmp.sed
-			numsed=`expr $numsed + 1`
+			echo "/^$t\$/d" >>$tmp.grep
+			numgrep=`expr $numgrep + 1`
 		done
-		sed -f $tmp.sed <$tmp.list >$tmp.tmp
+		grep -v -f $tmp.grep <$tmp.list >$tmp.tmp
 		mv $tmp.tmp $tmp.list
 		;;
 
@@ -199,7 +218,7 @@ fi
 
 # sort the list of tests into numeric order
 list=`sort -n $tmp.list`
-rm -f $tmp.list $tmp.tmp $tmp.sed
+rm -f $tmp.list $tmp.tmp $tmp.grep
 
 if $randomize
 then
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
