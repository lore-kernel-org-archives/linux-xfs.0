Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E36110E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299856; cv=none; b=S5Ur6OPG/F+75lraBO+6/zt9iCqO5SIts0u4XXUAjLdJR44EgcmLPkxwIurMcHxDD8WbIsFNX1XpPLobqywsg4OWbbg3ClxQp/X+cfjU+FIY3GdbSbI/92MoGTT3Cp5iHyy+S86FS+vHpcnxQWcqyFMMS/EURaCB09p0sWDLRmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299856; c=relaxed/simple;
	bh=ExmV9iTl5uDhIj3X34lOrx7MWLwDzQRusxZYxf7np00=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tm/Oi5hYf/+uyCxXnYFrJKUCQPvxSiwXIR3Psakwl148Ytgyf9jQbh+oFa58gwT5fPuV3rSSE8rhxhl0piSoDYN4gs//ZVTOhNKzL9WGdxnXXQOe2jbhKdnKrcID6BxLnNIejHW7aK6rGAxb1i0i+T6JDLCATR/SYPJsFoGPVgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QKKAQI88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QKKAQI88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCF9C32786;
	Tue, 30 Jul 2024 00:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299856;
	bh=ExmV9iTl5uDhIj3X34lOrx7MWLwDzQRusxZYxf7np00=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QKKAQI88nBr2HmYskMIMmef3s92geDS6wLhgmnKh+WgqW37DoQpqdrE5TH84K+ofy
	 SuNXJuZ5fca5WE7TSPSx4L9n4lqfwbsUIWRe5Q6X4QWkq8/MCEDBjxv88pKDLIJK4k
	 K4QND1DgB0Q++sKCpTMeBuPSdNOugZ9zyvREp6VqHdXndgCWmKxKbmnDJuroizDNKB
	 C61X17trP9xafq5INYrzzM0gdRUElxCHO37DAJgr13Vs+bK3aH53YuxBTq0hmQY9m7
	 pYjPx1rWNdAp7z1NjkWrtlwO2VSSybmXxg42xCiIGFbOVIS+TGpDzQtWascmiP6/46
	 7Tkms3rKXt7mg==
Date: Mon, 29 Jul 2024 17:37:35 -0700
Subject: [PATCH 053/115] xfs: move xfs_attr_defer_add to xfs_attr_item.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229843188.1338752.4667514580772658424.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9713dc88773d066413ae23aa474b13241507a89e

Move the code that adds the incore xfs_attr_item deferred work data to a
transaction live with the ATTRI log item code.  This means that the
upper level extended attribute code no longer has to know about the
inner workings of the ATTRI log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/defer_item.c |   28 ++++++++++++++++++++++++++++
 libxfs/defer_item.h |    8 ++++++++
 libxfs/xfs_attr.c   |   38 ++++----------------------------------
 3 files changed, 40 insertions(+), 34 deletions(-)


diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index fd329e77c..9955e189d 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -670,6 +670,34 @@ xfs_attr_cancel_item(
 	xfs_attr_free_item(attr);
 }
 
+void
+xfs_attr_defer_add(
+	struct xfs_da_args	*args,
+	enum xfs_attr_defer_op	op)
+{
+	struct xfs_attr_intent	*new;
+
+	new = kmem_cache_zalloc(xfs_attr_intent_cache, GFP_NOFS | __GFP_NOFAIL);
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
+}
+
 const struct xfs_defer_op_type xfs_attr_defer_type = {
 	.name		= "attr",
 	.max_items	= 1,
diff --git a/libxfs/defer_item.h b/libxfs/defer_item.h
index a5a07867c..df2b8d68b 100644
--- a/libxfs/defer_item.h
+++ b/libxfs/defer_item.h
@@ -10,6 +10,14 @@ struct xfs_bmap_intent;
 
 void xfs_bmap_defer_add(struct xfs_trans *tp, struct xfs_bmap_intent *bi);
 
+enum xfs_attr_defer_op {
+	XFS_ATTR_DEFER_SET,
+	XFS_ATTR_DEFER_REMOVE,
+	XFS_ATTR_DEFER_REPLACE,
+};
+
+void xfs_attr_defer_add(struct xfs_da_args *args, enum xfs_attr_defer_op op);
+
 struct xfs_exchmaps_intent;
 
 void xfs_exchmaps_defer_add(struct xfs_trans *tp,
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index e0a3bc702..7f64d8a2e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_quota_defs.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "defer_item.h"
 
 struct kmem_cache		*xfs_attr_intent_cache;
 
@@ -899,37 +900,6 @@ xfs_attr_lookup(
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
@@ -1019,14 +989,14 @@ xfs_attr_set(
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
@@ -1036,7 +1006,7 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (op == XFS_ATTRUPDATE_REPLACE)
 			goto out_trans_cancel;
-		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
+		xfs_attr_defer_add(args, XFS_ATTR_DEFER_SET);
 		break;
 	default:
 		goto out_trans_cancel;

