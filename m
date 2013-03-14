Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 7FD3E7F5F
	for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 08:06:12 -0500 (CDT)
Received: from polaris-admin.engr.sgi.com (polaris-admin.engr.sgi.com
	[150.166.41.54])
	by cthulhu.engr.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id
	r2ED6Bx7007472 for <xfs@oss.sgi.com>; Thu, 14 Mar 2013 06:06:11 -0700
Date: Thu, 14 Mar 2013 06:06:11 -0700
Subject: [PATCH 13/18] xfstests: Change command line parsing for new structure
MIME-Version: 1.0
Message-Id: <20130314130611.9B6AB53DEAFA@polaris-admin.engr.sgi.com>
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
Now that tests are in separate subdirectories, they cannot be selected purely by
test number on the command line. We need to specify the test by subdir and test
name, so effectively we move to specifying them by regexes on the command line
rather than by expanding a range internally. This is needed to support
non-numeric test names as well, so the change may as well be made here.

This means the command line parsing needs to change from trying to detect tests
by a regex match to a processing loop that simply parses the tests and checks
for there existence. Hence the moment we find an argument that is not a switch
(i.e no preceeding "-"), we move from the arg processing loop to the test name
processing loop. IOWs, tests must be specified last on the command line.
-----------------

Signed-off-by: Phil White <pwhite@sgi.com>
---
 check  |    3 +-
 common |   85 ++++++++++++++++++++++++++++------------------------------------
 2 files changed, 38 insertions(+), 50 deletions(-)

diff --git a/check b/check
index 9819a84..25f6c7e 100755
--- a/check
+++ b/check
@@ -70,8 +70,7 @@ check options
 testlist options
     -g group[,group...]        include tests from these groups
     -x group[,group...]        exclude tests from these groups
-    NNN                        include test NNN
-    NNN-NNN            include test range (eg. 012-021)
+    [testlist]         include tests matching names in testlist
 '
 }
 
diff --git a/common b/common
index d7207d6..1c6a08c 100644
--- a/common
+++ b/common
@@ -56,25 +56,6 @@ get_group_list()
 	echo $grpl
 }
 
-expand_test_numbers()
-{
-	# strip leading zeros, could be considered octal.
-	start=`echo $1 | sed 's/^0*//'`
-	end=`echo $2 | sed 's/^0*//'`
-	$AWK_PROG </dev/null '
-BEGIN  { for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
-	| while read id
-	do
-		if grep -s "^$id " group >/dev/null ; then
-			# in group file ... OK
-			echo $id >>$tmp.list
-		else
-			# oops
-			echo "$id - unknown test, ignored"
-		fi
-	done
-}
-
 _wallclock()
 {
 	date "+%H %M %S" | $AWK_PROG '{ print $1*3600 + $2*60 + $3 }'
@@ -105,6 +86,7 @@ then
 	exit 1
 fi
 
+# Process command arguments first.
 while [ $# -gt 0 ]; do
 	case "$1" in
 	-\? | -h | --help) usage ;;
@@ -158,43 +140,50 @@ while [ $# -gt 0 ]; do
 	-r)	randomize=true ;;
 	-T)	timestamp=true ;;
 
-	"$SUPPORTED_TESTS")
-		echo "No tests?"
-		status=1
-		exit $status
-		;;
-
-	[0-9]*-[0-9]*)
-		eval `echo $1 | sed -e 's/^/start=/' -e 's/-/ end=/'`
-		expand_test_numbers $start $end
-		have_test_arg=true
-		;;
-
-	[0-9]*-)
-		eval `echo $1 | sed -e 's/^/start=/' -e 's/-//'`
-		end=`echo $SUPPORTED_TESTS | \
-			sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
-		if [ -z "$end" ]; then
-			echo "No tests in range \"$1\"?"
-			status=1
-			exit $status
-		fi
-
-		expand_test_numbers $start $end
-		have_test_arg=true
-		;;
-
 	--large-fs)		export LARGE_SCRATCH_DEV=yes ;;
 	--extra-space=*)	export SCRATCH_DEV_EMPTY_SPACE=${r#*=} ;;
 
 	-*)	usage ;;
-	*)	expand_test_numbers $1 $1 ;
-		have_test_arg=true
-		;;
+	*)	# not an argument, we've got tests now.
+		have_test_arg=true ;;
 	esac
+
+	# if we've found a test specification, the break out of the processing
+	# loop before we shift the arguments so that this is the first argument
+	# that we process in the test arg loop below.
+	if $have_test_arg; then
+		break;
+	fi
+
 	shift
 done
 
+# Process tests from command line now.
+if $have_test_arg; then
+	while [ $# -gt 0 ]; do
+		case "$1" in
+		-*)     echo "Argments before tests, please!"
+			status=1
+			exit $status
+			;;
+		*)      test_dir=`dirname $1`
+			test_name=`basename $1`
+			group_file=$SRC_DIR/$test_dir/group
+
+			if grep "^$testname" $group_file >/dev/null ; then
+				# in group file ... OK
+				echo $SRC_DIR/$1 >>$tmp.list
+			else
+				# oops
+				echo "$1 - unknown test, ignored"
+			fi
+			;;
+		esac
+
+		shift
+	done
+fi
+
 if [ -s $tmp.list ]
 then
     # found some valid test numbers ... this is good
-- 
1.5.3.8

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
