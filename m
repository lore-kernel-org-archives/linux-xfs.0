Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wsalTPpQ"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16ACF1710
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ihY/BPGp2Lx+g5Qjt+h+7zMQpGmnwjSrf98+kNB6cDg=; b=wsalTPpQEylBAFyG5VqwPTPj8u
	kO4nMjKfFCKDaYp2dctsGx+bYQCTvC4fdGzZ/FUGFThFhSmp7w7igJJzNSJFpCXILsjNefCtoB8Vx
	HuSiiMZC1Aukm2K91t4Gf0C76FvJH3gdbB0BCoI+TeexXYTgwdf2fdCqZeQhhC9dx1PJDoLp/Du7M
	DKjyHDTpQK16OGg2QA2T/Bes+5HogHYS/J5UvK+vTzqMKcv5dfM0bWg5qpeWy+6ODX8GMSqoOY9U/
	qi3vE2lCT872pYj864Bfv2bGsWY0WOrnbpShZKIafwLK5Vp3zp32JGjdg6F+a4gWvhkQGjKulhiVL
	D/xkGAKg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6kq4-008ZhK-18;
	Sat, 25 Nov 2023 05:04:20 +0000
Date: Fri, 24 Nov 2023 21:04:20 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: don't append work items to logged
 xfs_defer_pending objects
Message-ID: <ZWGAVOuWUjEQntJv@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926145.2768790.15414309437495285174.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926145.2768790.15414309437495285174.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

To make the code nicer for the later addition of the barrier defer
ops I'd fold the hunk belw to split xfs_defer_try_append, but we could
also do that later:

index 6c283b30ea054a..7be2f9063e0ded 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -624,17 +624,12 @@ xfs_defer_cancel(
 	xfs_defer_cancel_list(mp, &tp->t_dfops);
 }
 
-/*
- * Decide if we can add a deferred work item to the last dfops item attached
- * to the transaction.
- */
 static inline struct xfs_defer_pending *
-xfs_defer_try_append(
+xfs_defer_find(
 	struct xfs_trans		*tp,
-	enum xfs_defer_ops_type		type,
-	const struct xfs_defer_op_type	*ops)
+	enum xfs_defer_ops_type		type)
 {
-	struct xfs_defer_pending	*dfp = NULL;
+	struct xfs_defer_pending	*dfp;
 
 	/* No dfops at all? */
 	if (list_empty(&tp->t_dfops))
@@ -646,16 +641,25 @@ xfs_defer_try_append(
 	/* Wrong type? */
 	if (dfp->dfp_type != type)
 		return NULL;
+	return dfp;
+}
 
+/*
+ * Decide if we can add a deferred work item to the last dfops item attached
+ * to the transaction.
+ */
+static inline bool
+xfs_defer_can_append(
+	struct xfs_defer_pending	*dfp,
+	const struct xfs_defer_op_type	*ops)
+{
 	/* Already logged? */
 	if (dfp->dfp_intent)
-		return NULL;
-
+		return false;
 	/* Already full? */
 	if (ops->max_items && dfp->dfp_count >= ops->max_items)
 		return NULL;
-
-	return dfp;
+	return true;
 }
 
 /* Add an item for later deferred processing. */
@@ -671,8 +675,8 @@ xfs_defer_add(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
-	dfp = xfs_defer_try_append(tp, type, ops);
-	if (!dfp) {
+	dfp = xfs_defer_find(tp, type);
+	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
 		/* Create a new pending item at the end of the intake list. */
 		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
 				GFP_NOFS | __GFP_NOFAIL);
