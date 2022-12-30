Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334A2C54E76
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235712AbiL3XoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbiL3Xn6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:43:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106CD1DF10
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:43:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 925B061C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BF7C433EF;
        Fri, 30 Dec 2022 23:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443836;
        bh=0HQPczx/E7K+ehnNMb5+O8oC6Q+OdNqbxCqQ5G74jkQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HnPDeqg7VvYMqE300vCm6jaYGxN8jXL5c9FbCurWk2xjp3zcqbYu4q/lPw+eXXCmV
         xORllTXqoQGAXJa6Je4tKKdI5omrHakP5NWHKXaoPN4YS0NmzF0JSkywlPzybVscqU
         kq2EJvB2i94Eje7/UzeU2WhJ9EaK6lau7LYvEfR3V5iGP3lAp76iyXsQrGjX3drNyH
         6LWrerGAHQOoE4iVm267407L+Qxw3JuQh1ccAWwPBlyL5XLozAF3iZylhPDpaalrra
         v1Gt9Shc16XcF56MO0f7iucnWQ6/4TjL+gLQRqr2dA//c7QwWYdJEgYFiu2EF8fhCE
         8+DYNDOKrebqw==
Subject: [PATCH 4/4] xfs: hook live rmap operations during a repair operation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:30 -0800
Message-ID: <167243841061.696748.8124096499529531254.stgit@magnolia>
In-Reply-To: <167243840997.696748.11741067698987523110.stgit@magnolia>
References: <167243840997.696748.11741067698987523110.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hook the regular rmap code when an rmapbt repair operation is running so
that we can unlock the AGF buffer to scan the filesystem and keep the
in-memory btree up to date during the scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c     |    1 
 fs/xfs/libxfs/xfs_ag.h     |    3 +
 fs/xfs/libxfs/xfs_rmap.c   |  145 ++++++++++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_rmap.h   |   28 ++++++++
 fs/xfs/scrub/common.c      |    3 +
 fs/xfs/scrub/repair.c      |   36 +++++++++++
 fs/xfs/scrub/repair.h      |    4 +
 fs/xfs/scrub/rmap_repair.c |  146 ++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/scrub.c       |    4 +
 fs/xfs/scrub/scrub.h       |    4 +
 fs/xfs/scrub/trace.c       |    1 
 fs/xfs/scrub/trace.h       |   47 ++++++++++++++
 12 files changed, 381 insertions(+), 41 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index d98ac1a997d9..58d485a76150 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -334,6 +334,7 @@ xfs_initialize_perag(
 		init_waitqueue_head(&pag->pagb_wait);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
+		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		error = xfs_buf_hash_init(pag);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index fd663d04bdff..6d5ddefa321e 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -121,6 +121,9 @@ struct xfs_perag {
 	 * inconsistencies.
 	 */
 	struct xfs_drain	pag_intents;
+
+	/* Hook to feed rmapbt updates to an active online repair. */
+	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index f7587f985aca..8da59935780a 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -821,6 +821,77 @@ xfs_rmap_unmap(
 	return error;
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Use a static key here to reduce the overhead of rmapbt live updates.  If
+ * the compiler supports jump labels, the static branch will be replaced by a
+ * nop sled when there are no hook users.  Online fsck is currently the only
+ * caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_rmap_hooks_switch);
+
+void
+xfs_rmap_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_rmap_hooks_switch);
+}
+
+void
+xfs_rmap_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_rmap_hooks_switch);
+}
+
+/* Call downstream hooks for a reverse mapping update. */
+static inline void
+xfs_rmap_update_hook(
+	struct xfs_trans		*tp,
+	struct xfs_perag		*pag,
+	enum xfs_rmap_intent_type	op,
+	xfs_agblock_t			startblock,
+	xfs_extlen_t			blockcount,
+	bool				unwritten,
+	const struct xfs_owner_info	*oinfo)
+{
+	if (xfs_hooks_switched_on(&xfs_rmap_hooks_switch)) {
+		struct xfs_rmap_update_params	p = {
+			.startblock	= startblock,
+			.blockcount	= blockcount,
+			.unwritten	= unwritten,
+			.oinfo		= *oinfo, /* struct copy */
+		};
+
+		if (pag)
+			xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
+	}
+}
+
+/* Call the specified function during a reverse mapping update. */
+int
+xfs_rmap_hook_add(
+	struct xfs_perag	*pag,
+	struct xfs_rmap_hook	*hook)
+{
+	return xfs_hooks_add(&pag->pag_rmap_update_hooks, &hook->update_hook);
+}
+
+/* Stop calling the specified function during a reverse mapping update. */
+void
+xfs_rmap_hook_del(
+	struct xfs_perag	*pag,
+	struct xfs_rmap_hook	*hook)
+{
+	xfs_hooks_del(&pag->pag_rmap_update_hooks, &hook->update_hook);
+}
+#else
+# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while(0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Remove a reference to an extent in the rmap btree.
  */
@@ -841,7 +912,7 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-
+	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1093,6 +1164,7 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
+	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2512,6 +2584,38 @@ xfs_rmap_finish_one_cleanup(
 		xfs_trans_brelse(tp, agbp);
 }
 
+/* Commit an rmap operation into the ondisk tree. */
+int
+__xfs_rmap_finish_intent(
+	struct xfs_btree_cur		*rcur,
+	enum xfs_rmap_intent_type	op,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo,
+	bool				unwritten)
+{
+	switch (op) {
+	case XFS_RMAP_ALLOC:
+	case XFS_RMAP_MAP:
+		return xfs_rmap_map(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_MAP_SHARED:
+		return xfs_rmap_map_shared(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_FREE:
+	case XFS_RMAP_UNMAP:
+		return xfs_rmap_unmap(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_UNMAP_SHARED:
+		return xfs_rmap_unmap_shared(rcur, bno, len, unwritten, oinfo);
+	case XFS_RMAP_CONVERT:
+		return xfs_rmap_convert(rcur, bno, len, !unwritten, oinfo);
+	case XFS_RMAP_CONVERT_SHARED:
+		return xfs_rmap_convert_shared(rcur, bno, len, !unwritten,
+				oinfo);
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+}
+
 /*
  * Process one of the deferred rmap operations.  We pass back the
  * btree cursor to maintain our lock on the rmapbt between calls.
@@ -2578,39 +2682,14 @@ xfs_rmap_finish_one(
 	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
 	bno = XFS_FSB_TO_AGBNO(rcur->bc_mp, ri->ri_bmap.br_startblock);
 
-	switch (ri->ri_type) {
-	case XFS_RMAP_ALLOC:
-	case XFS_RMAP_MAP:
-		error = xfs_rmap_map(rcur, bno, ri->ri_bmap.br_blockcount,
-				unwritten, &oinfo);
-		break;
-	case XFS_RMAP_MAP_SHARED:
-		error = xfs_rmap_map_shared(rcur, bno,
-				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
-		break;
-	case XFS_RMAP_FREE:
-	case XFS_RMAP_UNMAP:
-		error = xfs_rmap_unmap(rcur, bno, ri->ri_bmap.br_blockcount,
-				unwritten, &oinfo);
-		break;
-	case XFS_RMAP_UNMAP_SHARED:
-		error = xfs_rmap_unmap_shared(rcur, bno,
-				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
-		break;
-	case XFS_RMAP_CONVERT:
-		error = xfs_rmap_convert(rcur, bno, ri->ri_bmap.br_blockcount,
-				!unwritten, &oinfo);
-		break;
-	case XFS_RMAP_CONVERT_SHARED:
-		error = xfs_rmap_convert_shared(rcur, bno,
-				ri->ri_bmap.br_blockcount, !unwritten, &oinfo);
-		break;
-	default:
-		ASSERT(0);
-		error = -EFSCORRUPTED;
-	}
+	error = __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
+	if (error)
+		return error;
 
-	return error;
+	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index b7ad51055e13..2a9265218f1d 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -186,6 +186,10 @@ void xfs_rmap_finish_one_cleanup(struct xfs_trans *tp,
 		struct xfs_btree_cur *rcur, int error);
 int xfs_rmap_finish_one(struct xfs_trans *tp, struct xfs_rmap_intent *ri,
 		struct xfs_btree_cur **pcur);
+int __xfs_rmap_finish_intent(struct xfs_btree_cur *rcur,
+		enum xfs_rmap_intent_type op, xfs_agblock_t bno,
+		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
+		bool unwritten);
 
 int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		uint64_t owner, uint64_t offset, unsigned int flags,
@@ -237,4 +241,28 @@ extern struct kmem_cache	*xfs_rmap_intent_cache;
 int __init xfs_rmap_intent_init_cache(void);
 void xfs_rmap_intent_destroy_cache(void);
 
+/*
+ * Parameters for tracking reverse mapping changes.  The hook function arg
+ * parameter is enum xfs_rmap_intent_type, and the rest is below.
+ */
+struct xfs_rmap_update_params {
+	xfs_agblock_t			startblock;
+	xfs_extlen_t			blockcount;
+	struct xfs_owner_info		oinfo;
+	bool				unwritten;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+
+struct xfs_rmap_hook {
+	struct xfs_hook			update_hook;
+};
+
+void xfs_rmap_hook_disable(void);
+void xfs_rmap_hook_enable(void);
+
+int xfs_rmap_hook_add(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+void xfs_rmap_hook_del(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+#endif
+
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index c436d613521c..bde9159dca4a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1264,5 +1264,8 @@ xchk_fshooks_enable(
 	if (scrub_fshooks & XCHK_FSHOOKS_NLINKS)
 		xfs_nlink_hook_enable();
 
+	if (scrub_fshooks & XCHK_FSHOOKS_RMAP)
+		xfs_rmap_hook_enable();
+
 	sc->flags |= scrub_fshooks;
 }
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index a685161db7bb..da6bff1fcd86 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1153,3 +1153,39 @@ xrep_setup_buftarg(
 
 	return xfs_alloc_memory_buftarg(sc->mp, sc->xfile, &sc->xfile_buftarg);
 }
+
+/*
+ * Create a dummy transaction for use in a live update hook function.  This
+ * function MUST NOT be called from regular repair code because the current
+ * process' transaction is saved via the cookie.
+ */
+int
+xrep_trans_alloc_hook_dummy(
+	struct xfs_mount	*mp,
+	void			**cookiep,
+	struct xfs_trans	**tpp)
+{
+	int			error;
+
+	*cookiep = current->journal_info;
+	current->journal_info = NULL;
+
+	error = xfs_trans_alloc_empty(mp, tpp);
+	if (!error)
+		return 0;
+
+	current->journal_info = *cookiep;
+	*cookiep = NULL;
+	return error;
+}
+
+/* Cancel a dummy transaction used by a live update hook function. */
+void
+xrep_trans_cancel_hook_dummy(
+	void			**cookiep,
+	struct xfs_trans	*tp)
+{
+	xfs_trans_cancel(tp);
+	current->journal_info = *cookiep;
+	*cookiep = NULL;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 87e4827a6fb2..34c601aad642 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -131,6 +131,10 @@ int xrep_quotacheck(struct xfs_scrub *sc);
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
 
+int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
+		struct xfs_trans **tpp);
+void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
+
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index ae6015b171d9..ed937e461bf8 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -127,6 +127,8 @@ int
 xrep_setup_ag_rmapbt(
 	struct xfs_scrub	*sc)
 {
+	xchk_fshooks_enable(sc, XCHK_FSHOOKS_RMAP);
+
 	return xrep_setup_buftarg(sc, "rmapbt repair");
 }
 
@@ -135,6 +137,9 @@ struct xrep_rmap {
 	/* new rmapbt information */
 	struct xrep_newbt	new_btree;
 
+	/* lock for the xfbtree and xfile */
+	struct mutex		lock;
+
 	/* rmap records generated from primary metadata */
 	struct xfbtree		*rmap_btree;
 
@@ -143,6 +148,9 @@ struct xrep_rmap {
 	/* in-memory btree cursor for the xfs_btree_bload iteration */
 	struct xfs_btree_cur	*mcur;
 
+	/* Hooks into rmap update code. */
+	struct xfs_rmap_hook	hooks;
+
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
@@ -204,11 +212,15 @@ xrep_rmap_stash(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	if (xchk_iscan_aborted(&rr->iscan))
+		return -EFSCORRUPTED;
+
 	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
 
+	mutex_lock(&rr->lock);
 	error = xfbtree_head_read_buf(rr->rmap_btree, sc->tp, &mhead_bp);
 	if (error)
-		return error;
+		goto out_abort;
 
 	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, mhead_bp,
 			rr->rmap_btree);
@@ -217,10 +229,18 @@ xrep_rmap_stash(
 	if (error)
 		goto out_cancel;
 
-	return xfbtree_trans_commit(rr->rmap_btree, sc->tp);
+	error = xfbtree_trans_commit(rr->rmap_btree, sc->tp);
+	if (error)
+		goto out_abort;
+
+	mutex_unlock(&rr->lock);
+	return 0;
 
 out_cancel:
 	xfbtree_trans_cancel(rr->rmap_btree, sc->tp);
+out_abort:
+	xchk_iscan_abort(&rr->iscan);
+	mutex_unlock(&rr->lock);
 	return error;
 }
 
@@ -865,6 +885,13 @@ xrep_rmap_find_rmaps(
 	if (error)
 		return error;
 
+	/*
+	 * If a hook failed to update the in-memory btree, we lack the data to
+	 * continue the repair.
+	 */
+	if (xchk_iscan_aborted(&rr->iscan))
+		return -EFSCORRUPTED;
+
 	/*
 	 * Now that we have everything locked again, we need to count the
 	 * number of rmap records stashed in the btree.  This should reflect
@@ -1469,6 +1496,97 @@ xrep_rmap_remove_old_tree(
 	return error;
 }
 
+static inline bool
+xrep_rmapbt_want_live_update(
+	struct xchk_iscan		*iscan,
+	const struct xfs_owner_info	*oi)
+{
+	if (xchk_iscan_aborted(iscan))
+		return false;
+
+	/*
+	 * Before unlocking the AG header to perform the inode scan, we
+	 * recorded reverse mappings for all AG metadata except for the OWN_AG
+	 * metadata.  IOWs, the in-memory btree knows about the AG headers, the
+	 * two inode btrees, the CoW staging extents, and the refcount btrees.
+	 * For these types of metadata, we need to record the live updates in
+	 * the in-memory rmap btree.
+	 *
+	 * However, we do not scan the free space btrees or the AGFL until we
+	 * have re-locked the AGF and are ready to reserve space for the new
+	 * new rmap btree, so we do not want live updates for OWN_AG metadata.
+	 */
+	if (XFS_RMAP_NON_INODE_OWNER(oi->oi_owner))
+		return oi->oi_owner != XFS_RMAP_OWN_AG;
+
+	/* Ignore updates to files that the scanner hasn't visited yet. */
+	return xchk_iscan_want_live_update(iscan, oi->oi_owner);
+}
+
+/*
+ * Apply a rmapbt update from the regular filesystem into our shadow btree.
+ * We're running from the thread that owns the AGF buffer and is generating
+ * the update, so we must be careful about which parts of the struct xrep_rmap
+ * that we change.
+ */
+static int
+xrep_rmapbt_live_update(
+	struct xfs_hook			*hook,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_rmap_update_params	*p = data;
+	struct xrep_rmap		*rr;
+	struct xfs_mount		*mp;
+	struct xfs_btree_cur		*mcur;
+	struct xfs_buf			*mhead_bp;
+	struct xfs_trans		*tp;
+	void				*txcookie;
+	int				error;
+
+	rr = container_of(hook, struct xrep_rmap, hooks.update_hook);
+	mp = rr->sc->mp;
+
+	if (!xrep_rmapbt_want_live_update(&rr->iscan, &p->oinfo))
+		goto out_unlock;
+
+	trace_xrep_rmap_live_update(mp, rr->sc->sa.pag->pag_agno, action, p);
+
+	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
+	if (error)
+		goto out_abort;
+
+	mutex_lock(&rr->lock);
+	error = xfbtree_head_read_buf(rr->rmap_btree, tp, &mhead_bp);
+	if (error)
+		goto out_cancel;
+
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, mhead_bp,
+			rr->rmap_btree);
+	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
+			p->blockcount, &p->oinfo, p->unwritten);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	error = xfbtree_trans_commit(rr->rmap_btree, tp);
+	if (error)
+		goto out_cancel;
+
+	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+	mutex_unlock(&rr->lock);
+	return NOTIFY_DONE;
+
+out_cancel:
+	xfbtree_trans_cancel(rr->rmap_btree, tp);
+	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+out_abort:
+	mutex_unlock(&rr->lock);
+	xchk_iscan_abort(&rr->iscan);
+out_unlock:
+	return NOTIFY_DONE;
+}
+
 /* Repair the rmap btree for some AG. */
 int
 xrep_rmapbt(
@@ -1477,13 +1595,11 @@ xrep_rmapbt(
 	struct xrep_rmap	*rr;
 	int			error;
 
-	/* Functionality is not yet complete. */
-	return xrep_notsupported(sc);
-
 	rr = kzalloc(sizeof(struct xrep_rmap), XCHK_GFP_FLAGS);
 	if (!rr)
 		return -ENOMEM;
 	rr->sc = sc;
+	mutex_init(&rr->lock);
 
 	/* Set up in-memory rmap btree */
 	error = xfs_rmapbt_mem_create(sc->mp, sc->sa.pag->pag_agno,
@@ -1494,26 +1610,42 @@ xrep_rmapbt(
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(&rr->iscan, 30000, 100);
 
+	/*
+	 * Hook into live rmap operations so that we can update our in-memory
+	 * btree to reflect live changes on the filesystem.  Since we drop the
+	 * AGF buffer to scan all the inodes, we need this piece to avoid
+	 * installing a stale btree.
+	 */
+	ASSERT(sc->flags & XCHK_FSHOOKS_RMAP);
+	xfs_hook_setup(&rr->hooks.update_hook, xrep_rmapbt_live_update);
+	error = xfs_rmap_hook_add(sc->sa.pag, &rr->hooks);
+	if (error)
+		goto out_records;
+
 	/*
 	 * Collect rmaps for everything in this AG that isn't space metadata.
 	 * These rmaps won't change even as we try to allocate blocks.
 	 */
 	error = xrep_rmap_find_rmaps(rr);
 	if (error)
-		goto out_records;
+		goto out_abort;
 
 	/* Rebuild the rmap information. */
 	error = xrep_rmap_build_new_tree(rr);
 	if (error)
-		goto out_records;
+		goto out_abort;
 
 	/* Kill the old tree. */
 	error = xrep_rmap_remove_old_tree(rr);
 
+out_abort:
+	xchk_iscan_abort(&rr->iscan);
+	xfs_rmap_hook_del(sc->sa.pag, &rr->hooks);
 out_records:
 	xchk_iscan_finish(&rr->iscan);
 	xfbtree_destroy(rr->rmap_btree);
 out_rr:
+	mutex_destroy(&rr->lock);
 	kfree(rr);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index f030311fae2b..c6eb692a0822 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -17,6 +17,7 @@
 #include "xfs_scrub.h"
 #include "xfs_btree.h"
 #include "xfs_btree_staging.h"
+#include "xfs_rmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -164,6 +165,9 @@ xchk_fshooks_disable(
 	if (sc->flags & XCHK_FSHOOKS_NLINKS)
 		xfs_nlink_hook_disable();
 
+	if (sc->flags & XCHK_FSHOOKS_RMAP)
+		xfs_rmap_hook_disable();
+
 	sc->flags &= ~XCHK_FSHOOKS_ALL;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 6fe59d1a2518..cf18bb4e8b35 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -126,12 +126,14 @@ struct xfs_scrub {
 #define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to use intent drain */
 #define XCHK_FSHOOKS_QUOTA	(1 << 4)  /* quota live update enabled */
 #define XCHK_FSHOOKS_NLINKS	(1 << 5)  /* link count live update enabled */
+#define XCHK_FSHOOKS_RMAP	(1 << 6)  /* rmapbt live update enabled */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 #define XCHK_FSHOOKS_ALL	(XCHK_FSHOOKS_DRAIN | \
 				 XCHK_FSHOOKS_QUOTA | \
-				 XCHK_FSHOOKS_NLINKS)
+				 XCHK_FSHOOKS_NLINKS | \
+				 XCHK_FSHOOKS_RMAP)
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 177fc4c75507..f8f50c5a02c0 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -18,6 +18,7 @@
 #include "xfs_dir2.h"
 #include "xfs_da_format.h"
 #include "xfs_btree_mem.h"
+#include "xfs_rmap.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 53aafc70878b..dc0547691fe4 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -26,6 +26,7 @@ struct xchk_nlink;
 struct xchk_fscounters;
 struct xfbtree;
 struct xfbtree_config;
+struct xfs_rmap_update_params;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -121,6 +122,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XCHK_FSHOOKS_QUOTA,			"fshooks_quota" }, \
 	{ XCHK_FSHOOKS_NLINKS,			"fshooks_nlinks" }, \
+	{ XCHK_FSHOOKS_RMAP,			"fshooks_rmap" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
@@ -2111,6 +2113,51 @@ DEFINE_EVENT(xfbtree_freesp_class, name, \
 DEFINE_XFBTREE_FREESP_EVENT(xfbtree_alloc_block);
 DEFINE_XFBTREE_FREESP_EVENT(xfbtree_free_block);
 
+TRACE_DEFINE_ENUM(XFS_RMAP_MAP);
+TRACE_DEFINE_ENUM(XFS_RMAP_MAP_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_UNMAP);
+TRACE_DEFINE_ENUM(XFS_RMAP_UNMAP_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_CONVERT);
+TRACE_DEFINE_ENUM(XFS_RMAP_CONVERT_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_ALLOC);
+TRACE_DEFINE_ENUM(XFS_RMAP_FREE);
+
+TRACE_EVENT(xrep_rmap_live_update,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, unsigned int op,
+		 const struct xfs_rmap_update_params *p),
+	TP_ARGS(mp, agno, op, p),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(unsigned int, op)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->op = op;
+		__entry->agbno = p->startblock;
+		__entry->len = p->blockcount;
+		xfs_owner_info_unpack(&p->oinfo, &__entry->owner,
+				&__entry->offset, &__entry->flags);
+		if (p->unwritten)
+			__entry->flags |= XFS_RMAP_UNWRITTEN;
+	),
+	TP_printk("dev %d:%d agno 0x%x op %d agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->op,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 

