Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42291 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967431AbdAEBFT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:05:19 -0500
Subject: [PATCH 6/7] dedupe: fix consistent error message prefixes for
 dedupe tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:05:14 -0800
Message-ID: <148357831442.7677.16850160926032292098.stgit@birch.djwong.org>
In-Reply-To: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Since we're fixing the xfs_io dedupe command to consistently
print the dedupe ioctl name on error, fix the tests too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/122.out |    2 +-
 tests/generic/136.out |    2 +-
 tests/generic/158.out |   16 ++++++++--------
 tests/generic/304.out |   12 ++++++------
 tests/generic/374.out |    2 +-
 5 files changed, 17 insertions(+), 17 deletions(-)


diff --git a/tests/generic/122.out b/tests/generic/122.out
index 7925e90..4459985 100644
--- a/tests/generic/122.out
+++ b/tests/generic/122.out
@@ -4,7 +4,7 @@ Create the original files
 5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
 Files 1-2 do not match (intentional)
 (Fail to) dedupe the middle blocks together
-dedupe: Extents did not match.
+XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
 Compare sections
 35ac8d7917305c385c30f3d82c30a8f6  TEST_DIR/test-122/file1
 5e3501f97fd2669babfcbd3e1972e833  TEST_DIR/test-122/file2
diff --git a/tests/generic/136.out b/tests/generic/136.out
index f76f40a..508953f 100644
--- a/tests/generic/136.out
+++ b/tests/generic/136.out
@@ -7,7 +7,7 @@ c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
 Dedupe the last blocks together
 1->2
 1->3
-dedupe: Extents did not match.
+XFS_IOC_FILE_EXTENT_SAME: Extents did not match.
 c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file1
 c4fd505be25a0c91bcca9f502b9a8156  TEST_DIR/test-136/file2
 07ac67bf7f271195442509e79cde4cee  TEST_DIR/test-136/file3
diff --git a/tests/generic/158.out b/tests/generic/158.out
index 9b82ddf..8df9d9a 100644
--- a/tests/generic/158.out
+++ b/tests/generic/158.out
@@ -2,17 +2,17 @@ QA output created by 158
 Format and mount
 Create the original files
 Try cross-device dedupe
-dedupe: Invalid cross-device link
+XFS_IOC_FILE_EXTENT_SAME: Invalid cross-device link
 Try unaligned dedupe
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try overlapping dedupe
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try dedupe from past EOF
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try dedupe to past EOF, destination offset beyond EOF
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try dedupe to past EOF, destination offset behind EOF
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try to dedupe a dir
 XFS_IOC_FILE_EXTENT_SAME: Is a directory
 Try to dedupe a device
@@ -20,8 +20,8 @@ XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try to dedupe to a dir
 TEST_DIR/test-158/dir1: Is a directory
 Try to dedupe to a device
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try to dedupe to a fifo
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Try to dedupe an append-only file
 Dedupe two files
diff --git a/tests/generic/304.out b/tests/generic/304.out
index 7b5ff0e..a979099 100644
--- a/tests/generic/304.out
+++ b/tests/generic/304.out
@@ -2,17 +2,17 @@ QA output created by 304
 Format and mount
 Create the original files
 Dedupe large single byte file
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Dedupe large empty file
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Dedupe past maximum file size in dest file (should fail)
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Dedupe high offset to low offset
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Dedupe past source file EOF (should fail)
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Dedupe max size at nonzero offset (should fail)
-dedupe: Invalid argument
+XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Dedupe with huge off/len (should fail)
 XFS_IOC_FILE_EXTENT_SAME: Invalid argument
 Check file creation
diff --git a/tests/generic/374.out b/tests/generic/374.out
index b9a2073..3243ad3 100644
--- a/tests/generic/374.out
+++ b/tests/generic/374.out
@@ -3,7 +3,7 @@ Format and mount
 Mount otherdir
 Create file
 Dedupe one file to another
-dedupe: Invalid cross-device link
+XFS_IOC_FILE_EXTENT_SAME: Invalid cross-device link
 Check output
 2d61aa54b58c2e94403fb092c3dbc027  SCRATCH_MNT/test-374/file
 2d61aa54b58c2e94403fb092c3dbc027  OTHER_DIR/test-374/otherfile

