Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F41167F50
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:46:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4C4730407B
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:46:23 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	8af4NQ5jRmNQG1qe for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:46:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxXH-0007au-6S
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:45:47 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxXH-0007pa-5E
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:45:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/2] mkfs: default log size for small filesystems too large
Date: Thu, 27 Feb 2014 20:45:43 +1100
Message-Id: <1393494344-30056-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494344-30056-1-git-send-email-david@fromorbit.com>
References: <1393494344-30056-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Recent changes to the log size scaling have resulted in using the
default size multiplier for the log size even on small filesystems.
Commit 88cd79b ("xfs: Add xfs_log_rlimit.c") changed the calculation
of the maximum transaction size that the kernel would issues and
that significantly increased the minimum size of the default log.
As such the size of the log on small filesystems was typically
larger than the prefious default, even though the previous default
was still larger than the minimum needed.

Rework the default log size calculation such that it will use the
original log size default if it is larger than the minimum log size
required, and only use a larger log if the configuration of the
filesystem requires it.

This is especially obvious in xfs/216, where the default log size is
10MB all the way up to 16GB filesystems. The current mkfs selects a
log size of 50MB for the same size filesystems and this is
unnecessarily large.

Return the scaling of the log size for small filesystems to
something similar to what xfs/216 expects.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/xfs_mkfs.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d82128c..f7cf394 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2366,32 +2366,40 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 	} else if (!loginternal && !xi.logdev) {
 		logblocks = 0;
 	} else if (loginternal && !logsize) {
-		/*
-		 * With a 2GB max log size, default to maximum size
-		 * at 4TB. This keeps the same ratio from the older
-		 * max log size of 128M at 256GB fs size. IOWs,
-		 * the ratio of fs size to log size is 2048:1.
-		 */
-		logblocks = (dblocks << blocklog) / 2048;
-		logblocks = logblocks >> blocklog;
-		logblocks = MAX(min_logblocks, logblocks);
 
-		/*
-		 * If the default log size doesn't fit in the AG size, use the
-		 * minimum log size instead. This ensures small filesystems
-		 * don't use excessive amounts of space for the log.
-		 */
-		if (min_logblocks * XFS_DFL_LOG_FACTOR >= agsize) {
+		if (dblocks < GIGABYTES(1, blocklog)) {
+			/* tiny filesystems get minimum sized logs. */
 			logblocks = min_logblocks;
+		} else if (dblocks < GIGABYTES(16, blocklog)) {
+
+			/*
+			 * For small filesystems, we want to use the
+			 * XFS_MIN_LOG_BYTES for filesystems smaller than 16G if
+			 * at all possible, ramping up to 128MB at 256GB.
+			 */
+			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
+					min_logblocks * XFS_DFL_LOG_FACTOR);
 		} else {
-			logblocks = MAX(logblocks,
-				MAX(XFS_DFL_LOG_SIZE,
-					min_logblocks * XFS_DFL_LOG_FACTOR));
+			/*
+			 * With a 2GB max log size, default to maximum size
+			 * at 4TB. This keeps the same ratio from the older
+			 * max log size of 128M at 256GB fs size. IOWs,
+			 * the ratio of fs size to log size is 2048:1.
+			 */
+			logblocks = (dblocks << blocklog) / 2048;
+			logblocks = logblocks >> blocklog;
+			logblocks = MAX(min_logblocks, logblocks);
 		}
+
+		/* make sure the log fits wholly within an AG */
+		if (logblocks >= agsize)
+			logblocks = min_logblocks;
+
+		/* and now clamp the size to the maximum supported size */
 		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
-		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
+		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES)
 			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
-		}
+
 	}
 	validate_log_size(logblocks, blocklog, min_logblocks);
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
