Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 073AA7F75
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:40:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74956AC002
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:51 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vZkGKYHhZh2Zaim5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:40:47 -0800 (PST)
Subject: [PATCH 13/32] reflink: test intersecting CoW and
	falloc/fpunch/fzero/fcollapse/finsert/ftrunc
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:40:44 -0800
Message-ID: <20160211234044.2202.25667.stgit@birch.djwong.org>
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

Ensure that we correctly handle a CoW operation immediately followed
by a truncate, falloc, fpunch, fzero, fcollapse, and finsert operation
in the middle of the CoW'd region before any flush can occur.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/253     |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/253.out |   12 ++++++
 tests/generic/254     |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/254.out |   12 ++++++
 tests/generic/259     |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/259.out |   12 ++++++
 tests/generic/261     |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/261.out |   12 ++++++
 tests/generic/262     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/262.out |   12 ++++++
 tests/generic/264     |   90 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/264.out |   12 ++++++
 tests/generic/group   |    6 +++
 13 files changed, 621 insertions(+)
 create mode 100755 tests/generic/253
 create mode 100644 tests/generic/253.out
 create mode 100755 tests/generic/254
 create mode 100644 tests/generic/254.out
 create mode 100755 tests/generic/259
 create mode 100644 tests/generic/259.out
 create mode 100755 tests/generic/261
 create mode 100644 tests/generic/261.out
 create mode 100755 tests/generic/262
 create mode 100644 tests/generic/262.out
 create mode 100755 tests/generic/264
 create mode 100644 tests/generic/264.out


diff --git a/tests/generic/253 b/tests/generic/253
new file mode 100755
index 0000000..bfb91a3
--- /dev/null
+++ b/tests/generic/253
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 253
+#
+# Truncate a file at midway through a CoW region.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+_require_xfs_io_command "truncate"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=4
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $filesize $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 2)) $blksz $((blksz * 2))" -c "truncate $((blksz * 2))" $testdir/file2 >> $seqres.full
+_scratch_remount
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 2)) $blksz $((blksz * 2))" -c "truncate $((blksz * 2))" $testdir/file2.chk >> $seqres.full
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
diff --git a/tests/generic/253.out b/tests/generic/253.out
new file mode 100644
index 0000000..3364ba0
--- /dev/null
+++ b/tests/generic/253.out
@@ -0,0 +1,12 @@
+QA output created by 253
+Format and mount
+Create the original files
+Compare files
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-253/file1
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-253/file2
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-253/file2.chk
+CoW and unmount
+Compare files
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-253/file1
+b5fc98f04b19fa7b2085ec1358c78760  SCRATCH_MNT/test-253/file2
+b5fc98f04b19fa7b2085ec1358c78760  SCRATCH_MNT/test-253/file2.chk
diff --git a/tests/generic/254 b/tests/generic/254
new file mode 100755
index 0000000..f16cdd3
--- /dev/null
+++ b/tests/generic/254
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 254
+#
+# Punch a file at midway through a CoW region.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+_require_xfs_io_command "fpunch"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=5
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $filesize $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "fpunch $((blksz * 2)) $blksz" $testdir/file2 >> $seqres.full
+_scratch_remount
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "pwrite -S 0x00 $((blksz * 2)) $blksz" $testdir/file2.chk >> $seqres.full
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
diff --git a/tests/generic/254.out b/tests/generic/254.out
new file mode 100644
index 0000000..97a8b5a
--- /dev/null
+++ b/tests/generic/254.out
@@ -0,0 +1,12 @@
+QA output created by 254
+Format and mount
+Create the original files
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-254/file1
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-254/file2
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-254/file2.chk
+CoW and unmount
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-254/file1
+b9f7a56c2ab90569cb19d8597583c6a6  SCRATCH_MNT/test-254/file2
+b9f7a56c2ab90569cb19d8597583c6a6  SCRATCH_MNT/test-254/file2.chk
diff --git a/tests/generic/259 b/tests/generic/259
new file mode 100755
index 0000000..6718c50
--- /dev/null
+++ b/tests/generic/259
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 259
+#
+# fzero a file at midway through a CoW region.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+_require_xfs_io_command "fzero"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=5
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $filesize $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "fzero $((blksz * 2)) $blksz" $testdir/file2 >> $seqres.full
+_scratch_remount
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "pwrite -S 0x00 $((blksz * 2)) $blksz" $testdir/file2.chk >> $seqres.full
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
diff --git a/tests/generic/259.out b/tests/generic/259.out
new file mode 100644
index 0000000..3517fb1
--- /dev/null
+++ b/tests/generic/259.out
@@ -0,0 +1,12 @@
+QA output created by 259
+Format and mount
+Create the original files
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-259/file1
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-259/file2
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-259/file2.chk
+CoW and unmount
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-259/file1
+b9f7a56c2ab90569cb19d8597583c6a6  SCRATCH_MNT/test-259/file2
+b9f7a56c2ab90569cb19d8597583c6a6  SCRATCH_MNT/test-259/file2.chk
diff --git a/tests/generic/261 b/tests/generic/261
new file mode 100755
index 0000000..28d0e0b
--- /dev/null
+++ b/tests/generic/261
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 261
+#
+# fcollapse a file at midway through a CoW region.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+_require_xfs_io_command "fcollapse"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=5
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $filesize $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "fcollapse $((blksz * 2)) $blksz" $testdir/file2 >> $seqres.full
+_scratch_remount
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 2)) $blksz $((blksz * 2))" -c "truncate $((blksz * (nr - 1)))" $testdir/file2.chk >> $seqres.full
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
diff --git a/tests/generic/261.out b/tests/generic/261.out
new file mode 100644
index 0000000..43691ad
--- /dev/null
+++ b/tests/generic/261.out
@@ -0,0 +1,12 @@
+QA output created by 261
+Format and mount
+Create the original files
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-261/file1
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-261/file2
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-261/file2.chk
+CoW and unmount
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-261/file1
+91b31bb8bffa8c3d3374445039287226  SCRATCH_MNT/test-261/file2
+91b31bb8bffa8c3d3374445039287226  SCRATCH_MNT/test-261/file2.chk
diff --git a/tests/generic/262 b/tests/generic/262
new file mode 100755
index 0000000..aaf38cf
--- /dev/null
+++ b/tests/generic/262
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 262
+#
+# finsert a file at midway through a CoW region.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+_require_xfs_io_command "finsert"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=4
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $filesize $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 2)) $blksz $((blksz * 2))" -c "finsert $((blksz * 2)) $blksz" $testdir/file2 >> $seqres.full
+_scratch_remount
+_pwrite_byte 0x62 $blksz $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x00 $((blksz * 2)) $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x62 $((blksz * 3)) $blksz $testdir/file2.chk >> $seqres.full
+_pwrite_byte 0x61 $((blksz * 4)) $blksz $testdir/file2.chk >> $seqres.full
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
diff --git a/tests/generic/262.out b/tests/generic/262.out
new file mode 100644
index 0000000..32c7503
--- /dev/null
+++ b/tests/generic/262.out
@@ -0,0 +1,12 @@
+QA output created by 262
+Format and mount
+Create the original files
+Compare files
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-262/file1
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-262/file2
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-262/file2.chk
+CoW and unmount
+Compare files
+c946b71bb69c07daf25470742c967e7c  SCRATCH_MNT/test-262/file1
+b9f7a56c2ab90569cb19d8597583c6a6  SCRATCH_MNT/test-262/file2
+b9f7a56c2ab90569cb19d8597583c6a6  SCRATCH_MNT/test-262/file2.chk
diff --git a/tests/generic/264 b/tests/generic/264
new file mode 100755
index 0000000..d5bcca6
--- /dev/null
+++ b/tests/generic/264
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 264
+#
+# fallocate a file at midway through a CoW region.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+_require_xfs_io_command "falloc"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=5
+filesize=$((blksz * nr))
+
+echo "Create the original files"
+_pwrite_byte 0x61 0 $filesize $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_pwrite_byte 0x61 0 $filesize $testdir/file2.chk >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" -c "falloc $((blksz * 2)) $blksz" $testdir/file2 >> $seqres.full
+_scratch_remount
+$XFS_IO_PROG -f -c "pwrite -S 0x62 -b $((blksz * 3)) $blksz $((blksz * 3))" $testdir/file2.chk >> $seqres.full
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
diff --git a/tests/generic/264.out b/tests/generic/264.out
new file mode 100644
index 0000000..cd6904b
--- /dev/null
+++ b/tests/generic/264.out
@@ -0,0 +1,12 @@
+QA output created by 264
+Format and mount
+Create the original files
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-264/file1
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-264/file2
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-264/file2.chk
+CoW and unmount
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-264/file1
+3383b9c17e643acd1a9a249cf041e183  SCRATCH_MNT/test-264/file2
+3383b9c17e643acd1a9a249cf041e183  SCRATCH_MNT/test-264/file2.chk
diff --git a/tests/generic/group b/tests/generic/group
index 0e4e7d3..b768882 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -255,12 +255,18 @@
 250 auto quick prealloc rw
 251 ioctl trim
 252 auto quick prealloc rw
+253 auto quick clone
+254 auto quick clone
 255 auto quick prealloc
 256 auto quick
 257 dir auto quick
 258 auto quick
+259 auto quick clone
 260 auto quick trim
+261 auto quick clone
+262 auto quick clone
 263 rw auto quick
+264 auto quick clone
 269 auto rw prealloc ioctl enospc stress
 270 auto quota rw prealloc ioctl enospc stress
 273 auto rw

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
