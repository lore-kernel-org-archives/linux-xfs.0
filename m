Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:59679 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753889AbeAQUXA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jan 2018 15:23:00 -0500
From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 80/99] blk-ioc: Convert to XArray
Date: Wed, 17 Jan 2018 12:21:44 -0800
Message-Id: <20180117202203.19756-81-willy@infradead.org>
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Skip converting the lock to use xa_lock; I think this code can live with
the double-locking.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 block/blk-ioc.c           | 13 +++++++------
 include/linux/iocontext.h |  6 +++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index f23311e4b201..baf83c8ac503 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -68,7 +68,7 @@ static void ioc_destroy_icq(struct io_cq *icq)
 
 	lockdep_assert_held(&ioc->lock);
 
-	radix_tree_delete(&ioc->icq_tree, icq->q->id);
+	xa_erase(&ioc->icq_array, icq->q->id);
 	hlist_del_init(&icq->ioc_node);
 	list_del_init(&icq->q_node);
 
@@ -278,7 +278,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 	atomic_set(&ioc->nr_tasks, 1);
 	atomic_set(&ioc->active_ref, 1);
 	spin_lock_init(&ioc->lock);
-	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
+	xa_init_flags(&ioc->icq_array, XA_FLAGS_LOCK_IRQ);
 	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
@@ -363,7 +363,7 @@ struct io_cq *ioc_lookup_icq(struct io_context *ioc, struct request_queue *q)
 	if (icq && icq->q == q)
 		goto out;
 
-	icq = radix_tree_lookup(&ioc->icq_tree, q->id);
+	icq = xa_load(&ioc->icq_array, q->id);
 	if (icq && icq->q == q)
 		rcu_assign_pointer(ioc->icq_hint, icq);	/* allowed to race */
 	else
@@ -398,7 +398,7 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 	if (!icq)
 		return NULL;
 
-	if (radix_tree_maybe_preload(gfp_mask) < 0) {
+	if (xa_reserve(&ioc->icq_array, q->id, gfp_mask)) {
 		kmem_cache_free(et->icq_cache, icq);
 		return NULL;
 	}
@@ -412,7 +412,8 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 	spin_lock_irq(q->queue_lock);
 	spin_lock(&ioc->lock);
 
-	if (likely(!radix_tree_insert(&ioc->icq_tree, q->id, icq))) {
+	if (likely(!xa_store(&ioc->icq_array, q->id, icq,
+						GFP_ATOMIC | __GFP_HIGH))) {
 		hlist_add_head(&icq->ioc_node, &ioc->icq_list);
 		list_add(&icq->q_node, &q->icq_list);
 		if (et->uses_mq && et->ops.mq.init_icq)
@@ -421,6 +422,7 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 			et->ops.sq.elevator_init_icq_fn(icq);
 	} else {
 		kmem_cache_free(et->icq_cache, icq);
+		xa_erase(&ioc->icq_array, q->id);
 		icq = ioc_lookup_icq(ioc, q);
 		if (!icq)
 			printk(KERN_ERR "cfq: icq link failed!\n");
@@ -428,7 +430,6 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 
 	spin_unlock(&ioc->lock);
 	spin_unlock_irq(q->queue_lock);
-	radix_tree_preload_end();
 	return icq;
 }
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index dba15ca8e60b..e16224f70084 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -2,9 +2,9 @@
 #ifndef IOCONTEXT_H
 #define IOCONTEXT_H
 
-#include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 
 enum {
 	ICQ_EXITED		= 1 << 2,
@@ -56,7 +56,7 @@ enum {
  * - ioc->icq_list and icq->ioc_node are protected by ioc lock.
  *   q->icq_list and icq->q_node by q lock.
  *
- * - ioc->icq_tree and ioc->icq_hint are protected by ioc lock, while icq
+ * - ioc->icq_array and ioc->icq_hint are protected by ioc lock, while icq
  *   itself is protected by q lock.  However, both the indexes and icq
  *   itself are also RCU managed and lookup can be performed holding only
  *   the q lock.
@@ -111,7 +111,7 @@ struct io_context {
 	int nr_batch_requests;     /* Number of requests left in the batch */
 	unsigned long last_waited; /* Time last woken after wait for request */
 
-	struct radix_tree_root	icq_tree;
+	struct xarray		icq_array;
 	struct io_cq __rcu	*icq_hint;
 	struct hlist_head	icq_list;
 
-- 
2.15.1

