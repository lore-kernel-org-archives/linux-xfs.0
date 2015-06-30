Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 135EB7F51
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 23:15:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BFB59304043
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 21:15:45 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id cA9cRu1lkFNSIN2t (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 21:15:42 -0700 (PDT)
Subject: [PATCH 02/11] move btrfs reflink tests to generic
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 21:15:34 -0700
Message-ID: <20150630041534.2476.92290.stgit@birch.djwong.org>
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
 tests/generic/800     |   92 +++++++++++++++++++++++++++++++++++++++++
 tests/generic/800.out |   16 +++++++
 tests/generic/801     |  109 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |   25 +++++++++++
 tests/generic/802     |   83 +++++++++++++++++++++++++++++++++++++
 tests/generic/802.out |    7 +++
 tests/generic/group   |    3 +
 14 files changed, 335 insertions(+), 335 deletions(-)
 delete mode 100755 tests/btrfs/026
 delete mode 100644 tests/btrfs/026.out
 delete mode 100755 tests/btrfs/027
 delete mode 100644 tests/btrfs/027.out
 delete mode 100755 tests/btrfs/028
 delete mode 100644 tests/btrfs/028.out
 create mode 100755 tests/generic/800
 create mode 100644 tests/generic/800.out
 create mode 100755 tests/generic/801
 create mode 100644 tests/generic/801.out
 create mode 100755 tests/generic/802
 create mode 100644 tests/generic/802.out


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
index ffe18bf..f69aa6e 100644
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
diff --git a/tests/generic/800 b/tests/generic/800
new file mode 100755
index 0000000..a71f11a
--- /dev/null
+++ b/tests/generic/800
@@ -0,0 +1,92 @@
+#! /bin/bash
+# FS QA Test No. 800
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
diff --git a/tests/generic/800.out b/tests/generic/800.out
new file mode 100644
index 0000000..6978d71
--- /dev/null
+++ b/tests/generic/800.out
@@ -0,0 +1,16 @@
+QA output created by 800
+Create the original file and reflink to copy1, copy2
+Original md5sums:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-800/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-800/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-800/copy2
+Overwrite original file with new data
+md5sums after overwriting original:
+4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-800/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-800/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-800/copy2
+Overwrite copy1 with different new data
+md5sums after overwriting copy1:
+4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-800/original
+e271cd47d9f62ebc96cb4e67ae4d16db  TEST_DIR/test-800/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-800/copy2
diff --git a/tests/generic/801 b/tests/generic/801
new file mode 100755
index 0000000..b21c44b
--- /dev/null
+++ b/tests/generic/801
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. 801
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
diff --git a/tests/generic/801.out b/tests/generic/801.out
new file mode 100644
index 0000000..b8225cc
--- /dev/null
+++ b/tests/generic/801.out
@@ -0,0 +1,25 @@
+QA output created by 801
+Create the original files and reflink dirs
+Original md5sums:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-801/original/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-801/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-801/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-801/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-801/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-801/copy2/subdir/file2
+Overwrite original/file1 and original/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-801/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-801/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-801/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-801/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-801/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-801/copy2/subdir/file2
+Overwrite copy1/file1 and copy1/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-801/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-801/original/subdir/file2
+b20229a003e3985c4b0e6806abcd6642  TEST_DIR/test-801/copy1/file1
+b815b24069db14e0a3a07169fd563e93  TEST_DIR/test-801/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-801/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-801/copy2/subdir/file2
diff --git a/tests/generic/802 b/tests/generic/802
new file mode 100755
index 0000000..afd8513
--- /dev/null
+++ b/tests/generic/802
@@ -0,0 +1,83 @@
+#! /bin/bash
+# FS QA Test No. 802
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
diff --git a/tests/generic/802.out b/tests/generic/802.out
new file mode 100644
index 0000000..c20e16e
--- /dev/null
+++ b/tests/generic/802.out
@@ -0,0 +1,7 @@
+QA output created by 802
+Create the original files and reflink dirs
+Move orig & reflink copy to subdir and md5sum:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-802/subdir/original_moved
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-802/subdir/copy_moved
+remove orig from subdir and md5sum reflink copy:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-802/subdir/copy_moved
diff --git a/tests/generic/group b/tests/generic/group
index 0c8964c..433ac30 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -194,3 +194,6 @@
 323 auto aio stress
 324 auto fsr quick
 325 auto quick data log
+800 auto quick clone
+801 auto quick clone
+802 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
