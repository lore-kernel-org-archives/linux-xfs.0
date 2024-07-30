Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA472563
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722299246; cv=none; b=JyIwTAzngm8yo8v0D6tJc72bir9q+8JI39FttturYUEOEqef80FpNHAblPIjB4U68TrvY8waVkXfedKKkmH5IQNn6LDDAsjLaS8a8ToNOE7DaC1vpfpO4QeqKQ19WT/NPLEEjiDIUayYm6NTdJrK54LvqMZcgXLvAn63q7+jSfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722299246; c=relaxed/simple;
	bh=K5+SkDc9nrGKcmzS2HycCanzqR2XXo4U/7jZXt/cQ7Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tDkKGMK+hRCzIVVc+Bt0uJSMDzLpX8e4NYjCZ32GCXhhEmKcrqddmvBSHL9ngxgL+RopyA/cBLA0jq2UUs5xyYGI5w/0QfJ6U2T/V067QWemQ3iPEUGDQFuIUjygHieFPpd5usy25XMXsrTzYk8sbKVAMYHMZgB5wSB2DrgSzdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRZ3J6Yi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRZ3J6Yi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E90C32786;
	Tue, 30 Jul 2024 00:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722299246;
	bh=K5+SkDc9nrGKcmzS2HycCanzqR2XXo4U/7jZXt/cQ7Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jRZ3J6YiBIOsfuedhT4nd7QGw5TUBCaIpIDAXWke29eZXlomm61VpZEcTABgCxLHg
	 89VcOndM/m8U9HctiOLrsUCttPLIsVqwehoY3xRgRQoUQWmiL/6oCFVXR3ewFqPj9C
	 pe5PzC6dYV8VB+0jLUctYAFNg9LIQ+/bFx7gNyKp/kkHv2V6ERe5K//+pyYey3toej
	 nR8LCl6BFzraqnPmOl4fTMJACQGgLmVAASRJC20krpmmhDeVW24nKTlGbdKCATXrQR
	 gO9GrOxtE71SEG65GRlZnl6ZM+FkbLaGtcX4ID3e1TRDKPhPES+Uxj7v3cTUAAXMfr
	 Bd5xcQukzH1uQ==
Date: Mon, 29 Jul 2024 17:27:25 -0700
Subject: [PATCH 014/115] xfs: add an explicit owner field to xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172229842639.1338752.9671858425538758638.stgit@frogsfrogsfrogs>
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

Source kernel commit: 9eef772f3a194f6841850e45dacdf4207ec7da84

Add an explicit owner field to xfs_da_args, which will make it easier
for online fsck to set the owner field of the temporary directory and
xattr structures that it builds to repair damaged metadata.

Note: I hopefully found all the xfs_da_args definitions by looking for
automatic stack variable declarations and xfs_da_args.dp assignments:

git grep -E '(args.*dp =|struct xfs_da_args[[:space:]]*[a-z0-9][a-z0-9]*)'

Note that callers of xfs_attr_{get,set,change} can set the owner to zero
(or leave it unset) to have the default set to args->dp.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.c      |    4 ++++
 libxfs/xfs_attr_leaf.c |    2 ++
 libxfs/xfs_bmap.c      |    1 +
 libxfs/xfs_da_btree.h  |    1 +
 libxfs/xfs_dir2.c      |    5 +++++
 libxfs/xfs_exchmaps.c  |    2 ++
 6 files changed, 15 insertions(+)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index caf04daa7..21b5d922b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -262,6 +262,8 @@ xfs_attr_get(
 	if (xfs_is_shutdown(args->dp->i_mount))
 		return -EIO;
 
+	if (!args->owner)
+		args->owner = args->dp->i_ino;
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
@@ -935,6 +937,8 @@ xfs_attr_set(
 	if (error)
 		return error;
 
+	if (!args->owner)
+		args->owner = args->dp->i_ino;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index a44312cdc..393e5e6ca 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -901,6 +901,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	sfe = xfs_attr_sf_firstentry(sf);
 	for (i = 0; i < sf->count; i++) {
@@ -1103,6 +1104,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index b089f53e0..868334229 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -970,6 +970,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
+		dargs.owner = ip->i_ino;
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 706baf36e..7fb13f26e 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
@@ -79,6 +79,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 } xfs_da_args_t;
 
 /*
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 530c3e22a..803fb82b2 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -249,6 +249,7 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
 	kfree(args);
 	return error;
@@ -294,6 +295,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
@@ -382,6 +384,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -455,6 +458,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -516,6 +520,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 37e58d088..6160beef1 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -426,6 +426,7 @@ xfs_exchmaps_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
+		.owner		= xmi->xmi_ip2->i_ino,
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -456,6 +457,7 @@ xfs_exchmaps_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
+		.owner		= xmi->xmi_ip2->i_ino,
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;

