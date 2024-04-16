Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4501A6AB9
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230810; cv=none; b=eL+LstVoSM5DfawC5spAJlQOFRpCz6BTgO5HGNvKIrYAlrTcqBq3RS7intSL4bNcLSC2IqfIJApNTIBe6cDioCyAnTo99TQKxUwk51gI8WWNH7nnVOrmUrnX5kg/5qXg0I6pc4+fWErX+MsMDtE7n5+hYvx0R//YDOaKtWxbsec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230810; c=relaxed/simple;
	bh=TUdBTHzuS+dy//z0+8rOyzxZUgkRrF6cg9wzvV94+p0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgioJr8GN2rdyqCNv6vR/ra9f+wwAs3QPDoB4MMMu6RCrQuehEom27uhk8oUPU//aU9yFyjuvNaSGzhUXUHgtvzD+RPmFla6vm1bDhOaG+SvX28iUgtkJhz8ff3llBREzf0XQHt31q+bB8THJgia5jGKdPrWBLoMS3DYtzYt2+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lpEot5Ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lpEot5Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8E4C113CC;
	Tue, 16 Apr 2024 01:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230810;
	bh=TUdBTHzuS+dy//z0+8rOyzxZUgkRrF6cg9wzvV94+p0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lpEot5EwHe1zTtO4fo9bYF6rdqEJQAs8YAJluANj0LJK5FDID+99zUXwdOzSZ7Z7L
	 4/fdi4yLKjcmVprvjCaRJ4O2ojvUbEZGw0OxpHB5Vz48I2GFxhmsNNGxu5zvUy02sS
	 S5bbnoOuLGWCDsmn0YR32qSBvfWf20bYV0DDsbjpjWHqBOyNfXxHp47P6iJCjAZHPV
	 m+H2slB3KQK0xwKnU5pm9LGBK7QCcvXNpT5GP3+l2ZkjALhnwy7POgUpLRVK87wRPb
	 PHYREEKU3RzQP1xOrYO9lS65Mo+7tToDVJrKsvlbYsKBWxkVY7vM4yGqSf4Z+1xW9n
	 tY7nJ982kcrFg==
Date: Mon, 15 Apr 2024 18:26:49 -0700
Subject: [PATCH 03/31] xfs: move xfs_attr_defer_add to xfs_attr_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323027834.251715.1479493083656670893.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
References: <171323027704.251715.12000080989736970684.stgit@frogsfrogsfrogs>
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

Move the code that adds the incore xfs_attr_item deferred work data to a
transaction live with the ATTRI log item code.  This means that the
upper level extended attribute code no longer has to know about the
inner workings of the ATTRI log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |   37 +++----------------------------------
 fs/xfs/xfs_attr_item.c   |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h   |    8 ++++++++
 3 files changed, 41 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 629fb25d149cf..50eab63ff3be1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -901,37 +901,6 @@ xfs_attr_lookup(
 	return error;
 }
 
-static void
-xfs_attr_defer_add(
-	struct xfs_da_args	*args,
-	unsigned int		op_flags)
-{
-
-	struct xfs_attr_intent	*new;
-
-	new = kmem_cache_zalloc(xfs_attr_intent_cache,
-			GFP_KERNEL | __GFP_NOFAIL);
-	new->xattri_op_flags = op_flags;
-	new->xattri_da_args = args;
-
-	switch (op_flags) {
-	case XFS_ATTRI_OP_FLAGS_SET:
-		new->xattri_dela_state = xfs_attr_init_add_state(args);
-		break;
-	case XFS_ATTRI_OP_FLAGS_REPLACE:
-		new->xattri_dela_state = xfs_attr_init_replace_state(args);
-		break;
-	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		new->xattri_dela_state = xfs_attr_init_remove_state(args);
-		break;
-	default:
-		ASSERT(0);
-	}
-
-	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
-	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
-}
-
 int
 xfs_attr_set(
 	struct xfs_da_args	*args,
@@ -1021,14 +990,14 @@ xfs_attr_set(
 	case -EEXIST:
 		if (op == XFS_ATTRUPDATE_REMOVE) {
 			/* if no value, we are performing a remove operation */
-			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
+			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
 			break;
 		}
 
 		/* Pure create fails if the attr already exists */
 		if (op == XFS_ATTRUPDATE_CREATE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
+		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
@@ -1038,7 +1007,7 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (op == XFS_ATTRUPDATE_REPLACE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
+		xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
 		break;
 	default:
 		goto out_trans_cancel;
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index a65ac74797680..a7d6c9af47e88 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -727,6 +727,36 @@ xfs_attr_create_done(
 	return &attrdp->attrd_item;
 }
 
+void
+xfs_attr_defer_add(
+	struct xfs_da_args	*args,
+	enum xfs_attr_defer_op	op)
+{
+	struct xfs_attr_intent	*new;
+
+	new = kmem_cache_zalloc(xfs_attr_intent_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	new->xattri_da_args = args;
+
+	switch (op) {
+	case XFS_ATTR_DEFER_SET:
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_SET;
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTR_DEFER_REPLACE:
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_REPLACE;
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTR_DEFER_REMOVE:
+		new->xattri_op_flags = XFS_ATTRI_OP_FLAGS_REMOVE;
+		new->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	}
+
+	xfs_defer_add(args->trans, &new->xattri_list, &xfs_attr_defer_type);
+	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
+}
+
 const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.name		= "attr",
 	.max_items	= 1,
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
index 3280a79302876..c32b669b0e16a 100644
--- a/fs/xfs/xfs_attr_item.h
+++ b/fs/xfs/xfs_attr_item.h
@@ -51,4 +51,12 @@ struct xfs_attrd_log_item {
 extern struct kmem_cache	*xfs_attri_cache;
 extern struct kmem_cache	*xfs_attrd_cache;
 
+enum xfs_attr_defer_op {
+	XFS_ATTR_DEFER_SET,
+	XFS_ATTR_DEFER_REMOVE,
+	XFS_ATTR_DEFER_REPLACE,
+};
+
+void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
+
 #endif	/* __XFS_ATTR_ITEM_H__ */

