Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6140E153BCF
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713803986; cv=none; b=dMe9oEa4e5O09Tz9u2t0fF5X1Cv3wxNhDPh5UZnsxw4o1YGKUpv4yvVotedrVwh6TGj1dyzqrA+JBZClJ9vWvMpslvGTuYIL1ZtS9lAlF4K3TN9kM6MLx9HyJ6HN30RPvZJGv2PmGMGteK5Ez6pkEnafbgLMzIJIlJK3Pd9JIWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713803986; c=relaxed/simple;
	bh=cUtkCKTPNXwhktTBgXvdP/lBZWE+rJmLWeeo3z7QbSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF1Htt8+PQDT/PaoiBAZpZON3kgk8gq1mhBw8tjLm4x68qcrTCHf4T3CfldwBbSUcdrnss3fzU4GNYbirmOM5XUKwxF0awVYb84gj3t6+PSG1ru96bPpN0fnMP104ZZ2vihyNWcsy4bly/meZXiy9+8Vwe+WqPUQgot4cXjyPlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SOc+3oZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SOc+3oZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC82C116B1;
	Mon, 22 Apr 2024 16:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713803986;
	bh=cUtkCKTPNXwhktTBgXvdP/lBZWE+rJmLWeeo3z7QbSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SOc+3oZJxi5+oV7pDlb0ICB1rJoeL78GEWRKuTe9s53P3+QG7YWoBakR2Scceb2lB
	 fuLBYmUwfjFWnowcNh6KyQyBYiZYBxfBUINHjun/XFh1WGSMGZGX7iXBQSF7uzYQRb
	 G0OQd1pHkaMpRymzK9HguWLpFMUw83rMyazK3FSXMTteCpME3mSX+fDkFOwSwsx/K6
	 bhMBJ1LZUs8Z9apdypI9FEhpVbn20enIMdM8GKjACT28ij531JoffOXzURnpg4ax3h
	 9jU0V47/vERYIPwiZtlohSORJ2KgRTjJlrxsLqIIXcrsfr/LBDqMX3u2aUeKAZhe37
	 koRc+ERBwTX7w==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 25/67] xfs: consolidate the xfs_attr_defer_* helpers
Date: Mon, 22 Apr 2024 18:25:47 +0200
Message-ID: <20240422163832.858420-27-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: c00eebd09e95757c9c1d08f0a6bbc32c543daf90

Consolidate the xfs_attr_defer_* helpers into a single xfs_attr_defer_add
one that picks the right dela_state based on the passed in operation.
Also move to a single trace point as the actual operation is visible
through the flags in the delta_state passed to the trace point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_attr.c | 90 +++++++++++------------------------------------
 1 file changed, 21 insertions(+), 69 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2103a06b9..550ca6b2e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -878,11 +878,10 @@ xfs_attr_lookup(
 	return error;
 }
 
-static int
-xfs_attr_intent_init(
+static void
+xfs_attr_defer_add(
 	struct xfs_da_args	*args,
-	unsigned int		op_flags,	/* op flag (set or remove) */
-	struct xfs_attr_intent	**attr)		/* new xfs_attr_intent */
+	unsigned int		op_flags)
 {
 
 	struct xfs_attr_intent	*new;
@@ -891,66 +890,22 @@ xfs_attr_intent_init(
 	new->xattri_op_flags = op_flags;
 	new->xattri_da_args = args;
 
-	*attr = new;
-	return 0;
-}
-
-/* Sets an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_add(
-	struct xfs_da_args	*args)
-{
-	struct xfs_attr_intent	*new;
-	int			error = 0;
-
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_SET, &new);
-	if (error)
-		return error;
+	switch (op_flags) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+		new->xattri_dela_state = xfs_attr_init_add_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		new->xattri_dela_state = xfs_attr_init_replace_state(args);
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		new->xattri_dela_state = xfs_attr_init_remove_state(args);
+		break;
+	default:
+		ASSERT(0);
+	}
 
-	new->xattri_dela_state = xfs_attr_init_add_state(args);
 	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
-
-	return 0;
-}
-
-/* Sets an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_replace(
-	struct xfs_da_args	*args)
-{
-	struct xfs_attr_intent	*new;
-	int			error = 0;
-
-	error = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REPLACE, &new);
-	if (error)
-		return error;
-
-	new->xattri_dela_state = xfs_attr_init_replace_state(args);
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-	trace_xfs_attr_defer_replace(new->xattri_dela_state, args->dp);
-
-	return 0;
-}
-
-/* Removes an attribute for an inode as a deferred operation */
-static int
-xfs_attr_defer_remove(
-	struct xfs_da_args	*args)
-{
-
-	struct xfs_attr_intent	*new;
-	int			error;
-
-	error  = xfs_attr_intent_init(args, XFS_ATTRI_OP_FLAGS_REMOVE, &new);
-	if (error)
-		return error;
-
-	new->xattri_dela_state = xfs_attr_init_remove_state(args);
-	xfs_defer_add(args->trans, XFS_DEFER_OPS_TYPE_ATTR, &new->xattri_list);
-	trace_xfs_attr_defer_remove(new->xattri_dela_state, args->dp);
-
-	return 0;
 }
 
 /*
@@ -1036,16 +991,16 @@ xfs_attr_set(
 	error = xfs_attr_lookup(args);
 	switch (error) {
 	case -EEXIST:
-		/* if no value, we are performing a remove operation */
 		if (!args->value) {
-			error = xfs_attr_defer_remove(args);
+			/* if no value, we are performing a remove operation */
+			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
 			break;
 		}
+
 		/* Pure create fails if the attr already exists */
 		if (args->attr_flags & XATTR_CREATE)
 			goto out_trans_cancel;
-
-		error = xfs_attr_defer_replace(args);
+		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REPLACE);
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
@@ -1055,14 +1010,11 @@ xfs_attr_set(
 		/* Pure replace fails if no existing attr to replace. */
 		if (args->attr_flags & XATTR_REPLACE)
 			goto out_trans_cancel;
-
-		error = xfs_attr_defer_add(args);
+		xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_SET);
 		break;
 	default:
 		goto out_trans_cancel;
 	}
-	if (error)
-		goto out_trans_cancel;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
-- 
2.44.0

