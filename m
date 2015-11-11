Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D13F029E1F
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 13:27:43 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C37D1304043
	for <xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:43 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8JUkEROesRXkJgS3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Nov 2015 11:27:39 -0800 (PST)
Subject: [PATCH 06/11] reflink: concurrent operations tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Nov 2015 11:27:10 -0800
Message-ID: <20151111192710.15056.50137.stgit@birch.djwong.org>
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

Make sure that running reflink ops while other IO is ongoing doesn't
break the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/821     |   97 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/821.out |    6 +++
 tests/generic/822     |   97 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/822.out |    6 +++
 tests/generic/823     |   93 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/823.out |    6 +++
 tests/generic/824     |   93 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/824.out |    6 +++
 tests/generic/825     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/825.out |    7 +++
 tests/generic/826     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/826.out |    7 +++
 tests/generic/827     |   95 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/827.out |    7 +++
 tests/generic/828     |   95 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/828.out |    7 +++
 tests/generic/829     |   79 +++++++++++++++++++++++++++++++++++++
 tests/generic/829.out |    6 +++
 tests/generic/group   |    9 ++++
 19 files changed, 926 insertions(+)
 create mode 100755 tests/generic/821
 create mode 100644 tests/generic/821.out
 create mode 100755 tests/generic/822
 create mode 100644 tests/generic/822.out
 create mode 100755 tests/generic/823
 create mode 100644 tests/generic/823.out
 create mode 100755 tests/generic/824
 create mode 100644 tests/generic/824.out
 create mode 100755 tests/generic/825
 create mode 100644 tests/generic/825.out
 create mode 100755 tests/generic/826
 create mode 100644 tests/generic/826.out
 create mode 100755 tests/generic/827
 create mode 100644 tests/generic/827.out
 create mode 100755 tests/generic/828
 create mode 100644 tests/generic/828.out
 create mode 100755 tests/generic/829
 create mode 100644 tests/generic/829.out


diff --git a/tests/generic/821 b/tests/generic/821
new file mode 100755
index 0000000..d38eff7
--- /dev/null
+++ b/tests/generic/821
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 821
+#
+# Test for races or FS corruption when DIO writing to a file that's also
+# the target of a reflink operation.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=1024
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize files"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_scratch_remount
+
+# Direct I/O overwriter...
+overwrite() {
+	while [ ! -e "$TESTDIR/finished" ]; do
+		seq $nr_loops -1 0 | while read i; do
+			_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ -d "$TESTDIR/file2" >> "$seqres.full"
+		done
+	done
+}
+
+echo "Reflink and dio write the target"
+overwrite &
+seq 1 10 | while read j; do
+	seq 0 $nr_loops | while read i; do
+		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
+				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && exit
+	done
+done
+touch "$TESTDIR/finished"
+wait
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/821.out b/tests/generic/821.out
new file mode 100644
index 0000000..ca6bc53
--- /dev/null
+++ b/tests/generic/821.out
@@ -0,0 +1,6 @@
+QA output created by 821
+Format and mount
+Initialize files
+Reflink and dio write the target
+Check for damage
+Done
diff --git a/tests/generic/822 b/tests/generic/822
new file mode 100755
index 0000000..b37207c
--- /dev/null
+++ b/tests/generic/822
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 822
+#
+# Test for races or FS corruption when writing to a file that's also
+# the target of a reflink operation.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=1024
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize files"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_scratch_remount
+
+# Direct I/O overwriter...
+overwrite() {
+	while [ ! -e "$TESTDIR/finished" ]; do
+		seq $nr_loops -1 0 | while read i; do
+			_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+		done
+	done
+}
+
+echo "Reflink and write the target"
+overwrite &
+seq 1 10 | while read j; do
+	seq 0 $nr_loops | while read i; do
+		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
+				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && exit
+	done
+done
+touch "$TESTDIR/finished"
+wait
+
+echo "Check for damage"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/822.out b/tests/generic/822.out
new file mode 100644
index 0000000..14399ae
--- /dev/null
+++ b/tests/generic/822.out
@@ -0,0 +1,6 @@
+QA output created by 822
+Format and mount
+Initialize files
+Reflink and write the target
+Check for damage
+Done
diff --git a/tests/generic/823 b/tests/generic/823
new file mode 100755
index 0000000..768623d
--- /dev/null
+++ b/tests/generic/823
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 823
+#
+# Test for races or FS corruption when writing to a file that's also
+# the source of a reflink operation.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=1024
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize file"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_scratch_remount
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e "$TESTDIR/finished" ]; do
+		_cp_reflink "$TESTDIR/file1" "$TESTDIR/snap_$n" || break
+		n=$((n + 1))
+	done
+}
+
+echo "Snapshot a file undergoing buffered rewrite"
+snappy &
+seq $nr_loops -1 0 | while read i; do
+	_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+done
+touch $TESTDIR/finished
+wait
+
+echo "Check for damage"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/823.out b/tests/generic/823.out
new file mode 100644
index 0000000..ef3e209
--- /dev/null
+++ b/tests/generic/823.out
@@ -0,0 +1,6 @@
+QA output created by 823
+Format and mount
+Initialize file
+Snapshot a file undergoing buffered rewrite
+Check for damage
+Done
diff --git a/tests/generic/824 b/tests/generic/824
new file mode 100755
index 0000000..7055d33
--- /dev/null
+++ b/tests/generic/824
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 824
+#
+# Test for races or FS corruption when DIO writing to a file that's also
+# the source of a reflink operation.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=1024
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize file"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_scratch_remount
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e "$TESTDIR/finished" ]; do
+		_cp_reflink "$TESTDIR/file1" "$TESTDIR/snap_$n" || break
+		n=$((n + 1))
+	done
+}
+
+echo "Snapshot a file undergoing directio rewrite"
+snappy &
+seq $nr_loops -1 0 | while read i; do
+	_pwrite_byte 0x63 $((i * BLKSZ)) $BLKSZ -d "$TESTDIR/file1" >> "$seqres.full"
+done
+touch $TESTDIR/finished
+wait
+
+echo "Check for damage"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+echo "Done"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/824.out b/tests/generic/824.out
new file mode 100644
index 0000000..0376736
--- /dev/null
+++ b/tests/generic/824.out
@@ -0,0 +1,6 @@
+QA output created by 824
+Format and mount
+Initialize file
+Snapshot a file undergoing directio rewrite
+Check for damage
+Done
diff --git a/tests/generic/825 b/tests/generic/825
new file mode 100755
index 0000000..2f58fb8
--- /dev/null
+++ b/tests/generic/825
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 825
+#
+# Test for races or FS corruption between reflink and direct I/O reading the
+# target file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=512
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize files"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_cp_reflink $TESTDIR/file1 $TESTDIR/file3
+_scratch_remount
+
+fbytes() {
+	egrep -v '(61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61|62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62)'
+}
+
+reader() {
+	while [ ! -e "$TESTDIR/finished" ]; do
+		_read_range "$TESTDIR/file3" 0 $((loops * BLKSZ)) -d | fbytes
+	done
+}
+
+echo "Reflink and dio reread the files!"
+reader &
+for i in `seq 1 2`; do
+	seq $nr_loops -1 0 | while read i; do
+		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
+				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && break
+	done
+	seq $nr_loops -1 0 | while read i; do
+		_reflink_range  "$TESTDIR/file2" $((i * BLKSZ)) \
+				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished reflinking"
+touch "$TESTDIR/finished"
+wait
+
+echo "Check fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Done"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/825.out b/tests/generic/825.out
new file mode 100644
index 0000000..1e2f36c
--- /dev/null
+++ b/tests/generic/825.out
@@ -0,0 +1,7 @@
+QA output created by 825
+Format and mount
+Initialize files
+Reflink and dio reread the files!
+Finished reflinking
+Check fs
+Done
diff --git a/tests/generic/826 b/tests/generic/826
new file mode 100755
index 0000000..d5c8e14
--- /dev/null
+++ b/tests/generic/826
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 826
+#
+# Test for races or FS corruption between reflink and buffered I/O reading the
+# target file.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=512
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize files"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file3"
+_scratch_remount
+
+fbytes() {
+	egrep -v '(61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61|62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62)'
+}
+
+reader() {
+	while [ ! -e "$TESTDIR/finished" ]; do
+		_read_range "$TESTDIR/file3" 0 $((loops * BLKSZ)) | fbytes
+	done
+}
+
+echo "Reflink and reread the files!"
+reader &
+for i in `seq 1 2`; do
+	seq $nr_loops -1 0 | while read i; do
+		_reflink_range  "$TESTDIR/file1" $((i * BLKSZ)) \
+				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && break
+	done
+	seq $nr_loops -1 0 | while read i; do
+		_reflink_range  "$TESTDIR/file2" $((i * BLKSZ)) \
+				"$TESTDIR/file3" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished reflinking"
+touch "$TESTDIR/finished"
+wait
+
+echo "Check fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Done"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/826.out b/tests/generic/826.out
new file mode 100644
index 0000000..144f4bc
--- /dev/null
+++ b/tests/generic/826.out
@@ -0,0 +1,7 @@
+QA output created by 826
+Format and mount
+Initialize files
+Reflink and reread the files!
+Finished reflinking
+Check fs
+Done
diff --git a/tests/generic/827 b/tests/generic/827
new file mode 100755
index 0000000..ce9dbdc
--- /dev/null
+++ b/tests/generic/827
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 827
+#
+# Test for race between dedupe and writing the source file
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+_require_scratch_dedupe
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=512
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize files"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_scratch_remount
+
+overwrite() {
+	while [ ! -e "$TESTDIR/finished" ]; do
+		seq $nr_loops -1 0 | while read i; do
+			_pwrite_byte 0x61 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file1" >> "$seqres.full"
+		done
+	done
+}
+
+echo "Dedupe and rewrite the file!"
+overwrite &
+for i in `seq 1 2`; do
+	seq $nr_loops -1 0 | while read i; do
+		_dedupe_range   "$TESTDIR/file1" $((i * BLKSZ)) \
+				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished dedupeing"
+touch "$TESTDIR/finished"
+wait
+
+echo "Check fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Done"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/827.out b/tests/generic/827.out
new file mode 100644
index 0000000..1b05f59
--- /dev/null
+++ b/tests/generic/827.out
@@ -0,0 +1,7 @@
+QA output created by 827
+Format and mount
+Initialize files
+Dedupe and rewrite the file!
+Finished dedupeing
+Check fs
+Done
diff --git a/tests/generic/828 b/tests/generic/828
new file mode 100755
index 0000000..39c7206
--- /dev/null
+++ b/tests/generic/828
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 828
+#
+# Test for race between dedupe and writing the dest file
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+_require_scratch_dedupe
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=512
+nr_loops=$((loops - 1))
+BLKSZ=65536
+
+echo "Initialize files"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file2" >> "$seqres.full"
+_scratch_remount
+
+overwrite() {
+	while [ ! -e "$TESTDIR/finished" ]; do
+		seq $nr_loops -1 0 | while read i; do
+			_pwrite_byte 0x61 $((i * BLKSZ)) $BLKSZ "$TESTDIR/file2" >> "$seqres.full"
+		done
+	done
+}
+
+echo "Dedupe and rewrite the file!"
+overwrite &
+for i in `seq 1 2`; do
+	seq $nr_loops -1 0 | while read i; do
+		_dedupe_range   "$TESTDIR/file1" $((i * BLKSZ)) \
+				"$TESTDIR/file2" $((i * BLKSZ)) $BLKSZ >> "$seqres.full"
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished dedupeing"
+touch "$TESTDIR/finished"
+wait
+
+echo "Check fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Done"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/828.out b/tests/generic/828.out
new file mode 100644
index 0000000..fb31777
--- /dev/null
+++ b/tests/generic/828.out
@@ -0,0 +1,7 @@
+QA output created by 828
+Format and mount
+Initialize files
+Dedupe and rewrite the file!
+Finished dedupeing
+Check fs
+Done
diff --git a/tests/generic/829 b/tests/generic/829
new file mode 100755
index 0000000..7b5a40e
--- /dev/null
+++ b/tests/generic/829
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 829
+#
+# Test for race between delete a file while rewriting its reflinked twin
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount >> "$seqres.full" 2>&1
+
+TESTDIR="$SCRATCH_MNT/test-$seq"
+rm -rf "$TESTDIR"
+mkdir "$TESTDIR"
+
+loops=4096
+BLKSZ=65536
+
+echo "Initialize files"
+echo > "$seqres.full"
+_pwrite_byte 0x61 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+_cp_reflink "$TESTDIR/file1" "$TESTDIR/file2"
+_scratch_remount
+
+echo "Delete while rewriting"
+rm -rf "$TESTDIR/file1" &
+_pwrite_byte 0x62 0 $((loops * BLKSZ)) "$TESTDIR/file1" >> "$seqres.full"
+wait
+
+echo "Check fs"
+umount "$SCRATCH_MNT"
+_check_scratch_fs
+
+echo "Done"
+# success, all done
+status=0
+exit
diff --git a/tests/generic/829.out b/tests/generic/829.out
new file mode 100644
index 0000000..9cee8ba
--- /dev/null
+++ b/tests/generic/829.out
@@ -0,0 +1,6 @@
+QA output created by 829
+Format and mount
+Initialize files
+Delete while rewriting
+Check fs
+Done
diff --git a/tests/generic/group b/tests/generic/group
index 58c68c8..0c137ea 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -228,5 +228,14 @@
 817 auto quick clone
 818 auto quick clone
 819 auto quick clone
+821 auto quick clone
+822 auto quick clone
+823 auto quick clone
+824 auto quick clone
+825 auto quick clone
+826 auto quick clone
+827 auto quick clone
+828 auto quick clone
+829 auto quick clone
 837 auto quick clone
 838 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
