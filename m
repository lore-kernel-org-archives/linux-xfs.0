Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbcKGGaU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Nov 2016 01:30:20 -0500
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v2] fstests: multi-threads freeze/unfreeze test under fsstress stress
Date: Mon,  7 Nov 2016 14:30:12 +0800
Message-Id: <1478500212-11648-1-git-send-email-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

Multi-threads freeze/unfreeze maybe trigger some bugs, e.g: panic,
hang or data corruption etc. It does't check the return value of
freeze/unfreeze, but it tries to make sure fsstress won't run fails,
and no any other bugs happen.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2 did below changes:
 - "_fail" if scratch_mkfs/mount run fails
 - add _require_test_program "feature"
 - some code style change
 - "kill -0 $fsstress_pid 2>/dev/null" instead of
   "[ $(ps -ef | grep "fsstress" | grep -v -c grep) -gt 0 ]"
 - move the last unfreeze operation to _cleanup
 - increase fsstress' nops from 600 to 1000

Until now, it ran about 97s in my test x86_64 machine which has 8
cpus, 64G memory.

Thanks,
Zorro

 tests/generic/999     | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/999.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 96 insertions(+)
 create mode 100755 tests/generic/999
 create mode 100644 tests/generic/999.out

diff --git a/tests/generic/999 b/tests/generic/999
new file mode 100755
index 0000000..46b95c7
--- /dev/null
+++ b/tests/generic/999
@@ -0,0 +1,93 @@
+#! /bin/bash
+# FS QA Test 999
+#
+# Multi-threads freeze/unfreeze testing. This's a stress test case,
+# it won't do functional check.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat, Inc.  All Rights Reserved.
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
+	# Make sure $SCRATCH_MNT is unfreezed
+	xfs_freeze -u $SCRATCH_MNT 2>/dev/null
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+echo "Silence is golden"
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_freeze
+_require_test_program "feature"
+
+_scratch_mkfs >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount >>$seqres.full 2>&1 || _fail "mount failed"
+
+num_cpus=`$here/src/feature -o`
+
+# Start fsstress in background
+procs=$num_cpus
+if [ $procs -gt 20 ]; then
+	procs=20
+elif [ $procs -le 1 ]; then
+	procs=2
+fi
+nops=1000
+stress_dir="$SCRATCH_MNT/fsstress_test_dir"
+mkdir "$stress_dir"
+fsstress_args=`_scale_fsstress_args -d $stress_dir -p $procs -n $nops $FSSTRESS_AVOID`
+$FSSTRESS_PROG $fsstress_args >>$seqres.full 2>&1 &
+fsstress_pid=$!
+
+# Start multi-threads freeze/unfreeze
+for ((i=0; i<$procs; i++)); do
+	while kill -0 $fsstress_pid 2>/dev/null; do
+		xfs_freeze -f $SCRATCH_MNT 2>/dev/null
+		xfs_freeze -u $SCRATCH_MNT 2>/dev/null
+	done &
+	freeze_pids="$! $freeze_pids"
+done
+
+wait $fsstress_pid
+result=$?
+wait $freeze_pids
+
+# Exit with fsstress return value
+status=$result
+exit
diff --git a/tests/generic/999.out b/tests/generic/999.out
new file mode 100644
index 0000000..3b276ca
--- /dev/null
+++ b/tests/generic/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 08007d7..76abf71 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -392,3 +392,4 @@
 387 auto clone
 388 auto log metadata
 389 auto quick acl
+999 auto freeze stress dangerous
-- 
2.7.4

