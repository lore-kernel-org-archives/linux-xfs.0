Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34DEDC4338F
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1084261078
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Aug 2021 02:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238152AbhHECHh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 22:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238146AbhHECHh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 22:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB57F6105A;
        Thu,  5 Aug 2021 02:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628129243;
        bh=aRvWrr/MbXUb87Jzdcib/RI2r8kJ9riM9euaRdQyYaY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=t10vz0CsPcKUg6DAJqi2nZvXEqzj9GHFxpK5K4cQhLPHJV4f9gF+BvWbllHh/SzGs
         UGBhWMFxwjGC9UBsuXGLMgS4BqXrKj7nIb+zmy/Tl8ABXBDF1ExrleKDogS/EXqOdj
         m9X0AIIbtFBojpgE6qTm8+YLkwgW3vDyBmN3kVxijIqCmrrp5mLE3vFqDH672VAs/W
         1R83QqP1tD5ofXLrQ+b+lZx48BPiHHcv4lfofAYVhWfviRi7XgKp0RbjxtvyZoGHix
         OVa6A9JhncpMTlRf1jna71k/orAQCqCgoDi4rUDZ9O/SsZcZpzY3k47CNJrXUJxf2a
         EVIyNo7rLgunA==
Subject: [PATCH 11/14] xfs: don't run speculative preallocation gc when fs is
 frozen
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Wed, 04 Aug 2021 19:07:23 -0700
Message-ID: <162812924340.2589546.13912967141285396653.stgit@magnolia>
In-Reply-To: <162812918259.2589546.16599271324044986858.stgit@magnolia>
References: <162812918259.2589546.16599271324044986858.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we have the infrastructure to switch background workers on and
off at will, fix the block gc worker code so that we don't actually run
the worker when the filesystem is frozen, same as we do for deferred
inactivation.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    9 +++++----
 fs/xfs/xfs_icache.c   |   27 +++++++++++++++++++++++----
 fs/xfs/xfs_mount.c    |    1 +
 fs/xfs/xfs_mount.h    |    8 ++++++++
 fs/xfs/xfs_super.c    |    9 ++++++---
 fs/xfs/xfs_trace.h    |    6 +++++-
 6 files changed, 48 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 06b697f72f23..e86854171b0c 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -893,11 +893,12 @@ xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
 	/*
-	 * Readonly filesystems do not perform inactivation, so there's no
-	 * need to restart the worker.
+	 * Readonly filesystems do not perform inactivation or speculative
+	 * preallocation, so there's no need to restart the workers.
 	 */
-	if (!(sc->mp->m_flags & XFS_MOUNT_RDONLY))
+	if (!(sc->mp->m_flags & XFS_MOUNT_RDONLY)) {
 		xfs_inodegc_start(sc->mp);
-	xfs_blockgc_start(sc->mp);
+		xfs_blockgc_start(sc->mp);
+	}
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f2d12405dd87..5ee1a084d36d 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -211,6 +211,11 @@ static inline void
 xfs_blockgc_queue(
 	struct xfs_perag	*pag)
 {
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	if (!xfs_is_blockgc_enabled(mp))
+		return;
+
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
 		queue_delayed_work(pag->pag_mount->m_blockgc_wq,
@@ -1366,8 +1371,12 @@ xfs_blockgc_stop(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
-	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
+	if (!xfs_clear_blockgc_enabled(mp))
+		return;
+
+	for_each_perag(mp, agno, pag)
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
+	trace_xfs_blockgc_stop(mp, __return_address);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1378,6 +1387,10 @@ xfs_blockgc_start(
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		agno;
 
+	if (xfs_set_blockgc_enabled(mp))
+		return;
+
+	trace_xfs_blockgc_start(mp, __return_address);
 	for_each_perag_tag(mp, agno, pag, XFS_ICI_BLOCKGC_TAG)
 		xfs_blockgc_queue(pag);
 }
@@ -1435,6 +1448,13 @@ xfs_blockgc_scan_inode(
 	unsigned int		lockflags = 0;
 	int			error;
 
+	/*
+	 * Speculative preallocation gc isn't supposed to run when the fs is
+	 * frozen because we don't want kernel threads to block on transaction
+	 * allocation.
+	 */
+	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);
+
 	error = xfs_inode_free_eofblocks(ip, icw, &lockflags);
 	if (error)
 		goto unlock;
@@ -1457,13 +1477,12 @@ xfs_blockgc_worker(
 	struct xfs_mount	*mp = pag->pag_mount;
 	int			error;
 
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
+	trace_xfs_blockgc_worker(mp, __return_address);
+
 	error = xfs_icwalk_ag(pag, XFS_ICWALK_BLOCKGC, NULL);
 	if (error)
 		xfs_info(mp, "AG %u preallocation gc worker failed, err=%d",
 				pag->pag_agno, error);
-	sb_end_write(mp->m_super);
 	xfs_blockgc_queue(pag);
 }
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ed1e7e3dce7e..b81f2fc734bd 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -789,6 +789,7 @@ xfs_mountfs(
 
 	/* Enable background inode inactivation workers. */
 	xfs_inodegc_start(mp);
+	xfs_blockgc_start(mp);
 
 	/*
 	 * Get and sanity-check the root inode.
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 1061ac985c18..797b8068dfe6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -280,6 +280,13 @@ typedef struct xfs_mount {
  */
 #define XFS_STATE_INODEGC_ENABLED	0
 
+/*
+ * If set, background speculative prealloc gc worker threads will be scheduled
+ * to process queued blockgc work.  If not, inodes retain their preallocations
+ * until explicitly deleted.
+ */
+#define XFS_STATE_BLOCKGC_ENABLED	1
+
 #define __XFS_IS_STATE(name, NAME) \
 static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
 { \
@@ -295,6 +302,7 @@ static inline bool xfs_set_ ## name (struct xfs_mount *mp) \
 }
 
 __XFS_IS_STATE(inodegc_enabled, INODEGC_ENABLED)
+__XFS_IS_STATE(blockgc_enabled, BLOCKGC_ENABLED)
 
 /*
  * Max and min values for mount-option defined I/O
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 2ac040c95703..2bab18ed73b9 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -912,14 +912,17 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
-	xfs_blockgc_start(mp);
 
 	/*
 	 * Don't reactivate the inodegc worker on a readonly filesystem because
-	 * inodes are sent directly to reclaim.
+	 * inodes are sent directly to reclaim.  Don't reactivate the blockgc
+	 * worker because there are no speculative preallocations on a readonly
+	 * filesystem.
 	 */
-	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
+		xfs_blockgc_start(mp);
 		xfs_inodegc_start(mp);
+	}
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bd8abb50b33a..1b1c288610af 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -158,7 +158,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
 #define XFS_STATE_FLAGS \
-	{ (1UL << XFS_STATE_INODEGC_ENABLED),		"inodegc" }
+	{ (1UL << XFS_STATE_INODEGC_ENABLED),		"inodegc" }, \
+	{ (1UL << XFS_STATE_BLOCKGC_ENABLED),		"blockgc" }
 
 DECLARE_EVENT_CLASS(xfs_fs_class,
 	TP_PROTO(struct xfs_mount *mp, void *caller_ip),
@@ -198,6 +199,9 @@ DEFINE_FS_EVENT(xfs_inodegc_worker);
 DEFINE_FS_EVENT(xfs_inodegc_queue);
 DEFINE_FS_EVENT(xfs_inodegc_throttle);
 DEFINE_FS_EVENT(xfs_fs_sync_fs);
+DEFINE_FS_EVENT(xfs_blockgc_start);
+DEFINE_FS_EVENT(xfs_blockgc_stop);
+DEFINE_FS_EVENT(xfs_blockgc_worker);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),

