Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC25BA951
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295018; cv=none; b=fQdm90yWStlgKSwwcOXu64XTjzI2LIrP5jjhNdaAVni8NljeHC894SsresudiXT0YVV+LIBmC3vp0v+Nw+kroz2iqZMo6tAM7Bdzc5v7l4Q5jkgd7I/xEPQC6WMIiiPhWpRzMMYoCS1ZSr0NXciTQZLdqfzkiPU/plJUxbZT/3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295018; c=relaxed/simple;
	bh=x60kTWrwiWrKwuOUKSTn4WQRZM5xaf6l0XjSk2K6B10=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5Q877n/AjoEcKNxblxqMAFBSLmMpL8caY35wnTDVbqKopns7P4trmE0gUDfJl/+CrOXyiM/cUNuxXFn9T+DCkNgqudIP0psVD4xi+WoVTc9tVYHehq0OUWOn8oZg04Zqtz04Okl0sxSYv7fdGCRT19sNhYnAqHiqLC11HVjO3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQtWiZd/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQtWiZd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5F6C433C7;
	Wed, 13 Mar 2024 01:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295017;
	bh=x60kTWrwiWrKwuOUKSTn4WQRZM5xaf6l0XjSk2K6B10=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gQtWiZd/2q8IpIaMkmnoDWB0A+IrhCsYXRHM4G0jCtaL37FjugEuURkFJOu5XygHD
	 twh8RzMnqWnUDQqzLjjGN3yCqi4RcF2Vshc6YlgMASvLxO7lzg4C8dqDeT1RLQXgc6
	 KwhFOwOIdw3326Qps2QRuMhBJEpMgCBBfW6ZC7RFjM3J2ZBHZ6dpXSftRoygWqdtK+
	 3PH55EavUUUoa7hkqWuAQ6ytD8C1R9WJHvZppQ1WnVFZiTVUDsibLI6H/DjfUV1Fso
	 Q11fTj0i6adYXaBAt1VwIu72RvHAPYMtzP7ZPP71Ggc2uuy6VDWf2MLOeqft9N3R6J
	 HLzMVTVnlyQVQ==
Date: Tue, 12 Mar 2024 18:56:57 -0700
Subject: [PATCH 15/67] xfs: don't append work items to logged
 xfs_defer_pending objects
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431410.2061787.16324925199920397381.stgit@frogsfrogsfrogs>
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

Source kernel commit: 6b126139401a2284402d7c38fe3168d5a26da41d

When someone tries to add a deferred work item to xfs_defer_add, it will
try to attach the work item to the most recently added xfs_defer_pending
object attached to the transaction.  However, it doesn't check if the
pending object has a log intent item attached to it.  This is incorrect
behavior because we cannot add more work to an object that has already
been committed to the ondisk log.

Therefore, change the behavior not to append to pending items with a non
null dfp_intent.  In practice this has not been an issue because the
only way xfs_defer_add gets called after log intent items have been
the @dop_pending isolation in xfs_defer_finish_noroll protects the
pending items that have already been logged.

However, the next patch will add the ability to pause a deferred extent
free object during online btree rebuilding, and any new extfree work
items need to have their own pending event.

While we're at it, hoist the predicate to its own static inline function
for readability.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_defer.c |   61 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 13 deletions(-)


diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 722ff6a77260..200d1b300f95 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -689,6 +689,51 @@ xfs_defer_cancel(
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
+/*
+ * Return the last pending work item attached to this transaction if it matches
+ * the deferred op type.
+ */
+static inline struct xfs_defer_pending *
+xfs_defer_find_last(
+	struct xfs_trans		*tp,
+	enum xfs_defer_ops_type		type,
+	const struct xfs_defer_op_type	*ops)
+{
+	struct xfs_defer_pending	*dfp = NULL;
+
+	/* No dfops at all? */
+	if (list_empty(&tp->t_dfops))
+		return NULL;
+
+	dfp = list_last_entry(&tp->t_dfops, struct xfs_defer_pending,
+			dfp_list);
+
+	/* Wrong type? */
+	if (dfp->dfp_type != type)
+		return NULL;
+	return dfp;
+}
+
+/*
+ * Decide if we can add a deferred work item to the last dfops item attached
+ * to the transaction.
+ */
+static inline bool
+xfs_defer_can_append(
+	struct xfs_defer_pending	*dfp,
+	const struct xfs_defer_op_type	*ops)
+{
+	/* Already logged? */
+	if (dfp->dfp_intent)
+		return false;
+
+	/* Already full? */
+	if (ops->max_items && dfp->dfp_count >= ops->max_items)
+		return false;
+
+	return true;
+}
+
 /* Add an item for later deferred processing. */
 void
 xfs_defer_add(
@@ -702,19 +747,9 @@ xfs_defer_add(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
-	/*
-	 * Add the item to a pending item at the end of the intake list.
-	 * If the last pending item has the same type, reuse it.  Else,
-	 * create a new pending item at the end of the intake list.
-	 */
-	if (!list_empty(&tp->t_dfops)) {
-		dfp = list_last_entry(&tp->t_dfops,
-				struct xfs_defer_pending, dfp_list);
-		if (dfp->dfp_type != type ||
-		    (ops->max_items && dfp->dfp_count >= ops->max_items))
-			dfp = NULL;
-	}
-	if (!dfp) {
+	dfp = xfs_defer_find_last(tp, type, ops);
+	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
+		/* Create a new pending item at the end of the intake list. */
 		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 				GFP_NOFS | __GFP_NOFAIL);
 		dfp->dfp_type = type;

