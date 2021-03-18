Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71B0AC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EB4764F33
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Mar 2021 22:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbhCRWe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Mar 2021 18:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232036AbhCRWeF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Mar 2021 18:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEB9C64E0C;
        Thu, 18 Mar 2021 22:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616106844;
        bh=3W+/igz8fjomysZE77RJhnzZAz6kt2fm28jmQBqgvII=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dNhhmZ9dJxhVXAqCRYY5Ce5DjkNqHBrnw43p9FAr5TWwWFSimRcUuruPIf1brNJrp
         S9irWbDdOj7ffFo4xDk8bET8JNXaVdhmWZHJl7TC2DLzz9wIz9poI51PV6lN8Dzra0
         oSH86s1g5wiRd3JxJ0gSJh7OB85NMHu6D7Ir9DAhKPGH6MAOgck1OlVcjG4GjkY9um
         6/x870NHmXRQGloTIc+B2C47iRrzp4bx8nYbaFhv40u8rrHOu5z0oDUuHgWmHEInk6
         bEatvvs5gRbMlWvLodGI0bj5Q6Mz5GyxFjQIvWceRqi3SXj5XZZxkOFi2u+pCSMqmO
         bxiZ2N5FbrCIQ==
Subject: [PATCH 1/7] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Date:   Thu, 18 Mar 2021 15:34:04 -0700
Message-ID: <161610684438.1887744.14925931297825970601.stgit@magnolia>
In-Reply-To: <161610683869.1887744.8863884017621115954.stgit@magnolia>
References: <161610683869.1887744.8863884017621115954.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
defer the inactivation phase to a separate workqueue.  With this we
avoid blocking memory reclaim on filesystem metadata updates that are
necessary to free an in-core inode, such as post-eof block freeing, COW
staging extent freeing, and truncating and freeing unlinked inodes.  Now
that work is deferred to a workqueue where we can do the freeing in
batches.

We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
The first flag helps our worker find inodes needing inactivation, and
the second flag marks inodes that are in the process of being
inactivated.  A concurrent xfs_iget on the inode can still resurrect the
inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).

Unfortunately, deferring the inactivation has one huge downside --
eventual consistency.  Since all the freeing is deferred to a worker
thread, one can rm a file but the space doesn't come back immediately.
This can cause some odd side effects with quota accounting and statfs,
so we also force inactivation scans in order to maintain the existing
behaviors, at least outwardly.

For this patch we'll set the delay to zero to mimic the old timing as
much as possible; in the next patch we'll play with different delay
settings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Documentation/admin-guide/xfs.rst |    3 
 fs/xfs/scrub/common.c             |    2 
 fs/xfs/xfs_fsops.c                |    9 +
 fs/xfs/xfs_icache.c               |  420 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h               |    9 +
 fs/xfs/xfs_inode.c                |   93 ++++++++
 fs/xfs/xfs_inode.h                |   16 +
 fs/xfs/xfs_log_recover.c          |    7 +
 fs/xfs/xfs_mount.c                |   13 +
 fs/xfs/xfs_mount.h                |    4 
 fs/xfs/xfs_qm_syscalls.c          |   20 ++
 fs/xfs/xfs_super.c                |   53 ++++-
 fs/xfs/xfs_trace.h                |   16 +
 13 files changed, 640 insertions(+), 25 deletions(-)


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
index da60e7d1f895..8bc824515e0b 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -886,6 +886,7 @@ xchk_stop_reaping(
 {
 	sc->flags |= XCHK_REAPING_DISABLED;
 	xfs_blockgc_stop(sc->mp);
+	xfs_inodegc_stop(sc->mp);
 }
 
 /* Restart background reaping of resources. */
@@ -893,6 +894,7 @@ void
 xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
+	xfs_inodegc_start(sc->mp);
 	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a2a407039227..3a3baf56198b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -19,6 +19,8 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
 
 /*
  * growfs operations
@@ -290,6 +292,13 @@ xfs_fs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
 {
+	/*
+	 * Process all the queued file and speculative preallocation cleanup so
+	 * that the counter values we report here do not incorporate any
+	 * resources that were previously deleted.
+	 */
+	xfs_inodegc_force(mp);
+
 	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
 	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
 	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 563865140a99..75116000b494 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -28,6 +28,7 @@
 
 /* Forward declarations to reduce indirect calls in xfs_inode_walk_ag */
 static int xfs_blockgc_scan_inode(struct xfs_inode *ip, void *args);
+static int xfs_inodegc_inactivate(struct xfs_inode *ip, void *args);
 
 /*
  * Allocate and initialise an xfs_inode.
@@ -198,6 +199,18 @@ xfs_perag_clear_reclaim_tag(
 	trace_xfs_perag_clear_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
 }
 
+static void
+__xfs_inode_set_reclaim_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			   XFS_ICI_RECLAIM_TAG);
+	xfs_perag_set_reclaim_tag(pag);
+	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+}
 
 /*
  * We set the inode flag atomically with the radix tree tag.
@@ -215,10 +228,7 @@ xfs_inode_set_reclaim_tag(
 	spin_lock(&pag->pag_ici_lock);
 	spin_lock(&ip->i_flags_lock);
 
-	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			   XFS_ICI_RECLAIM_TAG);
-	xfs_perag_set_reclaim_tag(pag);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	__xfs_inode_set_reclaim_tag(pag, ip);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -236,6 +246,93 @@ xfs_inode_clear_reclaim_tag(
 	xfs_perag_clear_reclaim_tag(pag);
 }
 
+/* Queue a new inode gc pass if there are inodes needing inactivation. */
+static void
+xfs_inodegc_queue(
+	struct xfs_mount        *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+	rcu_read_unlock();
+}
+
+/* Remember that an AG has one more inode to inactivate. */
+static void
+xfs_perag_set_inactive_tag(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	lockdep_assert_held(&pag->pag_ici_lock);
+	if (pag->pag_ici_inactive++)
+		return;
+
+	/* propagate the inactive tag up into the perag radix tree */
+	spin_lock(&mp->m_perag_lock);
+	radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
+			XFS_ICI_INODEGC_TAG);
+	spin_unlock(&mp->m_perag_lock);
+
+	/* schedule periodic background inode inactivation */
+	xfs_inodegc_queue(mp);
+
+	trace_xfs_perag_set_inactive(mp, pag->pag_agno, -1, _RET_IP_);
+}
+
+/* Set this inode's inactive tag and set the per-AG tag. */
+void
+xfs_inode_set_inactive_tag(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_INODEGC_TAG);
+	xfs_perag_set_inactive_tag(pag);
+	__xfs_iflags_set(ip, XFS_NEED_INACTIVE);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
+
+/* Remember that an AG has one less inode to inactivate. */
+static void
+xfs_perag_clear_inactive_tag(
+	struct xfs_perag	*pag)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	lockdep_assert_held(&pag->pag_ici_lock);
+	if (--pag->pag_ici_inactive)
+		return;
+
+	/* clear the inactive tag from the perag radix tree */
+	spin_lock(&mp->m_perag_lock);
+	radix_tree_tag_clear(&mp->m_perag_tree, pag->pag_agno,
+			XFS_ICI_INODEGC_TAG);
+	spin_unlock(&mp->m_perag_lock);
+	trace_xfs_perag_clear_inactive(mp, pag->pag_agno, -1, _RET_IP_);
+}
+
+/* Clear this inode's inactive tag and try to clear the AG's. */
+STATIC void
+xfs_inode_clear_inactive_tag(
+	struct xfs_perag	*pag,
+	xfs_ino_t		ino)
+{
+	radix_tree_tag_clear(&pag->pag_ici_root,
+			XFS_INO_TO_AGINO(pag->pag_mount, ino),
+			XFS_ICI_INODEGC_TAG);
+	xfs_perag_clear_inactive_tag(pag);
+}
+
 static void
 xfs_inew_wait(
 	struct xfs_inode	*ip)
@@ -301,6 +398,13 @@ xfs_iget_check_free_state(
 	struct xfs_inode	*ip,
 	int			flags)
 {
+	/*
+	 * Unlinked inodes awaiting inactivation must not be reused until we
+	 * have a chance to clear the on-disk metadata.
+	 */
+	if (VFS_I(ip)->i_nlink == 0 && (ip->i_flags & XFS_NEED_INACTIVE))
+		return -ENOENT;
+
 	if (flags & XFS_IGET_CREATE) {
 		/* should be a free inode */
 		if (VFS_I(ip)->i_mode != 0) {
@@ -326,6 +430,67 @@ xfs_iget_check_free_state(
 	return 0;
 }
 
+/*
+ * We've torn down the VFS part of this NEED_INACTIVE inode, so we need to get
+ * it back into working state.
+ */
+static int
+xfs_iget_inactive(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct inode		*inode = VFS_I(ip);
+	int			error;
+
+	error = xfs_reinit_inode(mp, inode);
+	if (error) {
+		bool wake;
+		/*
+		 * Re-initializing the inode failed, and we are in deep
+		 * trouble.  Try to re-add it to the inactive list.
+		 */
+		rcu_read_lock();
+		spin_lock(&ip->i_flags_lock);
+		wake = !!__xfs_iflags_test(ip, XFS_INEW);
+		ip->i_flags &= ~(XFS_INEW | XFS_INACTIVATING);
+		if (wake)
+			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
+		ASSERT(ip->i_flags & XFS_NEED_INACTIVE);
+		trace_xfs_iget_inactive_fail(ip);
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+		return error;
+	}
+
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	/*
+	 * Clear the per-lifetime state in the inode as we are now effectively
+	 * a new inode and need to return to the initial state before reuse
+	 * occurs.
+	 */
+	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
+	ip->i_flags |= XFS_INEW;
+	xfs_inode_clear_inactive_tag(pag, ip->i_ino);
+	inode->i_state = I_NEW;
+	ip->i_sick = 0;
+	ip->i_checked = 0;
+
+	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
+	init_rwsem(&inode->i_rwsem);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+
+	/*
+	 * Reattach dquots since we might have removed them when we put this
+	 * inode on the inactivation list.
+	 */
+	return xfs_qm_dqattach(ip);
+}
+
 /*
  * Check the validity of the inode we just found it the cache
  */
@@ -360,14 +525,14 @@ xfs_iget_cache_hit(
 	/*
 	 * If we are racing with another cache hit that is currently
 	 * instantiating this inode or currently recycling it out of
-	 * reclaimabe state, wait for the initialisation to complete
+	 * reclaimable state, wait for the initialisation to complete
 	 * before continuing.
 	 *
 	 * XXX(hch): eventually we should do something equivalent to
 	 *	     wait_on_inode to wait for these flags to be cleared
 	 *	     instead of polling for it.
 	 */
-	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
+	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING)) {
 		trace_xfs_iget_skip(ip);
 		XFS_STATS_INC(mp, xs_ig_frecycle);
 		error = -EAGAIN;
@@ -441,6 +606,32 @@ xfs_iget_cache_hit(
 
 		spin_unlock(&ip->i_flags_lock);
 		spin_unlock(&pag->pag_ici_lock);
+	} else if (ip->i_flags & XFS_NEED_INACTIVE) {
+		/*
+		 * If NEED_INACTIVE is set, we've torn down the VFS inode and
+		 * need to carefully get it back into useable state.
+		 */
+		trace_xfs_iget_inactive(ip);
+
+		if (flags & XFS_IGET_INCORE) {
+			error = -EAGAIN;
+			goto out_error;
+		}
+
+		/*
+		 * We need to set XFS_INACTIVATING to prevent
+		 * xfs_inactive_inode from stomping over us while we recycle
+		 * the inode.  We can't clear the radix tree inactive tag yet
+		 * as it requires pag_ici_lock to be held exclusive.
+		 */
+		ip->i_flags |= XFS_INACTIVATING;
+
+		spin_unlock(&ip->i_flags_lock);
+		rcu_read_unlock();
+
+		error = xfs_iget_inactive(pag, ip);
+		if (error)
+			return error;
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -743,9 +934,29 @@ xfs_inode_walk_ag_grab(
 	if (!ip->i_ino)
 		goto out_unlock_noent;
 
+	if (tag == XFS_ICI_INODEGC_TAG) {
+		/*
+		 * Skip inodes that don't need inactivation or are being
+		 * inactivated (or reactivated) by another thread.
+		 */
+		if (!(ip->i_flags & XFS_NEED_INACTIVE) ||
+		    (ip->i_flags & XFS_INACTIVATING))
+			goto out_unlock_noent;
+
+		/*
+		 * Mark this inode as being inactivated even if the fs is shut
+		 * down because we need xfs_inodegc_inactivate to push this
+		 * inode into the reclaim state.
+		 */
+		ip->i_flags |= XFS_INACTIVATING;
+		spin_unlock(&ip->i_flags_lock);
+		return true;
+	}
+
 	/* avoid new or reclaimable inodes. Leave for reclaim code to flush */
 	if ((tag != XFS_ICI_NO_TAG && __xfs_iflags_test(ip, XFS_INEW)) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM))
+	    __xfs_iflags_test(ip, XFS_IRECLAIMABLE | XFS_IRECLAIM |
+				  XFS_NEED_INACTIVE | XFS_INACTIVATING))
 		goto out_unlock_noent;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -770,6 +981,8 @@ inode_walk_fn_to_tag(int (*execute)(struct xfs_inode *ip, void *args))
 {
 	if (execute == xfs_blockgc_scan_inode)
 		return XFS_ICI_BLOCKGC_TAG;
+	else if (execute == xfs_inodegc_inactivate)
+		return XFS_ICI_INODEGC_TAG;
 	return XFS_ICI_NO_TAG;
 }
 
@@ -858,6 +1071,9 @@ xfs_inode_walk_ag(
 				error = xfs_blockgc_scan_inode(batch[i], args);
 				xfs_irele(batch[i]);
 				break;
+			case XFS_ICI_INODEGC_TAG:
+				error = xfs_inodegc_inactivate(batch[i], args);
+				break;
 			case XFS_ICI_NO_TAG:
 				if (xfs_iflags_test(batch[i], XFS_INEW))
 					xfs_inew_wait(batch[i]);
@@ -1005,6 +1221,7 @@ xfs_reclaim_inode(
 
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 reclaim:
+	trace_xfs_inode_reclaiming(ip);
 
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
@@ -1718,3 +1935,192 @@ xfs_blockgc_free_quota(
 			xfs_inode_dquot(ip, XFS_DQTYPE_GROUP),
 			xfs_inode_dquot(ip, XFS_DQTYPE_PROJ), eof_flags);
 }
+
+/*
+ * Deferred Inode Inactivation
+ * ===========================
+ *
+ * Sometimes, inodes need to have work done on them once the last program has
+ * closed the file.  Typically this means cleaning out any leftover post-eof or
+ * CoW staging blocks for linked files.  For inodes that have been totally
+ * unlinked, this means unmapping data/attr/cow blocks, removing the inode
+ * from the unlinked buckets, and marking it free in the inobt and inode table.
+ *
+ * This process can generate many metadata updates, which shows up as close()
+ * and unlink() calls that take a long time.  We defer all that work to a
+ * per-AG workqueue which means that we can batch a lot of work and do it in
+ * inode order for better performance.  Furthermore, we can control the
+ * workqueue, which means that we can avoid doing inactivation work at a bad
+ * time, such as when the fs is frozen.
+ *
+ * Deferred inactivation introduces new inode flag states (NEED_INACTIVE and
+ * INACTIVATING) and adds a new INACTIVE radix tree tag for fast access.  We
+ * maintain separate perag counters for both types, and move counts as inodes
+ * wander the state machine, which now works as follows:
+ *
+ * If the inode needs inactivation, we:
+ *   - Set the NEED_INACTIVE inode flag
+ *   - Increment the per-AG inactive count
+ *   - Set the INACTIVE tag in the per-AG inode tree
+ *   - Set the INACTIVE tag in the per-fs AG tree
+ *   - Schedule background inode inactivation
+ *
+ * If the inode does not need inactivation, we:
+ *   - Set the RECLAIMABLE inode flag
+ *   - Increment the per-AG reclaim count
+ *   - Set the RECLAIM tag in the per-AG inode tree
+ *   - Set the RECLAIM tag in the per-fs AG tree
+ *   - Schedule background inode reclamation
+ *
+ * When it is time for background inode inactivation, we:
+ *   - Set the INACTIVATING inode flag
+ *   - Make all the on-disk updates
+ *   - Clear both INACTIVATING and NEED_INACTIVE inode flags
+ *   - Decrement the per-AG inactive count
+ *   - Clear the INACTIVE tag in the per-AG inode tree
+ *   - Clear the INACTIVE tag in the per-fs AG tree if that was the last one
+ *   - Kick the inode into reclamation per the previous paragraph.
+ *
+ * When it is time for background inode reclamation, we:
+ *   - Set the IRECLAIM inode flag
+ *   - Detach all the resources and remove the inode from the per-AG inode tree
+ *   - Clear both IRECLAIM and RECLAIMABLE inode flags
+ *   - Decrement the per-AG reclaim count
+ *   - Clear the RECLAIM tag from the per-AG inode tree
+ *   - Clear the RECLAIM tag from the per-fs AG tree if there are no more
+ *     inodes waiting for reclamation or inactivation
+ *
+ * Note that xfs_inodegc_queue and xfs_inactive_grab are further up in
+ * the source code so that we avoid static function declarations.
+ */
+
+/*
+ * Free all speculative preallocations and possibly even the inode itself.
+ * This is the last chance to make changes to an otherwise unreferenced file
+ * before incore reclamation happens.
+ */
+static int
+xfs_inodegc_inactivate(
+	struct xfs_inode	*ip,
+	void			*args)
+{
+	struct xfs_eofblocks	*eofb = args;
+	struct xfs_perag	*pag;
+
+	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);
+
+	/*
+	 * Not a match for our passed in scan filter?  Put it back on the shelf
+	 * and move on.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!xfs_inode_matches_eofb(ip, eofb)) {
+		ip->i_flags &= ~XFS_INACTIVATING;
+		spin_unlock(&ip->i_flags_lock);
+		return 0;
+	}
+	spin_unlock(&ip->i_flags_lock);
+
+	trace_xfs_inode_inactivating(ip);
+
+	xfs_inactive(ip);
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+
+	/*
+	 * Clear the inactive state flags and schedule a reclaim run once
+	 * we're done with the inactivations.  We must ensure that the inode
+	 * smoothly transitions from inactivating to reclaimable so that iget
+	 * cannot see either data structure midway through the transition.
+	 */
+	pag = xfs_perag_get(ip->i_mount,
+			XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
+	xfs_inode_clear_inactive_tag(pag, ip->i_ino);
+
+	__xfs_inode_set_reclaim_tag(pag, ip);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+
+	return 0;
+}
+
+/* Walk the fs and inactivate the inodes in them. */
+int
+xfs_inodegc_free_space(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	trace_xfs_inodegc_free_space(mp, eofb, _RET_IP_);
+
+	return xfs_inode_walk(mp, xfs_inodegc_inactivate, eofb);
+}
+
+/* Background inode inactivation worker. */
+void
+xfs_inodegc_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_inodegc_work);
+	int			error;
+
+	/*
+	 * We want to skip inode inactivation while the filesystem is frozen
+	 * because we don't want the inactivation thread to block while taking
+	 * sb_intwrite.  Therefore, we try to take sb_write for the duration
+	 * of the inactive scan -- a freeze attempt will block until we're
+	 * done here, and if the fs is past stage 1 freeze we'll bounce out
+	 * until things unfreeze.  If the fs goes down while frozen we'll
+	 * still have log recovery to clean up after us.
+	 */
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
+
+	error = xfs_inodegc_free_space(mp, NULL);
+	if (error && error != -EAGAIN)
+		xfs_err(mp, "inode inactivation failed, error %d", error);
+
+	sb_end_write(mp->m_super);
+	xfs_inodegc_queue(mp);
+}
+
+/* Force all currently queued inode inactivation work to run immediately. */
+void
+xfs_inodegc_force(
+	struct xfs_mount	*mp)
+{
+	if (!radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+		return;
+
+	/*
+	 * In order to reset the delayed work to run immediately, we have to
+	 * cancel the work item and requeue it with a zero timer value.  We
+	 * don't care if the worker races with our requeue, because at worst it
+	 * will iterate the radix tree one extra time and find no inodes to
+	 * inactivate.
+	 */
+	cancel_delayed_work(&mp->m_inodegc_work);
+	queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+	flush_delayed_work(&mp->m_inodegc_work);
+}
+
+/* Stop all queued inactivation work. */
+void
+xfs_inodegc_stop(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_inodegc_work);
+}
+
+/* Schedule deferred inode inactivation work. */
+void
+xfs_inodegc_start(
+	struct xfs_mount	*mp)
+{
+	xfs_inodegc_queue(mp);
+}
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 04e59b775432..d4171998deef 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -25,6 +25,8 @@ struct xfs_eofblocks {
 #define XFS_ICI_RECLAIM_TAG	0	/* inode is to be reclaimed */
 /* Inode has speculative preallocations (posteof or cow) to clean. */
 #define XFS_ICI_BLOCKGC_TAG	1
+/* Inode can be inactivated. */
+#define XFS_ICI_INODEGC_TAG	2
 
 /*
  * Flags for xfs_iget()
@@ -48,6 +50,7 @@ int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
 void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
+void xfs_inode_set_inactive_tag(struct xfs_inode *ip);
 
 int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
@@ -73,4 +76,10 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
+void xfs_inodegc_worker(struct work_struct *work);
+void xfs_inodegc_force(struct xfs_mount *mp);
+void xfs_inodegc_stop(struct xfs_mount *mp);
+void xfs_inodegc_start(struct xfs_mount *mp);
+int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
+
 #endif
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 12c79962f8c3..d0afb76a5d84 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1665,6 +1665,83 @@ xfs_inactive_ifree(
 	return 0;
 }
 
+/* Prepare inode for inactivation. */
+void
+xfs_inode_inactivation_prep(
+	struct xfs_inode	*ip)
+{
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return;
+
+	/*
+	 * If this inode is unlinked (and now unreferenced) we need to dispose
+	 * of it in the on disk metadata.
+	 *
+	 * Change the generation so that the inode can't be opened by handle
+	 * now that the last external references has dropped.  Bulkstat won't
+	 * return inodes with zero nlink so nobody will ever find this inode
+	 * again.
+	 */
+	if (VFS_I(ip)->i_nlink == 0)
+		VFS_I(ip)->i_generation = prandom_u32();
+
+	/*
+	 * Detach dquots just in case someone tries a quotaoff while the inode
+	 * is waiting on the inactive list.  We'll reattach them (if needed)
+	 * when inactivating the inode.
+	 */
+	xfs_qm_dqdetach(ip);
+}
+
+/*
+ * Returns true if we need to update the on-disk metadata before we can free
+ * the memory used by this inode.  Updates include freeing post-eof
+ * preallocations; freeing COW staging extents; and marking the inode free in
+ * the inobt if it is on the unlinked list.
+ */
+bool
+xfs_inode_needs_inactivation(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*cow_ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+
+	/*
+	 * If the inode is already free, then there can be nothing
+	 * to clean up here.
+	 */
+	if (VFS_I(ip)->i_mode == 0)
+		return false;
+
+	/* If this is a read-only mount, don't do this (would generate I/O) */
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
+		return false;
+
+	/* Metadata inodes require explicit resource cleanup. */
+	if (xfs_is_metadata_inode(ip))
+		return false;
+
+	/* Try to clean out the cow blocks if there are any. */
+	if (cow_ifp && cow_ifp->if_bytes > 0)
+		return true;
+
+	/* Unlinked files must be freed. */
+	if (VFS_I(ip)->i_nlink == 0)
+		return true;
+
+	/*
+	 * This file isn't being freed, so check if there are post-eof blocks
+	 * to free.  @force is true because we are evicting an inode from the
+	 * cache.  Post-eof blocks must be freed, lest we end up with broken
+	 * free space accounting.
+	 *
+	 * Note: don't bother with iolock here since lockdep complains about
+	 * acquiring it in reclaim context. We have the only reference to the
+	 * inode at this point anyways.
+	 */
+	return xfs_can_free_eofblocks(ip, true);
+}
+
 /*
  * xfs_inactive
  *
@@ -1675,7 +1752,7 @@ xfs_inactive_ifree(
  */
 void
 xfs_inactive(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp;
 	int			error;
@@ -1701,6 +1778,16 @@ xfs_inactive(
 	if (xfs_is_metadata_inode(ip))
 		return;
 
+	/*
+	 * Re-attach dquots prior to freeing EOF blocks or CoW staging extents.
+	 * We dropped the dquot prior to inactivation (because quotaoff can't
+	 * resurrect inactive inodes to force-drop the dquot) so we /must/
+	 * do this before touching any block mappings.
+	 */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return;
+
 	/* Try to clean out the cow blocks if there are any. */
 	if (xfs_inode_has_cow_data(ip))
 		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
@@ -1726,10 +1813,6 @@ xfs_inactive(
 	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		return;
-
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c2c26f8f4a81..7aaff07d1210 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -222,6 +222,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
 #define __XFS_INEW_BIT		3	 /* inode has just been allocated */
 #define XFS_INEW		(1 << __XFS_INEW_BIT)
+#define XFS_NEED_INACTIVE	(1 << 4) /* see XFS_INACTIVATING below */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
 #define XFS_IFLUSHING		(1 << 7) /* inode is being flushed */
@@ -236,6 +237,15 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
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
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
  * inode lookup. This prevents unintended behaviour on the new inode from
@@ -243,7 +253,8 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
+	 XFS_INACTIVATING)
 
 /*
  * Flags for inode locking.
@@ -480,6 +491,9 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+bool xfs_inode_needs_inactivation(struct xfs_inode *ip);
+void xfs_inode_inactivation_prep(struct xfs_inode *ip);
+
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 97f31308de03..b03b127e34cc 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2792,6 +2792,13 @@ xlog_recover_process_iunlinks(
 		}
 		xfs_buf_rele(agibp);
 	}
+
+	/*
+	 * Now that we've put all the iunlink inodes on the lru, let's make
+	 * sure that we perform all the on-disk metadata updates to actually
+	 * free those inodes.
+	 */
+	xfs_inodegc_force(mp);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 1c97b155a8ee..cd015e3d72fc 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -640,6 +640,10 @@ xfs_check_summary_counts(
  * so we need to unpin them, write them back and/or reclaim them before unmount
  * can proceed.
  *
+ * Start the process by pushing all inodes through the inactivation process
+ * so that all file updates to on-disk metadata can be flushed with the log.
+ * After the AIL push, all inodes should be ready for reclamation.
+ *
  * An inode cluster that has been freed can have its buffer still pinned in
  * memory because the transaction is still sitting in a iclog. The stale inodes
  * on that buffer will be pinned to the buffer until the transaction hits the
@@ -663,6 +667,7 @@ static void
 xfs_unmount_flush_inodes(
 	struct xfs_mount	*mp)
 {
+	xfs_inodegc_force(mp);
 	xfs_log_force(mp, XFS_LOG_SYNC);
 	xfs_extent_busy_wait_all(mp);
 	flush_workqueue(xfs_discard_wq);
@@ -670,6 +675,7 @@ xfs_unmount_flush_inodes(
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 
 	xfs_ail_push_all_sync(mp->m_ail);
+	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
@@ -1095,6 +1101,13 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes.
+	 * Since this can involve finobt updates, do it now before we lose the
+	 * per-AG space reservations.
+	 */
+	xfs_inodegc_force(mp);
+
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 81829d19596e..987bb3cca9a7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -177,6 +177,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct delayed_work	m_inodegc_work; /* background inode inactive */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -349,7 +350,8 @@ typedef struct xfs_perag {
 
 	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
-	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned int	pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned int	pag_ici_inactive;	/* inodes wanting inactivation*/
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
 	/* buffer cache index */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index dad4d3fc3df3..4c2af35f95c7 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -104,6 +104,12 @@ xfs_qm_scall_quotaoff(
 	uint			inactivate_flags;
 	struct xfs_qoff_logitem	*qoffstart = NULL;
 
+	/*
+	 * Clean up the inactive list before we turn quota off, to reduce the
+	 * amount of quotaoff work we have to do with the mutex held.
+	 */
+	xfs_inodegc_force(mp);
+
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
 	 * Note that quota utilities (like quotaoff) _expect_
@@ -697,6 +703,13 @@ xfs_qm_scall_getquota(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	/*
+	 * Process all the queued file and speculative preallocation cleanup so
+	 * that the counter values we report here do not incorporate any
+	 * resources that were previously deleted.
+	 */
+	xfs_inodegc_force(mp);
+
 	/*
 	 * Try to get the dquot. We don't want it allocated on disk, so don't
 	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
@@ -735,6 +748,13 @@ xfs_qm_scall_getquota_next(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	/*
+	 * Process all the queued file and speculative preallocation cleanup so
+	 * that the counter values we report here do not incorporate any
+	 * resources that were previously deleted.
+	 */
+	xfs_inodegc_force(mp);
+
 	error = xfs_qm_dqget_next(mp, *id, type, &dqp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e774358383d6..8d0142487fc7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -637,28 +637,34 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			need_inactive;
 
 	trace_xfs_destroy_inode(ip);
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
-	XFS_STATS_INC(ip->i_mount, vn_rele);
-	XFS_STATS_INC(ip->i_mount, vn_remove);
+	XFS_STATS_INC(mp, vn_rele);
+	XFS_STATS_INC(mp, vn_remove);
 
-	xfs_inactive(ip);
-
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
+	need_inactive = xfs_inode_needs_inactivation(ip);
+	if (need_inactive) {
+		trace_xfs_inode_set_need_inactive(ip);
+		xfs_inode_inactivation_prep(ip);
+	} else if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
 		xfs_check_delalloc(ip, XFS_COW_FORK);
 		ASSERT(0);
 	}
-
-	XFS_STATS_INC(ip->i_mount, vn_reclaim);
+	XFS_STATS_INC(mp, vn_reclaim);
+	trace_xfs_inode_set_reclaimable(ip);
 
 	/*
 	 * We should never get here with one of the reclaim flags already set.
 	 */
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
 	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_NEED_INACTIVE));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_INACTIVATING));
 
 	/*
 	 * We always use background reclaim here because even if the inode is
@@ -667,7 +673,10 @@ xfs_fs_destroy_inode(
 	 * reclaim path handles this more efficiently than we can here, so
 	 * simply let background reclaim tear down all inodes.
 	 */
-	xfs_inode_set_reclaim_tag(ip);
+	if (need_inactive)
+		xfs_inode_set_inactive_tag(ip);
+	else
+		xfs_inode_set_reclaim_tag(ip);
 }
 
 static void
@@ -797,6 +806,13 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
+	/*
+	 * Process all the queued file and speculative preallocation cleanup so
+	 * that the counter values we report here do not incorporate any
+	 * resources that were previously deleted.
+	 */
+	xfs_inodegc_force(mp);
+
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
 
@@ -911,6 +927,18 @@ xfs_fs_unfreeze(
 	return 0;
 }
 
+/*
+ * Before we get to stage 1 of a freeze, force all the inactivation work so
+ * that there's less work to do if we crash during the freeze.
+ */
+STATIC int
+xfs_fs_freeze_super(
+	struct super_block	*sb)
+{
+	xfs_inodegc_force(XFS_M(sb));
+	return freeze_super(sb);
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock _has_ now been read in.
@@ -1089,6 +1117,7 @@ static const struct super_operations xfs_super_operations = {
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.freeze_super		= xfs_fs_freeze_super,
 };
 
 static int
@@ -1720,6 +1749,13 @@ xfs_remount_ro(
 		return error;
 	}
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes.
+	 * Since this can involve finobt updates, do it now before we lose the
+	 * per-AG space reservations.
+	 */
+	xfs_inodegc_force(mp);
+
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
@@ -1843,6 +1879,7 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index e74bbb648f83..4add2b248bc6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -157,6 +157,8 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_set_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_reclaim);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_blockgc);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_blockgc);
+DEFINE_PERAG_REF_EVENT(xfs_perag_set_inactive);
+DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inactive);
 
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
@@ -617,14 +619,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
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
@@ -634,6 +639,8 @@ DEFINE_EVENT(xfs_inode_class, name, \
 DEFINE_INODE_EVENT(xfs_iget_skip);
 DEFINE_INODE_EVENT(xfs_iget_reclaim);
 DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
+DEFINE_INODE_EVENT(xfs_iget_inactive);
+DEFINE_INODE_EVENT(xfs_iget_inactive_fail);
 DEFINE_INODE_EVENT(xfs_iget_hit);
 DEFINE_INODE_EVENT(xfs_iget_miss);
 
@@ -668,6 +675,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
+DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
+DEFINE_INODE_EVENT(xfs_inode_reclaiming);
+DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
+DEFINE_INODE_EVENT(xfs_inode_inactivating);
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -3927,6 +3938,7 @@ DEFINE_EVENT(xfs_eofblocks_class, name,	\
 	TP_ARGS(mp, eofb, caller_ip))
 DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
 DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
+DEFINE_EOFBLOCKS_EVENT(xfs_inodegc_free_space);
 
 #endif /* _TRACE_XFS_H */
 

