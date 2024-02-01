Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAE15F46B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 20:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706817600; cv=none; b=IoQyxCHe2mxCvxtu8SLyCqn6XOrhlp9VoXnzonDa6Laq0wXO2wOpuJYmitzv1Gp+Sqk13YwVASu2EIzQXFFAeWTfjHOU3BC6GMkSt5jsJwgHX0FW7wYdbKJ8qahmYIvtJFlSZfvDdy+4TtDN59kZI5faWnkgGT62rBIht2WDDEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706817600; c=relaxed/simple;
	bh=GXNlsaS44jDFAqanUyWRLzIIS9F0FHjMGNWZGUfelEI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A733YWYxQfpy0hKYQ9aqCf6wz6hz55rpJtCBoe63lgHpvZ5uLQItmYBZw489l4DFOR8U5uWMAeSLwNWZ/pJ3esbSa2vff6PSQbm6//Deay0LoQQAcpVX9c/Dm0+N9RnysA8IpFJa8tvJHrNcchCd6BNcxtV/lAz4k9RGj2ZE0UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xk3YQBCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xk3YQBCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E979DC433C7;
	Thu,  1 Feb 2024 19:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706817600;
	bh=GXNlsaS44jDFAqanUyWRLzIIS9F0FHjMGNWZGUfelEI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xk3YQBCY7AAphyYDMEbwY6WIto8Cju6vZwU6GuCONFYDbmMtfzHr8FidfnysPTX1Q
	 xvpQtEQinSagHd5dPVI0sMNpUAT+qVepVCm9u7KpXliS9e7q0XJqMYNdGhPjr7CyB0
	 6QvbcvNQ/J74ip+sLIEnwNbgq33j3GuDFISIbmglfJGsDn0SqNWLUyWvPvv+iALqnJ
	 7uwktmD/NqN/JioxS40k32Bl8Ik1WeFwfLLa0MFKnK4zz0mvII+1Sob7/d0QEuhKj2
	 +SESCdetNqapHE34sIhMCw05NWz9BtH+9x9BewimlDjOo6/2XKdBu4F5G3vjJ4g97p
	 QoMAr19jxHisA==
Date: Thu, 01 Feb 2024 11:59:59 -0800
Subject: [PATCH 5/5] xfs: hook live rmap operations during a repair operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681337508.1608576.7152826825431557169.stgit@frogsfrogsfrogs>
In-Reply-To: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
References: <170681337409.1608576.2345800520406509462.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 fs/xfs/scrub/rmap_repair.c |  145 ++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/scrub.c       |    4 +
 fs/xfs/scrub/scrub.h       |    4 +
 fs/xfs/scrub/trace.c       |    1 
 fs/xfs/scrub/trace.h       |   47 ++++++++++++++
 12 files changed, 382 insertions(+), 39 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 279ba77236d66..9edcfeacd0bcb 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -417,6 +417,7 @@ xfs_initialize_perag(
 		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
+		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		error = xfs_buf_cache_init(&pag->pag_bcache);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index e019b79dbbe3d..35de09a2516c7 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -120,6 +120,9 @@ struct xfs_perag {
 	 * inconsistencies.
 	 */
 	struct xfs_defer_drain	pag_intents_drain;
+
+	/* Hook to feed rmapbt updates to an active online repair. */
+	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 43000bf54982b..bbc4d19592726 100644
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
+# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while (0)
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
@@ -2508,6 +2580,38 @@ xfs_rmap_finish_one_cleanup(
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
@@ -2574,39 +2678,14 @@ xfs_rmap_finish_one(
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
index 58c67896d12cb..3a153b4801b46 100644
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
@@ -235,4 +239,28 @@ extern struct kmem_cache	*xfs_rmap_intent_cache;
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
index dea883632b2d3..abff79a77c72b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1309,6 +1309,9 @@ xchk_fsgates_enable(
 	if (scrub_fsgates & XCHK_FSGATES_DIRENTS)
 		xfs_dir_hook_enable();
 
+	if (scrub_fsgates & XCHK_FSGATES_RMAP)
+		xfs_rmap_hook_enable();
+
 	sc->flags |= scrub_fsgates;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 2645abddad782..f43dce771cdd2 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -1165,3 +1165,39 @@ xrep_setup_xfbtree(
 
 	return xmbuf_alloc(sc->mp, descr, &sc->xmbtp);
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
index 059b510273654..dd1c89e8714ce 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -140,6 +140,10 @@ int xrep_quotacheck(struct xfs_scrub *sc);
 int xrep_reinit_pagf(struct xfs_scrub *sc);
 int xrep_reinit_pagi(struct xfs_scrub *sc);
 
+int xrep_trans_alloc_hook_dummy(struct xfs_mount *mp, void **cookiep,
+		struct xfs_trans **tpp);
+void xrep_trans_cancel_hook_dummy(void **cookiep, struct xfs_trans *tp);
+
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 6efca28e461d0..4bb70958dedc4 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -128,6 +128,9 @@ struct xrep_rmap {
 	/* new rmapbt information */
 	struct xrep_newbt	new_btree;
 
+	/* lock for the xfbtree and xfile */
+	struct mutex		lock;
+
 	/* rmap records generated from primary metadata */
 	struct xfbtree		rmap_btree;
 
@@ -136,6 +139,9 @@ struct xrep_rmap {
 	/* in-memory btree cursor for the xfs_btree_bload iteration */
 	struct xfs_btree_cur	*mcur;
 
+	/* Hooks into rmap update code. */
+	struct xfs_rmap_hook	hooks;
+
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
@@ -158,6 +164,8 @@ xrep_setup_ag_rmapbt(
 	char			*descr;
 	int			error;
 
+	xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
+
 	descr = xchk_xfile_ag_descr(sc, "reverse mapping records");
 	error = xrep_setup_xfbtree(sc, descr);
 	kfree(descr);
@@ -220,18 +228,30 @@ xrep_rmap_stash(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	if (xchk_iscan_aborted(&rr->iscan))
+		return -EFSCORRUPTED;
+
 	trace_xrep_rmap_found(sc->mp, sc->sa.pag->pag_agno, &rmap);
 
+	mutex_lock(&rr->lock);
 	mcur = xfs_rmapbt_mem_cursor(sc->sa.pag, sc->tp, &rr->rmap_btree);
 	error = xfs_rmap_map_raw(mcur, &rmap);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
 		goto out_cancel;
 
-	return xfbtree_trans_commit(&rr->rmap_btree, sc->tp);
+	error = xfbtree_trans_commit(&rr->rmap_btree, sc->tp);
+	if (error)
+		goto out_abort;
+
+	mutex_unlock(&rr->lock);
+	return 0;
 
 out_cancel:
 	xfbtree_trans_cancel(&rr->rmap_btree, sc->tp);
+out_abort:
+	xchk_iscan_abort(&rr->iscan);
+	mutex_unlock(&rr->lock);
 	return error;
 }
 
@@ -914,6 +934,13 @@ xrep_rmap_find_rmaps(
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
@@ -1495,6 +1522,91 @@ xrep_rmap_remove_old_tree(
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
+	 * rmap btree, so we do not want live updates for OWN_AG metadata.
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
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_rmap_update_params	*p = data;
+	struct xrep_rmap		*rr;
+	struct xfs_mount		*mp;
+	struct xfs_btree_cur		*mcur;
+	struct xfs_trans		*tp;
+	void				*txcookie;
+	int				error;
+
+	rr = container_of(nb, struct xrep_rmap, hooks.update_hook.nb);
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
+	mcur = xfs_rmapbt_mem_cursor(rr->sc->sa.pag, tp, &rr->rmap_btree);
+	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
+			p->blockcount, &p->oinfo, p->unwritten);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	error = xfbtree_trans_commit(&rr->rmap_btree, tp);
+	if (error)
+		goto out_cancel;
+
+	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+	mutex_unlock(&rr->lock);
+	return NOTIFY_DONE;
+
+out_cancel:
+	xfbtree_trans_cancel(&rr->rmap_btree, tp);
+	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+out_abort:
+	mutex_unlock(&rr->lock);
+	xchk_iscan_abort(&rr->iscan);
+out_unlock:
+	return NOTIFY_DONE;
+}
+
 /* Set up the filesystem scan components. */
 STATIC int
 xrep_rmap_setup_scan(
@@ -1503,15 +1615,36 @@ xrep_rmap_setup_scan(
 	struct xfs_scrub	*sc = rr->sc;
 	int			error;
 
+	mutex_init(&rr->lock);
+
 	/* Set up in-memory rmap btree */
 	error = xfs_rmapbt_mem_init(sc->mp, &rr->rmap_btree, sc->xmbtp,
 			sc->sa.pag->pag_agno);
 	if (error)
-		return error;
+		goto out_mutex;
 
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(sc, 30000, 100, &rr->iscan);
+
+	/*
+	 * Hook into live rmap operations so that we can update our in-memory
+	 * btree to reflect live changes on the filesystem.  Since we drop the
+	 * AGF buffer to scan all the inodes, we need this piece to avoid
+	 * installing a stale btree.
+	 */
+	ASSERT(sc->flags & XCHK_FSGATES_RMAP);
+	xfs_hook_setup(&rr->hooks.update_hook, xrep_rmapbt_live_update);
+	error = xfs_rmap_hook_add(sc->sa.pag, &rr->hooks);
+	if (error)
+		goto out_iscan;
 	return 0;
+
+out_iscan:
+	xchk_iscan_teardown(&rr->iscan);
+	xfbtree_destroy(&rr->rmap_btree);
+out_mutex:
+	mutex_destroy(&rr->lock);
+	return error;
 }
 
 /* Tear down scan components. */
@@ -1519,8 +1652,13 @@ STATIC void
 xrep_rmap_teardown(
 	struct xrep_rmap	*rr)
 {
+	struct xfs_scrub	*sc = rr->sc;
+
+	xchk_iscan_abort(&rr->iscan);
+	xfs_rmap_hook_del(sc->sa.pag, &rr->hooks);
 	xchk_iscan_teardown(&rr->iscan);
 	xfbtree_destroy(&rr->rmap_btree);
+	mutex_destroy(&rr->lock);
 }
 
 /* Repair the rmap btree for some AG. */
@@ -1531,9 +1669,6 @@ xrep_rmapbt(
 	struct xrep_rmap	*rr = sc->buf;
 	int			error;
 
-	/* Functionality is not yet complete. */
-	return xrep_notsupported(sc);
-
 	error = xrep_rmap_setup_scan(rr);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 2a68b8f483bbf..20fac9723c08c 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -16,6 +16,7 @@
 #include "xfs_qm.h"
 #include "xfs_scrub.h"
 #include "xfs_buf_mem.h"
+#include "xfs_rmap.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -164,6 +165,9 @@ xchk_fsgates_disable(
 	if (sc->flags & XCHK_FSGATES_DIRENTS)
 		xfs_dir_hook_disable();
 
+	if (sc->flags & XCHK_FSGATES_RMAP)
+		xfs_rmap_hook_disable();
+
 	sc->flags &= ~XCHK_FSGATES_ALL;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 1247284c17a09..9ad65b604fe12 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -126,6 +126,7 @@ struct xfs_scrub {
 #define XCHK_NEED_DRAIN		(1U << 3)  /* scrub needs to drain defer ops */
 #define XCHK_FSGATES_QUOTA	(1U << 4)  /* quota live update enabled */
 #define XCHK_FSGATES_DIRENTS	(1U << 5)  /* directory live update enabled */
+#define XCHK_FSGATES_RMAP	(1U << 6)  /* rmapbt live update enabled */
 #define XREP_RESET_PERAG_RESV	(1U << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1U << 31) /* checking our repair work */
 
@@ -137,7 +138,8 @@ struct xfs_scrub {
  */
 #define XCHK_FSGATES_ALL	(XCHK_FSGATES_DRAIN | \
 				 XCHK_FSGATES_QUOTA | \
-				 XCHK_FSGATES_DIRENTS)
+				 XCHK_FSGATES_DIRENTS | \
+				 XCHK_FSGATES_RMAP)
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index dc8a331f4b02d..3dd281d6d1854 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -18,6 +18,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_da_format.h"
 #include "xfs_dir2.h"
+#include "xfs_rmap.h"
 #include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1c97c2ff835e6..5b294be52c558 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -25,6 +25,7 @@ struct xchk_dqiter;
 struct xchk_iscan;
 struct xchk_nlink;
 struct xchk_fscounters;
+struct xfs_rmap_update_params;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -112,9 +113,19 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
 	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
+	{ XCHK_FSGATES_RMAP,			"fsgates_rmap" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
+TRACE_DEFINE_ENUM(XFS_RMAP_MAP);
+TRACE_DEFINE_ENUM(XFS_RMAP_MAP_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_UNMAP);
+TRACE_DEFINE_ENUM(XFS_RMAP_UNMAP_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_CONVERT);
+TRACE_DEFINE_ENUM(XFS_RMAP_CONVERT_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_ALLOC);
+TRACE_DEFINE_ENUM(XFS_RMAP_FREE);
+
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),
@@ -2226,6 +2237,42 @@ DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
 
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
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

