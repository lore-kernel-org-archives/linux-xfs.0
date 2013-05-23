Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED9D87F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 12:06:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CA64130407B
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 10:06:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WEWsrTQMJu093UL0 for
	<xfs@oss.sgi.com>; Thu, 23 May 2013 10:06:33 -0700 (PDT)
Message-ID: <519E4C96.3000901@redhat.com>
Date: Thu, 23 May 2013 12:06:30 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: btrfs/311: sparse copy between different
	filesystems/mountpoints on btrfs
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

From: Koen De Wit <koen.de.wit@oracle.com>

# Check if creating a sparse copy ("reflink") of a file on btrfs
# expectedly fails when it's done between different filesystems or
# different mount points of the same filesystem.
#
# For both situations, these actions are executed:
#    - Copy a file with the reflink=auto option.
#      A normal copy should be created.
#    - Copy a file with the reflink=always option. Should result in error,
#      no file should be created.

[sandeen: mostly cosmetic changes]

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Originally submitted as:
xfstests: 301: sparse copy between different filesystems/mountpoints on btrfs

diff --git a/tests/btrfs/311 b/tests/btrfs/311
new file mode 100755
index 0000000..9256e7a
--- /dev/null
+++ b/tests/btrfs/311
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 311
+#
+# Check if creating a sparse copy ("reflink") of a file on btrfs
+# expectedly fails when it's done between different filesystems or
+# different mount points of the same filesystem.
+#
+# For both situations, these actions are executed:
+#    - Copy a file with the reflink=auto option.
+#      A normal copy should be created.
+#    - Copy a file with the reflink=always option. Should result in error,
+#      no file should be created.
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
+    umount $SCRATCH_MNT &>/dev/null
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
+_require_scratch
+_require_cp_reflink
+
+SOURCE_DIR=$TEST_DIR/test-$seq
+CROSS_DEV_DIR=$SCRATCH_MNT/test-$seq
+# mount point & target for twice-mounted device
+TEST_DIR2=$TEST_DIR/mount2
+DUAL_MOUNT_DIR=$SCRATCH_MNT/test-bis-$seq
+
+rm -rf $SOURCE_DIR
+mkdir $SOURCE_DIR
+
+rm -f $seqres.full
+
+_scratch_mkfs
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $SOURCE_DIR/original >> $seqres.fll
+
+_filter_testdirs()
+{
+	_filter_test_dir | _filter_scratch
+}
+
+_create_reflinks_to()
+{
+    # auto reflink, should fall back to non-reflink
+    rm -rf $1; mkdir $1
+    echo "reflink=auto:"
+    cp --reflink=auto $SOURCE_DIR/original $1/copy
+    md5sum $SOURCE_DIR/original | _filter_testdirs
+    md5sum $1/copy | _filter_testdirs
+
+    # always reflink, should fail outright
+    rm -rf $1; mkdir $1
+    echo "reflink=always:"
+    cp --reflink=always $SOURCE_DIR/original $1/copyfail 2>&1 | _filter_testdirs
+
+    # The failed target actually gets created by cp:
+    ls $1/copyfail | _filter_testdirs
+}
+
+echo "test reflinks across different devices"
+_scratch_mount
+_create_reflinks_to $CROSS_DEV_DIR
+_scratch_unmount
+
+echo "test reflinks across different mountpoints of same device"
+mount $TEST_DEV $SCRATCH_MNT || _fail "Couldn't double-mount $TEST_DEV"
+_create_reflinks_to $DUAL_MOUNT_DIR
+umount $SCRATCH_MNT
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/311.out b/tests/btrfs/311.out
new file mode 100644
index 0000000..210727b
--- /dev/null
+++ b/tests/btrfs/311.out
@@ -0,0 +1,15 @@
+QA output created by 311
+test reflinks across different devices
+reflink=auto:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-311/original
+42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-311/copy
+reflink=always:
+cp: failed to clone `SCRATCH_MNT/test-311/copyfail': Invalid cross-device link
+SCRATCH_MNT/test-311/copyfail
+test reflinks across different mountpoints of same device
+reflink=auto:
+42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-311/original
+42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-bis-311/copy
+reflink=always:
+cp: failed to clone `SCRATCH_MNT/test-bis-311/copyfail': Invalid cross-device link
+SCRATCH_MNT/test-bis-311/copyfail
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bd624c4..c897118 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -12,3 +12,4 @@
 308 auto quick reflink
 309 auto quick reflink
 310 auto quick reflink
+311 auto quick reflink

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
