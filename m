Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36881 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdFUV6M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jun 2017 17:58:12 -0400
Subject: [PATCH 6/8] xfs: test that we can SEEK_HOLE/DATA data and holes
 that are in the CoW fork only
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 21 Jun 2017 14:57:57 -0700
Message-ID: <149808227783.8924.10804862952463567410.stgit@birch.djwong.org>
In-Reply-To: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
References: <149808222258.8924.1682057078986741098.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a file with a hole in the data fork and CoW reservations in the
same region in the CoW fork.  Ensure that SEEK_HOLE/DATA find the data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/901     |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/901.out |   52 +++++++++++++++++
 tests/xfs/902     |  160 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/902.out |   52 +++++++++++++++++
 tests/xfs/group   |    2 +
 5 files changed, 426 insertions(+)
 create mode 100755 tests/xfs/901
 create mode 100644 tests/xfs/901.out
 create mode 100755 tests/xfs/902
 create mode 100644 tests/xfs/902.out


diff --git a/tests/xfs/901 b/tests/xfs/901
new file mode 100755
index 0000000..7ac618e
--- /dev/null
+++ b/tests/xfs/901
@@ -0,0 +1,160 @@
+#! /bin/bash
+# FS QA Test No. 901
+#
+# Test SEEK_HOLE/SEEK_DATA into a region that is marked CoW'd for
+# speculative preallocation in the CoW fork and isn't backed by
+# data fork extents.
+#
+# - Set a huge cowextsize hint.
+# - Create a file "DD      " (two data blocks, six hole blocks)
+# - Reflink copy this file to a second file.
+# - Write to the first block of the second file to create a single
+#   large CoW reservation covering the whole file.
+# - Write to block 3, which should be a hole in the data fork.
+# - Display the SEEK_HOLE/SEEK_DATA info for the second file to confirm
+#   that we see the data in blocks 0-1, the hole at block 2, the data
+#   at block 3, and the hole for the rest of the file.
+#
+# Basically we want to create a file with the following data/CoW forks:
+#
+# data: DD------
+#  cow: dddddddd
+#       ^--^---------- these blocks are dirty
+#
+# And then check that SEEK_HOLE and SEEK_DATA actually find that second
+# dirty block even though we've never had a data fork extent mapping the
+# second dirty block.  We need the huge cowextsize so that the hole
+# area receives preallocation in the CoW fork.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+_require_xfs_io_command "cowextsize"
+_require_xfs_io_command "fpunch"
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
+nr=8
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+$XFS_IO_PROG -c "cowextsize" $testdir >> $seqres.full
+$XFS_IO_PROG -c "cowextsize $filesize" $testdir >> $seqres.full
+$XFS_IO_PROG -c "cowextsize" $testdir >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((blksz * 2))" -c "truncate $filesize" -c "fpunch $((blksz * 2)) $((blksz * (nr - 2) ))" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0 0 $filesize" -c "pwrite -S 0x61 0 $((blksz * 2))" $testdir/file3 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "CoW the shared part then write into the empty part" | tee -a $seqres.full
+$XFS_IO_PROG -c "cowextsize" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -S 0x63 0 $blksz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file2 >> $seqres.full
+
+$XFS_IO_PROG -c "pwrite -S 0x63 0 $blksz" $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file3 >> $seqres.full
+
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
+
+echo "Seek holes and data in file1"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
+echo "Seek holes and data in file2"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "sync filesystem" | tee -a $seqres.full
+sync
+
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
+
+echo "Seek holes and data in file1"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
+echo "Seek holes and data in file2"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "Remount" | tee -a $seqres.full
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
+
+echo "Seek holes and data in file1"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
+echo "Seek holes and data in file2"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/901.out b/tests/xfs/901.out
new file mode 100644
index 0000000..4a829e3
--- /dev/null
+++ b/tests/xfs/901.out
@@ -0,0 +1,52 @@
+QA output created by 901
+Format and mount
+Create the original files
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-901/file1
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-901/file2
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-901/file3
+CoW the shared part then write into the empty part
+Seek holes and data in file1
+Whence	Result
+DATA	0
+HOLE	131072
+Seek holes and data in file2
+Whence	Result
+DATA	0
+HOLE	131072
+DATA	196608
+HOLE	262144
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-901/file1
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-901/file2
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-901/file3
+sync filesystem
+Seek holes and data in file1
+Whence	Result
+DATA	0
+HOLE	131072
+Seek holes and data in file2
+Whence	Result
+DATA	0
+HOLE	131072
+DATA	196608
+HOLE	262144
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-901/file1
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-901/file2
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-901/file3
+Remount
+Seek holes and data in file1
+Whence	Result
+DATA	0
+HOLE	131072
+Seek holes and data in file2
+Whence	Result
+DATA	0
+HOLE	131072
+DATA	196608
+HOLE	262144
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-901/file1
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-901/file2
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-901/file3
diff --git a/tests/xfs/902 b/tests/xfs/902
new file mode 100755
index 0000000..c2933ab
--- /dev/null
+++ b/tests/xfs/902
@@ -0,0 +1,160 @@
+#! /bin/bash
+# FS QA Test No. 902
+#
+# Test SEEK_HOLE/SEEK_DATA into a region that is marked CoW'd for
+# speculative preallocation in the CoW fork and isn't backed by
+# data fork extents.
+#
+# - Set a huge cowextsize hint.
+# - Create a file "DD      " (two data blocks, six hole blocks)
+# - Reflink copy this file to a second file.
+# - dio write to the first block of the second file to create a single
+#   large CoW reservation covering the whole file.
+# - dio write to block 3, which should be a hole in the data fork.
+# - Display the SEEK_HOLE/SEEK_DATA info for the second file to confirm
+#   that we see the data in blocks 0-1, the hole at block 2, the data
+#   at block 3, and the hole for the rest of the file.
+#
+# Basically we want to create a file with the following data/CoW forks:
+#
+# data: DD------
+#  cow: dddddddd
+#       ^--^---------- these blocks are dirty
+#
+# And then check that SEEK_HOLE and SEEK_DATA actually find that second
+# dirty block even though we've never had a data fork extent mapping the
+# second dirty block.  We need the huge cowextsize so that the hole
+# area receives preallocation in the CoW fork.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+_require_xfs_io_command "cowextsize"
+_require_xfs_io_command "fpunch"
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
+nr=8
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+$XFS_IO_PROG -c "cowextsize" $testdir >> $seqres.full
+$XFS_IO_PROG -c "cowextsize $filesize" $testdir >> $seqres.full
+$XFS_IO_PROG -c "cowextsize" $testdir >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((blksz * 2))" -c "truncate $filesize" -c "fpunch $((blksz * 2)) $((blksz * (nr - 2) ))" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0 0 $filesize" -c "pwrite -S 0x61 0 $((blksz * 2))" $testdir/file3 >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "CoW the shared part then write into the empty part" | tee -a $seqres.full
+$XFS_IO_PROG -c "cowextsize" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -c "pwrite -S 0x63 0 $blksz" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file2 >> $seqres.full
+
+$XFS_IO_PROG -d -c "pwrite -S 0x63 0 $blksz" $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -d -c "pwrite -S 0x63 $((blksz * 3)) $blksz" $testdir/file3 >> $seqres.full
+
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
+
+echo "Seek holes and data in file1"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
+echo "Seek holes and data in file2"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "sync filesystem" | tee -a $seqres.full
+sync
+
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
+
+echo "Seek holes and data in file1"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
+echo "Seek holes and data in file2"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "Remount" | tee -a $seqres.full
+_scratch_cycle_mount
+
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file1 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file2 >> $seqres.full 2>&1
+$XFS_IO_PROG -c "bmap -ev" -c "bmap -cv" $testdir/file3 >> $seqres.full 2>&1
+
+echo "Seek holes and data in file1"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file1
+echo "Seek holes and data in file2"
+$XFS_IO_PROG -c "seek -a -r 0" $testdir/file2
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/902.out b/tests/xfs/902.out
new file mode 100644
index 0000000..d5b8eae
--- /dev/null
+++ b/tests/xfs/902.out
@@ -0,0 +1,52 @@
+QA output created by 902
+Format and mount
+Create the original files
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-902/file1
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-902/file2
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-902/file3
+CoW the shared part then write into the empty part
+Seek holes and data in file1
+Whence	Result
+DATA	0
+HOLE	131072
+Seek holes and data in file2
+Whence	Result
+DATA	0
+HOLE	131072
+DATA	196608
+HOLE	262144
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-902/file1
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-902/file2
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-902/file3
+sync filesystem
+Seek holes and data in file1
+Whence	Result
+DATA	0
+HOLE	131072
+Seek holes and data in file2
+Whence	Result
+DATA	0
+HOLE	131072
+DATA	196608
+HOLE	262144
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-902/file1
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-902/file2
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-902/file3
+Remount
+Seek holes and data in file1
+Whence	Result
+DATA	0
+HOLE	131072
+Seek holes and data in file2
+Whence	Result
+DATA	0
+HOLE	131072
+DATA	196608
+HOLE	262144
+Compare files
+c2803804acc9936eef8aab42c119bfac  SCRATCH_MNT/test-902/file1
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-902/file2
+017c08a9320aad844ce86aa9631afb98  SCRATCH_MNT/test-902/file3
diff --git a/tests/xfs/group b/tests/xfs/group
index 5f37c5a..faf0095 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -417,3 +417,5 @@
 417 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 418 dangerous_fuzzers dangerous_scrub dangerous_repair
 701 auto quick
+901 auto quick clone dedupe
+902 auto quick clone dedupe

