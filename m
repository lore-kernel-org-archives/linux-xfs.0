Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 606007F61
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 05:50:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 12A8A8F8049
	for <xfs@oss.sgi.com>; Mon, 12 Aug 2013 03:50:58 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	k5aPNbJWU6UQWMxm for <xfs@oss.sgi.com>;
	Mon, 12 Aug 2013 03:50:52 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1V8phX-0004YA-4J
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1V8phX-000628-3D
	for xfs@oss.sgi.com; Mon, 12 Aug 2013 20:50:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** [PATCH 21/50] xfs: create
	xfs_bmap_util.[ch]
Date: Mon, 12 Aug 2013 20:49:42 +1000
Message-Id: <1376304611-22994-22-git-send-email-david@fromorbit.com>
In-Reply-To: <1376304611-22994-1-git-send-email-david@fromorbit.com>
References: <1376304611-22994-1-git-send-email-david@fromorbit.com>
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
not shared with userspace. To minimise the difference between the
kernel and userspace code, shift this unshared code to
xfs_bmap_util.c, and the declarations to xfs_bmap_util.h.

The biggest issue here is xfs_bmap_finish() - userspace has it's own
definition of this function, and so we need to move it out of
xfs_bmap.[ch]. This means several other files need to include
xfs_bmap_util.h as well.

It also introduces and interesting dance for the stack switching
code in xfs_bmapi_allocate(). The stack switching/workqueue code is
actually moved to xfs_bmap_util.c, so that userspace can simply use
a #define in a header file to connect the dots without needing to
know about the stack switch code at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/Makefile          |   1 +
 fs/xfs/xfs_aops.c        |   1 +
 fs/xfs/xfs_attr.c        |   1 +
 fs/xfs/xfs_attr_remote.c |   1 +
 fs/xfs/xfs_bmap.c        | 804 +--------------------------------------------
 fs/xfs/xfs_bmap.h        |  56 ----
 fs/xfs/xfs_bmap_util.c   | 834 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h   |  96 ++++++
 fs/xfs/xfs_dfrag.c       |   1 +
 fs/xfs/xfs_dquot.c       |   1 +
 fs/xfs/xfs_filestream.c  |   5 +-
 fs/xfs/xfs_inode.c       |   1 +
 fs/xfs/xfs_ioctl.c       |   1 +
 fs/xfs/xfs_iomap.c       |   1 +
 fs/xfs/xfs_iops.c        |   1 +
 fs/xfs/xfs_rename.c      |   1 +
 fs/xfs/xfs_rtalloc.c     |   1 +
 fs/xfs/xfs_symlink.c     |   1 +
 fs/xfs/xfs_trans_resv.c  |   1 +
 fs/xfs/xfs_vnodeops.c    |   1 +
 20 files changed, 957 insertions(+), 853 deletions(-)
 create mode 100644 fs/xfs/xfs_bmap_util.c
 create mode 100644 fs/xfs/xfs_bmap_util.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index fb14461..dcd21b9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -30,6 +30,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_attr_inactive.o \
 				   xfs_attr_list.o \
 				   xfs_bit.o \
+				   xfs_bmap_util.o \
 				   xfs_buf.o \
 				   xfs_dfrag.o \
 				   xfs_dir2_readdir.o \
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7967086..709347d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -31,6 +31,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 6ab77e3..91acc38 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -33,6 +33,7 @@
 #include "xfs_alloc.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
diff --git a/fs/xfs/xfs_attr_remote.c b/fs/xfs/xfs_attr_remote.c
index 39a59ea..13a0ed9 100644
--- a/fs/xfs/xfs_attr_remote.c
+++ b/fs/xfs/xfs_attr_remote.c
@@ -34,6 +34,7 @@
 #include "xfs_alloc.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
diff --git a/fs/xfs/xfs_bmap.c b/fs/xfs/xfs_bmap.c
index 72a2eea..1f09faf 100644
--- a/fs/xfs/xfs_bmap.c
+++ b/fs/xfs/xfs_bmap.c
@@ -40,6 +40,7 @@
 #include "xfs_extfree_item.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_attr_leaf.h"
@@ -109,19 +110,6 @@ xfs_bmap_compute_maxlevels(
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
@@ -264,173 +252,6 @@ xfs_bmap_forkoff_reset(
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
 
@@ -824,7 +645,7 @@ xfs_bmap_add_free(
  * Remove the entry "free" from the free item list.  Prev points to the
  * previous entry, unless "free" is the head of the list.
  */
-STATIC void
+void
 xfs_bmap_del_free(
 	xfs_bmap_free_t		*flist,	/* free item list header */
 	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
@@ -838,92 +659,6 @@ xfs_bmap_del_free(
 	kmem_zone_free(xfs_bmap_free_item_zone, free);
 }
 
-
-/*
- * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
- * caller.  Frees all the extents that need freeing, which must be done
- * last due to locking considerations.  We never free any extents in
- * the first transaction.
- *
- * Return 1 if the given transaction was committed and a new one
- * started, and 0 otherwise in the committed parameter.
- */
-int						/* error */
-xfs_bmap_finish(
-	xfs_trans_t		**tp,		/* transaction pointer addr */
-	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
-	int			*committed)	/* xact committed or not */
-{
-	xfs_efd_log_item_t	*efd;		/* extent free data */
-	xfs_efi_log_item_t	*efi;		/* extent free intention */
-	int			error;		/* error return value */
-	xfs_bmap_free_item_t	*free;		/* free extent item */
-	unsigned int		logres;		/* new log reservation */
-	unsigned int		logcount;	/* new log count */
-	xfs_mount_t		*mp;		/* filesystem mount structure */
-	xfs_bmap_free_item_t	*next;		/* next item on free list */
-	xfs_trans_t		*ntp;		/* new transaction pointer */
-
-	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
-	if (flist->xbf_count == 0) {
-		*committed = 0;
-		return 0;
-	}
-	ntp = *tp;
-	efi = xfs_trans_get_efi(ntp, flist->xbf_count);
-	for (free = flist->xbf_first; free; free = free->xbfi_next)
-		xfs_trans_log_efi_extent(ntp, efi, free->xbfi_startblock,
-			free->xbfi_blockcount);
-	logres = ntp->t_log_res;
-	logcount = ntp->t_log_count;
-	ntp = xfs_trans_dup(*tp);
-	error = xfs_trans_commit(*tp, 0);
-	*tp = ntp;
-	*committed = 1;
-	/*
-	 * We have a new transaction, so we should return committed=1,
-	 * even though we're returning an error.
-	 */
-	if (error)
-		return error;
-
-	/*
-	 * transaction commit worked ok so we can drop the extra ticket
-	 * reference that we gained in xfs_trans_dup()
-	 */
-	xfs_log_ticket_put(ntp->t_ticket);
-
-	if ((error = xfs_trans_reserve(ntp, 0, logres, 0, XFS_TRANS_PERM_LOG_RES,
-			logcount)))
-		return error;
-	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
-	for (free = flist->xbf_first; free != NULL; free = next) {
-		next = free->xbfi_next;
-		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
-				free->xbfi_blockcount))) {
-			/*
-			 * The bmap free list will be cleaned up at a
-			 * higher level.  The EFI will be canceled when
-			 * this transaction is aborted.
-			 * Need to force shutdown here to make sure it
-			 * happens, since this transaction may not be
-			 * dirty yet.
-			 */
-			mp = ntp->t_mountp;
-			if (!XFS_FORCED_SHUTDOWN(mp))
-				xfs_force_shutdown(mp,
-						   (error == EFSCORRUPTED) ?
-						   SHUTDOWN_CORRUPT_INCORE :
-						   SHUTDOWN_META_IO_ERROR);
-			return error;
-		}
-		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
-			free->xbfi_blockcount);
-		xfs_bmap_del_free(flist, NULL, free);
-	}
-	return 0;
-}
-
 /*
  * Free up any items left in the list.
  */
@@ -1864,7 +1599,7 @@ xfs_bmap_last_before(
 	return 0;
 }
 
-STATIC int
+int
 xfs_bmap_last_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
@@ -1928,29 +1663,6 @@ xfs_bmap_isaeof(
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
@@ -3489,7 +3201,7 @@ done:
 /*
  * Adjust the size of the new extent based on di_extsize and rt extsize.
  */
-STATIC int
+int
 xfs_bmap_extsize_align(
 	xfs_mount_t	*mp,
 	xfs_bmbt_irec_t	*gotp,		/* next extent pointer */
@@ -3651,9 +3363,9 @@ xfs_bmap_extsize_align(
 
 #define XFS_ALLOC_GAP_UNITS	4
 
-STATIC void
+void
 xfs_bmap_adjacent(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_fsblock_t	adjust;		/* adjustment to block numbers */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
@@ -3800,109 +3512,6 @@ xfs_bmap_adjacent(
 }
 
 STATIC int
-xfs_bmap_rtalloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
-{
-	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
-	int		error;		/* error return value */
-	xfs_mount_t	*mp;		/* mount point structure */
-	xfs_extlen_t	prod = 0;	/* product factor for allocators */
-	xfs_extlen_t	ralen = 0;	/* realtime allocation length */
-	xfs_extlen_t	align;		/* minimum allocation alignment */
-	xfs_rtblock_t	rtb;
-
-	mp = ap->ip->i_mount;
-	align = xfs_get_extsz_hint(ap->ip);
-	prod = align / mp->m_sb.sb_rextsize;
-	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
-					align, 1, ap->eof, 0,
-					ap->conv, &ap->offset, &ap->length);
-	if (error)
-		return error;
-	ASSERT(ap->length);
-	ASSERT(ap->length % mp->m_sb.sb_rextsize == 0);
-
-	/*
-	 * If the offset & length are not perfectly aligned
-	 * then kill prod, it will just get us in trouble.
-	 */
-	if (do_mod(ap->offset, align) || ap->length % align)
-		prod = 1;
-	/*
-	 * Set ralen to be the actual requested length in rtextents.
-	 */
-	ralen = ap->length / mp->m_sb.sb_rextsize;
-	/*
-	 * If the old value was close enough to MAXEXTLEN that
-	 * we rounded up to it, cut it back so it's valid again.
-	 * Note that if it's a really large request (bigger than
-	 * MAXEXTLEN), we don't hear about that number, and can't
-	 * adjust the starting point to match it.
-	 */
-	if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
-		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
-
-	/*
-	 * Lock out other modifications to the RT bitmap inode.
-	 */
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
-
-	/*
-	 * If it's an allocation to an empty file at offset 0,
-	 * pick an extent that will space things out in the rt area.
-	 */
-	if (ap->eof && ap->offset == 0) {
-		xfs_rtblock_t uninitialized_var(rtx); /* realtime extent no */
-
-		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
-		if (error)
-			return error;
-		ap->blkno = rtx * mp->m_sb.sb_rextsize;
-	} else {
-		ap->blkno = 0;
-	}
-
-	xfs_bmap_adjacent(ap);
-
-	/*
-	 * Realtime allocation, done through xfs_rtallocate_extent.
-	 */
-	atype = ap->blkno == 0 ?  XFS_ALLOCTYPE_ANY_AG : XFS_ALLOCTYPE_NEAR_BNO;
-	do_div(ap->blkno, mp->m_sb.sb_rextsize);
-	rtb = ap->blkno;
-	ap->length = ralen;
-	if ((error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
-				&ralen, atype, ap->wasdel, prod, &rtb)))
-		return error;
-	if (rtb == NULLFSBLOCK && prod > 1 &&
-	    (error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1,
-					   ap->length, &ralen, atype,
-					   ap->wasdel, 1, &rtb)))
-		return error;
-	ap->blkno = rtb;
-	if (ap->blkno != NULLFSBLOCK) {
-		ap->blkno *= mp->m_sb.sb_rextsize;
-		ralen *= mp->m_sb.sb_rextsize;
-		ap->length = ralen;
-		ap->ip->i_d.di_nblocks += ralen;
-		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
-		if (ap->wasdel)
-			ap->ip->i_delayed_blks -= ralen;
-		/*
-		 * Adjust the disk quota also. This was reserved
-		 * earlier.
-		 */
-		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
-			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
-					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
-	} else {
-		ap->length = 0;
-	}
-	return 0;
-}
-
-STATIC int
 xfs_bmap_btalloc_nullfb(
 	struct xfs_bmalloca	*ap,
 	struct xfs_alloc_arg	*args,
@@ -4019,7 +3628,7 @@ xfs_bmap_btalloc_nullfb(
 
 STATIC int
 xfs_bmap_btalloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
@@ -4251,7 +3860,7 @@ xfs_bmap_btalloc(
  */
 STATIC int
 xfs_bmap_alloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
@@ -4639,7 +4248,7 @@ xfs_bmapi_delay(
 }
 
 
-STATIC int
+int
 __xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
@@ -4757,45 +4366,6 @@ __xfs_bmapi_allocate(
 	return 0;
 }
 
-static void
-xfs_bmapi_allocate_worker(
-	struct work_struct	*work)
-{
-	struct xfs_bmalloca	*args = container_of(work,
-						struct xfs_bmalloca, work);
-	unsigned long		pflags;
-
-	/* we are in a transaction context here */
-	current_set_flags_nested(&pflags, PF_FSTRANS);
-
-	args->result = __xfs_bmapi_allocate(args);
-	complete(args->done);
-
-	current_restore_flags_nested(&pflags, PF_FSTRANS);
-}
-
-/*
- * Some allocation requests often come in with little stack to work on. Push
- * them off to a worker thread so there is lots of stack to use. Otherwise just
- * call directly to avoid the context switch overhead here.
- */
-int
-xfs_bmapi_allocate(
-	struct xfs_bmalloca	*args)
-{
-	DECLARE_COMPLETION_ONSTACK(done);
-
-	if (!args->stack_switch)
-		return __xfs_bmapi_allocate(args);
-
-
-	args->done = &done;
-	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
-	queue_work(xfs_alloc_wq, &args->work);
-	wait_for_completion(&done);
-	return args->result;
-}
-
 STATIC int
 xfs_bmapi_convert_unwritten(
 	struct xfs_bmalloca	*bma,
@@ -5790,359 +5360,3 @@ error0:
 	}
 	return error;
 }
-
-/*
- * returns 1 for success, 0 if we failed to map the extent.
- */
-STATIC int
-xfs_getbmapx_fix_eof_hole(
-	xfs_inode_t		*ip,		/* xfs incore inode pointer */
-	struct getbmapx		*out,		/* output structure */
-	int			prealloced,	/* this is a file with
-						 * preallocated data space */
-	__int64_t		end,		/* last block requested */
-	xfs_fsblock_t		startblock)
-{
-	__int64_t		fixlen;
-	xfs_mount_t		*mp;		/* file system mount point */
-	xfs_ifork_t		*ifp;		/* inode fork pointer */
-	xfs_extnum_t		lastx;		/* last extent pointer */
-	xfs_fileoff_t		fileblock;
-
-	if (startblock == HOLESTARTBLOCK) {
-		mp = ip->i_mount;
-		out->bmv_block = -1;
-		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
-		fixlen -= out->bmv_offset;
-		if (prealloced && out->bmv_offset + out->bmv_length == end) {
-			/* Came to hole at EOF. Trim it. */
-			if (fixlen <= 0)
-				return 0;
-			out->bmv_length = fixlen;
-		}
-	} else {
-		if (startblock == DELAYSTARTBLOCK)
-			out->bmv_block = -2;
-		else
-			out->bmv_block = xfs_fsb_to_db(ip, startblock);
-		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
-		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
-		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
-			out->bmv_oflags |= BMV_OF_LAST;
-	}
-
-	return 1;
-}
-
-/*
- * Get inode's extents as described in bmv, and format for output.
- * Calls formatter to fill the user's buffer until all extents
- * are mapped, until the passed-in bmv->bmv_count slots have
- * been filled, or until the formatter short-circuits the loop,
- * if it is tracking filled-in extents on its own.
- */
-int						/* error code */
-xfs_getbmap(
-	xfs_inode_t		*ip,
-	struct getbmapx		*bmv,		/* user bmap structure */
-	xfs_bmap_format_t	formatter,	/* format to user */
-	void			*arg)		/* formatter arg */
-{
-	__int64_t		bmvend;		/* last block requested */
-	int			error = 0;	/* return value */
-	__int64_t		fixlen;		/* length for -1 case */
-	int			i;		/* extent number */
-	int			lock;		/* lock state */
-	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
-	xfs_mount_t		*mp;		/* file system mount point */
-	int			nex;		/* # of user extents can do */
-	int			nexleft;	/* # of user extents left */
-	int			subnex;		/* # of bmapi's can do */
-	int			nmap;		/* number of map entries */
-	struct getbmapx		*out;		/* output structure */
-	int			whichfork;	/* data or attr fork */
-	int			prealloced;	/* this is a file with
-						 * preallocated data space */
-	int			iflags;		/* interface flags */
-	int			bmapi_flags;	/* flags for xfs_bmapi */
-	int			cur_ext = 0;
-
-	mp = ip->i_mount;
-	iflags = bmv->bmv_iflags;
-	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
-
-	if (whichfork == XFS_ATTR_FORK) {
-		if (XFS_IFORK_Q(ip)) {
-			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
-			    ip->i_d.di_aformat != XFS_DINODE_FMT_BTREE &&
-			    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
-				return XFS_ERROR(EINVAL);
-		} else if (unlikely(
-			   ip->i_d.di_aformat != 0 &&
-			   ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS)) {
-			XFS_ERROR_REPORT("xfs_getbmap", XFS_ERRLEVEL_LOW,
-					 ip->i_mount);
-			return XFS_ERROR(EFSCORRUPTED);
-		}
-
-		prealloced = 0;
-		fixlen = 1LL << 32;
-	} else {
-		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
-		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
-		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
-			return XFS_ERROR(EINVAL);
-
-		if (xfs_get_extsz_hint(ip) ||
-		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
-			prealloced = 1;
-			fixlen = mp->m_super->s_maxbytes;
-		} else {
-			prealloced = 0;
-			fixlen = XFS_ISIZE(ip);
-		}
-	}
-
-	if (bmv->bmv_length == -1) {
-		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, fixlen));
-		bmv->bmv_length =
-			max_t(__int64_t, fixlen - bmv->bmv_offset, 0);
-	} else if (bmv->bmv_length == 0) {
-		bmv->bmv_entries = 0;
-		return 0;
-	} else if (bmv->bmv_length < 0) {
-		return XFS_ERROR(EINVAL);
-	}
-
-	nex = bmv->bmv_count - 1;
-	if (nex <= 0)
-		return XFS_ERROR(EINVAL);
-	bmvend = bmv->bmv_offset + bmv->bmv_length;
-
-
-	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
-		return XFS_ERROR(ENOMEM);
-	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
-	if (!out) {
-		out = kmem_zalloc_large(bmv->bmv_count *
-					sizeof(struct getbmapx));
-		if (!out)
-			return XFS_ERROR(ENOMEM);
-	}
-
-	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
-		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
-			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
-			if (error)
-				goto out_unlock_iolock;
-		}
-		/*
-		 * even after flushing the inode, there can still be delalloc
-		 * blocks on the inode beyond EOF due to speculative
-		 * preallocation. These are not removed until the release
-		 * function is called or the inode is inactivated. Hence we
-		 * cannot assert here that ip->i_delayed_blks == 0.
-		 */
-	}
-
-	lock = xfs_ilock_map_shared(ip);
-
-	/*
-	 * Don't let nex be bigger than the number of extents
-	 * we can have assuming alternating holes and real extents.
-	 */
-	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
-		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
-
-	bmapi_flags = xfs_bmapi_aflag(whichfork);
-	if (!(iflags & BMV_IF_PREALLOC))
-		bmapi_flags |= XFS_BMAPI_IGSTATE;
-
-	/*
-	 * Allocate enough space to handle "subnex" maps at a time.
-	 */
-	error = ENOMEM;
-	subnex = 16;
-	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL | KM_NOFS);
-	if (!map)
-		goto out_unlock_ilock;
-
-	bmv->bmv_entries = 0;
-
-	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0 &&
-	    (whichfork == XFS_ATTR_FORK || !(iflags & BMV_IF_DELALLOC))) {
-		error = 0;
-		goto out_free_map;
-	}
-
-	nexleft = nex;
-
-	do {
-		nmap = (nexleft > subnex) ? subnex : nexleft;
-		error = xfs_bmapi_read(ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
-				       XFS_BB_TO_FSB(mp, bmv->bmv_length),
-				       map, &nmap, bmapi_flags);
-		if (error)
-			goto out_free_map;
-		ASSERT(nmap <= subnex);
-
-		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
-			out[cur_ext].bmv_oflags = 0;
-			if (map[i].br_state == XFS_EXT_UNWRITTEN)
-				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
-			else if (map[i].br_startblock == DELAYSTARTBLOCK)
-				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
-			out[cur_ext].bmv_offset =
-				XFS_FSB_TO_BB(mp, map[i].br_startoff);
-			out[cur_ext].bmv_length =
-				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
-			out[cur_ext].bmv_unused1 = 0;
-			out[cur_ext].bmv_unused2 = 0;
-
-			/*
-			 * delayed allocation extents that start beyond EOF can
-			 * occur due to speculative EOF allocation when the
-			 * delalloc extent is larger than the largest freespace
-			 * extent at conversion time. These extents cannot be
-			 * converted by data writeback, so can exist here even
-			 * if we are not supposed to be finding delalloc
-			 * extents.
-			 */
-			if (map[i].br_startblock == DELAYSTARTBLOCK &&
-			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
-				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
-
-                        if (map[i].br_startblock == HOLESTARTBLOCK &&
-			    whichfork == XFS_ATTR_FORK) {
-				/* came to the end of attribute fork */
-				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
-				goto out_free_map;
-			}
-
-			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
-					prealloced, bmvend,
-					map[i].br_startblock))
-				goto out_free_map;
-
-			bmv->bmv_offset =
-				out[cur_ext].bmv_offset +
-				out[cur_ext].bmv_length;
-			bmv->bmv_length =
-				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
-
-			/*
-			 * In case we don't want to return the hole,
-			 * don't increase cur_ext so that we can reuse
-			 * it in the next loop.
-			 */
-			if ((iflags & BMV_IF_NO_HOLES) &&
-			    map[i].br_startblock == HOLESTARTBLOCK) {
-				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
-				continue;
-			}
-
-			nexleft--;
-			bmv->bmv_entries++;
-			cur_ext++;
-		}
-	} while (nmap && nexleft && bmv->bmv_length);
-
- out_free_map:
-	kmem_free(map);
- out_unlock_ilock:
-	xfs_iunlock_map_shared(ip, lock);
- out_unlock_iolock:
-	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
-
-	for (i = 0; i < cur_ext; i++) {
-		int full = 0;	/* user array is full */
-
-		/* format results & advance arg */
-		error = formatter(&arg, &out[i], &full);
-		if (error || full)
-			break;
-	}
-
-	if (is_vmalloc_addr(out))
-		kmem_free_large(out);
-	else
-		kmem_free(out);
-	return error;
-}
-
-/*
- * dead simple method of punching delalyed allocation blocks from a range in
- * the inode. Walks a block at a time so will be slow, but is only executed in
- * rare error cases so the overhead is not critical. This will alays punch out
- * both the start and end blocks, even if the ranges only partially overlap
- * them, so it is up to the caller to ensure that partial blocks are not
- * passed in.
- */
-int
-xfs_bmap_punch_delalloc_range(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		start_fsb,
-	xfs_fileoff_t		length)
-{
-	xfs_fileoff_t		remaining = length;
-	int			error = 0;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	do {
-		int		done;
-		xfs_bmbt_irec_t	imap;
-		int		nimaps = 1;
-		xfs_fsblock_t	firstblock;
-		xfs_bmap_free_t flist;
-
-		/*
-		 * Map the range first and check that it is a delalloc extent
-		 * before trying to unmap the range. Otherwise we will be
-		 * trying to remove a real extent (which requires a
-		 * transaction) or a hole, which is probably a bad idea...
-		 */
-		error = xfs_bmapi_read(ip, start_fsb, 1, &imap, &nimaps,
-				       XFS_BMAPI_ENTIRE);
-
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_alert(ip->i_mount,
-			"Failed delalloc mapping lookup ino %lld fsb %lld.",
-						ip->i_ino, start_fsb);
-			}
-			break;
-		}
-		if (!nimaps) {
-			/* nothing there */
-			goto next_block;
-		}
-		if (imap.br_startblock != DELAYSTARTBLOCK) {
-			/* been converted, ignore */
-			goto next_block;
-		}
-		WARN_ON(imap.br_blockcount == 0);
-
-		/*
-		 * Note: while we initialise the firstblock/flist pair, they
-		 * should never be used because blocks should never be
-		 * allocated or freed for a delalloc extent and hence we need
-		 * don't cancel or finish them after the xfs_bunmapi() call.
-		 */
-		xfs_bmap_init(&flist, &firstblock);
-		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
-					&flist, &done);
-		if (error)
-			break;
-
-		ASSERT(!flist.xbf_count && !flist.xbf_first);
-next_block:
-		start_fsb++;
-		remaining--;
-	} while(remaining > 0);
-
-	return error;
-}
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index 314dca1..8b2fe97 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
@@ -108,43 +108,6 @@ static inline void xfs_bmap_init(xfs_bmap_free_t *flp, xfs_fsblock_t *fbp)
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
@@ -207,23 +170,4 @@ int	xfs_check_nostate_extents(struct xfs_ifork *ifp, xfs_extnum_t idx,
 		xfs_extnum_t num);
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 
-#ifdef __KERNEL__
-/* bmap to userspace formatter - copy to user & advance pointer */
-typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
-
-int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
-		int *committed);
-int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
-		xfs_bmap_format_t formatter, void *arg);
-int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
-		int whichfork, int *eof);
-int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
-		int whichfork, int *count);
-int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
-		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
-
-xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
-
-#endif	/* __KERNEL__ */
-
 #endif	/* __XFS_BMAP_H__ */
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
new file mode 100644
index 0000000..8e48ddf
--- /dev/null
+++ b/fs/xfs/xfs_bmap_util.c
@@ -0,0 +1,834 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_bit.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+#include "xfs_da_btree.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_alloc_btree.h"
+#include "xfs_ialloc_btree.h"
+#include "xfs_dinode.h"
+#include "xfs_inode.h"
+#include "xfs_btree.h"
+#include "xfs_extfree_item.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
+#include "xfs_rtalloc.h"
+#include "xfs_error.h"
+#include "xfs_quota.h"
+#include "xfs_trans_space.h"
+#include "xfs_trace.h"
+
+/* Kernel only BMAP related definitions and functions */
+
+/*
+ * Convert the given file system block to a disk block.  We have to treat it
+ * differently based on whether the file is a real time file or not, because the
+ * bmap code does.
+ */
+xfs_daddr_t
+xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb)
+{
+	return (XFS_IS_REALTIME_INODE(ip) ? \
+		 (xfs_daddr_t)XFS_FSB_TO_BB((ip)->i_mount, (fsb)) : \
+		 XFS_FSB_TO_DADDR((ip)->i_mount, (fsb)));
+}
+
+/*
+ * Routine to be called at transaction's end by xfs_bmapi, xfs_bunmapi
+ * caller.  Frees all the extents that need freeing, which must be done
+ * last due to locking considerations.  We never free any extents in
+ * the first transaction.
+ *
+ * Return 1 if the given transaction was committed and a new one
+ * started, and 0 otherwise in the committed parameter.
+ */
+int						/* error */
+xfs_bmap_finish(
+	xfs_trans_t		**tp,		/* transaction pointer addr */
+	xfs_bmap_free_t		*flist,		/* i/o: list extents to free */
+	int			*committed)	/* xact committed or not */
+{
+	xfs_efd_log_item_t	*efd;		/* extent free data */
+	xfs_efi_log_item_t	*efi;		/* extent free intention */
+	int			error;		/* error return value */
+	xfs_bmap_free_item_t	*free;		/* free extent item */
+	unsigned int		logres;		/* new log reservation */
+	unsigned int		logcount;	/* new log count */
+	xfs_mount_t		*mp;		/* filesystem mount structure */
+	xfs_bmap_free_item_t	*next;		/* next item on free list */
+	xfs_trans_t		*ntp;		/* new transaction pointer */
+
+	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
+	if (flist->xbf_count == 0) {
+		*committed = 0;
+		return 0;
+	}
+	ntp = *tp;
+	efi = xfs_trans_get_efi(ntp, flist->xbf_count);
+	for (free = flist->xbf_first; free; free = free->xbfi_next)
+		xfs_trans_log_efi_extent(ntp, efi, free->xbfi_startblock,
+			free->xbfi_blockcount);
+	logres = ntp->t_log_res;
+	logcount = ntp->t_log_count;
+	ntp = xfs_trans_dup(*tp);
+	error = xfs_trans_commit(*tp, 0);
+	*tp = ntp;
+	*committed = 1;
+	/*
+	 * We have a new transaction, so we should return committed=1,
+	 * even though we're returning an error.
+	 */
+	if (error)
+		return error;
+
+	/*
+	 * transaction commit worked ok so we can drop the extra ticket
+	 * reference that we gained in xfs_trans_dup()
+	 */
+	xfs_log_ticket_put(ntp->t_ticket);
+
+	if ((error = xfs_trans_reserve(ntp, 0, logres, 0, XFS_TRANS_PERM_LOG_RES,
+			logcount)))
+		return error;
+	efd = xfs_trans_get_efd(ntp, efi, flist->xbf_count);
+	for (free = flist->xbf_first; free != NULL; free = next) {
+		next = free->xbfi_next;
+		if ((error = xfs_free_extent(ntp, free->xbfi_startblock,
+				free->xbfi_blockcount))) {
+			/*
+			 * The bmap free list will be cleaned up at a
+			 * higher level.  The EFI will be canceled when
+			 * this transaction is aborted.
+			 * Need to force shutdown here to make sure it
+			 * happens, since this transaction may not be
+			 * dirty yet.
+			 */
+			mp = ntp->t_mountp;
+			if (!XFS_FORCED_SHUTDOWN(mp))
+				xfs_force_shutdown(mp,
+						   (error == EFSCORRUPTED) ?
+						   SHUTDOWN_CORRUPT_INCORE :
+						   SHUTDOWN_META_IO_ERROR);
+			return error;
+		}
+		xfs_trans_log_efd_extent(ntp, efd, free->xbfi_startblock,
+			free->xbfi_blockcount);
+		xfs_bmap_del_free(flist, NULL, free);
+	}
+	return 0;
+}
+
+int
+xfs_bmap_rtalloc(
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
+{
+	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
+	int		error;		/* error return value */
+	xfs_mount_t	*mp;		/* mount point structure */
+	xfs_extlen_t	prod = 0;	/* product factor for allocators */
+	xfs_extlen_t	ralen = 0;	/* realtime allocation length */
+	xfs_extlen_t	align;		/* minimum allocation alignment */
+	xfs_rtblock_t	rtb;
+
+	mp = ap->ip->i_mount;
+	align = xfs_get_extsz_hint(ap->ip);
+	prod = align / mp->m_sb.sb_rextsize;
+	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
+					align, 1, ap->eof, 0,
+					ap->conv, &ap->offset, &ap->length);
+	if (error)
+		return error;
+	ASSERT(ap->length);
+	ASSERT(ap->length % mp->m_sb.sb_rextsize == 0);
+
+	/*
+	 * If the offset & length are not perfectly aligned
+	 * then kill prod, it will just get us in trouble.
+	 */
+	if (do_mod(ap->offset, align) || ap->length % align)
+		prod = 1;
+	/*
+	 * Set ralen to be the actual requested length in rtextents.
+	 */
+	ralen = ap->length / mp->m_sb.sb_rextsize;
+	/*
+	 * If the old value was close enough to MAXEXTLEN that
+	 * we rounded up to it, cut it back so it's valid again.
+	 * Note that if it's a really large request (bigger than
+	 * MAXEXTLEN), we don't hear about that number, and can't
+	 * adjust the starting point to match it.
+	 */
+	if (ralen * mp->m_sb.sb_rextsize >= MAXEXTLEN)
+		ralen = MAXEXTLEN / mp->m_sb.sb_rextsize;
+
+	/*
+	 * Lock out other modifications to the RT bitmap inode.
+	 */
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(ap->tp, mp->m_rbmip, XFS_ILOCK_EXCL);
+
+	/*
+	 * If it's an allocation to an empty file at offset 0,
+	 * pick an extent that will space things out in the rt area.
+	 */
+	if (ap->eof && ap->offset == 0) {
+		xfs_rtblock_t uninitialized_var(rtx); /* realtime extent no */
+
+		error = xfs_rtpick_extent(mp, ap->tp, ralen, &rtx);
+		if (error)
+			return error;
+		ap->blkno = rtx * mp->m_sb.sb_rextsize;
+	} else {
+		ap->blkno = 0;
+	}
+
+	xfs_bmap_adjacent(ap);
+
+	/*
+	 * Realtime allocation, done through xfs_rtallocate_extent.
+	 */
+	atype = ap->blkno == 0 ?  XFS_ALLOCTYPE_ANY_AG : XFS_ALLOCTYPE_NEAR_BNO;
+	do_div(ap->blkno, mp->m_sb.sb_rextsize);
+	rtb = ap->blkno;
+	ap->length = ralen;
+	if ((error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1, ap->length,
+				&ralen, atype, ap->wasdel, prod, &rtb)))
+		return error;
+	if (rtb == NULLFSBLOCK && prod > 1 &&
+	    (error = xfs_rtallocate_extent(ap->tp, ap->blkno, 1,
+					   ap->length, &ralen, atype,
+					   ap->wasdel, 1, &rtb)))
+		return error;
+	ap->blkno = rtb;
+	if (ap->blkno != NULLFSBLOCK) {
+		ap->blkno *= mp->m_sb.sb_rextsize;
+		ralen *= mp->m_sb.sb_rextsize;
+		ap->length = ralen;
+		ap->ip->i_d.di_nblocks += ralen;
+		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+		if (ap->wasdel)
+			ap->ip->i_delayed_blks -= ralen;
+		/*
+		 * Adjust the disk quota also. This was reserved
+		 * earlier.
+		 */
+		xfs_trans_mod_dquot_byino(ap->tp, ap->ip,
+			ap->wasdel ? XFS_TRANS_DQ_DELRTBCOUNT :
+					XFS_TRANS_DQ_RTBCOUNT, (long) ralen);
+	} else {
+		ap->length = 0;
+	}
+	return 0;
+}
+
+/*
+ * Stack switching interfaces for allocation
+ */
+static void
+xfs_bmapi_allocate_worker(
+	struct work_struct	*work)
+{
+	struct xfs_bmalloca	*args = container_of(work,
+						struct xfs_bmalloca, work);
+	unsigned long		pflags;
+
+	/* we are in a transaction context here */
+	current_set_flags_nested(&pflags, PF_FSTRANS);
+
+	args->result = __xfs_bmapi_allocate(args);
+	complete(args->done);
+
+	current_restore_flags_nested(&pflags, PF_FSTRANS);
+}
+
+/*
+ * Some allocation requests often come in with little stack to work on. Push
+ * them off to a worker thread so there is lots of stack to use. Otherwise just
+ * call directly to avoid the context switch overhead here.
+ */
+int
+xfs_bmapi_allocate(
+	struct xfs_bmalloca	*args)
+{
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	if (!args->stack_switch)
+		return __xfs_bmapi_allocate(args);
+
+
+	args->done = &done;
+	INIT_WORK_ONSTACK(&args->work, xfs_bmapi_allocate_worker);
+	queue_work(xfs_alloc_wq, &args->work);
+	wait_for_completion(&done);
+	return args->result;
+}
+
+/*
+ * Check if the endoff is outside the last extent. If so the caller will grow
+ * the allocation to a stripe unit boundary.  All offsets are considered outside
+ * the end of file for an empty fork, so 1 is returned in *eof in that case.
+ */
+int
+xfs_bmap_eof(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		endoff,
+	int			whichfork,
+	int			*eof)
+{
+	struct xfs_bmbt_irec	rec;
+	int			error;
+
+	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, eof);
+	if (error || *eof)
+		return error;
+
+	*eof = endoff >= rec.br_startoff + rec.br_blockcount;
+	return 0;
+}
+
+/*
+ * Extent tree block counting routines.
+ */
+
+/*
+ * Count leaf blocks given a range of extent records.
+ */
+STATIC void
+xfs_bmap_count_leaves(
+	xfs_ifork_t		*ifp,
+	xfs_extnum_t		idx,
+	int			numrecs,
+	int			*count)
+{
+	int		b;
+
+	for (b = 0; b < numrecs; b++) {
+		xfs_bmbt_rec_host_t *frp = xfs_iext_get_ext(ifp, idx + b);
+		*count += xfs_bmbt_get_blockcount(frp);
+	}
+}
+
+/*
+ * Count leaf blocks given a range of extent records originally
+ * in btree format.
+ */
+STATIC void
+xfs_bmap_disk_count_leaves(
+	struct xfs_mount	*mp,
+	struct xfs_btree_block	*block,
+	int			numrecs,
+	int			*count)
+{
+	int		b;
+	xfs_bmbt_rec_t	*frp;
+
+	for (b = 1; b <= numrecs; b++) {
+		frp = XFS_BMBT_REC_ADDR(mp, block, b);
+		*count += xfs_bmbt_disk_get_blockcount(frp);
+	}
+}
+
+/*
+ * Recursively walks each level of a btree
+ * to count total fsblocks is use.
+ */
+STATIC int                                     /* error */
+xfs_bmap_count_tree(
+	xfs_mount_t     *mp,            /* file system mount point */
+	xfs_trans_t     *tp,            /* transaction pointer */
+	xfs_ifork_t	*ifp,		/* inode fork pointer */
+	xfs_fsblock_t   blockno,	/* file system block number */
+	int             levelin,	/* level in btree */
+	int		*count)		/* Count of blocks */
+{
+	int			error;
+	xfs_buf_t		*bp, *nbp;
+	int			level = levelin;
+	__be64			*pp;
+	xfs_fsblock_t           bno = blockno;
+	xfs_fsblock_t		nextbno;
+	struct xfs_btree_block	*block, *nextblock;
+	int			numrecs;
+
+	error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp, XFS_BMAP_BTREE_REF,
+						&xfs_bmbt_buf_ops);
+	if (error)
+		return error;
+	*count += 1;
+	block = XFS_BUF_TO_BLOCK(bp);
+
+	if (--level) {
+		/* Not at node above leaves, count this level of nodes */
+		nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
+		while (nextbno != NULLFSBLOCK) {
+			error = xfs_btree_read_bufl(mp, tp, nextbno, 0, &nbp,
+						XFS_BMAP_BTREE_REF,
+						&xfs_bmbt_buf_ops);
+			if (error)
+				return error;
+			*count += 1;
+			nextblock = XFS_BUF_TO_BLOCK(nbp);
+			nextbno = be64_to_cpu(nextblock->bb_u.l.bb_rightsib);
+			xfs_trans_brelse(tp, nbp);
+		}
+
+		/* Dive to the next level */
+		pp = XFS_BMBT_PTR_ADDR(mp, block, 1, mp->m_bmap_dmxr[1]);
+		bno = be64_to_cpu(*pp);
+		if (unlikely((error =
+		     xfs_bmap_count_tree(mp, tp, ifp, bno, level, count)) < 0)) {
+			xfs_trans_brelse(tp, bp);
+			XFS_ERROR_REPORT("xfs_bmap_count_tree(1)",
+					 XFS_ERRLEVEL_LOW, mp);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+		xfs_trans_brelse(tp, bp);
+	} else {
+		/* count all level 1 nodes and their leaves */
+		for (;;) {
+			nextbno = be64_to_cpu(block->bb_u.l.bb_rightsib);
+			numrecs = be16_to_cpu(block->bb_numrecs);
+			xfs_bmap_disk_count_leaves(mp, block, numrecs, count);
+			xfs_trans_brelse(tp, bp);
+			if (nextbno == NULLFSBLOCK)
+				break;
+			bno = nextbno;
+			error = xfs_btree_read_bufl(mp, tp, bno, 0, &bp,
+						XFS_BMAP_BTREE_REF,
+						&xfs_bmbt_buf_ops);
+			if (error)
+				return error;
+			*count += 1;
+			block = XFS_BUF_TO_BLOCK(bp);
+		}
+	}
+	return 0;
+}
+
+/*
+ * Count fsblocks of the given fork.
+ */
+int						/* error */
+xfs_bmap_count_blocks(
+	xfs_trans_t		*tp,		/* transaction pointer */
+	xfs_inode_t		*ip,		/* incore inode */
+	int			whichfork,	/* data or attr fork */
+	int			*count)		/* out: count of blocks */
+{
+	struct xfs_btree_block	*block;	/* current btree block */
+	xfs_fsblock_t		bno;	/* block # of "block" */
+	xfs_ifork_t		*ifp;	/* fork structure */
+	int			level;	/* btree level, for checking */
+	xfs_mount_t		*mp;	/* file system mount structure */
+	__be64			*pp;	/* pointer to block address */
+
+	bno = NULLFSBLOCK;
+	mp = ip->i_mount;
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if ( XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS ) {
+		xfs_bmap_count_leaves(ifp, 0,
+			ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t),
+			count);
+		return 0;
+	}
+
+	/*
+	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
+	 */
+	block = ifp->if_broot;
+	level = be16_to_cpu(block->bb_level);
+	ASSERT(level > 0);
+	pp = XFS_BMAP_BROOT_PTR_ADDR(mp, block, 1, ifp->if_broot_bytes);
+	bno = be64_to_cpu(*pp);
+	ASSERT(bno != NULLDFSBNO);
+	ASSERT(XFS_FSB_TO_AGNO(mp, bno) < mp->m_sb.sb_agcount);
+	ASSERT(XFS_FSB_TO_AGBNO(mp, bno) < mp->m_sb.sb_agblocks);
+
+	if (unlikely(xfs_bmap_count_tree(mp, tp, ifp, bno, level, count) < 0)) {
+		XFS_ERROR_REPORT("xfs_bmap_count_blocks(2)", XFS_ERRLEVEL_LOW,
+				 mp);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+	return 0;
+}
+
+/*
+ * returns 1 for success, 0 if we failed to map the extent.
+ */
+STATIC int
+xfs_getbmapx_fix_eof_hole(
+	xfs_inode_t		*ip,		/* xfs incore inode pointer */
+	struct getbmapx		*out,		/* output structure */
+	int			prealloced,	/* this is a file with
+						 * preallocated data space */
+	__int64_t		end,		/* last block requested */
+	xfs_fsblock_t		startblock)
+{
+	__int64_t		fixlen;
+	xfs_mount_t		*mp;		/* file system mount point */
+	xfs_ifork_t		*ifp;		/* inode fork pointer */
+	xfs_extnum_t		lastx;		/* last extent pointer */
+	xfs_fileoff_t		fileblock;
+
+	if (startblock == HOLESTARTBLOCK) {
+		mp = ip->i_mount;
+		out->bmv_block = -1;
+		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, XFS_ISIZE(ip)));
+		fixlen -= out->bmv_offset;
+		if (prealloced && out->bmv_offset + out->bmv_length == end) {
+			/* Came to hole at EOF. Trim it. */
+			if (fixlen <= 0)
+				return 0;
+			out->bmv_length = fixlen;
+		}
+	} else {
+		if (startblock == DELAYSTARTBLOCK)
+			out->bmv_block = -2;
+		else
+			out->bmv_block = xfs_fsb_to_db(ip, startblock);
+		fileblock = XFS_BB_TO_FSB(ip->i_mount, out->bmv_offset);
+		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+		if (xfs_iext_bno_to_ext(ifp, fileblock, &lastx) &&
+		   (lastx == (ifp->if_bytes / (uint)sizeof(xfs_bmbt_rec_t))-1))
+			out->bmv_oflags |= BMV_OF_LAST;
+	}
+
+	return 1;
+}
+
+/*
+ * Get inode's extents as described in bmv, and format for output.
+ * Calls formatter to fill the user's buffer until all extents
+ * are mapped, until the passed-in bmv->bmv_count slots have
+ * been filled, or until the formatter short-circuits the loop,
+ * if it is tracking filled-in extents on its own.
+ */
+int						/* error code */
+xfs_getbmap(
+	xfs_inode_t		*ip,
+	struct getbmapx		*bmv,		/* user bmap structure */
+	xfs_bmap_format_t	formatter,	/* format to user */
+	void			*arg)		/* formatter arg */
+{
+	__int64_t		bmvend;		/* last block requested */
+	int			error = 0;	/* return value */
+	__int64_t		fixlen;		/* length for -1 case */
+	int			i;		/* extent number */
+	int			lock;		/* lock state */
+	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
+	xfs_mount_t		*mp;		/* file system mount point */
+	int			nex;		/* # of user extents can do */
+	int			nexleft;	/* # of user extents left */
+	int			subnex;		/* # of bmapi's can do */
+	int			nmap;		/* number of map entries */
+	struct getbmapx		*out;		/* output structure */
+	int			whichfork;	/* data or attr fork */
+	int			prealloced;	/* this is a file with
+						 * preallocated data space */
+	int			iflags;		/* interface flags */
+	int			bmapi_flags;	/* flags for xfs_bmapi */
+	int			cur_ext = 0;
+
+	mp = ip->i_mount;
+	iflags = bmv->bmv_iflags;
+	whichfork = iflags & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
+
+	if (whichfork == XFS_ATTR_FORK) {
+		if (XFS_IFORK_Q(ip)) {
+			if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS &&
+			    ip->i_d.di_aformat != XFS_DINODE_FMT_BTREE &&
+			    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
+				return XFS_ERROR(EINVAL);
+		} else if (unlikely(
+			   ip->i_d.di_aformat != 0 &&
+			   ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS)) {
+			XFS_ERROR_REPORT("xfs_getbmap", XFS_ERRLEVEL_LOW,
+					 ip->i_mount);
+			return XFS_ERROR(EFSCORRUPTED);
+		}
+
+		prealloced = 0;
+		fixlen = 1LL << 32;
+	} else {
+		if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
+		    ip->i_d.di_format != XFS_DINODE_FMT_BTREE &&
+		    ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+			return XFS_ERROR(EINVAL);
+
+		if (xfs_get_extsz_hint(ip) ||
+		    ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC|XFS_DIFLAG_APPEND)){
+			prealloced = 1;
+			fixlen = mp->m_super->s_maxbytes;
+		} else {
+			prealloced = 0;
+			fixlen = XFS_ISIZE(ip);
+		}
+	}
+
+	if (bmv->bmv_length == -1) {
+		fixlen = XFS_FSB_TO_BB(mp, XFS_B_TO_FSB(mp, fixlen));
+		bmv->bmv_length =
+			max_t(__int64_t, fixlen - bmv->bmv_offset, 0);
+	} else if (bmv->bmv_length == 0) {
+		bmv->bmv_entries = 0;
+		return 0;
+	} else if (bmv->bmv_length < 0) {
+		return XFS_ERROR(EINVAL);
+	}
+
+	nex = bmv->bmv_count - 1;
+	if (nex <= 0)
+		return XFS_ERROR(EINVAL);
+	bmvend = bmv->bmv_offset + bmv->bmv_length;
+
+
+	if (bmv->bmv_count > ULONG_MAX / sizeof(struct getbmapx))
+		return XFS_ERROR(ENOMEM);
+	out = kmem_zalloc(bmv->bmv_count * sizeof(struct getbmapx), KM_MAYFAIL);
+	if (!out) {
+		out = kmem_zalloc_large(bmv->bmv_count *
+					sizeof(struct getbmapx));
+		if (!out)
+			return XFS_ERROR(ENOMEM);
+	}
+
+	xfs_ilock(ip, XFS_IOLOCK_SHARED);
+	if (whichfork == XFS_DATA_FORK && !(iflags & BMV_IF_DELALLOC)) {
+		if (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size) {
+			error = -filemap_write_and_wait(VFS_I(ip)->i_mapping);
+			if (error)
+				goto out_unlock_iolock;
+		}
+		/*
+		 * even after flushing the inode, there can still be delalloc
+		 * blocks on the inode beyond EOF due to speculative
+		 * preallocation. These are not removed until the release
+		 * function is called or the inode is inactivated. Hence we
+		 * cannot assert here that ip->i_delayed_blks == 0.
+		 */
+	}
+
+	lock = xfs_ilock_map_shared(ip);
+
+	/*
+	 * Don't let nex be bigger than the number of extents
+	 * we can have assuming alternating holes and real extents.
+	 */
+	if (nex > XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1)
+		nex = XFS_IFORK_NEXTENTS(ip, whichfork) * 2 + 1;
+
+	bmapi_flags = xfs_bmapi_aflag(whichfork);
+	if (!(iflags & BMV_IF_PREALLOC))
+		bmapi_flags |= XFS_BMAPI_IGSTATE;
+
+	/*
+	 * Allocate enough space to handle "subnex" maps at a time.
+	 */
+	error = ENOMEM;
+	subnex = 16;
+	map = kmem_alloc(subnex * sizeof(*map), KM_MAYFAIL | KM_NOFS);
+	if (!map)
+		goto out_unlock_ilock;
+
+	bmv->bmv_entries = 0;
+
+	if (XFS_IFORK_NEXTENTS(ip, whichfork) == 0 &&
+	    (whichfork == XFS_ATTR_FORK || !(iflags & BMV_IF_DELALLOC))) {
+		error = 0;
+		goto out_free_map;
+	}
+
+	nexleft = nex;
+
+	do {
+		nmap = (nexleft > subnex) ? subnex : nexleft;
+		error = xfs_bmapi_read(ip, XFS_BB_TO_FSBT(mp, bmv->bmv_offset),
+				       XFS_BB_TO_FSB(mp, bmv->bmv_length),
+				       map, &nmap, bmapi_flags);
+		if (error)
+			goto out_free_map;
+		ASSERT(nmap <= subnex);
+
+		for (i = 0; i < nmap && nexleft && bmv->bmv_length; i++) {
+			out[cur_ext].bmv_oflags = 0;
+			if (map[i].br_state == XFS_EXT_UNWRITTEN)
+				out[cur_ext].bmv_oflags |= BMV_OF_PREALLOC;
+			else if (map[i].br_startblock == DELAYSTARTBLOCK)
+				out[cur_ext].bmv_oflags |= BMV_OF_DELALLOC;
+			out[cur_ext].bmv_offset =
+				XFS_FSB_TO_BB(mp, map[i].br_startoff);
+			out[cur_ext].bmv_length =
+				XFS_FSB_TO_BB(mp, map[i].br_blockcount);
+			out[cur_ext].bmv_unused1 = 0;
+			out[cur_ext].bmv_unused2 = 0;
+
+			/*
+			 * delayed allocation extents that start beyond EOF can
+			 * occur due to speculative EOF allocation when the
+			 * delalloc extent is larger than the largest freespace
+			 * extent at conversion time. These extents cannot be
+			 * converted by data writeback, so can exist here even
+			 * if we are not supposed to be finding delalloc
+			 * extents.
+			 */
+			if (map[i].br_startblock == DELAYSTARTBLOCK &&
+			    map[i].br_startoff <= XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+				ASSERT((iflags & BMV_IF_DELALLOC) != 0);
+
+                        if (map[i].br_startblock == HOLESTARTBLOCK &&
+			    whichfork == XFS_ATTR_FORK) {
+				/* came to the end of attribute fork */
+				out[cur_ext].bmv_oflags |= BMV_OF_LAST;
+				goto out_free_map;
+			}
+
+			if (!xfs_getbmapx_fix_eof_hole(ip, &out[cur_ext],
+					prealloced, bmvend,
+					map[i].br_startblock))
+				goto out_free_map;
+
+			bmv->bmv_offset =
+				out[cur_ext].bmv_offset +
+				out[cur_ext].bmv_length;
+			bmv->bmv_length =
+				max_t(__int64_t, 0, bmvend - bmv->bmv_offset);
+
+			/*
+			 * In case we don't want to return the hole,
+			 * don't increase cur_ext so that we can reuse
+			 * it in the next loop.
+			 */
+			if ((iflags & BMV_IF_NO_HOLES) &&
+			    map[i].br_startblock == HOLESTARTBLOCK) {
+				memset(&out[cur_ext], 0, sizeof(out[cur_ext]));
+				continue;
+			}
+
+			nexleft--;
+			bmv->bmv_entries++;
+			cur_ext++;
+		}
+	} while (nmap && nexleft && bmv->bmv_length);
+
+ out_free_map:
+	kmem_free(map);
+ out_unlock_ilock:
+	xfs_iunlock_map_shared(ip, lock);
+ out_unlock_iolock:
+	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
+	for (i = 0; i < cur_ext; i++) {
+		int full = 0;	/* user array is full */
+
+		/* format results & advance arg */
+		error = formatter(&arg, &out[i], &full);
+		if (error || full)
+			break;
+	}
+
+	if (is_vmalloc_addr(out))
+		kmem_free_large(out);
+	else
+		kmem_free(out);
+	return error;
+}
+
+/*
+ * dead simple method of punching delalyed allocation blocks from a range in
+ * the inode. Walks a block at a time so will be slow, but is only executed in
+ * rare error cases so the overhead is not critical. This will alays punch out
+ * both the start and end blocks, even if the ranges only partially overlap
+ * them, so it is up to the caller to ensure that partial blocks are not
+ * passed in.
+ */
+int
+xfs_bmap_punch_delalloc_range(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		start_fsb,
+	xfs_fileoff_t		length)
+{
+	xfs_fileoff_t		remaining = length;
+	int			error = 0;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	do {
+		int		done;
+		xfs_bmbt_irec_t	imap;
+		int		nimaps = 1;
+		xfs_fsblock_t	firstblock;
+		xfs_bmap_free_t flist;
+
+		/*
+		 * Map the range first and check that it is a delalloc extent
+		 * before trying to unmap the range. Otherwise we will be
+		 * trying to remove a real extent (which requires a
+		 * transaction) or a hole, which is probably a bad idea...
+		 */
+		error = xfs_bmapi_read(ip, start_fsb, 1, &imap, &nimaps,
+				       XFS_BMAPI_ENTIRE);
+
+		if (error) {
+			/* something screwed, just bail */
+			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+				xfs_alert(ip->i_mount,
+			"Failed delalloc mapping lookup ino %lld fsb %lld.",
+						ip->i_ino, start_fsb);
+			}
+			break;
+		}
+		if (!nimaps) {
+			/* nothing there */
+			goto next_block;
+		}
+		if (imap.br_startblock != DELAYSTARTBLOCK) {
+			/* been converted, ignore */
+			goto next_block;
+		}
+		WARN_ON(imap.br_blockcount == 0);
+
+		/*
+		 * Note: while we initialise the firstblock/flist pair, they
+		 * should never be used because blocks should never be
+		 * allocated or freed for a delalloc extent and hence we need
+		 * don't cancel or finish them after the xfs_bunmapi() call.
+		 */
+		xfs_bmap_init(&flist, &firstblock);
+		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
+					&flist, &done);
+		if (error)
+			break;
+
+		ASSERT(!flist.xbf_count && !flist.xbf_first);
+next_block:
+		start_fsb++;
+		remaining--;
+	} while(remaining > 0);
+
+	return error;
+}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
new file mode 100644
index 0000000..004fe4b
--- /dev/null
+++ b/fs/xfs/xfs_bmap_util.h
@@ -0,0 +1,96 @@
+/*
+ * Copyright (c) 2000-2006 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_BMAP_UTIL_H__
+#define	__XFS_BMAP_UTIL_H__
+
+/* Kernel only BMAP related definitions and functions */
+
+struct xfs_bmbt_irec;
+struct xfs_ifork;
+struct xfs_inode;
+struct xfs_mount;
+struct xfs_trans;
+
+/*
+ * Argument structure for xfs_bmap_alloc.
+ */
+struct xfs_bmalloca {
+	xfs_fsblock_t		*firstblock; /* i/o first block allocated */
+	struct xfs_bmap_free	*flist;	/* bmap freelist */
+	struct xfs_trans	*tp;	/* transaction pointer */
+	struct xfs_inode	*ip;	/* incore inode pointer */
+	struct xfs_bmbt_irec	prev;	/* extent before the new one */
+	struct xfs_bmbt_irec	got;	/* extent after, or delayed */
+
+	xfs_fileoff_t		offset;	/* offset in file filling in */
+	xfs_extlen_t		length;	/* i/o length asked/allocated */
+	xfs_fsblock_t		blkno;	/* starting block of new extent */
+
+	struct xfs_btree_cur	*cur;	/* btree cursor */
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
+	struct completion	*done;
+	struct work_struct	work;
+	int			result;
+};
+
+int	xfs_bmap_finish(struct xfs_trans **tp, struct xfs_bmap_free *flist,
+			int *committed);
+int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
+int	xfs_bmapi_allocate(struct xfs_bmalloca *args);
+int	__xfs_bmapi_allocate(struct xfs_bmalloca *args);
+int	xfs_bmap_eof(struct xfs_inode *ip, xfs_fileoff_t endoff,
+		     int whichfork, int *eof);
+int	xfs_bmap_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
+			      int whichfork, int *count);
+int	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
+		xfs_fileoff_t start_fsb, xfs_fileoff_t length);
+
+/* bmap to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_bmap_format_t)(void **, struct getbmapx *, int *);
+int	xfs_getbmap(struct xfs_inode *ip, struct getbmapx *bmv,
+		xfs_bmap_format_t formatter, void *arg);
+
+/* functions in xfs_bmap.c that are only needed by xfs_bmap_util.c */
+void	xfs_bmap_del_free(struct xfs_bmap_free *flist,
+			  struct xfs_bmap_free_item *prev,
+			  struct xfs_bmap_free_item *free);
+int	xfs_bmap_extsize_align(struct xfs_mount *mp, struct xfs_bmbt_irec *gotp,
+			       struct xfs_bmbt_irec *prevp, xfs_extlen_t extsz,
+			       int rt, int eof, int delay, int convert,
+			       xfs_fileoff_t *offp, xfs_extlen_t *lenp);
+void	xfs_bmap_adjacent(struct xfs_bmalloca *ap);
+int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+			     int whichfork, struct xfs_bmbt_irec *rec,
+			     int *is_empty);
+
+xfs_daddr_t xfs_fsb_to_db(struct xfs_inode *ip, xfs_fsblock_t fsb);
+
+#endif	/* __XFS_BMAP_UTIL_H__ */
diff --git a/fs/xfs/xfs_dfrag.c b/fs/xfs/xfs_dfrag.c
index e36445c..815dace 100644
--- a/fs/xfs/xfs_dfrag.c
+++ b/fs/xfs/xfs_dfrag.c
@@ -31,6 +31,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_itable.h"
 #include "xfs_dfrag.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 36e1cf3..e90e123 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -29,6 +29,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 9eae097..d0e8890 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -26,6 +26,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_utils.h"
 #include "xfs_mru_cache.h"
@@ -668,8 +669,8 @@ exit:
  */
 int
 xfs_filestream_new_ag(
-	xfs_bmalloca_t	*ap,
-	xfs_agnumber_t	*agp)
+	struct xfs_bmalloca	*ap,
+	xfs_agnumber_t		*agp)
 {
 	int		flags, err;
 	xfs_inode_t	*ip, *pip = NULL;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fcda5b3..1029f56 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -39,6 +39,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_utils.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3124efa..7c27538 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -33,6 +33,7 @@
 #include "xfs_error.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_dfrag.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index e4577f8..b04a60f 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -33,6 +33,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index e441698..17b70f0 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -30,6 +30,7 @@
 #include "xfs_dinode.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
diff --git a/fs/xfs/xfs_rename.c b/fs/xfs/xfs_rename.c
index 4715c7f..68cb725 100644
--- a/fs/xfs/xfs_rename.c
+++ b/fs/xfs/xfs_rename.c
@@ -31,6 +31,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_utils.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index bb4f7a1..084caa8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -29,6 +29,7 @@
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_rtalloc.h"
 #include "xfs_fsops.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 18f24de..1ce2756 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -35,6 +35,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_utils.h"
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 5a1537e..ed6446e 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -37,6 +37,7 @@
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trans_space.h"
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 221e2e3..dc81a8d 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -38,6 +38,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_error.h"
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
