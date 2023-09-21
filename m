Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2222CD493B
	for <linux-xfs@archiver.kernel.org>; Thu, 21 Sep 2023 01:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjIUBs6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 21:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjIUBs5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 21:48:57 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CA0AF
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:50 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c44c7dbaf9so3632085ad.1
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 18:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1695260930; x=1695865730; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CzeEBWmN2kD1lC+HOlruj7m6tfoh3K/GU+TzmaCHAek=;
        b=zS9E8HOaupp7gVvWX1JLJq0GONcNkluo0ddSkEHjoPJGS2tfAHHFt1v2DiESZFJ1Xp
         tjtRlKKV2fU5Pd0BpLw9B2zKzYNl2XrBF7dGFD/mR+92t3FYzDcTPzTHI90txmF2s9Pt
         H8WqUumbZ+5XWIepChewgI3fN++2w7B2yp8cNPH6KwNFY/V4KqC+wTqjv+mzv5jgc9dl
         pnOgkbxm/mcb7yyKzMLdBgQ84TAd9lgPJ+FCBx6pj3Yvfs11PUT56FMrpH/Ssx7w1i3Z
         soTexm0kOfXyAqLhC0AQpBUJluOZFZgQQKMkS5zNkkHCmL6VPPQfwpL+R4VxVTXo4eds
         N5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695260930; x=1695865730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CzeEBWmN2kD1lC+HOlruj7m6tfoh3K/GU+TzmaCHAek=;
        b=PpxyColpf9+X6yLNHAP8HLHgG/vDLvsayt5Tu8vff8qM6XAGJpcxxR6IWy3+HtINoY
         XfIwE+he4DtRUTyySbAi2XqPruzEXF3n4ewfmtW3ofIVNQG4seXaiZpavsL/QFd4NIba
         MC4j1bxC3fL8DRVFaKbv2ocrmCxfYejIyw+njHYtkvbYaAl9LWguEnoVQ3OYFQykuNbd
         hO1+vs4NUiJ+r7olx7gYzDybigTNsNuzADxEDLeERnuaTSfctbF6iSfot5oNZVkbANwl
         bUi+ChaCHIyMwJKmn67hmKs46TA9GbGaHUNRqSZXM/FAAqv+ZZ/juv4QCQ887hZimfBx
         METw==
X-Gm-Message-State: AOJu0Ywvkn5WX8PpLUpNRhvXRF2hA7l2nuyvw/ckiPVltp8YAfHLI8Dx
        oq7TywNA30RdDvl04hzbnSCcQ/5MaPpFW/qhx6c=
X-Google-Smtp-Source: AGHT+IEQ5zIlEYwp4ceSigI5J2sIxZB/eAnfnm4ZF2WOEhjcsz/49Uc0aOyyIp867IWwMrm7O/rAOw==
X-Received: by 2002:a17:902:ea0b:b0:1c5:c218:9891 with SMTP id s11-20020a170902ea0b00b001c5c2189891mr2698461plg.20.1695260929955;
        Wed, 20 Sep 2023 18:48:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id iw11-20020a170903044b00b001c582de968dsm158256plb.72.2023.09.20.18.48.49
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 18:48:49 -0700 (PDT)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.96)
        (envelope-from <dave@fromorbit.com>)
        id 1qj8oB-003T1Z-0Z
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:47 +1000
Received: from dave by devoid.disaster.area with local (Exim 4.97-RC0)
        (envelope-from <dave@devoid.disaster.area>)
        id 1qj8oA-00000002VNu-3twC
        for linux-xfs@vger.kernel.org;
        Thu, 21 Sep 2023 11:48:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/9] xfs: move and xfs_trans_committed_bulk
Date:   Thu, 21 Sep 2023 11:48:36 +1000
Message-Id: <20230921014844.582667-2-david@fromorbit.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230921014844.582667-1-david@fromorbit.com>
References: <20230921014844.582667-1-david@fromorbit.com>
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
index ebc70aaa299c..c1fee14be5c2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -695,6 +695,136 @@ xlog_cil_insert_items(
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
@@ -804,7 +934,7 @@ xlog_cil_committed(
 		spin_unlock(&ctx->cil->xc_push_lock);
 	}
 
-	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, &ctx->lv_chain,
+	xlog_cil_ail_insert(ctx->cil->xc_log, &ctx->lv_chain,
 					ctx->start_lsn, abort);
 
 	xfs_extent_busy_sort(&ctx->busy_extents);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 8c0bfc9a33b1..4ebef316c128 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -717,135 +717,6 @@ xfs_trans_free_items(
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
2.40.1

