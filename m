Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225CB3D76
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713230560; cv=none; b=TFH/FNOC7lw/BYMKWju2jTKRAosuJ0l0X+Fg5K9zI+1tuqEfWmp1nI7SFchcrXjJ62QdtQy2yOrtQkHVBq19Wx9yG0QA5pO45RDzGFK/1rG+Vmbx/aHZU0vnoNTAHAKERZU5Finwzf2hbvZAbFBVWtum5YBuPOplKK5QxZIfoI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713230560; c=relaxed/simple;
	bh=0DrMG9PMepBPhTGBNnXgg2scsx7aGvWfmq7Jt/Fah+M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5LJ2cIVN5LdocxEAivdNQ5uT8YDkSUwJA1AptScRveyQU8MildsX4MFn1+XYy9y3Qp7FAm7qmoL/IcS9wgjetws1dvkGFkNiHeXBz5aj4Bc3Irh9FdE4zMVOGHwtqPOks5xE4DLSpwe1cCpTXEVyXm+xSq/yxizJLneJh/Gzig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vRg+keSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vRg+keSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3EDC113CC;
	Tue, 16 Apr 2024 01:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713230559;
	bh=0DrMG9PMepBPhTGBNnXgg2scsx7aGvWfmq7Jt/Fah+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=vRg+keSqWDtTQ6pygjK8ozxYot+6+uw/87pCQpsWjsNEN9E/FbLKx4nTRONQGq73d
	 UBtXi1GELB5P0qGCrQlMjyFMbSj440nJ2iNqZdxbIBhwjieLJZh2nkOXFmDgZB2Rou
	 tqpbq3dTUET/2G6VdbsUlWr2RwUS1wxtCl6ZZmEnIx+wb5dt/UdrhJQmFSHWDSdWLa
	 gA0jDNAIjkHRQycyYchLj3INN0ZFu93mrtkLtgownZbztZ1GP7S/7duaj0+5z30+PE
	 NuLtG1uOened3nOkNHXV7o8aPjcJXQWC+W4e6+G6t8fMA61qQV5W9sfz7HoQCNICkC
	 oGOOvt7LMkEEA==
Date: Mon, 15 Apr 2024 18:22:39 -0700
Subject: [PATCH 01/14] xfs: attr fork iext must be loaded before calling
 xfs_attr_is_leaf
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org, hch@lst.de, hch@infradead.org
Message-ID: <171323027090.251201.7655662132113894127.stgit@frogsfrogsfrogs>
In-Reply-To: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
References: <171323027037.251201.2636888245172247449.stgit@frogsfrogsfrogs>
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

Christoph noticed that the xfs_attr_is_leaf in xfs_attr_get_ilocked can
access the incore extent tree of the attr fork, but nothing in the
xfs_attr_get path guarantees that the incore tree is actually loaded.

Most of the time it is, but seeing as xfs_attr_is_leaf ignores the
return value of xfs_iext_get_extent I guess we've been making choices
based on random stack contents and nobody's complained?

Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c |   17 +++++++++++++++++
 fs/xfs/xfs_attr_item.c   |   42 ++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_attr_list.c   |    7 +++++++
 3 files changed, 60 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index f8f7445b063c0..54edc690ac1e1 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -87,6 +87,8 @@ xfs_attr_is_leaf(
 	struct xfs_iext_cursor	icur;
 	struct xfs_bmbt_irec	imap;
 
+	ASSERT(!xfs_need_iread_extents(ifp));
+
 	if (ifp->if_nextents != 1 || ifp->if_format != XFS_DINODE_FMT_EXTENTS)
 		return false;
 
@@ -224,11 +226,21 @@ int
 xfs_attr_get_ilocked(
 	struct xfs_da_args	*args)
 {
+	int			error;
+
 	xfs_assert_ilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
 	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
 
+	/*
+	 * The incore attr fork iext tree must be loaded for xfs_attr_is_leaf
+	 * to work correctly.
+	 */
+	error = xfs_iread_extents(args->trans, args->dp, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
 	if (args->dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
 	if (xfs_attr_is_leaf(args->dp))
@@ -870,6 +882,11 @@ xfs_attr_lookup(
 		return -ENOATTR;
 	}
 
+	/* Prerequisite for xfs_attr_is_leaf */
+	error = xfs_iread_extents(args->trans, args->dp, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_hasname(args, &bp);
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index d460347056945..541455731618b 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -498,6 +498,25 @@ xfs_attri_validate(
 	return xfs_verify_ino(mp, attrp->alfi_ino);
 }
 
+static int
+xfs_attri_iread_extents(
+	struct xfs_inode		*ip)
+{
+	struct xfs_trans		*tp;
+	int				error;
+
+	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_iread_extents(tp, ip, XFS_ATTR_FORK);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_cancel(tp);
+
+	return error;
+}
+
 static inline struct xfs_attr_intent *
 xfs_attri_recover_work(
 	struct xfs_mount		*mp,
@@ -508,13 +527,22 @@ xfs_attri_recover_work(
 {
 	struct xfs_attr_intent		*attr;
 	struct xfs_da_args		*args;
+	struct xfs_inode		*ip;
 	int				local;
 	int				error;
 
-	error = xlog_recover_iget(mp,  attrp->alfi_ino, ipp);
+	error = xlog_recover_iget(mp,  attrp->alfi_ino, &ip);
 	if (error)
 		return ERR_PTR(error);
 
+	if (xfs_inode_has_attr_fork(ip)) {
+		error = xfs_attri_iread_extents(ip);
+		if (error) {
+			xfs_irele(ip);
+			return ERR_PTR(error);
+		}
+	}
+
 	attr = kzalloc(sizeof(struct xfs_attr_intent) +
 			sizeof(struct xfs_da_args), GFP_KERNEL | __GFP_NOFAIL);
 	args = (struct xfs_da_args *)(attr + 1);
@@ -531,7 +559,7 @@ xfs_attri_recover_work(
 	attr->xattri_nameval = xfs_attri_log_nameval_get(nv);
 	ASSERT(attr->xattri_nameval);
 
-	args->dp = *ipp;
+	args->dp = ip;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->name = nv->name.i_addr;
@@ -561,6 +589,7 @@ xfs_attri_recover_work(
 	}
 
 	xfs_defer_add_item(dfp, &attr->xattri_list);
+	*ipp = ip;
 	return attr;
 }
 
@@ -615,16 +644,17 @@ xfs_attr_recover_work(
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				&attrip->attri_format,
 				sizeof(attrip->attri_format));
-	if (error) {
-		xfs_trans_cancel(tp);
-		goto out_unlock;
-	}
+	if (error)
+		goto out_cancel;
 
 	error = xfs_defer_ops_capture_and_commit(tp, capture_list);
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	xfs_irele(ip);
 	return error;
+out_cancel:
+	xfs_trans_cancel(tp);
+	goto out_unlock;
 }
 
 /* Re-log an intent item to push the log tail forward. */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 6a621f016f040..97c8f3dcfb89d 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -544,6 +544,7 @@ xfs_attr_list_ilocked(
 	struct xfs_attr_list_context	*context)
 {
 	struct xfs_inode		*dp = context->dp;
+	int				error;
 
 	xfs_assert_ilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
 
@@ -554,6 +555,12 @@ xfs_attr_list_ilocked(
 		return 0;
 	if (dp->i_af.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_list(context);
+
+	/* Prerequisite for xfs_attr_is_leaf */
+	error = xfs_iread_extents(NULL, dp, XFS_ATTR_FORK);
+	if (error)
+		return error;
+
 	if (xfs_attr_is_leaf(dp))
 		return xfs_attr_leaf_list(context);
 	return xfs_attr_node_list(context);

