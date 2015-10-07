Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 47B3B29E89
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:07:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 29F6D8F8037
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:07:09 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id XgF34Eyxc1b26cTh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:07:00 -0700 (PDT)
Subject: [PATCH 16/51] libxfs: enhance rmapbt definition to support reflink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:06:56 -0700
Message-ID: <20151007050656.1504.18168.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Enlarge the rmapbt records to support reflink operation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_trace.h       |   12 +
 libxfs/util.c             |    2 
 libxfs/xfs_alloc.c        |   45 ++-
 libxfs/xfs_alloc.h        |    5 
 libxfs/xfs_bmap.c         |  281 +++++++++++++++++++--
 libxfs/xfs_bmap.h         |    5 
 libxfs/xfs_bmap_btree.c   |    7 -
 libxfs/xfs_format.h       |  120 +++++++++
 libxfs/xfs_ialloc.c       |    8 -
 libxfs/xfs_ialloc_btree.c |    6 
 libxfs/xfs_rmap.c         |  610 +++++++++++++++++++++++++++++++++++++++------
 libxfs/xfs_rmap_btree.c   |   85 ++++--
 libxfs/xfs_rmap_btree.h   |   38 ++-
 13 files changed, 1055 insertions(+), 169 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index ebdf778..2c8d34e 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -178,4 +178,16 @@
 #define trace_xfs_rmap_free_extent_done(a,b,c,d,e)	((void) 0)
 #define trace_xfs_rmap_free_extent_error(a,b,c,d,e)	((void) 0)
 
+#define trace_xfs_rmapbt_delete(a...)			((void) 0)
+#define trace_xfs_rmapbt_insert(a...)			((void) 0)
+#define trace_xfs_rmap_insert(a...)			((void) 0)
+#define trace_xfs_rmap_delete(a...)			((void) 0)
+#define trace_xfs_rmap_move(a...)			((void) 0)
+#define trace_xfs_rmap_slide(a...)			((void) 0)
+#define trace_xfs_rmap_resize(a...)			((void) 0)
+#define trace_xfs_rmapbt_update(a...)			((void) 0)
+#define trace_xfs_rmap_combine(a...)			((void) 0)
+#define trace_xfs_rmap_lcombine(a...)			((void) 0)
+#define trace_xfs_rmap_rcombine(a...)			((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/util.c b/libxfs/util.c
index c9f9175..32c3623 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -507,7 +507,7 @@ libxfs_bmap_finish(
 	for (free = flist->xbf_first; free != NULL; free = next) {
 		next = free->xbfi_next;
 		if ((error = xfs_free_extent(*tp, free->xbfi_startblock,
-				free->xbfi_blockcount)))
+				free->xbfi_blockcount, &free->xbfi_oinfo)))
 			return error;
 		xfs_bmap_del_free(flist, NULL, free);
 	}
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 40cb20a..7bb3a88 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -707,11 +707,13 @@ xfs_alloc_ag_vextent(
 	ASSERT(!args->wasfromfl || !args->isfl);
 	ASSERT(args->agbno % args->alignment == 0);
 
-	/* insert new block into the reverse map btree */
-	error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
-			       args->agbno, args->len, args->owner);
-	if (error)
-		return error;
+	/* if not file data, insert new block into the reverse map btree */
+	if (args->oinfo.oi_owner) {
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+				       args->agbno, args->len, &args->oinfo);
+		if (error)
+			return error;
+	}
 
 	if (!args->wasfromfl) {
 		error = xfs_alloc_update_counters(args->tp, args->pag,
@@ -1661,6 +1663,7 @@ xfs_free_ag_extent(
 	xfs_agnumber_t	agno,	/* allocation group number */
 	xfs_agblock_t	bno,	/* starting block number */
 	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo,	/* extent owner */
 	int		isfl)	/* set if is freelist blocks - no sb acctg */
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
@@ -1678,6 +1681,12 @@ xfs_free_ag_extent(
 	xfs_extlen_t	nlen;		/* new length of freespace */
 	xfs_perag_t	*pag;		/* per allocation group data */
 
+	if (oinfo->oi_owner) {
+		error = xfs_rmap_free(tp, agbp, agno, bno, len, oinfo);
+		if (error)
+			goto error0;
+	}
+
 	mp = tp->t_mountp;
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
@@ -2086,13 +2095,15 @@ xfs_alloc_fix_freelist(
 	 * back on the free list? Maybe we should only do this when space is
 	 * getting low or the AGFL is more than half full?
 	 */
+	XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
 	while (pag->pagf_flcount > need) {
 		struct xfs_buf	*bp;
 
 		error = xfs_alloc_get_freelist(tp, agbp, &bno, 0);
 		if (error)
 			goto out_agbp_relse;
-		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1, 1);
+		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
+					   &targs.oinfo, 1);
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
@@ -2102,7 +2113,7 @@ xfs_alloc_fix_freelist(
 	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
-	targs.owner = XFS_RMAP_OWN_AG;
+	XFS_RMAP_AG_OWNER(&targs.oinfo, XFS_RMAP_OWN_AG);
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
@@ -2361,6 +2372,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
 		return false;
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2491,6 +2506,8 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+		pag->pagf_levels[XFS_BTNUM_RMAPi] =
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		/* XXX: pagb_tree doesn't exist in userspace */
@@ -2733,14 +2750,13 @@ error0:
  * Free an extent.
  * Just break up the extent address and hand off to xfs_free_ag_extent
  * after fixing up the freelist.
- *
- * XXX: need owner of extent being freed
  */
 int				/* error */
 xfs_free_extent(
 	xfs_trans_t	*tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len)	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo)	/* extent owner */
 {
 	xfs_alloc_arg_t	args;
 	int		error;
@@ -2776,13 +2792,8 @@ xfs_free_extent(
 		goto error0;
 	}
 
-	/* XXX: need owner */
-	error = xfs_rmap_free(tp, args.agbp, args.agno, args.agbno, len, 0);
-	if (error)
-		goto error0;
-
-	/* XXX: initially no multiple references, so just free it */
-	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
+	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno,
+				   len, oinfo, 0);
 	if (!error)
 		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
 error0:
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 5b2b616..f78ce53 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -87,7 +87,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* set if this is user data */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
-	uint64_t	owner;		/* owner of blocks being allocated */
+	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*
@@ -179,7 +179,8 @@ int				/* error */
 xfs_free_extent(
 	struct xfs_trans *tp,	/* transaction pointer */
 	xfs_fsblock_t	bno,	/* starting block number of extent */
-	xfs_extlen_t	len);	/* length of extent */
+	xfs_extlen_t	len,	/* length of extent */
+	struct xfs_owner_info	*oinfo);	/* extent owner */
 
 int					/* error */
 xfs_alloc_lookup_le(
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 73fbdf0..14934eb 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota_defs.h"
+#include "xfs_rmap_btree.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -562,7 +563,8 @@ xfs_bmap_add_free(
 	struct xfs_mount	*mp,		/* mount point structure */
 	struct xfs_bmap_free	*flist,		/* list of extents */
 	xfs_fsblock_t		bno,		/* fs block number of extent */
-	xfs_filblks_t		len)		/* length of extent */
+	xfs_filblks_t		len,		/* length of extent */
+	struct xfs_owner_info	*oinfo)		/* extent owner */
 {
 	xfs_bmap_free_item_t	*cur;		/* current (next) element */
 	xfs_bmap_free_item_t	*new;		/* new element */
@@ -583,9 +585,14 @@ xfs_bmap_add_free(
 	ASSERT(agbno + len <= mp->m_sb.sb_agblocks);
 #endif
 	ASSERT(xfs_bmap_free_item_zone != NULL);
+
 	new = kmem_zone_alloc(xfs_bmap_free_item_zone, KM_SLEEP);
 	new->xbfi_startblock = bno;
 	new->xbfi_blockcount = (xfs_extlen_t)len;
+	if (oinfo)
+		memcpy(&new->xbfi_oinfo, oinfo, sizeof(struct xfs_owner_info));
+	else
+		memset(&new->xbfi_oinfo, 0, sizeof(struct xfs_owner_info));
 	for (prev = NULL, cur = flist->xbf_first;
 	     cur != NULL;
 	     prev = cur, cur = cur->xbfi_next) {
@@ -665,6 +672,7 @@ xfs_bmap_btree_to_extents(
 	xfs_mount_t		*mp;	/* mount point structure */
 	__be64			*pp;	/* ptr to block address */
 	struct xfs_btree_block	*rblock;/* root btree block */
+	struct xfs_owner_info	oinfo;
 
 	mp = ip->i_mount;
 	ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -688,7 +696,8 @@ xfs_bmap_btree_to_extents(
 	cblock = XFS_BUF_TO_BLOCK(cbp);
 	if ((error = xfs_btree_check_block(cur, cblock, 0, cbp)))
 		return error;
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1);
+	XFS_RMAP_INO_BMBT_OWNER(&oinfo, ip->i_ino, whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, cbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
@@ -769,7 +778,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
-	args.owner = ip->i_ino;
+	XFS_RMAP_INO_BMBT_OWNER(&args.oinfo, ip->i_ino, whichfork);
 	args.firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -916,7 +925,7 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
-	args.owner = ip->i_ino;
+	XFS_RMAP_INO_OWNER(&args.oinfo, ip->i_ino, whichfork, 0);
 	args.firstblock = *firstblock;
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -1845,6 +1854,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_combine(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -1877,6 +1890,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_lcombine(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -1908,6 +1925,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_rcombine(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, &RIGHT, &PREV, new);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -1937,6 +1958,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG:
@@ -1972,6 +1997,10 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_lcombine(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, &LEFT, new);
+		if (error)
+			goto done;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
 		xfs_bmbt_set_startblock(ep, nullstartblock(da_new));
@@ -2007,6 +2036,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2055,6 +2088,8 @@ xfs_bmap_add_extent_delay_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_rcombine(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, &RIGHT, new, new);
 
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock));
@@ -2091,6 +2126,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2160,6 +2199,10 @@ xfs_bmap_add_extent_delay_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 
 		if (xfs_bmap_needs_btree(bma->ip, XFS_DATA_FORK)) {
 			error = xfs_bmap_extents_to_btree(bma->tp, bma->ip,
@@ -2255,7 +2298,8 @@ xfs_bmap_add_extent_unwritten_real(
 	xfs_bmbt_irec_t		*new,	/* new data to add to file extents */
 	xfs_fsblock_t		*first,	/* pointer to firstblock variable */
 	xfs_bmap_free_t		*flist,	/* list of extents to be freed */
-	int			*logflagsp) /* inode logging flags */
+	int			*logflagsp, /* inode logging flags */
+	struct xfs_btree_cur	*rcur)/* rmap btree pointer */
 {
 	xfs_btree_cur_t		*cur;	/* btree cursor */
 	xfs_bmbt_rec_host_t	*ep;	/* extent entry for idx */
@@ -2401,6 +2445,10 @@ xfs_bmap_add_extent_unwritten_real(
 				RIGHT.br_blockcount, LEFT.br_state)))
 				goto done;
 		}
+		error = xfs_rmap_combine(rcur, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &RIGHT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_LEFT_CONTIG:
@@ -2438,6 +2486,10 @@ xfs_bmap_add_extent_unwritten_real(
 				LEFT.br_state)))
 				goto done;
 		}
+		error = xfs_rmap_lcombine(rcur, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, &PREV);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -2473,6 +2525,10 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
+		error = xfs_rmap_rcombine(rcur, ip->i_ino,
+				XFS_DATA_FORK, &RIGHT, &PREV, new);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_RIGHT_FILLING:
@@ -2546,6 +2602,14 @@ xfs_bmap_add_extent_unwritten_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(rcur, ip->i_ino,
+				XFS_DATA_FORK, &PREV, new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_resize(rcur, ip->i_ino,
+				XFS_DATA_FORK, &LEFT, -new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING:
@@ -2584,6 +2648,14 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_move(rcur, ip->i_ino,
+				XFS_DATA_FORK, &PREV, new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(rcur, ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_RIGHT_FILLING | BMAP_RIGHT_CONTIG:
@@ -2626,6 +2698,14 @@ xfs_bmap_add_extent_unwritten_real(
 				newext)))
 				goto done;
 		}
+		error = xfs_rmap_resize(rcur, ip->i_ino,
+				XFS_DATA_FORK, &PREV, -new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_move(rcur, ip->i_ino,
+				XFS_DATA_FORK, &RIGHT, -new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_RIGHT_FILLING:
@@ -2666,6 +2746,14 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_resize(rcur, ip->i_ino,
+				XFS_DATA_FORK, &PREV, -new->br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(rcur, ip->i_ino,
+				XFS_DATA_FORK, new);
+		if (error)
+			goto done;
 		break;
 
 	case 0:
@@ -2727,6 +2815,17 @@ xfs_bmap_add_extent_unwritten_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_resize(rcur, ip->i_ino, XFS_DATA_FORK, &PREV,
+				new->br_startoff - PREV.br_startoff -
+				PREV.br_blockcount);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(rcur, ip->i_ino, XFS_DATA_FORK, new);
+		if (error)
+			goto done;
+		error = xfs_rmap_insert(rcur, ip->i_ino, XFS_DATA_FORK, &r[1]);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_FILLING | BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
@@ -2930,6 +3029,7 @@ xfs_bmap_add_extent_hole_real(
 	int			rval=0;	/* return value (logging flags) */
 	int			state;	/* state bits, accessed thru macros */
 	struct xfs_mount	*mp;
+	struct xfs_bmbt_irec	prev;	/* fake previous extent entry */
 
 	mp = bma->tp ? bma->tp->t_mountp : NULL;
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
@@ -3037,6 +3137,12 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		prev = *new;
+		prev.br_startblock = nullstartblock(0);
+		error = xfs_rmap_combine(bma->rcur, bma->ip->i_ino,
+				whichfork, &left, &right, &prev);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_LEFT_CONTIG:
@@ -3069,6 +3175,10 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_resize(bma->rcur, bma->ip->i_ino,
+				whichfork, &left, new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case BMAP_RIGHT_CONTIG:
@@ -3103,6 +3213,10 @@ xfs_bmap_add_extent_hole_real(
 			if (error)
 				goto done;
 		}
+		error = xfs_rmap_move(bma->rcur, bma->ip->i_ino,
+				whichfork, &right, -new->br_blockcount);
+		if (error)
+			goto done;
 		break;
 
 	case 0:
@@ -3131,6 +3245,10 @@ xfs_bmap_add_extent_hole_real(
 				goto done;
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, done);
 		}
+		error = xfs_rmap_insert(bma->rcur, bma->ip->i_ino,
+				whichfork, new);
+		if (error)
+			goto done;
 		break;
 	}
 
@@ -3697,7 +3815,6 @@ xfs_bmap_btalloc(
 	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
-	args.owner = ap->ip->i_ino;
 	args.fsbno = ap->blkno;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
@@ -4261,6 +4378,59 @@ xfs_bmapi_delay(
 	return 0;
 }
 
+static int
+alloc_rcur(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_btree_cur	**pcur,
+	xfs_fsblock_t		fsblock)
+{
+	struct xfs_btree_cur	*cur = *pcur;
+	struct xfs_buf		*agbp;
+	int			error;
+	xfs_agnumber_t		agno;
+
+	agno = XFS_FSB_TO_AGNO(mp, fsblock);
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+	if (cur && cur->bc_private.a.agno == agno)
+		return 0;
+	if (isnullstartblock(fsblock))
+		return 0;
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+	if (!cur) {
+		xfs_trans_brelse(tp, agbp);
+		return -ENOMEM;
+	}
+
+	*pcur = cur;
+	return 0;
+}
+
+static void
+free_rcur(
+	struct xfs_btree_cur	**pcur,
+	int			bt_error)
+{
+	struct xfs_btree_cur	*cur = *pcur;
+	struct xfs_buf		*agbp;
+	struct xfs_trans	*tp;
+
+	if (cur == NULL)
+		return;
+
+	agbp = cur->bc_private.a.agbp;
+	tp = cur->bc_tp;
+	xfs_btree_del_cursor(cur, bt_error);
+	xfs_trans_brelse(tp, agbp);
+
+	*pcur = NULL;
+}
 
 static int
 xfs_bmapi_allocate(
@@ -4353,6 +4523,10 @@ xfs_bmapi_allocate(
 	    xfs_sb_version_hasextflgbit(&mp->m_sb))
 		bma->got.br_state = XFS_EXT_UNWRITTEN;
 
+	error = alloc_rcur(mp, bma->tp, &bma->rcur, bma->got.br_startblock);
+	if (error)
+		return error;
+
 	if (bma->wasdel)
 		error = xfs_bmap_add_extent_delay_real(bma);
 	else
@@ -4414,9 +4588,13 @@ xfs_bmapi_convert_unwritten(
 	mval->br_state = (mval->br_state == XFS_EXT_UNWRITTEN)
 				? XFS_EXT_NORM : XFS_EXT_UNWRITTEN;
 
+	error = alloc_rcur(bma->ip->i_mount, bma->tp, &bma->rcur, mval->br_startblock);
+	if (error)
+		return error;
+
 	error = xfs_bmap_add_extent_unwritten_real(bma->tp, bma->ip, &bma->idx,
 			&bma->cur, mval, bma->firstblock, bma->flist,
-			&tmp_logflags);
+			&tmp_logflags, bma->rcur);
 	/*
 	 * Log the inode core unconditionally in the unwritten extent conversion
 	 * path because the conversion might not have done so (e.g., if the
@@ -4618,6 +4796,7 @@ xfs_bmapi_write(
 	}
 	*nmap = n;
 
+	free_rcur(&bma.rcur, XFS_BTREE_NOERROR);
 	/*
 	 * Transform from btree to extents, give it cur.
 	 */
@@ -4637,6 +4816,7 @@ xfs_bmapi_write(
 		XFS_IFORK_MAXEXT(ip, whichfork));
 	error = 0;
 error0:
+	free_rcur(&bma.rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	/*
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
@@ -4689,7 +4869,8 @@ xfs_bmap_del_extent(
 	xfs_btree_cur_t		*cur,	/* if null, not a btree */
 	xfs_bmbt_irec_t		*del,	/* data to remove from extents */
 	int			*logflagsp, /* inode logging flags */
-	int			whichfork) /* data or attr fork */
+	int			whichfork, /* data or attr fork */
+	struct xfs_btree_cur	*rcur)	/* rmap btree */
 {
 	xfs_filblks_t		da_new;	/* new delay-alloc indirect blocks */
 	xfs_filblks_t		da_old;	/* old delay-alloc indirect blocks */
@@ -4787,6 +4968,7 @@ xfs_bmap_del_extent(
 		nblks = 0;
 		do_fx = 0;
 	}
+
 	/*
 	 * Set flag value to use in switch statement.
 	 * Left-contig is 2, right-contig is 1.
@@ -4806,6 +4988,9 @@ xfs_bmap_del_extent(
 		XFS_IFORK_NEXT_SET(ip, whichfork,
 			XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 		flags |= XFS_ILOG_CORE;
+		error = xfs_rmap_delete(rcur, ip->i_ino, whichfork, &got);
+		if (error)
+			goto done;
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -4833,6 +5018,10 @@ xfs_bmap_del_extent(
 		}
 		xfs_bmbt_set_startblock(ep, del_endblock);
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		error = xfs_rmap_move(rcur, ip->i_ino, whichfork,
+				&got, del->br_blockcount);
+		if (error)
+			goto done;
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -4859,6 +5048,10 @@ xfs_bmap_del_extent(
 			break;
 		}
 		trace_xfs_bmap_post_update(ip, *idx, state, _THIS_IP_);
+		error = xfs_rmap_resize(rcur, ip->i_ino, whichfork,
+				&got, -del->br_blockcount);
+		if (error)
+			goto done;
 		if (!cur) {
 			flags |= xfs_ilog_fext(whichfork);
 			break;
@@ -4884,6 +5077,15 @@ xfs_bmap_del_extent(
 		if (!delay) {
 			new.br_startblock = del_endblock;
 			flags |= XFS_ILOG_CORE;
+			error = xfs_rmap_resize(rcur, ip->i_ino,
+					whichfork, &got,
+					temp - got.br_blockcount);
+			if (error)
+				goto done;
+			error = xfs_rmap_insert(rcur, ip->i_ino,
+					whichfork, &new);
+			if (error)
+				goto done;
 			if (cur) {
 				if ((error = xfs_bmbt_update(cur,
 						got.br_startoff,
@@ -4973,7 +5175,7 @@ xfs_bmap_del_extent(
 	 */
 	if (do_fx)
 		xfs_bmap_add_free(mp, flist, del->br_startblock,
-			del->br_blockcount);
+			del->br_blockcount, NULL);
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
@@ -5036,6 +5238,7 @@ xfs_bunmapi(
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
 	xfs_fsblock_t		sum;
+	struct xfs_btree_cur	*rcur = NULL;	/* rmap btree */
 
 	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
 
@@ -5120,6 +5323,11 @@ xfs_bunmapi(
 			got.br_startoff + got.br_blockcount - 1);
 		if (bno < start)
 			break;
+
+		error = alloc_rcur(mp, tp, &rcur, got.br_startblock);
+		if (error)
+			goto error0;
+
 		/*
 		 * Then deal with the (possibly delayed) allocated space
 		 * we found.
@@ -5179,7 +5387,7 @@ xfs_bunmapi(
 			del.br_state = XFS_EXT_UNWRITTEN;
 			error = xfs_bmap_add_extent_unwritten_real(tp, ip,
 					&lastx, &cur, &del, firstblock, flist,
-					&logflags);
+					&logflags, rcur);
 			if (error)
 				goto error0;
 			goto nodelete;
@@ -5237,7 +5445,8 @@ xfs_bunmapi(
 				lastx--;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, &lastx, &cur, &prev,
-						firstblock, flist, &logflags);
+						firstblock, flist, &logflags,
+						rcur);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5246,7 +5455,8 @@ xfs_bunmapi(
 				del.br_state = XFS_EXT_UNWRITTEN;
 				error = xfs_bmap_add_extent_unwritten_real(tp,
 						ip, &lastx, &cur, &del,
-						firstblock, flist, &logflags);
+						firstblock, flist, &logflags,
+						rcur);
 				if (error)
 					goto error0;
 				goto nodelete;
@@ -5299,7 +5509,7 @@ xfs_bunmapi(
 			goto error0;
 		}
 		error = xfs_bmap_del_extent(ip, tp, &lastx, flist, cur, &del,
-				&tmp_logflags, whichfork);
+				&tmp_logflags, whichfork, rcur);
 		logflags |= tmp_logflags;
 		if (error)
 			goto error0;
@@ -5323,6 +5533,7 @@ nodelete:
 	}
 	*done = bno == (xfs_fileoff_t)-1 || bno < start || lastx < 0;
 
+	free_rcur(&rcur, XFS_BTREE_NOERROR);
 	/*
 	 * Convert to a btree if necessary.
 	 */
@@ -5350,6 +5561,7 @@ nodelete:
 	 */
 	error = 0;
 error0:
+	free_rcur(&rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	/*
 	 * Log everything.  Do this after conversion, there's no point in
 	 * logging the extent records if we've converted to btree format.
@@ -5422,7 +5634,8 @@ xfs_bmse_merge(
 	struct xfs_bmbt_rec_host	*gotp,		/* extent to shift */
 	struct xfs_bmbt_rec_host	*leftp,		/* preceding extent */
 	struct xfs_btree_cur		*cur,
-	int				*logflags)	/* output */
+	int				*logflags,	/* output */
+	struct xfs_btree_cur		*rcur)		/* rmap btree */
 {
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		left;
@@ -5453,6 +5666,13 @@ xfs_bmse_merge(
 	XFS_IFORK_NEXT_SET(ip, whichfork,
 			   XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
 	*logflags |= XFS_ILOG_CORE;
+	error = xfs_rmap_resize(rcur, ip->i_ino, whichfork, &left,
+			blockcount - left.br_blockcount);
+	if (error)
+		return error;
+	error = xfs_rmap_delete(rcur, ip->i_ino, whichfork, &got);
+	if (error)
+		return error;
 	if (!cur) {
 		*logflags |= XFS_ILOG_DEXT;
 		return 0;
@@ -5495,7 +5715,8 @@ xfs_bmse_shift_one(
 	struct xfs_bmbt_rec_host	*gotp,
 	struct xfs_btree_cur		*cur,
 	int				*logflags,
-	enum shift_direction		direction)
+	enum shift_direction		direction,
+	struct xfs_btree_cur		*rcur)
 {
 	struct xfs_ifork		*ifp;
 	struct xfs_mount		*mp;
@@ -5545,7 +5766,7 @@ xfs_bmse_shift_one(
 				       offset_shift_fsb)) {
 			return xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
 					      *current_ext, gotp, adj_irecp,
-					      cur, logflags);
+					      cur, logflags, rcur);
 		}
 	} else {
 		startoff = got.br_startoff + offset_shift_fsb;
@@ -5582,6 +5803,10 @@ update_current_ext:
 		(*current_ext)--;
 	xfs_bmbt_set_startoff(gotp, startoff);
 	*logflags |= XFS_ILOG_CORE;
+	error = xfs_rmap_slide(rcur, ip->i_ino, whichfork,
+			&got, startoff - got.br_startoff);
+	if (error)
+		return error;
 	if (!cur) {
 		*logflags |= XFS_ILOG_DEXT;
 		return 0;
@@ -5633,6 +5858,7 @@ xfs_bmap_shift_extents(
 	int				error = 0;
 	int				whichfork = XFS_DATA_FORK;
 	int				logflags = 0;
+	struct xfs_btree_cur		*rcur = NULL;
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -5721,9 +5947,14 @@ xfs_bmap_shift_extents(
 	}
 
 	while (nexts++ < num_exts) {
+		xfs_bmbt_get_all(gotp, &got);
+		error = alloc_rcur(mp, tp, &rcur, got.br_startblock);
+		if (error)
+			return error;
+
 		error = xfs_bmse_shift_one(ip, whichfork, offset_shift_fsb,
 					   &current_ext, gotp, cur, &logflags,
-					   direction);
+					   direction, rcur);
 		if (error)
 			goto del_cursor;
 		/*
@@ -5749,6 +5980,7 @@ xfs_bmap_shift_extents(
 	}
 
 del_cursor:
+	free_rcur(&rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	if (cur)
 		xfs_btree_del_cursor(cur,
 			error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
@@ -5785,6 +6017,7 @@ xfs_bmap_split_extent_at(
 	int				error = 0;
 	int				logflags = 0;
 	int				i = 0;
+	struct xfs_btree_cur		*rcur = NULL;
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -5879,6 +6112,18 @@ xfs_bmap_split_extent_at(
 		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, del_cursor);
 	}
 
+	/* update rmapbt */
+	error = alloc_rcur(mp, tp, &rcur, new.br_startblock);
+	if (error)
+		goto del_cursor;
+	error = xfs_rmap_resize(rcur, ip->i_ino, whichfork, &got, -gotblkcnt);
+	if (error)
+		goto del_cursor;
+	error = xfs_rmap_insert(rcur, ip->i_ino, whichfork, &new);
+	if (error)
+		goto del_cursor;
+	free_rcur(&rcur, XFS_BTREE_NOERROR);
+
 	/*
 	 * Convert to a btree if necessary.
 	 */
@@ -5892,6 +6137,8 @@ xfs_bmap_split_extent_at(
 	}
 
 del_cursor:
+	free_rcur(&rcur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
+
 	if (cur) {
 		cur->bc_private.b.allocated = 0;
 		xfs_btree_del_cursor(cur,
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index d3daf6d..da73d59 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -56,6 +56,7 @@ struct xfs_bmalloca {
 	bool			aeof;	/* allocated space at eof */
 	bool			conv;	/* overwriting unwritten extents */
 	int			flags;
+	struct xfs_btree_cur	*rcur;	/* rmap btree cursor */
 };
 
 /*
@@ -66,6 +67,7 @@ typedef struct xfs_bmap_free_item
 {
 	xfs_fsblock_t		xbfi_startblock;/* starting fs block number */
 	xfs_extlen_t		xbfi_blockcount;/* number of blocks in extent */
+	struct xfs_owner_info	xbfi_oinfo;	/* extent owner */
 	struct xfs_bmap_free_item *xbfi_next;	/* link to next entry */
 } xfs_bmap_free_item_t;
 
@@ -183,7 +185,8 @@ void	xfs_bmap_trace_exlist(struct xfs_inode *ip, xfs_extnum_t cnt,
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_inode *ip, int whichfork);
 void	xfs_bmap_add_free(struct xfs_mount *mp, struct xfs_bmap_free *flist,
-			  xfs_fsblock_t bno, xfs_filblks_t len);
+			  xfs_fsblock_t bno, xfs_filblks_t len,
+			  struct xfs_owner_info *oinfo);
 void	xfs_bmap_cancel(struct xfs_bmap_free *flist);
 int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
 			int *committed);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index c928abf..02ebbae 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -443,7 +443,8 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
-	args.owner = cur->bc_private.b.ip->i_ino;
+	XFS_RMAP_INO_BMBT_OWNER(&args.oinfo, cur->bc_private.b.ip->i_ino,
+			cur->bc_private.b.whichfork);
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
@@ -523,8 +524,10 @@ xfs_bmbt_free_block(
 	struct xfs_inode	*ip = cur->bc_private.b.ip;
 	struct xfs_trans	*tp = cur->bc_tp;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
 
-	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1);
+	XFS_RMAP_INO_BMBT_OWNER(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
+	xfs_bmap_add_free(mp, cur->bc_private.b.flist, fsbno, 1, &oinfo);
 	ip->i_d.di_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index afa9885..ead7f30 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1306,6 +1306,55 @@ typedef __be32 xfs_inobt_ptr_t;
 #define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
 
 /*
+ * Ownership info for an extent.  This is used to create reverse-mapping
+ * entries.
+ */
+#define XFS_RMAP_INO_ATTR_FORK	(1)
+#define XFS_RMAP_BMBT_BLOCK	(2)
+struct xfs_owner_info {
+	uint64_t		oi_owner;
+	xfs_fileoff_t		oi_offset;
+	unsigned int		oi_flags;
+};
+
+static inline void
+XFS_RMAP_AG_OWNER(
+	struct xfs_owner_info	*oi,
+	uint64_t		owner)
+{
+	oi->oi_owner = owner;
+	oi->oi_offset = 0;
+	oi->oi_flags = 0;
+}
+
+static inline void
+XFS_RMAP_INO_BMBT_OWNER(
+	struct xfs_owner_info	*oi,
+	xfs_ino_t		ino,
+	int			whichfork)
+{
+	oi->oi_owner = ino;
+	oi->oi_offset = 0;
+	oi->oi_flags = XFS_RMAP_BMBT_BLOCK;
+	if (whichfork == XFS_ATTR_FORK)
+		oi->oi_flags |= XFS_RMAP_INO_ATTR_FORK;
+}
+
+static inline void
+XFS_RMAP_INO_OWNER(
+	struct xfs_owner_info	*oi,
+	xfs_ino_t		ino,
+	int			whichfork,
+	xfs_fileoff_t		offset)
+{
+	oi->oi_owner = ino;
+	oi->oi_offset = offset;
+	oi->oi_flags = 0;
+	if (whichfork == XFS_ATTR_FORK)
+		oi->oi_flags |= XFS_RMAP_INO_ATTR_FORK;
+}
+
+/*
  * Special owner types.
  *
  * Seeing as we only support up to 8EB, we have the upper bit of the owner field
@@ -1321,6 +1370,8 @@ typedef __be32 xfs_inobt_ptr_t;
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
 #define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
 
+#define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
+
 /*
  * Data record structure
  */
@@ -1328,12 +1379,44 @@ struct xfs_rmap_rec {
 	__be32		rm_startblock;	/* extent start block */
 	__be32		rm_blockcount;	/* extent length */
 	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
 };
 
+/*
+ * rmap btree record
+ *  rm_blockcount:31 is the unwritten extent flag (same as l0:63 in bmbt)
+ *  rm_blockcount:0-30 are the extent length
+ *  rm_offset:63 is the attribute fork flag
+ *  rm_offset:62 is the bmbt block flag
+ *  rm_offset:0-61 is the block offset within the inode
+ */
+#define XFS_RMAP_OFF_ATTR	((__uint64_t)1ULL << 63)
+#define XFS_RMAP_OFF_BMBT	((__uint64_t)1ULL << 62)
+#define XFS_RMAP_LEN_UNWRITTEN	((xfs_extlen_t)1U << 31)
+
+#define XFS_RMAP_OFF_MASK	~(XFS_RMAP_OFF_ATTR | XFS_RMAP_OFF_BMBT)
+#define XFS_RMAP_LEN_MASK	~XFS_RMAP_LEN_UNWRITTEN
+
+#define XFS_RMAP_OFF(off)		((off) & XFS_RMAP_OFF_MASK)
+#define XFS_RMAP_LEN(len)		((len) & XFS_RMAP_LEN_MASK)
+
+#define XFS_RMAP_IS_BMBT(off)		(!!((off) & XFS_RMAP_OFF_BMBT))
+#define XFS_RMAP_IS_ATTR_FORK(off)	(!!((off) & XFS_RMAP_OFF_ATTR))
+#define XFS_RMAP_IS_UNWRITTEN(len)	(!!((len) & XFS_RMAP_LEN_UNWRITTEN))
+
+#define RMAPBT_STARTBLOCK_BITLEN	32
+#define RMAPBT_EXNTFLAG_BITLEN		1
+#define RMAPBT_BLOCKCOUNT_BITLEN	31
+#define RMAPBT_OWNER_BITLEN		64
+#define RMAPBT_ATTRFLAG_BITLEN		1
+#define RMAPBT_BMBTFLAG_BITLEN		1
+#define RMAPBT_OFFSET_BITLEN		62
+
 struct xfs_rmap_irec {
 	xfs_agblock_t	rm_startblock;	/* extent start block */
 	xfs_extlen_t	rm_blockcount;	/* extent length */
 	__uint64_t	rm_owner;	/* extent owner */
+	__uint64_t	rm_offset;	/* offset within the owner */
 };
 
 /*
@@ -1343,19 +1426,50 @@ struct xfs_rmap_irec {
  */
 struct xfs_rmap_key {
 	__be32		rm_startblock;	/* extent start block */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
 };
 
 /* btree pointer type */
 typedef __be32 xfs_rmap_ptr_t;
 
-/*
- * block numbers in the AG.
- */
 #define	XFS_RMAP_BLOCK(mp) \
 	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
+static inline void
+xfs_owner_info_unpack(
+	struct xfs_owner_info	*oinfo,
+	uint64_t		*owner,
+	uint64_t		*offset)
+{
+	__uint64_t		r;
+
+	*owner = oinfo->oi_owner;
+	r = oinfo->oi_offset;
+	if (oinfo->oi_flags & XFS_RMAP_INO_ATTR_FORK)
+		r |= XFS_RMAP_OFF_ATTR;
+	if (oinfo->oi_flags & XFS_RMAP_BMBT_BLOCK)
+		r |= XFS_RMAP_OFF_BMBT;
+	*offset = r;
+}
+
+static inline void
+xfs_owner_info_pack(
+	struct xfs_owner_info	*oinfo,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	oinfo->oi_owner = owner;
+	oinfo->oi_offset = XFS_RMAP_OFF(offset);
+	oinfo->oi_flags = 0;
+	if (XFS_RMAP_IS_ATTR_FORK(offset))
+		oinfo->oi_flags |= XFS_RMAP_INO_ATTR_FORK;
+	if (XFS_RMAP_IS_BMBT(offset))
+		oinfo->oi_flags |= XFS_RMAP_BMBT_BLOCK;
+}
+
 /*
  * BMAP Btree format definitions
  *
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index b22ec2f..2d78962 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -608,6 +608,7 @@ xfs_ialloc_ag_alloc(
 	args.tp = tp;
 	args.mp = tp->t_mountp;
 	args.fsbno = NULLFSBLOCK;
+	XFS_RMAP_AG_OWNER(&args.oinfo, XFS_RMAP_OWN_INODES);
 
 #ifdef DEBUG
 	/* randomly do sparse inode allocations */
@@ -615,7 +616,6 @@ xfs_ialloc_ag_alloc(
 	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks)
 		do_sparse = prandom_u32() & 1;
 #endif
-	args.owner = XFS_RMAP_OWN_INODES;
 
 	/*
 	 * Locking will ensure that we don't have two callers in here
@@ -1819,13 +1819,15 @@ xfs_difree_inode_chunk(
 	int		nextbit;
 	xfs_agblock_t	agbno;
 	int		contigblk;
+	struct xfs_owner_info	oinfo;
 	DECLARE_BITMAP(holemask, XFS_INOBT_HOLEMASK_BITS);
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_INODES);
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
 		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno,
 				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
-				  mp->m_ialloc_blks);
+				  mp->m_ialloc_blks, &oinfo);
 		return;
 	}
 
@@ -1869,7 +1871,7 @@ xfs_difree_inode_chunk(
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
 		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, agbno),
-				  contigblk);
+				  contigblk, &oinfo);
 
 		/* reset range to current bit and carry on... */
 		startidx = endidx = nextbit;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index ffeab1e..1d3b9e7 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -95,7 +95,7 @@ xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
-	args.owner = XFS_RMAP_OWN_INOBT;
+	XFS_RMAP_AG_OWNER(&args.oinfo, XFS_RMAP_OWN_INOBT);
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
@@ -127,9 +127,11 @@ xfs_inobt_free_block(
 {
 	xfs_fsblock_t		fsbno;
 	int			error;
+	struct xfs_owner_info	oinfo;
 
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_INOBT);
 	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1);
+	error = xfs_free_extent(cur->bc_tp, fsbno, 1, &oinfo);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index b2a3330..12aac59 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -34,28 +34,49 @@
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
 
-
 /*
- * Lookup the first record less than or equal to [bno, len]
+ * Lookup the first record less than or equal to [bno, len, owner, offset]
  * in the btree given by cur.
  */
-STATIC int
+int
 xfs_rmap_lookup_le(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	uint64_t		owner,
+	uint64_t		offset,
 	int			*stat)
 {
 	cur->bc_rec.r.rm_startblock = bno;
 	cur->bc_rec.r.rm_blockcount = len;
 	cur->bc_rec.r.rm_owner = owner;
+	cur->bc_rec.r.rm_offset = offset;
 	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
 }
 
 /*
+ * Lookup the record exactly matching [bno, len, owner, offset]
+ * in the btree given by cur.
+ */
+int
+xfs_rmap_lookup_eq(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset,
+	int			*stat)
+{
+	cur->bc_rec.r.rm_startblock = bno;
+	cur->bc_rec.r.rm_blockcount = len;
+	cur->bc_rec.r.rm_owner = owner;
+	cur->bc_rec.r.rm_offset = offset;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_EQ, stat);
+}
+
+/*
  * Update the record referred to by cur to the value given
- * by [bno, len, ref].
+ * by [bno, len, owner, offset].
  * This either works (return 0) or gets an EFSCORRUPTED error.
  */
 STATIC int
@@ -65,16 +86,79 @@ xfs_rmap_update(
 {
 	union xfs_btree_rec	rec;
 
+	trace_xfs_rmapbt_update(cur->bc_mp, cur->bc_private.a.agno,
+			irec->rm_startblock, irec->rm_blockcount,
+			irec->rm_owner, irec->rm_offset);
+
 	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
 	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
 	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
+	rec.rmap.rm_offset = cpu_to_be64(irec->rm_offset);
 	return xfs_btree_update(cur, &rec);
 }
 
+int
+xfs_rmapbt_insert(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	int			i;
+	int			error;
+
+	trace_xfs_rmapbt_insert(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+			len, owner, offset);
+
+	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 0, done);
+
+	rcur->bc_rec.r.rm_startblock = agbno;
+	rcur->bc_rec.r.rm_blockcount = len;
+	rcur->bc_rec.r.rm_owner = owner;
+	rcur->bc_rec.r.rm_offset = offset;
+	error = xfs_btree_insert(rcur, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+done:
+	return error;
+}
+
+STATIC int
+xfs_rmapbt_delete(
+	struct xfs_btree_cur	*rcur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	int			i;
+	int			error;
+
+	trace_xfs_rmapbt_delete(rcur->bc_mp, rcur->bc_private.a.agno, agbno,
+			len, owner, offset);
+
+	error = xfs_rmap_lookup_eq(rcur, agbno, len, owner, offset, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+
+	error = xfs_btree_delete(rcur, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+done:
+	return error;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
-STATIC int
+int
 xfs_rmap_get_rec(
 	struct xfs_btree_cur	*cur,
 	struct xfs_rmap_irec	*irec,
@@ -90,31 +174,27 @@ xfs_rmap_get_rec(
 	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
 	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
 	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
+	irec->rm_offset = be64_to_cpu(rec->rmap.rm_offset);
 	return 0;
 }
 
 /*
  * Find the extent in the rmap btree and remove it.
  *
- * The record we find should always span a range greater than or equal to the
- * the extent being freed. This makes the code simple as, in theory, we do not
- * have to handle ranges that are split across multiple records as extents that
- * result in bmap btree extent merges should also result in rmap btree extent
- * merges.  The owner field ensures we don't merge extents from different
- * structures into the same record, hence this property should always hold true
- * if we ensure that the rmap btree supports at least the same size maximum
- * extent as the bmap btree (2^21 blocks at present).
+ * The record we find should always be an exact match for the extent that we're
+ * looking for, since we insert them into the btree without modification.
  *
- * Complexity: when growing the filesystem, we "free" an extent when growing the
- * last AG. This extent is new space and so it is not tracked as used space in
- * the btree. The growfs code will pass in an owner of XFS_RMAP_OWN_NULL to
- * indicate that it expected that there is no owner of this extent. We verify
- * that - the extent lookup result in a record that does not overlap.
+ * Special Case #1: when growing the filesystem, we "free" an extent when
+ * growing the last AG. This extent is new space and so it is not tracked as
+ * used space in the btree. The growfs code will pass in an owner of
+ * XFS_RMAP_OWN_NULL to indicate that it expected that there is no owner of this
+ * extent. We verify that - the extent lookup result in a record that does not
+ * overlap.
  *
- * Complexity #2: EFIs do not record the owner of the extent, so when recovering
- * EFIs from the log we pass in XFS_RMAP_OWN_UNKNOWN to tell the rmap btree to
- * ignore the owner (i.e. wildcard match) so we don't trigger corruption checks
- * during log recovery.
+ * Special Case #2: EFIs do not record the owner of the extent, so when
+ * recovering EFIs from the log we pass in XFS_RMAP_OWN_UNKNOWN to tell the rmap
+ * btree to ignore the owner (i.e. wildcard match) so we don't trigger
+ * corruption checks during log recovery.
  */
 int
 xfs_rmap_free(
@@ -123,29 +203,32 @@ xfs_rmap_free(
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	uint64_t		owner)
+	struct xfs_owner_info	*oinfo)
 {
-	struct xfs_btree_cur	*cur;
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_btree_cur	*cur;
 	struct xfs_rmap_irec	ltrec;
-	int			error;
+	uint64_t		ltoff;
+	int			error = 0;
 	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
 
-	/*
-	 * if rmap btree is not supported, then just return success without
-	 * doing anything.
-	 */
-	if (!xfs_sb_version_hasrmapbt(&tp->t_mountp->m_sb))
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	trace_xfs_rmap_free_extent(mp, agno, bno, len, owner);
+	trace_xfs_rmap_free_extent(mp, agno, bno, len, oinfo);
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
 
+	xfs_owner_info_unpack(oinfo, &owner, &offset);
+	ASSERT(XFS_RMAP_NON_INODE_OWNER(owner) || XFS_RMAP_IS_BMBT(offset));
+	ltoff = ltrec.rm_offset & ~XFS_RMAP_OFF_BMBT;
 	/*
-	 * We always have a left record because there's a static record
-	 * for the AG headers at rm_startblock == 0.
+	 * We should always have a left record because there's a static record
+	 * for the AG headers at rm_startblock == 0 created by mkfs/growfs that
+	 * will not ever be removed from the tree.
 	 */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, &i);
 	if (error)
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
@@ -155,17 +238,18 @@ xfs_rmap_free(
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
 
-	/* special growfs case - bno is beyond last record */
+	/*
+	 * For growfs, the incoming extent must be beyond the left record we
+	 * just found as it is new space and won't be used by anyone. This is
+	 * just a corruption check as we don't actually do anything with this
+	 * extent.
+	 */
 	if (owner == XFS_RMAP_OWN_NULL) {
 		XFS_WANT_CORRUPTED_GOTO(mp, bno > ltrec.rm_startblock +
 						ltrec.rm_blockcount, out_error);
 		goto out_done;
 	}
 
-	/* make sure the extent we found covers the entire freeing range. */
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno, out_error);
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_blockcount >= len, out_error);
-
 /*
 	if (owner != ltrec.rm_owner ||
 	    bno > ltrec.rm_startblock + ltrec.rm_blockcount)
@@ -173,16 +257,36 @@ xfs_rmap_free(
 	//printk("rmfree  ag %d bno 0x%x/0x%x/0x%llx, ltrec 0x%x/0x%x/0x%llx\n",
 	//		agno, bno, len, owner, ltrec.rm_startblock,
 	//		ltrec.rm_blockcount, ltrec.rm_owner);
-	XFS_WANT_CORRUPTED_GOTO(mp, bno <= ltrec.rm_startblock + ltrec.rm_blockcount,
-				out_error);
+
+	/* make sure the extent we found covers the entire freeing range. */
+	XFS_WANT_CORRUPTED_GOTO(mp, !XFS_RMAP_IS_UNWRITTEN(ltrec.rm_blockcount),
+		out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno &&
+		ltrec.rm_startblock + XFS_RMAP_LEN(ltrec.rm_blockcount) >=
+		bno + len, out_error);
+
+	/* make sure the owner matches what we expect to find in the tree */
 	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
-				(owner < XFS_RMAP_OWN_NULL &&
-				 owner >= XFS_RMAP_OWN_MIN), out_error);
+				    XFS_RMAP_NON_INODE_OWNER(owner), out_error);
+
+	/* check the offset, if necessary */
+	if (!XFS_RMAP_NON_INODE_OWNER(owner)) {
+		if (XFS_RMAP_IS_BMBT(offset)) {
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					XFS_RMAP_IS_BMBT(ltrec.rm_offset),
+					out_error);
+		} else {
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					ltrec.rm_offset <= offset, out_error);
+			XFS_WANT_CORRUPTED_GOTO(mp,
+					offset <= ltoff + ltrec.rm_blockcount,
+					out_error);
+		}
+	}
 
-	/* exact match is easy */
 	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
 	//printk("remove exact\n");
-		/* remove extent from rmap tree */
+		/* exact match, simply remove the record from rmap tree */
 		error = xfs_btree_delete(cur, &i);
 		if (error)
 			goto out_error;
@@ -190,7 +294,8 @@ xfs_rmap_free(
 	} else if (ltrec.rm_startblock == bno) {
 	//printk("remove left\n");
 		/*
-		 * overlap left hand side of extent
+		 * overlap left hand side of extent: move the start, trim the
+		 * length and update the current record.
 		 *
 		 *       ltbno                ltlen
 		 * Orig:    |oooooooooooooooooooo|
@@ -206,7 +311,8 @@ xfs_rmap_free(
 	} else if (ltrec.rm_startblock + ltrec.rm_blockcount == bno + len) {
 	//printk("remove right\n");
 		/*
-		 * overlap right hand side of extent
+		 * overlap right hand side of extent: trim the length and update
+		 * the current record.
 		 *
 		 *       ltbno                ltlen
 		 * Orig:    |oooooooooooooooooooo|
@@ -219,8 +325,12 @@ xfs_rmap_free(
 		if (error)
 			goto out_error;
 	} else {
+
 		/*
-		 * overlap middle of extent
+		 * overlap middle of extent: trim the length of the existing
+		 * record to the length of the new left-extent size, increment
+		 * the insertion position so we can insert a new record
+		 * containing the remaining right-extent space.
 		 *
 		 *       ltbno                ltlen
 		 * Orig:    |oooooooooooooooooooo|
@@ -231,7 +341,7 @@ xfs_rmap_free(
 		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
 	//printk("remove middle\n");
 
-		ltrec.rm_blockcount = bno - ltrec.rm_startblock;;
+		ltrec.rm_blockcount = bno - ltrec.rm_startblock;
 		error = xfs_rmap_update(cur, &ltrec);
 		if (error)
 			goto out_error;
@@ -244,33 +354,52 @@ xfs_rmap_free(
 		cur->bc_rec.r.rm_blockcount = orig_len - len -
 						     ltrec.rm_blockcount;
 		cur->bc_rec.r.rm_owner = ltrec.rm_owner;
+		cur->bc_rec.r.rm_offset = offset;
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
 	}
 
 out_done:
-	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, owner);
+	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, oinfo);
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
 out_error:
-	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, owner);
+	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, oinfo);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
 
 /*
- * When we allocate a new block, the first thing we do is add a reference to the
- * extent in the rmap btree. This is how we track the owner of the extent and th
- * enumber of references to it.
- *
- * Initially, we do not have shared extents, and so the extent can only have a
- * single reference count and owner. This makes the initial implementation easy,
- * but does not allow us to use the rmap tree for tracking reflink shared files.
- * Hence the initial implementation is simply a lookup to find the place to
- * insert (and checking we don't find a duplicate/overlap) and then insertng the
- * appropriate record.
+ * A mergeable rmap should have the same owner, cannot be unwritten, and
+ * must be a bmbt rmap if we're asking about a bmbt rmap.
+ */
+static bool
+is_mergeable_rmap(
+	struct xfs_rmap_irec	*irec,
+	uint64_t		owner,
+	uint64_t		offset)
+{
+	if (irec->rm_owner == XFS_RMAP_OWN_NULL)
+		return false;
+	if (irec->rm_owner != owner)
+		return false;
+	if (XFS_RMAP_IS_UNWRITTEN(irec->rm_blockcount))
+		return false;
+	if (XFS_RMAP_IS_ATTR_FORK(offset) ^
+	    XFS_RMAP_IS_ATTR_FORK(irec->rm_offset))
+		return false;
+	if (XFS_RMAP_IS_BMBT(offset) ^ XFS_RMAP_IS_BMBT(irec->rm_offset))
+		return false;
+	return true;
+}
+
+/*
+ * When we allocate a new block, the first thing we do is add a reference to
+ * the extent in the rmap btree. This takes the form of a [agbno, length,
+ * owner, offset] record.  Flags are encoded in the high bits of the offset
+ * field.
  */
 int
 xfs_rmap_alloc(
@@ -279,31 +408,32 @@ xfs_rmap_alloc(
 	xfs_agnumber_t		agno,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	uint64_t		owner)
+	struct xfs_owner_info	*oinfo)
 {
-	struct xfs_btree_cur	*cur;
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_btree_cur	*cur;
 	struct xfs_rmap_irec	ltrec;
 	struct xfs_rmap_irec	gtrec;
 	int			have_gt;
-	int			error;
+	int			error = 0;
 	int			i;
+	uint64_t		owner;
+	uint64_t		offset;
 
-	/*
-	 * if rmap btree is not supported, then just return success without
-	 * doing anything.
-	 */
-	if (!xfs_sb_version_hasrmapbt(&tp->t_mountp->m_sb))
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return 0;
 
-	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, owner);
+	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, oinfo);
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
 
+	xfs_owner_info_unpack(oinfo, &owner, &offset);
+	ASSERT(XFS_RMAP_NON_INODE_OWNER(owner) || XFS_RMAP_IS_BMBT(offset));
 	/*
-	 * chekc to see if we find an existing record for this extent rather
-	 * than just the location for insert.
+	 * For the initial lookup, look for and exact match or the left-adjacent
+	 * record for our insertion point. This will also give us the record for
+	 * start block contiguity tests.
 	 */
-	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, offset, &i);
 	if (error)
 		goto out_error;
 	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
@@ -315,10 +445,18 @@ xfs_rmap_alloc(
 	//printk("rmalloc ag %d bno 0x%x/0x%x/0x%llx, ltrec 0x%x/0x%x/0x%llx\n",
 	//		agno, bno, len, owner, ltrec.rm_startblock,
 	//		ltrec.rm_blockcount, ltrec.rm_owner);
+	if (!is_mergeable_rmap(&ltrec, owner, offset))
+		ltrec.rm_owner = XFS_RMAP_OWN_NULL;
 
-	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock + ltrec.rm_blockcount <= bno,
-				out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp,
+		ltrec.rm_owner == XFS_RMAP_OWN_NULL ||
+		ltrec.rm_startblock + ltrec.rm_blockcount <= bno, out_error);
 
+	/*
+	 * Increment the cursor to see if we have a right-adjacent record to our
+	 * insertion point. This will give us the record for end block
+	 * contiguity tests.
+	 */
 	error = xfs_btree_increment(cur, 0, &have_gt);
 	if (error)
 		goto out_error;
@@ -335,12 +473,17 @@ xfs_rmap_alloc(
 	} else {
 		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
 	}
+	if (!is_mergeable_rmap(&gtrec, owner, offset))
+		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
 
-	/* cursor currently points one record past ltrec */
+	/*
+	 * Note: cursor currently points one record to the right of ltrec, even
+	 * if there is no record in the tree to the right.
+	 */
 	if (ltrec.rm_owner == owner &&
 	    ltrec.rm_startblock + ltrec.rm_blockcount == bno) {
 		/*
-		 * left edge contiguous
+		 * left edge contiguous, merge into left record.
 		 *
 		 *       ltbno     ltlen
 		 * orig:   |ooooooooo|
@@ -354,7 +497,8 @@ xfs_rmap_alloc(
 		    bno + len == gtrec.rm_startblock) {
 			//printk("add middle\n");
 			/*
-			 * right edge also contiguous
+			 * right edge also contiguous, delete right record
+			 * and merge into left record.
 			 *
 			 *       ltbno     ltlen    gtbno     gtlen
 			 * orig:   |ooooooooo|         |ooooooooo|
@@ -368,6 +512,7 @@ xfs_rmap_alloc(
 			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
 		}
 
+		/* point the cursor back to the left record and update */
 		error = xfs_btree_decrement(cur, 0, &have_gt);
 		if (error)
 			goto out_error;
@@ -377,7 +522,7 @@ xfs_rmap_alloc(
 	} else if (gtrec.rm_owner == owner &&
 		   bno + len == gtrec.rm_startblock) {
 		/*
-		 * right edge contiguous
+		 * right edge contiguous, merge into right record.
 		 *
 		 *                 gtbno     gtlen
 		 * Orig:             |ooooooooo|
@@ -393,21 +538,322 @@ xfs_rmap_alloc(
 			goto out_error;
 	} else {
 		//printk("add no match\n");
-		/* no contiguous edge with identical owner */
+		/*
+		 * no contiguous edge with identical owner, insert
+		 * new record at current cursor position.
+		 */
 		cur->bc_rec.r.rm_startblock = bno;
 		cur->bc_rec.r.rm_blockcount = len;
 		cur->bc_rec.r.rm_owner = owner;
+		cur->bc_rec.r.rm_offset = offset;
 		error = xfs_btree_insert(cur, &i);
 		if (error)
 			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
 	}
 
-	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, owner);
+	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, oinfo);
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	return 0;
 
 out_error:
-	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, owner);
+	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, oinfo);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 	return error;
 }
+
+/* Encode logical offset for a rmapbt record */
+STATIC uint64_t
+b2r_off(
+	int		whichfork,
+	xfs_fileoff_t	off)
+{
+	uint64_t	x;
+
+	x = off;
+	if (whichfork == XFS_ATTR_FORK)
+		x |= XFS_RMAP_OFF_ATTR;
+	return x;
+}
+
+/* Encode blockcount for a rmapbt record */
+STATIC xfs_extlen_t
+b2r_len(
+	struct xfs_bmbt_irec	*irec)
+{
+	xfs_extlen_t		x;
+
+	x = irec->br_blockcount;
+	if (irec->br_state == XFS_EXT_UNWRITTEN)
+		x |= XFS_RMAP_LEN_UNWRITTEN;
+	return x;
+}
+
+/* Combine two adjacent rmap extents */
+int
+xfs_rmap_combine(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*LEFT,
+	struct xfs_bmbt_irec	*RIGHT,
+	struct xfs_bmbt_irec	*PREV)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_combine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, LEFT, PREV, RIGHT);
+
+	/* Delete right rmap */
+	error = xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, RIGHT->br_startblock),
+			b2r_len(RIGHT), ino,
+			b2r_off(whichfork, RIGHT->br_startoff));
+	if (error)
+		goto done;
+
+	/* Delete prev rmap */
+	if (!isnullstartblock(PREV->br_startblock)) {
+		error = xfs_rmapbt_delete(rcur,
+				XFS_FSB_TO_AGBNO(rcur->bc_mp,
+						PREV->br_startblock),
+				b2r_len(PREV), ino,
+				b2r_off(whichfork, PREV->br_startoff));
+		if (error)
+			goto done;
+	}
+
+	/* Enlarge left rmap */
+	return xfs_rmap_resize(rcur, ino, whichfork, LEFT,
+			PREV->br_blockcount + RIGHT->br_blockcount);
+done:
+	return error;
+}
+
+/* Extend a left rmap extent */
+int
+xfs_rmap_lcombine(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*LEFT,
+	struct xfs_bmbt_irec	*PREV)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_lcombine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, LEFT, PREV);
+
+	/* Delete prev rmap */
+	if (!isnullstartblock(PREV->br_startblock)) {
+		error = xfs_rmapbt_delete(rcur,
+				XFS_FSB_TO_AGBNO(rcur->bc_mp,
+						PREV->br_startblock),
+				b2r_len(PREV), ino,
+				b2r_off(whichfork, PREV->br_startoff));
+		if (error)
+			goto done;
+	}
+
+	/* Enlarge left rmap */
+	return xfs_rmap_resize(rcur, ino, whichfork, LEFT, PREV->br_blockcount);
+done:
+	return error;
+}
+
+/* Extend a right rmap extent */
+int
+xfs_rmap_rcombine(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*RIGHT,
+	struct xfs_bmbt_irec	*PREV,
+	struct xfs_bmbt_irec	*new)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+	ASSERT(PREV->br_startoff == new->br_startoff);
+
+	trace_xfs_rmap_rcombine(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, RIGHT, PREV);
+
+	/* Delete prev rmap */
+	if (!isnullstartblock(PREV->br_startblock)) {
+		error = xfs_rmapbt_delete(rcur,
+				XFS_FSB_TO_AGBNO(rcur->bc_mp,
+						PREV->br_startblock),
+				b2r_len(PREV), ino,
+				b2r_off(whichfork, PREV->br_startoff));
+		if (error)
+			goto done;
+	}
+
+	/* Enlarge right rmap */
+	return xfs_rmap_resize(rcur, ino, whichfork, RIGHT,
+			-PREV->br_blockcount);
+done:
+	return error;
+}
+
+/* Insert a rmap extent */
+int
+xfs_rmap_insert(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*new)
+{
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_insert(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, new);
+
+	return xfs_rmapbt_insert(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, new->br_startblock),
+			b2r_len(new), ino,
+			b2r_off(whichfork, new->br_startoff));
+}
+
+/* Delete a rmap extent */
+int
+xfs_rmap_delete(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*new)
+{
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_delete(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, new);
+
+	return xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, new->br_startblock),
+			b2r_len(new), ino,
+			b2r_off(whichfork, new->br_startoff));
+}
+
+/* Change the start of an rmap */
+int
+xfs_rmap_move(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			start_adj)
+{
+	int			error;
+	struct xfs_bmbt_irec	irec;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_move(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, PREV, start_adj);
+
+	/* Delete prev rmap */
+	error = xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff));
+	if (error)
+		goto done;
+
+	/* Re-add rmap with new start */
+	irec = *PREV;
+	irec.br_startblock += start_adj;
+	irec.br_startoff += start_adj;
+	irec.br_blockcount -= start_adj;
+	return xfs_rmapbt_insert(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, irec.br_startblock),
+			b2r_len(&irec), ino,
+			b2r_off(whichfork, irec.br_startoff));
+done:
+	return error;
+}
+
+/* Change the logical offset of an rmap */
+int
+xfs_rmap_slide(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			start_adj)
+{
+	int			error;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_slide(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, PREV, start_adj);
+
+	/* Delete prev rmap */
+	error = xfs_rmapbt_delete(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff));
+	if (error)
+		goto done;
+
+	/* Re-add rmap with new logical offset */
+	return xfs_rmapbt_insert(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff + start_adj));
+done:
+	return error;
+}
+
+/* Change the size of an rmap */
+int
+xfs_rmap_resize(
+	struct xfs_btree_cur	*rcur,
+	xfs_ino_t		ino,
+	int			whichfork,
+	struct xfs_bmbt_irec	*PREV,
+	long			size_adj)
+{
+	int			i;
+	int			error;
+	struct xfs_bmbt_irec	irec;
+	struct xfs_rmap_irec	rrec;
+
+	if (!rcur)
+		return 0;
+
+	trace_xfs_rmap_resize(rcur->bc_mp, rcur->bc_private.a.agno, ino,
+			whichfork, PREV, size_adj);
+
+	error = xfs_rmap_lookup_eq(rcur,
+			XFS_FSB_TO_AGBNO(rcur->bc_mp, PREV->br_startblock),
+			b2r_len(PREV), ino,
+			b2r_off(whichfork, PREV->br_startoff), &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+	error = xfs_rmap_get_rec(rcur, &rrec, &i);
+	if (error)
+		goto done;
+	XFS_WANT_CORRUPTED_GOTO(rcur->bc_mp, i == 1, done);
+	irec = *PREV;
+	irec.br_blockcount += size_adj;
+	rrec.rm_blockcount = b2r_len(&irec);
+	error = xfs_rmap_update(rcur, &rrec);
+	if (error)
+		goto done;
+done:
+	return error;
+}
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ed1792d..c02a46f 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -36,37 +36,29 @@
 /*
  * Reverse map btree.
  *
- * This is a per-ag tree used to track the owner of a given extent. Owner
- * records are inserted when an extent is allocated, and removed when an extent
- * is freed. For existing filesystems, there can only be one owner of an extent,
- * usually an inode or some other metadata structure like a AG btree.
- *
- * Initial thoughts are that the
- * value of the owner field needs external flags to define what it means, and
- * hence we need a flags field in the record. This means the record is going to
- * be larger than 16 bytes (agbno,len,owner = 16 bytes), so maybe this isn't the
- * best idea. Initially just implement the owner field - we can probably steal
- * bits from the extent length field for type descriptors given that MAXEXTLEN
- * is only 21 bits if we want to store the type as well. Keep in mind that if we
- * want to do this there are still restrictions on the length of extents we
- * track in the rmap btree (see comments on xfs_rmap_free()).
+ * This is a per-ag tree used to track the owner(s) of a given extent. With
+ * reflink it is possible for there to be multiple owners, which is a departure
+ * from classic XFS. Owner records for data extents are inserted when the
+ * extent is mapped and removed when an extent is unmapped.  Owner records for
+ * all other block types (i.e. metadata) are inserted when an extent is
+ * allocated and removed when an extent is freed. There can only be one owner
+ * of a metadata extent, usually an inode or some other metadata structure like
+ * an AG btree.
  *
  * The rmap btree is part of the free space management, so blocks for the tree
  * are sourced from the agfl. Hence we need transaction reservation support for
  * this tree so that the freelist is always large enough. This also impacts on
  * the minimum space we need to leave free in the AG.
  *
- * The tree is ordered by block number - there's no need to order/search by
- * extent size for  online updating/management of the tree, and the reverse
- * lookups are going to be "who owns this block" and so are by-block ordering is
- * perfect for this.
- *
- * XXX: open question is how to handle blocks that are owned by the freespace
- * tree blocks. Right now they will be classified when they are moved to the
- * freelist or removed from the freelist. i.e. the extent allocation/freeing
- * will mark the extents allocated as owned by the AG.
+ * The tree is ordered by [ag block, owner, offset]. This is a large key size,
+ * but it is the only way to enforce unique keys when a block can be owned by
+ * multiple files at any offset. There's no need to order/search by extent
+ * size for online updating/management of the tree. It is intended that most
+ * reverse lookups will be to find the owner(s) of a particular block, or to
+ * try to recover tree and file data from corrupt primary metadata.
  */
-STATIC struct xfs_btree_cur *
+
+static struct xfs_btree_cur *
 xfs_rmapbt_dup_cursor(
 	struct xfs_btree_cur	*cur)
 {
@@ -177,6 +169,8 @@ xfs_rmapbt_init_key_from_rec(
 	union xfs_btree_rec	*rec)
 {
 	key->rmap.rm_startblock = rec->rmap.rm_startblock;
+	key->rmap.rm_owner = rec->rmap.rm_owner;
+	key->rmap.rm_offset = rec->rmap.rm_offset;
 }
 
 STATIC void
@@ -185,6 +179,8 @@ xfs_rmapbt_init_rec_from_key(
 	union xfs_btree_rec	*rec)
 {
 	rec->rmap.rm_startblock = key->rmap.rm_startblock;
+	rec->rmap.rm_owner = key->rmap.rm_owner;
+	rec->rmap.rm_offset = key->rmap.rm_offset;
 }
 
 STATIC void
@@ -195,6 +191,7 @@ xfs_rmapbt_init_rec_from_cur(
 	rec->rmap.rm_startblock = cpu_to_be32(cur->bc_rec.r.rm_startblock);
 	rec->rmap.rm_blockcount = cpu_to_be32(cur->bc_rec.r.rm_blockcount);
 	rec->rmap.rm_owner = cpu_to_be64(cur->bc_rec.r.rm_owner);
+	rec->rmap.rm_offset = cpu_to_be64(cur->bc_rec.r.rm_offset);
 }
 
 STATIC void
@@ -217,8 +214,16 @@ xfs_rmapbt_key_diff(
 {
 	struct xfs_rmap_irec	*rec = &cur->bc_rec.r;
 	struct xfs_rmap_key	*kp = &key->rmap;
-
-	return (__int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
+	__int64_t		d;
+
+	d = (__int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
+	if (d)
+		return d;
+	d = (__int64_t)be64_to_cpu(kp->rm_owner) - rec->rm_owner;
+	if (d)
+		return d;
+	d = (__int64_t)be64_to_cpu(kp->rm_offset) - rec->rm_offset;
+	return d;
 }
 
 static bool
@@ -242,7 +247,7 @@ xfs_rmapbt_verify(
 	 * from the on disk AGF. Again, we can only check against maximum limits
 	 * in this case.
 	 */
-	if (block->bb_magic!= cpu_to_be32(XFS_RMAP_CRC_MAGIC))
+	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
 		return false;
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
@@ -312,7 +317,6 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write = xfs_rmapbt_write_verify,
 };
 
-
 #if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_rmapbt_keys_inorder(
@@ -320,8 +324,16 @@ xfs_rmapbt_keys_inorder(
 	union xfs_btree_key	*k1,
 	union xfs_btree_key	*k2)
 {
-	return be32_to_cpu(k1->rmap.rm_startblock) <
-	       be32_to_cpu(k2->rmap.rm_startblock);
+	if (be32_to_cpu(k1->rmap.rm_startblock) <
+	    be32_to_cpu(k2->rmap.rm_startblock))
+		return 1;
+	if (be64_to_cpu(k1->rmap.rm_owner) <
+	    be64_to_cpu(k2->rmap.rm_owner))
+		return 1;
+	if (be64_to_cpu(k1->rmap.rm_offset) <=
+	    be64_to_cpu(k2->rmap.rm_offset))
+		return 1;
+	return 0;
 }
 
 STATIC int
@@ -330,9 +342,16 @@ xfs_rmapbt_recs_inorder(
 	union xfs_btree_rec	*r1,
 	union xfs_btree_rec	*r2)
 {
-	return be32_to_cpu(r1->rmap.rm_startblock) +
-		be32_to_cpu(r1->rmap.rm_blockcount) <=
-		be32_to_cpu(r2->rmap.rm_startblock);
+	if (be32_to_cpu(r1->rmap.rm_startblock) <
+	    be32_to_cpu(r2->rmap.rm_startblock))
+		return 1;
+	if (be64_to_cpu(r1->rmap.rm_offset) <
+	    be64_to_cpu(r2->rmap.rm_offset))
+		return 1;
+	if (be64_to_cpu(r1->rmap.rm_owner) <=
+	    be64_to_cpu(r2->rmap.rm_owner))
+		return 1;
+	return 0;
 }
 #endif	/* DEBUG */
 
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 9ad65e5..0131d9a 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -18,10 +18,6 @@
 #ifndef __XFS_RMAP_BTREE_H__
 #define	__XFS_RMAP_BTREE_H__
 
-/*
- * Freespace on-disk structures
- */
-
 struct xfs_buf;
 struct xfs_btree_cur;
 struct xfs_mount;
@@ -55,11 +51,41 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				xfs_agnumber_t agno);
 int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
 
+int xfs_rmap_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t	bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset, int *stat);
+int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t	bno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset, int *stat);
+int xfs_rmapbt_insert(struct xfs_btree_cur *rcur, xfs_agblock_t	agbno,
+		xfs_extlen_t len, uint64_t owner, uint64_t offset);
+int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
+		int *stat);
+
+/* functions for updating the rmapbt for bmbt blocks and AG btree blocks */
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
-		   uint64_t owner);
+		   struct xfs_owner_info *oinfo);
 int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
-		  uint64_t owner);
+		  struct xfs_owner_info *oinfo);
+
+/* functions for updating the rmapbt based on bmbt map/unmap operations */
+int xfs_rmap_combine(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *LEFT, struct xfs_bmbt_irec *RIGHT,
+		struct xfs_bmbt_irec *PREV);
+int xfs_rmap_lcombine(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *LEFT, struct xfs_bmbt_irec *PREV);
+int xfs_rmap_rcombine(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *RIGHT, struct xfs_bmbt_irec *PREV,
+		struct xfs_bmbt_irec *new);
+int xfs_rmap_insert(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *new);
+int xfs_rmap_delete(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *new);
+int xfs_rmap_move(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *PREV, long start_adj);
+int xfs_rmap_slide(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *PREV, long start_adj);
+int xfs_rmap_resize(struct xfs_btree_cur *rcur, xfs_ino_t ino, int whichfork,
+		struct xfs_bmbt_irec *PREV, long size_adj);
 
 #endif	/* __XFS_RMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
