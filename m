Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3F138E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFxDocOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACA8C433C7;
	Mon,  1 Jan 2024 00:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068160;
	bh=r1KZ56/lKpINmfcuWxkAONBq6YiJ8Kuwm7+/CwW9X+4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FFxDocOob9GLZW6ILQbqtyfBiH+uTuhYqv6B7oEw3qTbtUV8gdd936iUP+vZqm+JR
	 gxiuzBprDVYAfoG9mPI7B77EtFWqYnJCHD4VVIpEA6tFVMswziTfPCpWBWxE68BFYH
	 2dyzPj16Bf5cc+FCwTYrEVRsgARzXmwiA1D9jONbXUHnHX/S/Ifs1nPbKO3qicgqdI
	 t4h9mjXSXGtzwrVGT16E6SiBqkxY5e0xbUogLurcMLlMYKCWXH1GWFkEmqng1U8n6S
	 rBfzJHAs5wVsaeSU6UkfDvh1e1ddJ9P0G1Zo9fZSP1d/R0/Dpw6Qlo6OWgvXcPyjW9
	 Gl5ivDZDh8Wuw==
Date: Sun, 31 Dec 2023 16:15:59 +9900
Subject: [PATCH 21/47] xfs: hook live realtime rmap operations during a repair
 operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015592.1815505.13752026724077466077.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_rmap.c    |   56 +++++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/xfs_rmap.h    |    6 +++++
 libxfs/xfs_rtgroup.c |    1 +
 libxfs/xfs_rtgroup.h |    3 +++
 4 files changed, 63 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 42713dd17f4..0056dc08662 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -919,8 +919,7 @@ xfs_rmap_update_hook(
 			.oinfo		= *oinfo, /* struct copy */
 		};
 
-		if (pag)
-			xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
+		xfs_hooks_call(&pag->pag_rmap_update_hooks, op, &p);
 	}
 }
 
@@ -945,6 +944,50 @@ xfs_rmap_hook_del(
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
@@ -2701,6 +2744,7 @@ xfs_rtrmap_finish_one(
 	xfs_rgnumber_t			rgno;
 	xfs_rgblock_t			bno;
 	bool				unwritten;
+	int				error;
 
 	trace_xfs_rmap_deferred(mp, ri);
 
@@ -2726,8 +2770,14 @@ xfs_rtrmap_finish_one(
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
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 3719fc4cbc2..9e19e657eef 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
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
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 1acf98f8c7e..03eb776ef8b 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -160,6 +160,7 @@ xfs_initialize_rtgroups(
 		spin_lock_init(&rtg->rtg_state_lock);
 		init_waitqueue_head(&rtg->rtg_active_wq);
 		xfs_defer_drain_init(&rtg->rtg_intents_drain);
+		xfs_hooks_init(&rtg->rtg_rmap_update_hooks);
 #endif /* __KERNEL__ */
 
 		/* Active ref owned by mount indicates rtgroup is online. */
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 9487c2e0047..3522527e553 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -48,6 +48,9 @@ struct xfs_rtgroup {
 	 * inconsistencies.
 	 */
 	struct xfs_defer_drain	rtg_intents_drain;
+
+	/* Hook to feed rt rmapbt updates to an active online repair. */
+	struct xfs_hooks	rtg_rmap_update_hooks;
 #endif /* __KERNEL__ */
 };
 

