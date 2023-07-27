Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC03C0015E
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbjG0WYV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjG0WYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:24:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3BEF0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F00CF61F50
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53536C433C7;
        Thu, 27 Jul 2023 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496657;
        bh=eEFXKfrEHP8ZyHeMRpyVgpmSNxTX0+kiuUcnIP59Yb4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jrWjstB+GlcmymPcngipdpZJ0GE4bSwB/r7rlGCMIpjphhh5uVnhOry9g5tBfljnD
         e470UmxKub7z/nzUkbWhgxZMiT+MaToAWkWui/JY6zYMqqASJE5f6QFEnucCXjJrFh
         Y+PhDpKjhukoNE+NX41JeM6wkpPOfvcvQL1z7llXXCI0+Q3YF8MiPBCIyOk2YBdVNG
         +0jQzDXxa8syzGNB2QYhlXNR+tgPBEJWiexJ3iHCZJxelzk8hgKXI4oecrE5pY1ARJ
         YtA5OAK6I4Q0onUhBeK7iUWqyNb7vuM5IaFGGcDuXEkg6I/p+oxeWZXOt0t8BqZeLg
         mgZxObSoggq/g==
Date:   Thu, 27 Jul 2023 15:24:16 -0700
Subject: [PATCH 2/6] xfs: implement block reservation accounting for btrees
 we're staging
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049623203.921279.8246035009618084259.stgit@frogsfrogsfrogs>
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

Create a new xrep_newbt structure to encapsulate a fake root for
creating a staged btree cursor as well as to track all the blocks that
we need to reserve in order to build that btree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile                   |    1 
 fs/xfs/libxfs/xfs_btree_staging.h |    7 -
 fs/xfs/scrub/agheader_repair.c    |    1 
 fs/xfs/scrub/common.c             |    1 
 fs/xfs/scrub/newbt.c              |  477 +++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h              |   62 +++++
 fs/xfs/scrub/scrub.c              |    2 
 fs/xfs/scrub/trace.h              |   37 +++
 8 files changed, 583 insertions(+), 5 deletions(-)
 create mode 100644 fs/xfs/scrub/newbt.c
 create mode 100644 fs/xfs/scrub/newbt.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0a5cebb9802b1..d562d128af8ec 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -173,6 +173,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   newbt.o \
 				   reap.o \
 				   repair.o \
 				   )
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index f0d2976050aea..d6dea3f0088c6 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -38,11 +38,8 @@ struct xbtree_ifakeroot {
 	/* Number of bytes available for this fork in the inode. */
 	unsigned int		if_fork_size;
 
-	/* Fork format. */
-	unsigned int		if_format;
-
-	/* Number of records. */
-	unsigned int		if_extents;
+	/* Which fork is this btree being built for? */
+	int			if_whichfork;
 };
 
 /* Cursor interactions with fake roots for inode-rooted btrees. */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 9e99486b5f20b..7874ae8149caa 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7a20256be969a..532fa6729af4e 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
 #include "xfs_inode.h"
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
new file mode 100644
index 0000000000000..2eceac52f2834
--- /dev/null
+++ b/fs/xfs/scrub/newbt.c
@@ -0,0 +1,477 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap.h"
+#include "xfs_ag.h"
+#include "xfs_defer.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/newbt.h"
+
+/*
+ * Estimate proper slack values for a btree that's being reloaded.
+ *
+ * Under most circumstances, we'll take whatever default loading value the
+ * btree bulk loading code calculates for us.  However, there are some
+ * exceptions to this rule:
+ *
+ * (1) If someone turned one of the debug knobs.
+ * (2) If this is a per-AG btree and the AG has less than ~9% space free.
+ * (3) If this is an inode btree and the FS has less than ~9% space free.
+ *
+ * Note that we actually use 3/32 for the comparison to avoid division.
+ */
+static void
+xrep_newbt_estimate_slack(
+	struct xrep_newbt	*xnr)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	struct xfs_btree_bload	*bload = &xnr->bload;
+	uint64_t		free;
+	uint64_t		sz;
+
+	/* Let the btree code compute the default slack values. */
+	bload->leaf_slack = -1;
+	bload->node_slack = -1;
+
+	if (sc->ops->type == ST_PERAG) {
+		free = sc->sa.pag->pagf_freeblks;
+		sz = xfs_ag_block_count(sc->mp, sc->sa.pag->pag_agno);
+	} else {
+		free = percpu_counter_sum(&sc->mp->m_fdblocks);
+		sz = sc->mp->m_sb.sb_dblocks;
+	}
+
+	/* No further changes if there's more than 3/32ths space left. */
+	if (free >= ((sz * 3) >> 5))
+		return;
+
+	/* We're low on space; load the btrees as tightly as possible. */
+	if (bload->leaf_slack < 0)
+		bload->leaf_slack = 0;
+	if (bload->node_slack < 0)
+		bload->node_slack = 0;
+}
+
+/* Initialize accounting resources for staging a new AG btree. */
+void
+xrep_newbt_init_ag(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc,
+	const struct xfs_owner_info	*oinfo,
+	xfs_fsblock_t			alloc_hint,
+	enum xfs_ag_resv_type		resv)
+{
+	memset(xnr, 0, sizeof(struct xrep_newbt));
+	xnr->sc = sc;
+	xnr->oinfo = *oinfo; /* structure copy */
+	xnr->alloc_hint = alloc_hint;
+	xnr->resv = resv;
+	INIT_LIST_HEAD(&xnr->resv_list);
+	xrep_newbt_estimate_slack(xnr);
+}
+
+/* Initialize accounting resources for staging a new inode fork btree. */
+int
+xrep_newbt_init_inode(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc,
+	int				whichfork,
+	const struct xfs_owner_info	*oinfo)
+{
+	struct xfs_ifork		*ifp;
+
+	ifp = kmem_cache_zalloc(xfs_ifork_cache, XCHK_GFP_FLAGS);
+	if (!ifp)
+		return -ENOMEM;
+
+	xrep_newbt_init_ag(xnr, sc, oinfo,
+			XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino),
+			XFS_AG_RESV_NONE);
+	xnr->ifake.if_fork = ifp;
+	xnr->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, whichfork);
+	xnr->ifake.if_whichfork = whichfork;
+	return 0;
+}
+
+/*
+ * Initialize accounting resources for staging a new btree.  Callers are
+ * expected to add their own reservations (and clean them up) manually.
+ */
+void
+xrep_newbt_init_bare(
+	struct xrep_newbt		*xnr,
+	struct xfs_scrub		*sc)
+{
+	xrep_newbt_init_ag(xnr, sc, &XFS_RMAP_OINFO_ANY_OWNER, NULLFSBLOCK,
+			XFS_AG_RESV_NONE);
+}
+
+/*
+ * Designate specific blocks to be used to build our new btree.  @pag must be
+ * a passive reference.
+ */
+STATIC int
+xrep_newbt_add_blocks(
+	struct xrep_newbt		*xnr,
+	struct xfs_perag		*pag,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len)
+{
+	struct xrep_newbt_resv		*resv;
+
+	resv = kmalloc(sizeof(struct xrep_newbt_resv), XCHK_GFP_FLAGS);
+	if (!resv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&resv->list);
+	resv->agbno = agbno;
+	resv->len = len;
+	resv->used = 0;
+	resv->pag = xfs_perag_hold(pag);
+
+	list_add_tail(&resv->list, &xnr->resv_list);
+	return 0;
+}
+
+/* Don't let our allocation hint take us beyond this AG */
+static inline void
+xrep_newbt_validate_ag_alloc_hint(
+	struct xrep_newbt	*xnr)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(sc->mp, xnr->alloc_hint);
+
+	if (agno == sc->sa.pag->pag_agno &&
+	    xfs_verify_fsbno(sc->mp, xnr->alloc_hint))
+		return;
+
+	xnr->alloc_hint = XFS_AGB_TO_FSB(sc->mp, sc->sa.pag->pag_agno,
+					 XFS_AGFL_BLOCK(sc->mp) + 1);
+}
+
+/* Allocate disk space for a new per-AG btree. */
+STATIC int
+xrep_newbt_alloc_ag_blocks(
+	struct xrep_newbt	*xnr,
+	uint64_t		nr_blocks)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	int			error = 0;
+
+	ASSERT(sc->sa.pag != NULL);
+
+	while (nr_blocks > 0) {
+		struct xfs_alloc_arg	args = {
+			.tp		= sc->tp,
+			.mp		= sc->mp,
+			.oinfo		= xnr->oinfo,
+			.minlen		= 1,
+			.maxlen		= nr_blocks,
+			.prod		= 1,
+			.resv		= xnr->resv,
+		};
+
+		xrep_newbt_validate_ag_alloc_hint(xnr);
+
+		error = xfs_alloc_vextent_near_bno(&args, xnr->alloc_hint);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK)
+			return -ENOSPC;
+
+		trace_xrep_newbt_alloc_ag_blocks(sc->mp, args.agno, args.agbno,
+				args.len, xnr->oinfo.oi_owner);
+
+		error = xrep_newbt_add_blocks(xnr, sc->sa.pag, args.agbno,
+				args.len);
+		if (error)
+			return error;
+
+		nr_blocks -= args.len;
+		xnr->alloc_hint = args.fsbno + args.len;
+
+		error = xrep_defer_finish(sc);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Don't let our allocation hint take us beyond EOFS */
+static inline void
+xrep_newbt_validate_file_alloc_hint(
+	struct xrep_newbt	*xnr)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+
+	if (xfs_verify_fsbno(sc->mp, xnr->alloc_hint))
+		return;
+
+	xnr->alloc_hint = XFS_AGB_TO_FSB(sc->mp, 0, XFS_AGFL_BLOCK(sc->mp) + 1);
+}
+
+/* Allocate disk space for our new file-based btree. */
+STATIC int
+xrep_newbt_alloc_file_blocks(
+	struct xrep_newbt	*xnr,
+	uint64_t		nr_blocks)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	int			error = 0;
+
+	while (nr_blocks > 0) {
+		struct xfs_alloc_arg	args = {
+			.tp		= sc->tp,
+			.mp		= sc->mp,
+			.oinfo		= xnr->oinfo,
+			.minlen		= 1,
+			.maxlen		= nr_blocks,
+			.prod		= 1,
+			.resv		= xnr->resv,
+		};
+		struct xfs_perag	*pag;
+
+		xrep_newbt_validate_file_alloc_hint(xnr);
+
+		error = xfs_alloc_vextent_start_ag(&args, xnr->alloc_hint);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK)
+			return -ENOSPC;
+
+		trace_xrep_newbt_alloc_file_blocks(sc->mp, args.agno,
+				args.agbno, args.len, xnr->oinfo.oi_owner);
+
+		pag = xfs_perag_get(sc->mp, args.agno);
+		if (!pag) {
+			ASSERT(0);
+			return -EFSCORRUPTED;
+		}
+
+		error = xrep_newbt_add_blocks(xnr, pag, args.agbno, args.len);
+		xfs_perag_put(pag);
+		if (error)
+			return error;
+
+		nr_blocks -= args.len;
+		xnr->alloc_hint = args.fsbno + args.len;
+
+		error = xrep_defer_finish(sc);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* Allocate disk space for our new btree. */
+int
+xrep_newbt_alloc_blocks(
+	struct xrep_newbt	*xnr,
+	uint64_t		nr_blocks)
+{
+	if (xnr->sc->ip)
+		return xrep_newbt_alloc_file_blocks(xnr, nr_blocks);
+	return xrep_newbt_alloc_ag_blocks(xnr, nr_blocks);
+}
+
+/*
+ * How many extent freeing items can we attach to a transaction before we want
+ * to finish the chain so that unreserving new btree blocks doesn't overrun
+ * the transaction reservation?
+ */
+#define XREP_REAP_MAX_NEWBT_EFIS	(128)
+
+/*
+ * Free the unused part of an extent.  Returns the number of EFIs logged or
+ * a negative errno.
+ */
+STATIC int
+xrep_newbt_free_extent(
+	struct xrep_newbt	*xnr,
+	struct xrep_newbt_resv	*resv,
+	bool			btree_committed)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	xfs_agblock_t		free_agbno = resv->agbno;
+	xfs_extlen_t		free_aglen = resv->len;
+	xfs_fsblock_t		fsbno;
+	int			error;
+
+	/*
+	 * If we used space and committed the btree, remove those blocks from
+	 * the extent before we act on it.
+	 */
+	if (btree_committed) {
+		free_agbno += resv->used;
+		free_aglen -= resv->used;
+	}
+
+	if (free_aglen == 0)
+		return 0;
+
+	trace_xrep_newbt_free_blocks(sc->mp, resv->pag->pag_agno, free_agbno,
+			free_aglen, xnr->oinfo.oi_owner);
+
+	ASSERT(xnr->resv != XFS_AG_RESV_AGFL);
+
+	/*
+	 * Use EFIs to free the reservations.  This reduces the chance
+	 * that we leak blocks if the system goes down.
+	 */
+	fsbno = XFS_AGB_TO_FSB(sc->mp, resv->pag->pag_agno, free_agbno);
+	error = __xfs_free_extent_later(sc->tp, fsbno, free_aglen, &xnr->oinfo,
+			xnr->resv, true);
+	if (error)
+		return error;
+
+	return 1;
+}
+
+/* Free all the accounting info and disk space we reserved for a new btree. */
+STATIC int
+xrep_newbt_free(
+	struct xrep_newbt	*xnr,
+	bool			btree_committed)
+{
+	struct xfs_scrub	*sc = xnr->sc;
+	struct xrep_newbt_resv	*resv, *n;
+	unsigned int		freed = 0;
+	int			error = 0;
+
+	/*
+	 * If the filesystem already went down, we can't free the blocks.  Skip
+	 * ahead to freeing the incore metadata because we can't fix anything.
+	 */
+	if (xfs_is_shutdown(sc->mp))
+		goto junkit;
+
+	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		int		ret;
+
+		ret = xrep_newbt_free_extent(xnr, resv, btree_committed);
+		list_del(&resv->list);
+		xfs_perag_put(resv->pag);
+		kfree(resv);
+		if (ret < 0) {
+			error = ret;
+			goto junkit;
+		}
+
+		freed += ret;
+		if (freed >= XREP_REAP_MAX_NEWBT_EFIS) {
+			error = xrep_defer_finish(sc);
+			if (error)
+				goto junkit;
+			freed = 0;
+		}
+	}
+
+	if (freed)
+		error = xrep_defer_finish(sc);
+
+junkit:
+	/*
+	 * If we still have reservations attached to @newbt, cleanup must have
+	 * failed and the filesystem is about to go down.  Clean up the incore
+	 * reservations.
+	 */
+	list_for_each_entry_safe(resv, n, &xnr->resv_list, list) {
+		list_del(&resv->list);
+		xfs_perag_put(resv->pag);
+		kfree(resv);
+	}
+
+	if (sc->ip) {
+		kmem_cache_free(xfs_ifork_cache, xnr->ifake.if_fork);
+		xnr->ifake.if_fork = NULL;
+	}
+
+	return error;
+}
+
+/*
+ * Free all the accounting info and unused disk space allocations after
+ * committing a new btree.
+ */
+int
+xrep_newbt_commit(
+	struct xrep_newbt	*xnr)
+{
+	return xrep_newbt_free(xnr, true);
+}
+
+/*
+ * Free all the accounting info and all of the disk space we reserved for a new
+ * btree that we're not going to commit.  We want to try to roll things back
+ * cleanly for things like ENOSPC midway through allocation.
+ */
+void
+xrep_newbt_cancel(
+	struct xrep_newbt	*xnr)
+{
+	xrep_newbt_free(xnr, false);
+}
+
+/* Feed one of the reserved btree blocks to the bulk loader. */
+int
+xrep_newbt_claim_block(
+	struct xfs_btree_cur	*cur,
+	struct xrep_newbt	*xnr,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xrep_newbt_resv	*resv;
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_agblock_t		agbno;
+
+	/*
+	 * The first item in the list should always have a free block unless
+	 * we're completely out.
+	 */
+	resv = list_first_entry(&xnr->resv_list, struct xrep_newbt_resv, list);
+	if (resv->used == resv->len)
+		return -ENOSPC;
+
+	/*
+	 * Peel off a block from the start of the reservation.  We allocate
+	 * blocks in order to place blocks on disk in increasing record or key
+	 * order.  The block reservations tend to end up on the list in
+	 * decreasing order, which hopefully results in leaf blocks ending up
+	 * together.
+	 */
+	agbno = resv->agbno + resv->used;
+	resv->used++;
+
+	/* If we used all the blocks in this reservation, move it to the end. */
+	if (resv->used == resv->len)
+		list_move_tail(&resv->list, &xnr->resv_list);
+
+	trace_xrep_newbt_claim_block(mp, resv->pag->pag_agno, agbno, 1,
+			xnr->oinfo.oi_owner);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(XFS_AGB_TO_FSB(mp, resv->pag->pag_agno,
+								agbno));
+	else
+		ptr->s = cpu_to_be32(agbno);
+	return 0;
+}
diff --git a/fs/xfs/scrub/newbt.h b/fs/xfs/scrub/newbt.h
new file mode 100644
index 0000000000000..ca53271f3a4c6
--- /dev/null
+++ b/fs/xfs/scrub/newbt.h
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022-2023 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_NEWBT_H__
+#define __XFS_SCRUB_NEWBT_H__
+
+struct xrep_newbt_resv {
+	/* Link to list of extents that we've reserved. */
+	struct list_head	list;
+
+	struct xfs_perag	*pag;
+
+	/* AG block of the extent we reserved. */
+	xfs_agblock_t		agbno;
+
+	/* Length of the reservation. */
+	xfs_extlen_t		len;
+
+	/* How much of this reservation has been used. */
+	xfs_extlen_t		used;
+};
+
+struct xrep_newbt {
+	struct xfs_scrub	*sc;
+
+	/* List of extents that we've reserved. */
+	struct list_head	resv_list;
+
+	/* Fake root for new btree. */
+	union {
+		struct xbtree_afakeroot	afake;
+		struct xbtree_ifakeroot	ifake;
+	};
+
+	/* rmap owner of these blocks */
+	struct xfs_owner_info	oinfo;
+
+	/* btree geometry for the bulk loader */
+	struct xfs_btree_bload	bload;
+
+	/* Allocation hint */
+	xfs_fsblock_t		alloc_hint;
+
+	/* per-ag reservation type */
+	enum xfs_ag_resv_type	resv;
+};
+
+void xrep_newbt_init_bare(struct xrep_newbt *xnr, struct xfs_scrub *sc);
+void xrep_newbt_init_ag(struct xrep_newbt *xnr, struct xfs_scrub *sc,
+		const struct xfs_owner_info *oinfo, xfs_fsblock_t alloc_hint,
+		enum xfs_ag_resv_type resv);
+int xrep_newbt_init_inode(struct xrep_newbt *xnr, struct xfs_scrub *sc,
+		int whichfork, const struct xfs_owner_info *oinfo);
+int xrep_newbt_alloc_blocks(struct xrep_newbt *xnr, uint64_t nr_blocks);
+void xrep_newbt_cancel(struct xrep_newbt *xnr);
+int xrep_newbt_commit(struct xrep_newbt *xnr);
+int xrep_newbt_claim_block(struct xfs_btree_cur *cur, struct xrep_newbt *xnr,
+		union xfs_btree_ptr *ptr);
+
+#endif /* __XFS_SCRUB_NEWBT_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 3d98f604765e1..d603efa2a9af3 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -17,6 +17,8 @@
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_scrub.h"
+#include "xfs_btree.h"
+#include "xfs_btree_staging.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 73cf1002bd94a..7418d6c60056a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -988,6 +988,43 @@ TRACE_EVENT(xrep_ialloc_insert,
 		  __entry->freemask)
 )
 
+DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 int64_t owner),
+	TP_ARGS(mp, agno, agbno, len, owner),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(int64_t, owner)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = owner;
+	),
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner)
+);
+#define DEFINE_NEWBT_EXTENT_EVENT(name) \
+DEFINE_EVENT(xrep_newbt_extent_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 int64_t owner), \
+	TP_ARGS(mp, agno, agbno, len, owner))
+DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_ag_blocks);
+DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_file_blocks);
+DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_free_blocks);
+DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_claim_block);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

