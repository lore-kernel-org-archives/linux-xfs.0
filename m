Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475131C6A8
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422248; cv=none; b=WUO36yvwlE7RTJhar5w8NLowmkzONE+aq5cnvM6bdk2/nD1M9qEPDdI72Kq0bTGXPmiuzWf6B16KLqngM0fcFc+v0ptMYPsUUF0+O1CcxZoNg9pMBAzze8uJ0uQXtXXyIMxnd/+qqpYOEb9qXn5iZHDqqAJ9QDIe4vjo3q4u2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422248; c=relaxed/simple;
	bh=neHhtaYHwoF0Zl4gTTBXo8rCaLZt3EGiqXodWtt5sCk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hgRCxeUc1PVY7OtLEaK44YkUCqrqF6EMvvn4p/HBOeDA2/VG7K2LQ1bicw9s4MFdr54ueyzxDiMzjuL8dgoBYRqC+NIvmg+Pw/MAPtDoqIXLm6+qqXD28PcrnL5qMhGqz8d2DYDu/2GDmeG2HpHL4gol+jJgQ7crsf90BqIV4Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gwJPbMtY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gwJPbMtY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CE5C433C7;
	Tue, 26 Mar 2024 03:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422248;
	bh=neHhtaYHwoF0Zl4gTTBXo8rCaLZt3EGiqXodWtt5sCk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gwJPbMtYN0xb9X+5LWJw0m+ckbYszFCQ6Ge48I0D6KxU0vIoBChFBCPQzF0aWevKX
	 kqZHYA0XpO1W+cNmd5DyYYv1TL0R47qXhrFjGMvv2HVAaXMtLapzIvQcRRt6unRqKF
	 kvV95ePRweH3PgaEa92s97IROuyZy94dTmAen83x7QYRoSj3O0F/PFZXaSIubz1DQf
	 RzCBqI9GQDkaEjWAUqIq69VBHc9xCnTcSTNFghKHoqQ5mn7y4LD8a0J0cpG4CB6TmQ
	 GeZm0eq+BtDiUY7dfNZLD9sUdn/OJPXyXEEZkEIhvC9jPt9+UbGBTB+iM8NW+VG/zy
	 oXpmz4Q60r0FQ==
Date: Mon, 25 Mar 2024 20:04:07 -0700
Subject: [PATCH 05/67] xfs: hoist intent done flag setting to ->finish_item
 callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142127036.2212320.14528986078829285995.stgit@frogsfrogsfrogs>
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

Source kernel commit: 3dd75c8db1c1675a26d3e228bab349c1fc065867

Each log intent item's ->finish_item call chain inevitably includes some
code to set the dirty flag of the transaction.  If there's an associated
log intent done item, it also sets the item's dirty flag and the
transaction's INTENT_DONE flag.  This is repeated throughout the
codebase.

Reduce the LOC by moving all that to xfs_defer_finish_one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
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

