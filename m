Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C1A37CD8
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:29:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F3051304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:36 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id b7U1SCq08HgF2LT4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:29:35 -0700 (PDT)
Subject: [PATCH 11/13] xfs: test getbmapx shared extent reporting
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:29:30 -0700
Message-ID: <147216777074.32641.10368196568223720351.stgit@birch.djwong.org>
In-Reply-To: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
References: <147216769914.32641.55434969009554013.stgit@birch.djwong.org>
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
To: david@fromorbit.com, eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Test that getbmapx returns exact shared extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/896     |   93 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/896.out |   17 ++++++++++
 tests/xfs/group   |    1 +
 3 files changed, 111 insertions(+)
 create mode 100755 tests/xfs/896
 create mode 100644 tests/xfs/896.out


diff --git a/tests/xfs/896 b/tests/xfs/896
new file mode 100755
index 0000000..a0281bd
--- /dev/null
+++ b/tests/xfs/896
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 896
+#
+# Check that GETBMAPX accurately report shared extents.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Oracle, Inc.  All Rights Reserved.
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
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+	cd /
+	rm -rf $tmp.*
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
+_require_scratch_reflink
+_require_xfs_io_command "bmap"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blocks=5
+blksz=65536
+sz=$((blocks * blksz))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "falloc 0 $sz" $testdir/file1 >> $seqres.full
+_pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
+_scratch_cycle_mount
+
+bmap() {
+	$XFS_IO_PROG -c 'bmap -v' $1 | grep '^[[:space:]]*[0-9]*:'
+}
+
+echo "file1 extents and holes"
+bmap $testdir/file1 | grep -v -c hole
+bmap $testdir/file1 | grep -c hole
+
+_reflink_range $testdir/file1 $blksz $testdir/file2 $((blksz * 3)) $blksz >> $seqres.full
+_reflink_range $testdir/file1 $((blksz * 3)) $testdir/file2 $blksz $blksz >> $seqres.full
+_scratch_cycle_mount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+
+echo "file1 extents and holes"
+bmap $testdir/file1 | grep -v -c hole
+bmap $testdir/file1 | grep -c hole
+echo "file2 extents and holes"
+bmap $testdir/file2 | grep -v -c hole
+bmap $testdir/file2 | grep -c hole
+echo "file1 shared extents"
+bmap $testdir/file1 | grep -c '1.....$'
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/896.out b/tests/xfs/896.out
new file mode 100644
index 0000000..63b3a11
--- /dev/null
+++ b/tests/xfs/896.out
@@ -0,0 +1,17 @@
+QA output created by 896
+Format and mount
+Create the original files
+file1 extents and holes
+1
+0
+Compare files
+17af09af790a9b4c79cddf72f6b642cb  SCRATCH_MNT/test-896/file1
+79418df9c55ab7f58781cb7b9e7d5d91  SCRATCH_MNT/test-896/file2
+file1 extents and holes
+5
+0
+file2 extents and holes
+2
+2
+file1 shared extents
+2
diff --git a/tests/xfs/group b/tests/xfs/group
index 6d349dc..5ff35cb 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -331,3 +331,4 @@
 893 auto quick rmap fsmap
 894 auto quick rmap fsmap
 895 auto quick rmap fsmap
+896 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
