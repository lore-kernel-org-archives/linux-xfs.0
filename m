Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8876DC433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 15:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiEVP2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 11:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347796AbiEVP2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 11:28:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FC138D80
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 08:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AE30ECE0ACE
        for <linux-xfs@vger.kernel.org>; Sun, 22 May 2022 15:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229F9C385AA;
        Sun, 22 May 2022 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653233290;
        bh=cAqJQ6bNgiH6dYy4zeqV4fJZvZcsc49ihXoHUPK9OeA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CamFXKXBEj2qkUalouDi9nq3EbjhdyBfc1gdKQKe6Ev0U/vkaQ+ZTEO1ELOq65SD5
         APuXtwhcym6/8CQxj6utYXkDvWhvwT4VupIfnkIM7aX/a1/5I7ZaC3sseYyFKqpvk+
         Z7u1IU7xN1bf35dW00n5bPBm2/1itoctsgIWjXIiN5varbyShO3ADF/x2o0kdCu+QW
         CMzlk8yISY4W/r7ToyU3/BgCNiHDt3I9u4laIMKhWkAuQWvZkNVvciM2ugxD6t9wR5
         RboJwdJLwVbNKMUUS1bnA8v4rxYdJ/2bniLNGnepbJNGv5Py/xxr07iXvzCQE7cB4f
         FFnhQrNe4R1bg==
Subject: [PATCH 4/4] xfs: allow ->create_intent to return negative errnos
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 22 May 2022 08:28:09 -0700
Message-ID: <165323328947.78754.13344109701512442909.stgit@magnolia>
In-Reply-To: <165323326679.78754.13346434666230687214.stgit@magnolia>
References: <165323326679.78754.13346434666230687214.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, the deferred operation manager assumes that all the
->create_intent implementations return only NULL or a pointer to a log
item.  If xattr log intent item code cannot allocate memory for shared
state, it can only shut down the log, which is suboptimal.  Rework the
deferred op manager to handle ERR_PTR returns from ->create_intent, and
adjust the xattr log items to return one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |   59 ++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_attr_item.c    |    7 ++---
 2 files changed, 49 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index ace229c1d251..5a321b783398 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -191,35 +191,56 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
-static bool
+/*
+ * Ensure there's a log intent item associated with this deferred work item if
+ * the operation must be restarted on crash.  Returns 1 if there's a log item;
+ * 0 if there isn't; or a negative errno.
+ */
+static int
 xfs_defer_create_intent(
 	struct xfs_trans		*tp,
 	struct xfs_defer_pending	*dfp,
 	bool				sort)
 {
 	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct xfs_log_item		*lip;
 
-	if (!dfp->dfp_intent)
-		dfp->dfp_intent = ops->create_intent(tp, &dfp->dfp_work,
-						     dfp->dfp_count, sort);
-	return dfp->dfp_intent != NULL;
+	if (dfp->dfp_intent)
+		return 1;
+
+	lip = ops->create_intent(tp, &dfp->dfp_work, dfp->dfp_count, sort);
+	if (!lip)
+		return 0;
+	if (IS_ERR(lip))
+		return PTR_ERR(lip);
+
+	dfp->dfp_intent = lip;
+	return 1;
 }
 
 /*
  * For each pending item in the intake list, log its intent item and the
  * associated extents, then add the entire intake list to the end of
  * the pending list.
+ *
+ * Returns 1 if at least one log item was associated with the deferred work;
+ * 0 if there are no log items; or a negative errno.
  */
-static bool
+static int
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
 	struct xfs_defer_pending	*dfp;
-	bool				ret = false;
+	int				ret = 0;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
+		int			ret2;
+
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		ret |= xfs_defer_create_intent(tp, dfp, true);
+		ret2 = xfs_defer_create_intent(tp, dfp, true);
+		if (ret2 < 0)
+			return ret2;
+		ret |= ret2;
 	}
 	return ret;
 }
@@ -457,6 +478,8 @@ xfs_defer_finish_one(
 		dfp->dfp_count--;
 		error = ops->finish_item(tp, dfp->dfp_done, li, &state);
 		if (error == -EAGAIN) {
+			int		ret;
+
 			/*
 			 * Caller wants a fresh transaction; put the work item
 			 * back on the list and log a new log intent item to
@@ -467,7 +490,9 @@ xfs_defer_finish_one(
 			dfp->dfp_count++;
 			dfp->dfp_done = NULL;
 			dfp->dfp_intent = NULL;
-			xfs_defer_create_intent(tp, dfp, false);
+			ret = xfs_defer_create_intent(tp, dfp, false);
+			if (ret < 0)
+				error = ret;
 		}
 
 		if (error)
@@ -514,10 +539,14 @@ xfs_defer_finish_noroll(
 		 * of time that any one intent item can stick around in memory,
 		 * pinning the log tail.
 		 */
-		bool has_intents = xfs_defer_create_intents(*tp);
+		int has_intents = xfs_defer_create_intents(*tp);
 
 		list_splice_init(&(*tp)->t_dfops, &dop_pending);
 
+		if (has_intents < 0) {
+			error = has_intents;
+			goto out_shutdown;
+		}
 		if (has_intents || dfp) {
 			error = xfs_defer_trans_roll(tp);
 			if (error)
@@ -676,13 +705,15 @@ xfs_defer_ops_capture(
 	if (list_empty(&tp->t_dfops))
 		return NULL;
 
+	error = xfs_defer_create_intents(tp);
+	if (error < 0)
+		return ERR_PTR(error);
+
 	/* Create an object to capture the defer ops. */
 	dfc = kmem_zalloc(sizeof(*dfc), KM_NOFS);
 	INIT_LIST_HEAD(&dfc->dfc_list);
 	INIT_LIST_HEAD(&dfc->dfc_dfops);
 
-	xfs_defer_create_intents(tp);
-
 	/* Move the dfops chain and transaction state to the capture struct. */
 	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
 	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
@@ -759,6 +790,10 @@ xfs_defer_ops_capture_and_commit(
 
 	/* If we don't capture anything, commit transaction and exit. */
 	dfc = xfs_defer_ops_capture(tp);
+	if (IS_ERR(dfc)) {
+		xfs_trans_cancel(tp);
+		return PTR_ERR(dfc);
+	}
 	if (!dfc)
 		return xfs_trans_commit(tp);
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 164364337404..028c358a7c90 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -442,11 +442,8 @@ xfs_attr_create_intent(
 		attr->xattri_nameval = xfs_attri_log_nameval_alloc(args->name,
 				args->namelen, args->value, args->valuelen);
 	}
-	if (!attr->xattri_nameval) {
-		/* Callers cannot handle errors, so we can only shut down. */
-		xlog_force_shutdown(mp->m_log, SHUTDOWN_LOG_IO_ERROR);
-		return NULL;
-	}
+	if (!attr->xattri_nameval)
+		return ERR_PTR(-ENOMEM);
 
 	attrip = xfs_attri_init(mp, attr->xattri_nameval);
 	xfs_trans_add_item(tp, &attrip->attri_item);

