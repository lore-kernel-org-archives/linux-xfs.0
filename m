Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 283E87FA5
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:42:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 177D48F8050
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:08 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id WcoQBIFpgEMPqVMO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:05 -0800 (PST)
Subject: [PATCH 24/32] xfs: test the automatic cowextsize extent garbage
	collector
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:42:01 -0800
Message-ID: <20160211234201.2202.59992.stgit@birch.djwong.org>
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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/231     |  130 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/231.out |   16 ++++++
 tests/xfs/232     |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/232.out |   16 ++++++
 tests/xfs/group   |    2 +
 5 files changed, 296 insertions(+)
 create mode 100755 tests/xfs/231
 create mode 100644 tests/xfs/231.out
 create mode 100755 tests/xfs/232
 create mode 100644 tests/xfs/232.out


diff --git a/tests/xfs/231 b/tests/xfs/231
new file mode 100755
index 0000000..3672887
--- /dev/null
+++ b/tests/xfs/231
@@ -0,0 +1,130 @@
+#! /bin/bash
+# FS QA Test No. 231
+#
+# Test recovery of unused CoW reservations:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Dirty a single byte on a number of CoW reservations in the second file.
+# - Fsync to flush out the dirty pages.
+# - Wait for the reclaim to run.
+# - Write more and see how bad fragmentation is.
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
+    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
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
+
+old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
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
+nr=64
+filesize=$((blksz * nr))
+bufnr=2
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -c "cowextsize $bufsize" $testdir
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file2.chk >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and leave leftovers"
+echo 2 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+seq 2 2 $((nr - 1)) | while read f; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2.chk >> $seqres.full
+done
+sync
+
+echo "Wait for CoW expiration"
+sleep 3
+
+echo "Allocate free space"
+for i in $(seq 1 32); do
+	$XFS_IO_PROG -f -c "falloc 0 1" $testdir/junk.$i >> $seqres.full
+done
+$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/junk >> $seqres.full
+
+echo "CoW and leave leftovers"
+echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+seq 2 2 $((nr - 1)) | while read f; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2.chk >> $seqres.full
+done
+sync
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 7)) || echo "file2 badly fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/231.out b/tests/xfs/231.out
new file mode 100644
index 0000000..0dcaba3
--- /dev/null
+++ b/tests/xfs/231.out
@@ -0,0 +1,16 @@
+QA output created by 231
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-231/file1
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-231/file2
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-231/file2.chk
+CoW and leave leftovers
+Wait for CoW expiration
+Allocate free space
+CoW and leave leftovers
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-231/file1
+211b0f725e67149d75104a747365eb70  SCRATCH_MNT/test-231/file2
+211b0f725e67149d75104a747365eb70  SCRATCH_MNT/test-231/file2.chk
+Check extent counts
diff --git a/tests/xfs/232 b/tests/xfs/232
new file mode 100755
index 0000000..7219a64
--- /dev/null
+++ b/tests/xfs/232
@@ -0,0 +1,132 @@
+#! /bin/bash
+# FS QA Test No. 232
+#
+# Test non-recovery of unused CoW reservations for dirty files:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Dirty a single byte on a number of CoW reservations in the second file.
+# - Fsync to flush out the dirty pages.
+# - Dirty a single byte anywhere in the second file.
+# - Wait for the reclaim to run.
+# - Write more and see how bad fragmentation is.
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
+    echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
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
+
+old_cow_lifetime=$(cat /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime)
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
+nr=64
+filesize=$((blksz * nr))
+bufnr=2
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+real_blksz=$(stat -f -c '%S' $testdir)
+internal_blks=$((filesize / real_blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -c "cowextsize $bufsize" $testdir
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file2.chk >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and leave leftovers"
+echo 2 > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+seq 2 2 $((nr - 1)) | while read f; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f - 1)) 1" $testdir/file2.chk >> $seqres.full
+done
+sync
+
+echo "Wait for CoW expiration"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * 2)) 1" $testdir/file2 >> $seqres.full
+sleep 3
+
+echo "Allocate free space"
+for i in $(seq 1 32); do
+	$XFS_IO_PROG -f -c "falloc 0 1" $testdir/junk.$i >> $seqres.full
+done
+$XFS_IO_PROG -f -c "falloc 0 $filesize" $testdir/junk >> $seqres.full
+
+echo "CoW and leave leftovers"
+echo $old_cow_lifetime > /proc/sys/fs/xfs/speculative_cow_prealloc_lifetime
+seq 2 2 $((nr - 1)) | while read f; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2 >> $seqres.full
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 $((blksz * f)) 1" $testdir/file2.chk >> $seqres.full
+done
+sync
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "Check extent counts"
+old_extents=$(_count_extents $testdir/file1)
+new_extents=$(_count_extents $testdir/file2)
+
+echo "old extents: $old_extents" >> $seqres.full
+echo "new extents: $new_extents" >> $seqres.full
+echo "maximum extents: $internal_blks" >> $seqres.full
+test $new_extents -lt $((internal_blks / 12)) || echo "file2 not sufficiently fragmented"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/232.out b/tests/xfs/232.out
new file mode 100644
index 0000000..0fb9fb9
--- /dev/null
+++ b/tests/xfs/232.out
@@ -0,0 +1,16 @@
+QA output created by 232
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-232/file1
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-232/file2
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-232/file2.chk
+CoW and leave leftovers
+Wait for CoW expiration
+Allocate free space
+CoW and leave leftovers
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-232/file1
+211b0f725e67149d75104a747365eb70  SCRATCH_MNT/test-232/file2
+211b0f725e67149d75104a747365eb70  SCRATCH_MNT/test-232/file2.chk
+Check extent counts
diff --git a/tests/xfs/group b/tests/xfs/group
index da83274..de3c7d6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -228,6 +228,8 @@
 228 auto quick clone
 229 auto rw
 230 auto quick clone
+231 auto quick clone
+232 auto quick clone
 238 auto quick metadata ioctl
 242 auto quick prealloc
 244 auto quota quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
