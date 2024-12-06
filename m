Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A782719ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733528129; cv=none; b=Fb0vl2GKhOUX1aDponIrPWoKNbzgyap9JTpi2nCOILA3X8oBF0wT803D1XsGAXHd+c+HcLfOQ5u/jP1tnGCsMYr9sE67fWsXwBude7twmM/dCeEgMNWX1fBksqdqc7iBvSbvWqzbXJKK6B9RA4lHFCgLs0cTf7M0ugYck7DX/ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733528129; c=relaxed/simple;
	bh=SAj7uXJsuNCGSZqu/M47GZIqIp0+p7nHnu1QuOwjvhg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pm3J30lXdeO1bsXAQfwKI8jNX/oY3RFcQnTbvwfM177SgSFaGSK1IP7tD6XrXgz+z2hgeObiwVAwFUZ9w1r4m2nO22PhmpCP56XwrKJ/thvuv6mN31rMR08/q3Z2n2vVuCwXC8H7E3EODd9UOEvO3yVPViptZd3U0HOJUZ4VXz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uPBuuubM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uPBuuubM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E14C4CED1;
	Fri,  6 Dec 2024 23:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733528129;
	bh=SAj7uXJsuNCGSZqu/M47GZIqIp0+p7nHnu1QuOwjvhg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uPBuuubM1CfkmQqhkWPbhrD1j2xNnzGSY95AtKAUbl3TtLriOWltFRagRVN3J1GSt
	 Bknp978HGZRTdkAt4ICvYEZSyAhJnHMxqtgMB1C1B3kibe/Y2B0rPwJtYWHzMV18Pj
	 UP/4cBTXH9YikLa3LydtV039Uc3FwULcjfCPU3sxNtOWLnw0VDklbGf30aWf3VCr6l
	 aa/QUD2axK9CFXVkCJPl8cTjdrn8Q+5kOLFvaNTxBUiMNfQulfWQi1/Dw1ziSG6Ry9
	 AV3ToqMjpuJ8OoLIdwe/lAha1VJJrZBpI1XMF/Eo0RhrMD0oVCdsY9Zfqu3PltLq92
	 qo5e7fNkopF3Q==
Date: Fri, 06 Dec 2024 15:35:28 -0800
Subject: [PATCH 20/36] xfs: move the online repair rmap hooks to the generic
 group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352747180.121772.11042488996630419562.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: eb4a84a3c2bd09efe770fa940fb68e349f90c8c6

Prepare for the upcoming realtime groups feature by moving the online
repair rmap hooks to based to the generic xfs_group structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_ag.c    |    1 -
 libxfs/xfs_ag.h    |    3 ---
 libxfs/xfs_group.c |    1 +
 libxfs/xfs_group.h |    5 +++++
 libxfs/xfs_rmap.c  |   24 +++++++++++++-----------
 libxfs/xfs_rmap.h  |    4 ++--
 6 files changed, 21 insertions(+), 17 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index d67e40f49a3fc0..1542fea06e305e 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -233,7 +233,6 @@ xfs_perag_alloc(
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
 	init_waitqueue_head(&pag->pagb_wait);
 	pag->pagb_tree = RB_ROOT;
-	xfs_hooks_init(&pag->pag_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 45f8de06cdbc8a..042ee0913fb9b9 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -96,9 +96,6 @@ struct xfs_perag {
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
-
-	/* Hook to feed rmapbt updates to an active online repair. */
-	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 
diff --git a/libxfs/xfs_group.c b/libxfs/xfs_group.c
index dfcebf2e9b30f8..58ace330a765cf 100644
--- a/libxfs/xfs_group.c
+++ b/libxfs/xfs_group.c
@@ -185,6 +185,7 @@ xfs_group_insert(
 
 #ifdef __KERNEL__
 	spin_lock_init(&xg->xg_state_lock);
+	xfs_hooks_init(&xg->xg_rmap_update_hooks);
 #endif
 	xfs_defer_drain_init(&xg->xg_intents_drain);
 
diff --git a/libxfs/xfs_group.h b/libxfs/xfs_group.h
index ebefbba7d98cc2..a87b9b80ef7516 100644
--- a/libxfs/xfs_group.h
+++ b/libxfs/xfs_group.h
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
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 0f7dee40bda87a..e13f4aa7e99538 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -834,7 +834,7 @@ xfs_rmap_hook_enable(void)
 static inline void
 xfs_rmap_update_hook(
 	struct xfs_trans		*tp,
-	struct xfs_perag		*pag,
+	struct xfs_group		*xg,
 	enum xfs_rmap_intent_type	op,
 	xfs_agblock_t			startblock,
 	xfs_extlen_t			blockcount,
@@ -849,27 +849,27 @@ xfs_rmap_update_hook(
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
@@ -904,7 +904,8 @@ xfs_rmap_free(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_UNMAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_UNMAP, bno, len,
+			false, oinfo);
 	error = xfs_rmap_unmap(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -1148,7 +1149,8 @@ xfs_rmap_alloc(
 		return 0;
 
 	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
-	xfs_rmap_update_hook(tp, pag, XFS_RMAP_MAP, bno, len, false, oinfo);
+	xfs_rmap_update_hook(tp, pag_group(pag), XFS_RMAP_MAP, bno, len, false,
+			oinfo);
 	error = xfs_rmap_map(cur, bno, len, false, oinfo);
 
 	xfs_btree_del_cursor(cur, error);
@@ -2619,8 +2621,8 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, ri->ri_pag, ri->ri_type, bno,
-			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	xfs_rmap_update_hook(tp, pag_group(ri->ri_pag), ri->ri_type, bno,
+			     ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
 
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index b783dd4dd95d1a..d409b463bc6662 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -264,8 +264,8 @@ struct xfs_rmap_hook {
 void xfs_rmap_hook_disable(void);
 void xfs_rmap_hook_enable(void);
 
-int xfs_rmap_hook_add(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
-void xfs_rmap_hook_del(struct xfs_perag *pag, struct xfs_rmap_hook *hook);
+int xfs_rmap_hook_add(struct xfs_group *xg, struct xfs_rmap_hook *hook);
+void xfs_rmap_hook_del(struct xfs_group *xg, struct xfs_rmap_hook *hook);
 void xfs_rmap_hook_setup(struct xfs_rmap_hook *hook, notifier_fn_t mod_fn);
 #endif
 

