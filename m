Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33661F667B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844873; cv=none; b=qMkoL0nehdlcnVekgA1zugJiQ+LQ3dnjBGP02WPMFTUuROg/m/ehD3zQ3GgkgSrAMy05a80TUsW4tWf0SoS2tYDxaRBIGdjQuaQyMH+WQzP2FB86h71ryTfHT45U23Qqz3ab0MXRTO2yIA4ir4oGbooiQOu+2y1k2DGPwH4gAlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844873; c=relaxed/simple;
	bh=my1wQOYy9qJmjip6zjHKpjyKCj1UZ30TFtEdehsIE4w=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=atyFjY3e2cRq/pnPo5fHj6BkqNS4rj3Zkyfho5Yy8SKinT/FEManx2bIBRarSaZi4uwCyJ+GIPQ7pa2BaSXVv2bStXf9JOuoQhCYaQRElPU0L8JPmCw3B1xT9MvKO6l/66OTpzl/xesoY+f4iPzYmWEtxz6SU6+/z/apvhx0a5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyOLyg1+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyOLyg1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89515C4CECF;
	Tue,  5 Nov 2024 22:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844873;
	bh=my1wQOYy9qJmjip6zjHKpjyKCj1UZ30TFtEdehsIE4w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MyOLyg1++SuXbNH8eSg2ar4ZkVmJgQ9fDQ3IxVCkDtr3HeJe+eMc3n+Aap8rpxjIr
	 1OttA6JSew3P7UJ/be8S36x086+vwFvXQixXOa6nbYvsDQ91UZVrUAtG4nG/RS02ra
	 QrSkpDZUeBSavSp3WLWo1IpAq3P4RLFmCkzW02Jik3t88G8Dx2oW4IRSN7wlRRrRl8
	 PLscRffHb9PTow1K9gobXh7n+MHslYIpxDdbH+H9MAuFwuSzdjAoPernZHA7xrPB2x
	 7O79LlF9PHAwOOSas5eVMe4wDI7YpJKBZJsRSt5Kfc3Wz7KIkoe5wNx08i97qJl2iP
	 LBXBajXoS1k1Q==
Date: Tue, 05 Nov 2024 14:14:33 -0800
Subject: [PATCH 08/16] xfs: move the online repair rmap hooks to the generic
 group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395407.1869491.17920277207031054678.stgit@frogsfrogsfrogs>
In-Reply-To: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
References: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Prepare for the upcoming realtime groups feature by moving the online
repair rmap hooks to based to the generic xfs_group structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c     |    1 -
 fs/xfs/libxfs/xfs_ag.h     |    3 ---
 fs/xfs/libxfs/xfs_group.c  |    1 +
 fs/xfs/libxfs/xfs_group.h  |    5 +++++
 fs/xfs/libxfs/xfs_rmap.c   |   24 +++++++++++++-----------
 fs/xfs/libxfs/xfs_rmap.h   |    4 ++--
 fs/xfs/scrub/rmap_repair.c |    4 ++--
 7 files changed, 23 insertions(+), 19 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index c2f1f830d299d3..e60469fee87514 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -235,7 +235,6 @@ xfs_perag_alloc(
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 	init_waitqueue_head(&pag->pagb_wait);
 	pag->pagb_tree = RB_ROOT;
-	xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 45f8de06cdbc8a..042ee0913fb9b9 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -96,9 +96,6 @@ struct xfs_perag {
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
-
-	/* Hook to feed rmapbt updates to an active online repair. */
-	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 6737f009dd38ca..8532dc2f8628c5 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -186,6 +186,7 @@ xfs_group_insert(
 
 #ifdef __KERNEL__
 	spin_lock_init(&xg->xg_state_lock);
+	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
 	xfs_defer_drain_init(&xg->xg_intents_drain);
 
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index ebefbba7d98cc2..a87b9b80ef7516 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -31,6 +31,11 @@ struct xfs_group {
 	 * inconsistencies.
 	 */
 	struct xfs_defer_drain	xg_intents_drain;
+
+	/*
+	 * Hook to feed rmapbt updates to an active online repair.
+	 */
+	struct xfs_hooks	xg_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index b6764d6b3ab891..984120b128fb9c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -835,7 +835,7 @@ xfs_rmap_hook_enable(void)
 static inline void
 xfs_rmap_update_hook(
 	struct xfs_trans		*tp,
-	struct xfs_perag		*pag,
+	struct xfs_group		*xg,
 	enum xfs_rmap_intent_type	op,
 	xfs_agblock_t			startblock,
 	xfs_extlen_t			blockcount,
@@ -850,27 +850,27 @@ xfs_rmap_update_hook(
 			.oinfo		= *oinfo, /* struct copy */
 		};
 
-		if (pag)
-			xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
+		if (xg)
+			xfs_hooks_call(&xg->xg_rmap_update_hooks, op, &p);
 	}
 }
 
 /* Call the specified function during a reverse mapping update. */
 int
 xfs_rmap_hook_add(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	struct xfs_rmap_hook	*hook)
 {
-	return xfs_hooks_add(&pag->pag_rmap_update_hooks, &hook->rmap_hook);
+	return xfs_hooks_add(&xg->xg_rmap_update_hooks, &hook->rmap_hook);
 }
 
 /* Stop calling the specified function during a reverse mapping update. */
 void
 xfs_rmap_hook_del(
-	struct xfs_perag	*pag,
+	struct xfs_group	*xg,
 	struct xfs_rmap_hook	*hook)
 {
-	xfs_hooks_del(&pag->pag_rmap_update_hooks, &hook->rmap_hook);
+	xfs_hooks_del(&xg->xg_rmap_update_hooks, &hook->rmap_hook);
 }
 
 /* Configure rmap update hook functions. */
@@ -905,7 +905,8 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_UNMAP, bno, len,
+			false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1149,7 +1150,8 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_MAP, bno, len, false,
+			oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2620,8 +2622,8 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
-			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	xfs_rmap_update_hook(tp, pag_group(ri->ri_pag), ri->ri_type, bno,
+			     ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index b783dd4dd95d1a..d409b463bc6662 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -264,8 +264,8 @@ struct xfs_rmap_hook {
 void xfs_rmap_hook_disable(void);
 void xfs_rmap_hook_enable(void);
 
-int xfs_rmap_hook_add(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
-void xfs_rmap_hook_del(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+int xfs_rmap_hook_add(struct xfs_group *xg, struct xfs_rmap_hook *hook);
+void xfs_rmap_hook_del(struct xfs_group *xg, struct xfs_rmap_hook *hook);
 void xfs_rmap_hook_setup(struct xfs_rmap_hook *hook, notifier_fn_t mod_fn);
 #endif
 
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index f88f58db909867..6c420ec7dacd1b 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -1611,7 +1611,7 @@ xrep_rmap_setup_scan(
 	 */
 	ASSERT(sc->flags & XCHK_FSGATES_RMAP);
 	xfs_rmap_hook_setup(&rr->rhook, xrep_rmapbt_live_update);
-	error = xfs_rmap_hook_add(sc->sa.pag, &rr->rhook);
+	error = xfs_rmap_hook_add(pag_group(sc->sa.pag), &rr->rhook);
 	if (error)
 		goto out_iscan;
 	return 0;
@@ -1632,7 +1632,7 @@ xrep_rmap_teardown(
 	struct xfs_scrub	*sc = rr->sc;
 
 	xchk_iscan_abort(&rr->iscan);
-	xfs_rmap_hook_del(sc->sa.pag, &rr->rhook);
+	xfs_rmap_hook_del(pag_group(sc->sa.pag), &rr->rhook);
 	xchk_iscan_teardown(&rr->iscan);
 	xfbtree_destroy(&rr->rmap_btree);
 	mutex_destroy(&rr->lock);

