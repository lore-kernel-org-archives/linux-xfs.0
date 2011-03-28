Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SL650t185402 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:06:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD1D3383CEE
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lm98MoKfufDLhQlU for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q4JgZ-0001sm-80
	for xfs@oss.sgi.com; Mon, 28 Mar 2011 21:09:15 +0000
Message-Id: <20110328210915.214513168@bombadil.infradead.org>
Date: Mon, 28 Mar 2011 17:06:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] xfs: allow reusing busy extents where safe
References: <20110328210614.832613417@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-user-allocations
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

Allow reusing any busy extent for metadata allocations, and reusing busy
userdata extents for userdata allocations.  Most of the complexity is
propagating the userdata information from the XFS_BMAPI_METADATA flag
to xfs_bunmapi into the low-level extent freeing routines.  After that
we can just track what type of busy extent we have and treat it accordingly.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-03-28 16:09:32.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-03-28 16:14:49.253338527 +0200
@@ -1396,7 +1396,8 @@ xfs_alloc_ag_vextent_small(
 		if (error)
 			goto error0;
 		if (fbno != NULLAGBLOCK) {
-			xfs_alloc_busy_reuse(args->tp, args->agno, fbno, 1);
+			xfs_alloc_busy_reuse(args->tp, args->agno, fbno, 1,
+					     args->userdata);
 
 			if (args->userdata) {
 				xfs_buf_t	*bp;
@@ -2431,7 +2432,8 @@ int				/* error */
 xfs_free_extent(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len)	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	bool		userdata)
 {
 	xfs_alloc_arg_t	args;
 	int		error;
@@ -2444,6 +2446,7 @@ xfs_free_extent(
 	ASSERT(args.agno < args.mp->m_sb.sb_agcount);
 	args.agbno = XFS_FSB_TO_AGBNO(args.mp, bno);
 	args.pag = xfs_perag_get(args.mp, args.agno);
+	args.userdata = userdata;
 	if ((error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING)))
 		goto error0;
 #ifdef DEBUG
@@ -2453,7 +2456,7 @@ xfs_free_extent(
 #endif
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 	if (!error)
-		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len);
+		xfs_alloc_busy_insert(tp, args.agno, args.agbno, len, userdata);
 error0:
 	xfs_perag_put(args.pag);
 	return error;
@@ -2464,7 +2467,8 @@ xfs_alloc_busy_insert(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
-	xfs_extlen_t		len)
+	xfs_extlen_t		len,
+	bool			userdata)
 {
 	struct xfs_busy_extent	*new;
 	struct xfs_busy_extent	*busyp;
@@ -2487,6 +2491,7 @@ xfs_alloc_busy_insert(
 	new->agno = agno;
 	new->bno = bno;
 	new->length = len;
+	new->flags = userdata ? XFS_ALLOC_BUSY_USERDATA : 0;
 	INIT_LIST_HEAD(&new->list);
 
 	/* trace before insert to be able to see failed inserts */
@@ -2569,6 +2574,12 @@ xfs_alloc_busy_search(
 	return match;
 }
 
+enum {
+	XFS_BUSY_REUSE_OK,
+	XFS_BUSY_LOG_FORCE,
+	XFS_BUSY_RESCAN,
+};
+
 /*
  * The found free extent [fbno, fend] overlaps part or all of the given busy
  * extent.  If the overlap covers the beginning, the end, or all of the busy
@@ -2580,7 +2591,7 @@ xfs_alloc_busy_search(
  * The caller will force the log and re-check the busy list after returning
  * from this function.
  */
-STATIC void
+STATIC int
 xfs_alloc_busy_update_extent(
 	struct xfs_perag	*pag,
 	struct xfs_busy_extent	*busyp,
@@ -2608,6 +2619,7 @@ xfs_alloc_busy_update_extent(
 		 * Let the caller force out the log to clear the busy extents
 		 * and retry the search.
 		 */
+		 return XFS_BUSY_LOG_FORCE;
 	} else if (bbno >= fbno && bend <= fend) {
 		/*
 		 * Case 2:
@@ -2645,6 +2657,7 @@ xfs_alloc_busy_update_extent(
 		 */
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 		busyp->length = 0;
+		return XFS_BUSY_RESCAN;
 	} else if (bbno == fbno) {
 		/*
 		 * Case 6:
@@ -2680,6 +2693,8 @@ xfs_alloc_busy_update_extent(
 	} else {
 		ASSERT(0);
 	}
+
+	return XFS_BUSY_REUSE_OK;
 }
 
 
@@ -2691,7 +2706,8 @@ xfs_alloc_busy_reuse(
 	struct xfs_trans	*tp,
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		fbno,
-	xfs_extlen_t		flen)
+	xfs_extlen_t		flen,
+	bool			userdata)
 {
 	struct xfs_perag	*pag;
 	struct rb_node		*rbp;
@@ -2699,6 +2715,7 @@ xfs_alloc_busy_reuse(
 	ASSERT(flen > 0);
 
 	pag = xfs_perag_get(tp->t_mountp, agno);
+restart:
 	spin_lock(&pag->pagb_lock);
 	rbp = pag->pagb_tree.rb_node;
 	while (rbp) {
@@ -2707,6 +2724,7 @@ xfs_alloc_busy_reuse(
 		xfs_agblock_t	fend = fbno + flen;
 		xfs_agblock_t	bbno = busyp->bno;
 		xfs_agblock_t	bend = bbno + busyp->length;
+		int		ret;
 
 		if (fend <= bbno) {
 			rbp = rbp->rb_left;
@@ -2716,10 +2734,21 @@ xfs_alloc_busy_reuse(
 			continue;
 		}
 
-		xfs_alloc_busy_update_extent(pag, busyp, fbno, fbno + flen);
-
-		spin_unlock(&pag->pagb_lock);
-		xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
+		ret = xfs_alloc_busy_update_extent(pag, busyp,
+						   fbno, fbno + flen);
+		if (ret != XFS_BUSY_REUSE_OK || userdata) {
+			spin_unlock(&pag->pagb_lock);
+			if (ret == XFS_BUSY_LOG_FORCE)
+				xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
+ 			goto restart;
+		}
+#if 0
+		/*
+		 * No more busy extents to search.
+		 */
+		if (bbno <= fbno && bend >= fend)
+			break;
+#endif
 	}
 	spin_unlock(&pag->pagb_lock);
 	xfs_perag_put(pag);
@@ -2743,6 +2772,11 @@ xfs_alloc_busy_trim(
 
 	ASSERT(flen > 0);
 
+	if (!args->userdata) {
+		xfs_alloc_busy_reuse(args->tp, args->agno, fbno, flen, false);
+		goto out;
+	}
+
 	spin_lock(&args->pag->pagb_lock);
 	rbp = args->pag->pagb_tree.rb_node;
 	while (rbp && flen >= args->minlen) {
@@ -2883,7 +2917,7 @@ xfs_alloc_busy_trim(
 		flen = fend - fbno;
 	}
 	spin_unlock(&args->pag->pagb_lock);
-
+out:
 	*rbno = fbno;
 	*rlen = flen;
 	return;
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2011-03-28 16:10:24.930841761 +0200
@@ -137,7 +137,7 @@ xfs_alloc_longest_free_extent(struct xfs
 #ifdef __KERNEL__
 void
 xfs_alloc_busy_insert(struct xfs_trans *tp, xfs_agnumber_t agno,
-	xfs_agblock_t bno, xfs_extlen_t len);
+	xfs_agblock_t bno, xfs_extlen_t len, bool userdata);
 
 void
 xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
@@ -148,7 +148,7 @@ xfs_alloc_busy_search(struct xfs_mount *
 
 void
 xfs_alloc_busy_reuse(struct xfs_trans *tp, xfs_agnumber_t agno,
-	xfs_agblock_t fbno, xfs_extlen_t flen);
+	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
 #endif	/* __KERNEL__ */
 
 /*
@@ -224,7 +224,8 @@ int				/* error */
 xfs_free_extent(
 	struct xfs_trans *tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len);	/* length of extent */
+	xfs_extlen_t	len,
+	bool		userdata);/* length of extent */
 
 int					/* error */
 xfs_alloc_lookup_le(
Index: xfs/fs/xfs/xfs_alloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc_btree.c	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_alloc_btree.c	2011-03-28 16:10:24.938837964 +0200
@@ -95,7 +95,7 @@ xfs_allocbt_alloc_block(
 		return 0;
 	}
 
-	xfs_alloc_busy_reuse(cur->bc_tp, cur->bc_private.a.agno, bno, 1);
+	xfs_alloc_busy_reuse(cur->bc_tp, cur->bc_private.a.agno, bno, 1, false);
 
 	xfs_trans_agbtree_delta(cur->bc_tp, 1);
 	new->s = cpu_to_be32(bno);
@@ -120,18 +120,8 @@ xfs_allocbt_free_block(
 	if (error)
 		return error;
 
-	/*
-	 * Since blocks move to the free list without the coordination used in
-	 * xfs_bmap_finish, we can't allow block to be available for
-	 * reallocation and non-transaction writing (user data) until we know
-	 * that the transaction that moved it to the free list is permanently
-	 * on disk. We track the blocks by declaring these blocks as "busy";
-	 * the busy list is maintained on a per-ag basis and each transaction
-	 * records which entries should be removed when the iclog commits to
-	 * disk. If a busy block is allocated, the iclog is pushed up to the
-	 * LSN that freed the block.
-	 */
-	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1);
+	xfs_alloc_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno,
+			      1, false);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 	return 0;
 }
Index: xfs/fs/xfs/xfs_ag.h
===================================================================
--- xfs.orig/fs/xfs/xfs_ag.h	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_ag.h	2011-03-28 16:10:24.938837964 +0200
@@ -187,6 +187,8 @@ struct xfs_busy_extent {
 	xfs_agnumber_t	agno;
 	xfs_agblock_t	bno;
 	xfs_extlen_t	length;
+	unsigned int	flags;
+#define XFS_ALLOC_BUSY_USERDATA		0x01	/* freed data extents */
 };
 
 /*
Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-03-28 16:06:23.049342208 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-03-28 16:10:24.942837745 +0200
@@ -180,22 +180,6 @@ xfs_bmap_btree_to_extents(
 	int			whichfork); /* data or attr fork */
 
 /*
- * Called by xfs_bmapi to update file extent records and the btree
- * after removing space (or undoing a delayed allocation).
- */
-STATIC int				/* error */
-xfs_bmap_del_extent(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_trans_t		*tp,	/* current trans pointer */
-	xfs_extnum_t		idx,	/* extent number to update/insert */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp,/* inode logging flags */
-	int			whichfork, /* data or attr fork */
-	int			rsvd);	 /* OK to allocate reserved blocks */
-
-/*
  * Remove the entry "free" from the free item list.  Prev points to the
  * previous entry, unless "free" is the head of the list.
  */
@@ -2811,7 +2795,7 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(cbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1, 0);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -2838,8 +2822,7 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
-	int			whichfork, /* data or attr fork */
-	int			rsvd)	/* OK to allocate reserved blocks */
+	int			flags)	/* XFS_BMAPI_* flags */
 {
 	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
 	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
@@ -2849,7 +2832,6 @@ xfs_bmap_del_extent(
 	int			do_fx;	/* free extent at end of routine */
 	xfs_bmbt_rec_host_t	*ep;	/* current extent entry pointer */
 	int			error;	/* error return value */
-	int			flags;	/* inode logging flags */
 	xfs_bmbt_irec_t		got;	/* current extent entry */
 	xfs_fileoff_t		got_endoff;	/* first offset past got */
 	int			i;	/* temp state */
@@ -2861,12 +2843,17 @@ xfs_bmap_del_extent(
 	uint			qfield;	/* quota field to update */
 	xfs_filblks_t		temp;	/* for indirect length calculations */
 	xfs_filblks_t		temp2;	/* for indirect length calculations */
-	int			state = 0;
+	int			state, whichfork;
 
 	XFS_STATS_INC(xs_del_exlist);
 
-	if (whichfork == XFS_ATTR_FORK)
-		state |= BMAP_ATTRFORK;
+	if (flags & XFS_BMAPI_ATTRFORK) {
+		whichfork = XFS_ATTR_FORK;
+		state = BMAP_ATTRFORK;
+	} else {
+		whichfork = XFS_DATA_FORK;
+		state = 0;
+	}
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -3121,9 +3108,13 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx)
-		xfs_bmap_add_free(del->br_startblock, del->br_blockcount, flist,
-			mp);
+	if (do_fx) {
+		xfs_bmap_add_free(mp, flist, del->br_startblock,
+				  del->br_blockcount,
+				  (flags & XFS_BMAPI_METADATA) ? 0 :
+				   XFS_BFI_USERDATA);
+	}
+
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
@@ -3142,7 +3133,9 @@ xfs_bmap_del_extent(
 	ASSERT(da_old >= da_new);
 	if (da_old > da_new) {
 		xfs_icsb_modify_counters(mp, XFS_SBS_FDBLOCKS,
-			(int64_t)(da_old - da_new), rsvd);
+			(int64_t)(da_old - da_new),
+			!!(flags & XFS_BMAPI_RSVBLOCKS));
+
 	}
 done:
 	*logflagsp = flags;
@@ -3723,10 +3716,11 @@ error0:
 /* ARGSUSED */
 void
 xfs_bmap_add_free(
+	struct xfs_mount	*mp,		/* mount point structure */
+	struct xfs_bmap_free	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len,		/* length of extent */
-	xfs_bmap_free_t		*flist,		/* list of extents */
-	xfs_mount_t		*mp)		/* mount point structure */
+	unsigned int		flags)
 {
 	xfs_bmap_free_item_t	*cur;		/* current (next) element */
 	xfs_bmap_free_item_t	*new;		/* new element */
@@ -3750,6 +3744,7 @@ xfs_bmap_add_free(
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
+	new->xbfi_flags = flags;
 	for (prev = NULL, cur = flist->xbf_first;
 	     cur != NULL;
 	     prev = cur, cur = cur->xbfi_next) {
@@ -3883,8 +3878,11 @@ xfs_bmap_finish(
 	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
-		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
-				free->xbfi_blockcount))) {
+
+		error = xfs_free_extent(ntp, free->xbfi_startblock,
+				free->xbfi_blockcount,
+				!!(free->xbfi_flags & XFS_BFI_USERDATA));
+		if (error) {
 			/*
 			 * The bmap free list will be cleaned up at a
 			 * higher level.  The EFI will be canceled when
@@ -5278,7 +5276,7 @@ xfs_bunmapi(
 			goto error0;
 		}
 		error = xfs_bmap_del_extent(ip, tp, lastx, flist, cur, &del,
-				&tmp_logflags, whichfork, rsvd);
+				&tmp_logflags, flags);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
Index: xfs/fs/xfs/xfs_bmap.h
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.h	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap.h	2011-03-28 16:10:24.950887404 +0200
@@ -35,6 +35,8 @@ typedef struct xfs_bmap_free_item
 {
 	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
 	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
+	unsigned int		xbfi_flags;
+#define XFS_BFI_USERDATA	0x01		/* userdata extent */
 	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
 } xfs_bmap_free_item_t;
 
@@ -188,10 +190,11 @@ xfs_bmap_add_attrfork(
  */
 void
 xfs_bmap_add_free(
+	struct xfs_mount	*mp,		/* mount point structure */
+	struct xfs_bmap_free	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
 	xfs_filblks_t		len,		/* length of extent */
-	xfs_bmap_free_t		*flist,		/* list of extents */
-	struct xfs_mount	*mp);		/* mount point structure */
+	unsigned int		flags);
 
 /*
  * Routine to clean up the free list data structure when
Index: xfs/fs/xfs/xfs_bmap_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap_btree.c	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_bmap_btree.c	2011-03-28 16:10:24.950887404 +0200
@@ -598,7 +598,7 @@ xfs_bmbt_free_block(
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
 
-	xfs_bmap_add_free(fsbno, 1, cur->bc_private.b.flist, mp);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1, 0);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
Index: xfs/fs/xfs/xfs_fsops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_fsops.c	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_fsops.c	2011-03-28 16:10:24.954839193 +0200
@@ -344,7 +344,7 @@ xfs_growfs_data_private(
 		 * Free the new space.
 		 */
 		error = xfs_free_extent(tp, XFS_AGB_TO_FSB(mp, agno,
-			be32_to_cpu(agf->agf_length) - new), new);
+			be32_to_cpu(agf->agf_length) - new), new, false);
 		if (error) {
 			goto error0;
 		}
Index: xfs/fs/xfs/xfs_ialloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc.c	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_ialloc.c	2011-03-28 16:10:24.954839193 +0200
@@ -1154,9 +1154,10 @@ xfs_difree(
 			goto error0;
 		}
 
-		xfs_bmap_add_free(XFS_AGB_TO_FSB(mp,
-				agno, XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
-				XFS_IALLOC_BLOCKS(mp), flist, mp);
+		xfs_bmap_add_free(mp, flist,
+				  XFS_AGB_TO_FSB(mp, agno,
+					XFS_INO_TO_AGBNO(mp,rec.ir_startino)),
+				  XFS_IALLOC_BLOCKS(mp), 0);
 	} else {
 		*delete = 0;
 
Index: xfs/fs/xfs/xfs_ialloc_btree.c
===================================================================
--- xfs.orig/fs/xfs/xfs_ialloc_btree.c	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_ialloc_btree.c	2011-03-28 16:10:24.954839193 +0200
@@ -117,7 +117,7 @@ xfs_inobt_free_block(
 	int			error;
 
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1);
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1, false);
 	if (error)
 		return error;
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-03-28 16:06:23.000000000 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2011-03-28 16:10:24.958839336 +0200
@@ -2907,8 +2907,9 @@ xlog_recover_process_efi(
 	efdp = xfs_trans_get_efd(tp, efip, efip->efi_format.efi_nextents);
 
 	for (i = 0; i < efip->efi_format.efi_nextents; i++) {
-		extp = &(efip->efi_format.efi_extents[i]);
-		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len);
+		extp = &efip->efi_format.efi_extents[i];
+		error = xfs_free_extent(tp, extp->ext_start, extp->ext_len,
+					false);
 		if (error)
 			goto abort_error;
 		xfs_trans_log_efd_extent(tp, efdp, extp->ext_start,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
