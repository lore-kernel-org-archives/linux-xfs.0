Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CFE5223
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230528; cv=none; b=lBy40Vu01B8ji3wVsAj8M2AAvU8bKX+ksXipTgCpokFnN1z/NiGM/geAasleEnIN/QmSeNRVXa/+qg4k+gaArpbCoaoxqrIY/ZkobM6WrOC79STTsRiFn92KnnZ+gC/mIfBZnrl/Tr6gj47lwj+FmAEFvxERsbGfqmYppb37omk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230528; c=relaxed/simple;
	bh=munX0xASTp/q7rMmkb/k2iZ4pIhxAThPMLlJuptm6Wk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fwlxPG1LdrszRH7OS5tAHG8M8kYEW4R5nzmuW5eg+d9UyFy3SSoiAUrb0Bfv+SPvUqsf0ewyTlaGtaJrDdCxfBU8c/QHjR2u0Xx+XMP049RYBELnPcMJHqi6zBDDey1bCzsUNUeJZVvyKstJpeaakArN85aCQfy7ZmuTQjliJw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZEX4XcJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZEX4XcJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FFEC113CC;
	Tue, 16 Apr 2024 01:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230528;
	bh=munX0xASTp/q7rMmkb/k2iZ4pIhxAThPMLlJuptm6Wk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZEX4XcJu/FEFv/h87nlG//KgyZEMfN5CmA7bWwKtnzofw3T/L55d50poBIRFL2PYq
	 37I85vik+n69UjVho5HzxBZQqnn2xDuhDxDlaCpDKIaegfJUb+UN8TjVbjrIu2woW7
	 jOB6WxP9MbcEx9++rk5oLjKwOVe68GhO9w9fy57dShoEiLMycUwontDSJTs/pGsLU9
	 O9AZhgdt8KP4nk74JRm4vBmdm+v4XWeVyPunwM5/olEhZLLyMiufpg+0kU2sZPkw4u
	 CehbfRosnDgDultYjdP+ApNaDIkfwrLFWkPyeQflquQRrL/y8uhLNyNqPDV1cScjpX
	 aW7HxIuWgjVXw==
Date: Mon, 15 Apr 2024 18:22:07 -0700
Subject: [PATCH 4/5] xfs: make attr removal an explicit operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Message-ID: <171323026654.250975.17998254398908556664.stgit@frogsfrogsfrogs>
In-Reply-To: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
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

Parent pointers match attrs on name+value, unlike everything else which
matches on only the name.  Therefore, we cannot keep using the heuristic
that !value means remove.  Make this an explicit operation code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   19 ++++++++++---------
 fs/xfs/libxfs/xfs_attr.h |    1 +
 fs/xfs/xfs_acl.c         |    3 ++-
 fs/xfs/xfs_ioctl.c       |    7 +++++--
 fs/xfs/xfs_xattr.c       |    7 +++++--
 5 files changed, 23 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b04e09143869d..f8f7445b063c0 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -916,10 +916,6 @@ xfs_attr_defer_add(
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
-/*
- * Note: If args->value is NULL the attribute will be removed, just like the
- * Linux ->setattr API.
- */
 int
 xfs_attr_set(
 	struct xfs_da_args	*args,
@@ -955,7 +951,10 @@ xfs_attr_set(
 	args->op_flags = XFS_DA_OP_OKNOENT |
 					(args->op_flags & XFS_DA_OP_LOGGED);
 
-	if (args->value) {
+	switch (op) {
+	case XFS_ATTRUPDATE_UPSERT:
+	case XFS_ATTRUPDATE_CREATE:
+	case XFS_ATTRUPDATE_REPLACE:
 		XFS_STATS_INC(mp, xs_attr_set);
 		args->total = xfs_attr_calc_size(args, &local);
 
@@ -975,9 +974,11 @@ xfs_attr_set(
 
 		if (!local)
 			rmt_blks = xfs_attr3_rmt_blocks(mp, args->valuelen);
-	} else {
+		break;
+	case XFS_ATTRUPDATE_REMOVE:
 		XFS_STATS_INC(mp, xs_attr_remove);
 		rmt_blks = xfs_attr3_rmt_blocks(mp, XFS_XATTR_SIZE_MAX);
+		break;
 	}
 
 	/*
@@ -989,7 +990,7 @@ xfs_attr_set(
 	if (error)
 		return error;
 
-	if (args->value || xfs_inode_hasattr(dp)) {
+	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
 		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error == -EFBIG)
@@ -1002,7 +1003,7 @@ xfs_attr_set(
 	error = xfs_attr_lookup(args);
 	switch (error) {
 	case -EEXIST:
-		if (!args->value) {
+		if (op == XFS_ATTRUPDATE_REMOVE) {
 			/* if no value, we are performing a remove operation */
 			xfs_attr_defer_add(args, XFS_ATTRI_OP_FLAGS_REMOVE);
 			break;
@@ -1015,7 +1016,7 @@ xfs_attr_set(
 		break;
 	case -ENOATTR:
 		/* Can't remove what isn't there. */
-		if (!args->value)
+		if (op == XFS_ATTRUPDATE_REMOVE)
 			goto out_trans_cancel;
 
 		/* Pure replace fails if no existing attr to replace. */
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 02dca538f6b91..c8005f52102ad 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,6 +546,7 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 
 enum xfs_attr_update {
+	XFS_ATTRUPDATE_REMOVE,	/* remove attr */
 	XFS_ATTRUPDATE_UPSERT,	/* set value, replace any existing attr */
 	XFS_ATTRUPDATE_CREATE,	/* set value, fail if attr already exists */
 	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index ea3ae0acff096..48e93b14b4ab8 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -203,7 +203,8 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		xfs_acl_to_disk(args.value, acl);
 	}
 
-	error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT);
+	error = xfs_attr_change(&args, args.value ? XFS_ATTRUPDATE_UPSERT :
+						    XFS_ATTRUPDATE_REMOVE);
 	kvfree(args.value);
 
 	/*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9cf3f8d16c055..66133b4fc20f7 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -363,8 +363,11 @@ xfs_attr_filter(
 
 static inline enum xfs_attr_update
 xfs_xattr_flags(
-	u32			ioc_flags)
+	u32			ioc_flags,
+	void			*value)
 {
+	if (!value)
+		return XFS_ATTRUPDATE_REMOVE;
 	if (ioc_flags & XFS_IOC_ATTR_CREATE)
 		return XFS_ATTRUPDATE_CREATE;
 	if (ioc_flags & XFS_IOC_ATTR_REPLACE)
@@ -526,7 +529,7 @@ xfs_attrmulti_attr_set(
 		args.valuelen = len;
 	}
 
-	error = xfs_attr_change(&args, xfs_xattr_flags(flags));
+	error = xfs_attr_change(&args, xfs_xattr_flags(flags, args.value));
 	if (!error && (flags & XFS_IOC_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	kfree(args.value);
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c2d17def7d9d1..0cbb93cf2869c 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -118,8 +118,11 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 
 static inline enum xfs_attr_update
 xfs_xattr_flags_to_op(
-	int		flags)
+	int		flags,
+	const void	*value)
 {
+	if (!value)
+		return XFS_ATTRUPDATE_REMOVE;
 	if (flags & XATTR_CREATE)
 		return XFS_ATTRUPDATE_CREATE;
 	if (flags & XATTR_REPLACE)
@@ -143,7 +146,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	};
 	int			error;
 
-	error = xfs_attr_change(&args, xfs_xattr_flags_to_op(flags));
+	error = xfs_attr_change(&args, xfs_xattr_flags_to_op(flags, value));
 	if (!error && (handler->flags & XFS_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	return error;

