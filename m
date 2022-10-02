Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A86C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:33:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiJBSc6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJBSc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:32:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0B63C164
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:32:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97E78B80D82
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:32:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F87C433C1;
        Sun,  2 Oct 2022 18:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735573;
        bh=taSlhEAeoNuhUbIbjwNe7S+YDu0JssDhAMPBUVUX/dY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lZHshC6/v+RgnUw0ml4+bQVU4oOilgmplwgwOa3InHiR/5HSHosny0HoAYl28Comb
         s+8fXbZo8FkmQWXs8MvNkKQ+G116wNGkPlJgx39557rSwzM/eqVEWh6xx3/YMC7maC
         I01aYkSHCRDDngSVrmktYd0hDgOmMr6dSYebe74WZEdaZ5QhzI6q2/OuR2NKrPkhzc
         kJrKPkJs2K2lZVq5UVMjszG6sJvUEjd3AJhGMSYUVGvRaTWbuXXyHziscbdb/euUtX
         0lxfwGoPA8nsXVYnHRZfRvvEaudOFnOEwxl4WK/sGFIglK+2cTOhxm4weYs3sHWOtm
         EVidry1zuEH4A==
Subject: [PATCH 4/5] xfs: check the reference counts of gaps in the refcount
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:16 -0700
Message-ID: <166473481642.1084209.18220457727847413785.stgit@magnolia>
In-Reply-To: <166473481572.1084209.5434516873607335909.stgit@magnolia>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Gaps in the reference count btree are also significant -- for these
regions, there must not be any overlapping reverse mappings.  We don't
currently check this, so make the refcount scrubber more complete.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/refcount.c |   84 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 79 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index bfd48aaceb82..d97e7e372b9c 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -332,14 +332,69 @@ xchk_refcountbt_xref(
 	xchk_refcountbt_xref_rmap(sc, agbno, len, refcount);
 }
 
+struct xchk_refcbt_records {
+	/* The next AG block where we aren't expecting shared extents. */
+	xfs_agblock_t		next_unshared_agbno;
+
+	/* Number of CoW blocks we expect. */
+	xfs_agblock_t		cow_blocks;
+};
+
+STATIC int
+xchk_refcountbt_rmap_check_gap(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	xfs_agblock_t			*next_bno = priv;
+
+	if (*next_bno != NULLAGBLOCK && rec->rm_startblock < *next_bno)
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
+xchk_refcountbt_xref_gaps(
+	struct xfs_scrub	*sc,
+	struct xchk_refcbt_records *rrc,
+	xfs_agblock_t		bno)
+{
+	struct xfs_rmap_irec	low;
+	struct xfs_rmap_irec	high;
+	xfs_agblock_t		next_bno = NULLAGBLOCK;
+	int			error;
+
+	if (bno <= rrc->next_unshared_agbno || !sc->sa.rmap_cur ||
+            xchk_skip_xref(sc->sm))
+		return;
+
+	memset(&low, 0, sizeof(low));
+	low.rm_startblock = rrc->next_unshared_agbno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rm_startblock = bno - 1;
+
+	error = xfs_rmap_query_range(sc->sa.rmap_cur, &low, &high,
+			xchk_refcountbt_rmap_check_gap, &next_bno);
+	if (error == -ECANCELED)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+	else
+		xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur);
+}
+
 /* Scrub a refcountbt record. */
 STATIC int
 xchk_refcountbt_rec(
 	struct xchk_btree	*bs,
 	const union xfs_btree_rec *rec)
 {
-	xfs_agblock_t		*cow_blocks = bs->private;
 	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
+	struct xchk_refcbt_records *rrc = bs->private;
 	xfs_agblock_t		bno;
 	xfs_extlen_t		len;
 	xfs_nlink_t		refcount;
@@ -354,7 +409,7 @@ xchk_refcountbt_rec(
 	if ((refcount == 1 && !has_cowflag) || (refcount != 1 && has_cowflag))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	if (has_cowflag)
-		(*cow_blocks) += len;
+		rrc->cow_blocks += len;
 
 	/* Check the extent. */
 	bno &= ~XFS_REFC_COW_START;
@@ -368,6 +423,16 @@ xchk_refcountbt_rec(
 
 	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
 
+	/*
+	 * If this is a record for a shared extent, check that all blocks
+	 * between the previous record and this one have at most one reverse
+	 * mapping.
+	 */
+	if (!has_cowflag) {
+		xchk_refcountbt_xref_gaps(bs->sc, rrc, bno);
+		rrc->next_unshared_agbno = bno + len;
+	}
+
 	return 0;
 }
 
@@ -409,15 +474,24 @@ int
 xchk_refcountbt(
 	struct xfs_scrub	*sc)
 {
-	xfs_agblock_t		cow_blocks = 0;
+	struct xchk_refcbt_records rrc = {
+		.cow_blocks		= 0,
+		.next_unshared_agbno	= 0,
+	};
 	int			error;
 
 	error = xchk_btree(sc, sc->sa.refc_cur, xchk_refcountbt_rec,
-			&XFS_RMAP_OINFO_REFC, &cow_blocks);
+			&XFS_RMAP_OINFO_REFC, &rrc);
 	if (error)
 		return error;
 
-	xchk_refcount_xref_rmap(sc, cow_blocks);
+	/*
+	 * Check that all blocks between the last refcount > 1 record and the
+	 * end of the AG have at most one reverse mapping.
+	 */
+	xchk_refcountbt_xref_gaps(sc, &rrc, sc->mp->m_sb.sb_agblocks);
+
+	xchk_refcount_xref_rmap(sc, rrc.cow_blocks);
 
 	return 0;
 }

