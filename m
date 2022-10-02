Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8747FC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiJBS16 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiJBS1y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39483B977
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8067CB80D88
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D32C433D6;
        Sun,  2 Oct 2022 18:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735267;
        bh=NrEQe4wZgwIZHUWCBg9fcTEbHj3VFeC8gyfg3kh80g4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=S6+9jSsgOgSri0GOBaVuvqI36OprrE2JR2Z7to2J0EUARvv1lT2s9xB+A6dmm14Vl
         NfASk47TAcqIbCSyNUWee1/Ac6dzBzZOglywiHM5ICEZB8A5uwnPRHheESfkQyEcQS
         +Ai9aFNKXg/TieUoG+kgL2bRXbKspukuz8a5O1y/zcyaEBQ99L9MBZDRCIIJw9v3O5
         hoWWIWqHnfsXUQsAuPnHq/bM9bAJ9QAszcbbS/k+CI+s6TZaQ9S6B2PlousoT7SFec
         lSmINTtR576o3Jjk/y3NKpI8bUBt/ULuGwBs1KzqUB2yopu9BlMtVnfiqtVKiwE/kM
         0keS9ghuKzVOQ==
Subject: [PATCH 2/4] xfs: don't track the AGFL buffer in the scrub AG context
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:48 -0700
Message-ID: <166473478879.1083155.7048621417340358108.stgit@magnolia>
In-Reply-To: <166473478844.1083155.9238102682926048449.stgit@magnolia>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While scrubbing an allocation group, we don't need to hold the AGFL
buffer as part of the scrub context.  All that is necessary to lock an
AG is to hold the AGI and AGF buffers, so fix all the existing users of
the AGFL buffer to grab them only when necessary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader.c        |   47 +++++++++++++++++++++++++---------------
 fs/xfs/scrub/agheader_repair.c |    1 -
 fs/xfs/scrub/common.c          |    8 -------
 fs/xfs/scrub/repair.c          |   11 +++++----
 fs/xfs/scrub/scrub.h           |    1 -
 5 files changed, 35 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index b7b838bd4ba4..af284baa6f4c 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -609,9 +609,16 @@ xchk_agf(
 /* AGFL */
 
 struct xchk_agfl_info {
-	unsigned int		sz_entries;
+	/* Number of AGFL entries that the AGF claims are in use. */
+	unsigned int		agflcount;
+
+	/* Number of AGFL entries that we found. */
 	unsigned int		nr_entries;
+
+	/* Buffer to hold AGFL entries for extent checking. */
 	xfs_agblock_t		*entries;
+
+	struct xfs_buf		*agfl_bp;
 	struct xfs_scrub	*sc;
 };
 
@@ -641,10 +648,10 @@ xchk_agfl_block(
 	struct xfs_scrub	*sc = sai->sc;
 
 	if (xfs_verify_agbno(sc->sa.pag, agbno) &&
-	    sai->nr_entries < sai->sz_entries)
+	    sai->nr_entries < sai->agflcount)
 		sai->entries[sai->nr_entries++] = agbno;
 	else
-		xchk_block_set_corrupt(sc, sc->sa.agfl_bp);
+		xchk_block_set_corrupt(sc, sai->agfl_bp);
 
 	xchk_agfl_block_xref(sc, agbno);
 
@@ -696,19 +703,26 @@ int
 xchk_agfl(
 	struct xfs_scrub	*sc)
 {
-	struct xchk_agfl_info	sai;
+	struct xchk_agfl_info	sai = {
+		.sc		= sc,
+	};
 	struct xfs_agf		*agf;
 	xfs_agnumber_t		agno = sc->sm->sm_agno;
-	unsigned int		agflcount;
 	unsigned int		i;
 	int			error;
 
+	/* Lock the AGF and AGI so that nobody can touch this AG. */
 	error = xchk_ag_read_headers(sc, agno, &sc->sa);
 	if (!xchk_process_error(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
-		goto out;
+		return error;
 	if (!sc->sa.agf_bp)
 		return -EFSCORRUPTED;
-	xchk_buffer_recheck(sc, sc->sa.agfl_bp);
+
+	/* Try to read the AGFL, and verify its structure if we get it. */
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &sai.agfl_bp);
+	if (!xchk_process_error(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
+		return error;
+	xchk_buffer_recheck(sc, sai.agfl_bp);
 
 	xchk_agfl_xref(sc);
 
@@ -717,24 +731,21 @@ xchk_agfl(
 
 	/* Allocate buffer to ensure uniqueness of AGFL entries. */
 	agf = sc->sa.agf_bp->b_addr;
-	agflcount = be32_to_cpu(agf->agf_flcount);
-	if (agflcount > xfs_agfl_size(sc->mp)) {
+	sai.agflcount = be32_to_cpu(agf->agf_flcount);
+	if (sai.agflcount > xfs_agfl_size(sc->mp)) {
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 		goto out;
 	}
-	memset(&sai, 0, sizeof(sai));
-	sai.sc = sc;
-	sai.sz_entries = agflcount;
-	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
-			KM_MAYFAIL);
+	sai.entries = kvcalloc(sai.agflcount, sizeof(xfs_agblock_t),
+			GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!sai.entries) {
 		error = -ENOMEM;
 		goto out;
 	}
 
 	/* Check the blocks in the AGFL. */
-	error = xfs_agfl_walk(sc->mp, sc->sa.agf_bp->b_addr,
-			sc->sa.agfl_bp, xchk_agfl_block, &sai);
+	error = xfs_agfl_walk(sc->mp, sc->sa.agf_bp->b_addr, sai.agfl_bp,
+			xchk_agfl_block, &sai);
 	if (error == -ECANCELED) {
 		error = 0;
 		goto out_free;
@@ -742,7 +753,7 @@ xchk_agfl(
 	if (error)
 		goto out_free;
 
-	if (agflcount != sai.nr_entries) {
+	if (sai.agflcount != sai.nr_entries) {
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 		goto out_free;
 	}
@@ -758,7 +769,7 @@ xchk_agfl(
 	}
 
 out_free:
-	kmem_free(sai.entries);
+	kvfree(sai.entries);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 1b0b4e243f77..2e75ff9b5b2e 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -697,7 +697,6 @@ xrep_agfl(
 	 * freespace overflow to the freespace btrees.
 	 */
 	sc->sa.agf_bp = agf_bp;
-	sc->sa.agfl_bp = agfl_bp;
 	error = xrep_roll_ag_trans(sc);
 	if (error)
 		goto err;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9bbbf20f401b..ad70f29233c3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -424,10 +424,6 @@ xchk_ag_read_headers(
 	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGF))
 		return error;
 
-	error = xfs_alloc_read_agfl(sa->pag, sc->tp, &sa->agfl_bp);
-	if (error && want_ag_read_header_failure(sc, XFS_SCRUB_TYPE_AGFL))
-		return error;
-
 	return 0;
 }
 
@@ -515,10 +511,6 @@ xchk_ag_free(
 	struct xchk_ag		*sa)
 {
 	xchk_ag_btcur_free(sa);
-	if (sa->agfl_bp) {
-		xfs_trans_brelse(sc->tp, sa->agfl_bp);
-		sa->agfl_bp = NULL;
-	}
 	if (sa->agf_bp) {
 		xfs_trans_brelse(sc->tp, sa->agf_bp);
 		sa->agf_bp = NULL;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index c18bd039fce9..2ada7fc1c398 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -126,8 +126,6 @@ xrep_roll_ag_trans(
 		xfs_trans_bhold(sc->tp, sc->sa.agi_bp);
 	if (sc->sa.agf_bp)
 		xfs_trans_bhold(sc->tp, sc->sa.agf_bp);
-	if (sc->sa.agfl_bp)
-		xfs_trans_bhold(sc->tp, sc->sa.agfl_bp);
 
 	/*
 	 * Roll the transaction.  We still own the buffer and the buffer lock
@@ -145,8 +143,6 @@ xrep_roll_ag_trans(
 		xfs_trans_bjoin(sc->tp, sc->sa.agi_bp);
 	if (sc->sa.agf_bp)
 		xfs_trans_bjoin(sc->tp, sc->sa.agf_bp);
-	if (sc->sa.agfl_bp)
-		xfs_trans_bjoin(sc->tp, sc->sa.agfl_bp);
 
 	return 0;
 }
@@ -498,6 +494,7 @@ xrep_put_freelist(
 	struct xfs_scrub	*sc,
 	xfs_agblock_t		agbno)
 {
+	struct xfs_buf		*agfl_bp;
 	int			error;
 
 	/* Make sure there's space on the freelist. */
@@ -516,8 +513,12 @@ xrep_put_freelist(
 		return error;
 
 	/* Put the block on the AGFL. */
+	error = xfs_alloc_read_agfl(sc->sa.pag, sc->tp, &agfl_bp);
+	if (error)
+		return error;
+
 	error = xfs_alloc_put_freelist(sc->sa.pag, sc->tp, sc->sa.agf_bp,
-			sc->sa.agfl_bp, agbno, 0);
+			agfl_bp, agbno, 0);
 	if (error)
 		return error;
 	xfs_extent_busy_insert(sc->tp, sc->sa.pag, agbno, 1,
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 3de5287e98d8..151567f88366 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -39,7 +39,6 @@ struct xchk_ag {
 
 	/* AG btree roots */
 	struct xfs_buf		*agf_bp;
-	struct xfs_buf		*agfl_bp;
 	struct xfs_buf		*agi_bp;
 
 	/* AG btrees */

