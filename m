Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA48AD56
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294939; cv=none; b=kVOVDa4/92GwZ565HwLNy2wiV/ufwomwsooT8+TdDTSEHnPkiaUDfS9FvIvZNo4qWhn2TNN+VDKVoCHHilrDMWN/cyGt4DemAvToMf/CxPjtopbyXudEzE7IJ0L4wwUOpvlt+3EevF3nZUZt23JOCfhBpT1qgK8BXRb8Be/ar6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294939; c=relaxed/simple;
	bh=gH6S4iVUkHQMaI7BkVg4g63Fclo57M+u/vyUC1hPNi4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ME4Huo/yTx5gg/L7O6cj06S0PibWJBO/yBx0rXE3Sk+YHARHYMl8MLxZw3m24b4q3You7llwFtjihxKD5ucf3vcpbVMpcvJxftiRBVSKpzPnOu/8nTtVcBgbycRq7WUOixiUS/2C7Ibw/AtEAMieU2staELldmZqrdMtLHVwXl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s03Rtulb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s03Rtulb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2C8C433F1;
	Wed, 13 Mar 2024 01:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294939;
	bh=gH6S4iVUkHQMaI7BkVg4g63Fclo57M+u/vyUC1hPNi4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=s03RtulbjlmlL0i0TJ+casuy+C9s6Iag+1eSn2H3HocU18EBHyiVEdI6abU3hanWp
	 WKdxubSSvtxrJL8PDjmI4Mfu6IgDwU/MESOH9YHndwZW7nFSSF/bc/vOZnqu4FSvlv
	 DSoygfS7W9Hoo+AxHrFw6fV0MsHTSN7+Lr7CUPboNfVe42VcUQ/cLRH2BhLDj1Txtk
	 +timGvEdHpgZViU9ElxkMbK/S6TmxCacgXO5Qi/KaAtIoIEftcFXQ4vQH4BB0YKikb
	 hAldJ1V6gG7Nvr2cPP0VrGmSs6N9h+zo03FuwFdqW8kYzhf4psOAQDzSd/elnlZocT
	 YnOuuY3+ard2A==
Date: Tue, 12 Mar 2024 18:55:38 -0700
Subject: [PATCH 10/67] xfs: move ->iop_relog to struct xfs_defer_op_type
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431338.2061787.12147597650422174571.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a49c708f9a445457f6a5905732081871234f61c6

The only log items that need relogging are the ones created for deferred
work operations, and the only part of the code base that relogs log
items is the deferred work machinery.  Move the function pointers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trans.h |    1 -
 libxfs/xfs_defer.c  |   31 ++++++++++++++++++++-----------
 libxfs/xfs_defer.h  |    3 +++
 3 files changed, 23 insertions(+), 12 deletions(-)


diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index ee250d521118..ab298ccfe556 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -158,7 +158,6 @@ libxfs_trans_read_buf(
 }
 
 #define xfs_log_item_in_current_chkpt(lip)	(false)
-#define xfs_trans_item_relog(lip, dontcare, tp)	(NULL)
 
 /* Contorted mess to make gcc shut up about unused vars. */
 #define xlog_grant_push_threshold(log, need)    \
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 27f9938a08d7..29ec0bd8138c 100644
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
index ef86a7f9b059..78d6dcd1af2c 100644
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
 

