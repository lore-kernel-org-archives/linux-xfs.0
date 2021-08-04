Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD1BC4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 03:20:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27D5061037
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 03:20:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhHDDUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 23:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhHDDUm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Aug 2021 23:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6908F60F02;
        Wed,  4 Aug 2021 03:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628047230;
        bh=rUbG8DhHkXlKqEoAOzA7VdB+c35PX0KtzDg3GnhrMBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XJaFahv/TdfKyMk3gSmXeFdXl6p/6GptUgKuJUIcOUsg/siTcKiiUifx06wa44est
         2htfW4pi0MgUdGExYhXK0mxoey/MxDslE1siuzi+LZ/yY5Kn8V1bmcX/Jw3bRhp+a7
         NEaiO2JUXgvn1dwDWSTBtRyk/b0CHZrYnA0v9M0F1G2sYSa4+n8qf3pyxgRi85ICGz
         B7WgzHL7rSEPWLx0u6sJS83VnBGuqKj8kY2lpXB1NJZ6h4FSEZAB4k18BCn7Q78VcW
         8qEF2GACZ+zPn5VPqnzvsXvdlzCQBhkSnBCLmWXf8iqTjxcVmd5X+w/ctaU4fu8Kdb
         IMViQy8oeRIlw==
Date:   Tue, 3 Aug 2021 20:20:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH, alternative v2] xfs: per-cpu deferred inode inactivation
 queues
Message-ID: <20210804032030.GT3601443@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803083403.GI2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For everyone else following along at home, I've posted the current draft
version of this whole thing in:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.15

Here's Dave's patch reworked slightly to fix a deadlock between icreate
and inactivation; conversion to use m_opstate and related macro stamping
goodness; and some code reorganization to make it easier to add the
throttling bits in the back two thirds of the series.

IOWs, I like this patch.  The runtime for my crazy deltree benchmark
dropped from ~27 minutes to ~17 when the VM has 560M of RAM, and there's
no observable drop in performance when the VM has 16G of RAM.  I also
finally got it to run with 512M of RAM, whereas current TOT OOMs.

(Note: My crazy deltree benchmark is: I have a mdrestored sparse image
with 10m files that I use dm-snapshot so that I can repeatedly write to
it without needing to restore the image.  Then I mount the dm snapshot,
and try to delete every file in the fs.)

--D

From: Dave Chinner <dchinner@redhat.com>

xfs: per-cpu deferred inode inactivation queues

Move inode inactivation to background work contexts so that it no
longer runs in the context that releases the final reference to an
inode. This will allow process work that ends up blocking on
inactivation to continue doing work while the filesytem processes
the inactivation in the background.

A typical demonstration of this is unlinking an inode with lots of
extents. The extents are removed during inactivation, so this blocks
the process that unlinked the inode from the directory structure. By
moving the inactivation to the background process, the userspace
applicaiton can keep working (e.g. unlinking the next inode in the
directory) while the inactivation work on the previous inode is
done by a different CPU.

The implementation of the queue is relatively simple. We use a
per-cpu lockless linked list (llist) to queue inodes for
inactivation without requiring serialisation mechanisms, and a work
item to allow the queue to be processed by a CPU bound worker
thread. We also keep a count of the queue depth so that we can
trigger work after a number of deferred inactivations have been
queued.

The use of a bound workqueue with a single work depth allows the
workqueue to run one work item per CPU. We queue the work item on
the CPU we are currently running on, and so this essentially gives
us affine per-cpu worker threads for the per-cpu queues. THis
maintains the effective CPU affinity that occurs within XFS at the
AG level due to all objects in a directory being local to an AG.
Hence inactivation work tends to run on the same CPU that last
accessed all the objects that inactivation accesses and this
maintains hot CPU caches for unlink workloads.

A depth of 32 inodes was chosen to match the number of inodes in an
inode cluster buffer. This hopefully allows sequential
allocation/unlink behaviours to defering inactivation of all the
inodes in a single cluster buffer at a time, further helping
maintain hot CPU and buffer cache accesses while running
inactivations.

A hard per-cpu queue throttle of 256 inode has been set to avoid
runaway queuing when inodes that take a long to time inactivate are
being processed. For example, when unlinking inodes with large
numbers of extents that can take a lot of processing to free.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[djwong: tweak comments and tracepoints, convert opflags to state bits]
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c    |    7 +
 fs/xfs/xfs_icache.c      |  301 ++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_icache.h      |    5 +
 fs/xfs/xfs_inode.h       |   20 +++
 fs/xfs/xfs_log_recover.c |    7 +
 fs/xfs/xfs_mount.c       |   26 ++++
 fs/xfs/xfs_mount.h       |   38 ++++++
 fs/xfs/xfs_super.c       |  113 ++++++++++++++++-
 fs/xfs/xfs_trace.h       |   53 ++++++++
 9 files changed, 517 insertions(+), 53 deletions(-)

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
index b9214733d0c3..625dea381d0f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -213,7 +213,7 @@ xfs_blockgc_queue(
 {
 	rcu_read_lock();
 	if (radix_tree_tagged(&pag->pag_ici_root, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(pag->pag_mount->m_gc_workqueue,
+		queue_delayed_work(pag->pag_mount->m_blockgc_wq,
 				   &pag->pag_blockgc_work,
 				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
@@ -478,17 +478,26 @@ xfs_iget_cache_hit(
 
 	/*
 	 * If we are racing with another cache hit that is currently
-	 * instantiating this inode or currently recycling it out of
-	 * reclaimable state, wait for the initialisation to complete
-	 * before continuing.
+	 * instantiating this inode, actively inactivating it, or currently
+	 * recycling it out of reclaimable state, wait for the initialisation
+	 * to complete before continuing.
 	 *
 	 * XXX(hch): eventually we should do something equivalent to
 	 *	     wait_on_inode to wait for these flags to be cleared
 	 *	     instead of polling for it.
 	 */
-	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM))
+	if (ip->i_flags & (XFS_INEW | XFS_IRECLAIM | XFS_INACTIVATING))
 		goto out_skip;
 
+	if (ip->i_flags & XFS_NEED_INACTIVE) {
+		/* Unlinked inodes cannot be re-grabbed. */
+		if (VFS_I(ip)->i_nlink == 0) {
+			error = -ENOENT;
+			goto out_error;
+		}
+		goto out_inodegc_flush;
+	}
+
 	/*
 	 * Check the inode free state is valid. This also detects lookup
 	 * racing with unlinks.
@@ -536,6 +545,12 @@ xfs_iget_cache_hit(
 	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();
 	return error;
+
+out_inodegc_flush:
+	spin_unlock(&ip->i_flags_lock);
+	rcu_read_unlock();
+	xfs_inodegc_flush(mp);
+	return -EAGAIN;
 }
 
 static int
@@ -863,6 +878,7 @@ xfs_reclaim_inode(
 
 	xfs_iflags_clear(ip, XFS_IFLUSHING);
 reclaim:
+	trace_xfs_inode_reclaiming(ip);
 
 	/*
 	 * Because we use RCU freeing we need to ensure the inode always appears
@@ -1340,6 +1356,8 @@ xfs_blockgc_start(
 
 /* Don't try to run block gc on an inode that's in any of these states. */
 #define XFS_BLOCKGC_NOGRAB_IFLAGS	(XFS_INEW | \
+					 XFS_NEED_INACTIVE | \
+					 XFS_INACTIVATING | \
 					 XFS_IRECLAIMABLE | \
 					 XFS_IRECLAIM)
 /*
@@ -1741,25 +1759,13 @@ xfs_check_delalloc(
 #define xfs_check_delalloc(ip, whichfork)	do { } while (0)
 #endif
 
-/*
- * We set the inode flag atomically with the radix tree tag.
- * Once we get tag lookups on the radix tree, this inode flag
- * can go away.
- */
-void
-xfs_inode_mark_reclaimable(
+/* Schedule the inode for reclaim. */
+static void
+xfs_inodegc_set_reclaimable(
 	struct xfs_inode	*ip)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_perag	*pag;
-	bool			need_inactive = xfs_inode_needs_inactive(ip);
-
-	if (!need_inactive) {
-		/* Going straight to reclaim, so drop the dquots. */
-		xfs_qm_dqdetach(ip);
-	} else {
-		xfs_inactive(ip);
-	}
 
 	if (!XFS_FORCED_SHUTDOWN(mp) && ip->i_delayed_blks) {
 		xfs_check_delalloc(ip, XFS_DATA_FORK);
@@ -1767,30 +1773,245 @@ xfs_inode_mark_reclaimable(
 		ASSERT(0);
 	}
 
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+	spin_lock(&pag->pag_ici_lock);
+	spin_lock(&ip->i_flags_lock);
+
+	trace_xfs_inode_set_reclaimable(ip);
+	ip->i_flags &= ~(XFS_NEED_INACTIVE | XFS_INACTIVATING);
+	ip->i_flags |= XFS_IRECLAIMABLE;
+	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
+			XFS_ICI_RECLAIM_TAG);
+
+	spin_unlock(&ip->i_flags_lock);
+	spin_unlock(&pag->pag_ici_lock);
+	xfs_perag_put(pag);
+}
+
+/*
+ * Free all speculative preallocations and possibly even the inode itself.
+ * This is the last chance to make changes to an otherwise unreferenced file
+ * before incore reclamation happens.
+ */
+static void
+xfs_inodegc_inactivate(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount        *mp = ip->i_mount;
+
+	/*
+	* Inactivation isn't supposed to run when the fs is frozen because
+	* we don't want kernel threads to block on transaction allocation.
+	*/
+	ASSERT(mp->m_super->s_writers.frozen < SB_FREEZE_FS);
+
+	trace_xfs_inode_inactivating(ip);
+	xfs_inactive(ip);
+	xfs_inodegc_set_reclaimable(ip);
+}
+
+void
+xfs_inodegc_worker(
+	struct work_struct	*work)
+{
+	struct xfs_inodegc	*gc = container_of(work, struct xfs_inodegc,
+							work);
+	struct llist_node	*node = llist_del_all(&gc->list);
+	struct xfs_inode	*ip, *n;
+
+	WRITE_ONCE(gc->items, 0);
+
+	if (!node)
+		return;
+
+	ip = llist_entry(node, struct xfs_inode, i_gclist);
+	trace_xfs_inodegc_worker(ip->i_mount, __return_address);
+
+	llist_for_each_entry_safe(ip, n, node, i_gclist) {
+		xfs_iflags_set(ip, XFS_INACTIVATING);
+		xfs_inodegc_inactivate(ip);
+	}
+}
+
+/*
+ * Force all currently queued inode inactivation work to run immediately, and
+ * wait for the work to finish. Two pass - queue all the work first pass, wait
+ * for it in a second pass.
+ */
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inodegc	*gc;
+	int			cpu;
+
+	trace_xfs_inodegc_flush(mp, __return_address);
+
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
+	}
+
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		flush_work(&gc->work);
+	}
+}
+
+/*
+ * Flush all the pending work and then disable the inode inactivation background
+ * workers and wait for them to stop.
+ */
+void
+xfs_inodegc_stop(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inodegc	*gc;
+	int			cpu;
+
+	if (!xfs_clear_inodegc_enabled(mp))
+		return;
+
+	xfs_inodegc_flush(mp);
+
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		cancel_work_sync(&gc->work);
+	}
+	trace_xfs_inodegc_stop(mp, __return_address);
+}
+
+/*
+ * Enable the inode inactivation background workers and schedule deferred inode
+ * inactivation work if there is any.
+ */
+void
+xfs_inodegc_start(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inodegc	*gc;
+	int			cpu;
+
+	if (xfs_set_inodegc_enabled(mp))
+		return;
+
+	trace_xfs_inodegc_start(mp, __return_address);
+	for_each_online_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		if (!llist_empty(&gc->list))
+			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
+	}
+}
+
+/*
+ * Schedule the inactivation worker when:
+ *
+ *  - We've accumulated more than one inode cluster buffer's worth of inodes.
+ */
+static inline bool
+xfs_inodegc_want_queue_work(
+	struct xfs_inode	*ip,
+	unsigned int		items)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (items > mp->m_ino_geo.inodes_per_cluster)
+		return true;
+
+	return false;
+}
+
+/*
+ * Upper bound on the number of inodes in each AG that can be queued for
+ * inactivation at any given time, to avoid monopolizing the workqueue.
+ */
+#define XFS_INODEGC_MAX_BACKLOG		(4 * XFS_INODES_PER_CHUNK)
+
+/*
+ * Make the frontend wait for inactivations when:
+ *
+ *  - The queue depth exceeds the maximum allowable percpu backlog.
+ */
+static inline bool
+xfs_inodegc_want_flush_work(
+	struct xfs_inode	*ip,
+	unsigned int		items)
+{
+	if (items > XFS_INODEGC_MAX_BACKLOG)
+		return true;
+
+	return false;
+}
+
+/*
+ * Queue a background inactivation worker if there are inodes that need to be
+ * inactivated and higher level xfs code hasn't disabled the background
+ * workers.
+ */
+static void
+xfs_inodegc_queue(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_inodegc	*gc;
+	int			items;
+
+	trace_xfs_inode_set_need_inactive(ip);
+	spin_lock(&ip->i_flags_lock);
+	ip->i_flags |= XFS_NEED_INACTIVE;
+	spin_unlock(&ip->i_flags_lock);
+
+	gc = get_cpu_ptr(mp->m_inodegc);
+	llist_add(&ip->i_gclist, &gc->list);
+	items = READ_ONCE(gc->items);
+	WRITE_ONCE(gc->items, items + 1);
+	put_cpu_ptr(gc);
+
+	if (!xfs_is_inodegc_enabled(mp))
+		return;
+
+	if (xfs_inodegc_want_queue_work(ip, items)) {
+		trace_xfs_inodegc_queue(mp, __return_address);
+		queue_work(mp->m_inodegc_wq, &gc->work);
+	}
+
+	if (xfs_inodegc_want_flush_work(ip, items)) {
+		trace_xfs_inodegc_throttle(mp, __return_address);
+		flush_work(&gc->work);
+	}
+}
+
+/*
+ * We set the inode flag atomically with the radix tree tag.  Once we get tag
+ * lookups on the radix tree, this inode flag can go away.
+ *
+ * We always use background reclaim here because even if the inode is clean, it
+ * still may be under IO and hence we have wait for IO completion to occur
+ * before we can reclaim the inode. The background reclaim path handles this
+ * more efficiently than we can here, so simply let background reclaim tear down
+ * all inodes.
+ */
+void
+xfs_inode_mark_reclaimable(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			need_inactive;
+
 	XFS_STATS_INC(mp, vn_reclaim);
 
 	/*
-	 * We should never get here with one of the reclaim flags already set.
+	 * We should never get here with any of the reclaim flags already set.
 	 */
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
-	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_IRECLAIM));
+	ASSERT_ALWAYS(!xfs_iflags_test(ip, XFS_ALL_IRECLAIM_FLAGS));
 
-	/*
-	 * We always use background reclaim here because even if the inode is
-	 * clean, it still may be under IO and hence we have wait for IO
-	 * completion to occur before we can reclaim the inode. The background
-	 * reclaim path handles this more efficiently than we can here, so
-	 * simply let background reclaim tear down all inodes.
-	 */
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	spin_lock(&pag->pag_ici_lock);
-	spin_lock(&ip->i_flags_lock);
-
-	xfs_perag_set_inode_tag(pag, XFS_INO_TO_AGINO(mp, ip->i_ino),
-			XFS_ICI_RECLAIM_TAG);
-	__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
+	need_inactive = xfs_inode_needs_inactive(ip);
+	if (need_inactive) {
+		xfs_inodegc_queue(ip);
+		return;
+	}
 
-	spin_unlock(&ip->i_flags_lock);
-	spin_unlock(&pag->pag_ici_lock);
-	xfs_perag_put(pag);
+	/* Going straight to reclaim, so drop the dquots. */
+	xfs_qm_dqdetach(ip);
+	xfs_inodegc_set_reclaimable(ip);
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
index e3137bbc7b14..1f62b481d8c5 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -42,6 +42,7 @@ typedef struct xfs_inode {
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_mmaplock;	/* inode mmap IO lock */
 	atomic_t		i_pincount;	/* inode pin count */
+	struct llist_node	i_gclist;	/* deferred inactivation list */
 
 	/*
 	 * Bitsets of inode metadata that have been checked and/or are sick.
@@ -240,6 +241,7 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
 #define __XFS_IPINNED_BIT	8	 /* wakeup key for zero pin count */
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
 #define XFS_IEOFBLOCKS		(1 << 9) /* has the preallocblocks tag set */
+#define XFS_NEED_INACTIVE	(1 << 10) /* see XFS_INACTIVATING below */
 /*
  * If this unlinked inode is in the middle of recovery, don't let drop_inode
  * truncate and free the inode.  This can happen if we iget the inode during
@@ -248,6 +250,21 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
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
@@ -255,7 +272,8 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
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
index c78b63fe779a..949d33cb270f 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -56,6 +56,15 @@ struct xfs_error_cfg {
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
+/*
+ * Per-cpu deferred inode inactivation GC lists.
+ */
+struct xfs_inodegc {
+	struct llist_head	list;
+	struct work_struct	work;
+	unsigned int		items;
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -82,6 +91,8 @@ typedef struct xfs_mount {
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
 	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
+	void __percpu		*m_inodegc;	/* percpu inodegc structures */
+
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
 	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
@@ -94,8 +105,9 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct *m_gc_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
+	struct workqueue_struct *m_blockgc_wq;
+	struct workqueue_struct *m_inodegc_wq;
 
 	int			m_bsize;	/* fs logical block size */
 	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
@@ -136,6 +148,7 @@ typedef struct xfs_mount {
 	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
 						/* low free space thresholds */
+	unsigned long		m_opstate;	/* dynamic state flags */
 	bool			m_always_cow;
 	bool			m_fail_unmount;
 	bool			m_finobt_nores; /* no per-AG finobt resv. */
@@ -258,6 +271,29 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_DAX_ALWAYS	(1ULL << 26)
 #define XFS_MOUNT_DAX_NEVER	(1ULL << 27)
 
+/*
+ * If set, inactivation worker threads will be scheduled to process queued
+ * inodegc work.  If not, queued inodes remain in memory waiting to be
+ * processed.
+ */
+#define XFS_STATE_INODEGC_ENABLED	0
+
+#define __XFS_IS_STATE(name, NAME) \
+static inline bool xfs_is_ ## name (struct xfs_mount *mp) \
+{ \
+	return test_bit(XFS_STATE_ ## NAME, &mp->m_opstate); \
+} \
+static inline bool xfs_clear_ ## name (struct xfs_mount *mp) \
+{ \
+	return test_and_clear_bit(XFS_STATE_ ## NAME, &mp->m_opstate); \
+} \
+static inline bool xfs_set_ ## name (struct xfs_mount *mp) \
+{ \
+	return test_and_set_bit(XFS_STATE_ ## NAME, &mp->m_opstate); \
+}
+
+__XFS_IS_STATE(inodegc_enabled, INODEGC_ENABLED)
+
 /*
  * Max and min values for mount-option defined I/O
  * preallocation sizes.
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index ef89a9a3ba9e..cc3af4f6efa8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -508,21 +508,29 @@ xfs_init_mount_workqueues(
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
-	mp->m_gc_workqueue = alloc_workqueue("xfs-gc/%s",
-			WQ_SYSFS | WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM,
+	mp->m_blockgc_wq = alloc_workqueue("xfs-blockgc/%s",
+			XFS_WQFLAGS(WQ_UNBOUND | WQ_FREEZABLE | WQ_MEM_RECLAIM),
 			0, mp->m_super->s_id);
-	if (!mp->m_gc_workqueue)
+	if (!mp->m_blockgc_wq)
 		goto out_destroy_reclaim;
 
+	mp->m_inodegc_wq = alloc_workqueue("xfs-inodegc/%s",
+			XFS_WQFLAGS(WQ_FREEZABLE | WQ_MEM_RECLAIM),
+			1, mp->m_super->s_id);
+	if (!mp->m_inodegc_wq)
+		goto out_destroy_blockgc;
+
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
 			XFS_WQFLAGS(WQ_FREEZABLE), 0, mp->m_super->s_id);
 	if (!mp->m_sync_workqueue)
-		goto out_destroy_eofb;
+		goto out_destroy_inodegc;
 
 	return 0;
 
-out_destroy_eofb:
-	destroy_workqueue(mp->m_gc_workqueue);
+out_destroy_inodegc:
+	destroy_workqueue(mp->m_inodegc_wq);
+out_destroy_blockgc:
+	destroy_workqueue(mp->m_blockgc_wq);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_cil:
@@ -540,7 +548,8 @@ xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	destroy_workqueue(mp->m_sync_workqueue);
-	destroy_workqueue(mp->m_gc_workqueue);
+	destroy_workqueue(mp->m_blockgc_wq);
+	destroy_workqueue(mp->m_inodegc_wq);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
@@ -702,6 +711,8 @@ xfs_fs_sync_fs(
 {
 	struct xfs_mount	*mp = XFS_M(sb);
 
+	trace_xfs_fs_sync_fs(mp, __return_address);
+
 	/*
 	 * Doing anything during the async pass would be counterproductive.
 	 */
@@ -718,6 +729,25 @@ xfs_fs_sync_fs(
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
 
@@ -832,6 +862,17 @@ xfs_fs_freeze(
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
@@ -847,6 +888,14 @@ xfs_fs_unfreeze(
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
 
@@ -972,6 +1021,35 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_delalloc_blks);
 }
 
+static int
+xfs_inodegc_init_percpu(
+	struct xfs_mount	*mp)
+{
+	struct xfs_inodegc	*gc;
+	int			cpu;
+
+	mp->m_inodegc = alloc_percpu(struct xfs_inodegc);
+	if (!mp->m_inodegc)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+		init_llist_head(&gc->list);
+		gc->items = 0;
+                INIT_WORK(&gc->work, xfs_inodegc_worker);
+	}
+	return 0;
+}
+
+static void
+xfs_inodegc_free_percpu(
+	struct xfs_mount	*mp)
+{
+	if (!mp->m_inodegc)
+		return;
+	free_percpu(mp->m_inodegc);
+}
+
 static void
 xfs_fs_put_super(
 	struct super_block	*sb)
@@ -988,6 +1066,7 @@ xfs_fs_put_super(
 
 	xfs_freesb(mp);
 	free_percpu(mp->m_stats.xs_stats);
+	xfs_inodegc_free_percpu(mp);
 	xfs_destroy_percpu_counters(mp);
 	xfs_destroy_mount_workqueues(mp);
 	xfs_close_devices(mp);
@@ -1359,11 +1438,15 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_destroy_workqueues;
 
+	error = xfs_inodegc_init_percpu(mp);
+	if (error)
+		goto out_destroy_counters;
+
 	/* Allocate stats memory before we do operations that might use it */
 	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
 	if (!mp->m_stats.xs_stats) {
 		error = -ENOMEM;
-		goto out_destroy_counters;
+		goto out_destroy_inodegc;
 	}
 
 	error = xfs_readsb(mp, flags);
@@ -1566,6 +1649,8 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_free_stats:
 	free_percpu(mp->m_stats.xs_stats);
+ out_destroy_inodegc:
+	xfs_inodegc_free_percpu(mp);
  out_destroy_counters:
 	xfs_destroy_percpu_counters(mp);
  out_destroy_workqueues:
@@ -1649,6 +1734,9 @@ xfs_remount_rw(
 	if (error && error != -ENOSPC)
 		return error;
 
+	/* Re-enable the background inode inactivation worker. */
+	xfs_inodegc_start(mp);
+
 	return 0;
 }
 
@@ -1671,6 +1759,15 @@ xfs_remount_ro(
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
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 19260291ff8b..bd8abb50b33a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -157,6 +157,48 @@ DEFINE_PERAG_REF_EVENT(xfs_perag_put);
 DEFINE_PERAG_REF_EVENT(xfs_perag_set_inode_tag);
 DEFINE_PERAG_REF_EVENT(xfs_perag_clear_inode_tag);
 
+#define XFS_STATE_FLAGS \
+	{ (1UL << XFS_STATE_INODEGC_ENABLED),		"inodegc" }
+
+DECLARE_EVENT_CLASS(xfs_fs_class,
+	TP_PROTO(struct xfs_mount *mp, void *caller_ip),
+	TP_ARGS(mp, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long long, mflags)
+		__field(unsigned long, opstate)
+		__field(unsigned long, sbflags)
+		__field(void *, caller_ip)
+	),
+	TP_fast_assign(
+		if (mp) {
+			__entry->dev = mp->m_super->s_dev;
+			__entry->mflags = mp->m_flags;
+			__entry->opstate = mp->m_opstate;
+			__entry->sbflags = mp->m_super->s_flags;
+		}
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d m_flags 0x%llx opstate (%s) s_flags 0x%lx caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->mflags,
+		  __print_flags(__entry->opstate, "|", XFS_STATE_FLAGS),
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
+DEFINE_FS_EVENT(xfs_inodegc_queue);
+DEFINE_FS_EVENT(xfs_inodegc_throttle);
+DEFINE_FS_EVENT(xfs_fs_sync_fs);
+
 DECLARE_EVENT_CLASS(xfs_ag_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno),
 	TP_ARGS(mp, agno),
@@ -616,14 +658,17 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
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
@@ -667,6 +712,10 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
 DEFINE_INODE_EVENT(xfs_inode_set_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_clear_cowblocks_tag);
 DEFINE_INODE_EVENT(xfs_inode_free_cowblocks_invalid);
+DEFINE_INODE_EVENT(xfs_inode_set_reclaimable);
+DEFINE_INODE_EVENT(xfs_inode_reclaiming);
+DEFINE_INODE_EVENT(xfs_inode_set_need_inactive);
+DEFINE_INODE_EVENT(xfs_inode_inactivating);
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
