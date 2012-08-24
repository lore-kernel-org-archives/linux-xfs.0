Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7O87qMU205540 for <xfs@oss.sgi.com>; Fri, 24 Aug 2012 03:07:53 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id WJnmXBvIzeX4AsmD for
	<xfs@oss.sgi.com>; Fri, 24 Aug 2012 01:08:38 -0700 (PDT)
Message-ID: <50373668.3000804@cn.fujitsu.com>
Date: Fri, 24 Aug 2012 16:08:08 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH V2 3/3] xfstests: fix wrong number of the required devices
	and wrong deletable device check method for case 265
References: <5036F1FB.80205@cn.fujitsu.com>
In-Reply-To: <5036F1FB.80205@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com
Cc: anand.jain@oracle.com

Case 265 need 4 devices to test RAID10, so we need 4 or more devices not 2.
And the deletable device check method is also wrong, the virtual devices in
the VMs which are drived by virtio are also not deletable(no delete entry
point), but it is not managed in the virtual directory in sysfs, so the current
method will make a mistake and thinks they are deletable. Fix it by check
the delete entry point. This fix method can also avoid the users use
partitions to run case 265.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Changelog v1 -> v2:
- drop the independent device check
- modify the deletable device check
- do not modify README
---
 265       |    2 +-
 common.rc |   18 ++++++++++--------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/265 b/265
index ec8410c..0687b62 100755
--- a/265
+++ b/265
@@ -50,7 +50,7 @@ _need_to_be_root
 _supported_fs btrfs
 _supported_os Linux
 _require_scratch
-_require_scratch_dev_pool
+_require_scratch_dev_pool 4
 _require_deletable_scratch_dev_pool
 
 # Test cases related to raid in btrfs
diff --git a/common.rc b/common.rc
index 602513a..a254e0e 100644
--- a/common.rc
+++ b/common.rc
@@ -1695,16 +1695,20 @@ _test_inode_extsz()
 _require_scratch_dev_pool()
 {
 	local i
+	local ndevs=$1
 	if [ -z "$SCRATCH_DEV_POOL" ]; then
 		_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
 	fi
 
-	# btrfs test case needs 2 or more scratch_dev_pool; other FS not sure
+	# btrfs test case needs scratch_dev_pool; other FS not sure
 	# so fail it
 	case $FSTYP in
 	btrfs)
-		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]; then
-			_notrun "btrfs and this test needs 2 or more disks in SCRATCH_DEV_POOL"
+		# We have moved a device from SCRATCH_DEV_POOL tp SCRATCH_DEV,
+		# so we must make it into account.
+		if [ $((`echo $SCRATCH_DEV_POOL | wc -w` + 1)) -lt $ndevs ]
+		then
+			_notrun "btrfs and this test needs $ndevs or more disks in SCRATCH_DEV_POOL"
 		fi
 	;;
 	*)
@@ -1731,17 +1735,15 @@ _require_scratch_dev_pool()
 	done
 }
 
-# We will check if the device is virtual (eg: loop device) since it does not
-# have the delete entry-point. Otherwise SCSI and USB devices are fine. 
+# We will check if the device is deletable. 
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
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
