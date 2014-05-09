Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D73B57F51
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 01:06:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E7C2B8F8039
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 23:06:06 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id FwffbbB72kq2fiyJ for
	<xfs@oss.sgi.com>; Thu, 08 May 2014 23:06:01 -0700 (PDT)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v3] xfstests/btrfs: add qgroup rescan stress test
Date: Fri, 9 May 2014 14:02:23 +0800
Message-ID: <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
To: xfs@oss.sgi.com
Cc: jbacik@fb.com, linux-btrfs@vger.kernel.org

Test flow is to run fsstress after triggering quota rescan.
the ruler is simple, we just remove all files and directories,
sync filesystem and see if qgroup's ref and excl are nodesize.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v2->v3: addressed comments from josef:
	- remove unnecessary redirections
	- don't use _run_btrfs_util_prog() when capturing qgroup show output.
	- turn off inode_cache mount option explicitly.

v1->v2: switch to _run_btrfs_util_prog()
---
 tests/btrfs/050     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/050.out |  3 ++
 tests/btrfs/group   |  1 +
 3 files changed, 85 insertions(+)
 create mode 100644 tests/btrfs/050
 create mode 100644 tests/btrfs/050.out

diff --git a/tests/btrfs/050 b/tests/btrfs/050
new file mode 100644
index 0000000..81d953a
--- /dev/null
+++ b/tests/btrfs/050
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FSQA Test No. btrfs/050
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
+# use small leaf size to get higher btree height.
+run_check _scratch_mkfs "-b 1g --nodesize 4096"
+
+# inode cache is saved in the FS tree itself for every
+# individual FS tree,that affects the sizes reported by qgroup show
+# so we need to explicitly turn it off to get consistent values.
+run_check _scratch_mount "-o noinode_cache"
+
+# -w ensures that the only ops are ones which cause write I/O
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT -w -p 5 -n 1000 \
+		$FSSTRESS_AVOID >&/dev/null
+
+_run_btrfs_util_prog subvolume snapshot $SCRATCH_MNT \
+	$SCRATCH_MNT/snap1
+
+run_check $FSSTRESS_PROG -d $SCRATCH_MNT/snap1 -w -p 5 -n 1000 \
+       $FSSTRESS_AVOID >&/dev/null
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog quota rescan -w $SCRATCH_MNT
+
+# ignore removing subvolume errors
+rm -rf $SCRATCH_MNT/* >& /dev/null
+
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT
+$BTRFS_UTIL_PROG qgroup show $SCRATCH_MNT | $SED_PROG -n '/[0-9]/p' \
+	| $AWK_PROG '{print $2" "$3}'
+
+status=0
+exit
diff --git a/tests/btrfs/050.out b/tests/btrfs/050.out
new file mode 100644
index 0000000..a388160
--- /dev/null
+++ b/tests/btrfs/050.out
@@ -0,0 +1,3 @@
+QA output created by 050
+4096 4096
+4096 4096
diff --git a/tests/btrfs/group b/tests/btrfs/group
index 59b0c98..ee3e8a5 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -52,3 +52,4 @@
 047 auto quick
 048 auto quick
 049 auto quick
+050 auto quick
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
