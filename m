Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xZlj127573 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:35 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	DDlyLPeOdAWdPymK for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:34 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIz-0001ae-27
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:21 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIy-0004YP-VO
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 20/37] xfs: kill b_file_offset
Date: Mon, 23 Apr 2012 15:58:50 +1000
Message-Id: <1335160747-17254-21-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Seeing as we pass block numbers around everywhere in the buffer
cache now, it makes no sense to index everything by byte offset.
Replace all the byte offset indexing with block number based
indexing, and replace all uses of the byte offset with direct
conversion from the block index.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_buf.c |   17 +++++++----------
 fs/xfs/xfs_buf.h |    5 +----
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index d3a1974..854b27a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -196,7 +196,7 @@ xfs_buf_alloc(
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	XB_SET_OWNER(bp);
 	bp->b_target = target;
-	bp->b_file_offset = blkno << BBSHIFT;
+
 	/*
 	 * Set buffer_length and count_desired to the same value initially.
 	 * I/O routines should use count_desired, which will be the same in
@@ -337,8 +337,8 @@ xfs_buf_allocate_memory(
 	}
 
 use_alloc_page:
-	end = bp->b_file_offset + bp->b_buffer_length;
-	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(bp->b_file_offset);
+	end = BBTOB(bp->b_bn) + bp->b_buffer_length;
+	page_count = xfs_buf_btoc(end) - xfs_buf_btoct(BBTOB(bp->b_bn));
 	error = _xfs_buf_get_pages(bp, page_count, flags);
 	if (unlikely(error))
 		return error;
@@ -439,19 +439,17 @@ _xfs_buf_find(
 	xfs_buf_flags_t		flags,
 	xfs_buf_t		*new_bp)
 {
-	xfs_off_t		offset;
 	size_t			numbytes;
 	struct xfs_perag	*pag;
 	struct rb_node		**rbp;
 	struct rb_node		*parent;
 	xfs_buf_t		*bp;
 
-	offset = BBTOB(blkno);
 	numbytes = BBTOB(numblks);
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
 	ASSERT(!(numbytes < (1 << btp->bt_sshift)));
-	ASSERT(!(offset & (xfs_off_t)btp->bt_smask));
+	ASSERT(!(BBTOB(blkno) & (xfs_off_t)btp->bt_smask));
 
 	/* get tree root */
 	pag = xfs_perag_get(btp->bt_mount,
@@ -466,13 +464,13 @@ _xfs_buf_find(
 		parent = *rbp;
 		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
 
-		if (offset < bp->b_file_offset)
+		if (blkno < bp->b_bn)
 			rbp = &(*rbp)->rb_left;
-		else if (offset > bp->b_file_offset)
+		else if (blkno > bp->b_bn)
 			rbp = &(*rbp)->rb_right;
 		else {
 			/*
-			 * found a block offset match. If the range doesn't
+			 * found a block number match. If the range doesn't
 			 * match, the only way this is allowed is if the buffer
 			 * in the cache is stale and the transaction that made
 			 * it stale has not yet committed. i.e. we are
@@ -718,7 +716,6 @@ xfs_buf_set_empty(
 	bp->b_pages = NULL;
 	bp->b_page_count = 0;
 	bp->b_addr = NULL;
-	bp->b_file_offset = 0;
 	bp->b_buffer_length = bp->b_count_desired = numblks << BBSHIFT;
 	bp->b_bn = XFS_BUF_DADDR_NULL;
 	bp->b_flags &= ~XBF_MAPPED;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index ffd6da0..4d472e5 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -116,7 +116,7 @@ typedef struct xfs_buf {
 	 * fast-path on locking.
 	 */
 	struct rb_node		b_rbnode;	/* rbtree node */
-	xfs_off_t		b_file_offset;	/* offset in file */
+	xfs_daddr_t		b_bn;		/* block number for I/O */
 	size_t			b_buffer_length;/* size of buffer in bytes */
 	atomic_t		b_hold;		/* reference count */
 	atomic_t		b_lru_ref;	/* lru reclaim ref count */
@@ -128,7 +128,6 @@ typedef struct xfs_buf {
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
-	xfs_daddr_t		b_bn;		/* block number for I/O */
 	size_t			b_count_desired;/* desired transfer size */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_iodone_work;
@@ -245,8 +244,6 @@ void xfs_buf_stale(struct xfs_buf *bp);
 
 #define XFS_BUF_ADDR(bp)		((bp)->b_bn)
 #define XFS_BUF_SET_ADDR(bp, bno)	((bp)->b_bn = (xfs_daddr_t)(bno))
-#define XFS_BUF_OFFSET(bp)		((bp)->b_file_offset)
-#define XFS_BUF_SET_OFFSET(bp, off)	((bp)->b_file_offset = (off))
 #define XFS_BUF_COUNT(bp)		((bp)->b_count_desired)
 #define XFS_BUF_SET_COUNT(bp, cnt)	((bp)->b_count_desired = (cnt))
 #define XFS_BUF_SIZE(bp)		((bp)->b_buffer_length)
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
