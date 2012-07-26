Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q9ScQ1006872 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 04:28:38 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	V9cKYIDPPNiiPEUX for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 02:28:37 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuKN1-0001BD-EJ
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:35 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuKMr-0005W0-BA
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 19:28:25 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 14/18] xfstests: rework CLI individual test specification
Date: Thu, 26 Jul 2012 19:28:08 +1000
Message-Id: <1343294892-20991-15-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check |   86 ++++++++++++++++++++++++++++-------------------------------------
 1 file changed, 37 insertions(+), 49 deletions(-)

diff --git a/check b/check
index 6ffede6..b65b060 100755
--- a/check
+++ b/check
@@ -65,8 +65,7 @@ check options
 testlist options
     -g group[,group...]	include tests from these groups
     -x group[,group...]	exclude tests from these groups
-    NNN			include test NNN
-    NNN-NNN		include test range (eg. 012-021)
+    [testlist]		include tests matching names in testlist
 '
 	    exit 0
 }
@@ -91,26 +90,6 @@ get_group_list()
 	echo $grpl
 }
 
-expand_test_numbers()
-{
-	# strip leading zeros, could be considered octal.
-	start=`echo $1 | sed 's/^0*//'`
-	end=`echo $2 | sed 's/^0*//'`
-
-	$AWK_PROG </dev/null '
-BEGIN	{ for (t='$start'; t<='$end'; t++) printf "%03d\n",t }' \
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
@@ -140,6 +119,7 @@ then
     exit 1
 fi
 
+# Process command arguments first.
 while [ $# -gt 0 ]; do
 	case "$1" in
 	-\? | -h | --help) usage ;;
@@ -196,42 +176,50 @@ while [ $# -gt 0 ]; do
 
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
-		end=`echo $SUPPORTED_TESTS | sed -e 's/\[0-9]//g' -e 's/  *$//' -e 's/.* //'`
-		if [ -z "$end" ]; then
-			echo "No tests in range \"$1\"?"
-			status=1
-			exit $status
-		fi
-		expand_test_numbers $start $end
-		have_test_arg=true
-		;;
-
 	--large-fs) export LARGE_SCRATCH_DEV=yes ;;
 	--extra-space=*) export SCRATCH_DEV_EMPTY_SPACE=${r#*=} ;;
 
 	-*)	usage ;;
-	*)	expand_test_numbers $1 $1 ;
-		have_test_arg=true
-		;;
+	*)	# not an argument, we've got tests now.
+		have_test_arg=true ;;
 	esac
 
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
+		-*)	echo "Argments before tests, please!"
+			status=1
+			exit $status
+			;;
+		*)	test_dir=`dirname $1`
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
 if [ -s $tmp.list ]; then
     # found some valid test numbers ... this is good
     :
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
