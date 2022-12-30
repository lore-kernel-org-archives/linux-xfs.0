Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1A71C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:38:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiL3WiM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3WiL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:38:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C23A17E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:38:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51532B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F3EC433D2;
        Fri, 30 Dec 2022 22:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439887;
        bh=7g9jviRNDaVqxJOF+5EZEZEMORa8evLf1rg4VijjlBU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PihZeSP3axgrxW0lmjWIDbj64DO5asZp59a4jp1PnDT0o6hZtw71Jgwu+lj1KrZDv
         Gyy39p7PWclkAVexiCJQC8nvdZcyz6rNk3yXp0NY9PrU2EKt/aO4cxVyI3jPuL+saT
         07/O+ShHDZbeai1Q6h6Fa7Sz3oRG00rkEk7c31643HJLQP9mI0llJPGxxRirp79Zp8
         JXFQm7dcwoVVHs0YHhDyxtZjoeO7TECWK030HouapglN3ewXYNdc+EukJMKQZGTI68
         w/U7vHZnspBtssfO+IZMdKUXq2EOZyVDHZsHmv1pZAW8BDDcoLFr3EjxqMHbcMOBMY
         b8Iq3gPsOdjXA==
Subject: [PATCH 1/8] xfs: standardize ondisk to incore conversion for free
 space btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:11 -0800
Message-ID: <167243827145.683855.2636636289945550594.stgit@magnolia>
In-Reply-To: <167243827121.683855.6049797551028464473.stgit@magnolia>
References: <167243827121.683855.6049797551028464473.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a xfs_alloc_btrec_to_irec function to convert an ondisk record to
an incore record, and a xfs_alloc_check_irec function to detect
corruption.  Replace all the open-coded logic with calls to the new
helpers and bubble up corruption reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   56 +++++++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_alloc.h |    6 +++++
 fs/xfs/scrub/alloc.c      |   24 ++++++++++---------
 3 files changed, 61 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 199f22ddc379..13b668673243 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -237,6 +237,34 @@ xfs_alloc_update(
 	return xfs_btree_update(cur, &rec);
 }
 
+/* Convert the ondisk btree record to its incore representation. */
+void
+xfs_alloc_btrec_to_irec(
+	const union xfs_btree_rec	*rec,
+	struct xfs_alloc_rec_incore	*irec)
+{
+	irec->ar_startblock = be32_to_cpu(rec->alloc.ar_startblock);
+	irec->ar_blockcount = be32_to_cpu(rec->alloc.ar_blockcount);
+}
+
+/* Simple checks for free space records. */
+xfs_failaddr_t
+xfs_alloc_check_irec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_alloc_rec_incore *irec)
+{
+	struct xfs_perag		*pag = cur->bc_ag.pag;
+
+	if (irec->ar_blockcount == 0)
+		return __this_address;
+
+	/* check for valid extent range, including overflow */
+	if (!xfs_verify_agbext(pag, irec->ar_startblock, irec->ar_blockcount))
+		return __this_address;
+
+	return NULL;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -247,34 +275,34 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat)	/* output: success/failure */
 {
+	struct xfs_alloc_rec_incore irec;
 	struct xfs_mount	*mp = cur->bc_mp;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
 	union xfs_btree_rec	*rec;
+	xfs_failaddr_t		fa;
 	int			error;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
 	if (error || !(*stat))
 		return error;
 
-	*bno = be32_to_cpu(rec->alloc.ar_startblock);
-	*len = be32_to_cpu(rec->alloc.ar_blockcount);
-
-	if (*len == 0)
-		goto out_bad_rec;
-
-	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbext(pag, *bno, *len))
+	xfs_alloc_btrec_to_irec(rec, &irec);
+	fa = xfs_alloc_check_irec(cur, &irec);
+	if (fa)
 		goto out_bad_rec;
 
+	*bno = irec.ar_startblock;
+	*len = irec.ar_blockcount;
 	return 0;
 
 out_bad_rec:
 	xfs_warn(mp,
-		"%s Freespace BTree record corruption in AG %d detected!",
+		"%s Freespace BTree record corruption in AG %d detected at %pS!",
 		cur->bc_btnum == XFS_BTNUM_BNO ? "Block" : "Size",
-		pag->pag_agno);
+		pag->pag_agno, fa);
 	xfs_warn(mp,
-		"start block 0x%x block count 0x%x", *bno, *len);
+		"start block 0x%x block count 0x%x", irec.ar_startblock,
+		irec.ar_blockcount);
 	return -EFSCORRUPTED;
 }
 
@@ -3450,8 +3478,10 @@ xfs_alloc_query_range_helper(
 	struct xfs_alloc_query_range_info	*query = priv;
 	struct xfs_alloc_rec_incore		irec;
 
-	irec.ar_startblock = be32_to_cpu(rec->alloc.ar_startblock);
-	irec.ar_blockcount = be32_to_cpu(rec->alloc.ar_blockcount);
+	xfs_alloc_btrec_to_irec(rec, &irec);
+	if (xfs_alloc_check_irec(cur, &irec) != NULL)
+		return -EFSCORRUPTED;
+
 	return query->fn(cur, &irec, query->priv);
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index f84f3966e849..becd06e5d0b8 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -170,6 +170,12 @@ xfs_alloc_get_rec(
 	xfs_extlen_t		*len,	/* output: length of extent */
 	int			*stat);	/* output: success/failure */
 
+union xfs_btree_rec;
+void xfs_alloc_btrec_to_irec(const union xfs_btree_rec *rec,
+		struct xfs_alloc_rec_incore *irec);
+xfs_failaddr_t xfs_alloc_check_irec(struct xfs_btree_cur *cur,
+		const struct xfs_alloc_rec_incore *irec);
+
 int xfs_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
 		struct xfs_buf **agfbpp);
 int xfs_alloc_read_agf(struct xfs_perag *pag, struct xfs_trans *tp, int flags,
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index d0509219722f..fb4f96716f6a 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -78,9 +78,11 @@ xchk_allocbt_xref_other(
 STATIC void
 xchk_allocbt_xref(
 	struct xfs_scrub	*sc,
-	xfs_agblock_t		agbno,
-	xfs_extlen_t		len)
+	const struct xfs_alloc_rec_incore *irec)
 {
+	xfs_agblock_t		agbno = irec->ar_startblock;
+	xfs_extlen_t		len = irec->ar_blockcount;
+
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		return;
 
@@ -93,20 +95,18 @@ xchk_allocbt_xref(
 /* Scrub a bnobt/cntbt record. */
 STATIC int
 xchk_allocbt_rec(
-	struct xchk_btree	*bs,
-	const union xfs_btree_rec *rec)
+	struct xchk_btree		*bs,
+	const union xfs_btree_rec	*rec)
 {
-	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
-	xfs_agblock_t		bno;
-	xfs_extlen_t		len;
+	struct xfs_alloc_rec_incore	irec;
 
-	bno = be32_to_cpu(rec->alloc.ar_startblock);
-	len = be32_to_cpu(rec->alloc.ar_blockcount);
-
-	if (!xfs_verify_agbext(pag, bno, len))
+	xfs_alloc_btrec_to_irec(rec, &irec);
+	if (xfs_alloc_check_irec(bs->cur, &irec) != NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
 
-	xchk_allocbt_xref(bs->sc, bno, len);
+	xchk_allocbt_xref(bs->sc, &irec);
 
 	return 0;
 }

