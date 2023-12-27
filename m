Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A647ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IA9+YC7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6280C433C8;
	Mon,  1 Jan 2024 00:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068706;
	bh=eyqyI9y4pDC5YcaQI7j3qP4STWt0ttaQFy2OIKIse6o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IA9+YC7/BzlqMt9uCAiowkTjAWeDYYNSbwjAoqbJHJgibeRIv9PVQljOGR5b12h6d
	 Ur9wzQJo9GT7YyPyG5SkagS4XDqr1el1TtIMzldsPjRvWOg5Bri+1fwjAhC3IAMIgA
	 MjWrY1S7arwVy6YrdKKgNkYjZVNsZ+Tpk2ov34T3rPkGJ+XKc+ckufZO9N8D0rvYz6
	 dYOqrcuDXCFvB0Vnu+a/2SODHBMHG5CAjs+AAyYElyNCxDevQC4fzePEv4Jp6HxN9B
	 Tq31DoqEvWSG2owCgEotxyw2zavJfbNU9/L/anySAqWGBDI/YfEiKaGCeQUoiWppiR
	 zlZYMk1xa24AA==
Date: Sun, 31 Dec 2023 16:25:06 +9900
Subject: [PATCH 5/9] xfs: add a ci_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016687.1816837.6258236545791657769.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
References: <170405016616.1816837.2298941345938137266.stgit@frogsfrogsfrogs>
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

Add a helper to translate from the item list head to the
refcount_intent_item structure and use it so shorten assignments and
avoid the need for extra local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index e7270d02c4b..471e4f6867d 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -485,6 +485,11 @@ const struct xfs_defer_op_type xfs_rtrmap_update_defer_type = {
 
 /* Reference Counting */
 
+static inline struct xfs_refcount_intent *ci_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_refcount_intent, ri_list);
+}
+
 /* Sort refcount intents by AG. */
 static int
 xfs_refcount_update_diff_items(
@@ -492,11 +497,8 @@ xfs_refcount_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_refcount_intent *ra;
-	const struct xfs_refcount_intent *rb;
-
-	ra = container_of(a, struct xfs_refcount_intent, ri_list);
-	rb = container_of(b, struct xfs_refcount_intent, ri_list);
+	struct xfs_refcount_intent	*ra = ci_entry(a);
+	struct xfs_refcount_intent	*rb = ci_entry(b);
 
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
@@ -551,10 +553,9 @@ xfs_refcount_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_refcount_intent	*ri;
+	struct xfs_refcount_intent	*ri = ci_entry(item);
 	int				error;
 
-	ri = container_of(item, struct xfs_refcount_intent, ri_list);
 	error = xfs_refcount_finish_one(tp, ri, state);
 
 	/* Did we run out of reservation?  Requeue what we didn't finish. */
@@ -581,9 +582,7 @@ STATIC void
 xfs_refcount_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_refcount_intent	*ri;
-
-	ri = container_of(item, struct xfs_refcount_intent, ri_list);
+	struct xfs_refcount_intent	*ri = ci_entry(item);
 
 	xfs_refcount_update_put_group(ri);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);

