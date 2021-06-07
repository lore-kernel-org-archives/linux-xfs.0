Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B5AC47082
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7B72610E7
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Jun 2021 22:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhFGW05 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Jun 2021 18:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhFGW04 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:26:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2051D61059;
        Mon,  7 Jun 2021 22:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104705;
        bh=6mbx2PZhp2YonvUfzcwkKywNwzrneL7maef/MJyjZVU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VEyURx1uKLkk72kwVlgsGyoNGfqqSl0oPTBnp+sGpnAZsWmmeEJG4vzlRyD4uE1oL
         KMxhMPDJk0T07mkVRD+l+iYpcczGrKgKG2OOYJW83bt7Zjs+UZXpcjE6Cgc06Ohw/6
         sD9QEn2pPnq//ujLuC+z5jhJCSrwtDpFAdv52az3uR2iak5ISt7tAam7fACpz/PX0b
         4P1UOAVksV8/XwcatKfazHhC95YGmqNMBbxJis4uPXvk6lLYvZny68YMc95famdTuG
         0CWn4ahxDyXnTz5jkJINEp5XnC26SZnQ3d2jqvWly13k33SHDOePn5Zch51x6gsszF
         k73UkrSZ8d1SQ==
Subject: [PATCH 2/9] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:25:04 -0700
Message-ID: <162310470480.3465262.12512984715866568596.stgit@locust>
In-Reply-To: <162310469340.3465262.504398465311182657.stgit@locust>
References: <162310469340.3465262.504398465311182657.stgit@locust>
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
 fs/xfs/xfs_fsops.c                |    4 
 fs/xfs/xfs_icache.c               |  364 +++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_icache.h               |   35 +++-
 fs/xfs/xfs_inode.c                |   60 ++++++
 fs/xfs/xfs_inode.h                |   15 +-
 fs/xfs/xfs_log_recover.c          |    7 +
 fs/xfs/xfs_mount.c                |   29 +++
 fs/xfs/xfs_mount.h                |    7 +
 fs/xfs/xfs_qm_syscalls.c          |    4 
 fs/xfs/xfs_super.c                |  120 +++++++++++-
 fs/xfs/xfs_trace.h                |   14 +
 13 files changed, 620 insertions(+), 44 deletions(-)


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
index cadfd5799909..93e63407c284 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -884,6 +884,7 @@ xchk_stop_reaping(
 {
 	sc->flags |= XCHK_REAPING_DISABLED;
 	xfs_blockgc_stop(sc->mp);
+	xfs_inodegc_stop(sc->mp);
 }
 
 /* Restart background reaping of resources. */
@@ -891,6 +892,7 @@ void
 xchk_start_reaping(
 	struct xfs_scrub	*sc)
 {
+	xfs_inodegc_start(sc->mp);
 	xfs_blockgc_start(sc->mp);
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 07c745cd483e..8e92402c685b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -19,6 +19,8 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
 
 /*
  * Write new AG headers to disk. Non-transactional, but need to be
@@ -343,6 +345,8 @@ xfs_fs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
 {
+	xfs_inodegc_summary_flush(mp);
+
 	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
 	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
 	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4d4aa61fbd34..791202236a18 100644
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
@@ -44,6 +46,7 @@ enum xfs_icwalk_goal {
 	/* Goals directly associated with tagged inodes. */
 	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
 	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
+	XFS_ICWALK_INODEGC	= XFS_ICI_INODEGC_TAG,
 };
 
 #define XFS_ICWALK_NULL_TAG	(-1U)
@@ -228,6 +231,26 @@ xfs_blockgc_queue(
 	rcu_read_unlock();
 }
 
+static inline bool
+xfs_inodegc_running(struct xfs_mount *mp)
+{
+	return test_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
+}
+
+/* Queue a new inode gc pass if there are inodes needing inactivation. */
+static void
+xfs_inodegc_queue(
+	struct xfs_mount        *mp)
+{
+	if (!xfs_inodegc_running(mp))
+		return;
+
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+	rcu_read_unlock();
+}
+
 /* Set a tag on both the AG incore inode tree and the AG radix tree. */
 static void
 xfs_perag_set_inode_tag(
@@ -262,6 +285,9 @@ xfs_perag_set_inode_tag(
 	case XFS_ICI_BLOCKGC_TAG:
 		xfs_blockgc_queue(pag);
 		break;
+	case XFS_ICI_INODEGC_TAG:
+		xfs_inodegc_queue(mp);
+		break;
 	}
 
 	trace_xfs_perag_set_inode_tag(mp, pag->pag_agno, tag, _RET_IP_);
@@ -308,18 +334,28 @@ xfs_perag_clear_inode_tag(
  */
 void
 xfs_inode_mark_reclaimable(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	bool			need_inactive)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	unsigned int		tag;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
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
@@ -383,19 +419,26 @@ xfs_reinit_inode(
 static int
 xfs_iget_recycle(
 	struct xfs_perag	*pag,
-	struct xfs_inode	*ip) __releases(&ip->i_flags_lock)
+	struct xfs_inode	*ip,
+	unsigned long		iflag) __releases(&ip->i_flags_lock)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
+	unsigned int		tag;
 	int			error;
 
+	ASSERT(iflag == XFS_IRECLAIM || iflag == XFS_INACTIVATING);
+
+	tag = (iflag == XFS_INACTIVATING) ? XFS_ICI_INODEGC_TAG :
+					    XFS_ICI_RECLAIM_TAG;
+
 	/*
 	 * We need to make it look like the inode is being reclaimed to prevent
 	 * the actual reclaim workers from stomping over us while we recycle
 	 * the inode.  We can't clear the radix tree tag yet as it requires
 	 * pag_ici_lock to be held exclusive.
 	 */
-	ip->i_flags |= XFS_IRECLAIM;
+	ip->i_flags |= iflag;
 
 	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();
@@ -412,10 +455,13 @@ xfs_iget_recycle(
 		rcu_read_lock();
 		spin_lock(&ip->i_flags_lock);
 		wake = !!__xfs_iflags_test(ip, XFS_INEW);
-		ip->i_flags &= ~(XFS_INEW | XFS_IRECLAIM);
+		ip->i_flags &= ~(XFS_INEW | iflag);
 		if (wake)
 			wake_up_bit(&ip->i_flags, __XFS_INEW_BIT);
-		ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
+		if (iflag == XFS_IRECLAIM)
+			ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
+		if (iflag == XFS_INACTIVATING)
+			ASSERT(ip->i_flags & XFS_NEED_INACTIVE);
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
 		return error;
@@ -431,8 +477,7 @@ xfs_iget_recycle(
 	 */
 	ip->i_flags &= ~XFS_IRECLAIM_RESET_FLAGS;
 	ip->i_flags |= XFS_INEW;
-	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_RECLAIM_TAG);
+	xfs_perag_clear_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino), tag);
 	inode->i_state = I_NEW;
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -455,6 +500,13 @@ xfs_iget_check_free_state(
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
@@ -521,7 +573,7 @@ xfs_iget_cache_hit(
 	 *	     wait_on_inode to wait for these flags to be cleared
 	 *	     instead of polling for it.
 	 */
-	if (ip->i_flags & (XFS_INEW|XFS_IRECLAIM)) {
+	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING)) {
 		trace_xfs_iget_skip(ip);
 		XFS_STATS_INC(mp, xs_ig_frecycle);
 		error = -EAGAIN;
@@ -549,11 +601,29 @@ xfs_iget_cache_hit(
 		}
 
 		/* Drops i_flags_lock and RCU read lock. */
-		error = xfs_iget_recycle(pag, ip);
+		error = xfs_iget_recycle(pag, ip, XFS_IRECLAIM);
 		if (error) {
 			trace_xfs_iget_reclaim_fail(ip);
 			return error;
 		}
+	} else if (ip->i_flags & XFS_NEED_INACTIVE) {
+		/*
+		 * If NEED_INACTIVE is set, we've torn down the VFS inode
+		 * already, and must carefully restore it to usable state.
+		 */
+		trace_xfs_iget_inactive(ip);
+
+		if (flags & XFS_IGET_INCORE) {
+			error = -EAGAIN;
+			goto out_error;
+		}
+
+		/* Drops i_flags_lock and RCU read lock. */
+		error = xfs_iget_recycle(pag, ip, XFS_INACTIVATING);
+		if (error) {
+			trace_xfs_iget_inactive_fail(ip);
+			return error;
+		}
 	} else {
 		/* If the VFS inode is being torn down, pause and try again. */
 		if (!igrab(inode)) {
@@ -845,22 +915,33 @@ xfs_dqrele_igrab(
 
 	/*
 	 * Skip inodes that are anywhere in the reclaim machinery because we
-	 * drop dquots before tagging an inode for reclamation.
+	 * drop dquots before tagging an inode for reclamation.  If the inode
+	 * is being inactivated, skip it because inactivation will drop the
+	 * dquots for us.
 	 */
-	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE))
+	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE | XFS_INACTIVATING))
 		goto out_unlock;
 
 	/*
-	 * The inode looks alive; try to grab a VFS reference so that it won't
-	 * get destroyed.  If we got the reference, return true to say that
-	 * we grabbed the inode.
+	 * If the inode is queued but not undergoing inactivation, set the
+	 * inactivating flag so everyone will leave it alone and return true
+	 * to say that we are taking ownership of it.
+	 *
+	 * Otherwise, the inode looks alive; try to grab a VFS reference so
+	 * that it won't get destroyed.  If we got the reference, return true
+	 * to say that we grabbed the inode.
 	 *
 	 * If we can't get the reference, then we know the inode had its VFS
 	 * state torn down and hasn't yet entered the reclaim machinery.  Since
 	 * we also know that dquots are detached from an inode before it enters
 	 * reclaim, we can skip the inode.
 	 */
-	ret = igrab(VFS_I(ip)) != NULL;
+	if (ip->i_flags & XFS_NEED_INACTIVE) {
+		ip->i_flags |= XFS_INACTIVATING;
+		ret = true;
+	} else {
+		ret = igrab(VFS_I(ip)) != NULL;
+	}
 
 out_unlock:
 	spin_unlock(&ip->i_flags_lock);
@@ -873,6 +954,8 @@ xfs_dqrele_inode(
 	struct xfs_inode	*ip,
 	struct xfs_icwalk	*icw)
 {
+	bool			live_inode;
+
 	if (xfs_iflags_test(ip, XFS_INEW))
 		xfs_inew_wait(ip);
 
@@ -890,7 +973,19 @@ xfs_dqrele_inode(
 		ip->i_pdquot = NULL;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	xfs_irele(ip);
+
+	/*
+	 * If we set INACTIVATING earlier to prevent this inode from being
+	 * touched, clear that state to let the inodegc claim it.  Otherwise,
+	 * it's a live inode and we need to release it.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	live_inode = !(ip->i_flags & XFS_INACTIVATING);
+	ip->i_flags &= ~XFS_INACTIVATING;
+	spin_unlock(&ip->i_flags_lock);
+
+	if (live_inode)
+		xfs_irele(ip);
 }
 
 /*
@@ -999,6 +1094,7 @@ xfs_reclaim_inode(
 
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 reclaim:
+	trace_xfs_inode_reclaiming(ip);
 
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
@@ -1476,6 +1572,8 @@ xfs_blockgc_start(
 
 /* Don't try to run block gc on an inode that's in any of these states. */
 #define XFS_BLOCKGC_NOGRAB_IFLAGS	(XFS_INEW | \
+					 XFS_NEED_INACTIVE | \
+					 XFS_INACTIVATING | \
 					 XFS_IRECLAIMABLE | \
 					 XFS_IRECLAIM)
 /*
@@ -1636,6 +1734,229 @@ xfs_blockgc_free_quota(
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
+ *   - Increment the per-AG inactive count
+ *   - Set the ICI_INODEGC tag in the per-AG inode tree
+ *   - Set the ICI_INODEGC tag in the per-fs AG tree
+ *   - Schedule background inode inactivation
+ *
+ * If the inode does not need inactivation, we:
+ *   - Set the IRECLAIMABLE inode flag
+ *   - Increment the per-AG reclaim count
+ *   - Set the ICI_RECLAIM tag in the per-AG inode tree
+ *   - Set the ICI_RECLAIM tag in the per-fs AG tree
+ *   - Schedule background inode reclamation
+ *
+ * When it is time for background inode inactivation, we:
+ *   - Set the INACTIVATING inode flag
+ *   - Make all the on-disk updates
+ *   - Clear both INACTIVATING and NEED_INACTIVE inode flags
+ *   - Decrement the per-AG inactive count
+ *   - Clear the ICI_INODEGC tag in the per-AG inode tree
+ *   - Clear the ICI_INODEGC tag in the per-fs AG tree if we just inactivated
+ *     the last inode in the AG
+ *   - Kick the inode into reclamation per the previous paragraph
+ *
+ * When it is time for background inode reclamation, we:
+ *   - Set the IRECLAIM inode flag
+ *   - Detach all the resources and remove the inode from the per-AG inode tree
+ *   - Clear both IRECLAIM and RECLAIMABLE inode flags
+ *   - Decrement the per-AG reclaim count
+ *   - Clear the ICI_RECLAIM tag from the per-AG inode tree
+ *   - Clear the ICI_RECLAIM tag from the per-fs AG tree if we just reclaimed
+ *     the last inode in the AG
+ *
+ * When these state transitions occur, the caller must have taken the per-AG
+ * incore inode tree lock and then the inode i_flags lock, in that order.
+ */
+
+/*
+ * Decide if the given @ip is eligible for inactivation, and grab it if so.
+ * Returns true if it's ready to go or false if we should just ignore it.
+ */
+static bool
+xfs_inodegc_igrab(
+	struct xfs_inode	*ip)
+{
+	ASSERT(rcu_read_lock_held());
+
+	/* Check for stale RCU freed inode */
+	spin_lock(&ip->i_flags_lock);
+	if (!ip->i_ino)
+		goto out_unlock_noent;
+
+	/*
+	 * Skip inodes that don't need inactivation or are being inactivated
+	 * (or reactivated) by another thread.  Inodes should not be tagged
+	 * for inactivation while also in INEW or any reclaim state.
+	 */
+	if (!(ip->i_flags & XFS_NEED_INACTIVE) ||
+	    (ip->i_flags & XFS_INACTIVATING))
+		goto out_unlock_noent;
+
+	/*
+	 * Mark this inode as being inactivated even if the fs is shut down
+	 * because we need xfs_inodegc_inactivate to push this inode into the
+	 * reclaim state.
+	 */
+	ip->i_flags |= XFS_INACTIVATING;
+	spin_unlock(&ip->i_flags_lock);
+	return true;
+
+out_unlock_noent:
+	spin_unlock(&ip->i_flags_lock);
+	return false;
+}
+
+/*
+ * Free all speculative preallocations and possibly even the inode itself.
+ * This is the last chance to make changes to an otherwise unreferenced file
+ * before incore reclamation happens.
+ */
+static int
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
+	 * Move the inode from the inactivation phase to the reclamation phase
+	 * by clearing both inactivation inode state flags and marking the
+	 * inode reclaimable.  Schedule background reclaim to run later.
+	 */
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
+	ip->i_flags |= XFS_IRECLAIMABLE;
+
+	xfs_perag_clear_inode_tag(pag, agino, XFS_ICI_INODEGC_TAG);
+	xfs_perag_set_inode_tag(pag, agino, XFS_ICI_RECLAIM_TAG);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+
+	return 0;
+}
+
+/* Walk the fs and inactivate the inodes in them. */
+int
+xfs_inodegc_free_space(
+	struct xfs_mount	*mp,
+	struct xfs_icwalk	*icw)
+{
+	trace_xfs_inodegc_free_space(mp, icw, _RET_IP_);
+
+	return xfs_icwalk(mp, XFS_ICWALK_INODEGC, icw);
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
+	 * Queueing of this inodegc worker can race with xfs_inodegc_stop,
+	 * which means that we can be running after the opflag clears.  Double
+	 * check the flag state so that we don't trip asserts.
+	 */
+	if (!xfs_inodegc_running(mp))
+		return;
+
+	error = xfs_inodegc_free_space(mp, NULL);
+	if (error && error != -EAGAIN)
+		xfs_err(mp, "inode inactivation failed, error %d", error);
+
+	xfs_inodegc_queue(mp);
+}
+
+/* Force all currently queued inode inactivation work to run immediately. */
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_inodegc_running(mp) ||
+	    !radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INODEGC_TAG))
+		return;
+
+	mod_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work, 0);
+	flush_delayed_work(&mp->m_inodegc_work);
+}
+
+/* Stop all queued inactivation work. */
+void
+xfs_inodegc_stop(
+	struct xfs_mount	*mp)
+{
+	clear_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
+	cancel_delayed_work_sync(&mp->m_inodegc_work);
+}
+
+/* Schedule deferred inode inactivation work. */
+void
+xfs_inodegc_start(
+	struct xfs_mount	*mp)
+{
+	set_bit(XFS_OPFLAG_INODEGC_RUNNING_BIT, &mp->m_opflags);
+	xfs_inodegc_queue(mp);
+}
+
 /* XFS Inode Cache Walking Code */
 
 /*
@@ -1664,6 +1985,8 @@ xfs_icwalk_igrab(
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
 		return xfs_reclaim_igrab(ip, icw);
+	case XFS_ICWALK_INODEGC:
+		return xfs_inodegc_igrab(ip);
 	default:
 		return false;
 	}
@@ -1692,6 +2015,9 @@ xfs_icwalk_process_inode(
 	case XFS_ICWALK_RECLAIM:
 		xfs_reclaim_inode(ip, pag);
 		break;
+	case XFS_ICWALK_INODEGC:
+		error = xfs_inodegc_inactivate(ip, pag, icw);
+		break;
 	}
 	return error;
 }
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 00dc98a92835..d03d46f83316 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -52,7 +52,7 @@ void xfs_reclaim_inodes(struct xfs_mount *mp);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
-void xfs_inode_mark_reclaimable(struct xfs_inode *ip);
+void xfs_inode_mark_reclaimable(struct xfs_inode *ip, bool need_inactive);
 
 int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
@@ -80,4 +80,37 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
+void xfs_inodegc_worker(struct work_struct *work);
+void xfs_inodegc_flush(struct xfs_mount *mp);
+void xfs_inodegc_stop(struct xfs_mount *mp);
+void xfs_inodegc_start(struct xfs_mount *mp);
+int xfs_inodegc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icw);
+
+/*
+ * Process all pending inode inactivations immediately (sort of) so that a
+ * resource usage report will be mostly accurate with regards to files that
+ * have been unlinked recently.
+ *
+ * It isn't practical to maintain a count of the resources used by unlinked
+ * inodes to adjust the values reported by this function.  Resources that are
+ * shared (e.g. reflink) when an inode is queued for inactivation cannot be
+ * counted towards the adjustment, and cross referencing data extents with the
+ * refcount btree is the only way to decide if a resource is shared.  Worse,
+ * unsharing of any data blocks in the system requires either a second
+ * consultation with the refcount btree, or training users to deal with the
+ * free space counts possibly fluctuating upwards as inactivations occur.
+ *
+ * Hence we guard the inactivation flush with a ratelimiter so that the counts
+ * are not way out of whack while ignoring workloads that hammer us with statfs
+ * calls.  Once per clock tick seems frequent enough to avoid complaints about
+ * inaccurate counts.
+ */
+static inline void
+xfs_inodegc_summary_flush(
+	struct xfs_mount	*mp)
+{
+	if (__ratelimit(&mp->m_inodegc_ratelimit))
+		xfs_inodegc_flush(mp);
+}
+
 #endif
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3bee1cd20072..aa55a210a440 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1654,6 +1654,55 @@ xfs_inactive_ifree(
 	return 0;
 }
 
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
+	/* Want to clean out the cow blocks if there are any. */
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
@@ -1664,7 +1713,7 @@ xfs_inactive_ifree(
  */
 void
 xfs_inactive(
-	xfs_inode_t	*ip)
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp;
 	int			error;
@@ -1690,6 +1739,11 @@ xfs_inactive(
 	if (xfs_is_metadata_inode(ip))
 		goto out;
 
+	/* Ensure dquots are attached prior to making changes to this file. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		goto out;
+
 	/* Try to clean out the cow blocks if there are any. */
 	if (xfs_inode_has_cow_data(ip))
 		xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, true);
@@ -1715,10 +1769,6 @@ xfs_inactive(
 	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		goto out;
-
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 4b6703dbffb8..8d695b39bcdf 100644
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
@@ -248,6 +249,15 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
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
@@ -255,7 +265,8 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
+	 XFS_INACTIVATING)
 
 /*
  * Flags for inode locking.
@@ -493,6 +504,8 @@ extern struct kmem_zone	*xfs_inode_zone;
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
 
+bool xfs_inode_needs_inactivation(struct xfs_inode *ip);
+
 int xfs_iunlink_init(struct xfs_perag *pag);
 void xfs_iunlink_destroy(struct xfs_perag *pag);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1227503d2246..9d8fc85bd28d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2784,6 +2784,13 @@ xlog_recover_process_iunlinks(
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
index c3a96fb3ad80..fbbee8ac12f3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -516,6 +516,10 @@ xfs_check_summary_counts(
  * so we need to unpin them, write them back and/or reclaim them before unmount
  * can proceed.
  *
+ * The caller should start the process by flushing queued inactivation work so
+ * that all file updates to on-disk metadata can be flushed with the log.
+ * After the AIL push, all inodes should be ready for reclamation.
+ *
  * An inode cluster that has been freed can have its buffer still pinned in
  * memory because the transaction is still sitting in a iclog. The stale inodes
  * on that buffer will be pinned to the buffer until the transaction hits the
@@ -546,6 +550,7 @@ xfs_unmount_flush_inodes(
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
 
 	xfs_ail_push_all_sync(mp->m_ail);
+	xfs_inodegc_stop(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
@@ -782,6 +787,17 @@ xfs_mountfs(
 	if (error)
 		goto out_log_dealloc;
 
+	/*
+	 * Don't allow statfs to hammer us with inodegc flushes.  Once per
+	 * clock tick seems sufficient to avoid complaints about inaccurate
+	 * counter values.  Disable ratelimit logging.
+	 */
+	ratelimit_state_init(&mp->m_inodegc_ratelimit, 1, 1);
+	ratelimit_set_flags(&mp->m_inodegc_ratelimit, RATELIMIT_MSG_ON_RELEASE);
+
+	/* Enable background workers. */
+	xfs_inodegc_start(mp);
+
 	/*
 	 * Get and sanity-check the root inode.
 	 * Save the pointer to it in the mount structure.
@@ -937,9 +953,9 @@ xfs_mountfs(
 	/* Clean out dquots that might be in memory after quotacheck. */
 	xfs_qm_unmount(mp);
 	/*
-	 * Flush all inode reclamation work and flush the log.
-	 * We have to do this /after/ rtunmount and qm_unmount because those
-	 * two will have scheduled delayed reclaim for the rt/quota inodes.
+	 * Flush all inode reclamation work and flush inodes to the log.  Do
+	 * this after rtunmount and qm_unmount because those two will have
+	 * released the rt and quota inodes.
 	 *
 	 * This is slightly different from the unmountfs call sequence
 	 * because we could be tearing down a partially set up mount.  In
@@ -947,6 +963,7 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
+	xfs_inodegc_flush(mp);
 	xfs_unmount_flush_inodes(mp);
  out_log_dealloc:
 	xfs_log_mount_cancel(mp);
@@ -983,6 +1000,12 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
+	/*
+	 * Flush all the queued inode inactivation work to disk before tearing
+	 * down rt metadata and quotas.
+	 */
+	xfs_inodegc_flush(mp);
+
 	xfs_blockgc_stop(mp);
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c78b63fe779a..04a016a46dc8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -154,6 +154,8 @@ typedef struct xfs_mount {
 	uint8_t			m_rt_checked;
 	uint8_t			m_rt_sick;
 
+	unsigned long		m_opflags;
+
 	/*
 	 * End of read-mostly variables. Frequently written variables and locks
 	 * should be placed below this comment from now on. The first variable
@@ -184,6 +186,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
+	struct delayed_work	m_inodegc_work; /* background inode inactive */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
@@ -220,6 +223,7 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+	struct ratelimit_state	m_inodegc_ratelimit;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
@@ -258,6 +262,9 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
 #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
 
+#define XFS_OPFLAG_INODEGC_RUNNING_BIT	(0)	/* are we allowed to start the
+						   inode inactivation worker? */
+
 /*
  * Max and min values for mount-option defined I/O
  * preallocation sizes.
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 13a56e1ea15c..137f9486ac6a 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -698,6 +698,8 @@ xfs_qm_scall_getquota(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	xfs_inodegc_summary_flush(mp);
+
 	/*
 	 * Try to get the dquot. We don't want it allocated on disk, so don't
 	 * set doalloc. If it doesn't exist, we'll get ENOENT back.
@@ -736,6 +738,8 @@ xfs_qm_scall_getquota_next(
 	struct xfs_dquot	*dqp;
 	int			error;
 
+	xfs_inodegc_summary_flush(mp);
+
 	error = xfs_qm_dqget_next(mp, *id, type, &dqp);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3a7fd4f02aa7..120a4426fd64 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -629,6 +629,43 @@ xfs_check_delalloc(
 #define xfs_check_delalloc(ip, whichfork)	do { } while (0)
 #endif
 
+#ifdef CONFIG_XFS_QUOTA
+/*
+ * If a quota type is turned off but we still have a dquot attached to the
+ * inode, detach it before tagging this inode for inactivation (or reclaim) to
+ * avoid delaying quotaoff for longer than is necessary.  Because the inode has
+ * no VFS state and has not yet been tagged for reclaim or inactivation, it is
+ * safe to drop the dquots locklessly because iget, quotaoff, blockgc, and
+ * reclaim will not touch the inode.
+ */
+static inline void
+xfs_fs_dqdestroy_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!XFS_IS_UQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_udquot);
+		ip->i_udquot = NULL;
+	}
+	if (!XFS_IS_GQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_gdquot);
+		ip->i_gdquot = NULL;
+	}
+	if (!XFS_IS_PQUOTA_ON(mp)) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
+}
+#else
+# define xfs_fs_dqdestroy_inode(ip)		((void)0)
+#endif
+
+/* iflags that we shouldn't see before scheduling reclaim or inactivation. */
+#define XFS_IDESTROY_BAD_IFLAGS	(XFS_IRECLAIMABLE | \
+				 XFS_IRECLAIM | \
+				 XFS_NEED_INACTIVE | \
+				 XFS_INACTIVATING)
 /*
  * Now that the generic code is guaranteed not to be accessing
  * the linux inode, we can inactivate and reclaim the inode.
@@ -638,28 +675,44 @@ xfs_fs_destroy_inode(
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
+	need_inactive = xfs_inode_needs_inactivation(ip);
+	if (!need_inactive) {
+		/*
+		 * If the inode doesn't need inactivation, that means we're
+		 * going directly into reclaim and can drop the dquots.  It
+		 * also means that there shouldn't be any delalloc reservations
+		 * or speculative CoW preallocations remaining.
+		 */
+		xfs_qm_dqdetach(ip);
 
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
-		xfs_check_delalloc(ip, XFS_DATA_FORK);
-		xfs_check_delalloc(ip, XFS_COW_FORK);
-		ASSERT(0);
+		if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
+			xfs_check_delalloc(ip, XFS_DATA_FORK);
+			xfs_check_delalloc(ip, XFS_COW_FORK);
+			ASSERT(0);
+		}
+	} else {
+		/*
+		 * Drop dquots for disabled quota types to avoid delaying
+		 * quotaoff while we wait for inactivation to occur.
+		 */
+		xfs_fs_dqdestroy_inode(ip);
 	}
 
-	XFS_STATS_INC(ip->i_mount, vn_reclaim);
+	XFS_STATS_INC(mp, vn_reclaim);
 
 	/*
-	 * We should never get here with one of the reclaim flags already set.
+	 * We should never get here with any of the reclaim flags already set.
 	 */
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IDESTROY_BAD_IFLAGS));
 
 	/*
 	 * We always use background reclaim here because even if the inode is
@@ -668,7 +721,7 @@ xfs_fs_destroy_inode(
 	 * reclaim path handles this more efficiently than we can here, so
 	 * simply let background reclaim tear down all inodes.
 	 */
-	xfs_inode_mark_reclaimable(ip);
+	xfs_inode_mark_reclaimable(ip, need_inactive);
 }
 
 static void
@@ -780,6 +833,21 @@ xfs_fs_sync_fs(
 		flush_delayed_work(&mp->m_log->l_work);
 	}
 
+	/*
+	 * If the fs is at FREEZE_PAGEFAULTS, that means the VFS holds the
+	 * umount mutex and is syncing the filesystem just before setting the
+	 * state to FREEZE_FS.  We are not allowed to run transactions on a
+	 * filesystem that is in FREEZE_FS state, so deactivate the background
+	 * workers before we get there, and leave them off for the duration of
+	 * the freeze.
+	 *
+	 * We can't do this in xfs_fs_freeze_super because freeze_super takes
+	 * s_umount, which means we can't lock out a concurrent thaw request
+	 * without adding another layer of locks to the freeze process.
+	 */
+	if (sb->s_writers.frozen == SB_FREEZE_PAGEFAULT)
+		xfs_inodegc_stop(mp);
+
 	return 0;
 }
 
@@ -798,6 +866,8 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
+	xfs_inodegc_summary_flush(mp);
+
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
 
@@ -908,10 +978,27 @@ xfs_fs_unfreeze(
 
 	xfs_restore_resvblks(mp);
 	xfs_log_work_queue(mp);
+	xfs_inodegc_start(mp);
 	xfs_blockgc_start(mp);
 	return 0;
 }
 
+STATIC int
+xfs_fs_freeze_super(
+	struct super_block	*sb)
+{
+	struct xfs_mount	*mp = XFS_M(sb);
+
+	/*
+	 * Before we take s_umount to get to FREEZE_WRITE, flush all the
+	 * accumulated background work so that there's less recovery work
+	 * to do if we crash during the freeze.
+	 */
+	xfs_inodegc_flush(mp);
+
+	return freeze_super(sb);
+}
+
 /*
  * This function fills in xfs_mount_t fields based on mount args.
  * Note: the superblock _has_ now been read in.
@@ -1090,6 +1177,7 @@ static const struct super_operations xfs_super_operations = {
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.freeze_super		= xfs_fs_freeze_super,
 };
 
 static int
@@ -1737,6 +1825,13 @@ xfs_remount_ro(
 		return error;
 	}
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes.
+	 * Since this can involve finobt updates, do it now before we lose the
+	 * per-AG space reservations to guarantee that we won't fail there.
+	 */
+	xfs_inodegc_flush(mp);
+
 	/* Free the per-AG metadata reservation pool. */
 	error = xfs_fs_unreserve_ag_blocks(mp);
 	if (error) {
@@ -1860,6 +1955,7 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
+	INIT_DELAYED_WORK(&mp->m_inodegc_work, xfs_inodegc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a10612155377..49d09b1571d6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -615,14 +615,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
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
@@ -632,6 +635,8 @@ DEFINE_EVENT(xfs_inode_class, name, \
 DEFINE_INODE_EVENT(xfs_iget_skip);
 DEFINE_INODE_EVENT(xfs_iget_reclaim);
 DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
+DEFINE_INODE_EVENT(xfs_iget_inactive);
+DEFINE_INODE_EVENT(xfs_iget_inactive_fail);
 DEFINE_INODE_EVENT(xfs_iget_hit);
 DEFINE_INODE_EVENT(xfs_iget_miss);
 
@@ -666,6 +671,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
+DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
+DEFINE_INODE_EVENT(xfs_inode_reclaiming);
+DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
+DEFINE_INODE_EVENT(xfs_inode_inactivating);
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -3928,6 +3937,7 @@ DEFINE_EVENT(xfs_icwalk_class, name,	\
 	TP_ARGS(mp, icw, caller_ip))
 DEFINE_ICWALK_EVENT(xfs_ioc_free_eofblocks);
 DEFINE_ICWALK_EVENT(xfs_blockgc_free_space);
+DEFINE_ICWALK_EVENT(xfs_inodegc_free_space);
 
 #endif /* _TRACE_XFS_H */
 

