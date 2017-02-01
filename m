Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46814 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdBAVmz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Feb 2017 16:42:55 -0500
Received: from clnet-p099-196.ikbnet.co.at ([83.175.99.196] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1cZ2g1-0003xI-Tu
        for linux-xfs@vger.kernel.org; Wed, 01 Feb 2017 21:42:54 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/4] xfs: go straight to real allocations for direct I/O COW writes
Date: Wed,  1 Feb 2017 22:42:38 +0100
Message-Id: <1485985359-971-4-git-send-email-hch@lst.de>
In-Reply-To: <1485985359-971-1-git-send-email-hch@lst.de>
References: <1485985359-971-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

When we allocate COW fork blocks for direct I/O writes we currently first
create a delayed allocation, and then convert it to a real allocation
once we've got the delayed one.

As there is no good reason for that this patch instead makes use call
xfs_bmapi_write from the COW allocation path.  The only interesting bits
are a few tweaks the low-level allocator to allow for this, most notably
the need to remove the call to xfs_bmap_extsize_align for the cowextsize
in xfs_bmap_btalloc - for the existing convert case it's a no-op, but
for the direct allocation case it would blow up our block reservation
way beyond what we reserved for the transaction.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  3 +-
 fs/xfs/xfs_reflink.c     | 94 +++++++++++++++++++++++++++++++++---------------
 2 files changed, 68 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1566e9d..2b4ad84 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2909,13 +2909,14 @@ xfs_bmap_add_extent_hole_real(
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
 	       !(bma->cur->bc_private.b.flags & XFS_BTCUR_BPRV_WASDEL));
-	ASSERT(whichfork != XFS_COW_FORK);
 
 	XFS_STATS_INC(mp, xs_add_exlist);
 
 	state = 0;
 	if (whichfork == XFS_ATTR_FORK)
 		state |= BMAP_ATTRFORK;
+	if (whichfork == XFS_COW_FORK)
+		state |= BMAP_COWFORK;
 
 	/*
 	 * Check and set flags if this segment has a left neighbor.
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index a2e1fff..1a96741 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -391,62 +391,100 @@ __xfs_reflink_allocate_cow(
 	xfs_fileoff_t		end_fsb)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_bmbt_irec	imap;
+	struct xfs_bmbt_irec	imap, got;
 	struct xfs_defer_ops	dfops;
 	struct xfs_trans	*tp;
 	xfs_fsblock_t		first_block;
-	int			nimaps = 1, error;
-	bool			shared;
+	int			nimaps, error, lockmode;
+	bool			shared, trimmed;
+	xfs_filblks_t		resaligned;
+	xfs_extlen_t		resblks;
+	xfs_extnum_t		idx;
 
-	xfs_defer_init(&dfops, &first_block);
+	resaligned = xfs_aligned_fsb_count(*offset_fsb, end_fsb - *offset_fsb,
+			xfs_get_cowextsz_hint(ip));
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
-			XFS_TRANS_RESERVE, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, lockmode);
 
-	/* Read extent from the source file. */
-	nimaps = 1;
-	error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
-			&imap, &nimaps, 0);
-	if (error)
-		goto out_unlock;
-	ASSERT(nimaps == 1);
+	/*
+	 * Even if the extent is not shared we might have a preallocation for
+	 * it in the COW fork.  If so use it.
+	 */
+	if (xfs_iext_lookup_extent(ip, ip->i_cowfp, *offset_fsb, &idx, &got) &&
+	    got.br_startoff <= *offset_fsb) {
+		/* If we have a real allocation in the COW fork we're done. */
+		if (!isnullstartblock(got.br_startblock)) {
+			xfs_trim_extent(&got, *offset_fsb,
+					end_fsb - *offset_fsb);
+			*offset_fsb = got.br_startoff + got.br_blockcount;
+			goto out_trans_cancel;
+		}
+	} else {
+		nimaps = 1;
+		error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
+				&imap, &nimaps, 0);
+		if (error)
+			goto out_trans_cancel;
+		ASSERT(nimaps == 1);
+
+		/* Trim the mapping to the nearest shared extent boundary. */
+		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
+				&trimmed);
+		if (error)
+			goto out_trans_cancel;
+
+		if (!shared) {
+			*offset_fsb = imap.br_startoff + imap.br_blockcount;
+			goto out_trans_cancel;
+		}
 
-	/* Make sure there's a CoW reservation for it. */
-	error = xfs_reflink_reserve_cow(ip, &imap, &shared);
+		*offset_fsb = imap.br_startoff;
+		end_fsb = imap.br_startoff + imap.br_blockcount;
+	}
+
+	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		goto out_trans_cancel;
 
-	if (!shared) {
-		*offset_fsb = imap.br_startoff + imap.br_blockcount;
-		goto out_trans_cancel;
-	}
+	xfs_trans_ijoin(tp, ip, 0);
+
+	xfs_defer_init(&dfops, &first_block);
+	nimaps = 1;
 
 	/* Allocate the entire reservation as unwritten blocks. */
-	xfs_trans_ijoin(tp, ip, 0);
-	error = xfs_bmapi_write(tp, ip, imap.br_startoff, imap.br_blockcount,
+	error = xfs_bmapi_write(tp, ip, *offset_fsb, end_fsb - *offset_fsb,
 			XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC, &first_block,
-			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
-			&imap, &nimaps, &dfops);
+			resblks, &imap, &nimaps, &dfops);
 	if (error)
-		goto out_trans_cancel;
+		goto out_bmap_cancel;
 
 	/* Finish up. */
 	error = xfs_defer_finish(&tp, &dfops, NULL);
 	if (error)
-		goto out_trans_cancel;
+		goto out_bmap_cancel;
 
 	error = xfs_trans_commit(tp);
+	if (error)
+		goto out_unlock;
 
 	*offset_fsb = imap.br_startoff + imap.br_blockcount;
+
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return error;
-out_trans_cancel:
+
+out_bmap_cancel:
 	xfs_defer_cancel(&dfops);
+	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
+			XFS_QMOPT_RES_REGBLKS);
+out_trans_cancel:
 	xfs_trans_cancel(tp);
 	goto out_unlock;
 }
-- 
2.1.4

