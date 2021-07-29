Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720D5C4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5467460F4B
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Jul 2021 18:44:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhG2SoQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Jul 2021 14:44:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229761AbhG2SoN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 29 Jul 2021 14:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BFB160249;
        Thu, 29 Jul 2021 18:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627584250;
        bh=FskPfDZc2EVxkcHAeGYlCW3JcDxpGWj/zXavJrH4uT4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qNOnoO2juHdl+1GQI6GXEtIHU80OAq8vLzCqG4rL9f7J314gYn6iKuSDmYc+yMmOd
         +RfuhPEruH0NenKY2Jc56oLwvkALWn/e+1J+F3pBeqVPTVq3e83g/u3rrpX0t/xMaq
         Th8pfY6ESVwbeTWBZlJ6YddyjtlvgJIWbmmjPhEO21lB93RPqDpGouQRGlRnoT8H3b
         XEkp6p5Elu4HLXkjheREz8+LygJ1g5uPgVn5kjx7Fz0BFmdUunhrmHZX3oTj6B4IWD
         lol5i5SenPj+zV3dVTLZGq38KeGu5rTkVj3ZHrRSXMw///9XJFFkSM8Gc9ptTclyzT
         rtCFdCvWYZ/Tg==
Subject: [PATCH 03/20] xfs: defer inode inactivation to a workqueue
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Thu, 29 Jul 2021 11:44:10 -0700
Message-ID: <162758425012.332903.3784529658243630550.stgit@magnolia>
In-Reply-To: <162758423315.332903.16799817941903734904.stgit@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
defer the inactivation phase to a separate workqueue.  With this change,
we can speed up directory tree deletions by reducing the duration of
unlink() calls to the directory and unlinked list updates.

By moving the inactivation work to the background, we can reduce the
total cost of deleting a lot of files by performing the file deletions
in disk order instead of directory entry order, which can be arbitrary.

We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
The first flag helps our worker find inodes needing inactivation, and
the second flag marks inodes that are in the process of being
inactivated.  A concurrent xfs_iget on the inode can still resurrect the
inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).

Unfortunately, deferring the inactivation has one huge downside --
eventual consistency.  Since all the freeing is deferred to a worker
thread, one can rm a file but the space doesn't come back immediately.
This can cause some odd side effects with quota accounting and statfs,
so we flush inactivation work during syncfs in order to maintain the
existing behaviors, at least for callers that unlink() and sync().

For this patch we'll set the delay to zero to mimic the old timing as
much as possible; in the next patch we'll play with different delay
settings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    3 
 fs/xfs/scrub/common.c             |    7 +
 fs/xfs/xfs_icache.c               |  306 ++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_icache.h               |    5 +
 fs/xfs/xfs_inode.h                |   19 ++
 fs/xfs/xfs_log_recover.c          |    7 +
 fs/xfs/xfs_mount.c                |   26 +++
 fs/xfs/xfs_mount.h                |   21 +++
 fs/xfs/xfs_super.c                |   53 ++++++
 fs/xfs/xfs_trace.h                |   68 ++++++++
 10 files changed, 488 insertions(+), 27 deletions(-)


diff --git a/Documentation/admin-guide/xfs.rst b/Documentation/admin-guide/xfs.rst
index 8de008c0c5ad..f9b109bfc6a6 100644
--- a/Documentation/admin-guide/xfs.rst
+++ b/Documentation/admin-guide/xfs.rst
@@ -524,7 +524,8 @@ and the short name of the data device.  They all can be found in:
                   mount time quotacheck.
   xfs-gc          Background garbage collection of disk space that have been
                   speculatively allocated beyond EOF or for staging copy on
-                  write operations.
+                  write operations; and files that are no longer linked into
+                  the directory tree.
 ================  ===========
 
 For example, the knobs for the quotacheck workqueue for /dev/nvme0n1 would be
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 8558ca05e11d..06b697f72f23 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -884,6 +884,7 @@ xchk_stop_reaping(
 {
 	sc->flags |= XCHK_REAPING_DISABLED;
 	xfs_blockgc_stop(sc->mp);
+	xfs_inodegc_stop(sc->mp);
 }
 
 /* Restart background reaping of resources. */
@@ -891,6 +892,12 @@ void
 xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
+	/*
+	 * Readonly filesystems do not perform inactivation, so there's no
+	 * need to restart the worker.
+	 */
+	if (!(sc->mp->m_flags & XFS_MOUNT_RDONLY))
+		xfs_inodegc_start(sc->mp);
 	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 709507cc83ae..e97404d2f63a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -32,6 +32,8 @@
 #define XFS_ICI_RECLAIM_TAG	0
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCKGC_TAG	1
+/* Inode can be inactivated. */
+#define XFS_ICI_INODEGC_TAG	2
 
 /*
  * The goal for walking incore inodes.  These can correspond with incore inode
@@ -41,6 +43,7 @@ enum xfs_icwalk_goal {
 	/* Goals directly associated with tagged inodes. */
 	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
 	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
+	XFS_ICWALK_INODEGC	= XFS_ICI_INODEGC_TAG,
 };
 
 #define XFS_ICWALK_NULL_TAG	(-1U)
@@ -219,6 +222,26 @@ xfs_blockgc_queue(
 	rcu_read_unlock();
 }
 
+/*
+ * Queue a background inactivation worker if there are inodes that need to be
+ * inactivated and higher level xfs code hasn't disabled the background
+ * workers.
+ */
+static void
+xfs_inodegc_queue(
+	struct xfs_mount        *mp)
+{
+	if (!test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
+		trace_xfs_inodegc_queue(mp, 0);
+		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+	}
+	rcu_read_unlock();
+}
+
 /* Set a tag on both the AG incore inode tree and the AG radix tree. */
 static void
 xfs_perag_set_inode_tag(
@@ -253,6 +276,9 @@ xfs_perag_set_inode_tag(
 	case XFS_ICI_BLOCKGC_TAG:
 		xfs_blockgc_queue(pag);
 		break;
+	case XFS_ICI_INODEGC_TAG:
+		xfs_inodegc_queue(mp);
+		break;
 	}
 
 	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
@@ -329,28 +355,27 @@ xfs_inode_mark_reclaimable(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
-	bool			need_inactive = xfs_inode_needs_inactive(ip);
+	unsigned int		tag;
+	bool			need_inactive;
 
+	need_inactive = xfs_inode_needs_inactive(ip);
 	if (!need_inactive) {
 		/* Going straight to reclaim, so drop the dquots. */
 		xfs_qm_dqdetach(ip);
-	} else {
-		xfs_inactive(ip);
-	}
 
-	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
-		xfs_check_delalloc(ip, XFS_DATA_FORK);
-		xfs_check_delalloc(ip, XFS_COW_FORK);
-		ASSERT(0);
+		if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
+			xfs_check_delalloc(ip, XFS_DATA_FORK);
+			xfs_check_delalloc(ip, XFS_COW_FORK);
+			ASSERT(0);
+		}
 	}
 
 	XFS_STATS_INC(mp, vn_reclaim);
 
 	/*
-	 * We should never get here with one of the reclaim flags already set.
+	 * We should never get here with any of the reclaim flags already set.
 	 */
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
 
 	/*
 	 * We always use background reclaim here because even if the inode is
@@ -363,13 +388,30 @@ xfs_inode_mark_reclaimable(
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_RECLAIM_TAG);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	if (need_inactive) {
+		trace_xfs_inode_set_need_inactive(ip);
+		ip->i_flags |= XFS_NEED_INACTIVE;
+		tag = XFS_ICI_INODEGC_TAG;
+	} else {
+		trace_xfs_inode_set_reclaimable(ip);
+		ip->i_flags |= XFS_IRECLAIMABLE;
+		tag = XFS_ICI_RECLAIM_TAG;
+	}
+
+	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
 	xfs_perag_put(pag);
+
+	/*
+	 * Wait for the background inodegc worker if it's running so that the
+	 * frontend can't overwhelm the background workers with inodes and OOM
+	 * the machine.  We'll improve this with feedback from the rest of the
+	 * system in subsequent patches.
+	 */
+	if (need_inactive && flush_work(&mp->m_inodegc_work.work))
+		trace_xfs_inodegc_throttled(mp, __return_address);
 }
 
 static inline void
@@ -433,6 +475,7 @@ xfs_iget_recycle(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	unsigned int		tag;
 	int			error;
 
 	trace_xfs_iget_recycle(ip);
@@ -443,7 +486,16 @@ xfs_iget_recycle(
 	 * the inode.  We can't clear the radix tree tag yet as it requires
 	 * pag_ici_lock to be held exclusive.
 	 */
-	ip->i_flags |= XFS_IRECLAIM;
+	if (ip->i_flags & XFS_IRECLAIMABLE) {
+		tag = XFS_ICI_RECLAIM_TAG;
+		ip->i_flags |= XFS_IRECLAIM;
+	} else if (ip->i_flags & XFS_NEED_INACTIVE) {
+		tag = XFS_ICI_INODEGC_TAG;
+		ip->i_flags |= XFS_INACTIVATING;
+	} else {
+		ASSERT(0);
+		return -EINVAL;
+	}
 
 	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();
@@ -460,10 +512,10 @@ xfs_iget_recycle(
 		rcu_read_lock();
 		spin_lock(&ip->i_flags_lock);
 		wake = !!__xfs_iflags_test(ip, XFS_INEW);
-		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
+		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING);
 		if (wake)
 			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
-		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
+		ASSERT(ip->i_flags & (XFS_IRECLAIMABLE | XFS_NEED_INACTIVE));
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
 
@@ -481,8 +533,7 @@ xfs_iget_recycle(
 	 */
 	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
 	ip->i_flags |= XFS_INEW;
-	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_RECLAIM_TAG);
+	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
 	inode->i_state = I_NEW;
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -566,9 +617,15 @@ xfs_iget_cache_hit(
 	 *	     wait_on_inode to wait for these flags to be cleared
 	 *	     instead of polling for it.
 	 */
-	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM))
+	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING))
 		goto out_skip;
 
+	/* Unlinked inodes cannot be re-grabbed. */
+	if (VFS_I(ip)->i_nlink == 0 && (ip->i_flags & XFS_NEED_INACTIVE)) {
+		error = -ENOENT;
+		goto out_error;
+	}
+
 	/*
 	 * Check the inode free state is valid. This also detects lookup
 	 * racing with unlinks.
@@ -579,11 +636,11 @@ xfs_iget_cache_hit(
 
 	/* Skip inodes that have no vfs state. */
 	if ((flags & XFS_IGET_INCORE) &&
-	    (ip->i_flags & XFS_IRECLAIMABLE))
+	    (ip->i_flags & (XFS_IRECLAIMABLE | XFS_NEED_INACTIVE)))
 		goto out_skip;
 
 	/* The inode fits the selection criteria; process it. */
-	if (ip->i_flags & XFS_IRECLAIMABLE) {
+	if (ip->i_flags & (XFS_IRECLAIMABLE | XFS_NEED_INACTIVE)) {
 		/* Drops i_flags_lock and RCU read lock. */
 		error = xfs_iget_recycle(pag, ip);
 		if (error)
@@ -943,6 +1000,7 @@ xfs_reclaim_inode(
 
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 reclaim:
+	trace_xfs_inode_reclaiming(ip);
 
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
@@ -1420,6 +1478,8 @@ xfs_blockgc_start(
 
 /* Don't try to run block gc on an inode that's in any of these states. */
 #define XFS_BLOCKGC_NOGRAB_IFLAGS	(XFS_INEW | \
+					 XFS_NEED_INACTIVE | \
+					 XFS_INACTIVATING | \
 					 XFS_IRECLAIMABLE | \
 					 XFS_IRECLAIM)
 /*
@@ -1580,6 +1640,203 @@ xfs_blockgc_free_quota(
 			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), iwalk_flags);
 }
 
+/*
+ * Inode Inactivation and Reclaimation
+ * ===================================
+ *
+ * Sometimes, inodes need to have work done on them once the last program has
+ * closed the file.  Typically this means cleaning out any leftover speculative
+ * preallocations after EOF or in the CoW fork.  For inodes that have been
+ * totally unlinked, this means unmapping data/attr/cow blocks, removing the
+ * inode from the unlinked buckets, and marking it free in the inobt and inode
+ * table.
+ *
+ * This process can generate many metadata updates, which shows up as close()
+ * and unlink() calls that take a long time.  We defer all that work to a
+ * workqueue which means that we can batch a lot of work and do it in inode
+ * order for better performance.  Furthermore, we can control the workqueue,
+ * which means that we can avoid doing inactivation work at a bad time, such as
+ * when the fs is frozen.
+ *
+ * Deferred inactivation introduces new inode flag states (NEED_INACTIVE and
+ * INACTIVATING) and adds a new INODEGC radix tree tag for fast access.  We
+ * maintain separate perag counters for both types, and move counts as inodes
+ * wander the state machine, which now works as follows:
+ *
+ * If the inode needs inactivation, we:
+ *   - Set the NEED_INACTIVE inode flag
+ *   - Schedule background inode inactivation
+ *
+ * If the inode does not need inactivation, we:
+ *   - Set the IRECLAIMABLE inode flag
+ *   - Schedule background inode reclamation
+ *
+ * When it is time to inactivate the inode, we:
+ *   - Set the INACTIVATING inode flag
+ *   - Make all the on-disk updates
+ *   - Clear the inactive state and set the IRECLAIMABLE inode flag
+ *   - Schedule background inode reclamation
+ *
+ * When it is time to reclaim the inode, we:
+ *   - Set the IRECLAIM inode flag
+ *   - Reclaim the inode and RCU free it
+ *
+ * When these state transitions occur, the caller must have taken the per-AG
+ * incore inode tree lock and then the inode i_flags lock, in that order.
+ */
+
+/*
+ * Decide if the given @ip is eligible for inactivation, and grab it if so.
+ * Returns true if it's ready to go or false if we should just ignore it.
+ *
+ * Skip inodes that don't need inactivation or are being inactivated (or
+ * recycled) by another thread.  Inodes should not be tagged for inactivation
+ * while also in INEW or any reclaim state.
+ *
+ * Otherwise, mark this inode as being inactivated even if the fs is shut down
+ * because we need xfs_inodegc_inactivate to push this inode into the reclaim
+ * state.
+ */
+static bool
+xfs_inodegc_igrab(
+	struct xfs_inode	*ip)
+{
+	bool			ret = false;
+
+	ASSERT(rcu_read_lock_held());
+
+	/* Check for stale RCU freed inode */
+	spin_lock(&ip->i_flags_lock);
+	if (!ip->i_ino)
+		goto out_unlock_noent;
+
+	if ((ip->i_flags & XFS_NEED_INACTIVE) &&
+	    !(ip->i_flags & XFS_INACTIVATING)) {
+		ret = true;
+		ip->i_flags |= XFS_INACTIVATING;
+	}
+
+out_unlock_noent:
+	spin_unlock(&ip->i_flags_lock);
+	return ret;
+}
+
+/*
+ * Free all speculative preallocations and possibly even the inode itself.
+ * This is the last chance to make changes to an otherwise unreferenced file
+ * before incore reclamation happens.
+ */
+static void
+xfs_inodegc_inactivate(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	struct xfs_icwalk	*icw)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+
+	/*
+	 * Inactivation isn't supposed to run when the fs is frozen because
+	 * we don't want kernel threads to block on transaction allocation.
+	 */
+	ASSERT(mp->m_super->s_writers.frozen < SB_FREEZE_FS);
+
+	/*
+	 * Foreground threads that have hit ENOSPC or EDQUOT are allowed to
+	 * pass in a icw structure to look for inodes to inactivate
+	 * immediately to free some resources.  If this inode isn't a match,
+	 * put it back on the shelf and move on.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!xfs_icwalk_match(ip, icw)) {
+		ip->i_flags &= ~XFS_INACTIVATING;
+		spin_unlock(&ip->i_flags_lock);
+		return;
+	}
+	spin_unlock(&ip->i_flags_lock);
+
+	trace_xfs_inode_inactivating(ip);
+
+	xfs_inactive(ip);
+
+	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
+		xfs_check_delalloc(ip, XFS_DATA_FORK);
+		xfs_check_delalloc(ip, XFS_COW_FORK);
+		ASSERT(0);
+	}
+
+	/* Schedule the inactivated inode for reclaim. */
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	trace_xfs_inode_set_reclaimable(ip);
+	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
+	ip->i_flags |= XFS_IRECLAIMABLE;
+
+	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_INODEGC_TAG);
+	xfs_perag_set_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+}
+
+/* Inactivate inodes until we run out. */
+void
+xfs_inodegc_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_inodegc_work);
+
+	/*
+	 * Inactivation never returns error codes and never fails to push a
+	 * tagged inode to reclaim.  Loop until there there's nothing left.
+	 */
+	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG)) {
+		trace_xfs_inodegc_worker(mp, __return_address);
+		xfs_icwalk(mp, XFS_ICWALK_INODEGC, NULL);
+	}
+}
+
+/*
+ * Force all currently queued inode inactivation work to run immediately, and
+ * wait for the work to finish.
+ */
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	trace_xfs_inodegc_flush(mp, __return_address);
+	flush_delayed_work(&mp->m_inodegc_work);
+}
+
+/* Disable the inode inactivation background worker and wait for it to stop. */
+void
+xfs_inodegc_stop(
+	struct xfs_mount	*mp)
+{
+	if (!test_and_clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	cancel_delayed_work_sync(&mp->m_inodegc_work);
+	trace_xfs_inodegc_stop(mp, __return_address);
+}
+
+/*
+ * Enable the inode inactivation background worker and schedule deferred inode
+ * inactivation work if there is any.
+ */
+void
+xfs_inodegc_start(
+	struct xfs_mount	*mp)
+{
+	if (test_and_set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags))
+		return;
+
+	trace_xfs_inodegc_start(mp, __return_address);
+	xfs_inodegc_queue(mp);
+}
+
 /* XFS Inode Cache Walking Code */
 
 /*
@@ -1606,6 +1863,8 @@ xfs_icwalk_igrab(
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
 		return xfs_reclaim_igrab(ip, icw);
+	case XFS_ICWALK_INODEGC:
+		return xfs_inodegc_igrab(ip);
 	default:
 		return false;
 	}
@@ -1631,6 +1890,9 @@ xfs_icwalk_process_inode(
 	case XFS_ICWALK_RECLAIM:
 		xfs_reclaim_inode(ip, pag);
 		break;
+	case XFS_ICWALK_INODEGC:
+		xfs_inodegc_inactivate(ip, pag, icw);
+		break;
 	}
 	return error;
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d0062ebb3f7a..c1dfc909a5b0 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -74,4 +74,9 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
+void xfs_inodegc_worker(struct work_struct *work);
+void xfs_inodegc_flush(struct xfs_mount *mp);
+void xfs_inodegc_stop(struct xfs_mount *mp);
+void xfs_inodegc_start(struct xfs_mount *mp);
+
 #endif
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index e3137bbc7b14..fa5be0d071ad 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -240,6 +240,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
 #define XFS_IEOFBLOCKS		(1 << 9) /* has the preallocblocks tag set */
+#define XFS_NEED_INACTIVE	(1 << 10) /* see XFS_INACTIVATING below */
 /*
  * If this unlinked inode is in the middle of recovery, don't let drop_inode
  * truncate and free the inode.  This can happen if we iget the inode during
@@ -248,6 +249,21 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 #define XFS_IRECOVERY		(1 << 11)
 #define XFS_ICOWBLOCKS		(1 << 12)/* has the cowblocks tag set */
 
+/*
+ * If we need to update on-disk metadata before this IRECLAIMABLE inode can be
+ * freed, then NEED_INACTIVE will be set.  Once we start the updates, the
+ * INACTIVATING bit will be set to keep iget away from this inode.  After the
+ * inactivation completes, both flags will be cleared and the inode is a
+ * plain old IRECLAIMABLE inode.
+ */
+#define XFS_INACTIVATING	(1 << 13)
+
+/* All inode state flags related to inode reclaim. */
+#define XFS_ALL_IRECLAIM_FLAGS	(XFS_IRECLAIMABLE | \
+				 XFS_IRECLAIM | \
+				 XFS_NEED_INACTIVE | \
+				 XFS_INACTIVATING)
+
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
  * inode lookup. This prevents unintended behaviour on the new inode from
@@ -255,7 +271,8 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
+	 XFS_INACTIVATING)
 
 /*
  * Flags for inode locking.
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1721fce2ec94..a98d2429d795 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2786,6 +2786,13 @@ xlog_recover_process_iunlinks(
 		}
 		xfs_buf_rele(agibp);
 	}
+
+	/*
+	 * Flush the pending unlinked inodes to ensure that the inactivations
+	 * are fully completed on disk and the incore inodes can be reclaimed
+	 * before we signal that recovery is complete.
+	 */
+	xfs_inodegc_flush(mp);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index baf7b323cb15..1f7e9a608f38 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -514,7 +514,8 @@ xfs_check_summary_counts(
  * Flush and reclaim dirty inodes in preparation for unmount. Inodes and
  * internal inode structures can be sitting in the CIL and AIL at this point,
  * so we need to unpin them, write them back and/or reclaim them before unmount
- * can proceed.
+ * can proceed.  In other words, callers are required to have inactivated all
+ * inodes.
  *
  * An inode cluster that has been freed can have its buffer still pinned in
  * memory because the transaction is still sitting in a iclog. The stale inodes
@@ -546,6 +547,7 @@ xfs_unmount_flush_inodes(
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 
 	xfs_ail_push_all_sync(mp->m_ail);
+	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
@@ -782,6 +784,9 @@ xfs_mountfs(
 	if (error)
 		goto out_log_dealloc;
 
+	/* Enable background inode inactivation workers. */
+	xfs_inodegc_start(mp);
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
@@ -942,6 +947,15 @@ xfs_mountfs(
 	xfs_irele(rip);
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
+
+	/*
+	 * Inactivate all inodes that might still be in memory after a log
+	 * intent recovery failure so that reclaim can free them.  Metadata
+	 * inodes and the root directory shouldn't need inactivation, but the
+	 * mount failed for some reason, so pull down all the state and flee.
+	 */
+	xfs_inodegc_flush(mp);
+
 	/*
 	 * Flush all inode reclamation work and flush the log.
 	 * We have to do this /after/ rtunmount and qm_unmount because those
@@ -989,6 +1003,16 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes
+	 * that the VFS evicted earlier in the unmount process.  Freeing inodes
+	 * and discarding CoW fork preallocations can cause shape changes to
+	 * the free inode and refcount btrees, respectively, so we must finish
+	 * this before we discard the metadata space reservations.  Metadata
+	 * inodes and the root directory do not require inactivation.
+	 */
+	xfs_inodegc_flush(mp);
+
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c78b63fe779a..dc906b78e24c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -154,6 +154,13 @@ typedef struct xfs_mount {
 	uint8_t			m_rt_checked;
 	uint8_t			m_rt_sick;
 
+	/*
+	 * This atomic bitset controls flags that alter the behavior of the
+	 * filesystem.  Use only the atomic bit helper functions here; see
+	 * XFS_OPFLAG_* for information about the actual flags.
+	 */
+	unsigned long		m_opflags;
+
 	/*
 	 * End of read-mostly variables. Frequently written variables and locks
 	 * should be placed below this comment from now on. The first variable
@@ -184,6 +191,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct delayed_work	m_inodegc_work; /* background inode inactive */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -258,6 +266,19 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
 #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
 
+/*
+ * Operation flags -- each entry here is a bit index into m_opflags and is
+ * not itself a flag value.  Use the atomic bit functions to access.
+ */
+enum xfs_opflag_bits {
+	/*
+	 * If set, background inactivation worker threads will be scheduled to
+	 * process queued inodegc work.  If not, queued inodes remain in memory
+	 * waiting to be processed.
+	 */
+	XFS_OPFLAG_INODEGC_RUNNING_BIT	= 0,
+};
+
 /*
  * Max and min values for mount-option defined I/O
  * preallocation sizes.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ef89a9a3ba9e..f8f05d1037d2 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -702,6 +702,8 @@ xfs_fs_sync_fs(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	trace_xfs_fs_sync_fs(mp, __return_address);
+
 	/*
 	 * Doing anything during the async pass would be counterproductive.
 	 */
@@ -718,6 +720,25 @@ xfs_fs_sync_fs(
 		flush_delayed_work(&mp->m_log->l_work);
 	}
 
+	/*
+	 * Flush all deferred inode inactivation work so that the free space
+	 * counters will reflect recent deletions.  Do not force the log again
+	 * because log recovery can restart the inactivation from the info that
+	 * we just wrote into the ondisk log.
+	 *
+	 * For regular operation this isn't strictly necessary since we aren't
+	 * required to guarantee that unlinking frees space immediately, but
+	 * that is how XFS historically behaved.
+	 *
+	 * If, however, the filesystem is at FREEZE_PAGEFAULTS, this is our
+	 * last chance to complete the inactivation work before the filesystem
+	 * freezes and the log is quiesced.  The background worker will not
+	 * activate again until the fs is thawed because the VFS won't evict
+	 * any more inodes until freeze_super drops s_umount and we disable the
+	 * worker in xfs_fs_freeze.
+	 */
+	xfs_inodegc_flush(mp);
+
 	return 0;
 }
 
@@ -832,6 +853,17 @@ xfs_fs_freeze(
 	 */
 	flags = memalloc_nofs_save();
 	xfs_blockgc_stop(mp);
+
+	/*
+	 * Stop the inodegc background worker.  freeze_super already flushed
+	 * all pending inodegc work when it sync'd the filesystem after setting
+	 * SB_FREEZE_PAGEFAULTS, and it holds s_umount, so we know that inodes
+	 * cannot enter xfs_fs_destroy_inode until the freeze is complete.
+	 * If the filesystem is read-write, inactivated inodes will queue but
+	 * the worker will not run until the filesystem thaws or unmounts.
+	 */
+	xfs_inodegc_stop(mp);
+
 	xfs_save_resvblks(mp);
 	ret = xfs_log_quiesce(mp);
 	memalloc_nofs_restore(flags);
@@ -847,6 +879,14 @@ xfs_fs_unfreeze(
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
 	xfs_blockgc_start(mp);
+
+	/*
+	 * Don't reactivate the inodegc worker on a readonly filesystem because
+	 * inodes are sent directly to reclaim.
+	 */
+	if (!(mp->m_flags & XFS_MOUNT_RDONLY))
+		xfs_inodegc_start(mp);
+
 	return 0;
 }
 
@@ -1649,6 +1689,9 @@ xfs_remount_rw(
 	if (error && error != -ENOSPC)
 		return error;
 
+	/* Re-enable the background inode inactivation worker. */
+	xfs_inodegc_start(mp);
+
 	return 0;
 }
 
@@ -1671,6 +1714,15 @@ xfs_remount_ro(
 		return error;
 	}
 
+	/*
+	 * Stop the inodegc background worker.  xfs_fs_reconfigure already
+	 * flushed all pending inodegc work when it sync'd the filesystem.
+	 * The VFS holds s_umount, so we know that inodes cannot enter
+	 * xfs_fs_destroy_inode during a remount operation.  In readonly mode
+	 * we send inodes straight to reclaim, so no inodes will be queued.
+	 */
+	xfs_inodegc_stop(mp);
+
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
@@ -1794,6 +1846,7 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9d8d605f9b1..12ce47aebaef 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -157,6 +157,63 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
+DECLARE_EVENT_CLASS(xfs_fs_class,
+	TP_PROTO(struct xfs_mount *mp, void *caller_ip),
+	TP_ARGS(mp, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long long, mflags)
+		__field(unsigned long, opflags)
+		__field(unsigned long, sbflags)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->mflags = mp->m_flags;
+		__entry->opflags = mp->m_opflags;
+		__entry->sbflags = mp->m_super->s_flags;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d m_flags 0x%llx m_opflags 0x%lx s_flags 0x%lx caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->mflags,
+		  __entry->opflags,
+		  __entry->sbflags,
+		  __entry->caller_ip)
+);
+
+#define DEFINE_FS_EVENT(name)	\
+DEFINE_EVENT(xfs_fs_class, name,					\
+	TP_PROTO(struct xfs_mount *mp, void *caller_ip), \
+	TP_ARGS(mp, caller_ip))
+DEFINE_FS_EVENT(xfs_inodegc_flush);
+DEFINE_FS_EVENT(xfs_inodegc_start);
+DEFINE_FS_EVENT(xfs_inodegc_stop);
+DEFINE_FS_EVENT(xfs_inodegc_worker);
+DEFINE_FS_EVENT(xfs_inodegc_throttled);
+DEFINE_FS_EVENT(xfs_fs_sync_fs);
+
+DECLARE_EVENT_CLASS(xfs_gc_queue_class,
+	TP_PROTO(struct xfs_mount *mp, unsigned int delay_ms),
+	TP_ARGS(mp, delay_ms),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, delay_ms)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->delay_ms = delay_ms;
+	),
+	TP_printk("dev %d:%d delay_ms %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->delay_ms)
+);
+#define DEFINE_GC_QUEUE_EVENT(name)	\
+DEFINE_EVENT(xfs_gc_queue_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, unsigned int delay_ms),	\
+	TP_ARGS(mp, delay_ms))
+DEFINE_GC_QUEUE_EVENT(xfs_inodegc_queue);
+
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
 	TP_ARGS(mp, agno),
@@ -616,14 +673,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
+		__field(unsigned long, iflags)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
+		__entry->iflags = ip->i_flags;
 	),
-	TP_printk("dev %d:%d ino 0x%llx",
+	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino)
+		  __entry->ino,
+		  __entry->iflags)
 )
 
 #define DEFINE_INODE_EVENT(name) \
@@ -667,6 +727,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
+DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
+DEFINE_INODE_EVENT(xfs_inode_reclaiming);
+DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
+DEFINE_INODE_EVENT(xfs_inode_inactivating);
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the

