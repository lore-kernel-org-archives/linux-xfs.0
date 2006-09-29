Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Sep 2006 20:56:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8T3uBaG009143
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 20:56:12 -0700
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56CCCD11A33B
	for <xfs@oss.sgi.com>; Thu, 28 Sep 2006 20:55:30 -0700 (PDT)
Subject: [PATCH 2/2] Remove unused stuff
Message-Id: <20060929032916.AB75B18001A5F@sandeen.net>
Date: Thu, 28 Sep 2006 22:29:16 -0500 (CDT)
From: sandeen@sandeen.net
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

And now that things are static, remove things that are not used.

 xfs_bmap.c       |   36 ------------------
 xfs_bmap_btree.c |   74 -------------------------------------
 xfs_bmap_btree.h |   11 -----
 xfs_da_btree.c   |   15 -------
 xfs_da_btree.h   |    1 
 xfs_error.c      |   26 -------------
 xfs_error.h      |    1 
 xfs_rtalloc.c    |  108 -------------------------------------------------------
 xfs_rtalloc.h    |   18 ---------
 9 files changed, 290 deletions(-)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs-linux/xfs_da_btree.c
===================================================================
--- xfs-linux.orig/xfs_da_btree.c
+++ xfs-linux/xfs_da_btree.c
@@ -2166,21 +2166,6 @@ xfs_da_reada_buf(
 		return rval;
 }
 
-/*
- * Calculate the number of bits needed to hold i different values.
- */
-uint
-xfs_da_log2_roundup(uint i)
-{
-	uint rval;
-
-	for (rval = 0; rval < NBBY * sizeof(i); rval++) {
-		if ((1 << rval) >= i)
-			break;
-	}
-	return(rval);
-}
-
 kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
 kmem_zone_t *xfs_dabuf_zone;		/* dabuf zone */
 
Index: xfs-linux/xfs_da_btree.h
===================================================================
--- xfs-linux.orig/xfs_da_btree.h
+++ xfs-linux/xfs_da_btree.h
@@ -249,7 +249,6 @@ int	xfs_da_shrink_inode(xfs_da_args_t *a
 					  xfs_dabuf_t *dead_buf);
 
 uint xfs_da_hashname(const uchar_t *name_string, int name_length);
-uint xfs_da_log2_roundup(uint i);
 xfs_da_state_t *xfs_da_state_alloc(void);
 void xfs_da_state_free(xfs_da_state_t *state);
 
Index: xfs-linux/xfs_bmap.c
===================================================================
--- xfs-linux.orig/xfs_bmap.c
+++ xfs-linux/xfs_bmap.c
@@ -185,16 +185,6 @@ xfs_bmap_btree_to_extents(
 	int			*logflagsp, /* inode logging flags */
 	int			whichfork); /* data or attr fork */
 
-#ifdef DEBUG
-/*
- * Check that the extents list for the inode ip is in the right order.
- */
-STATIC void
-xfs_bmap_check_extents(
-	xfs_inode_t		*ip,		/* incore inode pointer */
-	int			whichfork);	/* data or attr fork */
-#endif
-
 /*
  * Called by xfs_bmapi to update file extent records and the btree
  * after removing space (or undoing a delayed allocation).
@@ -6046,32 +6036,6 @@ xfs_bmap_eof(
 }
 
 #ifdef DEBUG
-/*
- * Check that the extents list for the inode ip is in the right order.
- */
-STATIC void
-xfs_bmap_check_extents(
-	xfs_inode_t		*ip,		/* incore inode pointer */
-	int			whichfork)	/* data or attr fork */
-{
-	xfs_bmbt_rec_t		*ep;		/* current extent entry */
-	xfs_extnum_t		idx;		/* extent record index */
-	xfs_ifork_t		*ifp;		/* inode fork pointer */
-	xfs_extnum_t		nextents;	/* number of extents in list */
-	xfs_bmbt_rec_t		*nextp;		/* next extent entry */
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
-	nextents = ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t);
-	ep = xfs_iext_get_ext(ifp, 0);
-	for (idx = 0; idx < nextents - 1; idx++) {
-		nextp = xfs_iext_get_ext(ifp, idx + 1);
-		xfs_btree_check_rec(XFS_BTNUM_BMAP, (void *)ep,
-			(void *)(nextp));
-		ep = nextp;
-	}
-}
-
 STATIC xfs_buf_t *
 xfs_bmap_get_bp(
 	xfs_btree_cur_t         *cur,
Index: xfs-linux/xfs_bmap_btree.c
===================================================================
--- xfs-linux.orig/xfs_bmap_btree.c
+++ xfs-linux/xfs_bmap_btree.c
@@ -66,10 +66,6 @@ STATIC xfs_bmbt_block_t *xfs_bmbt_get_bl
 STATIC void xfs_bmbt_disk_set_all(xfs_bmbt_rec_t *r, xfs_bmbt_irec_t *s);
 STATIC void xfs_bmbt_disk_set_allf(xfs_bmbt_rec_t *r, xfs_fileoff_t o,
 			xfs_fsblock_t b, xfs_filblks_t c, xfs_exntst_t v);
-#ifdef DEBUG
-STATIC xfs_fsblock_t xfs_bmbt_disk_get_startblock(xfs_bmbt_rec_t *r);
-STATIC xfs_exntst_t xfs_bmbt_disk_get_state(xfs_bmbt_rec_t *r);
-#endif
 #endif
 
 #if defined(XFS_BMBT_TRACE)
@@ -688,43 +684,6 @@ error0:
 	return error;
 }
 
-#ifdef DEBUG
-/*
- * Get the data from the pointed-to record.
- */
-int
-xfs_bmbt_get_rec(
-	xfs_btree_cur_t		*cur,
-	xfs_fileoff_t		*off,
-	xfs_fsblock_t		*bno,
-	xfs_filblks_t		*len,
-	xfs_exntst_t		*state,
-	int			*stat)
-{
-	xfs_bmbt_block_t	*block;
-	xfs_buf_t		*bp;
-	int			error;
-	int			ptr;
-	xfs_bmbt_rec_t		*rp;
-
-	block = xfs_bmbt_get_block(cur, 0, &bp);
-	ptr = cur->bc_ptrs[0];
-	if ((error = xfs_btree_check_lblock(cur, block, 0, bp)))
-		return error;
-	if (ptr > be16_to_cpu(block->bb_numrecs) || ptr <= 0) {
-		*stat = 0;
-		return 0;
-	}
-	rp = XFS_BMAP_REC_IADDR(block, ptr, cur);
-	*off = xfs_bmbt_disk_get_startoff(rp);
-	*bno = xfs_bmbt_disk_get_startblock(rp);
-	*len = xfs_bmbt_disk_get_blockcount(rp);
-	*state = xfs_bmbt_disk_get_state(rp);
-	*stat = 1;
-	return 0;
-}
-#endif
-
 /*
  * Insert one record/level.  Return information to the caller
  * allowing the next level up to proceed if necessary.
@@ -2021,39 +1980,6 @@ xfs_bmbt_disk_get_blockcount(
 	return (xfs_filblks_t)(INT_GET(r->l1, ARCH_CONVERT) & XFS_MASK64LO(21));
 }
 
-#ifdef DEBUG
-/*
- * Extract the startblock field from an on disk bmap extent record.
- */
-STATIC xfs_fsblock_t
-xfs_bmbt_disk_get_startblock(
-	xfs_bmbt_rec_t	*r)
-{
-#if XFS_BIG_BLKNOS
-	return (((xfs_fsblock_t)INT_GET(r->l0, ARCH_CONVERT) & XFS_MASK64LO(9)) << 43) |
-	       (((xfs_fsblock_t)INT_GET(r->l1, ARCH_CONVERT)) >> 21);
-#else
-	xfs_dfsbno_t	b;
-
-	b = (((xfs_dfsbno_t)INT_GET(r->l0, ARCH_CONVERT) & XFS_MASK64LO(9)) << 43) |
-	    (((xfs_dfsbno_t)INT_GET(r->l1, ARCH_CONVERT)) >> 21);
-	ASSERT((b >> 32) == 0 || ISNULLDSTARTBLOCK(b));
-	return (xfs_fsblock_t)b;
-#endif	/* XFS_BIG_BLKNOS */
-}
-
-STATIC xfs_exntst_t
-xfs_bmbt_disk_get_state(
-	xfs_bmbt_rec_t  *r)
-{
-	int	ext_flag;
-
-	ext_flag = (int)((INT_GET(r->l0, ARCH_CONVERT)) >> (64 - BMBT_EXNTFLAG_BITLEN));
-	return xfs_extent_state(xfs_bmbt_disk_get_blockcount(r),
-				ext_flag);
-}
-#endif	/* DEBUG */
-
 /*
  * Extract the startoff field from a disk format bmap extent record.
  */
Index: xfs-linux/xfs_bmap_btree.h
===================================================================
--- xfs-linux.orig/xfs_bmap_btree.h
+++ xfs-linux/xfs_bmap_btree.h
@@ -317,9 +317,7 @@ extern xfs_filblks_t xfs_bmbt_disk_get_b
 extern xfs_fileoff_t xfs_bmbt_disk_get_startoff(xfs_bmbt_rec_t *r);
 #else
 #define xfs_bmbt_disk_get_all(r, s)	xfs_bmbt_get_all(r, s)
-#define xfs_bmbt_disk_get_state(r)	xfs_bmbt_get_state(r)
 #define xfs_bmbt_disk_get_blockcount(r)	xfs_bmbt_get_blockcount(r)
-#define xfs_bmbt_disk_get_startblock(r)	xfs_bmbt_get_blockcount(r)
 #define xfs_bmbt_disk_get_startoff(r)	xfs_bmbt_get_startoff(r)
 #endif /* XFS_NATIVE_HOST */
 
@@ -356,15 +354,6 @@ extern void xfs_bmbt_to_bmdr(xfs_bmbt_bl
 extern int xfs_bmbt_update(struct xfs_btree_cur *, xfs_fileoff_t,
 				xfs_fsblock_t, xfs_filblks_t, xfs_exntst_t);
 
-#ifdef DEBUG
-/*
- * Get the data from the pointed-to record.
- */
-extern int xfs_bmbt_get_rec(struct xfs_btree_cur *, xfs_fileoff_t *,
-				xfs_fsblock_t *, xfs_filblks_t *,
-				xfs_exntst_t *, int *);
-#endif
-
 #endif	/* __KERNEL__ */
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
Index: xfs-linux/xfs_rtalloc.c
===================================================================
--- xfs-linux.orig/xfs_rtalloc.c
+++ xfs-linux/xfs_rtalloc.c
@@ -913,57 +913,6 @@ xfs_rtcheck_alloc_range(
 }
 #endif
 
-#ifdef DEBUG
-/*
- * Check whether the given block in the bitmap has the given value.
- */
-STATIC int				/* 1 for matches, 0 for not */
-xfs_rtcheck_bit(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* bit (block) to check */
-	int		val)		/* 1 for free, 0 for allocated */
-{
-	int		bit;		/* bit number in the word */
-	xfs_rtblock_t	block;		/* bitmap block number */
-	xfs_buf_t	*bp;		/* buf for the block */
-	xfs_rtword_t	*bufp;		/* pointer into the buffer */
-	/* REFERENCED */
-	int		error;		/* error value */
-	xfs_rtword_t	wdiff;		/* difference between bit & expected */
-	int		word;		/* word number in the buffer */
-	xfs_rtword_t	wval;		/* word value from buffer */
-
-	block = XFS_BITTOBLOCK(mp, start);
-	error = xfs_rtbuf_get(mp, tp, block, 0, &bp);
-	bufp = (xfs_rtword_t *)XFS_BUF_PTR(bp);
-	word = XFS_BITTOWORD(mp, start);
-	bit = (int)(start & (XFS_NBWORD - 1));
-	wval = bufp[word];
-	xfs_trans_brelse(tp, bp);
-	wdiff = (wval ^ -val) & ((xfs_rtword_t)1 << bit);
-	return !wdiff;
-}
-#endif	/* DEBUG */
-
-#if 0
-/*
- * Check that the given extent (block range) is free already.
- */
-STATIC int				/* error */
-xfs_rtcheck_free_range(
-	xfs_mount_t	*mp,		/* file system mount point */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	bno,		/* starting block number of extent */
-	xfs_extlen_t	len,		/* length of extent */
-	int		*stat)		/* out: 1 for free, 0 for not */
-{
-	xfs_rtblock_t	new;		/* dummy for xfs_rtcheck_range */
-
-	return xfs_rtcheck_range(mp, tp, bno, len, 1, &new, stat);
-}
-#endif
-
 /*
  * Check that the given range is either all allocated (val = 0) or
  * all free (val = 1).
@@ -2382,60 +2331,3 @@ xfs_rtpick_extent(
 	*pick = b;
 	return 0;
 }
-
-#ifdef DEBUG
-/*
- * Debug code: print out the value of a range in the bitmap.
- */
-void
-xfs_rtprint_range(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp,		/* transaction pointer */
-	xfs_rtblock_t	start,		/* starting block to print */
-	xfs_extlen_t	len)		/* length to print */
-{
-	xfs_extlen_t	i;		/* block number in the extent */
-
-	cmn_err(CE_DEBUG, "%Ld: ", (long long)start);
-	for (i = 0; i < len; i++)
-		cmn_err(CE_DEBUG, "%d", xfs_rtcheck_bit(mp, tp, start + i, 1));
-	cmn_err(CE_DEBUG, "\n");
-}
-
-/*
- * Debug code: print the summary file.
- */
-void
-xfs_rtprint_summary(
-	xfs_mount_t	*mp,		/* file system mount structure */
-	xfs_trans_t	*tp)		/* transaction pointer */
-{
-	xfs_suminfo_t	c;		/* summary data */
-	xfs_rtblock_t	i;		/* bitmap block number */
-	int		l;		/* summary information level */
-	int		p;		/* flag for printed anything */
-	xfs_fsblock_t	sb;		/* summary block number */
-	xfs_buf_t	*sumbp;		/* summary block buffer */
-
-	sumbp = NULL;
-	for (l = 0; l < mp->m_rsumlevels; l++) {
-		for (p = 0, i = 0; i < mp->m_sb.sb_rbmblocks; i++) {
-			(void)xfs_rtget_summary(mp, tp, l, i, &sumbp, &sb, &c);
-			if (c) {
-				if (!p) {
-					cmn_err(CE_DEBUG, "%Ld-%Ld:", 1LL << l,
-						XFS_RTMIN((1LL << l) +
-							  ((1LL << l) - 1LL),
-							 mp->m_sb.sb_rextents));
-					p = 1;
-				}
-				cmn_err(CE_DEBUG, " %Ld:%d", (long long)i, c);
-			}
-		}
-		if (p)
-			cmn_err(CE_DEBUG, "\n");
-	}
-	if (sumbp)
-		xfs_trans_brelse(tp, sumbp);
-}
-#endif	/* DEBUG */
Index: xfs-linux/xfs_rtalloc.h
===================================================================
--- xfs-linux.orig/xfs_rtalloc.h
+++ xfs-linux/xfs_rtalloc.h
@@ -134,24 +134,6 @@ xfs_rtpick_extent(
 	xfs_rtblock_t		*pick);	/* result rt extent */
 
 /*
- * Debug code: print out the value of a range in the bitmap.
- */
-void
-xfs_rtprint_range(
-	struct xfs_mount	*mp,	/* file system mount structure */
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		start,	/* starting block to print */
-	xfs_extlen_t		len);	/* length to print */
-
-/*
- * Debug code: print the summary file.
- */
-void
-xfs_rtprint_summary(
-	struct xfs_mount	*mp,	/* file system mount structure */
-	struct xfs_trans	*tp);	/* transaction pointer */
-
-/*
  * Grow the realtime area of the filesystem.
  */
 int
Index: xfs-linux/xfs_error.c
===================================================================
--- xfs-linux.orig/xfs_error.c
+++ xfs-linux/xfs_error.c
@@ -132,32 +132,6 @@ xfs_errortag_add(int error_tag, xfs_moun
 }
 
 int
-xfs_errortag_clear(int error_tag, xfs_mount_t *mp)
-{
-	int i;
-	int64_t fsid;
-
-	memcpy(&fsid, mp->m_fixedfsid, sizeof(xfs_fsid_t));
-
-	for (i = 0; i < XFS_NUM_INJECT_ERROR; i++) {
-		if (xfs_etest_fsid[i] == fsid && xfs_etest[i] == error_tag) {
-			xfs_etest[i] = 0;
-			xfs_etest_fsid[i] = 0LL;
-			kmem_free(xfs_etest_fsname[i],
-				  strlen(xfs_etest_fsname[i]) + 1);
-			xfs_etest_fsname[i] = NULL;
-			cmn_err(CE_WARN, "Cleared XFS error tag #%d",
-				error_tag);
-			return 0;
-		}
-	}
-
-	cmn_err(CE_WARN, "XFS error tag %d not on", error_tag);
-
-	return 1;
-}
-
-int
 xfs_errortag_clearall_umount(int64_t fsid, char *fsname, int loud)
 {
 	int i;
Index: xfs-linux/xfs_error.h
===================================================================
--- xfs-linux.orig/xfs_error.h
+++ xfs-linux/xfs_error.h
@@ -144,7 +144,6 @@ extern void xfs_error_test_init(void);
 #endif /* __ANSI_CPP__ */
 
 extern int xfs_errortag_add(int error_tag, xfs_mount_t *mp);
-extern int xfs_errortag_clear(int error_tag, xfs_mount_t *mp);
 extern int xfs_errortag_clearall(xfs_mount_t *mp);
 extern int xfs_errortag_clearall_umount(int64_t fsid, char *fsname, int loud);
 #else
