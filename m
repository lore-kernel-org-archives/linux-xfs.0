Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 98D4529DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:38:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 77B0A8F8070
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:38:05 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OJeMDfDN7FDppuj3 for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 13:38:03 -0800 (PST)
Date: Wed, 10 Feb 2016 08:38:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 6/6 v3] xfs: remove XFS_BUF_ZEROFLAGS macro
Message-ID: <20160209213801.GC14668@dastard>
References: <1454632683-20543-1-git-send-email-david@fromorbit.com>
	<1454632683-20543-7-git-send-email-david@fromorbit.com>
	<20160208091235.GN5534@infradead.org>
	<20160208223120.GM27429@dastard>
	<20160209091632.GB23349@infradead.org>
	<20160209212336.GB14668@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209212336.GB14668@dastard>
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

xfs: remove XFS_BUF_ZEROFLAGS macro

From: Dave Chinner <dchinner@redhat.com>

The places where we use this macro already clear unnecessary IO
flags (e.g.  through xfs_bwrite()) or never have unexpected IO flags
set on them in the first place (e.g. iclog buffers). Remove the
macro from these locations, and where necessary clear only the
specific flags that are conditional in the current buffer use
context.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
Version 3 - completely remove the macro as Christoph originally
intended.

 fs/xfs/xfs_buf.h         | 6 ------
 fs/xfs/xfs_log.c         | 4 ++--
 fs/xfs/xfs_log_recover.c | 1 -
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 98b7ee9..4eb89bd 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -313,12 +313,6 @@ extern int xfs_buf_delwri_submit_nowait(struct list_head *);
 extern int xfs_buf_init(void);
 extern void xfs_buf_terminate(void);
 
-#define XFS_BUF_ZEROFLAGS(bp) \
-	((bp)->b_flags &= ~(XBF_READ|XBF_WRITE|XBF_ASYNC| \
-			    XBF_SYNCIO|XBF_FUA|XBF_FLUSH| \
-			    XBF_WRITE_FAIL))
-
-
 /*
  * These macros use the IO block map rather than b_bn. b_bn is now really
  * just for the buffer cache index for cached buffers. As IO does not use b_bn
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index edf20b2..40b700d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1864,7 +1864,7 @@ xlog_sync(
 
 	bp->b_io_length = BTOBB(count);
 	bp->b_fspriv = iclog;
-	XFS_BUF_ZEROFLAGS(bp);
+	bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);
 	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
 
 	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER) {
@@ -1908,7 +1908,7 @@ xlog_sync(
 		xfs_buf_associate_memory(bp,
 				(char *)&iclog->ic_header + count, split);
 		bp->b_fspriv = iclog;
-		XFS_BUF_ZEROFLAGS(bp);
+		bp->b_flags &= ~(XBF_FUA | XBF_FLUSH);
 		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE);
 		if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 			bp->b_flags |= XBF_FUA;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 70e4c1e..1dc0e14 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -275,7 +275,6 @@ xlog_bwrite(
 	ASSERT(nbblks <= bp->b_length);
 
 	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	XFS_BUF_ZEROFLAGS(bp);
 	xfs_buf_hold(bp);
 	xfs_buf_lock(bp);
 	bp->b_io_length = nbblks;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
