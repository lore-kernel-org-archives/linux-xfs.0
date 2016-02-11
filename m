Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A09577F84
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:41:48 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C773AC002
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:48 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 4mC6Atf3fKo6T1Qb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:41:45 -0800 (PST)
Subject: [PATCH 21/32] reflink: test xfs cow behavior when the filesystem
	crashes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:41:42 -0800
Message-ID: <20160211234142.2202.57779.stgit@birch.djwong.org>
In-Reply-To: <20160211233916.2202.40961.stgit@birch.djwong.org>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
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

Use the extent size hint to force leftover CoW reservations then
crash the filesystem to see how recovery works.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/212     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/212.out |   13 +++++++
 tests/xfs/group   |    1 +
 3 files changed, 113 insertions(+)
 create mode 100755 tests/xfs/212
 create mode 100644 tests/xfs/212.out


diff --git a/tests/xfs/212 b/tests/xfs/212
new file mode 100755
index 0000000..4e3bcd4
--- /dev/null
+++ b/tests/xfs/212
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 212
+#
+# Test recovery of "lost" CoW blocks after a crash:
+# - Create two reflinked files.  Set extsz hint on second file.
+# - Dirty one byte on the second file and fsync.
+# - Crash the FS to test recovery.
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
+_require_scratch_reflink
+_require_cp_reflink
+_require_fiemap
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+blksz=65536
+nr=16
+filesize=$((blksz * nr))
+bufnr=2
+bufsize=$((blksz * bufnr))
+
+_require_fs_space $SCRATCH_MNT $((filesize / 1024 * 3 * 5 / 4))
+
+echo "Create the original files"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 -b $bufsize 0 $filesize" $testdir/file2.chk >> $seqres.full
+$XFS_IO_PROG -f -c "extsize $bufsize" $testdir/file2
+_cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+echo "CoW and leave leftovers"
+$XFS_IO_PROG -f -c "extsize" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((filesize - 1)) 1" -c "fsync" $testdir/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 $((filesize - 1)) 1" -c "fsync" $testdir/file2.chk >> $seqres.full
+sync
+
+echo "Crash and recover"
+$XFS_IO_PROG -x -c "shutdown" $testdir/file2 >> $seqres.full
+_scratch_remount
+
+echo "Compare files"
+md5sum $testdir/file1 | _filter_scratch
+md5sum $testdir/file2 | _filter_scratch
+md5sum $testdir/file2.chk | _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/212.out b/tests/xfs/212.out
new file mode 100644
index 0000000..97e8425
--- /dev/null
+++ b/tests/xfs/212.out
@@ -0,0 +1,13 @@
+QA output created by 212
+Format and mount
+Create the original files
+Compare files
+7202826a7791073fe2787f0c94603278  SCRATCH_MNT/test-212/file1
+7202826a7791073fe2787f0c94603278  SCRATCH_MNT/test-212/file2
+7202826a7791073fe2787f0c94603278  SCRATCH_MNT/test-212/file2.chk
+CoW and leave leftovers
+Crash and recover
+Compare files
+7202826a7791073fe2787f0c94603278  SCRATCH_MNT/test-212/file1
+83feff041c88d5c746837552399dc27d  SCRATCH_MNT/test-212/file2
+83feff041c88d5c746837552399dc27d  SCRATCH_MNT/test-212/file2.chk
diff --git a/tests/xfs/group b/tests/xfs/group
index 119e1fd..d4a0d59 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -209,6 +209,7 @@
 209 auto quick clone
 210 auto quick clone
 211 clone_stress
+212 auto quick clone
 216 log metadata auto quick
 217 log metadata auto
 220 auto quota quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
