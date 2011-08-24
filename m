Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66jl6014500 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 125711F03733
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	qYLWVSkQV4Niapkh for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6br-0005EB-Er
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:43 +0000
Message-Id: <20110824060643.401685261@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 14/25] xfs: remove xfs_bmap_add_extent
References: <20110824060428.789245205@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-bmapi-split-xfs_bmap_extent-2
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

There is no real need to the xfs_bmap_add_extent, as the callers know what
kind of extents they need to it.  Removing it means duplicating the
extents to btree conversion logic in three places, but overall it's still
a lot less, and much simpler code.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_bmap.c
===================================================================
--- xfs.orig/fs/xfs/xfs_bmap.c	2011-08-23 21:14:31.535436367 +0200
+++ xfs/fs/xfs/xfs_bmap.c	2011-08-23 21:14:33.735424450 +0200
@@ -50,17 +50,22 @@
 #include "xfs_trace.h"
 
 
-#ifdef DEBUG
-STATIC void
-xfs_bmap_check_leaf_extents(xfs_btree_cur_t *cur, xfs_inode_t *ip, int whichfork);
-#endif
-
 kmem_zone_t		*xfs_bmap_free_item_zone;
 
 /*
  * Prototypes for internal bmap routines.
  */
 
+#ifdef DEBUG
+STATIC void
+xfs_bmap_check_leaf_extents(
+	struct xfs_btree_cur	*cur,
+	struct xfs_inode	*ip,
+	int			whichfork);
+#else
+#define xfs_bmap_check_leaf_extents(cur, ip, whichfork)		do { } while (0)
+#endif
+
 
 /*
  * Called from xfs_bmap_add_attrfork to handle extents format files.
@@ -85,47 +90,6 @@ xfs_bmap_add_attrfork_local(
 	int			*flags);	/* inode logging flags */
 
 /*
- * Called by xfs_bmap_add_extent to handle cases converting a delayed
- * allocation to a real allocation.
- */
-STATIC int				/* error */
-xfs_bmap_add_extent_delay_real(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	xfs_filblks_t		*dnew,	/* new delayed-alloc indirect blocks */
-	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp); /* inode logging flags */
-
-/*
- * Called by xfs_bmap_add_extent to handle cases converting a hole
- * to a real allocation.
- */
-STATIC int				/* error */
-xfs_bmap_add_extent_hole_real(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp, /* inode logging flags */
-	int			whichfork); /* data or attr fork */
-
-/*
- * Called by xfs_bmap_add_extent to handle cases converting an unwritten
- * allocation to a real allocation or vice versa.
- */
-STATIC int				/* error */
-xfs_bmap_add_extent_unwritten_real(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	int			*logflagsp); /* inode logging flags */
-
-/*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
  * It figures out where to ask the underlying allocator to put the new extent.
  */
@@ -407,147 +371,7 @@ xfs_bmap_add_attrfork_local(
 }
 
 /*
- * Update file extent records and the btree after allocating space.
- */
-STATIC int				/* error */
-xfs_bmap_add_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
-	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
-	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp, /* inode logging flags */
-	int			whichfork) /* data or attr fork */
-{
-	xfs_btree_cur_t		*cur;	/* btree cursor or null */
-	xfs_filblks_t		da_new; /* new count del alloc blocks used */
-	xfs_filblks_t		da_old; /* old count del alloc blocks used */
-	int			error;	/* error return value */
-	xfs_ifork_t		*ifp;	/* inode fork ptr */
-	int			logflags; /* returned value */
-	xfs_extnum_t		nextents; /* number of extents in file now */
-
-	XFS_STATS_INC(xs_add_exlist);
-
-	cur = *curp;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	da_old = da_new = 0;
-	error = 0;
-
-	ASSERT(*idx >= 0);
-	ASSERT(*idx <= nextents);
-	ASSERT(!isnullstartblock(new->br_startblock));
-
-	/*
-	 * Real allocation off the end of the file.
-	 */
-	if (*idx == nextents) {
-		if (cur)
-			ASSERT((cur->bc_private.b.flags &
-				XFS_BTCUR_BPRV_WASDEL) == 0);
-		error = xfs_bmap_add_extent_hole_real(ip, idx, cur, new,
-				&logflags, whichfork);
-	} else {
-		xfs_bmbt_irec_t	prev;	/* old extent at offset idx */
-
-		/*
-		 * Get the record referred to by idx.
-		 */
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *idx), &prev);
-		/*
-		 * If it's a real allocation record, and the new allocation ends
-		 * after the start of the referred to record, then we're filling
-		 * in a delayed or unwritten allocation with a real one, or
-		 * converting real back to unwritten.
-		 */
-		if (!isnullstartblock(new->br_startblock) &&
-		    new->br_startoff + new->br_blockcount > prev.br_startoff) {
-			if (prev.br_state != XFS_EXT_UNWRITTEN &&
-			    isnullstartblock(prev.br_startblock)) {
-				da_old = startblockval(prev.br_startblock);
-				if (cur)
-					ASSERT(cur->bc_private.b.flags &
-						XFS_BTCUR_BPRV_WASDEL);
-				error = xfs_bmap_add_extent_delay_real(tp, ip,
-						idx, &cur, new, &da_new,
-						first, flist, &logflags);
-			} else {
-				ASSERT(new->br_state == XFS_EXT_NORM ||
-				       new->br_state == XFS_EXT_UNWRITTEN);
-
-				error = xfs_bmap_add_extent_unwritten_real(ip,
-						idx, &cur, new, &logflags);
-				if (error)
-					goto done;
-			}
-		}
-		/*
-		 * Otherwise we're filling in a hole with an allocation.
-		 */
-		else {
-			if (cur)
-				ASSERT((cur->bc_private.b.flags &
-					XFS_BTCUR_BPRV_WASDEL) == 0);
-			error = xfs_bmap_add_extent_hole_real(ip, idx, cur,
-					new, &logflags, whichfork);
-		}
-	}
-
-	if (error)
-		goto done;
-	ASSERT(*curp == cur || *curp == NULL);
-
-	/*
-	 * Convert to a btree if necessary.
-	 */
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
-	    XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max) {
-		int	tmp_logflags;	/* partial log flag return val */
-
-		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, first,
-			flist, &cur, da_old > 0, &tmp_logflags, whichfork);
-		logflags |= tmp_logflags;
-		if (error)
-			goto done;
-	}
-	/*
-	 * Adjust for changes in reserved delayed indirect blocks.
-	 * Nothing to do for disk quotas here.
-	 */
-	if (da_old || da_new) {
-		xfs_filblks_t	nblks;
-
-		nblks = da_new;
-		if (cur)
-			nblks += cur->bc_private.b.allocated;
-		ASSERT(nblks <= da_old);
-		if (nblks < da_old)
-			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
-				(int64_t)(da_old - nblks), 0);
-	}
-	/*
-	 * Clear out the allocated field, done with it now in any case.
-	 */
-	if (cur) {
-		cur->bc_private.b.allocated = 0;
-		*curp = cur;
-	}
-done:
-#ifdef DEBUG
-	if (!error)
-		xfs_bmap_check_leaf_extents(*curp, ip, whichfork);
-#endif
-	*logflagsp = logflags;
-	return error;
-}
-
-/*
- * Called by xfs_bmap_add_extent to handle cases converting a delayed
- * allocation to a real allocation.
+ * Convert a delayed allocation to a real allocation.
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_delay_real(
@@ -556,7 +380,6 @@ xfs_bmap_add_extent_delay_real(
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
-	xfs_filblks_t		*dnew,	/* new delayed-alloc indirect blocks */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp) /* inode logging flags */
@@ -572,10 +395,24 @@ xfs_bmap_add_extent_delay_real(
 					/* left is 0, right is 1, prev is 2 */
 	int			rval=0;	/* return value (logging flags) */
 	int			state = 0;/* state bits, accessed thru macros */
-	xfs_filblks_t		temp=0;	/* value for dnew calculations */
-	xfs_filblks_t		temp2=0;/* value for dnew calculations */
+	xfs_filblks_t		da_new; /* new count del alloc blocks used */
+	xfs_filblks_t		da_old; /* old count del alloc blocks used */
+	xfs_filblks_t		temp=0;	/* value for da_new calculations */
+	xfs_filblks_t		temp2=0;/* value for da_new calculations */
 	int			tmp_rval;	/* partial logging flags */
 
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	cur = *curp;
+
+	ASSERT(*idx >= 0);
+	ASSERT(*idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
+	ASSERT(!isnullstartblock(new->br_startblock));
+	ASSERT(!cur || (cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+
+	XFS_STATS_INC(xs_add_exlist);
+
+	*logflagsp = 0;
+
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
 #define	PREV		r[2]
@@ -583,14 +420,15 @@ xfs_bmap_add_extent_delay_real(
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
-	cur = *curp;
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	ep = xfs_iext_get_ext(ifp, *idx);
 	xfs_bmbt_get_all(ep, &PREV);
 	new_endoff = new->br_startoff + new->br_blockcount;
 	ASSERT(PREV.br_startoff <= new->br_startoff);
 	ASSERT(PREV.br_startoff + PREV.br_blockcount >= new_endoff);
 
+	da_old = startblockval(PREV.br_startblock);
+	da_new = 0;
+
 	/*
 	 * Set flags determining what part of the previous delayed allocation
 	 * extent is being replaced by a real allocation.
@@ -688,7 +526,6 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, LEFT.br_state)))
 				goto done;
 		}
-		*dnew = 0;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -719,7 +556,6 @@ xfs_bmap_add_extent_delay_real(
 					PREV.br_blockcount, LEFT.br_state)))
 				goto done;
 		}
-		*dnew = 0;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -749,8 +585,6 @@ xfs_bmap_add_extent_delay_real(
 					RIGHT.br_blockcount, PREV.br_state)))
 				goto done;
 		}
-
-		*dnew = 0;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -778,8 +612,6 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(i == 1, done);
 		}
-
-		*dnew = 0;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -813,13 +645,12 @@ xfs_bmap_add_extent_delay_real(
 					LEFT.br_state)))
 				goto done;
 		}
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock));
-		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		--*idx;
-		*dnew = temp;
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -856,14 +687,12 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, *idx + 1);
-		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
 		trace_xfs_bmap_post_update(ip, *idx + 1, state, _THIS_IP_);
-
-		*dnew = temp;
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -896,14 +725,13 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 		}
 
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock));
 		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
-		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		++*idx;
-		*dnew = temp;
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -939,15 +767,14 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
-		temp = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
 			startblockval(PREV.br_startblock) -
 			(cur ? cur->bc_private.b.allocated : 0));
 		ep = xfs_iext_get_ext(ifp, *idx);
-		xfs_bmbt_set_startblock(ep, nullstartblock((int)temp));
+		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
 
 		++*idx;
-		*dnew = temp;
 		break;
 
 	case 0:
@@ -1029,7 +856,7 @@ xfs_bmap_add_extent_delay_real(
 		trace_xfs_bmap_post_update(ip, *idx + 2, state, _THIS_IP_);
 
 		++*idx;
-		*dnew = temp + temp2;
+		da_new = temp + temp2;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
@@ -1044,9 +871,39 @@ xfs_bmap_add_extent_delay_real(
 		 */
 		ASSERT(0);
 	}
-	*curp = cur;
+
+	/* convert to a btree if necessary */
+	if (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > ifp->if_ext_max) {
+		int	tmp_logflags;	/* partial log flag return val */
+
+		ASSERT(cur == NULL);
+		error = xfs_bmap_extents_to_btree(tp, ip, first, flist, &cur,
+				da_old > 0, &tmp_logflags, XFS_DATA_FORK);
+		*logflagsp |= tmp_logflags;
+		if (error)
+			goto done;
+	}
+
+	/* adjust for changes in reserved delayed indirect blocks */
+	if (da_old || da_new) {
+		temp = da_new;
+		if (cur)
+			temp += cur->bc_private.b.allocated;
+		ASSERT(temp <= da_old);
+		if (temp < da_old)
+			xfs_icsb_modify_counters(ip->i_mount, XFS_SBS_FDBLOCKS,
+				(int64_t)(da_old - temp), 0);
+	}
+
+	/* clear out the allocated field, done with it now in any case. */
+	if (cur) {
+		cur->bc_private.b.allocated = 0;
+		*curp = cur;
+	}
+	xfs_bmap_check_leaf_extents(cur, ip, XFS_DATA_FORK);
 done:
-	*logflagsp = rval;
+	*logflagsp |= rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
@@ -1054,15 +911,17 @@ done:
 }
 
 /*
- * Called by xfs_bmap_add_extent to handle cases converting an unwritten
- * allocation to a real allocation or vice versa.
+ * Convert an unwritten allocation to a real allocation or vice versa.
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_unwritten_real(
+	struct xfs_trans	*tp,
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
 	xfs_btree_cur_t		**curp,	/* if *curp is null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
+	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
+	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp) /* inode logging flags */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
@@ -1078,15 +937,25 @@ xfs_bmap_add_extent_unwritten_real(
 	int			rval=0;	/* return value (logging flags) */
 	int			state = 0;/* state bits, accessed thru macros */
 
+	*logflagsp = 0;
+
+	cur = *curp;
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+
+	ASSERT(*idx >= 0);
+	ASSERT(*idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
+	ASSERT(!isnullstartblock(new->br_startblock));
+
+	XFS_STATS_INC(xs_add_exlist);
+
 #define	LEFT		r[0]
 #define	RIGHT		r[1]
 #define	PREV		r[2]
+
 	/*
 	 * Set up a bunch of variables to make the tests simpler.
 	 */
 	error = 0;
-	cur = *curp;
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	ep = xfs_iext_get_ext(ifp, *idx);
 	xfs_bmbt_get_all(ep, &PREV);
 	newext = new->br_state;
@@ -1537,9 +1406,29 @@ xfs_bmap_add_extent_unwritten_real(
 		 */
 		ASSERT(0);
 	}
-	*curp = cur;
+
+	/* convert to a btree if necessary */
+	if (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) > ifp->if_ext_max) {
+		int	tmp_logflags;	/* partial log flag return val */
+
+		ASSERT(cur == NULL);
+		error = xfs_bmap_extents_to_btree(tp, ip, first, flist, &cur,
+				0, &tmp_logflags, XFS_DATA_FORK);
+		*logflagsp |= tmp_logflags;
+		if (error)
+			goto done;
+	}
+
+	/* clear out the allocated field, done with it now in any case. */
+	if (cur) {
+		cur->bc_private.b.allocated = 0;
+		*curp = cur;
+	}
+
+	xfs_bmap_check_leaf_extents(*curp, ip, XFS_DATA_FORK);
 done:
-	*logflagsp = rval;
+	*logflagsp |= rval;
 	return error;
 #undef	LEFT
 #undef	RIGHT
@@ -1691,30 +1580,42 @@ xfs_bmap_add_extent_hole_delay(
 }
 
 /*
- * Called by xfs_bmap_add_extent to handle cases converting a hole
- * to a real allocation.
+ * Convert a hole to a real allocation.
  */
 STATIC int				/* error */
 xfs_bmap_add_extent_hole_real(
+	struct xfs_trans	*tp,
 	xfs_inode_t		*ip,	/* incore inode pointer */
 	xfs_extnum_t		*idx,	/* extent number to update/insert */
-	xfs_btree_cur_t		*cur,	/* if null, not a btree */
+	xfs_btree_cur_t		**curp,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
+	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
+	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
 	int			*logflagsp, /* inode logging flags */
 	int			whichfork) /* data or attr fork */
 {
 	int			error;	/* error return value */
 	int			i;	/* temp state */
+	xfs_btree_cur_t		*cur;	/* if null, not a btree */
 	xfs_ifork_t		*ifp;	/* inode fork pointer */
 	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
 	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
 
+	*logflagsp = 0;
+
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(*idx <= ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t));
-	state = 0;
+	cur = *curp;
+
+	ASSERT(*idx >= 0);
+	ASSERT(*idx <= ifp->if_bytes / sizeof(struct xfs_bmbt_rec));
+	ASSERT(!isnullstartblock(new->br_startblock));
+	ASSERT(!cur || !(cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
+
+	XFS_STATS_INC(xs_add_exlist);
 
+	state = 0;
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
 
@@ -1897,8 +1798,28 @@ xfs_bmap_add_extent_hole_real(
 		}
 		break;
 	}
+
+	/* convert to a btree if necessary */
+	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+	    XFS_IFORK_NEXTENTS(ip, whichfork) > ifp->if_ext_max) {
+		int	tmp_logflags;	/* partial log flag return val */
+
+		ASSERT(cur == NULL);
+		error = xfs_bmap_extents_to_btree(tp, ip, first,
+			flist, &cur, 0, &tmp_logflags, whichfork);
+		*logflagsp |= tmp_logflags;
+		if (error)
+			goto done;
+	}
+
+	/* clear out the allocated field, done with it now in any case. */
+	if (cur) {
+		cur->bc_private.b.allocated = 0;
+		*curp = cur;
+	}
+	xfs_bmap_check_leaf_extents(cur, ip, whichfork);
 done:
-	*logflagsp = rval;
+	*logflagsp |= rval;
 	return error;
 }
 
@@ -4787,14 +4708,22 @@ xfs_bmapi_allocate(
 	    xfs_sb_version_hasextflgbit(&mp->m_sb))
 		bma->gotp->br_state = XFS_EXT_UNWRITTEN;
 
-	error = xfs_bmap_add_extent(bma->tp, bma->ip, lastx, cur, bma->gotp,
-				    firstblock, flist, logflags, whichfork);
+	if (bma->wasdel) {
+		error = xfs_bmap_add_extent_delay_real(bma->tp, bma->ip, lastx,
+				cur, bma->gotp, firstblock, flist, logflags);
+	} else {
+		error = xfs_bmap_add_extent_hole_real(bma->tp, bma->ip, lastx,
+				cur, bma->gotp, firstblock, flist, logflags,
+				whichfork);
+	}
+
 	if (error)
 		return error;
 
 	/*
-	 * Update our extent pointer, given that xfs_bmap_add_extent  might
-	 * have merged it into one of the neighbouring ones.
+	 * Update our extent pointer, given that xfs_bmap_add_extent_delay_real
+	 * or xfs_bmap_add_extent_hole_real might have merged it into one of
+	 * the neighbouring ones.
 	 */
 	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), bma->gotp);
 
@@ -4849,14 +4778,15 @@ xfs_bmapi_convert_unwritten(
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
-	error = xfs_bmap_add_extent(bma->tp, bma->ip, lastx, cur, mval,
-				firstblock, flist, logflags, whichfork);
+	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, lastx,
+			cur, mval, firstblock, flist, logflags);
 	if (error)
 		return error;
 
 	/*
-	 * Update our extent pointer, given that xfs_bmap_add_extent  might
-	 * have merged it into one of the neighbouring ones.
+	 * Update our extent pointer, given that
+	 * xfs_bmap_add_extent_unwritten_real might have merged it into one
+	 * of the neighbouring ones.
 	 */
 	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), bma->gotp);
 
@@ -5290,9 +5220,9 @@ xfs_bunmapi(
 				del.br_blockcount = mod;
 			}
 			del.br_state = XFS_EXT_UNWRITTEN;
-			error = xfs_bmap_add_extent(tp, ip, &lastx, &cur, &del,
-				firstblock, flist, &logflags,
-				XFS_DATA_FORK);
+			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
+					&lastx, &cur, &del, firstblock, flist,
+					&logflags);
 			if (error)
 				goto error0;
 			goto nodelete;
@@ -5348,18 +5278,18 @@ xfs_bunmapi(
 				}
 				prev.br_state = XFS_EXT_UNWRITTEN;
 				lastx--;
-				error = xfs_bmap_add_extent(tp, ip, &lastx,
-						&cur, &prev, firstblock, flist,
-						&logflags, XFS_DATA_FORK);
+				error = xfs_bmap_add_extent_unwritten_real(tp,
+						ip, &lastx, &cur, &prev,
+						firstblock, flist, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;
 			} else {
 				ASSERT(del.br_state == XFS_EXT_NORM);
 				del.br_state = XFS_EXT_UNWRITTEN;
-				error = xfs_bmap_add_extent(tp, ip, &lastx,
-						&cur, &del, firstblock, flist,
-						&logflags, XFS_DATA_FORK);
+				error = xfs_bmap_add_extent_unwritten_real(tp,
+						ip, &lastx, &cur, &del,
+						firstblock, flist, &logflags);
 				if (error)
 					goto error0;
 				goto nodelete;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
