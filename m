Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE465306776
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 20:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783022565; cv=none; b=UcIS5S9zQQI0rbiHDhfT3IJ8mSokB4PueXABQrHmopfvOznFJxmY8ib+v7kFCuRE4oupgA18aK07evbsoTS9QH3DrtqzW29iBBmurPUyndfsUihGbh5gX0FwRbTtWCG/TmMoylYKb4nSq1lD995qqs75dKwq7dXTa71RuI3iw3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783022565; c=relaxed/simple;
	bh=kSFHA1f1B6/nlE6nxB1Wx4pCSmObqK9EsQR1VWK29LM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bX8omtDOEGbKM18XNA70BtH6mIeOH605HkfXdV+acE+V3/DB4fUXHK6v2p9ur7IodbQXUpqdCmCXxJtuXdyQbq8/6N4Y3P0NGIqG7hbkbb7xhrmPyEwrRI1YMRYmSSRW+DKFXyPOu0xDzc5I2MwHaLkNb+oBfkiuQFCKQxVoydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWR8QDZX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWR8QDZX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 898BB1F000E9;
	Thu,  2 Jul 2026 20:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783022561;
	bh=uJ10J9NSz+f2O+dmvw6FaxlrezpE6cTBCGERBdqLEwQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=hWR8QDZXoB7tggQuhBubFKHIG1mhZ3x0MacmTwDc0M8aM3XxkVt9Q4I25vU11WUtb
	 u7ou4aR9r7JTqMb4t7036uHBQAeBa37v/8iXYPrFHbeFUY3KT2JJW0n1Gll4ZpeHFZ
	 6zpCAjPJpExzMxcNqrSfMMxGjMe4fhcSphjxSVwir7XwkGRHCZpBw3amF51oAWlZz3
	 KorVaCB9ptmXIkDYKIxnpmnF/efKWDf2v0FfqkWPkJB21I6r7ms3WnLU1iW+2voZaY
	 RGLsQqbXbwOgtcJKGsN8elBynMtHj7v6m2gObTPFFJ4O76o7Fg9fdCYRVa5jrSoSLo
	 /5ylElbiW5kmQ==
Date: Thu, 02 Jul 2026 13:02:41 -0700
Subject: [PATCH 09/18] xfs: remove the i_ino field in struct xfs_inode
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, cmaiolino@redhat.com, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <178302226468.845537.10102947127694286851.stgit@frogsfrogsfrogs>
In-Reply-To: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
References: <178302226213.845537.4378925114415707650.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 1113a6d6d5d1336f4415fa1367aac0f853f0892d

Now that the VFS inode has a u64 i_ino field, there is no need to store
a copy of the inode number in the xfs_inode structure.

Introduce an I_INO() wrapper as a shortcut to the inode number so that
we don't have to propagate the VFS inode everywhere.

The only non-obvious part is the clearing of i_ino to 0 for RCU freeing
the inode.  None of this calls into VFS paths, which makes clearing the
VFS inode field here just as safe as clearing the old field in the
xfs_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 include/xfs_inode.h           |    7 ++
 libxfs/xfs_format.h           |    6 +-
 libxfs/xfs_parent.h           |    2 -
 libxfs/xfs_rmap.h             |    4 +
 db/attrset.c                  |    2 -
 db/bmap_inflate.c             |    4 +
 db/dquot.c                    |    2 -
 db/iunlink.c                  |    2 -
 db/namei.c                    |   14 ++--
 db/rdump.c                    |    2 -
 libxfs/defer_item.c           |    2 -
 libxfs/inode.c                |    4 +
 libxfs/listxattr.c            |    4 +
 libxfs/logitem.c              |    4 +
 libxfs/util.c                 |    2 -
 libxfs/xfs_attr.c             |    2 -
 libxfs/xfs_attr_leaf.c        |    2 -
 libxfs/xfs_bmap.c             |    6 +-
 libxfs/xfs_bmap_btree.c       |    4 +
 libxfs/xfs_btree.c            |    8 +--
 libxfs/xfs_btree_staging.c    |    2 -
 libxfs/xfs_da_btree.c         |    2 -
 libxfs/xfs_dir2.c             |   40 ++++++-------
 libxfs/xfs_dir2_node.c        |    2 -
 libxfs/xfs_dir2_sf.c          |    4 +
 libxfs/xfs_exchmaps.c         |    8 +--
 libxfs/xfs_ialloc.c           |    2 -
 libxfs/xfs_inode_buf.c        |    4 +
 libxfs/xfs_inode_fork.c       |    6 +-
 libxfs/xfs_inode_util.c       |    6 +-
 libxfs/xfs_metadir.c          |    2 -
 libxfs/xfs_parent.c           |    8 +--
 libxfs/xfs_rmap.c             |    6 +-
 libxfs/xfs_rtbitmap.c         |    4 +
 libxfs/xfs_rtrefcount_btree.c |    4 +
 libxfs/xfs_rtrmap_btree.c     |    4 +
 libxfs/xfs_symlink_remote.c   |    6 +-
 mkfs/proto.c                  |   16 +++--
 repair/bmap_repair.c          |    4 +
 repair/phase6.c               |  128 +++++++++++++++++++++--------------------
 repair/pptr.c                 |   96 +++++++++++++++----------------
 repair/quotacheck.c           |    8 +--
 repair/rt.c                   |    6 +-
 repair/xfs_repair.c           |    2 -
 44 files changed, 229 insertions(+), 224 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 61d4d285a10613..f07a34ec5d4643 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -72,6 +72,7 @@ struct inode {
 	unsigned long		i_state; /* Not actually used in userspace */
 	uint32_t		i_generation;
 	uint64_t		i_version;
+	uint64_t		i_ino;		/* inode number (agno/agino) */
 	struct timespec64	__i_atime;
 	struct timespec64	__i_mtime;
 	struct timespec64	__i_ctime; /* use inode_*_ctime accessors! */
@@ -218,7 +219,6 @@ static inline bool inode_wrong_type(const struct inode *inode, umode_t mode)
 typedef struct xfs_inode {
 	struct cache_node	i_node;
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
-	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 	struct xfs_ifork	*i_cowfp;	/* copy on write extents */
 	struct xfs_ifork	i_df;		/* data fork */
@@ -366,6 +366,11 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
 }
 #define XFS_IS_REALTIME_INODE(ip) ((ip)->i_diflags & XFS_DIFLAG_REALTIME)
 
+static inline uint64_t I_INO(const struct xfs_inode *ip)
+{
+	return VFS_IC(ip)->i_ino;
+}
+
 static inline bool xfs_is_zoned_inode(struct xfs_inode *ip)
 {
 	return xfs_has_zoned(ip->i_mount) && XFS_IS_REALTIME_INODE(ip);
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 9886af0507e3af..dd0ed046fbe9c9 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1277,11 +1277,11 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 #define	XFS_INO_TO_AGNO(mp,i)		\
 	((xfs_agnumber_t)((i) >> XFS_INO_AGINO_BITS(mp)))
 #define	XFS_INODE_TO_AGNO(ip)		\
-	XFS_INO_TO_AGNO((ip)->i_mount, (ip)->i_ino)
+	XFS_INO_TO_AGNO((ip)->i_mount, I_INO(ip))
 #define	XFS_INO_TO_AGINO(mp,i)		\
 	((xfs_agino_t)(i) & XFS_INO_MASK(XFS_INO_AGINO_BITS(mp)))
 #define	XFS_INODE_TO_AGINO(ip)		\
-	XFS_INO_TO_AGINO((ip)->i_mount, (ip)->i_ino)
+	XFS_INO_TO_AGINO((ip)->i_mount, I_INO(ip))
 #define	XFS_INO_TO_AGBNO(mp,i)		\
 	(((xfs_agblock_t)(i) >> XFS_INO_OFFSET_BITS(mp)) & \
 		XFS_INO_MASK(XFS_INO_AGBNO_BITS(mp)))
@@ -1290,7 +1290,7 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 #define	XFS_INO_TO_FSB(mp,i)		\
 	XFS_AGB_TO_FSB(mp, XFS_INO_TO_AGNO(mp,i), XFS_INO_TO_AGBNO(mp,i))
 #define	XFS_INODE_TO_FSB(ip)		\
-	XFS_INO_TO_FSB((ip)->i_mount, (ip)->i_ino)
+	XFS_INO_TO_FSB((ip)->i_mount, I_INO(ip))
 #define	XFS_AGINO_TO_INO(mp,a,i)	\
 	(((xfs_ino_t)(a) << XFS_INO_AGINO_BITS(mp)) | (i))
 #define	XFS_AGINO_TO_AGBNO(mp,i)	((i) >> XFS_INO_OFFSET_BITS(mp))
diff --git a/libxfs/xfs_parent.h b/libxfs/xfs_parent.h
index b8036527cdc73c..8eb4de9c5f1a9c 100644
--- a/libxfs/xfs_parent.h
+++ b/libxfs/xfs_parent.h
@@ -34,7 +34,7 @@ xfs_inode_to_parent_rec(
 	struct xfs_parent_rec	*rec,
 	const struct xfs_inode	*dp)
 {
-	xfs_parent_rec_init(rec, dp->i_ino, VFS_IC(dp)->i_generation);
+	xfs_parent_rec_init(rec, I_INO(dp), VFS_IC(dp)->i_generation);
 }
 
 extern struct kmem_cache	*xfs_parent_args_cache;
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 6016fd5fcad98f..4afa33575ce204 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -22,7 +22,7 @@ xfs_rmap_ino_bmbt_owner(
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
 #define xfs_rmap_inode_bmbt_owner(oi, ip, whichfork) \
-	xfs_rmap_ino_bmbt_owner(oi, (ip)->i_ino, whichfork)
+	xfs_rmap_ino_bmbt_owner(oi, I_INO(ip), whichfork)
 
 static inline void
 xfs_rmap_ino_owner(
@@ -38,7 +38,7 @@ xfs_rmap_ino_owner(
 		oi->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
 }
 #define xfs_rmap_inode_owner(oi, ip, whichfork, offset) \
-	xfs_rmap_ino_owner(oi, (ip)->i_ino, whichfork, offset)
+	xfs_rmap_ino_owner(oi, I_INO(ip), whichfork, offset)
 
 static inline bool
 xfs_rmap_should_skip_owner_update(
diff --git a/db/attrset.c b/db/attrset.c
index 273c2029560047..ec51ce2e07756d 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -701,7 +701,7 @@ attrlist_print(
 		.whichfork	= XFS_ATTR_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
 		.dp		= ip,
-		.owner		= ip->i_ino,
+		.owner		= I_INO(ip),
 		.trans		= tp,
 		.attr_filter	= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.name		= name,
diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index cc7c197e788d7f..13891896fc8b60 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -176,7 +176,7 @@ alloc_bmbt_blocks(
 			target = XFS_AGB_TO_FSB(mp, tgt_agno, 0);
 		}
 
-		libxfs_rmap_ino_bmbt_owner(&args.oinfo, ip->i_ino,
+		libxfs_rmap_ino_bmbt_owner(&args.oinfo, I_INO(ip),
 				XFS_DATA_FORK);
 
 		error = -libxfs_alloc_vextent_start_ag(&args, target);
@@ -421,7 +421,7 @@ estimate_size(
 
 report:
 	dbprintf(_("ino 0x%llx nextents %llu btblocks %llu btheight %u dirty %u\n"),
-			ip->i_ino, nextents, bmap_bload.nr_blocks,
+			I_INO(ip), nextents, bmap_bload.nr_blocks,
 			bmap_bload.btree_height, dirty_blocks);
 
 	return 0;
diff --git a/db/dquot.c b/db/dquot.c
index c028d50e4ca4e6..0c1ebf4e7907f6 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -104,7 +104,7 @@ dqtype_to_inode(
 	if (error)
 		goto out_dp;
 
-	ret = ip->i_ino;
+	ret = I_INO(ip);
 	libxfs_irele(ip);
 out_dp:
 	if (dp)
diff --git a/db/iunlink.c b/db/iunlink.c
index 7eeef5f0886e11..b4705a187b28b1 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -246,7 +246,7 @@ create_unlinked(
 		dbprintf(_("commit inode: %s\n"), strerror(error));
 
 	dbprintf(_("Created unlinked inode %llu in agno %u\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			XFS_INODE_TO_AGNO(ip));
 	libxfs_irele(ip);
 	return error;
diff --git a/db/namei.c b/db/namei.c
index 0a50ec87df9f54..6e5d0ac46360d9 100644
--- a/db/namei.c
+++ b/db/namei.c
@@ -331,7 +331,7 @@ list_sfdir(
 	/* . and .. entries */
 	off = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			geo->data_entry_offset);
-	error = dir_emit(args->trans, args->dp, off, ".", -1, dp->i_ino,
+	error = dir_emit(args->trans, args->dp, off, ".", -1, I_INO(dp),
 			XFS_DIR3_FT_DIR, private);
 	if (error)
 		return error;
@@ -503,7 +503,7 @@ listdir(
 		.trans		= tp,
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
-		.owner		= dp->i_ino,
+		.owner		= I_INO(dp),
 	};
 	int			error;
 
@@ -748,7 +748,7 @@ list_leaf_pptrs(
 	struct xfs_buf			*leaf_bp;
 	int				error;
 
-	error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino, 0, &leaf_bp);
+	error = -libxfs_attr3_leaf_read(NULL, ip, I_INO(ip), 0, &leaf_bp);
 	if (error)
 		return error;
 
@@ -846,7 +846,7 @@ list_node_pptrs(
 
 		libxfs_trans_brelse(NULL, leaf_bp);
 
-		error = -libxfs_attr3_leaf_read(NULL, ip, ip->i_ino,
+		error = -libxfs_attr3_leaf_read(NULL, ip, I_INO(ip),
 				leafhdr.forw, &leaf_bp);
 		if (error)
 			return error;
@@ -1062,7 +1062,7 @@ create_child(
 	libxfs_trans_ijoin(tp, dp, 0);
 	libxfs_trans_ijoin(tp, ip, 0);
 
-	error = -libxfs_dir_createname(tp, dp, &xname, ip->i_ino, resblks);
+	error = -libxfs_dir_createname(tp, dp, &xname, I_INO(ip), resblks);
 	if (error)
 		goto out_trans;
 
@@ -1076,7 +1076,7 @@ create_child(
 	/* Replace the dotdot entry in the child directory. */
 	if (isdir) {
 		error = -libxfs_dir_replace(tp, ip, &xfs_name_dotdot,
-				dp->i_ino, resblks);
+				I_INO(dp), resblks);
 		if (error)
 			goto out_trans;
 	}
@@ -1287,7 +1287,7 @@ remove_child(
 	if (error)
 		goto out_trans;
 
-	error = -libxfs_dir_removename(tp, dp, &xname, ip->i_ino, resblks);
+	error = -libxfs_dir_removename(tp, dp, &xname, I_INO(ip), resblks);
 	if (error)
 		goto out_trans;
 
diff --git a/db/rdump.c b/db/rdump.c
index 599d0727e78892..7fd171a9d53f25 100644
--- a/db/rdump.c
+++ b/db/rdump.c
@@ -376,7 +376,7 @@ rdump_xattr(
 			.trans		= tp,
 			.dp		= ip,
 			.geo		= mp->m_attr_geo,
-			.owner		= ip->i_ino,
+			.owner		= I_INO(ip),
 			.attr_filter	= attr_flags & XFS_ATTR_NSP_ONDISK_MASK,
 			.namelen	= namelen,
 			.name		= name,
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 5d72ee0706f0b7..14ee4152551783 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -563,7 +563,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
+	return cmp_int(I_INO(ba->bi_owner), I_INO(bb->bi_owner));
 }
 
 /* Get an BUI. */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 83741b97117106..b4bf3b5859a7e6 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -151,7 +151,7 @@ libxfs_iget(
 		return -ENOMEM;
 
 	VFS_I(ip)->i_count = 1;
-	ip->i_ino = ino;
+	VFS_I(ip)->i_ino = ino;
 	ip->i_mount = mp;
 	ip->i_diflags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_af.if_format = XFS_DINODE_FMT_EXTENTS;
@@ -160,7 +160,7 @@ libxfs_iget(
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
 	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
-	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, 0);
+	error = xfs_imap(pag, tp, I_INO(ip), &ip->i_imap, 0);
 	xfs_perag_put(pag);
 
 	if (error)
diff --git a/libxfs/listxattr.c b/libxfs/listxattr.c
index 34205682f022d5..fb6f1d53b9d8f5 100644
--- a/libxfs/listxattr.c
+++ b/libxfs/listxattr.c
@@ -101,7 +101,7 @@ xattr_walk_leaf(
 	struct xfs_buf			*leaf_bp;
 	int				error;
 
-	error = -libxfs_attr3_leaf_read(tp, ip, ip->i_ino, 0, &leaf_bp);
+	error = -libxfs_attr3_leaf_read(tp, ip, I_INO(ip), 0, &leaf_bp);
 	if (error)
 		return error;
 
@@ -231,7 +231,7 @@ xattr_walk_node(
 		if (bitmap_test(seen_blocks, leafhdr.forw, 1))
 			goto out_bitmap;
 
-		error = -libxfs_attr3_leaf_read(tp, ip, ip->i_ino,
+		error = -libxfs_attr3_leaf_read(tp, ip, I_INO(ip),
 				leafhdr.forw, &leaf_bp);
 		if (error)
 			goto out_bitmap;
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index d8d86d919cf4d7..67b982788061f8 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -140,7 +140,7 @@ static uint64_t
 xfs_inode_item_sort(
 	struct xfs_log_item	*lip)
 {
-	return INODE_ITEM(lip)->ili_inode->i_ino;
+	return I_INO(INODE_ITEM(lip)->ili_inode);
 }
 
 /*
@@ -316,7 +316,7 @@ xfs_inode_item_init(
 	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_cache, 0);
 #ifdef LI_DEBUG
 	fprintf(stderr, "inode_item_init for inode %llu, iip=%p\n",
-		ip->i_ino, iip);
+		I_INO(ip), iip);
 #endif
 
 	spin_lock_init(&iip->ili_lock);
diff --git a/libxfs/util.c b/libxfs/util.c
index 143d011ac60ddd..6cbbe9056ebad8 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -343,7 +343,7 @@ xfs_inode_verifier_error(
 	xfs_alert(NULL, "Metadata %s detected at %p, inode 0x%llx %s",
 		  error == -EFSBADCRC ? "CRC error" : "corruption",
 		  failaddr ? failaddr : __return_address,
-		  ip->i_ino, name);
+		  I_INO(ip), name);
 }
 
 /*
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index a2611aace8190f..bff8096767014e 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -275,7 +275,7 @@ xfs_attr_get(
 		return -EIO;
 
 	if (!args->owner)
-		args->owner = args->dp->i_ino;
+		args->owner = I_INO(args->dp);
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 6aaa7ff10959d5..c621ccedaa489b 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -1426,7 +1426,7 @@ xfs_attr3_leaf_init(
 	struct xfs_da_args	args = {
 		.trans		= tp,
 		.dp		= dp,
-		.owner		= dp->i_ino,
+		.owner		= I_INO(dp),
 		.geo		= dp->i_mount->m_attr_geo,
 	};
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 23cc5bb4627288..330325004106d9 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -968,7 +968,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
-		dargs.owner = ip->i_ino;
+		dargs.owner = I_INO(ip);
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
@@ -1102,7 +1102,7 @@ xfs_bmap_complain_bad_rec(
 
 	xfs_warn(mp,
  "Bmap BTree record corruption in inode 0x%llx %s fork detected at %pS!",
-				ip->i_ino, forkname, fa);
+				I_INO(ip), forkname, fa);
 	xfs_warn(mp,
 		"Offset 0x%llx, start block 0x%llx, block count 0x%llx state 0x%x",
 		irec->br_startoff, irec->br_startblock, irec->br_blockcount,
@@ -1135,7 +1135,7 @@ xfs_iread_bmbt_block(
 	num_recs = xfs_btree_get_numrecs(block);
 	if (unlikely(ir->loaded + num_recs > ifp->if_nextents)) {
 		xfs_warn(ip->i_mount, "corrupt dinode %llu, (btree extents).",
-				(unsigned long long)ip->i_ino);
+				(unsigned long long)I_INO(ip));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
 				sizeof(*block), __this_address);
 		xfs_bmap_mark_sick(ip, whichfork);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 077b862ca6d2ca..a12ba6918c7b73 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -35,10 +35,10 @@ xfs_bmbt_init_block(
 {
 	if (bp)
 		xfs_btree_init_buf(ip->i_mount, bp, &xfs_bmbt_ops, level,
-				numrecs, ip->i_ino);
+				numrecs, I_INO(ip));
 	else
 		xfs_btree_init_block(ip->i_mount, buf, &xfs_bmbt_ops, level,
-				numrecs, ip->i_ino);
+				numrecs, I_INO(ip));
 }
 
 /*
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index c7db42a4786005..ec77f325aab692 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -368,7 +368,7 @@ xfs_btree_check_ptr(
 		case XFS_BTREE_TYPE_INODE:
 			xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
-				cur->bc_ino.ip->i_ino,
+				I_INO(cur->bc_ino.ip),
 				cur->bc_ino.whichfork, cur->bc_ops->name,
 				level, index);
 			break;
@@ -1302,7 +1302,7 @@ xfs_btree_owner(
 	case XFS_BTREE_TYPE_MEM:
 		return cur->bc_mem.xfbtree->owner;
 	case XFS_BTREE_TYPE_INODE:
-		return cur->bc_ino.ip->i_ino;
+		return I_INO(cur->bc_ino.ip);
 	case XFS_BTREE_TYPE_AG:
 		return cur->bc_group->xg_gno;
 	default:
@@ -3126,7 +3126,7 @@ xfs_btree_promote_leaf_iroot(
 	 */
 	broot = cur->bc_ops->broot_realloc(cur, 1);
 	xfs_btree_init_block(cur->bc_mp, broot, cur->bc_ops,
-			cur->bc_nlevels - 1, 1, cur->bc_ino.ip->i_ino);
+			cur->bc_nlevels - 1, 1, I_INO(cur->bc_ino.ip));
 
 	pp = xfs_btree_ptr_addr(cur, 1, broot);
 	kp = xfs_btree_key_addr(cur, 1, broot);
@@ -3823,7 +3823,7 @@ xfs_btree_demote_leaf_child(
 	 */
 	broot = cur->bc_ops->broot_realloc(cur, numrecs);
 	xfs_btree_init_block(cur->bc_mp, broot, cur->bc_ops, 0, numrecs,
-			cur->bc_ino.ip->i_ino);
+			I_INO(cur->bc_ino.ip));
 
 	rp = xfs_btree_rec_addr(cur, 1, broot);
 	crp = xfs_btree_rec_addr(cur, 1, cblock);
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 4300c058807ba5..c3c7ea54895a60 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -309,7 +309,7 @@ xfs_btree_bload_prep_block(
 
 		/* Initialize it and send it out. */
 		xfs_btree_init_block(cur->bc_mp, ifp->if_broot, cur->bc_ops,
-				level, nr_this_block, cur->bc_ino.ip->i_ino);
+				level, nr_this_block, I_INO(cur->bc_ino.ip));
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index 508fd1475c006a..b51b10f916ab29 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2776,7 +2776,7 @@ xfs_dabuf_map(
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
-					__func__, bno, dp->i_ino);
+					__func__, bno, I_INO(dp));
 
 			for (i = 0; i < nirecs; i++) {
 				xfs_alert(mp,
diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 562d617254b2e3..fce2d847c76091 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -243,7 +243,7 @@ xfs_dir_init(
 	int		error;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
-	error = xfs_dir_ino_validate(tp->t_mountp, pdp->i_ino);
+	error = xfs_dir_ino_validate(tp->t_mountp, I_INO(pdp));
 	if (error)
 		return error;
 
@@ -254,8 +254,8 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
-	args->owner = dp->i_ino;
-	error = xfs_dir2_sf_create(args, pdp->i_ino);
+	args->owner = I_INO(dp);
+	error = xfs_dir2_sf_create(args, I_INO(pdp));
 	kfree(args);
 	return error;
 }
@@ -355,7 +355,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 
 	rval = xfs_dir_createname_args(args);
 	kfree(args);
@@ -446,7 +446,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -515,7 +515,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 	rval = xfs_dir_removename_args(args);
 	kfree(args);
 	return rval;
@@ -575,7 +575,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 	rval = xfs_dir_replace_args(args);
 	kfree(args);
 	return rval;
@@ -854,7 +854,7 @@ xfs_dir_create_child(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	xfs_assert_ilocked(dp, XFS_ILOCK_EXCL);
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, name, I_INO(ip), resblks);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		return error;
@@ -925,7 +925,7 @@ xfs_dir_add_child(
 			return error;
 	}
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, name, I_INO(ip), resblks);
 	if (error)
 		return error;
 
@@ -994,7 +994,7 @@ xfs_dir_remove_child(
 		 * get freed before the child directory is closed.  If the fs
 		 * gets shrunk, this can lead to dirent inode validation errors.
 		 */
-		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
+		if (I_INO(dp) != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
 					tp->t_mountp->m_sb.sb_rootino, 0);
 			if (error)
@@ -1015,7 +1015,7 @@ xfs_dir_remove_child(
 	if (error)
 		return error;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, I_INO(ip), resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		return error;
@@ -1058,12 +1058,12 @@ xfs_dir_exchange_children(
 	int			error;
 
 	/* Swap inode number for dirent in first parent */
-	error = xfs_dir_replace(tp, dp1, name1, ip2->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp1, name1, I_INO(ip2), spaceres);
 	if (error)
 		return error;
 
 	/* Swap inode number for dirent in second parent */
-	error = xfs_dir_replace(tp, dp2, name2, ip1->i_ino, spaceres);
+	error = xfs_dir_replace(tp, dp2, name2, I_INO(ip1), spaceres);
 	if (error)
 		return error;
 
@@ -1077,7 +1077,7 @@ xfs_dir_exchange_children(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						I_INO(dp1), spaceres);
 			if (error)
 				return error;
 
@@ -1101,7 +1101,7 @@ xfs_dir_exchange_children(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						I_INO(dp2), spaceres);
 			if (error)
 				return error;
 
@@ -1264,7 +1264,7 @@ xfs_dir_rename_children(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   I_INO(src_ip), spaceres);
 		if (error)
 			return error;
 
@@ -1285,7 +1285,7 @@ xfs_dir_rename_children(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					I_INO(src_ip), spaceres);
 		if (error)
 			return error;
 
@@ -1319,7 +1319,7 @@ xfs_dir_rename_children(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					I_INO(target_dp), spaceres);
 		ASSERT(error != -EEXIST);
 		if (error)
 			return error;
@@ -1357,10 +1357,10 @@ xfs_dir_rename_children(
 	 * altogether.
 	 */
 	if (du_wip->ip)
-		error = xfs_dir_replace(tp, src_dp, src_name, du_wip->ip->i_ino,
+		error = xfs_dir_replace(tp, src_dp, src_name, I_INO(du_wip->ip),
 					spaceres);
 	else
-		error = xfs_dir_removename(tp, src_dp, src_name, src_ip->i_ino,
+		error = xfs_dir_removename(tp, src_dp, src_name, I_INO(src_ip),
 					   spaceres);
 	if (error)
 		return error;
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 9d8bb27f716fe4..97b8860be942b9 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -1736,7 +1736,7 @@ xfs_dir2_node_add_datablk(
 				   fbno)) {
 			xfs_alert(mp,
 "%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld",
-				__func__, (unsigned long long)dp->i_ino,
+				__func__, (unsigned long long)I_INO(dp),
 				(long long)xfs_dir2_db_to_fdb(args->geo, *dbno),
 				(long long)*dbno, (long long)fbno);
 			if (fblk) {
diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c
index 1a67cdd6a70706..0567cf8b9c1bb2 100644
--- a/libxfs/xfs_dir2_sf.c
+++ b/libxfs/xfs_dir2_sf.c
@@ -301,7 +301,7 @@ xfs_dir2_block_to_sf(
 		 * Skip .
 		 */
 		if (dep->namelen == 1 && dep->name[0] == '.')
-			ASSERT(be64_to_cpu(dep->inumber) == dp->i_ino);
+			ASSERT(be64_to_cpu(dep->inumber) == I_INO(dp));
 		/*
 		 * Skip .., but make sure the inode number is right.
 		 */
@@ -863,7 +863,7 @@ xfs_dir2_sf_lookup(
 	 * Special case for .
 	 */
 	if (args->namelen == 1 && args->name[0] == '.') {
-		args->inumber = dp->i_ino;
+		args->inumber = I_INO(dp);
 		args->cmpresult = XFS_CMP_EXACT;
 		args->filetype = XFS_DIR3_FT_DIR;
 		return -EEXIST;
diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 651c3784caba73..3347dee2c1a852 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -426,7 +426,7 @@ xfs_exchmaps_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
-		.owner		= xmi->xmi_ip2->i_ino,
+		.owner		= I_INO(xmi->xmi_ip2),
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -435,7 +435,7 @@ xfs_exchmaps_attr_to_sf(
 	if (!xfs_attr_is_leaf(xmi->xmi_ip2))
 		return 0;
 
-	error = xfs_attr3_leaf_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, 0,
+	error = xfs_attr3_leaf_read(tp, xmi->xmi_ip2, I_INO(xmi->xmi_ip2), 0,
 			&bp);
 	if (error)
 		return error;
@@ -458,7 +458,7 @@ xfs_exchmaps_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
-		.owner		= xmi->xmi_ip2->i_ino,
+		.owner		= I_INO(xmi->xmi_ip2),
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
@@ -468,7 +468,7 @@ xfs_exchmaps_dir_to_sf(
 	if (xfs_dir2_format(&args, &error) != XFS_DIR2_FMT_BLOCK)
 		return error;
 
-	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, &bp);
+	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, I_INO(xmi->xmi_ip2), &bp);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index abfba2bfabafb7..64f0376a10508f 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1890,7 +1890,7 @@ xfs_dialloc(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_ino_t		ino = NULLFSINO;
-	xfs_ino_t		parent = args->pip ? args->pip->i_ino : 0;
+	xfs_ino_t		parent = args->pip ? I_INO(args->pip) : 0;
 	xfs_agnumber_t		agno;
 	xfs_agnumber_t		start_agno;
 	umode_t			mode = args->mode & S_IFMT;
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index f56aef0dbb3db9..2fc9462e95d67e 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -182,7 +182,7 @@ xfs_inode_from_disk(
 
 	ASSERT(ip->i_cowfp == NULL);
 
-	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
+	fa = xfs_dinode_verify(ip->i_mount, I_INO(ip), from);
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", from,
 				sizeof(*from), fa);
@@ -355,7 +355,7 @@ xfs_inode_to_disk(
 		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
 		/* also covers the di_used_blocks union arm: */
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
-		to->di_ino = cpu_to_be64(ip->i_ino);
+		to->di_ino = cpu_to_be64(I_INO(ip));
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 87afe671886ede..46699896da2404 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -85,7 +85,7 @@ xfs_iformat_local(
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
 	"corrupt inode %llu (bad size %d for local fork, size = %zd).",
-			(unsigned long long) ip->i_ino, size,
+			(unsigned long long)I_INO(ip), size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_local", dip, sizeof(*dip),
@@ -124,7 +124,7 @@ xfs_iformat_extents(
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
 		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
-			ip->i_ino, nex);
+			I_INO(ip), nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
@@ -203,7 +203,7 @@ xfs_iformat_btree(
 		     ifp->if_nextents > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
 		xfs_warn(mp, "corrupt inode %llu (btree).",
-					(unsigned long long) ip->i_ino);
+					(unsigned long long)I_INO(ip));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_btree", dfp, size,
 				__this_address);
diff --git a/libxfs/xfs_inode_util.c b/libxfs/xfs_inode_util.c
index 63b95238d8ce86..cef34004dbe7a2 100644
--- a/libxfs/xfs_inode_util.c
+++ b/libxfs/xfs_inode_util.c
@@ -651,7 +651,7 @@ xfs_droplink(
 	if (inode->i_nlink == 0) {
 		xfs_info_ratelimited(tp->t_mountp,
  "Inode 0x%llx link count dropped below zero.  Pinning link count.",
-				ip->i_ino);
+				I_INO(ip));
 		set_nlink(inode, XFS_NLINK_PINNED);
 	}
 	if (inode->i_nlink != XFS_NLINK_PINNED)
@@ -680,7 +680,7 @@ xfs_bumplink(
 	if (inode->i_nlink == XFS_NLINK_PINNED - 1)
 		xfs_info_ratelimited(tp->t_mountp,
  "Inode 0x%llx link count exceeded maximum.  Pinning link count.",
-				ip->i_ino);
+				I_INO(ip));
 	if (inode->i_nlink != XFS_NLINK_PINNED)
 		inc_nlink(inode);
 
@@ -704,7 +704,7 @@ xfs_inode_uninit(
 	 * makes the AGI lock -> unlinked list modification order the same as
 	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_difree(tp, pag, ip->i_ino, xic);
+	error = xfs_difree(tp, pag, I_INO(ip), xic);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_metadir.c b/libxfs/xfs_metadir.c
index bffe9ba9129002..bfb261e3f72da2 100644
--- a/libxfs/xfs_metadir.c
+++ b/libxfs/xfs_metadir.c
@@ -93,7 +93,7 @@ xfs_metadir_lookup(
 		.hashval	= xfs_dir2_hashname(mp, xname),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
-		.owner		= dp->i_ino,
+		.owner		= I_INO(dp),
 	};
 	int			error;
 
diff --git a/libxfs/xfs_parent.c b/libxfs/xfs_parent.c
index d82c38197f4696..ef406103517164 100644
--- a/libxfs/xfs_parent.c
+++ b/libxfs/xfs_parent.c
@@ -199,7 +199,7 @@ xfs_parent_addname(
 
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
-			child->i_ino, parent_name);
+			I_INO(child), parent_name);
 
 	return xfs_attr_setname(&ppargs->args, 0);
 }
@@ -221,7 +221,7 @@ xfs_parent_removename(
 
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
-			child->i_ino, parent_name);
+			I_INO(child), parent_name);
 
 	return xfs_attr_removename(&ppargs->args);
 }
@@ -245,7 +245,7 @@ xfs_parent_replacename(
 
 	xfs_inode_to_parent_rec(&ppargs->rec, old_dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
-			child->i_ino, old_name);
+			I_INO(child), old_name);
 
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 
@@ -309,7 +309,7 @@ xfs_parent_lookup(
 	struct xfs_da_args		*scratch)
 {
 	memset(scratch, 0, sizeof(struct xfs_da_args));
-	xfs_parent_da_args_init(scratch, tp, pptr, ip, ip->i_ino, parent_name);
+	xfs_parent_da_args_init(scratch, tp, pptr, ip, I_INO(ip), parent_name);
 	return xfs_attr_get_ilocked(scratch);
 }
 
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 9da10afe3578b5..e65f4d7808be38 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2779,7 +2779,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
+	__xfs_rmap_add(tp, type, I_INO(ip), isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2799,7 +2799,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
+	__xfs_rmap_add(tp, type, I_INO(ip), isrt, whichfork, PREV);
 }
 
 /*
@@ -2825,7 +2825,7 @@ xfs_rmap_convert_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_CONVERT_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
+	__xfs_rmap_add(tp, type, I_INO(ip), isrt, whichfork, PREV);
 }
 
 /* Schedule the creation of an rmap for non-file data. */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 7a06305b4e11dd..1681e4a91d7a80 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -209,7 +209,7 @@ xfs_rtbuf_get(
 	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
-		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+		if (hdr->rt_owner != cpu_to_be64(I_INO(ip))) {
 			xfs_buf_mark_corrupt(bp);
 			xfs_trans_brelse(args->tp, bp);
 			xfs_rtginode_mark_sick(args->rtg, type);
@@ -1404,7 +1404,7 @@ xfs_rtfile_initialize_block(
 			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
 		else
 			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
-		hdr->rt_owner = cpu_to_be64(ip->i_ino);
+		hdr->rt_owner = cpu_to_be64(I_INO(ip));
 		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
 		hdr->rt_lsn = 0;
 		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index f893677e0fcd32..2c51b618e1ce1d 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -600,7 +600,7 @@ xfs_rtrefcountbt_from_disk(
 	rblocklen = xfs_rtrefcount_broot_space(mp, dblock);
 
 	xfs_btree_init_block(mp, rblock, &xfs_rtrefcountbt_ops, 0, 0,
-			ip->i_ino);
+			I_INO(ip));
 
 	rblock->bb_level = dblock->bb_level;
 	rblock->bb_numrecs = dblock->bb_numrecs;
@@ -749,7 +749,7 @@ xfs_rtrefcountbt_create(
 			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
 	if (broot)
 		xfs_btree_init_block(mp, broot, &xfs_rtrefcountbt_ops, 0, 0,
-				ip->i_ino);
+				I_INO(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
 	return 0;
 }
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 7191bf445c399b..7fbe6c19c454d7 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -838,7 +838,7 @@ xfs_rtrmapbt_from_disk(
 	unsigned int		numrecs;
 	unsigned int		maxrecs;
 
-	xfs_btree_init_block(mp, rblock, &xfs_rtrmapbt_ops, 0, 0, ip->i_ino);
+	xfs_btree_init_block(mp, rblock, &xfs_rtrmapbt_ops, 0, 0, I_INO(ip));
 
 	rblock->bb_level = dblock->bb_level;
 	rblock->bb_numrecs = dblock->bb_numrecs;
@@ -980,7 +980,7 @@ xfs_rtrmapbt_create(
 	broot = xfs_broot_realloc(ifp, xfs_rtrmap_broot_space_calc(mp, 0, 0));
 	if (broot)
 		xfs_btree_init_block(mp, broot, &xfs_rtrmapbt_ops, 0, 0,
-				ip->i_ino);
+				I_INO(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
 
 	return 0;
diff --git a/libxfs/xfs_symlink_remote.c b/libxfs/xfs_symlink_remote.c
index d29eae498c493e..7b62dba485a5fa 100644
--- a/libxfs/xfs_symlink_remote.c
+++ b/libxfs/xfs_symlink_remote.c
@@ -193,7 +193,7 @@ xfs_symlink_local_to_remote(
 	bp->b_ops = &xfs_symlink_buf_ops;
 
 	buf = bp->b_addr;
-	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
+	buf += xfs_symlink_hdr_set(mp, I_INO(ip), 0, ifp->if_bytes, bp);
 	memcpy(buf, ifp->if_data, ifp->if_bytes);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
 					ifp->if_bytes - 1);
@@ -274,13 +274,13 @@ xfs_symlink_remote_read(
 
 		cur_chunk = bp->b_addr;
 		if (xfs_has_crc(mp)) {
-			if (!xfs_symlink_hdr_ok(ip->i_ino, offset,
+			if (!xfs_symlink_hdr_ok(I_INO(ip), offset,
 							byte_cnt, bp)) {
 				xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
 				error = -EFSCORRUPTED;
 				xfs_alert(mp,
 "symlink header does not match required off/len/owner (0x%x/0x%x,0x%llx)",
-					offset, byte_cnt, ip->i_ino);
+					offset, byte_cnt, I_INO(ip));
 				xfs_buf_relse(bp);
 				goto out;
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index dd47e41d833e5a..bdd0fadda5175c 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -289,7 +289,7 @@ writesymlink(
 	xfs_extlen_t		nb = XFS_B_TO_FSB(mp, len);
 	int			error;
 
-	error = -libxfs_symlink_write_target(tp, ip, ip->i_ino, buf, len, nb,
+	error = -libxfs_symlink_write_target(tp, ip, I_INO(ip), buf, len, nb,
 			nb);
 	if (error) {
 		fprintf(stderr,
@@ -417,7 +417,7 @@ writeattr(
 	struct xfs_da_args	args = {
 		.dp		= ip,
 		.geo		= ip->i_mount->m_attr_geo,
-		.owner		= ip->i_ino,
+		.owner		= I_INO(ip),
 		.whichfork	= XFS_ATTR_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
 		.value		= valuebuf,
@@ -548,7 +548,7 @@ newdirent(
 
 	rsv = XFS_DIRENTER_SPACE_RES(mp, name->len);
 
-	error = -libxfs_dir_createname(tp, pip, name, ip->i_ino, rsv);
+	error = -libxfs_dir_createname(tp, pip, name, I_INO(ip), rsv);
 	if (error)
 		fail(_("directory createname error"), error);
 
@@ -927,7 +927,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		if (!pip) {
 			pip = ip;
-			mp->m_sb.sb_rootino = ip->i_ino;
+			mp->m_sb.sb_rootino = I_INO(ip);
 			libxfs_log_sb(tp);
 			isroot = 1;
 		} else {
@@ -1057,10 +1057,10 @@ create_sb_metadata_file(
 
 	switch (type) {
 	case XFS_RTGI_BITMAP:
-		mp->m_sb.sb_rbmino = ip->i_ino;
+		mp->m_sb.sb_rbmino = I_INO(ip);
 		break;
 	case XFS_RTGI_SUMMARY:
-		mp->m_sb.sb_rsumino = ip->i_ino;
+		mp->m_sb.sb_rsumino = I_INO(ip);
 		break;
 	default:
 		error = EFSCORRUPTED;
@@ -1634,7 +1634,7 @@ create_nondir_inode(
 	 * hardlink, so we need to store it.
 	 */
 	if (file_stat->st_nlink > 1)
-		track_hardlink_inode(file_stat, ip->i_ino);
+		track_hardlink_inode(file_stat, I_INO(ip));
 
 	libxfs_irele(ip);
 }
@@ -1880,7 +1880,7 @@ populate_from_dir(
 	if (error)
 		fail(_("Inode allocation failed"), error);
 
-	mp->m_sb.sb_rootino = ip->i_ino;
+	mp->m_sb.sb_rootino = I_INO(ip);
 	libxfs_log_sb(tp);
 	newdirectory(mp, tp, ip, ip);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 335a35af5379dc..2e1995b3933428 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -134,7 +134,7 @@ xrep_bmap_walk_rmap(
 	int				error;
 
 	/* Skip extents which are not owned by this inode and fork. */
-	if (rec->rm_owner != rb->sc->ip->i_ino)
+	if (rec->rm_owner != I_INO(rb->sc->ip))
 		return 0;
 
 	error = xrep_bmap_check_fork_rmap(rb, cur, rec);
@@ -252,7 +252,7 @@ xrep_bmap_walk_rtrmap(
 	int				error = 0;
 
 	/* Skip extents which are not owned by this inode and fork. */
-	if (rec->rm_owner != rb->sc->ip->i_ino)
+	if (rec->rm_owner != I_INO(rb->sc->ip))
 		return 0;
 
 	error = xrep_bmap_check_rtfork_rmap(rb->sc, cur, rec);
diff --git a/repair/phase6.c b/repair/phase6.c
index 75429d4ca111d4..326fdfa3afb46a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -277,7 +277,7 @@ dir_hash_check(
 	if (seeval == DIR_HASH_CK_OK)
 		return 0;
 	do_warn(_("bad hash table for directory inode %" PRIu64 " (%s): "),
-		ip->i_ino, seevalstr[seeval]);
+		I_INO(ip), seevalstr[seeval]);
 	if (!no_modify)
 		do_warn(_("rebuilding\n"));
 	else
@@ -654,8 +654,8 @@ _("Couldn't create rtgroup %u %s inode, error %d\n"),
 	ip = rtg->rtg_inodes[type];
 
 	/* Mark the inode in use. */
-	mark_ino_inuse(mp, ip->i_ino, S_IFREG, mp->m_rtdirip->i_ino);
-	mark_ino_metadata(mp, ip->i_ino);
+	mark_ino_inuse(mp, I_INO(ip), S_IFREG, I_INO(mp->m_rtdirip));
+	mark_ino_metadata(mp, I_INO(ip));
 	return true;
 }
 
@@ -786,7 +786,7 @@ mk_metadir(
 
 	libxfs_trans_ijoin(tp, mp->m_metadirip, 0);
 	libxfs_metafile_set_iflag(tp, mp->m_metadirip, XFS_METAFILE_DIR);
-	mark_ino_metadata(mp, mp->m_metadirip->i_ino);
+	mark_ino_metadata(mp, I_INO(mp->m_metadirip));
 
 	error = -libxfs_trans_commit(tp);
 	if (error)
@@ -905,7 +905,7 @@ mk_orphanage(
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
-	add_parent_ptr(du.ip->i_ino, (unsigned char *)ORPHANAGE, du.dp, false);
+	add_parent_ptr(I_INO(du.ip), (unsigned char *)ORPHANAGE, du.dp, false);
 
 	/*
 	 * We bumped up the link count in the root directory to account
@@ -974,7 +974,7 @@ trunc_metadata_inode(
 	if (err)
 		do_error(
 	_("truncation of metadata inode 0x%llx failed, err=%d\n"),
-				(unsigned long long)ip->i_ino, err);
+				(unsigned long long)I_INO(ip), err);
 }
 
 /*
@@ -1008,7 +1008,7 @@ add_orphan_pptr(
 				sizeof(struct xfs_attr_sf_hdr), true);
 		if (error)
 			do_error(_("can't add attr fork to inode 0x%llx\n"),
-					(unsigned long long)ip->i_ino);
+					(unsigned long long)I_INO(ip));
 	}
 
 	error = -libxfs_parent_addname(tp, ppargs, orphanage_ip, xname, ip);
@@ -1202,7 +1202,7 @@ mv_orphanage(
 	}
 
 	if (xfs_has_parent(mp))
-		add_parent_ptr(ino_p->i_ino, xname.name, orphanage_ip, false);
+		add_parent_ptr(I_INO(ino_p), xname.name, orphanage_ip, false);
 
 	libxfs_irele(ino_p);
 	libxfs_irele(orphanage_ip);
@@ -1303,10 +1303,10 @@ longform_dir2_rebuild(
 	 * orphanage later (the inode number here needs to be valid
 	 * for the libxfs_dir_init() call).
 	 */
-	pip.i_ino = get_inode_parent(irec, ino_offset);
-	if (pip.i_ino == NULLFSINO ||
-	    libxfs_dir_ino_validate(mp, pip.i_ino))
-		pip.i_ino = mp->m_sb.sb_rootino;
+	VFS_I(&pip)->i_ino = get_inode_parent(irec, ino_offset);
+	if (VFS_I(&pip)->i_ino == NULLFSINO ||
+	    libxfs_dir_ino_validate(mp, I_INO(&pip)))
+		VFS_I(&pip)->i_ino = mp->m_sb.sb_rootino;
 
 	nres = libxfs_remove_space_res(mp, 0);
 	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_remove, nres, 0, 0, &tp);
@@ -1317,7 +1317,7 @@ longform_dir2_rebuild(
 	error = dir_binval(tp, ip, XFS_DATA_FORK);
 	if (error)
 		do_error(_("error %d invalidating directory %llu blocks\n"),
-				error, (unsigned long long)ip->i_ino);
+				error, (unsigned long long)I_INO(ip));
 
 	if ((error = -libxfs_bmap_last_offset(ip, &lastblock, XFS_DATA_FORK)))
 		do_error(_("xfs_bmap_last_offset failed -- error - %d\n"),
@@ -1435,7 +1435,7 @@ dir2_kill_block(
 	args.trans = tp;
 	args.whichfork = XFS_DATA_FORK;
 	args.geo = mp->m_dir_geo;
-	args.owner = ip->i_ino;
+	args.owner = I_INO(ip);
 	if (da_bno >= mp->m_dir_geo->leafblk && da_bno < mp->m_dir_geo->freeblk)
 		error = -libxfs_da_shrink_inode(&args, da_bno, bp);
 	else
@@ -1443,7 +1443,7 @@ dir2_kill_block(
 				xfs_dir2_da_to_db(mp->m_dir_geo, da_bno), bp);
 	if (error)
 		do_error(_("shrink_inode failed inode %" PRIu64 " block %u\n"),
-			ip->i_ino, da_bno);
+			I_INO(ip), da_bno);
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(
@@ -1479,14 +1479,14 @@ check_longform_ftype(
 		do_warn(
 _("would fix ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
 			dir_ftype, ino_ftype,
-			ip->i_ino, inum);
+			I_INO(ip), inum);
 		return;
 	}
 
 	do_warn(
 _("fixing ftype mismatch (%d/%d) in directory/child inode %" PRIu64 "/%" PRIu64 "\n"),
 		dir_ftype, ino_ftype,
-		ip->i_ino, inum);
+		I_INO(ip), inum);
 	libxfs_dir2_data_put_ftype(mp, dep, ino_ftype);
 	libxfs_dir2_data_log_entry(da, bp, dep);
 	dir_hash_update_ftype(hashtab, addr, ino_ftype);
@@ -1540,7 +1540,7 @@ longform_dir2_entry_check_data(
 	struct xfs_da_args	da = {
 		.dp = ip,
 		.geo = mp->m_dir_geo,
-		.owner = ip->i_ino,
+		.owner = I_INO(ip),
 	};
 
 
@@ -1633,11 +1633,11 @@ longform_dir2_entry_check_data(
 		if (junkit) {
 			do_warn(
 	_("empty data block %u in directory inode %" PRIu64 ": "),
-				da_bno, ip->i_ino);
+				da_bno, I_INO(ip));
 		} else {
 			do_warn(_
 	("corrupt block %u in directory inode %" PRIu64 ": "),
-				da_bno, ip->i_ino);
+				da_bno, I_INO(ip));
 		}
 		if (!no_modify) {
 			do_warn(_("junking block\n"));
@@ -1663,7 +1663,7 @@ longform_dir2_entry_check_data(
 	if (be32_to_cpu(d->magic) != wantmagic) {
 		do_warn(
 	_("bad directory block magic # %#x for directory inode %" PRIu64 " block %d: "),
-			be32_to_cpu(d->magic), ip->i_ino, da_bno);
+			be32_to_cpu(d->magic), I_INO(ip), da_bno);
 		if (!no_modify) {
 			do_warn(_("fixing magic # to %#x\n"), wantmagic);
 			d->magic = cpu_to_be32(wantmagic);
@@ -1691,7 +1691,7 @@ longform_dir2_entry_check_data(
 			if (lastfree) {
 				do_warn(
 	_("directory inode %" PRIu64 " block %u has consecutive free entries: "),
-					ip->i_ino, da_bno);
+					I_INO(ip), da_bno);
 				if (!no_modify) {
 
 					do_warn(_("joining together\n"));
@@ -1737,7 +1737,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" in directory inode %" PRIu64 " points to non-existent inode %" PRIu64 ", "),
-					fname, ip->i_ino, inum, NULLFSINO)) {
+					fname, I_INO(ip), inum, NULLFSINO)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1754,7 +1754,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" in directory inode %" PRIu64 " points to free inode %" PRIu64 ", "),
-					fname, ip->i_ino, inum, NULLFSINO)) {
+					fname, I_INO(ip), inum, NULLFSINO)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1770,7 +1770,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 ", "),
-					fname, ip->i_ino, inum, NULLFSINO)) {
+					fname, I_INO(ip), inum, NULLFSINO)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1786,7 +1786,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 ", "),
-					fname, ip->i_ino, inum, NULLFSINO)) {
+					fname, I_INO(ip), inum, NULLFSINO)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1804,7 +1804,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("%s (ino %" PRIu64 ") in root (%" PRIu64 ") is not a directory, "),
-						ORPHANAGE, inum, ip->i_ino, NULLFSINO)) {
+						ORPHANAGE, inum, I_INO(ip), NULLFSINO)) {
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
 				}
@@ -1827,7 +1827,7 @@ longform_dir2_entry_check_data(
 			nbad++;
 			if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " already points to ino %" PRIu64 ", "),
-					fname, inum, ip->i_ino, dup_inum)) {
+					fname, inum, I_INO(ip), dup_inum)) {
 				dep->name[0] = '/';
 				libxfs_dir2_data_log_entry(&da, bp, dep);
 			}
@@ -1858,7 +1858,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("entry \"%s\" (ino %" PRIu64 ") in dir %" PRIu64 " is not in the the first block, "), fname,
-						inum, ip->i_ino, NULLFSINO)) {
+						inum, I_INO(ip), NULLFSINO)) {
 					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1881,7 +1881,7 @@ longform_dir2_entry_check_data(
 		 * '..' is already accounted for or will be taken care
 		 * of when directory is moved to orphanage.
 		 */
-		if (ip->i_ino == inum)  {
+		if (I_INO(ip) == inum)  {
 			ASSERT(no_modify ||
 			       (dep->name[0] == '.' && dep->namelen == 1));
 			add_inode_ref(current_irec, current_ino_offset);
@@ -1891,7 +1891,7 @@ longform_dir2_entry_check_data(
 				nbad++;
 				if (entry_junked(
 	_("entry \"%s\" in dir %" PRIu64 " is not the first entry, "),
-						fname, inum, ip->i_ino, NULLFSINO)) {
+						fname, inum, I_INO(ip), NULLFSINO)) {
 					dir_hash_junkit(hashtab, addr);
 					dep->name[0] = '/';
 					libxfs_dir2_data_log_entry(&da, bp, dep);
@@ -1944,8 +1944,8 @@ longform_dir2_entry_check_data(
 			junkit = 1;
 			do_warn(
 _("entry \"%s\" in dir %" PRIu64" points to an already connected directory inode %" PRIu64 "\n"),
-				fname, ip->i_ino, inum);
-		} else if (parent == ip->i_ino)  {
+				fname, I_INO(ip), inum);
+		} else if (parent == I_INO(ip))  {
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
 		} else if (parent == NULLFSINO) {
@@ -1953,8 +1953,8 @@ _("entry \"%s\" in dir %" PRIu64" points to an already connected directory inode
 			   so, set it as the parent and mark for rebuild */
 			do_warn(
 	_("entry \"%s\" in dir ino %" PRIu64 " doesn't have a .. entry, will set it in ino %" PRIu64 ".\n"),
-				fname, ip->i_ino, inum);
-			set_inode_parent(irec, ino_offset, ip->i_ino);
+				fname, I_INO(ip), inum);
+			set_inode_parent(irec, ino_offset, I_INO(ip));
 			add_inode_reached(irec, ino_offset);
 			add_inode_ref(current_irec, current_ino_offset);
 			add_dotdot_update(XFS_INO_TO_AGNO(mp, inum), irec,
@@ -1963,7 +1963,7 @@ _("entry \"%s\" in dir %" PRIu64" points to an already connected directory inode
 			junkit = 1;
 			do_warn(
 _("entry \"%s\" in dir inode %" PRIu64 " inconsistent with .. value (%" PRIu64 ") in ino %" PRIu64 "\n"),
-				fname, ip->i_ino, parent, inum);
+				fname, I_INO(ip), parent, inum);
 		}
 		if (junkit)  {
 			if (inum == orphanage_ino)
@@ -2086,12 +2086,12 @@ longform_dir2_check_leaf(
 	if (error == EFSBADCRC || error == EFSCORRUPTED || fixit) {
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad CRC\n"),
-			da_bno, ip->i_ino);
+			da_bno, I_INO(ip));
 		return 1;
 	} else if (error) {
 		do_error(
 	_("can't read block %u for directory inode %" PRIu64 ", error %d\n"),
-			da_bno, ip->i_ino, error);
+			da_bno, I_INO(ip), error);
 		/* NOTREACHED */
 	}
 
@@ -2108,13 +2108,13 @@ longform_dir2_check_leaf(
 				(char *)&ents[leafhdr.count] > (char *)bestsp) {
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
-			da_bno, ip->i_ino);
+			da_bno, I_INO(ip));
 		libxfs_buf_relse(bp);
 		return 1;
 	}
 
 	if (leafhdr.magic == XFS_DIR3_LEAF1_MAGIC) {
-		error = check_da3_header(mp, bp, ip->i_ino);
+		error = check_da3_header(mp, bp, I_INO(ip));
 		if (error) {
 			libxfs_buf_relse(bp);
 			return error;
@@ -2134,7 +2134,7 @@ longform_dir2_check_leaf(
 	if (badtail) {
 		do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad tail\n"),
-			da_bno, ip->i_ino);
+			da_bno, I_INO(ip));
 		libxfs_buf_relse(bp);
 		return 1;
 	}
@@ -2195,7 +2195,7 @@ longform_dir2_check_node(
 		if (error) {
 			do_warn(
 	_("can't read leaf block %u for directory inode %" PRIu64 ", error %d\n"),
-				da_bno, ip->i_ino, error);
+				da_bno, I_INO(ip), error);
 			return 1;
 		}
 		leaf = bp->b_addr;
@@ -2207,7 +2207,7 @@ longform_dir2_check_node(
 		      leafhdr.magic == XFS_DA3_NODE_MAGIC)) {
 			do_warn(
 	_("unknown magic number %#x for block %u in directory inode %" PRIu64 "\n"),
-				leafhdr.magic, da_bno, ip->i_ino);
+				leafhdr.magic, da_bno, I_INO(ip));
 			libxfs_buf_relse(bp);
 			return 1;
 		}
@@ -2215,7 +2215,7 @@ longform_dir2_check_node(
 		/* check v5 metadata */
 		if (leafhdr.magic == XFS_DIR3_LEAFN_MAGIC ||
 		    leafhdr.magic == XFS_DA3_NODE_MAGIC) {
-			error = check_da3_header(mp, bp, ip->i_ino);
+			error = check_da3_header(mp, bp, I_INO(ip));
 			if (error) {
 				libxfs_buf_relse(bp);
 				return error;
@@ -2238,7 +2238,7 @@ longform_dir2_check_node(
 		    leafhdr.count < leafhdr.stale) {
 			do_warn(
 	_("leaf block %u for directory inode %" PRIu64 " bad header\n"),
-				da_bno, ip->i_ino);
+				da_bno, I_INO(ip));
 			libxfs_buf_relse(bp);
 			return 1;
 		}
@@ -2270,7 +2270,7 @@ longform_dir2_check_node(
 		if (error) {
 			do_warn(
 	_("can't read freespace block %u for directory inode %" PRIu64 ", error %d\n"),
-				da_bno, ip->i_ino, error);
+				da_bno, I_INO(ip), error);
 			return 1;
 		}
 		free = bp->b_addr;
@@ -2285,13 +2285,13 @@ longform_dir2_check_node(
 		    freehdr.nvalid < freehdr.nused) {
 			do_warn(
 	_("free block %u for directory inode %" PRIu64 " bad header\n"),
-				da_bno, ip->i_ino);
+				da_bno, I_INO(ip));
 			libxfs_buf_relse(bp);
 			return 1;
 		}
 
 		if (freehdr.magic == XFS_DIR3_FREE_MAGIC) {
-			error = check_dir3_header(mp, bp, ip->i_ino);
+			error = check_dir3_header(mp, bp, I_INO(ip));
 			if (error) {
 				libxfs_buf_relse(bp);
 				return error;
@@ -2303,7 +2303,7 @@ longform_dir2_check_node(
 						be16_to_cpu(bests[i])) {
 				do_warn(
 	_("free block %u entry %i for directory ino %" PRIu64 " bad\n"),
-					da_bno, i, ip->i_ino);
+					da_bno, i, I_INO(ip));
 				libxfs_buf_relse(bp);
 				return 1;
 			}
@@ -2313,7 +2313,7 @@ longform_dir2_check_node(
 		if (used != freehdr.nused) {
 			do_warn(
 	_("free block %u for directory inode %" PRIu64 " bad nused\n"),
-				da_bno, ip->i_ino);
+				da_bno, I_INO(ip));
 			libxfs_buf_relse(bp);
 			return 1;
 		}
@@ -2324,7 +2324,7 @@ longform_dir2_check_node(
 		    (freetab->ents[i].v != NULLDATAOFF)) {
 			do_warn(
 	_("missing freetab entry %u for directory inode %" PRIu64 "\n"),
-				i, ip->i_ino);
+				i, I_INO(ip));
 			return 1;
 		}
 	}
@@ -2376,7 +2376,7 @@ longform_dir2_entry_check(
 	/* is this a block, leaf, or node directory? */
 	args.dp = ip;
 	args.geo = mp->m_dir_geo;
-	args.owner = ip->i_ino;
+	args.owner = I_INO(ip);
 	fmt = libxfs_dir2_format(&args, &error);
 
 	/* check directory "data" blocks (ie. name/inode pairs) */
@@ -2734,7 +2734,7 @@ shortform_dir2_entry_check(
 		    inode_is_meta(irec, ino_offset)) {
 			do_warn(
 	_("entry \"%s\" in regular dir %" PRIu64" points to a metadata inode %" PRIu64 ", "),
-					fname, ip->i_ino, lino);
+					fname, I_INO(ip), lino);
 			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
 						&max_size, &i, &bytes_deleted,
 						ino_dirty);
@@ -2749,7 +2749,7 @@ shortform_dir2_entry_check(
 		    !inode_is_meta(irec, ino_offset)) {
 			do_warn(
 	_("entry \"%s\" in metadata dir %" PRIu64" points to a regular inode %" PRIu64 ", "),
-					fname, ip->i_ino, lino);
+					fname, I_INO(ip), lino);
 			next_sfep = shortform_dir2_junk(mp, sfp, sfep, lino,
 						&max_size, &i, &bytes_deleted,
 						ino_dirty);
@@ -3000,7 +3000,7 @@ fix_dotdot(
 
 	libxfs_trans_ijoin(tp, ip, 0);
 
-	error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot, ip->i_ino,
+	error = -libxfs_dir_createname(tp, ip, &xfs_name_dotdot, I_INO(ip),
 			nres);
 	if (error)
 		do_error(
@@ -3133,7 +3133,7 @@ process_dir_inode(
 					do_error(
 _("error %d fixing shortform directory %llu\n"),
 						error,
-						(unsigned long long)ip->i_ino);
+						(unsigned long long)I_INO(ip));
 			} else  {
 				libxfs_trans_cancel(tp);
 			}
@@ -3189,7 +3189,7 @@ _("error %d fixing shortform directory %llu\n"),
 			libxfs_trans_ijoin(tp, ip, 0);
 
 			error = -libxfs_dir_createname(tp, ip, &xfs_name_dot,
-					ip->i_ino, nres);
+					I_INO(ip), nres);
 			if (error)
 				do_error(
 	_("can't make \".\" entry in dir ino %" PRIu64 ", createname error %d\n"),
@@ -3436,9 +3436,9 @@ reset_rt_metadir_inodes(
 		}
 
 		if (mp->m_rtdirip) {
-			mark_ino_inuse(mp, mp->m_rtdirip->i_ino, S_IFDIR,
-					mp->m_metadirip->i_ino);
-			mark_ino_metadata(mp, mp->m_rtdirip->i_ino);
+			mark_ino_inuse(mp, I_INO(mp->m_rtdirip), S_IFDIR,
+					I_INO(mp->m_metadirip));
+			mark_ino_metadata(mp, I_INO(mp->m_rtdirip));
 		}
 	}
 
@@ -3557,8 +3557,8 @@ _("Couldn't reset link count on %s quota inode, error %d\n"),
 	}
 
 	/* Mark the inode in use. */
-	mark_ino_inuse(mp, ip->i_ino, S_IFREG, dp->i_ino);
-	mark_ino_metadata(mp, ip->i_ino);
+	mark_ino_inuse(mp, I_INO(ip), S_IFREG, I_INO(dp));
+	mark_ino_metadata(mp, I_INO(ip));
 	libxfs_irele(ip);
 	return true;
 bad:
@@ -3584,8 +3584,8 @@ reset_quota_metadir_inodes(
 		do_error(_("failed to create quota metadir (%d)\n"),
 				error);
 
-	mark_ino_inuse(mp, dp->i_ino, S_IFDIR, mp->m_metadirip->i_ino);
-	mark_ino_metadata(mp, dp->i_ino);
+	mark_ino_inuse(mp, I_INO(dp), S_IFDIR, I_INO(mp->m_metadirip));
+	mark_ino_metadata(mp, I_INO(dp));
 
 	ensure_quota_file(dp, XFS_DQTYPE_USER);
 	ensure_quota_file(dp, XFS_DQTYPE_GROUP);
diff --git a/repair/pptr.c b/repair/pptr.c
index 39e7bb5030d02f..84cd27d62b7c0b 100644
--- a/repair/pptr.c
+++ b/repair/pptr.c
@@ -372,7 +372,7 @@ add_parent_ptr(
 	};
 	struct ag_pptr		ag_pptr = {
 		.child_agino	= XFS_INO_TO_AGINO(mp, ino),
-		.parent_ino	= dp->i_ino,
+		.parent_ino	= I_INO(dp),
 		.parent_gen	= VFS_I(dp)->i_generation,
 		.namelen	= dname.len,
 	};
@@ -407,7 +407,7 @@ add_parent_ptr(
 	dbg_printf(
  _("%s: dp %llu gen 0x%x fname '%s' namehash 0x%x ino %llu namecookie 0x%llx\n"),
 			__func__,
-			(unsigned long long)dp->i_ino,
+			(unsigned long long)I_INO(dp),
 			VFS_I(dp)->i_generation,
 			fname,
 			ag_pptr.namehash,
@@ -438,7 +438,7 @@ remove_garbage_xattrs(
 			.attr_filter	= ga->attr_filter,
 			.namelen	= ga->attrnamelen,
 			.valuelen	= ga->attrvaluelen,
-			.owner		= ip->i_ino,
+			.owner		= I_INO(ip),
 			.geo		= ip->i_mount->m_attr_geo,
 			.whichfork	= XFS_ATTR_FORK,
 			.op_flags	= XFS_DA_OP_OKNOENT | XFS_DA_OP_LOGGED,
@@ -452,7 +452,7 @@ remove_garbage_xattrs(
 				do_error(
  _("allocating %zu bytes to remove ino %llu garbage xattr failed: %s\n"),
 						desired,
-						(unsigned long long)ip->i_ino,
+						(unsigned long long)I_INO(ip),
 						strerror(errno));
 			bufsize = desired;
 		}
@@ -480,7 +480,7 @@ remove_garbage_xattrs(
 		if (error)
 			do_error(
  _("removing ino %llu garbage xattr failed: %s\n"),
-					(unsigned long long)ip->i_ino,
+					(unsigned long long)I_INO(ip),
 					strerror(error));
 	}
 
@@ -515,7 +515,7 @@ record_garbage_xattr(
 		if (!fscan->have_garbage)
 			do_warn(
  _("would delete garbage parent pointer extended attributes in ino %llu\n"),
-					(unsigned long long)ip->i_ino);
+					(unsigned long long)I_INO(ip));
 		fscan->have_garbage = true;
 		return;
 	}
@@ -526,7 +526,7 @@ record_garbage_xattr(
 
 	do_warn(
  _("deleting garbage parent pointer extended attributes in ino %llu\n"),
-			(unsigned long long)ip->i_ino);
+			(unsigned long long)I_INO(ip));
 
 	error = -init_slab(&fscan->garbage_xattr_recs,
 			sizeof(struct garbage_xattr));
@@ -547,20 +547,20 @@ record_garbage_xattr(
 			&garbage_xattr.attrname_cookie, name, namelen);
 	if (error)
 		do_error(_("storing ino %llu garbage xattr failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	error = -xfblob_store(fscan->garbage_xattr_names,
 			&garbage_xattr.attrvalue_cookie, value, valuelen);
 	if (error)
 		do_error(_("storing ino %llu garbage xattr failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	error = -slab_add(fscan->garbage_xattr_recs, &garbage_xattr);
 	if (error)
 		do_error(_("storing ino %llu garbage xattr rec failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 }
 
@@ -627,7 +627,7 @@ examine_xattr(
 	if (error)
 		do_error(
  _("storing ino %llu parent pointer '%.*s' failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				namelen,
 				(const char *)name,
 				strerror(error));
@@ -635,7 +635,7 @@ examine_xattr(
 	error = -slab_add(fscan->file_pptr_recs, &file_pptr);
 	if (error)
 		do_error(_("storing ino %llu parent pointer rec failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	dbg_printf(
@@ -647,7 +647,7 @@ examine_xattr(
 			(const char *)name,
 			namelen,
 			file_pptr.namehash,
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)file_pptr.name_cookie,
 			file_pptr.name_in_nameblobs);
 
@@ -690,7 +690,7 @@ add_file_pptr(
 
 	xfs_parent_rec_init(&pptr_rec, ag_pptr->parent_ino,
 			ag_pptr->parent_gen);
-	return -libxfs_parent_set(ip, ip->i_ino, &xname, &pptr_rec, &scratch);
+	return -libxfs_parent_set(ip, I_INO(ip), &xname, &pptr_rec, &scratch);
 }
 
 /* Remove an on disk parent pointer from a file. */
@@ -709,7 +709,7 @@ remove_file_pptr(
 
 	xfs_parent_rec_init(&pptr_rec, file_pptr->parent_ino,
 			file_pptr->parent_gen);
-	return -libxfs_parent_unset(ip, ip->i_ino, &xname, &pptr_rec, &scratch);
+	return -libxfs_parent_unset(ip, I_INO(ip), &xname, &pptr_rec, &scratch);
 }
 
 /* Remove all pptrs from @ip. */
@@ -724,17 +724,17 @@ clear_all_pptrs(
 
 	if (no_modify) {
 		do_warn(_("would delete unlinked ino %llu parent pointers\n"),
-				(unsigned long long)ip->i_ino);
+				(unsigned long long)I_INO(ip));
 		return;
 	}
 
 	do_warn(_("deleting unlinked ino %llu parent pointers\n"),
-			(unsigned long long)ip->i_ino);
+			(unsigned long long)I_INO(ip));
 
 	error = -init_slab_cursor(fscan->file_pptr_recs, NULL, &cur);
 	if (error)
 		do_error(_("init ino %llu pptr cursor failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	while ((file_pptr = pop_slab_cursor(cur)) != NULL) {
@@ -744,7 +744,7 @@ clear_all_pptrs(
 		if (error)
 			do_error(
   _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
-					(unsigned long long)ip->i_ino,
+					(unsigned long long)I_INO(ip),
 					(unsigned long long)file_pptr->parent_ino,
 					file_pptr->parent_gen,
 					(unsigned long long)file_pptr->name_cookie,
@@ -754,7 +754,7 @@ clear_all_pptrs(
 		if (error)
 			do_error(
  _("wiping ino %llu pptr (ino %llu gen 0x%x) failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				strerror(error));
@@ -778,7 +778,7 @@ add_missing_parent_ptr(
 	if (error)
 		do_error(
  _("loading missing name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)ag_pptr->parent_ino,
 				ag_pptr->parent_gen,
 				(unsigned long long)ag_pptr->name_cookie,
@@ -787,7 +787,7 @@ add_missing_parent_ptr(
 	if (no_modify) {
 		do_warn(
  _("would add missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)ag_pptr->parent_ino,
 				ag_pptr->parent_gen,
 				ag_pptr->namelen,
@@ -796,7 +796,7 @@ add_missing_parent_ptr(
 	} else {
 		do_warn(
  _("adding missing ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)ag_pptr->parent_ino,
 				ag_pptr->parent_gen,
 				ag_pptr->namelen,
@@ -807,7 +807,7 @@ add_missing_parent_ptr(
 	if (error)
 		do_error(
  _("adding ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)ag_pptr->parent_ino,
 			ag_pptr->parent_gen,
 			ag_pptr->namelen,
@@ -829,7 +829,7 @@ remove_incorrect_parent_ptr(
 	if (error)
 		do_error(
  _("loading incorrect name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx) failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				(unsigned long long)file_pptr->name_cookie,
@@ -838,7 +838,7 @@ remove_incorrect_parent_ptr(
 	if (no_modify) {
 		do_warn(
  _("would remove bad ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				file_pptr->namelen,
@@ -848,7 +848,7 @@ remove_incorrect_parent_ptr(
 
 	do_warn(
  _("removing bad ino %llu parent pointer (ino %llu gen 0x%x name '%.*s')\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)file_pptr->parent_ino,
 			file_pptr->parent_gen,
 			file_pptr->namelen,
@@ -858,7 +858,7 @@ remove_incorrect_parent_ptr(
 	if (error)
 		do_error(
  _("removing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)file_pptr->parent_ino,
 			file_pptr->parent_gen,
 			file_pptr->namelen,
@@ -886,7 +886,7 @@ compare_parent_ptrs(
 	if (error)
 		do_error(
  _("loading master-list name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx namelen %u) failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)ag_pptr->parent_ino,
 				ag_pptr->parent_gen,
 				(unsigned long long)ag_pptr->name_cookie,
@@ -897,7 +897,7 @@ compare_parent_ptrs(
 	if (error)
 		do_error(
  _("loading file-list name for ino %llu parent pointer (ino %llu gen 0x%x namecookie 0x%llx namelen %u) failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				(unsigned long long)file_pptr->name_cookie,
@@ -919,7 +919,7 @@ compare_parent_ptrs(
 	if (no_modify) {
 		do_warn(
  _("would update ino %llu parent pointer (ino %llu gen 0x%x name '%.*s') -> (ino %llu gen 0x%x name '%.*s')\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				file_pptr->namelen,
@@ -933,7 +933,7 @@ compare_parent_ptrs(
 
 	do_warn(
  _("updating ino %llu parent pointer (ino %llu gen 0x%x name '%.*s') -> (ino %llu gen 0x%x name '%.*s')\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)file_pptr->parent_ino,
 			file_pptr->parent_gen,
 			file_pptr->namelen,
@@ -948,7 +948,7 @@ compare_parent_ptrs(
 	if (error)
 		do_error(
 _("erasing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)file_pptr->parent_ino,
 			file_pptr->parent_gen,
 			file_pptr->namelen,
@@ -964,7 +964,7 @@ _("erasing ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
 	if (error && error != EEXIST)
 		do_error(
  _("updating ino %llu pptr (ino %llu gen 0x%x name '%.*s') failed: %s\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)ag_pptr->parent_ino,
 			ag_pptr->parent_gen,
 			ag_pptr->namelen,
@@ -1081,7 +1081,7 @@ crosscheck_file_parent_ptrs(
  _("found dirent referring to ino %llu even though inobt scan moved on to ino %llu?!\n"),
 				(unsigned long long)XFS_AGINO_TO_INO(mp, agno,
 					ag_pptr->child_agino),
-				(unsigned long long)ip->i_ino);
+				(unsigned long long)I_INO(ip));
 		/* does not return */
 	}
 
@@ -1096,7 +1096,7 @@ crosscheck_file_parent_ptrs(
 			&fscan->file_pptr_recs_cur);
 	if (error)
 		do_error(_("init ino %llu parent pointer cursor failed: %s\n"),
-				(unsigned long long)ip->i_ino, strerror(error));
+				(unsigned long long)I_INO(ip), strerror(error));
 
 	do {
 		int	cmp_result;
@@ -1114,7 +1114,7 @@ crosscheck_file_parent_ptrs(
 					(unsigned long long)ag_pptr->parent_ino,
 					ag_pptr->parent_gen,
 					ag_pptr->namelen,
-					(unsigned long long)ip->i_ino,
+					(unsigned long long)I_INO(ip),
 					(unsigned long long)ag_pptr->name_cookie);
 			prev_ag_pptr = ag_pptr;
 			advance_slab_cursor(fscan->ag_pptr_recs_cur);
@@ -1131,7 +1131,7 @@ crosscheck_file_parent_ptrs(
 				(unsigned long long)ag_pptr->parent_ino,
 				ag_pptr->parent_gen,
 				ag_pptr->namelen,
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)ag_pptr->name_cookie);
 
 		if (file_pptr) {
@@ -1141,13 +1141,13 @@ crosscheck_file_parent_ptrs(
 					(unsigned long long)file_pptr->parent_ino,
 					file_pptr->parent_gen,
 					file_pptr->namelen,
-					(unsigned long long)ip->i_ino,
+					(unsigned long long)I_INO(ip),
 					(unsigned long long)file_pptr->name_cookie);
 		} else {
 			dbg_printf(
  _("%s: ran out of parent pointers for ino %llu (file)\n"),
 					__func__,
-					(unsigned long long)ip->i_ino);
+					(unsigned long long)I_INO(ip));
 		}
 
 		cmp_result = cmp_file_to_ag_pptr(file_pptr, ag_pptr);
@@ -1188,7 +1188,7 @@ crosscheck_file_parent_ptrs(
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				file_pptr->namelen,
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)file_pptr->name_cookie);
 
 		/*
@@ -1223,11 +1223,11 @@ check_file_parent_ptrs(
 		libxfs_trans_cancel(tp);
 	if (error && !no_modify)
 		do_error(_("ino %llu parent pointer scan failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 	if (error) {
 		do_warn(_("ino %llu parent pointer scan failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 		goto out_free;
 	}
@@ -1361,20 +1361,20 @@ erase_pptrs(
 			&garbage_xattr.attrname_cookie, name, namelen);
 	if (error)
 		do_error(_("storing ino %llu garbage pptr failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	error = -xfblob_store(fscan->garbage_xattr_names,
 			&garbage_xattr.attrvalue_cookie, value, valuelen);
 	if (error)
 		do_error(_("storing ino %llu garbage pptr failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	error = -slab_add(fscan->garbage_xattr_recs, &garbage_xattr);
 	if (error)
 		do_error(_("storing ino %llu garbage pptr rec failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	return 0;
@@ -1399,7 +1399,7 @@ try_erase_parent_ptrs(
 	if (no_modify) {
 		do_warn(
  _("would delete garbage parent pointers in metadata ino %llu\n"),
-				(unsigned long long)ip->i_ino);
+				(unsigned long long)I_INO(ip));
 		return;
 	}
 
@@ -1423,7 +1423,7 @@ try_erase_parent_ptrs(
 		libxfs_trans_cancel(tp);
 	if (error)
 		do_warn(_("ino %llu garbage pptr collection failed: %s\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				strerror(error));
 
 	remove_garbage_xattrs(ip, &fscan);
diff --git a/repair/quotacheck.c b/repair/quotacheck.c
index f4c0314177b013..fc7e3864654cd4 100644
--- a/repair/quotacheck.c
+++ b/repair/quotacheck.c
@@ -169,7 +169,7 @@ qc_count_rtblocks(
 	if (error) {
 		do_warn(
 _("could not read ino %"PRIu64" extents, err=%d\n"),
-			ip->i_ino, error);
+			I_INO(ip), error);
 		chkd_flags = 0;
 		return 0;
 	}
@@ -375,7 +375,7 @@ qc_walk_dquot_extent(
 		if (error) {
 			do_warn(
 _("cannot read %s inode %"PRIu64", block %"PRIu64", disk block %"PRIu64", err=%d\n"),
-				qflags_typestr(dquots->type), ip->i_ino,
+				qflags_typestr(dquots->type), I_INO(ip),
 				map->br_startoff + bno,
 				map->br_startblock + bno, error);
 			chkd_flags = 0;
@@ -454,7 +454,7 @@ quotacheck_verify(
 	if (error) {
 		do_warn(
 	_("could not read %s inode %"PRIu64" extents, err=%d\n"),
-			qflags_typestr(type), ip->i_ino, error);
+			qflags_typestr(type), I_INO(ip), error);
 		chkd_flags = 0;
 		goto err;
 	}
@@ -659,7 +659,7 @@ mark_quota_inode(
 	if (error)
 		goto out_corrupt;
 
-	set_quota_inode(type, ip->i_ino);
+	set_quota_inode(type, I_INO(ip));
 	libxfs_irele(ip);
 	return 0;
 
diff --git a/repair/rt.c b/repair/rt.c
index 781d8968446c27..3e51c9b5eb4beb 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -268,7 +268,7 @@ check_rtfile_contents(
 		if (xfs_has_rtgroups(mp)) {
 			struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
-			if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+			if (hdr->rt_owner != cpu_to_be64(I_INO(ip))) {
 				do_warn(
  _("corrupt owner in %s at dblock 0x%llx\n"),
 					filename, (unsigned long long)bno);
@@ -461,12 +461,12 @@ mark_rtginode(
 		goto out_corrupt;
 
 	if (xfs_has_rtgroups(rtg_mount(rtg))) {
-		if (bitmap_test(rtg_inodes[type], ip->i_ino, 1)) {
+		if (bitmap_test(rtg_inodes[type], I_INO(ip), 1)) {
 			error = EFSCORRUPTED;
 			goto out_corrupt;
 		}
 
-		error = bitmap_set(rtg_inodes[type], ip->i_ino, 1);
+		error = bitmap_set(rtg_inodes[type], I_INO(ip), 1);
 		if (error)
 			goto out_corrupt;
 	}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 6b97a806384096..bc79bfc05a29b3 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -668,7 +668,7 @@ check_metadir_inode(
 
 	/* If we changed the metadir inode, try reloading it. */
 	if (!mp->m_metadirip ||
-	    mp->m_metadirip->i_ino != mp->m_sb.sb_metadirino) {
+	    I_INO(mp->m_metadirip) != mp->m_sb.sb_metadirino) {
 		if (mp->m_metadirip)
 			libxfs_irele(mp->m_metadirip);
 

