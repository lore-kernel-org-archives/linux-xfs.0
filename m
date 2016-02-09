Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 849BD29E21
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 19:14:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 600C88F8033
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 17:14:21 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id uDAtv2WRbYfclzUx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 17:14:18 -0800 (PST)
Subject: [PATCH 23/23] reflink: test reflink+cow+enospc all at the same time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 08 Feb 2016 17:14:14 -0800
Message-ID: <20160209011414.23099.38917.stgit@birch.djwong.org>
In-Reply-To: <20160209011145.23099.95354.stgit@birch.djwong.org>
References: <20160209011145.23099.95354.stgit@birch.djwong.org>
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

Set up an impossibly small filesystem and try to reflink and rewrite a
file on it to see what happens when we ENOSPC.  Basically
generic/16[67] but with a constrained fs size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/166     |    6 ++-
 tests/generic/167     |    6 ++-
 tests/generic/333     |  104 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/333.out |    6 +++
 tests/generic/334     |  104 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/334.out |    6 +++
 tests/generic/group   |    2 +
 7 files changed, 232 insertions(+), 2 deletions(-)
 create mode 100755 tests/generic/333
 create mode 100644 tests/generic/333.out
 create mode 100755 tests/generic/334
 create mode 100644 tests/generic/334.out


diff --git a/tests/generic/166 b/tests/generic/166
index 2c2ff4e..30d76a0 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -69,7 +69,11 @@ _scratch_remount
 snappy() {
 	n=0
 	while [ ! -e "$testdir/finished" ]; do
-		_cp_reflink "$testdir/file1" "$testdir/snap_$n" || break
+		out="$(_cp_reflink "$testdir/file1" "$testdir/snap_$n" 2>&1)"
+		res=$?
+		echo "$out" | grep -q "No space left" && break
+		test -n "$out" && echo "$out"
+		test $res -ne 0 && break
 		n=$((n + 1))
 	done
 }
diff --git a/tests/generic/167 b/tests/generic/167
index b80b481..5198a81 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -69,7 +69,11 @@ _scratch_remount
 snappy() {
 	n=0
 	while [ ! -e "$testdir/finished" ]; do
-		_cp_reflink "$testdir/file1" "$testdir/snap_$n" || break
+		out="$(_cp_reflink "$testdir/file1" "$testdir/snap_$n" 2>&1)"
+		res=$?
+		echo "$out" | grep -q "No space left" && break
+		test -n "$out" && echo "$out"
+		test $res -ne 0 && break
 		n=$((n + 1))
 	done
 }
diff --git a/tests/generic/333 b/tests/generic/333
new file mode 100755
index 0000000..4ca7803
--- /dev/null
+++ b/tests/generic/333
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 333
+#
+# Test for races or FS corruption when trying to hit ENOSPC while DIO writing
+# to a file that's also the source of a reflink operation.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".*
+    wait
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
+echo "Format and mount"
+_scratch_mkfs_sized $((400 * 1048576)) > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+
+loops=1024
+nr_loops=$((loops - 1))
+blksz=65536
+
+echo "Initialize file"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_scratch_remount
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e "$testdir/finished" ]; do
+		out="$(_cp_reflink "$testdir/file1" "$testdir/snap_$n" 2>&1)"
+		res=$?
+		echo "$out" | grep -q "No space left" && break
+		test -n "$out" && echo "$out"
+		test $res -ne 0 && break
+		n=$((n + 1))
+	done
+	touch "$testdir/abort"
+}
+
+echo "Snapshot a file undergoing directio rewrite"
+snappy &
+seq 1 1000 | while read i; do
+	seq $nr_loops -1 0 | while read i; do
+		out="$(_pwrite_byte 0x63 $((i * blksz)) $blksz -d "$testdir/file1" 2>&1)"
+		echo "$out" >> "$seqres.full"
+		echo "$out" | grep -q "No space left" && touch "$testdir/abort"
+		echo "$out" | grep -qi "error" && touch "$testdir/abort"
+		test -e "$testdir/abort" && break
+	done
+	test -e "$testdir/abort" && break
+done
+touch "$testdir/finished"
+wait
+
+echo "Check for damage"
+_scratch_unmount
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/333.out b/tests/generic/333.out
new file mode 100644
index 0000000..501f2d6
--- /dev/null
+++ b/tests/generic/333.out
@@ -0,0 +1,6 @@
+QA output created by 333
+Format and mount
+Initialize file
+Snapshot a file undergoing directio rewrite
+Check for damage
+Done
diff --git a/tests/generic/334 b/tests/generic/334
new file mode 100755
index 0000000..a246711
--- /dev/null
+++ b/tests/generic/334
@@ -0,0 +1,104 @@
+#! /bin/bash
+# FS QA Test No. 334
+#
+# Test for races or FS corruption when trying to hit ENOSPC while DIO writing
+# to a file that's also the source of a reflink operation.
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
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 7 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".*
+    wait
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
+echo "Format and mount"
+_scratch_mkfs_sized $((400 * 1048576)) > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+rm -rf "$testdir"
+mkdir "$testdir"
+
+loops=1024
+nr_loops=$((loops - 1))
+blksz=65536
+
+echo "Initialize file"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * blksz)) "$testdir/file1" >> "$seqres.full"
+_scratch_remount
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e "$testdir/finished" ]; do
+		out="$(_cp_reflink "$testdir/file1" "$testdir/snap_$n" 2>&1)"
+		res=$?
+		echo "$out" | grep -q "No space left" && break
+		test -n "$out" && echo "$out"
+		test $res -ne 0 && break
+		n=$((n + 1))
+	done
+	touch "$testdir/abort"
+}
+
+echo "Snapshot a file undergoing buffered rewrite"
+snappy &
+seq 1 1000 | while read i; do
+	seq $nr_loops -1 0 | while read i; do
+		out="$(_pwrite_byte 0x63 $((i * blksz)) $blksz "$testdir/file1" 2>&1)"
+		echo "$out" >> "$seqres.full"
+		echo "$out" | grep -q "No space left" && touch "$testdir/abort"
+		echo "$out" | grep -qi "error" && touch "$testdir/abort"
+		test -e "$testdir/abort" && break
+	done
+	test -e "$testdir/abort" && break
+done
+touch "$testdir/finished"
+wait
+
+echo "Check for damage"
+_scratch_unmount
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/334.out b/tests/generic/334.out
new file mode 100644
index 0000000..c196ff1
--- /dev/null
+++ b/tests/generic/334.out
@@ -0,0 +1,6 @@
+QA output created by 334
+Format and mount
+Initialize file
+Snapshot a file undergoing buffered rewrite
+Check for damage
+Done
diff --git a/tests/generic/group b/tests/generic/group
index b5ae5ad..a23ffc9 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -335,3 +335,5 @@
 330 auto quick clone
 331 auto quick clone
 332 auto quick clone
+333 auto quick clone
+334 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
