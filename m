Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A7ED7F5A
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:37:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D03A8F8049
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:27 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ZsNUzJTrJVT9XwO1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:37:23 -0800 (PST)
Subject: [PATCH 02/12] btrfs: move btrfs reflink tests to generic
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:36:56 -0800
Message-ID: <20151113213656.31124.99827.stgit@birch.djwong.org>
In-Reply-To: <20151113213643.31124.80975.stgit@birch.djwong.org>
References: <20151113213643.31124.80975.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Move the cp --reflink tests from btrfs/ to generic/ since xfs now
supports that ioctl.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/btrfs/026       |   92 -----------------------------------------
 tests/btrfs/026.out   |   16 -------
 tests/btrfs/027       |  109 -------------------------------------------------
 tests/btrfs/027.out   |   25 -----------
 tests/btrfs/028       |   83 -------------------------------------
 tests/btrfs/028.out   |    7 ---
 tests/btrfs/group     |    3 -
 tests/generic/110     |   92 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/110.out |   16 +++++++
 tests/generic/111     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/111.out |   25 +++++++++++
 tests/generic/115     |   83 +++++++++++++++++++++++++++++++++++++
 tests/generic/115.out |    7 +++
 tests/generic/group   |    3 +
 14 files changed, 335 insertions(+), 335 deletions(-)
 delete mode 100755 tests/btrfs/026
 delete mode 100644 tests/btrfs/026.out
 delete mode 100755 tests/btrfs/027
 delete mode 100644 tests/btrfs/027.out
 delete mode 100755 tests/btrfs/028
 delete mode 100644 tests/btrfs/028.out
 create mode 100755 tests/generic/110
 create mode 100644 tests/generic/110.out
 create mode 100755 tests/generic/111
 create mode 100644 tests/generic/111.out
 create mode 100755 tests/generic/115
 create mode 100644 tests/generic/115.out


diff --git a/tests/btrfs/026 b/tests/btrfs/026
deleted file mode 100755
index 7559ca2..0000000
--- a/tests/btrfs/026
+++ /dev/null
@@ -1,92 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 026
-#
-# Tests file clone functionality of btrfs ("reflinks"):
-#   - Reflink a file
-#   - Reflink the reflinked file
-#   - Modify the original file
-#   - Modify the reflinked file
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-#
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. common/rc
-. common/filter
-
-# real QA test starts here
-_supported_fs btrfs
-_supported_os Linux
-
-_require_xfs_io_command "fiemap"
-_require_cp_reflink
-_require_test
-
-TESTDIR1=$TEST_DIR/test-$seq
-rm -rf $TESTDIR1
-mkdir $TESTDIR1
-
-_checksum_files() {
-    for F in original copy1 copy2
-    do
-        md5sum $TESTDIR1/$F | _filter_test_dir
-    done
-}
-
-rm -f $seqres.full
-
-echo "Create the original file and reflink to copy1, copy2"
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original \
-    >> $seqres.full 2>&1
-cp --reflink $TESTDIR1/original $TESTDIR1/copy1
-cp --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
-_verify_reflink $TESTDIR1/original $TESTDIR1/copy1
-_verify_reflink $TESTDIR1/original $TESTDIR1/copy2
-echo "Original md5sums:"
-_checksum_files
-
-echo "Overwrite original file with new data"
-$XFS_IO_PROG -c 'pwrite -S 0x62 0 9000' $TESTDIR1/original \
-    >> $seqres.full 2>&1
-echo "md5sums after overwriting original:"
-_checksum_files
-
-echo "Overwrite copy1 with different new data"
-$XFS_IO_PROG -c 'pwrite -S 0x63 0 9000' $TESTDIR1/copy1 \
-    >> $seqres.full 2>&1
-echo "md5sums after overwriting copy1:"
-_checksum_files
-
-# success, all done
-status=0
-exit
diff --git a/tests/btrfs/026.out b/tests/btrfs/026.out
deleted file mode 100644
index 3b90ff0..0000000
--- a/tests/btrfs/026.out
+++ /dev/null
@@ -1,16 +0,0 @@
-QA output created by 026
-Create the original file and reflink to copy1, copy2
-Original md5sums:
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-026/original
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-026/copy1
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-026/copy2
-Overwrite original file with new data
-md5sums after overwriting original:
-4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-026/original
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-026/copy1
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-026/copy2
-Overwrite copy1 with different new data
-md5sums after overwriting copy1:
-4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-026/original
-e271cd47d9f62ebc96cb4e67ae4d16db  TEST_DIR/test-026/copy1
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-026/copy2
diff --git a/tests/btrfs/027 b/tests/btrfs/027
deleted file mode 100755
index d2b812b..0000000
--- a/tests/btrfs/027
+++ /dev/null
@@ -1,109 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 027
-#
-# Tests file clone functionality of btrfs ("reflinks") on directory
-# trees.
-#   - Create directory and subdirectory, each having one file
-#   - Create 2 recursive reflinked copies of the tree
-#   - Modify the original files
-#   - Modify one of the copies
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. common/rc
-. common/filter
-
-# real QA test starts here
-_supported_fs btrfs
-_supported_os Linux
-
-_require_xfs_io_command "fiemap"
-_require_cp_reflink
-_require_test
-
-TESTDIR1=$TEST_DIR/test-$seq
-rm -rf $TESTDIR1
-mkdir $TESTDIR1
-
-_checksum_files() {
-    for F in original/file1 original/subdir/file2 \
-                 copy1/file1 copy1/subdir/file2 \
-                 copy2/file1 copy2/subdir/file2
-        do
-            md5sum $TESTDIR1/$F | _filter_test_dir
-        done
-}
-
-rm -f $seqres.full
-
-mkdir $TESTDIR1/original
-mkdir $TESTDIR1/original/subdir
-
-echo "Create the original files and reflink dirs"
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original/file1 \
-    >> $seqres.full 2>&1
-$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 11000' \
-    $TESTDIR1/original/subdir/file2 >> $seqres.full 2>&1
-cp --recursive --reflink $TESTDIR1/original $TESTDIR1/copy1
-cp --recursive --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
-
-_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy1/file1
-_verify_reflink $TESTDIR1/original/subdir/file2 \
-    $TESTDIR1/copy1/subdir/file2
-_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy2/file1
-_verify_reflink $TESTDIR1/original/subdir/file2 \
-    $TESTDIR1/copy2/subdir/file2
-
-echo "Original md5sums:"
-_checksum_files
-
-echo "Overwrite original/file1 and original/subdir/file2 with new data"
-$XFS_IO_PROG -c 'pwrite -S 0x63 0 13000' $TESTDIR1/original/file1 \
-    >> $seqres.full 2>&1
-$XFS_IO_PROG -c 'pwrite -S 0x64 5000 1000' \
-    $TESTDIR1/original/subdir/file2 >> $seqres.full 2>&1
-echo "md5sums now:"
-_checksum_files
-
-echo "Overwrite copy1/file1 and copy1/subdir/file2 with new data"
-$XFS_IO_PROG -c 'pwrite -S 0x65 0 9000' $TESTDIR1/copy1/file1 \
-    >> $seqres.full 2>&1
-$XFS_IO_PROG -c 'pwrite -S 0x66 5000 25000' \
-    $TESTDIR1/copy1/subdir/file2 >> $seqres.full 2>&1
-echo "md5sums now:"
-_checksum_files
-
-# success, all done
-status=0
-exit
diff --git a/tests/btrfs/027.out b/tests/btrfs/027.out
deleted file mode 100644
index 7b7e3bb..0000000
--- a/tests/btrfs/027.out
+++ /dev/null
@@ -1,25 +0,0 @@
-QA output created by 027
-Create the original files and reflink dirs
-Original md5sums:
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/original/file1
-ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-027/original/subdir/file2
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy1/file1
-ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-027/copy1/subdir/file2
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy2/file1
-ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-027/copy2/subdir/file2
-Overwrite original/file1 and original/subdir/file2 with new data
-md5sums now:
-260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-027/original/file1
-b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-027/original/subdir/file2
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy1/file1
-ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-027/copy1/subdir/file2
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy2/file1
-ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-027/copy2/subdir/file2
-Overwrite copy1/file1 and copy1/subdir/file2 with new data
-md5sums now:
-260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-027/original/file1
-b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-027/original/subdir/file2
-b20229a003e3985c4b0e6806abcd6642  TEST_DIR/test-027/copy1/file1
-b815b24069db14e0a3a07169fd563e93  TEST_DIR/test-027/copy1/subdir/file2
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy2/file1
-ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-027/copy2/subdir/file2
diff --git a/tests/btrfs/028 b/tests/btrfs/028
deleted file mode 100755
index 7193337..0000000
--- a/tests/btrfs/028
+++ /dev/null
@@ -1,83 +0,0 @@
-#! /bin/bash
-# FS QA Test No. 028
-#
-# Moving and deleting cloned ("reflinked") files on btrfs:
-#   - Create a file and a reflink
-#   - Move both to a directory
-#   - Delete the original (moved) file, check that the copy still exists.
-#
-#-----------------------------------------------------------------------
-# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
-#
-# This program is free software; you can redistribute it and/or
-# modify it under the terms of the GNU General Public License as
-# published by the Free Software Foundation.
-#
-# This program is distributed in the hope that it would be useful,
-# but WITHOUT ANY WARRANTY; without even the implied warranty of
-# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-# GNU General Public License for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program; if not, write the Free Software Foundation,
-# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
-#-----------------------------------------------------------------------
-
-seq=`basename $0`
-seqres=$RESULT_DIR/$seq
-echo "QA output created by $seq"
-
-here=`pwd`
-tmp=/tmp/$$
-status=1    # failure is the default!
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
-_cleanup()
-{
-    cd /
-    rm -f $tmp.*
-}
-
-# get standard environment, filters and checks
-. ./common/rc
-. ./common/filter
-
-# real QA test starts here
-_supported_fs btrfs
-_supported_os Linux
-
-_require_xfs_io_command "fiemap"
-_require_cp_reflink
-_require_test
-
-rm -f $seqres.full
-
-TESTDIR1=$TEST_DIR/test-$seq
-rm -rf $TESTDIR1
-mkdir $TESTDIR1
-
-echo "Create the original files and reflink dirs"
-$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original \
-    >> $seqres.full
-cp --reflink $TESTDIR1/original $TESTDIR1/copy
-
-_verify_reflink $TESTDIR1/original $TESTDIR1/copy
-
-echo "Move orig & reflink copy to subdir and md5sum:"
-mkdir $TESTDIR1/subdir
-mv $TESTDIR1/original $TESTDIR1/subdir/original_moved
-mv $TESTDIR1/copy $TESTDIR1/subdir/copy_moved
-_verify_reflink $TESTDIR1/subdir/original_moved \
-    $TESTDIR1/subdir/copy_moved
-
-md5sum $TESTDIR1/subdir/original_moved | _filter_test_dir
-md5sum $TESTDIR1/subdir/copy_moved | _filter_test_dir
-
-echo "remove orig from subdir and md5sum reflink copy:"
-rm $TESTDIR1/subdir/original_moved
-md5sum $TESTDIR1/subdir/copy_moved | _filter_test_dir
-rm -rf $TESTDIR1/subdir
-
-# success, all done
-status=0
-exit
diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
deleted file mode 100644
index f683fce..0000000
--- a/tests/btrfs/028.out
+++ /dev/null
@@ -1,7 +0,0 @@
-QA output created by 028
-Create the original files and reflink dirs
-Move orig & reflink copy to subdir and md5sum:
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/subdir/original_moved
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/subdir/copy_moved
-remove orig from subdir and md5sum reflink copy:
-42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/subdir/copy_moved
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 7cf7dd7..c5d529f 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -28,9 +28,6 @@
 023 auto
 024 auto quick compress
 025 auto quick send clone
-026 auto quick clone
-027 auto quick clone
-028 auto quick clone
 029 auto quick clone
 030 auto quick send
 031 auto quick subvol clone
diff --git a/tests/generic/110 b/tests/generic/110
new file mode 100755
index 0000000..ec74357
--- /dev/null
+++ b/tests/generic/110
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 110
+#
+# Tests file clone functionality of btrfs ("reflinks"):
+#   - Reflink a file
+#   - Reflink the reflinked file
+#   - Modify the original file
+#   - Modify the reflinked file
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
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
+#
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
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. common/rc
+. common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+_require_test
+
+TESTDIR1=$TEST_DIR/test-$seq
+rm -rf $TESTDIR1
+mkdir $TESTDIR1
+
+_checksum_files() {
+    for F in original copy1 copy2
+    do
+        md5sum $TESTDIR1/$F | _filter_test_dir
+    done
+}
+
+rm -f $seqres.full
+
+echo "Create the original file and reflink to copy1, copy2"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original \
+    >> $seqres.full 2>&1
+cp --reflink $TESTDIR1/original $TESTDIR1/copy1
+cp --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
+_verify_reflink $TESTDIR1/original $TESTDIR1/copy1
+_verify_reflink $TESTDIR1/original $TESTDIR1/copy2
+echo "Original md5sums:"
+_checksum_files
+
+echo "Overwrite original file with new data"
+$XFS_IO_PROG -c 'pwrite -S 0x62 0 9000' $TESTDIR1/original \
+    >> $seqres.full 2>&1
+echo "md5sums after overwriting original:"
+_checksum_files
+
+echo "Overwrite copy1 with different new data"
+$XFS_IO_PROG -c 'pwrite -S 0x63 0 9000' $TESTDIR1/copy1 \
+    >> $seqres.full 2>&1
+echo "md5sums after overwriting copy1:"
+_checksum_files
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/110.out b/tests/generic/110.out
new file mode 100644
index 0000000..e58b9d8
--- /dev/null
+++ b/tests/generic/110.out
@@ -0,0 +1,16 @@
+QA output created by 110
+Create the original file and reflink to copy1, copy2
+Original md5sums:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-110/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-110/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-110/copy2
+Overwrite original file with new data
+md5sums after overwriting original:
+4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-110/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-110/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-110/copy2
+Overwrite copy1 with different new data
+md5sums after overwriting copy1:
+4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-110/original
+e271cd47d9f62ebc96cb4e67ae4d16db  TEST_DIR/test-110/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-110/copy2
diff --git a/tests/generic/111 b/tests/generic/111
new file mode 100755
index 0000000..9da3f40
--- /dev/null
+++ b/tests/generic/111
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 111
+#
+# Tests file clone functionality of btrfs ("reflinks") on directory
+# trees.
+#   - Create directory and subdirectory, each having one file
+#   - Create 2 recursive reflinked copies of the tree
+#   - Modify the original files
+#   - Modify one of the copies
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. common/rc
+. common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+_require_test
+
+TESTDIR1=$TEST_DIR/test-$seq
+rm -rf $TESTDIR1
+mkdir $TESTDIR1
+
+_checksum_files() {
+    for F in original/file1 original/subdir/file2 \
+                 copy1/file1 copy1/subdir/file2 \
+                 copy2/file1 copy2/subdir/file2
+        do
+            md5sum $TESTDIR1/$F | _filter_test_dir
+        done
+}
+
+rm -f $seqres.full
+
+mkdir $TESTDIR1/original
+mkdir $TESTDIR1/original/subdir
+
+echo "Create the original files and reflink dirs"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original/file1 \
+    >> $seqres.full 2>&1
+$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 11000' \
+    $TESTDIR1/original/subdir/file2 >> $seqres.full 2>&1
+cp --recursive --reflink $TESTDIR1/original $TESTDIR1/copy1
+cp --recursive --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
+
+_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy1/file1
+_verify_reflink $TESTDIR1/original/subdir/file2 \
+    $TESTDIR1/copy1/subdir/file2
+_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy2/file1
+_verify_reflink $TESTDIR1/original/subdir/file2 \
+    $TESTDIR1/copy2/subdir/file2
+
+echo "Original md5sums:"
+_checksum_files
+
+echo "Overwrite original/file1 and original/subdir/file2 with new data"
+$XFS_IO_PROG -c 'pwrite -S 0x63 0 13000' $TESTDIR1/original/file1 \
+    >> $seqres.full 2>&1
+$XFS_IO_PROG -c 'pwrite -S 0x64 5000 1000' \
+    $TESTDIR1/original/subdir/file2 >> $seqres.full 2>&1
+echo "md5sums now:"
+_checksum_files
+
+echo "Overwrite copy1/file1 and copy1/subdir/file2 with new data"
+$XFS_IO_PROG -c 'pwrite -S 0x65 0 9000' $TESTDIR1/copy1/file1 \
+    >> $seqres.full 2>&1
+$XFS_IO_PROG -c 'pwrite -S 0x66 5000 25000' \
+    $TESTDIR1/copy1/subdir/file2 >> $seqres.full 2>&1
+echo "md5sums now:"
+_checksum_files
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/111.out b/tests/generic/111.out
new file mode 100644
index 0000000..e410802
--- /dev/null
+++ b/tests/generic/111.out
@@ -0,0 +1,25 @@
+QA output created by 111
+Create the original files and reflink dirs
+Original md5sums:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-111/original/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-111/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-111/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-111/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-111/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-111/copy2/subdir/file2
+Overwrite original/file1 and original/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-111/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-111/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-111/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-111/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-111/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-111/copy2/subdir/file2
+Overwrite copy1/file1 and copy1/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-111/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-111/original/subdir/file2
+b20229a003e3985c4b0e6806abcd6642  TEST_DIR/test-111/copy1/file1
+b815b24069db14e0a3a07169fd563e93  TEST_DIR/test-111/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-111/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-111/copy2/subdir/file2
diff --git a/tests/generic/115 b/tests/generic/115
new file mode 100755
index 0000000..35f0417
--- /dev/null
+++ b/tests/generic/115
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. 115
+#
+# Moving and deleting cloned ("reflinked") files on btrfs:
+#   - Create a file and a reflink
+#   - Move both to a directory
+#   - Delete the original (moved) file, check that the copy still exists.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+
+_require_xfs_io_command "fiemap"
+_require_cp_reflink
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR1=$TEST_DIR/test-$seq
+rm -rf $TESTDIR1
+mkdir $TESTDIR1
+
+echo "Create the original files and reflink dirs"
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original \
+    >> $seqres.full
+cp --reflink $TESTDIR1/original $TESTDIR1/copy
+
+_verify_reflink $TESTDIR1/original $TESTDIR1/copy
+
+echo "Move orig & reflink copy to subdir and md5sum:"
+mkdir $TESTDIR1/subdir
+mv $TESTDIR1/original $TESTDIR1/subdir/original_moved
+mv $TESTDIR1/copy $TESTDIR1/subdir/copy_moved
+_verify_reflink $TESTDIR1/subdir/original_moved \
+    $TESTDIR1/subdir/copy_moved
+
+md5sum $TESTDIR1/subdir/original_moved | _filter_test_dir
+md5sum $TESTDIR1/subdir/copy_moved | _filter_test_dir
+
+echo "remove orig from subdir and md5sum reflink copy:"
+rm $TESTDIR1/subdir/original_moved
+md5sum $TESTDIR1/subdir/copy_moved | _filter_test_dir
+rm -rf $TESTDIR1/subdir
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/115.out b/tests/generic/115.out
new file mode 100644
index 0000000..a532214
--- /dev/null
+++ b/tests/generic/115.out
@@ -0,0 +1,7 @@
+QA output created by 115
+Create the original files and reflink dirs
+Move orig & reflink copy to subdir and md5sum:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-115/subdir/original_moved
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-115/subdir/copy_moved
+remove orig from subdir and md5sum reflink copy:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-115/subdir/copy_moved
diff --git a/tests/generic/group b/tests/generic/group
index 1dd4269..aa31c8b 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -112,9 +112,12 @@
 107 auto quick metadata
 108 auto quick rw
 109 auto metadata dir
+110 auto quick clone
+111 auto quick clone
 112 rw aio auto quick
 113 rw aio auto quick
 114 rw aio auto quick
+115 auto quick clone
 117 attr auto quick
 120 other auto quick
 123 perms auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
