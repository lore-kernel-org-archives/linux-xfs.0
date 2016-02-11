Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B11387FE7
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:42:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9AA778F8033
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:58 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id hbDKx7nCCE27FRCc (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:51 -0800 (PST)
Subject: [PATCH 31/32] xfs: test source CoW across mixed block types with
	cowextsz set
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:42:47 -0800
Message-ID: <20160211234247.2202.84676.stgit@birch.djwong.org>
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

Ensure that we can CoW the source file when the source file consists
of a range of mixed block types and there's a cowextsize hint set.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/248     |   91 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/248.out |   12 +++++++
 tests/xfs/249     |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/249.out |   12 +++++++
 tests/xfs/251     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/251.out |   12 +++++++
 tests/xfs/254     |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/254.out |   12 +++++++
 tests/xfs/255     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/255.out |   12 +++++++
 tests/xfs/256     |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/256.out |   12 +++++++
 tests/xfs/257     |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/257.out |   12 +++++++
 tests/xfs/258     |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/258.out |   12 +++++++
 tests/xfs/group   |    8 ++++
 17 files changed, 852 insertions(+)
 create mode 100755 tests/xfs/248
 create mode 100644 tests/xfs/248.out
 create mode 100755 tests/xfs/249
 create mode 100644 tests/xfs/249.out
 create mode 100755 tests/xfs/251
 create mode 100644 tests/xfs/251.out
 create mode 100755 tests/xfs/254
 create mode 100644 tests/xfs/254.out
 create mode 100755 tests/xfs/255
 create mode 100644 tests/xfs/255.out
 create mode 100755 tests/xfs/256
 create mode 100644 tests/xfs/256.out
 create mode 100755 tests/xfs/257
 create mode 100644 tests/xfs/257.out
 create mode 100755 tests/xfs/258
 create mode 100644 tests/xfs/258.out


diff --git a/tests/xfs/248 b/tests/xfs/248
new file mode 100755
index 0000000..50771a1
--- /dev/null
+++ b/tests/xfs/248
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 248
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers regular unshared and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/248.out b/tests/xfs/248.out
new file mode 100644
index 0000000..bb668ad
--- /dev/null
+++ b/tests/xfs/248.out
@@ -0,0 +1,12 @@
+QA output created by 248
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-248/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-248/file3
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-248/file1.chk
+CoW across the transition
+Compare files
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-248/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-248/file3
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-248/file1.chk
diff --git a/tests/xfs/249 b/tests/xfs/249
new file mode 100755
index 0000000..f2088ee
--- /dev/null
+++ b/tests/xfs/249
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 249
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers regular unshared and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - dio CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_regular $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/249.out b/tests/xfs/249.out
new file mode 100644
index 0000000..4a9728a
--- /dev/null
+++ b/tests/xfs/249.out
@@ -0,0 +1,12 @@
+QA output created by 249
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-249/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-249/file3
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-249/file1.chk
+CoW across the transition
+Compare files
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-249/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-249/file3
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-249/file1.chk
diff --git a/tests/xfs/251 b/tests/xfs/251
new file mode 100755
index 0000000..a2617bb
--- /dev/null
+++ b/tests/xfs/251
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 251
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers unwritten and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - fallocate the first file.
+#   - Write the odd blocks of the first file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/251.out b/tests/xfs/251.out
new file mode 100644
index 0000000..bd6b222
--- /dev/null
+++ b/tests/xfs/251.out
@@ -0,0 +1,12 @@
+QA output created by 251
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-251/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-251/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-251/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-251/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-251/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-251/file1.chk
diff --git a/tests/xfs/254 b/tests/xfs/254
new file mode 100755
index 0000000..f5cbbfe
--- /dev/null
+++ b/tests/xfs/254
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 254
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers unwritten and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - fallocate the first file.
+#   - Write the odd blocks of the first file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - DIO CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_unwritten $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/254.out b/tests/xfs/254.out
new file mode 100644
index 0000000..14c7772
--- /dev/null
+++ b/tests/xfs/254.out
@@ -0,0 +1,12 @@
+QA output created by 254
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-254/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-254/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-254/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-254/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-254/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-254/file1.chk
diff --git a/tests/xfs/255 b/tests/xfs/255
new file mode 100755
index 0000000..7532d68
--- /dev/null
+++ b/tests/xfs/255
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 255
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers holes and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - Truncate the first file.
+#   - Write the odd blocks of the first file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/255.out b/tests/xfs/255.out
new file mode 100644
index 0000000..7c665d1
--- /dev/null
+++ b/tests/xfs/255.out
@@ -0,0 +1,12 @@
+QA output created by 255
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-255/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-255/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-255/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-255/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-255/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-255/file1.chk
diff --git a/tests/xfs/256 b/tests/xfs/256
new file mode 100755
index 0000000..ea8bd69
--- /dev/null
+++ b/tests/xfs/256
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 256
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers holes and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - Truncate the first file.
+#   - Write the odd blocks of the first file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - DIO CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/256.out b/tests/xfs/256.out
new file mode 100644
index 0000000..5c3d36c
--- /dev/null
+++ b/tests/xfs/256.out
@@ -0,0 +1,12 @@
+QA output created by 256
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-256/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-256/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-256/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-256/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-256/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-256/file1.chk
diff --git a/tests/xfs/257 b/tests/xfs/257
new file mode 100755
index 0000000..05a3d25
--- /dev/null
+++ b/tests/xfs/257
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 257
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers delalloc blocks and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - Truncate the first file.
+#   - Write the odd blocks of the first file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - Write the even blocks of the first file.
+#   - CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+_sweave_reflink_holes_delalloc $blksz $nr $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/257.out b/tests/xfs/257.out
new file mode 100644
index 0000000..0f27f03
--- /dev/null
+++ b/tests/xfs/257.out
@@ -0,0 +1,12 @@
+QA output created by 257
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-257/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-257/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-257/file1.chk
+CoW across the transition
+Compare files
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-257/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-257/file3
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-257/file1.chk
diff --git a/tests/xfs/258 b/tests/xfs/258
new file mode 100755
index 0000000..ad7cb83
--- /dev/null
+++ b/tests/xfs/258
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 258
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers delalloc blocks and regular shared blocks.
+#   - Set cowextsz.
+#   - Create two files.
+#   - Truncate the first file.
+#   - Write the odd blocks of the first file.
+#   - Reflink the odd blocks of the first file into the second file.
+#   - Write the even blocks of the first file.
+#   - DIO CoW the first file across the halfway mark, starting with the
+#     regular extent.
+#   - Check that the files are now different where we say they're different.
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
+_require_xfs_io_command "falloc"
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
+echo "Create the original files"
+blksz=65536
+nr=64
+filesize=$((blksz * nr))
+$XFS_IO_PROG -c "cowextsize $((blksz * 16))" $testdir >> $seqres.full
+_sweave_reflink_holes $blksz $nr $testdir/file1 $testdir/file3 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+echo "CoW across the transition"
+cowoff=$((filesize / 4))
+cowsz=$((filesize / 2))
+_sweave_reflink_holes_delalloc $blksz $nr $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -d -f -c "pwrite -S 0x63 -b $cowsz $cowoff $cowsz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 $cowoff $cowsz $testdir/file1.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file3 | _filter_scratch
+md5sum $testdir/file1.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/258.out b/tests/xfs/258.out
new file mode 100644
index 0000000..ccaca02
--- /dev/null
+++ b/tests/xfs/258.out
@@ -0,0 +1,12 @@
+QA output created by 258
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-258/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-258/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-258/file1.chk
+CoW across the transition
+Compare files
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-258/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-258/file3
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-258/file1.chk
diff --git a/tests/xfs/group b/tests/xfs/group
index 6f43c79..4fb7618 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -245,9 +245,17 @@
 245 auto quick clone
 246 auto quick clone
 247 auto quick clone
+248 auto quick clone
+249 auto quick clone
 250 auto quick rw prealloc metadata
+251 auto quick clone
 252 auto quick prealloc
 253 auto quick
+254 auto quick clone
+255 auto quick clone
+256 auto quick clone
+257 auto quick clone
+258 auto quick clone
 259 auto quick
 261 auto quick quota
 262 auto quick quota

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
