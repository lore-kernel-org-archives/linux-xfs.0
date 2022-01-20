Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72D6BC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345210AbiATAXT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345209AbiATAXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:23:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2056CC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:23:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B43BF61515
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1821AC004E1;
        Thu, 20 Jan 2022 00:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638198;
        bh=PpgI70vMegCa+NwOgwSrH+l+Eqz7j5stHqIbVxxZXxs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VhbbQR9tL4HaAQuzQWCESfHKzNcKC0GgRIU7BLbmb2MHS5v2+uR+y6GKUnYuLOQ9k
         yzzLtmIE0BKcnvonZEHbyKhQFrK7pivK0AFdiQpIrQssphc7AKcaNwNQFz5HClWRcB
         xkLulcSp3krsEWXaN9XwgNpch4n9uAW59RmQik7uevy5GXxpO/4pEcqGc8M00RFHVj
         6VQ+T3bwzjF31tjc0ddTNcgaOil1DLsgndW1PLHcGXpEcDRr+FqMsEZeqDx5OJjrCN
         REylzQjUayWTXDCSHCkmSUlvrPZrwPihuQ3vtzuLfvXhg2W2ykx1wTTIt9NN35hSJb
         X/2dvgaOSY7DA==
Subject: [PATCH 01/48] xfs: formalize the process of holding onto resources
 across a defer roll
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:23:17 -0800
Message-ID: <164263819776.865554.18114406966594175432.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: c5db9f937b2971c78d6c6bbaa61a6450efa8b845

Transaction users are allowed to flag up to two buffers and two inodes
for ownership preservation across a deferred transaction roll.  Hoist
the variables and code responsible for this out of xfs_defer_trans_roll
so that we can use it for the defer capture mechanism.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trans.h |    3 --
 libxfs/xfs_defer.c  |   85 ++++++++++++++++++++++++++++++++-------------------
 libxfs/xfs_defer.h  |   24 ++++++++++++++
 3 files changed, 78 insertions(+), 34 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 2c55bb85..690759ec 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -58,9 +58,6 @@ typedef struct xfs_qoff_logitem {
 	xfs_qoff_logformat_t	qql_format;	/* logged structure */
 } xfs_qoff_logitem_t;
 
-#define XFS_DEFER_OPS_NR_INODES	2	/* join up to two inodes */
-#define XFS_DEFER_OPS_NR_BUFS	2	/* join up to two buffers */
-
 typedef struct xfs_trans {
 	unsigned int		t_log_res;	/* amt of log space resvd */
 	unsigned int		t_log_count;	/* count for perm log res */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1fdf6c72..35f51f87 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -228,23 +228,20 @@ xfs_defer_trans_abort(
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
@@ -252,28 +249,29 @@ xfs_defer_trans_roll(
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
@@ -281,7 +279,43 @@ xfs_defer_trans_roll(
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
@@ -291,22 +325,11 @@ xfs_defer_trans_roll(
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
 
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 05472f71..e095abb9 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
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

