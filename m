Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0125529EFE
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:14:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5487304039
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:14:00 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gs8rOgHAhYa1qDHz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:13:56 -0700 (PDT)
Subject: [PATCH 07/12] reflink: concurrent operations tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:13:51 -0700
Message-ID: <20151007051351.3260.25873.stgit@birch.djwong.org>
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

Make sure that running reflink ops while other IO is ongoing doesn't
break the filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/821     |   96 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/821.out |    6 +++
 tests/generic/822     |   96 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/822.out |    6 +++
 tests/generic/823     |   94 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/823.out |    6 +++
 tests/generic/824     |   95 +++++++++++++++++++++++++++++++++++++++++++
 tests/generic/824.out |    6 +++
 tests/generic/825     |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/825.out |    7 +++
 tests/generic/826     |  108 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/826.out |    7 +++
 tests/generic/827     |   98 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/827.out |    7 +++
 tests/generic/828     |   98 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/828.out |    7 +++
 tests/generic/829     |   84 ++++++++++++++++++++++++++++++++++++++
 tests/generic/829.out |    6 +++
 tests/generic/group   |    9 ++++
 19 files changed, 944 insertions(+)
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
index 0000000..77393cb
--- /dev/null
+++ b/tests/generic/821
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 821
+#
+# Test for race between direct I/O and reflink
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=1024
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize files"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((loops * iosize))" $TESTDIR/file2 >> $seqres.full
+
+# Direct I/O overwriter...
+overwrite() {
+	while [ ! -e $TESTDIR/finished ]; do
+		dd if=/dev/zero of=$TESTDIR/file2 oflag=direct bs=$iosize count=$loops conv=notrunc 2> /dev/null
+	done
+}
+
+echo "Reflink and dio write the target"
+overwrite &
+start=`expr $loops - 1`
+for i in `seq $start -1 0`
+do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file2 >> $seqres.full
+	[ $? -ne 0 ] && exit
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
index 0000000..6ee7a8c
--- /dev/null
+++ b/tests/generic/822
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 822
+#
+# Test for race between buffered I/O and reflink
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=1024
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize file"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((loops * iosize))" $TESTDIR/file2 >> $seqres.full
+
+# Buffered I/O overwriter...
+overwrite() {
+	while [ ! -e $TESTDIR/finished ]; do
+		dd if=/dev/zero of=$TESTDIR/file2 bs=$iosize count=$loops conv=notrunc 2> /dev/null
+	done
+}
+
+echo "reflink while overwriting target"
+overwrite &
+start=`expr $loops - 1`
+for i in `seq $start -1 0`
+do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file2 >> $seqres.full
+	[ $? -ne 0 ] && exit
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
diff --git a/tests/generic/822.out b/tests/generic/822.out
new file mode 100644
index 0000000..4c86f97
--- /dev/null
+++ b/tests/generic/822.out
@@ -0,0 +1,6 @@
+QA output created by 822
+Format and mount
+Initialize file
+reflink while overwriting target
+Check for damage
+Done
diff --git a/tests/generic/823 b/tests/generic/823
new file mode 100755
index 0000000..bf3a712
--- /dev/null
+++ b/tests/generic/823
@@ -0,0 +1,94 @@
+#! /bin/bash
+# FS QA Test No. 823
+#
+# Test for race between buffered I/O while creating reflink snapshots
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=1024
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize file"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e $TESTDIR/finished ]; do
+		cp --reflink=always $TESTDIR/file1 $TESTDIR/snap_$n || break
+		n=$((n + 1))
+	done
+}
+
+echo "Snapshot a file undergoing buffered rewrite"
+snappy &
+for i in `seq 1 5`; do
+	dd if=/dev/zero of=$TESTDIR/file1 bs=$iosize count=$loops conv=notrunc 2> /dev/null
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
index 0000000..38737c6
--- /dev/null
+++ b/tests/generic/824
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 824
+#
+# Test for race between direct I/O while creating reflink snapshots
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
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=1024
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize file"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+
+# Snapshot creator...
+snappy() {
+	n=0
+	while [ ! -e $TESTDIR/finished ]; do
+		cp --reflink=always $TESTDIR/file1 $TESTDIR/snap_$n || break
+		n=$((n + 1))
+	done
+}
+
+echo "Snapshot a file while directio rewriting it"
+snappy &
+touch $TESTDIR/running
+for i in `seq 1 5`; do
+	dd if=/dev/zero of=$TESTDIR/file1 oflag=direct bs=$iosize count=$loops conv=notrunc 2> /dev/null
+done
+mv $TESTDIR/running $TESTDIR/finished
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
index 0000000..27c9bc0
--- /dev/null
+++ b/tests/generic/824.out
@@ -0,0 +1,6 @@
+QA output created by 824
+Format and mount
+Initialize file
+Snapshot a file while directio rewriting it
+Check for damage
+Done
diff --git a/tests/generic/825 b/tests/generic/825
new file mode 100755
index 0000000..476527a
--- /dev/null
+++ b/tests/generic/825
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 825
+#
+# Test for race between reflink and direct I/O reading the target file
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
+
+# real QA test starts here
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=512
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize files"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((loops * iosize))" $TESTDIR/file2 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+sync
+
+reader() {
+	while [ ! -e $TESTDIR/finished ]; do
+		dd if=$TESTDIR/file3 iflag=direct 2> /dev/null | od -tx1 -Ax | while read addr rest; do
+				test -n "$rest" && echo "$rest"
+		done | egrep -v '(61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61|62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62)'
+	done
+}
+
+echo "Reflink and dio reread the files!"
+reader &
+for i in `seq 1 2`; do
+	start=`expr $loops - 1`
+	for i in `seq $start -1 0`
+	do
+		$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file3 >> $seqres.full
+		[ $? -ne 0 ] && break
+	done
+	start=`expr $loops - 1`
+	for i in `seq $start -1 0`
+	do
+		$XFS_IO_PROG -f -c "reflink $TESTDIR/file2 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file3 >> $seqres.full
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished reflinking"
+touch $TESTDIR/finished
+wait
+
+echo "Check fs"
+umount $SCRATCH_MNT
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
index 0000000..1739778
--- /dev/null
+++ b/tests/generic/826
@@ -0,0 +1,108 @@
+#! /bin/bash
+# FS QA Test No. 826
+#
+# Test for race between reflink and buffered I/O reading the target file
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
+
+# real QA test starts here
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=512
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize files"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((loops * iosize))" $TESTDIR/file2 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file3
+sync
+
+reader() {
+	while [ ! -e $TESTDIR/finished ]; do
+		cat $TESTDIR/file3 | od -tx1 -Ax | while read addr rest; do
+				test -n "$rest" && echo "$rest"
+		done | egrep -v '(61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61|62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62)'
+	done
+}
+
+echo "Reflink and reread the files!"
+reader &
+for i in `seq 1 2`; do
+	start=`expr $loops - 1`
+	for i in `seq $start -1 0`
+	do
+		$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file3 >> $seqres.full
+		[ $? -ne 0 ] && break
+	done
+	start=`expr $loops - 1`
+	for i in `seq $start -1 0`
+	do
+		$XFS_IO_PROG -f -c "reflink $TESTDIR/file2 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file3 >> $seqres.full
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished reflinking"
+touch $TESTDIR/finished
+wait
+
+echo "Check fs"
+umount $SCRATCH_MNT
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
index 0000000..fa2ba2e
--- /dev/null
+++ b/tests/generic/827
@@ -0,0 +1,98 @@
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
+
+# real QA test starts here
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=512
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize files"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file2 >> $seqres.full
+sync
+
+overwrite() {
+	while [ ! -e $TESTDIR/finished ]; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+	done
+}
+
+echo "Dedupe and rewrite the file!"
+overwrite &
+for i in `seq 1 2`; do
+	start=`expr $loops - 1`
+	for i in `seq $start -1 0`
+	do
+		$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file2 >> $seqres.full
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished dedupeing"
+touch $TESTDIR/finished
+wait
+
+echo "Check fs"
+umount $SCRATCH_MNT
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
index 0000000..43b1682
--- /dev/null
+++ b/tests/generic/828
@@ -0,0 +1,98 @@
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
+
+# real QA test starts here
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=512
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize files"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file2 >> $seqres.full
+sync
+
+overwrite() {
+	while [ ! -e $TESTDIR/finished ]; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file2 >> $seqres.full
+	done
+}
+
+echo "Dedupe and rewrite the file!"
+overwrite &
+for i in `seq 1 2`; do
+	start=`expr $loops - 1`
+	for i in `seq $start -1 0`
+	do
+		$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $((i * iosize)) $((i * iosize)) $iosize" $TESTDIR/file2 >> $seqres.full
+		[ $? -ne 0 ] && break
+	done
+done
+echo "Finished dedupeing"
+touch $TESTDIR/finished
+wait
+
+echo "Check fs"
+umount $SCRATCH_MNT
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
index 0000000..76fe937
--- /dev/null
+++ b/tests/generic/829
@@ -0,0 +1,84 @@
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
+
+# real QA test starts here
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_scratch_reflink
+_require_cp_reflink
+_require_xfs_io_command "reflink"
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+loops=4096
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+iosize=$((BLKSZ * 16))
+
+echo "Initialize files"
+echo > $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+cp --reflink=always $TESTDIR/file1 $TESTDIR/file2
+sync
+
+echo "Delete while rewriting"
+rm -rf $TESTDIR/file1 &
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((loops * iosize))" $TESTDIR/file1 >> $seqres.full
+wait
+
+echo "Check fs"
+umount $SCRATCH_MNT
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
index b4ba56a..7f70690 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -227,5 +227,14 @@
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
