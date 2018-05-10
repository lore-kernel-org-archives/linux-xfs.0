Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39562 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965410AbeEJP3j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 May 2018 11:29:39 -0400
Subject: [PATCH 04/14] xfs: refactor dquot cache handling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 10 May 2018 08:29:10 -0700
Message-ID: <152596615091.27525.3447222197440783485.stgit@magnolia>
In-Reply-To: <152596612549.27525.9876256551560849585.stgit@magnolia>
References: <152596612549.27525.9876256551560849585.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, hch@lst.de

From: Darrick J. Wong <darrick.wong@oracle.com>

Delegate the dquot cache handling (radix tree lookup and insertion) to
separate helper functions so that we can continue to simplify the body
of dqget.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_dquot.c |  112 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 78 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 8d2a3becc4f4..299d4ce90ded 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -686,6 +686,81 @@ xfs_dq_get_next_id(
 	return error;
 }
 
+/*
+ * Look up the dquot in the in-core cache.  If found, the dquot is returned
+ * locked and ready to go.
+ */
+static struct xfs_dquot *
+xfs_qm_dqget_cache_lookup(
+	struct xfs_mount	*mp,
+	struct xfs_quotainfo	*qi,
+	struct radix_tree_root	*tree,
+	xfs_dqid_t		id)
+{
+	struct xfs_dquot	*dqp;
+
+restart:
+	mutex_lock(&qi->qi_tree_lock);
+	dqp = radix_tree_lookup(tree, id);
+	if (!dqp) {
+		mutex_unlock(&qi->qi_tree_lock);
+		XFS_STATS_INC(mp, xs_qm_dqcachemisses);
+		return NULL;
+	}
+
+	xfs_dqlock(dqp);
+	if (dqp->dq_flags & XFS_DQ_FREEING) {
+		xfs_dqunlock(dqp);
+		mutex_unlock(&qi->qi_tree_lock);
+		trace_xfs_dqget_freeing(dqp);
+		delay(1);
+		goto restart;
+	}
+
+	dqp->q_nrefs++;
+	mutex_unlock(&qi->qi_tree_lock);
+
+	trace_xfs_dqget_hit(dqp);
+	XFS_STATS_INC(mp, xs_qm_dqcachehits);
+	return dqp;
+}
+
+/*
+ * Try to insert a new dquot into the in-core cache.  If an error occurs the
+ * caller should throw away the dquot and start over.  Otherwise, the dquot
+ * is returned locked (and held by the cache) as if there had been a cache
+ * hit.
+ */
+static int
+xfs_qm_dqget_cache_insert(
+	struct xfs_mount	*mp,
+	struct xfs_quotainfo	*qi,
+	struct radix_tree_root	*tree,
+	xfs_dqid_t		id,
+	struct xfs_dquot	*dqp)
+{
+	int			error;
+
+	mutex_lock(&qi->qi_tree_lock);
+	error = radix_tree_insert(tree, id, dqp);
+	if (unlikely(error)) {
+		/* Duplicate found!  Caller must try again. */
+		WARN_ON(error != -EEXIST);
+		mutex_unlock(&qi->qi_tree_lock);
+		trace_xfs_dqget_dup(dqp);
+		return error;
+	}
+
+	/* Return a locked dquot to the caller, with a reference taken. */
+	xfs_dqlock(dqp);
+	dqp->q_nrefs = 1;
+
+	qi->qi_dquots++;
+	mutex_unlock(&qi->qi_tree_lock);
+
+	return 0;
+}
+
 /*
  * Given the file system, inode OR id, and type (UDQUOT/GDQUOT), return a
  * a locked dquot, doing an allocation (if requested) as needed.
@@ -724,28 +799,11 @@ xfs_qm_dqget(
 	}
 
 restart:
-	mutex_lock(&qi->qi_tree_lock);
-	dqp = radix_tree_lookup(tree, id);
+	dqp = xfs_qm_dqget_cache_lookup(mp, qi, tree, id);
 	if (dqp) {
-		xfs_dqlock(dqp);
-		if (dqp->dq_flags & XFS_DQ_FREEING) {
-			xfs_dqunlock(dqp);
-			mutex_unlock(&qi->qi_tree_lock);
-			trace_xfs_dqget_freeing(dqp);
-			delay(1);
-			goto restart;
-		}
-
-		dqp->q_nrefs++;
-		mutex_unlock(&qi->qi_tree_lock);
-
-		trace_xfs_dqget_hit(dqp);
-		XFS_STATS_INC(mp, xs_qm_dqcachehits);
 		*O_dqpp = dqp;
 		return 0;
 	}
-	mutex_unlock(&qi->qi_tree_lock);
-	XFS_STATS_INC(mp, xs_qm_dqcachemisses);
 
 	/*
 	 * Dquot cache miss. We don't want to keep the inode lock across
@@ -787,31 +845,17 @@ xfs_qm_dqget(
 		}
 	}
 
-	mutex_lock(&qi->qi_tree_lock);
-	error = radix_tree_insert(tree, id, dqp);
-	if (unlikely(error)) {
-		WARN_ON(error != -EEXIST);
-
+	error = xfs_qm_dqget_cache_insert(mp, qi, tree, id, dqp);
+	if (error) {
 		/*
 		 * Duplicate found. Just throw away the new dquot and start
 		 * over.
 		 */
-		mutex_unlock(&qi->qi_tree_lock);
-		trace_xfs_dqget_dup(dqp);
 		xfs_qm_dqdestroy(dqp);
 		XFS_STATS_INC(mp, xs_qm_dquot_dups);
 		goto restart;
 	}
 
-	/*
-	 * We return a locked dquot to the caller, with a reference taken
-	 */
-	xfs_dqlock(dqp);
-	dqp->q_nrefs = 1;
-
-	qi->qi_dquots++;
-	mutex_unlock(&qi->qi_tree_lock);
-
  dqret:
 	ASSERT((ip == NULL) || xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	trace_xfs_dqget_miss(dqp);

