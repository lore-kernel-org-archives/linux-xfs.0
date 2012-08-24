Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7O3FtnD144328 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 22:15:57 -0500
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id X7vKVngIqShkikbX for
	<xfs@oss.sgi.com>; Thu, 23 Aug 2012 20:16:41 -0700 (PDT)
Message-ID: <5036F1FB.80205@cn.fujitsu.com>
Date: Fri, 24 Aug 2012 11:16:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 3/3] xfstests: fix wrong number of the required devices and
	add independent device check for case 265
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
and it is better that these 4 devices are independent devices, especially
the 2nd last one, so we add independent device check to check the devices
in SCRATCH_DEV_POOL.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 265       |    1 +
 README    |    4 ++--
 common.rc |   22 +++++++++++++++++++---
 3 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/265 b/265
index ec8410c..947e65b 100755
--- a/265
+++ b/265
@@ -51,6 +51,7 @@ _supported_fs btrfs
 _supported_os Linux
 _require_scratch
 _require_scratch_dev_pool
+_require_independent_scratch_dev_pool
 _require_deletable_scratch_dev_pool
 
 # Test cases related to raid in btrfs
diff --git a/README b/README
index d81ede9..bb10dba 100644
--- a/README
+++ b/README
@@ -38,7 +38,7 @@ Preparing system for tests (IRIX and Linux):
               not be run.
               (SCRATCH and TEST must be two DIFFERENT partitions)
               OR
-        - for btrfs only: some btrfs test cases will need 3 or more independent
+        - for btrfs only: some btrfs test cases will need 4 or more independent
               SCRATCH disks which should be set using SCRATCH_DEV_POOL (for eg:
               SCRATCH_DEV_POOL="/dev/sda /dev/sdb /dev/sdc") with which
               SCRATCH_DEV should be unused by the tester, and for the legacy
@@ -50,7 +50,7 @@ Preparing system for tests (IRIX and Linux):
         - setenv TEST_DIR "mount point of TEST PARTITION"   
        	- optionally:
              - setenv SCRATCH_DEV "device containing SCRATCH PARTITION" OR
-               (btrfs only) setenv SCRATCH_DEV_POOL "to 3 or more SCRATCH disks for
+               (btrfs only) setenv SCRATCH_DEV_POOL "to 4 or more SCRATCH disks for
                testing btrfs raid concepts"
              - setenv SCRATCH_MNT "mount point for SCRATCH PARTITION"
              - setenv TAPE_DEV "tape device for testing xfsdump"
diff --git a/common.rc b/common.rc
index 602513a..ede25fe 100644
--- a/common.rc
+++ b/common.rc
@@ -1699,12 +1699,14 @@ _require_scratch_dev_pool()
 		_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
 	fi
 
-	# btrfs test case needs 2 or more scratch_dev_pool; other FS not sure
+	# btrfs test case needs 4 or more scratch_dev_pool; other FS not sure
 	# so fail it
+	# common.config has moved the first device to SCRATCH_DEV, so
+	# SCRATCH_DEV_POOL should have 3 or more disks.
 	case $FSTYP in
 	btrfs)
-		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]; then
-			_notrun "btrfs and this test needs 2 or more disks in SCRATCH_DEV_POOL"
+		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 3 ]; then
+			_notrun "btrfs and this test needs 4 or more disks in SCRATCH_DEV_POOL"
 		fi
 	;;
 	*)
@@ -1746,6 +1748,20 @@ _require_deletable_scratch_dev_pool()
 	done
 }
 
+# We will check if the device is independent device.
+_require_independent_scratch_dev_pool()
+{
+	local i
+	local dev
+	for i in $SCRATCH_DEV_POOL; do
+		dev=${i/*\//}
+		[[ ! $dev == md* && $dev == *[0-9] ]] && \
+			_notrun "$i is not a independent device"
+		[[ $dev == md* && $dev == md[0-9]*p[0-9]* ]] && \
+			_notrun "$i is not a independent device"
+	done
+}
+
 # We check for btrfs and (optionally) features of the btrfs command
 _require_btrfs()
 {
-- 
1.7.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
