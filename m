Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E45262A3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388985; cv=none; b=jVrCraaVilSobSGpJIHS6gyxuBMPItCh1mHwC4b9ZKywga/Gx21bl0JgH1YemBee8l+x7q3aCSdJLm9FHlY0eZxe5ghr2p2tFI2ibDLR7fC4YFRMf2oTxLUlMJIm/XAOPHxD9JObSKAOOov2PvOtqw5oaWF3i5lqfK6GMYx80LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388985; c=relaxed/simple;
	bh=YzJ9y50BWNsyJOq10N6aOaAIU+Tuejvjdg79JvLhT24=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LiNvGdyA8lP3Ken/KBWenP9Po9IMe7cxBFCwal+1Gb+TCN2WJLFbhVLq7H4i6CwmdyhNpTSeFj7ApUU0j0lmJj5NNQIivXrhkb5hOyqeabuBZXJR+r8TfRH3kgH1xdomqfhHW8hNkVAdK0ef7skCvPoy6A+2h3/5YhUpC+wae1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0OX0HKN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0OX0HKN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF48C072AA;
	Wed, 17 Apr 2024 21:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388985;
	bh=YzJ9y50BWNsyJOq10N6aOaAIU+Tuejvjdg79JvLhT24=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i0OX0HKNbIdhsgePGZNkPNY0xC6doDiiIAoTflpCUQ1frBpOGBLgyTu5NghP5ZLSa
	 ZpIkTvuZojGI2OB46c+xzSTJwWQANE4kCqm5nGZQWb9JkiDhGD1ubfYfj5P+8h8lmi
	 CWc6RQkjG04g6ktTsVaTTMHU92VoFAS7yZqIj23WInbpeWGWbttvl9Yzcb0ibuGCEm
	 Z7Go9ZempLmQ6kcsAuAn3LYirqgiB4XR2DYnqEb9wsy96IQi2TL6VCxPSzTuVUcwng
	 WSyIEpK1jFHxcW0A6WOlMfQP+mNtFnDFEaZ55HCx97mSzEnTatk7TDW4GIWnAGYHLp
	 XnIuJ5fyf4xyQ==
Date: Wed, 17 Apr 2024 14:23:04 -0700
Subject: [PATCH 05/67] xfs: hoist intent done flag setting to ->finish_item
 callsite
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338842415.1853449.14362799939712587802.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
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

