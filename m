Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EE6BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QK1zRYFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28573C433C8;
	Sun, 31 Dec 2023 21:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059012;
	bh=cLgfqWmnS2O1jcpPrmpOKLFfx67rtv+JaV61aBZarjg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QK1zRYFFZWorTZXcr9hrlTl5e5InpeHz0hDCh9osIMv84upq+GBWf349TqFzc6PvR
	 65sef/AfnXYmfTN43c5/p07EhJ3BMr+Fdhz0OVhfnu8nxwU7iUUgcsh5USROnPjiUS
	 6nCNEhgtH1/d1L+apK23RrUgY4Rko6W5UoNuIYv33C/R76bDGnpJBehUHS81Klt4OI
	 8OD2IdPTI1fxfU7LCO517NLdTtARKzXXZJm+klZ72To8CoXJHqi1ReozSSWbp88b8t
	 04HHfJR2gYulg9qfU7VRXDf03kO/1ah1BzJX+wb26As58b2pxv4GkbTt1iWKRcxkoQ
	 pS4DpKb+jv5Pw==
Date: Sun, 31 Dec 2023 13:43:31 -0800
Subject: [PATCH 06/10] xfs: add a ci_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850991.1765989.4161570305233450796.stgit@frogsfrogsfrogs>
In-Reply-To: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
References: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
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
 fs/xfs/xfs_refcount_item.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index b5087efa2ef28..652507c61573b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -227,6 +227,11 @@ static const struct xfs_item_ops xfs_cud_item_ops = {
 	.iop_intent	= xfs_cud_item_intent,
 };
 
+static inline struct xfs_refcount_intent *ci_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_refcount_intent, ri_list);
+}
+
 /* Sort refcount intents by AG. */
 static int
 xfs_refcount_update_diff_items(
@@ -234,11 +239,8 @@ xfs_refcount_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_refcount_intent	*ra;
-	struct xfs_refcount_intent	*rb;
-
-	ra = container_of(a, struct xfs_refcount_intent, ri_list);
-	rb = container_of(b, struct xfs_refcount_intent, ri_list);
+	struct xfs_refcount_intent	*ra = ci_entry(a);
+	struct xfs_refcount_intent	*rb = ci_entry(b);
 
 	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
@@ -341,11 +343,9 @@ xfs_refcount_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_refcount_intent	*ri;
+	struct xfs_refcount_intent	*ri = ci_entry(item);
 	int				error;
 
-	ri = container_of(item, struct xfs_refcount_intent, ri_list);
-
 	/* Did we run out of reservation?  Requeue what we didn't finish. */
 	error = xfs_refcount_finish_one(tp, ri, state);
 	if (!error && ri->ri_blockcount > 0) {
@@ -372,9 +372,7 @@ STATIC void
 xfs_refcount_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_refcount_intent	*ri;
-
-	ri = container_of(item, struct xfs_refcount_intent, ri_list);
+	struct xfs_refcount_intent	*ri = ci_entry(item);
 
 	xfs_refcount_update_put_group(ri);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);

