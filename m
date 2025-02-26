Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E213F2376FE
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740596250; cv=none; b=AD8YB51hX6u2oG2VjNHPfPmPjjQZ2JsASOHgzIPh24JCvikWAQQwOOptfma1mv0Ff8zTQgeDyi0HYOTMiQNdx85W9Z855H2QiIPfxPe14Oh1BISf9skznwrL+lXsZonm0j16LxZ5Nu9GXChJ7YtuLlb0eI0nvJNdtg0Jhb7BW1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740596250; c=relaxed/simple;
	bh=xPpZA9p2pBfp0M2yvW9SAkBczxX5099elQxfnsXotG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwnA3iyYhR3X2RBOjGf/B3VvbKf3k+CzkbudbOLwbF7ABxkD/6kN78r8Ur3YddKgpXfDdt0sjia2si4wUfaLWTukym4rq9Pp8Xo4+6fl6vsVyPB3zGdu8HEGF8N7Czc0ZbbYK2LelYay9LEkDQpiSCD7lV4kbFJWFJnvERACGEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i02kq0NK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i02kq0NK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=A42ux8B04dmS7GuMB4LBRc4o1NxQGDtvj5Gj+BPnzOY=; b=i02kq0NK4mpGlGAFUTYtg8FpF6
	T7uZa9wGuytDNl80DGagA3YTLB750aT7hLQLzFkCOg+ZBSqQ6pfoMgbnuTioFDLaWnS0z8qDZ8v1k
	shzk1PCUDQ30/79uCYtydU/QO0wM4EdEJwugTXoMsObFpPjHCRkCvsdPQfzeVDRqqvsStO6U7RNuF
	nFxiaK46Ek9HUEclWyTQt6S9PVrkXKo9tKZzBOrHwLqPxEPJQESNnCpRUHFqESWZWkTvoRvNcHu/i
	wDy7e5dN4ZXkKpb+32PeAGdU+F5mVpI4ZUQYEoIwX/P6dRK4UoKbBX8FvEN5Mp4/GmBxNyFn6M3QM
	RShwvEXQ==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnMb1-000000053sX-1S6a;
	Wed, 26 Feb 2025 18:57:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/44] xfs: move xfs_bmapi_reserve_delalloc to xfs_iomap.c
Date: Wed, 26 Feb 2025 10:56:42 -0800
Message-ID: <20250226185723.518867-11-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226185723.518867-1-hch@lst.de>
References: <20250226185723.518867-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Delalloc reservations are not supported in userspace, and thus it doesn't
make sense to share this helper with xfsprogs.c.  Move it to xfs_iomap.c
toward the two callers.

Note that there rest of the delalloc handling should probably eventually
also move out of xfs_bmap.c, but that will require a bit more surgery.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 295 +--------------------------------------
 fs/xfs/libxfs/xfs_bmap.h |   5 +-
 fs/xfs/xfs_iomap.c       | 279 ++++++++++++++++++++++++++++++++++++
 3 files changed, 287 insertions(+), 292 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 0ef19f1469ec..5b17e59ed5b8 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -34,7 +34,6 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_refcount.h"
-#include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_health.h"
 #include "xfs_bmap_item.h"
@@ -171,18 +170,16 @@ xfs_bmbt_update(
  * Compute the worst-case number of indirect blocks that will be used
  * for ip's delayed extent of length "len".
  */
-STATIC xfs_filblks_t
+xfs_filblks_t
 xfs_bmap_worst_indlen(
-	xfs_inode_t	*ip,		/* incore inode pointer */
-	xfs_filblks_t	len)		/* delayed extent length */
+	struct xfs_inode	*ip,		/* incore inode pointer */
+	xfs_filblks_t		len)		/* delayed extent length */
 {
-	int		level;		/* btree level number */
-	int		maxrecs;	/* maximum record count at this level */
-	xfs_mount_t	*mp;		/* mount structure */
-	xfs_filblks_t	rval;		/* return value */
+	struct xfs_mount	*mp = ip->i_mount;
+	int			maxrecs = mp->m_bmap_dmxr[0];
+	int			level;
+	xfs_filblks_t		rval;
 
-	mp = ip->i_mount;
-	maxrecs = mp->m_bmap_dmxr[0];
 	for (level = 0, rval = 0;
 	     level < XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK);
 	     level++) {
@@ -2571,146 +2568,6 @@ xfs_bmap_add_extent_unwritten_real(
 #undef	PREV
 }
 
-/*
- * Convert a hole to a delayed allocation.
- */
-STATIC void
-xfs_bmap_add_extent_hole_delay(
-	xfs_inode_t		*ip,	/* incore inode pointer */
-	int			whichfork,
-	struct xfs_iext_cursor	*icur,
-	xfs_bmbt_irec_t		*new)	/* new data to add to file extents */
-{
-	struct xfs_ifork	*ifp;	/* inode fork pointer */
-	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
-	xfs_filblks_t		newlen=0;	/* new indirect size */
-	xfs_filblks_t		oldlen=0;	/* old indirect size */
-	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
-	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
-	xfs_filblks_t		temp;	 /* temp for indirect calculations */
-
-	ifp = xfs_ifork_ptr(ip, whichfork);
-	ASSERT(isnullstartblock(new->br_startblock));
-
-	/*
-	 * Check and set flags if this segment has a left neighbor
-	 */
-	if (xfs_iext_peek_prev_extent(ifp, icur, &left)) {
-		state |= BMAP_LEFT_VALID;
-		if (isnullstartblock(left.br_startblock))
-			state |= BMAP_LEFT_DELAY;
-	}
-
-	/*
-	 * Check and set flags if the current (right) segment exists.
-	 * If it doesn't exist, we're converting the hole at end-of-file.
-	 */
-	if (xfs_iext_get_extent(ifp, icur, &right)) {
-		state |= BMAP_RIGHT_VALID;
-		if (isnullstartblock(right.br_startblock))
-			state |= BMAP_RIGHT_DELAY;
-	}
-
-	/*
-	 * Set contiguity flags on the left and right neighbors.
-	 * Don't let extents get too large, even if the pieces are contiguous.
-	 */
-	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
-	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
-		state |= BMAP_LEFT_CONTIG;
-
-	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
-	    new->br_startoff + new->br_blockcount == right.br_startoff &&
-	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
-	    (!(state & BMAP_LEFT_CONTIG) ||
-	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
-		state |= BMAP_RIGHT_CONTIG;
-
-	/*
-	 * Switch out based on the contiguity flags.
-	 */
-	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
-	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
-		/*
-		 * New allocation is contiguous with delayed allocations
-		 * on the left and on the right.
-		 * Merge all three into a single extent record.
-		 */
-		temp = left.br_blockcount + new->br_blockcount +
-			right.br_blockcount;
-
-		oldlen = startblockval(left.br_startblock) +
-			startblockval(new->br_startblock) +
-			startblockval(right.br_startblock);
-		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-					 oldlen);
-		left.br_startblock = nullstartblock(newlen);
-		left.br_blockcount = temp;
-
-		xfs_iext_remove(ip, icur, state);
-		xfs_iext_prev(ifp, icur);
-		xfs_iext_update_extent(ip, state, icur, &left);
-		break;
-
-	case BMAP_LEFT_CONTIG:
-		/*
-		 * New allocation is contiguous with a delayed allocation
-		 * on the left.
-		 * Merge the new allocation with the left neighbor.
-		 */
-		temp = left.br_blockcount + new->br_blockcount;
-
-		oldlen = startblockval(left.br_startblock) +
-			startblockval(new->br_startblock);
-		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-					 oldlen);
-		left.br_blockcount = temp;
-		left.br_startblock = nullstartblock(newlen);
-
-		xfs_iext_prev(ifp, icur);
-		xfs_iext_update_extent(ip, state, icur, &left);
-		break;
-
-	case BMAP_RIGHT_CONTIG:
-		/*
-		 * New allocation is contiguous with a delayed allocation
-		 * on the right.
-		 * Merge the new allocation with the right neighbor.
-		 */
-		temp = new->br_blockcount + right.br_blockcount;
-		oldlen = startblockval(new->br_startblock) +
-			startblockval(right.br_startblock);
-		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
-					 oldlen);
-		right.br_startoff = new->br_startoff;
-		right.br_startblock = nullstartblock(newlen);
-		right.br_blockcount = temp;
-		xfs_iext_update_extent(ip, state, icur, &right);
-		break;
-
-	case 0:
-		/*
-		 * New allocation is not contiguous with another
-		 * delayed allocation.
-		 * Insert a new entry.
-		 */
-		oldlen = newlen = 0;
-		xfs_iext_insert(ip, icur, new, state);
-		break;
-	}
-	if (oldlen != newlen) {
-		ASSERT(oldlen > newlen);
-		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
-
-		/*
-		 * Nothing to do for disk quota accounting here.
-		 */
-		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
-	}
-}
-
 /*
  * Convert a hole to a real allocation.
  */
@@ -4039,144 +3896,6 @@ xfs_bmapi_read(
 	return 0;
 }
 
-/*
- * Add a delayed allocation extent to an inode. Blocks are reserved from the
- * global pool and the extent inserted into the inode in-core extent tree.
- *
- * On entry, got refers to the first extent beyond the offset of the extent to
- * allocate or eof is specified if no such extent exists. On return, got refers
- * to the extent record that was inserted to the inode fork.
- *
- * Note that the allocated extent may have been merged with contiguous extents
- * during insertion into the inode fork. Thus, got does not reflect the current
- * state of the inode fork on return. If necessary, the caller can use lastx to
- * look up the updated record in the inode fork.
- */
-int
-xfs_bmapi_reserve_delalloc(
-	struct xfs_inode	*ip,
-	int			whichfork,
-	xfs_fileoff_t		off,
-	xfs_filblks_t		len,
-	xfs_filblks_t		prealloc,
-	struct xfs_bmbt_irec	*got,
-	struct xfs_iext_cursor	*icur,
-	int			eof)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	xfs_extlen_t		alen;
-	xfs_extlen_t		indlen;
-	uint64_t		fdblocks;
-	int			error;
-	xfs_fileoff_t		aoff;
-	bool			use_cowextszhint =
-					whichfork == XFS_COW_FORK && !prealloc;
-
-retry:
-	/*
-	 * Cap the alloc length. Keep track of prealloc so we know whether to
-	 * tag the inode before we return.
-	 */
-	aoff = off;
-	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
-	if (!eof)
-		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
-	if (prealloc && alen >= len)
-		prealloc = alen - len;
-
-	/*
-	 * If we're targetting the COW fork but aren't creating a speculative
-	 * posteof preallocation, try to expand the reservation to align with
-	 * the COW extent size hint if there's sufficient free space.
-	 *
-	 * Unlike the data fork, the CoW cancellation functions will free all
-	 * the reservations at inactivation, so we don't require that every
-	 * delalloc reservation have a dirty pagecache.
-	 */
-	if (use_cowextszhint) {
-		struct xfs_bmbt_irec	prev;
-		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
-
-		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
-			prev.br_startoff = NULLFILEOFF;
-
-		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, 0, eof,
-					       1, 0, &aoff, &alen);
-		ASSERT(!error);
-	}
-
-	/*
-	 * Make a transaction-less quota reservation for delayed allocation
-	 * blocks.  This number gets adjusted later.  We return if we haven't
-	 * allocated blocks already inside this loop.
-	 */
-	error = xfs_quota_reserve_blkres(ip, alen);
-	if (error)
-		goto out;
-
-	/*
-	 * Split changing sb for alen and indlen since they could be coming
-	 * from different places.
-	 */
-	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
-	ASSERT(indlen > 0);
-
-	fdblocks = indlen;
-	if (XFS_IS_REALTIME_INODE(ip)) {
-		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
-		if (error)
-			goto out_unreserve_quota;
-	} else {
-		fdblocks += alen;
-	}
-
-	error = xfs_dec_fdblocks(mp, fdblocks, false);
-	if (error)
-		goto out_unreserve_frextents;
-
-	ip->i_delayed_blks += alen;
-	xfs_mod_delalloc(ip, alen, indlen);
-
-	got->br_startoff = aoff;
-	got->br_startblock = nullstartblock(indlen);
-	got->br_blockcount = alen;
-	got->br_state = XFS_EXT_NORM;
-
-	xfs_bmap_add_extent_hole_delay(ip, whichfork, icur, got);
-
-	/*
-	 * Tag the inode if blocks were preallocated. Note that COW fork
-	 * preallocation can occur at the start or end of the extent, even when
-	 * prealloc == 0, so we must also check the aligned offset and length.
-	 */
-	if (whichfork == XFS_DATA_FORK && prealloc)
-		xfs_inode_set_eofblocks_tag(ip);
-	if (whichfork == XFS_COW_FORK && (prealloc || aoff < off || alen > len))
-		xfs_inode_set_cowblocks_tag(ip);
-
-	return 0;
-
-out_unreserve_frextents:
-	if (XFS_IS_REALTIME_INODE(ip))
-		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
-out_unreserve_quota:
-	if (XFS_IS_QUOTA_ON(mp))
-		xfs_quota_unreserve_blkres(ip, alen);
-out:
-	if (error == -ENOSPC || error == -EDQUOT) {
-		trace_xfs_delalloc_enospc(ip, off, len);
-
-		if (prealloc || use_cowextszhint) {
-			/* retry without any preallocation */
-			use_cowextszhint = false;
-			prealloc = 0;
-			goto retry;
-		}
-	}
-	return error;
-}
-
 static int
 xfs_bmapi_allocate(
 	struct xfs_bmalloca	*bma)
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 4b721d935994..4d48087fd3a8 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -219,10 +219,6 @@ int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		bool *done, xfs_fileoff_t stop_fsb);
 int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t split_offset);
-int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
-		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
-		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
-		int eof);
 int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_off_t offset, struct iomap *iomap, unsigned int *seq);
 int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
@@ -233,6 +229,7 @@ xfs_extlen_t xfs_bmapi_minleft(struct xfs_trans *tp, struct xfs_inode *ip,
 		int fork);
 int	xfs_bmap_btalloc_low_space(struct xfs_bmalloca *ap,
 		struct xfs_alloc_arg *args);
+xfs_filblks_t xfs_bmap_worst_indlen(struct xfs_inode *ip, xfs_filblks_t len);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c669b93bb2d1..a724fc2612e3 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -30,6 +30,7 @@
 #include "xfs_reflink.h"
 #include "xfs_health.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_icache.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -988,6 +989,284 @@ const struct iomap_ops xfs_dax_write_iomap_ops = {
 	.iomap_end	= xfs_dax_write_iomap_end,
 };
 
+/*
+ * Convert a hole to a delayed allocation.
+ */
+static void
+xfs_bmap_add_extent_hole_delay(
+	struct xfs_inode	*ip,	/* incore inode pointer */
+	int			whichfork,
+	struct xfs_iext_cursor	*icur,
+	struct xfs_bmbt_irec	*new)	/* new data to add to file extents */
+{
+	struct xfs_ifork	*ifp;	/* inode fork pointer */
+	xfs_bmbt_irec_t		left;	/* left neighbor extent entry */
+	xfs_filblks_t		newlen=0;	/* new indirect size */
+	xfs_filblks_t		oldlen=0;	/* old indirect size */
+	xfs_bmbt_irec_t		right;	/* right neighbor extent entry */
+	uint32_t		state = xfs_bmap_fork_to_state(whichfork);
+	xfs_filblks_t		temp;	 /* temp for indirect calculations */
+
+	ifp = xfs_ifork_ptr(ip, whichfork);
+	ASSERT(isnullstartblock(new->br_startblock));
+
+	/*
+	 * Check and set flags if this segment has a left neighbor
+	 */
+	if (xfs_iext_peek_prev_extent(ifp, icur, &left)) {
+		state |= BMAP_LEFT_VALID;
+		if (isnullstartblock(left.br_startblock))
+			state |= BMAP_LEFT_DELAY;
+	}
+
+	/*
+	 * Check and set flags if the current (right) segment exists.
+	 * If it doesn't exist, we're converting the hole at end-of-file.
+	 */
+	if (xfs_iext_get_extent(ifp, icur, &right)) {
+		state |= BMAP_RIGHT_VALID;
+		if (isnullstartblock(right.br_startblock))
+			state |= BMAP_RIGHT_DELAY;
+	}
+
+	/*
+	 * Set contiguity flags on the left and right neighbors.
+	 * Don't let extents get too large, even if the pieces are contiguous.
+	 */
+	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
+	    left.br_startoff + left.br_blockcount == new->br_startoff &&
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
+		state |= BMAP_LEFT_CONTIG;
+
+	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
+	    new->br_startoff + new->br_blockcount == right.br_startoff &&
+	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
+	    (!(state & BMAP_LEFT_CONTIG) ||
+	     (left.br_blockcount + new->br_blockcount +
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
+		state |= BMAP_RIGHT_CONTIG;
+
+	/*
+	 * Switch out based on the contiguity flags.
+	 */
+	switch (state & (BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG)) {
+	case BMAP_LEFT_CONTIG | BMAP_RIGHT_CONTIG:
+		/*
+		 * New allocation is contiguous with delayed allocations
+		 * on the left and on the right.
+		 * Merge all three into a single extent record.
+		 */
+		temp = left.br_blockcount + new->br_blockcount +
+			right.br_blockcount;
+
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
+		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+					 oldlen);
+		left.br_startblock = nullstartblock(newlen);
+		left.br_blockcount = temp;
+
+		xfs_iext_remove(ip, icur, state);
+		xfs_iext_prev(ifp, icur);
+		xfs_iext_update_extent(ip, state, icur, &left);
+		break;
+
+	case BMAP_LEFT_CONTIG:
+		/*
+		 * New allocation is contiguous with a delayed allocation
+		 * on the left.
+		 * Merge the new allocation with the left neighbor.
+		 */
+		temp = left.br_blockcount + new->br_blockcount;
+
+		oldlen = startblockval(left.br_startblock) +
+			startblockval(new->br_startblock);
+		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+					 oldlen);
+		left.br_blockcount = temp;
+		left.br_startblock = nullstartblock(newlen);
+
+		xfs_iext_prev(ifp, icur);
+		xfs_iext_update_extent(ip, state, icur, &left);
+		break;
+
+	case BMAP_RIGHT_CONTIG:
+		/*
+		 * New allocation is contiguous with a delayed allocation
+		 * on the right.
+		 * Merge the new allocation with the right neighbor.
+		 */
+		temp = new->br_blockcount + right.br_blockcount;
+		oldlen = startblockval(new->br_startblock) +
+			startblockval(right.br_startblock);
+		newlen = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(ip, temp),
+					 oldlen);
+		right.br_startoff = new->br_startoff;
+		right.br_startblock = nullstartblock(newlen);
+		right.br_blockcount = temp;
+		xfs_iext_update_extent(ip, state, icur, &right);
+		break;
+
+	case 0:
+		/*
+		 * New allocation is not contiguous with another
+		 * delayed allocation.
+		 * Insert a new entry.
+		 */
+		oldlen = newlen = 0;
+		xfs_iext_insert(ip, icur, new, state);
+		break;
+	}
+	if (oldlen != newlen) {
+		ASSERT(oldlen > newlen);
+		xfs_add_fdblocks(ip->i_mount, oldlen - newlen);
+
+		/*
+		 * Nothing to do for disk quota accounting here.
+		 */
+		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
+	}
+}
+
+/*
+ * Add a delayed allocation extent to an inode. Blocks are reserved from the
+ * global pool and the extent inserted into the inode in-core extent tree.
+ *
+ * On entry, got refers to the first extent beyond the offset of the extent to
+ * allocate or eof is specified if no such extent exists. On return, got refers
+ * to the extent record that was inserted to the inode fork.
+ *
+ * Note that the allocated extent may have been merged with contiguous extents
+ * during insertion into the inode fork. Thus, got does not reflect the current
+ * state of the inode fork on return. If necessary, the caller can use lastx to
+ * look up the updated record in the inode fork.
+ */
+static int
+xfs_bmapi_reserve_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len,
+	xfs_filblks_t		prealloc,
+	struct xfs_bmbt_irec	*got,
+	struct xfs_iext_cursor	*icur,
+	int			eof)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	xfs_extlen_t		alen;
+	xfs_extlen_t		indlen;
+	uint64_t		fdblocks;
+	int			error;
+	xfs_fileoff_t		aoff;
+	bool			use_cowextszhint =
+					whichfork == XFS_COW_FORK && !prealloc;
+
+retry:
+	/*
+	 * Cap the alloc length. Keep track of prealloc so we know whether to
+	 * tag the inode before we return.
+	 */
+	aoff = off;
+	alen = XFS_FILBLKS_MIN(len + prealloc, XFS_MAX_BMBT_EXTLEN);
+	if (!eof)
+		alen = XFS_FILBLKS_MIN(alen, got->br_startoff - aoff);
+	if (prealloc && alen >= len)
+		prealloc = alen - len;
+
+	/*
+	 * If we're targetting the COW fork but aren't creating a speculative
+	 * posteof preallocation, try to expand the reservation to align with
+	 * the COW extent size hint if there's sufficient free space.
+	 *
+	 * Unlike the data fork, the CoW cancellation functions will free all
+	 * the reservations at inactivation, so we don't require that every
+	 * delalloc reservation have a dirty pagecache.
+	 */
+	if (use_cowextszhint) {
+		struct xfs_bmbt_irec	prev;
+		xfs_extlen_t		extsz = xfs_get_cowextsz_hint(ip);
+
+		if (!xfs_iext_peek_prev_extent(ifp, icur, &prev))
+			prev.br_startoff = NULLFILEOFF;
+
+		error = xfs_bmap_extsize_align(mp, got, &prev, extsz, 0, eof,
+					       1, 0, &aoff, &alen);
+		ASSERT(!error);
+	}
+
+	/*
+	 * Make a transaction-less quota reservation for delayed allocation
+	 * blocks.  This number gets adjusted later.  We return if we haven't
+	 * allocated blocks already inside this loop.
+	 */
+	error = xfs_quota_reserve_blkres(ip, alen);
+	if (error)
+		goto out;
+
+	/*
+	 * Split changing sb for alen and indlen since they could be coming
+	 * from different places.
+	 */
+	indlen = (xfs_extlen_t)xfs_bmap_worst_indlen(ip, alen);
+	ASSERT(indlen > 0);
+
+	fdblocks = indlen;
+	if (XFS_IS_REALTIME_INODE(ip)) {
+		error = xfs_dec_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
+		if (error)
+			goto out_unreserve_quota;
+	} else {
+		fdblocks += alen;
+	}
+
+	error = xfs_dec_fdblocks(mp, fdblocks, false);
+	if (error)
+		goto out_unreserve_frextents;
+
+	ip->i_delayed_blks += alen;
+	xfs_mod_delalloc(ip, alen, indlen);
+
+	got->br_startoff = aoff;
+	got->br_startblock = nullstartblock(indlen);
+	got->br_blockcount = alen;
+	got->br_state = XFS_EXT_NORM;
+
+	xfs_bmap_add_extent_hole_delay(ip, whichfork, icur, got);
+
+	/*
+	 * Tag the inode if blocks were preallocated. Note that COW fork
+	 * preallocation can occur at the start or end of the extent, even when
+	 * prealloc == 0, so we must also check the aligned offset and length.
+	 */
+	if (whichfork == XFS_DATA_FORK && prealloc)
+		xfs_inode_set_eofblocks_tag(ip);
+	if (whichfork == XFS_COW_FORK && (prealloc || aoff < off || alen > len))
+		xfs_inode_set_cowblocks_tag(ip);
+
+	return 0;
+
+out_unreserve_frextents:
+	if (XFS_IS_REALTIME_INODE(ip))
+		xfs_add_frextents(mp, xfs_blen_to_rtbxlen(mp, alen));
+out_unreserve_quota:
+	if (XFS_IS_QUOTA_ON(mp))
+		xfs_quota_unreserve_blkres(ip, alen);
+out:
+	if (error == -ENOSPC || error == -EDQUOT) {
+		trace_xfs_delalloc_enospc(ip, off, len);
+
+		if (prealloc || use_cowextszhint) {
+			/* retry without any preallocation */
+			use_cowextszhint = false;
+			prealloc = 0;
+			goto retry;
+		}
+	}
+	return error;
+}
+
 static int
 xfs_buffered_write_iomap_begin(
 	struct inode		*inode,
-- 
2.45.2

