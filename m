Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ECE357F6F
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 15:38:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DEE538F8033
	for <xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:22 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dH7AeJiFdtGuWC3U (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Nov 2015 13:38:18 -0800 (PST)
Subject: [PATCH 10/12] reflink: concurrent operations tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 13 Nov 2015 13:37:49 -0800
Message-ID: <20151113213749.31124.34969.stgit@birch.djwong.org>
In-Reply-To: <20151113213643.31124.80975.stgit@birch.djwong.org>
References: <20151113213643.31124.80975.stgit@birch.djwong.org>
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
Cc: fstests@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, tao.peng@primarydata.com, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org

Make sure that running reflink ops while other IO is ongoing doesn't
break the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/161     |   79 +++++++++++++++++++++++++++++++++++++
 tests/generic/161.out |    6 +++
 tests/generic/162     |   95 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/162.out |    7 +++
 tests/generic/163     |   95 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/163.out |    7 +++
 tests/generic/164     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/164.out |    7 +++
 tests/generic/165     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/165.out |    7 +++
 tests/generic/166     |   93 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/166.out |    6 +++
 tests/generic/167     |   93 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/167.out |    6 +++
 tests/generic/168     |   97 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/168.out |    6 +++
 tests/generic/170     |   97 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/170.out |    6 +++
 tests/generic/group   |    9 ++++
 19 files changed, 926 insertions(+)
 create mode 100755 tests/generic/161
 create mode 100644 tests/generic/161.out
 create mode 100755 tests/generic/162
 create mode 100644 tests/generic/162.out
 create mode 100755 tests/generic/163
 create mode 100644 tests/generic/163.out
 create mode 100755 tests/generic/164
 create mode 100644 tests/generic/164.out
 create mode 100755 tests/generic/165
 create mode 100644 tests/generic/165.out
 create mode 100755 tests/generic/166
 create mode 100644 tests/generic/166.out
 create mode 100755 tests/generic/167
 create mode 100644 tests/generic/167.out
 create mode 100755 tests/generic/168
 create mode 100644 tests/generic/168.out
 create mode 100755 tests/generic/170
 create mode 100644 tests/generic/170.out


diff --git a/tests/generic/161 b/tests/generic/161
new file mode 100755
index 0000000..efb137c
--- /dev/null
+++ b/tests/generic/161
@@ -0,0 +1,79 @@
+#! /bin/bash
+# FS QA Test No. 161
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
diff --git a/tests/generic/161.out b/tests/generic/161.out
new file mode 100644
index 0000000..1db11c3
--- /dev/null
+++ b/tests/generic/161.out
@@ -0,0 +1,6 @@
+QA output created by 161
+Format and mount
+Initialize files
+Delete while rewriting
+Check fs
+Done
diff --git a/tests/generic/162 b/tests/generic/162
new file mode 100755
index 0000000..6bd3a33
--- /dev/null
+++ b/tests/generic/162
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 162
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
diff --git a/tests/generic/162.out b/tests/generic/162.out
new file mode 100644
index 0000000..4481f8c
--- /dev/null
+++ b/tests/generic/162.out
@@ -0,0 +1,7 @@
+QA output created by 162
+Format and mount
+Initialize files
+Dedupe and rewrite the file!
+Finished dedupeing
+Check fs
+Done
diff --git a/tests/generic/163 b/tests/generic/163
new file mode 100755
index 0000000..1f5042f
--- /dev/null
+++ b/tests/generic/163
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 163
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
diff --git a/tests/generic/163.out b/tests/generic/163.out
new file mode 100644
index 0000000..2d27d1b
--- /dev/null
+++ b/tests/generic/163.out
@@ -0,0 +1,7 @@
+QA output created by 163
+Format and mount
+Initialize files
+Dedupe and rewrite the file!
+Finished dedupeing
+Check fs
+Done
diff --git a/tests/generic/164 b/tests/generic/164
new file mode 100755
index 0000000..4df953d
--- /dev/null
+++ b/tests/generic/164
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 164
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
diff --git a/tests/generic/164.out b/tests/generic/164.out
new file mode 100644
index 0000000..0b4ed70
--- /dev/null
+++ b/tests/generic/164.out
@@ -0,0 +1,7 @@
+QA output created by 164
+Format and mount
+Initialize files
+Reflink and reread the files!
+Finished reflinking
+Check fs
+Done
diff --git a/tests/generic/165 b/tests/generic/165
new file mode 100755
index 0000000..49187ec
--- /dev/null
+++ b/tests/generic/165
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 165
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
diff --git a/tests/generic/165.out b/tests/generic/165.out
new file mode 100644
index 0000000..a89071d
--- /dev/null
+++ b/tests/generic/165.out
@@ -0,0 +1,7 @@
+QA output created by 165
+Format and mount
+Initialize files
+Reflink and dio reread the files!
+Finished reflinking
+Check fs
+Done
diff --git a/tests/generic/166 b/tests/generic/166
new file mode 100755
index 0000000..71eb2ab
--- /dev/null
+++ b/tests/generic/166
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 166
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
diff --git a/tests/generic/166.out b/tests/generic/166.out
new file mode 100644
index 0000000..a2ba34e
--- /dev/null
+++ b/tests/generic/166.out
@@ -0,0 +1,6 @@
+QA output created by 166
+Format and mount
+Initialize file
+Snapshot a file undergoing directio rewrite
+Check for damage
+Done
diff --git a/tests/generic/167 b/tests/generic/167
new file mode 100755
index 0000000..c4e6ce8
--- /dev/null
+++ b/tests/generic/167
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 167
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
diff --git a/tests/generic/167.out b/tests/generic/167.out
new file mode 100644
index 0000000..7cfb14e
--- /dev/null
+++ b/tests/generic/167.out
@@ -0,0 +1,6 @@
+QA output created by 167
+Format and mount
+Initialize file
+Snapshot a file undergoing buffered rewrite
+Check for damage
+Done
diff --git a/tests/generic/168 b/tests/generic/168
new file mode 100755
index 0000000..414dcb0
--- /dev/null
+++ b/tests/generic/168
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 168
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
diff --git a/tests/generic/168.out b/tests/generic/168.out
new file mode 100644
index 0000000..d0dd08e
--- /dev/null
+++ b/tests/generic/168.out
@@ -0,0 +1,6 @@
+QA output created by 168
+Format and mount
+Initialize files
+Reflink and write the target
+Check for damage
+Done
diff --git a/tests/generic/170 b/tests/generic/170
new file mode 100755
index 0000000..704b646
--- /dev/null
+++ b/tests/generic/170
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 170
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
diff --git a/tests/generic/170.out b/tests/generic/170.out
new file mode 100644
index 0000000..103aaa5
--- /dev/null
+++ b/tests/generic/170.out
@@ -0,0 +1,6 @@
+QA output created by 170
+Format and mount
+Initialize files
+Reflink and dio write the target
+Check for damage
+Done
diff --git a/tests/generic/group b/tests/generic/group
index 0a20421..6ae3105 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -163,7 +163,16 @@
 158 auto quick clone
 159 auto quick clone
 160 auto quick clone
+161 auto quick clone
+162 auto quick clone
+163 auto quick clone
+164 auto quick clone
+165 auto quick clone
+166 auto quick clone
+167 auto quick clone
+168 auto quick clone
 169 rw metadata auto quick
+170 auto quick clone
 184 metadata auto quick
 192 atime auto
 193 metadata auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
