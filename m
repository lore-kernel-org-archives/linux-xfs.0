Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876B1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiL3Wik (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3Wik (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:38:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7F217E33
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:38:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B23FA61645
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:38:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE8EC433EF;
        Fri, 30 Dec 2022 22:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439918;
        bh=A4n4d7WDJAiNyO+5RLaSvhT6p6s5cmMezPaCbUFqxaE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kmqb/FeG0P/tIomfYaNouzJY6eEz38PzHGVDHPyFOQDF33OAHSJ+RjiL8QdN01vxa
         VKt6HYGlO/I9aQpzjsNZzbIW5SUjqxQH3xJTyDsEHMTQ20yHd57CngtGrZdO+8wYgZ
         A6c3aXutWGlWu1v+18xi3iNeW68FDDzi9kkF1cpHpp/OEhcpRRlIe+cuDtbVLNdXoC
         /hHedldZ/lrwsf6ztRCODw/9mfj29kBRDEZbQ/nvUaH4kqgVn+3/yMXgzVwj0bni1S
         L91fMIFTOUrT7GGMwTMfW5TQlvOqRwR9COAI1GXNhg88xLPubGzbqt26VnGfbV/GDA
         wHpCwqoZCCScQ==
Subject: [PATCH 3/8] xfs: standardize ondisk to incore conversion for refcount
 btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:11 -0800
Message-ID: <167243827174.683855.14164094517925889328.stgit@magnolia>
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

Create a xfs_refcount_check_irec function to detect corruption in btree
records.  Fix all xfs_refcount_btrec_to_irec callsites to call the new
helper and bubble up corruption reports.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   45 +++++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_refcount.h |    2 ++
 fs/xfs/scrub/refcount.c      |   14 +++----------
 3 files changed, 36 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 6dc968618e66..b77dea10c8bd 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -120,6 +120,30 @@ xfs_refcount_btrec_to_irec(
 	irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
 }
 
+/* Simple checks for refcount records. */
+xfs_failaddr_t
+xfs_refcount_check_irec(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*irec)
+{
+	struct xfs_perag		*pag = cur->bc_ag.pag;
+
+	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
+		return __this_address;
+
+	if (!xfs_refcount_check_domain(irec))
+		return __this_address;
+
+	/* check for valid extent range, including overflow */
+	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
+		return __this_address;
+
+	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+		return __this_address;
+
+	return NULL;
+}
+
 /*
  * Get the data from the pointed-to record.
  */
@@ -132,6 +156,7 @@ xfs_refcount_get_rec(
 	struct xfs_mount		*mp = cur->bc_mp;
 	struct xfs_perag		*pag = cur->bc_ag.pag;
 	union xfs_btree_rec		*rec;
+	xfs_failaddr_t			fa;
 	int				error;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
@@ -139,17 +164,8 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
-		goto out_bad_rec;
-
-	if (!xfs_refcount_check_domain(irec))
-		goto out_bad_rec;
-
-	/* check for valid extent range, including overflow */
-	if (!xfs_verify_agbext(pag, irec->rc_startblock, irec->rc_blockcount))
-		goto out_bad_rec;
-
-	if (irec->rc_refcount == 0 || irec->rc_refcount > MAXREFCOUNT)
+	fa = xfs_refcount_check_irec(cur, irec);
+	if (fa)
 		goto out_bad_rec;
 
 	trace_xfs_refcount_get(cur->bc_mp, pag->pag_agno, irec);
@@ -157,8 +173,8 @@ xfs_refcount_get_rec(
 
 out_bad_rec:
 	xfs_warn(mp,
-		"Refcount BTree record corruption in AG %d detected!",
-		pag->pag_agno);
+		"Refcount BTree record corruption in AG %d detected at %pS!",
+		pag->pag_agno, fa);
 	xfs_warn(mp,
 		"Start block 0x%x, block count 0x%x, references 0x%x",
 		irec->rc_startblock, irec->rc_blockcount, irec->rc_refcount);
@@ -1871,7 +1887,8 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (XFS_IS_CORRUPT(cur->bc_mp,
+	if (xfs_refcount_check_irec(cur, &rr->rr_rrec) != NULL ||
+	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		kfree(rr);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index c89f0fcd1ee3..fc0b58d4c379 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -117,6 +117,8 @@ extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
+xfs_failaddr_t xfs_refcount_check_irec(struct xfs_btree_cur *cur,
+		const struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
 
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 9423aad28511..c2ae5a328a6d 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -340,24 +340,16 @@ xchk_refcountbt_rec(
 {
 	struct xfs_refcount_irec irec;
 	xfs_agblock_t		*cow_blocks = bs->private;
-	struct xfs_perag	*pag = bs->cur->bc_ag.pag;
 
 	xfs_refcount_btrec_to_irec(rec, &irec);
-
-	/* Check the domain and refcount are not incompatible. */
-	if (!xfs_refcount_check_domain(&irec))
+	if (xfs_refcount_check_irec(bs->cur, &irec) != NULL) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
+		return 0;
+	}
 
 	if (irec.rc_domain == XFS_REFC_DOMAIN_COW)
 		(*cow_blocks) += irec.rc_blockcount;
 
-	/* Check the extent. */
-	if (!xfs_verify_agbext(pag, irec.rc_startblock, irec.rc_blockcount))
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
-	if (irec.rc_refcount == 0)
-		xchk_btree_set_corrupt(bs->sc, bs->cur, 0);
-
 	xchk_refcountbt_xref(bs->sc, &irec);
 
 	return 0;

