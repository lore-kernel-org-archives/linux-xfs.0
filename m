Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B3B1AF0AF
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995662; cv=none; b=oUcwfVUbNv8Cbz21qVDIQnRgPtr8vlRAFX5rM4tqkfx20BgiDn1/ENC9bG3dQZ37VhUY03aKYGDw6XBo2/cDUJKsbd6eFnBxMNxt6JDjnn7UbHs6ZPxYvrgn0M+6W55i62TARqEu1WWVQvQqcW4d8n6J+S/ta1LimhP+M873OwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995662; c=relaxed/simple;
	bh=PYkyBnIQuOgs8za+Qknv9AvpWhwdP+9cKSFpyvW3L20=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RXBwT5f6DT05jqlz2ibLIKMt8hZqtI7vErFqng9NIC1V60FUo45VHnybtp5yBbvV9N1K+m61HaniRIXFxqtIA1EgA1Q/JJw8rc2pGnz10DZj+IzN9V2N0sKg1M5HOsLEEKknxdQ06bzAcyYkaRFnfbuBhTC1NsXa0wKnKYcgRsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vL3d/O7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vL3d/O7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F17C4CED3;
	Mon, 23 Dec 2024 23:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995662;
	bh=PYkyBnIQuOgs8za+Qknv9AvpWhwdP+9cKSFpyvW3L20=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vL3d/O7IZ9zlzt/W1OSkxIsfQztjDhOURS35A4/nouQ1ldzaSvMw3V/6+055LNd4K
	 TWZteCwgdr448+SWeQoSCf2Ferew+ujSvKybWlLx4MYElLYpO7Bnm01sDJuYtLTuwn
	 W2zb7wQPB/+Kmf/eXINrnhqlEFzWx1cZlfzXk8A5HX0+PL6dNSV7bFLyhf30dckEoc
	 csI/HJ7axGsiLvrWh/7osA/vBiw56lNU8wRQFe6QjZcJAJmjILUPefjj2YCplVZ5sO
	 pY4dbisCojZPy9zDcVAs41xkmax3g+GFTscyE/DvU7a5xrqXKGiBwQtOmCHcAjuDwh
	 wvm2EtP1EGhxA==
Date: Mon, 23 Dec 2024 15:14:21 -0800
Subject: [PATCH 31/43] xfs: check reference counts of gaps between rt refcount
 records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420470.2381378.4027391406479497649.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

If there's a gap between records in the rt refcount btree, we ought to
cross-reference the gap with the rtrmap records to make sure that there
aren't any overlapping records for a region that doesn't have any shared
ownership.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/rtrefcount.c |   81 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index f56f2cb7a9f707..18c9bcb0e82184 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -17,6 +17,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_metafile.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_rtalloc.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -348,8 +349,14 @@ struct xchk_rtrefcbt_records {
 	/* Previous refcount record. */
 	struct xfs_refcount_irec	prev_rec;
 
+	/* The next rtgroup block where we aren't expecting shared extents. */
+	xfs_rgblock_t			next_unshared_rgbno;
+
 	/* Number of CoW blocks we expect. */
 	xfs_extlen_t			cow_blocks;
+
+	/* Was the last record a shared or CoW staging extent? */
+	enum xfs_refc_domain		prev_domain;
 };
 
 static inline bool
@@ -390,6 +397,53 @@ xchk_rtrefcountbt_check_mergeable(
 	memcpy(&rrc->prev_rec, irec, sizeof(struct xfs_refcount_irec));
 }
 
+STATIC int
+xchk_rtrefcountbt_rmap_check_gap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	xfs_rgblock_t			*next_bno = priv;
+
+	if (*next_bno != NULLRGBLOCK && rec->rm_startblock < *next_bno)
+		return -ECANCELED;
+
+	*next_bno = rec->rm_startblock + rec->rm_blockcount;
+	return 0;
+}
+
+/*
+ * Make sure that a gap in the reference count records does not correspond to
+ * overlapping records (i.e. shared extents) in the reverse mappings.
+ */
+static inline void
+xchk_rtrefcountbt_xref_gaps(
+	struct xfs_scrub	*sc,
+	struct xchk_rtrefcbt_records *rrc,
+	xfs_rtblock_t		bno)
+{
+	struct xfs_rmap_irec	low;
+	struct xfs_rmap_irec	high;
+	xfs_rgblock_t		next_bno = NULLRGBLOCK;
+	int			error;
+
+	if (bno <= rrc->next_unshared_rgbno || !sc->sr.rmap_cur ||
+            xchk_skip_xref(sc->sm))
+		return;
+
+	memset(&low, 0, sizeof(low));
+	low.rm_startblock = rrc->next_unshared_rgbno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno - 1;
+
+	error = xfs_rmap_query_range(sc->sr.rmap_cur, &low, &high,
+			xchk_rtrefcountbt_rmap_check_gap, &next_bno);
+	if (error == -ECANCELED)
+		xchk_btree_xref_set_corrupt(sc, sc->sr.rmap_cur, 0);
+	else
+		xchk_should_check_xref(sc, &error, &sc->sr.rmap_cur);
+}
+
 /* Scrub a rtrefcountbt record. */
 STATIC int
 xchk_rtrefcountbt_rec(
@@ -419,9 +473,26 @@ xchk_rtrefcountbt_rec(
 	if (irec.rc_domain == XFS_REFC_DOMAIN_COW)
 		rrc->cow_blocks += irec.rc_blockcount;
 
+	/* Shared records always come before CoW records. */
+	if (irec.rc_domain == XFS_REFC_DOMAIN_SHARED &&
+	    rrc->prev_domain == XFS_REFC_DOMAIN_COW)
+		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+	rrc->prev_domain = irec.rc_domain;
+
 	xchk_rtrefcountbt_check_mergeable(bs, rrc, &irec);
 	xchk_rtrefcountbt_xref(bs->sc, &irec);
 
+	/*
+	 * If this is a record for a shared extent, check that all blocks
+	 * between the previous record and this one have at most one reverse
+	 * mapping.
+	 */
+	if (irec.rc_domain == XFS_REFC_DOMAIN_SHARED) {
+		xchk_rtrefcountbt_xref_gaps(bs->sc, rrc, irec.rc_startblock);
+		rrc->next_unshared_rgbno = irec.rc_startblock +
+					   irec.rc_blockcount;
+	}
+
 	return 0;
 }
 
@@ -466,7 +537,9 @@ xchk_rtrefcountbt(
 {
 	struct xfs_owner_info	btree_oinfo;
 	struct xchk_rtrefcbt_records rrc = {
-		.cow_blocks	= 0,
+		.cow_blocks		= 0,
+		.next_unshared_rgbno	= 0,
+		.prev_domain		= XFS_REFC_DOMAIN_SHARED,
 	};
 	int			error;
 
@@ -481,6 +554,12 @@ xchk_rtrefcountbt(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
+	/*
+	 * Check that all blocks between the last refcount > 1 record and the
+	 * end of the rt volume have at most one reverse mapping.
+	 */
+	xchk_rtrefcountbt_xref_gaps(sc, &rrc, sc->mp->m_sb.sb_rblocks);
+
 	xchk_refcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
 
 	return 0;

