Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6859F7F53
	for <xfs@oss.sgi.com>; Tue,  8 Dec 2015 00:29:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 376C7304059
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 22:29:25 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kzXKBvP0RnHuL80r (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2015 22:29:22 -0800 (PST)
Subject: [PATCH 2/3] generic/15[78]: fix error messages in the golden output
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 07 Dec 2015 22:28:58 -0800
Message-ID: <20151208062858.21871.84165.stgit@birch.djwong.org>
In-Reply-To: <20151208062844.21871.23644.stgit@birch.djwong.org>
References: <20151208062844.21871.23644.stgit@birch.djwong.org>
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
 tests/generic/157     |   18 +++++++++++++-----
 tests/generic/157.out |    6 +++---
 tests/generic/158     |   18 +++++++++++++-----
 tests/generic/158.out |    8 ++++----
 4 files changed, 33 insertions(+), 17 deletions(-)


diff --git a/tests/generic/157 b/tests/generic/157
index a43fb0d..f68ff52 100755
--- a/tests/generic/157
+++ b/tests/generic/157
@@ -75,10 +75,18 @@ mkdir "$TESTDIR1/dir1"
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
+_filter_einval() {
+	sed -e 's/Invalid argument/Bad file descriptor/g'
+}
+
 echo "Try cross-device reflink"
 _reflink_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
 
@@ -98,16 +106,16 @@ echo "Try to reflink a device"
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
-_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a 2>&1 | _filter_einval
 
 echo "Reflink two files"
 _reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ >> "$seqres.full"
diff --git a/tests/generic/157.out b/tests/generic/157.out
index 177e7f8..ac3c440 100644
--- a/tests/generic/157.out
+++ b/tests/generic/157.out
@@ -14,11 +14,11 @@ XFS_IOC_CLONE_RANGE: Is a directory
 Try to reflink a device
 XFS_IOC_CLONE_RANGE: Invalid argument
 Try to reflink to a dir
-/mnt/test-157/dir1: Is a directory
+TEST_DIR/test-157/dir1: Is a directory
 Try to reflink to a device
-XFS_IOC_CLONE_RANGE: Operation not supported
+XFS_IOC_CLONE_RANGE: Invalid argument
 Try to reflink to a fifo
-XFS_IOC_CLONE_RANGE: Operation not supported
+XFS_IOC_CLONE_RANGE: Invalid argument
 Try to reflink an append-only file
 XFS_IOC_CLONE_RANGE: Bad file descriptor
 Reflink two files
diff --git a/tests/generic/158 b/tests/generic/158
index a499b21..749b186 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -76,10 +76,18 @@ mkdir "$TESTDIR1/dir1"
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
+_filter_eperm() {
+	sed -e 's/Permission denied/Invalid argument/g'
+}
+
 echo "Try cross-device dedupe"
 _dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
 
@@ -96,16 +104,16 @@ echo "Try to dedupe a dir"
 _dedupe_range "$TESTDIR1/dir1" 0 "$TESTDIR1/file2" 0 $BLKSZ
 
 echo "Try to dedupe a device"
-_dedupe_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+_dedupe_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_enotty
 
 echo "Try to dedupe to a dir"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ 2>&1 | _filter_test_dir
 
 echo "Try to dedupe to a device"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ 2>&1 | _filter_eperm
 
 echo "Try to dedupe to a fifo"
-_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n 2>&1 | _filter_eperm
 
 echo "Try to dedupe an append-only file"
 _dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a >> "$seqres.full"
diff --git a/tests/generic/158.out b/tests/generic/158.out
index 36a3f1f..dff3692 100644
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
+dedupe: Invalid argument
 Try to dedupe to a fifo
-dedupe: Permission denied
+dedupe: Invalid argument
 Try to dedupe an append-only file
 Dedupe two files
 Check scratch fs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
