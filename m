Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6EE747F58
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 21:20:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 46CB2304062
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 19:20:53 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id egREgbJ3KDemAyve for
	<xfs@oss.sgi.com>; Wed, 12 Feb 2014 19:20:45 -0800 (PST)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 1/3] xfstests/btrfs: add qgroup rescan stress test
Date: Thu, 13 Feb 2014 11:18:57 +0800
Message-Id: <1392261539-28903-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
 tests/btrfs/038     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/038.out |  3 +++
 tests/btrfs/group   |  1 +
 3 files changed, 79 insertions(+)
 create mode 100644 tests/btrfs/038
 create mode 100644 tests/btrfs/038.out

diff --git a/tests/btrfs/038 b/tests/btrfs/038
new file mode 100644
index 0000000..f6bd872
--- /dev/null
+++ b/tests/btrfs/038
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FSQA Test No. btrfs/038
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
+       rm -f $tmp.*
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
+run_check _scratch_mkfs "-b 2g --nodesize 4096"
+run_check _scratch_mount
+
+# -w ensures that the only ops are ones which cause write I/O
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
+		$FSSTRESS_AVOID >&/dev/null
+
+run_check $BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT \
+       $SCRATCH_MNT/snap1 >>$seqres.full 2>&1
+
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5 -n 1000 \
+       $FSSTRESS_AVOID >&/dev/null
+
+run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+run_check $BTRFS_UTIL_PROG quota rescan -w $SCRATCH_MNT
+
+#ignore removing subvolume errors
+rm -rf $SCRATCH_MNT/* >& /dev/null
+$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >> $seqres.full 2>&1
+
+$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
+	| $AWK_PROG '{print $1" "$2" "$3 }'
+
+status=0
+exit
diff --git a/tests/btrfs/038.out b/tests/btrfs/038.out
new file mode 100644
index 0000000..1c24c55
--- /dev/null
+++ b/tests/btrfs/038.out
@@ -0,0 +1,3 @@
+QA output created by 038
+0/5 4096 4096
+0/258 4096 4096
diff --git a/tests/btrfs/group b/tests/btrfs/group
index f9f062f..7ac9f0a 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -37,3 +37,4 @@
 032 auto quick
 033 auto quick
 034 auto quick
+038 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
