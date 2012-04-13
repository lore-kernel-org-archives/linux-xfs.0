Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D9oRrZ020315 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 04:50:28 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UtzrxdTee3ucDL5W for
	<xfs@oss.sgi.com>; Fri, 13 Apr 2012 02:50:26 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q3D9oQWN004562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 05:50:26 -0400
From: tmarek@redhat.com
Subject: [PATCH 4/5] xfstests: sync before umount to avoid device busy problems
Date: Fri, 13 Apr 2012 11:49:45 +0200
Message-Id: <1334310586-2281-4-git-send-email-tmarek@redhat.com>
In-Reply-To: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
References: <1334310586-2281-1-git-send-email-tmarek@redhat.com>
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
To: xfs@oss.sgi.com
Cc: Tom Marek <tmarek@redhat.com>, lczerner@redhat.com, dchinner@redhat.com

From: Tom Marek <tmarek@redhat.com>

Some tests might fail because of 'device or resource busy' when unmounting
either the SCRATCH or the TEST device. The reason this happenes is that
some processes might not have time to finish properly, or they are still
waiting for IO. The sync command was added before unmount into
_scratch_unmount() and umount_or_remount_ro which should help processes to
finish before unmounting takes place and thus it solves the problem.
This fixes for example tests 226 and 247.

Test 226 uses plain umount command which suffers from exactly the same problem
as described above. Use fixed _scratch_unmount() instead of plain umount fixes
this problem.

Signed-off-by: Tom Marek <tmarek@redhat.com>

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
---
 226       |    4 ++--
 common.rc |    5 +++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/226 b/226
index 6f28ac9..f8847c6 100755
--- a/226
+++ b/226
@@ -61,7 +61,7 @@ for I in `seq 1 $loops`; do
 done
 
 echo
-umount $SCRATCH_DEV
+_scratch_unmount
 _scratch_mount
 
 echo "--> $loops direct 64m writes in a loop"
@@ -73,7 +73,7 @@ for I in `seq 1 $loops`; do
 done
 
 echo
-umount $SCRATCH_DEV
+_scratch_unmount
 
 status=0
 exit
diff --git a/common.rc b/common.rc
index cab0b64..e56e5bc 100644
--- a/common.rc
+++ b/common.rc
@@ -255,6 +255,8 @@ _scratch_mount()
 
 _scratch_unmount()
 {
+    # Run sync to give processes some time to finish before unmount
+    sync
     $UMOUNT_PROG $SCRATCH_DEV
 }
 
@@ -1051,6 +1053,9 @@ _umount_or_remount_ro()
     device=$1
     mountpoint=`_is_mounted $device`
 
+    # Run sync to give processes some time to finish before unmount
+    sync
+
     if [ $USE_REMOUNT -eq 0 ]; then
         $UMOUNT_PROG $device
     else
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
