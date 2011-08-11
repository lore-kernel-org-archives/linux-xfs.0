Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BJr8fH002775 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 14:53:08 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3541136762D
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 12:54:42 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id ykjiP4nMpoF9ofB8 for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2011 12:54:42 -0700 (PDT)
Message-ID: <4E44351D.4020202@oracle.com>
Date: Fri, 12 Aug 2011 04:01:33 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 3/3] Added test case 259 for the btrfs raid features
References: <4E3BA2F7.4080500@oracle.com>
In-Reply-To: <4E3BA2F7.4080500@oracle.com>
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
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Chris Mason <chris.mason@oracle.com>

Added test case 259 for the btrfs raid features. SCRATCH_DEV_POOL must
be set to 2 or more disks.

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
  259       |  186 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  259.out   |    2 +
  common.rc |    6 ++
  group     |    1 +
  4 files changed, 195 insertions(+), 0 deletions(-)
  create mode 100755 259
  create mode 100644 259.out

diff --git a/259 b/259
new file mode 100755
index 0000000..b4ba403
--- /dev/null
+++ b/259
@@ -0,0 +1,186 @@
+#! /bin/bash
+# FS QA Test No. 259
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
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
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
+_require_proc_scsi
+
+# arg 1 remove/add
+# arg 2 /dev/sdx or return of devmgt resply
+_devmgt()
+{
+	local x
+	local d
+
+	if [ $1 == "remove" ]; then
+		d=`echo $2|cut -d"/" -f3`
+		x=`ls -l /sys/class/block/${d} | cut -d "/" -f12 | sed 's/:/ /g'`
+		echo "scsi remove-single-device ${x}" > /proc/scsi/scsi || _fail 
"Remove disk failed"
+		DEVHTL=${x}
+	else
+		echo "scsi add-single-device ${2}" > /proc/scsi/scsi || _fail "Add 
disk failed"
+	fi
+}
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
+	local x
+	local devs=( $SCRATCH_DEV_POOL )
+	local n=${#devs[@]}
+	local ds
+	local DEVHTL=""
+
+	# exclude the last disk in the disk pool
+	n=$(($n-1))
+	ds=${devs[@]:0:$n}
+
+	export MKFS_OPTIONS=""
+	_scratch_mkfs "$ds" > /dev/null 2>&1 || _fail "mkfs failed"
+	_scratch_mount
+	_fillfs 1 10 100 4096 8192 $SCRATCH_MNT
+
+	#pick the 2nd last disk
+	ds=${devs[@]:$(($n-1)):1}
+
+	#fail disk
+	_devmgt remove ${ds}
+
+	btrfs fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null 
|| _fail \
+							"btrfs did not report device missing"
+
+	# add a new disk to btrfs
+	ds=${devs[@]:$(($n)):1}
+	btrfs device add ${ds} $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev add 
failed"
+
+	# cleaup. add the removed disk
+	umount $SCRATCH_MNT
+	_devmgt add "${DEVHTL}"
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
diff --git a/259.out b/259.out
new file mode 100644
index 0000000..bfbd2de
--- /dev/null
+++ b/259.out
@@ -0,0 +1,2 @@
+QA output created by 259
+Silence is golden
diff --git a/common.rc b/common.rc
index db7c2dd..aa45a7e 100644
--- a/common.rc
+++ b/common.rc
@@ -1646,6 +1646,12 @@ _require_scratch_dev_pool()
  	;;
  	esac
  }
+
+# we need this to test removing a dev from the system
+_require_proc_scsi()
+{
+	[ -e /proc/scsi/scsi ]  || _notrun "/proc/scsi/scsi is not present"
+}
 
################################################################################

  if [ "$iam" != new -a "$iam" != bench ]
diff --git a/group b/group
index 739f806..62eebfb 100644
--- a/group
+++ b/group
@@ -372,3 +372,4 @@ deprecated
  256 auto quick
  257 auto quick
  258 auto quick
+259 auto quick
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
