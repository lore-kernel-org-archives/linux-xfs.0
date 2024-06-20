Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816A982D83
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925055; cv=none; b=QWoFg07O1hGqfM+rcaQ2QfQEd754la0IeuhrNPNTFrNecDxeFqfS28UKWwOWVZayzJ4fqSewM3Y90sR3c7TFU6uz4CthozqrpFTG9YBVTcmjhnEYPTtl3HNAvt9GO999x0BJo8Y1erRN+9wPuTrLjlxlgRBpGzYjCXlOIL7Z16A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925055; c=relaxed/simple;
	bh=Z3MNSrDiG4xk1nM2nQnFzgQkowaVM57ciMCklPD6Xd0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TdCanLa70x38b/btDrDgAFW6nL7jN0sBRLJqaUC2TxXDA1Ogbzq9LJMSrHuaEizzxOy2heQniNl/V4EpU6ruFNr0yP39ywh/vdlzFRVEjXEpchhSmmV/lUQokZlu87w9z4DyG3zl3SdPe4js0ESKrxU5nec/7viZCkDGXSDd6Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUdOV714; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUdOV714"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE10C32781;
	Thu, 20 Jun 2024 23:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925055;
	bh=Z3MNSrDiG4xk1nM2nQnFzgQkowaVM57ciMCklPD6Xd0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cUdOV714YkwIQ88y7rYFr20Q4gMW7IPC3j3jylfB3cRU44uXQDbd9udBIQzKHvU9Q
	 q+zd9uNDAccJn4CPgmIVK+ZEzfKI37DtV6C2uwN5aK0blpt6yBRV8atLPqkM2hGzSF
	 y2bQ/uXSTpz4r/TrWWBJ8BEyFlTLQwgFXbKEhleGdqoBz9kPYacNniI74dFyxmZGH5
	 C02EZ9kET7mgRYA6HRoYcKc4JQX3fxDwMT19z4lmBo2BdYyt5nZpK34qIOMW1uqYEj
	 Jve7PJgnmUKemFUPgsZMitutv+KXYRbMu01jTgBWwlrw0RByyRbHpCg4152naCwQW4
	 GCB/HpeYUZa9w==
Date: Thu, 20 Jun 2024 16:10:54 -0700
Subject: [PATCH 06/10] xfs: add a ci_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419875.3184748.10263305750216565433.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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
index deb8b4aaa9541..cc53c733bef1b 100644
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

