Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30BFE7F14D
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Sep 2023 00:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbjI0APE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Sep 2023 20:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbjI0ANC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Sep 2023 20:13:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBEC1F9D4
        for <linux-xfs@vger.kernel.org>; Tue, 26 Sep 2023 16:31:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D82CC433C8;
        Tue, 26 Sep 2023 23:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695771083;
        bh=TBoQb4giXJsf6fBCEmEO+yy34bin2T8ADAhxEpmxJMs=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XxgQe6V1gBbWhTOYEkEdxyyMmcoRmsDX3z+SydB5mXlxPX/KDlY6HmvXWgtzkCOiS
         Q7STETB4TNEcCQL26Mhb+TEmqNfX/6A9NOWB3lNmVtQmWhTdMPmRIwpDovxpYlsGbT
         k2CzUj7bxgAipDvMlOjgfqf7B0oCKXQHUoBgI8OaY+ZPtPzU6lSrSLhB/A2P1lpraq
         9qZ6hPWMAmQRPHmqmLxz6l7/5J+ME64DEeKO2Rnt6t04DbhsEJDjDlrnC6YQsE7/iN
         w7rJOlun2zHn74nQLhmmpNkrWKpiWdrSSxfahCsedyJ7SsuuBZPIRmwgUIylidQIjw
         nvVsvFbwZMaGg==
Date:   Tue, 26 Sep 2023 16:31:22 -0700
Subject: [PATCH 1/7] xfs: don't append work items to logged xfs_defer_pending
 objects
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169577059164.3312911.8148982456892861553.stgit@frogsfrogsfrogs>
In-Reply-To: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
References: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When someone tries to add a deferred work item to xfs_defer_add, it will
try to attach the work item to the most recently added xfs_defer_pending
object attached to the transaction.  However, it doesn't check if the
pending object has a log intent item attached to it.  This is incorrect
behavior because we cannot add more work to an object that has already
been committed to the ondisk log.

Therefore, change the behavior not to append to pending items with a non
null dfp_intent.  In practice this has not been an issue because the
only way xfs_defer_add gets called after log intent items have been
committed is from the defer ops ->finish_item functions themselves, and
the @dop_pending isolation in xfs_defer_finish_noroll protects the
pending items that have already been logged.

However, the next patch will add the ability to pause a deferred extent
free object during online btree rebuilding, and any new extfree work
items need to have their own pending event.

While we're at it, hoist the predicate to its own static inline function
for readability.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |   48 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index bcfb6a4203cdd..ad41c6d0113ce 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -617,6 +617,40 @@ xfs_defer_cancel(
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
+/*
+ * Decide if we can add a deferred work item to the last dfops item attached
+ * to the transaction.
+ */
+static inline struct xfs_defer_pending *
+xfs_defer_try_append(
+	struct xfs_trans		*tp,
+	enum xfs_defer_ops_type		type,
+	const struct xfs_defer_op_type	*ops)
+{
+	struct xfs_defer_pending	*dfp = NULL;
+
+	/* No dfops at all? */
+	if (list_empty(&tp->t_dfops))
+		return NULL;
+
+	dfp = list_last_entry(&tp->t_dfops, struct xfs_defer_pending,
+			dfp_list);
+
+	/* Wrong type? */
+	if (dfp->dfp_type != type)
+		return NULL;
+
+	/* Already logged? */
+	if (dfp->dfp_intent)
+		return NULL;
+
+	/* Already full? */
+	if (ops->max_items && dfp->dfp_count >= ops->max_items)
+		return NULL;
+
+	return dfp;
+}
+
 /* Add an item for later deferred processing. */
 void
 xfs_defer_add(
@@ -630,19 +664,9 @@ xfs_defer_add(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
-	/*
-	 * Add the item to a pending item at the end of the intake list.
-	 * If the last pending item has the same type, reuse it.  Else,
-	 * create a new pending item at the end of the intake list.
-	 */
-	if (!list_empty(&tp->t_dfops)) {
-		dfp = list_last_entry(&tp->t_dfops,
-				struct xfs_defer_pending, dfp_list);
-		if (dfp->dfp_type != type ||
-		    (ops->max_items && dfp->dfp_count >= ops->max_items))
-			dfp = NULL;
-	}
+	dfp = xfs_defer_try_append(tp, type, ops);
 	if (!dfp) {
+		/* Create a new pending item at the end of the intake list. */
 		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 				GFP_NOFS | __GFP_NOFAIL);
 		dfp->dfp_type = type;

