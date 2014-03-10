Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 22E587F52
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2014 22:46:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06F45304051
	for <xfs@oss.sgi.com>; Sun,  9 Mar 2014 20:46:42 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id Kgva8iOnGFlSbaKl for
	<xfs@oss.sgi.com>; Sun, 09 Mar 2014 20:46:39 -0700 (PDT)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v2 2/3] xfstests/btrfs: add basic functional test for btrfs
	quota groups
Date: Mon, 10 Mar 2014 11:44:10 +0800
Message-Id: <1394423051-17356-2-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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

Add missing test for btrfs quota groups feature,test idea is to create
a parent qgroup that groups some subvolume groups, we try to write
some data into every subvolume and then check if we exceed parent
qgroup's limit size.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
	switch into new helper _run_btrfs_util_prog()
	use 'XFS_IO_PROG' instead of 'dd'
---
 tests/btrfs/042     | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/042.out |  2 ++
 tests/btrfs/group   |  1 +
 3 files changed, 98 insertions(+)
 create mode 100755 tests/btrfs/042
 create mode 100644 tests/btrfs/042.out

diff --git a/tests/btrfs/042 b/tests/btrfs/042
new file mode 100755
index 0000000..498ccc9
--- /dev/null
+++ b/tests/btrfs/042
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 042
+#
+# Test the basic functionality of Quota groups
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
+	cd /
+	rm -f $tmp.*
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
+run_check _scratch_mkfs
+run_check _scratch_mount
+
+LIMIT_SIZE=$((10 * 1024 * 1024))
+
+_run_btrfs_util_prog quota enable $SCRATCH_MNT
+_run_btrfs_util_prog qgroup create 1/1 $SCRATCH_MNT
+_run_btrfs_util_prog qgroup limit $LIMIT_SIZE 1/1 $SCRATCH_MNT
+
+for i in `seq 10 -1 1`; do
+	#add newly created subvolume qgroup to it's parent qgroup
+	_run_btrfs_util_prog subvolume create -i 1/1 \
+		$SCRATCH_MNT/subv_$i
+done
+
+#try to write data into every subvolume
+for i in `seq 10 -1 1`; do
+	$XFS_IO_PROG -f -d -c 'pwrite -b 4k 0 10m' $SCRATCH_MNT/subv_$i/data \
+		>> /dev/null 2>&1 &
+done
+
+wait
+_run_btrfs_util_prog filesystem sync $SCRATCH_MNT \
+	>>$seqres.full 2>&1
+
+total_written=0
+#calculate every subvolume's data.
+for i in `seq 10 -1 1`; do
+	#we may fail to create the file, skip this subvolume
+	test -f $SCRATCH_MNT/subv_$i || continue
+
+	filesize=`du -b $SCRATCH_MNT/subv_$i/data | $AWK_PROG '{print $1}'`
+	if [ $filesize -gt $LIMIT_SIZE ];then
+		_fail "subv_$i/data size should be less than $LIMIT_SIZE"
+	fi
+	total_written=$(($total_written+$filesize))
+done
+
+#check if total written exceeds limit
+if [ $total_written -gt $LIMIT_SIZE ];then
+	_fail "total written should be less than $LIMIT_SIZE"
+fi
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/btrfs/042.out b/tests/btrfs/042.out
new file mode 100644
index 0000000..85eac7a
--- /dev/null
+++ b/tests/btrfs/042.out
@@ -0,0 +1,2 @@
+QA output created by 042
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index fd0193c..1037761 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -44,3 +44,4 @@
 039 auto quick
 040 auto quick
 041 auto quick
+042 auto quick
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
