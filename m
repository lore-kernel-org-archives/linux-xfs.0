Return-Path: <SRS0=Q7ae=6N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D24BC83004
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3BE21D7E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Apr 2020 15:05:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Rf/LSWcl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgD2PF0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 11:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbgD2PF0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Apr 2020 11:05:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5100CC03C1AD
        for <linux-xfs@vger.kernel.org>; Wed, 29 Apr 2020 08:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=u2bCXyAfpCZw3qqdQGszQ7GCyuPzSaFMwQLRPY+MkUI=; b=Rf/LSWcl0bM53i6QRiIqVcBdwa
        hQK5Mq1ycadD9RXLl2Dh7TishwJpRILeMtmoCocXxdaWxyEtJgPv+Qa1mrqrhDSYFdHLhew4yeZPU
        3EFkew/N12l1IpmSnFsj3ugA69FFGe4w1wGhPR5CX/MVddQe7hVUQ1lpb6aZ+3H84fBfIQvdW2Lgz
        H9m3uDnadxcRZVcMwl/G02EeJBqKqlaG2Vn7eK7h3mpzPKBLChnzcgRas57psuCt0d0E4fyZWCTKv
        PEo0il3kZpYdC4P7t9y/+vd6Ct/CFrb/XPOv5ioCt++z/1q6jY3EMhe3hREsxnHKK1btmMljNWwK0
        vNCL17Gg==;
Received: from [2001:4bb8:184:1b25:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jToH7-0000AE-RL
        for linux-xfs@vger.kernel.org; Wed, 29 Apr 2020 15:05:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/11] xfs: factor out a xfs_defer_create_intent helper
Date:   Wed, 29 Apr 2020 17:05:04 +0200
Message-Id: <20200429150511.2191150-5-hch@lst.de>
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

Create a helper that encapsulates the whole logic to create a defer
intent.  This reorders some of the work that was done, but none of
that has an affect on the operation as only fields that don't directly
interact are affected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_defer.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 22557527cfdb6..8a38da602b7d9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -178,6 +178,23 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
+static void
+xfs_defer_create_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp,
+	bool				sort)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*li;
+
+	if (sort)
+		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
+
+	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
+	list_for_each(li, &dfp->dfp_work)
+		ops->log_item(tp, dfp->dfp_intent, li);
+}
+
 /*
  * For each pending item in the intake list, log its intent item and the
  * associated extents, then add the entire intake list to the end of
@@ -187,17 +204,11 @@ STATIC void
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
-	struct list_head		*li;
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
-		list_for_each(li, &dfp->dfp_work)
-			ops->log_item(tp, dfp->dfp_intent, li);
+		xfs_defer_create_intent(tp, dfp, true);
 	}
 }
 
@@ -419,17 +430,13 @@ xfs_defer_finish_noroll(
 		}
 		if (error == -EAGAIN) {
 			/*
-			 * Caller wants a fresh transaction, so log a
-			 * new log intent item to replace the old one
-			 * and roll the transaction.  See "Requesting
-			 * a Fresh Transaction while Finishing
-			 * Deferred Work" above.
+			 * Caller wants a fresh transaction, so log a new log
+			 * intent item to replace the old one and roll the
+			 * transaction.  See "Requesting a Fresh Transaction
+			 * while Finishing Deferred Work" above.
 			 */
-			dfp->dfp_intent = ops->create_intent(*tp,
-					dfp->dfp_count);
 			dfp->dfp_done = NULL;
-			list_for_each(li, &dfp->dfp_work)
-				ops->log_item(*tp, dfp->dfp_intent, li);
+			xfs_defer_create_intent(*tp, dfp, false);
 		} else {
 			/* Done with the dfp, free it. */
 			list_del(&dfp->dfp_list);
-- 
2.26.2

