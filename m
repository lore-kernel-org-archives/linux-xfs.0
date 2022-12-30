Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDFDC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbiL3WoK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3WoJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:44:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8475113CE7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F0C6B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ACFC433D2;
        Fri, 30 Dec 2022 22:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440244;
        bh=QwOwjwQghtJfx7Xj9HDd4oxXwtBwvWtP1EmM4JqZ82Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qh8XYDKQVaVoDfTgjucfnRiX+n1EMbDgw+AM++UVVEh3b9aQi3HTHLQChjqnxut76
         dY0K/OowrPA9OLtkOg0JnrQqvHMxvHvkTjUUBx4UCjt5tI6aMERlWjSIPbSaIAYl5+
         f4ZLN9WSw1SLwhMhHPfsKCkqG7K4AnVEKvf2PTQrk05Bzd8MSxc4T3rJfxCO14x2Mc
         DiwaRGPis1l8L7TTlye7njdbqY5iBAlhVb4FhDpj/DGvfWahk57V4yB9KuOSr7naZq
         XGI9WdiDRo3VCPVAKkEJVBowMG5W8jAEKKd9NfltSwcBoWHjGlLjnJGNGRLb7YOP/F
         9Ai9FrkVqxEGw==
Subject: [PATCH 3/4] xfs: directly cross-reference the inode btrees with each
 other
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:29 -0800
Message-ID: <167243828934.684591.5056055766224071541.stgit@magnolia>
In-Reply-To: <167243828888.684591.12405031427937736396.stgit@magnolia>
References: <167243828888.684591.12405031427937736396.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Improve the cross-referencing of the two inode btrees by directly
checking the free and hole state of each inode with the other btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/ialloc.c |  225 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 198 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index e5ce6a055ffe..65a6c01df235 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -51,32 +51,201 @@ struct xchk_iallocbt {
 };
 
 /*
- * If we're checking the finobt, cross-reference with the inobt.
- * Otherwise we're checking the inobt; if there is an finobt, make sure
- * we have a record or not depending on freecount.
+ * Does the finobt have a record for this inode with the same hole/free state?
+ * This is a bit complicated because of the following:
+ *
+ * - The finobt need not have a record if all inodes in the inobt record are
+ *   allocated.
+ * - The finobt need not have a record if all inodes in the inobt record are
+ *   free.
+ * - The finobt need not have a record if the inobt record says this is a hole.
+ *   This likely doesn't happen in practice.
  */
-static inline void
-xchk_iallocbt_chunk_xref_other(
+STATIC int
+xchk_inobt_xref_finobt(
+	struct xfs_scrub	*sc,
+	struct xfs_inobt_rec_incore *irec,
+	xfs_agino_t		agino,
+	bool			free,
+	bool			hole)
+{
+	struct xfs_inobt_rec_incore frec;
+	struct xfs_btree_cur	*cur = sc->sa.fino_cur;
+	bool			ffree, fhole;
+	unsigned int		frec_idx, fhole_idx;
+	int			has_record;
+	int			error;
+
+	ASSERT(cur->bc_btnum == XFS_BTNUM_FINO);
+
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has_record);
+	if (error)
+		return error;
+	if (!has_record)
+		goto no_record;
+
+	error = xfs_inobt_get_rec(cur, &frec, &has_record);
+	if (!has_record)
+		return -EFSCORRUPTED;
+
+	if (frec.ir_startino + XFS_INODES_PER_CHUNK <= agino)
+		goto no_record;
+
+	/* There's a finobt record; free and hole status must match. */
+	frec_idx = agino - frec.ir_startino;
+	ffree = frec.ir_free & (1ULL << frec_idx);
+	fhole_idx = frec_idx / XFS_INODES_PER_HOLEMASK_BIT;
+	fhole = frec.ir_holemask & (1U << fhole_idx);
+
+	if (ffree != free)
+		xchk_btree_xref_set_corrupt(sc, cur, 0);
+	if (fhole != hole)
+		xchk_btree_xref_set_corrupt(sc, cur, 0);
+	return 0;
+
+no_record:
+	/* inobt record is fully allocated */
+	if (irec->ir_free == 0)
+		return 0;
+
+	/* inobt record is totally unallocated */
+	if (irec->ir_free == XFS_INOBT_ALL_FREE)
+		return 0;
+
+	/* inobt record says this is a hole */
+	if (hole)
+		return 0;
+
+	/* finobt doesn't care about allocated inodes */
+	if (!free)
+		return 0;
+
+	xchk_btree_xref_set_corrupt(sc, cur, 0);
+	return 0;
+}
+
+/*
+ * Make sure that each inode of this part of an inobt record has the same
+ * sparse and free status as the finobt.
+ */
+STATIC void
+xchk_inobt_chunk_xref_finobt(
 	struct xfs_scrub		*sc,
 	struct xfs_inobt_rec_incore	*irec,
-	xfs_agino_t			agino)
+	xfs_agino_t			agino,
+	unsigned int			nr_inodes)
 {
-	struct xfs_btree_cur		**pcur;
-	bool				has_irec;
+	xfs_agino_t			i;
+	unsigned int			rec_idx;
 	int				error;
 
-	if (sc->sm->sm_type == XFS_SCRUB_TYPE_FINOBT)
-		pcur = &sc->sa.ino_cur;
-	else
-		pcur = &sc->sa.fino_cur;
-	if (!(*pcur))
+	ASSERT(sc->sm->sm_type == XFS_SCRUB_TYPE_INOBT);
+
+	if (!sc->sa.fino_cur || xchk_skip_xref(sc->sm))
 		return;
-	error = xfs_ialloc_has_inode_record(*pcur, agino, agino, &has_irec);
-	if (!xchk_should_check_xref(sc, &error, pcur))
+
+	for (i = agino, rec_idx = agino - irec->ir_startino;
+	     i < agino + nr_inodes;
+	     i++, rec_idx++) {
+		bool			free, hole;
+		unsigned int		hole_idx;
+
+		free = irec->ir_free & (1ULL << rec_idx);
+		hole_idx = rec_idx / XFS_INODES_PER_HOLEMASK_BIT;
+		hole = irec->ir_holemask & (1U << hole_idx);
+
+		error = xchk_inobt_xref_finobt(sc, irec, i, free, hole);
+		if (!xchk_should_check_xref(sc, &error, &sc->sa.fino_cur))
+			return;
+	}
+}
+
+/*
+ * Does the inobt have a record for this inode with the same hole/free state?
+ * The inobt must always have a record if there's a finobt record.
+ */
+STATIC int
+xchk_finobt_xref_inobt(
+	struct xfs_scrub	*sc,
+	struct xfs_inobt_rec_incore *frec,
+	xfs_agino_t		agino,
+	bool			ffree,
+	bool			fhole)
+{
+	struct xfs_inobt_rec_incore irec;
+	struct xfs_btree_cur	*cur = sc->sa.ino_cur;
+	bool			free, hole;
+	unsigned int		rec_idx, hole_idx;
+	int			has_record;
+	int			error;
+
+	ASSERT(cur->bc_btnum == XFS_BTNUM_INO);
+
+	error = xfs_inobt_lookup(cur, agino, XFS_LOOKUP_LE, &has_record);
+	if (error)
+		return error;
+	if (!has_record)
+		goto no_record;
+
+	error = xfs_inobt_get_rec(cur, &irec, &has_record);
+	if (!has_record)
+		return -EFSCORRUPTED;
+
+	if (irec.ir_startino + XFS_INODES_PER_CHUNK <= agino)
+		goto no_record;
+
+	/* There's an inobt record; free and hole status must match. */
+	rec_idx = agino - irec.ir_startino;
+	free = irec.ir_free & (1ULL << rec_idx);
+	hole_idx = rec_idx / XFS_INODES_PER_HOLEMASK_BIT;
+	hole = irec.ir_holemask & (1U << hole_idx);
+
+	if (ffree != free)
+		xchk_btree_xref_set_corrupt(sc, cur, 0);
+	if (fhole != hole)
+		xchk_btree_xref_set_corrupt(sc, cur, 0);
+	return 0;
+
+no_record:
+	/* finobt should never have a record for which the inobt does not */
+	xchk_btree_xref_set_corrupt(sc, cur, 0);
+	return 0;
+}
+
+/*
+ * Make sure that each inode of this part of an finobt record has the same
+ * sparse and free status as the inobt.
+ */
+STATIC void
+xchk_finobt_chunk_xref_inobt(
+	struct xfs_scrub		*sc,
+	struct xfs_inobt_rec_incore	*frec,
+	xfs_agino_t			agino,
+	unsigned int			nr_inodes)
+{
+	xfs_agino_t			i;
+	unsigned int			rec_idx;
+	int				error;
+
+	ASSERT(sc->sm->sm_type == XFS_SCRUB_TYPE_FINOBT);
+
+	if (!sc->sa.ino_cur || xchk_skip_xref(sc->sm))
 		return;
-	if (((irec->ir_freecount > 0 && !has_irec) ||
-	     (irec->ir_freecount == 0 && has_irec)))
-		xchk_btree_xref_set_corrupt(sc, *pcur, 0);
+
+	for (i = agino, rec_idx = agino - frec->ir_startino;
+	     i < agino + nr_inodes;
+	     i++, rec_idx++) {
+		bool			ffree, fhole;
+		unsigned int		hole_idx;
+
+		ffree = frec->ir_free & (1ULL << rec_idx);
+		hole_idx = rec_idx / XFS_INODES_PER_HOLEMASK_BIT;
+		fhole = frec->ir_holemask & (1U << hole_idx);
+
+		error = xchk_finobt_xref_inobt(sc, frec, i, ffree, fhole);
+		if (!xchk_should_check_xref(sc, &error, &sc->sa.ino_cur))
+			return;
+	}
 }
 
 /* Is this chunk worth checking and cross-referencing? */
@@ -85,14 +254,16 @@ xchk_iallocbt_chunk(
 	struct xchk_btree		*bs,
 	struct xfs_inobt_rec_incore	*irec,
 	xfs_agino_t			agino,
-	xfs_extlen_t			len)
+	unsigned int			nr_inodes)
 {
 	struct xfs_scrub		*sc = bs->sc;
 	struct xfs_mount		*mp = bs->cur->bc_mp;
 	struct xfs_perag		*pag = bs->cur->bc_ag.pag;
 	xfs_agblock_t			agbno;
+	xfs_extlen_t			len;
 
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
+	len = XFS_B_TO_FSB(mp, nr_inodes * mp->m_sb.sb_inodesize);
 
 	if (!xfs_verify_agbext(pag, agbno, len))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
@@ -101,7 +272,10 @@ xchk_iallocbt_chunk(
 		return false;
 
 	xchk_xref_is_used_space(sc, agbno, len);
-	xchk_iallocbt_chunk_xref_other(sc, irec, agino);
+	if (sc->sm->sm_type == XFS_SCRUB_TYPE_INOBT)
+		xchk_inobt_chunk_xref_finobt(sc, irec, agino, nr_inodes);
+	else
+		xchk_finobt_chunk_xref_inobt(sc, irec, agino, nr_inodes);
 	xchk_xref_is_owned_by(sc, agbno, len, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, len);
 	xchk_xref_is_not_cow_staging(sc, agbno, len);
@@ -406,7 +580,6 @@ xchk_iallocbt_rec(
 	struct xfs_inobt_rec_incore	irec;
 	uint64_t			holes;
 	xfs_agino_t			agino;
-	xfs_extlen_t			len;
 	int				holecount;
 	int				i;
 	int				error = 0;
@@ -428,12 +601,11 @@ xchk_iallocbt_rec(
 
 	/* Handle non-sparse inodes */
 	if (!xfs_inobt_issparse(irec.ir_holemask)) {
-		len = XFS_B_TO_FSB(mp,
-				XFS_INODES_PER_CHUNK * mp->m_sb.sb_inodesize);
 		if (irec.ir_count != XFS_INODES_PER_CHUNK)
 			xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-		if (!xchk_iallocbt_chunk(bs, &irec, agino, len))
+		if (!xchk_iallocbt_chunk(bs, &irec, agino,
+					XFS_INODES_PER_CHUNK))
 			goto out;
 		goto check_clusters;
 	}
@@ -441,8 +613,6 @@ xchk_iallocbt_rec(
 	/* Check each chunk of a sparse inode cluster. */
 	holemask = irec.ir_holemask;
 	holecount = 0;
-	len = XFS_B_TO_FSB(mp,
-			XFS_INODES_PER_HOLEMASK_BIT * mp->m_sb.sb_inodesize);
 	holes = ~xfs_inobt_irec_to_allocmask(&irec);
 	if ((holes & irec.ir_free) != holes ||
 	    irec.ir_freecount > irec.ir_count)
@@ -451,7 +621,8 @@ xchk_iallocbt_rec(
 	for (i = 0; i < XFS_INOBT_HOLEMASK_BITS; i++) {
 		if (holemask & 1)
 			holecount += XFS_INODES_PER_HOLEMASK_BIT;
-		else if (!xchk_iallocbt_chunk(bs, &irec, agino, len))
+		else if (!xchk_iallocbt_chunk(bs, &irec, agino,
+					XFS_INODES_PER_HOLEMASK_BIT))
 			goto out;
 		holemask >>= 1;
 		agino += XFS_INODES_PER_HOLEMASK_BIT;

