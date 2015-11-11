Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 69D7629E34
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:27:50 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E3B4FAC002
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:49 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id lUfzDuN20582kFSE (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:47 -0800 (PST)
Subject: [PATCH 08/11] reflink: test error conditions due to bad inputs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:27:24 -0800
Message-ID: <20151111192724.15056.40330.stgit@birch.djwong.org>
In-Reply-To: <20151111192628.15056.6451.stgit@birch.djwong.org>
References: <20151111192628.15056.6451.stgit@birch.djwong.org>
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
To: hch@infradead.org, david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Check that we can feed bad inputs to reflink and it'll reject them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/839     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/839.out |   19 +++++++++
 tests/generic/846     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/846.out |   19 +++++++++
 tests/generic/group   |    2 +
 5 files changed, 252 insertions(+)
 create mode 100755 tests/generic/839
 create mode 100644 tests/generic/839.out
 create mode 100755 tests/generic/846
 create mode 100644 tests/generic/846.out


diff --git a/tests/generic/839 b/tests/generic/839
new file mode 100755
index 0000000..0b754b1
--- /dev/null
+++ b/tests/generic/839
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 839
+#
+# Check that various invalid reflink scenarios are rejected
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR1"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_reflink
+_require_scratch_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR1="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR1"
+mkdir "$TESTDIR1"
+
+TESTDIR2=$SCRATCH_MNT/test-$seq
+rm -rf "$TESTDIR2"
+mkdir "$TESTDIR2"
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file2" >> "$seqres.full"
+sync
+
+echo "Try cross-device reflink"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
+
+echo "Try unaligned reflink"
+_reflink_range "$TESTDIR1/file1" 37 "$TESTDIR1/file1" 59 23
+
+echo "Try overlapping reflink"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file1" 1 $((BLKSZ * 2))
+
+echo "Try reflink past EOF"
+_reflink_range "$TESTDIR1/file1" $(( (BLKS + 10) * BLKSZ)) "$TESTDIR1/file1" 0 $BLKSZ
+
+chattr +i $TESTDIR1/file1 $TESTDIR1/file2
+echo "Try reflink on immutable files"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_test_dir
+chattr -i $TESTDIR1/file1 $TESTDIR1/file2
+
+echo "Reflink two files"
+_reflink_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ >> "$seqres.full"
+_reflink_range "$TESTDIR2/file1" 0 "$TESTDIR2/file2" 0 $BLKSZ >> "$seqres.full"
+
+lsattr -l $TESTDIR1/ | _filter_test_dir
+lsattr -l $TESTDIR2/ | _filter_scratch
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
index 0000000..d8703b1
--- /dev/null
+++ b/tests/generic/839.out
@@ -0,0 +1,19 @@
+QA output created by 839
+Format and mount
+Create the original files
+Try cross-device reflink
+XFS_IOC_CLONE_RANGE: Invalid cross-device link
+Try unaligned reflink
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try overlapping reflink
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try reflink past EOF
+XFS_IOC_CLONE_RANGE: Invalid argument
+Try reflink on immutable files
+TEST_DIR/test-839/file2: Permission denied
+Reflink two files
+TEST_DIR/test-839/file1          ---
+TEST_DIR/test-839/file2          ---
+SCRATCH_MNT/test-839/file1          ---
+SCRATCH_MNT/test-839/file2          ---
+Check scratch fs
diff --git a/tests/generic/846 b/tests/generic/846
new file mode 100755
index 0000000..e425fbd
--- /dev/null
+++ b/tests/generic/846
@@ -0,0 +1,106 @@
+#! /bin/bash
+# FS QA Test No. 839
+#
+# Check that various invalid dedupe scenarios are rejected
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
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
+    rm -rf "$tmp".* "$TESTDIR1"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_test_dedupe
+_require_scratch_dedupe
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR1="$TEST_DIR/test-$seq"
+rm -rf "$TESTDIR1"
+mkdir "$TESTDIR1"
+
+TESTDIR2=$SCRATCH_MNT/test-$seq
+rm -rf "$TESTDIR2"
+mkdir "$TESTDIR2"
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR1 -c '%S')"
+BLKS=1000
+MARGIN=50
+SZ=$((BLKSZ * BLKS))
+FREE_BLOCKS0=$(stat -f $TESTDIR1 -c '%f')
+NR=4
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR1/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR2/file2" >> "$seqres.full"
+sync
+
+echo "Try cross-device dedupe"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR2/file1" 0 $BLKSZ
+
+echo "Try unaligned dedupe"
+_dedupe_range "$TESTDIR1/file1" 37 "$TESTDIR1/file1" 59 23
+
+echo "Try overlapping dedupe"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file1" 1 $((BLKSZ * 2))
+
+echo "Try dedupe past EOF"
+_dedupe_range "$TESTDIR1/file1" $(( (BLKS + 10) * BLKSZ)) "$TESTDIR1/file1" 0 $BLKSZ
+
+chattr +i $TESTDIR1/file1 $TESTDIR1/file2
+echo "Try dedupe on immutable files"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ 2>&1 | _filter_test_dir
+chattr -i $TESTDIR1/file1 $TESTDIR1/file2
+
+echo "Dedupe two files"
+_dedupe_range "$TESTDIR1/file1" 0 "$TESTDIR1/file2" 0 $BLKSZ >> "$seqres.full"
+_dedupe_range "$TESTDIR2/file1" 0 "$TESTDIR2/file2" 0 $BLKSZ >> "$seqres.full"
+
+lsattr -l $TESTDIR1/ | _filter_test_dir
+lsattr -l $TESTDIR2/ | _filter_scratch
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/846.out b/tests/generic/846.out
new file mode 100644
index 0000000..65a20bf
--- /dev/null
+++ b/tests/generic/846.out
@@ -0,0 +1,19 @@
+QA output created by 846
+Format and mount
+Create the original files
+Try cross-device dedupe
+dedupe: Invalid cross-device link
+Try unaligned dedupe
+dedupe: Invalid argument
+Try overlapping dedupe
+dedupe: Invalid argument
+Try dedupe past EOF
+dedupe: Invalid argument
+Try dedupe on immutable files
+TEST_DIR/test-846/file2: Permission denied
+Dedupe two files
+TEST_DIR/test-846/file1          ---
+TEST_DIR/test-846/file2          ---
+SCRATCH_MNT/test-846/file1          ---
+SCRATCH_MNT/test-846/file2          ---
+Check scratch fs
diff --git a/tests/generic/group b/tests/generic/group
index 9b57872..90f28aa 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -246,3 +246,5 @@
 836 auto quick clone
 837 auto quick clone
 838 auto quick clone
+839 auto quick clone
+846 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
