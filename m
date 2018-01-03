Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58652 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbeACT0a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jan 2018 14:26:30 -0500
Date: Wed, 3 Jan 2018 11:26:26 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/8] xfs: check that fs freeze minimizes required recovery
Message-ID: <20180103192626.GB4854@magnolia>
References: <151314499003.18893.8687182548758898133.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151314499003.18893.8687182548758898133.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure that a fs freeze operation cleans up as much of the filesystem
so as to minimize the recovery required in a crash/remount scenario.  In
particular we want to check that we don't leave CoW preallocations
sitting around in the refcountbt, though this test looks for anything
out of the ordinary on the frozen fs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/903     |  107 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/903.out |   10 +++++
 tests/xfs/group   |    1 
 3 files changed, 118 insertions(+)
 create mode 100755 tests/xfs/903
 create mode 100644 tests/xfs/903.out

diff --git a/tests/xfs/903 b/tests/xfs/903
new file mode 100755
index 0000000..1686356
--- /dev/null
+++ b/tests/xfs/903
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 903
+#
+# Test that frozen filesystems are relatively clean and not full of errors.
+# Prior to freezing a filesystem, we want to minimize the amount of recovery
+# that will have to happen if the system goes down while the fs is frozen.
+# Therefore, start up fsstress and cycle through a few freeze/thaw cycles
+# to ensure that nothing blows up when we try to do this.
+#
+# Unfortunately the log will probably still be dirty, so we can't do much
+# about enforcing a clean repair -n run.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2000-2002 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2018 Oracle.  All Rights Reserved.
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
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1
+trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	# Make sure we thaw the fs before we unmount or else we remove the
+	# mount without actually deactivating the filesystem(!)
+	$XFS_IO_PROG -x -c "thaw" $SCRATCH_MNT 2> /dev/null
+	echo "*** unmount"
+	_scratch_unmount 2>/dev/null
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+# xfs_db will OOM kill the machine if you don't have huge amounts of RAM, so
+# don't run this on large filesystems.
+_require_no_large_scratch_dev
+
+echo "*** init FS"
+
+rm -f $seqres.full
+_scratch_unmount >/dev/null 2>&1
+echo "*** MKFS ***" >>$seqres.full
+echo "" >>$seqres.full
+_scratch_mkfs_xfs >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount >>$seqres.full 2>&1 || _fail "mount failed"
+
+echo "*** test"
+
+for l in 0 1 2 3 4
+do
+	echo "    *** test $l"
+	FSSTRESS_ARGS=`_scale_fsstress_args -d $SCRATCH_MNT -n 1000 $FSSTRESS_AVOID`
+	$FSSTRESS_PROG  $FSSTRESS_ARGS >>$seqres.full
+
+	$XFS_IO_PROG -x -c 'freeze' $SCRATCH_MNT
+
+	# Log will probably be dirty after the freeze, record state
+	echo "" >>$seqres.full
+	echo "*** xfs_logprint ***" >>$seqres.full
+	echo "" >>$seqres.full
+	log=clean
+	_scratch_xfs_logprint -tb 2>&1 | tee -a $seqres.full \
+		| head | grep -q "<CLEAN>" || log=dirty
+
+	# Fail if repair complains and the log is clean
+	echo "" >>$seqres.full
+	echo "*** XFS_REPAIR -n ***" >>$seqres.full
+	echo "" >>$seqres.full
+	_scratch_xfs_repair -f -n >> $seqres.full 2>&1
+
+	if [ $? -ne 0 ] && [ "$log" = "clean" ]; then
+		_fail "xfs_repair failed"
+	fi
+
+	$XFS_IO_PROG -x -c 'thaw' $SCRATCH_MNT
+done
+
+echo "*** done"
+status=0
+exit 0
diff --git a/tests/xfs/903.out b/tests/xfs/903.out
new file mode 100644
index 0000000..378f0cb
--- /dev/null
+++ b/tests/xfs/903.out
@@ -0,0 +1,10 @@
+QA output created by 903
+*** init FS
+*** test
+    *** test 0
+    *** test 1
+    *** test 2
+    *** test 3
+    *** test 4
+*** done
+*** unmount
diff --git a/tests/xfs/group b/tests/xfs/group
index e1b1582..23c26c2 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -435,3 +435,4 @@
 435 auto quick clone
 436 auto quick clone fsr
 708 auto quick other
+903 mount auto quick stress
