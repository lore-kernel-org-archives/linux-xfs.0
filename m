Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31157 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbcI3CYL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 22:24:11 -0400
Subject: [PATCH 9/9] xfs: test copy-on-write fragmentation when no cow
 extent size hint is set
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 19:24:02 -0700
Message-ID: <147520224274.26891.11193081257925690289.stgit@birch.djwong.org>
In-Reply-To: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
References: <147520218309.26891.10856487889060965097.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/897     |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/897.out |   10 +++++
 tests/xfs/898     |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/898.out |   10 +++++
 tests/xfs/899     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/899.out |   10 +++++
 tests/xfs/900     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/900.out |   10 +++++
 tests/xfs/group   |    4 ++
 9 files changed, 463 insertions(+)
 create mode 100755 tests/xfs/897
 create mode 100644 tests/xfs/897.out
 create mode 100755 tests/xfs/898
 create mode 100644 tests/xfs/898.out
 create mode 100755 tests/xfs/899
 create mode 100644 tests/xfs/899.out
 create mode 100755 tests/xfs/900
 create mode 100644 tests/xfs/900.out


diff --git a/tests/xfs/897 b/tests/xfs/897
new file mode 100755
index 0000000..e7da5c0
--- /dev/null
+++ b/tests/xfs/897
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 897
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set zero extsz hint on second file.
+# - Directio write to random offsets to scatter CoW reservations.
+# - falloc the whole file to unshare blocks.
+# - Check the number of extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_xfs_io_command "cowextsize"
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=128
+filesize=$((blksz * nr))
+bufnr=16
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+real_blksz=$(get_block_size $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $real_blksz" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/897.out b/tests/xfs/897.out
new file mode 100644
index 0000000..b418552
--- /dev/null
+++ b/tests/xfs/897.out
@@ -0,0 +1,10 @@
+QA output created by 897
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-897/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-897/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-897/file1
+Check extent counts
diff --git a/tests/xfs/898 b/tests/xfs/898
new file mode 100755
index 0000000..aa62ee2
--- /dev/null
+++ b/tests/xfs/898
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 898
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set zero extsz hint on second file.
+# - Buffered write to random offsets to scatter CoW reservations.
+# - Check the number of extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_xfs_io_command "cowextsize"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=128
+filesize=$((blksz * nr))
+bufnr=16
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+real_blksz=$(get_block_size $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $real_blksz" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/898.out b/tests/xfs/898.out
new file mode 100644
index 0000000..e50bb3b
--- /dev/null
+++ b/tests/xfs/898.out
@@ -0,0 +1,10 @@
+QA output created by 898
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-898/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-898/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-898/file1
+Check extent counts
diff --git a/tests/xfs/899 b/tests/xfs/899
new file mode 100755
index 0000000..0eea915
--- /dev/null
+++ b/tests/xfs/899
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 899
+#
+# Test fragmentation after writing and dropping CoW extent hint reservation:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Directio write to random offsets to scatter CoW reservations.
+# - Unmount, remount, repeat (twice more).
+# - Check the number of extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_xfs_io_command "cowextsize"
+_require_odirect
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=128
+filesize=$((blksz * nr))
+bufnr=8
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+real_blksz=$(get_block_size $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+seq 1 10 | while read i; do
+	$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
+	_scratch_cycle_mount
+done
+$XFS_IO_PROG -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/899.out b/tests/xfs/899.out
new file mode 100644
index 0000000..fd3d7fe
--- /dev/null
+++ b/tests/xfs/899.out
@@ -0,0 +1,10 @@
+QA output created by 899
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-899/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-899/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-899/file1
+Check extent counts
diff --git a/tests/xfs/900 b/tests/xfs/900
new file mode 100755
index 0000000..659ca23
--- /dev/null
+++ b/tests/xfs/900
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 900
+#
+# Test fragmentation after writing and dropping CoW extent hint reservation:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Buffered write to random offsets to scatter CoW reservations.
+# - Unmount, remount, repeat (twice more).
+# - Check the number of extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+_require_xfs_io_command "cowextsize"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=128
+filesize=$((blksz * nr))
+bufnr=8
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+real_blksz=$(get_block_size $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+seq 1 10 | while read i; do
+	$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
+	_scratch_cycle_mount
+done
+$XFS_IO_PROG -f -c "falloc -u 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/900.out b/tests/xfs/900.out
new file mode 100644
index 0000000..5ebf3e9
--- /dev/null
+++ b/tests/xfs/900.out
@@ -0,0 +1,10 @@
+QA output created by 900
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-900/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-900/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-900/file1
+Check extent counts
diff --git a/tests/xfs/group b/tests/xfs/group
index 3dbf3d2..b6bf5bf 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -328,3 +328,7 @@
 886 auto quick rmap
 887 auto quick rmap
 888 auto quick rmap
+897 auto quick clone
+898 auto quick clone
+899 auto quick clone
+900 auto quick clone

