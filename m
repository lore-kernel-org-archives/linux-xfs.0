Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E23A1C6BE
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713928355; cv=none; b=Of28Q3ZGxKR4gVTt0md8f+WVTKIJvMTxz5ucey4dk37Ay7dPpjkL4aFakT0+Hfdsje3huyG4or5X1IcTFWxnH9Lw3GzbTruMFFEz4lG6PrQ5T1xkfW/FkdBGDsyKs6qy7Re/ZeJrT4NnhcYUEKqtPoBZQthgipQopSRgvXeAlfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713928355; c=relaxed/simple;
	bh=5V1VZXeTuSqW0j2hjGrTW2Hxd75t8sO9pNh8CT+mSgM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIageIDV5nkmzvGFG590KZBQlAt/3CAOfTuHzGgHW1Vdv487SJqcSsXzoHt3DzGLTSWdOeKYxevfA0zWsqxXlTJsZ7IerwBHsFxF7XTIB/A60Ux/31AQxD8SMfW8YQY8tJFg2zpW0VxUrJ8D4f2xJNPTdiK9+R/fkywZWovisj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FD1qIMt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FD1qIMt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A17C116B1;
	Wed, 24 Apr 2024 03:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713928355;
	bh=5V1VZXeTuSqW0j2hjGrTW2Hxd75t8sO9pNh8CT+mSgM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FD1qIMt01nptiBB5oyLbar/Lso1fSJeufJ2advKV2K2vDicBWQr4hlPbLFMQmMWgB
	 f625d5WT7/eEHJRdvNth1Y2mWXkApPE7azbfMCDb7hClk8vPCq0WANJDJn4RtQqfpO
	 u/mUCUY6Fnwnhog3FngaXj4IlTMcc4xu74Ufo/SuUbsI08GLasenNjpgs7rzo+V8yu
	 InZZHECpnn+jdje+nrBjXoBYeErGDtX1SRCtjrQxcTyluI/lG7MT9BRObHiFR4/dDa
	 MEG1DXiYh8hIVTGb6VrRkVEEGxW3QTZ50/Lhax6naIAFCLlgnam/+TXY6E5YmHrdpr
	 uQa8pgDP9uSXA==
Date: Tue, 23 Apr 2024 20:12:34 -0700
Subject: [PATCH 14/14] xfs: enforce one namespace per attribute
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392782809.1904599.10577513322206096359.stgit@frogsfrogsfrogs>
In-Reply-To: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
References: <171392782539.1904599.4346314665349138617.stgit@frogsfrogsfrogs>
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

Create a standardized helper function to enforce one namespace bit per
extended attribute, and refactor all the open-coded hweight logic.  This
function is not a static inline to avoid porting hassles in userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      |   11 +++++++++++
 fs/xfs/libxfs/xfs_attr.h      |    4 +++-
 fs/xfs/libxfs/xfs_attr_leaf.c |    7 ++++++-
 fs/xfs/scrub/attr.c           |   12 +++++-------
 fs/xfs/scrub/attr_repair.c    |    4 +---
 fs/xfs/xfs_attr_item.c        |   10 ++++++++--
 fs/xfs/xfs_attr_list.c        |   11 +++++++----
 7 files changed, 41 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ba59dab6c56d..629fb25d149c 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1532,12 +1532,23 @@ xfs_attr_node_get(
 	return error;
 }
 
+/* Enforce that there is at most one namespace bit per attr. */
+inline bool xfs_attr_check_namespace(unsigned int attr_flags)
+{
+	return hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) < 2;
+}
+
 /* Returns true if the attribute entry name is valid. */
 bool
 xfs_attr_namecheck(
+	unsigned int	attr_flags,
 	const void	*name,
 	size_t		length)
 {
+	/* Only one namespace bit allowed. */
+	if (!xfs_attr_check_namespace(attr_flags))
+		return false;
+
 	/*
 	 * MAXNAMELEN includes the trailing null, but (name/length) leave it
 	 * out, so use >= for the length check.
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 79b457adb7bd..cd106b0a424f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -560,7 +560,9 @@ enum xfs_attr_update {
 int xfs_attr_set(struct xfs_da_args *args, enum xfs_attr_update op);
 int xfs_attr_set_iter(struct xfs_attr_intent *attr);
 int xfs_attr_remove_iter(struct xfs_attr_intent *attr);
-bool xfs_attr_namecheck(const void *name, size_t length);
+bool xfs_attr_check_namespace(unsigned int attr_flags);
+bool xfs_attr_namecheck(unsigned int attr_flags, const void *name,
+		size_t length);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 void xfs_init_attr_trans(struct xfs_da_args *args, struct xfs_trans_res *tres,
 			 unsigned int *total);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 17ec5ff5a4e3..3b024ab892e6 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -950,6 +950,11 @@ xfs_attr_shortform_to_leaf(
 		nargs.hashval = xfs_da_hashname(sfe->nameval,
 						sfe->namelen);
 		nargs.attr_filter = sfe->flags & XFS_ATTR_NSP_ONDISK_MASK;
+		if (!xfs_attr_check_namespace(sfe->flags)) {
+			xfs_da_mark_sick(args);
+			error = -EFSCORRUPTED;
+			goto out;
+		}
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
@@ -1063,7 +1068,7 @@ xfs_attr_shortform_verify(
 		 * one namespace flag per xattr, so we can just count the
 		 * bits (i.e. hweight) here.
 		 */
-		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		if (!xfs_attr_check_namespace(sfep->flags))
 			return __this_address;
 
 		sfep = next_sfep;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index fd22d652a63a..7789bd2f0950 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -203,14 +203,8 @@ xchk_xattr_actor(
 		return 0;
 	}
 
-	/* Only one namespace bit allowed. */
-	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1) {
-		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
-		return -ECANCELED;
-	}
-
 	/* Does this name make sense? */
-	if (!xfs_attr_namecheck(name, namelen)) {
+	if (!xfs_attr_namecheck(attr_flags, name, namelen)) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, args.blkno);
 		return -ECANCELED;
 	}
@@ -519,6 +513,10 @@ xchk_xattr_rec(
 		xchk_da_set_corrupt(ds, level);
 		return 0;
 	}
+	if (!xfs_attr_check_namespace(ent->flags)) {
+		xchk_da_set_corrupt(ds, level);
+		return 0;
+	}
 
 	if (ent->flags & XFS_ATTR_LOCAL) {
 		lentry = (struct xfs_attr_leaf_name_local *)
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 3066d662ea13..8b89c112c492 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -123,12 +123,10 @@ xrep_xattr_want_salvage(
 		return false;
 	if (namelen > XATTR_NAME_MAX || namelen <= 0)
 		return false;
-	if (!xfs_attr_namecheck(name, namelen))
+	if (!xfs_attr_namecheck(attr_flags, name, namelen))
 		return false;
 	if (valuelen > XATTR_SIZE_MAX || valuelen < 0)
 		return false;
-	if (hweight32(attr_flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
-		return false;
 	return true;
 }
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 39536303a7b6..a65ac7479768 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -492,6 +492,10 @@ xfs_attri_validate(
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
 		return false;
 
+	if (!xfs_attr_check_namespace(attrp->alfi_attr_filter &
+				      XFS_ATTR_NSP_ONDISK_MASK))
+		return false;
+
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -633,7 +637,8 @@ xfs_attr_recover_work(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.i_addr,
+				nv->name.i_len))
 		return -EFSCORRUPTED;
 
 	attr = xfs_attri_recover_work(mp, dfp, attrp, &ip, nv);
@@ -747,7 +752,8 @@ xfs_attri_validate_name_iovec(
 		return NULL;
 	}
 
-	if (!xfs_attr_namecheck(iovec->i_addr, name_len)) {
+	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, iovec->i_addr,
+				name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, sizeof(*attri_formatp));
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 97c8f3dcfb89..903ed46c6887 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -82,7 +82,8 @@ xfs_attr_shortform_list(
 	     (dp->i_af.if_bytes + sf->count * 16) < context->bufsize)) {
 		for (i = 0, sfe = xfs_attr_sf_firstentry(sf); i < sf->count; i++) {
 			if (XFS_IS_CORRUPT(context->dp->i_mount,
-					   !xfs_attr_namecheck(sfe->nameval,
+					   !xfs_attr_namecheck(sfe->flags,
+							       sfe->nameval,
 							       sfe->namelen))) {
 				xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 				return -EFSCORRUPTED;
@@ -122,7 +123,8 @@ xfs_attr_shortform_list(
 	for (i = 0, sfe = xfs_attr_sf_firstentry(sf); i < sf->count; i++) {
 		if (unlikely(
 		    ((char *)sfe < (char *)sf) ||
-		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)))) {
+		    ((char *)sfe >= ((char *)sf + dp->i_af.if_bytes)) ||
+		    !xfs_attr_check_namespace(sfe->flags))) {
 			XFS_CORRUPTION_ERROR("xfs_attr_shortform_list",
 					     XFS_ERRLEVEL_LOW,
 					     context->dp->i_mount, sfe,
@@ -177,7 +179,7 @@ xfs_attr_shortform_list(
 			cursor->offset = 0;
 		}
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(sbp->name,
+				   !xfs_attr_namecheck(sbp->flags, sbp->name,
 						       sbp->namelen))) {
 			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			error = -EFSCORRUPTED;
@@ -502,7 +504,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if (XFS_IS_CORRUPT(context->dp->i_mount,
-				   !xfs_attr_namecheck(name, namelen))) {
+				   !xfs_attr_namecheck(entry->flags, name,
+						       namelen))) {
 			xfs_dirattr_mark_sick(context->dp, XFS_ATTR_FORK);
 			return -EFSCORRUPTED;
 		}

