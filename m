Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1FD3C7F8D
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:16:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C69688F8040
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:16:09 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id svBur61NPdG4yrR0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:16:06 -0700 (PDT)
Subject: [PATCH 06/11] reflink fallocate tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:16:01 -0700
Message-ID: <20150630041601.2476.52977.stgit@birch.djwong.org>
In-Reply-To: <20150630041519.2476.23059.stgit@birch.djwong.org>
References: <20150630041519.2476.23059.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Check that the variants of fallocate (allocate, punch, zero range,
collapse range, insert range) do the right thing when they're run
against a range of reflinked blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/811     |  104 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/811.out |   39 ++++++++++++++++++
 tests/generic/812     |  106 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/812.out |   21 +++++++++
 tests/generic/813     |  100 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/813.out |   24 +++++++++++
 tests/generic/814     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/814.out |   24 +++++++++++
 tests/generic/815     |   95 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/815.out |   16 +++++++
 tests/generic/816     |  100 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/816.out |   24 +++++++++++
 tests/generic/group   |    6 +++
 13 files changed, 768 insertions(+)
 create mode 100755 tests/generic/811
 create mode 100644 tests/generic/811.out
 create mode 100755 tests/generic/812
 create mode 100644 tests/generic/812.out
 create mode 100755 tests/generic/813
 create mode 100644 tests/generic/813.out
 create mode 100755 tests/generic/814
 create mode 100644 tests/generic/814.out
 create mode 100755 tests/generic/815
 create mode 100644 tests/generic/815.out
 create mode 100755 tests/generic/816
 create mode 100644 tests/generic/816.out


diff --git a/tests/generic/811 b/tests/generic/811
new file mode 100755
index 0000000..2eeb1d5
--- /dev/null
+++ b/tests/generic/811
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 811
+#
+# Ensure that fallocate steps around reflinked ranges:
+#   - Reflink parts of two files together
+#   - Fallocate all the other sparse space.
+#   - Check that the reflinked areas are still there.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "falloc"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "pwrite -S 0x61 0 $(( (BLKSZ * 5) + 37))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ $(( (BLKSZ * 4) + 37))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 0 0 $BLKSZ" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ $BLKSZ" $TESTDIR/file4 >> $seqres.full
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 5))" -c "reflink $TESTDIR/file1 $((BLKSZ * 3)) $((BLKSZ * 3)) $BLKSZ" $TESTDIR/file4 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file5
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+md5sum $TESTDIR/file5 | _filter_test_dir
+
+echo "falloc everything"
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 5))" $TESTDIR/file2
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 5))" $TESTDIR/file3
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 5))" $TESTDIR/file4
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 6))" $TESTDIR/file5
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum all files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+md5sum $TESTDIR/file5 | _filter_test_dir
+
+checker() {
+	echo '---'
+	for nr in `seq 0 $2`; do
+		echo "Check $1 block $nr: $(_numbers_equal $(_extent_physical $TESTDIR/$1 $((nr * BLKSZ)) $BLKSZ) $(_extent_physical $TESTDIR/file1 $((nr * BLKSZ)) $BLKSZ))"
+	done
+}
+checker file2 4
+checker file3 4
+checker file4 4
+checker file5 5
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/811.out b/tests/generic/811.out
new file mode 100644
index 0000000..e7812c7
--- /dev/null
+++ b/tests/generic/811.out
@@ -0,0 +1,39 @@
+QA output created by 811
+Create the original files
+009b3e150ecd3ef6e8e3ca51cb686cce  TEST_DIR/test-811/file1
+c02d88b852eb45fdf6ecb76bcc2a57db  TEST_DIR/test-811/file2
+30e9e109eea1bd6bfbd16ea0cf77dbdd  TEST_DIR/test-811/file3
+84081fec09f6bac78a7c88cbe9510c8b  TEST_DIR/test-811/file4
+009b3e150ecd3ef6e8e3ca51cb686cce  TEST_DIR/test-811/file5
+falloc everything
+Checksum all files
+009b3e150ecd3ef6e8e3ca51cb686cce  TEST_DIR/test-811/file1
+c02d88b852eb45fdf6ecb76bcc2a57db  TEST_DIR/test-811/file2
+30e9e109eea1bd6bfbd16ea0cf77dbdd  TEST_DIR/test-811/file3
+84081fec09f6bac78a7c88cbe9510c8b  TEST_DIR/test-811/file4
+21e81f9335556ecab699637873c1670c  TEST_DIR/test-811/file5
+---
+Check file2 block 0: num #1 does not match #0
+Check file2 block 1: 
+Check file2 block 2: 
+Check file2 block 3: 
+Check file2 block 4: 
+---
+Check file3 block 0: 
+Check file3 block 1: num #1 does not match #0
+Check file3 block 2: num #1 does not match #0
+Check file3 block 3: num #1 does not match #0
+Check file3 block 4: num #1 does not match #0
+---
+Check file4 block 0: num #1 does not match #0
+Check file4 block 1: 
+Check file4 block 2: num #1 does not match #0
+Check file4 block 3: 
+Check file4 block 4: num #1 does not match #0
+---
+Check file5 block 0: 
+Check file5 block 1: 
+Check file5 block 2: 
+Check file5 block 3: 
+Check file5 block 4: 
+Check file5 block 5: num #1 does not match #0
diff --git a/tests/generic/812 b/tests/generic/812
new file mode 100755
index 0000000..7774514
--- /dev/null
+++ b/tests/generic/812
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 812
+#
+# Ensure that collapse range steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Collapse the start, middle, and end of the reflink range of each
+#     of the three files, respectively
+#   - Check that the reflinked areas are still there.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fcollapse"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file1
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file2
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file3
+$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file4
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "fcollapse files"
+$XFS_IO_PROG -f -c "fcollapse 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "fcollapse $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "fcollapse $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum all files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "Check file2 block 0: $(_numbers_equal $(_extent_physical $TESTDIR/file2 0) $(_extent_physical $TESTDIR/file1 $BLKSZ))"
+echo "Check file2 block 1: $(_numbers_equal $(_extent_physical $TESTDIR/file2 $BLKSZ) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 2))))"
+echo "Check file2 block 2: $(_numbers_equal $(_extent_physical $TESTDIR/file2 $((BLKSZ * 2))) -1) (intentional)"
+
+echo "Check file3 block 0: $(_numbers_equal $(_extent_physical $TESTDIR/file3 0) $(_extent_physical $TESTDIR/file1 0))"
+echo "Check file3 block 1: $(_numbers_equal $(_extent_physical $TESTDIR/file3 $BLKSZ) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 2))))"
+echo "Check file3 block 2: $(_numbers_equal $(_extent_physical $TESTDIR/file3 $((BLKSZ * 2))) -1) (intentional)"
+
+echo "Check file4 block 0: $(_numbers_equal $(_extent_physical $TESTDIR/file4 0) $(_extent_physical $TESTDIR/file1 0))"
+echo "Check file4 block 1: $(_numbers_equal $(_extent_physical $TESTDIR/file4 $BLKSZ) $(_extent_physical $TESTDIR/file1 $BLKSZ))"
+echo "Check file4 block 2: $(_numbers_equal $(_extent_physical $TESTDIR/file4 $((BLKSZ * 2))) -1) (intentional)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/812.out b/tests/generic/812.out
new file mode 100644
index 0000000..5cf5f5c
--- /dev/null
+++ b/tests/generic/812.out
@@ -0,0 +1,21 @@
+QA output created by 812
+Create the original files
+db163becd4078f300d75178b5da99c57  TEST_DIR/test-812/file1
+db163becd4078f300d75178b5da99c57  TEST_DIR/test-812/file2
+db163becd4078f300d75178b5da99c57  TEST_DIR/test-812/file3
+db163becd4078f300d75178b5da99c57  TEST_DIR/test-812/file4
+fcollapse files
+Checksum all files
+db163becd4078f300d75178b5da99c57  TEST_DIR/test-812/file1
+60362ff0a5d013a9ea90e999bff61ff7  TEST_DIR/test-812/file2
+2eb5c9479bda10ed1e7366ac0946d1b7  TEST_DIR/test-812/file3
+9f0d31cd374f021314919f30e7784ca2  TEST_DIR/test-812/file4
+Check file2 block 0: 
+Check file2 block 1: 
+Check file2 block 2: num #1 does not match #0 (intentional)
+Check file3 block 0: 
+Check file3 block 1: 
+Check file3 block 2: num #1 does not match #0 (intentional)
+Check file4 block 0: 
+Check file4 block 1: 
+Check file4 block 2: num #1 does not match #0 (intentional)
diff --git a/tests/generic/813 b/tests/generic/813
new file mode 100755
index 0000000..fb679fc
--- /dev/null
+++ b/tests/generic/813
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. 813
+#
+# Ensure that punch-hole steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Punch the start, middle, and end of the reflink range of each
+#     of the three files, respectively
+#   - Check that the reflinked areas are still there.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fpunch"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "fpunch files"
+$XFS_IO_PROG -f -c "fpunch 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "fpunch $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "fpunch $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum all files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+checker() {
+	echo '---'
+	for nr in `seq 0 $2`; do
+		echo "Check $1 block $nr: $(_numbers_equal $(_extent_physical $TESTDIR/$1 $((nr * BLKSZ)) $BLKSZ) $(_extent_physical $TESTDIR/file1 $((nr * BLKSZ)) $BLKSZ))"
+	done
+}
+checker file2 2
+checker file3 2
+checker file4 2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/813.out b/tests/generic/813.out
new file mode 100644
index 0000000..238ab2a
--- /dev/null
+++ b/tests/generic/813.out
@@ -0,0 +1,24 @@
+QA output created by 813
+Create the original files
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-813/file1
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-813/file2
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-813/file3
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-813/file4
+fpunch files
+Checksum all files
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-813/file1
+7d0093769a56b002ee10d87d2c250af0  TEST_DIR/test-813/file2
+0345e4da280cd6b84d2ccfd0b217ed5f  TEST_DIR/test-813/file3
+9f0d31cd374f021314919f30e7784ca2  TEST_DIR/test-813/file4
+---
+Check file2 block 0: num #1 does not match #0
+Check file2 block 1: 
+Check file2 block 2: 
+---
+Check file3 block 0: 
+Check file3 block 1: num #1 does not match #0
+Check file3 block 2: 
+---
+Check file4 block 0: 
+Check file4 block 1: 
+Check file4 block 2: num #1 does not match #0
diff --git a/tests/generic/814 b/tests/generic/814
new file mode 100755
index 0000000..67ab61f
--- /dev/null
+++ b/tests/generic/814
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 814
+#
+# Ensure that insert range steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Insert into the start, middle, and end of the reflink range of each
+#     of the three files, respectively
+#   - Check that the reflinked areas are still there.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+#$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file1
+#$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file2
+#$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file3
+#$XFS_IO_PROG -f -c "falloc 0 $((BLKSZ * 4))" $TESTDIR/file4
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "finsert files"
+$XFS_IO_PROG -f -c "finsert 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "finsert $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "finsert $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum all files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "Check file2 block 0: $(_numbers_equal $(_extent_physical $TESTDIR/file2 0) -1)"
+echo "Check file2 block 1: $(_numbers_equal $(_extent_physical $TESTDIR/file2 $((BLKSZ * 1))) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 0))))"
+echo "Check file2 block 2: $(_numbers_equal $(_extent_physical $TESTDIR/file2 $((BLKSZ * 2))) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 1))))"
+echo "Check file2 block 3: $(_numbers_equal $(_extent_physical $TESTDIR/file2 $((BLKSZ * 3))) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 2))))"
+
+echo "Check file3 block 0: $(_numbers_equal $(_extent_physical $TESTDIR/file3 0) $(_extent_physical $TESTDIR/file1 0))"
+echo "Check file3 block 1: $(_numbers_equal $(_extent_physical $TESTDIR/file3 $((BLKSZ * 1))) -1)"
+echo "Check file3 block 2: $(_numbers_equal $(_extent_physical $TESTDIR/file3 $((BLKSZ * 2))) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 1))))"
+echo "Check file3 block 3: $(_numbers_equal $(_extent_physical $TESTDIR/file3 $((BLKSZ * 3))) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 2))))"
+
+echo "Check file4 block 0: $(_numbers_equal $(_extent_physical $TESTDIR/file4 0) $(_extent_physical $TESTDIR/file1 0))"
+echo "Check file4 block 1: $(_numbers_equal $(_extent_physical $TESTDIR/file4 $((BLKSZ * 1))) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 1))))"
+echo "Check file4 block 2: $(_numbers_equal $(_extent_physical $TESTDIR/file4 $((BLKSZ * 2))) -1)"
+echo "Check file4 block 3: $(_numbers_equal $(_extent_physical $TESTDIR/file4 $((BLKSZ * 3))) $(_extent_physical $TESTDIR/file1 $((BLKSZ * 2))))"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/814.out b/tests/generic/814.out
new file mode 100644
index 0000000..cfa3653
--- /dev/null
+++ b/tests/generic/814.out
@@ -0,0 +1,24 @@
+QA output created by 814
+Create the original files
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-814/file1
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-814/file2
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-814/file3
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-814/file4
+finsert files
+Checksum all files
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-814/file1
+f00836e4dd293d4fba1d25d06db3311b  TEST_DIR/test-814/file2
+889c4ac987df12e434e5c561897d6b27  TEST_DIR/test-814/file3
+5a0067da56ad62f4c7c7b29436cc3183  TEST_DIR/test-814/file4
+Check file2 block 0: 
+Check file2 block 1: 
+Check file2 block 2: 
+Check file2 block 3: 
+Check file3 block 0: 
+Check file3 block 1: 
+Check file3 block 2: 
+Check file3 block 3: 
+Check file4 block 0: 
+Check file4 block 1: 
+Check file4 block 2: 
+Check file4 block 3: 
diff --git a/tests/generic/815 b/tests/generic/815
new file mode 100755
index 0000000..bf11f01
--- /dev/null
+++ b/tests/generic/815
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 815
+#
+# Ensure that truncating the last block in a reflinked file CoWs appropriately:
+#   - Create a file that doesn't end on a block boundary
+#   - Create two reflink clones of the file
+#   - Shorten one of the clones with truncate
+#   - Lengthen the other clone with truncate
+#   - Check that the reflinked areas are still there.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "truncate"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ 37" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+echo "truncate files"
+$XFS_IO_PROG -f -c "truncate $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "truncate $((BLKSZ * 2))" $TESTDIR/file3
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum all files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+
+checker() {
+	echo '---'
+	for nr in `seq 0 $2`; do
+		echo "Check $1 block $nr: $(_numbers_equal $(_extent_physical $TESTDIR/$1 $((nr * BLKSZ)) $BLKSZ) $(_extent_physical $TESTDIR/file1 $((nr * BLKSZ)) $BLKSZ))"
+	done
+}
+checker file2 1
+checker file3 1
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/815.out b/tests/generic/815.out
new file mode 100644
index 0000000..34ed6f8
--- /dev/null
+++ b/tests/generic/815.out
@@ -0,0 +1,16 @@
+QA output created by 815
+Create the original files
+9f2cbc628fdc2717059307aba4839b74  TEST_DIR/test-815/file1
+9f2cbc628fdc2717059307aba4839b74  TEST_DIR/test-815/file2
+9f2cbc628fdc2717059307aba4839b74  TEST_DIR/test-815/file3
+truncate files
+Checksum all files
+9f2cbc628fdc2717059307aba4839b74  TEST_DIR/test-815/file1
+21a199c53f422a380e20b162fb6ebe9c  TEST_DIR/test-815/file2
+c9eb942a9b1b30bc2ee6a4904514ab98  TEST_DIR/test-815/file3
+---
+Check file2 block 0: 
+Check file2 block 1: 
+---
+Check file3 block 0: 
+Check file3 block 1: num #1 does not match #0
diff --git a/tests/generic/816 b/tests/generic/816
new file mode 100755
index 0000000..19593f4
--- /dev/null
+++ b/tests/generic/816
@@ -0,0 +1,100 @@
+#! /bin/bash
+# FS QA Test No. 816
+#
+# Ensure that zero-range steps around reflinked ranges:
+#   - Create three reflink clones of a file
+#   - Zero-range the start, middle, and end of the reflink range of each
+#     of the three files, respectively
+#   - Check that the reflinked areas are still there.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "fzero"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file4
+
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+echo "fzero files"
+$XFS_IO_PROG -f -c "fzero 0 $BLKSZ" $TESTDIR/file2
+$XFS_IO_PROG -f -c "fzero $BLKSZ $BLKSZ" $TESTDIR/file3
+$XFS_IO_PROG -f -c "fzero $((BLKSZ * 2)) $BLKSZ" $TESTDIR/file4
+sync
+echo 3 > /proc/sys/vm/drop_caches
+
+echo "Checksum all files"
+md5sum $TESTDIR/file1 | _filter_test_dir
+md5sum $TESTDIR/file2 | _filter_test_dir
+md5sum $TESTDIR/file3 | _filter_test_dir
+md5sum $TESTDIR/file4 | _filter_test_dir
+
+checker() {
+	echo '---'
+	for nr in `seq 0 $2`; do
+		echo "Check $1 block $nr: $(_numbers_equal $(_extent_physical $TESTDIR/$1 $((nr * BLKSZ)) $BLKSZ) $(_extent_physical $TESTDIR/file1 $((nr * BLKSZ)) $BLKSZ))"
+	done
+}
+checker file2 2
+checker file3 2
+checker file4 2
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/816.out b/tests/generic/816.out
new file mode 100644
index 0000000..b884984
--- /dev/null
+++ b/tests/generic/816.out
@@ -0,0 +1,24 @@
+QA output created by 816
+Create the original files
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-816/file1
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-816/file2
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-816/file3
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-816/file4
+fzero files
+Checksum all files
+31f6ac4e2c450aca17a337b2cda026fb  TEST_DIR/test-816/file1
+7d0093769a56b002ee10d87d2c250af0  TEST_DIR/test-816/file2
+0345e4da280cd6b84d2ccfd0b217ed5f  TEST_DIR/test-816/file3
+9f0d31cd374f021314919f30e7784ca2  TEST_DIR/test-816/file4
+---
+Check file2 block 0: num #1 does not match #0
+Check file2 block 1: 
+Check file2 block 2: 
+---
+Check file3 block 0: 
+Check file3 block 1: num #1 does not match #0
+Check file3 block 2: 
+---
+Check file4 block 0: 
+Check file4 block 1: 
+Check file4 block 2: num #1 does not match #0
diff --git a/tests/generic/group b/tests/generic/group
index 9af1ef8..4493ade 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -205,6 +205,12 @@
 808 auto quick clone
 809 auto quick clone
 810 auto quick clone
+811 auto quick clone
+812 auto quick clone
+813 auto quick clone
+814 auto quick clone
+815 auto quick clone
+816 auto quick clone
 817 auto quick clone
 818 auto quick clone
 819 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
