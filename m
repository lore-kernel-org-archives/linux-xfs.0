Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 57DF029DFC
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:41:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2C3648F8039
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:41:24 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	SOrNPqWN4hEGN7cT for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:41:22 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRUPV-0000Rl-Ad
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRUPV-0005Mh-9t
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/6] xfs: remove XBF_WRITE flag wrapper macros
Date: Fri,  5 Feb 2016 11:38:01 +1100
Message-Id: <1454632683-20543-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1454632683-20543-1-git-send-email-david@fromorbit.com>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
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

They only set/clear/check a flag, no need for obfuscating this
with a macro.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h         | 4 ----
 fs/xfs/xfs_log.c         | 8 +++-----
 fs/xfs/xfs_log_recover.c | 2 +-
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 329e612..a118962 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -321,10 +321,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
 #define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 
-#define XFS_BUF_WRITE(bp)	((bp)->b_flags |= XBF_WRITE)
-#define XFS_BUF_UNWRITE(bp)	((bp)->b_flags &= ~XBF_WRITE)
-#define XFS_BUF_ISWRITE(bp)	((bp)->b_flags & XBF_WRITE)
-
 /*
  * These macros use the IO block map rather than b_bn. b_bn is now really
  * just for the buffer cache index for cached buffers. As IO does not use b_bn
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 19db3da..edf20b2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1865,7 +1865,7 @@ xlog_sync(
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
 	XFS_BUF_ZEROFLAGS(bp);
-	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO);
+	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
 		bp->b_flags |= XBF_FUA;
@@ -1892,12 +1892,11 @@ xlog_sync(
 
 	/* account for log which doesn't start at block #0 */
 	XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
+
 	/*
 	 * Don't call xfs_bwrite here. We do log-syncs even when the filesystem
 	 * is shutting down.
 	 */
-	XFS_BUF_WRITE(bp);
-
 	error = xlog_bdstrat(bp);
 	if (error) {
 		xfs_buf_ioerror_alert(bp, "xlog_sync");
@@ -1910,7 +1909,7 @@ xlog_sync(
 				(char *)&iclog->ic_header + count, split);
 		bp->b_fspriv = iclog;
 		XFS_BUF_ZEROFLAGS(bp);
-		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO);
+		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			bp->b_flags |= XBF_FUA;
 
@@ -1919,7 +1918,6 @@ xlog_sync(
 
 		/* account for internal log which doesn't start at block #0 */
 		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
-		XFS_BUF_WRITE(bp);
 		error = xlog_bdstrat(bp);
 		if (error) {
 			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 81c525a..68406fd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4927,7 +4927,7 @@ xlog_do_recover(
 	 */
 	bp = xfs_getsb(log->l_mp, 0);
 	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
-	ASSERT(!(XFS_BUF_ISWRITE(bp)));
+	ASSERT(!(bp->b_flags & XBF_WRITE));
 	bp->b_flags |= XBF_READ;
 	bp->b_ops = &xfs_sb_buf_ops;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
