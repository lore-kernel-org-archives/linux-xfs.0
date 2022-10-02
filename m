Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4B9C433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJBS3i (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJBS3h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:29:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B49310
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:29:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E23560EFE
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD773C433D6;
        Sun,  2 Oct 2022 18:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735372;
        bh=5/hBKJgG++qdEaXnXq+WVHeW0n3v7GDztlreXwGtBho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Tr++sCRiUicofRK+x8YgfH+EMjWthBvJiFMWEYNrmhS8/ZI79ELnua+Ab6A8WNAN5
         gZVlCvYdfY9gybJod4qoEFyZme37Uyn04a7rlDAQrRP+O0nfl8g2TcK230RLOcD5LL
         YmxcrMMevOReX8WCZfZWTbqKzXmW/J6fVaquwvbyap2sTalgCbwntB+S+rsT/+U7Fu
         hz8jy93IhyEv3NOPHDXFTMzAczZ1AJWTI2zsxEG6bEsKV47GFKDRDjwvXBfFLo+fH6
         2h4YQbXzJ82UUUL983Lx4i/X7yh6RZk4yaRZyAgjieeRFJKUpnB3cxZXyXmRMcU2h1
         3emxIcJAX5d3A==
Subject: [PATCH 2/5] xfs: use per-cpu counters to implement intent draining
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:19:59 -0700
Message-ID: <166473479905.1083534.13591957706795877748.stgit@magnolia>
In-Reply-To: <166473479864.1083534.16821762305468128245.stgit@magnolia>
References: <166473479864.1083534.16821762305468128245.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the intent draining code uses a per-AG atomic counter to keep
track of how many writer threads are currently or going to start
processing log intent items for that AG.  This isn't particularly
efficient, since every counter update will dirty the cacheline, and the
only code that cares about precise counter values is online scrub, which
shouldn't be running all that often.

Therefore, substitute the atomic_t for a per-cpu counter with a high
batch limit to avoid pingponging cache lines as long as possible.  While
updates to per-cpu counters are slower in the single-thread case (on the
author's system, 12ns vs. 8ns), this quickly reverses itself if there
are a lot of CPUs queuing intent items.

Because percpu counter summation is slow, this change shifts most of the
performance impact to code that calls xfs_drain_wait, which means that
online fsck runs a little bit slower to minimize the overhead of regular
runtime code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    4 +++-
 fs/xfs/xfs_mount.c     |   10 ++++++----
 fs/xfs/xfs_mount.h     |   19 ++++++++++++++-----
 fs/xfs/xfs_trace.h     |    2 +-
 4 files changed, 24 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 27ba30f8f64b..2da2a366395c 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -314,7 +314,9 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pag_state_lock);
 		INIT_DELAYED_WORK(&pag->pag_blockgc_work, xfs_blockgc_worker);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-		xfs_drain_init(&pag->pag_intents);
+		error = xfs_drain_init(&pag->pag_intents);
+		if (error)
+			goto out_remove_pag;
 		init_waitqueue_head(&pag->pagb_wait);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 6c84c6547a0b..2effc1647ce1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1390,15 +1390,14 @@ xfs_mod_delalloc(
 /* Increase the pending intent count. */
 static inline void xfs_drain_bump(struct xfs_drain *dr)
 {
-	atomic_inc(&dr->dr_count);
+	percpu_counter_add_batch(&dr->dr_count, 1, XFS_DRAIN_BATCH);
 }
 
 /* Decrease the pending intent count, and wake any waiters, if appropriate. */
 static inline void xfs_drain_drop(struct xfs_drain *dr)
 {
-	if (atomic_dec_and_test(&dr->dr_count) &&
-	    wq_has_sleeper(&dr->dr_waiters))
-		wake_up(&dr->dr_waiters);
+	percpu_counter_add_batch(&dr->dr_count, -1, XFS_DRAIN_BATCH);
+	wake_up(&dr->dr_waiters);
 }
 
 /*
@@ -1409,6 +1408,9 @@ static inline void xfs_drain_drop(struct xfs_drain *dr)
  */
 static inline int xfs_drain_wait(struct xfs_drain *dr)
 {
+	if (!xfs_drain_busy(dr))
+		return 0;
+
 	return wait_event_killable(dr->dr_waiters, !xfs_drain_busy(dr));
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ddf438701022..3e4921304442 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -64,7 +64,7 @@ struct xfs_error_cfg {
  */
 struct xfs_drain {
 	/* Number of items pending in some part of the filesystem. */
-	atomic_t		dr_count;
+	struct percpu_counter	dr_count;
 
 	/* Queue to wait for dri_count to go to zero */
 	struct wait_queue_head	dr_waiters;
@@ -76,21 +76,30 @@ bool xfs_ag_intents_busy(struct xfs_perag *pag);
 void xfs_fs_bump_intents(struct xfs_mount *mp, xfs_fsblock_t fsb);
 void xfs_fs_drop_intents(struct xfs_mount *mp, xfs_fsblock_t fsb);
 
+/*
+ * Use a large batch value for the drain counter so that writer threads
+ * can queue a large number of log intents before having to update the main
+ * counter.
+ */
+#define XFS_DRAIN_BATCH		(1024)
+
 /* Are there work items pending? */
 static inline bool xfs_drain_busy(struct xfs_drain *dr)
 {
-	return atomic_read(&dr->dr_count) > 0;
+	return __percpu_counter_compare(&dr->dr_count, 0, XFS_DRAIN_BATCH) > 0;
 }
 
-static inline void xfs_drain_init(struct xfs_drain *dr)
+static inline int xfs_drain_init(struct xfs_drain *dr)
 {
-	atomic_set(&dr->dr_count, 0);
 	init_waitqueue_head(&dr->dr_waiters);
+	return percpu_counter_init(&dr->dr_count, 0, GFP_KERNEL);
 }
 
 static inline void xfs_drain_free(struct xfs_drain *dr)
 {
 	ASSERT(!xfs_drain_busy(dr));
+
+	percpu_counter_destroy(&dr->dr_count);
 }
 #else
 struct xfs_drain { /* empty */ };
@@ -104,7 +113,7 @@ static inline void
 xfs_fs_drop_intents(struct xfs_mount *mp, xfs_fsblock_t fsb)
 {
 }
-# define xfs_drain_init(dr)	((void)0)
+# define xfs_drain_init(dr)	(0)
 # define xfs_drain_free(dr)	((void)0)
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fae3b0fe0971..c584ff52bb40 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4259,7 +4259,7 @@ DECLARE_EVENT_CLASS(xfs_perag_intents_class,
 	TP_fast_assign(
 		__entry->dev = pag->pag_mount->m_super->s_dev;
 		__entry->agno = pag->pag_agno;
-		__entry->nr_intents = atomic_read(&pag->pag_intents.dr_count);
+		__entry->nr_intents = percpu_counter_sum(&pag->pag_intents.dr_count);
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d agno 0x%x intents %ld caller %pS",

