Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34E1EC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02FC82173E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 10:15:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QNY67Bmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728519AbgEAKPp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 06:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728119AbgEAKPn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 06:15:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5796C08E859
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 03:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bzVKNERqKC4iDo7YRDEDKxGJqQ1ws84efWK3Q5KPBzY=; b=QNY67BmvP+TZZraAHhmOvoHs+b
        7Kz3nA9dZUlHHEBcom9bI/AG3KQOfvuATEbj9SVWWuqcyI6zpu/sT8kJFIkDPJr3n0P5vv5mmkwOV
        GskG7PJI/o0R7z4ZFbYSIQHub4ImJWXu4h7ym+hTEfoQe43CRp+9FuaYXq+SBXQ1D9sAmEfJOyBV3
        qLhYXH2Kt3rSMea6R1vOZ9F9Lq2dVUgxesfJqjJKsY/IrSCqp6SX+pZaEixn23xLOx7kDMtYKf+cY
        ZcDfFwqudZC6zEG6KfN74Rfiuv/ASRvXP49SSRGbMCFDa7EWfaecfmr1itwlR3uL7Yn9JFKQuBNrJ
        5d2KoC3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUShn-0008PK-97; Fri, 01 May 2020 10:15:39 +0000
Date:   Fri, 1 May 2020 03:15:39 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/21] xfs: refactor log recovery
Message-ID: <20200501101539.GA21903@infradead.org>
References: <158820765488.467894.15408191148091671053.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158820765488.467894.15408191148091671053.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I've looked a bit over the total diff and finaly result and really like
it.

A few comments from that without going into the individual patches:

 - I don't think the buffer cancellation table should remain in
   xfs_log_recovery.c.  I can either move them into a new file
   as part of resending my prep series, or you could move them into
   xfs_buf_item_recover.c.  Let me know what you prefer.
 - Should the match callback also move into struct xfs_item_ops?  That
   would also match iop_recover.
 - Based on that we could also kill XFS_ITEM_TYPE_IS_INTENT by just
   checking for iop_recover and/or iop_match.
 - Setting XFS_LI_RECOVERED could also move to common code, basically
   set it whenever iop_recover returns.  Also we can remove the
   XFS_LI_RECOVERED asserts in ->iop_recovery when the caller checks
   it just before.
 - we are still having a few redundant ri_type checks.
 - ri_type maybe should be ri_ops?

See this patch below for my take on cleaning up the recovery ops
handling a bit:

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index ba172eb454c8f..f97946cf94f11 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -7,7 +7,7 @@
 #define __XFS_LOG_RECOVER_H__
 
 /*
- * Each log item type (XFS_LI_*) gets its own xlog_recover_item_type to
+ * Each log item type (XFS_LI_*) gets its own xlog_recover_item_ops to
  * define how recovery should work for that type of log item.
  */
 struct xlog_recover_item;
@@ -20,7 +20,9 @@ enum xlog_recover_reorder {
 	XLOG_REORDER_CANCEL_LIST,
 };
 
-struct xlog_recover_item_type {
+struct xlog_recover_item_ops {
+	uint16_t		item_type;
+
 	/*
 	 * Help sort recovered log items into the order required to replay them
 	 * correctly.  Log item types that always use XLOG_REORDER_ITEM_LIST do
@@ -58,19 +60,19 @@ struct xlog_recover_item_type {
 			       struct xlog_recover_item *item, xfs_lsn_t lsn);
 };
 
-extern const struct xlog_recover_item_type xlog_icreate_item_type;
-extern const struct xlog_recover_item_type xlog_buf_item_type;
-extern const struct xlog_recover_item_type xlog_inode_item_type;
-extern const struct xlog_recover_item_type xlog_dquot_item_type;
-extern const struct xlog_recover_item_type xlog_quotaoff_item_type;
-extern const struct xlog_recover_item_type xlog_bmap_intent_item_type;
-extern const struct xlog_recover_item_type xlog_bmap_done_item_type;
-extern const struct xlog_recover_item_type xlog_extfree_intent_item_type;
-extern const struct xlog_recover_item_type xlog_extfree_done_item_type;
-extern const struct xlog_recover_item_type xlog_rmap_intent_item_type;
-extern const struct xlog_recover_item_type xlog_rmap_done_item_type;
-extern const struct xlog_recover_item_type xlog_refcount_intent_item_type;
-extern const struct xlog_recover_item_type xlog_refcount_done_item_type;
+extern const struct xlog_recover_item_ops xlog_icreate_item_type;
+extern const struct xlog_recover_item_ops xlog_buf_item_type;
+extern const struct xlog_recover_item_ops xlog_inode_item_type;
+extern const struct xlog_recover_item_ops xlog_dquot_item_type;
+extern const struct xlog_recover_item_ops xlog_quotaoff_item_type;
+extern const struct xlog_recover_item_ops xlog_bmap_intent_item_type;
+extern const struct xlog_recover_item_ops xlog_bmap_done_item_type;
+extern const struct xlog_recover_item_ops xlog_extfree_intent_item_type;
+extern const struct xlog_recover_item_ops xlog_extfree_done_item_type;
+extern const struct xlog_recover_item_ops xlog_rmap_intent_item_type;
+extern const struct xlog_recover_item_ops xlog_rmap_done_item_type;
+extern const struct xlog_recover_item_ops xlog_refcount_intent_item_type;
+extern const struct xlog_recover_item_ops xlog_refcount_done_item_type;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
@@ -93,7 +95,7 @@ typedef struct xlog_recover_item {
 	int			ri_cnt;	/* count of regions found */
 	int			ri_total;	/* total regions */
 	xfs_log_iovec_t		*ri_buf;	/* ptr to regions buffer */
-	const struct xlog_recover_item_type *ri_type;
+	const struct xlog_recover_item_ops *ri_ops;
 } xlog_recover_item_t;
 
 struct xlog_recover {
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 58f0904e4504d..952b4ce40433e 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -667,10 +667,12 @@ xlog_recover_bmap_done_commit_pass2(
 	return 0;
 }
 
-const struct xlog_recover_item_type xlog_bmap_intent_item_type = {
+const struct xlog_recover_item_ops xlog_bmap_intent_item_type = {
+	.item_type		= XFS_LI_BUI,
 	.commit_pass2_fn	= xlog_recover_bmap_intent_commit_pass2,
 };
 
-const struct xlog_recover_item_type xlog_bmap_done_item_type = {
+const struct xlog_recover_item_ops xlog_bmap_done_item_type = {
+	.item_type		= XFS_LI_BUD,
 	.commit_pass2_fn	= xlog_recover_bmap_done_commit_pass2,
 };
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d324f810819df..954e0e96af5dc 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -857,7 +857,8 @@ xlog_recover_buffer_commit_pass2(
 	return 0;
 }
 
-const struct xlog_recover_item_type xlog_buf_item_type = {
+const struct xlog_recover_item_ops xlog_buf_item_type = {
+	.item_type		= XFS_LI_BUF,
 	.reorder_fn		= xlog_buf_reorder_fn,
 	.ra_pass2_fn		= xlog_recover_buffer_ra_pass2,
 	.commit_pass1_fn	= xlog_recover_buffer_commit_pass1,
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 83bd7ded9185f..6c6216bdc432c 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -527,7 +527,8 @@ xlog_recover_dquot_commit_pass2(
 	return 0;
 }
 
-const struct xlog_recover_item_type xlog_dquot_item_type = {
+const struct xlog_recover_item_ops xlog_dquot_item_type = {
+	.item_type		= XFS_LI_DQUOT,
 	.ra_pass2_fn		= xlog_recover_dquot_ra_pass2,
 	.commit_pass2_fn	= xlog_recover_dquot_commit_pass2,
 };
@@ -559,6 +560,7 @@ xlog_recover_quotaoff_commit_pass1(
 	return 0;
 }
 
-const struct xlog_recover_item_type xlog_quotaoff_item_type = {
+const struct xlog_recover_item_ops xlog_quotaoff_item_type = {
+	.item_type		= XFS_LI_QUOTAOFF,
 	.commit_pass1_fn	= xlog_recover_quotaoff_commit_pass1,
 };
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index d6f2c88570de1..5d1fb5e05b781 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -729,10 +729,12 @@ xlog_recover_extfree_done_commit_pass2(
 	return 0;
 }
 
-const struct xlog_recover_item_type xlog_extfree_intent_item_type = {
+const struct xlog_recover_item_ops xlog_extfree_intent_item_type = {
+	.item_type		= XFS_LI_EFI,
 	.commit_pass2_fn	= xlog_recover_extfree_intent_commit_pass2,
 };
 
-const struct xlog_recover_item_type xlog_extfree_done_item_type = {
+const struct xlog_recover_item_ops xlog_extfree_done_item_type = {
+	.item_type		= XFS_LI_EFD,
 	.commit_pass2_fn	= xlog_recover_extfree_done_commit_pass2,
 };
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 602a8c91371fe..34805bdbc2e12 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -248,7 +248,8 @@ xlog_recover_do_icreate_commit_pass2(
 				     length, be32_to_cpu(icl->icl_gen));
 }
 
-const struct xlog_recover_item_type xlog_icreate_item_type = {
+const struct xlog_recover_item_ops xlog_icreate_item_type = {
+	.item_type		= XFS_LI_ICREATE,
 	.reorder_fn		= xlog_icreate_reorder,
 	.commit_pass2_fn	= xlog_recover_do_icreate_commit_pass2,
 };
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 46fc8a4b9ac61..9dff80783fe12 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -393,7 +393,8 @@ xlog_recover_inode_commit_pass2(
 	return error;
 }
 
-const struct xlog_recover_item_type xlog_inode_item_type = {
+const struct xlog_recover_item_ops xlog_inode_item_type = {
+	.item_type		= XFS_LI_INODE,
 	.ra_pass2_fn		= xlog_recover_inode_ra_pass2,
 	.commit_pass2_fn	= xlog_recover_inode_commit_pass2,
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 09dd514a34980..e3f13866deb08 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1828,55 +1828,35 @@ xlog_recover_insert_ail(
  ******************************************************************************
  */
 
-static int
-xlog_set_item_type(
-	struct xlog_recover_item		*item)
-{
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_ICREATE:
-		item->ri_type = &xlog_icreate_item_type;
-		return 0;
-	case XFS_LI_BUF:
-		item->ri_type = &xlog_buf_item_type;
-		return 0;
-	case XFS_LI_EFI:
-		item->ri_type = &xlog_extfree_intent_item_type;
-		return 0;
-	case XFS_LI_EFD:
-		item->ri_type = &xlog_extfree_done_item_type;
-		return 0;
-	case XFS_LI_RUI:
-		item->ri_type = &xlog_rmap_intent_item_type;
-		return 0;
-	case XFS_LI_RUD:
-		item->ri_type = &xlog_rmap_done_item_type;
-		return 0;
-	case XFS_LI_CUI:
-		item->ri_type = &xlog_refcount_intent_item_type;
-		return 0;
-	case XFS_LI_CUD:
-		item->ri_type = &xlog_refcount_done_item_type;
-		return 0;
-	case XFS_LI_BUI:
-		item->ri_type = &xlog_bmap_intent_item_type;
-		return 0;
-	case XFS_LI_BUD:
-		item->ri_type = &xlog_bmap_done_item_type;
-		return 0;
-	case XFS_LI_INODE:
-		item->ri_type = &xlog_inode_item_type;
-		return 0;
+static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
+	&xlog_icreate_item_type,
+	&xlog_buf_item_type,
+	&xlog_extfree_intent_item_type,
+	&xlog_extfree_done_item_type,
+	&xlog_rmap_intent_item_type,
+	&xlog_rmap_done_item_type,
+	&xlog_refcount_intent_item_type,
+	&xlog_refcount_done_item_type,
+	&xlog_bmap_intent_item_type,
+	&xlog_bmap_done_item_type,
+	&xlog_inode_item_type,
 #ifdef CONFIG_XFS_QUOTA
-	case XFS_LI_DQUOT:
-		item->ri_type = &xlog_dquot_item_type;
-		return 0;
-	case XFS_LI_QUOTAOFF:
-		item->ri_type = &xlog_quotaoff_item_type;
-		return 0;
+	&xlog_dquot_item_type,
+	&xlog_quotaoff_item_type,
 #endif /* CONFIG_XFS_QUOTA */
-	default:
-		return -EFSCORRUPTED;
-	}
+};
+
+static const struct xlog_recover_item_ops *
+xlog_find_item_ops(
+	struct xlog_recover_item	*item)
+{
+	int				i;
+
+	for (i = 0; i < ARRAY_SIZE(xlog_recover_item_ops); i++)
+		if (ITEM_TYPE(item) == xlog_recover_item_ops[i]->item_type)
+			return xlog_recover_item_ops[i];
+
+	return NULL;
 }
 
 /*
@@ -1946,8 +1926,8 @@ xlog_recover_reorder_trans(
 	list_for_each_entry_safe(item, n, &sort_list, ri_list) {
 		enum xlog_recover_reorder	fate = XLOG_REORDER_ITEM_LIST;
 
-		error = xlog_set_item_type(item);
-		if (error) {
+		item->ri_ops = xlog_find_item_ops(item);
+		if (!item->ri_ops) {
 			xfs_warn(log->l_mp,
 				"%s: unrecognized type of log operation (%d)",
 				__func__, ITEM_TYPE(item));
@@ -1958,11 +1938,12 @@ xlog_recover_reorder_trans(
 			 */
 			if (!list_empty(&sort_list))
 				list_splice_init(&sort_list, &trans->r_itemq);
+			error = -EFSCORRUPTED;
 			break;
 		}
 
-		if (item->ri_type->reorder_fn)
-			fate = item->ri_type->reorder_fn(item);
+		if (item->ri_ops->reorder_fn)
+			fate = item->ri_ops->reorder_fn(item);
 
 		switch (fate) {
 		case XLOG_REORDER_BUFFER_LIST:
@@ -2098,46 +2079,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-STATIC int
-xlog_recover_commit_pass1(
-	struct xlog			*log,
-	struct xlog_recover		*trans,
-	struct xlog_recover_item	*item)
-{
-	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS1);
-
-	if (!item->ri_type) {
-		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
-			__func__, ITEM_TYPE(item));
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-	if (!item->ri_type->commit_pass1_fn)
-		return 0;
-	return item->ri_type->commit_pass1_fn(log, item);
-}
-
-STATIC int
-xlog_recover_commit_pass2(
-	struct xlog			*log,
-	struct xlog_recover		*trans,
-	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
-{
-	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
-
-	if (!item->ri_type) {
-		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
-			__func__, ITEM_TYPE(item));
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-	if (!item->ri_type->commit_pass2_fn)
-		return 0;
-	return item->ri_type->commit_pass2_fn(log, buffer_list, item,
-			trans->r_lsn);
-}
-
 STATIC int
 xlog_recover_items_pass2(
 	struct xlog                     *log,
@@ -2146,16 +2087,18 @@ xlog_recover_items_pass2(
 	struct list_head                *item_list)
 {
 	struct xlog_recover_item	*item;
-	int				error = 0;
+	int				error;
 
 	list_for_each_entry(item, item_list, ri_list) {
-		error = xlog_recover_commit_pass2(log, trans,
-					  buffer_list, item);
+		if (!item->ri_ops->commit_pass2_fn)
+			continue;
+		error = item->ri_ops->commit_pass2_fn(log, buffer_list, item,
+				trans->r_lsn);
 		if (error)
 			return error;
 	}
 
-	return error;
+	return 0;
 }
 
 /*
@@ -2187,13 +2130,16 @@ xlog_recover_commit_trans(
 		return error;
 
 	list_for_each_entry_safe(item, next, &trans->r_itemq, ri_list) {
+		trace_xfs_log_recover_item_recover(log, trans, item, pass);
+
 		switch (pass) {
 		case XLOG_RECOVER_PASS1:
-			error = xlog_recover_commit_pass1(log, trans, item);
+			if (item->ri_ops->commit_pass1_fn)
+				error = item->ri_ops->commit_pass1_fn(log, item);
 			break;
 		case XLOG_RECOVER_PASS2:
-			if (item->ri_type && item->ri_type->ra_pass2_fn)
-				item->ri_type->ra_pass2_fn(log, item);
+			if (item->ri_ops->ra_pass2_fn)
+				item->ri_ops->ra_pass2_fn(log, item);
 			list_move_tail(&item->ri_list, &ra_list);
 			items_queued++;
 			if (items_queued >= XLOG_RECOVER_COMMIT_QUEUE_MAX) {
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 53a79dc618f76..5703d5fdf4eeb 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -690,10 +690,12 @@ xlog_recover_refcount_done_commit_pass2(
 	return 0;
 }
 
-const struct xlog_recover_item_type xlog_refcount_intent_item_type = {
+const struct xlog_recover_item_ops xlog_refcount_intent_item_type = {
+	.item_type		= XFS_LI_CUI,
 	.commit_pass2_fn	= xlog_recover_refcount_intent_commit_pass2,
 };
 
-const struct xlog_recover_item_type xlog_refcount_done_item_type = {
+const struct xlog_recover_item_ops xlog_refcount_done_item_type = {
+	.item_type		= XFS_LI_CUD,
 	.commit_pass2_fn	= xlog_recover_refcount_done_commit_pass2,
 };
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index cee5c61550321..12e035ff7bb2d 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -680,10 +680,12 @@ xlog_recover_rmap_done_commit_pass2(
 	return 0;
 }
 
-const struct xlog_recover_item_type xlog_rmap_intent_item_type = {
+const struct xlog_recover_item_ops xlog_rmap_intent_item_type = {
+	.item_type		= XFS_LI_RUI,
 	.commit_pass2_fn	= xlog_recover_rmap_intent_commit_pass2,
 };
 
-const struct xlog_recover_item_type xlog_rmap_done_item_type = {
+const struct xlog_recover_item_ops xlog_rmap_done_item_type = {
+	.item_type		= XFS_LI_RUD,
 	.commit_pass2_fn	= xlog_recover_rmap_done_commit_pass2,
 };
