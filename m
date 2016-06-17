Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC67B853F
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:47:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 34240AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:40 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id KRQkCxIiEVY87w7I (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:47:38 -0700 (PDT)
Subject: [PATCH 14/20] xfs: test clearing reflink inode flag
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:47:30 -0700
Message-ID: <146612805032.25024.3244105391915486280.stgit@birch.djwong.org>
In-Reply-To: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
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

Check that xfs_repair can clear the reflink inode flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/872     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/872.out |   20 +++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 114 insertions(+)
 create mode 100755 tests/xfs/872
 create mode 100644 tests/xfs/872.out


diff --git a/tests/xfs/872 b/tests/xfs/872
new file mode 100755
index 0000000..1a13f50
--- /dev/null
+++ b/tests/xfs/872
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 872
+#
+# Create 100 reflinked files, CoW them all, and see if xfs_repair will
+# clear the reflink flag.  There was a buffer handling bug in xfs_repair
+# that (fortunately) triggered asserts in the rmap code when clearing
+# the reflink flag.
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
+    umount $SCRATCH_MNT > /dev/null 2>&1
+    rm -rf $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_cp_reflink
+_require_scratch
+
+rm -f $seqres.full
+
+nr=128 # spanning at least one inode chunk tickles a bug in xfs_repair
+echo "Format filesystem"
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount >> $seqres.full
+
+echo "Create files"
+_pwrite_byte 0x66 0 1 $SCRATCH_MNT/file.0 >> $seqres.full
+seq 1 $nr | while read i; do
+	_cp_reflink $SCRATCH_MNT/file.0 $SCRATCH_MNT/file.$i
+done
+sync
+
+echo "Check files"
+for i in 0 $((nr / 2)) $nr; do
+	md5sum $SCRATCH_MNT/file.$i | _filter_scratch
+	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i | _filter_scratch
+done
+
+echo "CoW all files"
+seq 1 $nr | while read i; do
+	echo m >> $SCRATCH_MNT/file.$i
+done
+
+echo "Repair filesystem"
+_scratch_unmount
+_repair_scratch_fs >> $seqres.full
+_scratch_mount
+
+echo "Check files again"
+for i in 0 $((nr / 2)) $nr; do
+	md5sum $SCRATCH_MNT/file.$i | _filter_scratch
+	$XFS_IO_PROG -c 'lsattr -v' $SCRATCH_MNT/file.$i | _filter_scratch
+done
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/872.out b/tests/xfs/872.out
new file mode 100644
index 0000000..316cb0a
--- /dev/null
+++ b/tests/xfs/872.out
@@ -0,0 +1,20 @@
+QA output created by 872
+Format filesystem
+Create files
+Check files
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
+[reflink] SCRATCH_MNT/file.0 
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.64
+[reflink] SCRATCH_MNT/file.64 
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.128
+[reflink] SCRATCH_MNT/file.128 
+CoW all files
+Repair filesystem
+Check files again
+8fa14cdd754f91cc6554c9e71929cce7  SCRATCH_MNT/file.0
+[] SCRATCH_MNT/file.0 
+0f17fd72b7bbf5bda0ff433e6d1fc118  SCRATCH_MNT/file.64
+[] SCRATCH_MNT/file.64 
+0f17fd72b7bbf5bda0ff433e6d1fc118  SCRATCH_MNT/file.128
+[] SCRATCH_MNT/file.128 
+Done
diff --git a/tests/xfs/group b/tests/xfs/group
index 0f94794..ca36ad6 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -304,3 +304,4 @@
 869 auto quick clone
 870 auto quick clone
 871 auto quick clone
+872 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
