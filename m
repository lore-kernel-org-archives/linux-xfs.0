Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81B912836A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422327; cv=none; b=exYoSyDGCgGZ3e8K/863uwyMP5+K1vqvhc1LH+tZNm1Fqwr1QTt/7gKDWYEpERHHyibuglIIil7EGbowCoe6QTzIakNG+pwaWEaY1Fz1dz7XO2XEV/eIufJqUAwOOj6vIckobpI45J5j3iAFI/7o0nNJNNc55FIWfz2RfVLcM9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422327; c=relaxed/simple;
	bh=0zEzRJLuK8YbmFcD3WqNg9K0KOjodformHA2xyEFGrA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C1qcIiQWLMkElEggbhAbYtv7z/2Ym8ufXA8c1wc7CJKTp3ltLmEqau2LFcVbkmQY4IzC7FJu81NhiHdvde2Rhr7antlNG7CRSI/VnMtjQr4wLxJ7h/Fvi/vy5De782Kafj8leqExUWPBfQtYeezrHLEH9/nBcKh6D8mCL2t9Lcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XhDPK3sX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XhDPK3sX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8943AC433F1;
	Tue, 26 Mar 2024 03:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422326;
	bh=0zEzRJLuK8YbmFcD3WqNg9K0KOjodformHA2xyEFGrA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XhDPK3sXFX+6f/GKggMvHEvVfjTU7FynGKa9MSElPcJCMuL6wXbI5yI9yFYe8yAPI
	 DUFoBEKxVZ8hnAkzHYjq16MedyfyKYLsUmTBkK2bAMzHiILGe5bkx43ZyYUaR99XL0
	 q+V/brjhhknDWFXJLliiJK7Orr0XSZMaKk56qcM1byEWCee4bArEvNxhixSJmfwV/N
	 P7pPsszn3sOcFNMpOgJW6rWrhD5BUQfDiW3Qc6xzsMtFpI2CHS52K89tzflVjXUrV6
	 rGWwkQQDK1rRnWIwn3oSKWLICT/q+U5QGdMta4rheaTw+sx4o2UHKvX7OABNnI1Lpi
	 dPnF8gyvvLO5Q==
Date: Mon, 25 Mar 2024 20:05:25 -0700
Subject: [PATCH 10/67] xfs: move ->iop_relog to struct xfs_defer_op_type
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127107.2212320.4637416192103603176.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
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
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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
 

