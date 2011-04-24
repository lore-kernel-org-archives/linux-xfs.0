Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3OJ3RLT075622 for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 14:03:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FC3316438D4
	for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 12:06:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yLSS9kzLZOtM0IWS for
	<xfs@oss.sgi.com>; Sun, 24 Apr 2011 12:06:57 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QE4e1-0000jr-9K
	for xfs@oss.sgi.com; Sun, 24 Apr 2011 19:06:57 +0000
Message-Id: <20110424190657.249817918@bombadil.infradead.org>
Date: Sun, 24 Apr 2011 15:06:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: reduce the number of pagb_lock roundtrips in
	xfs_alloc_clear_busy
References: <20110424190613.404786382@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-reduce-pagb_lock-roundtrips
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Instead of finding the per-ag and then taking and releasing the pagb_lock
for every single busy extent completed sort the list of busy extents and
only switch betweens AGs where nessecary.  This becomes especially important
with the online discard support which will hit this lock more often.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_alloc.c
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.c	2011-04-15 09:47:49.034982545 +0200
+++ xfs/fs/xfs/xfs_alloc.c	2011-04-15 11:56:01.049977986 +0200
@@ -2968,24 +2968,60 @@ fail:
 	*rlen = 0;
 }
 
-void
-xfs_alloc_busy_clear(
+static void
+xfs_alloc_busy_clear_one(
 	struct xfs_mount	*mp,
+	struct xfs_perag	*pag,
 	struct xfs_busy_extent	*busyp)
 {
-	struct xfs_perag	*pag;
-
-	list_del_init(&busyp->list);
-
-	pag = xfs_perag_get(mp, busyp->agno);
-	spin_lock(&pag->pagb_lock);
 	if (busyp->length) {
 		trace_xfs_alloc_busy_clear(mp, busyp->agno, busyp->bno,
 						busyp->length);
 		rb_erase(&busyp->rb_node, &pag->pagb_tree);
 	}
-	spin_unlock(&pag->pagb_lock);
-	xfs_perag_put(pag);
 
+	list_del_init(&busyp->list);
 	kmem_free(busyp);
 }
+
+void
+xfs_alloc_busy_clear(
+	struct xfs_mount	*mp,
+	struct list_head	*list)
+{
+	struct xfs_busy_extent	*busyp, *n;
+	struct xfs_perag	*pag = NULL;
+	xfs_agnumber_t		agno = NULLAGNUMBER;
+
+	list_for_each_entry_safe(busyp, n, list, list) {
+		if (busyp->agno != agno) {
+			if (pag) {
+				spin_unlock(&pag->pagb_lock);
+				xfs_perag_put(pag);
+			}
+			pag = xfs_perag_get(mp, busyp->agno);
+			spin_lock(&pag->pagb_lock);
+			agno = busyp->agno;
+		}
+
+		xfs_alloc_busy_clear_one(mp, pag, busyp);
+	}
+
+	if (pag) {
+		spin_unlock(&pag->pagb_lock);
+		xfs_perag_put(pag);
+	}
+}
+
+/*
+ * Callback for list_sort to sort busy extents by the AG they reside in.
+ */
+int
+xfs_busy_extent_ag_cmp(
+	void			*priv,
+	struct list_head	*a,
+	struct list_head	*b)
+{
+	return container_of(a, struct xfs_busy_extent, list)->agno -
+		container_of(b, struct xfs_busy_extent, list)->agno;
+}
Index: xfs/fs/xfs/xfs_alloc.h
===================================================================
--- xfs.orig/fs/xfs/xfs_alloc.h	2011-04-15 09:47:49.041649176 +0200
+++ xfs/fs/xfs/xfs_alloc.h	2011-04-15 11:56:05.426620946 +0200
@@ -140,7 +140,7 @@ xfs_alloc_busy_insert(struct xfs_trans *
 	xfs_agblock_t bno, xfs_extlen_t len);
 
 void
-xfs_alloc_busy_clear(struct xfs_mount *mp, struct xfs_busy_extent *busyp);
+xfs_alloc_busy_clear(struct xfs_mount *mp, struct list_head *list);
 
 int
 xfs_alloc_busy_search(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -149,6 +149,15 @@ xfs_alloc_busy_search(struct xfs_mount *
 void
 xfs_alloc_busy_reuse(struct xfs_mount *mp, xfs_agnumber_t agno,
 	xfs_agblock_t fbno, xfs_extlen_t flen, bool userdata);
+
+int
+xfs_busy_extent_ag_cmp(void *priv, struct list_head *a, struct list_head *b);
+
+static inline void xfs_alloc_busy_sort(struct list_head *list)
+{
+	list_sort(NULL, list, xfs_busy_extent_ag_cmp);
+}
+
 #endif	/* __KERNEL__ */
 
 /*
Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-04-15 09:47:49.048315806 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2011-04-15 11:53:09.594240178 +0200
@@ -361,13 +361,12 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
-	struct xfs_busy_extent	*busyp, *n;
 
 	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
 					ctx->start_lsn, abort);
 
-	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
-		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
+	xfs_alloc_busy_sort(&ctx->busy_extents);
+	xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, &ctx->busy_extents);
 
 	spin_lock(&ctx->cil->xc_cil_lock);
 	list_del(&ctx->committing);
Index: xfs/fs/xfs/xfs_trans.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans.c	2011-04-15 09:47:49.054982436 +0200
+++ xfs/fs/xfs/xfs_trans.c	2011-04-15 11:53:24.300827172 +0200
@@ -608,10 +608,8 @@ STATIC void
 xfs_trans_free(
 	struct xfs_trans	*tp)
 {
-	struct xfs_busy_extent	*busyp, *n;
-
-	list_for_each_entry_safe(busyp, n, &tp->t_busy, list)
-		xfs_alloc_busy_clear(tp->t_mountp, busyp);
+	xfs_alloc_busy_sort(&tp->t_busy);
+	xfs_alloc_busy_clear(tp->t_mountp, &tp->t_busy);
 
 	atomic_dec(&tp->t_mountp->m_active_trans);
 	xfs_trans_free_dqinfo(tp);
Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-04-15 11:53:44.480717849 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-04-15 11:53:47.934032472 +0200
@@ -33,7 +33,6 @@
 #include <linux/migrate.h>
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
-#include <linux/list_sort.h>
 
 #include "xfs_sb.h"
 #include "xfs_inum.h"
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2011-04-15 11:53:44.500717739 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2011-04-15 11:53:53.234003761 +0200
@@ -70,6 +70,7 @@
 #include <linux/ctype.h>
 #include <linux/writeback.h>
 #include <linux/capability.h>
+#include <linux/list_sort.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
