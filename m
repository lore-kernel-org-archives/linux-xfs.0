Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A9tjbX167423 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 04:55:46 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4CF8E16BA148
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 03:02:53 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id XS7kDwUPMToxg8w4 for
	<xfs@oss.sgi.com>; Mon, 10 Oct 2011 03:02:53 -0700 (PDT)
Message-ID: <4E92C1D7.2010301@oracle.com>
Date: Mon, 10 Oct 2011 17:58:47 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
Subject: [PATCH] Changes to received review comments
References: <4E3BA2F7.4080500@oracle.com> <4E44351D.4020202@oracle.com>
	<20110902084941.GB29054@infradead.org>
In-Reply-To: <20110902084941.GB29054@infradead.org>
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

  Now SCRATCH_DEV is derived from SCRATCH_DEV_POOL.
  Moved code to delete and scan block device to common.rc and
  updated README.


Signed-off-by: Anand Jain <Anand.Jain@oracle.com>
---
  259           |   29 ++++++++---------------------
  README        |    9 +++++++--
  common.config |   14 ++++++++++++++
  common.rc     |   34 ++++++++++++++++++++++++++++++++--
  4 files changed, 61 insertions(+), 25 deletions(-)

diff --git a/259 b/259
index 522191d..fe90147 100755
--- a/259
+++ b/259
@@ -46,24 +46,7 @@ _supported_fs btrfs
  _supported_os Linux
  _require_scratch
  _require_scratch_dev_pool
-_require_proc_scsi
-
-# arg 1 remove/add
-# arg 2 /dev/sdx or return of devmgt resply
-_devmgt()
-{
-	local x
-	local d
-
-	if [ $1 == "remove" ]; then
-		d=`echo $2|cut -d"/" -f3`
-		x=`ls -l /sys/class/block/${d} | cut -d "/" -f12 | sed 's/:/ /g'`
-		echo "scsi remove-single-device ${x}" > /proc/scsi/scsi || _fail 
"Remove disk failed"
-		DEVHTL=${x}
-	else
-		echo "scsi add-single-device ${2}" > /proc/scsi/scsi || _fail "Add 
disk failed"
-	fi
-}
+_require_deletable_scratch_dev_pool

  # Test cases related to raid in btrfs
  _test_raid0()
@@ -128,10 +111,10 @@ _test_add()
  _test_replace()
  {
  	local i
-	local x
  	local devs=( $SCRATCH_DEV_POOL )
  	local n=${#devs[@]}
  	local ds
+	local d
  	local DEVHTL=""

  	# exclude the last disk in the disk pool
@@ -146,8 +129,12 @@ _test_replace()
  	#pick the 2nd last disk
  	ds=${devs[@]:$(($n-1)):1}

+	# retrive the HTL for this scsi disk
+	d=`echo $ds|cut -d"/" -f3`
+	DEVHTL=`ls -l /sys/class/block/${d} | rev | cut -d "/" -f 3 | rev`
+
  	#fail disk
-	_devmgt remove ${ds}
+	_devmgt_remove ${DEVHTL}

  	btrfs fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null 
|| _fail \
  							"btrfs did not report device missing"
@@ -162,7 +149,7 @@ _test_replace()

  	# cleaup. add the removed disk
  	umount $SCRATCH_MNT
-	_devmgt add "${DEVHTL}"
+	_devmgt_add "${DEVHTL}"
  }

  _test_remove()
diff --git a/README b/README
index 5367be6..407888a 100644
--- a/README
+++ b/README
@@ -34,14 +34,19 @@ Preparing system for tests (IRIX and Linux):
              - leave empty and expect this partition to be clobbered
                by some tests.  If this is not provided, many tests will
                not be run.
-
+
          (these must be two DIFFERENT partitions)
+
+    - for btrfs only: some tests would need 3 or more independent 
SCRATCH disks,
+      which should be setenv SCRATCH_DEV_POOL instead of SCRATCH_DEV
+

      - setup your environment
          - setenv TEST_DEV "device containing TEST PARTITION"
          - setenv TEST_DIR "mount point of TEST PARTITION"
         	- optionally:
               - setenv SCRATCH_DEV "device containing SCRATCH PARTITION"
+             - setenv SCRATCH_DEV_POOL "pool of SCRATCH disks for 
testing btrfs"
               - setenv SCRATCH_MNT "mount point for SCRATCH PARTITION"
               - setenv TAPE_DEV "tape device for testing xfsdump"
               - setenv RMT_TAPE_DEV "remote tape device for testing 
xfsdump"
@@ -63,7 +68,7 @@ Preparing system for tests (IRIX and Linux):
        tape which can be overwritten.

      - make sure $TEST_DEV is a mounted XFS partition
-    - make sure that $SCRATCH_DEV contains nothing useful
+    - make sure that $SCRATCH_DEV or $SCRATCH_DEV_POOL contains nothing 
useful

  Running tests:

diff --git a/common.config b/common.config
index 3642139..7ee255e 100644
--- a/common.config
+++ b/common.config
@@ -228,6 +228,20 @@ if [ ! -d "$TEST_DIR" ]; then
      exit 1
  fi

+# a btrfs tester will set only SCRATCH_DEV_POOL, we will put first of 
its dev
+# to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward 
compatibility
+if [ "$HOSTOS" == "Linux" ]; then
+    FSTYP_tmp=`blkid -c /dev/null -s TYPE -o value $TEST_DEV`
+else
+    FSTYP_tmp=xfs
+fi
+if [ "$FSTYP_tmp" == "btrfs" ]; then
+    if [ ! -z "$SCRATCH_DEV_POOL" ]; then
+	SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | cut -d" " -f 1`
+	SCRATCH_DEV_POOL=`echo $SCRATCH_DEV_POOL | cut -d" " -f 2-`
+    fi
+fi
+	
  echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
  if [ ! -z "$SCRATCH_DEV" -a ! -b "$SCRATCH_DEV" -a "$?" != "0" ]; then
      echo "common.config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) is not a 
block device or a NFS filesystem"
diff --git a/common.rc b/common.rc
index 02dde11..a614090 100644
--- a/common.rc
+++ b/common.rc
@@ -1609,9 +1609,19 @@ _require_scratch_dev_pool()
  	esac
  }

-_require_proc_scsi()
+# We will check if the device is virtual (eg: loop device) since it 
does not
+# have the delete entry-point. Otherwise SCSI and USB devices are fine.
+_require_deletable_scratch_dev_pool()
  {
-	[ -e /proc/scsi/scsi ]  || _notrun "/proc/scsi/scsi is not present"
+	local i
+	local x
+	for i in $SCRATCH_DEV_POOL; do
+		x=`echo $i | cut -d"/" -f 3`
+		ls -l /sys/class/block/${x} | grep -q "virtual"
+		if [ $? == "0" ]; then
+			_notrun "$i is a virtual device which is not deletable"
+		fi
+	done
  }

  # Generate Random number in a range
@@ -1659,6 +1669,26 @@ _fillfs()
  	wait $!
  }

+# arg 1 is dev to remove and is output of the below eg.
+# ls -l /sys/class/block/sdd | rev | cut -d "/" -f 3 | rev
+_devmgt_remove()
+{
+	echo 1 > /sys/class/scsi_device/${1}/device/delete || _fail "Remove 
disk failed"
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
+	echo ${tdl} >  /sys/class/scsi_host/host${h}/scan || _fail "Add disk 
failed"
+}
+
 
################################################################################
  if [ "$iam" != new -a "$iam" != bench ]
  then
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
