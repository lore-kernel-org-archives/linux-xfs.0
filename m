Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0E04C29E06
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 18:41:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEFF6AC004
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 16:41:22 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	153cmlETh0LTYUXp for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 16:41:20 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRUPV-0000Rn-BV
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRUPV-0005Mr-Ai
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 11:38:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6] xfs: rename XFS_BUF_ZEROFLAGS macro
Date: Fri,  5 Feb 2016 11:38:03 +1100
Message-Id: <1454632683-20543-7-git-send-email-david@fromorbit.com>
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

This macro is really clearing the IO flags from the buffer. Rename
it appropriately and turn it into a static inline to get rid of the
shoutiness.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h         | 10 ++++++----
 fs/xfs/xfs_log.c         |  4 ++--
 fs/xfs/xfs_log_recover.c |  2 +-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 98b7ee9..0735096 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -313,10 +313,12 @@ extern int xfs_buf_delwri_submit_nowait(struct list_head *);
 extern int xfs_buf_init(void);
 extern void xfs_buf_terminate(void);
 
-#define XFS_BUF_ZEROFLAGS(bp) \
-	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC| \
-			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH| \
-			    XBF_WRITE_FAIL))
+static inline void xfs_buf_clear_ioflags(struct xfs_buf *bp)
+{
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_ASYNC |
+			 XBF_SYNCIO | XBF_FUA | XBF_FLUSH |
+			 XBF_WRITE_FAIL);
+}
 
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index edf20b2..185d1b0 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1864,7 +1864,7 @@ xlog_sync(
 
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
-	XFS_BUF_ZEROFLAGS(bp);
+	xfs_buf_clear_ioflags(bp);
 	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
@@ -1908,7 +1908,7 @@ xlog_sync(
 		xfs_buf_associate_memory(bp,
 				(char *)&iclog->ic_header + count, split);
 		bp->b_fspriv = iclog;
-		XFS_BUF_ZEROFLAGS(bp);
+		xfs_buf_clear_ioflags(bp);
 		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			bp->b_flags |= XBF_FUA;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 68406fd..b05d07b 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -275,9 +275,9 @@ xlog_bwrite(
 	ASSERT(nbblks <= bp->b_length);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_ZEROFLAGS(bp);
 	xfs_buf_hold(bp);
 	xfs_buf_lock(bp);
+	xfs_buf_clear_ioflags(bp);
 	bp->b_io_length = nbblks;
 	bp->b_error = 0;
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
