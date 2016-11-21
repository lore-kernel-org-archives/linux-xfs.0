Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59020 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754386AbcKUQjo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2016 11:39:44 -0500
Received: from 80-109-146-114.cable.dynamic.surfer.at ([80.109.146.114] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c8rd9-0001nD-Hh
        for linux-xfs@vger.kernel.org; Mon, 21 Nov 2016 16:39:44 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/14] xfs: remove xfs_bmap_search_extents
Date: Mon, 21 Nov 2016 17:38:55 +0100
Message-Id: <1479746336-10986-14-git-send-email-hch@lst.de>
In-Reply-To: <1479746336-10986-1-git-send-email-hch@lst.de>
References: <1479746336-10986-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Now that all users are gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 91 ------------------------------------------------
 fs/xfs/libxfs/xfs_bmap.h |  4 ---
 2 files changed, 95 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f5de137..23cf045 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1370,97 +1370,6 @@ xfs_bmap_read_extents(
 	return -EFSCORRUPTED;
 }
 
-
-/*
- * Search the extent records for the entry containing block bno.
- * If bno lies in a hole, point to the next entry.  If bno lies
- * past eof, *eofp will be set, and *prevp will contain the last
- * entry (null if none).  Else, *lastxp will be set to the index
- * of the found entry; *gotp will contain the entry.
- */
-STATIC xfs_bmbt_rec_host_t *		/* pointer to found extent entry */
-xfs_bmap_search_multi_extents(
-	xfs_ifork_t	*ifp,		/* inode fork pointer */
-	xfs_fileoff_t	bno,		/* block number searched for */
-	int		*eofp,		/* out: end of file found */
-	xfs_extnum_t	*lastxp,	/* out: last extent index */
-	xfs_bmbt_irec_t	*gotp,		/* out: extent entry found */
-	xfs_bmbt_irec_t	*prevp)		/* out: previous extent entry found */
-{
-	xfs_bmbt_rec_host_t *ep;		/* extent record pointer */
-	xfs_extnum_t	lastx;		/* last extent index */
-
-	/*
-	 * Initialize the extent entry structure to catch access to
-	 * uninitialized br_startblock field.
-	 */
-	gotp->br_startoff = 0xffa5a5a5a5a5a5a5LL;
-	gotp->br_blockcount = 0xa55a5a5a5a5a5a5aLL;
-	gotp->br_state = XFS_EXT_INVALID;
-	gotp->br_startblock = 0xffffa5a5a5a5a5a5LL;
-	prevp->br_startoff = NULLFILEOFF;
-
-	ep = xfs_iext_bno_to_ext(ifp, bno, &lastx);
-	if (lastx > 0) {
-		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, lastx - 1), prevp);
-	}
-	if (lastx < xfs_iext_count(ifp)) {
-		xfs_bmbt_get_all(ep, gotp);
-		*eofp = 0;
-	} else {
-		if (lastx > 0) {
-			*gotp = *prevp;
-		}
-		*eofp = 1;
-		ep = NULL;
-	}
-	*lastxp = lastx;
-	return ep;
-}
-
-/*
- * Search the extents list for the inode, for the extent containing bno.
- * If bno lies in a hole, point to the next entry.  If bno lies past eof,
- * *eofp will be set, and *prevp will contain the last entry (null if none).
- * Else, *lastxp will be set to the index of the found
- * entry; *gotp will contain the entry.
- */
-xfs_bmbt_rec_host_t *                 /* pointer to found extent entry */
-xfs_bmap_search_extents(
-	xfs_inode_t     *ip,            /* incore inode pointer */
-	xfs_fileoff_t   bno,            /* block number searched for */
-	int             fork,      	/* data or attr fork */
-	int             *eofp,          /* out: end of file found */
-	xfs_extnum_t    *lastxp,        /* out: last extent index */
-	xfs_bmbt_irec_t *gotp,          /* out: extent entry found */
-	xfs_bmbt_irec_t *prevp)         /* out: previous extent entry found */
-{
-	xfs_ifork_t	*ifp;		/* inode fork pointer */
-	xfs_bmbt_rec_host_t  *ep;            /* extent record pointer */
-
-	XFS_STATS_INC(ip->i_mount, xs_look_exlist);
-	ifp = XFS_IFORK_PTR(ip, fork);
-
-	ep = xfs_bmap_search_multi_extents(ifp, bno, eofp, lastxp, gotp, prevp);
-
-	if (unlikely(!(gotp->br_startblock) && (*lastxp != NULLEXTNUM) &&
-		     !(XFS_IS_REALTIME_INODE(ip) && fork == XFS_DATA_FORK))) {
-		xfs_alert_tag(ip->i_mount, XFS_PTAG_FSBLOCK_ZERO,
-				"Access to block zero in inode %llu "
-				"start_block: %llx start_off: %llx "
-				"blkcnt: %llx extent-state: %x lastx: %x",
-			(unsigned long long)ip->i_ino,
-			(unsigned long long)gotp->br_startblock,
-			(unsigned long long)gotp->br_startoff,
-			(unsigned long long)gotp->br_blockcount,
-			gotp->br_state, *lastxp);
-		*lastxp = NULLEXTNUM;
-		*eofp = 1;
-		return NULL;
-	}
-	return ep;
-}
-
 /*
  * Returns the file-relative block number of the first unused block(s)
  * in the file with at least "len" logically contiguous blocks free.
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index e3c2b5a..ffed1f9 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -237,10 +237,6 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		struct xfs_defer_ops *dfops, enum shift_direction direction,
 		int num_exts);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
-struct xfs_bmbt_rec_host *
-	xfs_bmap_search_extents(struct xfs_inode *ip, xfs_fileoff_t bno,
-		int fork, int *eofp, xfs_extnum_t *lastxp,
-		struct xfs_bmbt_irec *gotp, struct xfs_bmbt_irec *prevp);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t aoff, xfs_filblks_t len,
 		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
-- 
2.1.4

