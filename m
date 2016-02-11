Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E20547F82
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:41:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D37FB8F804C
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:40 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EtKAHJEwrHV1OJuB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:32 -0800 (PST)
Subject: [PATCH 19/32] xfs: test fragmentation characteristics of copy-on-write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:41:28 -0800
Message-ID: <20160211234128.2202.17455.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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
 tests/generic/301     |  100 ++++++++++++++++++++++++++++++++++++
 tests/generic/301.out |   10 ++++
 tests/generic/302     |  101 ++++++++++++++++++++++++++++++++++++
 tests/generic/302.out |   10 ++++
 tests/generic/group   |    2 +
 tests/xfs/180         |  106 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/180.out     |   11 ++++
 tests/xfs/182         |  107 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/182.out     |   12 ++++
 tests/xfs/184         |  105 +++++++++++++++++++++++++++++++++++++
 tests/xfs/184.out     |   10 ++++
 tests/xfs/192         |  106 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/192.out     |   10 ++++
 tests/xfs/193         |  102 ++++++++++++++++++++++++++++++++++++
 tests/xfs/193.out     |   10 ++++
 tests/xfs/198         |  103 +++++++++++++++++++++++++++++++++++++
 tests/xfs/198.out     |   10 ++++
 tests/xfs/200         |  109 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/200.out     |   10 ++++
 tests/xfs/204         |  110 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/204.out     |   10 ++++
 tests/xfs/207         |  101 ++++++++++++++++++++++++++++++++++++
 tests/xfs/207.out     |   18 ++++++
 tests/xfs/208         |  138 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/208.out     |   13 +++++
 tests/xfs/209         |   82 +++++++++++++++++++++++++++++
 tests/xfs/209.out     |   13 +++++
 tests/xfs/210         |  108 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/210.out     |   23 ++++++++
 tests/xfs/211         |  107 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/211.out     |   11 ++++
 tests/xfs/group       |   13 +++++
 32 files changed, 1781 insertions(+)
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
index 0000000..0201d0b
--- /dev/null
+++ b/tests/generic/301
@@ -0,0 +1,100 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+for i in `seq 1 8`; do
+	$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
+done
+_scratch_remount
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
+test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/301.out b/tests/generic/301.out
new file mode 100644
index 0000000..3b677cb
--- /dev/null
+++ b/tests/generic/301.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/generic/302 b/tests/generic/302
new file mode 100755
index 0000000..c48da0a
--- /dev/null
+++ b/tests/generic/302
@@ -0,0 +1,101 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+for i in `seq 1 8`; do
+	$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
+done
+_scratch_remount
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
+test $new_extents -le $internal_blks || echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/302.out b/tests/generic/302.out
new file mode 100644
index 0000000..6a46fd7
--- /dev/null
+++ b/tests/generic/302.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/generic/group b/tests/generic/group
index f1a398c..7edc963 100644
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
index 0000000..fdb24eb
--- /dev/null
+++ b/tests/xfs/180
@@ -0,0 +1,106 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/180.out b/tests/xfs/180.out
new file mode 100644
index 0000000..a1cc4fd
--- /dev/null
+++ b/tests/xfs/180.out
@@ -0,0 +1,11 @@
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
diff --git a/tests/xfs/182 b/tests/xfs/182
new file mode 100755
index 0000000..c1bfc02
--- /dev/null
+++ b/tests/xfs/182
@@ -0,0 +1,107 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/182.out b/tests/xfs/182.out
new file mode 100644
index 0000000..7b0af93
--- /dev/null
+++ b/tests/xfs/182.out
@@ -0,0 +1,12 @@
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
diff --git a/tests/xfs/184 b/tests/xfs/184
new file mode 100755
index 0000000..50674ff
--- /dev/null
+++ b/tests/xfs/184
@@ -0,0 +1,105 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
+_scratch_remount
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
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/184.out b/tests/xfs/184.out
new file mode 100644
index 0000000..f6f6061
--- /dev/null
+++ b/tests/xfs/184.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/xfs/192 b/tests/xfs/192
new file mode 100755
index 0000000..6429def
--- /dev/null
+++ b/tests/xfs/192
@@ -0,0 +1,106 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_remount
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
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/192.out b/tests/xfs/192.out
new file mode 100644
index 0000000..13c8061
--- /dev/null
+++ b/tests/xfs/192.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/xfs/193 b/tests/xfs/193
new file mode 100755
index 0000000..974f1eb
--- /dev/null
+++ b/tests/xfs/193
@@ -0,0 +1,102 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
+_scratch_remount
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
+test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/193.out b/tests/xfs/193.out
new file mode 100644
index 0000000..cc12b6b
--- /dev/null
+++ b/tests/xfs/193.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/xfs/198 b/tests/xfs/198
new file mode 100755
index 0000000..7f3c105
--- /dev/null
+++ b/tests/xfs/198
@@ -0,0 +1,103 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_remount
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
+test $new_extents -lt $((internal_blks * 2 / 3)) || echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/198.out b/tests/xfs/198.out
new file mode 100644
index 0000000..e1d1831
--- /dev/null
+++ b/tests/xfs/198.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/xfs/200 b/tests/xfs/200
new file mode 100755
index 0000000..99bcf31
--- /dev/null
+++ b/tests/xfs/200
@@ -0,0 +1,109 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+cat $testdir/file2 > /dev/null
+$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "fadvise -d 0 $filesize" -c "fsync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_remount
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
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/200.out b/tests/xfs/200.out
new file mode 100644
index 0000000..6e0a1ee
--- /dev/null
+++ b/tests/xfs/200.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/xfs/204 b/tests/xfs/204
new file mode 100755
index 0000000..3159849
--- /dev/null
+++ b/tests/xfs/204
@@ -0,0 +1,110 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+cat $testdir/file2 > /dev/null
+$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "fadvise -d 0 $filesize" -c "fsync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_remount
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
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/204.out b/tests/xfs/204.out
new file mode 100644
index 0000000..702cd72
--- /dev/null
+++ b/tests/xfs/204.out
@@ -0,0 +1,10 @@
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
diff --git a/tests/xfs/207 b/tests/xfs/207
new file mode 100755
index 0000000..d416f79
--- /dev/null
+++ b/tests/xfs/207
@@ -0,0 +1,101 @@
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
+    rm -rf $tmp.*
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
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 0" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 1048576" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 0" $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Set extsz and cowextsz on zero byte file"
+$XFS_IO_PROG -c "extsize 1048576" $testdir/file1 | _filter_scratch
+$XFS_IO_PROG -c "cowextsize 1048576" $testdir/file1 | _filter_scratch
+
+echo "Set extsz and cowextsz on 1Mbyte file"
+$XFS_IO_PROG -c "extsize 1048576" $testdir/file2 | _filter_scratch
+$XFS_IO_PROG -c "cowextsize 1048576" $testdir/file2 | _filter_scratch
+_scratch_remount
+
+echo "Check extsz and cowextsz settings on zero byte file"
+$XFS_IO_PROG -c "extsize" $testdir/file1 | _filter_scratch
+$XFS_IO_PROG -c "cowextsize" $testdir/file1 | _filter_scratch
+
+echo "Check extsz and cowextsz settings on 1Mbyte file"
+$XFS_IO_PROG -c "extsize" $testdir/file2 | _filter_scratch
+$XFS_IO_PROG -c "cowextsize" $testdir/file2 | _filter_scratch
+
+echo "Set cowextsize and check flag"
+$XFS_IO_PROG -c "cowextsize 1048576" $testdir/file3 | _filter_scratch
+_scratch_remount
+
+$XFS_IO_PROG -c "stat" $testdir/file3 | grep 'fsxattr.xflags' | _filter_scratch
+$XFS_IO_PROG -c "cowextsize" $testdir/file3 | _filter_scratch
+
+echo "Unset cowextsize and check flag"
+$XFS_IO_PROG -c "cowextsize 0" $testdir/file3 | _filter_scratch
+_scratch_remount
+
+$XFS_IO_PROG -c "stat" $testdir/file3 | grep 'fsxattr.xflags' | _filter_scratch
+$XFS_IO_PROG -c "cowextsize" $testdir/file3 | _filter_scratch
+
+status=0
+exit
diff --git a/tests/xfs/207.out b/tests/xfs/207.out
new file mode 100644
index 0000000..14eede4
--- /dev/null
+++ b/tests/xfs/207.out
@@ -0,0 +1,18 @@
+QA output created by 207
+Format and mount
+Create the original files
+Set extsz and cowextsz on zero byte file
+Set extsz and cowextsz on 1Mbyte file
+xfs_io: XFS_IOC_FSSETXATTR SCRATCH_MNT/test-207/file2: Invalid argument
+Check extsz and cowextsz settings on zero byte file
+[1048576] SCRATCH_MNT/test-207/file1
+[1048576] SCRATCH_MNT/test-207/file1
+Check extsz and cowextsz settings on 1Mbyte file
+[0] SCRATCH_MNT/test-207/file2
+[1048576] SCRATCH_MNT/test-207/file2
+Set cowextsize and check flag
+fsxattr.xflags = 0x20000 [---------------C]
+[1048576] SCRATCH_MNT/test-207/file3
+Unset cowextsize and check flag
+fsxattr.xflags = 0x0 [----------------]
+[0] SCRATCH_MNT/test-207/file3
diff --git a/tests/xfs/208 b/tests/xfs/208
new file mode 100755
index 0000000..d876898
--- /dev/null
+++ b/tests/xfs/208
@@ -0,0 +1,138 @@
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
+    rm -rf $tmp.*
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
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+
+$XFS_IO_PROG -f -c "extsize $real_blksz" $testdir/file2
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+
+$XFS_IO_PROG -f -c "extsize $bufsize" $testdir/file3
+$XFS_IO_PROG -f -c "cowextsize $real_blksz" $testdir/file3
+_cp_reflink $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "CoW and unmount"
+echo "extsize" >> $seqres.full
+$XFS_IO_PROG -f -c "extsize" $testdir/file2 >> $seqres.full
+echo "cowextsize" >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file2 >> $seqres.full
+
+echo "extsize" >> $seqres.full
+$XFS_IO_PROG -f -c "extsize" $testdir/file3 >> $seqres.full
+echo "cowextsize" >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file3 >> $seqres.full
+
+$XFS_IO_PROG -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $filesize" -c "fdatasync" $testdir/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+new_extents=$(_count_extents $testdir/file3)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file3 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/208.out b/tests/xfs/208.out
new file mode 100644
index 0000000..a344036
--- /dev/null
+++ b/tests/xfs/208.out
@@ -0,0 +1,13 @@
+QA output created by 208
+Format and mount
+Create the original files
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
diff --git a/tests/xfs/209 b/tests/xfs/209
new file mode 100755
index 0000000..684187e
--- /dev/null
+++ b/tests/xfs/209
@@ -0,0 +1,82 @@
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
+    rm -rf $tmp.*
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
+echo "Set extsz and cowextsz on directory"
+$XFS_IO_PROG -c "cowextsize 1048576" $testdir >> $seqres.full
+
+echo "Create a fake tree structure"
+seq 1 2 | while read nr; do
+	mkdir "$testdir/dir-$nr"
+	seq 1 4 | while read nnr; do
+		touch "$testdir/dir-$nr/file-$nnr"
+	done
+done
+_scratch_remount
+
+echo "Check cowextsize settings"
+seq 1 2 | while read nr; do
+	seq 1 4 | while read nnr; do
+		file="$testdir/dir-$nr/file-$nnr"
+		$XFS_IO_PROG -c "cowextsize" $file
+	done
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/209.out b/tests/xfs/209.out
new file mode 100644
index 0000000..109af34
--- /dev/null
+++ b/tests/xfs/209.out
@@ -0,0 +1,13 @@
+QA output created by 209
+Format and mount
+Set extsz and cowextsz on directory
+Create a fake tree structure
+Check cowextsize settings
+[1048576] /opt/test-209/dir-1/file-1
+[1048576] /opt/test-209/dir-1/file-2
+[1048576] /opt/test-209/dir-1/file-3
+[1048576] /opt/test-209/dir-1/file-4
+[1048576] /opt/test-209/dir-2/file-1
+[1048576] /opt/test-209/dir-2/file-2
+[1048576] /opt/test-209/dir-2/file-3
+[1048576] /opt/test-209/dir-2/file-4
diff --git a/tests/xfs/210 b/tests/xfs/210
new file mode 100755
index 0000000..d3a2716
--- /dev/null
+++ b/tests/xfs/210
@@ -0,0 +1,108 @@
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
+    rm -rf $tmp.*
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
+echo "Create initial file"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 131072" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -c "cowextsize 1048576" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 1" $testdir/file4 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 262144" $testdir/file7 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 262144" $testdir/file9 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 262144" $testdir/file10 >> $seqres.full
+
+echo "Reflink to an empty file"
+_reflink_range $testdir/file1 0 $testdir/file2 0 0 >> $seqres.full
+
+echo "Reflink to an empty file that already has cowextsz"
+$XFS_IO_PROG -f -c "cowextsize 524288" $testdir/file3 >> $seqres.full
+_reflink_range $testdir/file1 0 $testdir/file3 0 0 >> $seqres.full
+
+echo "Reflink to a small file"
+_reflink_range $testdir/file1 0 $testdir/file4 0 0 >> $seqres.full
+
+echo "Reflink to a nonzero offset"
+_reflink_range $testdir/file1 0 $testdir/file5 65536 0 >> $seqres.full
+
+echo "Reflink from a nonzero offset"
+_reflink_range $testdir/file1 65536 $testdir/file6 0 0 >> $seqres.full
+
+echo "Reflink to a larger file"
+_reflink_range $testdir/file1 0 $testdir/file7 0 0 >> $seqres.full
+
+echo "Reflink less than the whole source file"
+_reflink_range $testdir/file1 0 $testdir/file8 0 65536 >> $seqres.full
+
+echo "cp reflink to a larger file"
+_cp_reflink $testdir/file1 $testdir/file9 >> $seqres.full
+
+echo "cp reflink to a larger file with cowextsize"
+$XFS_IO_PROG -f -c "cowextsize 524288" $testdir/file10 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file10 >> $seqres.full
+
+echo "Check cowextsz"
+for i in `seq 1 10`; do
+	$XFS_IO_PROG -c "cowextsize" $testdir/file$i | _filter_scratch
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/210.out b/tests/xfs/210.out
new file mode 100644
index 0000000..46d28d9
--- /dev/null
+++ b/tests/xfs/210.out
@@ -0,0 +1,23 @@
+QA output created by 210
+Format and mount
+Create initial file
+Reflink to an empty file
+Reflink to an empty file that already has cowextsz
+Reflink to a small file
+Reflink to a nonzero offset
+Reflink from a nonzero offset
+Reflink to a larger file
+Reflink less than the whole source file
+cp reflink to a larger file
+cp reflink to a larger file with cowextsize
+Check cowextsz
+[1048576] SCRATCH_MNT/test-210/file1
+[1048576] SCRATCH_MNT/test-210/file2
+[524288] SCRATCH_MNT/test-210/file3
+[1048576] SCRATCH_MNT/test-210/file4
+[0] SCRATCH_MNT/test-210/file5
+[0] SCRATCH_MNT/test-210/file6
+[0] SCRATCH_MNT/test-210/file7
+[0] SCRATCH_MNT/test-210/file8
+[1048576] SCRATCH_MNT/test-210/file9
+[524288] SCRATCH_MNT/test-210/file10
diff --git a/tests/xfs/211 b/tests/xfs/211
new file mode 100755
index 0000000..cb0f17a
--- /dev/null
+++ b/tests/xfs/211
@@ -0,0 +1,107 @@
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
+    rm -rf $tmp.*
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
+nr=50000
+filesize=$((blksz * nr))
+bufnr=16
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 2 * 5 / 4))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "cowextsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "cowextsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -R -S 0x63 -b $real_blksz 0 $((filesize + 1))" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b 8388608 0 $filesize" $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 20)) || test $new_extents -lt 15 \
+	|| echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/211.out b/tests/xfs/211.out
new file mode 100644
index 0000000..7371c5b
--- /dev/null
+++ b/tests/xfs/211.out
@@ -0,0 +1,11 @@
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
