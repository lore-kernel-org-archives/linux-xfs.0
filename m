Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A644D29DFE
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:12:56 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9510F304043
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:12:56 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Zp6sJn6PCoE9Tujg (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:12:51 -0800 (PST)
Subject: [PATCH 09/23] reflink: test CoW operations against the source file
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:12:43 -0800
Message-ID: <20160209011243.23099.61894.stgit@birch.djwong.org>
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

Ensure that CoW operations against shared blocks in the source file
work correctly.

v2: remove filefrag dependencies

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/196     |    2 -
 tests/generic/197     |    2 -
 tests/generic/284     |   95 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/284.out |   13 ++++++
 tests/generic/287     |   95 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/287.out |   13 ++++++
 tests/generic/289     |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/289.out |   13 ++++++
 tests/generic/290     |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/290.out |   13 ++++++
 tests/generic/291     |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/291.out |   13 ++++++
 tests/generic/292     |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/292.out |   13 ++++++
 tests/generic/293     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/293.out |   13 ++++++
 tests/generic/295     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/295.out |   13 ++++++
 tests/generic/296     |   96 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/296.out |   13 ++++++
 tests/generic/group   |    9 ++++
 21 files changed, 1036 insertions(+), 2 deletions(-)
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


diff --git a/tests/generic/196 b/tests/generic/196
index 4da9c76..11ecebb 100755
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
index 54ee5ab..72c2cb3 100755
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
index 0000000..2a94bd1
--- /dev/null
+++ b/tests/generic/284
@@ -0,0 +1,95 @@
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
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/284.out b/tests/generic/284.out
new file mode 100644
index 0000000..da24b6d
--- /dev/null
+++ b/tests/generic/284.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/287 b/tests/generic/287
new file mode 100755
index 0000000..d3c740c
--- /dev/null
+++ b/tests/generic/287
@@ -0,0 +1,95 @@
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
+blksz=65536
+nr=64
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/287.out b/tests/generic/287.out
new file mode 100644
index 0000000..fd1dcc0
--- /dev/null
+++ b/tests/generic/287.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/289 b/tests/generic/289
new file mode 100755
index 0000000..253782d
--- /dev/null
+++ b/tests/generic/289
@@ -0,0 +1,102 @@
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
+blksz=65536
+nr=64
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+sync
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/289.out b/tests/generic/289.out
new file mode 100644
index 0000000..424ac10
--- /dev/null
+++ b/tests/generic/289.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/290 b/tests/generic/290
new file mode 100755
index 0000000..76dae61
--- /dev/null
+++ b/tests/generic/290
@@ -0,0 +1,102 @@
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
+blksz=65536
+nr=64
+"$XFS_IO_PROG" -f -c "falloc 0 $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+sync
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/290.out b/tests/generic/290.out
new file mode 100644
index 0000000..6af6c5b
--- /dev/null
+++ b/tests/generic/290.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/291 b/tests/generic/291
new file mode 100755
index 0000000..a7bdd8b
--- /dev/null
+++ b/tests/generic/291
@@ -0,0 +1,102 @@
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
+blksz=65536
+nr=64
+"$XFS_IO_PROG" -f -c "truncate $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+sync
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/291.out b/tests/generic/291.out
new file mode 100644
index 0000000..93b813d
--- /dev/null
+++ b/tests/generic/291.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/292 b/tests/generic/292
new file mode 100755
index 0000000..23e1b92
--- /dev/null
+++ b/tests/generic/292
@@ -0,0 +1,102 @@
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
+blksz=65536
+nr=64
+"$XFS_IO_PROG" -f -c "truncate $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+sync
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/292.out b/tests/generic/292.out
new file mode 100644
index 0000000..2337a46
--- /dev/null
+++ b/tests/generic/292.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/293 b/tests/generic/293
new file mode 100755
index 0000000..1d2d418
--- /dev/null
+++ b/tests/generic/293
@@ -0,0 +1,107 @@
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
+blksz=65536
+nr=64
+"$XFS_IO_PROG" -f -c "truncate $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+sync
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+seq 0 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x64 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x64 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/293.out b/tests/generic/293.out
new file mode 100644
index 0000000..1f1aeb3
--- /dev/null
+++ b/tests/generic/293.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/295 b/tests/generic/295
new file mode 100755
index 0000000..e8b74f2
--- /dev/null
+++ b/tests/generic/295
@@ -0,0 +1,107 @@
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
+blksz=65536
+nr=64
+"$XFS_IO_PROG" -f -c "truncate $((blksz * nr))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x00 0 $((blksz * nr)) "$testdir/file1.chk" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((blksz * nr)) "$testdir/file3" >> "$seqres.full"
+seq 1 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x61 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+sync
+seq 1 2 $((nr-1)) | while read f; do
+	_reflink_range "$testdir/file1" $((blksz * f)) "$testdir/file3" $((blksz * f)) $blksz >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "CoW across the transition"
+seq 0 2 $((nr-1)) | while read f; do
+	_pwrite_byte 0x64 $((blksz * f)) $blksz "$testdir/file1" >> "$seqres.full"
+	_pwrite_byte 0x64 $((blksz * f)) $blksz "$testdir/file1.chk" >> "$seqres.full"
+done
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((blksz * nr / 2)) $((blksz * nr / 4)) $((blksz * nr / 2))" "$testdir/file1" >> "$seqres.full"
+_pwrite_byte 0x63 $((blksz * nr / 4)) $((blksz * nr / 2)) "$testdir/file1.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file3" | _filter_scratch
+md5sum "$testdir/file1.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/295.out b/tests/generic/295.out
new file mode 100644
index 0000000..a1c9b1f
--- /dev/null
+++ b/tests/generic/295.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/296 b/tests/generic/296
new file mode 100755
index 0000000..f8edc1b
--- /dev/null
+++ b/tests/generic/296
@@ -0,0 +1,96 @@
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
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((blksz * bsz)) 0 $((blksz * nr + 1))" "$testdir/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" -c "fdatasync" "$testdir/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $real_blksz 0 $((blksz * nr + 1))" -c "fdatasync" "$testdir/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$testdir/file1" | _filter_scratch
+md5sum "$testdir/file2" | _filter_scratch
+md5sum "$testdir/file2.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/296.out b/tests/generic/296.out
new file mode 100644
index 0000000..1b44cb4
--- /dev/null
+++ b/tests/generic/296.out
@@ -0,0 +1,13 @@
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
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index c2624eb..98242e8 100644
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
