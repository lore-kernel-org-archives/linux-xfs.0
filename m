Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B479F7F78
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:38:01 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17F3BAC008
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:57 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id FR3YIzZVlShGgney (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:53 -0800 (PST)
Subject: [PATCH 07/12] reflink: test accuracy of free block counts
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:29 -0800
Message-ID: <20151113213729.31124.57712.stgit@birch.djwong.org>
In-Reply-To: <20151113213643.31124.80975.stgit@birch.djwong.org>
References: <20151113213643.31124.80975.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Check that the free block counts seem to be handled correctly in
the reflink operation and subsequent attempts to rewrite reflinked
copies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/150     |   78 +++++++++++++++++++++++++++++++
 tests/generic/150.out |    4 ++
 tests/generic/151     |   98 +++++++++++++++++++++++++++++++++++++++
 tests/generic/151.out |    8 +++
 tests/generic/152     |  103 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/152.out |    8 +++
 tests/generic/153     |  102 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/153.out |    8 +++
 tests/generic/154     |  110 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/154.out |   11 ++++
 tests/generic/155     |  114 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/155.out |   11 ++++
 tests/generic/156     |  124 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/156.out |   12 +++++
 tests/generic/group   |    7 +++
 15 files changed, 798 insertions(+)
 create mode 100755 tests/generic/150
 create mode 100644 tests/generic/150.out
 create mode 100755 tests/generic/151
 create mode 100644 tests/generic/151.out
 create mode 100755 tests/generic/152
 create mode 100644 tests/generic/152.out
 create mode 100755 tests/generic/153
 create mode 100644 tests/generic/153.out
 create mode 100755 tests/generic/154
 create mode 100644 tests/generic/154.out
 create mode 100755 tests/generic/155
 create mode 100644 tests/generic/155.out
 create mode 100755 tests/generic/156
 create mode 100644 tests/generic/156.out


diff --git a/tests/generic/150 b/tests/generic/150
new file mode 100755
index 0000000..3046e92
--- /dev/null
+++ b/tests/generic/150
@@ -0,0 +1,78 @@
+#! /bin/bash
+# FS QA Test No. 150
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
diff --git a/tests/generic/150.out b/tests/generic/150.out
new file mode 100644
index 0000000..94580a6
--- /dev/null
+++ b/tests/generic/150.out
@@ -0,0 +1,4 @@
+QA output created by 150
+Create the original file blocks
+Create the reflink copies
+free blocks after reflink is in range
diff --git a/tests/generic/151 b/tests/generic/151
new file mode 100755
index 0000000..c42ca1d
--- /dev/null
+++ b/tests/generic/151
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 151
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
diff --git a/tests/generic/151.out b/tests/generic/151.out
new file mode 100644
index 0000000..214be54
--- /dev/null
+++ b/tests/generic/151.out
@@ -0,0 +1,8 @@
+QA output created by 151
+Create the original file blocks
+Create the reflink copies
+Delete most of the files
+Delete all the files
+free blocks after reflink is in range
+free blocks after deleting some reflink copies is in range
+free blocks after deleting all copies is in range
diff --git a/tests/generic/152 b/tests/generic/152
new file mode 100755
index 0000000..95ffe40
--- /dev/null
+++ b/tests/generic/152
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 152
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
diff --git a/tests/generic/152.out b/tests/generic/152.out
new file mode 100644
index 0000000..10b2003
--- /dev/null
+++ b/tests/generic/152.out
@@ -0,0 +1,8 @@
+QA output created by 152
+Create the original file blocks
+Create the reflink copies
+Punch most of the blocks
+Punch all the files
+free blocks after reflink is in range
+free blocks after punching some reflink copies is in range
+free blocks after punching all copies is in range
diff --git a/tests/generic/153 b/tests/generic/153
new file mode 100755
index 0000000..2deee20
--- /dev/null
+++ b/tests/generic/153
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 153
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
diff --git a/tests/generic/153.out b/tests/generic/153.out
new file mode 100644
index 0000000..c9ff37c
--- /dev/null
+++ b/tests/generic/153.out
@@ -0,0 +1,8 @@
+QA output created by 153
+Create the original file blocks
+Create the reflink copies
+Collapse most of the blocks
+Collpase nearly all the files
+free blocks after reflink is in range
+free blocks after fcollapsing some reflink copies is in range
+free blocks after fcollapsing all copies is in range
diff --git a/tests/generic/154 b/tests/generic/154
new file mode 100755
index 0000000..173b981
--- /dev/null
+++ b/tests/generic/154
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 154
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
diff --git a/tests/generic/154.out b/tests/generic/154.out
new file mode 100644
index 0000000..726b819
--- /dev/null
+++ b/tests/generic/154.out
@@ -0,0 +1,11 @@
+QA output created by 154
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
diff --git a/tests/generic/155 b/tests/generic/155
new file mode 100755
index 0000000..2551295
--- /dev/null
+++ b/tests/generic/155
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 155
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
diff --git a/tests/generic/155.out b/tests/generic/155.out
new file mode 100644
index 0000000..efb8faf
--- /dev/null
+++ b/tests/generic/155.out
@@ -0,0 +1,11 @@
+QA output created by 155
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
diff --git a/tests/generic/156 b/tests/generic/156
new file mode 100755
index 0000000..78b7e8c
--- /dev/null
+++ b/tests/generic/156
@@ -0,0 +1,124 @@
+#! /bin/bash
+# FS QA Test No. 156
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
+
+echo "funshare part of a file"
+"$XFS_IO_PROG" -f -c "falloc 0 $((SZ / 2))" "$TESTDIR/file2"
+_test_remount
+
+echo "funshare some of the copies"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file2"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file3"
+_test_remount
+FREE_BLOCKS2=$(stat -f "$TESTDIR" -c '%f')
+
+echo "funshare the rest of the files"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file4"
+"$XFS_IO_PROG" -f -c "falloc 0 $SZ" "$TESTDIR/file1"
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
diff --git a/tests/generic/156.out b/tests/generic/156.out
new file mode 100644
index 0000000..d6fdc81
--- /dev/null
+++ b/tests/generic/156.out
@@ -0,0 +1,12 @@
+QA output created by 156
+Create the original file blocks
+Create the reflink copies
+funshare part of a file
+funshare some of the copies
+funshare the rest of the files
+Rewrite the original file
+free blocks after reflinking is in range
+free blocks after nocow'ing some copies is in range
+free blocks after nocow'ing all copies is in range
+free blocks after overwriting original is in range
+free blocks after all tests is in range
diff --git a/tests/generic/group b/tests/generic/group
index 477c52b..3141ae5 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -152,6 +152,13 @@
 147 auto quick clone
 148 auto quick clone
 149 auto quick clone
+150 auto quick clone
+151 auto quick clone
+152 auto quick clone
+153 auto quick clone
+154 auto quick clone
+155 auto quick clone
+156 auto quick clone
 169 rw metadata auto quick
 184 metadata auto quick
 192 atime auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
