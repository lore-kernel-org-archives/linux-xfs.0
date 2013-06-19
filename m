Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DBDB4800B
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 00:37:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D78788F8033
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 22:37:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	imBtEkmEx8VznKL2 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 22:37:06 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpB4o-0003Co-TG
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpB4o-0000Gm-Pc
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 15:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 42/50] xfs: create xfs_bmap_util.[ch]
Date: Wed, 19 Jun 2013 15:36:05 +1000
Message-Id: <1371620173-712-43-git-send-email-david@fromorbit.com>
In-Reply-To: <1371620173-712-1-git-send-email-david@fromorbit.com>
References: <1371620173-712-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There is a bunch of code in xfs_bmap.c that is kernel specific and
not shared with userspace. to minimise the difference between the
kernel and userspace code, shift this unshared code to
xfs_bmap_util.c, and the declarations to xfs_bmap_util.h.

The biggest issue here is xfs_bmap_finish() - userspce has it's own
definition of this function, and so we need to move it out of
xfs_bmap.[ch]. This means several other files need to include
xfs_bmap_util.c as well.

It also introduces and interesting dance for the stack switching
code in xfs_bmapi_allocate(). The stack switching/workqueue code is
actually moved to xfs_bmap_util.c, so that userspace can simply use
a #define in a header file to connect the dots without needing to
know about the stack switch code at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/xfs_bmap.h |   50 ------------
 libxfs/xfs.h       |   34 ++++++++
 libxfs/xfs_bmap.c  |  222 +++-------------------------------------------------
 3 files changed, 43 insertions(+), 263 deletions(-)

diff --git a/include/xfs_bmap.h b/include/xfs_bmap.h
index a2e50c6..a64d6f7 100644
--- a/include/xfs_bmap.h
+++ b/include/xfs_bmap.h
@@ -107,43 +107,6 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
 }
 
 /*
- * Argument structure for xfs_bmap_alloc.
- */
-typedef struct xfs_bmalloca {
-	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
-	struct xfs_bmap_free	*flist;	/* bmap freelist */
-	struct xfs_trans	*tp;	/* transaction pointer */
-	struct xfs_inode	*ip;	/* incore inode pointer */
-	struct xfs_bmbt_irec	prev;	/* extent before the new one */
-	struct xfs_bmbt_irec	got;	/* extent after, or delayed */
-
-	xfs_fileoff_t		offset;	/* offset in file filling in */
-	xfs_extlen_t		length;	/* i/o length asked/allocated */
-	xfs_fsblock_t		blkno;	/* starting block of new extent */
-
-	struct xfs_btree_cur	*cur;	/* btree cursor */
-	xfs_extnum_t		idx;	/* current extent index */
-	int			nallocs;/* number of extents alloc'd */
-	int			logflags;/* flags for transaction logging */
-
-	xfs_extlen_t		total;	/* total blocks needed for xaction */
-	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
-	xfs_extlen_t		minleft; /* amount must be left after alloc */
-	char			eof;	/* set if allocating past last extent */
-	char			wasdel;	/* replacing a delayed allocation */
-	char			userdata;/* set if is user data */
-	char			aeof;	/* allocated space at eof */
-	char			conv;	/* overwriting unwritten extents */
-	char			stack_switch;
-	int			flags;
-#ifdef __KERNEL__
-	struct completion	*done;
-	struct work_struct	work;
-	int			result;
-#endif /* __KERNEL__ */
-} xfs_bmalloca_t;
-
-/*
  * Flags for xfs_bmap_add_extent*.
  */
 #define BMAP_LEFT_CONTIG	(1 << 0)
@@ -206,17 +169,4 @@ int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 
-#ifdef __KERNEL__
-
-int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-		int *committed);
-int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
-		int whichfork, int *eof);
-int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
-		int whichfork, int *count);
-
-xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
-
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_BMAP_H__ */
diff --git a/libxfs/xfs.h b/libxfs/xfs.h
index 0113b50..276fc25 100644
--- a/libxfs/xfs.h
+++ b/libxfs/xfs.h
@@ -51,6 +51,40 @@
 typedef __uint32_t		uint_t;
 typedef __uint32_t		inst_t;		/* an instruction */
 
+/*
+ * Argument structure for xfs_bmap_alloc.
+ */
+typedef struct xfs_bmalloca {
+	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
+	struct xfs_bmap_free    *flist;	/* bmap freelist */
+	struct xfs_trans        *tp;	/* transaction pointer */
+	struct xfs_inode        *ip;	/* incore inode pointer */
+	struct xfs_bmbt_irec    prev;	/* extent before the new one */
+	struct xfs_bmbt_irec    got;	/* extent after, or delayed */
+
+	xfs_fileoff_t		offset;	/* offset in file filling in */
+	xfs_extlen_t		length;	/* i/o length asked/allocated */
+	xfs_fsblock_t		blkno;	/* starting block of new extent */
+
+	struct xfs_btree_cur    *cur;	/* btree cursor */
+	xfs_extnum_t		idx;	/* current extent index */
+	int			nallocs;/* number of extents alloc'd */
+	int			logflags;/* flags for transaction logging */
+
+	xfs_extlen_t		total;	/* total blocks needed for xaction */
+	xfs_extlen_t		minlen;	/* minimum allocation size (blocks) */
+	xfs_extlen_t		minleft; /* amount must be left after alloc */
+	char			eof;	/* set if allocating past last extent */
+	char			wasdel;	/* replacing a delayed allocation */
+	char			userdata;/* set if is user data */
+	char			aeof;	/* allocated space at eof */
+	char			conv;	/* overwriting unwritten extents */
+	char			stack_switch;
+	int			flags;
+} xfs_bmalloca_t;
+
+#define xfs_bmapi_allocate		__xfs_bmapi_allocate
+
 #ifndef EWRONGFS
 #define EWRONGFS	EINVAL
 #endif
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ce72b87..eeaea94 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -74,19 +74,6 @@ xfs_bmap_compute_maxlevels(
 	mp->m_bm_maxlevels[whichfork] = level;
 }
 
-/*
- * Convert the given file system block to a disk block.  We have to treat it
- * differently based on whether the file is a real time file or not, because the
- * bmap code does.
- */
-xfs_daddr_t
-xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
-{
-	return (XFS_IS_REALTIME_INODE(ip) ? \
-		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
-		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
-}
-
 STATIC int				/* error */
 xfs_bmbt_lookup_eq(
 	struct xfs_btree_cur	*cur,
@@ -229,173 +216,6 @@ xfs_bmap_forkoff_reset(
 }
 
 /*
- * Extent tree block counting routines.
- */
-
-/*
- * Count leaf blocks given a range of extent records.
- */
-STATIC void
-xfs_bmap_count_leaves(
-	xfs_ifork_t		*ifp,
-	xfs_extnum_t		idx,
-	int			numrecs,
-	int			*count)
-{
-	int		b;
-
-	for (b = 0; b < numrecs; b++) {
-		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, idx + b);
-		*count += xfs_bmbt_get_blockcount(frp);
-	}
-}
-
-/*
- * Count leaf blocks given a range of extent records originally
- * in btree format.
- */
-STATIC void
-xfs_bmap_disk_count_leaves(
-	struct xfs_mount	*mp,
-	struct xfs_btree_block	*block,
-	int			numrecs,
-	int			*count)
-{
-	int		b;
-	xfs_bmbt_rec_t	*frp;
-
-	for (b = 1; b <= numrecs; b++) {
-		frp = XFS_BMBT_REC_ADDR(mp, block, b);
-		*count += xfs_bmbt_disk_get_blockcount(frp);
-	}
-}
-
-/*
- * Recursively walks each level of a btree
- * to count total fsblocks is use.
- */
-STATIC int                                     /* error */
-xfs_bmap_count_tree(
-	xfs_mount_t     *mp,            /* file system mount point */
-	xfs_trans_t     *tp,            /* transaction pointer */
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	xfs_fsblock_t   blockno,	/* file system block number */
-	int             levelin,	/* level in btree */
-	int		*count)		/* Count of blocks */
-{
-	int			error;
-	xfs_buf_t		*bp, *nbp;
-	int			level = levelin;
-	__be64			*pp;
-	xfs_fsblock_t           bno = blockno;
-	xfs_fsblock_t		nextbno;
-	struct xfs_btree_block	*block, *nextblock;
-	int			numrecs;
-
-	error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
-	if (error)
-		return error;
-	*count += 1;
-	block = XFS_BUF_TO_BLOCK(bp);
-
-	if (--level) {
-		/* Not at node above leaves, count this level of nodes */
-		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
-		while (nextbno != NULLFSBLOCK) {
-			error = xfs_btree_read_bufl(mp, tp, nextbno, 0, &nbp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
-			if (error)
-				return error;
-			*count += 1;
-			nextblock = XFS_BUF_TO_BLOCK(nbp);
-			nextbno = be64_to_cpu(nextblock->bb_u.l.bb_rightsib);
-			xfs_trans_brelse(tp, nbp);
-		}
-
-		/* Dive to the next level */
-		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
-		bno = be64_to_cpu(*pp);
-		if (unlikely((error =
-		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
-			xfs_trans_brelse(tp, bp);
-			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
-					 XFS_ERRLEVEL_LOW, mp);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
-		xfs_trans_brelse(tp, bp);
-	} else {
-		/* count all level 1 nodes and their leaves */
-		for (;;) {
-			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
-			numrecs = be16_to_cpu(block->bb_numrecs);
-			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
-			xfs_trans_brelse(tp, bp);
-			if (nextbno == NULLFSBLOCK)
-				break;
-			bno = nextbno;
-			error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
-						XFS_BMAP_BTREE_REF,
-						&xfs_bmbt_buf_ops);
-			if (error)
-				return error;
-			*count += 1;
-			block = XFS_BUF_TO_BLOCK(bp);
-		}
-	}
-	return 0;
-}
-
-/*
- * Count fsblocks of the given fork.
- */
-int						/* error */
-xfs_bmap_count_blocks(
-	xfs_trans_t		*tp,		/* transaction pointer */
-	xfs_inode_t		*ip,		/* incore inode */
-	int			whichfork,	/* data or attr fork */
-	int			*count)		/* out: count of blocks */
-{
-	struct xfs_btree_block	*block;	/* current btree block */
-	xfs_fsblock_t		bno;	/* block # of "block" */
-	xfs_ifork_t		*ifp;	/* fork structure */
-	int			level;	/* btree level, for checking */
-	xfs_mount_t		*mp;	/* file system mount structure */
-	__be64			*pp;	/* pointer to block address */
-
-	bno = NULLFSBLOCK;
-	mp = ip->i_mount;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
-		xfs_bmap_count_leaves(ifp, 0,
-			ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t),
-			count);
-		return 0;
-	}
-
-	/*
-	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
-	 */
-	block = ifp->if_broot;
-	level = be16_to_cpu(block->bb_level);
-	ASSERT(level > 0);
-	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
-	bno = be64_to_cpu(*pp);
-	ASSERT(bno != NULLDFSBNO);
-	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
-	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
-
-	if (unlikely(xfs_bmap_count_tree(mp, tp, ifp, bno, level, count) < 0)) {
-		XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)", XFS_ERRLEVEL_LOW,
-				 mp);
-		return XFS_ERROR(EFSCORRUPTED);
-	}
-
-	return 0;
-}
-
-/*
  * Debug/sanity checking code
  */
 
@@ -803,7 +623,6 @@ xfs_bmap_del_free(
 	kmem_zone_free(xfs_bmap_free_item_zone, free);
 }
 
-
 /*
  * Free up any items left in the list.
  */
@@ -1028,8 +847,8 @@ xfs_bmap_extents_to_btree(
 	 * Do all this logging at the end so that
 	 * the root is at the right level.
 	 */
-	xfs_btree_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	xfs_btree_log_block(cur, abp, XFS_BB_ALL_BITS);
+	xfs_btree_log_recs(cur, abp, 1, be16_to_cpu(ablock->bb_numrecs));
 	ASSERT(*curp == NULL);
 	*curp = cur;
 	*logflagsp = XFS_ILOG_CORE | xfs_ilog_fbroot(whichfork);
@@ -1744,7 +1563,7 @@ xfs_bmap_last_before(
 	return 0;
 }
 
-STATIC int
+int
 xfs_bmap_last_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
@@ -1808,29 +1627,6 @@ xfs_bmap_isaeof(
 }
 
 /*
- * Check if the endoff is outside the last extent. If so the caller will grow
- * the allocation to a stripe unit boundary.  All offsets are considered outside
- * the end of file for an empty fork, so 1 is returned in *eof in that case.
- */
-int
-xfs_bmap_eof(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		endoff,
-	int			whichfork,
-	int			*eof)
-{
-	struct xfs_bmbt_irec	rec;
-	int			error;
-
-	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, eof);
-	if (error || *eof)
-		return error;
-
-	*eof = endoff >= rec.br_startoff + rec.br_blockcount;
-	return 0;
-}
-
-/*
  * Returns the file-relative block number of the first block past eof in
  * the file.  This is not based on i_size, it is based on the extent records.
  * Returns 0 for local files, as they do not have extent records.
@@ -3369,7 +3165,7 @@ done:
 /*
  * Adjust the size of the new extent based on di_extsize and rt extsize.
  */
-STATIC int
+int
 xfs_bmap_extsize_align(
 	xfs_mount_t	*mp,
 	xfs_bmbt_irec_t	*gotp,		/* next extent pointer */
@@ -3531,9 +3327,9 @@ xfs_bmap_extsize_align(
 
 #define XFS_ALLOC_GAP_UNITS	4
 
-STATIC void
+void
 xfs_bmap_adjacent(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_fsblock_t	adjust;		/* adjustment to block numbers */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
@@ -3796,7 +3592,7 @@ xfs_bmap_btalloc_nullfb(
 
 STATIC int
 xfs_bmap_btalloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
@@ -4028,7 +3824,7 @@ xfs_bmap_btalloc(
  */
 STATIC int
 xfs_bmap_alloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
@@ -4416,8 +4212,8 @@ xfs_bmapi_delay(
 }
 
 
-STATIC int
-xfs_bmapi_allocate(
+int
+__xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
 	struct xfs_mount	*mp = bma->ip->i_mount;
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
