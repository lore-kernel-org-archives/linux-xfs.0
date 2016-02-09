Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4CB5329DF5
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:12:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A1702AC003
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:12:52 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kO5vKlFcxQbOCpOC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:12:45 -0800 (PST)
Subject: [PATCH 08/23] reflink: test CoW behavior with IO errors
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:12:36 -0800
Message-ID: <20160209011236.23099.3947.stgit@birch.djwong.org>
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

Test various scenarios (with dm-flakey) where we simulate write
failures during CoW, to see if the FS can get through it without
blowing up or corrupting data.  Plumb in a FS-generic method to
sort out repairing filesystems after they get hit by IO errors.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc             |   28 +++++++++++++
 tests/generic/265     |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/265.out |   11 +++++
 tests/generic/266     |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/266.out |   12 +++++
 tests/generic/267     |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/267.out |   10 +++++
 tests/generic/268     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/268.out |   12 +++++
 tests/generic/271     |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/271.out |   11 +++++
 tests/generic/272     |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/272.out |   12 +++++
 tests/generic/276     |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/276.out |   11 +++++
 tests/generic/278     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/278.out |   12 +++++
 tests/generic/279     |  103 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/279.out |   11 +++++
 tests/generic/281     |  104 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/281.out |   12 +++++
 tests/generic/282     |  104 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/282.out |   10 +++++
 tests/generic/283     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/283.out |   12 +++++
 tests/generic/group   |   12 +++++
 26 files changed, 1422 insertions(+)
 create mode 100755 tests/generic/265
 create mode 100644 tests/generic/265.out
 create mode 100755 tests/generic/266
 create mode 100644 tests/generic/266.out
 create mode 100755 tests/generic/267
 create mode 100644 tests/generic/267.out
 create mode 100755 tests/generic/268
 create mode 100644 tests/generic/268.out
 create mode 100755 tests/generic/271
 create mode 100644 tests/generic/271.out
 create mode 100755 tests/generic/272
 create mode 100644 tests/generic/272.out
 create mode 100755 tests/generic/276
 create mode 100644 tests/generic/276.out
 create mode 100755 tests/generic/278
 create mode 100644 tests/generic/278.out
 create mode 100755 tests/generic/279
 create mode 100644 tests/generic/279.out
 create mode 100755 tests/generic/281
 create mode 100644 tests/generic/281.out
 create mode 100755 tests/generic/282
 create mode 100644 tests/generic/282.out
 create mode 100755 tests/generic/283
 create mode 100644 tests/generic/283.out


diff --git a/common/rc b/common/rc
index 863d4b3..467c217 100644
--- a/common/rc
+++ b/common/rc
@@ -953,6 +953,34 @@ _scratch_xfs_repair()
     $XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
+_repair_scratch_fs()
+{
+    case $FSTYP in
+    xfs)
+        _scratch_xfs_repair "$@"
+	res=$?
+	if [ "$res" -eq 2 ]; then
+		echo "xfs_repair returns $res; replay log?"
+		_scratch_mount
+		res=$?
+		if [ "$res" -gt 0 ]; then
+			echo "mount returns $res; zap log?"
+			_scratch_xfs_repair -L
+			echo "log zap returns $?"
+		else
+			umount "$SCRATCH_MNT"
+		fi
+		_scratch_xfs_repair "$@"
+	fi
+	echo "error $?"
+        ;;
+    *)
+        # Let's hope fsck -y suffices...
+        fsck -t $FSTYP -y $SCRATCH_DEV
+        ;;
+    esac
+}
+
 _get_pids_by_name()
 {
     if [ $# -ne 1 ]
diff --git a/tests/generic/265 b/tests/generic/265
new file mode 100755
index 0000000..e91b307
--- /dev/null
+++ b/tests/generic/265
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 265
+#
+# Test CoW behavior when the write temporarily fails.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/265.out b/tests/generic/265.out
new file mode 100644
index 0000000..1b67114
--- /dev/null
+++ b/tests/generic/265.out
@@ -0,0 +1,11 @@
+QA output created by 265
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-265/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-265/file2
+CoW and unmount
+fdatasync: Input/output error
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-265/file1
+Check for damage
diff --git a/tests/generic/266 b/tests/generic/266
new file mode 100755
index 0000000..a100348
--- /dev/null
+++ b/tests/generic/266
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 266
+#
+# Test CoW behavior when the write permanently fails.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+
+echo "Clean up the mess"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/266.out b/tests/generic/266.out
new file mode 100644
index 0000000..bcfa097
--- /dev/null
+++ b/tests/generic/266.out
@@ -0,0 +1,12 @@
+QA output created by 266
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-266/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-266/file2
+CoW and unmount
+fdatasync: Input/output error
+Clean up the mess
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-266/file1
+Check for damage
diff --git a/tests/generic/267 b/tests/generic/267
new file mode 100755
index 0000000..25aaed7
--- /dev/null
+++ b/tests/generic/267
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 267
+#
+# Test CoW behavior when the write temporarily fails and we unmount.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+rm -rf "$testdir/file2" >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/267.out b/tests/generic/267.out
new file mode 100644
index 0000000..3c58e67
--- /dev/null
+++ b/tests/generic/267.out
@@ -0,0 +1,10 @@
+QA output created by 267
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-267/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-267/file2
+CoW and unmount
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-267/file1
+Check for damage
diff --git a/tests/generic/268 b/tests/generic/268
new file mode 100755
index 0000000..fa3d991
--- /dev/null
+++ b/tests/generic/268
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 268
+#
+# Test CoW behavior when the write temporarily fails but the userspace
+# program writes again.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+
+echo "Rewrite"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x64 -b $((blksz * bsz)) 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/268.out b/tests/generic/268.out
new file mode 100644
index 0000000..234e8be
--- /dev/null
+++ b/tests/generic/268.out
@@ -0,0 +1,12 @@
+QA output created by 268
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-268/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-268/file2
+CoW and unmount
+fdatasync: Input/output error
+Rewrite
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-268/file1
+Check for damage
diff --git a/tests/generic/271 b/tests/generic/271
new file mode 100755
index 0000000..efdd377
--- /dev/null
+++ b/tests/generic/271
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 271
+#
+# Test DIO CoW behavior when the write temporarily fails.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/271.out b/tests/generic/271.out
new file mode 100644
index 0000000..f7ea004
--- /dev/null
+++ b/tests/generic/271.out
@@ -0,0 +1,11 @@
+QA output created by 271
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-271/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-271/file2
+CoW and unmount
+pwrite64: Input/output error
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-271/file1
+Check for damage
diff --git a/tests/generic/272 b/tests/generic/272
new file mode 100755
index 0000000..64c9834
--- /dev/null
+++ b/tests/generic/272
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 272
+#
+# Test DIO CoW behavior when the write permanently fails.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+
+echo "Clean up the mess"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/272.out b/tests/generic/272.out
new file mode 100644
index 0000000..4794088
--- /dev/null
+++ b/tests/generic/272.out
@@ -0,0 +1,12 @@
+QA output created by 272
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-272/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-272/file2
+CoW and unmount
+pwrite64: Input/output error
+Clean up the mess
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-272/file1
+Check for damage
diff --git a/tests/generic/276 b/tests/generic/276
new file mode 100755
index 0000000..3b51ffd
--- /dev/null
+++ b/tests/generic/276
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 276
+#
+# Test DIO CoW behavior when the write temporarily fails and we unmount.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+rm -rf "$testdir/file2" >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/276.out b/tests/generic/276.out
new file mode 100644
index 0000000..e2aeacf
--- /dev/null
+++ b/tests/generic/276.out
@@ -0,0 +1,11 @@
+QA output created by 276
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-276/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-276/file2
+CoW and unmount
+pwrite64: Input/output error
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-276/file1
+Check for damage
diff --git a/tests/generic/278 b/tests/generic/278
new file mode 100755
index 0000000..892320e
--- /dev/null
+++ b/tests/generic/278
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 278
+#
+# Test CoW behavior when the write temporarily fails but the userspace
+# program writes again.
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
+    rm -rf "$tmp".*
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_dmerror_load_working_table
+
+echo "Rewrite"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x64 -b $((blksz * bsz)) 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/278.out b/tests/generic/278.out
new file mode 100644
index 0000000..6723b73
--- /dev/null
+++ b/tests/generic/278.out
@@ -0,0 +1,12 @@
+QA output created by 278
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-278/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-278/file2
+CoW and unmount
+pwrite64: Input/output error
+Rewrite
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-278/file1
+Check for damage
diff --git a/tests/generic/279 b/tests/generic/279
new file mode 100755
index 0000000..66ea000
--- /dev/null
+++ b/tests/generic/279
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 279
+#
+# Test mmap CoW behavior when the write temporarily fails.
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
+    rm -rf "$tmp".* "$TEST_DIR/mwrite.out"
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+urk=$("$XFS_IO_PROG" -f -c "mmap -rw 0 $((blksz * nr))" -c "mwrite -S 0x63 0 $((blksz * nr))" -c "msync -s 0 $((blksz * nr))" "$testdir/file2" > "$TEST_DIR/mwrite.out" 2>&1)
+cat "$TEST_DIR/mwrite.out" | tee -a "$seqres.full"
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/279.out b/tests/generic/279.out
new file mode 100644
index 0000000..f34c2b2
--- /dev/null
+++ b/tests/generic/279.out
@@ -0,0 +1,11 @@
+QA output created by 279
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-279/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-279/file2
+CoW and unmount
+msync: Input/output error
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-279/file1
+Check for damage
diff --git a/tests/generic/281 b/tests/generic/281
new file mode 100755
index 0000000..09dc4be
--- /dev/null
+++ b/tests/generic/281
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 281
+#
+# Test mmap CoW behavior when the write permanently fails.
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
+    rm -rf "$tmp".* "$TEST_DIR/mwrite.out"
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+urk=$("$XFS_IO_PROG" -f -c "mmap -rw 0 $((blksz * nr))" -c "mwrite -S 0x63 0 $((blksz * nr))" -c "msync -s 0 $((blksz * nr))" "$testdir/file2" > "$TEST_DIR/mwrite.out" 2>&1)
+cat "$TEST_DIR/mwrite.out" | tee -a "$seqres.full"
+
+echo "Clean up the mess"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/281.out b/tests/generic/281.out
new file mode 100644
index 0000000..17a656b
--- /dev/null
+++ b/tests/generic/281.out
@@ -0,0 +1,12 @@
+QA output created by 281
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-281/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-281/file2
+CoW and unmount
+msync: Input/output error
+Clean up the mess
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-281/file1
+Check for damage
diff --git a/tests/generic/282 b/tests/generic/282
new file mode 100755
index 0000000..29b7c13
--- /dev/null
+++ b/tests/generic/282
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 282
+#
+# Test mmap CoW behavior when the write temporarily fails and we unmount.
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
+    rm -rf "$tmp".* "$TEST_DIR/mwrite.out"
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+urk=$("$XFS_IO_PROG" -f -c "mmap -rw 0 $((blksz * nr))" -c "mwrite -S 0x63 0 $((blksz * nr))" "$testdir/file2" > "$TEST_DIR/mwrite.out" 2>&1)
+cat "$TEST_DIR/mwrite.out" | tee -a "$seqres.full"
+_dmerror_load_working_table
+rm -rf "$testdir/file2" >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/282.out b/tests/generic/282.out
new file mode 100644
index 0000000..624dbfa
--- /dev/null
+++ b/tests/generic/282.out
@@ -0,0 +1,10 @@
+QA output created by 282
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-282/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-282/file2
+CoW and unmount
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-282/file1
+Check for damage
diff --git a/tests/generic/283 b/tests/generic/283
new file mode 100755
index 0000000..3861954
--- /dev/null
+++ b/tests/generic/283
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 283
+#
+# Test mmap CoW behavior when the write temporarily fails but the userspace
+# program writes again.
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
+    rm -rf "$tmp".* "$TEST_DIR/mwrite.out"
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
+_need_to_be_root
+_require_dm_target error
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
+sync
+_dmerror_load_error_table
+urk=$("$XFS_IO_PROG" -f -c "mmap -rw 0 $((blksz * nr))" -c "mwrite -S 0x63 0 $((blksz * nr))" -c "msync -s 0 $((blksz * nr))" "$testdir/file2" > "$TEST_DIR/mwrite.out" 2>&1)
+cat "$TEST_DIR/mwrite.out" | tee -a "$seqres.full"
+_dmerror_load_working_table
+
+echo "Rewrite"
+"$XFS_IO_PROG" -f -c "mmap -rw 0 $((blksz * nr))" -c "mwrite -S 0x63 0 $((blksz * nr))" -c "msync 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full" 2>&1
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> "$seqres.full" 2>&1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/283.out b/tests/generic/283.out
new file mode 100644
index 0000000..f9fd5c8
--- /dev/null
+++ b/tests/generic/283.out
@@ -0,0 +1,12 @@
+QA output created by 283
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-283/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-283/file2
+CoW and unmount
+msync: Input/output error
+Rewrite
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-283/file1
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index 0b584d9..c2624eb 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -267,13 +267,25 @@
 262 auto quick clone
 263 rw auto quick
 264 auto quick clone
+265 auto quick clone
+266 auto quick clone
+267 auto quick clone
+268 auto quick clone
 269 auto rw prealloc ioctl enospc stress
 270 auto quota rw prealloc ioctl enospc stress
+271 auto quick clone
+272 auto quick clone
 273 auto rw
 274 auto rw prealloc
 275 auto rw enospc
+276 auto quick clone
 277 auto ioctl quick metadata
+278 auto quick clone
+279 auto quick clone
 280 auto quota freeze dangerous
+281 auto quick clone
+282 auto quick clone
+283 auto quick clone
 285 auto rw
 286 auto quick other
 288 auto quick ioctl trim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
