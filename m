Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:51486 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753969AbcJRUVX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 16:21:23 -0400
From: Lucas Stach <dev@lynxeye.de>
Subject: [PATCH 2/2] xfs: switch buffer cache entries to RCU freeing
Date: Tue, 18 Oct 2016 22:14:13 +0200
Message-Id: <1476821653-2595-3-git-send-email-dev@lynxeye.de>
In-Reply-To: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

The buffer cache hash as the indexing data structure into the buffer
cache is already protected by RCU. By freeing the entries itself by
RCU we can get rid of the buffer cache lock altogether.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
 fs/xfs/xfs_buf.c   | 41 +++++++++++++++++++++++++++--------------
 fs/xfs/xfs_buf.h   |  2 ++
 fs/xfs/xfs_mount.h |  1 -
 3 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 50c5b01..3ee0a3d1 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -326,6 +326,16 @@ xfs_buf_free(
 	kmem_zone_free(xfs_buf_zone, bp);
 }
 
+STATIC void
+__xfs_buf_rcu_free(
+	struct rcu_head	*head)
+{
+	xfs_buf_t *bp = container_of(head, struct xfs_buf, rcu_head);
+
+	ASSERT(atomic_read(&bp->b_hold) == 0);
+	xfs_buf_free(bp);
+}
+
 /*
  * Allocates all the pages for buffer in question and builds it's page list.
  */
@@ -491,6 +501,14 @@ _xfs_buf_cmp(
 	BUILD_BUG_ON(offsetof(struct xfs_buf_cmp_arg, blkno) != 0);
 
 	if (bp->b_bn == cmp_arg->blkno) {
+		/*
+		 * Skip matches with a hold count of zero, as they are about to
+		 * be freed by RCU. Continue searching as another valid entry
+		 * might have already been inserted into the hash.
+		 */
+		if (unlikely(atomic_read(&bp->b_hold) == 0))
+			return 1;
+
 		if (unlikely(bp->b_length != cmp_arg->numblks)) {
 			/*
 			 * found a block number match. If the range doesn't
@@ -522,7 +540,6 @@ static const struct rhashtable_params xfs_buf_hash_params = {
 int xfs_buf_hash_init(
 	struct xfs_perag *pag)
 {
-	spin_lock_init(&pag->pag_buf_lock);
 	return rhashtable_init(&pag->pag_buf_hash, &xfs_buf_hash_params);
 }
 
@@ -580,14 +597,16 @@ _xfs_buf_find(
 	pag = xfs_perag_get(btp->bt_mount,
 			    xfs_daddr_to_agno(btp->bt_mount, cmp_arg.blkno));
 
+	rcu_read_lock();
 	/* lookup buf in pag hash */
-	spin_lock(&pag->pag_buf_lock);
 	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmp_arg,
 				    xfs_buf_hash_params);
-	if (bp) {
-		atomic_inc(&bp->b_hold);
+
+	/* if the hold count is zero the buffer is about to be freed by RCU */
+	if (bp && atomic_inc_not_zero(&bp->b_hold))
 		goto found;
-	}
+
+	rcu_read_unlock();
 
 	/* No match found */
 	if (new_bp) {
@@ -596,16 +615,14 @@ _xfs_buf_find(
 		rhashtable_insert_fast(&pag->pag_buf_hash,
 				       &new_bp->b_rhash_head,
 				       xfs_buf_hash_params);
-		spin_unlock(&pag->pag_buf_lock);
 	} else {
 		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
-		spin_unlock(&pag->pag_buf_lock);
 		xfs_perag_put(pag);
 	}
 	return new_bp;
 
 found:
-	spin_unlock(&pag->pag_buf_lock);
+	rcu_read_unlock();
 	xfs_perag_put(pag);
 
 	if (!xfs_buf_trylock(bp)) {
@@ -956,7 +973,6 @@ xfs_buf_rele(
 	xfs_buf_t		*bp)
 {
 	struct xfs_perag	*pag = bp->b_pag;
-	bool			release;
 	bool			freebuf = false;
 
 	trace_xfs_buf_rele(bp, _RET_IP_);
@@ -975,9 +991,8 @@ xfs_buf_rele(
 
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 
-	release = atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock);
 	spin_lock(&bp->b_lock);
-	if (!release) {
+	if (!atomic_dec_and_test(&bp->b_hold)) {
 		/*
 		 * Drop the in-flight state if the buffer is already on the LRU
 		 * and it holds the only reference. This is racy because we
@@ -1001,7 +1016,6 @@ xfs_buf_rele(
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
 			atomic_inc(&bp->b_hold);
 		}
-		spin_unlock(&pag->pag_buf_lock);
 	} else {
 		/*
 		 * most of the time buffers will already be removed from the
@@ -1018,7 +1032,6 @@ xfs_buf_rele(
 		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 		rhashtable_remove_fast(&pag->pag_buf_hash, &bp->b_rhash_head,
 				       xfs_buf_hash_params);
-		spin_unlock(&pag->pag_buf_lock);
 		xfs_perag_put(pag);
 		freebuf = true;
 	}
@@ -1027,7 +1040,7 @@ xfs_buf_rele(
 	spin_unlock(&bp->b_lock);
 
 	if (freebuf)
-		xfs_buf_free(bp);
+		call_rcu(&bp->rcu_head, __xfs_buf_rcu_free);
 }
 
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 37943ac..3f99ea7 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -210,6 +210,8 @@ typedef struct xfs_buf {
 
 	const struct xfs_buf_ops	*b_ops;
 
+	struct rcu_head		rcu_head;
+
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 84f7852..1116909 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -393,7 +393,6 @@ typedef struct xfs_perag {
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
 	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
 	struct rhashtable pag_buf_hash;
 
 	/* for rcu-safe freeing */
-- 
2.7.4

