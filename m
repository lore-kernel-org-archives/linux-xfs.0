Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbeBHQEa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 8 Feb 2018 11:04:30 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] tests/xfs: rmapbt swapext block reservation overrun test
Date: Thu,  8 Feb 2018 11:04:29 -0500
Message-Id: <20180208160429.17281-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

The XFS rmapbt extent swap mechanism performs an extent by extent
swap to ensure the rmapbt is rectified with the appropriate extent
owner information after the operation. This implementation suffers
from a corner case that requires extra reservation if the swap
operation results in bouncing one of the associated inodes between
extent and btree formats. When this corner case occurs, it results
in a transaction block reservation overrun and possible corruption
of the free space accounting.

This regression test provides coverage for this corner case. It
creates two files with a large enough extent count to require btree
format, regardless of inode size, and performs a sequence of extent
swaps between them with a decreasing extent count until all extents
are removed from the file(s). This ensures that one of the swaps
covers the btree <-> extent fork format boundary case.

This test reproduces fs corruption on rmapbt enabled filesystems
running on kernels without the associated extent swap fix.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

The latest version of the xfs_io swapext patch is here:

  https://marc.info/?l=linux-xfs&m=151810545110330&w=2

... and doesn't appear to have serious objections after a first round of
review.

Brian

v2:
- Use fs blocksize and internal hole punch tool for file setup.
- Add fiemap sanity check to ensure test executes as expected.
- Add to fsr group.
v1: https://marc.info/?l=fstests&m=151792263511472&w=2

 tests/xfs/440     | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/440.out |   2 ++
 tests/xfs/group   |   1 +
 3 files changed, 109 insertions(+)
 create mode 100755 tests/xfs/440
 create mode 100644 tests/xfs/440.out

diff --git a/tests/xfs/440 b/tests/xfs/440
new file mode 100755
index 00000000..3ce771a8
--- /dev/null
+++ b/tests/xfs/440
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test 440
+#
+# Regression test for the XFS rmapbt based extent swap algorithm. The extent
+# swap algorithm for rmapbt=1 filesystems unmaps/remaps individual extents to
+# rectify the rmapbt for each extent swapped between inodes. If one of the
+# inodes happens to straddle the extent <-> btree format boundary (which can
+# vary depending on inode size), the unmap/remap sequence can bounce the inodes
+# back and forth between formats many times during the swap. Since extent ->
+# btree format conversion requires a block allocation, this can consume more
+# blocks than expected, lead to block reservation overrun and free space
+# accounting inconsistency.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Red Hat, Inc.  All Rights Reserved.
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
+. ./common/filter
+. ./common/punch
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_test_program "punch-alternating"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "swapext"
+
+_scratch_mkfs | _filter_mkfs >> $seqres.full 2> $tmp.mkfs
+_scratch_mount || _fail "mount failed"
+
+# get fs block size
+. $tmp.mkfs
+
+file1=$SCRATCH_MNT/file1
+file2=$SCRATCH_MNT/file2
+
+# The goal is run an extent swap where one of the associated files has the
+# minimum number of extents to remain in btree format. First, create a couple
+# files with large enough extent counts (200 or so should be plenty) to ensure
+# btree format on the largest possible inode size filesystems.
+$XFS_IO_PROG -fc "falloc 0 $((400 * dbsize))" $file1
+./src/punch-alternating $file1
+$XFS_IO_PROG -fc "falloc 0 $((400 * dbsize))" $file2
+./src/punch-alternating $file2
+
+# Now run an extent swap at every possible extent count down to 0. Depending on
+# inode size, one of these swaps will cover the boundary case between extent and
+# btree format.
+for i in $(seq 1 2 399); do
+	# punch one extent from the tmpfile and swap
+	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+	$XFS_IO_PROG -c "swapext $file2" $file1
+
+	# punch the same extent from the old fork (now in file2) to resync the
+	# extent counts and repeat
+	$XFS_IO_PROG -c "fpunch $((i * dbsize)) $dbsize" $file2
+done
+
+# sanity check that no extents are left over
+$XFS_IO_PROG -c "fiemap" $file1 | _filter_fiemap
+$XFS_IO_PROG -c "fiemap" $file2 | _filter_fiemap
+
+# failure results in fs corruption and possible assert failure
+echo Silence is golden
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/440.out b/tests/xfs/440.out
new file mode 100644
index 00000000..fb8dc21f
--- /dev/null
+++ b/tests/xfs/440.out
@@ -0,0 +1,2 @@
+QA output created by 440
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index cf81451d..ad30be42 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -437,3 +437,4 @@
 437 auto quick other
 438 auto quick quota dangerous
 439 auto quick fuzzers log
+440 auto quick ioctl fsr
-- 
2.13.6

