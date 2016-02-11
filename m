Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 980917F86
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:41:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A408304066
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:07 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 6PJU1xnC18UTKSWA (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:02 -0800 (PST)
Subject: [PATCH 15/32] reflink: test CoW operations against the source file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:40:58 -0800
Message-ID: <20160211234057.2202.16147.stgit@birch.djwong.org>
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

Ensure that CoW operations against shared blocks in the source file
work correctly.

v2: remove filefrag dependencies

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/reflink        |   66 ++++++++++++++++++++++++++++++++++
 tests/generic/196     |    2 +
 tests/generic/197     |    2 +
 tests/generic/284     |   89 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/284.out |   12 ++++++
 tests/generic/287     |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/287.out |   12 ++++++
 tests/generic/289     |   91 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/289.out |   12 ++++++
 tests/generic/290     |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/290.out |   12 ++++++
 tests/generic/291     |   91 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/291.out |   12 ++++++
 tests/generic/292     |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/292.out |   12 ++++++
 tests/generic/293     |   93 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/293.out |   12 ++++++
 tests/generic/295     |   94 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/295.out |   12 ++++++
 tests/generic/296     |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/296.out |   12 ++++++
 tests/generic/group   |    9 +++++
 22 files changed, 1007 insertions(+), 2 deletions(-)
 create mode 100755 tests/generic/284
 create mode 100644 tests/generic/284.out
 create mode 100755 tests/generic/287
 create mode 100644 tests/generic/287.out
 create mode 100755 tests/generic/289
 create mode 100644 tests/generic/289.out
 create mode 100755 tests/generic/290
 create mode 100644 tests/generic/290.out
 create mode 100755 tests/generic/291
 create mode 100644 tests/generic/291.out
 create mode 100755 tests/generic/292
 create mode 100644 tests/generic/292.out
 create mode 100755 tests/generic/293
 create mode 100644 tests/generic/293.out
 create mode 100755 tests/generic/295
 create mode 100644 tests/generic/295.out
 create mode 100755 tests/generic/296
 create mode 100644 tests/generic/296.out


diff --git a/common/reflink b/common/reflink
index b92f664..5d92a88 100644
--- a/common/reflink
+++ b/common/reflink
@@ -295,3 +295,69 @@ _weave_reflink_rainbow_delalloc() {
 		_pwrite_byte 0x62 $((blksz * i)) $blksz $dfile.chk
 	done
 }
+
+# Make the source file have interleaved regular blocks and reflinked blocks
+_sweave_reflink_regular() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+	dfile=$4
+
+	_pwrite_byte 0x61 0 $((blksz * nr)) $sfile
+	_pwrite_byte 0x62 0 $((blksz * nr)) $dfile
+	_pwrite_byte 0x61 0 $((blksz * nr)) $sfile.chk
+	seq 1 2 $((nr - 1)) | while read i; do
+		_reflink_range $sfile $((blksz * i)) $dfile $((blksz * i)) $blksz
+	done
+}
+
+# Make the source file have interleaved unwritten blocks and reflinked blocks
+_sweave_reflink_unwritten() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+	dfile=$4
+
+	$XFS_IO_PROG -f -c "falloc 0 $((blksz * nr))" $sfile
+	_pwrite_byte 0x00 0 $((blksz * nr)) $sfile.chk
+	_pwrite_byte 0x62 0 $((blksz * nr)) $dfile
+	seq 1 2 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $sfile
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $sfile.chk
+	done
+	seq 1 2 $((nr - 1)) | while read i; do
+		_reflink_range $sfile $((blksz * i)) $dfile $((blksz * i)) $blksz
+	done
+}
+
+# Make the source file have interleaved holes and reflinked blocks
+_sweave_reflink_holes() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+	dfile=$4
+
+	$XFS_IO_PROG -f -c "truncate $((blksz * nr))" $sfile
+	_pwrite_byte 0x00 0 $((blksz * nr)) $sfile.chk
+	_pwrite_byte 0x62 0 $((blksz * nr)) $dfile
+	seq 1 2 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $sfile
+		_pwrite_byte 0x61 $((blksz * i)) $blksz $sfile.chk
+	done
+	seq 1 2 $((nr - 1)) | while read i; do
+		_reflink_range $sfile $((blksz * i)) $dfile $((blksz * i)) $blksz
+	done
+}
+
+# For a file created with _sweave_reflink_holes, fill the holes with delalloc
+# extents
+_sweave_reflink_holes_delalloc() {
+	blksz=$1
+	nr=$2
+	sfile=$3
+
+	seq 0 2 $((nr - 1)) | while read i; do
+		_pwrite_byte 0x64 $((blksz * i)) $blksz $sfile
+		_pwrite_byte 0x64 $((blksz * i)) $blksz $sfile.chk
+	done
+}
diff --git a/tests/generic/196 b/tests/generic/196
index 1505de8..3fcf522 100755
--- a/tests/generic/196
+++ b/tests/generic/196
@@ -2,7 +2,7 @@
 # FS QA Test No. 196
 #
 # Ensuring that copy on write in direct-io mode works when the CoW
-# range originally covers multiple extents, some unwritten, some not.
+# range originally covers multiple extents, some regular, some not.
 #   - Create two files.
 #   - Reflink the odd blocks of the first file into the second file.
 #   - directio CoW across the halfway mark, starting with the unwritten extent.
diff --git a/tests/generic/197 b/tests/generic/197
index cfdbf1b..b40ea93 100755
--- a/tests/generic/197
+++ b/tests/generic/197
@@ -2,7 +2,7 @@
 # FS QA Test No. 197
 #
 # Ensuring that copy on write in buffered mode works when the CoW
-# range originally covers multiple extents, some unwritten, some not.
+# range originally covers multiple extents, some regular, some not.
 #   - Create two files.
 #   - Reflink the odd blocks of the first file into the second file.
 #   - CoW across the halfway mark, starting with the unwritten extent.
diff --git a/tests/generic/284 b/tests/generic/284
new file mode 100755
index 0000000..aae4bb0
--- /dev/null
+++ b/tests/generic/284
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 284
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers regular unshared and regular shared blocks.
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
diff --git a/tests/generic/284.out b/tests/generic/284.out
new file mode 100644
index 0000000..cc0054d
--- /dev/null
+++ b/tests/generic/284.out
@@ -0,0 +1,12 @@
+QA output created by 284
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-284/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-284/file3
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-284/file1.chk
+CoW across the transition
+Compare files
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-284/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-284/file3
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-284/file1.chk
diff --git a/tests/generic/287 b/tests/generic/287
new file mode 100755
index 0000000..11e3c9f
--- /dev/null
+++ b/tests/generic/287
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 287
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers regular unshared and regular shared blocks.
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
diff --git a/tests/generic/287.out b/tests/generic/287.out
new file mode 100644
index 0000000..b7d47e8
--- /dev/null
+++ b/tests/generic/287.out
@@ -0,0 +1,12 @@
+QA output created by 287
+Format and mount
+Create the original files
+Compare files
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-287/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-287/file3
+bdbcf02ee0aa977795a79d25fcfdccb1  SCRATCH_MNT/test-287/file1.chk
+CoW across the transition
+Compare files
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-287/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-287/file3
+2dc2b131303b2f70ddb480778caac8b7  SCRATCH_MNT/test-287/file1.chk
diff --git a/tests/generic/289 b/tests/generic/289
new file mode 100755
index 0000000..31df1b8
--- /dev/null
+++ b/tests/generic/289
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 289
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers unwritten and regular shared blocks.
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
diff --git a/tests/generic/289.out b/tests/generic/289.out
new file mode 100644
index 0000000..e7e37a7
--- /dev/null
+++ b/tests/generic/289.out
@@ -0,0 +1,12 @@
+QA output created by 289
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-289/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-289/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-289/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-289/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-289/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-289/file1.chk
diff --git a/tests/generic/290 b/tests/generic/290
new file mode 100755
index 0000000..4a576c5
--- /dev/null
+++ b/tests/generic/290
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 290
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers unwritten and regular shared blocks.
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
diff --git a/tests/generic/290.out b/tests/generic/290.out
new file mode 100644
index 0000000..2343695
--- /dev/null
+++ b/tests/generic/290.out
@@ -0,0 +1,12 @@
+QA output created by 290
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-290/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-290/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-290/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-290/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-290/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-290/file1.chk
diff --git a/tests/generic/291 b/tests/generic/291
new file mode 100755
index 0000000..0f35ee0
--- /dev/null
+++ b/tests/generic/291
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FS QA Test No. 291
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers holes and regular shared blocks.
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
diff --git a/tests/generic/291.out b/tests/generic/291.out
new file mode 100644
index 0000000..6ac3d0e
--- /dev/null
+++ b/tests/generic/291.out
@@ -0,0 +1,12 @@
+QA output created by 291
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-291/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-291/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-291/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-291/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-291/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-291/file1.chk
diff --git a/tests/generic/292 b/tests/generic/292
new file mode 100755
index 0000000..c3d9f11
--- /dev/null
+++ b/tests/generic/292
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 292
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers holes and regular shared blocks.
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
diff --git a/tests/generic/292.out b/tests/generic/292.out
new file mode 100644
index 0000000..a50e54f
--- /dev/null
+++ b/tests/generic/292.out
@@ -0,0 +1,12 @@
+QA output created by 292
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-292/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-292/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-292/file1.chk
+CoW across the transition
+Compare files
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-292/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-292/file3
+e8cf59797f0b3758c8878c368bb4cf7e  SCRATCH_MNT/test-292/file1.chk
diff --git a/tests/generic/293 b/tests/generic/293
new file mode 100755
index 0000000..f6579d9
--- /dev/null
+++ b/tests/generic/293
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 293
+#
+# Ensuring that copy on write in buffered mode to the source file when the
+# CoW range covers delalloc blocks and regular shared blocks.
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
diff --git a/tests/generic/293.out b/tests/generic/293.out
new file mode 100644
index 0000000..aaf4fe2
--- /dev/null
+++ b/tests/generic/293.out
@@ -0,0 +1,12 @@
+QA output created by 293
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-293/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-293/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-293/file1.chk
+CoW across the transition
+Compare files
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-293/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-293/file3
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-293/file1.chk
diff --git a/tests/generic/295 b/tests/generic/295
new file mode 100755
index 0000000..e7cfaa0
--- /dev/null
+++ b/tests/generic/295
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 295
+#
+# Ensuring that copy on write in directio mode to the source file when the
+# CoW range covers delalloc blocks and regular shared blocks.
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
diff --git a/tests/generic/295.out b/tests/generic/295.out
new file mode 100644
index 0000000..cdc2b10
--- /dev/null
+++ b/tests/generic/295.out
@@ -0,0 +1,12 @@
+QA output created by 295
+Format and mount
+Create the original files
+Compare files
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-295/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-295/file3
+b8a8a88d4c143f79900c4b4e79aa3e37  SCRATCH_MNT/test-295/file1.chk
+CoW across the transition
+Compare files
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-295/file1
+ce2023f765eba19677517c511886d5c9  SCRATCH_MNT/test-295/file3
+35e2170e14665b780c6dec328d6a263b  SCRATCH_MNT/test-295/file1.chk
diff --git a/tests/generic/296 b/tests/generic/296
new file mode 100755
index 0000000..53eceb2
--- /dev/null
+++ b/tests/generic/296
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 296
+#
+# - Create two reflinked files a byte longer than a block.
+# - Rewrite the whole file.
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
+real_blksz=$(stat -f -c '%S' "$testdir")
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $((filesize + 1))" $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $real_blksz 0 $((filesize + 1))" -c "fdatasync" $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/296.out b/tests/generic/296.out
new file mode 100644
index 0000000..4f9ed60
--- /dev/null
+++ b/tests/generic/296.out
@@ -0,0 +1,12 @@
+QA output created by 296
+Format and mount
+Create the original files
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-296/file1
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-296/file2
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-296/file2.chk
+CoW and unmount
+Compare files
+2909feb63a37b0e95fe5cfb7f274f7b1  SCRATCH_MNT/test-296/file1
+d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-296/file2
+d41f6527bc8320364e12ea7076140b8b  SCRATCH_MNT/test-296/file2.chk
diff --git a/tests/generic/group b/tests/generic/group
index b4a180e..c256617 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -286,10 +286,19 @@
 281 auto quick clone
 282 auto quick clone
 283 auto quick clone
+284 auto quick clone
 285 auto rw
 286 auto quick other
+287 auto quick clone
 288 auto quick ioctl trim
+289 auto quick clone
+290 auto quick clone
+291 auto quick clone
+292 auto quick clone
+293 auto quick clone
 294 auto quick
+295 auto quick clone
+296 auto quick clone
 299 auto aio enospc rw stress
 300 auto aio enospc preallocrw stress
 306 auto quick rw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
