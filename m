Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E906629E0F
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 03:32:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D636E8F8049
	for <xfs@oss.sgi.com>; Wed,  1 May 2013 01:32:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sogM5tywjDc3n8LN for <xfs@oss.sgi.com>;
	Wed, 01 May 2013 01:32:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UXSSL-000875-In
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:05 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UXSSL-0000fc-Fk
	for xfs@oss.sgi.com; Wed, 01 May 2013 18:32:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/5] xfstests: 310 fails with existing directory error
Date: Wed,  1 May 2013 18:32:00 +1000
Message-Id: <1367397123-2530-3-git-send-email-david@fromorbit.com>
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

Test 310 fails with:

mkdir: cannot create directory `/mnt/test/tmp': File exists

$TEST_DIR is persistent, so test directories need to be created with
"mkdir -p" so they don't fail if the directory already exists.

Many other things need fixing, too.
	- Tests should define directories they use on $TEST_DIR by
	  their sequence number, not generic names.

	- Use a variable for the directory the test runs in
	  ($SEQ_DIR, in this case) to avoid having to manually code
	  it everywhere.

	- New binaries need to be added to .gitignore.

	- Return status for shell functions is 0 for success,
	  non-zero for failure.

	- Setting status=0 if there is no failure in the first test
	  means that even if the second test fails, the test will
	  still pass. Change the test to use "_fatal" when a kernel
	  bug is detected, and only set status=0 when the entire
	  test has finished.

	- reduce the default runtime by to roughly a minute and
	  scale it with the stress load factor variables. In most
	  cases, this test is never going to hit problems (as
	  they've already been fixed) so running it for ~4 minutes
	  is mostly a waste of time...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 .gitignore        |    2 ++
 tests/generic/310 |   35 +++++++++++++++++------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/.gitignore b/.gitignore
index 7a10feb..0bd48c3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -67,6 +67,8 @@
 /src/preallo_rw_pattern_writer
 /src/pwrite_mmap_blocked
 /src/randholes
+/src/t_readdir_1
+/src/t_readdir_2
 /src/rename
 /src/resvtest
 /src/runas
diff --git a/tests/generic/310 b/tests/generic/310
index b5316cd..26d2d4a 100755
--- a/tests/generic/310
+++ b/tests/generic/310
@@ -75,12 +75,11 @@ check_kernel_bug()
 	new_warning=`dmesg | grep -c "^WARNING"`
 	new_lockdep=`dmesg | grep -c "possible recursive locking detected"`
 
-
 	# no kernel bug is detected
 	if [ $new_bug -eq $nr_bug -a $new_error -eq $nr_error -a \
 	     $new_null -eq $nr_null -a $new_warning -eq $nr_warning -a \
 	     $new_lockdep -eq $nr_lockdep ]; then
-		return 1
+		return 0
 	fi
 
 	nr_bug=$new_bug
@@ -88,37 +87,36 @@ check_kernel_bug()
 	nr_null=$new_null
 	nr_warning=$new_warning
 	nr_lockdep=$new_lockdep
+	return 1
 }
-mkdir $TEST_DIR/tmp
+
+RUN_TIME=$((30 * $TIME_FACTOR))
+
+SEQ_DIR=$TEST_DIR/$seq
+mkdir -p $SEQ_DIR
 for n in {1..4096}; do
-	touch $TEST_DIR/tmp/$n
+	touch $SEQ_DIR/$n
 done
 
 _test_read()
 {
-	src/t_readdir_1 $TEST_DIR/tmp &
-	sleep 100
+	src/t_readdir_1 $SEQ_DIR &
+	sleep $RUN_TIME
 	killall src/t_readdir_1
 	check_kernel_bug
-	if [ $? -eq 1 ]; then
-		status=0
-	else
-		echo "error: kernel bug was found, you can see the
-			dmesg for more infomation."
+	if [ $? -ne 0 ]; then
+		_fatal "kernel bug detected, check dmesg for more infomation."
 	fi
 }
 
 _test_lseek()
 {
-	src/t_readdir_2 $TEST_DIR/tmp &
-	sleep 100
+	src/t_readdir_2 $SEQ_DIR &
+	sleep $RUN_TIME
 	killall src/t_readdir_2
 	check_kernel_bug
-	if [ $? -eq 1 ]; then
-		status=0
-	else
-		echo "error: kernel bug was found, you can see the
-			dmesg for more infomation."
+	if [ $? -ne 0 ]; then
+		_fatal "kernel bug detected, check dmesg for more infomation."
 	fi
 }
 
@@ -127,4 +125,5 @@ _test_lseek
 
 # success, all done
 echo "*** done"
+status=0
 exit
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
