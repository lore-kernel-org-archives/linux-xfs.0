Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9KFc4g5009909 for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 10:38:04 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68E561C9F332
	for <xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:38:02 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id BYfiB6czclggeJo8 for
	<xfs@oss.sgi.com>; Thu, 20 Oct 2011 08:38:02 -0700 (PDT)
From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 2/5] Added SCRATCH_DEV_POOL to specify multiple disks for the
	btrfs RAID
Date: Thu, 20 Oct 2011 23:41:19 +0800
Message-Id: <1319125282-17062-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
References: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
	<1319125282-17062-1-git-send-email-Anand.Jain@oracle.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Cc: Anand Jain <Anand.Jain@oracle.com>

SCRATCH_DEV takes single disk as the scratch place for testing. New
SCRATCH_DEV_POOL can used to specify multiple disks for the scratch
btrfs filesystem.

Using SCRATCH_DEV and or SCRATCH_DEV_POOL will follow the following logic.
  btrfs FS OR any FS
    SCRATCH_DEV_POOL is unset and SCRATCH_DEV is set
     . test-case with _require_scratch_dev_pool will not run
     . test-case without _require_scratch_dev_pool will run

    SCRATCH_DEV_POOL is set and SCRATCH_DEV is unset
     . test-case with _require_scratch_dev_pool
         - runs only if FSTYP=btrfs
     . test-case without _require_scratch_dev_pool will run using first
       dev in the SCRATCH_DEV_POOL as a SCRATCH_DEV
         - if FSTYP=btrfs it includes SCRATCH_DEV_POOL disks to the FS
         - if FSTYP=non-btrfs SCRATCH_DEV_POOL is ignored

    SCRATCH_DEV_POOL is set and SCRATCH_DEV is set
     . reports error in the config

    SCRATCH_DEV_POOL is unset and SCRATCH_DEV is unset
     . no change

Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
 README        |   16 +++++++++---
 common.config |   11 ++++++++
 common.rc     |   76 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/README b/README
index 5367be6..0f52f02 100644
--- a/README
+++ b/README
@@ -34,14 +34,22 @@ Preparing system for tests (IRIX and Linux):
             - leave empty and expect this partition to be clobbered
               by some tests.  If this is not provided, many tests will
               not be run.
-              
-        (these must be two DIFFERENT partitions)
+              (SCRATCH and TEST must be two DIFFERENT partitions)
+              OR
+        - for btrfs only: some btrfs test cases will need 3 or more independent
+              SCRATCH disks which should be set using SCRATCH_DEV_POOL (for eg:
+              SCRATCH_DEV_POOL="/dev/sda /dev/sdb /dev/sdc") with which
+              SCRATCH_DEV should be unused by the tester, and for the legacy
+              support SCRATCH_DEV will be set to the first disk of the
+              SCRATCH_DEV_POOL by xfstests script.
               
     - setup your environment
         - setenv TEST_DEV "device containing TEST PARTITION"
         - setenv TEST_DIR "mount point of TEST PARTITION"   
        	- optionally:
-             - setenv SCRATCH_DEV "device containing SCRATCH PARTITION"
+             - setenv SCRATCH_DEV "device containing SCRATCH PARTITION" OR
+               (btrfs only) setenv SCRATCH_DEV_POOL "to 3 or more SCRATCH disks for
+               testing btrfs raid concepts"
              - setenv SCRATCH_MNT "mount point for SCRATCH PARTITION"
              - setenv TAPE_DEV "tape device for testing xfsdump"
              - setenv RMT_TAPE_DEV "remote tape device for testing xfsdump"
@@ -63,7 +71,7 @@ Preparing system for tests (IRIX and Linux):
       tape which can be overwritten.
           
     - make sure $TEST_DEV is a mounted XFS partition
-    - make sure that $SCRATCH_DEV contains nothing useful
+    - make sure that $SCRATCH_DEV or $SCRATCH_DEV_POOL contains nothing useful
     
 Running tests:
 
diff --git a/common.config b/common.config
index e94624e..1df2bbd 100644
--- a/common.config
+++ b/common.config
@@ -229,6 +229,17 @@ if [ ! -d "$TEST_DIR" ]; then
     exit 1
 fi
 
+# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of its dev
+# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
+if [ ! -z "$SCRATCH_DEV_POOL" ]; then
+    if [ ! -z "$SCRATCH_DEV" ]; then
+        echo "common.config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
+        exit 1
+    fi
+    SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
+    SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | awk '{ for (i = 2; i <= NF; i++) print $i}'`
+fi
+
 echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
 if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
     echo "common.config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a block device or a NFS filesystem"
diff --git a/common.rc b/common.rc
index 37379a5..e3c4e67 100644
--- a/common.rc
+++ b/common.rc
@@ -1499,7 +1499,7 @@ _nfiles()
                 file=f$f
                 echo > $file
                 if [ $size -gt 0 ]; then
-                    if [ $2 == false ]; then
+                    if [ "$2" == "false" ]; then
                         dd if=/dev/zero of=$file bs=1024 count=$size 2>&1 | _filter_dd
                     else
                         dd if=/dev/urandom of=$file bs=1024 count=$size 2>&1 | _filter_dd
@@ -1598,6 +1598,80 @@ _test_inode_extsz()
     echo $blocks
 }
 
+# scratch_dev_pool should contain the disks pool for the btrfs raid
+_require_scratch_dev_pool()
+{
+	local i
+	if [ -z "$SCRATCH_DEV_POOL" ]; then
+		_notrun "this test requires a valid \$SCRATCH_DEV_POOL"
+	fi
+
+	# btrfs test case needs 2 or more scratch_dev_pool; other FS not sure
+	# so fail it
+	case $FSTYP in
+	btrfs)
+		if [ "`echo $SCRATCH_DEV_POOL|wc -w`" -lt 2 ]; then
+			_notrun "btrfs and this test needs 2 or more disks in SCRATCH_DEV_POOL"
+		fi
+	;;
+	*)
+		_notrun "dev_pool is not supported by fstype \"$FSTYP\""
+	;;
+	esac
+
+	for i in $SCRATCH_DEV_POOL; do
+		if [ "`_is_block_dev $i`" = "" ]; then
+			_notrun "this test requires valid block disk $i"
+		fi
+		if [ "`_is_block_dev $i`" = "`_is_block_dev $TEST_DEV`" ]; then
+			_notrun "$i is part of TEST_DEV, this test requires unique disks"
+		fi
+		if _mount | grep -q $i; then
+			if ! $UMOUNT_PROG $i; then
+		            echo "failed to unmount $i - aborting"
+		            exit 1
+		        fi
+		fi
+		# to help better debug when something fails, we remove
+		# traces of previous btrfs FS on the dev.
+		dd if=/dev/zero of=$i bs=4096 count=100 > /dev/null 2>&1
+	done
+}
+
+# We will check if the device is virtual (eg: loop device) since it does not
+# have the delete entry-point. Otherwise SCSI and USB devices are fine. 
+_require_deletable_scratch_dev_pool()
+{
+	local i
+	local x
+	for i in $SCRATCH_DEV_POOL; do
+		x=`echo $i | cut -d"/" -f 3`
+		ls -l /sys/class/block/${x} | grep -q "virtual" 
+		if [ $? == "0" ]; then
+			_notrun "$i is a virtual device which is not deletable"
+		fi
+	done
+}
+
+# arg 1 is dev to remove and is output of the below eg.
+# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
+_devmgt_remove()
+{
+	echo 1 > /sys/class/scsi_device/${1}/device/delete || _fail "Remove disk failed"
+}
+
+# arg 1 is dev to add and is output of the below eg.
+# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
+_devmgt_add()
+{
+	local h
+	local tdl
+	# arg 1 will be in h:t:d:l format now in the h and "t d l" format
+	h=`echo ${1} | cut -d":" -f 1`
+	tdl=`echo ${1} | cut -d":" -f 2-|sed 's/:/ /g'`
+
+	echo ${tdl} >  /sys/class/scsi_host/host${h}/scan || _fail "Add disk failed"
+}
 
 ################################################################################
 
-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
