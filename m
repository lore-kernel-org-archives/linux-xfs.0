Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638C1130AD7
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442272; cv=none; b=B59cOrMUF6grf20N4SNiF9H36xkn8/8CIHNgZiPpGHtjcmPn2EF572leJLu5KOMZVwHE4abPGH2Ik/8fH1tBTqBIyyw8c2osmlg8DNQX60Ztm1tG1usFLDFsrQ4AtlI8NSeUM99KZNoQYuJLXy2u71p7jzatst/QO374SHCvTUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442272; c=relaxed/simple;
	bh=+CWUysEhymU/5FG8kjUQGDsptTUS35Zn5CxWubOtaiM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kQHS5RtjVPGGvptK3nnqez3gTRerd9xYn5TJ5EKEpxAdH3iU6Xx8l0JX+V0UPh7A2f/EiJGgc0eRR7/Ui+UwYL+bze95OcHu0JDB19S1HfPhGD00YBXdhSod3IuwEO7VDCDtZeaCJcTHbVIT6NKiOm2QxztGrQMxiORBkvQAHec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oBvT5/8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oBvT5/8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401EDC2BD10;
	Mon,  3 Jun 2024 19:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442272;
	bh=+CWUysEhymU/5FG8kjUQGDsptTUS35Zn5CxWubOtaiM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oBvT5/8sCUmLM7y9BrntE49nbr0wPXnLkI7W1DhAD3eGzLMxfheB7UBSgVRpgY7sV
	 n1PH+xQv/Q1Nu/DtbPC7vjGsfGq+K1Ejh7chcmEvD1BgFlOYYgFW6bOJaxRtPAGy99
	 ybTe6tUTg370F4LpUs1QJf9JhWBazeCSKAZPUWy5D8iCBjQc+FVFQd5twcA8ak16sZ
	 IPVL2GNJ4jmYvJr4VtIhrSqgeNtJTUUOEh4jx6HRbEQJ/OPoBslcDA9VpuatuvAbCA
	 6djW/l7Vrx7bEjbL3xY84M+K7kEG96rG+tPgm8j1y8ro/To8GRXWDeDTrm87FrRlIl
	 eM7NuEXbmZPZw==
Date: Mon, 03 Jun 2024 12:17:51 -0700
Subject: [PATCH 099/111] xfs: hook live rmap operations during a repair
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040853.1443973.3203347477022676763.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 7e1b84b24d257700e417bc9cd724c1efdff653d7

Hook the regular rmap code when an rmapbt repair operation is running so
that we can unlock the AGF buffer to scan the filesystem and keep the
in-memory btree up to date during the scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_ag.c   |    1 
 libxfs/xfs_ag.h   |    3 +
 libxfs/xfs_rmap.c |  154 ++++++++++++++++++++++++++++++++++++++++++-----------
 libxfs/xfs_rmap.h |   29 ++++++++++
 4 files changed, 154 insertions(+), 33 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 06a881285..e2fc3e882 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -415,6 +415,7 @@ xfs_initialize_perag(
 		init_waitqueue_head(&pag->pag_active_wq);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
+		xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		error = xfs_buf_cache_init(&pag->pag_bcache);
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index e019b79db..35de09a25 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -120,6 +120,9 @@ struct xfs_perag {
 	 * inconsistencies.
 	 */
 	struct xfs_defer_drain	pag_intents_drain;
+
+	/* Hook to feed rmapbt updates to an active online repair. */
+	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index a7be2aa92..c3195e532 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -820,6 +820,86 @@ xfs_rmap_unmap(
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
+	return xfs_hooks_add(&pag->pag_rmap_update_hooks, &hook->rmap_hook);
+}
+
+/* Stop calling the specified function during a reverse mapping update. */
+void
+xfs_rmap_hook_del(
+	struct xfs_perag	*pag,
+	struct xfs_rmap_hook	*hook)
+{
+	xfs_hooks_del(&pag->pag_rmap_update_hooks, &hook->rmap_hook);
+}
+
+/* Configure rmap update hook functions. */
+void
+xfs_rmap_hook_setup(
+	struct xfs_rmap_hook	*hook,
+	notifier_fn_t		mod_fn)
+{
+	xfs_hook_setup(&hook->rmap_hook, mod_fn);
+}
+#else
+# define xfs_rmap_update_hook(t, p, o, s, b, u, oi)	do { } while (0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Remove a reference to an extent in the rmap btree.
  */
@@ -840,7 +920,7 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-
+	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1092,6 +1172,7 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
+	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2507,6 +2588,38 @@ xfs_rmap_finish_one_cleanup(
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
@@ -2573,39 +2686,14 @@ xfs_rmap_finish_one(
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
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 58c67896d..9d01fe689 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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
@@ -235,4 +239,29 @@ extern struct kmem_cache	*xfs_rmap_intent_cache;
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
+	struct xfs_hook			rmap_hook;
+};
+
+void xfs_rmap_hook_disable(void);
+void xfs_rmap_hook_enable(void);
+
+int xfs_rmap_hook_add(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+void xfs_rmap_hook_del(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+void xfs_rmap_hook_setup(struct xfs_rmap_hook *hook, notifier_fn_t mod_fn);
+#endif
+
 #endif	/* __XFS_RMAP_H__ */

