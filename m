Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E3D9B29E2C
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:14:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9CFB3304032
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:14:08 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gL7vKXNohyJVDPDr (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:14:05 -0800 (PST)
Subject: [PATCH 21/23] xfs: aio cow tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:14:01 -0800
Message-ID: <20160209011401.23099.38.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/237     |  107 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/237.out |   12 ++++++
 tests/xfs/239     |   98 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/239.out |   11 +++++
 tests/xfs/240     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/240.out |   12 ++++++
 tests/xfs/241     |   99 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/241.out |   11 +++++
 tests/xfs/group   |    4 ++
 9 files changed, 463 insertions(+)
 create mode 100755 tests/xfs/237
 create mode 100644 tests/xfs/237.out
 create mode 100755 tests/xfs/239
 create mode 100644 tests/xfs/239.out
 create mode 100755 tests/xfs/240
 create mode 100644 tests/xfs/240.out
 create mode 100755 tests/xfs/241
 create mode 100644 tests/xfs/241.out


diff --git a/tests/xfs/237 b/tests/xfs/237
new file mode 100755
index 0000000..8288724
--- /dev/null
+++ b/tests/xfs/237
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 237
+#
+# Test AIO DIO CoW behavior when the write temporarily fails.
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
+    rm -rf "$tmp".* "$testdir" "$TEST_DIR/moo"
+    _dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/dmerror
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_dm_target error
+_require_xfs_io_command "cowextsize"
+_require_aiodio "aiocp"
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_dmerror_init
+_dmerror_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+blksz=65536
+nr=640
+bsz=128
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -c "cowextsize $((blksz * bsz * 2))" "$testdir"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"
+sync
+_dmerror_load_error_table
+"$AIO_TEST" -f DIRECT -b $((blksz * bsz)) "$TEST_DIR/moo" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/237.out b/tests/xfs/237.out
new file mode 100644
index 0000000..c83dd8b
--- /dev/null
+++ b/tests/xfs/237.out
@@ -0,0 +1,12 @@
+QA output created by 237
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-237/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-237/file2
+CoW and unmount
+write missed bytes expect 8388608 got 0
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-237/file1
+d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-237/file2
+Check for damage
diff --git a/tests/xfs/239 b/tests/xfs/239
new file mode 100755
index 0000000..dfb1107
--- /dev/null
+++ b/tests/xfs/239
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 239
+#
+# Test AIO DIO CoW behavior.
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
+    rm -rf "$tmp".* "$testdir" "$TEST_DIR/moo"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "cowextsize"
+_require_aiodio "aiocp"
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+blksz=65536
+nr=640
+bsz=128
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -c "cowextsize $((blksz * bsz * 2))" "$testdir"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
+sync
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"
+"$AIO_TEST" -f DIRECT -b $((blksz * bsz)) "$TEST_DIR/moo" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/239.out b/tests/xfs/239.out
new file mode 100644
index 0000000..a123da9
--- /dev/null
+++ b/tests/xfs/239.out
@@ -0,0 +1,11 @@
+QA output created by 239
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-239/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-239/file2
+CoW and unmount
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-239/file1
+7a4d22297e80ff3c92cb1b3e4566d234  SCRATCH_MNT/test-239/file2
+Check for damage
diff --git a/tests/xfs/240 b/tests/xfs/240
new file mode 100755
index 0000000..100beba
--- /dev/null
+++ b/tests/xfs/240
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 240
+#
+# Test AIO CoW behavior when the write temporarily fails.
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
+    rm -rf "$tmp".* "$testdir" "$TEST_DIR/moo"
+    _dmerror_cleanup
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+. ./common/dmerror
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_dm_target error
+_require_xfs_io_command "cowextsize"
+AIO_TEST="src/aio-dio-regress/aiocp"
+test -x "$AIO_TEST" || _notrun "aiocp not built"
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_dmerror_init
+_dmerror_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+blksz=65536
+nr=640
+bsz=128
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -c "cowextsize $((blksz * bsz * 2))" "$testdir"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"
+sync
+_dmerror_load_error_table
+"$AIO_TEST" -b $((blksz * bsz)) "$TEST_DIR/moo" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -c "fdatasync" "$testdir/file2"
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/240.out b/tests/xfs/240.out
new file mode 100644
index 0000000..1a22e8a
--- /dev/null
+++ b/tests/xfs/240.out
@@ -0,0 +1,12 @@
+QA output created by 240
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file2
+CoW and unmount
+fdatasync: Input/output error
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-240/file1
+d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-240/file2
+Check for damage
diff --git a/tests/xfs/241 b/tests/xfs/241
new file mode 100755
index 0000000..3fdb9c3
--- /dev/null
+++ b/tests/xfs/241
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 241
+#
+# Test AIO CoW behavior.
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
+    rm -rf "$tmp".* "$testdir" "$TEST_DIR/moo"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "cowextsize"
+AIO_TEST="src/aio-dio-regress/aiocp"
+test -x "$AIO_TEST" || _notrun "aiocp not built"
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+blksz=65536
+nr=640
+bsz=128
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -c "cowextsize $((blksz * bsz * 2))" "$testdir"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 $((blksz * bsz)) 1" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$TEST_DIR/moo" >> "$seqres.full"
+sync
+"$AIO_TEST" -b $((blksz * bsz)) "$TEST_DIR/moo" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/241.out b/tests/xfs/241.out
new file mode 100644
index 0000000..a7e7df2
--- /dev/null
+++ b/tests/xfs/241.out
@@ -0,0 +1,11 @@
+QA output created by 241
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-241/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-241/file2
+CoW and unmount
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-241/file1
+7a4d22297e80ff3c92cb1b3e4566d234  SCRATCH_MNT/test-241/file2
+Check for damage
diff --git a/tests/xfs/group b/tests/xfs/group
index 1d08065..c0ce1f4 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -234,7 +234,11 @@
 234 auto quick rmap
 235 fuzzers rmap
 236 auto quick rmap
+237 auto quick clone
 238 auto quick metadata ioctl
+239 auto quick clone
+240 auto quick clone
+241 auto quick clone
 242 auto quick prealloc
 244 auto quota quick
 250 auto quick rw prealloc metadata

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
