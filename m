Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753591AbcL3EJE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Dec 2016 23:09:04 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] generic/158,304: filter dedupe error message
Date: Fri, 30 Dec 2016 12:08:54 +0800
Message-Id: <20161230040854.17512-1-eguan@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, darrick.wong@oracle.com, Eryu Guan <eguan@redhat.com>

Kernel commit 22725ce4e4a0 ("vfs: fix isize/pos/len checks for reflink &
dedupe") added more checks on reflink and dedupe, rejected dedupe past
EOF early and explicitly, and causes generic/158 and generic/304 to fail.

  Try dedupe from past EOF
 -dedupe: Invalid argument
 +XFS_IOC_FILE_EXTENT_SAME: Invalid argument
  Try dedupe to past EOF, destination offset beyond EOF

Fix it by replacing fs-specific ioctl in error message to "dedupe".

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/reflink        | 7 +++++++
 tests/generic/158     | 7 +++++--
 tests/generic/158.out | 4 ++--
 tests/generic/304     | 9 ++++++---
 tests/generic/304.out | 2 +-
 5 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/common/reflink b/common/reflink
index 64ee04f..7306efd 100644
--- a/common/reflink
+++ b/common/reflink
@@ -241,6 +241,13 @@ _dedupe_range() {
 	$XFS_IO_PROG $xfs_io_args -f -c "dedupe $file1 $offset1 $offset2 $len" "$file2"
 }
 
+# Filter fs-specific ioctl in error message to "dedupe"
+# e.g. replace XFS_IOC_FILE_EXTENT_SAME with dedupe
+_filter_dedupe()
+{
+	sed -e 's/XFS_IOC_FILE_EXTENT_SAME/dedupe/g'
+}
+
 # Create a file of interleaved unwritten and reflinked blocks
 _weave_reflink_unwritten() {
 	blksz=$1
diff --git a/tests/generic/158 b/tests/generic/158
index 086c522..77ab1ce 100755
--- a/tests/generic/158
+++ b/tests/generic/158
@@ -81,10 +81,12 @@ mkfifo $testdir1/fifo1
 sync
 
 _filter_enotty() {
+	_filter_dedupe | \
 	sed -e 's/Inappropriate ioctl for device/Invalid argument/g'
 }
 
 _filter_eperm() {
+	_filter_dedupe | \
 	sed -e 's/Permission denied/Invalid argument/g'
 }
 
@@ -98,7 +100,8 @@ echo "Try overlapping dedupe"
 _dedupe_range $testdir1/file1 0 $testdir1/file1 1 $((blksz * 2))
 
 echo "Try dedupe from past EOF"
-_dedupe_range $testdir1/file1 $(( (blks + 10) * blksz)) $testdir1/file1 0 $blksz
+_dedupe_range $testdir1/file1 $(( (blks + 10) * blksz)) $testdir1/file1 0 $blksz \
+	2>&1 | _filter_dedupe
 
 echo "Try dedupe to past EOF, destination offset beyond EOF"
 _dedupe_range $testdir1/file1 0 $testdir1/file1 $(( (blks + 10) * blksz)) \
@@ -109,7 +112,7 @@ _dedupe_range $testdir1/file1 0 $testdir1/file1 $(( (blks - 1) * blksz)) \
 	$((blksz * 2))
 
 echo "Try to dedupe a dir"
-_dedupe_range $testdir1/dir1 0 $testdir1/file2 0 $blksz
+_dedupe_range $testdir1/dir1 0 $testdir1/file2 0 $blksz 2>&1 | _filter_dedupe
 
 echo "Try to dedupe a device"
 _dedupe_range $testdir1/dev1 0 $testdir1/file2 0 $blksz 2>&1 | _filter_enotty
diff --git a/tests/generic/158.out b/tests/generic/158.out
index 9b82ddf..3a9596f 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -14,9 +14,9 @@ dedupe: Invalid argument
 Try dedupe to past EOF, destination offset behind EOF
 dedupe: Invalid argument
 Try to dedupe a dir
-XFS_IOC_FILE_EXTENT_SAME: Is a directory
+dedupe: Is a directory
 Try to dedupe a device
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+dedupe: Invalid argument
 Try to dedupe to a dir
 TEST_DIR/test-158/dir1: Is a directory
 Try to dedupe to a device
diff --git a/tests/generic/304 b/tests/generic/304
index b7ee7b9..8f0a3b4 100755
--- a/tests/generic/304
+++ b/tests/generic/304
@@ -75,13 +75,16 @@ echo "Dedupe high offset to low offset"
 _dedupe_range $testdir/file1 $bigoff_64k $testdir/file6 1048576 65535 >> $seqres.full
 
 echo "Dedupe past source file EOF (should fail)"
-_dedupe_range $testdir/file2 524288 $testdir/file7 0 1048576 >> $seqres.full
+_dedupe_range $testdir/file2 524288 $testdir/file7 0 1048576 \
+	2>&1 >> $seqres.full | _filter_dedupe
 
 echo "Dedupe max size at nonzero offset (should fail)"
-_dedupe_range $testdir/file2 524288 $testdir/file8 0 $len >> $seqres.full
+_dedupe_range $testdir/file2 524288 $testdir/file8 0 $len \
+	2>&1 >> $seqres.full | _filter_dedupe
 
 echo "Dedupe with huge off/len (should fail)"
-_dedupe_range $testdir/file2 $bigoff_64k $testdir/file9 0 $bigoff_64k >> $seqres.full
+_dedupe_range $testdir/file2 $bigoff_64k $testdir/file9 0 $bigoff_64k \
+	2>&1 >> $seqres.full | _filter_dedupe
 
 echo "Check file creation"
 _test_cycle_mount
diff --git a/tests/generic/304.out b/tests/generic/304.out
index 7b5ff0e..fbba6f3 100644
--- a/tests/generic/304.out
+++ b/tests/generic/304.out
@@ -14,7 +14,7 @@ dedupe: Invalid argument
 Dedupe max size at nonzero offset (should fail)
 dedupe: Invalid argument
 Dedupe with huge off/len (should fail)
-XFS_IOC_FILE_EXTENT_SAME: Invalid argument
+dedupe: Invalid argument
 Check file creation
 file3
 7ffffffffffffffe:  61  a
-- 
2.9.3

