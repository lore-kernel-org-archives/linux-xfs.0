Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 23F0529F25
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:14:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 79A86AC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:14:39 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3YqELMSY4xgInQTT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:14:36 -0700 (PDT)
Subject: [PATCH 12/12] reflink: test that CoW writes fail when we're out of
	space
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:14:25 -0700
Message-ID: <20151007051425.3260.73646.stgit@birch.djwong.org>
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

Ensure that copy-on-writing a reflinked file when there's no free disk
space reflects the desired ENOSPC back to userspace during the write
call.  Tests the buffered IO, direct IO, and mmap write paths.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/generic/842     |  110 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/842.out |   10 ++++
 tests/generic/843     |  110 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/843.out |   10 ++++
 tests/generic/844     |  112 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/844.out |    9 ++++
 tests/generic/845     |  110 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/845.out |   10 ++++
 tests/generic/group   |    4 ++
 9 files changed, 485 insertions(+)
 create mode 100755 tests/generic/842
 create mode 100644 tests/generic/842.out
 create mode 100755 tests/generic/843
 create mode 100644 tests/generic/843.out
 create mode 100755 tests/generic/844
 create mode 100644 tests/generic/844.out
 create mode 100755 tests/generic/845
 create mode 100644 tests/generic/845.out


diff --git a/tests/generic/842 b/tests/generic/842
new file mode 100755
index 0000000..9e46b6e
--- /dev/null
+++ b/tests/generic/842
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 842
+#
+# Reflink a file, use up the rest of the space, then try to observe ENOSPC
+# while copy-on-writing the file via the page cache.
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
+_require_scratch
+_require_scratch_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_cp_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+NR_BLKS=10240
+umount $SCRATCH_MNT
+SZ_BYTES="$((NR_BLKS * 8 * BLKSZ))"
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create a big file and reflink it"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile >> $seqres.full 2>&1
+cp --reflink=always $TESTDIR/bigfile $TESTDIR/clonefile
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' $TESTDIR)"
+touch $TESTDIR/file0 $TESTDIR/file1
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_FREE))" $TESTDIR/eat_my_space >> $seqres.full 2>&1
+sync
+
+echo "CoW the big file"
+out="$($XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+test "$(echo "${out}" | grep -c "No space left on device")" -eq 1 || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> $seqres.full 2>&1
+echo "${out}"
+
+echo "Remount and try CoW again"
+umount $SCRATCH_MNT
+_scratch_mount
+
+out="$($XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+test "$(echo "${out}" | grep -c "No space left on device")" -eq 1 || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> $seqres.full 2>&1
+echo "${out}"
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/842.out b/tests/generic/842.out
new file mode 100644
index 0000000..df58025
--- /dev/null
+++ b/tests/generic/842.out
@@ -0,0 +1,10 @@
+QA output created by 842
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+CoW the big file
+pwrite64: No space left on device
+Remount and try CoW again
+pwrite64: No space left on device
+Check scratch fs
diff --git a/tests/generic/843 b/tests/generic/843
new file mode 100755
index 0000000..9349af1
--- /dev/null
+++ b/tests/generic/843
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 843
+#
+# Reflink a file that uses more than half the space, then try to run out of
+# space while copy-on-writing.
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
+_require_scratch
+_require_scratch_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_cp_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+NR_BLKS=10240
+umount $SCRATCH_MNT
+SZ_BYTES="$((NR_BLKS * 3 / 2 * BLKSZ))"
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create a big file and reflink it"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile >> $seqres.full 2>&1
+cp --reflink=always $TESTDIR/bigfile $TESTDIR/clonefile
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' $TESTDIR)"
+touch $TESTDIR/file0 $TESTDIR/file1
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_FREE))" $TESTDIR/eat_my_space >> $seqres.full 2>&1
+sync
+
+echo "CoW the big file"
+out="$($XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+test "$(echo "${out}" | grep -c "No space left on device")" -eq 1 || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> $seqres.full 2>&1
+echo "${out}"
+
+echo "Remount and try CoW again"
+umount $SCRATCH_MNT
+_scratch_mount
+
+out="$($XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+test "$(echo "${out}" | grep -c "No space left on device")" -eq 1 || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> $seqres.full 2>&1
+echo "${out}"
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/843.out b/tests/generic/843.out
new file mode 100644
index 0000000..43c1cf6
--- /dev/null
+++ b/tests/generic/843.out
@@ -0,0 +1,10 @@
+QA output created by 843
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+CoW the big file
+pwrite64: No space left on device
+Remount and try CoW again
+pwrite64: No space left on device
+Check scratch fs
diff --git a/tests/generic/844 b/tests/generic/844
new file mode 100755
index 0000000..ee834b3
--- /dev/null
+++ b/tests/generic/844
@@ -0,0 +1,112 @@
+#! /bin/bash
+# FS QA Test No. 844
+#
+# Reflink a file, use up the rest of the space, then try to observe ENOSPC
+# while copy-on-writing the file via mmap.
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
+_require_scratch
+_require_scratch_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_cp_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+NR_BLKS=10240
+umount $SCRATCH_MNT
+SZ_BYTES="$((NR_BLKS * 8 * BLKSZ))"
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create a big file and reflink it"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile >> $seqres.full 2>&1
+cp --reflink=always $TESTDIR/bigfile $TESTDIR/clonefile
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' $TESTDIR)"
+touch $TESTDIR/file0 $TESTDIR/file1
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_FREE))" $TESTDIR/eat_my_space >> $seqres.full 2>&1
+sync
+
+echo "mmap CoW the big file"
+out="$($XFS_IO_PROG -f -c "mmap -rw 0 $((BLKSZ * NR_BLKS))" -c "mwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+err="$?"
+if [ "$err" -lt 128 ]; then
+	echo "mmap CoW should have failed with SIGBUS, got SIG$(kill -l $err)"
+fi
+sync
+
+echo "Remount and try CoW again"
+umount $SCRATCH_MNT
+_scratch_mount
+
+out="$($XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+test "$(echo "${out}" | grep -c "No space left on device")" -eq 1 || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> $seqres.full 2>&1
+echo "${out}"
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/844.out b/tests/generic/844.out
new file mode 100644
index 0000000..f74f5bf
--- /dev/null
+++ b/tests/generic/844.out
@@ -0,0 +1,9 @@
+QA output created by 844
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+mmap CoW the big file
+Remount and try CoW again
+pwrite64: No space left on device
+Check scratch fs
diff --git a/tests/generic/845 b/tests/generic/845
new file mode 100755
index 0000000..5587687
--- /dev/null
+++ b/tests/generic/845
@@ -0,0 +1,110 @@
+#! /bin/bash
+# FS QA Test No. 845
+#
+# Reflink a file, use up the rest of the space, then try to observe ENOSPC
+# while copy-on-writing the file via direct-io.
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
+_require_scratch
+_require_scratch_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_cp_reflink
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+
+TESTDIR=$SCRATCH_MNT/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Reformat with appropriate size"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+NR_BLKS=10240
+umount $SCRATCH_MNT
+SZ_BYTES="$((NR_BLKS * 8 * BLKSZ))"
+if [ $SZ_BYTES -lt $((32 * 1048576)) ]; then
+	SZ_BYTES=$((32 * 1048576))
+fi
+_scratch_mkfs_sized $SZ_BYTES >> $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create a big file and reflink it"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile >> $seqres.full 2>&1
+cp --reflink=always $TESTDIR/bigfile $TESTDIR/clonefile
+sync
+
+echo "Allocate the rest of the space"
+NR_FREE="$(stat -f -c '%f' $TESTDIR)"
+touch $TESTDIR/file0 $TESTDIR/file1
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * NR_FREE))" $TESTDIR/eat_my_space >> $seqres.full 2>&1
+sync
+
+echo "CoW the big file"
+out="$($XFS_IO_PROG -d -f -c "pwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+test "$(echo "${out}" | grep -c "No space left on device")" -eq 1 || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> $seqres.full 2>&1
+echo "${out}"
+
+echo "Remount and try CoW again"
+umount $SCRATCH_MNT
+_scratch_mount
+
+out="$($XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * NR_BLKS))" $TESTDIR/bigfile 2>&1)"
+test "$(echo "${out}" | grep -c "No space left on device")" -eq 1 || echo "CoW should have failed with ENOSPC"
+echo "${out}" >> $seqres.full 2>&1
+echo "${out}"
+
+#filefrag -v $TESTDIR/bigfile
+#filefrag -v $TESTDIR/clonefile
+
+echo "Check scratch fs"
+umount $SCRATCH_MNT
+_check_scratch_fs
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/845.out b/tests/generic/845.out
new file mode 100644
index 0000000..d367a73
--- /dev/null
+++ b/tests/generic/845.out
@@ -0,0 +1,10 @@
+QA output created by 845
+Format and mount
+Reformat with appropriate size
+Create a big file and reflink it
+Allocate the rest of the space
+CoW the big file
+pwrite64: No space left on device
+Remount and try CoW again
+pwrite64: No space left on device
+Check scratch fs
diff --git a/tests/generic/group b/tests/generic/group
index d4f05a9..2ff60a8 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -248,3 +248,7 @@
 839 auto quick clone
 840 clone_stress
 841 clone_stress
+842 auto quick dangerous_clone
+843 auto quick dangerous_clone
+844 auto quick dangerous_clone
+845 auto quick dangerous_clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
