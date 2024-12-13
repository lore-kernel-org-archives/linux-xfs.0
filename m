Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B80629
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052169; cv=none; b=FWeOWfA3HJvsOvBSaOf3CsZ5KHvkXIizDWsGL0wDX8at8/HwwZoY1XZ+s1KpomojtJHPpdHJ1MqqTpUEdoj8tfknQv8A0t03B8O+BUcTp8ImnckW1nevsmJss5wTgwEWyF/dhQypXaNkF3MziO3rXNXW2iZQtz+cNFDRH7wWDfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052169; c=relaxed/simple;
	bh=ZbJx1M9JAY8n2e11arruWa/XZ6pMmwlV2jUQmuTVT7M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EpeuT7NGr8slItHwAGEvmSfngz/4vmu8W9NnG2ZYky1UrsiETM58lTP35TBXrMN9JY2tOuv83CSpfpQoguiEBTqtGZ7PruBNW9g+99btZ8JJcrE3WS6d+b/aUzsx9FAjhtd/nDOccPP0n6KidzLKDagI+N+a1ZhvFuJtVPLsGfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyj5kX2X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyj5kX2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86286C4CECE;
	Fri, 13 Dec 2024 01:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052168;
	bh=ZbJx1M9JAY8n2e11arruWa/XZ6pMmwlV2jUQmuTVT7M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gyj5kX2XCmfU3b1ZTs+/hvXXat6uaA56XDPQiBBAZBmOEECohNYtqxSh0CMx+W7o0
	 5mAOZE532rz7SHv6G/LD3lpGGISs9vZQI2U07zm6ILrA7NqFFE3BBsOdFPIridPtsM
	 LefKyxba4hOW3fMS4CEX/V6VX1V12J/WPtO7nB1xpGnI+Zm5HPYB6wbwS+dK4jZwBP
	 v2YFE7ZAavdvae9cKljO/cNXoM8GJ1TFz9mVaNYv7vIQAoIhNil6I1vZnvlXqGL/zo
	 l4au7HJhDr+pCHeZ/2zWQAYQOBjiu6f8e+oA8c9EQb/JwKjkTRKYaOeVqPP8FToAIn
	 Sw9E23VAwlWDw==
Date: Thu, 12 Dec 2024 17:09:28 -0800
Subject: [PATCH 34/37] xfs: hook live realtime rmap operations during a repair
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123900.1181370.14934453235625748262.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c   |    2 -
 fs/xfs/scrub/rtrmap_repair.c |  131 +++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h         |   17 ++++-
 3 files changed, 140 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 91c17feb49768b..c2c7b76cc25ab8 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -1614,7 +1614,7 @@ xrep_rmapbt_live_update(
 	if (!xrep_rmapbt_want_live_update(&rr->iscan, &p->oinfo))
 		goto out_unlock;
 
-	trace_xrep_rmap_live_update(rr->sc->sa.pag, action, p);
+	trace_xrep_rmap_live_update(pag_group(rr->sc->sa.pag), action, p);
 
 	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
 	if (error)
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index b376bcc8d1d2ed..49de8bc2dd17f5 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -71,6 +71,9 @@ struct xrep_rtrmap {
 	/* new rtrmapbt information */
 	struct xrep_newbt	new_btree;
 
+	/* lock for the xfbtree and xfile */
+	struct mutex		lock;
+
 	/* rmap records generated from primary metadata */
 	struct xfbtree		rtrmap_btree;
 
@@ -79,6 +82,9 @@ struct xrep_rtrmap {
 	/* bitmap of old rtrmapbt blocks */
 	struct xfsb_bitmap	old_rtrmapbt_blocks;
 
+	/* Hooks into rtrmap update code. */
+	struct xfs_rmap_hook	rhook;
+
 	/* inode scan cursor */
 	struct xchk_iscan	iscan;
 
@@ -98,6 +104,8 @@ xrep_setup_rtrmapbt(
 	char			*descr;
 	int			error;
 
+	xchk_fsgates_enable(sc, XCHK_FSGATES_RMAP);
+
 	descr = xchk_xfile_rtgroup_descr(sc, "reverse mapping records");
 	error = xrep_setup_xfbtree(sc, descr);
 	kfree(descr);
@@ -151,19 +159,31 @@ xrep_rtrmap_stash(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	if (xchk_iscan_aborted(&rr->iscan))
+		return -EFSCORRUPTED;
+
 	trace_xrep_rtrmap_found(sc->mp, &rmap);
 
 	/* Add entry to in-memory btree. */
+	mutex_lock(&rr->lock);
 	mcur = xfs_rtrmapbt_mem_cursor(sc->sr.rtg, sc->tp, &rr->rtrmap_btree);
 	error = xfs_rmap_map_raw(mcur, &rmap);
 	xfs_btree_del_cursor(mcur, error);
 	if (error)
 		goto out_cancel;
 
-	return xfbtree_trans_commit(&rr->rtrmap_btree, sc->tp);
+	error = xfbtree_trans_commit(&rr->rtrmap_btree, sc->tp);
+	if (error)
+		goto out_abort;
+
+	mutex_unlock(&rr->lock);
+	return 0;
 
 out_cancel:
 	xfbtree_trans_cancel(&rr->rtrmap_btree, sc->tp);
+out_abort:
+	xchk_iscan_abort(&rr->iscan);
+	mutex_unlock(&rr->lock);
 	return error;
 }
 
@@ -486,6 +506,13 @@ xrep_rtrmap_find_rmaps(
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
 	while ((pag = xfs_perag_next(sc->mp, pag))) {
 		error = xrep_rtrmap_scan_ag(rr, pag);
@@ -702,6 +729,83 @@ xrep_rtrmap_remove_old_tree(
 	return xrep_reset_metafile_resv(rr->sc);
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
+	struct xfs_trans		*tp;
+	void				*txcookie;
+	int				error;
+
+	rr = container_of(nb, struct xrep_rtrmap, rhook.rmap_hook.nb);
+	mp = rr->sc->mp;
+
+	if (!xrep_rtrmapbt_want_live_update(&rr->iscan, &p->oinfo))
+		goto out_unlock;
+
+	trace_xrep_rmap_live_update(rtg_group(rr->sc->sr.rtg), action, p);
+
+	error = xrep_trans_alloc_hook_dummy(mp, &txcookie, &tp);
+	if (error)
+		goto out_abort;
+
+	mutex_lock(&rr->lock);
+	mcur = xfs_rtrmapbt_mem_cursor(rr->sc->sr.rtg, tp, &rr->rtrmap_btree);
+	error = __xfs_rmap_finish_intent(mcur, action, p->startblock,
+			p->blockcount, &p->oinfo, p->unwritten);
+	xfs_btree_del_cursor(mcur, error);
+	if (error)
+		goto out_cancel;
+
+	error = xfbtree_trans_commit(&rr->rtrmap_btree, tp);
+	if (error)
+		goto out_cancel;
+
+	xrep_trans_cancel_hook_dummy(&txcookie, tp);
+	mutex_unlock(&rr->lock);
+	return NOTIFY_DONE;
+
+out_cancel:
+	xfbtree_trans_cancel(&rr->rtrmap_btree, tp);
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
@@ -710,6 +814,7 @@ xrep_rtrmap_setup_scan(
 	struct xfs_scrub	*sc = rr->sc;
 	int			error;
 
+	mutex_init(&rr->lock);
 	xfsb_bitmap_init(&rr->old_rtrmapbt_blocks);
 
 	/* Set up some storage */
@@ -720,10 +825,26 @@ xrep_rtrmap_setup_scan(
 
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
+	xfs_rmap_hook_setup(&rr->rhook, xrep_rtrmapbt_live_update);
+	error = xfs_rmap_hook_add(rtg_group(sc->sr.rtg), &rr->rhook);
+	if (error)
+		goto out_iscan;
 	return 0;
 
+out_iscan:
+	xchk_iscan_teardown(&rr->iscan);
+	xfbtree_destroy(&rr->rtrmap_btree);
 out_bitmap:
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+	mutex_destroy(&rr->lock);
 	return error;
 }
 
@@ -732,9 +853,14 @@ STATIC void
 xrep_rtrmap_teardown(
 	struct xrep_rtrmap	*rr)
 {
+	struct xfs_scrub	*sc = rr->sc;
+
+	xchk_iscan_abort(&rr->iscan);
+	xfs_rmap_hook_del(rtg_group(sc->sr.rtg), &rr->rhook);
 	xchk_iscan_teardown(&rr->iscan);
 	xfbtree_destroy(&rr->rtrmap_btree);
 	xfsb_bitmap_destroy(&rr->old_rtrmapbt_blocks);
+	mutex_destroy(&rr->lock);
 }
 
 /* Repair the realtime rmap btree. */
@@ -745,9 +871,6 @@ xrep_rtrmapbt(
 	struct xrep_rtrmap	*rr = sc->buf;
 	int			error;
 
-	/* Functionality is not yet complete. */
-	return xrep_notsupported(sc);
-
 	/* Make sure any problems with the fork are fixed. */
 	error = xrep_metadata_inode_forks(sc);
 	if (error)
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3f2a8695ef5cb5..fb86b746bc174a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -41,6 +41,9 @@ struct xchk_dirtree_outcomes;
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_SHARED);
 TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
 
+TRACE_DEFINE_ENUM(XG_TYPE_AG);
+TRACE_DEFINE_ENUM(XG_TYPE_RTG);
+
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_PROBE);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_SB);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_AGF);
@@ -2709,11 +2712,12 @@ DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
 
 TRACE_EVENT(xrep_rmap_live_update,
-	TP_PROTO(const struct xfs_perag *pag, unsigned int op,
+	TP_PROTO(const struct xfs_group *xg, unsigned int op,
 		 const struct xfs_rmap_update_params *p),
-	TP_ARGS(pag, op, p),
+	TP_ARGS(xg, op, p),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(unsigned int, op)
 		__field(xfs_agblock_t, agbno)
@@ -2723,8 +2727,9 @@ TRACE_EVENT(xrep_rmap_live_update,
 		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->agno = xg->xg_gno;
 		__entry->op = op;
 		__entry->agbno = p->startblock;
 		__entry->len = p->blockcount;
@@ -2733,10 +2738,12 @@ TRACE_EVENT(xrep_rmap_live_update,
 		if (p->unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x op %d agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x op %d %sbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __entry->op,
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agbno,
 		  __entry->len,
 		  __entry->owner,

