Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0T4ffA2091509 for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 22:41:42 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3809195AF4
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 20:42:47 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id pgrQkYdFf0Ybqs4g for
	<xfs@oss.sgi.com>; Thu, 28 Jan 2010 20:42:47 -0800 (PST)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 34ABF9E7255
	for <xfs@oss.sgi.com>; Thu, 28 Jan 2010 22:42:47 -0600 (CST)
Message-ID: <4B626748.3070601@sandeen.net>
Date: Thu, 28 Jan 2010 22:42:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: helper to detect fs free space
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Make a common helper to skip a test if there's not enough
free space on the target fs.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/180 b/180
index 6ba32fe..c303169 100755
--- a/180
+++ b/180
@@ -51,10 +51,8 @@ _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
 
-# Do we have enough space on disk?
-FREE_BLOCKS=`df -klP $SCRATCH_MNT | grep -v Filesystem | awk '{print $4}'`
-[ $FREE_BLOCKS -lt 10485760 ] && _notrun "This test requires at least 10GB of \
-                                          $SCRATCH_DEV to run"
+# Do we have enough space on disk?  10G
+_require_fs_space $SCRATCH_MNT 10485760
 
 _check_files()
 {
diff --git a/217 b/217
index 6032578..19540ad 100755
--- a/217
+++ b/217
@@ -50,6 +50,8 @@ _setup_testdir
 _require_scratch
 _scratch_mkfs_xfs >/dev/null 2>&1
 _scratch_mount
+# 16T mkfs requires a bit over 2G free
+_require_fs_space $SCRATCH_MNT 2202000
 
 _require_loop
 LOOP_DEV=$SCRATCH_MNT/test_fs
diff --git a/common.rc b/common.rc
index 237f3aa..537f575 100644
--- a/common.rc
+++ b/common.rc
@@ -755,7 +755,8 @@ _require_user()
 # check that xfs_io, glibc, kernel, and filesystem all (!) support
 # fallocate
 #
-_require_xfs_io_falloc() {
+_require_xfs_io_falloc()
+{
 	testio=`$XFS_IO_PROG -F -f -c "falloc 0 1m" $TEST_DIR/$tmp.io 2>&1`
 	rm -f $TEST_DIR/$tmp.io 2>&1 > /dev/null
 	echo $testio | grep -q "not found" && \
@@ -764,6 +765,19 @@ _require_xfs_io_falloc() {
 		_notrun "xfs_io fallocate command failed (old kernel/wrong fs?)"
 }
 
+# Check that a fs has enough free space (in 1024b blocks)
+#
+_require_fs_space()
+{
+	MNT=$1
+	BLOCKS=$2	# in units of 1024
+	let GB=$BLOCKS/1024/1024
+
+	FREE_BLOCKS=`df -klP $MNT | grep -v Filesystem | awk '{print $4}'`
+	[ $FREE_BLOCKS -lt $BLOCKS ] && \
+		_notrun "This test requires at least ${GB}GB free on $MNT to run"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
