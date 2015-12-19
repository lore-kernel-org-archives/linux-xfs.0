Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AD5729EB1
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:12:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2A2AD30405F
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:09 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pIovPGpNAYYYYGm2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:12:06 -0800 (PST)
Subject: [PATCH 10/11] reflink: test a big CoW operation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:12:00 -0800
Message-ID: <20151219091200.15320.21534.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Test what happens when we send largeish buffers to CoW all at once.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/878     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/878.out |   13 ++++++
 tests/generic/879     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/879.out |   13 ++++++
 tests/generic/group   |    2 +
 5 files changed, 226 insertions(+)
 create mode 100755 tests/generic/878
 create mode 100644 tests/generic/878.out
 create mode 100755 tests/generic/879
 create mode 100644 tests/generic/879.out


diff --git a/tests/generic/878 b/tests/generic/878
new file mode 100755
index 0000000..342a94e
--- /dev/null
+++ b/tests/generic/878
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 878
+#
+# Reflink two large files and CoW them in big chunks.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+BLKSZ=65536
+NR=6400
+BSZ=1280
+
+FREE_BLOCKS=$(stat -f -c '%a' "$TESTDIR")
+REAL_BLKSZ=$(stat -f -c '%S' "$TESTDIR")
+SPACE_NEEDED=$(((BLKSZ * NR * 3) * 5 / 4))
+SPACE_AVAIL=$((FREE_BLOCKS * REAL_BLKSZ))
+test $SPACE_NEEDED -gt $SPACE_AVAIL && _notrun "Not enough space. $SPACE_AVAIL < $SPACE_NEEDED"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/878.out b/tests/generic/878.out
new file mode 100644
index 0000000..0da5baa
--- /dev/null
+++ b/tests/generic/878.out
@@ -0,0 +1,13 @@
+QA output created by 878
+Format and mount
+Create the original files
+Compare files
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-878/file1
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-878/file2
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-878/file2.chk
+CoW and unmount
+Compare files
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-878/file1
+c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-878/file2
+c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-878/file2.chk
+Check for damage
diff --git a/tests/generic/879 b/tests/generic/879
new file mode 100755
index 0000000..83be543
--- /dev/null
+++ b/tests/generic/879
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 879
+#
+# Reflink two large files and DIO CoW them in big chunks.
+#
+# This test is dependent on the system page size, so we cannot use md5 in
+# the golden output; we can only compare to a check file.
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
+    rm -rf "$tmp".* "$TESTDIR"
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+BLKSZ=65536
+NR=6400
+BSZ=1280
+
+FREE_BLOCKS=$(stat -f -c '%a' "$TESTDIR")
+REAL_BLKSZ=$(stat -f -c '%S' "$TESTDIR")
+SPACE_NEEDED=$(((BLKSZ * NR * 3) * 5 / 4))
+SPACE_AVAIL=$((FREE_BLOCKS * REAL_BLKSZ))
+test $SPACE_NEEDED -gt $SPACE_AVAIL && _notrun "Not enough space. $SPACE_AVAIL < $SPACE_NEEDED"
+
+echo "Create the original files"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x61 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "CoW and unmount"
+"$XFS_IO_PROG" -d -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2" >> "$seqres.full"
+"$XFS_IO_PROG" -f -c "pwrite -S 0x63 -b $((BLKSZ * BSZ)) 0 $((BLKSZ * NR))" "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_scratch
+md5sum "$TESTDIR/file2" | _filter_scratch
+md5sum "$TESTDIR/file2.chk" | _filter_scratch
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/879.out b/tests/generic/879.out
new file mode 100644
index 0000000..fc1363a
--- /dev/null
+++ b/tests/generic/879.out
@@ -0,0 +1,13 @@
+QA output created by 879
+Format and mount
+Create the original files
+Compare files
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-879/file1
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-879/file2
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-879/file2.chk
+CoW and unmount
+Compare files
+01768a16d33c9bd21dc67a7fac006ee1  SCRATCH_MNT/test-879/file1
+c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-879/file2
+c835fd53fa27b72511b250d51595c053  SCRATCH_MNT/test-879/file2.chk
+Check for damage
diff --git a/tests/generic/group b/tests/generic/group
index f3e3e2c..68853b4 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -289,3 +289,5 @@
 875 auto quick clone
 876 auto quick clone
 877 auto quick clone
+878 auto quick clone
+879 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
