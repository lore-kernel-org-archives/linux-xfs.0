Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2VBQeU1137789 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 06:26:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E1EC3391846
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GFWpXbCDYyoZk7dT for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:52 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q5G4W-0006Pr-Bt
	for xfs@oss.sgi.com; Thu, 31 Mar 2011 11:29:52 +0000
Message-Id: <20110331112952.333209372@bombadil.infradead.org>
Date: Thu, 31 Mar 2011 07:28:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/5] xfs: add a reference count to the CIL context
References: <20110331112850.980290062@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cil-ctx-refcounting
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

For the upcoming asynchronoyus discard support we need to be able to delay
freeing the CIL context until the last discard request that reference it
has completed.  Add a reference count to the CIL context, and only clear
the busy extents and free the CIL context structure when it reaches zero,
and a work item to allow freeing it from irq context.

Note that this means delaying the clearing of the busy extents for a little
bit even on non-discard mounts, but with the new busy extent trim/reuse
code there is no real life impact of this change.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_cil.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-03-28 15:41:39.062838900 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2011-03-28 16:47:04.658839185 +0200
@@ -30,6 +30,46 @@
 #include "xfs_error.h"
 #include "xfs_alloc.h"
 
+static void
+xlog_cil_ctx_free(
+	struct xfs_cil_ctx	*ctx)
+{
+	struct xfs_busy_extent	*busyp, *n;
+
+	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
+		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
+	kmem_free(ctx);
+}
+
+static void
+xlog_cil_ctx_free_work(
+	struct work_struct	*work)
+{
+	xlog_cil_ctx_free(container_of(work, struct xfs_cil_ctx, work));
+}
+
+static void
+xlog_cil_ctx_init(
+	struct xfs_cil_ctx	*ctx,
+	struct xfs_cil		*cil,
+	xfs_lsn_t		sequence)
+{
+	INIT_LIST_HEAD(&ctx->committing);
+	INIT_LIST_HEAD(&ctx->busy_extents);
+	ctx->sequence = sequence;
+	ctx->cil = cil;
+	atomic_set(&ctx->ref, 1);
+	INIT_WORK(&ctx->work, xlog_cil_ctx_free_work);
+	cil->xc_ctx = ctx;
+
+	/*
+	 * Mirror the sequence into the cil structure so that we can do
+	 * unlocked checks against the current sequence in log forces without
+	 * risking deferencing a freed context pointer.
+	 */
+	cil->xc_current_sequence = ctx->sequence;
+}
+
 /*
  * Perform initial CIL structure initialisation. If the CIL is not
  * enabled in this filesystem, ensure the log->l_cilp is null so
@@ -63,12 +103,7 @@ xlog_cil_init(
 	init_rwsem(&cil->xc_ctx_lock);
 	init_waitqueue_head(&cil->xc_commit_wait);
 
-	INIT_LIST_HEAD(&ctx->committing);
-	INIT_LIST_HEAD(&ctx->busy_extents);
-	ctx->sequence = 1;
-	ctx->cil = cil;
-	cil->xc_ctx = ctx;
-	cil->xc_current_sequence = ctx->sequence;
+	xlog_cil_ctx_init(ctx, cil, 1);
 
 	cil->xc_log = log;
 	log->l_cilp = cil;
@@ -361,20 +396,17 @@ xlog_cil_committed(
 	int	abort)
 {
 	struct xfs_cil_ctx	*ctx = args;
-	struct xfs_busy_extent	*busyp, *n;
 
 	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
 					ctx->start_lsn, abort);
 
-	list_for_each_entry_safe(busyp, n, &ctx->busy_extents, list)
-		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp, busyp);
-
 	spin_lock(&ctx->cil->xc_cil_lock);
 	list_del(&ctx->committing);
 	spin_unlock(&ctx->cil->xc_cil_lock);
 
 	xlog_cil_free_logvec(ctx->lv_chain);
-	kmem_free(ctx);
+	if (atomic_dec_and_test(&ctx->ref))
+		xlog_cil_ctx_free(ctx);
 }
 
 /*
@@ -481,18 +513,7 @@ xlog_cil_push(
 	 * during log forces to extract the commit lsn of the sequence that
 	 * needs to be forced.
 	 */
-	INIT_LIST_HEAD(&new_ctx->committing);
-	INIT_LIST_HEAD(&new_ctx->busy_extents);
-	new_ctx->sequence = ctx->sequence + 1;
-	new_ctx->cil = cil;
-	cil->xc_ctx = new_ctx;
-
-	/*
-	 * mirror the new sequence into the cil structure so that we can do
-	 * unlocked checks against the current sequence in log forces without
-	 * risking deferencing a freed context pointer.
-	 */
-	cil->xc_current_sequence = new_ctx->sequence;
+	xlog_cil_ctx_init(new_ctx, cil, ctx->sequence + 1);
 
 	/*
 	 * The switch is now done, so we can drop the context lock and move out
Index: xfs/fs/xfs/xfs_log_priv.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log_priv.h	2011-03-28 16:06:20.398888649 +0200
+++ xfs/fs/xfs/xfs_log_priv.h	2011-03-28 16:47:04.662839297 +0200
@@ -389,6 +389,8 @@ struct xfs_cil_ctx {
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	xfs_log_callback_t	log_cb;		/* completion callback hook. */
 	struct list_head	committing;	/* ctx committing list */
+	atomic_t		ref;		/* reference count */
+	struct work_struct	work;		/* for deferred freeing */
 };
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
