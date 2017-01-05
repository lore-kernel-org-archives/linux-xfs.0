Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42358 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967431AbdAEBF2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:05:28 -0500
Subject: [PATCH 7/7] xfs/ext4: check negative inode size
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:05:20 -0800
Message-ID: <148357832063.7677.12994144585642711957.stgit@birch.djwong.org>
In-Reply-To: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
References: <148357827617.7677.15595044775254927245.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Craft a malicious filesystem image with a negative inode size,
then try to trigger a kernel DoS by appending data to the file.
Ideally this should trigger verifier errors instead of hanging.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/shared/400     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/400.out |    5 +++
 tests/shared/401     |   71 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/401.out |    5 +++
 tests/shared/group   |    2 +
 tests/xfs/400        |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/400.out    |    5 +++
 tests/xfs/401        |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/401.out    |    5 +++
 tests/xfs/group      |    2 +
 10 files changed, 310 insertions(+)
 create mode 100755 tests/shared/400
 create mode 100644 tests/shared/400.out
 create mode 100755 tests/shared/401
 create mode 100644 tests/shared/401.out
 create mode 100755 tests/xfs/400
 create mode 100644 tests/xfs/400.out
 create mode 100755 tests/xfs/401
 create mode 100644 tests/xfs/401.out


diff --git a/tests/shared/400 b/tests/shared/400
new file mode 100755
index 0000000..ba7bcda
--- /dev/null
+++ b/tests/shared/400
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FSQA Test No. 400
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext2 ext3 ext4
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+
+echo "Corrupt filesystem"
+_scratch_unmount
+debugfs -w -R "sif /a size -1" $SCRATCH_DEV >> $seqres.full 2>&1
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/shared/400.out b/tests/shared/400.out
new file mode 100644
index 0000000..ddf8a28
--- /dev/null
+++ b/tests/shared/400.out
@@ -0,0 +1,5 @@
+QA output created by 400
+Format and mount
+Corrupt filesystem
+Remount, try to append
+Write did not succeed (ok).
diff --git a/tests/shared/401 b/tests/shared/401
new file mode 100755
index 0000000..d790381
--- /dev/null
+++ b/tests/shared/401
@@ -0,0 +1,71 @@
+#! /bin/bash
+# FSQA Test No. 401
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs ext2 ext3 ext4
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+
+echo "Corrupt filesystem"
+_scratch_unmount
+debugfs -w -R "sif /a size 0xFFFFFFFFFFFFFE00" $SCRATCH_DEV >> $seqres.full 2>&1
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=direct,append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/shared/401.out b/tests/shared/401.out
new file mode 100644
index 0000000..0d45add
--- /dev/null
+++ b/tests/shared/401.out
@@ -0,0 +1,5 @@
+QA output created by 401
+Format and mount
+Corrupt filesystem
+Remount, try to append
+Write did not succeed (ok).
diff --git a/tests/shared/group b/tests/shared/group
index 55bb594..64d2d2f 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -13,3 +13,5 @@
 272 auto enospc rw
 289 auto quick
 298 auto trim
+400 dangerous_fuzzers
+401 dangerous_fuzzers
diff --git a/tests/xfs/400 b/tests/xfs/400
new file mode 100755
index 0000000..eed8fdf
--- /dev/null
+++ b/tests/xfs/400
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FSQA Test No. 400
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+inum=$(stat -c "%i" $testdir/a)
+
+echo "Corrupt filesystem"
+_scratch_unmount
+_scratch_xfs_db -x -c "inode ${inum}" -c 'write core.size -- -1' >> $seqres.full
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/400.out b/tests/xfs/400.out
new file mode 100644
index 0000000..ddf8a28
--- /dev/null
+++ b/tests/xfs/400.out
@@ -0,0 +1,5 @@
+QA output created by 400
+Format and mount
+Corrupt filesystem
+Remount, try to append
+Write did not succeed (ok).
diff --git a/tests/xfs/401 b/tests/xfs/401
new file mode 100755
index 0000000..2be684a
--- /dev/null
+++ b/tests/xfs/401
@@ -0,0 +1,72 @@
+#! /bin/bash
+# FSQA Test No. 401
+#
+# Since loff_t is a signed type, it is invalid for a filesystem to load
+# an inode with i_size = -1ULL.  Unfortunately, nobody checks this,
+# which means that we can trivially DoS the VFS by creating such a file
+# and appending to it.  This causes an integer overflow in the routines
+# underlying writeback, which results in the kernel locking up.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Oracle, Inc.  All Rights Reserved.
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
+PIDS=""
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_scratch_nocheck
+_disable_dmesg_check
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs  >> $seqres.full 2>&1
+_scratch_mount
+
+testdir=$SCRATCH_MNT
+echo m > $testdir/a
+inum=$(stat -c "%i" $testdir/a)
+
+echo "Corrupt filesystem"
+_scratch_unmount
+_scratch_xfs_db -x -c "inode ${inum}" -c 'write core.size -- -512' >> $seqres.full
+
+echo "Remount, try to append"
+_scratch_mount
+dd if=/dev/zero of=$testdir/a bs=512 count=1 oflag=direct,append conv=notrunc >> $seqres.full 2>&1 || echo "Write did not succeed (ok)."
+sync
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/401.out b/tests/xfs/401.out
new file mode 100644
index 0000000..0d45add
--- /dev/null
+++ b/tests/xfs/401.out
@@ -0,0 +1,5 @@
+QA output created by 401
+Format and mount
+Corrupt filesystem
+Remount, try to append
+Write did not succeed (ok).
diff --git a/tests/xfs/group b/tests/xfs/group
index c237b50..10ba27b 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -334,3 +334,5 @@
 345 auto quick clone
 346 auto quick clone
 347 auto quick clone
+400 dangerous_fuzzers
+401 dangerous_fuzzers

