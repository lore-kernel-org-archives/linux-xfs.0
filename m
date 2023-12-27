Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751E38E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oUAsGfHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E048EC433C8;
	Mon,  1 Jan 2024 00:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067769;
	bh=U3kXH8HUtA358UPGU5vNNB0P2XkzNj5NTeoC5oNC0Uw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oUAsGfHDG0BFm5u94p/wS/FIIYBjLxh22fYPNUhU9kIc0ac6jDfi3SO0DU4o/lQhq
	 djiU40BQaHQHeQvdXXDF3XGrp7/jLkZLkfycPs3qRfn8qXkba+iZAiwO+RrpQ1OLM2
	 Paoo7uQBMWlXgp3PPUpulGwT8bkzMPFcKcr9mJZY/ZetvPA6QYW5pUqMCiJ1nC1JWH
	 vc1Mx4cJl0dE7pkuNoyLOTwn2k/lLiyPRIUVClC/wtnAdfV1eXiqpgHsHfUqIWtAhW
	 aCHAYjy1VO0YKrIbDDFCTXs7D2hyMtwDS4Afx6nl/thPbQ32dSRtqwlrGfUKyeQtuf
	 6AFVK8klvvBTQ==
Date: Sun, 31 Dec 2023 16:09:28 +9900
Subject: [PATCH 5/9] xfs: add a ri_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <170405014884.1815232.3576515918053401150.stgit@frogsfrogsfrogs>
In-Reply-To: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
References: <170405014813.1815232.16195473149230327174.stgit@frogsfrogsfrogs>
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
rmap_intent_item structure and use it so shorten assignments and avoid
the need for extra local variables.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/defer_item.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 82b70575bc5..8fc27e9efd4 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -275,6 +275,11 @@ const struct xfs_defer_op_type xfs_agfl_free_defer_type = {
 
 /* Reverse Mapping */
 
+static inline struct xfs_rmap_intent *ri_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_rmap_intent, ri_list);
+}
+
 /* Sort rmap intents by AG. */
 static int
 xfs_rmap_update_diff_items(
@@ -282,11 +287,8 @@ xfs_rmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	const struct xfs_rmap_intent	*ra;
-	const struct xfs_rmap_intent	*rb;
-
-	ra = container_of(a, struct xfs_rmap_intent, ri_list);
-	rb = container_of(b, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ra = ri_entry(a);
+	struct xfs_rmap_intent		*rb = ri_entry(b);
 
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
@@ -341,11 +343,9 @@ xfs_rmap_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_rmap_intent		*ri;
+	struct xfs_rmap_intent		*ri = ri_entry(item);
 	int				error;
 
-	ri = container_of(item, struct xfs_rmap_intent, ri_list);
-
 	error = xfs_rmap_finish_one(tp, ri, state);
 
 	xfs_rmap_update_put_group(ri);
@@ -365,9 +365,7 @@ STATIC void
 xfs_rmap_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_rmap_intent		*ri;
-
-	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+	struct xfs_rmap_intent		*ri = ri_entry(item);
 
 	xfs_rmap_update_put_group(ri);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);

