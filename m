Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18BBA2B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294861; cv=none; b=UvtwIi9L3ZOhcDl+M1KNd604Oa/dlJyjS2HQYws5L2Ijt3zYBrtbaSXtNRRhjY21dVgRSbZZnA0ELXXcN+4tBlpn95Ib+dAgUg0HTj8oOkIYnxFd8BJAs7JK0qp1gRCVCCsJnrO1ZoIUv7DtH7/3tyEV+DnyPh2tmRK2bEmQ4rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294861; c=relaxed/simple;
	bh=ZuurV066BV4kBhfj5hXsd9HPmpGfRWw0Jq5DAw6bWwg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlbyCB1/6EpA4LAr3tttB+sRGsKgofMi60ll8p724a4xSWKHwXY/hEQvsbs4DVNoJyM5P9RgMymdBaPNo2LvpfjQreWfQgkby9alO8KOYdf9Mk+7jNnlbJsyZRqRwVT7lVzPN7VudDhK2NWTnD1NTXhf0qzQ5shdQKnoCiTDTIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=caFUuNFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caFUuNFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455AEC433C7;
	Wed, 13 Mar 2024 01:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710294861;
	bh=ZuurV066BV4kBhfj5hXsd9HPmpGfRWw0Jq5DAw6bWwg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=caFUuNFkdie+sTohKRs7Ai5k2scE/r8FCTuqIYfGVdIsqejUoEDbHVd+RkLOEp4TX
	 3Ymij9+wyhKEef0pv7gM7JfTWPZ7tUdEuCtFgIBMI7QzzCDqwLsywHno7J3KqdGhvq
	 bxCi3fwTYduietqOTSBxARSAXFcA2C5nf7HFJ8sk1oktnQPoSOCFB0Uny/EOmC1mfu
	 rqlbYlwNvGGteVkEN0vli4NNGBOhJBtR2rtx/qK2Gv35TU2Hl3C+DGKQEl5WCA5UVQ
	 QHa4vWs/Q8xAFJ2OVNVaz/kBqBVdQ3UVnjNrbZwdus+2i5U9xqTAajeF7rnjeVuXtG
	 SPZfchDrwDZsw==
Date: Tue, 12 Mar 2024 18:54:20 -0700
Subject: [PATCH 05/67] xfs: hoist intent done flag setting to ->finish_item
 callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171029431265.2061787.17302316296695672402.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3dd75c8db1c1675a26d3e228bab349c1fc065867

Each log intent item's ->finish_item call chain inevitably includes some
code to set the dirty flag of the transaction.  If there's an associated
log intent done item, it also sets the item's dirty flag and the
transaction's INTENT_DONE flag.  This is repeated throughout the
codebase.

Reduce the LOC by moving all that to xfs_defer_finish_one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 54865b73b47f..6a9ce92419c0 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -186,6 +186,32 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
+/* Create a log intent done item for a log intent item. */
+static inline void
+xfs_defer_create_done(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct xfs_log_item		*lip;
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the log intent item and frees the log done item
+	 * 2.) shuts down the filesystem
+	 */
+	tp->t_flags |= XFS_TRANS_DIRTY;
+	lip = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	if (!lip)
+		return;
+
+	tp->t_flags |= XFS_TRANS_HAS_INTENT_DONE;
+	set_bit(XFS_LI_DIRTY, &lip->li_flags);
+	dfp->dfp_done = lip;
+}
+
 /*
  * Ensure there's a log intent item associated with this deferred work item if
  * the operation must be restarted on crash.  Returns 1 if there's a log item;
@@ -491,7 +517,7 @@ xfs_defer_finish_one(
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 
-	dfp->dfp_done = ops->create_done(tp, dfp->dfp_intent, dfp->dfp_count);
+	xfs_defer_create_done(tp, dfp);
 	list_for_each_safe(li, n, &dfp->dfp_work) {
 		list_del(li);
 		dfp->dfp_count--;

