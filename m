Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2AFED7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 11:50:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 169D0304053
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 09:50:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4w8q9oj42ju5amhA for
	<xfs@oss.sgi.com>; Thu, 23 May 2013 09:50:21 -0700 (PDT)
Message-ID: <519E48C4.9080807@redhat.com>
Date: Thu, 23 May 2013 11:50:12 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: btrfs/310: moving and deleting sparse copies on
	btrfs
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
To: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, Koen De Wit <koen.de.wit@oracle.com>

# Moving and deleting cloned ("reflinked") files on btrfs:
#   - Create a file and a reflink
#   - Move both to a directory
#   - Delete the original (moved) file, check that the copy still exists.

[sandeen: mostly cosmetic changes]

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Originally submitted as
xfstests: 299: moving and deleting sparse copies on btrfs

diff --git a/tests/btrfs/310 b/tests/btrfs/310
new file mode 100755
index 0000000..f87e782
--- /dev/null
+++ b/tests/btrfs/310
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. btrfs/310
+#
+# Moving and deleting cloned ("reflinked") files on btrfs:
+#   - Create a file and a reflink
+#   - Move both to a directory
+#   - Delete the original (moved) file, check that the copy still exists.
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
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $TESTDIR1/original >> $seqres.full
+cp --reflink $TESTDIR1/original $TESTDIR1/copy
+
+_verify_reflink $TESTDIR1/original $TESTDIR1/copy
+
+echo "Move orig & reflink copy to subdir and md5sum:"
+mkdir $TESTDIR1/subdir
+mv $TESTDIR1/original $TESTDIR1/subdir/original_moved
+mv $TESTDIR1/copy $TESTDIR1/subdir/copy_moved
+_verify_reflink $TESTDIR1/subdir/original_moved $TESTDIR1/subdir/copy_moved
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
diff --git a/tests/btrfs/310.out b/tests/btrfs/310.out
new file mode 100644
index 0000000..dae889d
--- /dev/null
+++ b/tests/btrfs/310.out
@@ -0,0 +1,7 @@
+QA output created by 310
+Create the original files and reflink dirs
+Move orig & reflink copy to subdir and md5sum:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-310/subdir/original_moved
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-310/subdir/copy_moved
+remove orig from subdir and md5sum reflink copy:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-310/subdir/copy_moved
diff --git a/tests/btrfs/group b/tests/btrfs/group
index a5bd6aa..bd624c4 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -11,3 +11,4 @@
 307 auto quick
 308 auto quick reflink
 309 auto quick reflink
+310 auto quick reflink


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
