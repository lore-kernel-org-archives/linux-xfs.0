Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6BF687FD5
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 04:37:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 428CA304032
	for <xfs@oss.sgi.com>; Tue,  6 May 2014 02:37:46 -0700 (PDT)
Received: from heian.cn.fujitsu.com (cn.fujitsu.com [59.151.112.132]) by
	cuda.sgi.com with ESMTP id tAPlrAVCoaceWuek for
	<xfs@oss.sgi.com>; Tue, 06 May 2014 02:37:44 -0700 (PDT)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH] xfstests: add regression test for inode cache vs tree log
Date: Tue, 6 May 2014 17:31:24 +0800
Message-ID: <1399368684-1585-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
Cc: linux-btrfs@vger.kernel.org

This patch adds a regression test to verify btrfs can not
reuse inode id until we have committed transaction. Which was
addressed by the following kernel patch:

 Btrfs: fix inode cache vs tree log

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/049     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/049.out |   1 +
 tests/btrfs/group   |   1 +
 3 files changed, 111 insertions(+)
 create mode 100644 tests/btrfs/049
 create mode 100644 tests/btrfs/049.out

diff --git a/tests/btrfs/049 b/tests/btrfs/049
new file mode 100644
index 0000000..3101d09
--- /dev/null
+++ b/tests/btrfs/049
@@ -0,0 +1,109 @@
+#! /bin/bash
+# FS QA Test No. btrfs/049
+#
+# Regression test for btrfs inode caching vs tree log which was
+# addressed by the following kernel patch.
+#
+# Btrfs: fix inode caching vs tree log
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
+
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_flakey
+	rm -rf $tmp
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/dmflakey
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_need_to_be_root
+_require_scratch
+_require_dm_flakey
+
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1
+
+SAVE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
+MOUNT_OPTIONS="$MOUNT_OPTIONS -o inode_cache,commit=100"
+
+# create a basic flakey device that will never error out
+_init_flakey
+_mount_flakey
+
+_get_inode_id()
+{
+	local inode_id
+	inode_id=`stat $1 | grep Inode: | $AWK_PROG '{print $4}'`
+	echo $inode_id
+}
+
+$XFS_IO_PROG -f -c "pwrite 0 10M" -c "fsync" \
+	$SCRATCH_MNT/data >& /dev/null
+
+inode_id=`_get_inode_id "$SCRATCH_MNT/data"`
+rm -f $SCRATCH_MNT/data
+
+for i in `seq 1 5`;
+do
+	mkdir $SCRATCH_MNT/dir_$i
+	new_inode_id=`_get_inode_id $SCRATCH_MNT/dir_$i`
+	if [ $new_inode_id -eq $inode_id ]
+	then
+		$XFS_IO_PROG -f -c "pwrite 0 1M" -c "fsync" \
+			$SCRATCH_MNT/dir_$i/data1 >& /dev/null
+		_load_flakey_table 1
+		_unmount_flakey
+		need_umount=1
+		break
+	fi
+	sleep 1
+done
+
+# restore previous mount options
+export MOUNT_OPTIONS="$SAVE_MOUNT_OPTIONS"
+
+# ok mount so that any recovery that needs to happen is done
+if [ $new_inode_id -eq $inode_id ];then
+	_load_flakey_table $FLAKEY_ALLOW_WRITES
+	_mount_flakey
+	_unmount_flakey
+fi
+
+# make sure we got a valid fs after replay
+_check_scratch_fs $FLAKEY_DEV
+
+status=0
+exit
diff --git a/tests/btrfs/049.out b/tests/btrfs/049.out
new file mode 100644
index 0000000..cb0061b
--- /dev/null
+++ b/tests/btrfs/049.out
@@ -0,0 +1 @@
+QA output created by 049
diff --git a/tests/btrfs/group b/tests/btrfs/group
index af60c79..59b0c98 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -51,3 +51,4 @@
 046 auto quick
 047 auto quick
 048 auto quick
+049 auto quick
-- 
1.8.2.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
