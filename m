Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A073EB64DA
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 01:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbjFPBhQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 21:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFPBhP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 21:37:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DC82948
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 18:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4556261B74
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2023 01:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896D3C433C8;
        Fri, 16 Jun 2023 01:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686879433;
        bh=cigPxtkjXbxI6b11RkxZOc8h5s8DAPW1wmNl6/q3aEg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BjqveVuHXKR318R4gegh78HoPYysoNuEy0oDlrz+6IDY+obKqfaMdcW8zrwYcoxMS
         kF1I3rF+KQiuUTiMe4CnC8ohKFBIxOS+wADWXDOCGBP5fkXZUpykg+uwcnKCfldZzo
         FP//8CXdK9xjONWCqnyOofvGUwH3ZV2Z6ek4vHuM35l2FnajuqXD3OoOAliV4kiSdM
         cGq6yMxUUb1THNNq8E5iU3HQlw0LD5mKInmRyydM13lSOF6r75Cqe1G04kXvG3Ir8L
         3PvmBeDaBgzRBX2CZJr7SQasI1Fk6bZpFAjoFUBHbzhBPYawtZ9B9KhVCjamh3TJUA
         1ZC7ffFURFqMA==
Subject: [PATCH 3/8] libxfs: port transaction precommit hooks to userspace
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 15 Jun 2023 18:37:12 -0700
Message-ID: <168687943296.831530.837601482403467309.stgit@frogsfrogsfrogs>
In-Reply-To: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
References: <168687941600.831530.8013975214397479444.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trans.h  |    6 +++
 libxfs/libxfs_priv.h |    4 ++
 libxfs/logitem.c     |   11 +++++-
 libxfs/trans.c       |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/util.c        |    4 ++
 5 files changed, 117 insertions(+), 4 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 6627a83f..64aade94 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -16,6 +16,11 @@ struct xfs_buf_map;
  * Userspace Transaction interface
  */
 
+struct xfs_item_ops {
+	uint64_t (*iop_sort)(struct xfs_log_item *lip);
+	int (*iop_precommit)(struct xfs_trans *tp, struct xfs_log_item *lip);
+};
+
 typedef struct xfs_log_item {
 	struct list_head		li_trans;	/* transaction list */
 	xfs_lsn_t			li_lsn;		/* last on-disk lsn */
@@ -24,6 +29,7 @@ typedef struct xfs_log_item {
 	unsigned long			li_flags;	/* misc flags */
 	struct xfs_buf			*li_buf;	/* real buffer pointer */
 	struct list_head		li_bio_list;	/* buffer item list */
+	const struct xfs_item_ops	*li_ops;	/* function list */
 } xfs_log_item_t;
 
 #define XFS_LI_DIRTY	3	/* log item dirty in transaction */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index dce5abf2..a23341ae 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -589,8 +589,10 @@ int libxfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
                         xfs_off_t count_fsb);
 
 /* xfs_log.c */
+struct xfs_item_ops;
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
-void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
+void xfs_log_item_init(struct xfs_mount *mp, struct xfs_log_item *lip, int type,
+		const struct xfs_item_ops *ops);
 #define xfs_attr_use_log_assist(mp)	(0)
 #define xlog_drop_incompat_feat(log)	do { } while (0)
 #define xfs_log_in_recovery(mp)		(false)
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 98ccdaef..6b3315c3 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -59,6 +59,9 @@ xfs_trans_buf_item_match(
  * The following are from fs/xfs/xfs_buf_item.c
  */
 
+static const struct xfs_item_ops xfs_buf_item_ops = {
+};
+
 /*
  * Allocate a new buf log item to go with the given buffer.
  * Set the buffer's b_log_item field to point to the new
@@ -101,7 +104,7 @@ xfs_buf_item_init(
 	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
 		bip, bp);
 #endif
-	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF);
+	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF, &xfs_buf_item_ops);
 	bip->bli_buf = bp;
 	bip->__bli_format.blf_type = XFS_LI_BUF;
 	bip->__bli_format.blf_blkno = (int64_t)xfs_buf_daddr(bp);
@@ -127,6 +130,9 @@ xfs_buf_item_log(
 	bip->bli_flags |= XFS_BLI_DIRTY;
 }
 
+static const struct xfs_item_ops xfs_inode_item_ops = {
+};
+
 /*
  * Initialize the inode log item for a newly allocated (in-core) inode.
  */
@@ -146,6 +152,7 @@ xfs_inode_item_init(
 
 	spin_lock_init(&iip->ili_lock);
 
-        xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE);
+        xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE,
+						&xfs_inode_item_ops);
 	iip->ili_inode = ip;
 }
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 553f9471..a05111bf 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -951,6 +951,90 @@ xfs_trans_free_items(
 	}
 }
 
+/*
+ * Sort transaction items prior to running precommit operations. This will
+ * attempt to order the items such that they will always be locked in the same
+ * order. Items that have no sort function are moved to the end of the list
+ * and so are locked last.
+ *
+ * This may need refinement as different types of objects add sort functions.
+ *
+ * Function is more complex than it needs to be because we are comparing 64 bit
+ * values and the function only returns 32 bit values.
+ */
+static int
+xfs_trans_precommit_sort(
+	void			*unused_arg,
+	const struct list_head	*a,
+	const struct list_head	*b)
+{
+	struct xfs_log_item	*lia = container_of(a,
+					struct xfs_log_item, li_trans);
+	struct xfs_log_item	*lib = container_of(b,
+					struct xfs_log_item, li_trans);
+	int64_t			diff;
+
+	/*
+	 * If both items are non-sortable, leave them alone. If only one is
+	 * sortable, move the non-sortable item towards the end of the list.
+	 */
+	if (!lia->li_ops->iop_sort && !lib->li_ops->iop_sort)
+		return 0;
+	if (!lia->li_ops->iop_sort)
+		return 1;
+	if (!lib->li_ops->iop_sort)
+		return -1;
+
+	diff = lia->li_ops->iop_sort(lia) - lib->li_ops->iop_sort(lib);
+	if (diff < 0)
+		return -1;
+	if (diff > 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Run transaction precommit functions.
+ *
+ * If there is an error in any of the callouts, then stop immediately and
+ * trigger a shutdown to abort the transaction. There is no recovery possible
+ * from errors at this point as the transaction is dirty....
+ */
+static int
+xfs_trans_run_precommits(
+	struct xfs_trans	*tp)
+{
+	//struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_log_item	*lip, *n;
+	int			error = 0;
+
+	/*
+	 * Sort the item list to avoid ABBA deadlocks with other transactions
+	 * running precommit operations that lock multiple shared items such as
+	 * inode cluster buffers.
+	 */
+	list_sort(NULL, &tp->t_items, xfs_trans_precommit_sort);
+
+	/*
+	 * Precommit operations can remove the log item from the transaction
+	 * if the log item exists purely to delay modifications until they
+	 * can be ordered against other operations. Hence we have to use
+	 * list_for_each_entry_safe() here.
+	 */
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
+			continue;
+		if (lip->li_ops->iop_precommit) {
+			error = lip->li_ops->iop_precommit(tp, lip);
+			if (error)
+				break;
+		}
+	}
+	if (error)
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return error;
+}
+
 /*
  * Commit the changes represented by this transaction
  */
@@ -967,6 +1051,13 @@ __xfs_trans_commit(
 	if (tp == NULL)
 		return 0;
 
+	error = xfs_trans_run_precommits(tp);
+	if (error) {
+		if (tp->t_flags & XFS_TRANS_PERM_LOG_RES)
+			xfs_defer_cancel(tp);
+		goto out_unreserve;
+	}
+
 	/*
 	 * Finish deferred items on final commit. Only permanent transactions
 	 * should ever have deferred ops.
@@ -977,6 +1068,11 @@ __xfs_trans_commit(
 		error = xfs_defer_finish_noroll(&tp);
 		if (error)
 			goto out_unreserve;
+
+		/* Run precommits from final tx in defer chain. */
+		error = xfs_trans_run_precommits(tp);
+		if (error)
+			goto out_unreserve;
 	}
 
 	if (!(tp->t_flags & XFS_TRANS_DIRTY))
diff --git a/libxfs/util.c b/libxfs/util.c
index 6525f63d..e7d3497e 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -643,10 +643,12 @@ void
 xfs_log_item_init(
 	struct xfs_mount	*mp,
 	struct xfs_log_item	*item,
-	int			type)
+	int			type,
+	const struct xfs_item_ops *ops)
 {
 	item->li_mountp = mp; 
 	item->li_type = type;
+	item->li_ops = ops;
 
 	INIT_LIST_HEAD(&item->li_trans);
 	INIT_LIST_HEAD(&item->li_bio_list);

