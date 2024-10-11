Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3391372
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607563; cv=none; b=rk/Oxb1LAjNmfkiyDVKagFHAlB+2PBkRkcXcII2i7cSpDd24rcp5X4FJclaRLH6120fkJx78Cv83ZT0xxujltcmr4DZJqgRKb/KNSB4agB9Q6+2q2FaJCsO5akZjv3oVPANzSi3+qyHVQljT2jbqt+crwU6TP2rYADhC/9xSwPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607563; c=relaxed/simple;
	bh=lrR+w3DjUM0pdA6H9YLQIKw9CoVlgFikEEAtov73xrA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KC6zkQ1mrGtc202D72fbHAzPXdPNJI++IUacg3vy+MPNo1p3Ao0fyEyJuuVlss6y/sxeMeT+lTn4bWf/6xOLkVdCwBK/TjA2fiXbLUKHOcCNbaKGfvKNRLchJM0tMBVBHp1vJGLed/YvxrksPegMLvrP0ykHS2+hPTLpo9YIHEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FZQlzlEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FZQlzlEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714A2C4CEC5;
	Fri, 11 Oct 2024 00:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607562;
	bh=lrR+w3DjUM0pdA6H9YLQIKw9CoVlgFikEEAtov73xrA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FZQlzlEyqpr1Vnn5M2Kbxat4+WlmQcRRGBrnbMA8Vo7ez2sUZkD72v8hNuoOf0v1z
	 2NTYraUutl+WOTV/aEHAtxbnCL84HvNnLevcMMaBD+JGoGp6HYkRPbAojAipv0WUR5
	 qTwVym1j640lx6DnjGeuxjjoZL8pi/VTeBU3HkEYH+ClWTGX8JJCPxLyYa6A2yDbTF
	 n5Iylc6h1YNYbu382BIOyyEhWWqI2GjXNHjkotmZmivyIgdbmXMIVNLT8WdmJ4Lt7t
	 c2gbiaM5uasfbq/xtp5JYSaq5sPKoewOV2RSgVmMfPMFBVI12F4N7XNLc5Xeedpuld
	 R1eq84CH16UxA==
Date: Thu, 10 Oct 2024 17:46:00 -0700
Subject: [PATCH 07/16] xfs: move draining of deferred operations to the
 generic group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860641382.4176300.7148519197600997081.stgit@frogsfrogsfrogs>
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

Prepare supporting the upcoming realtime groups feature by moving the
deferred operation draining to the generic xfs_group structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c    |    7 ++-----
 fs/xfs/libxfs/xfs_ag.h    |    9 ---------
 fs/xfs/libxfs/xfs_group.c |    4 ++++
 fs/xfs/libxfs/xfs_group.h |    9 +++++++++
 fs/xfs/scrub/common.c     |    4 ++--
 fs/xfs/xfs_drain.c        |   46 ++++++++++++++++++++++++---------------------
 fs/xfs/xfs_drain.h        |    6 ++++--
 fs/xfs/xfs_trace.h        |   36 ++++++++++++++++++++---------------
 8 files changed, 66 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 79e037612adf7a..ed4dc43d67dbcf 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -112,7 +112,6 @@ xfs_perag_uninit(
 #ifdef __KERNEL__
 	struct xfs_perag	*pag = to_perag(xg);
 
-	xfs_defer_drain_free(&pag->pag_intents_drain);
 	cancel_delayed_work_sync(&pag->pag_blockgc_work);
 	xfs_buf_cache_destroy(&pag->pag_bcache);
 #endif
@@ -213,7 +212,6 @@ xfs_perag_alloc(
 	spin_lock_init(&pag->pagb_lock);
 	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-	xfs_defer_drain_init(&pag->pag_intents_drain);
 	init_waitqueue_head(&pag->pagb_wait);
 	pag->pagb_tree = RB_ROOT;
 	xfs_hooks_init(&pag->pag_rmap_update_hooks);
@@ -221,7 +219,7 @@ xfs_perag_alloc(
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
 	if (error)
-		goto out_defer_drain_free;
+		goto out_free_perag;
 
 	/*
 	 * Pre-calculated geometry
@@ -239,8 +237,7 @@ xfs_perag_alloc(
 
 out_buf_cache_destroy:
 	xfs_buf_cache_destroy(&pag->pag_bcache);
-out_defer_drain_free:
-	xfs_defer_drain_free(&pag->pag_intents_drain);
+out_free_perag:
 	kfree(pag);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index d95af53e10d7e9..8ec00c6d9bd9e2 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -97,15 +97,6 @@ struct xfs_perag {
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;
 
-	/*
-	 * We use xfs_drain to track the number of deferred log intent items
-	 * that have been queued (but not yet processed) so that waiters (e.g.
-	 * scrub) will not lock resources when other threads are in the middle
-	 * of processing a chain of intent items only to find momentary
-	 * inconsistencies.
-	 */
-	struct xfs_defer_drain	pag_intents_drain;
-
 	/* Hook to feed rmapbt updates to an active online repair. */
 	struct xfs_hooks	pag_rmap_update_hooks;
 #endif /* __KERNEL__ */
diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index a68477639fd025..6d6d64288e49cf 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -160,6 +160,8 @@ xfs_group_free(
 
 	XFS_IS_CORRUPT(mp, atomic_read(&xg->xg_ref) != 0);
 
+	xfs_defer_drain_free(&xg->xg_intents_drain);
+
 	if (uninit)
 		uninit(xg);
 
@@ -185,6 +187,7 @@ xfs_group_insert(
 #ifdef __KERNEL__
 	spin_lock_init(&xg->xg_state_lock);
 #endif
+	xfs_defer_drain_init(&xg->xg_intents_drain);
 
 	/* Active ref owned by mount indicates group is online. */
 	atomic_set(&xg->xg_active_ref, 1);
@@ -192,6 +195,7 @@ xfs_group_insert(
 	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
 	if (error) {
 		WARN_ON_ONCE(error == -EBUSY);
+		xfs_defer_drain_free(&xg->xg_intents_drain);
 		return error;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 93b247dd12c430..3184214310a609 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -22,6 +22,15 @@ struct xfs_group {
 	uint16_t		xg_checked;
 	uint16_t		xg_sick;
 	spinlock_t		xg_state_lock;
+
+	/*
+	 * We use xfs_drain to track the number of deferred log intent items
+	 * that have been queued (but not yet processed) so that waiters (e.g.
+	 * scrub) will not lock resources when other threads are in the middle
+	 * of processing a chain of intent items only to find momentary
+	 * inconsistencies.
+	 */
+	struct xfs_defer_drain	xg_intents_drain;
 #endif /* __KERNEL__ */
 };
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 28095ed490fbf6..b71768c2a8c129 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -513,7 +513,7 @@ xchk_perag_drain_and_lock(
 		 * Obviously, this should be slanted against scrub and in favor
 		 * of runtime threads.
 		 */
-		if (!xfs_perag_intent_busy(sa->pag))
+		if (!xfs_group_intent_busy(&sa->pag->pag_group))
 			return 0;
 
 		if (sa->agf_bp) {
@@ -528,7 +528,7 @@ xchk_perag_drain_and_lock(
 
 		if (!(sc->flags & XCHK_FSGATES_DRAIN))
 			return -ECHRNG;
-		error = xfs_perag_intent_drain(sa->pag);
+		error = xfs_group_intent_drain(&sa->pag->pag_group);
 		if (error == -ERESTARTSYS)
 			error = -EINTR;
 	} while (!error);
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 3f280971b498b8..3d234016c53547 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -94,24 +94,26 @@ static inline int xfs_defer_drain_wait(struct xfs_defer_drain *dr)
 }
 
 /*
- * Declare an intent to update AG metadata.  Other threads that need exclusive
- * access can decide to back off if they see declared intentions.
+ * Declare an intent to update group metadata.  Other threads that need
+ * exclusive access can decide to back off if they see declared intentions.
  */
 static void
-xfs_perag_intent_hold(
-	struct xfs_perag	*pag)
+xfs_group_intent_hold(
+	struct xfs_group	*xg)
 {
-	trace_xfs_perag_intent_hold(pag, __return_address);
-	xfs_defer_drain_grab(&pag->pag_intents_drain);
+	trace_xfs_group_intent_hold(xg, __return_address);
+	xfs_defer_drain_grab(&xg->xg_intents_drain);
 }
 
-/* Release our intent to update this AG's metadata. */
+/*
+ * Release our intent to update this groups metadata.
+ */
 static void
-xfs_perag_intent_rele(
-	struct xfs_perag	*pag)
+xfs_group_intent_rele(
+	struct xfs_group	*xg)
 {
-	trace_xfs_perag_intent_rele(pag, __return_address);
-	xfs_defer_drain_rele(&pag->pag_intents_drain);
+	trace_xfs_group_intent_rele(xg, __return_address);
+	xfs_defer_drain_rele(&xg->xg_intents_drain);
 }
 
 /*
@@ -129,7 +131,7 @@ xfs_perag_intent_get(
 	if (!pag)
 		return NULL;
 
-	xfs_perag_intent_hold(pag);
+	xfs_group_intent_hold(&pag->pag_group);
 	return pag;
 }
 
@@ -141,7 +143,7 @@ void
 xfs_perag_intent_put(
 	struct xfs_perag	*pag)
 {
-	xfs_perag_intent_rele(pag);
+	xfs_group_intent_rele(&pag->pag_group);
 	xfs_perag_put(pag);
 }
 
@@ -150,17 +152,19 @@ xfs_perag_intent_put(
  * Callers must not hold any AG header buffers.
  */
 int
-xfs_perag_intent_drain(
-	struct xfs_perag	*pag)
+xfs_group_intent_drain(
+	struct xfs_group	*xg)
 {
-	trace_xfs_perag_wait_intents(pag, __return_address);
-	return xfs_defer_drain_wait(&pag->pag_intents_drain);
+	trace_xfs_group_wait_intents(xg, __return_address);
+	return xfs_defer_drain_wait(&xg->xg_intents_drain);
 }
 
-/* Has anyone declared an intent to update this AG? */
+/*
+ * Has anyone declared an intent to update this group?
+ */
 bool
-xfs_perag_intent_busy(
-	struct xfs_perag	*pag)
+xfs_group_intent_busy(
+	struct xfs_group	*xg)
 {
-	return xfs_defer_drain_busy(&pag->pag_intents_drain);
+	return xfs_defer_drain_busy(&xg->xg_intents_drain);
 }
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index f39c90946ab71f..3e6143572e52d2 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -6,6 +6,7 @@
 #ifndef XFS_DRAIN_H_
 #define XFS_DRAIN_H_
 
+struct xfs_group;
 struct xfs_perag;
 
 #ifdef CONFIG_XFS_DRAIN_INTENTS
@@ -65,8 +66,9 @@ struct xfs_perag *xfs_perag_intent_get(struct xfs_mount *mp,
 		xfs_fsblock_t fsbno);
 void xfs_perag_intent_put(struct xfs_perag *pag);
 
-int xfs_perag_intent_drain(struct xfs_perag *pag);
-bool xfs_perag_intent_busy(struct xfs_perag *pag);
+int xfs_group_intent_drain(struct xfs_group *xg);
+bool xfs_group_intent_busy(struct xfs_group *xg);
+
 #else
 struct xfs_defer_drain { /* empty */ };
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ac2ec21d3486fe..40f535538dc0ec 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4689,35 +4689,39 @@ TRACE_EVENT(xfs_force_shutdown,
 );
 
 #ifdef CONFIG_XFS_DRAIN_INTENTS
-DECLARE_EVENT_CLASS(xfs_perag_intents_class,
-	TP_PROTO(const struct xfs_perag *pag, void *caller_ip),
-	TP_ARGS(pag, caller_ip),
+DECLARE_EVENT_CLASS(xfs_group_intents_class,
+	TP_PROTO(const struct xfs_group *xg, void *caller_ip),
+	TP_ARGS(xg, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
+		__field(enum xfs_group_type, type)
+		__field(uint32_t, index)
 		__field(long, nr_intents)
 		__field(void *, caller_ip)
 	),
 	TP_fast_assign(
-		__entry->dev = pag_mount(pag)->m_super->s_dev;
-		__entry->agno = pag_agno(pag);
-		__entry->nr_intents = atomic_read(&pag->pag_intents_drain.dr_count);
+		__entry->dev = xg->xg_mount->m_super->s_dev;
+		__entry->type = xg->xg_type;
+		__entry->index = xg->xg_index;
+		__entry->nr_intents =
+			atomic_read(&xg->xg_intents_drain.dr_count);
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno 0x%x intents %ld caller %pS",
+	TP_printk("dev %d:%d %sno 0x%x intents %ld caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->agno,
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
+		  __entry->index,
 		  __entry->nr_intents,
 		  __entry->caller_ip)
 );
 
-#define DEFINE_PERAG_INTENTS_EVENT(name)	\
-DEFINE_EVENT(xfs_perag_intents_class, name,					\
-	TP_PROTO(const struct xfs_perag *pag, void *caller_ip), \
-	TP_ARGS(pag, caller_ip))
-DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_hold);
-DEFINE_PERAG_INTENTS_EVENT(xfs_perag_intent_rele);
-DEFINE_PERAG_INTENTS_EVENT(xfs_perag_wait_intents);
+#define DEFINE_GROUP_INTENTS_EVENT(name)	\
+DEFINE_EVENT(xfs_group_intents_class, name,					\
+	TP_PROTO(const struct xfs_group *xg, void *caller_ip), \
+	TP_ARGS(xg, caller_ip))
+DEFINE_GROUP_INTENTS_EVENT(xfs_group_intent_hold);
+DEFINE_GROUP_INTENTS_EVENT(xfs_group_intent_rele);
+DEFINE_GROUP_INTENTS_EVENT(xfs_group_wait_intents);
 
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 

