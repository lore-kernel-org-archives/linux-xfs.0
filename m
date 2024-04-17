Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5D88F4A
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713389298; cv=none; b=aq7JRJQmYU4OUYL9JFF52jZEoQd1twU9B/3nODskCaf/RqXbqxSYaV+W35RDR/sIWXi3o30caVN3384dkNbN+/g3xXpwNNf/YoT51iGBvKrHAh6Sl/OhP4W+Vn4OamL9We+EpaQGeODtT35Haw/vFog7brndivibEZ8lpiFCOXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713389298; c=relaxed/simple;
	bh=0lrieo1Ff/Wa6R3mi3mGucWpolWBN2G5AwrUCjidzJo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ccvc8lVUjGy7Whw/5lHVbEy67CAhuTfa9Pcq8ftIIm73P7bGrvwTi466dS77n87QulWSUYeiZejuL6qJ4iosBOtCfpAu0HbN7Rv9nL7iRoj+sWg5p8rBMEPyvm2EuDysJlJ3AxLPGiiLxIOPdk4LHSVVbHHo5ZYImbCcZo43rLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIxIONgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIxIONgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C21C072AA;
	Wed, 17 Apr 2024 21:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713389298;
	bh=0lrieo1Ff/Wa6R3mi3mGucWpolWBN2G5AwrUCjidzJo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nIxIONgV2yK02Fa9Yg6MEju4UfbRzEazt4MLBGZuoMZ2Op2R+YPLq6mbo3q3CEf3k
	 pgRbftAqmGQpDOio39jTmGokYO3Ms1JcvILKt2guGAaZbEjJ1uxTGN332JYqdW3e5x
	 /wVqu4v2rFq5kX9yH+fv5+0nsCv7J4pQsVtc659PzfCqp+r3i4K2g1jfBv6IUgq/yJ
	 wq7fRhCSbEluLf1oOcZYVe5px3tGMn9WT4ZKgvwKMi+j/AbtInRbxodnijkcgZ5/b5
	 IWulS4rrf5HGuP/IZQttF43TYESjp7+wJTL2cPQPXPhgegh8iDuwm9qb//6uRRA2ar
	 247TI35uNP6zQ==
Date: Wed, 17 Apr 2024 14:28:17 -0700
Subject: [PATCH 25/67] xfs: consolidate the xfs_attr_defer_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171338842715.1853449.8565825912269380630.stgit@frogsfrogsfrogs>
In-Reply-To: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
References: <171338842269.1853449.4066376212453408283.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: c00eebd09e95757c9c1d08f0a6bbc32c543daf90

Consolidate the xfs_attr_defer_* helpers into a single xfs_attr_defer_add
one that picks the right dela_state based on the passed in operation.
Also move to a single trace point as the actual operation is visible
through the flags in the delta_state passed to the trace point.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_attr.c |   90 ++++++++++++-----------------------------------------
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
-
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

