Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DA9639
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868118; cv=none; b=NGlNx0UpRRKsn9lGio48DEF9oQtVBEKW2U8MAQr1lTGQx2Hg3r1QMzxq6mqNexn0LG6cGpoKd9NjUJAHnTigFzAFu4yomg+XyWlCB4VAUuxa1pnh1FvEviYVVHmwUMOniIUTdt0IAlMPZizvXWA+soS8xIUIwheWTirEmkjLkdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868118; c=relaxed/simple;
	bh=PceMULnaGdEBxMk4PU8nzqAUyP8Gj17Tqn56drb7Sm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5FbCgyaNKDEX/9pH0glBQA59+TvkCCIg6v8tZ9tHEQmUG3eN6ZZt0mvYJXa56WRPKbU69xbjNFlSTVDkoy/PVprNafrxIyKtw1bvY6dKzxB9VLXPwFqwY4/mrtUDNPktUAAkH4kT6/w6EssK21LUgtPjFrPPhmd4f7OyuCRjLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dNZg+59p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dNZg+59p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=uWsAPhBS+7nuiAbcTgT9Hdk/Zy8gmorRf8Aqmq9Gvpo=; b=dNZg+59piw7xEogrN1LeIfWaMR
	Q1LJ+wve9Di2PSFepv0vHbv751GpG4xQ58XDj/2Ua7rkIJuWor7JH2uXAhioohceoxKhzTRQhzCUR
	5biDAl5634xdWJ9NGIjnmFe3QJiXPo6itnNbEGPvEWwNiX37n2UKmQBClvjJu7I3J/ToaE7Y39Wug
	QZ+EeakB66xHzyASaY2Cdwsj6l+uhYGFPF0aQP9ygY7zIX6aO/YIs/z3yVNN2Wmg2PUPr0LrdL8fU
	eS/xj7ddhvXpZpd9mSUbjz/W1vjWPrrtDUVGt4hYCWi9B/oqI2Sy94QWTHHVvhrtmvFDKHAn/gblB
	FzJo8Qww==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7H-00000003xYF-2hUS;
	Thu, 20 Jun 2024 07:21:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 02/11] xfs: move and rename xfs_trans_committed_bulk
Date: Thu, 20 Jun 2024 09:21:19 +0200
Message-ID: <20240620072146.530267-3-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620072146.530267-1-hch@lst.de>
References: <20240620072146.530267-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

Ever since the CIL and delayed logging was introduced,
xfs_trans_committed_bulk() has been a purely CIL checkpoint
completion function and not a transaction commit completion
function. Now that we are adding log specific updates to this
function, it really does not have anything to do with the
transaction subsystem - it is really log and log item level
functionality.

This should be part of the CIL code as it is the callback
that moves log items from the CIL checkpoint to the AIL. Move it
and rename it to xlog_cil_ail_insert().

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c    | 132 +++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_trans.c      | 129 ---------------------------------------
 fs/xfs/xfs_trans_priv.h |   3 -
 3 files changed, 131 insertions(+), 133 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f51cbc6405c15a..141bde08bd6e3c 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -694,6 +694,136 @@ xlog_cil_insert_items(
 	}
 }
 
+static inline void
+xlog_cil_ail_insert_batch(
+	struct xfs_ail		*ailp,
+	struct xfs_ail_cursor	*cur,
+	struct xfs_log_item	**log_items,
+	int			nr_items,
+	xfs_lsn_t		commit_lsn)
+{
+	int	i;
+
+	spin_lock(&ailp->ail_lock);
+	/* xfs_trans_ail_update_bulk drops ailp->ail_lock */
+	xfs_trans_ail_update_bulk(ailp, cur, log_items, nr_items, commit_lsn);
+
+	for (i = 0; i < nr_items; i++) {
+		struct xfs_log_item *lip = log_items[i];
+
+		if (lip->li_ops->iop_unpin)
+			lip->li_ops->iop_unpin(lip, 0);
+	}
+}
+
+/*
+ * Take the checkpoint's log vector chain of items and insert the attached log
+ * items into the AIL. This uses bulk insertion techniques to minimise AIL lock
+ * traffic.
+ *
+ * If we are called with the aborted flag set, it is because a log write during
+ * a CIL checkpoint commit has failed. In this case, all the items in the
+ * checkpoint have already gone through iop_committed and iop_committing, which
+ * means that checkpoint commit abort handling is treated exactly the same as an
+ * iclog write error even though we haven't started any IO yet. Hence in this
+ * case all we need to do is iop_committed processing, followed by an
+ * iop_unpin(aborted) call.
+ *
+ * The AIL cursor is used to optimise the insert process. If commit_lsn is not
+ * at the end of the AIL, the insert cursor avoids the need to walk the AIL to
+ * find the insertion point on every xfs_log_item_batch_insert() call. This
+ * saves a lot of needless list walking and is a net win, even though it
+ * slightly increases that amount of AIL lock traffic to set it up and tear it
+ * down.
+ */
+static void
+xlog_cil_ail_insert(
+	struct xlog		*log,
+	struct list_head	*lv_chain,
+	xfs_lsn_t		commit_lsn,
+	bool			aborted)
+{
+#define LOG_ITEM_BATCH_SIZE	32
+	struct xfs_ail		*ailp = log->l_ailp;
+	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
+	struct xfs_log_vec	*lv;
+	struct xfs_ail_cursor	cur;
+	int			i = 0;
+
+	spin_lock(&ailp->ail_lock);
+	xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
+	spin_unlock(&ailp->ail_lock);
+
+	/* unpin all the log items */
+	list_for_each_entry(lv, lv_chain, lv_list) {
+		struct xfs_log_item	*lip = lv->lv_item;
+		xfs_lsn_t		item_lsn;
+
+		if (aborted)
+			set_bit(XFS_LI_ABORTED, &lip->li_flags);
+
+		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
+			lip->li_ops->iop_release(lip);
+			continue;
+		}
+
+		if (lip->li_ops->iop_committed)
+			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
+		else
+			item_lsn = commit_lsn;
+
+		/* item_lsn of -1 means the item needs no further processing */
+		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
+			continue;
+
+		/*
+		 * if we are aborting the operation, no point in inserting the
+		 * object into the AIL as we are in a shutdown situation.
+		 */
+		if (aborted) {
+			ASSERT(xlog_is_shutdown(ailp->ail_log));
+			if (lip->li_ops->iop_unpin)
+				lip->li_ops->iop_unpin(lip, 1);
+			continue;
+		}
+
+		if (item_lsn != commit_lsn) {
+
+			/*
+			 * Not a bulk update option due to unusual item_lsn.
+			 * Push into AIL immediately, rechecking the lsn once
+			 * we have the ail lock. Then unpin the item. This does
+			 * not affect the AIL cursor the bulk insert path is
+			 * using.
+			 */
+			spin_lock(&ailp->ail_lock);
+			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0)
+				xfs_trans_ail_update(ailp, lip, item_lsn);
+			else
+				spin_unlock(&ailp->ail_lock);
+			if (lip->li_ops->iop_unpin)
+				lip->li_ops->iop_unpin(lip, 0);
+			continue;
+		}
+
+		/* Item is a candidate for bulk AIL insert.  */
+		log_items[i++] = lv->lv_item;
+		if (i >= LOG_ITEM_BATCH_SIZE) {
+			xlog_cil_ail_insert_batch(ailp, &cur, log_items,
+					LOG_ITEM_BATCH_SIZE, commit_lsn);
+			i = 0;
+		}
+	}
+
+	/* make sure we insert the remainder! */
+	if (i)
+		xlog_cil_ail_insert_batch(ailp, &cur, log_items, i, commit_lsn);
+
+	spin_lock(&ailp->ail_lock);
+	xfs_trans_ail_cursor_done(&cur);
+	spin_unlock(&ailp->ail_lock);
+}
+
 static void
 xlog_cil_free_logvec(
 	struct list_head	*lv_chain)
@@ -733,7 +863,7 @@ xlog_cil_committed(
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
 
-	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, &ctx->lv_chain,
+	xlog_cil_ail_insert(ctx->cil->xc_log, &ctx->lv_chain,
 					ctx->start_lsn, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents.extent_list);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 828da4ac4316d6..bdf3704dc30118 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -725,135 +725,6 @@ xfs_trans_free_items(
 	}
 }
 
-static inline void
-xfs_log_item_batch_insert(
-	struct xfs_ail		*ailp,
-	struct xfs_ail_cursor	*cur,
-	struct xfs_log_item	**log_items,
-	int			nr_items,
-	xfs_lsn_t		commit_lsn)
-{
-	int	i;
-
-	spin_lock(&ailp->ail_lock);
-	/* xfs_trans_ail_update_bulk drops ailp->ail_lock */
-	xfs_trans_ail_update_bulk(ailp, cur, log_items, nr_items, commit_lsn);
-
-	for (i = 0; i < nr_items; i++) {
-		struct xfs_log_item *lip = log_items[i];
-
-		if (lip->li_ops->iop_unpin)
-			lip->li_ops->iop_unpin(lip, 0);
-	}
-}
-
-/*
- * Bulk operation version of xfs_trans_committed that takes a log vector of
- * items to insert into the AIL. This uses bulk AIL insertion techniques to
- * minimise lock traffic.
- *
- * If we are called with the aborted flag set, it is because a log write during
- * a CIL checkpoint commit has failed. In this case, all the items in the
- * checkpoint have already gone through iop_committed and iop_committing, which
- * means that checkpoint commit abort handling is treated exactly the same
- * as an iclog write error even though we haven't started any IO yet. Hence in
- * this case all we need to do is iop_committed processing, followed by an
- * iop_unpin(aborted) call.
- *
- * The AIL cursor is used to optimise the insert process. If commit_lsn is not
- * at the end of the AIL, the insert cursor avoids the need to walk
- * the AIL to find the insertion point on every xfs_log_item_batch_insert()
- * call. This saves a lot of needless list walking and is a net win, even
- * though it slightly increases that amount of AIL lock traffic to set it up
- * and tear it down.
- */
-void
-xfs_trans_committed_bulk(
-	struct xfs_ail		*ailp,
-	struct list_head	*lv_chain,
-	xfs_lsn_t		commit_lsn,
-	bool			aborted)
-{
-#define LOG_ITEM_BATCH_SIZE	32
-	struct xfs_log_item	*log_items[LOG_ITEM_BATCH_SIZE];
-	struct xfs_log_vec	*lv;
-	struct xfs_ail_cursor	cur;
-	int			i = 0;
-
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_cursor_last(ailp, &cur, commit_lsn);
-	spin_unlock(&ailp->ail_lock);
-
-	/* unpin all the log items */
-	list_for_each_entry(lv, lv_chain, lv_list) {
-		struct xfs_log_item	*lip = lv->lv_item;
-		xfs_lsn_t		item_lsn;
-
-		if (aborted)
-			set_bit(XFS_LI_ABORTED, &lip->li_flags);
-
-		if (lip->li_ops->flags & XFS_ITEM_RELEASE_WHEN_COMMITTED) {
-			lip->li_ops->iop_release(lip);
-			continue;
-		}
-
-		if (lip->li_ops->iop_committed)
-			item_lsn = lip->li_ops->iop_committed(lip, commit_lsn);
-		else
-			item_lsn = commit_lsn;
-
-		/* item_lsn of -1 means the item needs no further processing */
-		if (XFS_LSN_CMP(item_lsn, (xfs_lsn_t)-1) == 0)
-			continue;
-
-		/*
-		 * if we are aborting the operation, no point in inserting the
-		 * object into the AIL as we are in a shutdown situation.
-		 */
-		if (aborted) {
-			ASSERT(xlog_is_shutdown(ailp->ail_log));
-			if (lip->li_ops->iop_unpin)
-				lip->li_ops->iop_unpin(lip, 1);
-			continue;
-		}
-
-		if (item_lsn != commit_lsn) {
-
-			/*
-			 * Not a bulk update option due to unusual item_lsn.
-			 * Push into AIL immediately, rechecking the lsn once
-			 * we have the ail lock. Then unpin the item. This does
-			 * not affect the AIL cursor the bulk insert path is
-			 * using.
-			 */
-			spin_lock(&ailp->ail_lock);
-			if (XFS_LSN_CMP(item_lsn, lip->li_lsn) > 0)
-				xfs_trans_ail_update(ailp, lip, item_lsn);
-			else
-				spin_unlock(&ailp->ail_lock);
-			if (lip->li_ops->iop_unpin)
-				lip->li_ops->iop_unpin(lip, 0);
-			continue;
-		}
-
-		/* Item is a candidate for bulk AIL insert.  */
-		log_items[i++] = lv->lv_item;
-		if (i >= LOG_ITEM_BATCH_SIZE) {
-			xfs_log_item_batch_insert(ailp, &cur, log_items,
-					LOG_ITEM_BATCH_SIZE, commit_lsn);
-			i = 0;
-		}
-	}
-
-	/* make sure we insert the remainder! */
-	if (i)
-		xfs_log_item_batch_insert(ailp, &cur, log_items, i, commit_lsn);
-
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_cursor_done(&cur);
-	spin_unlock(&ailp->ail_lock);
-}
-
 /*
  * Sort transaction items prior to running precommit operations. This will
  * attempt to order the items such that they will always be locked in the same
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index d5400150358e85..52a45f0a5ef173 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -19,9 +19,6 @@ void	xfs_trans_add_item(struct xfs_trans *, struct xfs_log_item *);
 void	xfs_trans_del_item(struct xfs_log_item *);
 void	xfs_trans_unreserve_and_mod_sb(struct xfs_trans *tp);
 
-void	xfs_trans_committed_bulk(struct xfs_ail *ailp,
-				struct list_head *lv_chain,
-				xfs_lsn_t commit_lsn, bool aborted);
 /*
  * AIL traversal cursor.
  *
-- 
2.43.0

