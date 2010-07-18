Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6IKaRMo163627 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 15:36:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBDBCBD867B
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:45:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lik2ZWBjhDG88Du9 for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 13:45:59 -0700 (PDT)
Message-Id: <20100718203925.908589529@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 16:38:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/6] xfs: fix gcc 4.6 set but not read and unused statement
	warnings
References: <20100718203848.927859114@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-gcc46-warnings
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
Cc: Andi Kleen <ak@linux.intel.com>

[hch: dropped a few hunks that need structural changes instead]

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: xfs/fs/xfs/xfs_da_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_da_btree.c	2010-07-03 10:53:08.000000000 +0200
+++ xfs/fs/xfs/xfs_da_btree.c	2010-07-18 07:00:15.917494680 +0200
@@ -576,16 +576,14 @@ xfs_da_node_add(xfs_da_state_t *state, x
 	xfs_da_intnode_t *node;
 	xfs_da_node_entry_t *btree;
 	int tmp;
-	xfs_mount_t *mp;
 
 	node = oldblk->bp->data;
-	mp = state->mp;
 	ASSERT(be16_to_cpu(node->hdr.info.magic) == XFS_DA_NODE_MAGIC);
 	ASSERT((oldblk->index >= 0) && (oldblk->index <= be16_to_cpu(node->hdr.count)));
 	ASSERT(newblk->blkno != 0);
 	if (state->args->whichfork == XFS_DATA_FORK)
-		ASSERT(newblk->blkno >= mp->m_dirleafblk &&
-		       newblk->blkno < mp->m_dirfreeblk);
+		ASSERT(newblk->blkno >= state->mp->m_dirleafblk &&
+		       newblk->blkno < state->mp->m_dirfreeblk);
 
 	/*
 	 * We may need to make some room before we insert the new node.
Index: xfs/fs/xfs/xfs_dir2_block.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2_block.c	2010-07-03 10:53:08.000000000 +0200
+++ xfs/fs/xfs/xfs_dir2_block.c	2010-07-18 07:00:15.917494680 +0200
@@ -1071,10 +1071,10 @@ xfs_dir2_sf_to_block(
 	 */
 
 	buf_len = dp->i_df.if_bytes;
-	buf = kmem_alloc(dp->i_df.if_bytes, KM_SLEEP);
+	buf = kmem_alloc(buf_len, KM_SLEEP);
 
-	memcpy(buf, sfp, dp->i_df.if_bytes);
-	xfs_idata_realloc(dp, -dp->i_df.if_bytes, XFS_DATA_FORK);
+	memcpy(buf, sfp, buf_len);
+	xfs_idata_realloc(dp, -buf_len, XFS_DATA_FORK);
 	dp->i_d.di_size = 0;
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	/*
Index: xfs/fs/xfs/xfs_iget.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iget.c	2010-07-03 10:53:08.000000000 +0200
+++ xfs/fs/xfs/xfs_iget.c	2010-07-18 07:00:15.925494680 +0200
@@ -261,7 +261,6 @@ xfs_iget_cache_miss(
 {
 	struct xfs_inode	*ip;
 	int			error;
-	unsigned long		first_index, mask;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
 
 	ip = xfs_inode_alloc(mp, ino);
@@ -298,8 +297,6 @@ xfs_iget_cache_miss(
 			BUG();
 	}
 
-	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
-	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);
 
 	/* insert the new inode */
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-07-16 08:07:57.855494681 +0200
+++ xfs/fs/xfs/xfs_inode.c	2010-07-18 07:00:15.930494680 +0200
@@ -918,7 +918,6 @@ xfs_iread_extents(
 	int		error;
 	xfs_ifork_t	*ifp;
 	xfs_extnum_t	nextents;
-	size_t		size;
 
 	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		XFS_ERROR_REPORT("xfs_iread_extents", XFS_ERRLEVEL_LOW,
@@ -926,7 +925,6 @@ xfs_iread_extents(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
-	size = nextents * sizeof(xfs_bmbt_rec_t);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	/*
@@ -3501,13 +3499,11 @@ xfs_iext_remove_indirect(
 	xfs_extnum_t	ext_diff;	/* extents to remove in current list */
 	xfs_extnum_t	nex1;		/* number of extents before idx */
 	xfs_extnum_t	nex2;		/* extents after idx + count */
-	int		nlists;		/* entries in indirection array */
 	int		page_idx = idx;	/* index in target extent list */
 
 	ASSERT(ifp->if_flags & XFS_IFEXTIREC);
 	erp = xfs_iext_idx_to_irec(ifp,  &page_idx, &erp_idx, 0);
 	ASSERT(erp != NULL);
-	nlists = ifp->if_real_bytes / XFS_IEXT_BUFSZ;
 	nex1 = page_idx;
 	ext_cnt = count;
 	while (ext_cnt) {
Index: xfs/fs/xfs/xfs_inode_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode_item.c	2010-07-03 10:53:08.000000000 +0200
+++ xfs/fs/xfs/xfs_inode_item.c	2010-07-18 07:00:15.935494680 +0200
@@ -214,7 +214,6 @@ xfs_inode_item_format(
 	uint			nvecs;
 	size_t			data_bytes;
 	xfs_bmbt_rec_t		*ext_buffer;
-	int			nrecs;
 	xfs_mount_t		*mp;
 
 	vecp->i_addr = &iip->ili_format;
@@ -314,9 +313,8 @@ xfs_inode_item_format(
 			ASSERT(ip->i_df.if_u1.if_extents != NULL);
 			ASSERT(ip->i_d.di_nextents > 0);
 			ASSERT(iip->ili_extents_buf == NULL);
-			nrecs = ip->i_df.if_bytes /
-				(uint)sizeof(xfs_bmbt_rec_t);
-			ASSERT(nrecs > 0);
+			ASSERT((ip->i_df.if_bytes /
+				(uint)sizeof(xfs_bmbt_rec_t)) > 0);
 #ifdef XFS_NATIVE_HOST
 			if (nrecs == ip->i_d.di_nextents) {
 				/*
@@ -439,15 +437,15 @@ xfs_inode_item_format(
 		ASSERT(!(iip->ili_format.ilf_fields &
 			 (XFS_ILOG_ADATA | XFS_ILOG_ABROOT)));
 		if (iip->ili_format.ilf_fields & XFS_ILOG_AEXT) {
-			ASSERT(ip->i_afp->if_bytes > 0);
-			ASSERT(ip->i_afp->if_u1.if_extents != NULL);
-			ASSERT(ip->i_d.di_anextents > 0);
 #ifdef DEBUG
-			nrecs = ip->i_afp->if_bytes /
+			int nrecs = ip->i_afp->if_bytes /
 				(uint)sizeof(xfs_bmbt_rec_t);
-#endif
 			ASSERT(nrecs > 0);
 			ASSERT(nrecs == ip->i_d.di_anextents);
+			ASSERT(ip->i_afp->if_bytes > 0);
+			ASSERT(ip->i_afp->if_u1.if_extents != NULL);
+			ASSERT(ip->i_d.di_anextents > 0);
+#endif
 #ifdef XFS_NATIVE_HOST
 			/*
 			 * There are not delayed allocation extents
@@ -889,10 +887,8 @@ xfs_iflush_abort(
 	xfs_inode_t		*ip)
 {
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
-	xfs_mount_t		*mp;
 
 	iip = ip->i_itemp;
-	mp = ip->i_mount;
 	if (iip) {
 		struct xfs_ail	*ailp = iip->ili_item.li_ailp;
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2010-07-16 08:03:14.000000000 +0200
+++ xfs/fs/xfs/xfs_log.c	2010-07-18 07:00:15.941494680 +0200
@@ -1042,7 +1042,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
 	xfs_buf_t		*bp;
 	int			i;
-	int			iclogsize;
 	int			error = ENOMEM;
 	uint			log2_size = 0;
 
@@ -1122,7 +1121,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	 * with different amounts of memory.  See the definition of
 	 * xlog_in_core_t in xfs_log_priv.h for details.
 	 */
-	iclogsize = log->l_iclog_size;
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i=0; i < log->l_iclog_bufs; i++) {
 		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2010-07-18 06:58:25.017494682 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2010-07-18 07:00:15.949494680 +0200
@@ -683,8 +683,6 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	ltbno;		/* start bno of left side entry */
 	xfs_agblock_t	ltbnoa;		/* aligned ... */
 	xfs_extlen_t	ltdiff;		/* difference to left side entry */
-	/*REFERENCED*/
-	xfs_agblock_t	ltend;		/* end bno of left side entry */
 	xfs_extlen_t	ltlen;		/* length of left side entry */
 	xfs_extlen_t	ltlena;		/* aligned ... */
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
@@ -809,8 +807,7 @@ xfs_alloc_ag_vextent_near(
 		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		ltend = ltbno + ltlen;
-		ASSERT(ltend <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 		args->len = blen;
 		if (!xfs_alloc_fix_minleft(args)) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
@@ -823,7 +820,7 @@ xfs_alloc_ag_vextent_near(
 		 */
 		args->agbno = bnew;
 		ASSERT(bnew >= ltbno);
-		ASSERT(bnew + blen <= ltend);
+		ASSERT(bnew + blen <= ltbno + ltlen);
 		/*
 		 * Set up a cursor for the by-bno tree.
 		 */
@@ -1152,7 +1149,6 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * Fix up the length and compute the useful address.
 	 */
-	ltend = ltbno + ltlen;
 	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args)) {
@@ -1165,7 +1161,7 @@ xfs_alloc_ag_vextent_near(
 	(void)xfs_alloc_compute_diff(args->agbno, rlen, args->alignment, ltbno,
 		ltlen, &ltnew);
 	ASSERT(ltnew >= ltbno);
-	ASSERT(ltnew + rlen <= ltend);
+	ASSERT(ltnew + rlen <= ltbno + ltlen);
 	ASSERT(ltnew + rlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 	args->agbno = ltnew;
 	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
