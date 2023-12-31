Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E501F9C3
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOp9eiMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B950C433C7;
	Sun, 31 Dec 2023 20:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054771;
	bh=4IIgxghW1Hk4fdRqBSg33ZP+cMLH+U/Wlkxsc5pTtNs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KOp9eiMvyugaos/Xx5iqcGJ4bNhEWys5wXdkm0+MYt+FeAz826Z4Qn/kLRz45RCaV
	 dd+a/NTh9WflPwtPEOo4L5FDujbKKXuHLr7nqVx+MGAAaANKKZZppBWrY1AFq1+rgV
	 hsE7f4eru22JGI3RVTszSE8fQHz9iXkVgo0xGZA26vQK8becjZ3lEmfrSuTMxGsa70
	 JSQKalIyvzX5LTNd5z88Z632yYl7iqNRt1SRQog1LOqIcL4hEtbEttHkmwY+K1Amoc
	 PyErM/WXn54pUW1fxO0HK7nJ7nYHBwczKH84fxf9/uCfC5RyvOjW+r+EJ0YOUVbzAS
	 KBInaAW/bWhmQ==
Date: Sun, 31 Dec 2023 12:32:50 -0800
Subject: [PATCH 1/9] xfs: add an explicit owner field to xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404834714.1753044.5413433360070877248.stgit@frogsfrogsfrogs>
In-Reply-To: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
References: <170404834676.1753044.18168629400918360020.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 ++
 fs/xfs/libxfs/xfs_bmap.c      |    1 +
 fs/xfs/libxfs/xfs_da_btree.h  |    1 +
 fs/xfs/libxfs/xfs_dir2.c      |    5 +++++
 fs/xfs/libxfs/xfs_swapext.c   |    2 ++
 fs/xfs/scrub/attr.c           |    1 +
 fs/xfs/scrub/dabtree.c        |    1 +
 fs/xfs/scrub/dir.c            |    3 ++-
 fs/xfs/scrub/readdir.c        |    2 ++
 fs/xfs/xfs_acl.c              |    2 ++
 fs/xfs/xfs_attr_item.c        |    1 +
 fs/xfs/xfs_dir2_readdir.c     |    1 +
 fs/xfs/xfs_ioctl.c            |    2 ++
 fs/xfs/xfs_iops.c             |    1 +
 fs/xfs/xfs_trace.h            |    7 +++++--
 fs/xfs/xfs_xattr.c            |    2 ++
 16 files changed, 31 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 94893f19ee187..157117a049837 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -975,6 +975,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
@@ -1178,6 +1179,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 17f607b3b8cdf..5a0e6cffb90d9 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -958,6 +958,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
+		dargs.owner = ip->i_ino;
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 706baf36e1751..7fb13f26edaa7 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -79,6 +79,7 @@ typedef struct xfs_da_args {
 	int		rmtvaluelen2;	/* remote attr value length in bytes */
 	uint32_t	op_flags;	/* operation flags */
 	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+	xfs_ino_t	owner;		/* inode that owns the dir/attr data */
 } xfs_da_args_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 748fe2c514922..51eed639f2dfe 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -250,6 +250,7 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
 	kmem_free(args);
 	return error;
@@ -295,6 +296,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
@@ -389,6 +391,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -462,6 +465,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -523,6 +527,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 7e36e136cee0d..ced2365fa7b59 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -526,6 +526,7 @@ xfs_swapext_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -556,6 +557,7 @@ xfs_swapext_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 6c16d9530ccac..40a59b24c209f 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -169,6 +169,7 @@ xchk_xattr_listent(
 		.hashval		= xfs_da_hashname(name, namelen),
 		.trans			= context->tp,
 		.valuelen		= valuelen,
+		.owner			= context->dp->i_ino,
 	};
 	struct xchk_xattr_buf		*ab;
 	struct xchk_xattr		*sx;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 82b150d3b8b70..fa6385a99ac4e 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -494,6 +494,7 @@ xchk_da_btree(
 	ds->dargs.whichfork = whichfork;
 	ds->dargs.trans = sc->tp;
 	ds->dargs.op_flags = XFS_DA_OP_OKNOENT;
+	ds->dargs.owner = sc->ip->i_ino;
 	ds->state = xfs_da_state_alloc(&ds->dargs);
 	ds->sc = sc;
 	ds->private = private;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 076a310b8eb00..042e28547e044 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -621,10 +621,11 @@ xchk_directory_blocks(
 {
 	struct xfs_bmbt_irec	got;
 	struct xfs_da_args	args = {
-		.dp		= sc ->ip,
+		.dp		= sc->ip,
 		.whichfork	= XFS_DATA_FORK,
 		.geo		= sc->mp->m_dir_geo,
 		.trans		= sc->tp,
+		.owner		= sc->ip->i_ino,
 	};
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
 	struct xfs_mount	*mp = sc->mp;
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index e51c1544be632..20375c0972db9 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -275,6 +275,7 @@ xchk_dir_walk(
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
 		.trans		= sc->tp,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock;
 	int			error;
@@ -326,6 +327,7 @@ xchk_dir_lookup(
 		.hashval	= xfs_dir2_hashname(dp->i_mount, name),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock, isleaf;
 	int			error;
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index 6b840301817a9..505c3069cbaaa 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -135,6 +135,7 @@ xfs_get_acl(struct inode *inode, int type, bool rcu)
 		.dp		= ip,
 		.attr_filter	= XFS_ATTR_ROOT,
 		.valuelen	= XFS_ACL_MAX_SIZE(mp),
+		.owner		= ip->i_ino,
 	};
 	int			error;
 
@@ -178,6 +179,7 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
 	struct xfs_da_args	args = {
 		.dp		= ip,
 		.attr_filter	= XFS_ATTR_ROOT,
+		.owner		= ip->i_ino,
 	};
 	int			error;
 
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index f8c6c34e348f3..d7ebb54a03870 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -540,6 +540,7 @@ xfs_attri_recover_work(
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
+	args->owner = args->dp->i_ino;
 
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index a457be34b3fff..263a897bee49e 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -534,6 +534,7 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
+	args.owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 071b135ec9653..de16dbc9e7ded 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -480,6 +480,7 @@ xfs_attrmulti_attr_get(
 		.name		= name,
 		.namelen	= strlen(name),
 		.valuelen	= *len,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
@@ -513,6 +514,7 @@ xfs_attrmulti_attr_set(
 		.attr_flags	= xfs_attr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 11382c499c92c..037606e5eee40 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -62,6 +62,7 @@ xfs_initxattrs(
 			.namelen	= strlen(xattr->name),
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
+			.owner		= ip->i_ino,
 		};
 		error = xfs_attr_change(&args);
 		if (error < 0)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 91ec676fcf8ed..ee6f569c2f3d9 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1927,6 +1927,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__field(xfs_dahash_t, hashval)
 		__field(xfs_ino_t, inumber)
 		__field(uint32_t, op_flags)
+		__field(xfs_ino_t, owner)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
@@ -1937,9 +1938,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__entry->hashval = args->hashval;
 		__entry->inumber = args->inumber;
 		__entry->op_flags = args->op_flags;
+		__entry->owner = args->owner;
 	),
 	TP_printk("dev %d:%d ino 0x%llx name %.*s namelen %d hashval 0x%x "
-		  "inumber 0x%llx op_flags %s",
+		  "inumber 0x%llx op_flags %s owner 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->namelen,
@@ -1947,7 +1949,8 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		  __entry->namelen,
 		  __entry->hashval,
 		  __entry->inumber,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->owner)
 )
 
 #define DEFINE_DIR2_EVENT(name) \
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0e0e25e386f17..1920ca49b08d6 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -133,6 +133,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		.namelen	= strlen(name),
 		.value		= value,
 		.valuelen	= size,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
@@ -159,6 +160,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 		.namelen	= strlen(name),
 		.value		= (void *)value,
 		.valuelen	= size,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 

