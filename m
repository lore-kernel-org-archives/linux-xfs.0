Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p44IuXR2088827 for <xfs@oss.sgi.com>; Wed, 4 May 2011 13:56:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 357FC11CD885
	for <xfs@oss.sgi.com>; Wed,  4 May 2011 12:00:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mZAtcXrwXFqtrNTC for
	<xfs@oss.sgi.com>; Wed, 04 May 2011 12:00:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QHhIx-00024p-IB
	for xfs@oss.sgi.com; Wed, 04 May 2011 19:00:11 +0000
Message-Id: <20110504190011.508745503@bombadil.infradead.org>
Date: Wed, 04 May 2011 14:55:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] xfs: add a reference count to the CIL context
References: <20110504185513.136746538@bombadil.infradead.org>
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
--- xfs.orig/fs/xfs/xfs_log_cil.c	2011-05-03 12:00:49.000000000 +0200
+++ xfs/fs/xfs/xfs_log_cil.c	2011-05-03 12:17:19.399350953 +0200
@@ -20,7 +20,7 @@
 #include "xfs_types.h"
 #include "xfs_bit.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
+#include "xfs_inum.h" 
 #include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_log_priv.h"
@@ -31,6 +31,46 @@
 #include "xfs_alloc.h"
 #include "xfs_discard.h"
 
+static void
+xlog_cil_ctx_free(
+	struct xfs_cil_ctx	*ctx)
+{
+	if (!list_empty(&ctx->busy_extents)) {
+		xfs_alloc_busy_clear(ctx->cil->xc_log->l_mp,
+				     &ctx->busy_extents, false);
+	}
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
@@ -64,12 +104,7 @@ xlog_cil_init(
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
@@ -381,10 +416,10 @@ xlog_cil_committed(
 		ASSERT(mp->m_flags & XFS_MOUNT_DISCARD);
 
 		xfs_discard_extents(mp, &ctx->busy_extents);
-		xfs_alloc_busy_clear(mp, &ctx->busy_extents, false);
 	}
 
-	kmem_free(ctx);
+	if (atomic_dec_and_test(&ctx->ref))
+		xlog_cil_ctx_free(ctx);
 }
 
 /*
@@ -491,18 +526,7 @@ xlog_cil_push(
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
--- xfs.orig/fs/xfs/xfs_log_priv.h	2011-05-03 11:41:29.000000000 +0200
+++ xfs/fs/xfs/xfs_log_priv.h	2011-05-03 12:13:49.743820088 +0200
@@ -390,6 +390,8 @@ struct xfs_cil_ctx {
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
