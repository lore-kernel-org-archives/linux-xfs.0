Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EBBFF7FC8
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 17:42:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BAA388F8033
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:41 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id BWTw1uhCxgzHE8sP (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 15:42:38 -0800 (PST)
Subject: [PATCH 29/32] reflink: test reflink+cow+enospc all at the same time
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 11 Feb 2016 15:42:34 -0800
Message-ID: <20160211234234.2202.62281.stgit@birch.djwong.org>
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

Set up an impossibly small filesystem and try to reflink and rewrite a
file on it to see what happens when we ENOSPC.  Basically
generic/16[67] but with a constrained fs size.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/166     |    6 ++-
 tests/generic/167     |    6 ++-
 tests/generic/333     |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/333.out |    4 ++
 tests/generic/334     |   98 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/334.out |    4 ++
 tests/generic/group   |    2 +
 7 files changed, 217 insertions(+), 2 deletions(-)
 create mode 100755 tests/generic/333
 create mode 100644 tests/generic/333.out
 create mode 100755 tests/generic/334
 create mode 100644 tests/generic/334.out


diff --git a/tests/generic/166 b/tests/generic/166
index 9b177be..a1e4ff4 100755
--- a/tests/generic/166
+++ b/tests/generic/166
@@ -69,7 +69,11 @@ _scratch_remount
 snappy() {
 	n=0
 	while [ ! -e $testdir/finished ]; do
-		_cp_reflink $testdir/file1 $testdir/snap_$n || break
+		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		res=$?
+		echo "$out" | grep -q "No space left" && break
+		test -n "$out" && echo "$out"
+		test $res -ne 0 && break
 		n=$((n + 1))
 	done
 }
diff --git a/tests/generic/167 b/tests/generic/167
index ef8e75b..76969c1 100755
--- a/tests/generic/167
+++ b/tests/generic/167
@@ -68,7 +68,11 @@ _scratch_remount
 snappy() {
 	n=0
 	while [ ! -e $testdir/finished ]; do
-		_cp_reflink $testdir/file1 $testdir/snap_$n || break
+		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		res=$?
+		echo "$out" | grep -q "No space left" && break
+		test -n "$out" && echo "$out"
+		test $res -ne 0 && break
 		n=$((n + 1))
 	done
 }
diff --git a/tests/generic/333 b/tests/generic/333
new file mode 100755
index 0000000..b8a1ea8
--- /dev/null
+++ b/tests/generic/333
@@ -0,0 +1,99 @@
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
+    cd /
+    rm -rf $tmp.*
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
+_require_odirect
+
+echo "Format and mount"
+_scratch_mkfs_sized $((400 * 1048576)) > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+loops=1024
+nr_loops=$((loops - 1))
+blksz=65536
+
+echo "Initialize file"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_scratch_remount
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e $testdir/finished ]; do
+		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		res=$?
+		echo $out | grep -q "No space left" && break
+		test -n "$out" && echo $out
+		test $res -ne 0 && break
+		n=$((n + 1))
+	done
+	touch $testdir/abort
+}
+
+echo "Snapshot a file undergoing directio rewrite"
+snappy &
+seq 1 1000 | while read j; do
+	seq $nr_loops -1 0 | while read i; do
+		out="$(_pwrite_byte 0x63 $((i * blksz)) $blksz -d $testdir/file1 2>&1)"
+		echo $out >> $seqres.full
+		echo $out | grep -q "No space left" && touch $testdir/abort
+		echo $out | grep -qi "error" && touch $testdir/abort
+		test -e $testdir/abort && break
+	done
+	test -e $testdir/abort && break
+done
+touch $testdir/finished
+wait
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/333.out b/tests/generic/333.out
new file mode 100644
index 0000000..3354c98
--- /dev/null
+++ b/tests/generic/333.out
@@ -0,0 +1,4 @@
+QA output created by 333
+Format and mount
+Initialize file
+Snapshot a file undergoing directio rewrite
diff --git a/tests/generic/334 b/tests/generic/334
new file mode 100755
index 0000000..89601be
--- /dev/null
+++ b/tests/generic/334
@@ -0,0 +1,98 @@
+#! /bin/bash
+# FS QA Test No. 334
+#
+# Test for races or FS corruption when trying to hit ENOSPC while writing
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
+    cd /
+    rm -rf $tmp.*
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
+_scratch_mkfs_sized $((400 * 1048576)) > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+testdir=$SCRATCH_MNT/test-$seq
+mkdir $testdir
+
+loops=1024
+nr_loops=$((loops - 1))
+blksz=65536
+
+echo "Initialize file"
+echo > $seqres.full
+_pwrite_byte 0x61 0 $((loops * blksz)) $testdir/file1 >> $seqres.full
+_scratch_remount
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e $testdir/finished ]; do
+		out="$(_cp_reflink $testdir/file1 $testdir/snap_$n 2>&1)"
+		res=$?
+		echo $out | grep -q "No space left" && break
+		test -n "$out" && echo $out
+		test $res -ne 0 && break
+		n=$((n + 1))
+	done
+	touch $testdir/abort
+}
+
+echo "Snapshot a file undergoing buffered rewrite"
+snappy &
+seq 1 1000 | while read j; do
+	seq $nr_loops -1 0 | while read i; do
+		out="$(_pwrite_byte 0x63 $((i * blksz)) $blksz $testdir/file1 2>&1)"
+		echo $out >> $seqres.full
+		echo $out | grep -q "No space left" && touch $testdir/abort
+		echo $out | grep -qi "error" && touch $testdir/abort
+		test -e $testdir/abort && break
+	done
+	test -e $testdir/abort && break
+done
+touch $testdir/finished
+wait
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/334.out b/tests/generic/334.out
new file mode 100644
index 0000000..c2c40fd
--- /dev/null
+++ b/tests/generic/334.out
@@ -0,0 +1,4 @@
+QA output created by 334
+Format and mount
+Initialize file
+Snapshot a file undergoing buffered rewrite
diff --git a/tests/generic/group b/tests/generic/group
index e7ed475..e3c4e8a 100644
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
