Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 262217F54
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 18:50:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A2588AC004
	for <xfs@oss.sgi.com>; Fri, 20 Nov 2015 16:50:49 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id lWg523o5NaGhHxDp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 20 Nov 2015 16:50:46 -0800 (PST)
Subject: [PATCH 2/2] generic/15[78]: fix error messages in the golden output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 20 Nov 2015 16:50:14 -0800
Message-ID: <20151121005014.20398.22316.stgit@birch.djwong.org>
In-Reply-To: <20151121005001.20398.92856.stgit@birch.djwong.org>
References: <20151121005001.20398.92856.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Fix the error messages in the golden output for generic/15[78], which
examine the responses to invalid inputs as returned by the
clone/clone_range/extent_same ioctls.  Also fix a filtering omission.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/157     |   12 ++++++++----
 tests/generic/157.out |    2 +-
 tests/generic/158     |   10 +++++++---
 tests/generic/158.out |    8 ++++----
 4 files changed, 20 insertions(+), 12 deletions(-)


diff --git a/tests/generic/157 b/tests/generic/157
index a43fb0d..f3de285 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -75,10 +75,14 @@ mkdir "$TESTDIR1/dir1"
 seq 1 $((2 * BLKSZ / 250)) | while read f; do
 	touch "$TESTDIR1/dir1/$f"
 done
-mknod "$TESTDIR1/dev1" b 8 0
+mknod "$TESTDIR1/dev1" c 1 3
 mkfifo "$TESTDIR1/fifo1"
 sync
 
+_filter_enotty() {
+	sed -e 's/Inappropriate ioctl for device/Operation not supported/g'
+}
+
 echo "Try cross-device reflink"
 _reflink_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
 
@@ -98,13 +102,13 @@ echo "Try to reflink a device"
 _reflink_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ
 
 echo "Try to reflink to a dir"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ 2>&1 | _filter_test_dir
 
 echo "Try to reflink to a device"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ 2>&1 | _filter_enotty
 
 echo "Try to reflink to a fifo"
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n 2>&1 | _filter_enotty
 
 echo "Try to reflink an append-only file"
 _reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a
diff --git a/tests/generic/157.out b/tests/generic/157.out
index 177e7f8..3a690ca 100644
--- a/tests/generic/157.out
+++ b/tests/generic/157.out
@@ -14,7 +14,7 @@ XFS_IOC_CLONE_RANGE: Is a directory
 Try to reflink a device
 XFS_IOC_CLONE_RANGE: Invalid argument
 Try to reflink to a dir
-/mnt/test-157/dir1: Is a directory
+TEST_DIR/test-157/dir1: Is a directory
 Try to reflink to a device
 XFS_IOC_CLONE_RANGE: Operation not supported
 Try to reflink to a fifo
diff --git a/tests/generic/158 b/tests/generic/158
index a499b21..db5d05c 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -76,10 +76,14 @@ mkdir "$TESTDIR1/dir1"
 seq 1 $((2 * BLKSZ / 250)) | while read f; do
 	touch "$TESTDIR1/dir1/$f"
 done
-mknod "$TESTDIR1/dev1" b 8 0
+mknod "$TESTDIR1/dev1" c 1 3
 mkfifo "$TESTDIR1/fifo1"
 sync
 
+_filter_enotty() {
+	sed -e 's/Inappropriate ioctl for device/Invalid argument/g'
+}
+
 echo "Try cross-device dedupe"
 _dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
 
@@ -96,10 +100,10 @@ echo "Try to dedupe a dir"
 _dedupe_range "$TESTDIR1/dir1" 0 "$TESTDIR1/file2" 0 $BLKSZ
 
 echo "Try to dedupe a device"
-_dedupe_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+_dedupe_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_enotty
 
 echo "Try to dedupe to a dir"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ 2>&1 | _filter_test_dir
 
 echo "Try to dedupe to a device"
 _dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ
diff --git a/tests/generic/158.out b/tests/generic/158.out
index 36a3f1f..1210429 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -12,13 +12,13 @@ dedupe: Invalid argument
 Try to dedupe a dir
 XFS_IOC_FILE_EXTENT_SAME: Is a directory
 Try to dedupe a device
-XFS_IOC_FILE_EXTENT_SAME: Permission denied
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try to dedupe to a dir
-/mnt/test-158/dir1: Is a directory
+TEST_DIR/test-158/dir1: Is a directory
 Try to dedupe to a device
-dedupe: Permission denied
+dedupe: Operation not supported
 Try to dedupe to a fifo
-dedupe: Permission denied
+dedupe: Operation not supported
 Try to dedupe an append-only file
 Dedupe two files
 Check scratch fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
