Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A81547CA4
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:13:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1327C304039
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:13:26 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 769jzOnc9sVYLbXV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:13:17 -0800 (PST)
Subject: [PATCH 13/23] xfs: test fragmentation characteristics of copy-on-write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:13:09 -0800
Message-ID: <20160209011309.23099.60912.stgit@birch.djwong.org>
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

Perform copy-on-writes at random offsets to stress the CoW allocation
system.  Assess the effectiveness of the extent size hint at
combatting fragmentation via unshare, a rewrite, and no-op after the
random writes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/301     |  105 +++++++++++++++++++++++++++++++++
 tests/generic/301.out |   11 ++++
 tests/generic/302     |  105 +++++++++++++++++++++++++++++++++
 tests/generic/302.out |   11 ++++
 tests/generic/group   |    2 +
 tests/xfs/180         |  111 +++++++++++++++++++++++++++++++++++
 tests/xfs/180.out     |   12 ++++
 tests/xfs/182         |  111 +++++++++++++++++++++++++++++++++++
 tests/xfs/182.out     |   13 ++++
 tests/xfs/184         |  110 +++++++++++++++++++++++++++++++++++
 tests/xfs/184.out     |   11 ++++
 tests/xfs/192         |  110 +++++++++++++++++++++++++++++++++++
 tests/xfs/192.out     |   11 ++++
 tests/xfs/193         |  107 ++++++++++++++++++++++++++++++++++
 tests/xfs/193.out     |   11 ++++
 tests/xfs/198         |  107 ++++++++++++++++++++++++++++++++++
 tests/xfs/198.out     |   11 ++++
 tests/xfs/200         |  114 ++++++++++++++++++++++++++++++++++++
 tests/xfs/200.out     |   11 ++++
 tests/xfs/204         |  114 ++++++++++++++++++++++++++++++++++++
 tests/xfs/204.out     |   11 ++++
 tests/xfs/207         |  104 +++++++++++++++++++++++++++++++++
 tests/xfs/207.out     |   10 +++
 tests/xfs/208         |  154 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/208.out     |   15 +++++
 tests/xfs/209         |   88 ++++++++++++++++++++++++++++
 tests/xfs/209.out     |    6 ++
 tests/xfs/210         |  125 ++++++++++++++++++++++++++++++++++++++++
 tests/xfs/210.out     |   14 ++++
 tests/xfs/211         |  111 +++++++++++++++++++++++++++++++++++
 tests/xfs/211.out     |   12 ++++
 tests/xfs/group       |   13 ++++
 32 files changed, 1861 insertions(+)
 create mode 100755 tests/generic/301
 create mode 100644 tests/generic/301.out
 create mode 100755 tests/generic/302
 create mode 100644 tests/generic/302.out
 create mode 100755 tests/xfs/180
 create mode 100644 tests/xfs/180.out
 create mode 100755 tests/xfs/182
 create mode 100644 tests/xfs/182.out
 create mode 100755 tests/xfs/184
 create mode 100644 tests/xfs/184.out
 create mode 100755 tests/xfs/192
 create mode 100644 tests/xfs/192.out
 create mode 100755 tests/xfs/193
 create mode 100644 tests/xfs/193.out
 create mode 100755 tests/xfs/198
 create mode 100644 tests/xfs/198.out
 create mode 100755 tests/xfs/200
 create mode 100644 tests/xfs/200.out
 create mode 100755 tests/xfs/204
 create mode 100644 tests/xfs/204.out
 create mode 100755 tests/xfs/207
 create mode 100644 tests/xfs/207.out
 create mode 100755 tests/xfs/208
 create mode 100644 tests/xfs/208.out
 create mode 100755 tests/xfs/209
 create mode 100644 tests/xfs/209.out
 create mode 100755 tests/xfs/210
 create mode 100644 tests/xfs/210.out
 create mode 100755 tests/xfs/211
 create mode 100644 tests/xfs/211.out


diff --git a/tests/generic/301 b/tests/generic/301
new file mode 100755
index 0000000..c4f70e1
--- /dev/null
+++ b/tests/generic/301
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 301
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.
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
+    #rm -rf "$tmp".* "$testdir"
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
+_require_fiemap
+
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+for i in `seq 1 8`; do
+	"$XFS_IO_PROG" -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks * 2 / 3)) || _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/301.out b/tests/generic/301.out
new file mode 100644
index 0000000..668b053
--- /dev/null
+++ b/tests/generic/301.out
@@ -0,0 +1,11 @@
+QA output created by 301
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-301/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-301/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-301/file1
+Check extent counts
+Check for damage
diff --git a/tests/generic/302 b/tests/generic/302
new file mode 100755
index 0000000..e0aea69
--- /dev/null
+++ b/tests/generic/302
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 302
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.
+# - Directio write to random offsets to scatter CoW reservations.
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
+    #rm -rf "$tmp".* "$testdir"
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
+_require_fiemap
+
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+for i in `seq 1 8`; do
+	"$XFS_IO_PROG" -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -le $internal_blks || _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/302.out b/tests/generic/302.out
new file mode 100644
index 0000000..002e54d
--- /dev/null
+++ b/tests/generic/302.out
@@ -0,0 +1,11 @@
+QA output created by 302
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-302/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-302/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-302/file1
+Check extent counts
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index 3798f3b..7e1ea72 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -303,6 +303,8 @@
 298 auto quick clone
 299 auto aio enospc rw stress
 300 auto aio enospc preallocrw stress
+301 auto quick clone
+302 auto quick clone
 306 auto quick rw
 307 auto quick
 308 auto quick
diff --git a/tests/xfs/180 b/tests/xfs/180
new file mode 100755
index 0000000..0bbece0
--- /dev/null
+++ b/tests/xfs/180
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 180
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Buffered write to random offsets to scatter CoW reservations.
+# - Rewrite the whole file to use up reservations.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/180.out b/tests/xfs/180.out
new file mode 100644
index 0000000..b538430
--- /dev/null
+++ b/tests/xfs/180.out
@@ -0,0 +1,12 @@
+QA output created by 180
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-180/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-180/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-180/file1
+d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-180/file2
+Check extent counts
+Check for damage
diff --git a/tests/xfs/182 b/tests/xfs/182
new file mode 100755
index 0000000..8a32671
--- /dev/null
+++ b/tests/xfs/182
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 182
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Directio write to random offsets to scatter CoW reservations.
+# - Rewrite the whole file to use up reservations.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/182.out b/tests/xfs/182.out
new file mode 100644
index 0000000..49a18e6
--- /dev/null
+++ b/tests/xfs/182.out
@@ -0,0 +1,13 @@
+QA output created by 182
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file2
+CoW and unmount
+pwrite64: Invalid argument
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-182/file1
+c6ba35da9f73ced20d7781a448cc11d4  SCRATCH_MNT/test-182/file2
+Check extent counts
+Check for damage
diff --git a/tests/xfs/184 b/tests/xfs/184
new file mode 100755
index 0000000..27bd00f
--- /dev/null
+++ b/tests/xfs/184
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 184
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Buffered write to random offsets to scatter CoW reservations.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * nr + 1))" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/184.out b/tests/xfs/184.out
new file mode 100644
index 0000000..8a329c2
--- /dev/null
+++ b/tests/xfs/184.out
@@ -0,0 +1,11 @@
+QA output created by 184
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-184/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-184/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-184/file1
+Check extent counts
+Check for damage
diff --git a/tests/xfs/192 b/tests/xfs/192
new file mode 100755
index 0000000..7cdd707
--- /dev/null
+++ b/tests/xfs/192
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 192
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "falloc 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/192.out b/tests/xfs/192.out
new file mode 100644
index 0000000..b65e107
--- /dev/null
+++ b/tests/xfs/192.out
@@ -0,0 +1,11 @@
+QA output created by 192
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-192/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-192/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-192/file1
+Check extent counts
+Check for damage
diff --git a/tests/xfs/193 b/tests/xfs/193
new file mode 100755
index 0000000..d42c3da
--- /dev/null
+++ b/tests/xfs/193
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 193
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks * 2 / 3)) || _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/193.out b/tests/xfs/193.out
new file mode 100644
index 0000000..9ba6ea5
--- /dev/null
+++ b/tests/xfs/193.out
@@ -0,0 +1,11 @@
+QA output created by 193
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-193/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-193/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-193/file1
+Check extent counts
+Check for damage
diff --git a/tests/xfs/198 b/tests/xfs/198
new file mode 100755
index 0000000..aade7b8
--- /dev/null
+++ b/tests/xfs/198
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 198
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Directio write to random offsets to scatter CoW reservations.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks * 2 / 3)) || _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/198.out b/tests/xfs/198.out
new file mode 100644
index 0000000..9e05a17
--- /dev/null
+++ b/tests/xfs/198.out
@@ -0,0 +1,11 @@
+QA output created by 198
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-198/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-198/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-198/file1
+Check extent counts
+Check for damage
diff --git a/tests/xfs/200 b/tests/xfs/200
new file mode 100755
index 0000000..1d0e415
--- /dev/null
+++ b/tests/xfs/200
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 200
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Read the whole file into memory.
+# - Buffered write to random offsets to scatter CoW reservations.
+# - fadvise(dontneed) the whole file to evict the pages.
+# - falloc the whole fle to see if the extsz hints still apply.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+cat "$testdir/file2" > /dev/null
+"$XFS_IO_PROG" -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "fadvise -d 0 $((blksz * nr))" -c "fsync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/200.out b/tests/xfs/200.out
new file mode 100644
index 0000000..57a2726
--- /dev/null
+++ b/tests/xfs/200.out
@@ -0,0 +1,11 @@
+QA output created by 200
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-200/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-200/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-200/file1
+Check extent counts
+Check for damage
diff --git a/tests/xfs/204 b/tests/xfs/204
new file mode 100755
index 0000000..507cfc3
--- /dev/null
+++ b/tests/xfs/204
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 204
+#
+# Test fragmentation after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Read the whole file into memory.
+# - DIO write to random offsets to scatter CoW reservations.
+# - fadvise(dontneed) the whole file to evict the pages.
+# - falloc the whole fle to see if the extsz hints still apply.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+cat "$testdir/file2" > /dev/null
+"$XFS_IO_PROG" -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "fadvise -d 0 $((blksz * nr))" -c "fsync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/204.out b/tests/xfs/204.out
new file mode 100644
index 0000000..0b46503
--- /dev/null
+++ b/tests/xfs/204.out
@@ -0,0 +1,11 @@
+QA output created by 204
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-204/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-204/file2
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-204/file1
+Check extent counts
+Check for damage
diff --git a/tests/xfs/207 b/tests/xfs/207
new file mode 100755
index 0000000..d8d7e90
--- /dev/null
+++ b/tests/xfs/207
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 207
+#
+# Test setting the extsz and cowextsz hints:
+# - Ensure that we can set both on a zero-byte file.
+# - Ensure that we can set only cowextsz on a many-byte file.
+# - Ensure that whatever we set we get back later.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 0" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 1048576" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Set extsz and cowextsz on zero byte file"
+"$XFS_IO_PROG" -f -c "extsize 1048576" "$testdir/file1" | _filter_scratch
+"$XFS_IO_PROG" -f -c "cowextsize 1048576" "$testdir/file1" | _filter_scratch
+
+echo "Set extsz and cowextsz on 1Mbyte file"
+"$XFS_IO_PROG" -f -c "extsize 1048576" "$testdir/file2" | _filter_scratch
+"$XFS_IO_PROG" -f -c "cowextsize 1048576" "$testdir/file2" | _filter_scratch
+_scratch_remount
+
+fn() {
+	"$XFS_IO_PROG" -c "$1" "$2" | sed -e 's/.\([0-9]*\).*$/\1/g'
+}
+echo "Check extsz and cowextsz settings on zero byte file"
+test $(fn extsize "$testdir/file1") -eq 1048576 || echo "file1 extsize not set"
+test $(fn cowextsize "$testdir/file1") -eq 1048576 || echo "file1 cowextsize not set" 
+
+echo "Check extsz and cowextsz settings on 1Mbyte file"
+test $(fn extsize "$testdir/file2") -eq 0 || echo "file2 extsize not set"
+test $(fn cowextsize "$testdir/file2") -eq 1048576 || echo "file2 cowextsize not set" 
+
+echo "Set cowextsize and check flag"
+"$XFS_IO_PROG" -f -c "cowextsize 1048576" "$testdir/file3" | _filter_scratch
+_scratch_remount
+test $("$XFS_IO_PROG" -c "stat" "$testdir/file3" | grep 'fsxattr.xflags' | awk '{print $4}' | grep -c 'C') -eq 1 || echo "file3 cowextsz flag not set"
+test $(fn cowextsize "$testdir/file3") -eq 1048576 || echo "file3 cowextsize not set"
+"$XFS_IO_PROG" -f -c "cowextsize 0" "$testdir/file3" | _filter_scratch
+_scratch_remount
+test $(fn cowextsize "$testdir/file3") -eq 0 || echo "file3 cowextsize not set"
+test $("$XFS_IO_PROG" -c "stat" "$testdir/file3" | grep 'fsxattr.xflags' | awk '{print $4}' | grep -c 'C') -eq 0 || echo "file3 cowextsz flag not set"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/207.out b/tests/xfs/207.out
new file mode 100644
index 0000000..6fc0105
--- /dev/null
+++ b/tests/xfs/207.out
@@ -0,0 +1,10 @@
+QA output created by 207
+Format and mount
+Create the original files
+Set extsz and cowextsz on zero byte file
+Set extsz and cowextsz on 1Mbyte file
+xfs_io: XFS_IOC_FSSETXATTR SCRATCH_MNT/test-207/file2: Invalid argument
+Check extsz and cowextsz settings on zero byte file
+Check extsz and cowextsz settings on 1Mbyte file
+Set cowextsize and check flag
+Check for damage
diff --git a/tests/xfs/208 b/tests/xfs/208
new file mode 100755
index 0000000..6b470f4
--- /dev/null
+++ b/tests/xfs/208
@@ -0,0 +1,154 @@
+#! /bin/bash
+# FS QA Test No. 208
+#
+# Ensure that the effective cow extent allocation size hint is the maximum of
+# the cowextsize and extsize inode fields.
+# - Create two reflinked files.  Set extsz hint on second file to $blocksize
+#   and cowextsize hint to 1MB.
+# - Buffered write to random offsets to scatter CoW reservations.
+# - Rewrite the whole file to use up reservations.
+# - Check the number of extents.
+# - Repeat, but with extsz = 1MB and cowextsz = $blocksize.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=128
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 3) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "extsize $real_blksz" "$testdir/file2"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "extsize $((blksz * bsz))" "$testdir/file3"
+"$XFS_IO_PROG" -f -c "cowextsize $real_blksz" "$testdir/file3"
+_cp_reflink "$testdir/file1" "$testdir/file3" >> "$seqres.full"
+_scratch_remount
+
+echo "Check extsize and cowextsize"
+expected="[$real_blksz] $testdir/file2"
+test "$expected" = "$("$XFS_IO_PROG" -f -c "extsize" "$testdir/file2")" || echo "file2 extsize setting failed"
+expected="[$((blksz * bsz))] $testdir/file2"
+test "$expected" = "$("$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2")" || echo "file2 cowextsize setting failed"
+
+expected="[$real_blksz] $testdir/file3"
+test "$expected" = "$("$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file3")" || echo "file3 extsize setting failed"
+expected="[$((blksz * bsz))] $testdir/file3"
+test "$expected" = "$("$XFS_IO_PROG" -f -c "extsize" "$testdir/file3")" || echo "file3 cowextsize setting failed"
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+
+echo "CoW and unmount"
+echo "extsize" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "extsize" "$testdir/file2" >> "$seqres.full"
+echo "cowextsize" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+
+echo "extsize" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "extsize" "$testdir/file3" >> "$seqres.full"
+echo "cowextsize" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file3" >> "$seqres.full"
+
+"$XFS_IO_PROG" -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr))" -c "fdatasync" "$testdir/file3" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" -c "fdatasync" "$testdir/file3" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+new_extents=$(_count_extents "$testdir/file3")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file3 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/208.out b/tests/xfs/208.out
new file mode 100644
index 0000000..0a31249
--- /dev/null
+++ b/tests/xfs/208.out
@@ -0,0 +1,15 @@
+QA output created by 208
+Format and mount
+Create the original files
+Check extsize and cowextsize
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-208/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-208/file2
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-208/file3
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-208/file1
+d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-208/file2
+d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-208/file3
+Check extent counts
+Check for damage
diff --git a/tests/xfs/209 b/tests/xfs/209
new file mode 100755
index 0000000..ef47e74
--- /dev/null
+++ b/tests/xfs/209
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 209
+#
+# Make sure setting cowextsz on a directory propagates it to subfiles.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Set extsz and cowextsz on directory"
+"$XFS_IO_PROG" -c "cowextsize 1048576" "$testdir" >> "$seqres.full"
+
+echo "Create a fake tree structure"
+seq 1 32 | while read nr; do
+	mkdir "$testdir/dir-$nr"
+	seq 1 8 | while read nnr; do
+		touch "$testdir/dir-$nr/file-$nnr"
+	done
+done
+_scratch_remount
+
+echo "Check cowextsize settings"
+seq 1 32 | while read nr; do
+	seq 1 8 | while read nnr; do
+		file="$testdir/dir-$nr/file-$nnr"
+		expected="[1048576] $file"
+		actual="$("$XFS_IO_PROG" -c "cowextsize" "$file")"
+		test "$expected" = "$actual" || echo "cowextsize didn't propagate to $file"
+	done
+done
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/209.out b/tests/xfs/209.out
new file mode 100644
index 0000000..ffb0609
--- /dev/null
+++ b/tests/xfs/209.out
@@ -0,0 +1,6 @@
+QA output created by 209
+Format and mount
+Set extsz and cowextsz on directory
+Create a fake tree structure
+Check cowextsize settings
+Check for damage
diff --git a/tests/xfs/210 b/tests/xfs/210
new file mode 100755
index 0000000..95e73b2
--- /dev/null
+++ b/tests/xfs/210
@@ -0,0 +1,125 @@
+#! /bin/bash
+# FS QA Test No. 210
+#
+# During reflink, XFS should carry the cowextsz setting to the destination file
+# if the destination file size is less than the size of the source file, the
+# length is the size of the source file, both offsets are zero, and the
+# destination does not already have a cowextsz setting.  It should not do so
+# otherwise.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf $testdir
+mkdir $testdir
+
+echo "Create initial file"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 131072" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -c "cowextsize 1048576" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 1" "$testdir/file4" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 262144" "$testdir/file7" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 262144" "$testdir/file9" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 0 262144" "$testdir/file10" >> "$seqres.full"
+
+echo "Reflink to an empty file"
+_reflink_range "$testdir/file1" 0 "$testdir/file2" 0 0 >> "$seqres.full"
+
+echo "Reflink to an empty file that already has cowextsz"
+"$XFS_IO_PROG" -f -c "cowextsize 524288" "$testdir/file3" >> "$seqres.full"
+_reflink_range "$testdir/file1" 0 "$testdir/file3" 0 0 >> "$seqres.full"
+
+echo "Reflink to a small file"
+_reflink_range "$testdir/file1" 0 "$testdir/file4" 0 0 >> "$seqres.full"
+
+echo "Reflink to a nonzero offset"
+_reflink_range "$testdir/file1" 0 "$testdir/file5" 65536 0 >> "$seqres.full"
+
+echo "Reflink from a nonzero offset"
+_reflink_range "$testdir/file1" 65536 "$testdir/file6" 0 0 >> "$seqres.full"
+
+echo "Reflink to a large file"
+_reflink_range "$testdir/file1" 0 "$testdir/file7" 0 0 >> "$seqres.full"
+
+echo "Reflink less than the whole source file"
+_reflink_range "$testdir/file1" 0 "$testdir/file8" 0 65536 >> "$seqres.full"
+
+echo "cp reflink to a large file"
+_cp_reflink "$testdir/file1" "$testdir/file9" >> "$seqres.full"
+
+echo "cp reflink to a large file with cowextsize"
+"$XFS_IO_PROG" -f -c "cowextsize 524288" "$testdir/file10" >> "$seqres.full"
+_cp_reflink "$testdir/file1" "$testdir/file10" >> "$seqres.full"
+
+fn() {
+	"$XFS_IO_PROG" -c "cowextsize" "$1" | sed -e 's/.\([0-9]*\).*$/\1/g'
+}
+echo "Check cowextsz"
+test "$(fn "$testdir/file1")" -eq 1048576 || echo "file1 cowextsize wrong"
+test "$(fn "$testdir/file2")" -eq 1048576 || echo "file2 cowextsize wrong"
+test "$(fn "$testdir/file3")" -eq 524288 || echo "file3 cowextsize wrong"
+test "$(fn "$testdir/file4")" -eq 1048576 || echo "file4 cowextsize wrong"
+test "$(fn "$testdir/file5")" -eq 0 || echo "file5 cowextsize wrong"
+test "$(fn "$testdir/file6")" -eq 0 || echo "file6 cowextsize wrong"
+test "$(fn "$testdir/file7")" -eq 0 || echo "file7 cowextsize wrong"
+test "$(fn "$testdir/file8")" -eq 0 || echo "file8 cowextsize wrong"
+test "$(fn "$testdir/file9")" -eq 1048576 || echo "file9 cowextsize wrong"
+test "$(fn "$testdir/file10")" -eq 524288 || echo "file10 cowextsize wrong"
+for i in $(seq 1 10); do
+	echo "$testdir/file$i $(fn "$testdir/file$i")" >> "$seqres.full"
+done
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/210.out b/tests/xfs/210.out
new file mode 100644
index 0000000..ca5086b
--- /dev/null
+++ b/tests/xfs/210.out
@@ -0,0 +1,14 @@
+QA output created by 210
+Format and mount
+Create initial file
+Reflink to an empty file
+Reflink to an empty file that already has cowextsz
+Reflink to a small file
+Reflink to a nonzero offset
+Reflink from a nonzero offset
+Reflink to a large file
+Reflink less than the whole source file
+cp reflink to a large file
+cp reflink to a large file with cowextsize
+Check cowextsz
+Check for damage
diff --git a/tests/xfs/211 b/tests/xfs/211
new file mode 100755
index 0000000..abc9a07
--- /dev/null
+++ b/tests/xfs/211
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 211
+#
+# Test fragmentation in a big file after a lot of random CoW:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Directio write to random offsets to scatter CoW reservations.
+# - Rewrite the whole file to use up reservations.
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
+    #rm -rf "$tmp".* "$testdir"
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
+rm -f "$seqres.full"
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
+nr=50000
+bsz=16
+
+free_blocks=$(stat -f -c '%a' "$testdir")
+real_blksz=$(stat -f -c '%S' "$testdir")
+space_needed=$(((blksz * nr * 2) * 5 / 4))
+space_avail=$((free_blocks * real_blksz))
+internal_blks=$((blksz * nr / real_blksz))
+test $space_needed -gt $space_avail && _notrun "Not enough space. $space_avail < $space_needed"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file1" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "cowextsize $((blksz * bsz))" "$testdir/file2"
+_cp_reflink "$testdir/file1" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "cowextsize" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b 8388608 0 $((blksz * nr))" "$testdir/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents "$testdir/file1")
+new_extents=$(_count_extents "$testdir/file2")
+
+echo "old extents: $old_extents" >> "$seqres.full"
+echo "new extents: $new_extents" >> "$seqres.full"
+echo "maximum extents: $internal_blks" >> "$seqres.full"
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| _fail "file2 badly fragmented"
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/211.out b/tests/xfs/211.out
new file mode 100644
index 0000000..3d912a8
--- /dev/null
+++ b/tests/xfs/211.out
@@ -0,0 +1,12 @@
+QA output created by 211
+Format and mount
+Create the original files
+Compare files
+07415406aea963ab8e005f1d3744fded  SCRATCH_MNT/test-211/file1
+07415406aea963ab8e005f1d3744fded  SCRATCH_MNT/test-211/file2
+CoW and unmount
+Compare files
+07415406aea963ab8e005f1d3744fded  SCRATCH_MNT/test-211/file1
+7d8ab127adfc1f745a7d1cd5e44d10d8  SCRATCH_MNT/test-211/file2
+Check extent counts
+Check for damage
diff --git a/tests/xfs/group b/tests/xfs/group
index abf1d33..119e1fd 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -177,8 +177,11 @@
 177 dmapi
 178 mkfs other auto
 179 auto quick clone
+180 auto quick clone
 181 log auto quick
+182 auto quick clone
 183 rw other auto quick
+184 auto quick clone
 185 dmapi
 186 attr auto quick
 187 attr auto quick
@@ -186,16 +189,26 @@
 189 mount auto quick
 190 rw auto quick
 191 nfs4acl auto
+192 auto quick clone
+193 auto quick clone
 194 rw auto
 195 ioctl dump auto quick
 196 quota auto quick
 197 dir auto quick
+198 auto quick clone
 199 mount auto quick
+200 auto quick clone
 201 metadata auto quick
 202 repair auto quick
 203 ioctl auto
+204 auto quick clone
 205 metadata rw auto
 206 growfs auto quick
+207 auto quick clone
+208 auto quick clone
+209 auto quick clone
+210 auto quick clone
+211 clone_stress
 216 log metadata auto quick
 217 log metadata auto
 220 auto quota quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
