Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q99FIwmN060137 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 10:18:58 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id IIrY7iaMDl4xlKyr for
	<xfs@oss.sgi.com>; Tue, 09 Oct 2012 08:20:28 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q99FKRga011242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 11:20:27 -0400
From: Tomas Racek <tracek@redhat.com>
Subject: [PATCH] xfstests: 251,
	260: Use loopdev as fallback if $SCRATCH_DEV doesn't support FITRIM
Date: Tue,  9 Oct 2012 17:20:00 +0200
Message-Id: <1349796000-27776-1-git-send-email-tracek@redhat.com>
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
Cc: lczerner@redhat.com, Tomas Racek <tracek@redhat.com>

This patch adds an option to test FITRIM even if it's not supported on $SCRATCH_DEV. 

Also introduces _create_loop_device and _destroy_loop_device functions to
unify loopback handling.

(depends on patch "Use upstream version of fstrim...")

Signed-off-by: Tomas Racek <tracek@redhat.com>
---
 251       | 18 ++++++++++++++++--
 260       | 22 ++++++++++++++++++++--
 common.rc | 14 ++++++++++++++
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/251 b/251
index dbb6ba7..fb88f2a 100755
--- a/251
+++ b/251
@@ -51,13 +51,18 @@ _scratch_mount
 _cleanup()
 {
 	rm -rf $tmp
+	if [ -n "$loop" ]; then
+		_scratch_unmount
+		_destroy_loop_device $loop
+		rm $img_file
+	fi
 }
 
 _destroy()
 {
 	kill $pids $fstrim_pid 2> /dev/null
 	wait $pids $fstrim_pid 2> /dev/null
-	rm -rf $tmp
+	_cleanup
 }
 
 _destroy_fstrim()
@@ -153,7 +158,16 @@ content=$here
 
 # Check for FITRIM support
 echo -n "Checking FITRIM support: "
-_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
+if ! _test_batched_discard $SCRATCH_MNT; then
+	_scratch_unmount
+	img_file=$TEST_DIR/$$.fs
+	_require_fs_space $TEST_DIR 1048576
+	$XFS_IO_PROG -f -c "truncate 1G" $img_file || _fail "Cannot allocate space for $img_file"
+	loop=$(_create_loop_device $img_file)
+	SCRATCH_DEV=$loop
+	_scratch_mkfs >/dev/null 2>&1
+	_scratch_mount
+fi
 echo "done."
 
 mkdir -p $tmp
diff --git a/260 b/260
index ae4740a..cce5137 100755
--- a/260
+++ b/260
@@ -29,7 +29,7 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=`mktemp -d`
 status=0
-trap "exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 3
 chpid=0
 mypid=$$
 
@@ -47,7 +47,25 @@ _require_scratch
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
-_test_batched_discard $SCRATCH_MNT || _notrun "FITRIM not supported on $SCRATCH_DEV"
+_cleanup()
+{
+	if [ -n "$loop" ]; then
+		_scratch_unmount
+		_destroy_loop_device $loop
+		rm $img_file
+	fi
+}
+
+if ! _test_batched_discard $SCRATCH_MNT; then
+	_scratch_unmount
+	img_file=$TEST_DIR/$$.fs
+	_require_fs_space $TEST_DIR 1048576
+	$XFS_IO_PROG -f -c "truncate 1G" $img_file || _fail "Cannot allocate space for $img_file"
+	loop=$(_create_loop_device $img_file)
+	SCRATCH_DEV=$loop
+	_scratch_mkfs >/dev/null 2>&1
+	_scratch_mount
+fi
 
 fssize=$(df -k | grep "$SCRATCH_MNT" | grep "$SCRATCH_DEV"  | awk '{print $2}')
 
diff --git a/common.rc b/common.rc
index 966fc93..62b982b 100644
--- a/common.rc
+++ b/common.rc
@@ -1804,6 +1804,20 @@ _test_batched_discard()
 	$FSTRIM_PROG ${1} &>/dev/null
 }
 
+_create_loop_device()
+{
+	file=$1
+	dev=`losetup -f`
+	losetup $dev $file || _fail "Cannot associate $file with $dev"
+	echo $dev
+}
+
+_destroy_loop_device()
+{
+	dev=$1
+	losetup -d $dev || _fail "Cannot destroy loop device $dev"
+}
+
 ################################################################################
 
 if [ "$iam" != new -a "$iam" != bench ]
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
