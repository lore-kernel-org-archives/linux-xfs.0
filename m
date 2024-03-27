Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AF61CF92
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 01:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711504730; cv=none; b=Lz31B/7ZbcufNaj7TLQ2/mu+rubN2z1OkurEjkoN0Aw5PCNGcwdpl0H2i+oNliA5BfAPCMyWXA/4gaEK9vuY6CAKdM6g6w0pZxD8EF0IU+StySNkUnjMlufRvOSpbY6ZthBUJfkwpVDuDWNlsT92PM7pa2K7Y9M67vc380lAmfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711504730; c=relaxed/simple;
	bh=MTs9olI4rVBdDehMeTZCWN1vxcMjwb2PyAClKAuHU+s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AiIwPJbABqNa/ZtbW/DpT5FxK6UawmO/Cxql9FrAcaCkPNRXpGhLeFsKBKCR0ZDqehtaJILd9sCaNSfZM5W1e6kwE7CbGu7otue7z5zcC//pkvaRDOm6y4mnum4Ws9u9i+K41J9HxgWLQlnKrdIboS3kLQim+WdiE8by6zSlTp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NDwx09Xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NDwx09Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F022C433C7;
	Wed, 27 Mar 2024 01:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711504730;
	bh=MTs9olI4rVBdDehMeTZCWN1vxcMjwb2PyAClKAuHU+s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NDwx09XqbdVDzoCNdcqyWVCBrXNAxHuzbKRM/kKTsHhhS1bEE4+WKLjABNb20CSUV
	 xoLBeJQOyEP01wm0au6dibToj7hQ7XG/pdnm+4mPK3V+Xp52zcKNl9O+YiTby7b874
	 0m+8o8qhBoOkm+IGCeoN9ia1FRFAss3g1C/2mMvdfXetJgdIx17uMocVFiZm7NTtsT
	 YuGhlygXIJH3pXsnmla2uQnQsvvYRRgJch1A+RoO2s8qDbwyjHkctOGH9QnB/aN8Gn
	 nRJ+LFDzYuB0k9ItfEYG3/XZ6WK19n2KyGYGo8fHZ30rC2T2xXl9FO4FQA7I1rjneg
	 j34ysTz8fIAwQ==
Date: Tue, 26 Mar 2024 18:58:50 -0700
Subject: [PATCH 01/10] xfs: add an explicit owner field to xfs_da_args
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150382139.3217370.1830176733881316702.stgit@frogsfrogsfrogs>
In-Reply-To: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
References: <171150382098.3217370.5208665628669220587.stgit@frogsfrogsfrogs>
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

Note that callers of xfs_attr_{get,set,change} can set the owner to zero
(or leave it unset) to have the default set to args->dp.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c      |    4 ++++
 fs/xfs/libxfs/xfs_attr_leaf.c |    2 ++
 fs/xfs/libxfs/xfs_bmap.c      |    1 +
 fs/xfs/libxfs/xfs_da_btree.h  |    1 +
 fs/xfs/libxfs/xfs_dir2.c      |    5 +++++
 fs/xfs/libxfs/xfs_exchmaps.c  |    2 ++
 fs/xfs/scrub/attr.c           |    1 +
 fs/xfs/scrub/dabtree.c        |    1 +
 fs/xfs/scrub/dir.c            |    3 ++-
 fs/xfs/scrub/readdir.c        |    2 ++
 fs/xfs/xfs_attr_item.c        |    1 +
 fs/xfs/xfs_dir2_readdir.c     |    1 +
 fs/xfs/xfs_trace.h            |    7 +++++--
 13 files changed, 28 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 673a4b6d2e8d1..74d7694614434 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -264,6 +264,8 @@ xfs_attr_get(
 	if (xfs_is_shutdown(args->dp->i_mount))
 		return -EIO;
 
+	if (!args->owner)
+		args->owner = args->dp->i_ino;
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
@@ -937,6 +939,8 @@ xfs_attr_set(
 	if (error)
 		return error;
 
+	if (!args->owner)
+		args->owner = args->dp->i_ino;
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index ac904cc1a97ba..e606eae8d3770 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -904,6 +904,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	sfe = xfs_attr_sf_firstentry(sf);
 	for (i = 0; i < sf->count; i++) {
@@ -1106,6 +1107,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 656c95a22f2e6..46bbc9f0a1173 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -976,6 +976,7 @@ xfs_bmap_add_attrfork_local(
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
index 4821519efad4b..9da99fa20c759 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -250,6 +250,7 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 	error = xfs_dir2_sf_create(args, pdp->i_ino);
 	kfree(args);
 	return error;
@@ -295,6 +296,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
@@ -383,6 +385,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
+	args->owner = dp->i_ino;
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -456,6 +459,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
@@ -517,6 +521,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
+	args->owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 0ac52a73152f2..70e17ce44810e 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -429,6 +429,7 @@ xfs_exchmaps_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
+		.owner		= xmi->xmi_ip2->i_ino,
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -459,6 +460,7 @@ xfs_exchmaps_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
+		.owner		= xmi->xmi_ip2->i_ino,
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 83c7feb387147..0c467f4f8e778 100644
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
index dfdcb96b6c169..fb98b7624994a 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -273,6 +273,7 @@ xchk_dir_walk(
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
 		.trans		= sc->tp,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock;
 	int			error;
@@ -324,6 +325,7 @@ xchk_dir_lookup(
 		.hashval	= xfs_dir2_hashname(dp->i_mount, name),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
+		.owner		= dp->i_ino,
 	};
 	bool			isblock, isleaf;
 	int			error;
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 9b4c61e1c22e8..d460347056945 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -540,6 +540,7 @@ xfs_attri_recover_work(
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
+	args->owner = args->dp->i_ino;
 
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index cf9296b7e06ff..4e811fa393add 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -532,6 +532,7 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
+	args.owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 39f7784823cbf..fd9fa87819d5c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1931,6 +1931,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__field(xfs_dahash_t, hashval)
 		__field(xfs_ino_t, inumber)
 		__field(uint32_t, op_flags)
+		__field(xfs_ino_t, owner)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
@@ -1941,9 +1942,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
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
@@ -1951,7 +1953,8 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		  __entry->namelen,
 		  __entry->hashval,
 		  __entry->inumber,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->owner)
 )
 
 #define DEFINE_DIR2_EVENT(name) \

