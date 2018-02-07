Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932244AbeBGVTo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Feb 2018 16:19:44 -0500
Subject: [PATCH 3/4] xfs: regression tests for reflink quota bugs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 07 Feb 2018 13:19:38 -0800
Message-ID: <151803837867.19313.1263746347032621084.stgit@magnolia>
In-Reply-To: <151803835881.19313.17455678207236452557.stgit@magnolia>
References: <151803835881.19313.17455678207236452557.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add three tests to look for quota bugs in xfs reflink.  The first test
looks for problems when we have speculative cow reservations in memory,
we chown the file, but the reservations don't move to the new owner.
The second test checks that we remembered to dqattach the inodes before
performing reflink operations.  The third is a stress test for reflink
quota handling near enospc and helped us to find a directio cow write
corruption bug when free space is fragmented.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/904     |   93 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/904.out |   17 ++++++++
 tests/xfs/905     |   88 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/905.out |   13 ++++++
 tests/xfs/906     |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/906.out |    6 +++
 tests/xfs/group   |    3 +
 7 files changed, 339 insertions(+)
 create mode 100755 tests/xfs/904
 create mode 100644 tests/xfs/904.out
 create mode 100755 tests/xfs/905
 create mode 100644 tests/xfs/905.out
 create mode 100755 tests/xfs/906
 create mode 100644 tests/xfs/906.out


diff --git a/tests/xfs/904 b/tests/xfs/904
new file mode 100755
index 0000000..ef78f1a
--- /dev/null
+++ b/tests/xfs/904
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test No. 904
+#
+# Regression test for a quota accounting bug when changing the owner of
+# a file that has CoW reservations and no dirty pages.  The reservations
+# should shift over to the new owner, but they do not.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/reflink
+. ./common/quota
+. ./common/filter
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_quota
+_require_scratch_reflink
+_require_cp_reflink
+_require_user
+
+rm -f $seqres.full
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount "-o usrquota,grpquota" >> "$seqres.full" 2>&1
+
+echo "Create files"
+$XFS_IO_PROG -c "cowextsize 1m" $SCRATCH_MNT
+touch $SCRATCH_MNT/a $SCRATCH_MNT/force_fsgqa
+chown $qa_user $SCRATCH_MNT/a $SCRATCH_MNT/force_fsgqa
+_pwrite_byte 0x58 0 64k $SCRATCH_MNT/a >> $seqres.full
+$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
+_report_quota_blocks "-u $SCRATCH_MNT"
+
+echo "Reflink and CoW"
+_cp_reflink $SCRATCH_MNT/a $SCRATCH_MNT/b
+_pwrite_byte 0x59 0 64k $SCRATCH_MNT/a >> $seqres.full
+$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
+_report_quota_blocks "-u $SCRATCH_MNT"
+
+echo "Sync"
+sync
+_report_quota_blocks "-u $SCRATCH_MNT"
+
+echo "Chown and check quota"
+chown root $SCRATCH_MNT/a
+$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
+_report_quota_blocks "-u $SCRATCH_MNT"
+
+echo "Remount"
+_scratch_unmount
+_scratch_mount "-o usrquota,grpquota" >> "$seqres.full" 2>&1
+$XFS_IO_PROG -c 'stat -r' $SCRATCH_MNT/a | grep stat.size >> $seqres.full
+_report_quota_blocks "-u $SCRATCH_MNT"
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/904.out b/tests/xfs/904.out
new file mode 100644
index 0000000..4c2f508
--- /dev/null
+++ b/tests/xfs/904.out
@@ -0,0 +1,17 @@
+QA output created by 904
+Format and mount
+Create files
+root 0 0 0
+fsgqa 64 0 0
+Reflink and CoW
+root 0 0 0
+fsgqa 1152 0 0
+Sync
+root 0 0 0
+fsgqa 1088 0 0
+Chown and check quota
+root 1024 0 0
+fsgqa 64 0 0
+Remount
+root 64 0 0
+fsgqa 64 0 0
diff --git a/tests/xfs/905 b/tests/xfs/905
new file mode 100755
index 0000000..a457c84
--- /dev/null
+++ b/tests/xfs/905
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 905
+#
+# Regression test for a quota accounting bug when reflinking across EOF
+# of a file in which we forgot dq_attach.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/reflink
+. ./common/quota
+. ./common/filter
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_quota
+_require_scratch_reflink
+_require_cp_reflink
+_require_user
+
+rm -f $seqres.full
+
+check_quota() {
+	du_total="$(du -ksc $SCRATCH_MNT/a $SCRATCH_MNT/b | tail -n 1 | awk '{print $1}')"
+	qu_total="$(_report_quota_blocks "-u $SCRATCH_MNT" | grep $qa_user | awk '{print $2}')"
+	echo "du: $du_total; quota: $qu_total"
+}
+
+echo "Format and mount (noquota)"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount "-o noquota" >> $seqres.full 2>&1
+
+echo "Create files"
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
+_pwrite_byte 0x58 0 1m $SCRATCH_MNT/b >> $seqres.full
+chown $qa_user $SCRATCH_MNT/a $SCRATCH_MNT/b
+check_quota 2>&1 | _filter_scratch
+
+echo "Mount (usrquota) and check quota"
+_scratch_unmount
+_scratch_mount "-o usrquota,grpquota" >> "$seqres.full" 2>&1
+check_quota
+
+echo "Reflink and check quota again"
+_reflink_range $SCRATCH_MNT/a 256k $SCRATCH_MNT/b 384k 128k >> $seqres.full
+_reflink_range $SCRATCH_MNT/a 256k $SCRATCH_MNT/b 960k 128k >> $seqres.full
+check_quota
+
+echo "Force quotacheck"
+_check_quota_usage
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/905.out b/tests/xfs/905.out
new file mode 100644
index 0000000..fa95624
--- /dev/null
+++ b/tests/xfs/905.out
@@ -0,0 +1,13 @@
+QA output created by 905
+Format and mount (noquota)
+Create files
+repquota: Mountpoint (or device) SCRATCH_MNT not found or has no quota enabled.
+repquota: Not all specified mountpoints are using quota.
+du: 2048; quota: 
+Mount (usrquota) and check quota
+du: 2048; quota: 2048
+Reflink and check quota again
+du: 2112; quota: 2112
+Force quotacheck
+Comparing user usage
+Comparing group usage
diff --git a/tests/xfs/906 b/tests/xfs/906
new file mode 100755
index 0000000..b2e715d
--- /dev/null
+++ b/tests/xfs/906
@@ -0,0 +1,119 @@
+#! /bin/bash
+# FS QA Test No. 906
+#
+# Force enable all XFS quotas, run fsstress until the fs runs out of
+# space, and make sure the quotas are still correct when we're done.
+# This is a general regression/stress test for numerous quota bugs with
+# reflink and copy on write.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2018 Oracle, Inc.  All Rights Reserved.
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/quota
+. ./common/filter
+. ./common/reflink
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch_reflink
+_require_quota
+_require_command "$KILLALL_PROG" "killall"
+
+rm -f $seqres.full
+
+report_quota_blocks() {
+	$XFS_QUOTA_PROG -x -c "report $1" $SCRATCH_MNT | \
+			awk '{x += $2;} END { print(x); }'
+}
+
+compare_quota_to_du() {
+	test $1 -eq $2 || echo "$3 quota $2 blocks does not match du $1 blocks?"
+}
+
+# Make sure the user/group/project quota block counts match the du output.
+# This ensures that we did the quota accounting correctly and that we're
+# accurately reporting cow preallocation blocks in stat.
+check_quota_du_blocks() {
+	sync
+	#$XFS_QUOTA_PROG -x -c 'report' $SCRATCH_MNT >> $seqres.full
+	du_rep=$(du -ks $SCRATCH_MNT | awk '{print $1}')
+	u_rep=$(report_quota_blocks -u)
+	g_rep=$(report_quota_blocks -g)
+	p_rep=$(report_quota_blocks -p)
+
+	compare_quota_to_du $du_rep $u_rep "user"
+	compare_quota_to_du $du_rep $g_rep "group"
+	compare_quota_to_du $du_rep $p_rep "project"
+}
+
+echo "Format and fsstress"
+
+_qmount_option "usrquota,grpquota,prjquota"
+# We use a small volume so that we hit ENOSPC.  This is critical for
+# regression testing a bug in the directio write code that could result in fs
+# corruption ("xfs: check reflink allocation mappings").
+#
+# This started as a test for quota accounting problems ("xfs: treat CoW fork
+# operations as delalloc for quota accounting") and ("xfs: call
+# xfs_qm_dqattach before performing reflink operations") though each of those
+# tests now have separate faster-running regression tests.
+_scratch_mkfs_sized $((1600 * 1048576)) > $seqres.full 2>&1
+_scratch_mount >> $seqres.full 2>&1 || _fail "mount failed..."
+
+nr_cpus=$((LOAD_FACTOR * 4))
+nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
+$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus >> $seqres.full
+
+echo "Check quota before remount"
+check_quota_du_blocks
+
+# Clear out all the preallocations before we quotacheck.
+# The count comparison in _check_quota_usage will be unhappy if we don't
+# manage to clean out all the cow preallocations before the remount.
+_scratch_unmount
+_scratch_mount
+
+# Make sure the usage doesn't change after quotacheck.
+echo "Check quota after remount"
+_check_quota_usage
+
+check_quota_du_blocks
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/906.out b/tests/xfs/906.out
new file mode 100644
index 0000000..201daf3
--- /dev/null
+++ b/tests/xfs/906.out
@@ -0,0 +1,6 @@
+QA output created by 906
+Format and fsstress
+Check quota before remount
+Check quota after remount
+Comparing user usage
+Comparing group usage
diff --git a/tests/xfs/group b/tests/xfs/group
index cf81451..fa68824 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -437,3 +437,6 @@
 437 auto quick other
 438 auto quick quota dangerous
 439 auto quick fuzzers log
+904 auto quick clone quota
+905 auto quick clone quota
+906 auto stress clone quota

