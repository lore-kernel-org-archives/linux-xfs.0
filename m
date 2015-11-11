Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6CFBA29E3D
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:27:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4EAD1304043
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:47 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IlD1RL9XGYHdOs92 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:43 -0800 (PST)
Subject: [PATCH 07/11] reflink: test accuracy of free block counts
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:27:17 -0800
Message-ID: <20151111192717.15056.86798.stgit@birch.djwong.org>
In-Reply-To: <20151111192628.15056.6451.stgit@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Check that the free block counts seem to be handled correctly in
the reflink operation and subsequent attempts to rewrite reflinked
copies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/830     |   78 ++++++++++++++++++++++++++++++
 tests/generic/830.out |    4 ++
 tests/generic/831     |   98 +++++++++++++++++++++++++++++++++++++
 tests/generic/831.out |    8 +++
 tests/generic/832     |  103 +++++++++++++++++++++++++++++++++++++++
 tests/generic/832.out |    8 +++
 tests/generic/833     |  102 +++++++++++++++++++++++++++++++++++++++
 tests/generic/833.out |    8 +++
 tests/generic/834     |  110 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/834.out |   11 ++++
 tests/generic/835     |  114 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/835.out |   11 ++++
 tests/generic/836     |  129 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/836.out |   32 ++++++++++++
 tests/generic/group   |    7 +++
 15 files changed, 823 insertions(+)
 create mode 100755 tests/generic/830
 create mode 100644 tests/generic/830.out
 create mode 100755 tests/generic/831
 create mode 100644 tests/generic/831.out
 create mode 100755 tests/generic/832
 create mode 100644 tests/generic/832.out
 create mode 100755 tests/generic/833
 create mode 100644 tests/generic/833.out
 create mode 100755 tests/generic/834
 create mode 100644 tests/generic/834.out
 create mode 100755 tests/generic/835
 create mode 100644 tests/generic/835.out
 create mode 100755 tests/generic/836
 create mode 100644 tests/generic/836.out


diff --git a/tests/generic/830 b/tests/generic/830
new file mode 100755
index 0000000..d85bacf
--- /dev/null
+++ b/tests/generic/830
@@ -0,0 +1,78 @@
+#! /bin/bash
+# FS QA Test No. 830
+#
+# Ensure that reflinking a file N times doesn't eat a lot of blocks
+#   - Create a file and record fs block usage
+#   - Create some reflink copies
+#   - Compare fs block usage to before
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=2000
+MARGIN=100
+SZ=$((BLKSZ * BLKS))
+NR=7
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+sync
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file.$i"
+done
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+
+_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $FREE_BLOCKS0 $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/830.out b/tests/generic/830.out
new file mode 100644
index 0000000..76e2f1d
--- /dev/null
+++ b/tests/generic/830.out
@@ -0,0 +1,4 @@
+QA output created by 830
+Create the original file blocks
+Create the reflink copies
+free blocks after reflink is in range
diff --git a/tests/generic/831 b/tests/generic/831
new file mode 100755
index 0000000..d729769
--- /dev/null
+++ b/tests/generic/831
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 831
+#
+# Ensure that deleting all copies of a file reflinked N times releases the blocks
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - Delete some copies of the file
+#   - Record fs block usage (2)
+#   - Delete all copies of the file
+#   - Compare fs block usage to (2), (1), and (0)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+BLKS=2000
+MARGIN=100
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+NR=7
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file.$i"
+done
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/survivor"
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Delete most of the files"
+rm -rf "$TESTDIR"/file*
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Delete all the files"
+rm -rf "$TESTDIR"/*
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+
+_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after deleting some reflink copies" $FREE_BLOCKS2 $FREE_BLOCKS1 $MARGIN -v
+
+_within_tolerance "free blocks after deleting all copies" $FREE_BLOCKS3 $FREE_BLOCKS0 $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/831.out b/tests/generic/831.out
new file mode 100644
index 0000000..88e0a23
--- /dev/null
+++ b/tests/generic/831.out
@@ -0,0 +1,8 @@
+QA output created by 831
+Create the original file blocks
+Create the reflink copies
+Delete most of the files
+Delete all the files
+free blocks after reflink is in range
+free blocks after deleting some reflink copies is in range
+free blocks after deleting all copies is in range
diff --git a/tests/generic/832 b/tests/generic/832
new file mode 100755
index 0000000..4f12b77
--- /dev/null
+++ b/tests/generic/832
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 832
+#
+# Ensure that punching all copies of a file reflinked N times releases the blocks
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - Punch some blocks of the copies
+#   - Record fs block usage (2)
+#   - Punch all blocks of the copies
+#   - Compare fs block usage to (2), (1), and (0)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "fpunch"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+BLKS=2000
+MARGIN=100
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Punch most of the blocks"
+"$XFS_IO_PROG" -f -c "fpunch 0 $SZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "fpunch 0 $((SZ / 2))" "$TESTDIR/file3"
+"$XFS_IO_PROG" -f -c "fpunch $((SZ / 2)) $((SZ / 2))" "$TESTDIR/file4"
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Punch all the files"
+for i in `seq 2 $NR`; do
+	"$XFS_IO_PROG" -f -c "fpunch 0 $SZ" "$TESTDIR/file$i"
+done
+"$XFS_IO_PROG" -f -c "fpunch 0 $SZ" "$TESTDIR/file1"
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+
+_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after punching some reflink copies" $FREE_BLOCKS2 $FREE_BLOCKS1 $MARGIN -v
+
+_within_tolerance "free blocks after punching all copies" $FREE_BLOCKS3 $FREE_BLOCKS0 $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/832.out b/tests/generic/832.out
new file mode 100644
index 0000000..bb95578
--- /dev/null
+++ b/tests/generic/832.out
@@ -0,0 +1,8 @@
+QA output created by 832
+Create the original file blocks
+Create the reflink copies
+Punch most of the blocks
+Punch all the files
+free blocks after reflink is in range
+free blocks after punching some reflink copies is in range
+free blocks after punching all copies is in range
diff --git a/tests/generic/833 b/tests/generic/833
new file mode 100755
index 0000000..07dfabf
--- /dev/null
+++ b/tests/generic/833
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 833
+#
+# Ensure that collapse-range on all copies of a file reflinked N times releases the blocks
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - Collapse-range some blocks of the copies
+#   - Record fs block usage (2)
+#   - Truncate all blocks of the copies
+#   - Compare fs block usage to (2), (1), and (0)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "fcollapse"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+BLKS=2000
+MARGIN=100
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Collapse most of the blocks"
+"$XFS_IO_PROG" -f -c "fcollapse 0 $(((BLKS - 1) * BLKSZ))" $TESTDIR/file2
+"$XFS_IO_PROG" -f -c "fcollapse 0 $((SZ / 2))" $TESTDIR/file3
+"$XFS_IO_PROG" -f -c "fcollapse $((SZ / 2)) $(( ((BLKS / 2) - 1) * BLKSZ))" $TESTDIR/file4
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Collpase nearly all the files"
+"$XFS_IO_PROG" -f -c "fcollapse 0 $(( ((BLKS / 2) - 1) * BLKSZ))" $TESTDIR/file3
+"$XFS_IO_PROG" -f -c "fcollapse 0 $((SZ / 2))" $TESTDIR/file4
+"$XFS_IO_PROG" -f -c "fcollapse 0 $(( (BLKS - 1) * BLKSZ))" $TESTDIR/file1
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+
+_within_tolerance "free blocks after reflink" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after fcollapsing some reflink copies" $FREE_BLOCKS2 $FREE_BLOCKS1 $MARGIN -v
+
+_within_tolerance "free blocks after fcollapsing all copies" $FREE_BLOCKS3 $FREE_BLOCKS0 $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/833.out b/tests/generic/833.out
new file mode 100644
index 0000000..a9a2941
--- /dev/null
+++ b/tests/generic/833.out
@@ -0,0 +1,8 @@
+QA output created by 833
+Create the original file blocks
+Create the reflink copies
+Collapse most of the blocks
+Collpase nearly all the files
+free blocks after reflink is in range
+free blocks after fcollapsing some reflink copies is in range
+free blocks after fcollapsing all copies is in range
diff --git a/tests/generic/834 b/tests/generic/834
new file mode 100755
index 0000000..d24dfa5
--- /dev/null
+++ b/tests/generic/834
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 834
+#
+# Ensure that CoW on all copies of a file reflinked N times increases block count
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - CoW some blocks of the copies
+#   - Record fs block usage (2)
+#   - CoW all the rest of the blocks of the copies
+#   - Compare fs block usage to (2), (1), and (0)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+BLKS=2000
+MARGIN=100
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+NR=4
+SZ=$((BLKS * BLKSZ))
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Rewrite some of the blocks"
+_pwrite_byte 0x62 0 $SZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $((SZ / 2)) "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x64 $((SZ / 2)) $((SZ / 2)) "$TESTDIR/file4" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Rewrite all the files"
+_pwrite_byte 0x62 0 $SZ "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $SZ "$TESTDIR/file3" >> "$seqres.full"
+_pwrite_byte 0x64 0 $SZ "$TESTDIR/file4" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Rewrite the original file"
+_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+
+_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after partially CoWing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+
+_within_tolerance "free blocks after CoWing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+
+_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/834.out b/tests/generic/834.out
new file mode 100644
index 0000000..e67e803
--- /dev/null
+++ b/tests/generic/834.out
@@ -0,0 +1,11 @@
+QA output created by 834
+Create the original file blocks
+Create the reflink copies
+Rewrite some of the blocks
+Rewrite all the files
+Rewrite the original file
+free blocks after reflinking is in range
+free blocks after partially CoWing some copies is in range
+free blocks after CoWing all copies is in range
+free blocks after overwriting original is in range
+free blocks after all tests is in range
diff --git a/tests/generic/835 b/tests/generic/835
new file mode 100755
index 0000000..881063b
--- /dev/null
+++ b/tests/generic/835
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 835
+#
+# Ensure that CoW on all copies of a file reflinked N times increases block count
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - CoW some blocks of the copies
+#   - Record fs block usage (2)
+#   - CoW all the rest of the blocks of the copies
+#   - Compare fs block usage to (2), (1), and (0)
+#
+# The main difference from 834 is that we use zero range, directio, and
+# mmap to mix things up a bit.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "fzero"
+
+rm -f "$seqres.full"
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+BLKS=2000
+MARGIN=100
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Rewrite some of the blocks"
+"$XFS_IO_PROG" -f -c "fzero 0 $SZ" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x63 0 $((SZ / 2)) "$TESTDIR/file3" -d >> "$seqres.full"
+_mwrite_byte 0x64 $((SZ / 2)) $((SZ / 2)) $SZ "$TESTDIR/file4" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Rewrite all the files"
+_pwrite_byte 0x62 0 $SZ "$TESTDIR/file2" -d >> "$seqres.full"
+_mwrite_byte 0x63 0 $SZ $SZ "$TESTDIR/file3" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "fzero 0 $SZ" $TESTDIR/file4 >> "$seqres.full"
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+
+echo "Rewrite the original file"
+_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+
+_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after partially CoWing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+
+_within_tolerance "free blocks after CoWing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+
+_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/835.out b/tests/generic/835.out
new file mode 100644
index 0000000..c1103be
--- /dev/null
+++ b/tests/generic/835.out
@@ -0,0 +1,11 @@
+QA output created by 835
+Create the original file blocks
+Create the reflink copies
+Rewrite some of the blocks
+Rewrite all the files
+Rewrite the original file
+free blocks after reflinking is in range
+free blocks after partially CoWing some copies is in range
+free blocks after CoWing all copies is in range
+free blocks after overwriting original is in range
+free blocks after all tests is in range
diff --git a/tests/generic/836 b/tests/generic/836
new file mode 100755
index 0000000..2e0639f
--- /dev/null
+++ b/tests/generic/836
@@ -0,0 +1,129 @@
+#! /bin/bash
+# FS QA Test No. 836
+#
+# Ensure that fallocate on reflinked files actually CoWs the shared blocks.
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - funshare half of one of the copies
+#   - Record fs block usage (2)
+#   - funshare all of the copies
+#   - Record fs block usage (3)
+#   - rewrite the original file
+#   - Record fs block usage (4)
+#   - Compare fs block usage of 0-4 to ensure that block usage behaves as
+#     we expect.
+#
+# "funshare" refers to fallocate copy-on-writing the shared blocks
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+if [ $FSTYP = "btrfs" ]; then
+	_notrun "btrfs doesn't handle unshare on fallocate"
+fi
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_cp_reflink
+_require_xfs_io_command "falloc"
+
+rm -f "$seqres.full"
+
+TESTDIR="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+BLKS=2000
+MARGIN=100
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f "$TESTDIR" -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	_cp_reflink "$TESTDIR/file1" "$TESTDIR/file$i"
+done
+_test_remount
+FREE_BLOCKS1=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "funshare part of a file"
+"$XFS_IO_PROG" -f -c "falloc 0 $((SZ / 2))" "$TESTDIR/file2"
+_test_remount
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "funshare some of the copies"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file3"
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "funshare the rest of the files"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file1"
+_test_remount
+FREE_BLOCKS3=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "Rewrite the original file"
+_pwrite_byte 0x65 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_test_remount
+FREE_BLOCKS4=$(stat -f "$TESTDIR" -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+
+_within_tolerance "free blocks after reflinking" $FREE_BLOCKS1 $((FREE_BLOCKS0 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after nocow'ing some copies" $FREE_BLOCKS2 $((FREE_BLOCKS1 - (2 * BLKS))) $MARGIN -v
+
+_within_tolerance "free blocks after nocow'ing all copies" $FREE_BLOCKS3 $((FREE_BLOCKS2 - BLKS)) $MARGIN -v
+
+_within_tolerance "free blocks after overwriting original" $FREE_BLOCKS4 $FREE_BLOCKS3 $MARGIN -v
+
+_within_tolerance "free blocks after all tests" $FREE_BLOCKS4 $((FREE_BLOCKS0 - (4 * BLKS))) $MARGIN -v
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/836.out b/tests/generic/836.out
new file mode 100644
index 0000000..45f7750
--- /dev/null
+++ b/tests/generic/836.out
@@ -0,0 +1,32 @@
+QA output created by 836
+Create the original file blocks
+Create the reflink copies
+TEST_DIR/test-836/file1          ---
+TEST_DIR/test-836/file2          ---
+TEST_DIR/test-836/file3          ---
+TEST_DIR/test-836/file4          ---
+funshare part of a file
+TEST_DIR/test-836/file1          ---
+TEST_DIR/test-836/file2          ---
+TEST_DIR/test-836/file3          ---
+TEST_DIR/test-836/file4          ---
+funshare some of the copies
+TEST_DIR/test-836/file1          ---
+TEST_DIR/test-836/file2          No_COW
+TEST_DIR/test-836/file3          No_COW
+TEST_DIR/test-836/file4          ---
+funshare the rest of the files
+TEST_DIR/test-836/file1          No_COW
+TEST_DIR/test-836/file2          No_COW
+TEST_DIR/test-836/file3          No_COW
+TEST_DIR/test-836/file4          No_COW
+Rewrite the original file
+TEST_DIR/test-836/file1          No_COW
+TEST_DIR/test-836/file2          No_COW
+TEST_DIR/test-836/file3          No_COW
+TEST_DIR/test-836/file4          No_COW
+free blocks after reflinking is in range
+free blocks after nocow'ing some copies is in range
+free blocks after nocow'ing all copies is in range
+free blocks after overwriting original is in range
+free blocks after all tests is in range
diff --git a/tests/generic/group b/tests/generic/group
index 0c137ea..9b57872 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -237,5 +237,12 @@
 827 auto quick clone
 828 auto quick clone
 829 auto quick clone
+830 auto quick clone
+831 auto quick clone
+832 auto quick clone
+833 auto quick clone
+834 auto quick clone
+835 auto quick clone
+836 auto quick clone
 837 auto quick clone
 838 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
