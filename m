Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEDDC129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NU9VW3nK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3111CC433C7;
	Sun, 31 Dec 2023 22:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061952;
	bh=VHAaFhWqX9pE0nnGEIkk/+HvTQj8Uv9R/U8zruIgtp4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NU9VW3nKSwaPuczaMJIRyR30fchJL8/HUuDbkCP/afKbKDA3Y4+9gfwnHWniiJc5x
	 jPQ9JVYresEdGrqs0KiML38H+FXRBYzvu/Zt44dzHvz/S7HjEayVySypBl4NHkusOc
	 RD04pEWkzxSuE3oADJryw3MCceHvfH0VK27vyYLSMsv90OdDvioMilg1CXJKoedv6K
	 bzejTyA2HMSUc7Q/+3FhQYl3IeI3fB6o3IEbsWK+oRTO33ZW9oePjf8umNdWMPtQIL
	 fAgjFaAoZRiuboLYMKF3M1rIX1Pky14lpMpRNK0li9sZZicpBNWdBMZzXh4JZbZb6f
	 jbyLgBiH76W7g==
Date: Sun, 31 Dec 2023 14:32:31 -0800
Subject: [PATCH 1/9] xfs: add an explicit owner field to xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404996881.1796662.10277481601586037353.stgit@frogsfrogsfrogs>
In-Reply-To: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
References: <170404996860.1796662.9605761412685436403.stgit@frogsfrogsfrogs>
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

Add an explicit owner field to xfs_da_args, which will make it easier
for online fsck to set the owner field of the temporary directory and
xattr structures that it builds to repair damaged metadata.

Note: I hopefully found all the xfs_da_args definitions by looking for
automatic stack variable declarations and xfs_da_args.dp assignments:

git grep -E '(args.*dp =|struct xfs_da_args[[:space:]]*[a-z0-9][a-z0-9]*)'

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/attrset.c           |    2 ++
 db/namei.c             |    1 +
 libxfs/xfs_attr_leaf.c |    2 ++
 libxfs/xfs_bmap.c      |    1 +
 libxfs/xfs_da_btree.h  |    1 +
 libxfs/xfs_dir2.c      |    5 +++++
 libxfs/xfs_swapext.c   |    2 ++
 repair/phase6.c        |    3 +++
 8 files changed, 17 insertions(+)


diff --git a/db/attrset.c b/db/attrset.c
index 0d8d70a8429..2b6cdb5f5c3 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -161,6 +161,7 @@ attr_set_f(
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
+	args.owner = iocur_top->ino;
 
 	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to set attr %s on inode %llu\n"),
@@ -247,6 +248,7 @@ attr_remove_f(
 			(unsigned long long)iocur_top->ino);
 		goto out;
 	}
+	args.owner = iocur_top->ino;
 
 	if (libxfs_attr_set(&args)) {
 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
diff --git a/db/namei.c b/db/namei.c
index 063721ca98f..eb09288b490 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -448,6 +448,7 @@ listdir(
 	struct xfs_da_args	args = {
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
+		.owner		= dp->i_ino,
 	};
 	int			error;
 	bool			isblock;
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index aa7aad36864..e3e9c265fab 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -972,6 +972,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
@@ -1175,6 +1176,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 54db35bc398..296e7d85f63 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -952,6 +952,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
+		dargs.owner = ip->i_ino;
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 706baf36e17..7fb13f26eda 100644
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
index e503bf8f92f..79b6ec893fd 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -249,6 +249,7 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
 	kmem_free(args);
 	return error;
@@ -294,6 +295,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
@@ -388,6 +390,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -461,6 +464,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -522,6 +526,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
diff --git a/libxfs/xfs_swapext.c b/libxfs/xfs_swapext.c
index 92d2f8fa133..5c96ad8a203 100644
--- a/libxfs/xfs_swapext.c
+++ b/libxfs/xfs_swapext.c
@@ -524,6 +524,7 @@ xfs_swapext_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -554,6 +555,7 @@ xfs_swapext_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
diff --git a/repair/phase6.c b/repair/phase6.c
index c681a69017d..ac037cf80ad 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1393,6 +1393,7 @@ dir2_kill_block(
 	args.trans = tp;
 	args.whichfork = XFS_DATA_FORK;
 	args.geo = mp->m_dir_geo;
+	args.owner = ip->i_ino;
 	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
 		error = -libxfs_da_shrink_inode(&args, da_bno, bp);
 	else
@@ -1496,6 +1497,7 @@ longform_dir2_entry_check_data(
 	struct xfs_da_args	da = {
 		.dp = ip,
 		.geo = mp->m_dir_geo,
+		.owner = ip->i_ino,
 	};
 
 
@@ -2284,6 +2286,7 @@ longform_dir2_entry_check(
 	/* is this a block, leaf, or node directory? */
 	args.dp = ip;
 	args.geo = mp->m_dir_geo;
+	args.owner = ip->i_ino;
 	libxfs_dir2_isblock(&args, &isblock);
 	libxfs_dir2_isleaf(&args, &isleaf);
 

