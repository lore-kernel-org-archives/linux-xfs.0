Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 82F0A7F5E
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:38:06 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 664F4304032
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:06 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iwEpk3iAREIWg8Kk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:03 -0800 (PST)
Subject: [PATCH 08/12] reflink: test error conditions due to bad inputs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:36 -0800
Message-ID: <20151113213736.31124.61530.stgit@birch.djwong.org>
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

Check that we can feed bad inputs to reflink/dedupe and it'll reject
them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/157     |  122 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/157.out |   25 ++++++++++
 tests/generic/158     |  123 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/158.out |   24 ++++++++++
 tests/generic/159     |   74 +++++++++++++++++++++++++++++
 tests/generic/159.out |    5 ++
 tests/generic/160     |   74 +++++++++++++++++++++++++++++
 tests/generic/160.out |    5 ++
 tests/generic/group   |    4 ++
 9 files changed, 456 insertions(+)
 create mode 100755 tests/generic/157
 create mode 100644 tests/generic/157.out
 create mode 100755 tests/generic/158
 create mode 100644 tests/generic/158.out
 create mode 100755 tests/generic/159
 create mode 100755 tests/generic/159.out
 create mode 100755 tests/generic/160
 create mode 100755 tests/generic/160.out


diff --git a/tests/generic/157 b/tests/generic/157
new file mode 100755
index 0000000..a43fb0d
--- /dev/null
+++ b/tests/generic/157
@@ -0,0 +1,122 @@
+#! /bin/bash
+# FS QA Test No. 157
+#
+# Check that various invalid reflink scenarios are rejected.
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
+    rm -rf "$tmp".* "$TESTDIR1"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_scratch_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR1="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR1"
+mkdir "$TESTDIR1"
+
+TESTDIR2=$SCRATCH_MNT/test-$seq
+rm -rf "$TESTDIR2"
+mkdir "$TESTDIR2"
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file2" >> "$seqres.full"
+mkdir "$TESTDIR1/dir1"
+seq 1 $((2 * BLKSZ / 250)) | while read f; do
+	touch "$TESTDIR1/dir1/$f"
+done
+mknod "$TESTDIR1/dev1" b 8 0
+mkfifo "$TESTDIR1/fifo1"
+sync
+
+echo "Try cross-device reflink"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
+
+echo "Try unaligned reflink"
+_reflink_range "$TESTDIR1/file1" 37 "$TESTDIR1/file1" 59 23
+
+echo "Try overlapping reflink"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file1" 1 $((BLKSZ * 2))
+
+echo "Try reflink past EOF"
+_reflink_range "$TESTDIR1/file1" $(( (BLKS + 10) * BLKSZ)) "$TESTDIR1/file1" 0 $BLKSZ
+
+echo "Try to reflink a dir"
+_reflink_range "$TESTDIR1/dir1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+
+echo "Try to reflink a device"
+_reflink_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+
+echo "Try to reflink to a dir"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ
+
+echo "Try to reflink to a device"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ
+
+echo "Try to reflink to a fifo"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n
+
+echo "Try to reflink an append-only file"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a
+
+echo "Reflink two files"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ >> "$seqres.full"
+_reflink_range "$TESTDIR2/file1" 0 "$TESTDIR2/file2" 0 $BLKSZ >> "$seqres.full"
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/157.out b/tests/generic/157.out
new file mode 100644
index 0000000..177e7f8
--- /dev/null
+++ b/tests/generic/157.out
@@ -0,0 +1,25 @@
+QA output created by 157
+Format and mount
+Create the original files
+Try cross-device reflink
+XFS_IOC_CLONE_RANGE: Invalid cross-device link
+Try unaligned reflink
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try overlapping reflink
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try reflink past EOF
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try to reflink a dir
+XFS_IOC_CLONE_RANGE: Is a directory
+Try to reflink a device
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try to reflink to a dir
+/mnt/test-157/dir1: Is a directory
+Try to reflink to a device
+XFS_IOC_CLONE_RANGE: Operation not supported
+Try to reflink to a fifo
+XFS_IOC_CLONE_RANGE: Operation not supported
+Try to reflink an append-only file
+XFS_IOC_CLONE_RANGE: Bad file descriptor
+Reflink two files
+Check scratch fs
diff --git a/tests/generic/158 b/tests/generic/158
new file mode 100755
index 0000000..a499b21
--- /dev/null
+++ b/tests/generic/158
@@ -0,0 +1,123 @@
+#! /bin/bash
+# FS QA Test No. 158
+#
+# Check that various invalid dedupe scenarios are rejected.
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
+    rm -rf "$tmp".* "$TESTDIR1"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_dedupe
+_require_scratch_dedupe
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR1="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR1"
+mkdir "$TESTDIR1"
+
+TESTDIR2=$SCRATCH_MNT/test-$seq
+rm -rf "$TESTDIR2"
+mkdir "$TESTDIR2"
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file3" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file2" >> "$seqres.full"
+mkdir "$TESTDIR1/dir1"
+seq 1 $((2 * BLKSZ / 250)) | while read f; do
+	touch "$TESTDIR1/dir1/$f"
+done
+mknod "$TESTDIR1/dev1" b 8 0
+mkfifo "$TESTDIR1/fifo1"
+sync
+
+echo "Try cross-device dedupe"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
+
+echo "Try unaligned dedupe"
+_dedupe_range "$TESTDIR1/file1" 37 "$TESTDIR1/file1" 59 23
+
+echo "Try overlapping dedupe"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file1" 1 $((BLKSZ * 2))
+
+echo "Try dedupe past EOF"
+_dedupe_range "$TESTDIR1/file1" $(( (BLKS + 10) * BLKSZ)) "$TESTDIR1/file1" 0 $BLKSZ
+
+echo "Try to dedupe a dir"
+_dedupe_range "$TESTDIR1/dir1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+
+echo "Try to dedupe a device"
+_dedupe_range "$TESTDIR1/dev1" 0 "$TESTDIR1/file2" 0 $BLKSZ
+
+echo "Try to dedupe to a dir"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dir1" 0 $BLKSZ
+
+echo "Try to dedupe to a device"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/dev1" 0 $BLKSZ
+
+echo "Try to dedupe to a fifo"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/fifo1" 0 $BLKSZ -n
+
+echo "Try to dedupe an append-only file"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file3" 0 $BLKSZ -a >> "$seqres.full"
+
+echo "Dedupe two files"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ >> "$seqres.full"
+_dedupe_range "$TESTDIR2/file1" 0 "$TESTDIR2/file2" 0 $BLKSZ >> "$seqres.full"
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/158.out b/tests/generic/158.out
new file mode 100644
index 0000000..36a3f1f
--- /dev/null
+++ b/tests/generic/158.out
@@ -0,0 +1,24 @@
+QA output created by 158
+Format and mount
+Create the original files
+Try cross-device dedupe
+dedupe: Invalid cross-device link
+Try unaligned dedupe
+dedupe: Invalid argument
+Try overlapping dedupe
+dedupe: Invalid argument
+Try dedupe past EOF
+dedupe: Invalid argument
+Try to dedupe a dir
+XFS_IOC_FILE_EXTENT_SAME: Is a directory
+Try to dedupe a device
+XFS_IOC_FILE_EXTENT_SAME: Permission denied
+Try to dedupe to a dir
+/mnt/test-158/dir1: Is a directory
+Try to dedupe to a device
+dedupe: Permission denied
+Try to dedupe to a fifo
+dedupe: Permission denied
+Try to dedupe an append-only file
+Dedupe two files
+Check scratch fs
diff --git a/tests/generic/159 b/tests/generic/159
new file mode 100755
index 0000000..7944267
--- /dev/null
+++ b/tests/generic/159
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 159
+#
+# Check that we can't reflink immutable files
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
+ #   rm -rf "$tmp".* "$TESTDIR1"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_lsattr
+_require_test_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+TESTDIR1="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR1"
+mkdir "$TESTDIR1"
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+sync
+
+echo "Try reflink on immutable files"
+$CHATTR_PROG +i $TESTDIR1/file1 $TESTDIR1/file2
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_test_dir
+$CHATTR_PROG -i $TESTDIR1/file1 $TESTDIR1/file2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/159.out b/tests/generic/159.out
new file mode 100755
index 0000000..92fe33a
--- /dev/null
+++ b/tests/generic/159.out
@@ -0,0 +1,5 @@
+QA output created by 159
+Format and mount
+Create the original files
+Try reflink on immutable files
+TEST_DIR/test-159/file2: Permission denied
diff --git a/tests/generic/160 b/tests/generic/160
new file mode 100755
index 0000000..e8c43df
--- /dev/null
+++ b/tests/generic/160
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 160
+#
+# Check that we can't dedupe immutable files
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
+ #   rm -rf "$tmp".* "$TESTDIR1"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_lsattr
+_require_test_dedupe
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+TESTDIR1="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR1"
+mkdir "$TESTDIR1"
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+sync
+
+echo "Try dedupe on immutable files"
+$CHATTR_PROG +i $TESTDIR1/file1 $TESTDIR1/file2
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_test_dir
+$CHATTR_PROG -i $TESTDIR1/file1 $TESTDIR1/file2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/160.out b/tests/generic/160.out
new file mode 100755
index 0000000..a999a9c
--- /dev/null
+++ b/tests/generic/160.out
@@ -0,0 +1,5 @@
+QA output created by 160
+Format and mount
+Create the original files
+Try dedupe on immutable files
+TEST_DIR/test-160/file2: Permission denied
diff --git a/tests/generic/group b/tests/generic/group
index 3141ae5..0a20421 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -159,6 +159,10 @@
 154 auto quick clone
 155 auto quick clone
 156 auto quick clone
+157 auto quick clone
+158 auto quick clone
+159 auto quick clone
+160 auto quick clone
 169 rw metadata auto quick
 184 metadata auto quick
 192 atime auto

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
