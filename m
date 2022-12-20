Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575DEC3DA6E
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 23:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiLTXXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 18:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLTXXR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 18:23:17 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318A8F4F
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:16 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id d10so649387pgm.13
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 15:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4zkrPNxNQfuqeXolSjD0fop010vx+bHcdJ3i4reoBfw=;
        b=SeoxBidyosl4ZxqzTFYRyMbgBQwPn3D0PRYMSQBobvDy4GlU0or/BmXP4BZxyAAo36
         AC67rd0cBXdcOzE0n53iERD9pCvi2wTK7y8OzhwKQ5+cjgK4EqEhy5v6yYMbAI4qR7hX
         jg1y2WfGdcEjhdt+tjiLrnS0FvF3M68Qh3TlDmR79Ef0K3NLxSK41GpgX2RAnRCxKlNR
         fhsLE7+c6+5xDITcz6Pdu9EPQHsyCzDXPPzSUMA25Vrc6pyWgagIWzoXOCgifBSftmil
         TFYLCJZNpBbrlsIskoBylVL+ZiEQkY+VN2Kl3Jts8hcnCa+7AVnKkXr8Jq9zmIW/uH3s
         DRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4zkrPNxNQfuqeXolSjD0fop010vx+bHcdJ3i4reoBfw=;
        b=yh5ZJIcMKqyUzvt4th5GtwjHcijE0BIpARiqBGVbasij4W79aztmAE+ANtruqAhC01
         Lcjgyc0zTkf+Oq3qXMnIcZXCQxCP1ceZ4wPAO2Tr038d5gS8l+c8MMBgMSLT1tUTdoki
         5lc4ot+rI2Wd4LwY7AuOIsmFHJAKlyvvabfdOzYMbGaYLlra5tTL7W4DBA2u2LeZiMF5
         4TqwkqHL1AOuN+8B6Ev6wR/sbX66PFfjscyyI5toJskA3ISDPOUo5BZ1Y9HTCM+P4acS
         ORDO9v2PWIGv28LhJtn3C/yb5tOvza48eBTZH2Ca2WkRUMlSC1a8Wa0sYrUZ+6HQnuKQ
         4RhA==
X-Gm-Message-State: AFqh2kpbMCPViEMV9lIeBIGS5GOxeR/GdhK1S8CtynrH5ItUJTIVxOSl
        sCEGfR20ypEJOqTLc7X5fxOHZ+TNmFPZth9i
X-Google-Smtp-Source: AMrXdXtMxaQyu9NClkvwHKswIRY2u7+2qoAuEnDgHilpbWRlrriKUAt0m3hvqR/aEKm9ygG0ddUL6w==
X-Received: by 2002:a62:384e:0:b0:575:fbab:a152 with SMTP id f75-20020a62384e000000b00575fbaba152mr49651pfa.31.1671578595519;
        Tue, 20 Dec 2022 15:23:15 -0800 (PST)
Received: from dread.disaster.area (pa49-181-138-158.pa.nsw.optusnet.com.au. [49.181.138.158])
        by smtp.gmail.com with ESMTPSA id h18-20020aa79f52000000b00576df4543d4sm9117230pfr.166.2022.12.20.15.23.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 15:23:14 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1p7lx1-00AsnS-4D
        for linux-xfs@vger.kernel.org; Wed, 21 Dec 2022 10:23:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1p7lx1-00Ec5q-0M
        for linux-xfs@vger.kernel.org;
        Wed, 21 Dec 2022 10:23:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: move and xfs_trans_committed_bulk
Date:   Wed, 21 Dec 2022 10:23:00 +1100
Message-Id: <20221220232308.3482960-2-david@fromorbit.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221220232308.3482960-1-david@fromorbit.com>
References: <20221220232308.3482960-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index eccbfb99e894..a430ef863c55 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -683,6 +683,136 @@ xlog_cil_insert_items(
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
+ * items into the the AIL. This uses bulk insertion techniques to minimise AIL
+ * lock traffic.
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
@@ -792,7 +922,7 @@ xlog_cil_committed(
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
 
-	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, &ctx->lv_chain,
+	xlog_cil_ail_insert(ctx->cil->xc_log, &ctx->lv_chain,
 					ctx->start_lsn, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 7bd16fbff534..58c4e875eb12 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -715,135 +715,6 @@ xfs_trans_free_items(
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
index d5400150358e..52a45f0a5ef1 100644
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
2.38.1

