Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5F015099A
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803955; cv=none; b=iUIH+UycqCf1jTRgdx9G+3kb6sJzWdzfG6xGJYyZtu50ZbZzKZxU3yCOWIQpUDAVrDr8R0e4YnaqCcMK/ElKb7x0XWjIw7/sPaGLVg8TeZ0xP2XHkxJIjUZw+7ALc3L3zPt/gdJ6TGFokw7ioRk9uJNuZ010Gb6/XF1ajNS4gpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803955; c=relaxed/simple;
	bh=5FburhU4w3fQkPHp67dEAIFAh2jkcwegVWZs8Zqa8rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYtSHeO5sN136VTn40CYkCZMiVbmUG+HD6QzC7Db5FQYL5H184xpC0+j0WjsyNMSewGGtzbH/hWytGDOg+UhxE3eaSpTCFgH3WEnSLY0x6hhJ+j8acK1JBNVz5+YMFAoGBSfbZ8doTKYmGGsQ9Kixsn79i0UT6hWkl9fHW+NZEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsfQ+lHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsfQ+lHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F3BC4AF07;
	Mon, 22 Apr 2024 16:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803955;
	bh=5FburhU4w3fQkPHp67dEAIFAh2jkcwegVWZs8Zqa8rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsfQ+lHWt1lFhEayHjgtxOgXsCtC4MqNw5v14e2rQeLKzsI35QrhlSUsvXpUzE7Vd
	 MX8v4ePErbcfarFdDGMwdkUesSqErpLukScGrava4pbNuGPyc/jUXNXokyj4tFyYJy
	 SxBAnFKI/hCxPqBoE5P4/GvAG1KzhzhjpeCn8KGuBdKtFRuX2N7Yh8lfJYwMsEWBuc
	 5W32PLjgCYnkbacB2ybTonk4s/RPAJxOqzPMsjYwm+jRH/RFySHtCHqRSniyEx8ro4
	 3NUdNCXspCwRVB6MjkUr2onzN47l4W8CogK9zQaO3gjjZI+qPtOfidYPHZnf16g0H6
	 GaLtnKUs62tJg==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 05/67] xfs: hoist intent done flag setting to ->finish_item callsite
Date: Mon, 22 Apr 2024 18:25:27 +0200
Message-ID: <20240422163832.858420-7-cem@kernel.org>
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

Source kernel commit: 3dd75c8db1c1675a26d3e228bab349c1fc065867

Each log intent item's ->finish_item call chain inevitably includes some
code to set the dirty flag of the transaction.  If there's an associated
log intent done item, it also sets the item's dirty flag and the
transaction's INTENT_DONE flag.  This is repeated throughout the
codebase.

Reduce the LOC by moving all that to xfs_defer_finish_one.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 54865b73b..6a9ce9241 100644
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
-- 
2.44.0

