Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3CB4908D3
	for <linux-xfs@vger.kernel.org>; Thu,  3 Sep 2026 11:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435661; cv=none; b=NikXdl5iyovkLiJbY4wf4x05plnqRBo13dwmEOIJNR7mQ5A7ZIUPkxPqRNnCfBBP0OSVhwgoPtlIIkE1x1BOxk7Us2E/F3KuyLwCKMj0itzbUvk7LIayxAA83XR7GpwpeNP2X24aAhWbF1dLHS8WpXIcykaXeomrGDmTRJUhnG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435661; c=relaxed/simple;
	bh=ofFtFvH483JhF8pYUDs4sYze403rupL5aJoZlK4fvzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kYDiZDB3qkEUAJtxjqg6tMkSodysKx7hFpqZDMYkPshypCXyhxnAHRby5JYnCeoGSLJyh2ECjwgvntMAo69UAkcJIzJ5axrXf6X6vNhheWQY8/JdXMo4rIuD62Fo1HWjPK6O1+mIJ3QfK+nl6oev+7yuAUxU7aRXF5eiVtjaElM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebU41QS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebU41QS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE3C1F000E9;
	Thu,  3 Sep 2026 11:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435644;
	bh=q85NHXAeOTLvCTWmDhn4rO0bjRdF/dzU4Dr3TgQiapA=;
	h=From:To:Cc:Subject:Date;
	b=ebU41QS1OG9KukidJhVdovNoE0KEE7ZHGfbdC8eXx63LFS1XnAqLsVplvNhAcq8UK
	 IQfNSkQlHbPRO9zboDdmCV5iziS8yY0fmv0LOvGgHFWpxUpEDtRbtlpaLADVFBFD4V
	 yHBenqY0+RxO4JmxCwSmBt9A9BuLEj3gG7sZBSiPbMKkEU368ZrjRbQ0idz19UspVW
	 /nyzRsHpXqcRO+SnJQ/YRwuqq62mvWn6msnCYS3FRsFsA1vpNhFfZriSifAzwa37fm
	 vlw0moOUXbq9io06Qwma/s4FvJYUP/IOQCuFBbLC516Xiv6R+7ObttS6TxhaDvYBc2
	 QYiZva9UK8H/Q==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	aalbersh@kernel.org
Cc: bestswngs@gmail.com,
	brauner@kernel.org,
	cem@kernel.org,
	chuck.lever@oracle.com,
	cmaiolino@redhat.com,
	dawei.feng@seu.edu.cn,
	djwong@kernel.org,
	gaoyingjie@uniontech.com,
	hch@lst.de,
	jiapenglin@tencent.com,
	roland.mainz@nrubsig.org,
	xmei5@asu.edu
Subject: [PATCH v2 00/23] xfsprogs: libxfs sync for v7.2
Date: Thu,  3 Sep 2026 13:39:42 +0200
Message-ID: <20260903114022.570210-1-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This is v2 of libxfs sync for v7.1..v7.2.

This one is Darrick's v7.2 sync which I missed while preparing v1. On top of the
patchset I added "Fixes:" included in v7.2.

See Interdiff below.

Andrey Albershteyn (1):
  xfs: fix null pointer dereference in tracepoint

Christoph Hellwig (15):
  xfs: add a XFS_INODE_TO_AGNO helper
  xfs: add a XFS_INODE_TO_AGINO helper
  xfs: add a XFS_INO_TO_FSB helper
  xfs: add a xfs_rmap_inode_bmbt_owner
  xfs: add a xfs_rmap_inode_owner helper
  xfs: remove the i_ino field in struct xfs_inode
  xfs: cleanup xfs_imap
  xfs: remove im_len field in struct xfs_imap
  xfs: massage xfs_imap_to_bp into xfs_read_icluster
  xfs: store an agbno in struct xfs_imap
  xfs: mark struct xfs_imap as __packed
  xfs: pass back updated nb from xfs_growfs_compute_deltas
  xfs: cleanup xfs_growfs_compute_deltas
  xfs: move XFS_LSN_CMP to xfs_log_format.h
  xfs: check v5 superblock features early

Chuck Lever (1):
  xfs: Report case sensitivity in fileattr_get

Darrick J. Wong (2):
  libxfs: convert diff_items helpers to cmp_int
  xfs: fix pointer arithmetic error on 32-bit systems

Dawei Feng (1):
  xfs: fix memory leak in xfs_dqinode_metadir_create()

Lin Jiapeng (1):
  xfs: fix exchange-range reflink flag clearing issue with INO1_WRITTEN

Xiang Mei (1):
  xfs: fix off-by-one in rtrefcount btree root level validation

Yingjie Gao (1):
  xfs: fix exchmaps reservation limit check

 db/attrset.c                  |   2 +-
 db/bmap_inflate.c             |   4 +-
 db/dquot.c                    |   2 +-
 db/iunlink.c                  |  13 ++--
 db/namei.c                    |  14 ++--
 db/rdump.c                    |   2 +-
 include/linux.h               |  17 +++++
 include/xfs_inode.h           |   7 +-
 include/xfs_trans.h           |  18 -----
 libxfs/defer_item.c           |   8 +--
 libxfs/inode.c                |   8 +--
 libxfs/iunlink.c              |   4 +-
 libxfs/libxfs_api_defs.h      |   2 +-
 libxfs/listxattr.c            |   4 +-
 libxfs/logitem.c              |  17 +++--
 libxfs/util.c                 |   2 +-
 libxfs/xfs_ag.c               |  42 ++++++-----
 libxfs/xfs_ag.h               |   5 +-
 libxfs/xfs_attr.c             |   2 +-
 libxfs/xfs_attr_leaf.c        |   2 +-
 libxfs/xfs_bmap.c             |  20 +++---
 libxfs/xfs_bmap_btree.c       |   8 +--
 libxfs/xfs_bmap_btree.h       |   2 +-
 libxfs/xfs_btree.c            |  18 +++--
 libxfs/xfs_btree_staging.c    |   2 +-
 libxfs/xfs_da_btree.c         |   2 +-
 libxfs/xfs_defer.c            |   2 +-
 libxfs/xfs_dir2.c             |  44 ++++++------
 libxfs/xfs_dir2_node.c        |   2 +-
 libxfs/xfs_dir2_sf.c          |   4 +-
 libxfs/xfs_dquot_buf.c        |  14 +++-
 libxfs/xfs_exchmaps.c         |  20 ++++--
 libxfs/xfs_format.h           |   6 ++
 libxfs/xfs_ialloc.c           |  90 ++++++++++--------------
 libxfs/xfs_inode_buf.c        |  24 +++----
 libxfs/xfs_inode_buf.h        |  13 ++--
 libxfs/xfs_inode_fork.c       |   6 +-
 libxfs/xfs_inode_util.c       |  15 ++--
 libxfs/xfs_log_format.h       |  13 ++++
 libxfs/xfs_metadir.c          |   2 +-
 libxfs/xfs_parent.c           |   8 +--
 libxfs/xfs_parent.h           |   2 +-
 libxfs/xfs_rmap.c             |   6 +-
 libxfs/xfs_rmap.h             |   4 ++
 libxfs/xfs_rtbitmap.c         |   4 +-
 libxfs/xfs_rtrefcount_btree.c |   8 +--
 libxfs/xfs_rtrmap_btree.c     |   4 +-
 libxfs/xfs_sb.c               |   6 +-
 libxfs/xfs_symlink_remote.c   |   6 +-
 mkfs/proto.c                  |  16 ++---
 repair/bmap_repair.c          |  12 ++--
 repair/bulkload.c             |   2 +-
 repair/phase6.c               | 128 +++++++++++++++++-----------------
 repair/pptr.c                 | 100 +++++++++++++-------------
 repair/quotacheck.c           |   8 +--
 repair/rt.c                   |   6 +-
 repair/rtrefcount_repair.c    |   2 +-
 repair/rtrmap_repair.c        |   2 +-
 repair/xfs_repair.c           |   2 +-
 59 files changed, 422 insertions(+), 386 deletions(-)

Interdiff against v1:
diff --git a/db/attrset.c b/db/attrset.c
index 273c20295600..ec51ce2e0775 100644
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
index cc7c197e788d..13891896fc8b 100644
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
index c028d50e4ca4..0c1ebf4e7907 100644
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
index c73f818242b9..447d2859b104 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -22,8 +22,8 @@ count_rtblocks(
 	if (error) {
 		dbprintf(
 _("could not read AG %u agino %u extents, err=%d\n"),
-				XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino),
-				XFS_INO_TO_AGINO(ip->i_mount, ip->i_ino),
+				XFS_INODE_TO_AGNO(ip),
+				XFS_INODE_TO_AGINO(ip),
 				error);
 		return 0;
 	}
@@ -43,6 +43,7 @@ get_next_unlinked(
 	struct xfs_buf		*ino_bp;
 	struct xfs_dinode	*dip;
 	struct xfs_inode	*ip;
+	struct xfs_perag	*pag;
 	xfs_ino_t		ino;
 	xfs_agino_t		ret;
 	int			error;
@@ -65,7 +66,9 @@ get_next_unlinked(
 		dbprintf("\n");
 	}
 
-	error = -libxfs_imap_to_bp(mp, NULL, &ip->i_imap, &ino_bp);
+	pag = libxfs_perag_get(mp, agno);
+	error = -libxfs_read_icluster(pag, NULL, ip->i_imap.im_agbno, &ino_bp);
+	libxfs_perag_put(pag);
 	if (error) {
 		libxfs_irele(ip);
 		goto bad;
@@ -246,8 +249,8 @@ create_unlinked(
 		dbprintf(_("commit inode: %s\n"), strerror(error));
 
 	dbprintf(_("Created unlinked inode %llu in agno %u\n"),
-			(unsigned long long)ip->i_ino,
-			XFS_INO_TO_AGNO(mp, ip->i_ino));
+			(unsigned long long)I_INO(ip),
+			XFS_INODE_TO_AGNO(ip));
 	libxfs_irele(ip);
 	return error;
 out_rele:
diff --git a/db/namei.c b/db/namei.c
index 0a50ec87df9f..6e5d0ac46360 100644
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
index 599d0727e788..7fd171a9d53f 100644
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
diff --git a/include/linux.h b/include/linux.h
index 8972c9596c75..a10d531cffdb 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -258,6 +258,23 @@ struct file_attr {
 #define FS_XFLAG_COWEXTSIZE	0x00010000	/* CoW extent size allocator hint */
 #endif
 
+#ifndef FS_XFLAG_VERITY
+#define FS_XFLAG_VERITY		0x00020000	/* fs-verity enabled */
+#endif
+
+/*
+ * Case handling flags (read-only, cannot be set via ioctl).
+ * Default (neither set) indicates POSIX semantics: case-sensitive
+ * lookups and case-preserving storage.
+ */
+#ifndef FS_XFLAG_CASEFOLD
+#define FS_XFLAG_CASEFOLD	0x00040000	/* case-insensitive lookups */
+#endif
+
+#ifndef FS_XFLAG_CASENONPRESERVING
+#define FS_XFLAG_CASENONPRESERVING 0x00080000	/* case not preserved */
+#endif
+
 /* Atomic Write */
 #ifndef RWF_ATOMIC
 #define RWF_ATOMIC	((__kernel_rwf_t)0x00000040)
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 61d4d285a106..f07a34ec5d46 100644
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
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index d4b546a0e3d0..9102bc6f5b27 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -164,22 +164,4 @@ libxfs_trans_read_buf(
 #define xfs_ail_get_push_target(ail)    \
 		((log) == (log) ? NULLCOMMITLSN : NULLCOMMITLSN)
 
-/* from xfs_log.h */
-/*
- * By comparing each component, we don't have to worry about extra
- * endian issues in treating two 32 bit numbers as one 64 bit number
- */
-static inline xfs_lsn_t _lsn_cmp(xfs_lsn_t lsn1, xfs_lsn_t lsn2)
-{
-	if (CYCLE_LSN(lsn1) != CYCLE_LSN(lsn2))
-		return (CYCLE_LSN(lsn1)<CYCLE_LSN(lsn2))? -999 : 999;
-
-	if (BLOCK_LSN(lsn1) != BLOCK_LSN(lsn2))
-		return (BLOCK_LSN(lsn1)<BLOCK_LSN(lsn2))? -999 : 999;
-
-	return 0;
-}
-
-#define XFS_LSN_CMP(a, b)			_lsn_cmp(a, b)
-
 #endif	/* __XFS_TRANS_H__ */
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 4fc2c74a548c..14ee41525517 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -50,7 +50,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
+	return cmp_int(ra->xefi_group->xg_gno, rb->xefi_group->xg_gno);
 }
 
 /* Get an EFI. */
@@ -252,7 +252,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Get an RUI. */
@@ -404,7 +404,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
+	return cmp_int(ra->ri_group->xg_gno, rb->ri_group->xg_gno);
 }
 
 /* Get an CUI. */
@@ -563,7 +563,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return ba->bi_owner->i_ino - bb->bi_owner->i_ino;
+	return cmp_int(I_INO(ba->bi_owner), I_INO(bb->bi_owner));
 }
 
 /* Get an BUI. */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index dc7e227e8ee9..b6838d3d4bd3 100644
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
@@ -159,8 +159,8 @@ libxfs_iget(
 	ip->i_prev_unlinked = NULLAGINO;
 	spin_lock_init(&VFS_I(ip)->i_lock);
 
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, 0);
+	pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
+	error = xfs_imap(pag, tp, I_INO(ip), &ip->i_imap, 0);
 	xfs_perag_put(pag);
 
 	if (error)
@@ -182,7 +182,7 @@ libxfs_iget(
 	} else {
 		struct xfs_buf		*bp;
 
-		error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &bp);
+		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
 		if (error)
 			goto out_destroy;
 
diff --git a/libxfs/iunlink.c b/libxfs/iunlink.c
index 2d4dd0aee0b8..875e0caae988 100644
--- a/libxfs/iunlink.c
+++ b/libxfs/iunlink.c
@@ -44,7 +44,7 @@ xfs_iunlink_log_dinode(
 	int			offset;
 	int			error;
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
+	error = xfs_read_icluster(iup->pag, tp, ip->i_imap.im_agbno, &ibp);
 	if (error)
 		return error;
 	/*
@@ -66,7 +66,7 @@ xfs_iunlink_log_dinode(
 	}
 
 	trace_xfs_iunlink_update_dinode(mp, pag_agno(iup->pag),
-					XFS_INO_TO_AGINO(mp, ip->i_ino),
+					XFS_INODE_TO_AGINO(ip),
 					be32_to_cpu(dip->di_next_unlinked),
 					iup->next_agino);
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index d7c912e77879..4f542ae7267e 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -200,7 +200,7 @@
 #define xfs_iext_lookup_extent		libxfs_iext_lookup_extent
 #define xfs_iext_next			libxfs_iext_next
 #define xfs_ifork_zap_attr		libxfs_ifork_zap_attr
-#define xfs_imap_to_bp			libxfs_imap_to_bp
+#define xfs_read_icluster		libxfs_read_icluster
 
 #define xfs_initialize_perag		libxfs_initialize_perag
 #define xfs_initialize_perag_data	libxfs_initialize_perag_data
diff --git a/libxfs/listxattr.c b/libxfs/listxattr.c
index 34205682f022..fb6f1d53b9d8 100644
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
index d8d86d919cf4..6e56e476d1ea 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -16,6 +16,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_ag.h"
 
 struct kmem_cache	*xfs_buf_item_cache;
 struct kmem_cache	*xfs_ili_cache;		/* inode log item cache */
@@ -140,7 +141,7 @@ static uint64_t
 xfs_inode_item_sort(
 	struct xfs_log_item	*lip)
 {
-	return INODE_ITEM(lip)->ili_inode->i_ino;
+	return I_INO(INODE_ITEM(lip)->ili_inode);
 }
 
 /*
@@ -180,6 +181,7 @@ xfs_inode_item_precommit(
 {
 	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
 	struct xfs_inode	*ip = iip->ili_inode;
+	struct xfs_mount	*mp = ip->i_mount;
 	struct inode		*inode = VFS_I(ip);
 	unsigned int		flags = iip->ili_dirty_flags;
 
@@ -200,7 +202,7 @@ xfs_inode_item_precommit(
 	 * to upgrade this inode to bigtime format, do so now.
 	 */
 	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
-	    xfs_has_bigtime(ip->i_mount) &&
+	    xfs_has_bigtime(mp) &&
 	    !xfs_inode_has_bigtime(ip)) {
 		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
 		flags |= XFS_ILOG_CORE;
@@ -214,7 +216,7 @@ xfs_inode_item_precommit(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
-	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
+	    xfs_extlen_to_rtxmod(mp, ip->i_extsize) > 0) {
 		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
 				   XFS_DIFLAG_EXTSZINHERIT);
 		ip->i_extsize = 0;
@@ -241,13 +243,14 @@ xfs_inode_item_precommit(
 	 */
 	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
 	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
-	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
+	    xfs_extlen_to_rtxmod(mp, ip->i_cowextsize) > 0) {
 		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
 		ip->i_cowextsize = 0;
 		flags |= XFS_ILOG_CORE;
 	}
 
 	if (!iip->ili_item.li_buf) {
+		struct xfs_perag *pag;
 		struct xfs_buf	*bp;
 		int		error;
 
@@ -261,7 +264,9 @@ xfs_inode_item_precommit(
 		 * here.
 		 */
 		spin_unlock(&iip->ili_lock);
-		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
+		pag = xfs_perag_get(mp, XFS_INODE_TO_AGNO(ip));
+		error = xfs_read_icluster(pag, tp, ip->i_imap.im_agbno, &bp);
+		xfs_perag_put(pag);
 		if (error)
 			return error;
 
@@ -316,7 +321,7 @@ xfs_inode_item_init(
 	iip = ip->i_itemp = kmem_cache_zalloc(xfs_ili_cache, 0);
 #ifdef LI_DEBUG
 	fprintf(stderr, "inode_item_init for inode %llu, iip=%p\n",
-		ip->i_ino, iip);
+		I_INO(ip), iip);
 #endif
 
 	spin_lock_init(&iip->ili_lock);
diff --git a/libxfs/util.c b/libxfs/util.c
index 143d011ac60d..6cbbe9056eba 100644
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
diff --git a/mkfs/proto.c b/mkfs/proto.c
index dd47e41d833e..bdd0fadda517 100644
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
index 192f189de052..dfdce1a0e01f 100644
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
@@ -576,7 +576,7 @@ xrep_bmap_build_new_fork(
 	 * Prepare to construct the new fork by initializing the new btree
 	 * structure and creating a fake ifork in the ifakeroot structure.
 	 */
-	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, rb->whichfork);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, rb->whichfork);
 	bulkload_init_inode(&rb->new_fork_info, sc, rb->whichfork, &oinfo);
 	bmap_cur = libxfs_bmbt_init_cursor(sc->mp, NULL, sc->ip,
 			XFS_STAGING_FORK);
@@ -740,6 +740,7 @@ rebuild_bmap(
 		.mp		= mp,
 	};
 	const struct xfs_buf_ops *bp_ops;
+	struct xfs_perag	*pag;
 	unsigned long		boffset;
 	unsigned long long	resblks;
 	xfs_daddr_t		bp_bn;
@@ -821,7 +822,10 @@ rebuild_bmap(
 	 * Rebuilding the inode fork rolled the transaction, so we need to
 	 * re-grab the inode cluster buffer and dinode pointer for the caller.
 	 */
-	err2 = -libxfs_imap_to_bp(mp, NULL, &sc.ip->i_imap, ino_bpp);
+	pag = libxfs_perag_get(mp, XFS_INODE_TO_AGNO(sc.ip));
+	err2 = -libxfs_read_icluster(pag, NULL, sc.ip->i_imap.im_agbno,
+			ino_bpp);
+	libxfs_perag_put(pag);
 	if (err2)
 		do_error(
  _("Unable to re-grab inode cluster buffer after failed repair of inode %llu, error %d.\n"),
diff --git a/repair/bulkload.c b/repair/bulkload.c
index a9e51de0a24c..6bc110071f02 100644
--- a/repair/bulkload.c
+++ b/repair/bulkload.c
@@ -32,7 +32,7 @@ bulkload_init_inode(
 	int				whichfork,
 	const struct xfs_owner_info	*oinfo)
 {
-	bulkload_init_ag(bkl, sc, oinfo, XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino));
+	bulkload_init_ag(bkl, sc, oinfo, XFS_INODE_TO_FSB(sc->ip));
 	bkl->ifake.if_fork = kmem_cache_zalloc(xfs_ifork_cache, 0);
 	bkl->ifake.if_fork_size = xfs_inode_fork_size(sc->ip, whichfork);
 }
diff --git a/repair/phase6.c b/repair/phase6.c
index 75429d4ca111..326fdfa3afb4 100644
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
index 6a9e072b360d..84cd27d62b7c 100644
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
@@ -547,20 +547,20 @@ stuffit:
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
@@ -919,7 +919,7 @@ reset:
 	if (no_modify) {
 		do_warn(
  _("would update ino %llu parent pointer (ino %llu gen 0x%x name '%.*s') -> (ino %llu gen 0x%x name '%.*s')\n"),
-				(unsigned long long)ip->i_ino,
+				(unsigned long long)I_INO(ip),
 				(unsigned long long)file_pptr->parent_ino,
 				file_pptr->parent_gen,
 				file_pptr->namelen,
@@ -933,7 +933,7 @@ reset:
 
 	do_warn(
  _("updating ino %llu parent pointer (ino %llu gen 0x%x name '%.*s') -> (ino %llu gen 0x%x name '%.*s')\n"),
-			(unsigned long long)ip->i_ino,
+			(unsigned long long)I_INO(ip),
 			(unsigned long long)file_pptr->parent_ino,
 			file_pptr->parent_gen,
 			file_pptr->namelen,
@@ -948,7 +948,7 @@ reset:
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
@@ -1050,8 +1050,8 @@ crosscheck_file_parent_ptrs(
 	struct ag_pptr		*ag_pptr, *prev_ag_pptr = NULL;
 	struct file_pptr	*file_pptr;
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agnumber_t		agno = XFS_INODE_TO_AGNO(ip);
+	xfs_agino_t		agino = XFS_INODE_TO_AGINO(ip);
 	int			error;
 
 	ag_pptr = peek_slab_cursor(fscan->ag_pptr_recs_cur);
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
index f4c0314177b0..fc7e3864654c 100644
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
index 781d8968446c..3e51c9b5eb4b 100644
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
diff --git a/repair/rtrefcount_repair.c b/repair/rtrefcount_repair.c
index 228d080e5a5d..7906af17e893 100644
--- a/repair/rtrefcount_repair.c
+++ b/repair/rtrefcount_repair.c
@@ -173,7 +173,7 @@ xrep_rtrefc_build_new_tree(
 	 * Prepare to construct the new fork by initializing the new btree
 	 * structure and creating a fake ifork in the ifakeroot structure.
 	 */
-	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
 	bulkload_init_inode(&rr->new_fork_info, sc, XFS_DATA_FORK, &oinfo);
 	cur = libxfs_rtrefcountbt_init_cursor(NULL, rr->rtg);
 	libxfs_btree_stage_ifakeroot(cur, ifake);
diff --git a/repair/rtrmap_repair.c b/repair/rtrmap_repair.c
index 955db1738fe2..136fafc01024 100644
--- a/repair/rtrmap_repair.c
+++ b/repair/rtrmap_repair.c
@@ -211,7 +211,7 @@ xrep_rtrmap_build_new_tree(
 	 * Prepare to construct the new fork by initializing the new btree
 	 * structure and creating a fake ifork in the ifakeroot structure.
 	 */
-	libxfs_rmap_ino_bmbt_owner(&oinfo, sc->ip->i_ino, XFS_DATA_FORK);
+	xfs_rmap_inode_bmbt_owner(&oinfo, sc->ip, XFS_DATA_FORK);
 	bulkload_init_inode(&rr->new_fork_info, sc, XFS_DATA_FORK, &oinfo);
 	cur = libxfs_rtrmapbt_init_cursor(NULL, rr->rtg);
 	libxfs_btree_stage_ifakeroot(cur, ifake);
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index dd758ebc577e..2ad1ee8b4aa7 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -670,7 +670,7 @@ check_metadir_inode(
 
 	/* If we changed the metadir inode, try reloading it. */
 	if (!mp->m_metadirip ||
-	    mp->m_metadirip->i_ino != mp->m_sb.sb_metadirino) {
+	    I_INO(mp->m_metadirip) != mp->m_sb.sb_metadirino) {
 		if (mp->m_metadirip)
 			libxfs_irele(mp->m_metadirip);
 
-- 
2.55.0

