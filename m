Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECA24C83F2D
	for <linux-xfs@archiver.kernel.org>; Sun,  3 Sep 2023 23:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349147AbjICX3e (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 19:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjICX3e (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Sep 2023 19:29:34 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA0BCE
        for <linux-xfs@vger.kernel.org>; Sun,  3 Sep 2023 16:29:29 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1d4c9494b42so625580fac.0
        for <linux-xfs@vger.kernel.org>; Sun, 03 Sep 2023 16:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693783769; x=1694388569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aGXhpJq+YjD0jPNofuAQcNK7A0Ija2ffO6jhTXMb3sY=;
        b=RJ3CUzrATpJUgodj8zPxW4Bq9IP2e8gzvMkD4AE3nlFSrLc64v7qqphbORyjEwH0fO
         qvIat6IbSCpyPfMiNl4uUMdgjDNNrRHM22xsw/UwidoIU0YNZL01jrV2lf3YBUQ1e6kn
         YEnwxMtulJWG+C3VFG8/jW9riu/8ht5ChLWcLpCL2/1DIif7LgsSitqGbAXazJl5b74Q
         ZmQN4nAV3tqGwxFRz2H6vxUK6X02Qx7l01kmATAs2JPTbvVQECXlKibR5BwEBYACL0RN
         MX/2lJIZ4AGCB1RiKeXOxkF/0DkKvI6LnrxIExymT93DCye7i/sMzi0qSMyNpqTb9ww8
         maZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693783769; x=1694388569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGXhpJq+YjD0jPNofuAQcNK7A0Ija2ffO6jhTXMb3sY=;
        b=OYzHcS5m1wBwbmTV23VIHXMjiDDU9Prfo9Wq3LoclPmvb7fXB71crBUUSPgriXcT5R
         mpU/3qnlZpyMN7CmAXl09YpzKR9Up/kDMvZBeWznoFp5aaTAzGqKwVNPEAffiVw8p/EX
         aGxsKHg7Nc3eB+0YvDXy8PuFahA9e1iw7po+uVMI/jvxjR/QzB8AL/b4wJMCYhDEzp1G
         QY73QefaxgDI8nSeknz9Qugm6yolOBn+GrZopnxs8eG4RNgOnf6eylufI2KtKckdfcml
         vvk1jsc/1QsCL8xFxyEwFvJoRmxDik1N91nYDB3f2zCHTKodHPMSTJjgFzfzWxPM3JDm
         iecg==
X-Gm-Message-State: AOJu0Yzyh8dxKyW2zexBGzh+AWkSpYdtlm/fmrfMUvjqudsA3ohVojWy
        MiLgA9TXaZeeyhRFJT24aqMZaYFjmJ1Q+S3ozrk=
X-Google-Smtp-Source: AGHT+IHIeZg7H1+22ljKg12VgAoNQ2cIg8VWsq8A4zHfg+B7sWncAGDoQMEuVd7pxGTdXTa5l7apNA==
X-Received: by 2002:a05:6870:2492:b0:1a6:c968:4a15 with SMTP id s18-20020a056870249200b001a6c9684a15mr11765071oaq.4.1693783768899;
        Sun, 03 Sep 2023 16:29:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id k22-20020a635a56000000b00570935a3d4asm1847058pgm.56.2023.09.03.16.29.27
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 16:29:28 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qcwWz-00ATP9-25
        for linux-xfs@vger.kernel.org;
        Mon, 04 Sep 2023 09:29:25 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qcwWz-000tn0-11
        for linux-xfs@vger.kernel.org;
        Mon, 04 Sep 2023 09:29:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: move log discard work to xfs_discard.c
Date:   Mon,  4 Sep 2023 09:29:22 +1000
Message-Id: <20230903232923.211003-2-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230903232923.211003-1-david@fromorbit.com>
References: <20230903232923.211003-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because we are going to use the same list-based discard submission
interface for fstrim-based discards, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c     | 77 +++++++++++++++++++++++++++++++-
 fs/xfs/xfs_discard.h     |  6 ++-
 fs/xfs/xfs_extent_busy.h | 20 +++++++--
 fs/xfs/xfs_log_cil.c     | 96 +++++++---------------------------------
 fs/xfs/xfs_log_priv.h    |  5 ++-
 5 files changed, 115 insertions(+), 89 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index afc4c78b9eed..3f45c7bb94f2 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Copyright (C) 2010 Red Hat, Inc.
+ * Copyright (C) 2010, 2023 Red Hat, Inc.
  * All Rights Reserved.
  */
 #include "xfs.h"
@@ -19,6 +19,81 @@
 #include "xfs_log.h"
 #include "xfs_ag.h"
 
+struct workqueue_struct *xfs_discard_wq;
+
+static void
+xfs_discard_endio_work(
+	struct work_struct	*work)
+{
+	struct xfs_busy_extents	*extents =
+		container_of(work, struct xfs_busy_extents, endio_work);
+
+	xfs_extent_busy_clear(extents->mount, &extents->extent_list, false);
+	kmem_free(extents->owner);
+}
+
+/*
+ * Queue up the actual completion to a thread to avoid IRQ-safe locking for
+ * pagb_lock.
+ */
+static void
+xfs_discard_endio(
+	struct bio		*bio)
+{
+	struct xfs_busy_extents	*extents = bio->bi_private;
+
+	INIT_WORK(&extents->endio_work, xfs_discard_endio_work);
+	queue_work(xfs_discard_wq, &extents->endio_work);
+	bio_put(bio);
+}
+
+/*
+ * Walk the discard list and issue discards on all the busy extents in the
+ * list. We plug and chain the bios so that we only need a single completion
+ * call to clear all the busy extents once the discards are complete.
+ */
+int
+xfs_discard_extents(
+	struct xfs_mount	*mp,
+	struct xfs_busy_extents	*extents)
+{
+	struct xfs_extent_busy	*busyp;
+	struct bio		*bio = NULL;
+	struct blk_plug		plug;
+	int			error = 0;
+
+	blk_start_plug(&plug);
+	list_for_each_entry(busyp, &extents->extent_list, list) {
+		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
+					 busyp->length);
+
+		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
+				XFS_FSB_TO_BB(mp, busyp->length),
+				GFP_NOFS, &bio);
+		if (error && error != -EOPNOTSUPP) {
+			xfs_info(mp,
+	 "discard failed for extent [0x%llx,%u], error %d",
+				 (unsigned long long)busyp->bno,
+				 busyp->length,
+				 error);
+			break;
+		}
+	}
+
+	if (bio) {
+		bio->bi_private = extents;
+		bio->bi_end_io = xfs_discard_endio;
+		submit_bio(bio);
+	} else {
+		xfs_discard_endio_work(&extents->endio_work);
+	}
+	blk_finish_plug(&plug);
+
+	return error;
+}
+
+
 STATIC int
 xfs_trim_extents(
 	struct xfs_perag	*pag,
diff --git a/fs/xfs/xfs_discard.h b/fs/xfs/xfs_discard.h
index de92d9cc958f..2b1a85223a56 100644
--- a/fs/xfs/xfs_discard.h
+++ b/fs/xfs/xfs_discard.h
@@ -3,8 +3,10 @@
 #define XFS_DISCARD_H 1
 
 struct fstrim_range;
-struct list_head;
+struct xfs_mount;
+struct xfs_busy_extents;
 
-extern int	xfs_ioc_trim(struct xfs_mount *, struct fstrim_range __user *);
+int xfs_discard_extents(struct xfs_mount *mp, struct xfs_busy_extents *busy);
+int xfs_ioc_trim(struct xfs_mount *mp, struct fstrim_range __user *fstrim);
 
 #endif /* XFS_DISCARD_H */
diff --git a/fs/xfs/xfs_extent_busy.h b/fs/xfs/xfs_extent_busy.h
index c37bf87e6781..71c28d031e3b 100644
--- a/fs/xfs/xfs_extent_busy.h
+++ b/fs/xfs/xfs_extent_busy.h
@@ -16,9 +16,6 @@ struct xfs_alloc_arg;
 /*
  * Busy block/extent entry.  Indexed by a rbtree in perag to mark blocks that
  * have been freed but whose transactions aren't committed to disk yet.
- *
- * Note that we use the transaction ID to record the transaction, not the
- * transaction structure itself. See xfs_extent_busy_insert() for details.
  */
 struct xfs_extent_busy {
 	struct rb_node	rb_node;	/* ag by-bno indexed search tree */
@@ -31,6 +28,23 @@ struct xfs_extent_busy {
 #define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
 };
 
+/*
+ * List used to track groups of related busy extents all the way through
+ * to discard completion.
+ */
+struct xfs_busy_extents {
+	struct xfs_mount	*mount;
+	struct list_head	extent_list;
+	struct work_struct	endio_work;
+
+	/*
+	 * Owner is the object containing the struct xfs_busy_extents to free
+	 * once the busy extents have been processed. If only the
+	 * xfs_busy_extents object needs freeing, then point this at itself.
+	 */
+	void			*owner;
+};
+
 void
 xfs_extent_busy_insert(struct xfs_trans *tp, struct xfs_perag *pag,
 	xfs_agblock_t bno, xfs_extlen_t len, unsigned int flags);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 68fcb2a2430d..59856fac23f0 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -16,8 +16,7 @@
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_trace.h"
-
-struct workqueue_struct *xfs_discard_wq;
+#include "xfs_discard.h"
 
 /*
  * Allocate a new ticket. Failing to get a new ticket makes it really hard to
@@ -103,7 +102,7 @@ xlog_cil_ctx_alloc(void)
 
 	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
 	INIT_LIST_HEAD(&ctx->committing);
-	INIT_LIST_HEAD(&ctx->busy_extents);
+	INIT_LIST_HEAD(&ctx->busy_extents.extent_list);
 	INIT_LIST_HEAD(&ctx->log_items);
 	INIT_LIST_HEAD(&ctx->lv_chain);
 	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
@@ -132,7 +131,7 @@ xlog_cil_push_pcp_aggregate(
 
 		if (!list_empty(&cilpcp->busy_extents)) {
 			list_splice_init(&cilpcp->busy_extents,
-					&ctx->busy_extents);
+					&ctx->busy_extents.extent_list);
 		}
 		if (!list_empty(&cilpcp->log_items))
 			list_splice_init(&cilpcp->log_items, &ctx->log_items);
@@ -870,76 +869,6 @@ xlog_cil_free_logvec(
 	}
 }
 
-static void
-xlog_discard_endio_work(
-	struct work_struct	*work)
-{
-	struct xfs_cil_ctx	*ctx =
-		container_of(work, struct xfs_cil_ctx, discard_endio_work);
-	struct xfs_mount	*mp = ctx->cil->xc_log->l_mp;
-
-	xfs_extent_busy_clear(mp, &ctx->busy_extents, false);
-	kmem_free(ctx);
-}
-
-/*
- * Queue up the actual completion to a thread to avoid IRQ-safe locking for
- * pagb_lock.  Note that we need a unbounded workqueue, otherwise we might
- * get the execution delayed up to 30 seconds for weird reasons.
- */
-static void
-xlog_discard_endio(
-	struct bio		*bio)
-{
-	struct xfs_cil_ctx	*ctx = bio->bi_private;
-
-	INIT_WORK(&ctx->discard_endio_work, xlog_discard_endio_work);
-	queue_work(xfs_discard_wq, &ctx->discard_endio_work);
-	bio_put(bio);
-}
-
-static void
-xlog_discard_busy_extents(
-	struct xfs_mount	*mp,
-	struct xfs_cil_ctx	*ctx)
-{
-	struct list_head	*list = &ctx->busy_extents;
-	struct xfs_extent_busy	*busyp;
-	struct bio		*bio = NULL;
-	struct blk_plug		plug;
-	int			error = 0;
-
-	ASSERT(xfs_has_discard(mp));
-
-	blk_start_plug(&plug);
-	list_for_each_entry(busyp, list, list) {
-		trace_xfs_discard_extent(mp, busyp->agno, busyp->bno,
-					 busyp->length);
-
-		error = __blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
-				XFS_AGB_TO_DADDR(mp, busyp->agno, busyp->bno),
-				XFS_FSB_TO_BB(mp, busyp->length),
-				GFP_NOFS, &bio);
-		if (error && error != -EOPNOTSUPP) {
-			xfs_info(mp,
-	 "discard failed for extent [0x%llx,%u], error %d",
-				 (unsigned long long)busyp->bno,
-				 busyp->length,
-				 error);
-			break;
-		}
-	}
-
-	if (bio) {
-		bio->bi_private = ctx;
-		bio->bi_end_io = xlog_discard_endio;
-		submit_bio(bio);
-	} else {
-		xlog_discard_endio_work(&ctx->discard_endio_work);
-	}
-	blk_finish_plug(&plug);
-}
-
 /*
  * Mark all items committed and clear busy extents. We free the log vector
  * chains in a separate pass so that we unpin the log items as quickly as
@@ -968,8 +897,8 @@ xlog_cil_committed(
 
 	xlog_cil_ail_insert(ctx, abort);
 
-	xfs_extent_busy_sort(&ctx->busy_extents);
-	xfs_extent_busy_clear(mp, &ctx->busy_extents,
+	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
+	xfs_extent_busy_clear(mp, &ctx->busy_extents.extent_list,
 			      xfs_has_discard(mp) && !abort);
 
 	spin_lock(&ctx->cil->xc_push_lock);
@@ -978,10 +907,14 @@ xlog_cil_committed(
 
 	xlog_cil_free_logvec(&ctx->lv_chain);
 
-	if (!list_empty(&ctx->busy_extents))
-		xlog_discard_busy_extents(mp, ctx);
-	else
-		kmem_free(ctx);
+	if (!list_empty(&ctx->busy_extents.extent_list)) {
+		ctx->busy_extents.mount = mp;
+		ctx->busy_extents.owner = ctx;
+		xfs_discard_extents(mp, &ctx->busy_extents);
+		return;
+	}
+
+	kmem_free(ctx);
 }
 
 void
@@ -1989,7 +1922,8 @@ xlog_cil_pcp_dead(
 	if (!list_empty(&cilpcp->log_items))
 		list_splice_init(&cilpcp->log_items, &ctx->log_items);
 	if (!list_empty(&cilpcp->busy_extents))
-		list_splice_init(&cilpcp->busy_extents, &ctx->busy_extents);
+		list_splice_init(&cilpcp->busy_extents,
+				&ctx->busy_extents.extent_list);
 	atomic_add(cilpcp->space_used, &ctx->space_used);
 	cilpcp->space_used = 0;
 	up_write(&cil->xc_ctx_lock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index c7ae9172dcd9..afd74ded5b5e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_LOG_PRIV_H__
 #define __XFS_LOG_PRIV_H__
 
+#include "xfs_extent_busy.h"	/* for struct xfs_busy_extents */
+
 struct xfs_buf;
 struct xlog;
 struct xlog_ticket;
@@ -223,12 +225,11 @@ struct xfs_cil_ctx {
 	struct xlog_in_core	*commit_iclog;
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
 	atomic_t		space_used;	/* aggregate size of regions */
-	struct list_head	busy_extents;	/* busy extents in chkpt */
+	struct xfs_busy_extents	busy_extents;
 	struct list_head	log_items;	/* log items in chkpt */
 	struct list_head	lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
-	struct work_struct	discard_endio_work;
 	struct work_struct	push_work;
 	atomic_t		order_id;
 };
-- 
2.40.1

