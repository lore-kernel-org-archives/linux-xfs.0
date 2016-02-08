Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27FA27CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 16:59:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0892F304032
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 14:59:08 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	f8sxAfKVFGBeyO2B for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 14:59:03 -0800 (PST)
Date: Tue, 9 Feb 2016 09:59:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6 v2] xfs: rename XFS_BUF_ZEROFLAGS macro
Message-ID: <20160208225901.GN27429@dastard>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
	<1454632683-20543-7-git-send-email-david@fromorbit.com>
	<20160208091235.GN5534@infradead.org>
	<20160208223120.GM27429@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208223120.GM27429@dastard>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com


From: Dave Chinner <dchinner@redhat.com>

This macro is really clearing the IO flags from the buffer. Rename
it appropriately and turn it into a static inline to get rid of the
shoutiness.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
V2 - kill call from xlog_bwrite completely as xfs_bwrite() takes
care of clearing the flags appropriately.

 fs/xfs/xfs_buf.h         | 10 ++++++----
 fs/xfs/xfs_log.c         |  4 ++--
 fs/xfs/xfs_log_recover.c |  1 -
 3 files changed, 8 insertions(+), 7 deletions(-)

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
index bee2257..23ad143 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -275,7 +275,6 @@ xlog_bwrite(
 	ASSERT(nbblks <= bp->b_length);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_ZEROFLAGS(bp);
 	xfs_buf_hold(bp);
 	xfs_buf_lock(bp);
 	bp->b_io_length = nbblks;
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
