Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D02A7F37
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 03:12:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B6E8AC007
	for <xfs@oss.sgi.com>; Mon,  6 Jan 2014 01:12:34 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id WMq4zSA3GnNnfffy for
	<xfs@oss.sgi.com>; Mon, 06 Jan 2014 01:12:29 -0800 (PST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: [PATCH] xfstests: Enhance the scratch dev pool and deletable device
	check
Date: Mon, 6 Jan 2014 17:13:18 +0800
Message-Id: <1388999598-17058-1-git-send-email-quwenruo@cn.fujitsu.com>
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Cc: Miao Xie <miaox@cn.fujitsu.com>

From: Miao Xie <miaox@cn.fujitsu.com>

From: Miao Xie <miaox@cn.fujitsu.com>

_require_scratch_dev_pool() checks the devices number in
SCRATCH_DEV_POOL, but it's not enough since some btrfs RAID10 tests
needs 4 devices, but when 3 or less devices are provided, the check is
useless and related test case will fail(btrfs/003 btrfs/011 btrfs/023).

Also _require_deletable_scratch_dev_pool only checks whether it is
virtul, like virtio(not including virtio-scsi) disk will pass the check
but is unable to delete.

This patch enhance _require_scratch_dev_pool by add optional $1 as
needed device number to do extra check.
And enhance _require_deletable_scratch_dev_pool by directly check
/sys/class/block/$DEV/device/delete file.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 common/rc       | 22 ++++++++++++++--------
 tests/btrfs/003 |  2 +-
 tests/btrfs/011 |  2 +-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/common/rc b/common/rc
index a2005c9..09644af 100644
--- a/common/rc
+++ b/common/rc
@@ -1927,16 +1927,24 @@ _test_inode_extsz()
 _require_scratch_dev_pool()
 {
 	local i
+	local ndevs
+
 	if [ -z "$SCRATCH_DEV_POOL" ]; then
 		_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
 	fi
 
-	# btrfs test case needs 2 or more scratch_dev_pool; other FS not sure
+	if [ -z "$1" ]; then
+		ndevs=2
+	else
+		ndevs=$1
+	fi
+
+	# btrfs test case needs ndevs or more scratch_dev_pool; other FS not sure
 	# so fail it
 	case $FSTYP in
 	btrfs)
-		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]; then
-			_notrun "btrfs and this test needs 2 or more disks in SCRATCH_DEV_POOL"
+		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt $ndevs ]; then
+			_notrun "btrfs and this test needs $ndevs or more disks in SCRATCH_DEV_POOL"
 		fi
 	;;
 	*)
@@ -1963,17 +1971,15 @@ _require_scratch_dev_pool()
 	done
 }
 
-# We will check if the device is virtual (eg: loop device) since it does not
-# have the delete entry-point. Otherwise SCSI and USB devices are fine. 
+# We will check if the device is deletable
 _require_deletable_scratch_dev_pool()
 {
 	local i
 	local x
 	for i in $SCRATCH_DEV_POOL; do
 		x=`echo $i | cut -d"/" -f 3`
-		ls -l /sys/class/block/${x} | grep -q "virtual" 
-		if [ $? == "0" ]; then
-			_notrun "$i is a virtual device which is not deletable"
+		if [ ! -f /sys/class/block/${x}/device/delete ]; then
+			_notrun "$i is a device which is not deletable"
 		fi
 	done
 }
diff --git a/tests/btrfs/003 b/tests/btrfs/003
index 9105d06..29f947b 100755
--- a/tests/btrfs/003
+++ b/tests/btrfs/003
@@ -49,7 +49,7 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_scratch_dev_pool
+_require_scratch_dev_pool 4
 _require_deletable_scratch_dev_pool
 _require_command $WIPEFS_PROG
 
diff --git a/tests/btrfs/011 b/tests/btrfs/011
index 71ff3de..faa0402 100755
--- a/tests/btrfs/011
+++ b/tests/btrfs/011
@@ -62,7 +62,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _need_to_be_root
 _supported_fs btrfs
 _require_scratch
-_require_scratch_dev_pool
+_require_scratch_dev_pool 4
 _require_command $BTRFS_SHOW_SUPER_PROG btrfs-show-super
 
 rm -f $seqres.full
-- 
1.8.5.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
