Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xPiH127436 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:25 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4Py0pLhuSOAZNJiW for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:23 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIo-0001Zr-Jk
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004Xm-Gu
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/37] xfs: do not add buffers to the delwri queue until pushed
Date: Mon, 23 Apr 2012 15:58:38 +1000
Message-Id: <1335160747-17254-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

Instead of adding buffers to the delwri list as soon as they are logged,
even if they can't be written until commited because they are pinned
defer adding them to the delwri list until xfsaild pushes them.  This
makes the code more similar to other log items and prepares for writing
buffers directly from xfsaild.

The complication here is that we need to fail buffers that were added
but not logged yet in xfs_buf_item_unpin, borrowing code from
xfs_bioerror.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf_item.c  |   11 ++++++++---
 fs/xfs/xfs_trans_buf.c |    2 --
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index eac97ef..3a0bc38 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -460,6 +460,12 @@ xfs_buf_item_unpin(
 			ASSERT(bp->b_fspriv == NULL);
 		}
 		xfs_buf_relse(bp);
+	} else if (freed && remove) {
+		xfs_buf_lock(bp);
+		xfs_buf_ioerror(bp, EIO);
+		XFS_BUF_UNDONE(bp);
+		xfs_buf_stale(bp);
+		xfs_buf_ioend(bp, 0);
 	}
 }
 
@@ -604,9 +610,7 @@ xfs_buf_item_committed(
 }
 
 /*
- * The buffer is locked, but is not a delayed write buffer. This happens
- * if we race with IO completion and hence we don't want to try to write it
- * again. Just release the buffer.
+ * The buffer is locked, but is not a delayed write buffer.
  */
 STATIC void
 xfs_buf_item_push(
@@ -620,6 +624,7 @@ xfs_buf_item_push(
 
 	trace_xfs_buf_item_push(bip);
 
+	xfs_buf_delwri_queue(bp);
 	xfs_buf_relse(bp);
 }
 
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 1302d1d..296a799 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -626,8 +626,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
-	xfs_buf_delwri_queue(bp);
-
 	trace_xfs_trans_log_buf(bip);
 
 	/*
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
