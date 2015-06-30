Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EEBCC7F51
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:16:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4CB6CAC004
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:16:24 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 1Rw1oOWJIMiuWzuB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:16:20 -0700 (PDT)
Subject: [PATCH 08/11] test reflink for accuracy in free block counts
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:16:15 -0700
Message-ID: <20150630041615.2476.10269.stgit@birch.djwong.org>
In-Reply-To: <20150630041519.2476.23059.stgit@birch.djwong.org>
References: <20150630041519.2476.23059.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Check that the free block counts seem to be handled correctly in
the reflink operation and subsequent attempts to rewrite reflinked
copies.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/830     |   88 +++++++++++++++++++++++++
 tests/generic/830.out |    5 +
 tests/generic/831     |  120 ++++++++++++++++++++++++++++++++++
 tests/generic/831.out |   11 +++
 tests/generic/832     |  143 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/832.out |   11 +++
 tests/generic/833     |  142 ++++++++++++++++++++++++++++++++++++++++
 tests/generic/833.out |   11 +++
 tests/generic/834     |  160 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/834.out |   16 +++++
 tests/generic/835     |  164 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/835.out |   16 +++++
 tests/generic/836     |  172 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/836.out |   36 ++++++++++
 tests/generic/group   |    7 ++
 15 files changed, 1102 insertions(+)
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
index 0000000..4862603
--- /dev/null
+++ b/tests/generic/830
@@ -0,0 +1,88 @@
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
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+NR=7
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+
+echo "Compare free block count"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS1))
+if [ $DIFF -gt $MARGIN ]; then
+	echo "Free blocks decreased by more than $((-DIFF))."
+elif [ $DIFF -lt 0 ]; then
+	echo "Free blocks increased by $((-DIFF))?"
+else
+	echo "Looks ok"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/830.out b/tests/generic/830.out
new file mode 100644
index 0000000..e2802dd
--- /dev/null
+++ b/tests/generic/830.out
@@ -0,0 +1,5 @@
+QA output created by 830
+Create the original file blocks
+Create the reflink copies
+Compare free block count
+Looks ok
diff --git a/tests/generic/831 b/tests/generic/831
new file mode 100755
index 0000000..4947261
--- /dev/null
+++ b/tests/generic/831
@@ -0,0 +1,120 @@
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
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+NR=7
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+cp --reflink=always $TESTDIR/file1 $TESTDIR/survivor
+sync
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+
+echo "Delete most of the files"
+rm -rf $TESTDIR/file*
+sync
+FREE_BLOCKS2=$(stat -f $TESTDIR -c '%f')
+
+echo "Delete all the files"
+rm -rf $TESTDIR/*
+sync
+FREE_BLOCKS3=$(stat -f $TESTDIR -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+
+echo "Did we eat a ton of blocks?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS1))
+if [ $DIFF -lt $BLKS ]; then
+	echo "Reflinking only ate $DIFF blocks, expected $BLKS"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we not get anything back when we didn't delete everything?"
+DIFF=$((FREE_BLOCKS1 - FREE_BLOCKS2))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we get all the blocks back when we deleted everything?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS3))
+if [ $DIFF -gt $MARGIN ]; then
+	echo "Free blocks decreased by more than $((-DIFF))."
+elif [ $DIFF -lt 0 ]; then
+	echo "Free blocks increased by $((-DIFF))?"
+else
+	echo "Looks ok"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/831.out b/tests/generic/831.out
new file mode 100644
index 0000000..6f48729
--- /dev/null
+++ b/tests/generic/831.out
@@ -0,0 +1,11 @@
+QA output created by 831
+Create the original file blocks
+Create the reflink copies
+Delete most of the files
+Delete all the files
+Did we eat a ton of blocks?
+Looks ok
+Did we not get anything back when we didn't delete everything?
+Looks ok
+Did we get all the blocks back when we deleted everything?
+Looks ok
diff --git a/tests/generic/832 b/tests/generic/832
new file mode 100755
index 0000000..df116c6
--- /dev/null
+++ b/tests/generic/832
@@ -0,0 +1,143 @@
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
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+NR=4
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       || echo "Sections should match"
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+
+echo "Punch most of the blocks"
+$XFS_IO_PROG -f -c "fpunch 0 $((BLKS * BLKSZ))" $TESTDIR/file.2
+$XFS_IO_PROG -f -c "fpunch 0 $((BLKS / 2 * BLKSZ))" $TESTDIR/file.3
+$XFS_IO_PROG -f -c "fpunch $((BLKS / 2 * BLKSZ)) $((BLKS / 2 * BLKSZ))" $TESTDIR/file.4
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       && echo "Sections should not match"
+FREE_BLOCKS2=$(stat -f $TESTDIR -c '%f')
+
+echo "Punch all the files"
+for i in `seq 2 $NR`; do
+	$XFS_IO_PROG -f -c "fpunch 0 $((BLKS * BLKSZ))" $TESTDIR/file.$i
+done
+$XFS_IO_PROG -f -c "fpunch 0 $((BLKS * BLKSZ))" $TESTDIR/file1
+sync
+FREE_BLOCKS3=$(stat -f $TESTDIR -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+
+echo "Did we eat a ton of blocks?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS1))
+if [ $DIFF -lt $BLKS ]; then
+	echo "Reflinking only ate $DIFF blocks, expected $BLKS"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we not get anything back when we didn't punch everything?"
+DIFF=$((FREE_BLOCKS1 - FREE_BLOCKS2))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we get all the blocks back when we punch everything?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS3))
+if [ $DIFF -gt $MARGIN ]; then
+	echo "Free blocks decreased by more than $((-DIFF))."
+elif [ $DIFF -lt 0 ]; then
+	echo "Free blocks increased by $((-DIFF))?"
+else
+	echo "Looks ok"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/832.out b/tests/generic/832.out
new file mode 100644
index 0000000..d0c1d82
--- /dev/null
+++ b/tests/generic/832.out
@@ -0,0 +1,11 @@
+QA output created by 832
+Create the original file blocks
+Create the reflink copies
+Punch most of the blocks
+Punch all the files
+Did we eat a ton of blocks?
+Looks ok
+Did we not get anything back when we didn't punch everything?
+Looks ok
+Did we get all the blocks back when we punch everything?
+Looks ok
diff --git a/tests/generic/833 b/tests/generic/833
new file mode 100755
index 0000000..e37bf41
--- /dev/null
+++ b/tests/generic/833
@@ -0,0 +1,142 @@
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
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fcollapse"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+NR=4
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       || echo "Sections should match"
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+
+echo "Collapse most of the blocks"
+$XFS_IO_PROG -f -c "fcollapse 0 $(((BLKS - 1) * BLKSZ))" $TESTDIR/file.2
+$XFS_IO_PROG -f -c "fcollapse 0 $((BLKS / 2 * BLKSZ))" $TESTDIR/file.3
+$XFS_IO_PROG -f -c "fcollapse $((BLKS / 2 * BLKSZ)) $(( ((BLKS / 2) - 1) * BLKSZ))" $TESTDIR/file.4
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       && echo "Sections should not match"
+FREE_BLOCKS2=$(stat -f $TESTDIR -c '%f')
+
+echo "Collpase range nearly all the files"
+$XFS_IO_PROG -f -c "fcollapse 0 $(( ((BLKS / 2) - 1) * BLKSZ))" $TESTDIR/file.3
+$XFS_IO_PROG -f -c "fcollapse 0 $(( (BLKS / 2) * BLKSZ))" $TESTDIR/file.4
+$XFS_IO_PROG -f -c "fcollapse 0 $(( (BLKS - 1) * BLKSZ))" $TESTDIR/file1
+sync
+FREE_BLOCKS3=$(stat -f $TESTDIR -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3
+
+echo "Did we eat a ton of blocks?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS1))
+if [ $DIFF -lt $BLKS ]; then
+	echo "Reflinking only ate $DIFF blocks, expected $BLKS"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we not get anything back when we didn't collapse everything?"
+DIFF=$((FREE_BLOCKS1 - FREE_BLOCKS2))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we get all the blocks back when we collapse everything?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS3))
+if [ $DIFF -gt $MARGIN ]; then
+	echo "Free blocks decreased by more than $((-DIFF))."
+elif [ $DIFF -lt 0 ]; then
+	echo "Free blocks increased by $((-DIFF))?"
+else
+	echo "Looks ok"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/833.out b/tests/generic/833.out
new file mode 100644
index 0000000..5c72303
--- /dev/null
+++ b/tests/generic/833.out
@@ -0,0 +1,11 @@
+QA output created by 833
+Create the original file blocks
+Create the reflink copies
+Collapse most of the blocks
+Collpase range nearly all the files
+Did we eat a ton of blocks?
+Looks ok
+Did we not get anything back when we didn't collapse everything?
+Looks ok
+Did we get all the blocks back when we collapse everything?
+Looks ok
diff --git a/tests/generic/834 b/tests/generic/834
new file mode 100755
index 0000000..8e8fafd
--- /dev/null
+++ b/tests/generic/834
@@ -0,0 +1,160 @@
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
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+NR=4
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       || echo "Sections should match"
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+
+echo "Rewrite some of the blocks"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKS * BLKSZ))" $TESTDIR/file.2 > /dev/null
+$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((BLKS / 2 * BLKSZ))" $TESTDIR/file.3 > /dev/null
+$XFS_IO_PROG -f -c "pwrite -S 0x64 $((BLKS / 2 * BLKSZ)) $((BLKS / 2 * BLKSZ))" $TESTDIR/file.4 > /dev/null
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       && echo "Sections should not match"
+FREE_BLOCKS2=$(stat -f $TESTDIR -c '%f')
+
+echo "Rewrite all the files"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKS * BLKSZ))" $TESTDIR/file.2 > /dev/null
+$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((BLKS * BLKSZ))" $TESTDIR/file.3 > /dev/null
+$XFS_IO_PROG -f -c "pwrite -S 0x64 0 $((BLKS * BLKSZ))" $TESTDIR/file.4 > /dev/null
+sync
+FREE_BLOCKS3=$(stat -f $TESTDIR -c '%f')
+
+echo "Rewrite the original file"
+$XFS_IO_PROG -f -c "pwrite -S 0x65 0 $((BLKS * BLKSZ))" $TESTDIR/file1 > /dev/null
+sync
+FREE_BLOCKS4=$(stat -f $TESTDIR -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+
+echo "Did we eat a ton of blocks?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS1))
+if [ $DIFF -lt $BLKS ]; then
+	echo "Reflinking only ate $DIFF blocks, expected $BLKS"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we eat the same number of blocks we partially CoWd?"
+DIFF=$((FREE_BLOCKS1 - FREE_BLOCKS2 - (BLKS * 2) ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we eat the same number of blocks when we overwrote all the copies?"
+DIFF=$((FREE_BLOCKS2 - FREE_BLOCKS3 - BLKS ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did overwriting the original file consume no blocks?"
+DIFF=$((FREE_BLOCKS3 - FREE_BLOCKS4))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we use as many blocks overall as we figured on?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS4 - (4 * BLKS) ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/834.out b/tests/generic/834.out
new file mode 100644
index 0000000..1758c71
--- /dev/null
+++ b/tests/generic/834.out
@@ -0,0 +1,16 @@
+QA output created by 834
+Create the original file blocks
+Create the reflink copies
+Rewrite some of the blocks
+Rewrite all the files
+Rewrite the original file
+Did we eat a ton of blocks?
+Looks ok
+Did we eat the same number of blocks we partially CoWd?
+Looks ok
+Did we eat the same number of blocks when we overwrote all the copies?
+Looks ok
+Did overwriting the original file consume no blocks?
+Looks ok
+Did we use as many blocks overall as we figured on?
+Looks ok
diff --git a/tests/generic/835 b/tests/generic/835
new file mode 100755
index 0000000..ce07c7d
--- /dev/null
+++ b/tests/generic/835
@@ -0,0 +1,164 @@
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
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fzero"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+NR=4
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       || echo "Sections should match"
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+
+echo "Rewrite some of the blocks"
+$XFS_IO_PROG -f -c "fzero 0 $((BLKS * BLKSZ))" $TESTDIR/file.2 > /dev/null
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 0 $((BLKS / 2 * BLKSZ))" $TESTDIR/file.3 > /dev/null
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKS * BLKSZ))" -c "mwrite -S 0x64 $((BLKS / 2 * BLKSZ)) $((BLKS / 2 * BLKSZ))" $TESTDIR/file.4 > /dev/null
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       && echo "Sections should not match"
+FREE_BLOCKS2=$(stat -f $TESTDIR -c '%f')
+
+echo "Rewrite all the files"
+$XFS_IO_PROG -d -f -c "pwrite -S 0x62 0 $((BLKS * BLKSZ))" $TESTDIR/file.2 > /dev/null
+$XFS_IO_PROG -f -c "mmap -rw 0 $((BLKS * BLKSZ))" -c "mwrite -S 0x63 0 $((BLKS * BLKSZ))" $TESTDIR/file.3 > /dev/null
+$XFS_IO_PROG -f -c "fzero 0 $((BLKS * BLKSZ))" $TESTDIR/file.4 > /dev/null
+sync
+FREE_BLOCKS3=$(stat -f $TESTDIR -c '%f')
+
+echo "Rewrite the original file"
+$XFS_IO_PROG -f -c "pwrite -S 0x65 0 $((BLKS * BLKSZ))" $TESTDIR/file1 > /dev/null
+sync
+FREE_BLOCKS4=$(stat -f $TESTDIR -c '%f')
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+
+echo "Did we eat a ton of blocks?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS1))
+if [ $DIFF -lt $BLKS ]; then
+	echo "Reflinking only ate $DIFF blocks, expected $BLKS"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we eat the same number of blocks we partially CoWd?"
+DIFF=$((FREE_BLOCKS1 - FREE_BLOCKS2 - (BLKS * 2) ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we eat the same number of blocks when we overwrote all the copies?"
+DIFF=$((FREE_BLOCKS2 - FREE_BLOCKS3 - BLKS ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did overwriting the original file consume no blocks?"
+DIFF=$((FREE_BLOCKS3 - FREE_BLOCKS4))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we use as many blocks overall as we figured on?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS4 - (4 * BLKS) ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/835.out b/tests/generic/835.out
new file mode 100644
index 0000000..d280e67
--- /dev/null
+++ b/tests/generic/835.out
@@ -0,0 +1,16 @@
+QA output created by 835
+Create the original file blocks
+Create the reflink copies
+Rewrite some of the blocks
+Rewrite all the files
+Rewrite the original file
+Did we eat a ton of blocks?
+Looks ok
+Did we eat the same number of blocks we partially CoWd?
+Looks ok
+Did we eat the same number of blocks when we overwrote all the copies?
+Looks ok
+Did overwriting the original file consume no blocks?
+Looks ok
+Did we use as many blocks overall as we figured on?
+Looks ok
diff --git a/tests/generic/836 b/tests/generic/836
new file mode 100755
index 0000000..2c27f37
--- /dev/null
+++ b/tests/generic/836
@@ -0,0 +1,172 @@
+#! /bin/bash
+# FS QA Test No. 836
+#
+# Ensure that chattr +C on reflinked files actually CoWs the files and
+# removes the inode flag.
+#   - Record fs block usage (0)
+#   - Create a file and some reflink copies
+#   - Record fs block usage (1)
+#   - chattr +C the copies
+#   - Compare fs block usage to (2), (1), and (0)
+#   - Compare the extent lists of the copies
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
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+if [ $FSTYP = "btrfs" ]; then
+	_notrun "btrfs doesn't handle chattr +C on non-empty files"
+fi
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+_require_test
+_require_attrs
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR -c '%f')
+NR=4
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR/file1 >> $seqres.full
+sync
+
+echo "Create the reflink copies"
+for i in `seq 2 $NR`; do
+	cp --reflink=always $TESTDIR/file1 $TESTDIR/file.$i
+done
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       || echo "Sections should match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       || echo "Sections should match"
+FREE_BLOCKS1=$(stat -f $TESTDIR -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "chattr +C some of the copies"
+chattr +C $TESTDIR/file.2
+chattr +C $TESTDIR/file.3
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.2 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.3 | tail -n +2) \
+       && echo "Sections should not match"
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       || echo "Sections should match"
+FREE_BLOCKS2=$(stat -f $TESTDIR -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "chattr +C the rest of the files"
+chattr +C $TESTDIR/file.4
+chattr +C $TESTDIR/file1
+sync
+cmp -s <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file1 | tail -n +2) \
+       <($XFS_IO_PROG -f -c "fiemap -v" $TESTDIR/file.4 | tail -n +2) \
+       && echo "Sections should not match"
+FREE_BLOCKS3=$(stat -f $TESTDIR -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+echo "Rewrite the original file"
+$XFS_IO_PROG -f -c "pwrite -S 0x65 0 $((BLKS * BLKSZ))" $TESTDIR/file1 > /dev/null
+sync
+FREE_BLOCKS4=$(stat -f $TESTDIR -c '%f')
+lsattr -l $TESTDIR/ | _filter_test_dir
+#echo $FREE_BLOCKS0 $FREE_BLOCKS1 $FREE_BLOCKS2 $FREE_BLOCKS3 $FREE_BLOCKS4
+
+echo "Did we eat a ton of blocks?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS1))
+if [ $DIFF -lt $BLKS ]; then
+	echo "Reflinking only ate $DIFF blocks, expected $BLKS"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we eat the same number of blocks we partially CoWd?"
+DIFF=$((FREE_BLOCKS1 - FREE_BLOCKS2 - (BLKS * 2) ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we eat the same number of blocks when we overwrote all the copies?"
+DIFF=$((FREE_BLOCKS2 - FREE_BLOCKS3 - BLKS ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did overwriting the original file consume no blocks?"
+DIFF=$((FREE_BLOCKS3 - FREE_BLOCKS4))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+
+echo "Did we use as many blocks overall as we figured on?"
+DIFF=$((FREE_BLOCKS0 - FREE_BLOCKS4 - (4 * BLKS) ))
+if [ $DIFF -gt $MARGIN ] || [ $DIFF -lt -$MARGIN ]; then
+	echo "Free blocks changed by $((-DIFF))"
+else
+	echo "Looks ok"
+fi
+lsattr -l $TESTDIR/ | _filter_test_dir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/836.out b/tests/generic/836.out
new file mode 100644
index 0000000..eeeb498
--- /dev/null
+++ b/tests/generic/836.out
@@ -0,0 +1,36 @@
+QA output created by 836
+Create the original file blocks
+Create the reflink copies
+TEST_DIR/test-836/file1          ---
+TEST_DIR/test-836/file.2         ---
+TEST_DIR/test-836/file.3         ---
+TEST_DIR/test-836/file.4         ---
+chattr +C some of the copies
+TEST_DIR/test-836/file1          ---
+TEST_DIR/test-836/file.2         No_COW
+TEST_DIR/test-836/file.3         No_COW
+TEST_DIR/test-836/file.4         ---
+chattr +C the rest of the files
+TEST_DIR/test-836/file1          No_COW
+TEST_DIR/test-836/file.2         No_COW
+TEST_DIR/test-836/file.3         No_COW
+TEST_DIR/test-836/file.4         No_COW
+Rewrite the original file
+TEST_DIR/test-836/file1          No_COW
+TEST_DIR/test-836/file.2         No_COW
+TEST_DIR/test-836/file.3         No_COW
+TEST_DIR/test-836/file.4         No_COW
+Did we eat a ton of blocks?
+Looks ok
+Did we eat the same number of blocks we partially CoWd?
+Looks ok
+Did we eat the same number of blocks when we overwrote all the copies?
+Looks ok
+Did overwriting the original file consume no blocks?
+Looks ok
+Did we use as many blocks overall as we figured on?
+Looks ok
+TEST_DIR/test-836/file1          No_COW
+TEST_DIR/test-836/file.2         No_COW
+TEST_DIR/test-836/file.3         No_COW
+TEST_DIR/test-836/file.4         No_COW
diff --git a/tests/generic/group b/tests/generic/group
index a599fb2..c0a508d 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -224,5 +224,12 @@
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
