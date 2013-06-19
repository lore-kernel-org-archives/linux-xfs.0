Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A438D29E0A
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:53:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 57A84304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:53:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	0J7ZOG2LGHahvD08 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:53:46 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAOB-00031H-KF
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:59 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpANr-00007V-67
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:52:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 50/60] xfs: create xfs_bmap_util.[ch]
Date: Wed, 19 Jun 2013 14:50:58 +1000
Message-Id: <1371617468-32559-51-git-send-email-david@fromorbit.com>
In-Reply-To: <1371617468-32559-1-git-send-email-david@fromorbit.com>
References: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/Makefile          |    1 +
 fs/xfs/xfs_aops.c        |    1 +
 fs/xfs/xfs_attr.c        |    1 +
 fs/xfs/xfs_attr_remote.c |    1 +
 fs/xfs/xfs_bmap.c        |  448 +------------------------------------------
 fs/xfs/xfs_bmap.h        |   50 -----
 fs/xfs/xfs_bmap_util.c   |  478 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_util.h   |   89 +++++++++
 fs/xfs/xfs_dquot.c       |    1 +
 fs/xfs/xfs_extent_ops.c  |    1 +
 fs/xfs/xfs_filestream.c  |    5 +-
 fs/xfs/xfs_inode_ops.c   |    1 +
 fs/xfs/xfs_iomap.c       |    1 +
 fs/xfs/xfs_rtalloc.c     |    1 +
 fs/xfs/xfs_symlink.c     |    1 +
 fs/xfs/xfs_trans_resv.c  |    1 +
 16 files changed, 590 insertions(+), 491 deletions(-)
 create mode 100644 fs/xfs/xfs_bmap_util.c
 create mode 100644 fs/xfs/xfs_bmap_util.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5fbd5a1..c5c38a9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -30,6 +30,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_attr_inactive.o \
 				   xfs_attr_list.o \
 				   xfs_bit.o \
+				   xfs_bmap_util.o \
 				   xfs_buf.o \
 				   xfs_dir2_readdir.o \
 				   xfs_discard.o \
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 82d2bfd..69fdde8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -30,6 +30,7 @@
 #include "xfs_iomap.h"
 #include "xfs_trace.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include <linux/aio.h>
 #include <linux/gfp.h>
 #include <linux/mpage.h>
diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index f61d2bb..f4cc54c 100644
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
index b8ab302..712a502 100644
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
index 8f57042..2be9a04 100644
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
@@ -108,19 +109,6 @@ xfs_bmap_compute_maxlevels(
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
@@ -263,173 +251,6 @@ xfs_bmap_forkoff_reset(
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
 
@@ -823,7 +644,7 @@ xfs_bmap_add_free(
  * Remove the entry "free" from the free item list.  Prev points to the
  * previous entry, unless "free" is the head of the list.
  */
-STATIC void
+void
 xfs_bmap_del_free(
 	xfs_bmap_free_t		*flist,	/* free item list header */
 	xfs_bmap_free_item_t	*prev,	/* previous item on list, if any */
@@ -837,92 +658,6 @@ xfs_bmap_del_free(
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
@@ -1863,7 +1598,7 @@ xfs_bmap_last_before(
 	return 0;
 }
 
-STATIC int
+int
 xfs_bmap_last_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
@@ -1927,29 +1662,6 @@ xfs_bmap_isaeof(
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
@@ -3488,7 +3200,7 @@ done:
 /*
  * Adjust the size of the new extent based on di_extsize and rt extsize.
  */
-STATIC int
+int
 xfs_bmap_extsize_align(
 	xfs_mount_t	*mp,
 	xfs_bmbt_irec_t	*gotp,		/* next extent pointer */
@@ -3650,9 +3362,9 @@ xfs_bmap_extsize_align(
 
 #define XFS_ALLOC_GAP_UNITS	4
 
-STATIC void
+void
 xfs_bmap_adjacent(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_fsblock_t	adjust;		/* adjustment to block numbers */
 	xfs_agnumber_t	fb_agno;	/* ag number of ap->firstblock */
@@ -3799,109 +3511,6 @@ xfs_bmap_adjacent(
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
@@ -4018,7 +3627,7 @@ xfs_bmap_btalloc_nullfb(
 
 STATIC int
 xfs_bmap_btalloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	xfs_mount_t	*mp;		/* mount point structure */
 	xfs_alloctype_t	atype = 0;	/* type for allocation routines */
@@ -4250,7 +3859,7 @@ xfs_bmap_btalloc(
  */
 STATIC int
 xfs_bmap_alloc(
-	xfs_bmalloca_t	*ap)		/* bmap alloc argument struct */
+	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
@@ -4638,7 +4247,7 @@ xfs_bmapi_delay(
 }
 
 
-STATIC int
+int
 __xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
 {
@@ -4753,45 +4362,6 @@ __xfs_bmapi_allocate(
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
diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
index a2e50c6..a64d6f7 100644
--- a/fs/xfs/xfs_bmap.h
+++ b/fs/xfs/xfs_bmap.h
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
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
new file mode 100644
index 0000000..0571a1c
--- /dev/null
+++ b/fs/xfs/xfs_bmap_util.c
@@ -0,0 +1,478 @@
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
+#include "xfs_types.h"
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
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
new file mode 100644
index 0000000..cb1493a
--- /dev/null
+++ b/fs/xfs/xfs_bmap_util.h
@@ -0,0 +1,89 @@
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
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 044e97a..464f91c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -28,6 +28,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
diff --git a/fs/xfs/xfs_extent_ops.c b/fs/xfs/xfs_extent_ops.c
index 170b10b..f7e1f14 100644
--- a/fs/xfs/xfs_extent_ops.c
+++ b/fs/xfs/xfs_extent_ops.c
@@ -38,6 +38,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_acl.h"
 #include "xfs_attr.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 86cd468..4c71797 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -26,6 +26,7 @@
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_alloc.h"
 #include "xfs_mru_cache.h"
 #include "xfs_filestream.h"
@@ -667,8 +668,8 @@ exit:
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
diff --git a/fs/xfs/xfs_inode_ops.c b/fs/xfs/xfs_inode_ops.c
index b4d6948..2777741 100644
--- a/fs/xfs/xfs_inode_ops.c
+++ b/fs/xfs/xfs_inode_ops.c
@@ -44,6 +44,7 @@
 #include "xfs_alloc.h"
 #include "xfs_ialloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_filestream.h"
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index effd1bc4..770f75c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -32,6 +32,7 @@
 #include "xfs_inode_item.h"
 #include "xfs_btree.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
 #include "xfs_itable.h"
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 19b738f..46408df 100644
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
index bed61a5..6d30954 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -34,6 +34,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_alloc.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
index 91c6f42..1dc3a43 100644
--- a/fs/xfs/xfs_trans_resv.c
+++ b/fs/xfs/xfs_trans_resv.c
@@ -37,6 +37,7 @@
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
 #include "xfs_bmap.h"
+#include "xfs_bmap_util.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trans_priv.h"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
