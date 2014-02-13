Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F0D3A7F58
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 21:20:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6E7D0AC006
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 19:20:54 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id w50v95j5qR29oaCY for
	<xfs@oss.sgi.com>; Wed, 12 Feb 2014 19:20:51 -0800 (PST)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] xfstests/btrfs: add stress test for btrfs quota operations
Date: Thu, 13 Feb 2014 11:18:59 +0800
Message-Id: <1392261539-28903-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1392261539-28903-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1392261539-28903-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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

So this is a stress test for btrfs quota operations. it can also
detect the following commit fixed problem:

4082bd3d73(Btrfs: fix oops when writting dirty qgroups to disk)

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/040     | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/040.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 78 insertions(+)
 create mode 100644 tests/btrfs/040
 create mode 100644 tests/btrfs/040.out

diff --git a/tests/btrfs/040 b/tests/btrfs/040
new file mode 100644
index 0000000..d991304
--- /dev/null
+++ b/tests/btrfs/040
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test No. 040
+#
+# stresstest for btrfs quota operations. we run fsstress and quota
+# operations concurrently.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
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
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+rm -f $seqres.full
+
+_quota_enabled_background()
+{
+	i=1
+	while [ $i -le 5 ]
+	do
+		run_check $BTRFS_UTIL_PROG quota enable $SCRATCH_MNT
+		run_check $BTRFS_UTIL_PROG quota disable $SCRATCH_MNT
+		i=$(($i+1))
+		sleep 1
+	done
+}
+
+MKFS_SIZE=$((2 * 1024 * 1024 * 1024))
+run_check _scratch_mkfs_sized $MKFS_SIZE
+run_check _scratch_mount
+
+_quota_enabled_background &
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
+	$FSSTRESS_AVOID
+
+run_check _scratch_unmount
+_check_scratch_fs
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/040.out b/tests/btrfs/040.out
new file mode 100644
index 0000000..9e3d4d9
--- /dev/null
+++ b/tests/btrfs/040.out
@@ -0,0 +1,2 @@
+QA output created by 040
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index ba6b70c..3dc82e5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -39,3 +39,4 @@
 034 auto quick
 038 auto quick
 039 auto quick
+040 auto quick
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
