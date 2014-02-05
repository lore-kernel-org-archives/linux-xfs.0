Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C84D67F51
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 23:47:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 719F2AC002
	for <xfs@oss.sgi.com>; Tue,  4 Feb 2014 21:47:29 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	3YEjCjRjaF0I8Xv1 for <xfs@oss.sgi.com>;
	Tue, 04 Feb 2014 21:47:27 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1WAvKT-0004AJ-Pn
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 16:47:21 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WAvKT-000056-OX
	for xfs@oss.sgi.com; Wed, 05 Feb 2014 16:47:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] mkfs: default log size for small filesystems too large
Date: Wed,  5 Feb 2014 16:47:21 +1100
Message-Id: <1391579241-32747-1-git-send-email-david@fromorbit.com>
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
 mkfs/xfs_mkfs.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d82128c..4a29eea 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2377,17 +2377,18 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
 		logblocks = MAX(min_logblocks, logblocks);
 
 		/*
-		 * If the default log size doesn't fit in the AG size, use the
-		 * minimum log size instead. This ensures small filesystems
-		 * don't use excessive amounts of space for the log.
+		 * For small filesystems, we want to use the XFS_MIN_LOG_BYTES
+		 * for filesystems smaller than 16G if at all possible, ramping
+		 * up to 128MB at 256GB.
 		 */
-		if (min_logblocks * XFS_DFL_LOG_FACTOR >= agsize) {
-			logblocks = min_logblocks;
-		} else {
-			logblocks = MAX(logblocks,
-				MAX(XFS_DFL_LOG_SIZE,
-					min_logblocks * XFS_DFL_LOG_FACTOR));
+		 if (dblocks < GIGABYTES(16, blocklog)) {
+			logblocks = MIN(XFS_MIN_LOG_BYTES >> blocklog,
+					min_logblocks * XFS_DFL_LOG_FACTOR);
 		}
+
+		if (logblocks >= agsize)
+			logblocks = min_logblocks;
+
 		logblocks = MIN(logblocks, XFS_MAX_LOG_BLOCKS);
 		if ((logblocks << blocklog) > XFS_MAX_LOG_BYTES) {
 			logblocks = XFS_MAX_LOG_BYTES >> blocklog;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
