Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43696 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965726AbeAKThv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 14:37:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 2/8] xfs: add a proper transaction pointer to struct xfs_buf
Date: Thu, 11 Jan 2018 13:37:32 -0600
Message-Id: <1515699458-6925-3-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
References: <1515699458-6925-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Source kernel commit bf9d9013a2a559858efb590bf922377be9d6d969

Replace the typeless b_fspriv2 and the ugly macros around it with a properly
typed transaction pointer.  As a fallout the log buffer state debug checks
are also removed.  We could have kept them using casts, but as they do
not have a real purpose we can as well just remove them.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 libxfs/libxfs_io.h |  4 +---
 libxfs/trans.c     | 44 ++++++++++++++++++++++----------------------
 2 files changed, 23 insertions(+), 25 deletions(-)

diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 29fb1c7..5acd3df 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -69,7 +69,7 @@ typedef struct xfs_buf {
 	pthread_t		b_holder;
 	unsigned int		b_recur;
 	void			*b_fspriv;
-	void			*b_fsprivate2;
+	void			*b_transp;
 	void			*b_fsprivate3;
 	void			*b_addr;
 	int			b_error;
@@ -111,8 +111,6 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 #define XFS_BUF_SET_ADDR(bp,blk)	((bp)->b_bn = (blk))
 #define XFS_BUF_SET_COUNT(bp,cnt)	((bp)->b_bcount = (cnt))
 
-#define XFS_BUF_FSPRIVATE2(bp,type)	((type)(bp)->b_fsprivate2)
-#define XFS_BUF_SET_FSPRIVATE2(bp,val)	(bp)->b_fsprivate2 = (void *)(val)
 #define XFS_BUF_FSPRIVATE3(bp,type)	((type)(bp)->b_fsprivate3)
 #define XFS_BUF_SET_FSPRIVATE3(bp,val)	(bp)->b_fsprivate3 = (void *)(val)
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 6a1901b..57ff3ea 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -299,7 +299,7 @@ libxfs_trans_inode_alloc_buf(
 {
 	xfs_buf_log_item_t	*bip = bp->b_fspriv;;
 
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->bp_transp == tp);
 	ASSERT(bip != NULL);
 	bip->bli_flags |= XFS_BLI_INODE_ALLOC_BUF;
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DINO_BUF);
@@ -365,7 +365,7 @@ libxfs_trans_dirty_buf(
 {
 	struct xfs_buf_log_item	*bip = bp->b_fspriv;
 
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->bp_transp == tp);
 	ASSERT(bip != NULL);
 
 #ifdef XACT_DEBUG
@@ -430,11 +430,11 @@ libxfs_trans_brelse(
 #endif
 
 	if (tp == NULL) {
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
+		ASSERT(bp->bp_transp == NULL);
 		libxfs_putbuf(bp);
 		return;
 	}
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->bp_transp == tp);
 	bip = bp->b_fspriv;
 	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
 	if (bip->bli_recur > 0) {
@@ -449,7 +449,7 @@ libxfs_trans_brelse(
 	xfs_trans_del_item(&bip->bli_item);
 	if (bip->bli_flags & XFS_BLI_HOLD)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
-	XFS_BUF_SET_FSPRIVATE2(bp, NULL);
+	bp->b_transp = NULL;
 	libxfs_putbuf(bp);
 }
 
@@ -463,7 +463,7 @@ libxfs_trans_binval(
 	fprintf(stderr, "binval'd buffer %p, transaction %p\n", bp, tp);
 #endif
 
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->bp_transp == tp);
 	ASSERT(bip != NULL);
 
 	if (bip->bli_flags & XFS_BLI_STALE)
@@ -485,7 +485,7 @@ libxfs_trans_bjoin(
 {
 	xfs_buf_log_item_t	*bip;
 
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, void *) == NULL);
+	ASSERT(bp->bp_transp == NULL);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "bjoin'd buffer %p, transaction %p\n", bp, tp);
 #endif
@@ -493,7 +493,7 @@ libxfs_trans_bjoin(
 	xfs_buf_item_init(bp, tp->t_mountp);
 	bip = bp->b_fspriv;
 	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+	bp->b_transp = tp;
 }
 
 void
@@ -503,7 +503,7 @@ libxfs_trans_bhold(
 {
 	xfs_buf_log_item_t	*bip =bp->b_fspriv;
 
-	ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+	ASSERT(bp->bp_transp == tp);
 	ASSERT(bp->b_fspriv != NULL);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "bhold'd buffer %p, transaction %p\n", bp, tp);
@@ -528,7 +528,7 @@ libxfs_trans_get_buf_map(
 
 	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
 	if (bp != NULL) {
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+		ASSERT(bp->bp_transp == tp);
 		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
@@ -547,8 +547,8 @@ libxfs_trans_get_buf_map(
 	bip->bli_recur = 0;
 	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
 
-	/* initialize b_fsprivate2 so we can find it incore */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+	/* initialize b_transp so we can find it incore */
+	bp->b_transp = tp;
 	return bp;
 }
 
@@ -568,7 +568,7 @@ libxfs_trans_getsb(
 
 	bp = xfs_trans_buf_item_match(tp, mp->m_dev, &map, 1);
 	if (bp != NULL) {
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+		ASSERT(bp->bp_transp == tp);
 		bip = bp->b_fspriv;
 		ASSERT(bip != NULL);
 		bip->bli_recur++;
@@ -585,8 +585,8 @@ libxfs_trans_getsb(
 	bip->bli_recur = 0;
 	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
 
-	/* initialize b_fsprivate2 so we can find it incore */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+	/* initialize b_transp so we can find it incore */
+	bp->b_transp = tp;
 	return bp;
 }
 
@@ -619,7 +619,7 @@ libxfs_trans_read_buf_map(
 
 	bp = xfs_trans_buf_item_match(tp, btp, map, nmaps);
 	if (bp != NULL) {
-		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
+		ASSERT(bp->bp_transp == tp);
 		ASSERT(bp->b_fspriv != NULL);
 		bip = bp->b_fspriv;
 		bip->bli_recur++;
@@ -642,8 +642,8 @@ libxfs_trans_read_buf_map(
 	bip->bli_recur = 0;
 	xfs_trans_add_item(tp, (xfs_log_item_t *)bip);
 
-	/* initialise b_fsprivate2 so we can find it incore */
-	XFS_BUF_SET_FSPRIVATE2(bp, tp);
+	/* initialise b_transp so we can find it incore */
+	bp->b_transp = tp;
 done:
 	*bpp = bp;
 	return 0;
@@ -735,8 +735,8 @@ inode_item_done(
 	}
 
 	ip->i_transp = NULL;	/* disassociate from transaction */
-	bp->b_fspriv = NULL;			/* remove log item */
-	XFS_BUF_SET_FSPRIVATE2(bp, NULL);	/* remove xact ptr */
+	bp->b_fspriv = NULL;	/* remove log item */
+	bp->b_transp = NULL;	/* remove xact ptr */
 	libxfs_writebuf(bp, 0);
 #ifdef XACT_DEBUG
 	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
@@ -755,7 +755,7 @@ buf_item_done(
 	bp = bip->bli_buf;
 	ASSERT(bp != NULL);
 	bp->b_fspriv = NULL;			/* remove log item */
-	XFS_BUF_SET_FSPRIVATE2(bp, NULL);	/* remove xact ptr */
+	bp->b_transp = NULL;			/* remove xact ptr */
 
 	hold = (bip->bli_flags & XFS_BLI_HOLD);
 	if (bip->bli_flags & XFS_BLI_DIRTY) {
@@ -804,7 +804,7 @@ buf_item_unlock(
 	uint			hold;
 
 	/* Clear the buffer's association with this transaction. */
-	XFS_BUF_SET_FSPRIVATE2(bip->bli_buf, NULL);
+	bip->bli_buf->b_transp = NULL;
 
 	hold = bip->bli_flags & XFS_BLI_HOLD;
 	bip->bli_flags &= ~XFS_BLI_HOLD;
-- 
1.8.3.1

