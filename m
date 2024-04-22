Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568D815381C
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803963; cv=none; b=CJ4yd/ir+vIovx8yMiwDK1ig1+uy3Cdoil+B3SD69aa28KvfkS4to/qFyddduzXco8w3stgfaY1E2onDlLtvjbU6l3ETFH4lpUcixKbRdgmlUBGHr5Do73ZueSJQfLr2WYJEY0NbyA60vM+2tnQ/NtRBMwmj62lA0J2+QqCPjL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803963; c=relaxed/simple;
	bh=OWXNJHlc2Nk06SpPEEfFoSuWCnSHtzrACRhkZXp+T2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZir3NI/l76OMiep2BWFsHcKJ1BiuxgCetLlsCTf4CGmsEg16fiscQNYAJchcQQQNvVC3qpPfCjU/A9IM2UbZgoh78ADS5ZakJIThmFSnmbS9p0b9xzd9SSmej7n8MVafaHQskFwbjV90jNciBsjms7gZS8geVm191vXmR3Jet0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fbGYiZdv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbGYiZdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC14C113CC;
	Mon, 22 Apr 2024 16:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803963;
	bh=OWXNJHlc2Nk06SpPEEfFoSuWCnSHtzrACRhkZXp+T2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbGYiZdv6eLaTWuuV5ShJIDTbTewqqMSqBlvnjXj4mOdlPCZ16tW92aU6IAMfGN3M
	 UbU7aRWxu8JsNcYArLD8V5UInQBAe86ObvqQWzOKNAxUnw+3trYWJmAu3JQ19dPBsj
	 FbjEdSKWcdYBXwwUGZ1TaAxNWzcmxJp2QHkU+xvdSyFx+vu5KINTf6qTH9KGPz8vIW
	 LMTwKu8e/X0zhQsv764EmQK+tqYaSBLU7D4M36Cy2U5inKMKUeMTPm8ixofYFZyu2R
	 M+RdT87IjNjMynitCBN6BZU3PPCjt85lJ8BTAkeq6ndVfak8L/7O8jMV9EYHefHJMk
	 W1aCnOTB+7eVg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 10/67] xfs: move ->iop_relog to struct xfs_defer_op_type
Date: Mon, 22 Apr 2024 18:25:32 +0200
Message-ID: <20240422163832.858420-12-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: a49c708f9a445457f6a5905732081871234f61c6

The only log items that need relogging are the ones created for deferred
work operations, and the only part of the code base that relogs log
items is the deferred work machinery.  Move the function pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/xfs_trans.h |  1 -
 libxfs/xfs_defer.c  | 31 ++++++++++++++++++++-----------
 libxfs/xfs_defer.h  |  3 +++
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index b39f0c22d..ab298ccfe 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -158,7 +158,6 @@ libxfs_trans_read_buf(
 }
 
 #define xfs_log_item_in_current_chkpt(lip)	(false)
-#define xfs_trans_item_relog(lip, dip, tp)	(NULL)
 
 /* Contorted mess to make gcc shut up about unused vars. */
 #define xlog_grant_push_threshold(log, need)    \
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 27f9938a0..29ec0bd81 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -453,6 +453,25 @@ xfs_defer_cancel_list(
 		xfs_defer_pending_cancel_work(mp, dfp);
 }
 
+static inline void
+xfs_defer_relog_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	struct xfs_log_item		*lip;
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+
+	xfs_defer_create_done(tp, dfp);
+
+	lip = ops->relog_intent(tp, dfp->dfp_intent, dfp->dfp_done);
+	if (lip) {
+		xfs_trans_add_item(tp, lip);
+		set_bit(XFS_LI_DIRTY, &lip->li_flags);
+	}
+	dfp->dfp_done = NULL;
+	dfp->dfp_intent = lip;
+}
+
 /*
  * Prevent a log intent item from pinning the tail of the log by logging a
  * done item to release the intent item; and then log a new intent item.
@@ -471,8 +490,6 @@ xfs_defer_relog(
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	list_for_each_entry(dfp, dfops, dfp_list) {
-		struct xfs_log_item	*lip;
-
 		/*
 		 * If the log intent item for this deferred op is not a part of
 		 * the current log checkpoint, relog the intent item to keep
@@ -500,15 +517,7 @@ xfs_defer_relog(
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 
-		xfs_defer_create_done(*tpp, dfp);
-		lip = xfs_trans_item_relog(dfp->dfp_intent, dfp->dfp_done,
-				*tpp);
-		if (lip) {
-			xfs_trans_add_item(*tpp, lip);
-			set_bit(XFS_LI_DIRTY, &lip->li_flags);
-		}
-		dfp->dfp_done = NULL;
-		dfp->dfp_intent = lip;
+		xfs_defer_relog_intent(*tpp, dfp);
 	}
 
 	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index ef86a7f9b..78d6dcd1a 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -59,6 +59,9 @@ struct xfs_defer_op_type {
 	void (*cancel_item)(struct list_head *item);
 	int (*recover_work)(struct xfs_defer_pending *dfp,
 			    struct list_head *capture_list);
+	struct xfs_log_item *(*relog_intent)(struct xfs_trans *tp,
+			struct xfs_log_item *intent,
+			struct xfs_log_item *done_item);
 	unsigned int		max_items;
 };
 
-- 
2.44.0

