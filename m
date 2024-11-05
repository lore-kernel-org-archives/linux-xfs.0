Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770AE1F667B
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844859; cv=none; b=Pf2MzH8rLqNjPfBrI0iCQwZYFpg1sY+ESLIKDn27uK6GhAOEZcQlacuX1Csahk9/xKLTu0kCNTpl3QmTF1MIuaNJ2rzIyguXy4cuI9vn0QXwMnktTm8nkY0FLBCN5ZxG8p1tYaPH0txy4tnKep+thzzBEsomyirrK+gOEvuHo5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844859; c=relaxed/simple;
	bh=OPBVxrIwZX7ebPNYfCwLOHWFbGsCSJpCEhcuCPAbQWk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hZLokxE6jRPUTw0oC+XEFaUnDEUW9RA4+lrazyrvgz3CtuQRrtL5eWH2d9F4k9ibQSpT11eb6LQksX801wxX9KywizNTtGQ+WC0MoxvCDAU5Ef5dXF32hJvBleiw85jHOsO/ambWLdGB6/D1L0Fbwp3fOgiMSnOLeSH/b2TZIls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqLrrfSD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqLrrfSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30CEC4CECF;
	Tue,  5 Nov 2024 22:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844858;
	bh=OPBVxrIwZX7ebPNYfCwLOHWFbGsCSJpCEhcuCPAbQWk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jqLrrfSDCmboF1NMJ5OjfmlzvVriUZTwIowiqrFz9kQ38mEBYgo6EbKDHvAqjOm03
	 kP/u16UfFmGwsIhPvZrlUxrqV5KWm98JFy8pmzAnaVECh+8D9MUIz55slDtfizLVju
	 rP1p3sgykWvaqFOvhzEH4W33GAyx2XrZH7MjrTIdy/WwOXSFAy2+y6X0mLXEr7h5RR
	 wp7Cg7wYsv8v+Hf2qUxAl7ZhEI5sF/QFllUetwJM0VVsCUxLmwvlBBfDDNRt+mLZs/
	 jjyXq/sZtGPum3qpjRNhlbZ/g6K0ugpqXeKdDU6vp+wVRiTcaIIHK/G7TrF2RjYngg
	 /fndWqufr2HeA==
Date: Tue, 05 Nov 2024 14:14:17 -0800
Subject: [PATCH 07/16] xfs: move draining of deferred operations to the
 generic group structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395390.1869491.15523122724227287094.stgit@frogsfrogsfrogs>
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
index 84bd3831297e07..c2f1f830d299d3 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -112,7 +112,6 @@ xfs_perag_uninit(
 #ifdef __KERNEL__
 	struct xfs_perag	*pag = to_perag(xg);
 
-	xfs_defer_drain_free(&pag->pag_intents_drain);
 	cancel_delayed_work_sync(&pag->pag_blockgc_work);
 	xfs_buf_cache_destroy(&pag->pag_bcache);
 #endif
@@ -234,7 +233,6 @@ xfs_perag_alloc(
 	spin_lock_init(&pag->pagb_lock);
 	INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 	INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-	xfs_defer_drain_init(&pag->pag_intents_drain);
 	init_waitqueue_head(&pag->pagb_wait);
 	pag->pagb_tree = RB_ROOT;
 	xfs_hooks_init(&pag->pag_rmap_update_hooks);
@@ -242,7 +240,7 @@ xfs_perag_alloc(
 
 	error = xfs_buf_cache_init(&pag->pag_bcache);
 	if (error)
-		goto out_defer_drain_free;
+		goto out_free_perag;
 
 	/*
 	 * Pre-calculated geometry
@@ -260,8 +258,7 @@ xfs_perag_alloc(
 
 out_buf_cache_destroy:
 	xfs_buf_cache_destroy(&pag->pag_bcache);
-out_defer_drain_free:
-	xfs_defer_drain_free(&pag->pag_intents_drain);
+out_free_perag:
 	kfree(pag);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 8271cb72c88387..45f8de06cdbc8a 100644
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
index 927e72c0882b88..6737f009dd38ca 100644
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
index d2c61dd1f43e44..ebefbba7d98cc2 100644
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
index 28095ed490fbf6..e8b5e73bab60d3 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -513,7 +513,7 @@ xchk_perag_drain_and_lock(
 		 * Obviously, this should be slanted against scrub and in favor
 		 * of runtime threads.
 		 */
-		if (!xfs_perag_intent_busy(sa->pag))
+		if (!xfs_group_intent_busy(pag_group(sa->pag)))
 			return 0;
 
 		if (sa->agf_bp) {
@@ -528,7 +528,7 @@ xchk_perag_drain_and_lock(
 
 		if (!(sc->flags & XCHK_FSGATES_DRAIN))
 			return -ECHRNG;
-		error = xfs_perag_intent_drain(sa->pag);
+		error = xfs_group_intent_drain(pag_group(sa->pag));
 		if (error == -ERESTARTSYS)
 			error = -EINTR;
 	} while (!error);
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 3f280971b498b8..a72d08947d6d10 100644
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
+	xfs_group_intent_hold(pag_group(pag));
 	return pag;
 }
 
@@ -141,7 +143,7 @@ void
 xfs_perag_intent_put(
 	struct xfs_perag	*pag)
 {
-	xfs_perag_intent_rele(pag);
+	xfs_group_intent_rele(pag_group(pag));
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
index fd597a410b0298..29e8be9b6829d9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4684,35 +4684,39 @@ TRACE_EVENT(xfs_force_shutdown,
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
+		__entry->index = xg->xg_gno;
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
 

