Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A45AC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AABA6112E
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbhIRBb7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235000AbhIRBb6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E746D60FBF;
        Sat, 18 Sep 2021 01:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928636;
        bh=DqO2jdCfARungi1JtHFflO/0Mzhn2NojdDTOwigAnls=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QkC1VFikcvEUVI9keO6nJ8f5qoVxT8XkVzDLJEVOC+JTX/G2up08C6Qbm1gnZpLiJ
         GMrY3ps4iNuPqrTQqcsEf7KJNDw6OdnRHOMQVOuf9vzIu5zllRHzovnxQ4sRoDCFQh
         im5/EtffW7nlmGaoAVtgR1N3PZoU570DhYzQgryOei/IsXQ49fiLI96nmLFIuVqeDc
         5h1kavEnJVmZr4FVYiwog0kjZJUTJIRGPeBw52HZjMpyqBJMjaS3QLFzxL4d82ek2y
         7iplSfUurmS0GXdmNzJMCWsvDOMnFqnCFA+B/LWtNYJjrfgUB/vuSxC7l2X9cEpZjO
         Qb0lVyVHGgDvg==
Subject: [PATCH 1/2] xfs: formalize the process of holding onto resources
 across a defer roll
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, allison.henderson@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:30:35 -0700
Message-ID: <163192863566.417887.12509295398707646105.stgit@magnolia>
In-Reply-To: <163192863018.417887.1729794799105892028.stgit@magnolia>
References: <163192863018.417887.1729794799105892028.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Transaction users are allowed to flag up to two buffers and two inodes
for ownership preservation across a deferred transaction roll.  Hoist
the variables and code responsible for this out of xfs_defer_trans_roll
so that we can use it for the defer capture mechanism.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |   85 +++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_defer.h |   24 +++++++++++++
 fs/xfs/xfs_trans.h        |    6 ---
 3 files changed, 78 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index eff4a127188e..7c6490f3e537 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -232,23 +232,20 @@ xfs_defer_trans_abort(
 	}
 }
 
-/* Roll a transaction so we can do some deferred op processing. */
-STATIC int
-xfs_defer_trans_roll(
-	struct xfs_trans		**tpp)
+/*
+ * Capture resources that the caller said not to release ("held") when the
+ * transaction commits.  Caller is responsible for zero-initializing @dres.
+ */
+static int
+xfs_defer_save_resources(
+	struct xfs_defer_resources	*dres,
+	struct xfs_trans		*tp)
 {
-	struct xfs_trans		*tp = *tpp;
 	struct xfs_buf_log_item		*bli;
 	struct xfs_inode_log_item	*ili;
 	struct xfs_log_item		*lip;
-	struct xfs_buf			*bplist[XFS_DEFER_OPS_NR_BUFS];
-	struct xfs_inode		*iplist[XFS_DEFER_OPS_NR_INODES];
-	unsigned int			ordered = 0; /* bitmap */
-	int				bpcount = 0, ipcount = 0;
-	int				i;
-	int				error;
 
-	BUILD_BUG_ON(NBBY * sizeof(ordered) < XFS_DEFER_OPS_NR_BUFS);
+	BUILD_BUG_ON(NBBY * sizeof(dres->dr_ordered) < XFS_DEFER_OPS_NR_BUFS);
 
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		switch (lip->li_type) {
@@ -256,28 +253,29 @@ xfs_defer_trans_roll(
 			bli = container_of(lip, struct xfs_buf_log_item,
 					   bli_item);
 			if (bli->bli_flags & XFS_BLI_HOLD) {
-				if (bpcount >= XFS_DEFER_OPS_NR_BUFS) {
+				if (dres->dr_bufs >= XFS_DEFER_OPS_NR_BUFS) {
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
 				if (bli->bli_flags & XFS_BLI_ORDERED)
-					ordered |= (1U << bpcount);
+					dres->dr_ordered |=
+							(1U << dres->dr_bufs);
 				else
 					xfs_trans_dirty_buf(tp, bli->bli_buf);
-				bplist[bpcount++] = bli->bli_buf;
+				dres->dr_bp[dres->dr_bufs++] = bli->bli_buf;
 			}
 			break;
 		case XFS_LI_INODE:
 			ili = container_of(lip, struct xfs_inode_log_item,
 					   ili_item);
 			if (ili->ili_lock_flags == 0) {
-				if (ipcount >= XFS_DEFER_OPS_NR_INODES) {
+				if (dres->dr_inos >= XFS_DEFER_OPS_NR_INODES) {
 					ASSERT(0);
 					return -EFSCORRUPTED;
 				}
 				xfs_trans_log_inode(tp, ili->ili_inode,
 						    XFS_ILOG_CORE);
-				iplist[ipcount++] = ili->ili_inode;
+				dres->dr_ip[dres->dr_inos++] = ili->ili_inode;
 			}
 			break;
 		default:
@@ -285,7 +283,43 @@ xfs_defer_trans_roll(
 		}
 	}
 
-	trace_xfs_defer_trans_roll(tp, _RET_IP_);
+	return 0;
+}
+
+/* Attach the held resources to the transaction. */
+static void
+xfs_defer_restore_resources(
+	struct xfs_trans		*tp,
+	struct xfs_defer_resources	*dres)
+{
+	unsigned short			i;
+
+	/* Rejoin the joined inodes. */
+	for (i = 0; i < dres->dr_inos; i++)
+		xfs_trans_ijoin(tp, dres->dr_ip[i], 0);
+
+	/* Rejoin the buffers and dirty them so the log moves forward. */
+	for (i = 0; i < dres->dr_bufs; i++) {
+		xfs_trans_bjoin(tp, dres->dr_bp[i]);
+		if (dres->dr_ordered & (1U << i))
+			xfs_trans_ordered_buf(tp, dres->dr_bp[i]);
+		xfs_trans_bhold(tp, dres->dr_bp[i]);
+	}
+}
+
+/* Roll a transaction so we can do some deferred op processing. */
+STATIC int
+xfs_defer_trans_roll(
+	struct xfs_trans		**tpp)
+{
+	struct xfs_defer_resources	dres = { };
+	int				error;
+
+	error = xfs_defer_save_resources(&dres, *tpp);
+	if (error)
+		return error;
+
+	trace_xfs_defer_trans_roll(*tpp, _RET_IP_);
 
 	/*
 	 * Roll the transaction.  Rolling always given a new transaction (even
@@ -295,22 +329,11 @@ xfs_defer_trans_roll(
 	 * happened.
 	 */
 	error = xfs_trans_roll(tpp);
-	tp = *tpp;
 
-	/* Rejoin the joined inodes. */
-	for (i = 0; i < ipcount; i++)
-		xfs_trans_ijoin(tp, iplist[i], 0);
-
-	/* Rejoin the buffers and dirty them so the log moves forward. */
-	for (i = 0; i < bpcount; i++) {
-		xfs_trans_bjoin(tp, bplist[i]);
-		if (ordered & (1U << i))
-			xfs_trans_ordered_buf(tp, bplist[i]);
-		xfs_trans_bhold(tp, bplist[i]);
-	}
+	xfs_defer_restore_resources(*tpp, &dres);
 
 	if (error)
-		trace_xfs_defer_trans_roll_error(tp, error);
+		trace_xfs_defer_trans_roll_error(*tpp, error);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 05472f71fffe..e095abb96f1a 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -64,6 +64,30 @@ extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
 
+/*
+ * Deferred operation item relogging limits.
+ */
+#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
+#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
+
+/* Resources that must be held across a transaction roll. */
+struct xfs_defer_resources {
+	/* held buffers */
+	struct xfs_buf		*dr_bp[XFS_DEFER_OPS_NR_BUFS];
+
+	/* inodes with no unlock flags */
+	struct xfs_inode	*dr_ip[XFS_DEFER_OPS_NR_INODES];
+
+	/* number of held buffers */
+	unsigned short		dr_bufs;
+
+	/* bitmap of ordered buffers */
+	unsigned short		dr_ordered;
+
+	/* number of held inodes */
+	unsigned short		dr_inos;
+};
+
 /*
  * This structure enables a dfops user to detach the chain of deferred
  * operations from a transaction so that they can be continued later.
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 50da47f23a07..3d2e89c4d446 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -112,12 +112,6 @@ void	xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *item,
 #define XFS_ITEM_LOCKED		2
 #define XFS_ITEM_FLUSHING	3
 
-/*
- * Deferred operation item relogging limits.
- */
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
-#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
-
 /*
  * This is the structure maintained for every active transaction.
  */

