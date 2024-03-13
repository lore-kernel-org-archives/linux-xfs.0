Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAAE10953
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 01:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710295174; cv=none; b=E4XFE4wTInszpcyZSnn620X+ry66uj54Eh6SUyaQnWJGAsQG+/x8EoOLTsmgqBWTNC7NQnbpMdZu/IDfrPzs9ylDlrjMqfT/4wJ6FbGm1b/jOdLiJUE22I/Q2/7Msa4kqmRn8WkBbrts7PzgmU90z6HoqkrQPKgruUm11ROrxfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710295174; c=relaxed/simple;
	bh=VDlqfW1hV+NsqRAHr52Br4C7GdYfELg+YrOtFNI8orA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OZDkBR2mUsmKEy3yyU6AjxdriJ/EyGGLpVOdx5pSPNcHS2LTGi6z0JEeiSVUyS3uyJgbqeGU68bjOhO/JCzMMGnWWymNoi3F7WECb/mS6p0c61M2/oqz/AAWQsSsD0Ddz1CepAiaTS3B1TVjbjEsvh9z6Fgf9g49VpPUxzR/1IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jsTX60y7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jsTX60y7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7F5C433C7;
	Wed, 13 Mar 2024 01:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710295173;
	bh=VDlqfW1hV+NsqRAHr52Br4C7GdYfELg+YrOtFNI8orA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jsTX60y7aCF+0xbX48laOKUJbXtUkfU6XhVzDFYYtKr0hqQImFkwHIHcZfkTjv7uA
	 ahin6av36/4fR4yLgZguZvX65Q4NMBtUJs2wWaPBA0ihZ19569gu9JK/26gx6sxJ6N
	 9u5XjGhyLCsJtFNhqARAjaC6G4WS1Krq4E9ZexuJT4TCV2V6zzIHJz5aKJ+1eTbwJj
	 DL1pOIuv9T6x9udCKxIhzieKYTHIuWAkbsF/5sRWJaW0vY8RFMwB1HTbf0tkzziGJE
	 TtZSYwR4EXdHFg4t++vZFgNHX7RGwxfnnk3w6lXqRQLSsnxP8M8yHQ8sJvRocxxyb+
	 hQ0s9X0TMRkIA==
Date: Tue, 12 Mar 2024 18:59:33 -0700
Subject: [PATCH 25/67] xfs: consolidate the xfs_attr_defer_* helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <171029431554.2061787.13501993001816911277.stgit@frogsfrogsfrogs>
In-Reply-To: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
References: <171029431107.2061787.680090905906055791.stgit@frogsfrogsfrogs>
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
---
 libxfs/xfs_attr.c |   90 ++++++++++++-----------------------------------------
 1 file changed, 21 insertions(+), 69 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2103a06b9ee3..550ca6b2e263 100644
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

