Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA79C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236014AbiLaBqd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:46:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiLaBqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:46:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4BF12769
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35ED8B81DEC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0EFC433F0;
        Sat, 31 Dec 2022 01:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451188;
        bh=fxo7DRUi5o/T4crZz62K9ecpkBtwC08EFCPvvu1LDww=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=d7gJnpVKD3+t1E6OuI27dy8ZY0rboZJDDJ0/3+WhVNP2xhnw8SQYK1Q5J2bfmdZ44
         VWcZiWdkdkxYSwHGJwk45jygbsfWD2sdx78BTmloG6P9KMdNVozs4GGxT8szZ3sdf1
         1kPqq3++vSVVxPn4bLLicCYWalAhRCptWxKfTVBhb4HB3a8Tm9KFH1yTJSDDSNVBDM
         e8Q/Gf1+VuEv7R9aGfMa7hZT8yyiKA/rXQLGikYhBY/zsvFI5MXkLg/jzLRYZR2pw/
         UvgrBzsrzmXba18RkeK3JntZDzvY/UUX3sxUOyhh3+4uYg50Yh27EoKio7FeaMYq49
         g4vEAZCuH+4bw==
Subject: [PATCH 37/38] xfs: hook live realtime rmap operations during a repair
 operation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870131.715303.4124505167326518034.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Hook the regular realtime rmap code when an rtrmapbt repair operation is
running so that we can unlock the AGF buffer to scan the filesystem and
keep the in-memory btree up to date during the scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c     |   39 ++++++++++--
 fs/xfs/libxfs/xfs_rmap.h     |    6 ++
 fs/xfs/libxfs/xfs_rtgroup.c  |    2 -
 fs/xfs/libxfs/xfs_rtgroup.h  |    3 +
 fs/xfs/scrub/rtrmap_repair.c |  138 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h         |   36 +++++++++++
 6 files changed, 211 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 06840fc31f02..a533588a9b5b 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -906,6 +906,7 @@ static inline void
 xfs_rmap_update_hook(
 	struct xfs_trans		*tp,
 	struct xfs_perag		*pag,
+	struct xfs_rtgroup		*rtg,
 	enum xfs_rmap_intent_type	op,
 	xfs_agblock_t			startblock,
 	xfs_extlen_t			blockcount,
@@ -922,6 +923,8 @@ xfs_rmap_update_hook(
 
 		if (pag)
 			xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
+		else if (rtg)
+			xfs_hooks_call(&rtg->rtg_rmap_update_hooks, op, &p);
 	}
 }
 
@@ -942,8 +945,28 @@ xfs_rmap_hook_del(
 {
 	xfs_hooks_del(&pag->pag_rmap_update_hooks, &hook->update_hook);
 }
+
+# ifdef CONFIG_XFS_RT
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
+# endif /* CONFIG_XFS_RT */
 #else
-# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while(0)
+# define xfs_rmap_update_hook(t, p, r, o, s, b, u, oi)	do { } while(0)
 #endif /* CONFIG_XFS_LIVE_HOOKS */
 
 /*
@@ -966,7 +989,8 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag, NULL, XFS_RMAP_UNMAP, bno, len, false,
+			oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1210,7 +1234,8 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag, NULL, XFS_RMAP_MAP, bno, len, false,
+			oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2731,8 +2756,12 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
-			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	if (ri->ri_realtime)
+		xfs_rmap_update_hook(tp, NULL, ri->ri_rtg, ri->ri_type, bno,
+				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	else
+		xfs_rmap_update_hook(tp, ri->ri_pag, NULL, ri->ri_type, bno,
+				ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 9d0aaa16f551..36d071b3b44c 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -279,6 +279,12 @@ void xfs_rmap_hook_enable(void);
 
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
index e40806c84256..bd878e65bc44 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -133,7 +133,7 @@ xfs_initialize_rtgroups(
 		/* Place kernel structure only init below this point. */
 		spin_lock_init(&rtg->rtg_state_lock);
 		xfs_drain_init(&rtg->rtg_intents);
-
+		xfs_hooks_init(&rtg->rtg_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		/* first new rtg is fully initialized */
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 1d41a2cac34f..4e9b9098f2f2 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -46,6 +46,9 @@ struct xfs_rtgroup {
 	 * inconsistencies.
 	 */
 	struct xfs_drain	rtg_intents;
+
+	/* Hook to feed rt rmapbt updates to an active online repair. */
+	struct xfs_hooks	rtg_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 5775efa67de6..e26847784d21 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -70,6 +70,8 @@ int
 xrep_setup_rtrmapbt(
 	struct xfs_scrub	*sc)
 {
+	xchk_fshooks_enable(sc, XCHK_FSHOOKS_RMAP);
+
 	return xrep_setup_buftarg(sc, "rtrmapbt repair");
 }
 
@@ -78,6 +80,9 @@ struct xrep_rtrmap {
 	/* new rtrmapbt information */
 	struct xrep_newbt	new_btree;
 
+	/* lock for the xfbtree and xfile */
+	struct mutex		lock;
+
 	/* rmap records generated from primary metadata */
 	struct xfbtree		*rtrmap_btree;
 
@@ -86,6 +91,9 @@ struct xrep_rtrmap {
 	/* bitmap of old rtrmapbt blocks */
 	struct xfsb_bitmap	old_rtrmapbt_blocks;
 
+	/* Hooks into rtrmap update code. */
+	struct xfs_rmap_hook	hooks;
+
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
@@ -138,12 +146,16 @@ xrep_rtrmap_stash(
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
@@ -152,10 +164,18 @@ xrep_rtrmap_stash(
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
 
@@ -492,6 +512,13 @@ xrep_rtrmap_find_rmaps(
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
@@ -727,6 +754,89 @@ xrep_rtrmap_remove_old_tree(
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
+	struct xfs_hook			*update_hook,
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
+	rr = container_of(update_hook, struct xrep_rtrmap, hooks.update_hook);
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
 /* Repair the realtime rmap btree. */
 int
 xrep_rtrmapbt(
@@ -735,9 +845,6 @@ xrep_rtrmapbt(
 	struct xrep_rtrmap	*rr;
 	int			error;
 
-	/* Functionality is not yet complete. */
-	return xrep_notsupported(sc);
-
 	/* Make sure any problems with the fork are fixed. */
 	error = xrep_metadata_inode_forks(sc);
 	if (error)
@@ -748,6 +855,7 @@ xrep_rtrmapbt(
 		return -ENOMEM;
 	rr->sc = sc;
 
+	mutex_init(&rr->lock);
 	xfsb_bitmap_init(&rr->old_rtrmapbt_blocks);
 
 	/* Set up some storage */
@@ -759,26 +867,42 @@ xrep_rtrmapbt(
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(&rr->iscan, 30000, 100);
 
+	/*
+	 * Hook into live rtrmap operations so that we can update our in-memory
+	 * btree to reflect live changes on the filesystem.  Since we drop the
+	 * rtrmap ILOCK to scan all the inodes, we need this piece to avoid
+	 * installing a stale btree.
+	 */
+	ASSERT(sc->flags & XCHK_FSHOOKS_RMAP);
+	xfs_hook_setup(&rr->hooks.update_hook, xrep_rtrmapbt_live_update);
+	error = xfs_rtrmap_hook_add(sc->sr.rtg, &rr->hooks);
+	if (error)
+		goto out_records;
+
 	/* Collect rmaps for realtime files. */
 	error = xrep_rtrmap_find_rmaps(rr);
 	if (error)
-		goto out_records;
+		goto out_hook;
 
 	xfs_trans_ijoin(sc->tp, sc->ip, 0);
 
 	/* Rebuild the rtrmap information. */
 	error = xrep_rtrmap_build_new_tree(rr);
 	if (error)
-		goto out_records;
+		goto out_hook;
 
 	/* Kill the old tree. */
 	error = xrep_rtrmap_remove_old_tree(rr);
 
+out_hook:
+	xchk_iscan_abort(&rr->iscan);
+	xfs_rtrmap_hook_del(sc->sr.rtg, &rr->hooks);
 out_records:
 	xchk_iscan_finish(&rr->iscan);
 	xfbtree_destroy(rr->rtrmap_btree);
 out_bitmap:
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+	mutex_destroy(&rr->lock);
 	kfree(rr);
 	return error;
 }
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 654cbcbd99ea..4cf8180173ca 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -3024,6 +3024,42 @@ TRACE_EVENT(xrep_rtrmap_found,
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

