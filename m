Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE79929E0D
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 03:32:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC7528F8049
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:32:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	U2eyImWz3A3BFkGR for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 01:32:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXSSL-000874-I0
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXSSL-0000fY-E2
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfstests: fix last test runtime output
Date: Wed,  1 May 2013 18:31:59 +1000
Message-Id: <1367397123-2530-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1367397123-2530-1-git-send-email-david@fromorbit.com>
References: <1367397123-2530-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Prior to the test directory split-up, xfstests used to output the
time it previously took to run a specific test in it's output. This
was broken during the split up, as test identifiers changed and the
result output changed.

To fix this, the search for previous test results needs to look at
the sequence number rather than the absolute sequence for the test.
The new output looks the same as the old functionality:

generic/001 4s ... 5s
generic/002 1s ... 0s
generic/005 1s ... 1s
generic/006 1s ... 1s
generic/007 2s ... 1s

Where the first column is the time of the previous test run, and the
second column is the time that this run took.

Further, the check files used to generate this information are not
being output properly in the result directory, and so various log
files are not getting written to the correct location or file names.
For example, the calls to _check_test_fs would output failures to
".full", while other messages would be output to check.full, but
none would output to the corect location of RESULT_BASE/check.full.

Fix all this mess up so that all the check files for a specific run
end up in RESULT_BASE, and ensure the timing code checks the right
file and dumps output.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 check |   48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/check b/check
index 966fbe5..a79747e 100755
--- a/check
+++ b/check
@@ -293,14 +293,17 @@ fi
 
 _wrapup()
 {
+    seq="check"
+    check="$RESULT_BASE/check"
+
     if $showme
     then
 	:
     elif $needwrap
     then
-	if [ -f check.time -a -f $tmp.time ]
+	if [ -f $check.time -a -f $tmp.time ]
 	then
-	    cat check.time $tmp.time \
+	    cat $check.time $tmp.time \
 	    | $AWK_PROG '
 	{ t[$1] = $2 }
 END	{ if (NR > 0) {
@@ -308,13 +311,13 @@ END	{ if (NR > 0) {
 	  }
 	}' \
 	    | sort -n >$tmp.out
-	    mv $tmp.out check.time
+	    mv $tmp.out $check.time
 	fi
 
-	echo "" >>check.log
-	date >>check.log
-	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>check.log
-	$interrupt && echo "Interrupted!" >>check.log
+	echo "" >>$check.log
+	date >>$check.log
+	echo $list | fmt | sed -e 's/^/    /' -e "s;$SRC_DIR/;;g" >>$check.log
+	$interrupt && echo "Interrupted!" >>$check.log
         
         if [ ! -z "$n_try" -a $n_try != 0 ]
 	then
@@ -324,18 +327,18 @@ END	{ if (NR > 0) {
 	if [ ! -z "$notrun" ]
 	then
 	    echo "Not run:$notrun"
-	    echo "Not run:$notrun" >>check.log
+	    echo "Not run:$notrun" >>$check.log
 	fi
 
         if [ ! -z "$n_bad" -a $n_bad != 0 ]
 	then
 	    echo "Failures:$bad"
 	    echo "Failed $n_bad of $n_try tests"
-	    echo "Failures:$bad" | fmt >>check.log
-	    echo "Failed $n_bad of $n_try tests" >>check.log
+	    echo "Failures:$bad" | fmt >>$check.log
+	    echo "Failed $n_bad of $n_try tests" >>$check.log
 	else
 	    echo "Passed all $n_try tests"
-	    echo "Passed all $n_try tests" >>check.log
+	    echo "Passed all $n_try tests" >>$check.log
 	fi
 	needwrap=false
     fi
@@ -346,10 +349,19 @@ END	{ if (NR > 0) {
 
 trap "_wrapup; exit \$status" 0 1 2 3 15
 
+mkdir -p $RESULT_BASE
+if [ ! -d $RESULT_BASE ]; then
+	echo "failed to create results directory $RESULTS_BASE"
+	exit 1;
+fi
+
+seq="check"
+check="$RESULT_BASE/check"
+
 # don't leave old full output behind on a clean run
-rm -f check.full
+rm -f $check.full
 
-[ -f check.time ] || touch check.time
+[ -f $check.time ] || touch $check.time
 
 # print out our test configuration
 echo "FSTYP         -- `_full_fstyp_details`"
@@ -385,13 +397,7 @@ if [ ! -z "$SCRATCH_DEV" ]; then
   fi
 fi
 
-mkdir -p $RESULT_BASE
-if [ ! -d $RESULT_BASE ]; then
-	echo "failed to create results directory $RESULTS_BASE"
-	exit 1;
-fi
-
-seq="check"
+seqres="$check"
 _check_test_fs
 
 for seq in $list
@@ -432,7 +438,7 @@ do
 	fi
 
 	# slashes now in names, sed barfs on them so use grep
-	lasttime=`grep -w ^$seq check.time | awk '// {print $2}'`
+	lasttime=`grep -w ^$seqnum $check.time | awk '// {print $2}'`
 	if [ "X$lasttime" != X ]; then
 		echo -n " ${lasttime}s ..."
 	else
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
