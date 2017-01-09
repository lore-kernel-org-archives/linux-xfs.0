Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26444 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932974AbdAIUyW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 15:54:22 -0500
Date: Mon, 9 Jan 2017 12:54:18 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 6/7] dedupe: fix consistent error message prefixes for
 dedupe tests
Message-ID: <20170109205418.GE14033@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
 <148357831442.7677.16850160926032292098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148357831442.7677.16850160926032292098.stgit@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Since we're fixing the xfs_io dedupe command to consistently
print the dedupe ioctl name on error, fix the tests too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: use _filter_dedupe_error
---
 tests/generic/122     |    2 +-
 tests/generic/122.out |    2 +-
 tests/generic/136     |    2 +-
 tests/generic/136.out |    2 +-
 tests/generic/374     |    2 +-
 tests/generic/374.out |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/generic/122 b/tests/generic/122
index 9dcfa9a..5008190 100755
--- a/tests/generic/122
+++ b/tests/generic/122
@@ -67,7 +67,7 @@ _compare_range $testdir/file1 0 $testdir/file2 0 "$((blksz * 8))" \
 echo "(Fail to) dedupe the middle blocks together"
 free_before=$(stat -f -c '%a' $testdir)
 _dedupe_range $testdir/file1 $((blksz * 4)) $testdir/file2 \
-		$((blksz * 4)) $((blksz * 2)) >> $seqres.full
+		$((blksz * 4)) $((blksz * 2)) 2>&1 | _filter_dedupe_error
 _test_cycle_mount
 free_after=$(stat -f -c '%a' $testdir)
 echo "freesp changed by $free_before -> $free_after" >> $seqres.full
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
diff --git a/tests/generic/136 b/tests/generic/136
index c72d11f..665749f 100755
--- a/tests/generic/136
+++ b/tests/generic/136
@@ -85,7 +85,7 @@ echo "Dedupe the last blocks together"
 echo "1->2"
 _dedupe_range $testdir/file1 $blksz $testdir/file2 $blksz 37 >> $seqres.full
 echo "1->3"
-_dedupe_range $testdir/file1 $blksz $testdir/file3 $blksz 37 >> $seqres.full
+_dedupe_range $testdir/file1 $blksz $testdir/file3 $blksz 37 2>&1 | _filter_dedupe_error
 _test_cycle_mount
 
 md5sum $testdir/file1 | _filter_test_dir
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
diff --git a/tests/generic/374 b/tests/generic/374
index eabaf2e..5a24ec8 100755
--- a/tests/generic/374
+++ b/tests/generic/374
@@ -70,7 +70,7 @@ _pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
 _pwrite_byte 0x61 0 $sz $testdir/otherfile >> $seqres.full
 
 echo "Dedupe one file to another"
-_dedupe_range $testdir/file 0 $othertestdir/otherfile 0 $sz >> $seqres.full
+_dedupe_range $testdir/file 0 $othertestdir/otherfile 0 $sz 2>&1 | _filter_dedupe_error
 
 filter_md5()
 {
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
