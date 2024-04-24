Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7D3BE4D
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928121; cv=none; b=cNLkYo2MYgvtCtZwp5vQ5Xrp2vmrEHh53yVJZZpNMhPHKlTwfUDnqojgKUrYOEdPqZTCZ0Ij7rONbaHp2lFQUnrHs1Gcsw4/fvthpen1nvBn3XpYiYrku04lo0WWB6vO3VRiMI82LhJK04ceTH/7omWq85DZcFCzsUWyzF7nXEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928121; c=relaxed/simple;
	bh=NOFjchLaV2+MzM4mSXFX6J8+NU3hjlhnT3cCZpT4mhU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SaoV+ClHASP1EyR6bMM0jAN/pScDmo3uCU4FzvvLPVrkmaVR5bbFR43mAEhASoiHREEOzYy5OrDB7WJ0bFvy7trLmtMLmz+ofLZmYLkVa76lZLWnFMY53v0Mgjgs2k4LDB2UBn/nVYlrN+/Rt/qD+mz1Qa6GEodiJuatKRKeOu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IviZis7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IviZis7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB00C116B1;
	Wed, 24 Apr 2024 03:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928120;
	bh=NOFjchLaV2+MzM4mSXFX6J8+NU3hjlhnT3cCZpT4mhU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IviZis7JOpdxPPnT7955s1JNFRBRS7qYNNfaNQ0+0tmTB32yW2MMJRcbzK9GLzBZa
	 2ntLOkW0LXmaBPMIAvqwcXdKff6ou/Xs4Z38kWscM/9w4dn4Iwp18pfaXOqLrzqkLV
	 JPmpfVQeiJbzethiBkPxt4tcpAPRyNIx2UZhf6d2rY2I+eFE5qLFjdh2eeHSarmeoe
	 B+4pcMPhdV3tq+9KM4uidYMBvMpLFfb4sE76Me+RH8mBLkoC4EhiyV5oAXtpho+5Xo
	 kZj3uoSqB0VL6ZoZigv+DAXPS1wiQwezoFynKJyWoebmA8QwlV6wbnvgFuATIDD2jk
	 mJWTg2It7ReQA==
Date: Tue, 23 Apr 2024 20:08:40 -0700
Subject: [PATCH 4/5] xfs: make attr removal an explicit operation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782179.1904378.4791784673579839020.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
References: <171392782098.1904378.6539247354693938689.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |   19 ++++++++++---------
 fs/xfs/libxfs/xfs_attr.h |    3 ++-
 fs/xfs/xfs_acl.c         |   17 +++++++++--------
 fs/xfs/xfs_ioctl.c       |    9 ++++++---
 fs/xfs/xfs_iops.c        |    2 +-
 fs/xfs/xfs_xattr.c       |    9 ++++++---
 6 files changed, 34 insertions(+), 25 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index b04e09143869..f8f7445b063c 100644
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
index 228360f7c85c..c8005f52102a 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -546,7 +546,8 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 
 enum xfs_attr_update {
-	XFS_ATTRUPDATE_UPSERTR,	/* set/remove value, replace any existing attr */
+	XFS_ATTRUPDATE_REMOVE,	/* remove attr */
+	XFS_ATTRUPDATE_UPSERT,	/* set value, replace any existing attr */
 	XFS_ATTRUPDATE_CREATE,	/* set value, fail if attr already exists */
 	XFS_ATTRUPDATE_REPLACE,	/* set value, fail if attr does not exist */
 };
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 12f98af9e709..c7c3dcfa2718 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -201,16 +201,17 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 		if (!args.value)
 			return -ENOMEM;
 		xfs_acl_to_disk(args.value, acl);
+		error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT);
+		kvfree(args.value);
+	} else {
+		error = xfs_attr_change(&args, XFS_ATTRUPDATE_REMOVE);
+		/*
+		 * If the attribute didn't exist to start with that's fine.
+		 */
+		if (error == -ENOATTR)
+			error = 0;
 	}
 
-	error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERTR);
-	kvfree(args.value);
-
-	/*
-	 * If the attribute didn't exist to start with that's fine.
-	 */
-	if (!acl && error == -ENOATTR)
-		error = 0;
 	if (!error)
 		set_cached_acl(inode, type, acl);
 	return error;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0eca7a9096e2..e30f9f40f086 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -363,13 +363,16 @@ xfs_attr_filter(
 
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
 		return XFS_ATTRUPDATE_REPLACE;
-	return XFS_ATTRUPDATE_UPSERTR;
+	return XFS_ATTRUPDATE_UPSERT;
 }
 
 int
@@ -526,7 +529,7 @@ xfs_attrmulti_attr_set(
 		args.valuelen = len;
 	}
 
-	error = xfs_attr_change(&args, xfs_xattr_flags(flags));
+	error = xfs_attr_change(&args, xfs_xattr_flags(flags, args.value));
 	if (!error && (flags & XFS_IOC_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	kfree(args.value);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index d02ca2248bbc..659fd10c0cda 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -63,7 +63,7 @@ xfs_initxattrs(
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
 		};
-		error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERTR);
+		error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT);
 		if (error < 0)
 			break;
 	}
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 6ce1e06f650a..0cbb93cf2869 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -118,13 +118,16 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 
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
 		return XFS_ATTRUPDATE_REPLACE;
-	return XFS_ATTRUPDATE_UPSERTR;
+	return XFS_ATTRUPDATE_UPSERT;
 }
 
 static int
@@ -143,7 +146,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 	};
 	int			error;
 
-	error = xfs_attr_change(&args, xfs_xattr_flags_to_op(flags));
+	error = xfs_attr_change(&args, xfs_xattr_flags_to_op(flags, value));
 	if (!error && (handler->flags & XFS_ATTR_ROOT))
 		xfs_forget_acl(inode, name);
 	return error;

