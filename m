Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C39AEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjG0WYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjG0WYf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:24:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B904F0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:24:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91C7E61F6A
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1290C433C7;
        Thu, 27 Jul 2023 22:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496673;
        bh=jHztRVUPA28D1tU8NvwjbbfU5vGuKYqxVnEdgcCBkLo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=g4du9NqQxIZQSYJNTw5hX7feS/g4QVBEkDDe6mG8acRpsmGJ5P9xAR1WZfEITAMB9
         fdZBKLeDWnCCne2lTX5vAeIkanZepp+i75dNwwUaOe1WFSc2iVOlPj1YB7Ftda8Dw/
         dN/Ih1wMXtf/iTHi+nbV5aRKlOD8wFGVQWVKEQa/Du7AlikMBdWTy44g2HvDaTEf79
         g6bneU4AWMnRPWGdOc6t4iQqcFtAc/y3Zla6n+JEoVuZuUocZjP+Ln07ByLU3jrYsZ
         2PFCjBB2pBSBGpCxZfr6Q6XS7q07xHnzpKH+ibKokew6LKrD1QRgpyVUu0ZoO+/YQd
         9WhKOvJ7o40wQ==
Date:   Thu, 27 Jul 2023 15:24:32 -0700
Subject: [PATCH 3/6] xfs: log EFIs for all btree blocks being used to stage a
 btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623218.921279.10028914723578681696.stgit@frogsfrogsfrogs>
In-Reply-To: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
References: <169049623167.921279.16448199708156630380.stgit@frogsfrogsfrogs>
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
during log recovery.  Add a function to relog the EFIs, so that repair
can relog them all every time it creates a new btree block, which will
help us to avoid pinning the log tail.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/newbt.c  |  147 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h  |    4 +
 fs/xfs/scrub/repair.c |   10 +++
 fs/xfs/scrub/repair.h |    1 
 4 files changed, 162 insertions(+)


diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index 2eceac52f2834..cbfe2ffada635 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -13,12 +13,14 @@
 #include "xfs_btree_staging.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
+#include "xfs_log.h"
 #include "xfs_sb.h"
 #include "xfs_inode.h"
 #include "xfs_alloc.h"
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 #include "xfs_defer.h"
+#include "xfs_extfree_item.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -124,6 +126,139 @@ xrep_newbt_init_bare(
 			XFS_AG_RESV_NONE);
 }
 
+/*
+ * Set up automatic reaping of the blocks reserved for btree reconstruction in
+ * case we crash by logging a deferred free item for each extent we allocate so
+ * that we can get all of the space back if we crash before we can commit the
+ * new btree.  This function returns a token that can be used to cancel
+ * automatic reaping if repair is successful.
+ */
+static int
+xrep_newbt_schedule_autoreap(
+	struct xrep_newbt		*xnr,
+	struct xrep_newbt_resv		*resv)
+{
+	struct xfs_extent_free_item	efi_item = {
+		.xefi_blockcount	= resv->len,
+		.xefi_owner		= xnr->oinfo.oi_owner,
+		.xefi_flags		= XFS_EFI_SKIP_DISCARD,
+		.xefi_pag		= resv->pag,
+	};
+	struct xfs_scrub		*sc = xnr->sc;
+	struct xfs_log_item		*lip;
+	LIST_HEAD(items);
+
+	ASSERT(xnr->oinfo.oi_offset == 0);
+
+	efi_item.xefi_startblock = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno,
+			resv->agbno);
+	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_ATTR_FORK)
+		efi_item.xefi_flags |= XFS_EFI_ATTR_FORK;
+	if (xnr->oinfo.oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
+		efi_item.xefi_flags |= XFS_EFI_BMBT_BLOCK;
+
+	INIT_LIST_HEAD(&efi_item.xefi_list);
+	list_add(&efi_item.xefi_list, &items);
+
+	xfs_perag_intent_hold(resv->pag);
+	lip = xfs_extent_free_defer_type.create_intent(sc->tp, &items, 1,
+			false);
+	ASSERT(lip != NULL && !IS_ERR(lip));
+
+	resv->efi = lip;
+	return 0;
+}
+
+/*
+ * Earlier, we logged EFIs for the extents that we allocated to hold the new
+ * btree so that we could automatically roll back those allocations if the
+ * system crashed.  Now we log an EFD to cancel the EFI, either because the
+ * repair succeeded and the new blocks are in use; or because the repair was
+ * cancelled and we're about to free the extents directly.
+ */
+static inline void
+xrep_newbt_finish_autoreap(
+	struct xfs_scrub	*sc,
+	struct xrep_newbt_resv	*resv)
+{
+	struct xfs_efd_log_item	*efdp;
+	struct xfs_extent	*extp;
+	struct xfs_log_item	*efd_lip;
+
+	efd_lip = xfs_extent_free_defer_type.create_done(sc->tp, resv->efi, 1);
+	efdp = container_of(efd_lip, struct xfs_efd_log_item, efd_item);
+	extp = efdp->efd_format.efd_extents;
+	extp->ext_start = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno,
+					 resv->agbno);
+	extp->ext_len = resv->len;
+	efdp->efd_next_extent++;
+	set_bit(XFS_LI_DIRTY, &efd_lip->li_flags);
+	xfs_perag_intent_rele(resv->pag);
+}
+
+/* Abort an EFI logged for a new btree block reservation. */
+static inline void
+xrep_newbt_cancel_autoreap(
+	struct xrep_newbt_resv	*resv)
+{
+	xfs_extent_free_defer_type.abort_intent(resv->efi);
+	xfs_perag_intent_rele(resv->pag);
+}
+
+/*
+ * Relog the EFIs attached to a staging btree so that we don't pin the log
+ * tail.  Same logic as xfs_defer_relog.
+ */
+int
+xrep_newbt_relog_autoreap(
+	struct xrep_newbt	*xnr)
+{
+	struct xrep_newbt_resv	*resv;
+	unsigned int		efi_bytes = 0;
+
+	list_for_each_entry(resv, &xnr->resv_list, list) {
+		/*
+		 * If the log intent item for this deferred op is in a
+		 * different checkpoint, relog it to keep the log tail moving
+		 * forward.  We're ok with this being racy because an incorrect
+		 * decision means we'll be a little slower at pushing the tail.
+		 */
+		if (!resv->efi || xfs_log_item_in_current_chkpt(resv->efi))
+			continue;
+
+		resv->efi = xfs_trans_item_relog(resv->efi, xnr->sc->tp);
+
+		/*
+		 * If free space is very fragmented, it's possible that the new
+		 * btree will be allocated a large number of small extents.
+		 * On an active system, it's possible that so many of those
+		 * EFIs will need relogging here that doing them all in one
+		 * transaction will overflow the reservation.
+		 *
+		 * Each allocation for the new btree (xrep_newbt_resv) points
+		 * to a unique single-mapping EFI, so each relog operation logs
+		 * a single-mapping EFD followed by a new EFI.  Each single
+		 * mapping EF[ID] item consumes about 128 bytes, so we'll
+		 * assume 256 bytes per relog.  Roll if we consume more than
+		 * half of the transaction reservation.
+		 */
+		efi_bytes += 256;
+		if (efi_bytes > xnr->sc->tp->t_log_res / 2) {
+			int	error;
+
+			error = xrep_roll_trans(xnr->sc);
+			if (error)
+				return error;
+
+			efi_bytes = 0;
+		}
+	}
+
+	if (xnr->sc->tp->t_flags & XFS_TRANS_DIRTY)
+		return xrep_roll_trans(xnr->sc);
+	return 0;
+}
+
 /*
  * Designate specific blocks to be used to build our new btree.  @pag must be
  * a passive reference.
@@ -136,6 +271,7 @@ xrep_newbt_add_blocks(
 	xfs_extlen_t			len)
 {
 	struct xrep_newbt_resv		*resv;
+	int				error;
 
 	resv = kmalloc(sizeof(struct xrep_newbt_resv), XCHK_GFP_FLAGS);
 	if (!resv)
@@ -147,8 +283,16 @@ xrep_newbt_add_blocks(
 	resv->used = 0;
 	resv->pag = xfs_perag_hold(pag);
 
+	error = xrep_newbt_schedule_autoreap(xnr, resv);
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
@@ -326,6 +470,8 @@ xrep_newbt_free_extent(
 		free_aglen -= resv->used;
 	}
 
+	xrep_newbt_finish_autoreap(sc, resv);
+
 	if (free_aglen == 0)
 		return 0;
 
@@ -396,6 +542,7 @@ xrep_newbt_free(
 	 * reservations.
 	 */
 	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		xrep_newbt_cancel_autoreap(resv);
 		list_del(&resv->list);
 		xfs_perag_put(resv->pag);
 		kfree(resv);
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
index ca53271f3a4c6..cf822472f1667 100644
--- a/fs/xfs/scrub/newbt.h
+++ b/fs/xfs/scrub/newbt.h
@@ -12,6 +12,9 @@ struct xrep_newbt_resv {
 
 	struct xfs_perag	*pag;
 
+	/* EFI tracking this space reservation */
+	struct xfs_log_item	*efi;
+
 	/* AG block of the extent we reserved. */
 	xfs_agblock_t		agbno;
 
@@ -58,5 +61,6 @@ void xrep_newbt_cancel(struct xrep_newbt *xnr);
 int xrep_newbt_commit(struct xrep_newbt *xnr);
 int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xnr,
 		union xfs_btree_ptr *ptr);
+int xrep_newbt_relog_autoreap(struct xrep_newbt *xnr);
 
 #endif /* __XFS_SCRUB_NEWBT_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 83a1b1437a4fa..c2474cc40d04c 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -167,6 +167,16 @@ xrep_roll_ag_trans(
 	return 0;
 }
 
+/* Roll the scrub transaction, holding the primary metadata locked. */
+int
+xrep_roll_trans(
+	struct xfs_scrub	*sc)
+{
+	if (!sc->ip)
+		return xrep_roll_ag_trans(sc);
+	return xfs_trans_roll_inode(&sc->tp, sc->ip);
+}
+
 /* Finish all deferred work attached to the repair transaction. */
 int
 xrep_defer_finish(
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index dc89164d10a63..9ea1eb0aae49d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -20,6 +20,7 @@ static inline int xrep_notsupported(struct xfs_scrub *sc)
 int xrep_attempt(struct xfs_scrub *sc);
 void xrep_failure(struct xfs_mount *mp);
 int xrep_roll_ag_trans(struct xfs_scrub *sc);
+int xrep_roll_trans(struct xfs_scrub *sc);
 int xrep_defer_finish(struct xfs_scrub *sc);
 bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
 		enum xfs_ag_resv_type type);

