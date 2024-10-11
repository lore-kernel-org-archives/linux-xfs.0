Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BC62F22
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607578; cv=none; b=Jy5KSqyu8b1b+H+jHaw094IWlM7N5SLZIklz99zbZveHNtJSRAWJkDroAuWAwFAasB2LQBTITWWKxf+cK4QMjF7GlnlDtjZ4F681nVq/hZkm5nT0CnjWGl+khqTBDWE9lw4mtncbmLJeCZdzRNB+hKDyKlrfHZKkEI2hR++Odmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607578; c=relaxed/simple;
	bh=xpKmMibbogt20KY73zxdCuOQpSaKiNyzFqLfgc3anms=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2jFeQZULbrxyhbwor96XMGnNohDxdQ9XAqGKDbFIidewNHIGLofxYAkPIBeEolcbJ8tmBsPXkskIQmdQmowAtdVpnr98kHCX622/jsJ0vi6feo44MF52M1NiKgUo1uCrTsFIUaM0Fe1lzJjcKx9z5YvX4kea2FDI+0Lb7KdB98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NK9hkl07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NK9hkl07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1782CC4CEC5;
	Fri, 11 Oct 2024 00:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607578;
	bh=xpKmMibbogt20KY73zxdCuOQpSaKiNyzFqLfgc3anms=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NK9hkl07QyH9YegRjEuYcFgEc10Gttuntlc/IAXlRWy4wdQ6GDn5nRXbcSMLooNei
	 byNZawN6eLwncgxZCw63+d7OwW260X/OvpaRmIu8B9wSJSzgyBI4SUy3giCfPamYSG
	 XvigFxmDAWDeo+UHodxRA21RR05gyYoWhIF5k8n2GG5bAKRRxjDeeFOsfibl4rIhSg
	 nMHlD+PowZzAHtIltP/JizLtezElGZfyQ0Y4k6ZprbeHZ1K7zw1Fr2keBybYZ3bzJM
	 YEDFCcHrm6H07pJ64KovE5Mf8yCV9kMWfx+Z+0b3h7BLihXYUgLNbIfqCz+2giXS7t
	 otsM7CLcfpkVg==
Date: Thu, 10 Oct 2024 17:46:17 -0700
Subject: [PATCH 08/16] xfs: move the online repair rmap hooks to the generic
 group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641400.4176300.8068374778134424503.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
 fs/xfs/libxfs/xfs_rmap.c   |   22 ++++++++++++----------
 fs/xfs/libxfs/xfs_rmap.h   |    4 ++--
 fs/xfs/scrub/rmap_repair.c |    4 ++--
 7 files changed, 22 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index ed4dc43d67dbcf..d2ed559a700cee 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -214,7 +214,6 @@ xfs_perag_alloc(
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 	init_waitqueue_head(&pag->pagb_wait);
 	pag->pagb_tree = RB_ROOT;
-	xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 8ec00c6d9bd9e2..a8c27906de98a2 100644
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
index 6d6d64288e49cf..50e35d07a915d7 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -186,6 +186,7 @@ xfs_group_insert(
 
 #ifdef __KERNEL__
 	spin_lock_init(&xg->xg_state_lock);
+	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
 	xfs_defer_drain_init(&xg->xg_intents_drain);
 
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 3184214310a609..485cc5ce99f03f 100644
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
index b6764d6b3ab891..53c4b51c8a8217 100644
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
+	xfs_rmap_update_hook(tp, &pag->pag_group, XFS_RMAP_UNMAP, bno, len,
+			false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1149,7 +1150,8 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, &pag->pag_group, XFS_RMAP_MAP, bno, len, false,
+			oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2620,7 +2622,7 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
+	xfs_rmap_update_hook(tp, &ri->ri_pag->pag_group, ri->ri_type, bno,
 			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
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
index f88f58db909867..4ab0ae4919c1a8 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -1611,7 +1611,7 @@ xrep_rmap_setup_scan(
 	 */
 	ASSERT(sc->flags & XCHK_FSGATES_RMAP);
 	xfs_rmap_hook_setup(&rr->rhook, xrep_rmapbt_live_update);
-	error = xfs_rmap_hook_add(sc->sa.pag, &rr->rhook);
+	error = xfs_rmap_hook_add(&sc->sa.pag->pag_group, &rr->rhook);
 	if (error)
 		goto out_iscan;
 	return 0;
@@ -1632,7 +1632,7 @@ xrep_rmap_teardown(
 	struct xfs_scrub	*sc = rr->sc;
 
 	xchk_iscan_abort(&rr->iscan);
-	xfs_rmap_hook_del(sc->sa.pag, &rr->rhook);
+	xfs_rmap_hook_del(&sc->sa.pag->pag_group, &rr->rhook);
 	xchk_iscan_teardown(&rr->iscan);
 	xfbtree_destroy(&rr->rmap_btree);
 	mutex_destroy(&rr->lock);

