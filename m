Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5E8BRxo032490 for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 03:11:27 -0500
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 539453C424C
	for <xfs@oss.sgi.com>; Mon, 14 Jun 2010 01:13:58 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by
	cuda.sgi.com with ESMTP id rzYOFrlyCFtl9QKt for
	<xfs@oss.sgi.com>; Mon, 14 Jun 2010 01:13:58 -0700 (PDT)
Date: Mon, 14 Jun 2010 10:13:56 +0200
From: Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] XFS: Fix gcc 4.6 set but not read and unused statement
	warnings v2
Message-ID: <20100614081356.GA27499@basil.fritz.box>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, ak@linux.intel.com, dgc@fromorbit.com, hch@lst.de

XFS: Fix gcc 4.6 set but not read and unused statement warnings v2

Addresses (near) all outstanding comments:

v2: QASSERT removed. Dave Chinners comments addressed (well
the one I liked). CONFIG_XFS_DEBUG builds again now.
I checked RT+QUOTA enabled and there was no new warnings
(if someone is interested i put the remaining ones
at http://halobates.de/xfs-all-gcc46)

-Andi

---

For my configuration, that is without quota or RT.

Mostly dead code removed I think (but needs additional review) 

That is there were one or two bad error handling cases,
but they were not easily fixable, with comments 
and I left the warnings in for those for you to remember.

e.g. if there is a ENOSPC down in xfs_trans.c while
modifying the superblock it would not be handled.

Unused statements were mostly related to stub macros for disabled
features like QUOTA or RT ALLOC. I replace those with
inlines.

There were also some problems with variables used in ASSERT()
I partly moved those into the ASSERT itself.

v2: QASSERT removed. Dave Chinners comments addressed (well
the one I liked). CONFIG_XFS_DEBUG builds again now.
I checked RT+QUOTA enabled and there was no new warnings
(if someone is interested i put the remaining ones
at http://halobates.de/xfs-all-gcc46)

Cc: xfs@oss.sgi.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/xfs/linux-2.6/xfs_sync.c |    3 +++
 fs/xfs/xfs_alloc.c          |   10 +++-------
 fs/xfs/xfs_da_btree.c       |   19 +++++++------------
 fs/xfs/xfs_dir2_block.c     |    6 +++---
 fs/xfs/xfs_filestream.c     |   16 +++++-----------
 fs/xfs/xfs_iget.c           |    3 ---
 fs/xfs/xfs_inode.c          |    4 ----
 fs/xfs/xfs_inode_item.c     |    8 ++------
 fs/xfs/xfs_log.c            |    2 --
 fs/xfs/xfs_quota.h          |   14 ++++++++++----
 fs/xfs/xfs_trans.c          |    6 +++++-
 11 files changed, 38 insertions(+), 53 deletions(-)

Index: linux-2.6.35-rc3-gcc/fs/xfs/linux-2.6/xfs_sync.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/linux-2.6/xfs_sync.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/linux-2.6/xfs_sync.c
@@ -554,6 +554,9 @@ xfs_sync_worker(
 		xfs_log_force(mp, 0);
 		xfs_reclaim_inodes(mp, 0);
 		/* dgc: errors ignored here */
+		/* ak: yes and you'll get a warning for it now when you
+		 * upgrade compilers.
+		 */
 		error = xfs_qm_sync(mp, SYNC_TRYLOCK);
 		if (xfs_log_need_covered(mp))
 			error = xfs_commit_dummy_trans(mp, 0);
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_da_btree.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_da_btree.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_da_btree.c
@@ -581,16 +581,14 @@ xfs_da_node_add(xfs_da_state_t *state, x
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
@@ -710,8 +708,6 @@ STATIC int
 xfs_da_root_join(xfs_da_state_t *state, xfs_da_state_blk_t *root_blk)
 {
 	xfs_da_intnode_t *oldroot;
-	/* REFERENCED */
-	xfs_da_blkinfo_t *blkinfo;
 	xfs_da_args_t *args;
 	xfs_dablk_t child;
 	xfs_dabuf_t *bp;
@@ -742,15 +738,14 @@ xfs_da_root_join(xfs_da_state_t *state,
 	if (error)
 		return(error);
 	ASSERT(bp != NULL);
-	blkinfo = bp->data;
 	if (be16_to_cpu(oldroot->hdr.level) == 1) {
-		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DIR2_LEAFN_MAGIC ||
-		       be16_to_cpu(blkinfo->magic) == XFS_ATTR_LEAF_MAGIC);
+		ASSERT(be16_to_cpu(bp->data->magic) == XFS_DIR2_LEAFN_MAGIC ||
+		       be16_to_cpu(bp->data->magic) == XFS_ATTR_LEAF_MAGIC);
 	} else {
-		ASSERT(be16_to_cpu(blkinfo->magic) == XFS_DA_NODE_MAGIC);
+		ASSERT(be16_to_cpu(bp->data->magic) == XFS_DA_NODE_MAGIC);
 	}
-	ASSERT(!blkinfo->forw);
-	ASSERT(!blkinfo->back);
+	ASSERT(!bp->data->forw);
+	ASSERT(!bp->data->back);
 	memcpy(root_blk->bp->data, bp->data, state->blocksize);
 	xfs_da_log_buf(args->trans, root_blk->bp, 0, state->blocksize - 1);
 	error = xfs_da_shrink_inode(args, child, bp);
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_dir2_block.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_dir2_block.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_dir2_block.c
@@ -1073,10 +1073,10 @@ xfs_dir2_sf_to_block(
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
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_filestream.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_filestream.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_filestream.c
@@ -140,9 +140,8 @@ _xfs_filestream_pick_ag(
 	int		flags,
 	xfs_extlen_t	minlen)
 {
-	int		streams, max_streams;
 	int		err, trylock, nscan;
-	xfs_extlen_t	longest, free, minfree, maxfree = 0;
+	xfs_extlen_t	longest, minfree, maxfree = 0;
 	xfs_agnumber_t	ag, max_ag = NULLAGNUMBER;
 	struct xfs_perag *pag;
 
@@ -174,7 +173,6 @@ _xfs_filestream_pick_ag(
 		/* Keep track of the AG with the most free blocks. */
 		if (pag->pagf_freeblks > maxfree) {
 			maxfree = pag->pagf_freeblks;
-			max_streams = atomic_read(&pag->pagf_fstrms);
 			max_ag = ag;
 		}
 
@@ -196,8 +194,6 @@ _xfs_filestream_pick_ag(
 		     (flags & XFS_PICK_LOWSPACE))) {
 
 			/* Break out, retaining the reference on the AG. */
-			free = pag->pagf_freeblks;
-			streams = atomic_read(&pag->pagf_fstrms);
 			xfs_perag_put(pag);
 			*agp = ag;
 			break;
@@ -234,8 +230,6 @@ next_ag:
 		if (max_ag != NULLAGNUMBER) {
 			xfs_filestream_get_ag(mp, max_ag);
 			TRACE_AG_PICK1(mp, max_ag, maxfree);
-			streams = max_streams;
-			free = maxfree;
 			*agp = max_ag;
 			break;
 		}
@@ -364,7 +358,8 @@ xfs_fstrm_free_func(
 	/* Drop the reference taken on the AG when the item was added. */
 	ref = xfs_filestream_put_ag(ip->i_mount, item->ag);
 
-	ASSERT(ref >= 0);
+	if (ref < 0)
+		ASSERT(0);
 	TRACE_FREE(ip->i_mount, ip, item->pip, item->ag,
 		xfs_filestream_peek_ag(ip->i_mount, item->ag));
 
@@ -465,7 +460,6 @@ xfs_filestream_lookup_ag(
 	xfs_mru_cache_t	*cache;
 	fstrm_item_t	*item;
 	xfs_agnumber_t	ag;
-	int		ref;
 
 	if (!(ip->i_d.di_mode & (S_IFREG | S_IFDIR))) {
 		ASSERT(0);
@@ -481,10 +475,10 @@ xfs_filestream_lookup_ag(
 
 	ASSERT(ip == item->ip);
 	ag = item->ag;
-	ref = xfs_filestream_peek_ag(ip->i_mount, ag);
 	xfs_mru_cache_done(cache);
 
-	TRACE_LOOKUP(ip->i_mount, ip, item->pip, ag, ref);
+	TRACE_LOOKUP(ip->i_mount, ip, item->pip, ag,
+			xfs_filestream_peek_ag(ip->i_mount, ag));
 	return ag;
 }
 
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_iget.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_iget.c
@@ -265,7 +265,6 @@ xfs_iget_cache_miss(
 {
 	struct xfs_inode	*ip;
 	int			error;
-	unsigned long		first_index, mask;
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ino);
 
 	ip = xfs_inode_alloc(mp, ino);
@@ -302,8 +301,6 @@ xfs_iget_cache_miss(
 			BUG();
 	}
 
-	mask = ~(((XFS_INODE_CLUSTER_SIZE(mp) >> mp->m_sb.sb_inodelog)) - 1);
-	first_index = agino & mask;
 	write_lock(&pag->pag_ici_lock);
 
 	/* insert the new inode */
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_inode.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_inode.c
@@ -925,7 +925,6 @@ xfs_iread_extents(
 	int		error;
 	xfs_ifork_t	*ifp;
 	xfs_extnum_t	nextents;
-	size_t		size;
 
 	if (unlikely(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)) {
 		XFS_ERROR_REPORT("xfs_iread_extents", XFS_ERRLEVEL_LOW,
@@ -933,7 +932,6 @@ xfs_iread_extents(
 		return XFS_ERROR(EFSCORRUPTED);
 	}
 	nextents = XFS_IFORK_NEXTENTS(ip, whichfork);
-	size = nextents * sizeof(xfs_bmbt_rec_t);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	/*
@@ -3517,13 +3515,11 @@ xfs_iext_remove_indirect(
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
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_inode_item.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_inode_item.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_inode_item.c
@@ -220,7 +220,6 @@ xfs_inode_item_format(
 	xfs_inode_t		*ip;
 	size_t			data_bytes;
 	xfs_bmbt_rec_t		*ext_buffer;
-	int			nrecs;
 	xfs_mount_t		*mp;
 
 	ip = iip->ili_inode;
@@ -323,9 +322,8 @@ xfs_inode_item_format(
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
@@ -957,10 +955,8 @@ xfs_iflush_abort(
 	xfs_inode_t		*ip)
 {
 	xfs_inode_log_item_t	*iip = ip->i_itemp;
-	xfs_mount_t		*mp;
 
 	iip = ip->i_itemp;
-	mp = ip->i_mount;
 	if (iip) {
 		struct xfs_ail	*ailp = iip->ili_item.li_ailp;
 		if (iip->ili_item.li_flags & XFS_LI_IN_AIL) {
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_log.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_log.c
@@ -1047,7 +1047,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
 	xfs_buf_t		*bp;
 	int			i;
-	int			iclogsize;
 	int			error = ENOMEM;
 	uint			log2_size = 0;
 
@@ -1127,7 +1126,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	 * with different amounts of memory.  See the definition of
 	 * xlog_in_core_t in xfs_log_priv.h for details.
 	 */
-	iclogsize = log->l_iclog_size;
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i=0; i < log->l_iclog_bufs; i++) {
 		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_quota.h
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_quota.h
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_quota.h
@@ -346,7 +346,13 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip,
 #define xfs_trans_mod_dquot_byino(tp, ip, fields, delta)
 #define xfs_trans_apply_dquot_deltas(tp)
 #define xfs_trans_unreserve_and_mod_dquots(tp)
-#define xfs_trans_reserve_quota_nblks(tp, ip, nblks, ninos, flags)	(0)
+
+static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *t,
+		struct xfs_inode *i, long a, long b, uint c)
+{
+	return 0;
+}
+
 #define xfs_trans_reserve_quota_bydquots(tp, mp, u, g, nb, ni, fl)	(0)
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
@@ -355,13 +361,13 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip,
 #define xfs_qm_dqattach(ip, fl)						(0)
 #define xfs_qm_dqattach_locked(ip, fl)					(0)
 #define xfs_qm_dqdetach(ip)
-#define xfs_qm_dqrele(d)
+static inline void xfs_qm_dqrele(struct xfs_dquot *d) {}
 #define xfs_qm_statvfs(ip, s)
-#define xfs_qm_sync(mp, fl)						(0)
+static inline int xfs_qm_sync(struct xfs_mount *m, int i) { return 0; }
 #define xfs_qm_newmount(mp, a, b)					(0)
 #define xfs_qm_mount_quotas(mp)
 #define xfs_qm_unmount(mp)
-#define xfs_qm_unmount_quotas(mp)					(0)
+static inline void xfs_qm_unmount_quotas(struct xfs_mount *m) {}
 #endif /* CONFIG_XFS_QUOTA */
 
 #define xfs_trans_unreserve_quota_nblks(tp, ip, nblks, ninos, flags) \
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_trans.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_trans.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_trans.c
@@ -1119,7 +1119,11 @@ xfs_trans_unreserve_and_mod_sb(
 	if (msbp > msb) {
 		error = xfs_mod_incore_sb_batch(tp->t_mountp, msb,
 			(uint)(msbp - msb), rsvd);
-		ASSERT(error == 0);
+		/*
+	 	 * When an error happens here it's a race that's supposed
+		 * to be fixed. Check for this unconditionally.
+		 */
+		BUG_ON(error != 0);
 	}
 }
 
Index: linux-2.6.35-rc3-gcc/fs/xfs/xfs_alloc.c
===================================================================
--- linux-2.6.35-rc3-gcc.orig/fs/xfs/xfs_alloc.c
+++ linux-2.6.35-rc3-gcc/fs/xfs/xfs_alloc.c
@@ -688,8 +688,6 @@ xfs_alloc_ag_vextent_near(
 	xfs_agblock_t	ltbno;		/* start bno of left side entry */
 	xfs_agblock_t	ltbnoa;		/* aligned ... */
 	xfs_extlen_t	ltdiff;		/* difference to left side entry */
-	/*REFERENCED*/
-	xfs_agblock_t	ltend;		/* end bno of left side entry */
 	xfs_extlen_t	ltlen;		/* length of left side entry */
 	xfs_extlen_t	ltlena;		/* aligned ... */
 	xfs_agblock_t	ltnew;		/* useful start bno of left side */
@@ -814,8 +812,7 @@ xfs_alloc_ag_vextent_near(
 		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
 			goto error0;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
-		ltend = ltbno + ltlen;
-		ASSERT(ltend <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
+		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
 		args->len = blen;
 		if (!xfs_alloc_fix_minleft(args)) {
 			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
@@ -828,7 +825,7 @@ xfs_alloc_ag_vextent_near(
 		 */
 		args->agbno = bnew;
 		ASSERT(bnew >= ltbno);
-		ASSERT(bnew + blen <= ltend);
+		ASSERT(bnew + blen <= ltbno + ltlen);
 		/*
 		 * Set up a cursor for the by-bno tree.
 		 */
@@ -1157,7 +1154,6 @@ xfs_alloc_ag_vextent_near(
 	/*
 	 * Fix up the length and compute the useful address.
 	 */
-	ltend = ltbno + ltlen;
 	args->len = XFS_EXTLEN_MIN(ltlena, args->maxlen);
 	xfs_alloc_fix_len(args);
 	if (!xfs_alloc_fix_minleft(args)) {
@@ -1170,7 +1166,7 @@ xfs_alloc_ag_vextent_near(
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
