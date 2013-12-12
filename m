Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8BB9429DF8
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 03:41:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4784D30408A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:41:09 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	XUXtoZJO9nlDOaIi for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 01:41:07 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Vr2lR-00015r-8i
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1Vr2lR-0005tE-7z
	for xfs@oss.sgi.com; Thu, 12 Dec 2013 20:41:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfs: dquot refcounting by atomics
Date: Thu, 12 Dec 2013 20:40:57 +1100
Message-Id: <1386841258-22183-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1386841258-22183-1-git-send-email-david@fromorbit.com>
References: <1386841258-22183-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

On concurrent workloads, the dquot lock completely serialises the
workload. One of the contributors to that is that taking a reference
count on the dquot requires taking the dquot lock. If we make the
reference count atomic, we don't need to take the lock to bump the
count.

Profiles showed that the reference count locking really hurt:

-   5.02%  [kernel]  [k] __mutex_lock_slowpath
   - __mutex_lock_slowpath
      - 99.66% mutex_lock
         - 31.04% xfs_qm_vop_create_dqattach
         - 30.03% xfs_qm_vop_dqalloc
         - 20.56% xfs_qm_dqrele
         - 9.16% xfs_trans_dqresv
         - 7.31% xfs_trans_dqlockedjoin

Primarily in xfs_qm_vop_create_dqattach and xfs_qm_vop_dqalloc().
Baseline performance looked like:

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0      17666.5         15377143
     0      3200000            0      17018.6         15922906
     0      4800000            0      17373.5         16149660
     0      6400000            0      16564.9         17234139
     0      8000000            0      17022.4         15987230
     0      9600000            0      16684.2         14834507
     0     11200000            0      16770.3         27330353
     0     12800000            0      15921.4         18935868


So, convert the refcount to an atomic, slightly rearrange the dquot
structure to separate read-mostly and contended fields, and the
profile changes drastically:

-   5.54%  [kernel]  [k] __mutex_lock_slowpath
   - __mutex_lock_slowpath
      - 99.67% mutex_lock
         - 45.15% xfs_trans_dqlockedjoin
         - 44.71% xfs_trans_dqresv
         - 8.23% xfs_qm_dqrele

The reference count locking is gone completely and now all
contention is within the transaction subsystem. The result:

FSUse%        Count         Size    Files/sec     App Overhead
     0      1600000            0      17559.3         15606077
     0      3200000            0      18738.9         14026009
     0      4800000            0      18960.0         14381162
     0      6400000            0      19026.5         14422024
     0      8000000            0      18456.6         15369059
     0      9600000            0      17828.4         21075613
     0     11200000            0      17903.9         16474615
     0     12800000            0      17546.0         13919798

is a roughly 10% improvement in performance.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dquot.c | 16 ++++++++++------
 fs/xfs/xfs_dquot.h | 16 +++++++---------
 fs/xfs/xfs_qm.c    |  6 +++---
 fs/xfs/xfs_trace.h |  2 +-
 4 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 4ce4984..975a46c 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -748,7 +748,7 @@ restart:
 			goto restart;
 		}
 
-		dqp->q_nrefs++;
+		atomic_inc(&dqp->q_nrefs);
 		mutex_unlock(&qi->qi_tree_lock);
 
 		trace_xfs_dqget_hit(dqp);
@@ -799,6 +799,12 @@ restart:
 		}
 	}
 
+	/*
+	 * set the reference count before we insert the dquot into the tree
+	 * so it is safe from reclaim by default.
+	 */
+	atomic_set(&dqp->q_nrefs, 1);
+
 	mutex_lock(&qi->qi_tree_lock);
 	error = -radix_tree_insert(tree, id, dqp);
 	if (unlikely(error)) {
@@ -816,11 +822,9 @@ restart:
 	}
 
 	/*
-	 * We return a locked dquot to the caller, with a reference taken
+	 * We return a locked, referenced dquot to the caller.
 	 */
 	xfs_dqlock(dqp);
-	dqp->q_nrefs = 1;
-
 	qi->qi_dquots++;
 	mutex_unlock(&qi->qi_tree_lock);
 
@@ -841,12 +845,12 @@ void
 xfs_qm_dqput(
 	struct xfs_dquot	*dqp)
 {
-	ASSERT(dqp->q_nrefs > 0);
+	ASSERT(atomic_read(&dqp->q_nrefs) > 0);
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
 	trace_xfs_dqput(dqp);
 
-	if (--dqp->q_nrefs == 0) {
+	if (atomic_dec_and_test(&dqp->q_nrefs)) {
 		struct xfs_quotainfo	*qi = dqp->q_mount->m_quotainfo;
 		trace_xfs_dqput_free(dqp);
 
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 68a68f7..949a47b 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -44,26 +44,26 @@ enum {
  */
 typedef struct xfs_dquot {
 	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
-	struct list_head q_lru;		/* global free list of dquots */
 	struct xfs_mount*q_mount;	/* filesystem this relates to */
-	struct xfs_trans*q_transp;	/* trans this belongs to currently */
-	uint		 q_nrefs;	/* # active refs from inodes */
 	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
 	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
 	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
-
-	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
-	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
 	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
 	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
 	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
 	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
 	int64_t		 q_low_space[XFS_QLOWSP_MAX];
+
+	atomic_t	 q_nrefs;	/* # active refs from inodes */
+	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
+	xfs_dq_logitem_t q_logitem;	/* dquot log item */
 	struct mutex	 q_qlock;	/* quota lock */
 	struct completion q_flush;	/* flush completion queue */
 	atomic_t          q_pincount;	/* dquot pin count */
 	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
+	struct list_head q_lru;		/* global free list of dquots */
+	struct xfs_trans *q_transp;	/* trans this belongs to currently */
 } xfs_dquot_t;
 
 /*
@@ -164,9 +164,7 @@ extern void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
-	xfs_dqlock(dqp);
-	dqp->q_nrefs++;
-	xfs_dqunlock(dqp);
+	atomic_inc(&dqp->q_nrefs);
 	return dqp;
 }
 
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index d31b88e..31c0f85 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -136,7 +136,7 @@ xfs_qm_dqpurge(
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
 
 	xfs_dqlock(dqp);
-	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
+	if ((dqp->dq_flags & XFS_DQ_FREEING) || atomic_read(&dqp->q_nrefs)) {
 		xfs_dqunlock(dqp);
 		return EAGAIN;
 	}
@@ -540,7 +540,7 @@ xfs_qm_dquot_isolate(
 	 * This dquot has acquired a reference in the meantime remove it from
 	 * the freelist and try again.
 	 */
-	if (dqp->q_nrefs) {
+	if (atomic_read(&dqp->q_nrefs)) {
 		xfs_dqunlock(dqp);
 		XFS_STATS_INC(xs_qm_dqwants);
 
@@ -588,7 +588,7 @@ xfs_qm_dquot_isolate(
 	dqp->dq_flags |= XFS_DQ_FREEING;
 	xfs_dqunlock(dqp);
 
-	ASSERT(dqp->q_nrefs == 0);
+	ASSERT(atomic_read(&dqp->q_nrefs) == 0);
 	list_move_tail(&dqp->q_lru, &isol->dispose);
 	XFS_STATS_DEC(xs_qm_dquot_unused);
 	trace_xfs_dqreclaim_done(dqp);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 425dfa4..051813c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -769,7 +769,7 @@ DECLARE_EVENT_CLASS(xfs_dquot_class,
 		__entry->dev = dqp->q_mount->m_super->s_dev;
 		__entry->id = be32_to_cpu(dqp->q_core.d_id);
 		__entry->flags = dqp->dq_flags;
-		__entry->nrefs = dqp->q_nrefs;
+		__entry->nrefs = atomic_read(&dqp->q_nrefs);
 		__entry->res_bcount = dqp->q_res_bcount;
 		__entry->bcount = be64_to_cpu(dqp->q_core.d_bcount);
 		__entry->icount = be64_to_cpu(dqp->q_core.d_icount);
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
