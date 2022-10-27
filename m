Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516D3FA3740
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Oct 2022 17:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234239AbiJ0ROh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiJ0ROd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Oct 2022 13:14:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E7DFC0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 10:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8980AB826D7
        for <linux-xfs@vger.kernel.org>; Thu, 27 Oct 2022 17:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A088C433D6;
        Thu, 27 Oct 2022 17:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890866;
        bh=6BOBPznt/OdwIUslyS2Uq85tsLwcWDhDJMgwF+UBA38=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vMxOd/31XVgpLGe63+EEorXz+6E79fRzM26847kweKQMtWgsvzt82K849Q7ioXQCZ
         tI/h2azeq8c/vhfCIC6QD+2UctpG3klpFuQ7dNlOReR3tlJB0LgBJziFixwJOM0jFO
         V/AzZkp3FLUAJjC0g6EpE9udQSQ0UQ/mkD0Lp21HMPi2mBTOG7JmmjBCkcFmvue5pf
         ClDJhlKsFVHswp1ZRCVJdmdRrkWAOi6n3y2cD7riX8HrSGp72oeYMyaxwUTNg66eO7
         h7kkFyaBwrkgdpF05c58MKqq0a5ulUTT5HlMHYMof0P07J2Co/m+n0CaFvLnorfi+S
         FhzmRBw06piRA==
Subject: [PATCH 04/12] xfs: refactor refcount record usage in
 xchk_refcountbt_rec
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:14:25 -0700
Message-ID: <166689086587.3788582.6917561093265997787.stgit@magnolia>
In-Reply-To: <166689084304.3788582.15155501738043912776.stgit@magnolia>
References: <166689084304.3788582.15155501738043912776.stgit@magnolia>
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
 fs/xfs/scrub/refcount.c |   58 +++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index c68b767dc08f..8ab55e791ea8 100644
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
@@ -334,35 +331,32 @@ xchk_refcountbt_rec(
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
-	if (bno + len <= bno ||
-	    !xfs_verify_agbno(pag, bno) ||
-	    !xfs_verify_agbno(pag, bno + len - 1))
+	irec.rc_startblock &= ~XFS_REFC_COW_START;
+	if (irec.rc_startblock + irec.rc_blockcount <= irec.rc_startblock ||
+	    !xfs_verify_agbno(pag, irec.rc_startblock) ||
+	    !xfs_verify_agbno(pag, irec.rc_startblock + irec.rc_blockcount - 1))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	if (refcount == 0)
+	if (irec.rc_refcount == 0)
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
 
-	xchk_refcountbt_xref(bs->sc, bno, len, refcount);
+	xchk_refcountbt_xref(bs->sc, &irec);
 
 	return 0;
 }

