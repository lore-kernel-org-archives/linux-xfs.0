Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 04C397F3F
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 03:37:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 71FBBAC004
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 01:37:21 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id yaw7AbtJcN6TkAwb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 01:37:19 -0800 (PST)
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH RESEND] xfstests: btrfs/027: simple sparse copy testcase for
	btrfs
Date: Fri, 17 Jan 2014 10:36:49 +0100
Message-Id: <1389951409-26029-1-git-send-email-koen.de.wit@oracle.com>
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

Tests file clone functionality of btrfs ("reflinks"):
   - Reflink a file
   - Reflink the reflinked file
   - Modify the original file
   - Modify the reflinked file

[sandeen: add helpers, make several mostly-cosmetic
 changes to the original testcase]

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Originally submitted as test 297, btrfs/308

diff --git a/common/rc b/common/rc
index a585eb5..4157cc4 100644
--- a/common/rc
+++ b/common/rc
@@ -2078,6 +2078,27 @@ _require_ugid_map()
 	fi
 }
 
+_require_cp_reflink()
+{
+       cp --help | grep -q reflink || \
+               _notrun "This test requires a cp with --reflink support."
+}
+
+# Given 2 files, verify that they have the same mapping but different
+# inodes - i.e. an undisturbed reflink
+# Silent if so, make noise if not
+_verify_reflink()
+{
+       # not a hard link or symlink?
+       cmp -s  <(stat -c '%i' $1) <(stat -c '%i' $2) \
+               && echo "$1 and $2 are not reflinks: same inode number"
+
+       # same mapping?
+       diff -u <($XFS_IO_PROG -c "fiemap" $1 | grep -v $1) \
+               <($XFS_IO_PROG -c "fiemap" $2 | grep -v $2) \
+               || echo "$1 and $2 are not reflinks: different extents"
+}
+
 _create_loop_device()
 {
 	file=$1
diff --git a/tests/btrfs/027 b/tests/btrfs/027
new file mode 100644
index 0000000..ec0d5b4
--- /dev/null
+++ b/tests/btrfs/027
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 027
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
diff --git a/tests/btrfs/027.out b/tests/btrfs/027.out
new file mode 100644
index 0000000..13023bf
--- /dev/null
+++ b/tests/btrfs/027.out
@@ -0,0 +1,16 @@
+QA output created by 027
+Create the original file and reflink to copy1, copy2
+Original md5sums:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy2
+Overwrite original file with new data
+md5sums after overwriting original:
+4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-027/original
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy2
+Overwrite copy1 with different new data
+md5sums after overwriting copy1:
+4a847a25439532bf48b68c9e9536ed5b  TEST_DIR/test-027/original
+e271cd47d9f62ebc96cb4e67ae4d16db  TEST_DIR/test-027/copy1
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-027/copy2
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 87e7bca..379f95b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -27,3 +27,4 @@
 022 auto
 023 auto
 024 auto quick
+027 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
