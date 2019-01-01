Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:36544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfAACRs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:17:48 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012GwC4174951
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:42 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2pp1jqx417-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:17:42 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012Hffn002588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:41 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012HfO3026170
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:17:41 GMT
Subject: [PATCH 08/12] xfs: deferred inode inactivation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:17:40 -0800
Message-ID: <154630906001.16693.6052815050833817937.stgit@magnolia>
In-Reply-To: <154630901076.16693.13111277988041606505.stgit@magnolia>
References: <154630901076.16693.13111277988041606505.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

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

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_icache.c      |  309 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h      |    8 +
 fs/xfs/xfs_inode.c       |   70 ++++++++++
 fs/xfs/xfs_inode.h       |   15 ++
 fs/xfs/xfs_iomap.c       |    1 
 fs/xfs/xfs_log_recover.c |    7 +
 fs/xfs/xfs_mount.c       |   16 ++
 fs/xfs/xfs_mount.h       |    5 +
 fs/xfs/xfs_qm_syscalls.c |    6 +
 fs/xfs/xfs_super.c       |   59 +++++++--
 fs/xfs/xfs_trace.h       |   11 +-
 11 files changed, 479 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index c1b457ba1b7b..2386a2f3e1d0 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -225,6 +225,19 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
+/* Queue a new inode inactivation pass if there are reclaimable inodes. */
+static void
+xfs_inactive_work_queue(
+	struct xfs_mount        *mp)
+{
+	rcu_read_lock();
+	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG))
+		queue_delayed_work(mp->m_inactive_workqueue,
+				&mp->m_inactive_work,
+				msecs_to_jiffies(xfs_syncd_centisecs / 6 * 10));
+	rcu_read_unlock();
+}
+
 /*
  * This is a fast pass over the inode cache to try to get reclaim moving on as
  * many inodes as possible in a short period of time. It kicks itself every few
@@ -243,9 +256,85 @@ xfs_reclaim_worker(
 	xfs_reclaim_work_queue(mp);
 }
 
+/*
+ * Set the per-ag "inodes awaiting inactivation" tag.  This isn't a real tag;
+ * we overload the RECLAIM tag to cover both inactive and reclaimable inodes.
+ * We maintain separate perag counters for both types, and move counts as inodes
+ * wander the state machine.
+ *
+ * When an inode hits zero refcount, we:
+ *   - Set the RECLAIMABLE inode flag
+ *   - Set the RECLAIM tag in the per-AG inode tree
+ *   - Set the RECLAIM tag in the per-fs AG tree
+ *
+ * If the inode needs inactivation, we:
+ *   - Set the NEED_INACTIVE inode flag
+ *   - Increment the per-AG inactive count
+ *   - Schedule background inode inactivation
+ *
+ * If the inode did not need inactivation, we:
+ *   - Increment the per-AG reclaim count
+ *   - Schedule background inode reclamation
+ *
+ * When it is time for background inode inactivation, we:
+ *   - Set the INACTIVATING inode flag
+ *   - Make all the on-disk updates
+ *   - Clear both INACTIVATING and NEED_INACTIVE inode flags
+ *   - Decrement the per-AG inactive count
+ *   - Increment the per-AG reclaim count
+ *   - Schedule background inode reclamation
+ *
+ * When it is time for background inode reclamation, we:
+ *   - Set the IRECLAIM inode flag
+ *   - Detach all the resources and remove the inode from the per-AG inode tree
+ *   - Clear both IRECLAIM and RECLAIMABLE inode flags
+ *   - Decrement the per-AG reclaim count
+ *   - Clear the RECLAIM tag from the per-AG inode tree
+ *   - Clear the RECLAIM tag from the per-fs AG tree if there are no more
+ *     inodes waiting for reclamation or inactivation
+ */
 static void
-xfs_perag_set_reclaim_tag(
+xfs_perag_set_inactive_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	lockdep_assert_held(&pag->pag_ici_lock);
+	if (pag->pag_ici_inactive++ == 0) {
+		/* propagate the reclaim tag up into the perag radix tree */
+		spin_lock(&mp->m_perag_lock);
+		radix_tree_tag_set(&mp->m_perag_tree, pag->pag_agno,
+				   XFS_ICI_RECLAIM_TAG);
+		spin_unlock(&mp->m_perag_lock);
+	}
+
+	/*
+	 * Schedule periodic background inode inactivation.  Inactivation can
+	 * take a while, so we allow the deferral of an already-scheduled
+	 * inactivation on the grounds that xfs_fs_destroy_inode has a better
+	 * idea of when it ought to force inactivation, and in the mean time
+	 * we prefer batching.
+	 */
+	xfs_inactive_work_queue(mp);
+
+	trace_xfs_perag_set_reclaim(mp, pag->pag_agno, -1, _RET_IP_);
+}
+
+/* Move an inode from inactive to reclaim. */
+static void
+xfs_perag_clear_inactive_tag(
 	struct xfs_perag	*pag)
+{
+	lockdep_assert_held(&pag->pag_ici_lock);
+	pag->pag_ici_inactive--;
+	pag->pag_ici_reclaimable++;
+}
+
+static void
+xfs_perag_set_reclaim_tag(
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 
@@ -272,7 +361,7 @@ xfs_perag_clear_reclaim_tag(
 	struct xfs_mount	*mp = pag->pag_mount;
 
 	lockdep_assert_held(&pag->pag_ici_lock);
-	if (--pag->pag_ici_reclaimable)
+	if (--pag->pag_ici_reclaimable || pag->pag_ici_inactive > 0)
 		return;
 
 	/* clear the reclaim tag from the perag radix tree */
@@ -291,10 +380,12 @@ xfs_perag_clear_reclaim_tag(
  */
 void
 xfs_inode_set_reclaim_tag(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	bool			need_inactive)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
+	unsigned long		iflags = need_inactive ? XFS_NEED_INACTIVE : 0;
 
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
 	spin_lock(&pag->pag_ici_lock);
@@ -302,8 +393,11 @@ xfs_inode_set_reclaim_tag(
 
 	radix_tree_tag_set(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, ip->i_ino),
 			   XFS_ICI_RECLAIM_TAG);
-	xfs_perag_set_reclaim_tag(pag);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	if (need_inactive)
+		xfs_perag_set_inactive_tag(pag, ip);
+	else
+		xfs_perag_set_reclaim_tag(pag, ip);
+	__xfs_iflags_set(ip, XFS_IRECLAIMABLE | iflags);
 
 	spin_unlock(&ip->i_flags_lock);
 	spin_unlock(&pag->pag_ici_lock);
@@ -382,6 +476,13 @@ xfs_iget_check_free_state(
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
@@ -441,14 +542,14 @@ xfs_iget_cache_hit(
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
@@ -468,6 +569,8 @@ xfs_iget_cache_hit(
 	 * Need to carefully get it back into useable state.
 	 */
 	if (ip->i_flags & XFS_IRECLAIMABLE) {
+		bool	needed_inactive;
+
 		trace_xfs_iget_reclaim(ip);
 
 		if (flags & XFS_IGET_INCORE) {
@@ -475,17 +578,34 @@ xfs_iget_cache_hit(
 			goto out_error;
 		}
 
+		/*
+		 * If we played inactivation accounting tricks with this inode
+		 * we have to undo them prior to resurrecting this inode.
+		 */
+		needed_inactive = (ip->i_flags & XFS_NEED_INACTIVE);
+
 		/*
 		 * We need to set XFS_IRECLAIM to prevent xfs_reclaim_inode
 		 * from stomping over us while we recycle the inode.  We can't
 		 * clear the radix tree reclaimable tag yet as it requires
 		 * pag_ici_lock to be held exclusive.
+		 *
+		 * Clear NEED_INACTIVE so that the inactive worker won't
+		 * touch this inode now that we're trying to resurrect it.
 		 */
 		ip->i_flags |= XFS_IRECLAIM;
+		ip->i_flags &= ~XFS_NEED_INACTIVE;
 
 		spin_unlock(&ip->i_flags_lock);
 		rcu_read_unlock();
 
+		if (needed_inactive) {
+			xfs_inode_inactivation_cleanup(ip);
+			spin_lock(&pag->pag_ici_lock);
+			xfs_perag_clear_inactive_tag(pag);
+			spin_unlock(&pag->pag_ici_lock);
+		}
+
 		error = xfs_reinit_inode(mp, inode);
 		if (error) {
 			bool wake;
@@ -1079,6 +1199,7 @@ xfs_inode_ag_iterator_tag(
 STATIC bool
 xfs_reclaim_inode_grab(
 	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb,
 	int			flags)
 {
 	ASSERT(rcu_read_lock_held());
@@ -1108,7 +1229,8 @@ xfs_reclaim_inode_grab(
 	 */
 	spin_lock(&ip->i_flags_lock);
 	if (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) ||
-	    __xfs_iflags_test(ip, XFS_IRECLAIM)) {
+	    __xfs_iflags_test(ip, XFS_IRECLAIM) ||
+	    __xfs_iflags_test(ip, XFS_NEED_INACTIVE)) {
 		/* not a reclaim candidate. */
 		spin_unlock(&ip->i_flags_lock);
 		return false;
@@ -1167,6 +1289,8 @@ xfs_reclaim_inode(
 	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
 	int			error;
 
+	trace_xfs_inode_reclaiming(ip);
+
 restart:
 	error = 0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
@@ -1299,8 +1423,10 @@ xfs_reclaim_inode(
 STATIC int
 xfs_walk_ag_reclaim_inos(
 	struct xfs_perag	*pag,
+	struct xfs_eofblocks	*eofb,
 	int			sync_flags,
 	bool			(*grab_fn)(struct xfs_inode *ip,
+					   struct xfs_eofblocks *eofb,
 					   int sync_flags),
 	int			(*execute_fn)(struct xfs_inode *ip,
 					      struct xfs_perag *pag,
@@ -1335,7 +1461,7 @@ xfs_walk_ag_reclaim_inos(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (*done || !grab_fn(ip, sync_flags))
+			if (*done || !grab_fn(ip, eofb, sync_flags))
 				batch[i] = NULL;
 
 			/*
@@ -1415,7 +1541,7 @@ xfs_reclaim_inodes_ag(
 		} else
 			mutex_lock(&pag->pag_ici_reclaim_lock);
 
-		error = xfs_walk_ag_reclaim_inos(pag, flags,
+		error = xfs_walk_ag_reclaim_inos(pag, NULL, flags,
 				xfs_reclaim_inode_grab, xfs_reclaim_inode,
 				nr_to_scan, &done);
 		if (error && last_error != -EFSCORRUPTED)
@@ -1494,6 +1620,161 @@ xfs_reclaim_inodes_count(
 	return reclaimable;
 }
 
+/*
+ * Grab the inode for inactivation exclusively.
+ * Return true if we grabbed it.
+ */
+STATIC bool
+xfs_inactive_inode_grab(
+	struct xfs_inode	*ip,
+	struct xfs_eofblocks	*eofb,
+	int			sync_flags)
+{
+	ASSERT(rcu_read_lock_held());
+
+	/* quick check for stale RCU freed inode */
+	if (!ip->i_ino)
+		return false;
+
+	/*
+	 * The radix tree lock here protects a thread in xfs_iget from racing
+	 * with us starting reclaim on the inode.
+	 *
+	 * Due to RCU lookup, we may find inodes that have been freed and only
+	 * have XFS_IRECLAIM set.  Indeed, we may see reallocated inodes that
+	 * aren't candidates for reclaim at all, so we must check the
+	 * XFS_IRECLAIMABLE is set first before proceeding to reclaim.
+	 * Obviously if XFS_NEED_INACTIVE isn't set then we ignore this inode.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (!(ip->i_flags & XFS_IRECLAIMABLE) ||
+	    !(ip->i_flags & XFS_NEED_INACTIVE) ||
+	    (ip->i_flags & XFS_INACTIVATING)) {
+		/* not a inactivation candidate. */
+		spin_unlock(&ip->i_flags_lock);
+		return false;
+	}
+
+	if (!xfs_inode_matches_eofb(ip, eofb)) {
+		spin_unlock(&ip->i_flags_lock);
+		return false;
+	}
+
+	ip->i_flags |= XFS_INACTIVATING;
+	spin_unlock(&ip->i_flags_lock);
+	return true;
+}
+
+/* Inactivate this inode. */
+STATIC int
+xfs_inactive_inode(
+	struct xfs_inode	*ip,
+	struct xfs_perag	*pag,
+	int			sync_flags)
+{
+	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);
+
+	trace_xfs_inode_inactivating(ip);
+
+	/* Update metadata prior to freeing inode. */
+	xfs_inode_inactivation_cleanup(ip);
+	xfs_inactive(ip);
+	ASSERT(XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0);
+	spin_lock(&pag->pag_ici_lock);
+	xfs_perag_clear_inactive_tag(pag);
+	spin_unlock(&pag->pag_ici_lock);
+
+	/* Kick the inactive inode to reclaim now that we've made updates. */
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
+	ASSERT(ip->i_flags & XFS_IRECLAIMABLE);
+	xfs_reclaim_work_queue(ip->i_mount);
+	spin_unlock(&ip->i_flags_lock);
+	return 0;
+}
+
+/*
+ * Walk the AGs and reclaim the inodes in them. Even if the filesystem is
+ * corrupted, we still need to clear the INACTIVE iflag so that we can move
+ * on to reclaiming the inode.
+ */
+int
+xfs_inactive_inodes(
+	struct xfs_mount	*mp,
+	struct xfs_eofblocks	*eofb)
+{
+	struct xfs_perag	*pag;
+	xfs_agnumber_t		agno;
+	int			last_error = 0;
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
+		return -EAGAIN;
+
+	agno = 0;
+	while ((pag = xfs_perag_get_tag(mp, agno, XFS_ICI_RECLAIM_TAG))) {
+		int		nr_to_scan = INT_MAX;
+		bool		done = false;
+
+		agno = pag->pag_agno + 1;
+		error = xfs_walk_ag_reclaim_inos(pag, eofb, 0,
+				xfs_inactive_inode_grab, xfs_inactive_inode,
+				&nr_to_scan, &done);
+		if (error && last_error != -EFSCORRUPTED)
+			last_error = error;
+		xfs_perag_put(pag);
+	}
+
+	sb_end_write(mp->m_super);
+	return last_error;
+}
+
+/* Try to get inode inactivation moving. */
+void
+xfs_inactive_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_inactive_work);
+	int			error;
+
+	error = xfs_inactive_inodes(mp, NULL);
+	if (error && error != -EAGAIN)
+		xfs_err(mp, "inode inactivation failed, error %d", error);
+	xfs_inactive_work_queue(mp);
+}
+
+/* Flush all inode inactivation work that might be queued. */
+void
+xfs_inactive_force(
+	struct xfs_mount	*mp)
+{
+	queue_delayed_work(mp->m_inactive_workqueue, &mp->m_inactive_work, 0);
+	flush_delayed_work(&mp->m_inactive_work);
+}
+
+/*
+ * Flush all inode inactivation work that might be queued and make sure the
+ * delayed work item is not queued.
+ */
+void
+xfs_inactive_deactivate(
+	struct xfs_mount	*mp)
+{
+	cancel_delayed_work_sync(&mp->m_inactive_work);
+	flush_workqueue(mp->m_inactive_workqueue);
+	xfs_inactive_inodes(mp, NULL);
+}
+
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
@@ -1608,6 +1889,14 @@ __xfs_inode_free_quota_eofblocks(
 	return scan;
 }
 
+/* Flush any inode with the same quota as this inode. */
+int
+xfs_inactive_free_quota(
+	struct xfs_inode	*ip)
+{
+	return __xfs_inode_free_quota_eofblocks(ip, xfs_inactive_inodes);
+}
+
 int
 xfs_inode_free_quota_eofblocks(
 	struct xfs_inode *ip)
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 26c0626f1f75..fd4073debd6e 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -55,7 +55,7 @@ int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
-void xfs_inode_set_reclaim_tag(struct xfs_inode *ip);
+void xfs_inode_set_reclaim_tag(struct xfs_inode *ip, bool need_inactive);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
@@ -122,4 +122,10 @@ int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_icache_disable_reclaim(struct xfs_mount *mp);
 void xfs_icache_enable_reclaim(struct xfs_mount *mp);
 
+void xfs_inactive_worker(struct work_struct *work);
+int xfs_inactive_inodes(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
+void xfs_inactive_force(struct xfs_mount *mp);
+void xfs_inactive_deactivate(struct xfs_mount *mp);
+int xfs_inactive_free_quota(struct xfs_inode *ip);
+
 #endif
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 78c88a8c947a..26c8181f5760 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1842,6 +1842,62 @@ xfs_inode_iadjust(
 	xfs_qm_iadjust(ip, direction, inodes, dblocks, rblocks);
 }
 
+/* Clean up inode inactivation. */
+void
+xfs_inode_inactivation_cleanup(
+	struct xfs_inode	*ip)
+{
+	int			ret;
+
+	/*
+	 * Undo the pending-inactivation counter updates since we're bringing
+	 * this inode back to life.
+	 */
+	ret = xfs_qm_dqattach(ip);
+	if (ret)
+		xfs_err(ip->i_mount, "error %d reactivating inode quota", ret);
+
+	xfs_inode_iadjust(ip, -1);
+}
+
+/* Prepare inode for inactivation. */
+void
+xfs_inode_inactivation_prep(
+	struct xfs_inode	*ip)
+{
+	int			ret;
+
+	/*
+	 * If this inode is unlinked (and now unreferenced) we need to dispose
+	 * of it in the on disk metadata.
+	 *
+	 * Bump generation so that the inode can't be opened by handle now that
+	 * the last external references has dropped.  Bulkstat won't return
+	 * inodes with zero nlink so nobody will ever find this inode again.
+	 * Then add this inode & blocks to the counts of things that will be
+	 * freed during the next inactivation run.
+	 */
+	if (VFS_I(ip)->i_nlink == 0)
+		VFS_I(ip)->i_generation++;
+
+	/*
+	 * Increase the pending-inactivation counters so that the fs looks like
+	 * it's free.
+	 */
+	ret = xfs_qm_dqattach(ip);
+	if (ret)
+		xfs_err(ip->i_mount, "error %d inactivating inode quota", ret);
+
+	xfs_inode_iadjust(ip, 1);
+
+	/*
+	 * Detach dquots just in case someone tries a quotaoff while
+	 * the inode is waiting on the inactive list.  We'll reattach
+	 * them (if needed) when inactivating the inode.
+	 */
+	xfs_qm_dqdetach(ip);
+}
+
 /*
  * Returns true if we need to update the on-disk metadata before we can free
  * the memory used by this inode.  Updates include freeing post-eof
@@ -1926,6 +1982,16 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
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
@@ -1951,10 +2017,6 @@ xfs_inactive(
 	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
-	error = xfs_qm_dqattach(ip);
-	if (error)
-		return;
-
 	if (S_ISLNK(VFS_I(ip)->i_mode))
 		error = xfs_inactive_symlink(ip);
 	else if (truncate)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c7d638aaec1b..e95e30a94243 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -214,6 +214,7 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
 #define XFS_IRECLAIMABLE	(1 << 2) /* inode can be reclaimed */
 #define __XFS_INEW_BIT		3	 /* inode has just been allocated */
 #define XFS_INEW		(1 << __XFS_INEW_BIT)
+#define XFS_NEED_INACTIVE	(1 << 4) /* see XFS_INACTIVATING below */
 #define XFS_ITRUNCATED		(1 << 5) /* truncated down so flush-on-close */
 #define XFS_IDIRTY_RELEASE	(1 << 6) /* dirty release already seen */
 #define __XFS_IFLOCK_BIT	7	 /* inode is being flushed right now */
@@ -230,6 +231,15 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
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
@@ -237,7 +247,8 @@ static inline bool xfs_inode_has_cow_data(struct xfs_inode *ip)
  */
 #define XFS_IRECLAIM_RESET_FLAGS	\
 	(XFS_IRECLAIMABLE | XFS_IRECLAIM | \
-	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED)
+	 XFS_IDIRTY_RELEASE | XFS_ITRUNCATED | XFS_NEED_INACTIVE | \
+	 XFS_INACTIVATING)
 
 /*
  * Synchronize processes attempting to flush the in-core inode back to disk.
@@ -501,5 +512,7 @@ extern struct kmem_zone	*xfs_inode_zone;
 bool xfs_inode_verify_forks(struct xfs_inode *ip);
 bool xfs_inode_has_posteof_blocks(struct xfs_inode *ip);
 bool xfs_inode_needs_inactivation(struct xfs_inode *ip);
+void xfs_inode_inactivation_prep(struct xfs_inode *ip);
+void xfs_inode_inactivation_cleanup(struct xfs_inode *ip);
 
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 27c93b5f029d..59772a7c7586 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -449,6 +449,7 @@ xfs_iomap_prealloc_size(
 				       alloc_blocks);
 
 	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
+	freesp += percpu_counter_read_positive(&mp->m_dinactive);
 	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
 		shift = 2;
 		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ff9a27834c50..0f432bc33826 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5162,6 +5162,13 @@ xlog_recover_process_iunlinks(
 		}
 		xfs_buf_rele(agibp);
 	}
+
+	/*
+	 * Now that we've put all the iunlink inodes on the lru, let's make
+	 * sure that we perform all the on-disk metadata updates to actually
+	 * free those inodes.
+	 */
+	xfs_inactive_force(mp);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 10be706ec72e..6d629e1379a0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1066,6 +1066,7 @@ xfs_mountfs(
 	 * qm_unmount_quotas and therefore rely on qm_unmount to release the
 	 * quota inodes.
 	 */
+	xfs_inactive_deactivate(mp);
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
  out_log_dealloc:
@@ -1104,7 +1105,15 @@ xfs_unmountfs(
 	uint64_t		resblks;
 	int			error;
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes.
+	 * Since this can involve finobt updates, do it now before we lose the
+	 * per-AG space reservations.
+	 */
+	xfs_inactive_force(mp);
+
 	xfs_icache_disable_reclaim(mp);
+
 	xfs_fs_unreserve_ag_blocks(mp);
 	xfs_qm_unmount_quotas(mp);
 	xfs_rtunmount_inodes(mp);
@@ -1153,6 +1162,13 @@ xfs_unmountfs(
 
 	xfs_qm_unmount(mp);
 
+	/*
+	 * Kick off inode inactivation again to push the metadata inodes past
+	 * INACTIVE into RECLAIM.  We also have to deactivate the inactivation
+	 * worker.
+	 */
+	xfs_inactive_deactivate(mp);
+
 	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ff1a94b633cf..91391fd43e87 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -153,6 +153,7 @@ typedef struct xfs_mount {
 						     trimming */
 	struct delayed_work	m_cowblocks_work; /* background cow blocks
 						     trimming */
+	struct delayed_work	m_inactive_work; /* background inode inactive */
 	bool			m_update_sb;	/* sb needs update in mount */
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
@@ -167,6 +168,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
+	struct workqueue_struct	*m_inactive_workqueue;
 	struct workqueue_struct	*m_log_workqueue;
 	struct workqueue_struct *m_eofblocks_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
@@ -372,7 +374,8 @@ typedef struct xfs_perag {
 
 	spinlock_t	pag_ici_lock;	/* incore inode cache lock */
 	struct radix_tree_root pag_ici_root;	/* incore inode cache root */
-	int		pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned int	pag_ici_reclaimable;	/* reclaimable inodes */
+	unsigned int	pag_ici_inactive;	/* inactive inodes */
 	struct mutex	pag_ici_reclaim_lock;	/* serialisation point */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index ba058b8da8a8..d96f146e3fe6 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -47,6 +47,12 @@ xfs_qm_scall_quotaoff(
 	uint			inactivate_flags;
 	xfs_qoff_logitem_t	*qoffstart;
 
+	/*
+	 * Clean up the inactive list before we turn quota off, to reduce the
+	 * amount of quotaoff work we have to do with the mutex held.
+	 */
+	xfs_inactive_force(mp);
+
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
 	 * Note that quota utilities (like quotaoff) _expect_
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 24eb35b8fe5a..aa10df744a2a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -874,8 +874,15 @@ xfs_init_mount_workqueues(
 	if (!mp->m_sync_workqueue)
 		goto out_destroy_eofb;
 
+	mp->m_inactive_workqueue = alloc_workqueue("xfs-inactive/%s",
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+	if (!mp->m_inactive_workqueue)
+		goto out_destroy_sync;
+
 	return 0;
 
+out_destroy_sync:
+	destroy_workqueue(mp->m_inactive_workqueue);
 out_destroy_eofb:
 	destroy_workqueue(mp->m_eofblocks_workqueue);
 out_destroy_log:
@@ -898,6 +905,7 @@ STATIC void
 xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
+	destroy_workqueue(mp->m_inactive_workqueue);
 	destroy_workqueue(mp->m_sync_workqueue);
 	destroy_workqueue(mp->m_eofblocks_workqueue);
 	destroy_workqueue(mp->m_log_workqueue);
@@ -970,28 +978,34 @@ xfs_fs_destroy_inode(
 	struct inode		*inode)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			need_inactive;
 
 	trace_xfs_destroy_inode(ip);
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
-	XFS_STATS_INC(ip->i_mount, vn_rele);
-	XFS_STATS_INC(ip->i_mount, vn_remove);
-
-	xfs_inactive(ip);
-
-	if (!XFS_FORCED_SHUTDOWN(ip->i_mount) && ip->i_delayed_blks) {
+	XFS_STATS_INC(mp, vn_rele);
+	XFS_STATS_INC(mp, vn_remove);
+
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
 	 * We always use background reclaim here because even if the
@@ -1000,7 +1014,7 @@ xfs_fs_destroy_inode(
 	 * this more efficiently than we can here, so simply let background
 	 * reclaim tear down all inodes.
 	 */
-	xfs_inode_set_reclaim_tag(ip);
+	xfs_inode_set_reclaim_tag(ip, need_inactive);
 }
 
 static void
@@ -1252,6 +1266,12 @@ xfs_quiesce_attr(
 	while (atomic_read(&mp->m_active_trans) > 0)
 		delay(100);
 
+	/*
+	 * Perform all on-disk metadata updates required to inactivate inodes.
+	 * This has to be done before we force the log out.
+	 */
+	xfs_inactive_deactivate(mp);
+
 	/* force the log to unpin objects from the now complete transactions */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
@@ -1425,6 +1445,13 @@ xfs_fs_remount(
 			return error;
 		}
 
+		/*
+		 * Perform all on-disk metadata updates required to inactivate
+		 * inodes.  Since this can involve finobt updates, do it now
+		 * before we lose the per-AG space reservations.
+		 */
+		xfs_inactive_force(mp);
+
 		/* Free the per-AG metadata reservation pool. */
 		error = xfs_fs_unreserve_ag_blocks(mp);
 		if (error) {
@@ -1478,6 +1505,18 @@ xfs_fs_unfreeze(
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
+	xfs_inactive_force(XFS_M(sb));
+	return freeze_super(sb);
+}
+
 STATIC int
 xfs_fs_show_options(
 	struct seq_file		*m,
@@ -1640,6 +1679,7 @@ xfs_mount_alloc(
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
 	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
+	INIT_DELAYED_WORK(&mp->m_inactive_work, xfs_inactive_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	return mp;
 }
@@ -1900,6 +1940,7 @@ static const struct super_operations xfs_super_operations = {
 	.show_options		= xfs_fs_show_options,
 	.nr_cached_objects	= xfs_fs_nr_cached_objects,
 	.free_cached_objects	= xfs_fs_free_cached_objects,
+	.freeze_super		= xfs_fs_freeze_super,
 };
 
 static struct file_system_type xfs_fs_type = {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5127f91ce3fd..d2e5e6a794b5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -588,14 +588,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
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
@@ -639,6 +642,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
+DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
+DEFINE_INODE_EVENT(xfs_inode_reclaiming);
+DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
+DEFINE_INODE_EVENT(xfs_inode_inactivating);
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
