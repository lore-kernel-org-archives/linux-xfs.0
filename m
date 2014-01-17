Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 504957F5F
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 04:41:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BF6ECAC003
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 02:41:58 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XzmSpeSROrdZ8SZE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 02:41:57 -0800 (PST)
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH RESEND] xfstests: btrfs/029: moving and deleting sparse copies
	on btrfs
Date: Fri, 17 Jan 2014 11:41:08 +0100
Message-Id: <1389955268-27021-1-git-send-email-koen.de.wit@oracle.com>
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

Moving and deleting cloned ("reflinked") files on btrfs:
   - Create a file and a reflink
   - Move both to a directory
   - Delete the original (moved) file, check that the copy still exists.

[sandeen: mostly cosmetic changes]

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Originally submitted as test 299, btrfs/310

The functions _require_cp_reflink() and _verify_reflink() in common/rc
have been submitted with btrfs/027

diff --git a/tests/btrfs/029 b/tests/btrfs/029
new file mode 100644
index 0000000..7740d8f
--- /dev/null
+++ b/tests/btrfs/029
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test No. 029
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
+_require_xfs_io_fiemap
+_require_cp_reflink
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
diff --git a/tests/btrfs/029.out b/tests/btrfs/029.out
new file mode 100644
index 0000000..94e5808
--- /dev/null
+++ b/tests/btrfs/029.out
@@ -0,0 +1,7 @@
+QA output created by 029
+Create the original files and reflink dirs
+Move orig & reflink copy to subdir and md5sum:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/subdir/original_moved
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/subdir/copy_moved
+remove orig from subdir and md5sum reflink copy:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/subdir/copy_moved
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 372585d..9fcd15d 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -28,3 +28,4 @@
 023 auto
 024 auto quick
 028 auto quick
+029 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
