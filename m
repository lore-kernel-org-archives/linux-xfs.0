Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C476C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236031AbiLaB4X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235949AbiLaB4W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:56:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4756FAE5C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:56:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9B6661C63
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431F0C433EF;
        Sat, 31 Dec 2022 01:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451780;
        bh=8nyt3bfFmYyo3to7g0XUFNOT/zOvYt6kGnZ9Vy3Rtaw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ekaq2HqeZNM2VXh6FW4b1IoHAZ+zohXwyuwr4VLiYsybLVqV9XclNYLwrPuR2Qhjf
         yTQ0x8hsG6mR6pOFxL7QUntEMwyZHPU+abi64cxldi7ID29htR9iXWZHdtAK+M4X6E
         RSrKdAZhTZt/dDT956NhbQTvpvS7JcFaOfUjcwrcYa1R0ZXRb5e043jo6XGGkt73bt
         m3JszyHTTvnnUfRALWR2Jo3QKzwDudhmfutwG6X3U+6p9KdMLdGcz61s7MbSoJ8Ga0
         JROdHsrEOoXDDtn3hAgQY5I8FVewBV+w/+95nUqhn+yK0R7ym2rVUISiMzJp301CFZ
         35RPYedyA8WZw==
Subject: [PATCH 32/42] xfs: check reference counts of gaps between rt refcount
 records
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:33 -0800
Message-ID: <167243871351.717073.16895686653523718159.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 05512f8443a2..3cb2ff8443da 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -15,6 +15,7 @@
 #include "xfs_inode.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtalloc.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/btree.h"
@@ -356,8 +357,14 @@ struct xchk_rtrefcbt_records {
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
@@ -398,6 +405,53 @@ xchk_rtrefcountbt_check_mergeable(
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
@@ -426,9 +480,26 @@ xchk_rtrefcountbt_rec(
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
 
@@ -473,7 +544,9 @@ xchk_rtrefcountbt(
 {
 	struct xfs_owner_info	btree_oinfo;
 	struct xchk_rtrefcbt_records rrc = {
-		.cow_blocks	= 0,
+		.cow_blocks		= 0,
+		.next_unshared_rgbno	= 0,
+		.prev_domain		= XFS_REFC_DOMAIN_SHARED,
 	};
 	int			error;
 
@@ -488,6 +561,12 @@ xchk_rtrefcountbt(
 	if (error)
 		goto out_unlock;
 
+	/*
+	 * Check that all blocks between the last refcount > 1 record and the
+	 * end of the rt volume have at most one reverse mapping.
+	 */
+	xchk_rtrefcountbt_xref_gaps(sc, &rrc, sc->mp->m_sb.sb_rblocks);
+
 	xchk_refcount_xref_rmap(sc, &btree_oinfo, rrc.cow_blocks);
 
 out_unlock:

