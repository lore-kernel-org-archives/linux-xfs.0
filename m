Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8eG8P001472 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:16 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	GcVwIeQMPWBqdzOW for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:15 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJc1-00013i-Uv
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:40:01 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJbr-0003ur-S8
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/10] xfstest: enable xfs_repair for large filesystem testing
Date: Thu, 26 Jul 2012 18:39:45 +1000
Message-Id: <1343291989-14987-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Now that large filesystem testing does not play free space games to
fill the space without IO, we can enable xfs_repair when running in
this mode. xfs_repair has had it's scalability problems solved, too,
so this is a safe thing to do.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/common.rc b/common.rc
index 7bb1133..a9252e0 100644
--- a/common.rc
+++ b/common.rc
@@ -1238,12 +1238,12 @@ _check_xfs_filesystem()
     extra_mount_options=""
     device=$1
     if [ "$2" != "none" ]; then
-       	extra_log_options="-l$2"
+	extra_log_options="-l$2"
         extra_mount_options="-ologdev=$2"
     fi
 
     if [ "$3" != "none" ]; then
-       	extra_rt_options="-r$3"
+	extra_rt_options="-r$3"
         extra_mount_options=$extra_mount_options" -ortdev=$3"
     fi
     extra_mount_options=$extra_mount_options" $MOUNT_OPTIONS"
@@ -1288,8 +1288,7 @@ _check_xfs_filesystem()
 
         ok=0
     fi
-    # repair doesn't scale massively at this stage, optionally skip it for now
-    [ "$LARGE_SCRATCH_DEV" = yes ] || \
+
     $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
