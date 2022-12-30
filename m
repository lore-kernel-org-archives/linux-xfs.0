Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43716C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbiL3Whj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3Whi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:37:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9B018692
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:37:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9014361C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C6DC433EF;
        Fri, 30 Dec 2022 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439856;
        bh=qR1WQSqswEBxF44V9mTo+M309oURYEv4fRKLpPU+eXM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GSp8DJ6k03JkQncDrjzyOC4ZF1kR7Lnq/v8vig+8k6EQD4U8Uo0p/ORXPoLWA1c1R
         jcc69oiYlc5MzYBlsul2LMmTW2IP8L/58nfzc+A6a7JbUxF9/m4/5djKrNSMTRc7RO
         7CLAm472lALeKsn5nI9TTs5ARERjvyjlUdOvnHMjBqf6Skm82y6Kifv3tlMt9iZX12
         DetppGe+YtaRWtTIO3Q99pKK8mPxPz3OaifSQ9Ny3ePPyTXwdzinClt2ThlFFGCfb2
         dhD8hsEpfZks02dj6yXJ+2wxQnOwv9cMErOetXwceHfVHaDO3258GaAVxuPRJ1NIis
         hbpxBcX98leFw==
Subject: [PATCH 4/5] xfs: minimize overhead of drain wakeups by using jump
 labels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:08 -0800
Message-ID: <167243826808.683691.17908981757349425559.stgit@magnolia>
In-Reply-To: <167243826744.683691.2061427880010614570.stgit@magnolia>
References: <167243826744.683691.2061427880010614570.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

To reduce the runtime overhead even further when online fsck isn't
running, use a static branch key to decide if we call wake_up on the
drain.  For compilers that support jump labels, the call to wake_up is
replaced by a nop sled when nobody is waiting for intents to drain.

From my initial microbenchmarking, every transition of the static key
between the on and off states takes about 22000ns to complete; this is
paid entirely by the xfs_scrub process.  When the static key is off
(which it should be when fsck isn't running), the nop sled adds an
overhead of approximately 0.36ns to runtime code.

For the few compilers that don't support jump labels, runtime code pays
the cost of calling wake_up on an empty waitqueue, which was observed to
be about 30ns.  However, most architectures that have sufficient memory
and CPU capacity to run XFS also support jump labels, so this is not
much of a worry.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig            |    1 +
 fs/xfs/scrub/agheader.c   |    9 +++++++++
 fs/xfs/scrub/alloc.c      |    3 +++
 fs/xfs/scrub/bmap.c       |    3 +++
 fs/xfs/scrub/common.c     |   24 ++++++++++++++++++++++++
 fs/xfs/scrub/common.h     |   15 +++++++++++++++
 fs/xfs/scrub/fscounters.c |    7 +++++++
 fs/xfs/scrub/ialloc.c     |    2 ++
 fs/xfs/scrub/inode.c      |    3 +++
 fs/xfs/scrub/quota.c      |    3 +++
 fs/xfs/scrub/refcount.c   |    2 ++
 fs/xfs/scrub/rmap.c       |    3 +++
 fs/xfs/scrub/scrub.c      |   25 +++++++++++++++++++++----
 fs/xfs/scrub/scrub.h      |    5 ++++-
 fs/xfs/scrub/trace.h      |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_drain.c        |   27 ++++++++++++++++++++++++++-
 fs/xfs/xfs_drain.h        |    3 +++
 17 files changed, 162 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index ab24e683b440..05bc865142b8 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -95,6 +95,7 @@ config XFS_RT
 
 config XFS_DRAIN_INTENTS
 	bool
+	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
 
 config XFS_ONLINE_SCRUB
 	bool "XFS online metadata check support"
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 4dd52b15f09c..3dd9151a20ad 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -18,6 +18,15 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 
+int
+xchk_setup_agheader(
+	struct xfs_scrub	*sc)
+{
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+	return xchk_setup_fs(sc);
+}
+
 /* Superblock */
 
 /* Cross-reference with the other btrees. */
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 3b38f4e2a537..d0509219722f 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -24,6 +24,9 @@ int
 xchk_setup_ag_allocbt(
 	struct xfs_scrub	*sc)
 {
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
 	return xchk_setup_ag_btree(sc, false);
 }
 
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index d50d0eab196a..5c4b25585b8c 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -31,6 +31,9 @@ xchk_setup_inode_bmap(
 {
 	int			error;
 
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
 	error = xchk_get_inode(sc);
 	if (error)
 		goto out;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 453d8c3f2370..2c8ce015f3a9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -479,6 +479,8 @@ xchk_perag_lock(
 			sa->agi_bp = NULL;
 		}
 
+		if (!(sc->flags & XCHK_FSHOOKS_DRAIN))
+			return -EDEADLOCK;
 		error = xfs_perag_drain_intents(sa->pag);
 		if (error == -ERESTARTSYS)
 			error = -EINTR;
@@ -992,3 +994,25 @@ xchk_start_reaping(
 	}
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
+
+/*
+ * Enable filesystem hooks (i.e. runtime code patching) before starting a scrub
+ * operation.  Callers must not hold any locks that intersect with the CPU
+ * hotplug lock (e.g. writeback locks) because code patching must halt the CPUs
+ * to change kernel code.
+ */
+void
+xchk_fshooks_enable(
+	struct xfs_scrub	*sc,
+	unsigned int		scrub_fshooks)
+{
+	ASSERT(!(scrub_fshooks & ~XCHK_FSHOOKS_ALL));
+	ASSERT(!(sc->flags & scrub_fshooks));
+
+	trace_xchk_fshooks_enable(sc, scrub_fshooks);
+
+	if (scrub_fshooks & XCHK_FSHOOKS_DRAIN)
+		xfs_drain_wait_enable();
+
+	sc->flags |= scrub_fshooks;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b73648d81d23..4de5677390a4 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -72,6 +72,7 @@ bool xchk_should_check_xref(struct xfs_scrub *sc, int *error,
 			   struct xfs_btree_cur **curpp);
 
 /* Setup functions */
+int xchk_setup_agheader(struct xfs_scrub *sc);
 int xchk_setup_fs(struct xfs_scrub *sc);
 int xchk_setup_ag_allocbt(struct xfs_scrub *sc);
 int xchk_setup_ag_iallocbt(struct xfs_scrub *sc);
@@ -151,4 +152,18 @@ int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
 void xchk_stop_reaping(struct xfs_scrub *sc);
 void xchk_start_reaping(struct xfs_scrub *sc);
 
+/*
+ * Setting up a hook to wait for intents to drain is costly -- we have to take
+ * the CPU hotplug lock and force an i-cache flush on all CPUs once to set it
+ * up, and again to tear it down.  These costs add up quickly, so we only want
+ * to enable the drain waiter if the drain actually detected a conflict with
+ * running intent chains.
+ */
+static inline bool xchk_need_fshook_drain(struct xfs_scrub *sc)
+{
+	return sc->flags & XCHK_TRY_HARDER;
+}
+
+void xchk_fshooks_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 4777e7b89fdc..63755ba4fc0e 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -128,6 +128,13 @@ xchk_setup_fscounters(
 	struct xchk_fscounters	*fsc;
 	int			error;
 
+	/*
+	 * If the AGF doesn't track btreeblks, we have to lock the AGF to count
+	 * btree block usage by walking the actual btrees.
+	 */
+	if (!xfs_has_lazysbcount(sc->mp))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
 	sc->buf = kzalloc(sizeof(struct xchk_fscounters), XCHK_GFP_FLAGS);
 	if (!sc->buf)
 		return -ENOMEM;
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index e312be7cd375..fd5bc289de4c 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -32,6 +32,8 @@ int
 xchk_setup_ag_iallocbt(
 	struct xfs_scrub	*sc)
 {
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
 	return xchk_setup_ag_btree(sc, sc->flags & XCHK_TRY_HARDER);
 }
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 7a2f38e5202c..8c972ee15a30 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -32,6 +32,9 @@ xchk_setup_inode(
 {
 	int			error;
 
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
 	/*
 	 * Try to get the inode.  If the verifiers fail, we try again
 	 * in raw mode.
diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 9eeac8565394..7b21e1012eff 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -53,6 +53,9 @@ xchk_setup_quota(
 	if (!xfs_this_quota_on(sc->mp, dqtype))
 		return -ENOENT;
 
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
 	error = xchk_setup_fs(sc);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 080487f99e5f..9423aad28511 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -27,6 +27,8 @@ int
 xchk_setup_ag_refcountbt(
 	struct xfs_scrub	*sc)
 {
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
 	return xchk_setup_ag_btree(sc, false);
 }
 
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 229826b2e1c0..afc4f840b6bc 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -24,6 +24,9 @@ int
 xchk_setup_ag_rmapbt(
 	struct xfs_scrub	*sc)
 {
+	if (xchk_need_fshook_drain(sc))
+		xchk_fshooks_enable(sc, XCHK_FSHOOKS_DRAIN);
+
 	return xchk_setup_ag_btree(sc, false);
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 50db13c5f626..8f8a4eb758ea 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -145,6 +145,21 @@ xchk_probe(
 
 /* Scrub setup and teardown */
 
+static inline void
+xchk_fshooks_disable(
+	struct xfs_scrub	*sc)
+{
+	if (!(sc->flags & XCHK_FSHOOKS_ALL))
+		return;
+
+	trace_xchk_fshooks_disable(sc, sc->flags & XCHK_FSHOOKS_ALL);
+
+	if (sc->flags & XCHK_FSHOOKS_DRAIN)
+		xfs_drain_wait_disable();
+
+	sc->flags &= ~XCHK_FSHOOKS_ALL;
+}
+
 /* Free all the resources and finish the transactions. */
 STATIC int
 xchk_teardown(
@@ -177,6 +192,8 @@ xchk_teardown(
 		kvfree(sc->buf);
 		sc->buf = NULL;
 	}
+
+	xchk_fshooks_disable(sc);
 	return error;
 }
 
@@ -191,25 +208,25 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 	},
 	[XFS_SCRUB_TYPE_SB] = {		/* superblock */
 		.type	= ST_PERAG,
-		.setup	= xchk_setup_fs,
+		.setup	= xchk_setup_agheader,
 		.scrub	= xchk_superblock,
 		.repair	= xrep_superblock,
 	},
 	[XFS_SCRUB_TYPE_AGF] = {	/* agf */
 		.type	= ST_PERAG,
-		.setup	= xchk_setup_fs,
+		.setup	= xchk_setup_agheader,
 		.scrub	= xchk_agf,
 		.repair	= xrep_agf,
 	},
 	[XFS_SCRUB_TYPE_AGFL]= {	/* agfl */
 		.type	= ST_PERAG,
-		.setup	= xchk_setup_fs,
+		.setup	= xchk_setup_agheader,
 		.scrub	= xchk_agfl,
 		.repair	= xrep_agfl,
 	},
 	[XFS_SCRUB_TYPE_AGI] = {	/* agi */
 		.type	= ST_PERAG,
-		.setup	= xchk_setup_fs,
+		.setup	= xchk_setup_agheader,
 		.scrub	= xchk_agi,
 		.repair	= xrep_agi,
 	},
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b4d391b4c938..4ff4b19bee3d 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -96,9 +96,12 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
-#define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
+#define XCHK_REAPING_DISABLED	(1 << 1)  /* background block reaping paused */
+#define XCHK_FSHOOKS_DRAIN	(1 << 2)  /* defer ops draining enabled */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
+#define XCHK_FSHOOKS_ALL	(XCHK_FSHOOKS_DRAIN)
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 403c0e62257e..034b80371da5 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -96,6 +96,12 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 	{ XFS_SCRUB_OFLAG_WARNING,		"warning" }, \
 	{ XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED,	"norepair" }
 
+#define XFS_SCRUB_STATE_STRINGS \
+	{ XCHK_TRY_HARDER,			"try_harder" }, \
+	{ XCHK_REAPING_DISABLED,		"reaping_disabled" }, \
+	{ XCHK_FSHOOKS_DRAIN,			"fshooks_drain" }, \
+	{ XREP_ALREADY_FIXED,			"already_fixed" }
+
 DECLARE_EVENT_CLASS(xchk_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),
@@ -142,6 +148,33 @@ DEFINE_SCRUB_EVENT(xchk_deadlock_retry);
 DEFINE_SCRUB_EVENT(xrep_attempt);
 DEFINE_SCRUB_EVENT(xrep_done);
 
+DECLARE_EVENT_CLASS(xchk_fshook_class,
+	TP_PROTO(struct xfs_scrub *sc, unsigned int fshooks),
+	TP_ARGS(sc, fshooks),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, type)
+		__field(unsigned int, fshooks)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->type = sc->sm->sm_type;
+		__entry->fshooks = fshooks;
+	),
+	TP_printk("dev %d:%d type %s fshooks '%s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XFS_SCRUB_TYPE_STRINGS),
+		  __print_flags(__entry->fshooks, "|", XFS_SCRUB_STATE_STRINGS))
+)
+
+#define DEFINE_SCRUB_FSHOOK_EVENT(name) \
+DEFINE_EVENT(xchk_fshook_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, unsigned int fshooks), \
+	TP_ARGS(sc, fshooks))
+
+DEFINE_SCRUB_FSHOOK_EVENT(xchk_fshooks_enable);
+DEFINE_SCRUB_FSHOOK_EVENT(xchk_fshooks_disable);
+
 TRACE_EVENT(xchk_op_error,
 	TP_PROTO(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		 xfs_agblock_t bno, int error, void *ret_ip),
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index e8fced914f88..9b463e1183f6 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -12,6 +12,31 @@
 #include "xfs_ag.h"
 #include "xfs_trace.h"
 
+/*
+ * Use a static key here to reduce the overhead of xfs_drain_drop.  If the
+ * compiler supports jump labels, the static branch will be replaced by a nop
+ * sled when there are no xfs_drain_wait callers.  Online fsck is currently
+ * the only caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+static DEFINE_STATIC_KEY_FALSE(xfs_drain_waiter_hook);
+
+void
+xfs_drain_wait_disable(void)
+{
+	static_branch_dec(&xfs_drain_waiter_hook);
+}
+
+void
+xfs_drain_wait_enable(void)
+{
+	static_branch_inc(&xfs_drain_waiter_hook);
+}
+
 void
 xfs_drain_init(
 	struct xfs_drain	*dr)
@@ -36,7 +61,7 @@ static inline void xfs_drain_bump(struct xfs_drain *dr)
 static inline void xfs_drain_drop(struct xfs_drain *dr)
 {
 	if (atomic_dec_and_test(&dr->dr_count) &&
-	    wq_has_sleeper(&dr->dr_waiters))
+	    static_branch_unlikely(&xfs_drain_waiter_hook))
 		wake_up(&dr->dr_waiters);
 }
 
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index f01a2b5c7337..a980df6d3508 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -25,6 +25,9 @@ struct xfs_drain {
 void xfs_drain_init(struct xfs_drain *dr);
 void xfs_drain_free(struct xfs_drain *dr);
 
+void xfs_drain_wait_disable(void);
+void xfs_drain_wait_enable(void);
+
 /*
  * Deferred Work Intent Drains
  * ===========================

