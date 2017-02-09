Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52616 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752921AbdBIUiA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 15:38:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 2/3] tests/xfs: update indlen res. test to use fail writes mechanism
Date: Thu,  9 Feb 2017 14:43:43 -0500
Message-Id: <1486669424-45274-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
References: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

This test originally used zero range operations to reproduce problematic
indirect delalloc reservations on XFS. Zero range has since been updated
to include a pagecache flush before it updates extents, which means
delalloc extents are converted to real extents and indlen reservations
are drained before extents are modified. As a result, zero range is no
longer an effective tool to reproduce the original problem.

Instead, a debug mode failure injection mechanism has been added to XFS
to cause dropped writes and trigger the delalloc extent hole punch
behavior required to reproduce this problem. Update the test to use this
new mechanism.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/xfs/289     | 28 +++++++++++++++++++---------
 tests/xfs/289.out |  4 +---
 tests/xfs/group   |  2 +-
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/tests/xfs/289 b/tests/xfs/289
index 33cf060..3aa53b9 100755
--- a/tests/xfs/289
+++ b/tests/xfs/289
@@ -44,6 +44,7 @@ _cleanup()
 
 # get standard environment, filters and checks
 . ./common/rc
+. ./common/punch
 
 # real QA test starts here
 rm -f $seqres.full
@@ -52,33 +53,42 @@ rm -f $seqres.full
 _supported_fs generic
 _supported_os Linux
 _require_scratch
-_require_xfs_io_command "fzero"
+_require_xfs_sysfs $(_short_dev $TEST_DEV)/drop_writes
 
 _scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
+sdev=$(_short_dev $SCRATCH_DEV)
 file=$SCRATCH_MNT/file.$seq
 bytes=$((64 * 1024))
 
 # create sequential delayed allocation
 $XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
 
-# Zero every other 4k range to split the larger delalloc extent into many more
-# smaller extents. Use zero instead of hole punch because the former does not
-# force writeback (and hence delalloc conversion). It can simply discard
-# delalloc blocks and convert the ranges to unwritten.
+# Enable write drops. All buffered writes are dropped from this point on.
+echo 1 > /sys/fs/xfs/$sdev/drop_writes
+
+# Write every other 4k range to split the larger delalloc extent into many more
+# smaller extents. Use pwrite because with write failures enabled, all
+# preexisting delalloc blocks in the range of the I/O are tossed without
+# discretion. This allows manipulation of the delalloc extent without conversion
+# to real blocks (and thus releasing the indirect reservation).
 endoff=$((bytes - 4096))
 for i in $(seq 0 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
 done
 
-# now zero the opposite set to remove remaining delalloc extents
+# now pwrite the opposite set to remove remaining delalloc extents
 for i in $(seq 4096 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
 done
 
+echo 0 > /sys/fs/xfs/$sdev/drop_writes
+
+echo "Silence is golden."
+
 _scratch_cycle_mount
-hexdump $file
+$XFS_IO_PROG -c 'bmap -vp' $file | _filter_bmap
 
 status=0
 exit
diff --git a/tests/xfs/289.out b/tests/xfs/289.out
index bdcf195..72e60f9 100644
--- a/tests/xfs/289.out
+++ b/tests/xfs/289.out
@@ -1,4 +1,2 @@
 QA output created by 289
-0000000 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0010000
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index 5c1ba16..7c188fe 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -280,7 +280,7 @@
 283 dump ioctl auto quick
 284 auto quick dump copy db mkfs repair
 287 auto dump quota quick
-289 auto quick rw zero
+289 auto quick rw
 290 auto rw prealloc quick ioctl zero
 291 auto repair
 292 auto mkfs quick
-- 
2.7.4

