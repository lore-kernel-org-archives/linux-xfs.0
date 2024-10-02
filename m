Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901FA79D0
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832098; cv=none; b=VavsUfozPjDEjCg3QGegcXBVpRD9T4EmYOZKsqggLP14ThEZCWqz2pM3M5E+6F6IrzU7aq7fzhHtwv8CYzCG+SqfuPxcvmenSoi6EcLfJEDiGGcgArvHN5MgrvcKqTnitUS9Vb3qhLuQVfd6rjhDojePzcLvyI4WeA6ubg6iyIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832098; c=relaxed/simple;
	bh=R5v8HIevhYsb2hd1oSxeY+XrtCJoRndcij9Unwvh5mw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f4tEVCOY18axAIhydYtVByEz6ZX8EPygg+RghOVhRPCWQOr6YRK5E3M1mXy32w3bzz2+ffuuvxKr6wKv5wy8jDDoB8IU5/Ag8g+vIqKFHuKlRWIDfc7csoe/+xqlG2Mz39ZdtHusUaH04nyM36B7IVLM/pg0SHvsT/wZCxlModc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=svIvJ+tM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="svIvJ+tM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1078FC4CEC6;
	Wed,  2 Oct 2024 01:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832098;
	bh=R5v8HIevhYsb2hd1oSxeY+XrtCJoRndcij9Unwvh5mw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=svIvJ+tMAKpp7rzfRLVP1DISD6vYjvpceWlT1i1RP7IQaZScweLjUPLCcb/BAZkxt
	 LnS7KEeWMZIYEiGwbotvsSdCT3Jm5fZ8mLEv4ltJYlOoSUnENna3oWZDiJqx5wKVJI
	 kX/gigFAPwRqDb1vKYabQWTSF+DN5YyAbAtbqq4wOjP/dznBYYm0T5TYWBzYsSdzNt
	 yrIsuqQwdEdMNaK7j0rkHEwdR9SpOYpRQPwZiljMYIpvJgR1nlK881juywNUi1r7cf
	 E404vnUh4sXl75FHqrryHzv9aOiV4bRZvW5Y94LmowlwF2KUgR675vIKEXJXmEcLhF
	 znY0CTtmC7/eQ==
Date: Tue, 01 Oct 2024 18:21:37 -0700
Subject: [PATCH 53/64] xfs: add a ci_entry helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102580.4036371.16891509761067297377.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0e9254861f980bd60a58b7c2b57ba0414c038409

Add a helper to translate from the item list head to the
refcount_intent_item structure and use it so shorten assignments and
avoid the need for extra local variables.

Inspired-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 1c106b844..53902d775 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -321,6 +321,11 @@ const struct xfs_defer_op_type xfs_rmap_update_defer_type = {
 
 /* Reference Counting */
 
+static inline struct xfs_refcount_intent *ci_entry(const struct list_head *e)
+{
+	return list_entry(e, struct xfs_refcount_intent, ri_list);
+}
+
 /* Sort refcount intents by AG. */
 static int
 xfs_refcount_update_diff_items(
@@ -328,11 +333,8 @@ xfs_refcount_update_diff_items(
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
@@ -387,10 +389,9 @@ xfs_refcount_update_finish_item(
 	struct list_head		*item,
 	struct xfs_btree_cur		**state)
 {
-	struct xfs_refcount_intent	*ri;
+	struct xfs_refcount_intent	*ri = ci_entry(item);
 	int				error;
 
-	ri = container_of(item, struct xfs_refcount_intent, ri_list);
 	error = xfs_refcount_finish_one(tp, ri, state);
 
 	/* Did we run out of reservation?  Requeue what we didn't finish. */
@@ -417,9 +418,7 @@ STATIC void
 xfs_refcount_update_cancel_item(
 	struct list_head		*item)
 {
-	struct xfs_refcount_intent	*ri;
-
-	ri = container_of(item, struct xfs_refcount_intent, ri_list);
+	struct xfs_refcount_intent	*ri = ci_entry(item);
 
 	xfs_refcount_update_put_group(ri);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);

