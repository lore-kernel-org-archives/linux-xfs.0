Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:53826 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750873AbdKHH5I (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Nov 2017 02:57:08 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v2 3/4] xfs: test for umount hang caused by the pending dquota log item in AIL
Date: Wed, 8 Nov 2017 16:02:49 +0800
Message-ID: <20171108080250.5662-4-houtao1@huawei.com>
In-Reply-To: <20171108080250.5662-1-houtao1@huawei.com>
References: <20171108080250.5662-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, cmaiolino@redhat.com

When the first writeback and the retried writeback of dquota buffer get
the same IO error, XFS will let xfsaild to restart the writeback and
xfs_qm_dqflush_done() will not be invoked. xfsaild will try to re-push
the quota log item in AIL, the push will return early everytime after
checking xfs_dqflock_nowait(), and xfsaild will try to push it again.

IOWs, AIL will never be empty, and the umount process will wait for the
drain of AIL, so the umount process hangs.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tests/xfs/999     | 171 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/999.out |   2 +
 tests/xfs/group   |   1 +
 3 files changed, 174 insertions(+)
 create mode 100755 tests/xfs/999
 create mode 100644 tests/xfs/999.out

diff --git a/tests/xfs/999 b/tests/xfs/999
new file mode 100755
index 0000000..cea2f85
--- /dev/null
+++ b/tests/xfs/999
@@ -0,0 +1,171 @@
+#! /bin/bash
+# FS QA Test No. 999
+#
+# Test for XFS umount hang problem caused by the unceasing push
+# of dquot log item in AIL. Because xfs_qm_dqflush_done() will
+# not be invoked, so each time xfsaild initiates the push,
+# the push will return early after checking xfs_dqflock_nowait().
+#
+# xfs_qm_dqflush_done() should be invoked by xfs_buf_do_callbacks().
+# However after the first write and the retried write of dquota buffer
+# get the same IO error, XFS will let xfsaild to restart the write and
+# xfs_buf_do_callbacks() will not be inovked.
+#
+# This test emulates the write error by using dm-flakey. The log
+# area of the XFS filesystem is excluded from the range covered by
+# dm-flakey, so the XFS will not be shutdown prematurely.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Huawei Technologies Co., Ltd. All Rights Reserved.
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
+	[ -z "${interval}" ] || \
+		sysctl -w fs.xfs.xfssyncd_centisecs=${interval} >/dev/null 2>&1
+	cd /
+	rm -f $tmp.*
+	_unmount_flakey >/dev/null 2>&1
+	_cleanup_flakey > /dev/null 2>&1
+}
+
+_get_xfs_scratch_sb_field()
+{
+	local field=$1
+
+	_scratch_xfs_db -r -c "sb 0" -c "print $field" | \
+	awk -v field=$field '$0 ~ field {print $3}'
+}
+
+# inject IO write error for the XFS filesystem except its log section
+make_xfs_scratch_flakey_table()
+{
+	local tgt=flakey
+	local opt="0 1 1 error_writes"
+	local dev=${SCRATCH_DEV}
+	local dev_sz=$(blockdev --getsz $dev)
+
+	if [ "${USE_EXTERNAL}" = "yes" -a ! -z "$SCRATCH_LOGDEV" ]; then
+		echo "0 ${dev_sz} $tgt $dev 0 $opt"
+		return
+	fi
+
+	local blk_sz=$(_get_xfs_scratch_sb_field blocksize)
+	local log_ofs=$(_get_xfs_scratch_sb_field logstart)
+	local log_sz=$(_get_xfs_scratch_sb_field logblocks)
+	local table=""
+	local ofs=0
+	local sz
+
+	let "log_ofs *= blk_sz / 512"
+	let "log_sz *= blk_sz / 512"
+
+	if [ "$ofs" -lt "${log_ofs}" ]; then
+		let "sz = log_ofs - ofs"
+		table="$ofs $sz $tgt $dev $ofs $opt"
+	fi
+
+	table="$table\n${log_ofs} ${log_sz} linear $dev ${log_ofs}"
+
+	let "ofs = log_ofs + log_sz"
+	if [ "$ofs" -lt "${dev_sz}" ]; then
+		let "sz = dev_sz - ofs"
+		table="$table\n$ofs $sz $tgt $dev $ofs $opt"
+	fi
+
+	echo -e $table
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/dmflakey
+. ./common/quota
+
+_supported_fs xfs
+_supported_os Linux
+
+# due to the injection of write IO error, the fs will be inconsistent
+_require_scratch_nocheck
+# error_writes feature is introduced in dm-flakey v1.4.0, so check for that
+_require_dm_target flakey "1.4.0"
+_require_user
+_require_xfs_quota
+_require_freeze
+
+rm -f $seqres.full
+
+echo "Silence is golden"
+
+_scratch_mkfs_xfs > $seqres.full 2>&1
+
+# no error will be injected
+_init_flakey
+$DMSETUP_PROG info >> $seqres.full
+$DMSETUP_PROG table >> $seqres.full
+
+# save the old value for _cleanup()
+interval=$(sysctl -n fs.xfs.xfssyncd_centisecs 2>/dev/null)
+# shorten the time waiting for the push of ail items
+sysctl -w fs.xfs.xfssyncd_centisecs=100 >> $seqres.full 2>&1
+
+_qmount_option "usrquota"
+_mount_flakey
+
+# We need to set the quota limitation twice, and inject the write error
+# after the second setting. If we try to inject the write error after
+# the first setting, the initialization of the dquota buffer will get
+# IO error and also be retried, and during the umount process the
+# write will be ended, and xfs_qm_dqflush_done() will be inovked, and
+# the umount will exit normally.
+$XFS_QUOTA_PROG -x -c "limit -u isoft=500 fsgqa" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c "report -ih" $SCRATCH_MNT >> $seqres.full
+
+# ensure the initialization of the dquota buffer is done
+xfs_freeze -f $SCRATCH_MNT
+xfs_freeze -u $SCRATCH_MNT
+
+# inject write IO error
+FLAKEY_TABLE_DROP=$(make_xfs_scratch_flakey_table)
+_load_flakey_table ${FLAKEY_DROP_WRITES}
+$DMSETUP_PROG info >> $seqres.full
+$DMSETUP_PROG table >> $seqres.full
+
+# update the dquota buffer
+$XFS_QUOTA_PROG -x -c "limit -u isoft=400 fsgqa" $SCRATCH_MNT
+$XFS_QUOTA_PROG -x -c "report -ih" $SCRATCH_MNT >> $seqres.full
+
+sync
+
+# wait for the push of the dquota log item in AIL and
+# the completion of the retried write of dquota buffer
+sleep 2
+
+_unmount_flakey
+
+_cleanup_flakey
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/999.out b/tests/xfs/999.out
new file mode 100644
index 0000000..3b276ca
--- /dev/null
+++ b/tests/xfs/999.out
@@ -0,0 +1,2 @@
+QA output created by 999
+Silence is golden
diff --git a/tests/xfs/group b/tests/xfs/group
index b439842..127019a 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -431,3 +431,4 @@
 431 auto quick dangerous
 432 auto quick dir metadata
 433 auto quick attr
+999 auto quick quota dangerous
-- 
2.9.5

