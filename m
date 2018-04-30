Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36912 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeD3Fnf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 01:43:35 -0400
Subject: [PATCH 02/13] xfs: refactor dquot cache handling
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Apr 2018 22:43:14 -0700
Message-ID: <152506699458.21553.5575785933695714320.stgit@magnolia>
In-Reply-To: <152506698177.21553.13500862866416804148.stgit@magnolia>
References: <152506698177.21553.13500862866416804148.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

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
index 79a9df691d6c..43b0b32effd4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -678,6 +678,81 @@ xfs_dq_get_next_id(
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
@@ -716,28 +791,11 @@ xfs_qm_dqget(
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
@@ -779,31 +837,17 @@ xfs_qm_dqget(
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

