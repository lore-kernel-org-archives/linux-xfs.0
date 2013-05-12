Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F32757F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 03:03:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B78518F8037
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 01:03:53 -0700 (PDT)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id 685X2vO8376dhvyC
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 12 May 2013 01:03:49 -0700 (PDT)
Received: by mail-pa0-f46.google.com with SMTP id fa10so3894541pad.19
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 01:03:48 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3] xfstests: remove fio config files after finished test
Date: Sun, 12 May 2013 16:21:24 +0800
Message-Id: <1368346884-31264-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

After finished test, temporarily fio config file should be removed.
This commit tries to fix this problem in the following test cases:
  - generic/299-300
  - ext4/301-304
  - shared/305

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>
---
changelog:
 * rebase against the latest master branch of xfstests tree.

 tests/ext4/301    |  9 +++++----
 tests/ext4/302    |  9 +++++----
 tests/ext4/303    |  9 +++++----
 tests/ext4/304    |  9 +++++----
 tests/generic/299 |  9 +++++----
 tests/generic/300 |  9 +++++----
 tests/shared/305  | 10 ++++++----
 7 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/tests/ext4/301 b/tests/ext4/301
index e1583d4..0ca3622 100755
--- a/tests/ext4/301
+++ b/tests/ext4/301
@@ -28,6 +28,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -49,7 +50,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # reserve 30% in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -101,11 +102,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seqres.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seqres.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/ext4/302 b/tests/ext4/302
index abca805..497f4c6 100755
--- a/tests/ext4/302
+++ b/tests/ext4/302
@@ -29,6 +29,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -49,7 +50,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # reserve 30% in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -117,11 +118,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seqres.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seqres.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/ext4/303 b/tests/ext4/303
index 7051576..93354e5 100755
--- a/tests/ext4/303
+++ b/tests/ext4/303
@@ -29,6 +29,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -49,7 +50,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # Reserve space for 4 files in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (3+1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -127,11 +128,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seqres.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seqres.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/ext4/304 b/tests/ext4/304
index 5d15ecb..74e601a 100755
--- a/tests/ext4/304
+++ b/tests/ext4/304
@@ -30,6 +30,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -50,7 +51,7 @@ BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 # reserve 30% in order to avoid ENOSPC
 FILE_SIZE=$((BLK_DEV_SIZE * (512 / (2 + 1))))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 # Common e4defrag regression tests
 [global]
 ioengine=ioe_e4defrag
@@ -104,11 +105,11 @@ _workout()
 	echo ""
 	echo " Start defragment activity"
 	echo ""
-	cat $tmp-$seq.fio >>  $seqres.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seqres.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs  >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/generic/299 b/tests/generic/299
index 5f3edc4..14cce96 100644
--- a/tests/generic/299
+++ b/tests/generic/299
@@ -30,6 +30,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -47,7 +48,7 @@ NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 FILE_SIZE=$((BLK_DEV_SIZE * 512))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 ###########
 # $seq test fio activity
 # Filenames derived from jobsname and jobid like follows:
@@ -108,15 +109,15 @@ rw=randrw
 filename=buffered-aio-verifier
 EOF
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _workout()
 {
 	echo ""
 	echo "Run fio with random aio-dio pattern"
 	echo ""
-	cat $tmp-$seq.fio >>  $seqres.full
-	run_check $FIO_PROG $tmp-$seq.fio &
+	cat $fio_config >>  $seqres.full
+	run_check $FIO_PROG $fio_config &
 	pid=$!
 	echo "Start fallocate/truncate loop"
 
diff --git a/tests/generic/300 b/tests/generic/300
index 687e62d..7c60728 100644
--- a/tests/generic/300
+++ b/tests/generic/300
@@ -30,6 +30,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 
@@ -51,7 +52,7 @@ then
 fi
 FS_SIZE=$((BLK_DEV_SIZE * 512))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 ###########
 # $seq test fio activity
 # Run DIO, fallocate and punch_hole threads on a single in parallel
@@ -128,11 +129,11 @@ _workout()
 	echo ""
 	echo "Run fio with random aio-dio pattern"
 	echo ""
-	cat $tmp-$seq.fio >>  $seqres.full
-	run_check $FIO_PROG $tmp-$seq.fio
+	cat $fio_config >>  $seqres.full
+	run_check $FIO_PROG $fio_config
 }
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 _scratch_mkfs_sized $FS_SIZE >> $seqres.full 2>&1
 _scratch_mount
diff --git a/tests/shared/305 b/tests/shared/305
index 91cbf03..8e8b0cb 100644
--- a/tests/shared/305
+++ b/tests/shared/305
@@ -29,6 +29,7 @@ echo "QA output created by $seq"
 
 here=`pwd`
 tmp=/tmp/$$
+fio_config=$tmp.fio
 status=1	# failure is the default!
 
 # get standard environment, filters and checks
@@ -79,6 +80,7 @@ _cleanup()
 {
     poweron_scratch_dev
     disallow_fail_make_request
+    rm -f $tmp.*
 }
 trap "_cleanup; exit \$status" 1 2 3 15
 
@@ -87,7 +89,7 @@ NUM_JOBS=$((4*LOAD_FACTOR))
 BLK_DEV_SIZE=`blockdev --getsz $SCRATCH_DEV`
 FILE_SIZE=$((BLK_DEV_SIZE * 512))
 
-cat >$tmp-$seq.fio <<EOF
+cat >$fio_config <<EOF
 ###########
 # $seq test's fio activity
 # Filenames derived from jobsname and jobid like follows:
@@ -127,7 +129,7 @@ time_based
 
 EOF
 
-_require_fio $tmp-$seq.fio
+_require_fio $fio_config
 
 # Disable all sync operations to get higher load
 FSSTRESS_AVOID="$FSSTRESS_AVOID -ffsync=0 -fsync=0 -ffdatasync=0 -f setattr=1"
@@ -143,8 +145,8 @@ _workout()
 	$FSSTRESS_PROG $args > /dev/null 2>&1 &
 	fs_pid=$!
 	echo "Start fio.."
-	cat $tmp-$seq.fio >>  $seqres.full
-	$FIO_PROG $tmp-$seq.fio >> $seqres.full 2>&1 &
+	cat $fio_config >>  $seqres.full
+	$FIO_PROG $fio_config >> $seqres.full 2>&1 &
 	fio_pid=$!
 
 	# Let's it work for awhile, and force device failure
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
