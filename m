Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:25505 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727742AbeIEMss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Sep 2018 08:48:48 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1fxT2G-0003ND-49
        for linux-xfs@vger.kernel.org; Wed, 05 Sep 2018 18:19:36 +1000
Received: from dave by discord.disaster.area with local (Exim 4.91)
        (envelope-from <david@fromorbit.com>)
        id 1fxT2G-0007Gg-2r
        for linux-xfs@vger.kernel.org; Wed, 05 Sep 2018 18:19:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/4] mkfs: introduce new delayed write buffer list
Date: Wed,  5 Sep 2018 18:19:31 +1000
Message-Id: <20180905081932.27478-4-david@fromorbit.com>
In-Reply-To: <20180905081932.27478-1-david@fromorbit.com>
References: <20180905081932.27478-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Similar to the kernel concept of delayed write buffers, modify the
xfs_buf to have an internal list head we can use to park dirty
buffers we need to write back for later processing. This enables us
to control writeback directly, rather than have it occur as a side
effect of buffer cache LRU pressure.

Because the whole transaction subsystem is different in userspace,
we need to pass the delwri list to the commit code so that it can
add the buffers dirtied in the transaction to the delwri list rather
than writing them back immediately. This is really special case code
for mkfs because we don't have a proper metadata writeback setup
like we do in the kernel. It's a crutch to enable mkfs to do
async writeback, nothing more.

By itself, this change does not improve performance - IO
dispatch from mkfs is still synchronous, so it can't drive a queue
depth of more than 1. But we now have batched writeback....

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_trans.h |  2 ++
 libxfs/libxfs_io.h  |  6 +++++
 libxfs/rdwr.c       | 65 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/trans.c      | 47 ++++++++++++++++++++++++--------
 mkfs/xfs_mkfs.c     | 37 +++++++++++++++-----------
 5 files changed, 131 insertions(+), 26 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 63972e4fff0f..25de8b7c757c 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -84,6 +84,8 @@ int	libxfs_trans_alloc(struct xfs_mount *mp, struct xfs_trans_res *resp,
 			   struct xfs_trans **tpp);
 int	libxfs_trans_alloc_empty(struct xfs_mount *mp, struct xfs_trans **tpp);
 int	libxfs_trans_commit(struct xfs_trans *);
+int	libxfs_trans_commit_delwri(struct xfs_trans *tp,
+				   struct list_head *delwri_list);
 void	libxfs_trans_cancel(struct xfs_trans *);
 struct xfs_buf *libxfs_trans_getsb(struct xfs_trans *, struct xfs_mount *, int);
 
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 12064d798a2d..c69cc7cd7ec5 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -66,6 +66,7 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	*b_maps;
 	struct xfs_buf_map	__b_map;
 	int			b_nmaps;
+	struct list_head	b_list;
 #ifdef XFS_BUF_TRACING
 	struct list_head	b_lock_list;
 	const char		*b_func;
@@ -81,6 +82,7 @@ enum xfs_buf_flags_t {	/* b_flags bits */
 	LIBXFS_B_UPTODATE	= 0x0008,	/* buffer is sync'd to disk */
 	LIBXFS_B_DISCONTIG	= 0x0010,	/* discontiguous buffer */
 	LIBXFS_B_UNCHECKED	= 0x0020,	/* needs verification */
+	LIBXFS_B_DELWRI_Q	= 0x0040,	/* buffer is on a delwri list */
 };
 
 #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
@@ -168,6 +170,10 @@ extern void	libxfs_putbuf (xfs_buf_t *);
 
 #endif
 
+extern void	libxfs_buf_delwri_add(struct xfs_buf *bp, int flags,
+			struct list_head *delwri_list);
+extern int	libxfs_buf_delwri_flush(struct list_head *delwri_list);
+
 extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
 extern xfs_buf_t *libxfs_getsb(struct xfs_mount *, int);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 14a4633e9fa6..7fbaae571abe 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -579,6 +579,7 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 	bp->b_holder = 0;
 	bp->b_recur = 0;
 	bp->b_ops = NULL;
+	list_head_init(&bp->b_list);
 
 	if (!bp->b_maps) {
 		bp->b_nmaps = 1;
@@ -1196,6 +1197,70 @@ libxfs_writebuf(xfs_buf_t *bp, int flags)
 	return 0;
 }
 
+void
+libxfs_buf_delwri_add(
+	struct xfs_buf		*bp,
+	int			flags,
+	struct list_head	*delwri_list)
+{
+	if (bp->b_flags & LIBXFS_B_DELWRI_Q) {
+		libxfs_putbuf(bp);
+		return;
+	}
+
+	libxfs_writebuf_int(bp, flags);
+	bp->b_flags |= LIBXFS_B_DELWRI_Q;
+	list_add(&bp->b_list, delwri_list);
+}
+
+/*
+ * Compare function is more complex than it needs to be because
+ * the return value is only 32 bits and we are doing comparisons
+ * on 64 bit values
+ */
+static int
+xfs_buf_cmp(
+	void		*priv,
+	struct list_head *a,
+	struct list_head *b)
+{
+	struct xfs_buf	*ap = container_of(a, struct xfs_buf, b_list);
+	struct xfs_buf	*bp = container_of(b, struct xfs_buf, b_list);
+	xfs_daddr_t	diff;
+
+	diff = ap->b_maps[0].bm_bn - bp->b_maps[0].bm_bn;
+	if (diff < 0)
+		return -1;
+	if (diff > 0)
+		return 1;
+	return 0;
+}
+
+/* Processes entire list, but only returns the first error found */
+int
+libxfs_buf_delwri_flush(
+	struct list_head	*delwri_list)
+{
+	struct xfs_buf		*bp;
+	int			 error = 0;
+
+	list_sort(NULL, delwri_list, xfs_buf_cmp);
+	while (!list_empty(delwri_list)) {
+		bp = list_first_entry(delwri_list, struct xfs_buf, b_list);
+		list_del_init(&bp->b_list);
+		bp->b_flags &= ~LIBXFS_B_DELWRI_Q;
+		if (!bp->b_error && (bp->b_flags & LIBXFS_B_DIRTY)) {
+			int ret;
+			ret = libxfs_writebufr(bp);
+			if (ret && !error)
+				error = ret;
+		}
+		libxfs_putbuf(bp);
+	}
+	return error;
+}
+
+
 void
 libxfs_iomove(xfs_buf_t *bp, uint boff, int len, void *data, int flags)
 {
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 2bb0d3b8e2d1..c3da46479efa 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -728,10 +728,11 @@ inode_item_done(
 
 static void
 buf_item_done(
-	xfs_buf_log_item_t	*bip)
+	struct xfs_buf_log_item	*bip,
+	struct list_head	*delwri_list)
 {
-	xfs_buf_t		*bp;
-	int			hold;
+	struct xfs_buf		*bp;
+	bool			hold;
 	extern kmem_zone_t	*xfs_buf_item_zone;
 
 	bp = bip->bli_buf;
@@ -745,7 +746,13 @@ buf_item_done(
 		fprintf(stderr, "flushing/staling buffer %p (hold=%d)\n",
 			bp, hold);
 #endif
-		libxfs_writebuf_int(bp, 0);
+		if (delwri_list) {
+			/* delwri list needs to hold on to the buffer here */
+			libxfs_buf_delwri_add(bp, 0, delwri_list);
+			hold = true;
+		} else {
+			libxfs_writebuf_int(bp, 0);
+		}
 	}
 	if (hold)
 		bip->bli_flags &= ~XFS_BLI_HOLD;
@@ -757,7 +764,8 @@ buf_item_done(
 
 static void
 trans_committed(
-	xfs_trans_t		*tp)
+	struct xfs_trans	*tp,
+	struct list_head	*delwri_list)
 {
 	struct xfs_log_item	*lip, *next;
 
@@ -765,7 +773,7 @@ trans_committed(
 		xfs_trans_del_item(lip);
 
 		if (lip->li_type == XFS_LI_BUF)
-			buf_item_done((xfs_buf_log_item_t *)lip);
+			buf_item_done((xfs_buf_log_item_t *)lip, delwri_list);
 		else if (lip->li_type == XFS_LI_INODE)
 			inode_item_done((xfs_inode_log_item_t *)lip);
 		else {
@@ -828,11 +836,12 @@ xfs_trans_free_items(
 /*
  * Commit the changes represented by this transaction
  */
-int
-libxfs_trans_commit(
-	xfs_trans_t	*tp)
+static int
+trans_commit(
+	struct xfs_trans	*tp,
+	struct list_head	*delwri_list)
 {
-	xfs_sb_t	*sbp;
+	struct xfs_sb		*sbp;
 
 	if (tp == NULL)
 		return 0;
@@ -862,9 +871,25 @@ libxfs_trans_commit(
 #ifdef XACT_DEBUG
 	fprintf(stderr, "committing dirty transaction %p\n", tp);
 #endif
-	trans_committed(tp);
+	trans_committed(tp, delwri_list);
 
 	/* That's it for the transaction structure.  Free it. */
 	xfs_trans_free(tp);
 	return 0;
 }
+
+int
+libxfs_trans_commit(
+	struct xfs_trans	*tp)
+{
+	return trans_commit(tp, NULL);
+}
+
+int
+libxfs_trans_commit_delwri(
+	struct xfs_trans	*tp,
+	struct list_head	*delwri_list)
+{
+	return trans_commit(tp, delwri_list);
+}
+
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d70fbdb6b15a..b751b1fcb4a3 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3374,7 +3374,8 @@ initialise_ag_headers(
 	struct xfs_mount	*mp,
 	struct xfs_sb		*sbp,
 	xfs_agnumber_t		agno,
-	int			*freelist_size)
+	int			*freelist_size,
+	struct list_head	*delwri_list)
 {
 	struct xfs_perag	*pag = libxfs_perag_get(mp, agno);
 	struct xfs_agfl		*agfl;
@@ -3402,7 +3403,7 @@ initialise_ag_headers(
 	buf->b_ops = &xfs_sb_buf_ops;
 	memset(buf->b_addr, 0, cfg->sectorsize);
 	libxfs_sb_to_disk(buf->b_addr, sbp);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 
 	/*
 	 * AG header block: freespace
@@ -3469,7 +3470,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 		exit(1);
 	}
 
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 
 	/*
 	 * AG freelist header block
@@ -3489,7 +3490,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 			agfl->agfl_bno[bucket] = cpu_to_be32(NULLAGBLOCK);
 	}
 
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 
 	/*
 	 * AG header block: inodes
@@ -3518,7 +3519,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 		platform_uuid_copy(&agi->agi_uuid, &sbp->sb_uuid);
 	for (c = 0; c < XFS_AGI_UNLINKED_BUCKETS; c++)
 		agi->agi_unlinked[c] = cpu_to_be32(NULLAGINO);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 
 	/*
 	 * BNO btree root block
@@ -3570,7 +3571,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 	if (!arec->ar_blockcount)
 		block->bb_numrecs = 0;
 
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 
 	/*
 	 * CNT btree root block
@@ -3612,7 +3613,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 	if (!arec->ar_blockcount)
 		block->bb_numrecs = 0;
 
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 
 	/*
 	 * refcount btree root block
@@ -3626,7 +3627,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, cfg->blocksize);
 		libxfs_btree_init_block(mp, buf, XFS_BTNUM_REFC, 0, 0, agno, 0);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 	}
 
 	/*
@@ -3639,7 +3640,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 	block = XFS_BUF_TO_BLOCK(buf);
 	memset(block, 0, cfg->blocksize);
 	libxfs_btree_init_block(mp, buf, XFS_BTNUM_INO, 0, 0, agno, 0);
-	libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+	libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 
 	/*
 	 * Free INO btree root block
@@ -3652,7 +3653,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 		block = XFS_BUF_TO_BLOCK(buf);
 		memset(block, 0, cfg->blocksize);
 		libxfs_btree_init_block(mp, buf, XFS_BTNUM_FINO, 0, 0, agno, 0);
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 	}
 
 	/* RMAP btree root block */
@@ -3728,7 +3729,7 @@ _("%s: Abort! Freelist size (%u) for AG %u not constant (%u)!\n"),
 			be16_add_cpu(&block->bb_numrecs, 1);
 		}
 
-		libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+		libxfs_buf_delwri_add(buf, LIBXFS_EXIT_ON_FAILURE, delwri_list);
 	}
 
 	libxfs_perag_put(pag);
@@ -3738,7 +3739,8 @@ static void
 initialise_ag_freespace(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
-	int			freelist_size)
+	int			freelist_size,
+	struct list_head	*delwri_list)
 {
 	struct xfs_alloc_arg	args;
 	struct xfs_trans	*tp;
@@ -3758,7 +3760,7 @@ initialise_ag_freespace(
 
 	libxfs_alloc_fix_freelist(&args, 0);
 	libxfs_perag_put(args.pag);
-	libxfs_trans_commit(tp);
+	libxfs_trans_commit_delwri(tp, delwri_list);
 }
 
 /*
@@ -3812,6 +3814,7 @@ main(
 	char			*protofile = NULL;
 	char			*protostring = NULL;
 	int			freelist_size = 0;
+	LIST_HEAD		(delwri_list);
 
 	struct libxfs_xinit	xi = {
 		.isdirect = LIBXFS_DIRECT,
@@ -4042,9 +4045,13 @@ main(
 	 * Initialise all the AG headers on disk.
 	 */
 	for (agno = 0; agno < cfg.agcount; agno++) {
-		initialise_ag_headers(&cfg, mp, sbp, agno, &freelist_size);
-		initialise_ag_freespace(mp, agno, freelist_size);
+		initialise_ag_headers(&cfg, mp, sbp, agno, &freelist_size,
+				      &delwri_list);
+		initialise_ag_freespace(mp, agno, freelist_size, &delwri_list);
+		if (agno && !(agno % 100))
+			libxfs_buf_delwri_flush(&delwri_list);
 	}
+	libxfs_buf_delwri_flush(&delwri_list);
 
 	/*
 	 * Allocate the root inode and anything else in the proto file.
-- 
2.17.0
