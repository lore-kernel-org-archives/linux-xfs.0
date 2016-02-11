Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A6AD17FB5
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:42:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1B7BEAC002
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:21 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9MPuqoJy6uqsVr3J (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:18 -0800 (PST)
Subject: [PATCH 26/32] reflink: test aio copy on write
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:42:14 -0800
Message-ID: <20160211234214.2202.32501.stgit@birch.djwong.org>
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

Make sure that copy on write works with the AIO path.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/329     |  102 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/329.out |   12 ++++++
 tests/generic/330     |   93 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/330.out |   11 +++++
 tests/generic/331     |  104 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/331.out |   12 ++++++
 tests/generic/332     |   94 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/332.out |   11 +++++
 tests/generic/group   |    4 ++
 9 files changed, 443 insertions(+)
 create mode 100755 tests/generic/329
 create mode 100644 tests/generic/329.out
 create mode 100755 tests/generic/330
 create mode 100644 tests/generic/330.out
 create mode 100755 tests/generic/331
 create mode 100644 tests/generic/331.out
 create mode 100755 tests/generic/332
 create mode 100644 tests/generic/332.out


diff --git a/tests/generic/329 b/tests/generic/329
new file mode 100755
index 0000000..3991672
--- /dev/null
+++ b/tests/generic/329
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 329
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
+    rm -rf $tmp.* $TEST_DIR/moo
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
+_require_aiodio "aiocp"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_dmerror_init
+_dmerror_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=640
+bufnr=128
+filesize=$((blksz * nr))
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
+sync
+_dmerror_load_error_table
+$AIO_TEST -f DIRECT -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/329.out b/tests/generic/329.out
new file mode 100644
index 0000000..f14726c
--- /dev/null
+++ b/tests/generic/329.out
@@ -0,0 +1,12 @@
+QA output created by 329
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-329/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-329/file2
+CoW and unmount
+write missed bytes expect 8388608 got 0
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-329/file1
+d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-329/file2
+Check for damage
diff --git a/tests/generic/330 b/tests/generic/330
new file mode 100755
index 0000000..377d822
--- /dev/null
+++ b/tests/generic/330
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 330
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
+    rm -rf $tmp.* $TEST_DIR/moo
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
+_require_aiodio "aiocp"
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
+nr=640
+bufnr=128
+filesize=$((blksz * nr))
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
+sync
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
+$AIO_TEST -f DIRECT -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Check for damage"
+umount $SCRATCH_MNT
+_repair_scratch_fs >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/330.out b/tests/generic/330.out
new file mode 100644
index 0000000..9a33a22
--- /dev/null
+++ b/tests/generic/330.out
@@ -0,0 +1,11 @@
+QA output created by 330
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-330/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-330/file2
+CoW and unmount
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-330/file1
+7a4d22297e80ff3c92cb1b3e4566d234  SCRATCH_MNT/test-330/file2
+Check for damage
diff --git a/tests/generic/331 b/tests/generic/331
new file mode 100755
index 0000000..8d8fd6a
--- /dev/null
+++ b/tests/generic/331
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 331
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
+    rm -rf $tmp.* $TEST_DIR/moo
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
+_require_test_program "aio-dio-regress/aiocp"
+AIO_TEST="src/aio-dio-regress/aiocp"
+
+rm -f $seqres.full
+
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_dmerror_init
+_dmerror_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=640
+bufnr=128
+filesize=$((blksz * nr))
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
+sync
+_dmerror_load_error_table
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -c "fdatasync" $testdir/file2
+_dmerror_load_working_table
+_dmerror_unmount
+_dmerror_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Check for damage"
+_dmerror_unmount
+_dmerror_cleanup
+_repair_scratch_fs >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/331.out b/tests/generic/331.out
new file mode 100644
index 0000000..adbf841
--- /dev/null
+++ b/tests/generic/331.out
@@ -0,0 +1,12 @@
+QA output created by 331
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file2
+CoW and unmount
+fdatasync: Input/output error
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-331/file1
+d94b0ab13385aba594411c174b1cc13c  SCRATCH_MNT/test-331/file2
+Check for damage
diff --git a/tests/generic/332 b/tests/generic/332
new file mode 100755
index 0000000..f9b5f6f
--- /dev/null
+++ b/tests/generic/332
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 332
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
+    rm -rf $tmp.* $TEST_DIR/moo
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
+_require_test_program "aio-dio-regress/aiocp"
+AIO_TEST="src/aio-dio-regress/aiocp"
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
+nr=640
+bufnr=128
+filesize=$((blksz * nr))
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "CoW and unmount"
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $bufsize 1" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 -b $bufsize 0 $filesize" $TEST_DIR/moo >> $seqres.full
+sync
+$AIO_TEST -b $bufsize $TEST_DIR/moo $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "Check for damage"
+umount $SCRATCH_MNT
+_repair_scratch_fs >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/332.out b/tests/generic/332.out
new file mode 100644
index 0000000..b584b1e
--- /dev/null
+++ b/tests/generic/332.out
@@ -0,0 +1,11 @@
+QA output created by 332
+Format and mount
+Create the original files
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-332/file1
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-332/file2
+CoW and unmount
+Compare files
+1886e67cf8783e89ce6ddc5bb09a3944  SCRATCH_MNT/test-332/file1
+7a4d22297e80ff3c92cb1b3e4566d234  SCRATCH_MNT/test-332/file2
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index 8b9e0e5..e7ed475 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -331,3 +331,7 @@
 326 auto quick clone
 327 auto quick clone
 328 auto quick clone
+329 auto quick clone
+330 auto quick clone
+331 auto quick clone
+332 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
