Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ns.lynxeye.de ([87.118.118.114]:51487 "EHLO lynxeye.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753252AbcJRUVX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Oct 2016 16:21:23 -0400
From: Lucas Stach <dev@lynxeye.de>
Subject: [PATCH 1/2] xfs: use rhashtable to track buffer cache
Date: Tue, 18 Oct 2016 22:14:12 +0200
Message-Id: <1476821653-2595-2-git-send-email-dev@lynxeye.de>
In-Reply-To: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On filesystems with a lot of metadata and in metadata intensive workloads
xfs_buf_find() is showing up at the top of the CPU cycles trace. Most of
the CPU time is spent on CPU cache misses while traversing the rbtree.

As the buffer cache does not need any kind of ordering, but fast lookups
a hashtable is the natural data structure to use. The rhashtable
infrastructure provides a self-scaling hashtable implementation and
allows lookups to proceed while the table is going through a resize
operation.

This reduces the CPU-time spent for the lookups to 1/3 even for small
filesystems with a relatively small number of cached buffers, with
possibly much larger gains on higher loaded filesystems.

The minimum size of 4096 buckets was chosen as it was the size of the
xfs buffer cache hash before it was converted to an rbtree.

Signed-off-by: Lucas Stach <dev@lynxeye.de>
---
 fs/xfs/xfs_buf.c   | 118 ++++++++++++++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf.h   |   2 +-
 fs/xfs/xfs_linux.h |   1 +
 fs/xfs/xfs_mount.c |   7 +++-
 fs/xfs/xfs_mount.h |   7 +++-
 5 files changed, 88 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index b5b9bff..50c5b01 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -219,7 +219,6 @@ _xfs_buf_alloc(
 	init_completion(&bp->b_iowait);
 	INIT_LIST_HEAD(&bp->b_lru);
 	INIT_LIST_HEAD(&bp->b_list);
-	RB_CLEAR_NODE(&bp->b_rbnode);
 	sema_init(&bp->b_sema, 0); /* held, no waiters */
 	spin_lock_init(&bp->b_lock);
 	XB_SET_OWNER(bp);
@@ -473,7 +472,66 @@ _xfs_buf_map_pages(
 /*
  *	Finding and Reading Buffers
  */
+struct xfs_buf_cmp_arg {
+	xfs_daddr_t	blkno;
+	int		numblks;
+};
+int
+_xfs_buf_cmp(
+	struct rhashtable_compare_arg *arg,
+	const void *obj)
+{
+	const struct xfs_buf_cmp_arg *cmp_arg = arg->key;
+	const struct xfs_buf *bp = obj;
+
+	/*
+	 * The key hashing in the lookup path depends on the key being the
+	 * first element of the compare_arg, make sure to assert this.
+	 */
+	BUILD_BUG_ON(offsetof(struct xfs_buf_cmp_arg, blkno) != 0);
+
+	if (bp->b_bn == cmp_arg->blkno) {
+		if (unlikely(bp->b_length != cmp_arg->numblks)) {
+			/*
+			 * found a block number match. If the range doesn't
+			 * match, the only way this is allowed is if the buffer
+			 * in the cache is stale and the transaction that made
+			 * it stale has not yet committed. i.e. we are
+			 * reallocating a busy extent. Skip this buffer and
+			 * continue searching for an exact match.
+			 */
+			ASSERT(bp->b_flags & XBF_STALE);
+			return 1;
+		}
+
+		return 0;
+	}
+
+	return 1;
+}
+static const struct rhashtable_params xfs_buf_hash_params = {
+	.min_size = 4096,
+	.nelem_hint = 3072,
+	.key_len = sizeof(xfs_daddr_t),
+	.key_offset = offsetof(struct xfs_buf, b_bn),
+	.head_offset = offsetof(struct xfs_buf, b_rhash_head),
+	.automatic_shrinking = true,
+	.obj_cmpfn = _xfs_buf_cmp,
+};
+
+int xfs_buf_hash_init(
+	struct xfs_perag *pag)
+{
+	spin_lock_init(&pag->pag_buf_lock);
+	return rhashtable_init(&pag->pag_buf_hash, &xfs_buf_hash_params);
+}
 
+void
+xfs_buf_hash_destroy(
+	struct xfs_perag *pag)
+{
+	rhashtable_destroy(&pag->pag_buf_hash);
+}
 /*
  *	Look up, and creates if absent, a lockable buffer for
  *	a given range of an inode.  The buffer is returned
@@ -488,16 +546,13 @@ _xfs_buf_find(
 	xfs_buf_t		*new_bp)
 {
 	struct xfs_perag	*pag;
-	struct rb_node		**rbp;
-	struct rb_node		*parent;
 	xfs_buf_t		*bp;
-	xfs_daddr_t		blkno = map[0].bm_bn;
+	struct xfs_buf_cmp_arg	cmp_arg = { .blkno = map[0].bm_bn };
 	xfs_daddr_t		eofs;
-	int			numblks = 0;
 	int			i;
 
 	for (i = 0; i < nmaps; i++)
-		numblks += map[i].bm_len;
+		cmp_arg.numblks += map[i].bm_len;
 
 	/* Check for IOs smaller than the sector size / not sector aligned */
 	ASSERT(!(BBTOB(numblks) < btp->bt_meta_sectorsize));
@@ -508,7 +563,7 @@ _xfs_buf_find(
 	 * have to check that the buffer falls within the filesystem bounds.
 	 */
 	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
-	if (blkno < 0 || blkno >= eofs) {
+	if (cmp_arg.blkno < 0 || cmp_arg.blkno >= eofs) {
 		/*
 		 * XXX (dgc): we should really be returning -EFSCORRUPTED here,
 		 * but none of the higher level infrastructure supports
@@ -516,53 +571,31 @@ _xfs_buf_find(
 		 */
 		xfs_alert(btp->bt_mount,
 			  "%s: Block out of range: block 0x%llx, EOFS 0x%llx ",
-			  __func__, blkno, eofs);
+			  __func__, cmp_arg.blkno, eofs);
 		WARN_ON(1);
 		return NULL;
 	}
 
-	/* get tree root */
+	/* get pag */
 	pag = xfs_perag_get(btp->bt_mount,
-				xfs_daddr_to_agno(btp->bt_mount, blkno));
+			    xfs_daddr_to_agno(btp->bt_mount, cmp_arg.blkno));
 
-	/* walk tree */
+	/* lookup buf in pag hash */
 	spin_lock(&pag->pag_buf_lock);
-	rbp = &pag->pag_buf_tree.rb_node;
-	parent = NULL;
-	bp = NULL;
-	while (*rbp) {
-		parent = *rbp;
-		bp = rb_entry(parent, struct xfs_buf, b_rbnode);
-
-		if (blkno < bp->b_bn)
-			rbp = &(*rbp)->rb_left;
-		else if (blkno > bp->b_bn)
-			rbp = &(*rbp)->rb_right;
-		else {
-			/*
-			 * found a block number match. If the range doesn't
-			 * match, the only way this is allowed is if the buffer
-			 * in the cache is stale and the transaction that made
-			 * it stale has not yet committed. i.e. we are
-			 * reallocating a busy extent. Skip this buffer and
-			 * continue searching to the right for an exact match.
-			 */
-			if (bp->b_length != numblks) {
-				ASSERT(bp->b_flags & XBF_STALE);
-				rbp = &(*rbp)->rb_right;
-				continue;
-			}
-			atomic_inc(&bp->b_hold);
-			goto found;
-		}
+	bp = rhashtable_lookup_fast(&pag->pag_buf_hash, &cmp_arg,
+				    xfs_buf_hash_params);
+	if (bp) {
+		atomic_inc(&bp->b_hold);
+		goto found;
 	}
 
 	/* No match found */
 	if (new_bp) {
-		rb_link_node(&new_bp->b_rbnode, parent, rbp);
-		rb_insert_color(&new_bp->b_rbnode, &pag->pag_buf_tree);
 		/* the buffer keeps the perag reference until it is freed */
 		new_bp->b_pag = pag;
+		rhashtable_insert_fast(&pag->pag_buf_hash,
+				       &new_bp->b_rhash_head,
+				       xfs_buf_hash_params);
 		spin_unlock(&pag->pag_buf_lock);
 	} else {
 		XFS_STATS_INC(btp->bt_mount, xb_miss_locked);
@@ -983,7 +1016,8 @@ xfs_buf_rele(
 		}
 
 		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
-		rb_erase(&bp->b_rbnode, &pag->pag_buf_tree);
+		rhashtable_remove_fast(&pag->pag_buf_hash, &bp->b_rhash_head,
+				       xfs_buf_hash_params);
 		spin_unlock(&pag->pag_buf_lock);
 		xfs_perag_put(pag);
 		freebuf = true;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 1c2e52b..37943ac 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -150,7 +150,7 @@ typedef struct xfs_buf {
 	 * which is the only bit that is touched if we hit the semaphore
 	 * fast-path on locking.
 	 */
-	struct rb_node		b_rbnode;	/* rbtree node */
+	struct rhash_head	b_rhash_head;	/* pag buffer hash node */
 	xfs_daddr_t		b_bn;		/* block number of buffer */
 	int			b_length;	/* size of buffer in BBs */
 	atomic_t		b_hold;		/* reference count */
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 68640fb..a415f82 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -78,6 +78,7 @@ typedef __u32			xfs_nlink_t;
 #include <linux/freezer.h>
 #include <linux/list_sort.h>
 #include <linux/ratelimit.h>
+#include <linux/rhashtable.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index fc78739..b9a9a58 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -157,6 +157,7 @@ xfs_free_perag(
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
 		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
 	}
 }
@@ -212,8 +213,8 @@ xfs_initialize_perag(
 		spin_lock_init(&pag->pag_ici_lock);
 		mutex_init(&pag->pag_ici_reclaim_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-		spin_lock_init(&pag->pag_buf_lock);
-		pag->pag_buf_tree = RB_ROOT;
+		if (xfs_buf_hash_init(pag))
+			goto out_unwind;
 
 		if (radix_tree_preload(GFP_NOFS))
 			goto out_unwind;
@@ -239,9 +240,11 @@ xfs_initialize_perag(
 	return 0;
 
 out_unwind:
+	xfs_buf_hash_destroy(pag);
 	kmem_free(pag);
 	for (; index > first_initialised; index--) {
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
+		xfs_buf_hash_destroy(pag);
 		kmem_free(pag);
 	}
 	return error;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 819b80b..84f7852 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -393,8 +393,8 @@ typedef struct xfs_perag {
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
 	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_tree */
-	struct rb_root	pag_buf_tree;	/* ordered tree of active buffers */
+	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
+	struct rhashtable pag_buf_hash;
 
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
@@ -424,6 +424,9 @@ xfs_perag_resv(
 	}
 }
 
+int xfs_buf_hash_init(xfs_perag_t *pag);
+void xfs_buf_hash_destroy(xfs_perag_t *pag);
+
 extern void	xfs_uuid_table_free(void);
 extern int	xfs_log_sbcount(xfs_mount_t *);
 extern __uint64_t xfs_default_resblks(xfs_mount_t *mp);
-- 
2.7.4

