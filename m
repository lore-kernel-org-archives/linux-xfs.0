Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB77C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbiL3X5t (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiL3X5r (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:57:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F681E3C5
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BDF44B81DDD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7758BC433EF;
        Fri, 30 Dec 2022 23:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444660;
        bh=EBSTuQsJRzSa+M6s4fZMCDOtayM5DJi4TXxJFao8dJA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DXb6o28f2L3DNzYWKeU6K7G4UWrspc1PasIcbeuOLvUlc/3VusklCyxDYH/KZcmGK
         mDGfn+CK445dXdEWd8YEegJ4srm9IH35KFclddBTR4oK3uouDZs1Ayok+I7o3Pr0fh
         1YXnUqsGQviKccY6XlW25YYFBW7rMsenK8eNttWslfL2JMD88P6Avyz4Ti3GHC4CRO
         6M6zixr6w3qbrZHAl7Ld/rR0bwcKehwdAl8ILHnd4pXsLuBHgQiN/plNkcj+9OqMdd
         e9hGkA7ZpZCLc9kFXdEGOY0m50y1U639I422o050P97QbM6veslt/iPS+LwfbLsfln
         OJ3UZ5MhWR7sw==
Subject: [PATCH 1/9] xfs: add an explicit owner field to xfs_da_args
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:08 -0800
Message-ID: <167243844846.700244.7272783041496352726.stgit@magnolia>
In-Reply-To: <167243844821.700244.10251762547708755105.stgit@magnolia>
References: <167243844821.700244.10251762547708755105.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 1ba16c369f26..e771167c8766 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -975,6 +975,7 @@ xfs_attr_shortform_to_leaf(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count; i++) {
@@ -1195,6 +1196,7 @@ xfs_attr3_leaf_to_shortform(
 	nargs.whichfork = XFS_ATTR_FORK;
 	nargs.trans = args->trans;
 	nargs.op_flags = XFS_DA_OP_OKNOENT;
+	nargs.owner = args->owner;
 
 	for (i = 0; i < ichdr.count; entry++, i++) {
 		if (entry->flags & XFS_ATTR_INCOMPLETE)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cf85f3896afa..7cbb96a805a3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -968,6 +968,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
+		dargs.owner = ip->i_ino;
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..52694dc0cd3c 100644
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
index f56710005f43..fb0697dc733f 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
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
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 69812594fd71..65b1ccb162ad 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -466,6 +466,7 @@ xfs_swapext_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -496,6 +497,7 @@ xfs_swapext_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
+		.owner		= sxi->sxi_ip2->i_ino,
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ea9d0f1a6fd0..090710acc4b6 100644
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
index 957a0b1a2f0b..c8274a7e0cfd 100644
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
index 5b47d3cc8f78..8b4e58416327 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -614,10 +614,11 @@ xchk_directory_blocks(
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
index fd888fe5151f..59a658362b2b 100644
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
+		.owner		= sc->ip->i_ino,
 	};
 	bool			isblock, isleaf;
 	int			error;
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index a05f44eb8178..9108edbb9442 100644
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
index 2788a6f2edcd..0891d739666e 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -593,6 +593,7 @@ xfs_attri_item_recover(
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
+	args->owner = ip->i_ino;
 
 	ASSERT(xfs_sb_version_haslogxattrs(&mp->m_sb));
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 4c061b48da18..fc2524b8f1f1 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -532,6 +532,7 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
+	args.owner = dp->i_ino;
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 85c33142c5ab..df6601eda7ec 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -477,6 +477,7 @@ xfs_attrmulti_attr_get(
 		.name		= name,
 		.namelen	= strlen(name),
 		.valuelen	= *len,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
@@ -510,6 +511,7 @@ xfs_attrmulti_attr_set(
 		.attr_flags	= xfs_attr_flags(flags),
 		.name		= name,
 		.namelen	= strlen(name),
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 515318dfbc38..a24bf6bb5094 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -61,6 +61,7 @@ xfs_initxattrs(
 			.namelen	= strlen(xattr->name),
 			.value		= xattr->value,
 			.valuelen	= xattr->value_len,
+			.owner		= ip->i_ino,
 		};
 		error = xfs_attr_change(&args);
 		if (error < 0)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0802f078a945..da6b7461f4d0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1949,6 +1949,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		__field(xfs_dahash_t, hashval)
 		__field(xfs_ino_t, inumber)
 		__field(uint32_t, op_flags)
+		__field(xfs_ino_t, owner)
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
@@ -1959,9 +1960,10 @@ DECLARE_EVENT_CLASS(xfs_da_class,
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
@@ -1969,7 +1971,8 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 		  __entry->namelen,
 		  __entry->hashval,
 		  __entry->inumber,
-		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS))
+		  __print_flags(__entry->op_flags, "|", XFS_DA_OP_FLAGS),
+		  __entry->owner)
 )
 
 #define DEFINE_DIR2_EVENT(name) \
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index e03f199f50c7..809882e3978b 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -122,6 +122,7 @@ xfs_xattr_get(const struct xattr_handler *handler, struct dentry *unused,
 		.namelen	= strlen(name),
 		.value		= value,
 		.valuelen	= size,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 
@@ -145,6 +146,7 @@ xfs_xattr_set(const struct xattr_handler *handler,
 		.namelen	= strlen(name),
 		.value		= (void *)value,
 		.valuelen	= size,
+		.owner		= XFS_I(inode)->i_ino,
 	};
 	int			error;
 

