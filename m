Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3i4x145563 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A72B1CC6FC2
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8eS8I2RMo1ja65eF for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHr-0003C5-0R
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:43 +0000
Message-Id: <20111028100342.967353667@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 41/45] xfs: do not add buffers to the delwri queue until pushed
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-buf-item-write-later
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

Instead of adding buffers to the delwri list as soon as they are logged,
even if they can't be written until commited because they are pinned
defer adding them to the delwri list until xfsaild pushes them.  This
makes the code more similar to other log items and prepares for writing
buffers directly from xfsaild.

The complication here is that we need to fail buffers that were added
but not logged yet in xfs_buf_item_unpin, borrowing code from
xfs_bioerror.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_buf_item.c  |   11 ++++++++---
 fs/xfs/xfs_trans_buf.c |    2 --
 2 files changed, 8 insertions(+), 5 deletions(-)

Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-10-27 22:39:42.528674212 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-10-27 22:40:15.630172342 +0200
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
 
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-10-27 22:39:32.056672629 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-10-27 22:40:15.630172342 +0200
@@ -649,8 +649,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
 	bp->b_iodone = xfs_buf_iodone_callbacks;
 	bip->bli_item.li_cb = xfs_buf_iodone;
 
-	xfs_buf_delwri_queue(bp);
-
 	trace_xfs_trans_log_buf(bip);
 
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
