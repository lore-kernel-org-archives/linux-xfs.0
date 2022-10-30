Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436F1ECAAA1
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJ3Xl4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3Xlz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:41:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EA6D9FF5
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 685BACE10A0
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD0EC433C1;
        Sun, 30 Oct 2022 23:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173310;
        bh=eBOJJweUzrvBpVaYczknq4FRo/BGDsfOsRif4Ep2vNg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=deEC5eJiT7VD70eSgPMNAiksi5JeCB5QSWUHJNeXYrwLbyujME+gVlFffa511fbKO
         CCbylDbib4pFDr3MfGi/gjqCG29acrDTw/AIiuL7SiGfXqejLroIpOA8E2Or4ardzn
         kOvbANIkHn/DzWCPolinp8kS0MRuov/huIVJJYSWeL152Lmz/wniluhnehEvd2R9HS
         2SQQqGCk2YisL4xP7/Xe6ckwadQMyUjAFoYS0MQwt/lrCA/bVmElvvs9Ukt5U4Qiud
         Ed41Pn09VFbVgzMcDGmBJCfi2UV3inzLLmK8im1nKGYisUv1j8L1pec0AU942VdCzs
         zk/OV9xJjG1mQ==
Subject: [PATCH 05/13] xfs: refactor refcount record usage in
 xchk_refcountbt_rec
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:41:50 -0700
Message-ID: <166717331016.417886.10294356066395417472.stgit@magnolia>
In-Reply-To: <166717328145.417886.10627661186183843873.stgit@magnolia>
References: <166717328145.417886.10627661186183843873.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Consolidate the open-coded xfs_refcount_irec fields into an actual
struct and use the existing _btrec_to_irec to decode the ondisk record.
This will reduce code churn in the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/scrub/refcount.c |   54 +++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 30 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 9959397f797f..9e6b36ac8079 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -269,15 +269,13 @@ xchk_refcountbt_process_rmap_fragments(
 STATIC void
 xchk_refcountbt_xref_rmap(
 	struct xfs_scrub		*sc,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
-	xfs_nlink_t			refcount)
+	const struct xfs_refcount_irec	*irec)
 {
 	struct xchk_refcnt_check	refchk = {
-		.sc = sc,
-		.bno = bno,
-		.len = len,
-		.refcount = refcount,
+		.sc			= sc,
+		.bno			= irec->rc_startblock,
+		.len			= irec->rc_blockcount,
+		.refcount		= irec->rc_refcount,
 		.seen = 0,
 	};
 	struct xfs_rmap_irec		low;
@@ -291,9 +289,9 @@ xchk_refcountbt_xref_rmap(
 
 	/* Cross-reference with the rmapbt to confirm the refcount. */
 	memset(&low, 0, sizeof(low));
-	low.rm_startblock = bno;
+	low.rm_startblock = irec->rc_startblock;
 	memset(&high, 0xFF, sizeof(high));
-	high.rm_startblock = bno + len - 1;
+	high.rm_startblock = irec->rc_startblock + irec->rc_blockcount - 1;
 
 	INIT_LIST_HEAD(&refchk.fragments);
 	error = xfs_rmap_query_range(sc->sa.rmap_cur, &low, &high,
@@ -302,7 +300,7 @@ xchk_refcountbt_xref_rmap(
 		goto out_free;
 
 	xchk_refcountbt_process_rmap_fragments(&refchk);
-	if (refcount != refchk.seen)
+	if (irec->rc_refcount != refchk.seen)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 
 out_free:
@@ -315,17 +313,16 @@ xchk_refcountbt_xref_rmap(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_refcountbt_xref(
-	struct xfs_scrub	*sc,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		len,
-	xfs_nlink_t		refcount)
+	struct xfs_scrub		*sc,
+	const struct xfs_refcount_irec	*irec)
 {
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
-	xchk_xref_is_used_space(sc, agbno, len);
-	xchk_xref_is_not_inode_chunk(sc, agbno, len);
-	xchk_refcountbt_xref_rmap(sc, agbno, len, refcount);
+	xchk_xref_is_used_space(sc, irec->rc_startblock, irec->rc_blockcount);
+	xchk_xref_is_not_inode_chunk(sc, irec->rc_startblock,
+			irec->rc_blockcount);
+	xchk_refcountbt_xref_rmap(sc, irec);
 }
 
 /* Scrub a refcountbt record. */
@@ -334,34 +331,31 @@ xchk_refcountbt_rec(
 	struct xchk_btree	*bs,
 	const union xfs_btree_rec *rec)
 {
+	struct xfs_refcount_irec irec;
 	xfs_agblock_t		*cow_blocks = bs->private;
 	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
-	xfs_agblock_t		bno;
-	xfs_extlen_t		len;
-	xfs_nlink_t		refcount;
 	bool			has_cowflag;
 
-	bno = be32_to_cpu(rec->refc.rc_startblock);
-	len = be32_to_cpu(rec->refc.rc_blockcount);
-	refcount = be32_to_cpu(rec->refc.rc_refcount);
+	xfs_refcount_btrec_to_irec(rec, &irec);
 
 	/* Only CoW records can have refcount == 1. */
-	has_cowflag = (bno & XFS_REFC_COW_START);
-	if ((refcount == 1 && !has_cowflag) || (refcount != 1 && has_cowflag))
+	has_cowflag = (irec.rc_startblock & XFS_REFC_COW_START);
+	if ((irec.rc_refcount == 1 && !has_cowflag) ||
+	    (irec.rc_refcount != 1 && has_cowflag))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 	if (has_cowflag)
-		(*cow_blocks) += len;
+		(*cow_blocks) += irec.rc_blockcount;
 
 	/* Check the extent. */
-	bno &= ~XFS_REFC_COW_START;
+	irec.rc_startblock &= ~XFS_REFC_COW_START;
 
-	if (!xfs_verify_agbext(pag, bno, len))
+	if (!xfs_verify_agbext(pag, irec.rc_startblock, irec.rc_blockcount))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	if (refcount == 0)
+	if (irec.rc_refcount == 0)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
+	xchk_refcountbt_xref(bs->sc, &irec);
 
 	return 0;
 }

