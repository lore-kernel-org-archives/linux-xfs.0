Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E31B429EAD
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:11:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D3CDB8F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:47 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pH6dO2fidiKXPZ3o (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:45 -0800 (PST)
Subject: [PATCH 07/11] reflink: test ENOSPC when expanding btrees during
	reflink operations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:11:39 -0800
Message-ID: <20151219091139.15320.86780.stgit@birch.djwong.org>
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

See what happens when we ENOSPC while growing a btree on behalf of
some reflink operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/805     |   82 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/805.out |    8 +++++
 tests/xfs/806     |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/806.out |    7 ++++
 tests/xfs/group   |    2 +
 5 files changed, 188 insertions(+)
 create mode 100755 tests/xfs/805
 create mode 100644 tests/xfs/805.out
 create mode 100755 tests/xfs/806
 create mode 100644 tests/xfs/806.out


diff --git a/tests/xfs/805 b/tests/xfs/805
new file mode 100755
index 0000000..17a7743
--- /dev/null
+++ b/tests/xfs/805
@@ -0,0 +1,82 @@
+#! /bin/bash
+# FS QA Test No. 806
+#
+# Try to ENOSPC while expanding the refcntbt by CoWing every block
+# of a file that eats the whole AG.
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
+echo "Format and mount"
+_scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+BLKSZ="$(stat -f "$TESTDIR" -c '%S')"
+
+echo "Create the original files"
+SZ=$((48 * 1048576))
+NR=$((SZ / BLKSZ))
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+_scratch_remount
+
+echo "CoW every other block"
+_pwrite_byte 0x62 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+md5sum "$TESTDIR/file1" | _filter_test_dir
+md5sum "$TESTDIR/file2" | _filter_test_dir
+#filefrag -v "$TESTDIR/file1" "$TESTDIR/file2"
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/805.out b/tests/xfs/805.out
new file mode 100644
index 0000000..d36ab27
--- /dev/null
+++ b/tests/xfs/805.out
@@ -0,0 +1,8 @@
+QA output created by 805
+Format and mount
+Create the original files
+CoW every other block
+Compare files
+673c759fb131ccf3336c4f8c549a497e  /opt/test-805/file1
+dc802351f6717547cbf4c951b294f952  /opt/test-805/file2
+Check scratch fs
diff --git a/tests/xfs/806 b/tests/xfs/806
new file mode 100755
index 0000000..5e96b8a
--- /dev/null
+++ b/tests/xfs/806
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 806
+#
+# Try to ENOSPC while expanding the refcntbt by CoWing every other block
+# of a file that eats the whole AG.
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
+echo "Format and mount"
+_scratch_mkfs -d agsize=$((32 * 1048576)) > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+BLKSZ="$(stat -f -c '%S' "$TESTDIR")"
+
+echo "Create the original files"
+SZ=$((48 * 1048576))
+NR=$((SZ / BLKSZ))
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2" >> "$seqres.full"
+_pwrite_byte 0x61 0 $SZ "$TESTDIR/file2.chk" >> "$seqres.full"
+_scratch_remount
+
+echo "Compare files"
+cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "file1 and file2 do not match"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+echo "CoW every other block"
+seq 1 2 $NR | while read f; do
+	_pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+	_pwrite_byte 0x62 $((f * BLKSZ)) $BLKSZ "$TESTDIR/file2.chk" >> "$seqres.full"
+done
+_scratch_remount
+
+echo "Compare files"
+! cmp -s "$TESTDIR/file1" "$TESTDIR/file2" || echo "file1 and file2 must not match"
+cmp -s "$TESTDIR/file2" "$TESTDIR/file2.chk" || echo "file2 and file2.chk do not match"
+
+echo "Check scratch fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/806.out b/tests/xfs/806.out
new file mode 100644
index 0000000..be89ea0
--- /dev/null
+++ b/tests/xfs/806.out
@@ -0,0 +1,7 @@
+QA output created by 806
+Format and mount
+Create the original files
+Compare files
+CoW every other block
+Compare files
+Check scratch fs
diff --git a/tests/xfs/group b/tests/xfs/group
index 9884329..b654005 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -226,3 +226,5 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+805 auto quick clone
+806 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
