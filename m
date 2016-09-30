Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31068 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbcI3CX4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 22:23:56 -0400
Subject: [PATCH 7/9] xfs: more rmapbt tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 19:23:47 -0700
Message-ID: <147520222778.26891.14520830236205405604.stgit@birch.djwong.org>
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

More tests for the reverse mapping functionality.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/876     |   78 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/876.out |    4 ++
 tests/xfs/877     |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/877.out |   10 ++++++
 tests/xfs/group   |    2 +
 5 files changed, 186 insertions(+)
 create mode 100755 tests/xfs/876
 create mode 100644 tests/xfs/876.out
 create mode 100755 tests/xfs/877
 create mode 100644 tests/xfs/877.out


diff --git a/tests/xfs/876 b/tests/xfs/876
new file mode 100755
index 0000000..dae3f3a
--- /dev/null
+++ b/tests/xfs/876
@@ -0,0 +1,78 @@
+#! /bin/bash
+# FS QA Test No. 876
+#
+# Create a big enough rmapbt that we tickle a fdblocks accounting bug.
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
+	cd /
+	rm -rf "$tmp".*
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
+_require_scratch
+_require_xfs_scratch_rmapbt
+_require_scratch_reflink
+_require_test_program "punch-alternating"
+
+rm -f "$seqres.full"
+
+echo "+ create scratch fs"
+_scratch_mkfs > "$seqres.full" 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(get_block_size $SCRATCH_MNT)"
+
+# btree header is 56 bytes; an rmapbt record is 24 bytes; and
+# a rmapbt key/pointer pair is 44 bytes.
+bt_ptrs=$(( (blksz - 56) / 44 ))
+bt_recs=$(( (blksz - 56) / 24 ))
+
+blocks=$((bt_ptrs * bt_recs + 1))
+# Need (2 * blocks * blksz) bytes for files, and 20% for metadata
+_require_fs_space $SCRATCH_MNT $(( (2 * blocks * blksz) * 5 / 4096 ))
+len=$((blocks * blksz))
+
+echo "+ make some files"
+$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f2 >> $seqres.full
+./src/punch-alternating $SCRATCH_MNT/f1 >> "$seqres.full"
+./src/punch-alternating $SCRATCH_MNT/f2 >> "$seqres.full"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/876.out b/tests/xfs/876.out
new file mode 100644
index 0000000..96c1970
--- /dev/null
+++ b/tests/xfs/876.out
@@ -0,0 +1,4 @@
+QA output created by 876
++ create scratch fs
++ mount fs image
++ make some files
diff --git a/tests/xfs/877 b/tests/xfs/877
new file mode 100755
index 0000000..194b3be
--- /dev/null
+++ b/tests/xfs/877
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 877
+#
+# Make sure query_range returns -EINVAL if lowkey > highkey.
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
+	cd /
+	rm -rf "$tmp".* $metadump_file
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_xfs_scratch_rmapbt
+_require_command "$XFS_DB_PROG" "xfs_db"
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_xfs_io_command "fzero"
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+blksz=65536
+blocks=16
+len=$((blocks * blksz))
+
+echo "Create some files"
+$XFS_IO_PROG -f -c "falloc 0 $len" -c "pwrite -S 0x68 -b 1048576 0 $len" $SCRATCH_MNT/f1 >> $seqres.full
+
+echo "Manipulate file"
+$XFS_IO_PROG -c "fpunch $blksz $blksz" \
+	-c "fzero $((3 * blksz)) $blksz" \
+	-c "pwrite -S 0x69 $((5 * blksz)) $blksz" \
+	-c "fpunch $((7 * blksz)) $blksz" \
+	-c "fsync" \
+	-c "pwrite -S 0x70 $((7 * blksz)) $blksz" \
+	-c "fcollapse $((9 * blksz)) $blksz" \
+	-c "finsert $((10 * blksz)) $blksz" $SCRATCH_MNT/f1 >> $seqres.full
+
+echo "Check file"
+md5sum $SCRATCH_MNT/f1 | _filter_scratch
+od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
+
+echo "Unmount"
+_scratch_unmount
+
+echo "Try a regular fsmap"
+_scratch_xfs_db -c 'fsmap' >> $seqres.full
+_scratch_xfs_db -c 'fsmap 0 5' >> $seqres.full
+
+echo "Try a bad fsmap"
+_scratch_xfs_db -c 'fsmap 5 4'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/877.out b/tests/xfs/877.out
new file mode 100644
index 0000000..4a2242f
--- /dev/null
+++ b/tests/xfs/877.out
@@ -0,0 +1,10 @@
+QA output created by 877
+Format and mount
+Create some files
+Manipulate file
+Check file
+e45c5707fcf6817e914ffb6ce37a0ac7  SCRATCH_MNT/f1
+Unmount
+Try a regular fsmap
+Try a bad fsmap
+Error 22 while querying fsmap btree.
diff --git a/tests/xfs/group b/tests/xfs/group
index 798bf99..c09c8a1 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -315,3 +315,5 @@
 328 auto quick clone fsr
 329 auto quick clone fsr
 330 auto quick clone fsr quota
+876 auto quick rmap clone
+877 auto quick rmap clone

