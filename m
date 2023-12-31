Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6B4C8CA
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hrl1iOOr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1A7C433C8;
	Sun, 31 Dec 2023 21:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059575;
	bh=aJ0KbX9v7rHAnbQFOJ0Yya2pr1X1r0rduz5OP/3lepc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Hrl1iOOrwZ4rEwYZ9zoawQXpzLrE+ZwyDsCCx5FSMhauHb+b2CFJ2dFpJY9KqRogm
	 ol10NekKlkzLvmcfvK2YzOP8lEq7oqohoxNpOA3XbD3B+UDPIYGkgfeORTGoJ9ZTak
	 KBCBsN2XQk2poF/RmRcld0RwA/e0Za/FncemL8JYvI2/2JUCZhSfzbdVZc7oKKrAmF
	 51hSa1R3rBQMXc/rgxxKtLU2dpz2mnnC0+zTXZ6xeRFUEx682jy8qB8KpBHHP/cy2H
	 cuv+qK9PHAVGJe+83wcvgEd7h0AGe6FZqLnhb4lctK84lC24/b748yFneCJwNafLgG
	 qNjAv/MiAlAFw==
Date: Sun, 31 Dec 2023 13:52:54 -0800
Subject: [PATCH 32/44] xfs: check reference counts of gaps between rt refcount
 records
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852096.1766284.10510831147720898764.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/rtrefcount.c |   81 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index 360b9c6a4c04d..058a0ea18e09b 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -17,6 +17,7 @@
 #include "xfs_rtgroup.h"
 #include "xfs_imeta.h"
 #include "xfs_rtrefcount_btree.h"
+#include "xfs_rtalloc.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -359,8 +360,14 @@ struct xchk_rtrefcbt_records {
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
@@ -401,6 +408,53 @@ xchk_rtrefcountbt_check_mergeable(
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
@@ -429,9 +483,26 @@ xchk_rtrefcountbt_rec(
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
 
@@ -476,7 +547,9 @@ xchk_rtrefcountbt(
 {
 	struct xfs_owner_info	btree_oinfo;
 	struct xchk_rtrefcbt_records rrc = {
-		.cow_blocks	= 0,
+		.cow_blocks		= 0,
+		.next_unshared_rgbno	= 0,
+		.prev_domain		= XFS_REFC_DOMAIN_SHARED,
 	};
 	int			error;
 
@@ -491,6 +564,12 @@ xchk_rtrefcountbt(
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

