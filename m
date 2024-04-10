Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2138BE7
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710458; cv=none; b=CIDKJW9/z9TucNY9YEdIL80KXIqrpb3hcXYLQNAprcH9T6xEKuYSvERnNcRckqKPKiyryuTAAjlzIyVEoKpafz0/OIVOOxoJM/5/PZOLWTqeIKeMwivFMEXOjdCjbQpQCkXUJuoWB+IfsVYqhOwGVFbIF4HZC6QUPFEYkaRieok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710458; c=relaxed/simple;
	bh=OpcprZP6RXSQm4IUNQRIzYgFKBBCyZKWiMkMLOkQ18E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lnTo6MARSTlte0qewJB/lVMVwHVH+YH6GzM8RR6Gl28Ndx2hIf1TLgIyF5K7bFjGwjTnfLD8HtbJza+yEDp8UDF6NYS5SXK7jUhXTr5d2xgiYxSx0nJoSPWvAJqycgDB130umzLk6V2yOEYBEJ+K1eFO1/zXJMnaGX2Kds1V8sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R92dFnqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R92dFnqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065B3C433C7;
	Wed, 10 Apr 2024 00:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710458;
	bh=OpcprZP6RXSQm4IUNQRIzYgFKBBCyZKWiMkMLOkQ18E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=R92dFnqN0N+en+IqmlSEkcTVyFzMNtEufixWDIlf6da8TtYYAxSLp/EHTP+qPhlx3
	 wZQP4IyGvrcXwDT0ghM3Ms1cfZ3T3FhmYc+ERL6v750SyRKbpb6BFyBvKEFV13KyoQ
	 bWNk1QDYUGWwg43hjDl8eOeSvMcDVnyYjApjkv84EZywQNaNoq2bGEtF3nfLe7HzVB
	 hZpLb2QXur53jEIG46ww7msMT3FYp8ISsfOEtuZkRWgsfXeYAp/v2dTlzUMoiO+Qrk
	 EvDdI4f0xRExyFIeCZac3r68eYVA0DfljbtCHb554o0AGYgN56L6Prv9Yr92gIjMTS
	 nwOMRQei9Bi0Q==
Date: Tue, 09 Apr 2024 17:54:17 -0700
Subject: [PATCH 03/32] xfs: move xfs_attr_defer_add to xfs_attr_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270969608.3631889.469698599262996242.stgit@frogsfrogsfrogs>
In-Reply-To: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
References: <171270969477.3631889.12488500941186994317.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_attr.c |   37 +++----------------------------------
 fs/xfs/xfs_attr_item.c   |   30 ++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h   |    8 ++++++++
 3 files changed, 41 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 426a41b43f641..03df79f63f674 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -903,37 +903,6 @@ xfs_attr_lookup(
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
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -1023,14 +992,14 @@ xfs_attr_set(
 	case -EEXIST:
 		if (!args->value) {
 			/* if no value, we are performing a remove operation */
-			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
+			xfs_attr_defer_add(args, XFS_ATTR_DEFER_REMOVE);
 			break;
 		}
 
 		/* Pure create fails if the attr already exists */
 		if (args->xattr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
+		xfs_attr_defer_add(args, XFS_ATTR_DEFER_REPLACE);
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
@@ -1040,7 +1009,7 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (args->xattr_flags & XATTR_REPLACE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
+		xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
 		break;
 	default:
 		goto out_trans_cancel;
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 4d4fb804c0016..04aa2c68d5e56 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -723,6 +723,36 @@ xfs_attr_create_done(
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

