Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2ACC83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966B421973
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a9qwcvb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgD2PFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PFg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C740C03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=CjLZtYDMqlngCwTnW87dTWKdh2ntpE5RReO8DGc01ls=; b=a9qwcvb/egaDxdRDs2TWFwjfJ+
        kZwlJuI0kx7wCSTytyFU9v0hvmcN6T77UsXpLtSENQWMi7aYb58sh3vY49lNa6nSyIJpB5svD5a2Z
        kONYyOpbKhwyehp2A3PuxnKmLJ9KyI/EcxsaiMhUYvcwb6RZzHdJmuXbdPA45Jqi6psHYl0a+MSZn
        QFzxNU8DMeuJsgNrihzXZO7JSMssnpNKP4swmlVilTSSqxGxPyAGeAslafUf68CMonl4Pu/lIbTku
        DrUsa8uB/mVG+rAZyL6WdM/uTLgJRJ1zOK+M2W6ByvrRSOpiIpRb6J20hdCPPIXgKQiPVK8cuKqIO
        m+VIJ4wQ==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToHH-0000Ch-ID
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/11] xfs: refactor xfs_defer_finish_noroll
Date:   Wed, 29 Apr 2020 17:05:08 +0200
Message-Id: <20200429150511.2191150-9-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200429150511.2191150-1-hch@lst.de>
References: <20200429150511.2191150-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split out a helper that operates on a single xfs_defer_pending structure
to untangle the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c | 128 ++++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 5402a7bf31108..20950b56cdd07 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -351,6 +351,53 @@ xfs_defer_cancel_list(
 	}
 }
 
+/*
+ * Log an intent-done item for the first pending intent, and finish the work
+ * items.
+ */
+static int
+xfs_defer_finish_one(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	void				*state = NULL;
+	struct list_head		*li, *n;
+	int				error;
+
+	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
+
+	dfp->dfp_done = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	list_for_each_safe(li, n, &dfp->dfp_work) {
+		list_del(li);
+		dfp->dfp_count--;
+		error = ops->finish_item(tp, li, dfp->dfp_done, &state);
+		if (error == -EAGAIN) {
+			/*
+			 * Caller wants a fresh transaction; put the work item
+			 * back on the list and log a new log intent item to
+			 * replace the old one.  See "Requesting a Fresh
+			 * Transaction while Finishing Deferred Work" above.
+			 */
+			list_add(li, &dfp->dfp_work);
+			dfp->dfp_count++;
+			dfp->dfp_done = NULL;
+			xfs_defer_create_intent(tp, dfp, false);
+		}
+
+		if (error)
+			goto out;
+	}
+
+	/* Done with the dfp, free it. */
+	list_del(&dfp->dfp_list);
+	kmem_free(dfp);
+out:
+	if (ops->finish_cleanup)
+		ops->finish_cleanup(tp, state, error);
+	return error;
+}
+
 /*
  * Finish all the pending work.  This involves logging intent items for
  * any work items that wandered in since the last transaction roll (if
@@ -364,11 +411,7 @@ xfs_defer_finish_noroll(
 	struct xfs_trans		**tp)
 {
 	struct xfs_defer_pending	*dfp;
-	struct list_head		*li;
-	struct list_head		*n;
-	void				*state;
 	int				error = 0;
-	const struct xfs_defer_op_type	*ops;
 	LIST_HEAD(dop_pending);
 
 	ASSERT((*tp)->t_flags & XFS_TRANS_PERM_LOG_RES);
@@ -377,83 +420,30 @@ xfs_defer_finish_noroll(
 
 	/* Until we run out of pending work to finish... */
 	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
-		/* log intents and pull in intake items */
 		xfs_defer_create_intents(*tp);
 		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
 
-		/*
-		 * Roll the transaction.
-		 */
 		error = xfs_defer_trans_roll(tp);
 		if (error)
-			goto out;
+			goto out_shutdown;
 
-		/* Log an intent-done item for the first pending item. */
 		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
 				       dfp_list);
-		ops = defer_op_types[dfp->dfp_type];
-		trace_xfs_defer_pending_finish((*tp)->t_mountp, dfp);
-		dfp->dfp_done = ops->create_done(*tp, dfp->dfp_intent,
-				dfp->dfp_count);
-
-		/* Finish the work items. */
-		state = NULL;
-		list_for_each_safe(li, n, &dfp->dfp_work) {
-			list_del(li);
-			dfp->dfp_count--;
-			error = ops->finish_item(*tp, li, dfp->dfp_done,
-					&state);
-			if (error == -EAGAIN) {
-				/*
-				 * Caller wants a fresh transaction;
-				 * put the work item back on the list
-				 * and jump out.
-				 */
-				list_add(li, &dfp->dfp_work);
-				dfp->dfp_count++;
-				break;
-			} else if (error) {
-				/*
-				 * Clean up after ourselves and jump out.
-				 * xfs_defer_cancel will take care of freeing
-				 * all these lists and stuff.
-				 */
-				if (ops->finish_cleanup)
-					ops->finish_cleanup(*tp, state, error);
-				goto out;
-			}
-		}
-		if (error == -EAGAIN) {
-			/*
-			 * Caller wants a fresh transaction, so log a new log
-			 * intent item to replace the old one and roll the
-			 * transaction.  See "Requesting a Fresh Transaction
-			 * while Finishing Deferred Work" above.
-			 */
-			dfp->dfp_done = NULL;
-			xfs_defer_create_intent(*tp, dfp, false);
-		} else {
-			/* Done with the dfp, free it. */
-			list_del(&dfp->dfp_list);
-			kmem_free(dfp);
-		}
-
-		if (ops->finish_cleanup)
-			ops->finish_cleanup(*tp, state, error);
-	}
-
-out:
-	if (error) {
-		xfs_defer_trans_abort(*tp, &dop_pending);
-		xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
-		trace_xfs_defer_finish_error(*tp, error);
-		xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
-		xfs_defer_cancel(*tp);
-		return error;
+		error = xfs_defer_finish_one(*tp, dfp);
+		if (error && error != -EAGAIN)
+			goto out_shutdown;
 	}
 
 	trace_xfs_defer_finish_done(*tp, _RET_IP_);
 	return 0;
+
+out_shutdown:
+	xfs_defer_trans_abort(*tp, &dop_pending);
+	xfs_force_shutdown((*tp)->t_mountp, SHUTDOWN_CORRUPT_INCORE);
+	trace_xfs_defer_finish_error(*tp, error);
+	xfs_defer_cancel_list((*tp)->t_mountp, &dop_pending);
+	xfs_defer_cancel(*tp);
+	return error;
 }
 
 int
-- 
2.26.2

