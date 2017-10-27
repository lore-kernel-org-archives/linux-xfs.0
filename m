Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35065 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbdJ0Amb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 20:42:31 -0400
Date: Thu, 26 Oct 2017 17:42:25 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 6/6] xfs: test that we don't leak inodes and dquots during
 failed cow recovery
Message-ID: <20171027004225.GD5486@magnolia>
References: <150899709935.18389.17266737014565285073.stgit@magnolia>
 <150899713046.18389.15388342707754967041.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150899713046.18389.15388342707754967041.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Add a couple of tests to check that we don't leak inodes or dquots
if CoW recovery fails and therefore the mount fails.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |    1 
 tests/xfs/703     |  111 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/703.out |    9 ++++
 tests/xfs/704     |   89 ++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/704.out |    5 ++
 tests/xfs/705     |  105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/705.out |    9 ++++
 tests/xfs/group   |    3 +
 8 files changed, 332 insertions(+)
 create mode 100755 tests/xfs/703
 create mode 100644 tests/xfs/703.out
 create mode 100755 tests/xfs/704
 create mode 100644 tests/xfs/704.out
 create mode 100755 tests/xfs/705
 create mode 100644 tests/xfs/705.out

diff --git a/common/rc b/common/rc
index c708bfa..7e453e0 100644
--- a/common/rc
+++ b/common/rc
@@ -3324,6 +3324,7 @@ _check_dmesg()
 	     -e "(INFO|ERR): suspicious RCU usage" \
 	     -e "INFO: possible circular locking dependency detected" \
 	     -e "general protection fault:" \
+	     -e "BUG .* remaining" \
 	     $seqres.dmesg
 	if [ $? -eq 0 ]; then
 		_dump_err "_check_dmesg: something found in dmesg (see $seqres.dmesg)"
diff --git a/tests/xfs/703 b/tests/xfs/703
new file mode 100755
index 0000000..b2e37e6
--- /dev/null
+++ b/tests/xfs/703
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 703
+#
+# Ensure that we don't leak quota inodes when CoW recovery fails.
+#
+# Use xfs_fsr to inject bmap redo items in the log for a linked file and
+# an unlinked file; enable quota so that we always mount with the quota
+# inodes; and then corrupt the refcount btree to ensure that the CoW
+# garbage collection (and therefore the mount) fail.
+#
+# On a subsequent mount attempt, we should be able to replay the bmap
+# items for the linked and unlinked files without prematurely truncating
+# the unlinked inode and without leaking the linked inode, and we should
+# be able to release the quota inodes when we're aborting the mount.  We
+# also should not leak dquots.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+	cd /
+	rm -rf "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+. ./common/inject
+. ./common/quota
+. ./common/module
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_loadable_fs_module "xfs"
+_require_quota
+_require_scratch_reflink
+_require_cp_reflink
+_require_command "$XFS_FSR_PROG" "xfs_fsr"
+_require_xfs_io_error_injection "bmap_finish_one"
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount -o noquota >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+blksz=65536
+blks=3
+mkdir "$testdir"
+
+echo "Create a many-block file"
+_pwrite_byte 0x62 0 $((blksz * blks)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 0 $blksz $testdir/file2 >> $seqres.full
+_reflink_range $testdir/file2 0 $testdir/file1 $blksz $blksz >> $seqres.full
+_scratch_cycle_mount noquota
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Defrag the file"
+$XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full 2>&1
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log" | tee /dev/ttyprintk
+_scratch_unmount
+_scratch_dump_log >> $seqres.full
+_scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c 'fuzz -d recs[1].startblock ones' >> $seqres.full
+_scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c p >> $seqres.full
+
+# Suddenly enable quota to test if we can leak the quotacheck dquots!
+_scratch_mount -o quota >> $seqres.full 2>&1
+_scratch_unmount 2> /dev/null
+rm -f ${RESULT_DIR}/require_scratch
+
+echo "See if we leak"
+_reload_fs_module "xfs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/703.out b/tests/xfs/703.out
new file mode 100644
index 0000000..d811880
--- /dev/null
+++ b/tests/xfs/703.out
@@ -0,0 +1,9 @@
+QA output created by 703
+Format and mount
+Create a many-block file
+Inject error
+Defrag the file
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+See if we leak
diff --git a/tests/xfs/704 b/tests/xfs/704
new file mode 100755
index 0000000..3f4d704
--- /dev/null
+++ b/tests/xfs/704
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 704
+#
+# Ensure that we don't leak dquots when CoW recovery fails.
+#
+# Corrupt the refcount btree to ensure that the CoW garbage collection
+# (and therefore the mount) fail.
+#
+# On a subsequent mount attempt, we should be able to release the quota
+# inodes when we're aborting the mount.  We also should not leak dquots.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+	cd /
+	rm -rf "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+. ./common/quota
+. ./common/module
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_loadable_fs_module "xfs"
+_require_quota
+_require_scratch_reflink
+_require_cp_reflink
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount -o quota >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+blksz=65536
+blks=3
+mkdir "$testdir"
+
+echo "Create a many-block file"
+_pwrite_byte 0x62 0 $((blksz * blks)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 0 $blksz $testdir/file2 >> $seqres.full
+_reflink_range $testdir/file2 0 $testdir/file1 $blksz $blksz >> $seqres.full
+
+echo "Remount to check recovery" | tee /dev/ttyprintk
+_scratch_unmount
+_scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c 'fuzz -d recs[1].startblock ones' >> $seqres.full
+_scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c p >> $seqres.full
+_scratch_mount -o quota >> $seqres.full 2>&1
+_scratch_unmount 2> /dev/null
+rm -f ${RESULT_DIR}/require_scratch
+
+echo "See if we leak"
+_reload_fs_module "xfs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/704.out b/tests/xfs/704.out
new file mode 100644
index 0000000..b237b2d
--- /dev/null
+++ b/tests/xfs/704.out
@@ -0,0 +1,5 @@
+QA output created by 704
+Format and mount
+Create a many-block file
+Remount to check recovery
+See if we leak
diff --git a/tests/xfs/705 b/tests/xfs/705
new file mode 100755
index 0000000..6019a4e
--- /dev/null
+++ b/tests/xfs/705
@@ -0,0 +1,105 @@
+#! /bin/bash
+# FS QA Test No. 705
+#
+# Ensure that we don't leak inodes when CoW recovery fails.
+#
+# Use xfs_fsr to inject bmap redo items in the log for a linked file and
+# an unlinked file; and then corrupt the refcount btree to ensure that
+# the CoW garbage collection (and therefore the mount) fail.
+#
+# On a subsequent mount attempt, we should be able to replay the bmap
+# items for the linked and unlinked files without prematurely truncating
+# the unlinked inode and without leaking the linked inode, and we should
+# be able to release all the inodes when we're aborting the mount.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+	cd /
+	rm -rf "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+. ./common/reflink
+. ./common/inject
+. ./common/module
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_loadable_fs_module "xfs"
+_require_scratch_reflink
+_require_cp_reflink
+_require_command "$XFS_FSR_PROG" "xfs_fsr"
+_require_xfs_io_error_injection "bmap_finish_one"
+_require_xfs_scratch_rmapbt
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount -o noquota >> "$seqres.full" 2>&1
+
+testdir="$SCRATCH_MNT/test-$seq"
+blksz=65536
+blks=3
+mkdir "$testdir"
+
+echo "Create a many-block file"
+_pwrite_byte 0x62 0 $((blksz * blks)) $testdir/file1 >> $seqres.full
+_pwrite_byte 0x63 0 $blksz $testdir/file2 >> $seqres.full
+_reflink_range $testdir/file2 0 $testdir/file1 $blksz $blksz >> $seqres.full
+_scratch_cycle_mount noquota
+
+echo "Inject error"
+_scratch_inject_error "bmap_finish_one"
+
+echo "Defrag the file"
+$XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full 2>&1
+
+echo "FS should be shut down, touch will fail"
+touch $SCRATCH_MNT/badfs 2>&1 | _filter_scratch
+
+echo "Remount to replay log" | tee /dev/ttyprintk
+_scratch_unmount
+_scratch_dump_log >> $seqres.full
+_scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c 'fuzz -d recs[1].startblock ones' >> $seqres.full
+_scratch_xfs_db -x -c 'agf 0' -c 'addr refcntroot' -c p >> $seqres.full
+_scratch_mount -o noquota >> $seqres.full 2>&1
+_scratch_unmount 2> /dev/null
+rm -f ${RESULT_DIR}/require_scratch
+
+echo "See if we leak"
+_reload_fs_module "xfs"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/705.out b/tests/xfs/705.out
new file mode 100644
index 0000000..0bcd9ab
--- /dev/null
+++ b/tests/xfs/705.out
@@ -0,0 +1,9 @@
+QA output created by 705
+Format and mount
+Create a many-block file
+Inject error
+Defrag the file
+FS should be shut down, touch will fail
+touch: cannot touch 'SCRATCH_MNT/badfs': Input/output error
+Remount to replay log
+See if we leak
diff --git a/tests/xfs/group b/tests/xfs/group
index b439842..e56666b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -431,3 +431,6 @@
 431 auto quick dangerous
 432 auto quick dir metadata
 433 auto quick attr
+703 auto quick clone fsr
+704 auto quick clone
+705 auto quick clone fsr
