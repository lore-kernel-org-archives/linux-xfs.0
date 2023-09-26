Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6657DE7F14E
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjI0APG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjI0ANF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:13:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238691F20
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:32:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE3BC433C8;
        Tue, 26 Sep 2023 23:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771161;
        bh=zMd8nriu0ZnhfozJfe5g5iuukPI40ZhpJzcDE1n0pf8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rlLoFOQRqSGlCmkwqojpGaQbng53zPIK43GGpZapNShAopNTNKZx2BLvB5TDxfJIC
         gWtqbuVlN83qdnA2+LWxe/ZCR54g4x3eg9y1xJAq/stPVbhVaj3DvzxzSMITPMzbxv
         GJ5P/5IrKgB6gOjuvo/8X3UQToZzi095PyH+H7TsxLAgue3KGm/66q+Yf5Tb02fNAS
         GTqwkEAbYU2E6S6bYpo5PeO7qu8XCGHJ8dtW3iYh+tpIO3BCkfJf2HvH6G2Wv/ypSz
         fFZUjbC51Pz0uZTLPPrEb5ELpwhaPB7kyoRWI1dBkBMipXdtZUhtYl2DKnnAedFNLy
         4RcFNn22xOWsA==
Date:   Tue, 26 Sep 2023 16:32:41 -0700
Subject: [PATCH 6/7] xfs: log EFIs for all btree blocks being used to stage a
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059238.3312911.11027644382774083646.stgit@frogsfrogsfrogs>
In-Reply-To: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We need to log EFIs for every extent that we allocate for the purpose of
staging a new btree so that if we fail then the blocks will be freed
during log recovery.  Use the autoreaping mechanism provided by the
previous patch to attach paused freeing work to the scrub transaction.
We can then mark the EFIs stale if we decide to commit the new btree, or
we can unpause the EFIs if we decide to abort the repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/newbt.c |   34 ++++++++++++++++++++++++++--------
 fs/xfs/scrub/newbt.h |    3 +++
 2 files changed, 29 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 4e8d6637426e4..2932fd317ab23 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -136,6 +136,7 @@ xrep_newbt_add_blocks(
 {
 	struct xfs_mount		*mp = xnr->sc->mp;
 	struct xrep_newbt_resv		*resv;
+	int				error;
 
 	resv = kmalloc(sizeof(struct xrep_newbt_resv), XCHK_GFP_FLAGS);
 	if (!resv)
@@ -147,8 +148,18 @@ xrep_newbt_add_blocks(
 	resv->used = 0;
 	resv->pag = xfs_perag_hold(pag);
 
+	ASSERT(xnr->oinfo.oi_offset == 0);
+
+	error = xfs_alloc_schedule_autoreap(args, true, &resv->autoreap);
+	if (error)
+		goto out_pag;
+
 	list_add_tail(&resv->list, &xnr->resv_list);
 	return 0;
+out_pag:
+	xfs_perag_put(resv->pag);
+	kfree(resv);
+	return error;
 }
 
 /* Don't let our allocation hint take us beyond this AG */
@@ -327,16 +338,21 @@ xrep_newbt_free_extent(
 	if (!btree_committed || resv->used == 0) {
 		/*
 		 * If we're not committing a new btree or we didn't use the
-		 * space reservation, free the entire space extent.
+		 * space reservation, let the existing EFI free the entire
+		 * space extent.
 		 */
-		goto free;
+		trace_xrep_newbt_free_blocks(sc->mp, resv->pag->pag_agno,
+				free_agbno, free_aglen, xnr->oinfo.oi_owner);
+		xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
+		return 1;
 	}
 
 	/*
-	 * We used space and committed the btree.  Remove the written blocks
-	 * from the reservation and possibly log a new EFI to free any unused
-	 * reservation space.
+	 * We used space and committed the btree.  Cancel the autoreap, remove
+	 * the written blocks from the reservation, and possibly log a new EFI
+	 * to free any unused reservation space.
 	 */
+	xfs_alloc_cancel_autoreap(sc->tp, &resv->autoreap);
 	free_agbno += resv->used;
 	free_aglen -= resv->used;
 
@@ -348,7 +364,6 @@ xrep_newbt_free_extent(
 
 	ASSERT(xnr->resv != XFS_AG_RESV_AGFL);
 
-free:
 	/*
 	 * Use EFIs to free the reservations.  This reduces the chance
 	 * that we leak blocks if the system goes down.
@@ -408,9 +423,10 @@ xrep_newbt_free(
 	/*
 	 * If we still have reservations attached to @newbt, cleanup must have
 	 * failed and the filesystem is about to go down.  Clean up the incore
-	 * reservations.
+	 * reservations and try to commit to freeing the space we used.
 	 */
 	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
 		list_del(&resv->list);
 		xfs_perag_put(resv->pag);
 		kfree(resv);
@@ -488,5 +504,7 @@ xrep_newbt_claim_block(
 								agbno));
 	else
 		ptr->s = cpu_to_be32(agbno);
-	return 0;
+
+	/* Relog all the EFIs. */
+	return xrep_defer_finish(xnr->sc);
 }
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index ca53271f3a4c6..d2baffa17b1ae 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -12,6 +12,9 @@ struct xrep_newbt_resv {
 
 	struct xfs_perag	*pag;
 
+	/* Auto-freeing this reservation if we don't commit. */
+	struct xfs_alloc_autoreap autoreap;
+
 	/* AG block of the extent we reserved. */
 	xfs_agblock_t		agbno;
 

