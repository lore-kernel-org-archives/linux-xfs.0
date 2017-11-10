Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38434 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752494AbdKJAod (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2017 19:44:33 -0500
Subject: [PATCH 1/4] xfs/31[3-7]: hide pwrite fsync errors that are supposed
 to fail
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 09 Nov 2017 16:44:28 -0800
Message-ID: <151027466805.13147.11900555125085821847.stgit@magnolia>
In-Reply-To: <151027466195.13147.10381301768189156101.stgit@magnolia>
References: <151027466195.13147.10381301768189156101.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs_io 4.14 will gain the ability to print error messages when
pwrite+fsync fail.  Certain tests use the error injector to cause
failures, so the errors are expected.  Since we test for a shut down
filesystem after the error injection, we can push the error messages to
the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/312 |    2 +-
 tests/xfs/313 |    2 +-
 tests/xfs/314 |    2 +-
 tests/xfs/315 |    2 +-
 tests/xfs/317 |    2 +-
 tests/xfs/326 |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/tests/xfs/312 b/tests/xfs/312
index 0c10441..0987527 100755
--- a/tests/xfs/312
+++ b/tests/xfs/312
@@ -79,7 +79,7 @@ echo "Inject error"
 _scratch_inject_error "bmap_finish_one"
 
 echo "CoW a few blocks"
-$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full 2>&1
 
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
diff --git a/tests/xfs/313 b/tests/xfs/313
index 1a2cff2..0904b57 100755
--- a/tests/xfs/313
+++ b/tests/xfs/313
@@ -79,7 +79,7 @@ echo "Inject error"
 _scratch_inject_error "refcount_finish_one"
 
 echo "CoW a few blocks"
-$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full 2>&1
 
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
diff --git a/tests/xfs/314 b/tests/xfs/314
index ec16c6f..e2e4d7c 100755
--- a/tests/xfs/314
+++ b/tests/xfs/314
@@ -81,7 +81,7 @@ echo "Inject error"
 _scratch_inject_error "rmap_finish_one"
 
 echo "CoW a few blocks"
-$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full 2>&1
 
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
diff --git a/tests/xfs/315 b/tests/xfs/315
index 6170540..db26555 100755
--- a/tests/xfs/315
+++ b/tests/xfs/315
@@ -77,7 +77,7 @@ echo "Inject error"
 _scratch_inject_error "free_extent"
 
 echo "CoW a few blocks"
-$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $sz" $SCRATCH_MNT/file1 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $sz" $SCRATCH_MNT/file1 >> $seqres.full 2>&1
 sync
 
 echo "FS should be shut down, touch will fail"
diff --git a/tests/xfs/317 b/tests/xfs/317
index 507c2a9..651a067 100755
--- a/tests/xfs/317
+++ b/tests/xfs/317
@@ -71,7 +71,7 @@ echo "Inject error"
 _scratch_inject_error "rmap_finish_one"
 
 echo "Write files"
-$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $sz" $SCRATCH_MNT/file1 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz 0 $sz" $SCRATCH_MNT/file1 >> $seqres.full 2>&1
 
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
diff --git a/tests/xfs/326 b/tests/xfs/326
index 36bdcf4..929d3e6 100755
--- a/tests/xfs/326
+++ b/tests/xfs/326
@@ -87,7 +87,7 @@ echo "Inject error"
 _scratch_inject_error "refcount_finish_one"
 
 echo "CoW a few blocks"
-$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -W -S 0x67 -b $sz $((10 * blksz)) $((10 * blksz))" $SCRATCH_MNT/file2 >> $seqres.full 2>&1
 
 echo "FS should be shut down, touch will fail"
 touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch

