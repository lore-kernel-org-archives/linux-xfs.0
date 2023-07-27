Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690E7C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjG0WXe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjG0WXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:23:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAD12D4D
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:23:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D99F761F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0D8C433C8;
        Thu, 27 Jul 2023 22:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496610;
        bh=a90DKJW5kL90Sl+vmjB2bhf1PzEKzsCEM51z97NqtUI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=B2K0s3V6uQC4CqARtKyrOT8OOSx4yg3yjf9dQJv/etksUbLjv4ExbOVZlSdFcrG/S
         mtmImFNTdxnufYZOCpJBlfJ5hgWUNkoGM/RUfwHTVrlC/r4sjOrs6+i+cB38zJ9e6A
         NUNZsNNTR8Ql+Co4Nfu1+qfz0H+FSDdycpHcWJR13TF/5chnzuFh/+385l3Oph8xM6
         TcNXhZjymH0zmxqGA7iV2SQf1uY6BE99KXKF775Cl/fR9zDtErAH/HBpqxJvr1PNyp
         qySh0DqqiQyyjdcngse50ncedu9fdxCZO3APPaCfrBMbIE3h1okPkNNaCChQxCdGDh
         kf1x2B30hueJg==
Date:   Thu, 27 Jul 2023 15:23:29 -0700
Subject: [PATCH 8/9] xfs: reap large AG metadata extents when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049622845.921010.286166239346686392.stgit@frogsfrogsfrogs>
In-Reply-To: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
References: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're freeing extents that have been set in a bitmap, break the
bitmap extent into multiple sub-extents organized by fate, and reap the
extents.  This enables us to dispose of old resources more efficiently
than doing them block by block.

While we're at it, rename the reaping functions to make it clear that
they're reaping per-AG extents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    2 
 fs/xfs/scrub/bitmap.c          |   37 ----
 fs/xfs/scrub/bitmap.h          |    4 
 fs/xfs/scrub/reap.c            |  399 ++++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/reap.h            |    2 
 fs/xfs/scrub/repair.c          |   51 +++++
 fs/xfs/scrub/repair.h          |    1 
 fs/xfs/scrub/trace.h           |   37 ++++
 8 files changed, 407 insertions(+), 126 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index b8d28cfec2866..9ad2987ed6e5a 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -775,7 +775,7 @@ xrep_agfl(
 		goto err;
 
 	/* Dump any AGFL overflow. */
-	error = xrep_reap_extents(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
+	error = xrep_reap_ag_metadata(sc, &agfl_extents, &XFS_RMAP_OINFO_AG,
 			XFS_AG_RESV_AGFL);
 err:
 	xbitmap_destroy(&agfl_extents);
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 0c959be396eab..d926d708f2956 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -385,43 +385,6 @@ xbitmap_walk(
 	return error;
 }
 
-struct xbitmap_walk_bits {
-	xbitmap_walk_bits_fn	fn;
-	void			*priv;
-};
-
-/* Walk all the bits in a run. */
-static int
-xbitmap_walk_bits_in_run(
-	uint64_t			start,
-	uint64_t			len,
-	void				*priv)
-{
-	struct xbitmap_walk_bits	*wb = priv;
-	uint64_t			i;
-	int				error = 0;
-
-	for (i = start; i < start + len; i++) {
-		error = wb->fn(i, wb->priv);
-		if (error)
-			break;
-	}
-
-	return error;
-}
-
-/* Call a function for every set bit in this bitmap. */
-int
-xbitmap_walk_bits(
-	struct xbitmap			*bitmap,
-	xbitmap_walk_bits_fn		fn,
-	void				*priv)
-{
-	struct xbitmap_walk_bits	wb = {.fn = fn, .priv = priv};
-
-	return xbitmap_walk(bitmap, xbitmap_walk_bits_in_run, &wb);
-}
-
 /* Does this bitmap have no bits set at all? */
 bool
 xbitmap_empty(
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 84981724ecafd..a3ad564d94b7f 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -33,10 +33,6 @@ typedef int (*xbitmap_walk_fn)(uint64_t start, uint64_t len, void *priv);
 int xbitmap_walk(struct xbitmap *bitmap, xbitmap_walk_fn fn,
 		void *priv);
 
-typedef int (*xbitmap_walk_bits_fn)(uint64_t bit, void *priv);
-int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
-		void *priv);
-
 bool xbitmap_empty(struct xbitmap *bitmap);
 bool xbitmap_test(struct xbitmap *bitmap, uint64_t start, uint64_t *len);
 
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index df13a9e0fe86a..f62f00f500540 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -27,6 +27,10 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_bmap.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_attr_remote.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -76,20 +80,29 @@
  */
 
 /* Information about reaping extents after a repair. */
-struct xrep_reap_state {
+struct xreap_state {
 	struct xfs_scrub		*sc;
 
 	/* Reverse mapping owner and metadata reservation type. */
 	const struct xfs_owner_info	*oinfo;
 	enum xfs_ag_resv_type		resv;
 
+	/* If true, roll the transaction before reaping the next extent. */
+	bool				force_roll;
+
 	/* Number of deferred reaps attached to the current transaction. */
 	unsigned int			deferred;
+
+	/* Number of invalidated buffers logged to the current transaction. */
+	unsigned int			invalidated;
+
+	/* Number of deferred reaps queued during the whole reap sequence. */
+	unsigned long long		total_deferred;
 };
 
 /* Put a block back on the AGFL. */
 STATIC int
-xrep_put_freelist(
+xreap_put_freelist(
 	struct xfs_scrub	*sc,
 	xfs_agblock_t		agbno)
 {
@@ -126,69 +139,227 @@ xrep_put_freelist(
 	return 0;
 }
 
-/* Try to invalidate the incore buffer for a block that we're about to free. */
+/* Are there any uncommitted reap operations? */
+static inline bool xreap_dirty(const struct xreap_state *rs)
+{
+	if (rs->force_roll)
+		return true;
+	if (rs->deferred)
+		return true;
+	if (rs->invalidated)
+		return true;
+	if (rs->total_deferred)
+		return true;
+	return false;
+}
+
+#define XREAP_MAX_DEFERRED	(128)
+#define XREAP_MAX_BINVAL	(2048)
+
+/*
+ * Decide if we want to roll the transaction after reaping an extent.  We don't
+ * want to overrun the transaction reservation, so we prohibit more than
+ * 128 EFIs per transaction.  For the same reason, we limit the number
+ * of buffer invalidations to 2048.
+ */
+static inline bool xreap_want_roll(const struct xreap_state *rs)
+{
+	if (rs->force_roll)
+		return true;
+	if (rs->deferred > XREAP_MAX_DEFERRED)
+		return true;
+	if (rs->invalidated > XREAP_MAX_BINVAL)
+		return true;
+	return false;
+}
+
+static inline void xreap_reset(struct xreap_state *rs)
+{
+	rs->total_deferred += rs->deferred;
+	rs->deferred = 0;
+	rs->invalidated = 0;
+	rs->force_roll = false;
+}
+
+#define XREAP_MAX_DEFER_CHAIN		(2048)
+
+/*
+ * Decide if we want to finish the deferred ops that are attached to the scrub
+ * transaction.  We don't want to queue huge chains of deferred ops because
+ * that can consume a lot of log space and kernel memory.  Hence we trigger a
+ * xfs_defer_finish if there are more than 2048 deferred reap operations or the
+ * caller did some real work.
+ */
+static inline bool
+xreap_want_defer_finish(const struct xreap_state *rs)
+{
+	if (rs->force_roll)
+		return true;
+	if (rs->total_deferred > XREAP_MAX_DEFER_CHAIN)
+		return true;
+	return false;
+}
+
+static inline void xreap_defer_finish_reset(struct xreap_state *rs)
+{
+	rs->total_deferred = 0;
+	rs->deferred = 0;
+	rs->invalidated = 0;
+	rs->force_roll = false;
+}
+
+/* Try to invalidate the incore buffers for an extent that we're freeing. */
 STATIC void
-xrep_block_reap_binval(
-	struct xfs_scrub	*sc,
-	xfs_fsblock_t		fsbno)
+xreap_agextent_binval(
+	struct xreap_state	*rs,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		*aglenp)
 {
-	struct xfs_buf		*bp = NULL;
-	int			error;
+	struct xfs_scrub	*sc = rs->sc;
+	struct xfs_perag	*pag = sc->sa.pag;
+	struct xfs_mount	*mp = sc->mp;
+	xfs_agnumber_t		agno = sc->sa.pag->pag_agno;
+	xfs_agblock_t		agbno_next = agbno + *aglenp;
+	xfs_agblock_t		bno = agbno;
 
 	/*
-	 * If there's an incore buffer for exactly this block, invalidate it.
 	 * Avoid invalidating AG headers and post-EOFS blocks because we never
 	 * own those.
 	 */
-	if (!xfs_verify_fsbno(sc->mp, fsbno))
+	if (!xfs_verify_agbno(pag, agbno) ||
+	    !xfs_verify_agbno(pag, agbno_next - 1))
 		return;
 
 	/*
-	 * We assume that the lack of any other known owners means that the
-	 * buffer can be locked without risk of deadlocking.
+	 * If there are incore buffers for these blocks, invalidate them.  We
+	 * assume that the lack of any other known owners means that the buffer
+	 * can be locked without risk of deadlocking.  The buffer cache cannot
+	 * detect aliasing, so employ nested loops to scan for incore buffers
+	 * of any plausible size.
 	 */
-	error = xfs_buf_incore(sc->mp->m_ddev_targp,
-			XFS_FSB_TO_DADDR(sc->mp, fsbno),
-			XFS_FSB_TO_BB(sc->mp, 1), XBF_LIVESCAN, &bp);
-	if (error)
-		return;
-
-	xfs_trans_bjoin(sc->tp, bp);
-	xfs_trans_binval(sc->tp, bp);
+	while (bno < agbno_next) {
+		xfs_agblock_t	fsbcount;
+		xfs_agblock_t	max_fsbs;
+
+		/*
+		 * Max buffer size is the max remote xattr buffer size, which
+		 * is one fs block larger than 64k.
+		 */
+		max_fsbs = min_t(xfs_agblock_t, agbno_next - bno,
+				xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX));
+
+		for (fsbcount = 1; fsbcount < max_fsbs; fsbcount++) {
+			struct xfs_buf	*bp = NULL;
+			xfs_daddr_t	daddr;
+			int		error;
+
+			daddr = XFS_AGB_TO_DADDR(mp, agno, bno);
+			error = xfs_buf_incore(mp->m_ddev_targp, daddr,
+					XFS_FSB_TO_BB(mp, fsbcount),
+					XBF_LIVESCAN, &bp);
+			if (error)
+				continue;
+
+			xfs_trans_bjoin(sc->tp, bp);
+			xfs_trans_binval(sc->tp, bp);
+			rs->invalidated++;
+
+			/*
+			 * Stop invalidating if we've hit the limit; we should
+			 * still have enough reservation left to free however
+			 * far we've gotten.
+			 */
+			if (rs->invalidated > XREAP_MAX_BINVAL) {
+				*aglenp -= agbno_next - bno;
+				goto out;
+			}
+		}
+
+		bno++;
+	}
+
+out:
+	trace_xreap_agextent_binval(sc->sa.pag, agbno, *aglenp);
 }
 
-/* Dispose of a single block. */
+/*
+ * Figure out the longest run of blocks that we can dispose of with a single
+ * call.  Cross-linked blocks should have their reverse mappings removed, but
+ * single-owner extents can be freed.  AGFL blocks can only be put back one at
+ * a time.
+ */
 STATIC int
-xrep_reap_block(
-	uint64_t			fsbno,
-	void				*priv)
+xreap_agextent_select(
+	struct xreap_state	*rs,
+	xfs_agblock_t		agbno,
+	xfs_agblock_t		agbno_next,
+	bool			*crosslinked,
+	xfs_extlen_t		*aglenp)
 {
-	struct xrep_reap_state		*rs = priv;
-	struct xfs_scrub		*sc = rs->sc;
-	struct xfs_btree_cur		*cur;
-	xfs_agnumber_t			agno;
-	xfs_agblock_t			agbno;
-	bool				has_other_rmap;
-	bool				need_roll = true;
-	int				error;
-
-	agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
-	agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
-
-	/* We don't support reaping file extents yet. */
-	if (sc->ip != NULL || sc->sa.pag->pag_agno != agno) {
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-
-	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp, sc->sa.pag);
-
-	/* Can we find any other rmappings? */
+	struct xfs_scrub	*sc = rs->sc;
+	struct xfs_btree_cur	*cur;
+	xfs_agblock_t		bno = agbno + 1;
+	xfs_extlen_t		len = 1;
+	int			error;
+
+	/*
+	 * Determine if there are any other rmap records covering the first
+	 * block of this extent.  If so, the block is crosslinked.
+	 */
+	cur = xfs_rmapbt_init_cursor(sc->mp, sc->tp, sc->sa.agf_bp,
+			sc->sa.pag);
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, rs->oinfo,
-			&has_other_rmap);
+			crosslinked);
+	if (error)
+		goto out_cur;
+
+	/* AGFL blocks can only be deal with one at a time. */
+	if (rs->resv == XFS_AG_RESV_AGFL)
+		goto out_found;
+
+	/*
+	 * Figure out how many of the subsequent blocks have the same crosslink
+	 * status.
+	 */
+	while (bno < agbno_next) {
+		bool		also_crosslinked;
+
+		error = xfs_rmap_has_other_keys(cur, bno, 1, rs->oinfo,
+				&also_crosslinked);
+		if (error)
+			goto out_cur;
+
+		if (*crosslinked != also_crosslinked)
+			break;
+
+		len++;
+		bno++;
+	}
+
+out_found:
+	*aglenp = len;
+	trace_xreap_agextent_select(sc->sa.pag, agbno, len, *crosslinked);
+out_cur:
 	xfs_btree_del_cursor(cur, error);
-	if (error)
-		return error;
+	return error;
+}
+
+/*
+ * Dispose of as much of the beginning of this AG extent as possible.  The
+ * number of blocks disposed of will be returned in @aglenp.
+ */
+STATIC int
+xreap_agextent_iter(
+	struct xreap_state	*rs,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		*aglenp,
+	bool			crosslinked)
+{
+	struct xfs_scrub	*sc = rs->sc;
+	xfs_fsblock_t		fsbno;
+	int			error = 0;
+
+	fsbno = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno, agbno);
 
 	/*
 	 * If there are other rmappings, this block is cross linked and must
@@ -203,55 +374,117 @@ xrep_reap_block(
 	 * blow on writeout, the filesystem will shut down, and the admin gets
 	 * to run xfs_repair.
 	 */
-	if (has_other_rmap) {
-		trace_xrep_dispose_unmap_extent(sc->sa.pag, agbno, 1);
+	if (crosslinked) {
+		trace_xreap_dispose_unmap_extent(sc->sa.pag, agbno, *aglenp);
 
-		error = xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
-				1, rs->oinfo);
-		if (error)
-			return error;
-
-		goto roll_out;
+		rs->force_roll = true;
+		return xfs_rmap_free(sc->tp, sc->sa.agf_bp, sc->sa.pag, agbno,
+				*aglenp, rs->oinfo);
 	}
 
-	trace_xrep_dispose_free_extent(sc->sa.pag, agbno, 1);
+	trace_xreap_dispose_free_extent(sc->sa.pag, agbno, *aglenp);
 
-	xrep_block_reap_binval(sc, fsbno);
+	/*
+	 * Invalidate as many buffers as we can, starting at agbno.  If this
+	 * function sets *aglenp to zero, the transaction is full of logged
+	 * buffer invalidations, so we need to return early so that we can
+	 * roll and retry.
+	 */
+	xreap_agextent_binval(rs, agbno, aglenp);
+	if (*aglenp == 0) {
+		ASSERT(xreap_want_roll(rs));
+		return 0;
+	}
 
+	/* Put blocks back on the AGFL one at a time. */
 	if (rs->resv == XFS_AG_RESV_AGFL) {
-		error = xrep_put_freelist(sc, agbno);
-	} else {
-		/*
-		 * Use deferred frees to get rid of the old btree blocks to try
-		 * to minimize the window in which we could crash and lose the
-		 * old blocks.  However, we still need to roll the transaction
-		 * every 100 or so EFIs so that we don't exceed the log
-		 * reservation.
-		 */
-		error = __xfs_free_extent_later(sc->tp, fsbno, 1, rs->oinfo,
-				rs->resv, true);
+		ASSERT(*aglenp == 1);
+		error = xreap_put_freelist(sc, agbno);
 		if (error)
 			return error;
-		rs->deferred++;
-		need_roll = rs->deferred > 100;
+
+		rs->force_roll = true;
+		return 0;
 	}
-	if (error || !need_roll)
+
+	/*
+	 * Use deferred frees to get rid of the old btree blocks to try to
+	 * minimize the window in which we could crash and lose the old blocks.
+	 */
+	error = __xfs_free_extent_later(sc->tp, fsbno, *aglenp, rs->oinfo,
+			rs->resv, true);
+	if (error)
 		return error;
 
-roll_out:
-	rs->deferred = 0;
-	return xrep_roll_ag_trans(sc);
+	rs->deferred++;
+	return 0;
 }
 
-/* Dispose of every block of every extent in the bitmap. */
+/*
+ * Break an AG metadata extent into sub-extents by fate (crosslinked, not
+ * crosslinked), and dispose of each sub-extent separately.
+ */
+STATIC int
+xreap_agmeta_extent(
+	uint64_t		fsbno,
+	uint64_t		len,
+	void			*priv)
+{
+	struct xreap_state	*rs = priv;
+	struct xfs_scrub	*sc = rs->sc;
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(sc->mp, fsbno);
+	xfs_agblock_t		agbno_next = agbno + len;
+	int			error = 0;
+
+	ASSERT(len <= XFS_MAX_BMBT_EXTLEN);
+	ASSERT(sc->ip == NULL);
+
+	if (agno != sc->sa.pag->pag_agno) {
+		ASSERT(sc->sa.pag->pag_agno == agno);
+		return -EFSCORRUPTED;
+	}
+
+	while (agbno < agbno_next) {
+		xfs_extlen_t	aglen;
+		bool		crosslinked;
+
+		error = xreap_agextent_select(rs, agbno, agbno_next,
+				&crosslinked, &aglen);
+		if (error)
+			return error;
+
+		error = xreap_agextent_iter(rs, agbno, &aglen, crosslinked);
+		if (error)
+			return error;
+
+		if (xreap_want_defer_finish(rs)) {
+			error = xrep_defer_finish(sc);
+			if (error)
+				return error;
+			xreap_defer_finish_reset(rs);
+		} else if (xreap_want_roll(rs)) {
+			error = xrep_roll_ag_trans(sc);
+			if (error)
+				return error;
+			xreap_reset(rs);
+		}
+
+		agbno += aglen;
+	}
+
+	return 0;
+}
+
+/* Dispose of every block of every AG metadata extent in the bitmap. */
 int
-xrep_reap_extents(
+xrep_reap_ag_metadata(
 	struct xfs_scrub		*sc,
 	struct xbitmap			*bitmap,
 	const struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type		type)
 {
-	struct xrep_reap_state		rs = {
+	struct xreap_state		rs = {
 		.sc			= sc,
 		.oinfo			= oinfo,
 		.resv			= type,
@@ -259,10 +492,14 @@ xrep_reap_extents(
 	int				error;
 
 	ASSERT(xfs_has_rmapbt(sc->mp));
+	ASSERT(sc->ip == NULL);
 
-	error = xbitmap_walk_bits(bitmap, xrep_reap_block, &rs);
-	if (error || rs.deferred == 0)
+	error = xbitmap_walk(bitmap, xreap_agmeta_extent, &rs);
+	if (error)
 		return error;
 
-	return xrep_roll_ag_trans(sc);
+	if (xreap_dirty(&rs))
+		return xrep_defer_finish(sc);
+
+	return 0;
 }
diff --git a/fs/xfs/scrub/reap.h b/fs/xfs/scrub/reap.h
index 85c8d8a5fe389..7f234abfa78d1 100644
--- a/fs/xfs/scrub/reap.h
+++ b/fs/xfs/scrub/reap.h
@@ -6,7 +6,7 @@
 #ifndef __XFS_SCRUB_REAP_H__
 #define __XFS_SCRUB_REAP_H__
 
-int xrep_reap_extents(struct xfs_scrub *sc, struct xbitmap *bitmap,
+int xrep_reap_ag_metadata(struct xfs_scrub *sc, struct xbitmap *bitmap,
 		const struct xfs_owner_info *oinfo,
 		enum xfs_ag_resv_type type);
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index a3eddfcb42fc1..83a1b1437a4fa 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -26,6 +26,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_defer.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -166,6 +167,56 @@ xrep_roll_ag_trans(
 	return 0;
 }
 
+/* Finish all deferred work attached to the repair transaction. */
+int
+xrep_defer_finish(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	/*
+	 * Keep the AG header buffers locked while we complete deferred work
+	 * items.  Ensure that both AG buffers are dirty and held when we roll
+	 * the transaction so that they move forward in the log without losing
+	 * the bli (and hence the bli type) when the transaction commits.
+	 *
+	 * Normal code would never hold clean buffers across a roll, but repair
+	 * needs both buffers to maintain a total lock on the AG.
+	 */
+	if (sc->sa.agi_bp) {
+		xfs_ialloc_log_agi(sc->tp, sc->sa.agi_bp, XFS_AGI_MAGICNUM);
+		xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
+	}
+
+	if (sc->sa.agf_bp) {
+		xfs_alloc_log_agf(sc->tp, sc->sa.agf_bp, XFS_AGF_MAGICNUM);
+		xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
+	}
+
+	/*
+	 * Finish all deferred work items.  We still hold the AG header buffers
+	 * locked regardless of whether or not that succeeds.  On failure, the
+	 * buffers will be released during teardown on our way out of the
+	 * kernel.  If successful, join the buffers to the new transaction
+	 * and move on.
+	 */
+	error = xfs_defer_finish(&sc->tp);
+	if (error)
+		return error;
+
+	/*
+	 * Release the hold that we set above because defer_finish won't do
+	 * that for us.  The defer roll code redirties held buffers after each
+	 * roll, so the AG header buffers should be ready for logging.
+	 */
+	if (sc->sa.agi_bp)
+		xfs_trans_bhold_release(sc->tp, sc->sa.agi_bp);
+	if (sc->sa.agf_bp)
+		xfs_trans_bhold_release(sc->tp, sc->sa.agf_bp);
+
+	return 0;
+}
+
 /*
  * Does the given AG have enough space to rebuild a btree?  Neither AG
  * reservation can be critical, and we must have enough space (factoring
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index e01d63a4a93b4..dc89164d10a63 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -20,6 +20,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 int xrep_attempt(struct xfs_scrub *sc);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
+int xrep_defer_finish(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);
 xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 71bfab3d2d290..73cf1002bd94a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -753,10 +753,43 @@ DECLARE_EVENT_CLASS(xrep_extent_class,
 DEFINE_EVENT(xrep_extent_class, name, \
 	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len), \
 	TP_ARGS(pag, agbno, len))
-DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_unmap_extent);
-DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_free_extent);
+DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_unmap_extent);
+DEFINE_REPAIR_EXTENT_EVENT(xreap_dispose_free_extent);
+DEFINE_REPAIR_EXTENT_EVENT(xreap_agextent_binval);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
+DECLARE_EVENT_CLASS(xrep_reap_find_class,
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len,
+		bool crosslinked),
+	TP_ARGS(pag, agbno, len, crosslinked),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(bool, crosslinked)
+	),
+	TP_fast_assign(
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->crosslinked = crosslinked;
+	),
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x crosslinked %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->crosslinked ? 1 : 0)
+);
+#define DEFINE_REPAIR_REAP_FIND_EVENT(name) \
+DEFINE_EVENT(xrep_reap_find_class, name, \
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len, \
+		 bool crosslinked), \
+	TP_ARGS(pag, agbno, len, crosslinked))
+DEFINE_REPAIR_REAP_FIND_EVENT(xreap_agextent_select);
+
 DECLARE_EVENT_CLASS(xrep_rmap_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
 		 xfs_agblock_t agbno, xfs_extlen_t len,

