Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pALBVnwm255507 for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 05:31:49 -0600
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47BD01D1B4E4
	for <xfs@oss.sgi.com>; Mon, 21 Nov 2011 03:31:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	AZ8y25oFLZwz5NBo for <xfs@oss.sgi.com>;
	Mon, 21 Nov 2011 03:31:47 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/8] xfstest: enable xfs_repair for large filesystem testing
Date: Mon, 21 Nov 2011 22:31:26 +1100
Message-Id: <1321875088-30801-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1321875088-30801-1-git-send-email-david@fromorbit.com>
References: <1321875088-30801-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that large filesystem testing does not play free space games to
fill the space without IO, we can enable xfs_repair when running in
this mode. xfs_repair has had it's scalability problems solved, too,
so this is a safe thing to do.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common.rc |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/common.rc b/common.rc
index 34467ec..12bd349 100644
--- a/common.rc
+++ b/common.rc
@@ -1200,12 +1200,12 @@ _check_xfs_filesystem()
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
@@ -1250,8 +1250,7 @@ _check_xfs_filesystem()
 
         ok=0
     fi
-    # repair doesn't scale massively at this stage, optionally skip it for now
-    [ "$LARGE_SCRATCH_DEV" = yes ] || \
+
     $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
