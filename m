Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9BBP8aN257573 for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 06:25:08 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 949531BB025
	for <xfs@oss.sgi.com>; Tue, 11 Oct 2011 04:25:07 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id Vl4yj26mDqNq2JEn for
	<xfs@oss.sgi.com>; Tue, 11 Oct 2011 04:25:07 -0700 (PDT)
Message-ID: <4E94284B.1010909@oracle.com>
Date: Tue, 11 Oct 2011 19:28:11 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/3] 265: Functional test case for the btrfs raid operations
References: <4E3BA2F7.4080500@oracle.com> <4E44351D.4020202@oracle.com>
	<20110902084941.GB29054@infradead.org>
	<4E92C1D7.2010301@oracle.com>
	<20111010112151.GA28627@infradead.org>
In-Reply-To: <20111010112151.GA28627@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

This will verify the various raid features in btrfs and device
replacement functionality

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
  265     |  187 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  265.out |    2 +
  group   |    1 +
  3 files changed, 190 insertions(+), 0 deletions(-)
  create mode 100755 265
  create mode 100644 265.out

diff --git a/265 b/265
new file mode 100755
index 0000000..4e35f6b
--- /dev/null
+++ b/265
@@ -0,0 +1,187 @@
+#! /bin/bash
+# FS QA Test No. 265
+#
+# btrfs vol tests
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Oracle.  All Rights Reserved.
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
+# creator
+owner=anand.jain@oracle.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+dev_removed=0
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+    if [ $dev_removed == 1 ]; then
+	umount $SCRATCH_MNT
+        _devmgt_add "${DEVHTL}"
+    fi
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_need_to_be_root
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+_require_scratch_dev_pool
+_require_deletable_scratch_dev_pool
+
+# Test cases related to raid in btrfs
+_test_raid0()
+{
+	export MKFS_OPTIONS="-m raid0 -d raid0"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+	umount $SCRATCH_MNT
+}
+
+_test_raid1()
+{
+	export MKFS_OPTIONS="-m raid1 -d raid1"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+	umount $SCRATCH_MNT
+}
+
+_test_raid10()
+{
+	export MKFS_OPTIONS="-m raid10 -d raid10"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+	umount $SCRATCH_MNT
+}
+
+_test_single()
+{
+	export MKFS_OPTIONS="-m single -d single"
+	_scratch_mkfs $SCRATCH_DEV_POOL > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+	umount $SCRATCH_MNT
+}
+
+_test_add()
+{
+	local i
+	local devs[]="( $SCRATCH_DEV_POOL )"
+	local n=${#devs[@]}
+
+	n=$(($n-1))
+
+	export MKFS_OPTIONS=""
+	_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+	for i in `seq 1 $n`
+	do
+		btrfs device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail 
"device add failed"
+	done
+	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	#btrfs filesystem show $SCRATCH_DEV 2>&1 | egrep devid |awk '{
+	#	if ( $6 == "0.00" ) { exit 1 }
+	#}' || _fail "test6_add... failed"
+	umount $SCRATCH_MNT
+}
+
+_test_replace()
+{
+	local i
+	local devs=( $SCRATCH_DEV_POOL )
+	local n=${#devs[@]}
+	local ds
+	local d
+	local DEVHTL=""
+
+	# exclude the last disk in the disk pool
+	n=$(($n-1))
+	ds=${devs[@]:0:$n}
+
+	export MKFS_OPTIONS="-m raid1 -d raid1"
+	_scratch_mkfs "$ds" > /dev/null 2>&1 || _fail "tr: mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+
+	#pick the 2nd last disk
+	ds=${devs[@]:$(($n-1)):1}
+
+	# retrive the HTL for this scsi disk
+	d=`echo $ds|cut -d"/" -f3`
+	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
+
+	#fail disk
+	_devmgt_remove ${DEVHTL}
+	dev_removed=1
+
+	btrfs fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null 
|| _fail \
+							"btrfs did not report device missing"
+
+	# add a new disk to btrfs
+	ds=${devs[@]:$(($n)):1}
+	btrfs device add ${ds} $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev add 
failed"
+	# in some system balance fails if there is no delay (a bug)
+	# putting sleep 10 to work around as of now
+	# sleep 10
+	btrfs fi balance $SCRATCH_MNT || _fail "dev balance failed"
+	#btrfs filesystem show | egrep devid |awk '{
+	#	if ( $6 == "0.00" ) { exit 1 }
+	#}' || _fail "btrfs balance failed"
+
+	# cleaup. add the removed disk
+	umount $SCRATCH_MNT
+	_devmgt_add "${DEVHTL}"
+	dev_removed=0
+}
+
+_test_remove()
+{
+	_scratch_mkfs "$SCRATCH_DEV_POOL" > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+
+	# pick last dev in the list
+	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
+	btrfs device delete $dev_del $SCRATCH_MNT || _fail "btrfs device 
delete failed"
+	btrfs fi show $SCRATCH_DEV 2>&1 | grep $dev_del > /dev/null && _fail 
"btrfs still shows the deleted dev"
+	umount $SCRATCH_MNT
+}
+
+_test_raid0
+_test_raid1
+_test_raid10
+_test_single
+_test_add
+_test_replace
+_test_remove
+
+echo "Silence is golden"
+status=0; exit
diff --git a/265.out b/265.out
new file mode 100644
index 0000000..9fa4eb0
--- /dev/null
+++ b/265.out
@@ -0,0 +1,2 @@
+QA output created by 265
+Silence is golden
diff --git a/group b/group
index b5863be..b991b24 100644
--- a/group
+++ b/group
@@ -378,3 +378,4 @@ deprecated
  262 auto quick quota
  263 auto quick
  264 auto quick
+265 auto
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
