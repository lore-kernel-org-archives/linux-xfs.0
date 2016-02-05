Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AE0C529DF9
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:41:23 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8509F304059
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:41:23 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	N5xJ4494vtHAmy2D for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:41:21 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRUPV-0000Rj-9k
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRUPV-0005MX-91
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: remove XBF_ASYNC flag wrapper macros
Date: Fri,  5 Feb 2016 11:37:59 +1100
Message-Id: <1454632683-20543-3-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_buf_item.c    | 2 +-
 fs/xfs/xfs_log.c         | 8 +++-----
 fs/xfs/xfs_log_recover.c | 3 +--
 4 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 03b5d3a..2a28d1c 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -321,10 +321,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 #define XFS_BUF_UNSTALE(bp)	((bp)->b_flags &= ~XBF_STALE)
 #define XFS_BUF_ISSTALE(bp)	((bp)->b_flags & XBF_STALE)
 
-#define XFS_BUF_ASYNC(bp)	((bp)->b_flags |= XBF_ASYNC)
-#define XFS_BUF_UNASYNC(bp)	((bp)->b_flags &= ~XBF_ASYNC)
-#define XFS_BUF_ISASYNC(bp)	((bp)->b_flags & XBF_ASYNC)
-
 #define XFS_BUF_READ(bp)	((bp)->b_flags |= XBF_READ)
 #define XFS_BUF_UNREAD(bp)	((bp)->b_flags &= ~XBF_READ)
 #define XFS_BUF_ISREAD(bp)	((bp)->b_flags & XBF_READ)
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 2d2029d..344ab44 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -974,7 +974,7 @@ xfs_buf_iodone_callbacks(
 	 * errors tend to affect the whole device and a failing log write
 	 * will make us give up.  But we really ought to do better here.
 	 */
-	if (XFS_BUF_ISASYNC(bp)) {
+	if (bp->b_flags & XBF_ASYNC) {
 		ASSERT(bp->b_iodone != NULL);
 
 		trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index aa8c9bf..19db3da 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1212,7 +1212,7 @@ xlog_iodone(xfs_buf_t *bp)
 	}
 
 	/* log I/O is always issued ASYNC */
-	ASSERT(XFS_BUF_ISASYNC(bp));
+	ASSERT(bp->b_flags & XBF_ASYNC);
 	xlog_state_done_syncing(iclog, aborted);
 
 	/*
@@ -1865,8 +1865,7 @@ xlog_sync(
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
 	XFS_BUF_ZEROFLAGS(bp);
-	XFS_BUF_ASYNC(bp);
-	bp->b_flags |= XBF_SYNCIO;
+	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO);
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
 		bp->b_flags |= XBF_FUA;
@@ -1911,8 +1910,7 @@ xlog_sync(
 				(char *)&iclog->ic_header + count, split);
 		bp->b_fspriv = iclog;
 		XFS_BUF_ZEROFLAGS(bp);
-		XFS_BUF_ASYNC(bp);
-		bp->b_flags |= XBF_SYNCIO;
+		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			bp->b_flags |= XBF_FUA;
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97cfeab..b34337d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4926,10 +4926,9 @@ xlog_do_recover(
 	 * updates, re-read in the superblock and reverify it.
 	 */
 	bp = xfs_getsb(log->l_mp, 0);
-	bp->b_flags &= ~XBF_DONE;
+	bp->b_flags &= ~(XBF_DONE | XBF_ASYNC);
 	ASSERT(!(XFS_BUF_ISWRITE(bp)));
 	XFS_BUF_READ(bp);
-	XFS_BUF_UNASYNC(bp);
 	bp->b_ops = &xfs_sb_buf_ops;
 
 	error = xfs_buf_submit_wait(bp);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
