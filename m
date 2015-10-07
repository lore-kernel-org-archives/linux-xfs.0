Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7F6AC29F2A
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:14:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 61480304039
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:14:14 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 61aEUNyF7DxGb0yw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:14:12 -0700 (PDT)
Subject: [PATCH 09/12] reflink: test error conditions due to bad inputs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:14:04 -0700
Message-ID: <20151007051404.3260.72531.stgit@birch.djwong.org>
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Check that we can feed bad inputs to reflink and it'll reject them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/839     |  122 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/839.out |   30 ++++++++++++
 tests/generic/group   |    1 
 3 files changed, 153 insertions(+)
 create mode 100755 tests/generic/839
 create mode 100644 tests/generic/839.out


diff --git a/tests/generic/839 b/tests/generic/839
new file mode 100755
index 0000000..fe32cfb
--- /dev/null
+++ b/tests/generic/839
@@ -0,0 +1,122 @@
+#! /bin/bash
+# FS QA Test No. 839
+#
+# Check that cross-device reflink and dedupe are rejected
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+    rm -rf $tmp.* $TESTDIR1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_require_test
+_require_scratch
+_require_scratch_reflink
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "dedupe"
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR1=$TEST_DIR/test-$seq
+rm -rf $TESTDIR1
+mkdir $TESTDIR1
+
+TESTDIR2=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR2
+mkdir $TESTDIR2
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
+NR=4
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR1/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR1/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $SZ" $TESTDIR2/file1 >> $seqres.full
+sync
+
+echo "Try cross-device reflink"
+$XFS_IO_PROG -f -c "reflink $TESTDIR1/file1 0 0 $BLKSZ" $TESTDIR2/file1
+echo "Try cross-device dedupe"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR1/file1 0 0 $BLKSZ" $TESTDIR2/file1
+
+echo "Try unaligned reflink"
+$XFS_IO_PROG -f -c "reflink $TESTDIR1/file1 37 59 23" $TESTDIR1/file2
+echo "Try unaligned dedupe"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR1/file1 37 59 23" $TESTDIR1/file2
+
+echo "Try overlapping reflink"
+$XFS_IO_PROG -f -c "reflink $TESTDIR1/file1 0 0 $BLKSZ" $TESTDIR1/file1
+echo "Try overlapping dedupe"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR1/file2 0 0 $BLKSZ" $TESTDIR1/file2
+
+echo "Try reflink past EOF"
+$XFS_IO_PROG -f -c "reflink $TESTDIR1/file1 $(( (BLKS + 1000) * BLKSZ)) 0 $BLKSZ" $TESTDIR1/file1
+echo "Try dedupe past EOF"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR1/file2 $(( (BLKS + 1000) * BLKSZ)) 0 $BLKSZ" $TESTDIR1/file2
+
+chattr +i $TESTDIR1/file1 $TESTDIR1/file2
+echo "Try reflink on immutable files"
+$XFS_IO_PROG -f -c "reflink $TESTDIR1/file1 0 0 $BLKSZ" $TESTDIR1/file2 > $seqres.full
+echo "Try dedupe on immutable files"
+$XFS_IO_PROG -f -c "reflink $TESTDIR1/file1 $BLKSZ $BLKSZ $BLKSZ" $TESTDIR1/file2 > $seqres.full
+chattr -i $TESTDIR1/file1 $TESTDIR1/file2
+
+echo "Reflink two files"
+$XFS_IO_PROG -f -c "reflink $TESTDIR1/file1 0 0 $BLKSZ" $TESTDIR1/file2 > $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR2/file1 0 0 $BLKSZ" $TESTDIR2/file2 > $seqres.full
+echo "Dedupe two files"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR1/file1 $BLKSZ $BLKSZ $BLKSZ" $TESTDIR1/file2 > $seqres.full
+$XFS_IO_PROG -f -c "dedupe $TESTDIR2/file1 $BLKSZ $BLKSZ $BLKSZ" $TESTDIR2/file2 > $seqres.full
+
+lsattr -l $TESTDIR1/ | _filter_test_dir
+lsattr -l $TESTDIR2/ | sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g"
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/839.out b/tests/generic/839.out
new file mode 100644
index 0000000..542a5b3
--- /dev/null
+++ b/tests/generic/839.out
@@ -0,0 +1,30 @@
+QA output created by 839
+Format and mount
+Create the original files
+Try cross-device reflink
+XFS_IOC_CLONE_RANGE: Invalid cross-device link
+Try cross-device dedupe
+dedupe: Invalid cross-device link
+Try unaligned reflink
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try unaligned dedupe
+dedupe: Invalid argument
+Try overlapping reflink
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try overlapping dedupe
+dedupe: Invalid argument
+Try reflink past EOF
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try dedupe past EOF
+dedupe: Invalid argument
+Try reflink on immutable files
+/mnt/test-839/file2: Permission denied
+Try dedupe on immutable files
+/mnt/test-839/file2: Permission denied
+Reflink two files
+Dedupe two files
+TEST_DIR/test-839/file1          ---
+TEST_DIR/test-839/file2          ---
+SCRATCH_MNT/test-839/file1          ---
+SCRATCH_MNT/test-839/file2          ---
+Check scratch fs
diff --git a/tests/generic/group b/tests/generic/group
index 353e23c..daaf23a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -245,3 +245,4 @@
 836 auto quick clone
 837 auto quick clone
 838 auto quick clone
+839 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
