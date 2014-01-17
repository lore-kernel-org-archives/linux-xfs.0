Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 444727F5E
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 04:10:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F1D1304087
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 02:09:59 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4tQTan2IpQeny5Zn (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 02:09:54 -0800 (PST)
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH RESEND] xfstests: btrfs/028: sparse copy of a directory tree
	on btrfs
Date: Fri, 17 Jan 2014 11:09:45 +0100
Message-Id: <1389953385-26559-1-git-send-email-koen.de.wit@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Koen De Wit <koen.de.wit@oracle.com>, linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

Tests file clone functionality of btrfs ("reflinks") on directory trees.
   - Create directory and subdirectory, each having one file
   - Create 2 recursive reflinked copies of the tree
   - Modify the original files
   - Modify one of the copies

[sandeen: mostly cosmetic changes]

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Originally submitted as test 298, btrfs/309

The functions _require_cp_reflink() and _verify_reflink() in common/rc
have been submitted with btrfs/027

diff --git a/tests/btrfs/028 b/tests/btrfs/028
new file mode 100644
index 0000000..a034008
--- /dev/null
+++ b/tests/btrfs/028
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 028
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
diff --git a/tests/btrfs/028.out b/tests/btrfs/028.out
new file mode 100644
index 0000000..bd078db
--- /dev/null
+++ b/tests/btrfs/028.out
@@ -0,0 +1,25 @@
+QA output created by 028
+Create the original files and reflink dirs
+Original md5sums:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/original/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-028/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-028/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-028/copy2/subdir/file2
+Overwrite original/file1 and original/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-028/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-028/original/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/copy1/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-028/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-028/copy2/subdir/file2
+Overwrite copy1/file1 and copy1/subdir/file2 with new data
+md5sums now:
+260f6785c0537fd12582dcae28a3c1a9  TEST_DIR/test-028/original/file1
+b8d91fb600f6f2191f2ba66665374860  TEST_DIR/test-028/original/subdir/file2
+b20229a003e3985c4b0e6806abcd6642  TEST_DIR/test-028/copy1/file1
+b815b24069db14e0a3a07169fd563e93  TEST_DIR/test-028/copy1/subdir/file2
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-028/copy2/file1
+ca390545f0aedb54b808d6128c56a7dd  TEST_DIR/test-028/copy2/subdir/file2
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 87e7bca..372585d 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -27,3 +27,4 @@
 022 auto
 023 auto
 024 auto quick
+028 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
