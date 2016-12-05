Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49139 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbcLEVFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2016 16:05:35 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: go straight to real allocations for direct I/O COW writes
Date: Mon,  5 Dec 2016 22:05:23 +0100
Message-Id: <1480971924-4864-3-git-send-email-hch@lst.de>
In-Reply-To: <1480971924-4864-1-git-send-email-hch@lst.de>
References: <1480971924-4864-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com

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
 fs/xfs/libxfs/xfs_bmap.c |   9 ++---
 fs/xfs/xfs_reflink.c     | 101 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 76 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6f28814..a4a4327 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2893,13 +2893,14 @@ xfs_bmap_add_extent_hole_real(
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
@@ -3619,9 +3620,7 @@ xfs_bmap_btalloc(
 	else if (mp->m_dalign)
 		stripe_align = mp->m_dalign;
 
-	if (ap->flags & XFS_BMAPI_COWFORK)
-		align = xfs_get_cowextsz_hint(ap->ip);
-	else if (xfs_alloc_is_userdata(ap->datatype))
+	if (xfs_alloc_is_userdata(ap->datatype))
 		align = xfs_get_extsz_hint(ap->ip);
 	if (unlikely(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
@@ -4608,8 +4607,6 @@ xfs_bmapi_write(
 		 */
 		if (flags & XFS_BMAPI_REMAP)
 			ASSERT(inhole);
-		if (flags & XFS_BMAPI_COWFORK)
-			ASSERT(!inhole);
 
 		/*
 		 * First, deal with the hole before the allocated space
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 88fd03c..0a077e80 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -304,59 +304,104 @@ __xfs_reflink_allocate_cow(
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
+	xfs_extlen_t		resblks, align;
+	xfs_extnum_t		idx;
 
-	xfs_defer_init(&dfops, &first_block);
+	align = xfs_eof_alignment(ip, xfs_get_cowextsz_hint(ip));
+	if (align)
+		end_fsb = roundup_64(end_fsb, align);
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0,
-			XFS_TRANS_RESERVE, &tp);
+	resblks = XFS_DIOSTRAT_SPACE_RES(mp, end_fsb - *offset_fsb);
+
+	error = xfs_qm_dqattach(ip, 0);
 	if (error)
 		return error;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/* Read extent from the source file. */
-	nimaps = 1;
-	error = xfs_bmapi_read(ip, *offset_fsb, end_fsb - *offset_fsb,
-			&imap, &nimaps, 0);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
-		goto out_unlock;
-	ASSERT(nimaps == 1);
+		return error;
 
-	error = xfs_reflink_reserve_cow(ip, &imap, &shared);
-	if (error)
-		goto out_trans_cancel;
+	lockmode = XFS_ILOCK_EXCL;
+	xfs_ilock(ip, lockmode);
 
-	if (!shared) {
-		*offset_fsb = imap.br_startoff + imap.br_blockcount;
-		goto out_trans_cancel;
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
+
+		*offset_fsb = imap.br_startoff;
+		end_fsb = imap.br_startoff + imap.br_blockcount;
+		if (align)
+			end_fsb = roundup_64(end_fsb, align);
 	}
 
-	xfs_trans_ijoin(tp, ip, 0);
-	error = xfs_bmapi_write(tp, ip, imap.br_startoff, imap.br_blockcount,
-			XFS_BMAPI_COWFORK, &first_block,
-			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK),
-			&imap, &nimaps, &dfops);
+	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+			XFS_QMOPT_RES_REGBLKS);
 	if (error)
 		goto out_trans_cancel;
 
+	xfs_trans_ijoin(tp, ip, 0);
+
+	xfs_defer_init(&dfops, &first_block);
+	nimaps = 1;
+	error = xfs_bmapi_write(tp, ip, *offset_fsb, end_fsb - *offset_fsb,
+			XFS_BMAPI_COWFORK, &first_block, resblks, &imap,
+			&nimaps, &dfops);
+	if (error)
+		goto out_bmap_cancel;
+
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

