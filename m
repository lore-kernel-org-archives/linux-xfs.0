Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2RGkmJf128440 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 11:46:49 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8rqieFWPTExcoIMY (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 09:46:47 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCZXi-0007DH-J9
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 16:46:46 +0000
Message-Id: <20120327164646.539031348@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 12:44:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/10] xfs: do not add buffers to the delwri queue until pushed
References: <20120327164400.967415009@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_buf_item.c	2012-03-16 09:51:16.830170721 +0100
+++ xfs/fs/xfs/xfs_buf_item.c	2012-03-16 09:52:14.600171793 +0100
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
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2012-03-16 09:51:16.846837387 +0100
+++ xfs/fs/xfs/xfs_trans_buf.c	2012-03-16 09:52:14.600171793 +0100
@@ -626,8 +626,6 @@ xfs_trans_log_buf(xfs_trans_t	*tp,
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
