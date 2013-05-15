Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C31D87F37
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 10:20:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 540F0AC00A
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 08:20:23 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id 1lHfkSvtV7C6aqCt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 08:20:21 -0700 (PDT)
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2D3927C0689
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 09:20:21 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21])
	by mx2.fusionio.com with ESMTP id P6NfUD45f6XY73YS
	(version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 15 May 2013 09:20:20 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: 311: fsck the dmflakey device instead of the real
	device V2
Date: Wed, 15 May 2013 11:20:17 -0400
Message-ID: <1368631217-15511-1-git-send-email-jbacik@fusionio.com>
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

Dave pointed out that xfs was having issues with 311 because of caching issues.
He suggested that I fsck the dm-flakey device to make sure we don't have this
problem.  Make _check_scratch_fs take an optional argument to use as the device
to fsck.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: make _check_scratch_fs() take the optional argument of the device to
check

 common/rc         |   11 +++++++----
 tests/generic/311 |    2 +-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/common/rc b/common/rc
index 7adf8b8..fe6bbfc 100644
--- a/common/rc
+++ b/common/rc
@@ -1678,6 +1678,9 @@ _check_test_fs()
 
 _check_scratch_fs()
 {
+    device=$SCRATCH_DEV
+    [ $# -eq 1 ] && device=$1
+
     case $FSTYP in
     xfs)
 	SCRATCH_LOG="none"
@@ -1688,19 +1691,19 @@ _check_scratch_fs()
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
 	    SCRATCH_RT="$SCRATCH_RTDEV"
 
-	_check_xfs_filesystem $SCRATCH_DEV $SCRATCH_LOG $SCRATCH_RT
+	_check_xfs_filesystem $device $SCRATCH_LOG $SCRATCH_RT
 	;;
     udf)
-	_check_udf_filesystem $SCRATCH_DEV $udf_fsize
+	_check_udf_filesystem $device $udf_fsize
 	;;
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
     btrfs)
-	_check_btrfs_filesystem $SCRATCH_DEV
+	_check_btrfs_filesystem $device
 	;;
     *)
-	_check_generic_filesystem $SCRATCH_DEV
+	_check_generic_filesystem $device
 	;;
     esac
 }
diff --git a/tests/generic/311 b/tests/generic/311
index 2b3b569..675d927 100644
--- a/tests/generic/311
+++ b/tests/generic/311
@@ -125,7 +125,7 @@ _run_test()
 
 	#Unmount and fsck to make sure we got a valid fs after replay
 	_unmount_flakey
-	_check_scratch_fs
+	_check_scratch_fs $FLAKEY_DEV
 	[ $? -ne 0 ] && _fatal "fsck failed"
 
 	_mount_flakey
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
