Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753124AbdBIUiA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Feb 2017 15:38:00 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 1/3] xfstests: move generic indlen reservation test to xfs dir
Date: Thu,  9 Feb 2017 14:43:42 -0500
Message-Id: <1486669424-45274-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
References: <1486669424-45274-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

This test was originally designed to reproduce the split indlen
reservation depletion problem in XFS. It was included as a generic test
simply because it had no hard dependencies on XFS or associated tools.

This test is no longer effective in its current form. Fixing it requires
use of XFS specific mechanisms. Therefore, move the test to the XFS
specific test directory. No other changes are made in this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/033     | 84 ---------------------------------------------------
 tests/generic/033.out |  4 ---
 tests/generic/group   |  1 -
 tests/xfs/289         | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/289.out     |  4 +++
 tests/xfs/group       |  1 +
 6 files changed, 89 insertions(+), 89 deletions(-)
 delete mode 100755 tests/generic/033
 delete mode 100644 tests/generic/033.out
 create mode 100755 tests/xfs/289
 create mode 100644 tests/xfs/289.out

diff --git a/tests/generic/033 b/tests/generic/033
deleted file mode 100755
index 4f8bb92..0000000
--- a/tests/generic/033
+++ /dev/null
@@ -1,84 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 033
-#
-# This test stresses indirect block reservation for delayed allocation extents.
-# XFS reserves extra blocks for deferred allocation of delalloc extents. These
-# reserved blocks can be divided among more extents than anticipated if the
-# original extent for which the blocks were reserved is split into multiple
-# delalloc extents. If this scenario repeats, eventually some extents are left
-# without any indirect block reservation whatsoever. This leads to assert
-# failures and possibly other problems in XFS.
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1	# failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-	cd /
-	rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-
-# real QA test starts here
-rm -f $seqres.full
-
-# Modify as appropriate.
-_supported_fs generic
-_supported_os Linux
-_require_scratch
-_require_xfs_io_command "fzero"
-
-_scratch_mkfs >/dev/null 2>&1
-_scratch_mount
-
-file=$SCRATCH_MNT/file.$seq
-bytes=$((64 * 1024))
-
-# create sequential delayed allocation
-$XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
-
-# Zero every other 4k range to split the larger delalloc extent into many more
-# smaller extents. Use zero instead of hole punch because the former does not
-# force writeback (and hence delalloc conversion). It can simply discard
-# delalloc blocks and convert the ranges to unwritten.
-endoff=$((bytes - 4096))
-for i in $(seq 0 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
-done
-
-# now zero the opposite set to remove remaining delalloc extents
-for i in $(seq 4096 8192 $endoff); do
-	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
-done
-
-_scratch_cycle_mount
-hexdump $file
-
-status=0
-exit
diff --git a/tests/generic/033.out b/tests/generic/033.out
deleted file mode 100644
index 419d831..0000000
--- a/tests/generic/033.out
+++ /dev/null
@@ -1,4 +0,0 @@
-QA output created by 033
-0000000 0000 0000 0000 0000 0000 0000 0000 0000
-*
-0010000
diff --git a/tests/generic/group b/tests/generic/group
index d0bc47d..98d57f3 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -35,7 +35,6 @@
 030 auto quick rw
 031 auto quick prealloc rw collapse
 032 auto quick rw
-033 auto quick rw zero
 034 auto quick metadata log
 035 auto quick
 036 auto aio rw stress
diff --git a/tests/xfs/289 b/tests/xfs/289
new file mode 100755
index 0000000..33cf060
--- /dev/null
+++ b/tests/xfs/289
@@ -0,0 +1,84 @@
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
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
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
+
+# real QA test starts here
+rm -f $seqres.full
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_xfs_io_command "fzero"
+
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+file=$SCRATCH_MNT/file.$seq
+bytes=$((64 * 1024))
+
+# create sequential delayed allocation
+$XFS_IO_PROG -f -c "pwrite 0 $bytes" $file >> $seqres.full 2>&1
+
+# Zero every other 4k range to split the larger delalloc extent into many more
+# smaller extents. Use zero instead of hole punch because the former does not
+# force writeback (and hence delalloc conversion). It can simply discard
+# delalloc blocks and convert the ranges to unwritten.
+endoff=$((bytes - 4096))
+for i in $(seq 0 8192 $endoff); do
+	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+done
+
+# now zero the opposite set to remove remaining delalloc extents
+for i in $(seq 4096 8192 $endoff); do
+	$XFS_IO_PROG -c "fzero -k $i 4k" $file >> $seqres.full 2>&1
+done
+
+_scratch_cycle_mount
+hexdump $file
+
+status=0
+exit
diff --git a/tests/xfs/289.out b/tests/xfs/289.out
new file mode 100644
index 0000000..bdcf195
--- /dev/null
+++ b/tests/xfs/289.out
@@ -0,0 +1,4 @@
+QA output created by 289
+0000000 0000 0000 0000 0000 0000 0000 0000 0000
+*
+0010000
diff --git a/tests/xfs/group b/tests/xfs/group
index e2dfae2..5c1ba16 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -280,6 +280,7 @@
 283 dump ioctl auto quick
 284 auto quick dump copy db mkfs repair
 287 auto dump quota quick
+289 auto quick rw zero
 290 auto rw prealloc quick ioctl zero
 291 auto repair
 292 auto mkfs quick
-- 
2.7.4

