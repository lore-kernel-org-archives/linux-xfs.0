Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C26367F3F
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2014 22:46:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9F97A304051
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2014 20:46:39 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id MgjNLxYnCHAPbGMP for
	<xfs@oss.sgi.com>; Sun, 09 Mar 2014 20:46:30 -0700 (PDT)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v2 1/3] xfstests/btrfs: add qgroup rescan stress test
Date: Mon, 10 Mar 2014 11:44:09 +0800
Message-Id: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

Test flow is to run fsstress after triggering quota rescan.
the ruler is simple, we just remove all files and directories,
sync filesystem and see if qgroup's ref and excl are nodesize.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
	switch into new helper _run_btrfs_util_prog()
---
 tests/btrfs/041     | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/041.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 80 insertions(+)
 create mode 100644 tests/btrfs/041
 create mode 100644 tests/btrfs/041.out

diff --git a/tests/btrfs/041 b/tests/btrfs/041
new file mode 100644
index 0000000..92bd080
--- /dev/null
+++ b/tests/btrfs/041
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FSQA Test No. btrfs/041
+#
+# Quota rescan stress test, we run fsstress and quota rescan concurrently
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2014 Fujitsu.  All rights reserved.
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
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+run_check _scratch_mkfs "-b 1g --nodesize 4096"
+run_check _scratch_mount
+
+# -w ensures that the only ops are ones which cause write I/O
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
+		$FSSTRESS_AVOID >&/dev/null
+
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT \
+       $SCRATCH_MNT/snap1 >>$seqres.full 2>&1
+
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5 -n 1000 \
+       $FSSTRESS_AVOID >&/dev/null
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+#ignore removing subvolume errors
+rm -rf $SCRATCH_MNT/* >& /dev/null
+
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT >> $seqres.full 2>&1
+_run_btrfs_util_prog qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
+	| $AWK_PROG '{print $1" "$2" "$3 }'
+
+status=0
+exit
diff --git a/tests/btrfs/041.out b/tests/btrfs/041.out
new file mode 100644
index 0000000..fb59896
--- /dev/null
+++ b/tests/btrfs/041.out
@@ -0,0 +1,3 @@
+QA output created by 041
+0/5 4096 4096
+0/258 4096 4096
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f5452b5..fd0193c 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -43,3 +43,4 @@
 038 auto quick
 039 auto quick
 040 auto quick
+041 auto quick
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
