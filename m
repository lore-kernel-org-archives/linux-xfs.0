Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B901854
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 00:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710411; cv=none; b=dwkIOtSVvCWJirKd9LeYZFiNtxy2hiWjG9tuylEDAGG1fIF58EyLD5+isZzoBJdYw8+rrR+QJFAXWKJkhCa1dLGkRtaTo6VqsDumAjk2fV7huu9IpE+0PZAkW4LXtas/NVncj6ivNSfjebo97otRsEvN4DMMT6cn1rZ/R9Ia9VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710411; c=relaxed/simple;
	bh=6EglNPIYkOVr3QZ6vlpYr8SyHyYETEOBqycnR8uF/aA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HLeAsRQSr5bY517gtnx4k4eBVJzNmsCvxa2jAepakZCt32u3h/T0t6il3RQCSkXYoQUZkUONFgCUNREhnNejDmUikAdVYQxNei4VaVPhtpdGfxWAHCwewrlNDE++pJFJOu811Fy7cudI36piQ9EIlcnTTTKoY1rJHTSQ94rsH70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZXzfQ5Dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZXzfQ5Dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DD7C433C7;
	Wed, 10 Apr 2024 00:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710411;
	bh=6EglNPIYkOVr3QZ6vlpYr8SyHyYETEOBqycnR8uF/aA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZXzfQ5DxY4ElxLjC1kzHvj+pq7hMcSBnPOsPUfftCd5Jb2gtos+VGM2y6vivtkzPM
	 4M9wA1+oW/M4/sJ6n4Gl3O4FdF8XsKhRHCmzBF+/B06sMV8+R249ltdfyVw55HmerX
	 /o0X/gmpfDnVWFF/sL3wO/CTlxJqwpTYdfwI9/OmrrKj5QdTPvLN7EllWFS5j1OqLa
	 RmptKaCXZbbEKfjH6CLhrh1Lh+CLJKJrsgGg0RC9LJ7aFzgwPK8TevGxUTeODFrefN
	 pbciSf+leoz9eMpFzmLbKbS/5WC+WyETD5IZvfmBvT1x83tjSK1EHOxTWwfzWxLna9
	 UG77RJguPosKw==
Date: Tue, 09 Apr 2024 17:53:30 -0700
Subject: [PATCH 12/12] xfs: enforce one namespace per attribute
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171270969047.3631545.13061481708392950797.stgit@frogsfrogsfrogs>
In-Reply-To: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_attr.c      |   15 +++++++++++++++
 fs/xfs/libxfs/xfs_attr.h      |    4 +++-
 fs/xfs/libxfs/xfs_attr_leaf.c |    7 ++++++-
 fs/xfs/scrub/attr.c           |   12 +++++-------
 fs/xfs/scrub/attr_repair.c    |    4 +---
 fs/xfs/xfs_attr_item.c        |   10 ++++++++--
 fs/xfs/xfs_attr_list.c        |   11 +++++++----
 7 files changed, 45 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fda9acb81585d..426a41b43f641 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -275,6 +275,8 @@ xfs_attr_get(
 
 	if (xfs_is_shutdown(args->dp->i_mount))
 		return -EIO;
+	if (!xfs_attr_namecheck(args->attr_filter, args->name, args->namelen))
+		return -EFSCORRUPTED;
 
 	if (!args->owner)
 		args->owner = args->dp->i_ino;
@@ -950,6 +952,8 @@ xfs_attr_set(
 
 	if (xfs_is_shutdown(dp->i_mount))
 		return -EIO;
+	if (!xfs_attr_namecheck(args->attr_filter, args->name, args->namelen))
+		return -EFSCORRUPTED;
 
 	error = xfs_qm_dqattach(dp);
 	if (error)
@@ -1530,12 +1534,23 @@ xfs_attr_node_get(
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
index 04ae01ab9a5d8..3813f7ae626a2 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -552,7 +552,9 @@ int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
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
index 0e0faa19d4da6..7929caf2052f7 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -949,6 +949,11 @@ xfs_attr_shortform_to_leaf(
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
@@ -1062,7 +1067,7 @@ xfs_attr_shortform_verify(
 		 * one namespace flag per xattr, so we can just count the
 		 * bits (i.e. hweight) here.
 		 */
-		if (hweight8(sfep->flags & XFS_ATTR_NSP_ONDISK_MASK) > 1)
+		if (!xfs_attr_check_namespace(sfep->flags))
 			return __this_address;
 
 		sfep = next_sfep;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 5ca79af47e81e..fdff9be408186 100644
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
index 8192f9044c4a9..7228758c2da1a 100644
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
index 5ad14be760adc..4d4fb804c0016 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -486,6 +486,10 @@ xfs_attri_validate(
 	if (attrp->alfi_attr_filter & ~XFS_ATTRI_FILTER_MASK)
 		return false;
 
+	if (!xfs_attr_check_namespace(attrp->alfi_attr_filter &
+				      XFS_ATTR_NSP_ONDISK_MASK))
+		return false;
+
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
@@ -629,7 +633,8 @@ xfs_attr_recover_work(
 	 */
 	attrp = &attrip->attri_format;
 	if (!xfs_attri_validate(mp, attrp) ||
-	    !xfs_attr_namecheck(nv->name.i_addr, nv->name.i_len))
+	    !xfs_attr_namecheck(attrp->alfi_attr_filter, nv->name.i_addr,
+				nv->name.i_len))
 		return -EFSCORRUPTED;
 
 	attr = xfs_attri_recover_work(mp, dfp, attrp, &ip, nv);
@@ -801,7 +806,8 @@ xlog_recover_attri_commit_pass2(
 	}
 
 	attr_name = item->ri_buf[i].i_addr;
-	if (!xfs_attr_namecheck(attr_name, name_len)) {
+	if (!xfs_attr_namecheck(attri_formatp->alfi_attr_filter, attr_name,
+				name_len)) {
 		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 				attri_formatp, len);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 97c8f3dcfb89d..903ed46c68872 100644
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

