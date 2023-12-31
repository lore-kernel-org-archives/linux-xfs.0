Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FB4BE48
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgCqBgMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDE8C433C7;
	Sun, 31 Dec 2023 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058902;
	bh=uPowIBEIgJ+zNu7LcrROwXirsFE24e0p57Lh/8gsBJw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JgCqBgMt4A5rBn7vzjTH/Ej8H9LS1OE5sV1zG07uVg3oO3OmBPifTY9QSQoMeWf8u
	 Aem85/HB0t1LjwuVoqV4mT7GTGIb1RUOAq7MfqWAI07cJIWHmB+yBL1qGTIo9dL/0x
	 kDfun6U/H94y5L61HZoY9yLuAO7pyjzrAjckfLrpQzjiCTQYrMquBfsSpd5Yyp5Qyh
	 nl4y3rEHqnTJv5id4uovH+vyNe1P3J2nBhMg33c8VCkStRkRpjoZ9IgXAE5e4BnPHe
	 g3FSuPTFFLJPEdAuxg//EMAnbgfH84bGXOSDaKDTJ4v6frOrbBz9aIWT0l2DKq89Eu
	 tc4uSoB4VA2Pg==
Date: Sun, 31 Dec 2023 13:41:42 -0800
Subject: [PATCH 38/39] xfs: hook live realtime rmap operations during a repair
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850513.1764998.8060614318675586540.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Hook the regular realtime rmap code when an rtrmapbt repair operation is
running so that we can unlock the AGF buffer to scan the filesystem and
keep the in-memory btree up to date during the scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c     |   56 ++++++++++++++++-
 fs/xfs/libxfs/xfs_rmap.h     |    6 ++
 fs/xfs/libxfs/xfs_rtgroup.c  |    1 
 fs/xfs/libxfs/xfs_rtgroup.h  |    3 +
 fs/xfs/scrub/rtrmap_repair.c |  139 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h         |   36 +++++++++++
 6 files changed, 233 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d100e03f9560f..43108a195004c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -920,8 +920,7 @@ xfs_rmap_update_hook(
 			.oinfo		= *oinfo, /* struct copy */
 		};
 
-		if (pag)
-			xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
+		xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
 	}
 }
 
@@ -946,6 +945,50 @@ xfs_rmap_hook_del(
 # define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while (0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
+# if defined(CONFIG_XFS_LIVE_HOOKS) && defined(CONFIG_XFS_RT)
+static inline void
+xfs_rtrmap_update_hook(
+	struct xfs_trans		*tp,
+	struct xfs_rtgroup		*rtg,
+	enum xfs_rmap_intent_type	op,
+	xfs_rgblock_t			startblock,
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
+		xfs_hooks_call(&rtg->rtg_rmap_update_hooks, op, &p);
+	}
+}
+
+/* Call the specified function during a rt reverse mapping update. */
+int
+xfs_rtrmap_hook_add(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rmap_hook	*hook)
+{
+	return xfs_hooks_add(&rtg->rtg_rmap_update_hooks, &hook->update_hook);
+}
+
+/* Stop calling the specified function during a rt reverse mapping update. */
+void
+xfs_rtrmap_hook_del(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rmap_hook	*hook)
+{
+	xfs_hooks_del(&rtg->rtg_rmap_update_hooks, &hook->update_hook);
+}
+#else
+# define xfs_rtrmap_update_hook(t, r, o, s, b, u, oi)	do { } while (0)
+#endif /* CONFIG_XFS_LIVE_HOOKS && CONFIG_XFS_RT */
+
 /*
  * Remove a reference to an extent in the rmap btree.
  */
@@ -2702,6 +2745,7 @@ xfs_rtrmap_finish_one(
 	xfs_rgnumber_t			rgno;
 	xfs_rgblock_t			bno;
 	bool				unwritten;
+	int				error;
 
 	trace_xfs_rmap_deferred(mp, ri);
 
@@ -2727,8 +2771,14 @@ xfs_rtrmap_finish_one(
 	unwritten = ri->ri_bmap.br_state == XFS_EXT_UNWRITTEN;
 	bno = xfs_rtb_to_rgbno(mp, ri->ri_bmap.br_startblock, &rgno);
 
-	return __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
+	error = __xfs_rmap_finish_intent(rcur, ri->ri_type, bno,
 			ri->ri_bmap.br_blockcount, &oinfo, unwritten);
+	if (error)
+		return error;
+
+	xfs_rtrmap_update_hook(tp, ri->ri_rtg, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 3719fc4cbc26b..9e19e657eeff6 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -275,6 +275,12 @@ void xfs_rmap_hook_enable(void);
 
 int xfs_rmap_hook_add(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
 void xfs_rmap_hook_del(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+
+# ifdef CONFIG_XFS_RT
+int xfs_rtrmap_hook_add(struct xfs_rtgroup *rtg, struct xfs_rmap_hook *hook);
+void xfs_rtrmap_hook_del(struct xfs_rtgroup *rtg, struct xfs_rmap_hook *hook);
+# endif /* CONFIG_XFS_RT */
+
 #endif
 
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 7b031f4917349..8bc97c9aa4c9c 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -163,6 +163,7 @@ xfs_initialize_rtgroups(
 		spin_lock_init(&rtg->rtg_state_lock);
 		init_waitqueue_head(&rtg->rtg_active_wq);
 		xfs_defer_drain_init(&rtg->rtg_intents_drain);
+		xfs_hooks_init(&rtg->rtg_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		/* Active ref owned by mount indicates rtgroup is online. */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 9487c2e00478b..3522527e553b8 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -48,6 +48,9 @@ struct xfs_rtgroup {
 	 * inconsistencies.
 	 */
 	struct xfs_defer_drain	rtg_intents_drain;
+
+	/* Hook to feed rt rmapbt updates to an active online repair. */
+	struct xfs_hooks	rtg_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 00e606dfc6842..42df1cf45ae0b 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -71,6 +71,9 @@ struct xrep_rtrmap {
 	/* new rtrmapbt information */
 	struct xrep_newbt	new_btree;
 
+	/* lock for the xfbtree and xfile */
+	struct mutex		lock;
+
 	/* rmap records generated from primary metadata */
 	struct xfbtree		*rtrmap_btree;
 
@@ -79,6 +82,9 @@ struct xrep_rtrmap {
 	/* bitmap of old rtrmapbt blocks */
 	struct xfsb_bitmap	old_rtrmapbt_blocks;
 
+	/* Hooks into rtrmap update code. */
+	struct xfs_rmap_hook	hooks;
+
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
@@ -98,6 +104,8 @@ xrep_setup_rtrmapbt(
 	char			*descr;
 	int			error;
 
+	xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
+
 	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
 	error = xrep_setup_buftarg(sc, descr);
 	kfree(descr);
@@ -155,12 +163,16 @@ xrep_rtrmap_stash(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	if (xchk_iscan_aborted(&rr->iscan))
+		return -EFSCORRUPTED;
+
 	trace_xrep_rtrmap_found(sc->mp, &rmap);
 
 	/* Add entry to in-memory btree. */
+	mutex_lock(&rr->lock);
 	error = xfbtree_head_read_buf(rr->rtrmap_btree, sc->tp, &mhead_bp);
 	if (error)
-		return error;
+		goto out_abort;
 
 	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, mhead_bp,
 			rr->rtrmap_btree);
@@ -169,10 +181,18 @@ xrep_rtrmap_stash(
 	if (error)
 		goto out_cancel;
 
-	return xfbtree_trans_commit(rr->rtrmap_btree, sc->tp);
+	error = xfbtree_trans_commit(rr->rtrmap_btree, sc->tp);
+	if (error)
+		goto out_abort;
+
+	mutex_unlock(&rr->lock);
+	return 0;
 
 out_cancel:
 	xfbtree_trans_cancel(rr->rtrmap_btree, sc->tp);
+out_abort:
+	xchk_iscan_abort(&rr->iscan);
+	mutex_unlock(&rr->lock);
 	return error;
 }
 
@@ -509,6 +529,13 @@ xrep_rtrmap_find_rmaps(
 	if (error)
 		return error;
 
+	/*
+	 * If a hook failed to update the in-memory btree, we lack the data to
+	 * continue the repair.
+	 */
+	if (xchk_iscan_aborted(&rr->iscan))
+		return -EFSCORRUPTED;
+
 	/* Scan for old rtrmap blocks. */
 	for_each_perag(sc->mp, agno, pag) {
 		error = xrep_rtrmap_scan_ag(rr, pag);
@@ -739,6 +766,89 @@ xrep_rtrmap_remove_old_tree(
 	return xrep_reset_imeta_reservation(rr->sc);
 }
 
+static inline bool
+xrep_rtrmapbt_want_live_update(
+	struct xchk_iscan		*iscan,
+	const struct xfs_owner_info	*oi)
+{
+	if (xchk_iscan_aborted(iscan))
+		return false;
+
+	/*
+	 * We scanned the CoW staging extents before we started the iscan, so
+	 * we need all the updates.
+	 */
+	if (XFS_RMAP_NON_INODE_OWNER(oi->oi_owner))
+		return true;
+
+	/* Ignore updates to files that the scanner hasn't visited yet. */
+	return xchk_iscan_want_live_update(iscan, oi->oi_owner);
+}
+
+/*
+ * Apply a rtrmapbt update from the regular filesystem into our shadow btree.
+ * We're running from the thread that owns the rtrmap ILOCK and is generating
+ * the update, so we must be careful about which parts of the struct
+ * xrep_rtrmap that we change.
+ */
+static int
+xrep_rtrmapbt_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_rmap_update_params	*p = data;
+	struct xrep_rtrmap		*rr;
+	struct xfs_mount		*mp;
+	struct xfs_btree_cur		*mcur;
+	struct xfs_buf			*mhead_bp;
+	struct xfs_trans		*tp;
+	void				*txcookie;
+	int				error;
+
+	rr = container_of(nb, struct xrep_rtrmap, hooks.update_hook.nb);
+	mp = rr->sc->mp;
+
+	if (!xrep_rtrmapbt_want_live_update(&rr->iscan, &p->oinfo))
+		goto out_unlock;
+
+	trace_xrep_rtrmap_live_update(mp, rr->sc->sr.rtg->rtg_rgno, action, p);
+
+	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
+	if (error)
+		goto out_abort;
+
+	mutex_lock(&rr->lock);
+	error = xfbtree_head_read_buf(rr->rtrmap_btree, tp, &mhead_bp);
+	if (error)
+		goto out_cancel;
+
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, mhead_bp,
+			rr->rtrmap_btree);
+	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
+			p->blockcount, &p->oinfo, p->unwritten);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	error = xfbtree_trans_commit(rr->rtrmap_btree, tp);
+	if (error)
+		goto out_cancel;
+
+	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+	mutex_unlock(&rr->lock);
+	return NOTIFY_DONE;
+
+out_cancel:
+	xfbtree_trans_cancel(rr->rtrmap_btree, tp);
+	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+out_abort:
+	xchk_iscan_abort(&rr->iscan);
+	mutex_unlock(&rr->lock);
+out_unlock:
+	return NOTIFY_DONE;
+}
+
 /* Set up the filesystem scan components. */
 STATIC int
 xrep_rtrmap_setup_scan(
@@ -747,6 +857,7 @@ xrep_rtrmap_setup_scan(
 	struct xfs_scrub	*sc = rr->sc;
 	int			error;
 
+	mutex_init(&rr->lock);
 	xfsb_bitmap_init(&rr->old_rtrmapbt_blocks);
 
 	/* Set up some storage */
@@ -757,10 +868,26 @@ xrep_rtrmap_setup_scan(
 
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(sc, 30000, 100, &rr->iscan);
+
+	/*
+	 * Hook into live rtrmap operations so that we can update our in-memory
+	 * btree to reflect live changes on the filesystem.  Since we drop the
+	 * rtrmap ILOCK to scan all the inodes, we need this piece to avoid
+	 * installing a stale btree.
+	 */
+	ASSERT(sc->flags & XCHK_FSGATES_RMAP);
+	xfs_hook_setup(&rr->hooks.update_hook, xrep_rtrmapbt_live_update);
+	error = xfs_rtrmap_hook_add(sc->sr.rtg, &rr->hooks);
+	if (error)
+		goto out_iscan;
 	return 0;
 
+out_iscan:
+	xchk_iscan_teardown(&rr->iscan);
+	xfbtree_destroy(rr->rtrmap_btree);
 out_bitmap:
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+	mutex_destroy(&rr->lock);
 	return error;
 }
 
@@ -769,9 +896,14 @@ STATIC void
 xrep_rtrmap_teardown(
 	struct xrep_rtrmap	*rr)
 {
+	struct xfs_scrub	*sc = rr->sc;
+
+	xchk_iscan_abort(&rr->iscan);
+	xfs_rtrmap_hook_del(sc->sr.rtg, &rr->hooks);
 	xchk_iscan_teardown(&rr->iscan);
 	xfbtree_destroy(rr->rtrmap_btree);
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+	mutex_destroy(&rr->lock);
 }
 
 /* Repair the realtime rmap btree. */
@@ -782,9 +914,6 @@ xrep_rtrmapbt(
 	struct xrep_rtrmap	*rr = sc->buf;
 	int			error;
 
-	/* Functionality is not yet complete. */
-	return xrep_notsupported(sc);
-
 	/* Make sure any problems with the fork are fixed. */
 	error = xrep_metadata_inode_forks(sc);
 	if (error)
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 95fdb82660dc3..65e0872792e1f 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3956,6 +3956,42 @@ TRACE_EVENT(xrep_rtrmap_found,
 		  __entry->offset,
 		  __entry->flags)
 );
+
+TRACE_EVENT(xrep_rtrmap_live_update,
+	TP_PROTO(struct xfs_mount *mp, xfs_rgnumber_t rgno, unsigned int op,
+		 const struct xfs_rmap_update_params *p),
+	TP_ARGS(mp, rgno, op, p),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_rgnumber_t, rgno)
+		__field(unsigned int, op)
+		__field(xfs_rgblock_t, rgbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->rgno = rgno;
+		__entry->op = op;
+		__entry->rgbno = p->startblock;
+		__entry->len = p->blockcount;
+		xfs_owner_info_unpack(&p->oinfo, &__entry->owner,
+				&__entry->offset, &__entry->flags);
+		if (p->unwritten)
+			__entry->flags |= XFS_RMAP_UNWRITTEN;
+	),
+	TP_printk("dev %d:%d rgno 0x%x op %s rgbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->rgno,
+		  __print_symbolic(__entry->op, XFS_RMAP_INTENT_STRINGS),
+		  __entry->rgbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
 #endif /* CONFIG_XFS_RT */
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */

