Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13805 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbdBMPPy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Feb 2017 10:15:54 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] tests/xfs: test to stress XFS delalloc indirect block reservations
Date: Mon, 13 Feb 2017 10:15:53 -0500
Message-Id: <1486998953-26481-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

This test is based on generic/033, which originally used zero range
operations to reproduce indlen reservation problems. Zero range now
includes a pagecache flush before it updates extents, which means
generic/033 is no longer able to reproduce the problem it was originally
written to test.

Create a new test that uses an XFS-specific mechanism (in DEBUG mode) to
induce delalloc extent splits and reproduce the problem originally
reproduced by generic/033. In addition, update the test to include a
larger buffered write pattern that is known to reproduce premature
indlen exhaustion on delalloc extents.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v2:
- Copy original generic/033 rather than move.
- Squash series into single patch.
v1: http://www.spinics.net/lists/fstests/msg05187.html

 tests/xfs/289     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/289.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 112 insertions(+)
 create mode 100755 tests/xfs/289
 create mode 100644 tests/xfs/289.out

diff --git a/tests/xfs/289 b/tests/xfs/289
new file mode 100755
index 0000000..11844cf
--- /dev/null
+++ b/tests/xfs/289
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 289
+#
+# This test stresses indirect block reservation for delayed allocation extents.
+# XFS reserves extra blocks for deferred allocation of delalloc extents. These
+# reserved blocks can be divided among more extents than anticipated if the
+# original extent for which the blocks were reserved is split into multiple
+# delalloc extents. If this scenario repeats, eventually some extents are left
+# without any indirect block reservation whatsoever. This leads to assert
+# failures and possibly other problems in XFS.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/punch
+
+# real QA test starts here
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_sysfs $(_short_dev $TEST_DEV)/drop_writes
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+sdev=$(_short_dev $SCRATCH_DEV)
+file=$SCRATCH_MNT/file.$seq
+bytes=$((64 * 1024))
+
+# create sequential delayed allocation
+$XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
+
+# Enable write drops. All buffered writes are dropped from this point on.
+echo 1 > /sys/fs/xfs/$sdev/drop_writes
+
+# Write every other 4k range to split the larger delalloc extent into many more
+# smaller extents. Use pwrite because with write failures enabled, all
+# preexisting delalloc blocks in the range of the I/O are tossed without
+# discretion. This allows manipulation of the delalloc extent without conversion
+# to real blocks (and thus releasing the indirect reservation).
+endoff=$((bytes - 4096))
+for i in $(seq 0 8192 $endoff); do
+	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
+done
+
+# now pwrite the opposite set to remove remaining delalloc extents
+for i in $(seq 4096 8192 $endoff); do
+	$XFS_IO_PROG -c "pwrite $i 4k" $file >> $seqres.full 2>&1
+done
+
+echo 0 > /sys/fs/xfs/$sdev/drop_writes
+
+_scratch_cycle_mount
+$XFS_IO_PROG -c 'bmap -vp' $file | _filter_bmap
+
+# Now test a buffered write workload with larger extents. Write a 100m extent,
+# split it at the 3/4 mark, then write another 100m extent that is contiguous
+# with the 1/4 portion of the split extent. Repeat several times. This pattern
+# is known to prematurely exhaust indirect reservations and cause warnings and
+# assert failures.
+rm -f $file
+for offset in $(seq 0 100 500); do
+	$XFS_IO_PROG -fc "pwrite ${offset}m 100m" $file >> $seqres.full 2>&1
+
+	punchoffset=$((offset + 75))
+	echo 1 > /sys/fs/xfs/$sdev/drop_writes
+	$XFS_IO_PROG -c "pwrite ${punchoffset}m 4k" $file >> $seqres.full 2>&1
+	echo 0 > /sys/fs/xfs/$sdev/drop_writes
+done
+
+echo "Silence is golden."
+
+status=0
+exit
diff --git a/tests/xfs/289.out b/tests/xfs/289.out
new file mode 100644
index 0000000..72e60f9
--- /dev/null
+++ b/tests/xfs/289.out
@@ -0,0 +1,2 @@
+QA output created by 289
+Silence is golden.
diff --git a/tests/xfs/group b/tests/xfs/group
index e2dfae2..7c188fe 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -280,6 +280,7 @@
 283 dump ioctl auto quick
 284 auto quick dump copy db mkfs repair
 287 auto dump quota quick
+289 auto quick rw
 290 auto rw prealloc quick ioctl zero
 291 auto repair
 292 auto mkfs quick
-- 
2.7.4

