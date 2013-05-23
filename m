Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E4BF57F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 11:43:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B3D3F8F807A
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 09:43:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xwHAHOpo8TNf9RoS for
	<xfs@oss.sgi.com>; Thu, 23 May 2013 09:43:34 -0700 (PDT)
Message-ID: <519E4734.40904@redhat.com>
Date: Thu, 23 May 2013 11:43:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: btrfs/309: sparse copy of a directory tree on btrfs
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
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Koen De Wit <koen.de.wit@oracle.com>

# Tests file clone functionality of btrfs ("reflinks") on directory trees.
#   - Create directory and subdirectory, each having one file
#   - Create 2 recursive reflinked copies of the tree
#   - Modify the original files
#   - Modify one of the copies

[sandeen: mostly cosmetic changes]

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Originally submitted as
xfstests: 298: sparse copy of a directory tree on btrfs

diff --git a/tests/btrfs/309 b/tests/btrfs/309
new file mode 100755
index 0000000..b3927ba
--- /dev/null
+++ b/tests/btrfs/309
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. btrfs/309
+#
+# Tests file clone functionality of btrfs ("reflinks") on directory trees.
+#   - Create directory and subdirectory, each having one file
+#   - Create 2 recursive reflinked copies of the tree
+#   - Modify the original files
+#   - Modify one of the copies
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013, Oracle and/or its affiliates.  All Rights Reserved.
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
+_require_xfs_io_fiemap
+_require_cp_reflink
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
+$XFS_IO_PROG -F -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original/file1  >> $seqres.full 2>&1
+$XFS_IO_PROG -F -f -c 'pwrite -S 0x62 0 11000' $TESTDIR1/original/subdir/file2  >> $seqres.full 2>&1
+cp --recursive --reflink $TESTDIR1/original $TESTDIR1/copy1
+cp --recursive --reflink $TESTDIR1/copy1 $TESTDIR1/copy2
+
+_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy1/file1
+_verify_reflink $TESTDIR1/original/subdir/file2 $TESTDIR1/copy1/subdir/file2
+_verify_reflink $TESTDIR1/original/file1 $TESTDIR1/copy2/file1
+_verify_reflink $TESTDIR1/original/subdir/file2 $TESTDIR1/copy2/subdir/file2
+
+echo "Original md5sums:"
+_checksum_files
+
+echo "Overwrite original/file1 and original/subdir/file2 with new data"
+$XFS_IO_PROG -c 'pwrite -S 0x63 0 13000' $TESTDIR1/original/file1  >> $seqres.full 2>&1
+$XFS_IO_PROG -c 'pwrite -S 0x64 5000 1000'  $TESTDIR1/original/subdir/file2 >> $seqres.full 2>&1
+echo "md5sums now:"
+_checksum_files
+
+echo "Overwrite copy1/file1 and copy1/subdir/file2 with new data"
+$XFS_IO_PROG -c 'pwrite -S 0x65 0 9000' $TESTDIR1/copy1/file1  >> $seqres.full 2>&1
+$XFS_IO_PROG -c 'pwrite -S 0x66 5000 25000' $TESTDIR1/copy1/subdir/file2  >> $seqres.full 2>&1
+echo "md5sums now:"
+_checksum_files
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/309.out b/tests/btrfs/309.out
new file mode 100644
index 0000000..93197d8
--- /dev/null
+++ b/tests/btrfs/309.out
@@ -0,0 +1,25 @@
+QA output created by 309
+Create the original files and reflink dirs
+Original md5sums:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-309/original/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-309/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-309/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-309/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-309/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-309/copy2/subdir/file2
+Overwrite original/file1 and original/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-309/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-309/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-309/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-309/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-309/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-309/copy2/subdir/file2
+Overwrite copy1/file1 and copy1/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-309/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-309/original/subdir/file2
+b20229a003e3985c4b0e6806abcd6642  TEST_DIR/test-309/copy1/file1
+b815b24069db14e0a3a07169fd563e93  TEST_DIR/test-309/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-309/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-309/copy2/subdir/file2
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f24628c..a5bd6aa 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -10,3 +10,4 @@
 284 auto
 307 auto quick
 308 auto quick reflink
+309 auto quick reflink

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
