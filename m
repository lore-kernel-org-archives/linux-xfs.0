Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40391 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750775AbdFCRF1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Jun 2017 13:05:27 -0400
Date: Sat, 3 Jun 2017 10:04:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: try to avoid blowing out the transaction reservation
 when bunmaping a shared extent
Message-ID: <20170603170448.GC11308@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>

In a pathological scenario where we are trying to bunmapi a single
extent in which every other block is shared, it's possible that trying
to unmap the entire large extent in a single transaction can generate so
many EFIs that we overflow the transaction reservation.

Therefore, use a heuristic to guess at the number of blocks we can
safely unmap from a reflink file's data fork in an single transaction.
This should prevent problems such as the log head slamming into the tail
and ASSERTs that trigger because we've exceeded the transaction
reservation.

Note that since bunmapi can fail to unmap the entire range, we must also
teach the deferred unmap code to roll into a new transaction whenever we
get low on reservation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: random edits, all bugs are my fault]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     |   38 ++++++++++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_bmap.h     |    2 +-
 fs/xfs/libxfs/xfs_refcount.c |   10 +---------
 fs/xfs/libxfs/xfs_refcount.h |   16 ++++++++++++++++
 fs/xfs/xfs_bmap_item.c       |   17 +++++++++++++++--
 fs/xfs/xfs_trans.h           |    2 +-
 fs/xfs/xfs_trans_bmap.c      |   11 +++++++++--
 7 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0b241d6..210924d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5449,6 +5449,7 @@ __xfs_bunmapi(
 	int			whichfork;	/* data or attribute fork */
 	xfs_fsblock_t		sum;
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
+	xfs_fileoff_t		max_len;
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
@@ -5470,6 +5471,16 @@ __xfs_bunmapi(
 	ASSERT(len > 0);
 	ASSERT(nexts >= 0);
 
+	/*
+	 * Guesstimate how many blocks we can unmap without running the risk of
+	 * blowing out the transaction with a mix of EFIs and reflink
+	 * adjustments.
+	 */
+	if (xfs_is_reflink_inode(ip) && whichfork == XFS_DATA_FORK)
+		max_len = min(len, xfs_refcount_max_unmap(tp->t_log_res));
+	else
+		max_len = len;
+
 	if (!(ifp->if_flags & XFS_IFEXTENTS) &&
 	    (error = xfs_iread_extents(tp, ip, whichfork)))
 		return error;
@@ -5514,7 +5525,7 @@ __xfs_bunmapi(
 
 	extno = 0;
 	while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
-	       (nexts == 0 || extno < nexts)) {
+	       (nexts == 0 || extno < nexts) && max_len > 0) {
 		/*
 		 * Is the found extent after a hole in which bno lives?
 		 * Just back up to the previous extent, if so.
@@ -5546,6 +5557,15 @@ __xfs_bunmapi(
 		}
 		if (del.br_startoff + del.br_blockcount > bno + 1)
 			del.br_blockcount = bno + 1 - del.br_startoff;
+
+		/* How much can we safely unmap? */
+		if (max_len < del.br_blockcount) {
+			del.br_startoff += del.br_blockcount - max_len;
+			if (!wasdel)
+				del.br_startblock += del.br_blockcount - max_len;
+			del.br_blockcount = max_len;
+		}
+
 		sum = del.br_startblock + del.br_blockcount;
 		if (isrt &&
 		    (mod = do_mod(sum, mp->m_sb.sb_rextsize))) {
@@ -5722,6 +5742,7 @@ __xfs_bunmapi(
 		if (!isrt && wasdel)
 			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
 
+		max_len -= del.br_blockcount;
 		bno = del.br_startoff - 1;
 nodelete:
 		/*
@@ -6487,15 +6508,16 @@ xfs_bmap_finish_one(
 	int				whichfork,
 	xfs_fileoff_t			startoff,
 	xfs_fsblock_t			startblock,
-	xfs_filblks_t			blockcount,
+	xfs_filblks_t			*blockcount,
 	xfs_exntst_t			state)
 {
-	int				error = 0, done;
+	xfs_fsblock_t			firstfsb;
+	int				error = 0;
 
 	trace_xfs_bmap_deferred(tp->t_mountp,
 			XFS_FSB_TO_AGNO(tp->t_mountp, startblock), type,
 			XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
-			ip->i_ino, whichfork, startoff, blockcount, state);
+			ip->i_ino, whichfork, startoff, *blockcount, state);
 
 	if (WARN_ON_ONCE(whichfork != XFS_DATA_FORK))
 		return -EFSCORRUPTED;
@@ -6507,13 +6529,13 @@ xfs_bmap_finish_one(
 
 	switch (type) {
 	case XFS_BMAP_MAP:
-		error = xfs_bmapi_remap(tp, ip, startoff, blockcount,
+		error = xfs_bmapi_remap(tp, ip, startoff, *blockcount,
 				startblock, dfops, 0);
+		*blockcount = 0;
 		break;
 	case XFS_BMAP_UNMAP:
-		error = xfs_bunmapi(tp, ip, startoff, blockcount,
-				XFS_BMAPI_REMAP, 1, &startblock, dfops, &done);
-		ASSERT(done);
+		error = __xfs_bunmapi(tp, ip, startoff, blockcount, 0,
+				1, &firstfsb, dfops);
 		break;
 	default:
 		ASSERT(0);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 79dc312..d6cb130 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -275,7 +275,7 @@ struct xfs_bmap_intent {
 int	xfs_bmap_finish_one(struct xfs_trans *tp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, enum xfs_bmap_intent_type type,
 		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
-		xfs_filblks_t blockcount, xfs_exntst_t state);
+		xfs_filblks_t *blockcount, xfs_exntst_t state);
 int	xfs_bmap_map_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
 		struct xfs_inode *ip, struct xfs_bmbt_irec *imap);
 int	xfs_bmap_unmap_extent(struct xfs_mount *mp, struct xfs_defer_ops *dfops,
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 021c740..bdb83ed 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -801,14 +801,6 @@ xfs_refcount_merge_extents(
 }
 
 /*
- * While we're adjusting the refcounts records of an extent, we have
- * to keep an eye on the number of extents we're dirtying -- run too
- * many in a single transaction and we'll exceed the transaction's
- * reservation and crash the fs.  Each record adds 12 bytes to the
- * log (plus any key updates) so we'll conservatively assume 24 bytes
- * per record.  We must also leave space for btree splits on both ends
- * of the range and space for the CUD and a new CUI.
- *
  * XXX: This is a pretty hand-wavy estimate.  The penalty for guessing
  * true incorrectly is a shutdown FS; the penalty for guessing false
  * incorrectly is more transaction rolls than might be necessary.
@@ -839,7 +831,7 @@ xfs_refcount_still_have_space(
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
 	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_private.a.priv.refc.nr_ops * 32;
+		cur->bc_private.a.priv.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index cad61de..1d54c6c 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -77,4 +77,20 @@ extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
+/*
+ * While we're adjusting the refcounts records of an extent, we have
+ * to keep an eye on the number of extents we're dirtying -- run too
+ * many in a single transaction and we'll exceed the transaction's
+ * reservation and crash the fs.  Each record adds 12 bytes to the
+ * log (plus any key updates) so we'll conservatively assume 32 bytes
+ * per record.  We must also leave space for btree splits on both ends
+ * of the range and space for the CUD and a new CUI.
+ */
+#define XFS_REFCOUNT_ITEM_OVERHEAD	32
+
+static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
+{
+	return (log_res * 3 / 4) / XFS_REFCOUNT_ITEM_OVERHEAD;
+}
+
 #endif	/* __XFS_REFCOUNT_H__ */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d419d23..8807391 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -396,6 +396,7 @@ xfs_bui_recover(
 	struct xfs_map_extent		*bmap;
 	xfs_fsblock_t			startblock_fsb;
 	xfs_fsblock_t			inode_fsb;
+	xfs_filblks_t			count;
 	bool				op_ok;
 	struct xfs_bud_log_item		*budp;
 	enum xfs_bmap_intent_type	type;
@@ -404,6 +405,7 @@ xfs_bui_recover(
 	struct xfs_trans		*tp;
 	struct xfs_inode		*ip = NULL;
 	struct xfs_defer_ops		dfops;
+	struct xfs_bmbt_irec		irec;
 	xfs_fsblock_t			firstfsb;
 
 	ASSERT(!test_bit(XFS_BUI_RECOVERED, &buip->bui_flags));
@@ -481,13 +483,24 @@ xfs_bui_recover(
 	}
 	xfs_trans_ijoin(tp, ip, 0);
 
+	count = bmap->me_len;
 	error = xfs_trans_log_finish_bmap_update(tp, budp, &dfops, type,
 			ip, whichfork, bmap->me_startoff,
-			bmap->me_startblock, bmap->me_len,
-			state);
+			bmap->me_startblock, &count, state);
 	if (error)
 		goto err_dfops;
 
+	if (count > 0) {
+		ASSERT(type == XFS_BMAP_UNMAP);
+		irec.br_startblock = bmap->me_startblock;
+		irec.br_blockcount = count;
+		irec.br_startoff = bmap->me_startoff;
+		irec.br_state = state;
+		error = xfs_bmap_unmap_extent(tp->t_mountp, &dfops, ip, &irec);
+		if (error)
+			goto err_dfops;
+	}
+
 	/* Finish transaction, free inodes. */
 	error = xfs_defer_finish(&tp, &dfops, NULL);
 	if (error)
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 7fdfc4c8..ffa8c98 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -276,6 +276,6 @@ int xfs_trans_log_finish_bmap_update(struct xfs_trans *tp,
 		struct xfs_bud_log_item *rudp, struct xfs_defer_ops *dfops,
 		enum xfs_bmap_intent_type type, struct xfs_inode *ip,
 		int whichfork, xfs_fileoff_t startoff, xfs_fsblock_t startblock,
-		xfs_filblks_t blockcount, xfs_exntst_t state);
+		xfs_filblks_t *blockcount, xfs_exntst_t state);
 
 #endif	/* __XFS_TRANS_H__ */
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index 6408e7d..14543d9 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -63,7 +63,7 @@ xfs_trans_log_finish_bmap_update(
 	int				whichfork,
 	xfs_fileoff_t			startoff,
 	xfs_fsblock_t			startblock,
-	xfs_filblks_t			blockcount,
+	xfs_filblks_t			*blockcount,
 	xfs_exntst_t			state)
 {
 	int				error;
@@ -196,16 +196,23 @@ xfs_bmap_update_finish_item(
 	void				**state)
 {
 	struct xfs_bmap_intent		*bmap;
+	xfs_filblks_t			count;
 	int				error;
 
 	bmap = container_of(item, struct xfs_bmap_intent, bi_list);
+	count = bmap->bi_bmap.br_blockcount;
 	error = xfs_trans_log_finish_bmap_update(tp, done_item, dop,
 			bmap->bi_type,
 			bmap->bi_owner, bmap->bi_whichfork,
 			bmap->bi_bmap.br_startoff,
 			bmap->bi_bmap.br_startblock,
-			bmap->bi_bmap.br_blockcount,
+			&count,
 			bmap->bi_bmap.br_state);
+	if (!error && count > 0) {
+		ASSERT(bmap->bi_type == XFS_BMAP_UNMAP);
+		bmap->bi_bmap.br_blockcount = count;
+		return -EAGAIN;
+	}
 	kmem_free(bmap);
 	return error;
 }
