Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCD548A2A0
	for <linux-xfs@vger.kernel.org>; Fri, 15 May 2026 13:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778853104; cv=none; b=d9i5UnK+gZc4GmvcjBTWaSGzigW+pIXPHDBP/TEsnHwqGedY78viqvmpm8yg2JNy1b6CaEH6MsKJ6HQkyhjHfaXMxwCIQShqyEF+9Oeis7FlyM0d5daXKjoDEHfHdUzMNYFFcbDJ+yJP5wgq4MtK98023vOd3lyGlxc6TVDhp40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778853104; c=relaxed/simple;
	bh=GwG3HbnIPCP02+rcP3surMXuxMozFCYmKGsfM9VIWuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2efdCyb/DkezuA41Y6KDbK4fmgQEQPGjQNz339hYwPv6oWJX/X42RjvDFFVplmxFtG7dIFpnIvmTkk1CC3rmvPAbkhHYfwRemrpDklEiW1sN7B2nKBR9TAKFWe/nOP9PtiAocCuylSZWegS9pB0vcRytDHpe3s6ZFGQ/6h3M80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i9ZoowER; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i9ZoowER"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=yO49HPHuZqW3fIbmd+bou2BK8rBC7SDYcw+TDjfOijU=; b=i9ZoowER15aBpFp8VFpO9HtAPx
	bIgEpZ0ZXnZvBup8C/8Kvb/IIVeVX0PLbMzA+JmtQkRJvDZgYRfQmNoko6LqQthAXfs/iMqfJjaDi
	ndLhd6XqUD/kCJftkfVN32zbnVwKjs3hDsmqoLSks/AiW1aHDVDdoNM0K2gokkk2qPwh7RftwU0Mm
	Gn/TrR5PjKn04iaGk6CxaDpNnjElA6pMYDxsZca4ZPO1mT7eLNzYEWXdMJKyoGLmG0WnrjOuWgJuu
	FfTCaFwPnXxhVOl99pxVhJABn/PnACb15z/beDOpenfuUmBGw0A+9s6udzb1vnuVi9xkc8K8wWd6W
	3D2V9DoQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNsww-00000008UdG-2Eg1;
	Fri, 15 May 2026 13:51:35 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 9/9] xfs: remove the i_ino field in struct xfs_inode
Date: Fri, 15 May 2026 15:50:30 +0200
Message-ID: <20260515135103.4042407-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260515135103.4042407-1-hch@lst.de>
References: <20260515135103.4042407-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that the VFS inode has a u64 i_ino field, there is no need to store
a copy of the inode number in the xfs_inode structure.

Introduce an I_INO() wrapper as a shortcut to the inode number so that
we don't have to propagate the VFS inode everywhere.

The only non-obvious part is the clearing of i_ino to 0 for RCU freeing
the inode.  None of this calls into VFS paths, which makes clearing the
VFS inode field here just as safe as clearing the old field in the
xfs_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c             |   2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c        |   2 +-
 fs/xfs/libxfs/xfs_bmap.c             |   6 +-
 fs/xfs/libxfs/xfs_bmap_btree.c       |   4 +-
 fs/xfs/libxfs/xfs_btree.c            |   8 +-
 fs/xfs/libxfs/xfs_btree_staging.c    |   2 +-
 fs/xfs/libxfs/xfs_da_btree.c         |   2 +-
 fs/xfs/libxfs/xfs_dir2.c             |  40 +++++-----
 fs/xfs/libxfs/xfs_dir2_node.c        |   2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c          |   4 +-
 fs/xfs/libxfs/xfs_exchmaps.c         |   8 +-
 fs/xfs/libxfs/xfs_format.h           |   6 +-
 fs/xfs/libxfs/xfs_ialloc.c           |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c        |   4 +-
 fs/xfs/libxfs/xfs_inode_fork.c       |   6 +-
 fs/xfs/libxfs/xfs_inode_util.c       |   6 +-
 fs/xfs/libxfs/xfs_metadir.c          |   2 +-
 fs/xfs/libxfs/xfs_parent.c           |   8 +-
 fs/xfs/libxfs/xfs_parent.h           |   2 +-
 fs/xfs/libxfs/xfs_rmap.c             |   6 +-
 fs/xfs/libxfs/xfs_rmap.h             |   4 +-
 fs/xfs/libxfs/xfs_rtbitmap.c         |   4 +-
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |   4 +-
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c   |   6 +-
 fs/xfs/scrub/agheader_repair.c       |   2 +-
 fs/xfs/scrub/attr.c                  |   4 +-
 fs/xfs/scrub/attr_repair.c           |  16 ++--
 fs/xfs/scrub/bmap.c                  |   8 +-
 fs/xfs/scrub/bmap_repair.c           |   4 +-
 fs/xfs/scrub/common.c                |  12 +--
 fs/xfs/scrub/common.h                |   2 +-
 fs/xfs/scrub/dabtree.c               |   4 +-
 fs/xfs/scrub/dir.c                   |  22 +++---
 fs/xfs/scrub/dir_repair.c            |  40 +++++-----
 fs/xfs/scrub/dirtree.c               |  16 ++--
 fs/xfs/scrub/dirtree_repair.c        |   4 +-
 fs/xfs/scrub/findparent.c            |  33 ++++----
 fs/xfs/scrub/inode.c                 |  12 +--
 fs/xfs/scrub/inode_repair.c          |   2 +-
 fs/xfs/scrub/iscan.c                 |   2 +-
 fs/xfs/scrub/listxattr.c             |  10 +--
 fs/xfs/scrub/metapath.c              |  10 +--
 fs/xfs/scrub/nlinks.c                |  20 ++---
 fs/xfs/scrub/nlinks_repair.c         |   4 +-
 fs/xfs/scrub/orphanage.c             |  10 +--
 fs/xfs/scrub/parent.c                |  25 +++----
 fs/xfs/scrub/parent_repair.c         |  16 ++--
 fs/xfs/scrub/quotacheck.c            |   2 +-
 fs/xfs/scrub/readdir.c               |  12 +--
 fs/xfs/scrub/repair.c                |   2 +-
 fs/xfs/scrub/rmap_repair.c           |   2 +-
 fs/xfs/scrub/rtbitmap_repair.c       |   2 +-
 fs/xfs/scrub/rtrefcount_repair.c     |   2 +-
 fs/xfs/scrub/rtrmap_repair.c         |   4 +-
 fs/xfs/scrub/rtsummary_repair.c      |   2 +-
 fs/xfs/scrub/scrub.c                 |   2 +-
 fs/xfs/scrub/symlink_repair.c        |   8 +-
 fs/xfs/scrub/tempfile.c              |   2 +-
 fs/xfs/scrub/trace.h                 |  98 ++++++++++++------------
 fs/xfs/xfs_aops.c                    |   2 +-
 fs/xfs/xfs_attr_item.c               |   4 +-
 fs/xfs/xfs_attr_list.c               |  12 +--
 fs/xfs/xfs_bmap_item.c               |   4 +-
 fs/xfs/xfs_bmap_util.c               |   4 +-
 fs/xfs/xfs_dir2_readdir.c            |   4 +-
 fs/xfs/xfs_error.c                   |   2 +-
 fs/xfs/xfs_exchmaps_item.c           |   4 +-
 fs/xfs/xfs_exchrange.c               |   4 +-
 fs/xfs/xfs_export.c                  |   8 +-
 fs/xfs/xfs_filestream.c              |   6 +-
 fs/xfs/xfs_handle.c                  |   4 +-
 fs/xfs/xfs_healthmon.c               |   6 +-
 fs/xfs/xfs_icache.c                  |  25 ++++---
 fs/xfs/xfs_inode.c                   |  26 +++----
 fs/xfs/xfs_inode.h                   |  12 ++-
 fs/xfs/xfs_inode_item.c              |   8 +-
 fs/xfs/xfs_inode_item_recover.c      |   4 +-
 fs/xfs/xfs_ioctl.c                   |   2 +-
 fs/xfs/xfs_iomap.c                   |   4 +-
 fs/xfs/xfs_iops.c                    |   3 +-
 fs/xfs/xfs_iunlink_item.c            |   2 +-
 fs/xfs/xfs_mount.c                   |   2 +-
 fs/xfs/xfs_qm.c                      |  10 +--
 fs/xfs/xfs_quotaops.c                |   2 +-
 fs/xfs/xfs_reflink.c                 |   4 +-
 fs/xfs/xfs_symlink.c                 |   6 +-
 fs/xfs/xfs_trace.h                   | 108 +++++++++++++--------------
 fs/xfs/xfs_trans.c                   |   2 +-
 fs/xfs/xfs_trans_dquot.c             |   6 +-
 fs/xfs/xfs_xattr.c                   |   2 +-
 91 files changed, 427 insertions(+), 425 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 93caa1dae501..b3f7b2c34ad7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -276,7 +276,7 @@ xfs_attr_get(
 		return -EIO;
 
 	if (!args->owner)
-		args->owner = args->dp->i_ino;
+		args->owner = I_INO(args->dp);
 	args->geo = args->dp->i_mount->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2b78041e8672..86c5c09a5db4 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1429,7 +1429,7 @@ xfs_attr3_leaf_init(
 	struct xfs_da_args	args = {
 		.trans		= tp,
 		.dp		= dp,
-		.owner		= dp->i_ino,
+		.owner		= I_INO(dp),
 		.geo		= dp->i_mount->m_attr_geo,
 	};
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9920e2df62b0..d64defeda645 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -974,7 +974,7 @@ xfs_bmap_add_attrfork_local(
 		dargs.total = dargs.geo->fsbcount;
 		dargs.whichfork = XFS_DATA_FORK;
 		dargs.trans = tp;
-		dargs.owner = ip->i_ino;
+		dargs.owner = I_INO(ip);
 		return xfs_dir2_sf_to_block(&dargs);
 	}
 
@@ -1108,7 +1108,7 @@ xfs_bmap_complain_bad_rec(
 
 	xfs_warn(mp,
  "Bmap BTree record corruption in inode 0x%llx %s fork detected at %pS!",
-				ip->i_ino, forkname, fa);
+				I_INO(ip), forkname, fa);
 	xfs_warn(mp,
 		"Offset 0x%llx, start block 0x%llx, block count 0x%llx state 0x%x",
 		irec->br_startoff, irec->br_startblock, irec->br_blockcount,
@@ -1141,7 +1141,7 @@ xfs_iread_bmbt_block(
 	num_recs = xfs_btree_get_numrecs(block);
 	if (unlikely(ir->loaded + num_recs > ifp->if_nextents)) {
 		xfs_warn(ip->i_mount, "corrupt dinode %llu, (btree extents).",
-				(unsigned long long)ip->i_ino);
+				(unsigned long long)I_INO(ip));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, block,
 				sizeof(*block), __this_address);
 		xfs_bmap_mark_sick(ip, whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 8683574566e2..758a4b1ccf5b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -36,10 +36,10 @@ xfs_bmbt_init_block(
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
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index ea85c5fbe531..60ef7f08b1d3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -371,7 +371,7 @@ xfs_btree_check_ptr(
 		case XFS_BTREE_TYPE_INODE:
 			xfs_err(cur->bc_mp,
 "Inode %llu fork %d: Corrupt %sbt pointer at level %d index %d.",
-				cur->bc_ino.ip->i_ino,
+				I_INO(cur->bc_ino.ip),
 				cur->bc_ino.whichfork, cur->bc_ops->name,
 				level, index);
 			break;
@@ -1305,7 +1305,7 @@ xfs_btree_owner(
 	case XFS_BTREE_TYPE_MEM:
 		return cur->bc_mem.xfbtree->owner;
 	case XFS_BTREE_TYPE_INODE:
-		return cur->bc_ino.ip->i_ino;
+		return I_INO(cur->bc_ino.ip);
 	case XFS_BTREE_TYPE_AG:
 		return cur->bc_group->xg_gno;
 	default:
@@ -3129,7 +3129,7 @@ xfs_btree_promote_leaf_iroot(
 	 */
 	broot = cur->bc_ops->broot_realloc(cur, 1);
 	xfs_btree_init_block(cur->bc_mp, broot, cur->bc_ops,
-			cur->bc_nlevels - 1, 1, cur->bc_ino.ip->i_ino);
+			cur->bc_nlevels - 1, 1, I_INO(cur->bc_ino.ip));
 
 	pp = xfs_btree_ptr_addr(cur, 1, broot);
 	kp = xfs_btree_key_addr(cur, 1, broot);
@@ -3826,7 +3826,7 @@ xfs_btree_demote_leaf_child(
 	 */
 	broot = cur->bc_ops->broot_realloc(cur, numrecs);
 	xfs_btree_init_block(cur->bc_mp, broot, cur->bc_ops, 0, numrecs,
-			cur->bc_ino.ip->i_ino);
+			I_INO(cur->bc_ino.ip));
 
 	rp = xfs_btree_rec_addr(cur, 1, broot);
 	crp = xfs_btree_rec_addr(cur, 1, cblock);
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 4300c058807b..c3c7ea54895a 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -309,7 +309,7 @@ xfs_btree_bload_prep_block(
 
 		/* Initialize it and send it out. */
 		xfs_btree_init_block(cur->bc_mp, ifp->if_broot, cur->bc_ops,
-				level, nr_this_block, cur->bc_ino.ip->i_ino);
+				level, nr_this_block, I_INO(cur->bc_ino.ip));
 
 		*bpp = NULL;
 		*blockp = ifp->if_broot;
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index ad801b7bd2dd..9debb95d86fa 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2780,7 +2780,7 @@ xfs_dabuf_map(
 		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
 			xfs_alert(mp, "%s: bno %u inode %llu",
-					__func__, bno, dp->i_ino);
+					__func__, bno, I_INO(dp));
 
 			for (i = 0; i < nirecs; i++) {
 				xfs_alert(mp,
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 9f96528ea407..0c0402a29b6b 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -244,7 +244,7 @@ xfs_dir_init(
 	int		error;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
-	error = xfs_dir_ino_validate(tp->t_mountp, pdp->i_ino);
+	error = xfs_dir_ino_validate(tp->t_mountp, I_INO(pdp));
 	if (error)
 		return error;
 
@@ -255,8 +255,8 @@ xfs_dir_init(
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
@@ -356,7 +356,7 @@ xfs_dir_createname(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 
 	rval = xfs_dir_createname_args(args);
 	kfree(args);
@@ -447,7 +447,7 @@ xfs_dir_lookup(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 	args->op_flags = XFS_DA_OP_OKNOENT;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 	if (ci_name)
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
@@ -516,7 +516,7 @@ xfs_dir_removename(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 	rval = xfs_dir_removename_args(args);
 	kfree(args);
 	return rval;
@@ -576,7 +576,7 @@ xfs_dir_replace(
 	args->total = total;
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
-	args->owner = dp->i_ino;
+	args->owner = I_INO(dp);
 	rval = xfs_dir_replace_args(args);
 	kfree(args);
 	return rval;
@@ -855,7 +855,7 @@ xfs_dir_create_child(
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 	xfs_assert_ilocked(dp, XFS_ILOCK_EXCL);
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, name, I_INO(ip), resblks);
 	if (error) {
 		ASSERT(error != -ENOSPC);
 		return error;
@@ -926,7 +926,7 @@ xfs_dir_add_child(
 			return error;
 	}
 
-	error = xfs_dir_createname(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_createname(tp, dp, name, I_INO(ip), resblks);
 	if (error)
 		return error;
 
@@ -995,7 +995,7 @@ xfs_dir_remove_child(
 		 * get freed before the child directory is closed.  If the fs
 		 * gets shrunk, this can lead to dirent inode validation errors.
 		 */
-		if (dp->i_ino != tp->t_mountp->m_sb.sb_rootino) {
+		if (I_INO(dp) != tp->t_mountp->m_sb.sb_rootino) {
 			error = xfs_dir_replace(tp, ip, &xfs_name_dotdot,
 					tp->t_mountp->m_sb.sb_rootino, 0);
 			if (error)
@@ -1016,7 +1016,7 @@ xfs_dir_remove_child(
 	if (error)
 		return error;
 
-	error = xfs_dir_removename(tp, dp, name, ip->i_ino, resblks);
+	error = xfs_dir_removename(tp, dp, name, I_INO(ip), resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		return error;
@@ -1059,12 +1059,12 @@ xfs_dir_exchange_children(
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
 
@@ -1078,7 +1078,7 @@ xfs_dir_exchange_children(
 
 		if (S_ISDIR(VFS_I(ip2)->i_mode)) {
 			error = xfs_dir_replace(tp, ip2, &xfs_name_dotdot,
-						dp1->i_ino, spaceres);
+						I_INO(dp1), spaceres);
 			if (error)
 				return error;
 
@@ -1102,7 +1102,7 @@ xfs_dir_exchange_children(
 
 		if (S_ISDIR(VFS_I(ip1)->i_mode)) {
 			error = xfs_dir_replace(tp, ip1, &xfs_name_dotdot,
-						dp2->i_ino, spaceres);
+						I_INO(dp2), spaceres);
 			if (error)
 				return error;
 
@@ -1265,7 +1265,7 @@ xfs_dir_rename_children(
 		 * to account for the ".." reference from the new entry.
 		 */
 		error = xfs_dir_createname(tp, target_dp, target_name,
-					   src_ip->i_ino, spaceres);
+					   I_INO(src_ip), spaceres);
 		if (error)
 			return error;
 
@@ -1286,7 +1286,7 @@ xfs_dir_rename_children(
 		 * name at the destination directory, remove it first.
 		 */
 		error = xfs_dir_replace(tp, target_dp, target_name,
-					src_ip->i_ino, spaceres);
+					I_INO(src_ip), spaceres);
 		if (error)
 			return error;
 
@@ -1320,7 +1320,7 @@ xfs_dir_rename_children(
 		 * directory.
 		 */
 		error = xfs_dir_replace(tp, src_ip, &xfs_name_dotdot,
-					target_dp->i_ino, spaceres);
+					I_INO(target_dp), spaceres);
 		ASSERT(error != -EEXIST);
 		if (error)
 			return error;
@@ -1358,10 +1358,10 @@ xfs_dir_rename_children(
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
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index ed0b5287a44f..19cb536e53ef 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -1739,7 +1739,7 @@ xfs_dir2_node_add_datablk(
 				   fbno)) {
 			xfs_alert(mp,
 "%s: dir ino %llu needed freesp block %lld for data block %lld, got %lld",
-				__func__, (unsigned long long)dp->i_ino,
+				__func__, (unsigned long long)I_INO(dp),
 				(long long)xfs_dir2_db_to_fdb(args->geo, *dbno),
 				(long long)*dbno, (long long)fbno);
 			if (fblk) {
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 1a67cdd6a707..0567cf8b9c1b 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
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
diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 5d28f4eac527..34ede2c927ab 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -429,7 +429,7 @@ xfs_exchmaps_attr_to_sf(
 		.geo		= tp->t_mountp->m_attr_geo,
 		.whichfork	= XFS_ATTR_FORK,
 		.trans		= tp,
-		.owner		= xmi->xmi_ip2->i_ino,
+		.owner		= I_INO(xmi->xmi_ip2),
 	};
 	struct xfs_buf		*bp;
 	int			forkoff;
@@ -438,7 +438,7 @@ xfs_exchmaps_attr_to_sf(
 	if (!xfs_attr_is_leaf(xmi->xmi_ip2))
 		return 0;
 
-	error = xfs_attr3_leaf_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, 0,
+	error = xfs_attr3_leaf_read(tp, xmi->xmi_ip2, I_INO(xmi->xmi_ip2), 0,
 			&bp);
 	if (error)
 		return error;
@@ -461,7 +461,7 @@ xfs_exchmaps_dir_to_sf(
 		.geo		= tp->t_mountp->m_dir_geo,
 		.whichfork	= XFS_DATA_FORK,
 		.trans		= tp,
-		.owner		= xmi->xmi_ip2->i_ino,
+		.owner		= I_INO(xmi->xmi_ip2),
 	};
 	struct xfs_dir2_sf_hdr	sfh;
 	struct xfs_buf		*bp;
@@ -471,7 +471,7 @@ xfs_exchmaps_dir_to_sf(
 	if (xfs_dir2_format(&args, &error) != XFS_DIR2_FMT_BLOCK)
 		return error;
 
-	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, xmi->xmi_ip2->i_ino, &bp);
+	error = xfs_dir3_block_read(tp, xmi->xmi_ip2, I_INO(xmi->xmi_ip2), &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9886af0507e3..dd0ed046fbe9 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
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
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 77201a1eb3c4..8d6a4fe4228c 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -1895,7 +1895,7 @@ xfs_dialloc(
 	struct xfs_perag	*pag;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
 	xfs_ino_t		ino = NULLFSINO;
-	xfs_ino_t		parent = args->pip ? args->pip->i_ino : 0;
+	xfs_ino_t		parent = args->pip ? I_INO(args->pip) : 0;
 	xfs_agnumber_t		agno;
 	xfs_agnumber_t		start_agno;
 	umode_t			mode = args->mode & S_IFMT;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 3794e5412eba..88e27d567df3 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -185,7 +185,7 @@ xfs_inode_from_disk(
 
 	ASSERT(ip->i_cowfp == NULL);
 
-	fa = xfs_dinode_verify(ip->i_mount, ip->i_ino, from);
+	fa = xfs_dinode_verify(ip->i_mount, I_INO(ip), from);
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "dinode", from,
 				sizeof(*from), fa);
@@ -358,7 +358,7 @@ xfs_inode_to_disk(
 		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
 		/* also covers the di_used_blocks union arm: */
 		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
-		to->di_ino = cpu_to_be64(ip->i_ino);
+		to->di_ino = cpu_to_be64(I_INO(ip));
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index d14a7f2f4c03..606a36526ce2 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -87,7 +87,7 @@ xfs_iformat_local(
 	if (unlikely(size > XFS_DFORK_SIZE(dip, ip->i_mount, whichfork))) {
 		xfs_warn(ip->i_mount,
 	"corrupt inode %llu (bad size %d for local fork, size = %zd).",
-			(unsigned long long) ip->i_ino, size,
+			(unsigned long long)I_INO(ip), size,
 			XFS_DFORK_SIZE(dip, ip->i_mount, whichfork));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_local", dip, sizeof(*dip),
@@ -126,7 +126,7 @@ xfs_iformat_extents(
 	 */
 	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
 		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
-			ip->i_ino, nex);
+			I_INO(ip), nex);
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_extents(1)", dip, sizeof(*dip),
 				__this_address);
@@ -205,7 +205,7 @@ xfs_iformat_btree(
 		     ifp->if_nextents > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BM_MAXLEVELS(mp, whichfork)) {
 		xfs_warn(mp, "corrupt inode %llu (btree).",
-					(unsigned long long) ip->i_ino);
+					(unsigned long long)I_INO(ip));
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED,
 				"xfs_iformat_btree", dfp, size,
 				__this_address);
diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index f42935fe693d..533b8fd3fecb 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -652,7 +652,7 @@ xfs_droplink(
 	if (inode->i_nlink == 0) {
 		xfs_info_ratelimited(tp->t_mountp,
  "Inode 0x%llx link count dropped below zero.  Pinning link count.",
-				ip->i_ino);
+				I_INO(ip));
 		set_nlink(inode, XFS_NLINK_PINNED);
 	}
 	if (inode->i_nlink != XFS_NLINK_PINNED)
@@ -681,7 +681,7 @@ xfs_bumplink(
 	if (inode->i_nlink == XFS_NLINK_PINNED - 1)
 		xfs_info_ratelimited(tp->t_mountp,
  "Inode 0x%llx link count exceeded maximum.  Pinning link count.",
-				ip->i_ino);
+				I_INO(ip));
 	if (inode->i_nlink != XFS_NLINK_PINNED)
 		inc_nlink(inode);
 
@@ -705,7 +705,7 @@ xfs_inode_uninit(
 	 * makes the AGI lock -> unlinked list modification order the same as
 	 * used in O_TMPFILE creation.
 	 */
-	error = xfs_difree(tp, pag, ip->i_ino, xic);
+	error = xfs_difree(tp, pag, I_INO(ip), xic);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_metadir.c b/fs/xfs/libxfs/xfs_metadir.c
index 3e5c61188927..74c4596ee4cf 100644
--- a/fs/xfs/libxfs/xfs_metadir.c
+++ b/fs/xfs/libxfs/xfs_metadir.c
@@ -95,7 +95,7 @@ xfs_metadir_lookup(
 		.hashval	= xfs_dir2_hashname(mp, xname),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
-		.owner		= dp->i_ino,
+		.owner		= I_INO(dp),
 	};
 	int			error;
 
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 3509cc4b2175..5c7df544b9fc 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -202,7 +202,7 @@ xfs_parent_addname(
 
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
-			child->i_ino, parent_name);
+			I_INO(child), parent_name);
 
 	return xfs_attr_setname(&ppargs->args, 0);
 }
@@ -224,7 +224,7 @@ xfs_parent_removename(
 
 	xfs_inode_to_parent_rec(&ppargs->rec, dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
-			child->i_ino, parent_name);
+			I_INO(child), parent_name);
 
 	return xfs_attr_removename(&ppargs->args);
 }
@@ -248,7 +248,7 @@ xfs_parent_replacename(
 
 	xfs_inode_to_parent_rec(&ppargs->rec, old_dp);
 	xfs_parent_da_args_init(&ppargs->args, tp, &ppargs->rec, child,
-			child->i_ino, old_name);
+			I_INO(child), old_name);
 
 	xfs_inode_to_parent_rec(&ppargs->new_rec, new_dp);
 
@@ -312,7 +312,7 @@ xfs_parent_lookup(
 	struct xfs_da_args		*scratch)
 {
 	memset(scratch, 0, sizeof(struct xfs_da_args));
-	xfs_parent_da_args_init(scratch, tp, pptr, ip, ip->i_ino, parent_name);
+	xfs_parent_da_args_init(scratch, tp, pptr, ip, I_INO(ip), parent_name);
 	return xfs_attr_get_ilocked(scratch);
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index b8036527cdc7..8eb4de9c5f1a 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -34,7 +34,7 @@ xfs_inode_to_parent_rec(
 	struct xfs_parent_rec	*rec,
 	const struct xfs_inode	*dp)
 {
-	xfs_parent_rec_init(rec, dp->i_ino, VFS_IC(dp)->i_generation);
+	xfs_parent_rec_init(rec, I_INO(dp), VFS_IC(dp)->i_generation);
 }
 
 extern struct kmem_cache	*xfs_parent_args_cache;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e78133c908ca..34d218de21a9 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2780,7 +2780,7 @@ xfs_rmap_map_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_MAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
+	__xfs_rmap_add(tp, type, I_INO(ip), isrt, whichfork, PREV);
 }
 
 /* Unmap an extent out of a file. */
@@ -2800,7 +2800,7 @@ xfs_rmap_unmap_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_UNMAP_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
+	__xfs_rmap_add(tp, type, I_INO(ip), isrt, whichfork, PREV);
 }
 
 /*
@@ -2826,7 +2826,7 @@ xfs_rmap_convert_extent(
 	if (whichfork != XFS_ATTR_FORK && xfs_is_reflink_inode(ip))
 		type = XFS_RMAP_CONVERT_SHARED;
 
-	__xfs_rmap_add(tp, type, ip->i_ino, isrt, whichfork, PREV);
+	__xfs_rmap_add(tp, type, I_INO(ip), isrt, whichfork, PREV);
 }
 
 /* Schedule the creation of an rmap for non-file data. */
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 6016fd5fcad9..4afa33575ce2 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
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
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index bc4c0a99f4dd..e62786e90f7b 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -214,7 +214,7 @@ xfs_rtbuf_get(
 	if (xfs_has_rtgroups(mp)) {
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
-		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+		if (hdr->rt_owner != cpu_to_be64(I_INO(ip))) {
 			xfs_buf_mark_corrupt(bp);
 			xfs_trans_brelse(args->tp, bp);
 			xfs_rtginode_mark_sick(args->rtg, type);
@@ -1409,7 +1409,7 @@ xfs_rtfile_initialize_block(
 			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
 		else
 			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
-		hdr->rt_owner = cpu_to_be64(ip->i_ino);
+		hdr->rt_owner = cpu_to_be64(I_INO(ip));
 		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
 		hdr->rt_lsn = 0;
 		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
diff --git a/fs/xfs/libxfs/xfs_rtrefcount_btree.c b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
index c1518267eb17..f27b80a199ba 100644
--- a/fs/xfs/libxfs/xfs_rtrefcount_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrefcount_btree.c
@@ -602,7 +602,7 @@ xfs_rtrefcountbt_from_disk(
 	rblocklen = xfs_rtrefcount_broot_space(mp, dblock);
 
 	xfs_btree_init_block(mp, rblock, &xfs_rtrefcountbt_ops, 0, 0,
-			ip->i_ino);
+			I_INO(ip));
 
 	rblock->bb_level = dblock->bb_level;
 	rblock->bb_numrecs = dblock->bb_numrecs;
@@ -751,7 +751,7 @@ xfs_rtrefcountbt_create(
 			xfs_rtrefcount_broot_space_calc(mp, 0, 0));
 	if (broot)
 		xfs_btree_init_block(mp, broot, &xfs_rtrefcountbt_ops, 0, 0,
-				ip->i_ino);
+				I_INO(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 00557b7ef298..c264bc5651c0 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -839,7 +839,7 @@ xfs_rtrmapbt_from_disk(
 	unsigned int		numrecs;
 	unsigned int		maxrecs;
 
-	xfs_btree_init_block(mp, rblock, &xfs_rtrmapbt_ops, 0, 0, ip->i_ino);
+	xfs_btree_init_block(mp, rblock, &xfs_rtrmapbt_ops, 0, 0, I_INO(ip));
 
 	rblock->bb_level = dblock->bb_level;
 	rblock->bb_numrecs = dblock->bb_numrecs;
@@ -981,7 +981,7 @@ xfs_rtrmapbt_create(
 	broot = xfs_broot_realloc(ifp, xfs_rtrmap_broot_space_calc(mp, 0, 0));
 	if (broot)
 		xfs_btree_init_block(mp, broot, &xfs_rtrmapbt_ops, 0, 0,
-				ip->i_ino);
+				I_INO(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE | XFS_ILOG_DBROOT);
 
 	return 0;
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index f9a5966d8048..b0dc3888bf1b 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -196,7 +196,7 @@ xfs_symlink_local_to_remote(
 	bp->b_ops = &xfs_symlink_buf_ops;
 
 	buf = bp->b_addr;
-	buf += xfs_symlink_hdr_set(mp, ip->i_ino, 0, ifp->if_bytes, bp);
+	buf += xfs_symlink_hdr_set(mp, I_INO(ip), 0, ifp->if_bytes, bp);
 	memcpy(buf, ifp->if_data, ifp->if_bytes);
 	xfs_trans_log_buf(tp, bp, 0, sizeof(struct xfs_dsymlink_hdr) +
 					ifp->if_bytes - 1);
@@ -277,13 +277,13 @@ xfs_symlink_remote_read(
 
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
 
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 53c6d68ac638..7114c9a44182 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1209,7 +1209,7 @@ xrep_iunlink_mark_incore(
 			 */
 			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
 				continue;
-			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			first_index = XFS_INO_TO_AGINO(mp, I_INO(ip) + 1);
 			if (first_index < XFS_INODE_TO_AGINO(ip))
 				done = true;
 		}
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 390ac2e11ee0..d5226939c810 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -182,7 +182,7 @@ xchk_xattr_actor(
 		.namelen		= namelen,
 		.trans			= sc->tp,
 		.valuelen		= valuelen,
-		.owner			= ip->i_ino,
+		.owner			= I_INO(ip),
 	};
 	struct xchk_xattr_buf		*ab;
 	int				error = 0;
@@ -199,7 +199,7 @@ xchk_xattr_actor(
 
 	if (attr_flags & XFS_ATTR_INCOMPLETE) {
 		/* Incomplete attr key, just mark the inode for preening. */
-		xchk_ino_set_preen(sc, ip->i_ino);
+		xchk_ino_set_preen(sc, I_INO(ip));
 		return 0;
 	}
 
diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 7d00a1ce0bac..be627ab655ad 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -329,7 +329,7 @@ xrep_xattr_salvage_remote_attr(
 		.dp			= rx->sc->ip,
 		.index			= ent_idx,
 		.geo			= rx->sc->mp->m_attr_geo,
-		.owner			= rx->sc->ip->i_ino,
+		.owner			= I_INO(rx->sc->ip),
 		.attr_filter		= ent->flags & XFS_ATTR_NSP_ONDISK_MASK,
 		.namelen		= rentry->namelen,
 		.name			= rentry->name,
@@ -590,7 +590,7 @@ xrep_xattr_recover_block(
 	 * as much as we can from the block. */
 	if (info->magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC) &&
 	    xrep_buf_verify_struct(bp, &xfs_attr3_leaf_buf_ops) &&
-	    xfs_attr3_leaf_header_check(bp, rx->sc->ip->i_ino) == NULL)
+	    xfs_attr3_leaf_header_check(bp, I_INO(rx->sc->ip)) == NULL)
 		error = xrep_xattr_recover_leaf(rx, bp);
 
 	/*
@@ -617,7 +617,7 @@ xrep_xattr_insert_rec(
 		.attr_filter		= key->flags,
 		.namelen		= key->namelen,
 		.valuelen		= key->valuelen,
-		.owner			= rx->sc->ip->i_ino,
+		.owner			= I_INO(rx->sc->ip),
 		.geo			= rx->sc->mp->m_attr_geo,
 		.whichfork		= XFS_ATTR_FORK,
 		.op_flags		= XFS_DA_OP_OKNOENT,
@@ -982,7 +982,7 @@ xrep_xattr_fork_remove(
 
 		xfs_emerg(sc->mp,
 	"inode 0x%llx attr fork still has %llu attr extents, format %d?!",
-				ip->i_ino, ifp->if_nextents, ifp->if_format);
+				I_INO(ip), ifp->if_nextents, ifp->if_format);
 		for_each_xfs_iext(ifp, &icur, &irec) {
 			xfs_err(sc->mp,
 	"[%u]: startoff %llu startblock %llu blockcount %llu state %u",
@@ -1116,7 +1116,7 @@ xrep_xattr_replay_pptr_update(
 		trace_xrep_xattr_replay_parentadd(sc->tempip, xname,
 				&pptr->pptr_rec);
 
-		error = xfs_parent_set(sc->tempip, sc->ip->i_ino, xname,
+		error = xfs_parent_set(sc->tempip, I_INO(sc->ip), xname,
 				&pptr->pptr_rec, &rx->pptr_args);
 		ASSERT(error != -EEXIST);
 		return error;
@@ -1125,7 +1125,7 @@ xrep_xattr_replay_pptr_update(
 		trace_xrep_xattr_replay_parentremove(sc->tempip, xname,
 				&pptr->pptr_rec);
 
-		error = xfs_parent_unset(sc->tempip, sc->ip->i_ino, xname,
+		error = xfs_parent_unset(sc->tempip, I_INO(sc->ip), xname,
 				&pptr->pptr_rec, &rx->pptr_args);
 		ASSERT(error != -ENOATTR);
 		return error;
@@ -1256,7 +1256,7 @@ xrep_xattr_live_dirent_update(
 	 * repairing, so stash the update for replay against the temporary
 	 * file.
 	 */
-	if (p->ip->i_ino != sc->ip->i_ino)
+	if (I_INO(p->ip) != I_INO(sc->ip))
 		return NOTIFY_DONE;
 
 	mutex_lock(&rx->lock);
@@ -1295,7 +1295,7 @@ xrep_xattr_swap_prep(
 			.whichfork	= XFS_ATTR_FORK,
 			.trans		= sc->tp,
 			.total		= 1,
-			.owner		= sc->ip->i_ino,
+			.owner		= I_INO(sc->ip),
 		};
 
 		error = xfs_attr_shortform_to_leaf(&args);
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 6dc1f6eea45e..70028da1aacc 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -205,7 +205,7 @@ xchk_bmap_xref_rmap(
 {
 	struct xfs_rmap_irec	rmap;
 	unsigned long long	rmap_end;
-	uint64_t		owner = info->sc->ip->i_ino;
+	uint64_t		owner = I_INO(info->sc->ip);
 
 	if (xchk_skip_xref(info->sc->sm))
 		return;
@@ -543,7 +543,7 @@ xchk_bmapbt_rec(
 		for (i = 0; i < bs->cur->bc_nlevels - 1; i++) {
 			block = xfs_btree_get_block(bs->cur, i, &bp);
 			owner = be64_to_cpu(block->bb_u.l.bb_owner);
-			if (owner != ip->i_ino)
+			if (owner != I_INO(ip))
 				xchk_fblock_set_corrupt(bs->sc,
 						info->whichfork, 0);
 		}
@@ -628,7 +628,7 @@ xchk_bmap_check_rmap(
 	bool				have_map;
 
 	/* Is this even the right fork? */
-	if (rec->rm_owner != sc->ip->i_ino)
+	if (rec->rm_owner != I_INO(sc->ip))
 		return 0;
 	if ((sbcri->whichfork == XFS_ATTR_FORK) ^
 	    !!(rec->rm_flags & XFS_RMAP_ATTR_FORK))
@@ -1003,7 +1003,7 @@ xchk_bmap_iext_iter(
 	 */
 	if (nr > 1 && info->whichfork != XFS_COW_FORK &&
 	    howmany_64(irec->br_blockcount, XFS_MAX_BMBT_EXTLEN) < nr)
-		xchk_ino_set_preen(info->sc, info->sc->ip->i_ino);
+		xchk_ino_set_preen(info->sc, I_INO(info->sc->ip));
 
 	return true;
 }
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index f5791ad21e41..eabffba47776 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -252,7 +252,7 @@ xrep_bmap_walk_rmap(
 	if (xchk_should_terminate(rb->sc, &error))
 		return error;
 
-	if (rec->rm_owner != rb->sc->ip->i_ino)
+	if (rec->rm_owner != I_INO(rb->sc->ip))
 		return 0;
 
 	error = xrep_bmap_check_fork_rmap(rb, cur, rec);
@@ -416,7 +416,7 @@ xrep_bmap_walk_rtrmap(
 		return error;
 
 	/* Skip extents which are not owned by this inode and fork. */
-	if (rec->rm_owner != rb->sc->ip->i_ino)
+	if (rec->rm_owner != I_INO(rb->sc->ip))
 		return 0;
 
 	error = xrep_bmap_check_rtfork_rmap(rb->sc, cur, rec);
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index f4d17239175f..16e68eb04191 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -314,7 +314,7 @@ xchk_ip_xref_set_corrupt(
 	struct xfs_inode	*ip)
 {
 	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_XCORRUPT;
-	trace_xchk_ino_error(sc, ip->i_ino, __return_address);
+	trace_xchk_ino_error(sc, I_INO(ip), __return_address);
 }
 
 /* Record corruption in a block indexed by a file fork. */
@@ -1130,7 +1130,7 @@ xchk_iget_for_scrubbing(
 	ASSERT(sc->tp == NULL);
 
 	/* We want to scan the inode we already had opened. */
-	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino)
+	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == I_INO(ip_in))
 		return xchk_install_live_inode(sc, ip_in);
 
 	/*
@@ -1562,7 +1562,7 @@ xchk_inode_is_allocated(
 	 * This isn't the inode we want.
 	 */
 	spin_lock(&ip->i_flags_lock);
-	if (ip->i_ino != ino)
+	if (I_INO(ip) != ino)
 		goto out_skip;
 
 	trace_xchk_inode_is_allocated(ip);
@@ -1670,7 +1670,7 @@ bool
 xchk_inode_is_sb_rooted(const struct xfs_inode *ip)
 {
 	return xchk_inode_is_dirtree_root(ip) ||
-	       xfs_is_sb_inum(ip->i_mount, ip->i_ino);
+	       xfs_is_sb_inum(ip->i_mount, I_INO(ip));
 }
 
 /* What is the root directory inumber for this inode? */
@@ -1680,8 +1680,8 @@ xchk_inode_rootdir_inum(const struct xfs_inode *ip)
 	struct xfs_mount	*mp = ip->i_mount;
 
 	if (xfs_is_metadir_inode(ip))
-		return mp->m_metadirip->i_ino;
-	return mp->m_rootip->i_ino;
+		return I_INO(mp->m_metadirip);
+	return I_INO(mp->m_rootip);
 }
 
 static int
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5f854d3c7e8e..fb16c29519fd 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -31,7 +31,7 @@ void xchk_block_set_corrupt(struct xfs_scrub *sc,
 		struct xfs_buf *bp);
 void xchk_ino_set_corrupt(struct xfs_scrub *sc, xfs_ino_t ino);
 #define xchk_ip_set_corrupt(_sc, _ip) \
-	xchk_ino_set_corrupt((_sc), (_ip)->i_ino)
+	xchk_ino_set_corrupt((_sc), I_INO(_ip))
 void xchk_fblock_set_corrupt(struct xfs_scrub *sc, int whichfork,
 		xfs_fileoff_t offset);
 #ifdef CONFIG_XFS_QUOTA
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 1a71d36898b1..51fee7017d83 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -393,7 +393,7 @@ xchk_da_btree_block(
 	/* Check the owner. */
 	if (xfs_has_crc(ip->i_mount)) {
 		owner = be64_to_cpu(hdr3->owner);
-		if (owner != ip->i_ino)
+		if (owner != I_INO(ip))
 			xchk_da_set_corrupt(ds, level);
 	}
 
@@ -519,7 +519,7 @@ xchk_da_btree(
 	ds->dargs.whichfork = whichfork;
 	ds->dargs.trans = sc->tp;
 	ds->dargs.op_flags = XFS_DA_OP_OKNOENT;
-	ds->dargs.owner = sc->ip->i_ino;
+	ds->dargs.owner = I_INO(sc->ip);
 	ds->state = xfs_da_state_alloc(&ds->dargs);
 	ds->sc = sc;
 	ds->private = private;
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index c810c154d72e..b1de690fee4e 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -187,11 +187,11 @@ xchk_dir_check_pptr_fast(
 	if (!lockmode) {
 		struct xchk_dirent	save_de = {
 			.namelen	= name->len,
-			.ino		= ip->i_ino,
+			.ino		= I_INO(ip),
 		};
 
 		/* Couldn't lock the inode, so save the dirent for later. */
-		trace_xchk_dir_defer(sc->ip, name, ip->i_ino);
+		trace_xchk_dir_defer(sc->ip, name, I_INO(ip));
 
 		error = xfblob_storename(sd->dir_names, &save_de.name_cookie,
 				name);
@@ -254,14 +254,14 @@ xchk_dir_actor(
 
 	if (xfs_dir2_samename(name, &xfs_name_dot)) {
 		/* If this is "." then check that the inum matches the dir. */
-		if (ino != dp->i_ino)
+		if (ino != I_INO(dp))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 	} else if (xfs_dir2_samename(name, &xfs_name_dotdot)) {
 		/*
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.
 		 */
-		if (xchk_inode_is_dirtree_root(dp) && ino != dp->i_ino)
+		if (xchk_inode_is_dirtree_root(dp) && ino != I_INO(dp))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 	}
 
@@ -482,10 +482,10 @@ xchk_directory_data_bestfree(
 		/* dir block format */
 		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
-		error = xfs_dir3_block_read(sc->tp, sc->ip, sc->ip->i_ino, &bp);
+		error = xfs_dir3_block_read(sc->tp, sc->ip, I_INO(sc->ip), &bp);
 	} else {
 		/* dir data format */
-		error = xfs_dir3_data_read(sc->tp, sc->ip, sc->ip->i_ino, lblk,
+		error = xfs_dir3_data_read(sc->tp, sc->ip, I_INO(sc->ip), lblk,
 				0, &bp);
 	}
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
@@ -638,7 +638,7 @@ xchk_directory_leaf1_bestfree(
 	int				error;
 
 	/* Read the free space block. */
-	error = xfs_dir3_leaf_read(sc->tp, sc->ip, sc->ip->i_ino, lblk, &bp);
+	error = xfs_dir3_leaf_read(sc->tp, sc->ip, I_INO(sc->ip), lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		return error;
 	xchk_buffer_recheck(sc, bp);
@@ -744,7 +744,7 @@ xchk_directory_free_bestfree(
 	int				error;
 
 	/* Read the free space block */
-	error = xfs_dir2_free_read(sc->tp, sc->ip, sc->ip->i_ino, lblk, &bp);
+	error = xfs_dir2_free_read(sc->tp, sc->ip, I_INO(sc->ip), lblk, &bp);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, lblk, &error))
 		return error;
 	xchk_buffer_recheck(sc, bp);
@@ -792,7 +792,7 @@ xchk_directory_blocks(
 		.whichfork	= XFS_DATA_FORK,
 		.geo		= sc->mp->m_dir_geo,
 		.trans		= sc->tp,
-		.owner		= sc->ip->i_ino,
+		.owner		= I_INO(sc->ip),
 	};
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, XFS_DATA_FORK);
 	struct xfs_mount	*mp = sc->mp;
@@ -991,7 +991,7 @@ xchk_dir_slow_dirent(
 	 */
 	lockmode = xchk_dir_lock_child(sc, ip);
 	if (lockmode) {
-		trace_xchk_dir_slowpath(sc->ip, xname, ip->i_ino);
+		trace_xchk_dir_slowpath(sc->ip, xname, I_INO(ip));
 		goto check_pptr;
 	}
 
@@ -1002,7 +1002,7 @@ xchk_dir_slow_dirent(
 	xchk_iunlock(sc, sc->ilock_flags);
 	sd->need_revalidate = true;
 
-	trace_xchk_dir_ultraslowpath(sc->ip, xname, ip->i_ino);
+	trace_xchk_dir_ultraslowpath(sc->ip, xname, I_INO(ip));
 
 	error = xchk_dir_trylock_for_pptrs(sc, ip, &lockmode);
 	if (error)
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 373172e52287..1c088cfba10e 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -304,7 +304,7 @@ xrep_dir_want_salvage(
 	struct xfs_mount	*mp = rd->sc->mp;
 
 	/* No pointers to ourselves or to garbage. */
-	if (ino == rd->sc->ip->i_ino)
+	if (ino == I_INO(rd->sc->ip))
 		return false;
 	if (!xfs_verify_dir_ino(mp, ino))
 		return false;
@@ -644,14 +644,14 @@ xrep_dir_recover_dirblock(
 	case cpu_to_be32(XFS_DIR3_BLOCK_MAGIC):
 		if (!xrep_buf_verify_struct(bp, &xfs_dir3_block_buf_ops))
 			goto out;
-		if (xfs_dir3_block_header_check(bp, rd->sc->ip->i_ino) != NULL)
+		if (xfs_dir3_block_header_check(bp, I_INO(rd->sc->ip)) != NULL)
 			goto out;
 		break;
 	case cpu_to_be32(XFS_DIR2_DATA_MAGIC):
 	case cpu_to_be32(XFS_DIR3_DATA_MAGIC):
 		if (!xrep_buf_verify_struct(bp, &xfs_dir3_data_buf_ops))
 			goto out;
-		if (xfs_dir3_data_header_check(bp, rd->sc->ip->i_ino) != NULL)
+		if (xfs_dir3_data_header_check(bp, I_INO(rd->sc->ip)) != NULL)
 			goto out;
 		break;
 	default:
@@ -676,7 +676,7 @@ xrep_dir_init_args(
 	memset(&rd->args, 0, sizeof(struct xfs_da_args));
 	rd->args.geo = rd->sc->mp->m_dir_geo;
 	rd->args.whichfork = XFS_DATA_FORK;
-	rd->args.owner = rd->sc->ip->i_ino;
+	rd->args.owner = I_INO(rd->sc->ip);
 	rd->args.trans = rd->sc->tp;
 	rd->args.dp = dp;
 	if (!name)
@@ -1125,12 +1125,12 @@ xrep_dir_scan_pptr(
 	if (error)
 		return error;
 
-	if (parent_ino != sc->ip->i_ino ||
+	if (parent_ino != I_INO(sc->ip) ||
 	    parent_gen != VFS_I(sc->ip)->i_generation)
 		return 0;
 
 	mutex_lock(&rd->pscan.lock);
-	error = xrep_dir_stash_createname(rd, &xname, ip->i_ino);
+	error = xrep_dir_stash_createname(rd, &xname, I_INO(ip));
 	mutex_unlock(&rd->pscan.lock);
 	return error;
 }
@@ -1151,7 +1151,7 @@ xrep_dir_scan_dirent(
 	struct xrep_dir		*rd = priv;
 
 	/* Dirent doesn't point to this directory. */
-	if (ino != rd->sc->ip->i_ino)
+	if (ino != I_INO(rd->sc->ip))
 		return 0;
 
 	/* Ignore garbage inum. */
@@ -1168,9 +1168,9 @@ xrep_dir_scan_dirent(
 		return 0;
 
 	trace_xrep_dir_stash_createname(sc->tempip, &xfs_name_dotdot,
-			dp->i_ino);
+			I_INO(dp));
 
-	xrep_findparent_scan_found(&rd->pscan, dp->i_ino);
+	xrep_findparent_scan_found(&rd->pscan, I_INO(dp));
 	return 0;
 }
 
@@ -1281,7 +1281,7 @@ xrep_dir_scan_dirtree(
 
 	/* Roots of directory trees are their own parents. */
 	if (xchk_inode_is_dirtree_root(sc->ip))
-		xrep_findparent_scan_found(&rd->pscan, sc->ip->i_ino);
+		xrep_findparent_scan_found(&rd->pscan, I_INO(sc->ip));
 
 	/*
 	 * Filesystem scans are time consuming.  Drop the directory ILOCK and
@@ -1369,15 +1369,15 @@ xrep_dir_live_update(
 	 * rebuilding.  Stash the update for replay against the temporary
 	 * directory.
 	 */
-	if (p->dp->i_ino == sc->ip->i_ino &&
-	    xchk_iscan_want_live_update(&rd->pscan.iscan, p->ip->i_ino)) {
+	if (I_INO(p->dp) == I_INO(sc->ip) &&
+	    xchk_iscan_want_live_update(&rd->pscan.iscan, I_INO(p->ip))) {
 		mutex_lock(&rd->pscan.lock);
 		if (p->delta > 0)
 			error = xrep_dir_stash_createname(rd, p->name,
-					p->ip->i_ino);
+					I_INO(p->ip));
 		else
 			error = xrep_dir_stash_removename(rd, p->name,
-					p->ip->i_ino);
+					I_INO(p->ip));
 		mutex_unlock(&rd->pscan.lock);
 		if (error)
 			goto out_abort;
@@ -1388,14 +1388,14 @@ xrep_dir_live_update(
 	 * the directory that we're rebuilding, so remember the new dotdot
 	 * target.
 	 */
-	if (p->ip->i_ino == sc->ip->i_ino &&
-	    xchk_iscan_want_live_update(&rd->pscan.iscan, p->dp->i_ino)) {
+	if (I_INO(p->ip) == I_INO(sc->ip) &&
+	    xchk_iscan_want_live_update(&rd->pscan.iscan, I_INO(p->dp))) {
 		if (p->delta > 0) {
 			trace_xrep_dir_stash_createname(sc->tempip,
 					&xfs_name_dotdot,
-					p->dp->i_ino);
+					I_INO(p->dp));
 
-			xrep_findparent_scan_found(&rd->pscan, p->dp->i_ino);
+			xrep_findparent_scan_found(&rd->pscan, I_INO(p->dp));
 		} else {
 			trace_xrep_dir_stash_removename(sc->tempip,
 					&xfs_name_dotdot,
@@ -1468,7 +1468,7 @@ xrep_dir_swap_prep(
 			.whichfork	= XFS_DATA_FORK,
 			.trans		= sc->tp,
 			.total		= 1,
-			.owner		= sc->ip->i_ino,
+			.owner		= I_INO(sc->ip),
 		};
 
 		error = xfs_dir2_sf_to_block(&args);
@@ -1764,7 +1764,7 @@ xrep_dir_rebuild_tree(
 	 * directory to an empty shortform directory because inactivation does
 	 * nothing for directories.
 	 */
-	error = xrep_dir_reset_fork(rd, sc->mp->m_rootip->i_ino);
+	error = xrep_dir_reset_fork(rd, I_INO(sc->mp->m_rootip));
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 51b37dfa28f0..c6a210f7508f 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -175,7 +175,7 @@ xchk_dirpath_append(
 	if (error)
 		return error;
 
-	error = xino_bitmap_set(&path->seen_inodes, ip->i_ino);
+	error = xino_bitmap_set(&path->seen_inodes, I_INO(ip));
 	if (error)
 		return error;
 
@@ -394,7 +394,7 @@ xchk_dirpath_step_up(
 	 * The inode being scanned is its own distant ancestor!  Get rid of
 	 * this path.
 	 */
-	if (parent_ino == sc->ip->i_ino) {
+	if (parent_ino == I_INO(sc->ip)) {
 		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
 		error = 0;
 		goto out_scanlock;
@@ -533,7 +533,7 @@ xchk_dirpath_walk_upwards(
 	 * The inode being scanned is its own direct ancestor!
 	 * Get rid of this path.
 	 */
-	if (be64_to_cpu(dl->pptr_rec.p_ino) == sc->ip->i_ino) {
+	if (be64_to_cpu(dl->pptr_rec.p_ino) == I_INO(sc->ip)) {
 		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
 		return 0;
 	}
@@ -610,7 +610,7 @@ xchk_dirpath_step_is_stale(
 	 * If the parent and child being updated are not the ones mentioned in
 	 * this path step, the scan data is still ok.
 	 */
-	if (p->ip->i_ino != child_ino || p->dp->i_ino != *cursor)
+	if (I_INO(p->ip) != child_ino || I_INO(p->dp) != *cursor)
 		return 0;
 
 	/*
@@ -632,13 +632,13 @@ xchk_dirpath_step_is_stale(
 	 * If the update comes from the repair code itself, walk the state
 	 * machine forward.
 	 */
-	if (p->ip->i_ino == dl->scan_ino &&
+	if (I_INO(p->ip) == dl->scan_ino &&
 	    path->outcome == XREP_DIRPATH_ADOPTING) {
 		xchk_dirpath_set_outcome(dl, path, XREP_DIRPATH_ADOPTED);
 		return 0;
 	}
 
-	if (p->ip->i_ino == dl->scan_ino &&
+	if (I_INO(p->ip) == dl->scan_ino &&
 	    path->outcome == XREP_DIRPATH_DELETING) {
 		xchk_dirpath_set_outcome(dl, path, XREP_DIRPATH_DELETED);
 		return 0;
@@ -669,7 +669,7 @@ xchk_dirpath_is_stale(
 	 * The child being updated has not been seen by this path at all; this
 	 * path cannot be stale.
 	 */
-	if (!xino_bitmap_test(&path->seen_inodes, p->ip->i_ino))
+	if (!xino_bitmap_test(&path->seen_inodes, I_INO(p->ip)))
 		return 0;
 
 	ret = xchk_dirpath_step_is_stale(dl, path, 0, idx, p, &cursor);
@@ -928,7 +928,7 @@ xchk_dirtree(
 	 * released during teardown.
 	 */
 	dl->root_ino = xchk_inode_rootdir_inum(sc->ip);
-	dl->scan_ino = sc->ip->i_ino;
+	dl->scan_ino = I_INO(sc->ip);
 
 	trace_xchk_dirtree_start(sc->ip, sc->sm, 0);
 
diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
index bcfbbf5efc6c..1c0d7ea4a5be 100644
--- a/fs/xfs/scrub/dirtree_repair.c
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -459,7 +459,7 @@ xrep_dirtree_unlink(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_removename(sc->tp, dp, &dl->xname, sc->ip->i_ino,
+	error = xfs_dir_removename(sc->tp, dp, &dl->xname, I_INO(sc->ip),
 			resblks);
 	if (error) {
 		ASSERT(error != -ENOENT);
@@ -583,7 +583,7 @@ xrep_dirtree_create_adoption_path(
 	 */
 	xfs_inode_to_parent_rec(&dl->pptr_rec, sc->orphanage);
 
-	error = xino_bitmap_set(&path->seen_inodes, sc->orphanage->i_ino);
+	error = xino_bitmap_set(&path->seen_inodes, I_INO(sc->orphanage));
 	if (error)
 		goto out_path;
 
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 2076f028d271..04b6b96b0a30 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -65,7 +65,7 @@ struct xrep_findparent_info {
 
 	/*
 	 * Scrub context.  We're looking for a @dp containing a directory
-	 * entry pointing to sc->ip->i_ino.
+	 * entry pointing to I_INO(sc->ip).
 	 */
 	struct xfs_scrub	*sc;
 
@@ -106,7 +106,7 @@ xrep_findparent_dirent(
 	if (xchk_should_terminate(fpi->sc, &error))
 		return error;
 
-	if (ino != fpi->sc->ip->i_ino)
+	if (ino != I_INO(fpi->sc->ip))
 		return 0;
 
 	/* Ignore garbage directory entry names. */
@@ -123,18 +123,18 @@ xrep_findparent_dirent(
 
 	/* Uhoh, more than one parent for a dir? */
 	if (fpi->found_parent != NULLFSINO &&
-	    !(fpi->parent_tentative && fpi->found_parent == fpi->dp->i_ino)) {
+	    !(fpi->parent_tentative && fpi->found_parent == I_INO(fpi->dp))) {
 		trace_xrep_findparent_dirent(fpi->sc->ip, 0);
 		return -EFSCORRUPTED;
 	}
 
 	/* We found a potential parent; remember this. */
-	trace_xrep_findparent_dirent(fpi->sc->ip, fpi->dp->i_ino);
-	fpi->found_parent = fpi->dp->i_ino;
+	trace_xrep_findparent_dirent(fpi->sc->ip, I_INO(fpi->dp));
+	fpi->found_parent = I_INO(fpi->dp);
 	fpi->parent_tentative = false;
 
 	if (fpi->parent_scan)
-		xrep_findparent_scan_found(fpi->parent_scan, fpi->dp->i_ino);
+		xrep_findparent_scan_found(fpi->parent_scan, I_INO(fpi->dp));
 
 	return 0;
 }
@@ -227,13 +227,12 @@ xrep_findparent_live_update(
 	 * already scanned @p->dp, update the dotdot target inumber to the
 	 * parent inode.
 	 */
-	if (p->ip->i_ino == sc->ip->i_ino &&
-	    xchk_iscan_want_live_update(&pscan->iscan, p->dp->i_ino)) {
-		if (p->delta > 0) {
-			xrep_findparent_scan_found(pscan, p->dp->i_ino);
-		} else {
+	if (I_INO(p->ip) == I_INO(sc->ip) &&
+	    xchk_iscan_want_live_update(&pscan->iscan, I_INO(p->dp))) {
+		if (p->delta > 0)
+			xrep_findparent_scan_found(pscan, I_INO(p->dp));
+		else
 			xrep_findparent_scan_found(pscan, NULLFSINO);
-		}
 	}
 
 	return NOTIFY_DONE;
@@ -388,7 +387,7 @@ xrep_findparent_confirm(
 	if (*parent_ino == NULLFSINO)
 	       return 0;
 	if (!xfs_verify_dir_ino(sc->mp, *parent_ino) ||
-	    *parent_ino == sc->ip->i_ino) {
+	    *parent_ino == I_INO(sc->ip)) {
 		*parent_ino = NULLFSINO;
 		return 0;
 	}
@@ -422,10 +421,10 @@ xfs_ino_t
 xrep_findparent_self_reference(
 	struct xfs_scrub	*sc)
 {
-	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
+	if (I_INO(sc->ip) == sc->mp->m_sb.sb_rootino)
 		return sc->mp->m_sb.sb_rootino;
 
-	if (sc->ip->i_ino == sc->mp->m_sb.sb_metadirino)
+	if (I_INO(sc->ip) == sc->mp->m_sb.sb_metadirino)
 		return sc->mp->m_sb.sb_metadirino;
 
 	if (VFS_I(sc->ip)->i_nlink == 0)
@@ -457,8 +456,8 @@ xrep_findparent_from_dcache(
 	dput(parent);
 
 	if (S_ISDIR(pip->i_mode)) {
-		trace_xrep_findparent_from_dcache(sc->ip, XFS_I(pip)->i_ino);
-		ret = XFS_I(pip)->i_ino;
+		ret = pip->i_ino;
+		trace_xrep_findparent_from_dcache(sc->ip, ret);
 	}
 
 	xchk_irele(sc, XFS_I(pip));
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 3f234e9c5afd..65b13e311916 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -102,7 +102,7 @@ xchk_setup_inode(
 		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
 
 	/* We want to scan the opened inode, so lock it and exit. */
-	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == ip_in->i_ino) {
+	if (sc->sm->sm_ino == 0 || sc->sm->sm_ino == I_INO(ip_in)) {
 		error = xchk_install_live_inode(sc, ip_in);
 		if (error)
 			return error;
@@ -794,10 +794,10 @@ xchk_inode_check_unlinked(
 {
 	if (VFS_I(sc->ip)->i_nlink == 0) {
 		if (!xfs_inode_on_unlinked_list(sc->ip))
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ino_set_corrupt(sc, I_INO(sc->ip));
 	} else {
 		if (xfs_inode_on_unlinked_list(sc->ip))
-			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+			xchk_ino_set_corrupt(sc, I_INO(sc->ip));
 	}
 }
 
@@ -821,7 +821,7 @@ xchk_inode(
 
 	/* Scrub the inode core. */
 	xfs_inode_to_disk(sc->ip, &di, 0);
-	xchk_dinode(sc, &di, sc->ip->i_ino);
+	xchk_dinode(sc, &di, I_INO(sc->ip));
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 		goto out;
 
@@ -831,11 +831,11 @@ xchk_inode(
 	 * we scrubbed the dinode.
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode))
-		xchk_inode_check_reflink_iflag(sc, sc->ip->i_ino);
+		xchk_inode_check_reflink_iflag(sc, I_INO(sc->ip));
 
 	xchk_inode_check_unlinked(sc);
 
-	xchk_inode_xref(sc, sc->ip->i_ino, &di);
+	xchk_inode_xref(sc, I_INO(sc->ip), &di);
 out:
 	return error;
 }
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 8a2bf263ca3b..c84657add97a 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1796,7 +1796,7 @@ xrep_inode_flags(
 		sc->ip->i_diflags &= ~XFS_DIFLAG_ANY;
 
 	/* NEWRTBM only applies to realtime bitmaps */
-	if (sc->ip->i_ino == sc->mp->m_sb.sb_rbmino)
+	if (I_INO(sc->ip) == sc->mp->m_sb.sb_rbmino)
 		sc->ip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 	else
 		sc->ip->i_diflags &= ~XFS_DIFLAG_NEWRTBM;
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index 2a974eed00cc..03f72ba9e7a3 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -728,7 +728,7 @@ xchk_iscan_mark_visited(
 	struct xfs_inode	*ip)
 {
 	mutex_lock(&iscan->lock);
-	iscan->__visited_ino = ip->i_ino;
+	iscan->__visited_ino = I_INO(ip);
 	trace_xchk_iscan_visit(iscan);
 	mutex_unlock(&iscan->lock);
 }
diff --git a/fs/xfs/scrub/listxattr.c b/fs/xfs/scrub/listxattr.c
index 0863db64b1b2..9b4cf393788b 100644
--- a/fs/xfs/scrub/listxattr.c
+++ b/fs/xfs/scrub/listxattr.c
@@ -115,7 +115,7 @@ xchk_xattr_walk_leaf(
 	struct xfs_buf			*leaf_bp;
 	int				error;
 
-	error = xfs_attr3_leaf_read(sc->tp, ip, ip->i_ino, 0, &leaf_bp);
+	error = xfs_attr3_leaf_read(sc->tp, ip, I_INO(ip), 0, &leaf_bp);
 	if (error)
 		return error;
 
@@ -166,7 +166,7 @@ xchk_xattr_find_leftmost_leaf(
 		    magic != XFS_DA3_NODE_MAGIC)
 			goto out_buf;
 
-		fa = xfs_da3_node_header_check(bp, ip->i_ino);
+		fa = xfs_da3_node_header_check(bp, I_INO(ip));
 		if (fa)
 			goto out_buf;
 
@@ -195,7 +195,7 @@ xchk_xattr_find_leftmost_leaf(
 	}
 
 	error = -EFSCORRUPTED;
-	fa = xfs_attr3_leaf_header_check(bp, ip->i_ino);
+	fa = xfs_attr3_leaf_header_check(bp, I_INO(ip));
 	if (fa)
 		goto out_buf;
 
@@ -266,8 +266,8 @@ xchk_xattr_walk_node(
 			goto out_bitmap;
 		}
 
-		error = xfs_attr3_leaf_read(sc->tp, ip, ip->i_ino,
-				leafhdr.forw, &leaf_bp);
+		error = xfs_attr3_leaf_read(sc->tp, ip, I_INO(ip), leafhdr.forw,
+				&leaf_bp);
 		if (error)
 			goto out_bitmap;
 
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 680a8ba1cdf1..ff1ff762b300 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -335,7 +335,7 @@ xchk_metapath(
 	}
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out_ilock;
-	if (ino != sc->ip->i_ino) {
+	if (ino != I_INO(sc->ip)) {
 		/* Pointing to wrong inode */
 		xchk_ip_set_corrupt(sc, sc->ip);
 	}
@@ -364,7 +364,7 @@ xrep_metapath_link(
 	else
 		mpath->du.ppargs = NULL;
 
-	trace_xrep_metapath_link(sc, mpath->path, mpath->dp, sc->ip->i_ino);
+	trace_xrep_metapath_link(sc, mpath->path, mpath->dp, I_INO(sc->ip));
 
 	return xfs_dir_add_child(sc->tp, mpath->link_resblks, &mpath->du);
 }
@@ -462,7 +462,7 @@ xrep_metapath_try_link(
 	if (error)
 		goto out_cancel;
 
-	if (ino == sc->ip->i_ino) {
+	if (ino == I_INO(sc->ip)) {
 		/* The dirent already points to @sc->ip; we're done. */
 		error = 0;
 		goto out_cancel;
@@ -530,7 +530,7 @@ xrep_metapath_try_unlink(
 	xfs_ino_t		ino;
 	int			error;
 
-	ASSERT(*alleged_child != sc->ip->i_ino);
+	ASSERT(*alleged_child != I_INO(sc->ip));
 
 	trace_xrep_metapath_try_unlink(sc, mpath->path, mpath->dp,
 			*alleged_child);
@@ -575,7 +575,7 @@ xrep_metapath_try_unlink(
 	if (error)
 		goto out_cancel;
 
-	if (ino == sc->ip->i_ino) {
+	if (ino == I_INO(sc->ip)) {
 		/* The dirent already points to @sc->ip; we're done. */
 		error = -EEXIST;
 		goto out_cancel;
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index 01ce6517a036..355ab6de23ea 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -175,7 +175,7 @@ xchk_nlinks_live_update(
 	if (xrep_is_tempfile(p->dp))
 		return NOTIFY_DONE;
 
-	trace_xchk_nlinks_live_update(xnc->sc->mp, p->dp, action, p->ip->i_ino,
+	trace_xchk_nlinks_live_update(xnc->sc->mp, p->dp, action, I_INO(p->ip),
 			p->delta, p->name->name, p->name->len);
 
 	/*
@@ -183,12 +183,12 @@ xchk_nlinks_live_update(
 	 * to @ip.  If @ip is a subdirectory, update the number of child links
 	 * going out of @dp.
 	 */
-	if (xchk_iscan_want_live_update(&xnc->collect_iscan, p->dp->i_ino)) {
+	if (xchk_iscan_want_live_update(&xnc->collect_iscan, I_INO(p->dp))) {
 		mutex_lock(&xnc->lock);
-		error = xchk_nlinks_update_incore(xnc, p->ip->i_ino, p->delta,
+		error = xchk_nlinks_update_incore(xnc, I_INO(p->ip), p->delta,
 				0, 0);
 		if (!error && S_ISDIR(VFS_IC(p->ip)->i_mode))
-			error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+			error = xchk_nlinks_update_incore(xnc, I_INO(p->dp), 0,
 					0, p->delta);
 		mutex_unlock(&xnc->lock);
 		if (error)
@@ -200,9 +200,9 @@ xchk_nlinks_live_update(
 	 * number of backrefs pointing to @dp.
 	 */
 	if (S_ISDIR(VFS_IC(p->ip)->i_mode) &&
-	    xchk_iscan_want_live_update(&xnc->collect_iscan, p->ip->i_ino)) {
+	    xchk_iscan_want_live_update(&xnc->collect_iscan, I_INO(p->ip))) {
 		mutex_lock(&xnc->lock);
-		error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+		error = xchk_nlinks_update_incore(xnc, I_INO(p->dp), 0,
 				p->delta, 0);
 		mutex_unlock(&xnc->lock);
 		if (error)
@@ -243,7 +243,7 @@ xchk_nlinks_collect_dirent(
 		dotdot = true;
 
 	/* Don't accept a '.' entry that points somewhere else. */
-	if (dot && ino != dp->i_ino) {
+	if (dot && ino != I_INO(dp)) {
 		error = -ECANCELED;
 		goto out_abort;
 	}
@@ -304,7 +304,7 @@ xchk_nlinks_collect_dirent(
 	 * number of child links of dp.
 	 */
 	if (!dot && !dotdot && name->type == XFS_DIR3_FT_DIR) {
-		error = xchk_nlinks_update_incore(xnc, dp->i_ino, 0, 0, 1);
+		error = xchk_nlinks_update_incore(xnc, I_INO(dp), 0, 0, 1);
 		if (error)
 			goto out_unlock;
 	}
@@ -692,7 +692,7 @@ xchk_nlinks_compare_inode(
 		goto out_scanlock;
 	}
 
-	error = xchk_nlinks_comparison_read(xnc, ip->i_ino, &obs);
+	error = xchk_nlinks_comparison_read(xnc, I_INO(ip), &obs);
 	if (error)
 		goto out_scanlock;
 
@@ -721,7 +721,7 @@ xchk_nlinks_compare_inode(
 		xchk_ip_set_corrupt(sc, ip);
 		goto out_corrupt;
 	} else if (total_links > XFS_MAXLINK) {
-		xchk_ino_set_warning(sc, ip->i_ino);
+		xchk_ino_set_warning(sc, I_INO(ip));
 	}
 
 	/* Link counts should match. */
diff --git a/fs/xfs/scrub/nlinks_repair.c b/fs/xfs/scrub/nlinks_repair.c
index 3767dba9f515..fbc2ff809fc0 100644
--- a/fs/xfs/scrub/nlinks_repair.c
+++ b/fs/xfs/scrub/nlinks_repair.c
@@ -152,7 +152,7 @@ xrep_nlinks_repair_inode(
 		goto out_scanlock;
 	}
 
-	error = xfarray_load_sparse(xnc->nlinks, ip->i_ino, &obs);
+	error = xfarray_load_sparse(xnc->nlinks, I_INO(ip), &obs);
 	if (error)
 		goto out_scanlock;
 
@@ -206,7 +206,7 @@ xrep_nlinks_repair_inode(
 		 * updated our scan info.
 		 */
 		mutex_lock(&xnc->lock);
-		error = xfarray_load_sparse(xnc->nlinks, ip->i_ino, &obs);
+		error = xfarray_load_sparse(xnc->nlinks, I_INO(ip), &obs);
 		mutex_unlock(&xnc->lock);
 		if (error)
 			goto out_trans;
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index 33c6db6b4498..3aca66869b80 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -402,14 +402,14 @@ xrep_adoption_compute_name(
 	int			error = 0;
 
 	adopt->xname = xname;
-	xname->len = snprintf(namebuf, MAXNAMELEN, "%llu", sc->ip->i_ino);
+	xname->len = snprintf(namebuf, MAXNAMELEN, "%llu", I_INO(sc->ip));
 	xname->type = xfs_mode_to_ftype(VFS_I(sc->ip)->i_mode);
 
 	/* Make sure the filename is unique in the lost+found. */
 	error = xchk_dir_lookup(sc, sc->orphanage, xname, &ino);
 	while (error == 0 && incr < 10000) {
 		xname->len = snprintf(namebuf, MAXNAMELEN, "%llu.%u",
-				sc->ip->i_ino, ++incr);
+				I_INO(sc->ip), ++incr);
 		error = xchk_dir_lookup(sc, sc->orphanage, xname, &ino);
 	}
 	if (error == 0) {
@@ -532,7 +532,7 @@ xrep_adoption_move(
 	int			error;
 
 	trace_xrep_adoption_reparent(sc->orphanage, adopt->xname,
-			sc->ip->i_ino);
+			I_INO(sc->ip));
 
 	error = xrep_adoption_check_dcache(adopt);
 	if (error)
@@ -553,7 +553,7 @@ xrep_adoption_move(
 
 	/* Create the new name in the orphanage. */
 	error = xfs_dir_createname(sc->tp, sc->orphanage, adopt->xname,
-			sc->ip->i_ino, adopt->orphanage_blkres);
+			I_INO(sc->ip), adopt->orphanage_blkres);
 	if (error)
 		return error;
 
@@ -576,7 +576,7 @@ xrep_adoption_move(
 	/* Replace the dotdot entry if the child is a subdirectory. */
 	if (isdir) {
 		error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
-				sc->orphanage->i_ino, adopt->child_blkres);
+				I_INO(sc->orphanage), adopt->child_blkres);
 		if (error)
 			return error;
 	}
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index eb9ca3d75fef..a8c4807e1d94 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -72,7 +72,7 @@ xchk_parent_actor(
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
 
-	if (sc->ip->i_ino == ino)
+	if (I_INO(sc->ip) == ino)
 		spc->nlink++;
 
 	if (xchk_should_terminate(spc->sc, &error))
@@ -119,6 +119,7 @@ xchk_parent_validate(
 		.nlink		= 0,
 	};
 	struct xfs_mount	*mp = sc->mp;
+	xfs_ino_t		ino = I_INO(sc->ip);
 	struct xfs_inode	*dp = NULL;
 	xfs_nlink_t		expected_nlink;
 	unsigned int		lock_mode;
@@ -126,22 +127,20 @@ xchk_parent_validate(
 
 	/* Is this the root dir?  Then '..' must point to itself. */
 	if (sc->ip == mp->m_rootip) {
-		if (sc->ip->i_ino != mp->m_sb.sb_rootino ||
-		    sc->ip->i_ino != parent_ino)
+		if (ino != mp->m_sb.sb_rootino || ino != parent_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
 	}
 
 	/* Is this the metadata root dir?  Then '..' must point to itself. */
 	if (sc->ip == mp->m_metadirip) {
-		if (sc->ip->i_ino != mp->m_sb.sb_metadirino ||
-		    sc->ip->i_ino != parent_ino)
+		if (ino != mp->m_sb.sb_metadirino || ino != parent_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
 	}
 
 	/* '..' must not point to ourselves. */
-	if (sc->ip->i_ino == parent_ino) {
+	if (ino == parent_ino) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
 	}
@@ -315,7 +314,7 @@ xchk_parent_pptr_and_dotdot(
 
 	/* Is this the root dir?  Then '..' must point to itself. */
 	if (xchk_inode_is_dirtree_root(sc->ip)) {
-		if (sc->ip->i_ino != pp->parent_ino)
+		if (I_INO(sc->ip) != pp->parent_ino)
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
 	}
@@ -398,7 +397,7 @@ xchk_parent_dirent(
 		return error;
 
 	/* Does the inode number match? */
-	if (child_ino != sc->ip->i_ino) {
+	if (child_ino != I_INO(sc->ip)) {
 		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
 		return 0;
 	}
@@ -490,7 +489,7 @@ xchk_parent_scan_attr(
 	}
 
 	/* No self-referential parent pointers. */
-	if (parent_ino == sc->ip->i_ino) {
+	if (parent_ino == I_INO(sc->ip)) {
 		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
 		return -ECANCELED;
 	}
@@ -512,7 +511,7 @@ xchk_parent_scan_attr(
 		};
 
 		/* Couldn't lock the inode, so save the pptr for later. */
-		trace_xchk_parent_defer(sc->ip, &xname, dp->i_ino);
+		trace_xchk_parent_defer(sc->ip, &xname, I_INO(dp));
 
 		error = xfblob_storename(pp->pptr_names, &save_pp.name_cookie,
 				&xname);
@@ -599,7 +598,7 @@ xchk_parent_slow_pptr(
 	 */
 	lockmode = xchk_parent_lock_dir(sc, dp);
 	if (lockmode) {
-		trace_xchk_parent_slowpath(sc->ip, xname, dp->i_ino);
+		trace_xchk_parent_slowpath(sc->ip, xname, I_INO(dp));
 		goto check_dirent;
 	}
 
@@ -610,7 +609,7 @@ xchk_parent_slow_pptr(
 	xchk_iunlock(sc, sc->ilock_flags);
 	pp->need_revalidate = true;
 
-	trace_xchk_parent_ultraslowpath(sc->ip, xname, dp->i_ino);
+	trace_xchk_parent_ultraslowpath(sc->ip, xname, I_INO(dp));
 
 	error = xchk_dir_trylock_for_pptrs(sc, dp, &lockmode);
 	if (error)
@@ -856,7 +855,7 @@ xchk_parent(
 		return -ENOENT;
 
 	/* We're not a special inode, are we? */
-	if (!xfs_verify_dir_ino(mp, sc->ip->i_ino)) {
+	if (!xfs_verify_dir_ino(mp, I_INO(sc->ip))) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index a5dc7dc65f98..f643724910f9 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -302,14 +302,14 @@ xrep_parent_replay_update(
 		trace_xrep_parent_replay_parentadd(sc->tempip, xname,
 				&pptr->pptr_rec);
 
-		return xfs_parent_set(sc->tempip, sc->ip->i_ino, xname,
+		return xfs_parent_set(sc->tempip, I_INO(sc->ip), xname,
 				&pptr->pptr_rec, &rp->pptr_args);
 	case XREP_PPTR_REMOVE:
 		/* Remove parent pointer. */
 		trace_xrep_parent_replay_parentremove(sc->tempip, xname,
 				&pptr->pptr_rec);
 
-		return xfs_parent_unset(sc->tempip, sc->ip->i_ino, xname,
+		return xfs_parent_unset(sc->tempip, I_INO(sc->ip), xname,
 				&pptr->pptr_rec, &rp->pptr_args);
 	}
 
@@ -434,7 +434,7 @@ xrep_parent_scan_dirent(
 	int			error;
 
 	/* Dirent doesn't point to this directory. */
-	if (ino != rp->sc->ip->i_ino)
+	if (ino != I_INO(rp->sc->ip))
 		return 0;
 
 	/* No weird looking names. */
@@ -645,8 +645,8 @@ xrep_parent_live_update(
 	 * repairing, so stash the update for replay against the temporary
 	 * file.
 	 */
-	if (p->ip->i_ino == sc->ip->i_ino &&
-	    xchk_iscan_want_live_update(&rp->pscan.iscan, p->dp->i_ino)) {
+	if (I_INO(p->ip) == I_INO(sc->ip) &&
+	    xchk_iscan_want_live_update(&rp->pscan.iscan, I_INO(p->dp))) {
 		mutex_lock(&rp->pscan.lock);
 		if (p->delta > 0)
 			error = xrep_parent_stash_parentadd(rp, p->name, p->dp);
@@ -906,7 +906,7 @@ xrep_parent_fetch_xattr_remote(
 		.namelen	= namelen,
 		.trans		= sc->tp,
 		.valuelen	= valuelen,
-		.owner		= ip->i_ino,
+		.owner		= I_INO(ip),
 	};
 	int			error;
 
@@ -984,7 +984,7 @@ xrep_parent_insert_xattr(
 		.attr_filter		= key->flags,
 		.namelen		= key->namelen,
 		.valuelen		= key->valuelen,
-		.owner			= rp->sc->ip->i_ino,
+		.owner			= I_INO(rp->sc->ip),
 		.geo			= rp->sc->mp->m_attr_geo,
 		.whichfork		= XFS_ATTR_FORK,
 		.op_flags		= XFS_DA_OP_OKNOENT,
@@ -1329,7 +1329,7 @@ xrep_parent_rebuild_pptrs(
 	 * For this purpose, root directories are their own parents.
 	 */
 	if (xchk_inode_is_dirtree_root(sc->ip)) {
-		xrep_findparent_scan_found(&rp->pscan, sc->ip->i_ino);
+		xrep_findparent_scan_found(&rp->pscan, I_INO(sc->ip));
 	} else {
 		error = xrep_parent_lookup_pptrs(sc, &parent_ino);
 		if (error)
diff --git a/fs/xfs/scrub/quotacheck.c b/fs/xfs/scrub/quotacheck.c
index 9ea014e2ecfd..c199d128538e 100644
--- a/fs/xfs/scrub/quotacheck.c
+++ b/fs/xfs/scrub/quotacheck.c
@@ -399,7 +399,7 @@ xqcheck_collect_inode(
 	int			error = 0;
 
 	if (xfs_is_metadir_inode(ip) ||
-	    xfs_is_quota_inode(&tp->t_mountp->m_sb, ip->i_ino)) {
+	    xfs_is_quota_inode(&tp->t_mountp->m_sb, I_INO(ip))) {
 		/*
 		 * Quota files are never counted towards quota, so we do not
 		 * need to take the lock.  Files do not switch between the
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index c66ec9093a38..d68bf20b4a14 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -50,7 +50,7 @@ xchk_dir_walk_sf(
 	dapos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
 			geo->data_entry_offset);
 
-	error = dirent_fn(sc, dp, dapos, &name, dp->i_ino, priv);
+	error = dirent_fn(sc, dp, dapos, &name, I_INO(dp), priv);
 	if (error)
 		return error;
 
@@ -100,7 +100,7 @@ xchk_dir_walk_block(
 	unsigned int		off, next_off, end;
 	int			error;
 
-	error = xfs_dir3_block_read(sc->tp, dp, dp->i_ino, &bp);
+	error = xfs_dir3_block_read(sc->tp, dp, I_INO(dp), &bp);
 	if (error)
 		return error;
 
@@ -176,7 +176,7 @@ xchk_read_leaf_dir_buf(
 	if (new_off > *curoff)
 		*curoff = new_off;
 
-	return xfs_dir3_data_read(tp, dp, dp->i_ino, map.br_startoff, 0, bpp);
+	return xfs_dir3_data_read(tp, dp, I_INO(dp), map.br_startoff, 0, bpp);
 }
 
 /* Call a function for every entry in a leaf directory. */
@@ -274,7 +274,7 @@ xchk_dir_walk(
 		.dp		= dp,
 		.geo		= dp->i_mount->m_dir_geo,
 		.trans		= sc->tp,
-		.owner		= dp->i_ino,
+		.owner		= I_INO(dp),
 	};
 	int			error;
 
@@ -320,7 +320,7 @@ xchk_dir_lookup(
 		.hashval	= xfs_dir2_hashname(dp->i_mount, name),
 		.whichfork	= XFS_DATA_FORK,
 		.op_flags	= XFS_DA_OP_OKNOENT,
-		.owner		= dp->i_ino,
+		.owner		= I_INO(dp),
 	};
 	int			error;
 
@@ -332,7 +332,7 @@ xchk_dir_lookup(
 	 * set to sc->ip, so we must switch the owner here for the lookup.
 	 */
 	if (dp == sc->tempip)
-		args.owner = sc->ip->i_ino;
+		args.owner = I_INO(sc->ip);
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
 	xfs_assert_ilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL);
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index ac8c592579bd..11697a8b2a1d 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -816,7 +816,7 @@ xrep_ino_dqattach(
 	case -ENOENT:
 		xfs_err_ratelimited(sc->mp,
 "inode %llu repair encountered quota error %d, quotacheck forced.",
-				(unsigned long long)sc->ip->i_ino, error);
+				(unsigned long long)I_INO(sc->ip), error);
 		if (XFS_IS_UQUOTA_ON(sc->mp) && !sc->ip->i_udquot)
 			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
 		if (XFS_IS_GQUOTA_ON(sc->mp) && !sc->ip->i_gdquot)
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 6766df9922e8..590f9f41856e 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -570,7 +570,7 @@ xrep_rmap_scan_ifork(
 	int			whichfork)
 {
 	struct xrep_rmap_ifork	rf = {
-		.accum		= { .rm_owner = ip->i_ino, },
+		.accum		= { .rm_owner = I_INO(ip), },
 		.rr		= rr,
 		.whichfork	= whichfork,
 	};
diff --git a/fs/xfs/scrub/rtbitmap_repair.c b/fs/xfs/scrub/rtbitmap_repair.c
index f4ca86a2ea1b..dc64902d6c25 100644
--- a/fs/xfs/scrub/rtbitmap_repair.c
+++ b/fs/xfs/scrub/rtbitmap_repair.c
@@ -382,7 +382,7 @@ xrep_rtbitmap_prep_buf(
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
 		hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
-		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
+		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
 		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr->rt_lsn = 0;
 		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index f165fb397647..2b939960c7dd 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -360,7 +360,7 @@ xrep_rtrefc_walk_rmap(
 		return error;
 
 	/* Skip extents which are not owned by this inode and fork. */
-	if (rec->rm_owner != rr->sc->ip->i_ino)
+	if (rec->rm_owner != I_INO(rr->sc->ip))
 		return 0;
 
 	error = xrep_check_ino_btree_mapping(rr->sc, rec);
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index f2d16ca8d251..a2b72e61edf5 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -324,7 +324,7 @@ xrep_rtrmap_scan_dfork(
 	struct xfs_inode	*ip)
 {
 	struct xrep_rtrmap_ifork rf = {
-		.accum		= { .rm_owner = ip->i_ino, },
+		.accum		= { .rm_owner = I_INO(ip), },
 		.rr		= rr,
 	};
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
@@ -392,7 +392,7 @@ xrep_rtrmap_walk_rmap(
 		return error;
 
 	/* Skip extents which are not owned by this inode and fork. */
-	if (rec->rm_owner != rr->sc->ip->i_ino)
+	if (rec->rm_owner != I_INO(rr->sc->ip))
 		return 0;
 
 	error = xrep_check_ino_btree_mapping(rr->sc, rec);
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index afffbd6e0ad1..f065c3e51ce2 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -91,7 +91,7 @@ xrep_rtsummary_prep_buf(
 		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
 
 		hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
-		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
+		hdr->rt_owner = cpu_to_be64(I_INO(sc->ip));
 		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
 		hdr->rt_lsn = 0;
 		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 27511a125b39..8742445c86f4 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -955,7 +955,7 @@ xfs_ioc_scrubv_metadata(
 	 * because each scrubber gets to decide its own strategy and return
 	 * values for getting an inode.
 	 */
-	if (head.svh_ino && head.svh_ino != ip_in->i_ino)
+	if (head.svh_ino && head.svh_ino != I_INO(ip_in))
 		handle_ip = xchk_scrubv_open_by_handle(mp, &head);
 
 	/* Run all the scrubbers. */
diff --git a/fs/xfs/scrub/symlink_repair.c b/fs/xfs/scrub/symlink_repair.c
index 25416dfb5189..91c86ea0e0f1 100644
--- a/fs/xfs/scrub/symlink_repair.c
+++ b/fs/xfs/scrub/symlink_repair.c
@@ -144,7 +144,7 @@ xrep_symlink_salvage_remote(
 		fa = bp->b_ops->verify_struct(bp);
 		dsl = bp->b_addr;
 		magic_ok = dsl->sl_magic == cpu_to_be32(XFS_SYMLINK_MAGIC);
-		hdr_ok = xfs_symlink_hdr_ok(ip->i_ino, offset, byte_cnt, bp);
+		hdr_ok = xfs_symlink_hdr_ok(I_INO(ip), offset, byte_cnt, bp);
 		if (!hdr_ok || (fa != NULL && !magic_ok))
 			break;
 
@@ -259,7 +259,7 @@ xrep_symlink_local_to_remote(
 	if (!xfs_has_crc(sc->mp))
 		return;
 
-	dsl->sl_owner = cpu_to_be64(sc->ip->i_ino);
+	dsl->sl_owner = cpu_to_be64(I_INO(sc->ip));
 	xfs_trans_log_buf(tp, bp, 0,
 			  sizeof(struct xfs_dsymlink_hdr) + ifp->if_bytes - 1);
 }
@@ -375,7 +375,7 @@ xrep_symlink_reset_fork(
 
 	/* Reset the temp symlink target to dummy content. */
 	xfs_idestroy_fork(ifp);
-	return xfs_symlink_write_target(sc->tp, sc->tempip, sc->tempip->i_ino,
+	return xfs_symlink_write_target(sc->tp, sc->tempip, I_INO(sc->tempip),
 			"?", 1, 0, 0);
 }
 
@@ -434,7 +434,7 @@ xrep_symlink_rebuild(
 	sc->tempip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 
 	/* Write the salvaged target to the temporary link. */
-	error = xfs_symlink_write_target(sc->tp, sc->tempip, sc->ip->i_ino,
+	error = xfs_symlink_write_target(sc->tp, sc->tempip, I_INO(sc->ip),
 			target_buf, target_len, fs_blocks, resblks);
 	if (error)
 		return error;
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 8d754df72aa5..e0c630f888cf 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -121,7 +121,7 @@ xrep_tempfile_create(
 		 * remote target block, so the owner is irrelevant.
 		 */
 		error = xfs_symlink_write_target(tp, sc->tempip,
-				sc->tempip->i_ino, ".", 1, 0, 0);
+				I_INO(sc->tempip), ".", 1, 0, 0);
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index f607ac5fb953..d27c99beee13 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -162,7 +162,7 @@ DECLARE_EVENT_CLASS(xchk_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->type = sm->sm_type;
 		__entry->agno = sm->sm_agno;
 		__entry->inum = sm->sm_ino;
@@ -236,7 +236,7 @@ DECLARE_EVENT_CLASS(xchk_vector_head_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->agno = vhead->svh_agno;
 		__entry->inum = vhead->svh_ino;
 		__entry->gen = vhead->svh_gen;
@@ -340,7 +340,7 @@ TRACE_EVENT(xchk_file_op_error,
 	),
 	TP_fast_assign(
 		__entry->dev = sc->ip->i_mount->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = I_INO(sc->ip);
 		__entry->whichfork = whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->offset = offset;
@@ -438,7 +438,7 @@ DECLARE_EVENT_CLASS(xchk_fblock_error_class,
 	),
 	TP_fast_assign(
 		__entry->dev = sc->ip->i_mount->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = I_INO(sc->ip);
 		__entry->whichfork = whichfork;
 		__entry->type = sc->sm->sm_type;
 		__entry->offset = offset;
@@ -481,7 +481,7 @@ DECLARE_EVENT_CLASS(xchk_dqiter_class,
 	TP_fast_assign(
 		__entry->dev = cursor->sc->mp->m_super->s_dev;
 		__entry->dqtype = cursor->dqtype;
-		__entry->ino = cursor->quota_ip->i_ino;
+		__entry->ino = I_INO(cursor->quota_ip);
 		__entry->cur_id = cursor->id;
 		__entry->startoff = cursor->bmap.br_startoff;
 		__entry->startblock = cursor->bmap.br_startblock;
@@ -613,7 +613,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = cur->bc_ino.ip->i_ino;
+		__entry->ino = I_INO(cur->bc_ino.ip);
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__assign_str(name);
@@ -693,7 +693,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 	TP_fast_assign(
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->ip->i_ino;
+		__entry->ino = I_INO(sc->ip);
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
 		__assign_str(name);
@@ -839,7 +839,7 @@ TRACE_EVENT(xchk_inode_is_allocated,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->iflags = ip->i_flags;
 		__entry->mode = VFS_I(ip)->i_mode;
 	),
@@ -1437,7 +1437,7 @@ TRACE_EVENT(xchk_nlinks_collect_dirent,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->dir = dp->i_ino;
+		__entry->dir = I_INO(dp);
 		__entry->ino = ino;
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
@@ -1464,7 +1464,7 @@ TRACE_EVENT(xchk_nlinks_collect_pptr,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->dir = dp->i_ino;
+		__entry->dir = I_INO(dp);
 		__entry->ino = be64_to_cpu(pptr->p_ino);
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
@@ -1509,7 +1509,7 @@ TRACE_EVENT(xchk_nlinks_live_update,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->dir = dp ? dp->i_ino : NULLFSINO;
+		__entry->dir = dp ? I_INO(dp) : NULLFSINO;
 		__entry->action = action;
 		__entry->ino = ino;
 		__entry->delta = delta;
@@ -1602,7 +1602,7 @@ DECLARE_EVENT_CLASS(xchk_nlinks_diff_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->ftype = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
 		__entry->nlink = VFS_I(ip)->i_nlink;
 		__entry->parents = live->parents;
@@ -1638,7 +1638,7 @@ DECLARE_EVENT_CLASS(xchk_pptr_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name, name->len);
 		__entry->far_ino = far_ino;
@@ -1680,7 +1680,7 @@ DECLARE_EVENT_CLASS(xchk_dirtree_class,
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->path_nr = path_nr;
-		__entry->child_ino = ip->i_ino;
+		__entry->child_ino = I_INO(ip);
 		__entry->child_gen = VFS_I(ip)->i_generation;
 		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
 		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
@@ -1727,7 +1727,7 @@ DECLARE_EVENT_CLASS(xchk_dirpath_class,
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->path_nr = path_nr;
 		__entry->step_nr = step_nr;
-		__entry->child_ino = ip->i_ino;
+		__entry->child_ino = I_INO(ip);
 		__entry->child_gen = VFS_I(ip)->i_generation;
 		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
 		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
@@ -1830,7 +1830,7 @@ DECLARE_EVENT_CLASS(xchk_dirtree_evaluate_class,
 	),
 	TP_fast_assign(
 		__entry->dev = dl->sc->mp->m_super->s_dev;
-		__entry->ino = dl->sc->ip->i_ino;
+		__entry->ino = I_INO(dl->sc->ip);
 		__entry->rootino = dl->root_ino;
 		__entry->nr_paths = dl->nr_paths;
 		__entry->bad = oc->bad;
@@ -1873,8 +1873,8 @@ TRACE_EVENT(xchk_dirpath_changed,
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->path_nr = path_nr;
 		__entry->step_nr = step_nr;
-		__entry->child_ino = ip->i_ino;
-		__entry->parent_ino = dp->i_ino;
+		__entry->child_ino = I_INO(ip);
+		__entry->parent_ino = I_INO(dp);
 		__entry->namelen = xname->len;
 		memcpy(__get_str(name), xname->name, xname->len);
 	),
@@ -1904,9 +1904,9 @@ TRACE_EVENT(xchk_dirtree_live_update,
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->parent_ino = dp->i_ino;
+		__entry->parent_ino = I_INO(dp);
 		__entry->action = action;
-		__entry->child_ino = ip->i_ino;
+		__entry->child_ino = I_INO(ip);
 		__entry->delta = delta;
 		__entry->namelen = xname->len;
 		memcpy(__get_str(name), xname->name, xname->len);
@@ -1933,8 +1933,8 @@ DECLARE_EVENT_CLASS(xchk_metapath_class,
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->scrub_ino = sc->ip ? sc->ip->i_ino : NULLFSINO;
-		__entry->parent_ino = dp ? dp->i_ino : NULLFSINO;
+		__entry->scrub_ino = sc->ip ? I_INO(sc->ip) : NULLFSINO;
+		__entry->parent_ino = dp ? I_INO(dp) : NULLFSINO;
 		__entry->ino = ino;
 		__assign_str(name);
 	),
@@ -2208,7 +2208,7 @@ TRACE_EVENT(xrep_bmap_found,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->whichfork = whichfork;
 		__entry->lblk = irec->br_startoff;
 		__entry->len = irec->br_blockcount;
@@ -2609,7 +2609,7 @@ TRACE_EVENT(xrep_dinode_findmode_dirent,
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->ino = sc->sm->sm_ino;
-		__entry->parent_ino = dp->i_ino;
+		__entry->parent_ino = I_INO(dp);
 		__entry->ftype = ftype;
 	),
 	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx ftype '%s'",
@@ -2633,7 +2633,7 @@ TRACE_EVENT(xrep_dinode_findmode_dirent_inval,
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->ino = sc->sm->sm_ino;
-		__entry->parent_ino = dp->i_ino;
+		__entry->parent_ino = I_INO(dp);
 		__entry->ftype = ftype;
 		__entry->found_ftype = found_ftype;
 	),
@@ -2658,7 +2658,7 @@ TRACE_EVENT(xrep_cow_mark_file_range,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->startoff = startoff;
 		__entry->startblock = startblock;
 		__entry->blockcount = blockcount;
@@ -2687,7 +2687,7 @@ TRACE_EVENT(xrep_cow_replace_mapping,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->startoff = irec->br_startoff;
 		__entry->startblock = irec->br_startblock;
 		__entry->blockcount = irec->br_blockcount;
@@ -2817,13 +2817,13 @@ TRACE_EVENT(xrep_tempfile_create,
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->file ? XFS_I(file_inode(sc->file))->i_ino : 0;
+		__entry->ino = sc->file ? file_inode(sc->file)->i_ino : 0;
 		__entry->type = sc->sm->sm_type;
 		__entry->agno = sc->sm->sm_agno;
 		__entry->inum = sc->sm->sm_ino;
 		__entry->gen = sc->sm->sm_gen;
 		__entry->flags = sc->sm->sm_flags;
-		__entry->temp_inum = sc->tempip->i_ino;
+		__entry->temp_inum = I_INO(sc->tempip);
 	),
 	TP_printk("dev %d:%d ino 0x%llx type %s inum 0x%llx gen 0x%x flags 0x%x temp_inum 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -2850,7 +2850,7 @@ DECLARE_EVENT_CLASS(xrep_tempfile_class,
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = sc->tempip->i_ino;
+		__entry->ino = I_INO(sc->tempip);
 		__entry->whichfork = whichfork;
 		__entry->lblk = irec->br_startoff;
 		__entry->len = irec->br_blockcount;
@@ -2890,7 +2890,7 @@ TRACE_EVENT(xreap_ifork_extent,
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->whichfork = whichfork;
 		__entry->fileoff = irec->br_startoff;
 		__entry->len = irec->br_blockcount;
@@ -2946,7 +2946,7 @@ TRACE_EVENT(xrep_xattr_recover_leafblock,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->dabno = dabno;
 		__entry->magic = magic;
 	),
@@ -2971,7 +2971,7 @@ DECLARE_EVENT_CLASS(xrep_xattr_salvage_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->flags = flags;
 		__entry->namelen = namelen;
 		memcpy(__get_str(name), name, namelen);
@@ -3011,7 +3011,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_salvage_class,
 		const struct xfs_parent_rec	*rec = value;
 
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->parent_ino = be64_to_cpu(rec->p_ino);
 		__entry->parent_gen = be32_to_cpu(rec->p_gen);
 		__entry->namelen = namelen;
@@ -3043,8 +3043,8 @@ DECLARE_EVENT_CLASS(xrep_xattr_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->src_ino = arg_ip->i_ino;
+		__entry->ino = I_INO(ip);
+		__entry->src_ino = I_INO(arg_ip);
 	),
 	TP_printk("dev %d:%d ino 0x%llx src 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
@@ -3073,8 +3073,8 @@ DECLARE_EVENT_CLASS(xrep_xattr_pptr_scan_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->parent_ino = dp->i_ino;
+		__entry->ino = I_INO(ip);
+		__entry->parent_ino = I_INO(dp);
 		__entry->parent_gen = VFS_IC(dp)->i_generation;
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
@@ -3108,7 +3108,7 @@ TRACE_EVENT(xrep_dir_recover_dirblock,
 	),
 	TP_fast_assign(
 		__entry->dev = dp->i_mount->m_super->s_dev;
-		__entry->dir_ino = dp->i_ino;
+		__entry->dir_ino = I_INO(dp);
 		__entry->dabno = dabno;
 		__entry->magic = magic;
 		__entry->magic_guess = magic_guess;
@@ -3131,7 +3131,7 @@ DECLARE_EVENT_CLASS(xrep_dir_class,
 	),
 	TP_fast_assign(
 		__entry->dev = dp->i_mount->m_super->s_dev;
-		__entry->dir_ino = dp->i_ino;
+		__entry->dir_ino = I_INO(dp);
 		__entry->parent_ino = parent_ino;
 	),
 	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
@@ -3161,7 +3161,7 @@ DECLARE_EVENT_CLASS(xrep_dirent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = dp->i_mount->m_super->s_dev;
-		__entry->dir_ino = dp->i_ino;
+		__entry->dir_ino = I_INO(dp);
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
 		__entry->ino = ino;
@@ -3198,8 +3198,8 @@ DECLARE_EVENT_CLASS(xrep_adoption_class,
 	),
 	TP_fast_assign(
 		__entry->dev = dp->i_mount->m_super->s_dev;
-		__entry->dir_ino = dp->i_ino;
-		__entry->child_ino = ip->i_ino;
+		__entry->dir_ino = I_INO(dp);
+		__entry->child_ino = I_INO(ip);
 		__entry->moved = moved;
 	),
 	TP_printk("dev %d:%d dir 0x%llx child 0x%llx moved? %d",
@@ -3224,7 +3224,7 @@ DECLARE_EVENT_CLASS(xrep_parent_salvage_class,
 	),
 	TP_fast_assign(
 		__entry->dev = dp->i_mount->m_super->s_dev;
-		__entry->dir_ino = dp->i_ino;
+		__entry->dir_ino = I_INO(dp);
 		__entry->ino = ino;
 	),
 	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
@@ -3254,7 +3254,7 @@ DECLARE_EVENT_CLASS(xrep_pptr_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
 		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
 		__entry->namelen = name->len;
@@ -3292,8 +3292,8 @@ DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->parent_ino = dp->i_ino;
+		__entry->ino = I_INO(ip);
+		__entry->parent_ino = I_INO(dp);
 		__entry->parent_gen = VFS_IC(dp)->i_generation;
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
@@ -3392,7 +3392,7 @@ TRACE_EVENT(xrep_symlink_salvage_target,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->targetlen = targetlen;
 		memcpy(__get_str(target), target, targetlen);
 		__get_str(target)[targetlen] = 0;
@@ -3413,7 +3413,7 @@ DECLARE_EVENT_CLASS(xrep_symlink_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 	),
 	TP_printk("dev %d:%d ip 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f279055fcea0..1a82cf625a08 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -268,7 +268,7 @@ xfs_discard_folio(
 
 	xfs_alert_ratelimited(mp,
 		"page discard on page "PTR_FMT", inode 0x%llx, pos %llu.",
-			folio, ip->i_ino, pos);
+			folio, I_INO(ip), pos);
 
 	/*
 	 * The end of the punch range is always the offset of the first
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index deab14f31b38..a53ee2b0c54a 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -378,7 +378,7 @@ xfs_attr_log_item(
 	 * structure with fields from this xfs_attr_intent
 	 */
 	attrp = &attrip->attri_format;
-	attrp->alfi_ino = args->dp->i_ino;
+	attrp->alfi_ino = I_INO(args->dp);
 	ASSERT(!(attr->xattri_op_flags & ~XFS_ATTRI_OP_FLAGS_TYPE_MASK));
 	attrp->alfi_op_flags = attr->xattri_op_flags;
 	attrp->alfi_value_len = nv->value.iov_len;
@@ -695,7 +695,7 @@ xfs_attri_recover_work(
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
-	args->owner = args->dp->i_ino;
+	args->owner = I_INO(args->dp);
 	xfs_attr_sethash(args);
 
 	switch (xfs_attr_intent_op(attr)) {
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 114566b1ae5c..f751edb930b6 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -248,7 +248,7 @@ xfs_attr_node_list_lookup(
 			goto out_corruptbuf;
 		}
 
-		fa = xfs_da3_node_header_check(bp, dp->i_ino);
+		fa = xfs_da3_node_header_check(bp, I_INO(dp));
 		if (fa)
 			goto out_corruptbuf;
 
@@ -287,7 +287,7 @@ xfs_attr_node_list_lookup(
 		}
 	}
 
-	fa = xfs_attr3_leaf_header_check(bp, dp->i_ino);
+	fa = xfs_attr3_leaf_header_check(bp, I_INO(dp));
 	if (fa) {
 		__xfs_buf_mark_corrupt(bp, fa);
 		goto out_releasebuf;
@@ -348,7 +348,7 @@ xfs_attr_node_list(
 		case XFS_DA_NODE_MAGIC:
 		case XFS_DA3_NODE_MAGIC:
 			trace_xfs_attr_list_wrong_blk(context);
-			fa = xfs_da3_node_header_check(bp, dp->i_ino);
+			fa = xfs_da3_node_header_check(bp, I_INO(dp));
 			if (fa) {
 				__xfs_buf_mark_corrupt(bp, fa);
 				xfs_dirattr_mark_sick(dp, XFS_ATTR_FORK);
@@ -359,7 +359,7 @@ xfs_attr_node_list(
 		case XFS_ATTR_LEAF_MAGIC:
 		case XFS_ATTR3_LEAF_MAGIC:
 			leaf = bp->b_addr;
-			fa = xfs_attr3_leaf_header_check(bp, dp->i_ino);
+			fa = xfs_attr3_leaf_header_check(bp, I_INO(dp));
 			if (fa) {
 				__xfs_buf_mark_corrupt(bp, fa);
 				xfs_trans_brelse(context->tp, bp);
@@ -417,7 +417,7 @@ xfs_attr_node_list(
 			break;
 		cursor->blkno = leafhdr.forw;
 		xfs_trans_brelse(context->tp, bp);
-		error = xfs_attr3_leaf_read(context->tp, dp, dp->i_ino,
+		error = xfs_attr3_leaf_read(context->tp, dp, I_INO(dp),
 				cursor->blkno, &bp);
 		if (error)
 			return error;
@@ -543,7 +543,7 @@ xfs_attr_leaf_list(
 
 	context->cursor.blkno = 0;
 	error = xfs_attr3_leaf_read(context->tp, context->dp,
-			context->dp->i_ino, 0, &bp);
+			I_INO(context->dp), 0, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index b237a25d6045..89f6e79a955f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -245,7 +245,7 @@ xfs_bmap_update_diff_items(
 	struct xfs_bmap_intent		*ba = bi_entry(a);
 	struct xfs_bmap_intent		*bb = bi_entry(b);
 
-	return cmp_int(ba->bi_owner->i_ino, bb->bi_owner->i_ino);
+	return cmp_int(I_INO(ba->bi_owner), I_INO(bb->bi_owner));
 }
 
 /* Log bmap updates in the intent item. */
@@ -266,7 +266,7 @@ xfs_bmap_update_log_item(
 	next_extent = atomic_inc_return(&buip->bui_next_extent) - 1;
 	ASSERT(next_extent < buip->bui_format.bui_nextents);
 	map = &buip->bui_format.bui_extents[next_extent];
-	map->me_owner = bi->bi_owner->i_ino;
+	map->me_owner = I_INO(bi->bi_owner);
 	map->me_startblock = bi->bi_bmap.br_startblock;
 	map->me_startoff = bi->bi_bmap.br_startoff;
 	map->me_len = bi->bi_bmap.br_blockcount;
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0ab00615f1ad..3b9f262f8e91 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1479,7 +1479,7 @@ xfs_swap_change_owner(
 	struct xfs_trans	*tp = *tpp;
 
 	do {
-		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, ip->i_ino,
+		error = xfs_bmbt_change_owner(tp, ip, XFS_DATA_FORK, I_INO(ip),
 					      NULL);
 		/* success or fatal error */
 		if (error != -EAGAIN)
@@ -1631,7 +1631,7 @@ xfs_swap_extents(
 	if (error) {
 		xfs_notice(mp,
 		    "%s: inode 0x%llx format is incompatible for exchanging.",
-				__func__, ip->i_ino);
+				__func__, I_INO(ip));
 		goto out_trans_cancel;
 	}
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 60a80d4173f7..577f7a581043 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -84,7 +84,7 @@ xfs_dir2_sf_getdents(
 	 */
 	if (ctx->pos <= dot_offset) {
 		ctx->pos = dot_offset & 0x7fffffff;
-		if (!dir_emit(ctx, ".", 1, dp->i_ino, DT_DIR))
+		if (!dir_emit(ctx, ".", 1, I_INO(dp), DT_DIR))
 			return 0;
 	}
 
@@ -532,7 +532,7 @@ xfs_readdir(
 	args.dp = dp;
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
-	args.owner = dp->i_ino;
+	args.owner = I_INO(dp);
 
 	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_dir2_sf_getdents(&args, ctx);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d652240a1dca..9ece70fd94ca 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -369,7 +369,7 @@ xfs_inode_verifier_error(
 
 	xfs_alert(mp, "Metadata %s detected at %pS, inode 0x%llx %s",
 		  error == -EFSBADCRC ? "CRC error" : "corruption",
-		  fa, ip->i_ino, name);
+		  fa, I_INO(ip), name);
 
 	xfs_alert(mp, "Unmount and run xfs_repair");
 
diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 13a42467370f..c3745d33e54e 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -227,9 +227,9 @@ xfs_exchmaps_create_intent(
 	xmi_lip = xfs_xmi_init(tp->t_mountp);
 	xlf = &xmi_lip->xmi_format;
 
-	xlf->xmi_inode1 = xmi->xmi_ip1->i_ino;
+	xlf->xmi_inode1 = I_INO(xmi->xmi_ip1);
 	xlf->xmi_igen1 = VFS_I(xmi->xmi_ip1)->i_generation;
-	xlf->xmi_inode2 = xmi->xmi_ip2->i_ino;
+	xlf->xmi_inode2 = I_INO(xmi->xmi_ip2);
 	xlf->xmi_igen2 = VFS_I(xmi->xmi_ip2)->i_generation;
 	xlf->xmi_startoff1 = xmi->xmi_startoff1;
 	xlf->xmi_startoff2 = xmi->xmi_startoff2;
diff --git a/fs/xfs/xfs_exchrange.c b/fs/xfs/xfs_exchrange.c
index 5c083f29ea65..94965a6c2187 100644
--- a/fs/xfs/xfs_exchrange.c
+++ b/fs/xfs/xfs_exchrange.c
@@ -91,7 +91,7 @@ xfs_exchrange_check_freshness(
 	trace_xfs_exchrange_freshness(fxr, ip2);
 
 	/* Check that file2 hasn't otherwise been modified. */
-	if (fxr->file2_ino != ip2->i_ino ||
+	if (fxr->file2_ino != inode2->i_ino ||
 	    fxr->file2_gen != inode2->i_generation ||
 	    !timespec64_equal(&fxr->file2_ctime, &ctime) ||
 	    !timespec64_equal(&fxr->file2_mtime, &mtime))
@@ -863,7 +863,7 @@ xfs_ioc_start_commit(
 	kern_f->file2_ctime_nsec	= kstat.ctime.tv_nsec;
 	kern_f->file2_mtime		= kstat.mtime.tv_sec;
 	kern_f->file2_mtime_nsec	= kstat.mtime.tv_nsec;
-	kern_f->file2_ino		= ip2->i_ino;
+	kern_f->file2_ino		= inode2->i_ino;
 	kern_f->file2_gen		= inode2->i_generation;
 	kern_f->magic			= XCR_FRESH_MAGIC;
 	xfs_iunlock(ip2, lockflags);
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index e3e3c3c89840..82b884a81f7b 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -82,19 +82,19 @@ xfs_fs_encode_fh(
 
 	switch (fileid_type) {
 	case FILEID_INO32_GEN_PARENT:
-		fid->i32.parent_ino = XFS_I(parent)->i_ino;
+		fid->i32.parent_ino = parent->i_ino;
 		fid->i32.parent_gen = parent->i_generation;
 		fallthrough;
 	case FILEID_INO32_GEN:
-		fid->i32.ino = XFS_I(inode)->i_ino;
+		fid->i32.ino = inode->i_ino;
 		fid->i32.gen = inode->i_generation;
 		break;
 	case FILEID_INO32_GEN_PARENT | XFS_FILEID_TYPE_64FLAG:
-		fid64->parent_ino = XFS_I(parent)->i_ino;
+		fid64->parent_ino = parent->i_ino;
 		fid64->parent_gen = parent->i_generation;
 		fallthrough;
 	case FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG:
-		fid64->ino = XFS_I(inode)->i_ino;
+		fid64->ino = inode->i_ino;
 		fid64->gen = inode->i_generation;
 		break;
 	}
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 32e641d76e92..bb46852075f2 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -225,7 +225,7 @@ xfs_filestream_lookup_association(
 	atomic_inc(&pag_group(pag)->xg_active_ref);
 	xfs_mru_cache_done(mp->m_filestream);
 
-	trace_xfs_filestream_lookup(pag, ap->ip->i_ino);
+	trace_xfs_filestream_lookup(pag, I_INO(ap->ip));
 
 	ap->blkno = xfs_agbno_to_fsb(pag, 0);
 	xfs_bmap_adjacent(ap);
@@ -345,7 +345,7 @@ xfs_filestream_select_ag(
 	args->total = ap->total;
 	pip = xfs_filestream_get_parent(ap->ip);
 	if (pip) {
-		ino = pip->i_ino;
+		ino = I_INO(pip);
 		error = xfs_filestream_lookup_association(ap, args, ino,
 				longest);
 		xfs_irele(pip);
@@ -370,7 +370,7 @@ void
 xfs_filestream_deassociate(
 	struct xfs_inode	*ip)
 {
-	xfs_mru_cache_delete(ip->i_mount->m_filestream, ip->i_ino);
+	xfs_mru_cache_delete(ip->i_mount->m_filestream, I_INO(ip));
 }
 
 int
diff --git a/fs/xfs/xfs_handle.c b/fs/xfs/xfs_handle.c
index 2b8617ae7ec2..0689cade8f74 100644
--- a/fs/xfs/xfs_handle.c
+++ b/fs/xfs/xfs_handle.c
@@ -124,7 +124,7 @@ xfs_find_handle(
 	if (cmd == XFS_IOC_PATH_TO_FSHANDLE)
 		hsize = xfs_fshandle_init(ip->i_mount, &handle);
 	else
-		hsize = xfs_filehandle_init(ip->i_mount, ip->i_ino,
+		hsize = xfs_filehandle_init(ip->i_mount, inode->i_ino,
 				inode->i_generation, &handle);
 
 	error = -EFAULT;
@@ -808,7 +808,7 @@ xfs_getparents(
 			sizeof(struct xfs_attrlist_cursor));
 
 	/* Is this the root directory? */
-	if (ip->i_ino == mp->m_sb.sb_rootino)
+	if (I_INO(ip) == mp->m_sb.sb_rootino)
 		gp->gp_oflags |= XFS_GETPARENTS_OFLAG_ROOT;
 
 	if (gpx->context.seen_enough == 0) {
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
index 26c325d34bd1..4521ffdab9f1 100644
--- a/fs/xfs/xfs_healthmon.c
+++ b/fs/xfs/xfs_healthmon.c
@@ -533,7 +533,7 @@ xfs_healthmon_report_inode(
 	struct xfs_healthmon_event	event = {
 		.type			= type,
 		.domain			= XFS_HEALTHMON_INODE,
-		.ino			= ip->i_ino,
+		.ino			= I_INO(ip),
 		.gen			= VFS_I(ip)->i_generation,
 	};
 	struct xfs_healthmon		*hm = xfs_healthmon_get(ip->i_mount);
@@ -646,7 +646,7 @@ xfs_healthmon_report_file_ioerror(
 	struct xfs_healthmon_event	event = {
 		.type			= file_ioerr_type(p->type),
 		.domain			= XFS_HEALTHMON_FILERANGE,
-		.fino			= ip->i_ino,
+		.fino			= I_INO(ip),
 		.fgen			= VFS_I(ip)->i_generation,
 		.fpos			= p->pos,
 		.flen			= p->len,
@@ -1182,7 +1182,7 @@ xfs_ioc_health_monitor(
 	 */
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (ip->i_ino != mp->m_sb.sb_rootino)
+	if (I_INO(ip) != mp->m_sb.sb_rootino)
 		return -EPERM;
 	if (current_user_ns() != &init_user_ns)
 		return -EPERM;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 37caed10c089..6f19e751bb8a 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -101,6 +101,7 @@ xfs_inode_alloc(
 		return NULL;
 	}
 
+	VFS_I(ip)->i_ino = ino;
 	/* VFS doesn't initialise i_mode! */
 	VFS_I(ip)->i_mode = 0;
 	mapping_set_folio_min_order(VFS_I(ip)->i_mapping,
@@ -108,10 +109,8 @@ xfs_inode_alloc(
 
 	XFS_STATS_INC(mp, xs_inodes_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
-	ASSERT(ip->i_ino == 0);
 
 	/* initialise the xfs inode */
-	ip->i_ino = ino;
 	ip->i_mount = mp;
 	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
 	ip->i_cowfp = NULL;
@@ -193,7 +192,7 @@ xfs_inode_free(
 	 */
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
-	ip->i_ino = 0;
+	VFS_I(ip)->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
 	__xfs_inode_free(ip);
@@ -329,6 +328,7 @@ xfs_reinit_inode(
 	struct inode		*inode)
 {
 	int			error;
+	u64			ino = inode->i_ino;
 	uint32_t		nlink = inode->i_nlink;
 	uint32_t		generation = inode->i_generation;
 	uint64_t		version = inode_peek_iversion(inode);
@@ -340,6 +340,7 @@ xfs_reinit_inode(
 
 	error = inode_init_always(mp->m_super, inode);
 
+	inode->i_ino = ino;
 	set_nlink(inode, nlink);
 	inode->i_generation = generation;
 	inode_set_iversion_queried(inode, version);
@@ -426,7 +427,7 @@ xfs_iget_check_free_state(
 		if (VFS_I(ip)->i_mode != 0) {
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx not marked free! (mode 0x%x)",
-				ip->i_ino, VFS_I(ip)->i_mode);
+				I_INO(ip), VFS_I(ip)->i_mode);
 			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
 					XFS_SICK_AG_INOBT);
 			return -EFSCORRUPTED;
@@ -435,7 +436,7 @@ xfs_iget_check_free_state(
 		if (ip->i_nblocks != 0) {
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx has blocks allocated!",
-				ip->i_ino);
+				I_INO(ip));
 			xfs_agno_mark_sick(ip->i_mount, XFS_INODE_TO_AGNO(ip),
 					XFS_SICK_AG_INOBT);
 			return -EFSCORRUPTED;
@@ -514,7 +515,7 @@ xfs_iget_cache_hit(
 	 * will not match, so check for that, too.
 	 */
 	spin_lock(&ip->i_flags_lock);
-	if (ip->i_ino != ino)
+	if (I_INO(ip) != ino)
 		goto out_skip;
 
 	/*
@@ -644,7 +645,7 @@ xfs_iget_cache_miss(
 	 */
 	xfs_iflags_set(ip, XFS_INEW);
 
-	error = xfs_imap(pag, tp, ip->i_ino, &ip->i_imap, flags);
+	error = xfs_imap(pag, tp, I_INO(ip), &ip->i_imap, flags);
 	if (error)
 		goto out_destroy;
 
@@ -963,7 +964,7 @@ xfs_reclaim_inode(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag)
 {
-	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
+	xfs_ino_t		ino = I_INO(ip); /* for radix_tree_delete */
 
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 		goto out;
@@ -1011,7 +1012,7 @@ xfs_reclaim_inode(
 	 */
 	spin_lock(&ip->i_flags_lock);
 	ip->i_flags = XFS_IRECLAIM;
-	ip->i_ino = 0;
+	VFS_I(ip)->i_ino = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	spin_unlock(&ip->i_flags_lock);
@@ -1511,7 +1512,7 @@ xfs_blockgc_igrab(
 
 	/* Check for stale RCU freed inode */
 	spin_lock(&ip->i_flags_lock);
-	if (!ip->i_ino)
+	if (!I_INO(ip))
 		goto out_unlock_noent;
 
 	if (ip->i_flags & XFS_BLOCKGC_NOGRAB_IFLAGS)
@@ -1805,7 +1806,7 @@ xfs_icwalk_ag(
 			 */
 			if (XFS_INODE_TO_AGNO(ip) != pag_agno(pag))
 				continue;
-			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
+			first_index = XFS_INO_TO_AGINO(mp, I_INO(ip) + 1);
 			if (first_index < XFS_INODE_TO_AGINO(ip))
 				done = true;
 		}
@@ -1893,7 +1894,7 @@ xfs_check_delalloc(
 		if (isnullstartblock(got.br_startblock)) {
 			xfs_warn(ip->i_mount,
 	"ino %llx %s fork has delalloc extent at [0x%llx:0x%llx]",
-				ip->i_ino,
+				I_INO(ip),
 				whichfork == XFS_DATA_FORK ? "data" : "cow",
 				got.br_startoff, got.br_blockcount);
 		}
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f9015a1c6bd8..8452bc5d28a9 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -495,9 +495,9 @@ xfs_lock_two_inodes(
 	ASSERT(!(ip1_mode & (XFS_IOLOCK_SHARED|XFS_IOLOCK_EXCL)));
 	ASSERT(!(ip0_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)));
 	ASSERT(!(ip1_mode & (XFS_MMAPLOCK_SHARED|XFS_MMAPLOCK_EXCL)));
-	ASSERT(ip0->i_ino != ip1->i_ino);
+	ASSERT(I_INO(ip0) != I_INO(ip1));
 
-	if (ip0->i_ino > ip1->i_ino) {
+	if (I_INO(ip0) > I_INO(ip1)) {
 		swap(ip0, ip1);
 		swap(ip0_mode, ip1_mode);
 	}
@@ -1519,7 +1519,7 @@ xfs_iunlink_lookup(
 	 * Inode in RCU freeing limbo should not happen.  Warn about this and
 	 * let the caller handle the failure.
 	 */
-	if (WARN_ON_ONCE(!ip->i_ino)) {
+	if (WARN_ON_ONCE(!I_INO(ip))) {
 		rcu_read_unlock();
 		return NULL;
 	}
@@ -1620,7 +1620,7 @@ xfs_ifree_mark_inode_stale(
 	 * valid, the wrong inode or stale.
 	 */
 	spin_lock(&ip->i_flags_lock);
-	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE))
+	if (I_INO(ip) != inum || __xfs_iflags_test(ip, XFS_ISTALE))
 		goto out_iflags_unlock;
 
 	/*
@@ -2061,7 +2061,7 @@ xfs_sort_inodes(
 	 */
 	for (i = 0; i < num_inodes; i++) {
 		for (j = 1; j < num_inodes; j++) {
-			if (i_tab[j]->i_ino < i_tab[j-1]->i_ino)
+			if (I_INO(i_tab[j]) < I_INO(i_tab[j-1]))
 				swap(i_tab[j], i_tab[j - 1]);
 		}
 	}
@@ -2392,7 +2392,7 @@ xfs_iflush(
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_1)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: Bad inode %llu magic number 0x%x, ptr "PTR_FMT,
-			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
+			__func__, I_INO(ip), be16_to_cpu(dip->di_magic), dip);
 		goto flush_out;
 	}
 	if (ip->i_df.if_format == XFS_DINODE_FMT_META_BTREE) {
@@ -2401,7 +2401,7 @@ xfs_iflush(
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad %s meta btree inode %Lu, ptr "PTR_FMT,
 				__func__, xfs_metafile_type_str(ip->i_metatype),
-				ip->i_ino, ip);
+				I_INO(ip), ip);
 			goto flush_out;
 		}
 	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
@@ -2410,7 +2410,7 @@ xfs_iflush(
 		    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_3)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad regular inode %llu, ptr "PTR_FMT,
-				__func__, ip->i_ino, ip);
+				__func__, I_INO(ip), ip);
 			goto flush_out;
 		}
 	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
@@ -2420,7 +2420,7 @@ xfs_iflush(
 		    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_4)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad directory inode %llu, ptr "PTR_FMT,
-				__func__, ip->i_ino, ip);
+				__func__, I_INO(ip), ip);
 			goto flush_out;
 		}
 	}
@@ -2429,7 +2429,7 @@ xfs_iflush(
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: detected corrupt incore inode %llu, "
 			"total extents = %llu nblocks = %lld, ptr "PTR_FMT,
-			__func__, ip->i_ino,
+			__func__, I_INO(ip),
 			ip->i_df.if_nextents + xfs_ifork_nextents(&ip->i_af),
 			ip->i_nblocks, ip);
 		goto flush_out;
@@ -2438,7 +2438,7 @@ xfs_iflush(
 	    XFS_TEST_ERROR(mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: bad inode %llu, forkoff 0x%x, ptr "PTR_FMT,
-			__func__, ip->i_ino, ip->i_forkoff, ip);
+			__func__, I_INO(ip), ip->i_forkoff, ip);
 		goto flush_out;
 	}
 
@@ -2446,7 +2446,7 @@ xfs_iflush(
 	    ip->i_af.if_format == XFS_DINODE_FMT_META_BTREE) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: meta btree in inode %Lu attr fork, ptr "PTR_FMT,
-			__func__, ip->i_ino, ip);
+			__func__, I_INO(ip), ip);
 		goto flush_out;
 	}
 
@@ -2746,7 +2746,7 @@ xfs_mmaplock_two_inodes_and_break_dax_layout(
 {
 	int			error;
 
-	if (ip1->i_ino > ip2->i_ino)
+	if (I_INO(ip1) > I_INO(ip2))
 		swap(ip1, ip2);
 
 again:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 724baea02c8d..34c1038ebfcd 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -30,7 +30,6 @@ typedef struct xfs_inode {
 	struct xfs_dquot	*i_pdquot;	/* project dquot */
 
 	/* Inode location stuff */
-	xfs_ino_t		i_ino;		/* inode number (agno/agino)*/
 	struct xfs_imap		i_imap;		/* location for xfs_imap() */
 
 	/* Extent information. */
@@ -184,6 +183,11 @@ static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+static inline xfs_ino_t I_INO(const struct xfs_inode *ip)
+{
+	return VFS_IC(ip)->i_ino;
+}
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode
@@ -299,9 +303,9 @@ static inline bool xfs_is_internal_inode(const struct xfs_inode *ip)
 	 * Before metadata directories, the only metadata inodes were the
 	 * three quota files, the realtime bitmap, and the realtime summary.
 	 */
-	return ip->i_ino == mp->m_sb.sb_rbmino ||
-	       ip->i_ino == mp->m_sb.sb_rsumino ||
-	       xfs_is_quota_inode(&mp->m_sb, ip->i_ino);
+	return I_INO(ip) == mp->m_sb.sb_rbmino ||
+	       I_INO(ip) == mp->m_sb.sb_rsumino ||
+	       xfs_is_quota_inode(&mp->m_sb, I_INO(ip));
 }
 
 static inline bool xfs_is_zoned_inode(const struct xfs_inode *ip)
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 4ae81eed0442..2307ce96f753 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -34,7 +34,7 @@ static uint64_t
 xfs_inode_item_sort(
 	struct xfs_log_item	*lip)
 {
-	return INODE_ITEM(lip)->ili_inode->i_ino;
+	return I_INO(INODE_ITEM(lip)->ili_inode);
 }
 
 #ifdef DEBUG_EXPENSIVE
@@ -54,7 +54,7 @@ xfs_inode_item_precommit_check(
 
 	xfs_inode_to_disk(ip, dip, 0);
 	xfs_dinode_calc_crc(mp, dip);
-	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
+	fa = xfs_dinode_verify(mp, I_INO(ip), dip);
 	if (fa) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), fa);
@@ -588,7 +588,7 @@ xfs_inode_to_log_dinode(
 		to->di_flags2 = ip->i_diflags2;
 		/* also covers the di_used_blocks union arm: */
 		to->di_cowextsize = ip->i_cowextsize;
-		to->di_ino = ip->i_ino;
+		to->di_ino = I_INO(ip);
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
@@ -651,7 +651,7 @@ xfs_inode_item_format(
 
 	ilf = xlog_format_start(lfb, XLOG_REG_TYPE_IFORMAT);
 	ilf->ilf_type = XFS_LI_INODE;
-	ilf->ilf_ino = ip->i_ino;
+	ilf->ilf_ino = I_INO(ip);
 	ilf->ilf_blkno = ip->i_imap.im_blkno;
 	ilf->ilf_len = ip->i_imap.im_len;
 	ilf->ilf_boffset = ip->i_imap.im_boffset;
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index b42106c4a9ef..169a8fe3bf0a 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -99,7 +99,7 @@ xfs_recover_inode_owner_change(
 	if (in_f->ilf_fields & XFS_ILOG_DOWNER) {
 		ASSERT(in_f->ilf_fields & XFS_ILOG_DBROOT);
 		error = xfs_bmbt_change_owner(NULL, ip, XFS_DATA_FORK,
-					      ip->i_ino, buffer_list);
+					      I_INO(ip), buffer_list);
 		if (error)
 			goto out_free_ip;
 	}
@@ -107,7 +107,7 @@ xfs_recover_inode_owner_change(
 	if (in_f->ilf_fields & XFS_ILOG_AOWNER) {
 		ASSERT(in_f->ilf_fields & XFS_ILOG_ABROOT);
 		error = xfs_bmbt_change_owner(NULL, ip, XFS_ATTR_FORK,
-					      ip->i_ino, buffer_list);
+					      I_INO(ip), buffer_list);
 		if (error)
 			goto out_free_ip;
 	}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 46e234863644..fccd39d8157c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -984,7 +984,7 @@ xfs_ioc_swapext(
 	if (ip->i_mount != tip->i_mount)
 		return -EINVAL;
 
-	if (ip->i_ino == tip->i_ino)
+	if (I_INO(ip) == I_INO(tip))
 		return -EINVAL;
 
 	if (xfs_is_shutdown(ip->i_mount))
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f20a02f49ed9..6ff722f04f5d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -45,7 +45,7 @@ xfs_alert_fsblock_zero(
 			"Access to block zero in inode %llu "
 			"start_block: %llx start_off: %llx "
 			"blkcnt: %llx extent-state: %x",
-		(unsigned long long)ip->i_ino,
+		(unsigned long long)I_INO(ip),
 		(unsigned long long)imap->br_startblock,
 		(unsigned long long)imap->br_startoff,
 		(unsigned long long)imap->br_blockcount,
@@ -1736,7 +1736,7 @@ xfs_zoned_buffered_write_iomap_begin(
 	if (count_fsb > ac->reserved_blocks) {
 		xfs_warn_ratelimited(mp,
 "Short write on ino 0x%llx comm %.20s due to three-way race with write fault and direct I/O",
-			ip->i_ino, current->comm);
+			I_INO(ip), current->comm);
 		count_fsb = ac->reserved_blocks;
 		if (!count_fsb) {
 			error = -EIO;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 325c2200c501..6339f4956ecb 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -703,7 +703,7 @@ xfs_vn_getattr(
 	stat->nlink = inode->i_nlink;
 	stat->uid = vfsuid_into_kuid(vfsuid);
 	stat->gid = vfsgid_into_kgid(vfsgid);
-	stat->ino = ip->i_ino;
+	stat->ino = inode->i_ino;
 	stat->atime = inode_get_atime(inode);
 
 	fill_mg_cmtime(stat, request_mask, inode);
@@ -1423,7 +1423,6 @@ xfs_setup_inode(
 	gfp_t			gfp_mask;
 	bool			is_meta = xfs_is_internal_inode(ip);
 
-	inode->i_ino = ip->i_ino;
 	inode_state_set_raw(inode, I_NEW);
 
 	inode_sb_list_add(inode);
diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index a03a48eeb9a8..c8817112d49d 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -40,7 +40,7 @@ static uint64_t
 xfs_iunlink_item_sort(
 	struct xfs_log_item	*lip)
 {
-	return IUL_ITEM(lip)->ip->i_ino;
+	return I_INO(IUL_ITEM(lip)->ip);
 }
 
 /*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b24195f570cd..f0188eb47d1e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1080,7 +1080,7 @@ xfs_mountfs(
 
 	if (XFS_IS_CORRUPT(mp, !S_ISDIR(VFS_I(rip)->i_mode))) {
 		xfs_warn(mp, "corrupted root inode %llu: not a directory",
-			(unsigned long long)rip->i_ino);
+			(unsigned long long)I_INO(rip));
 		xfs_iunlock(rip, XFS_ILOCK_EXCL);
 		error = -EFSCORRUPTED;
 		goto out_rele_rip;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7bd15d9e7fba..aa0d2976f1c3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -297,7 +297,7 @@ xfs_qm_need_dqattach(
 		return false;
 	if (!XFS_NOT_DQATTACHED(mp, ip))
 		return false;
-	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+	if (xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
 		return false;
 	if (xfs_is_metadir_inode(ip))
 		return false;
@@ -390,7 +390,7 @@ xfs_qm_dqdetach(
 
 	trace_xfs_dquot_dqdetach(ip);
 
-	ASSERT(!xfs_is_quota_inode(&ip->i_mount->m_sb, ip->i_ino));
+	ASSERT(!xfs_is_quota_inode(&ip->i_mount->m_sb, I_INO(ip)));
 	if (ip->i_udquot) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
@@ -986,11 +986,11 @@ xfs_qm_qino_alloc(
 		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
 	}
 	if (flags & XFS_QMOPT_UQUOTA)
-		mp->m_sb.sb_uquotino = (*ipp)->i_ino;
+		mp->m_sb.sb_uquotino = I_INO(*ipp);
 	else if (flags & XFS_QMOPT_GQUOTA)
-		mp->m_sb.sb_gquotino = (*ipp)->i_ino;
+		mp->m_sb.sb_gquotino = I_INO(*ipp);
 	else
-		mp->m_sb.sb_pquotino = (*ipp)->i_ino;
+		mp->m_sb.sb_pquotino = I_INO(*ipp);
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index 8804508cc2b8..81f739e3aa0c 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -34,7 +34,7 @@ xfs_qm_fill_state(
 
 	defq = xfs_get_defquota(mp->m_quotainfo, type);
 
-	tstate->ino = ip->i_ino;
+	tstate->ino = I_INO(ip);
 	tstate->flags |= QCI_SYSFILE;
 	tstate->blocks = ip->i_nblocks;
 	tstate->nextents = ip->i_df.if_nextents;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index db23a0f231d6..ba96d322c950 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1188,7 +1188,7 @@ xfs_reflink_set_inode_flag(
 		goto out_error;
 
 	/* Lock both files against IO */
-	if (src->i_ino == dest->i_ino)
+	if (I_INO(src) == I_INO(dest))
 		xfs_ilock(src, XFS_ILOCK_EXCL);
 	else
 		xfs_lock_two_inodes(src, XFS_ILOCK_EXCL, dest, XFS_ILOCK_EXCL);
@@ -1202,7 +1202,7 @@ xfs_reflink_set_inode_flag(
 	} else
 		xfs_iunlock(src, XFS_ILOCK_EXCL);
 
-	if (src->i_ino == dest->i_ino)
+	if (I_INO(src) == I_INO(dest))
 		goto commit_flags;
 
 	if (!xfs_is_reflink_inode(dest)) {
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index c4da624fb296..5585ac7f4d16 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -52,7 +52,7 @@ xfs_readlink(
 
 	if (pathlen < 0 || pathlen > XFS_SYMLINK_MAXLEN) {
 		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
-			 __func__, (unsigned long long) ip->i_ino,
+			 __func__, (unsigned long long)I_INO(ip),
 			 (long long) pathlen);
 		ASSERT(0);
 		goto out_corrupt;
@@ -186,7 +186,7 @@ xfs_symlink(
 	xfs_qm_vop_create_dqattach(tp, du.ip, udqp, gdqp, pdqp);
 
 	resblks -= XFS_IALLOC_SPACE_RES(mp);
-	error = xfs_symlink_write_target(tp, du.ip, du.ip->i_ino, target_path,
+	error = xfs_symlink_write_target(tp, du.ip, I_INO(du.ip), target_path,
 			pathlen, fs_blocks, resblks);
 	if (error)
 		goto out_trans_cancel;
@@ -339,7 +339,7 @@ xfs_inactive_symlink(
 
 	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
 		xfs_alert(mp, "%s: inode (0x%llx) bad symlink length (%d)",
-			 __func__, (unsigned long long)ip->i_ino, pathlen);
+			 __func__, (unsigned long long)I_INO(ip), pathlen);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		ASSERT(0);
 		xfs_inode_mark_sick(ip, XFS_SICK_INO_SYMLINK);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6767e50b643d..ae5faa787830 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -132,7 +132,7 @@ DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
-		__entry->ino = ctx->dp->i_ino;
+		__entry->ino = I_INO(ctx->dp);
 		__entry->hashval = ctx->cursor.hashval;
 		__entry->blkno = ctx->cursor.blkno;
 		__entry->offset = ctx->cursor.offset;
@@ -634,7 +634,7 @@ TRACE_EVENT(xfs_attr_list_node_descend,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ctx->dp)->i_sb->s_dev;
-		__entry->ino = ctx->dp->i_ino;
+		__entry->ino = I_INO(ctx->dp);
 		__entry->hashval = ctx->cursor.hashval;
 		__entry->blkno = ctx->cursor.blkno;
 		__entry->offset = ctx->cursor.offset;
@@ -688,7 +688,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_class,
 		ifp = xfs_iext_state_to_fork(ip, state);
 		xfs_iext_get_extent(ifp, cur, &r);
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->leaf = cur->leaf;
 		__entry->pos = cur->pos;
 		__entry->startoff = r.br_startoff;
@@ -1021,7 +1021,7 @@ DECLARE_EVENT_CLASS(xfs_lock_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->lock_flags = lock_flags;
 		__entry->caller_ip = caller_ip;
 	),
@@ -1052,7 +1052,7 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->iflags = ip->i_flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx iflags 0x%lx",
@@ -1128,7 +1128,7 @@ DECLARE_EVENT_CLASS(xfs_fault_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->order = order;
 	),
 	TP_printk("dev %d:%d ino 0x%llx order %u",
@@ -1157,7 +1157,7 @@ DECLARE_EVENT_CLASS(xfs_iref_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->count = icount_read(VFS_I(ip));
 		__entry->pincount = atomic_read(&ip->i_pincount);
 		__entry->iflags = ip->i_flags;
@@ -1185,7 +1185,7 @@ TRACE_EVENT(xfs_iomap_prealloc_size,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->blocks = blocks;
 		__entry->shift = shift;
 		__entry->writeio_blocks = writeio_blocks;
@@ -1272,7 +1272,7 @@ DECLARE_EVENT_CLASS(xfs_namespace_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(dp)->i_sb->s_dev;
-		__entry->dp_ino = dp->i_ino;
+		__entry->dp_ino = I_INO(dp);
 		__entry->namelen = name->len;
 		memcpy(__get_str(name), name->name, name->len);
 	),
@@ -1308,8 +1308,8 @@ TRACE_EVENT(xfs_rename,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(src_dp)->i_sb->s_dev;
-		__entry->src_dp_ino = src_dp->i_ino;
-		__entry->target_dp_ino = target_dp->i_ino;
+		__entry->src_dp_ino = I_INO(src_dp);
+		__entry->target_dp_ino = I_INO(target_dp);
 		__entry->src_namelen = src_name->len;
 		__entry->target_namelen = target_name->len;
 		memcpy(__get_str(src_name), src_name->name, src_name->len);
@@ -1760,7 +1760,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 	),
 	TP_fast_assign(
 		__entry->dev = file_inode(iocb->ki_filp)->i_sb->s_dev;
-		__entry->ino = XFS_I(file_inode(iocb->ki_filp))->i_ino;
+		__entry->ino = file_inode(iocb->ki_filp)->i_ino;
 		__entry->size = XFS_I(file_inode(iocb->ki_filp))->i_disk_size;
 		__entry->offset = iocb->ki_pos;
 		__entry->count = iov_iter_count(iter);
@@ -1796,7 +1796,7 @@ TRACE_EVENT(xfs_iomap_atomic_write_cow,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->offset = offset;
 		__entry->count = count;
 	),
@@ -1824,7 +1824,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->size = ip->i_disk_size;
 		__entry->offset = offset;
 		__entry->count = count;
@@ -1869,7 +1869,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->isize = VFS_I(ip)->i_size;
 		__entry->disize = ip->i_disk_size;
 		__entry->offset = offset;
@@ -1908,7 +1908,7 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->size = ip->i_disk_size;
 		__entry->new_size = new_size;
 	),
@@ -1941,7 +1941,7 @@ TRACE_EVENT(xfs_bunmap,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->size = ip->i_disk_size;
 		__entry->fileoff = fileoff;
 		__entry->len = len;
@@ -2344,7 +2344,7 @@ DECLARE_EVENT_CLASS(xfs_da_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
-		__entry->ino = args->dp->i_ino;
+		__entry->ino = I_INO(args->dp);
 		if (args->namelen)
 			memcpy(__get_str(name), args->name, args->namelen);
 		__entry->namelen = args->namelen;
@@ -2411,7 +2411,7 @@ DECLARE_EVENT_CLASS(xfs_attr_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
-		__entry->ino = args->dp->i_ino;
+		__entry->ino = I_INO(args->dp);
 		if (args->namelen)
 			memcpy(__get_str(name), args->name, args->namelen);
 		__entry->namelen = args->namelen;
@@ -2511,7 +2511,7 @@ DECLARE_EVENT_CLASS(xfs_dir2_space_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
-		__entry->ino = args->dp->i_ino;
+		__entry->ino = I_INO(args->dp);
 		__entry->op_flags = args->op_flags;
 		__entry->idx = idx;
 	),
@@ -2544,7 +2544,7 @@ TRACE_EVENT(xfs_dir2_leafn_moveents,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(args->dp)->i_sb->s_dev;
-		__entry->ino = args->dp->i_ino;
+		__entry->ino = I_INO(args->dp);
 		__entry->op_flags = args->op_flags;
 		__entry->src_idx = src_idx;
 		__entry->dst_idx = dst_idx;
@@ -2586,7 +2586,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->which = which;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->format = ip->i_df.if_format;
 		__entry->nex = ip->i_df.if_nextents;
 		__entry->broot_size = ip->i_df.if_broot_bytes;
@@ -2944,7 +2944,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 		switch (cur->bc_ops->type) {
 		case XFS_BTREE_TYPE_INODE:
 			__entry->agno = 0;
-			__entry->ino = cur->bc_ino.ip->i_ino;
+			__entry->ino = I_INO(cur->bc_ino.ip);
 			break;
 		case XFS_BTREE_TYPE_AG:
 			__entry->agno = cur->bc_group->xg_gno;
@@ -2996,7 +2996,7 @@ TRACE_EVENT(xfs_btree_free_block,
 		__entry->agno = xfs_daddr_to_agno(cur->bc_mp,
 							xfs_buf_daddr(bp));
 		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
-			__entry->ino = cur->bc_ino.ip->i_ino;
+			__entry->ino = I_INO(cur->bc_ino.ip);
 		else
 			__entry->ino = 0;
 		__assign_str(name);
@@ -3251,7 +3251,7 @@ DECLARE_EVENT_CLASS(xfs_btree_error_class,
 		switch (cur->bc_ops->type) {
 		case XFS_BTREE_TYPE_INODE:
 			__entry->agno = 0;
-			__entry->ino = cur->bc_ino.ip->i_ino;
+			__entry->ino = I_INO(cur->bc_ino.ip);
 			break;
 		case XFS_BTREE_TYPE_AG:
 			__entry->agno = cur->bc_group->xg_gno;
@@ -3470,7 +3470,7 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 						bi->bi_bmap.br_startblock,
 						bi->bi_group->xg_type);
 		}
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->whichfork = bi->bi_whichfork;
 		__entry->l_loff = bi->bi_bmap.br_startoff;
 		__entry->l_len = bi->bi_bmap.br_blockcount;
@@ -3974,7 +3974,7 @@ DECLARE_EVENT_CLASS(xfs_inode_error_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->error = error;
 		__entry->caller_ip = caller_ip;
 	),
@@ -4012,12 +4012,12 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(src)->i_sb->s_dev;
-		__entry->src_ino = src->i_ino;
+		__entry->src_ino = I_INO(src);
 		__entry->src_isize = VFS_I(src)->i_size;
 		__entry->src_disize = src->i_disk_size;
 		__entry->src_offset = soffset;
 		__entry->len = len;
-		__entry->dest_ino = dest->i_ino;
+		__entry->dest_ino = I_INO(dest);
 		__entry->dest_isize = VFS_I(dest)->i_size;
 		__entry->dest_disize = dest->i_disk_size;
 		__entry->dest_offset = doffset;
@@ -4057,7 +4057,7 @@ DECLARE_EVENT_CLASS(xfs_inode_irec_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->lblk = irec->br_startoff;
 		__entry->len = irec->br_blockcount;
 		__entry->pblk = irec->br_startblock;
@@ -4093,7 +4093,7 @@ DECLARE_EVENT_CLASS(xfs_wb_invalid_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->addr = iomap->addr;
 		__entry->pos = iomap->offset;
 		__entry->len = iomap->length;
@@ -4136,7 +4136,7 @@ DECLARE_EVENT_CLASS(xfs_iomap_invalid_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->addr = iomap->addr;
 		__entry->pos = iomap->offset;
 		__entry->len = iomap->length;
@@ -4183,10 +4183,10 @@ TRACE_EVENT(xfs_reflink_remap_blocks,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(src)->i_sb->s_dev;
-		__entry->src_ino = src->i_ino;
+		__entry->src_ino = I_INO(src);
 		__entry->src_lblk = soffset;
 		__entry->len = len;
-		__entry->dest_ino = dest->i_ino;
+		__entry->dest_ino = I_INO(dest);
 		__entry->dest_lblk = doffset;
 	),
 	TP_printk("dev %d:%d fsbcount 0x%llx "
@@ -4649,7 +4649,7 @@ DECLARE_EVENT_CLASS(xfs_inode_corrupt_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->flags = flags;
 	),
 	TP_printk("dev %d:%d ino 0x%llx flags 0x%x",
@@ -5028,7 +5028,7 @@ DECLARE_EVENT_CLASS(xfs_das_state_class,
 	),
 	TP_fast_assign(
 		__entry->das = das;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 	),
 	TP_printk("state change %s ino 0x%llx",
 		  __print_symbolic(__entry->das, XFS_DAS_STRINGS),
@@ -5293,7 +5293,7 @@ DECLARE_EVENT_CLASS(xfs_exchrange_inode_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->whichfile = whichfile;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->format = ip->i_df.if_format;
 		__entry->nex = ip->i_df.if_nextents;
 		__entry->fork_off = xfs_inode_fork_boff(ip);
@@ -5346,10 +5346,10 @@ DECLARE_EVENT_CLASS(xfs_exchrange_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip1)->i_sb->s_dev;
-		__entry->ip1_ino = ip1->i_ino;
+		__entry->ip1_ino = I_INO(ip1);
 		__entry->ip1_isize = VFS_I(ip1)->i_size;
 		__entry->ip1_disize = ip1->i_disk_size;
-		__entry->ip2_ino = ip2->i_ino;
+		__entry->ip2_ino = I_INO(ip2);
 		__entry->ip2_isize = VFS_I(ip2)->i_size;
 		__entry->ip2_disize = ip2->i_disk_size;
 
@@ -5405,7 +5405,7 @@ TRACE_EVENT(xfs_exchrange_freshness,
 		struct inode		*inode2 = VFS_I(ip2);
 
 		__entry->dev = inode2->i_sb->s_dev;
-		__entry->ip2_ino = ip2->i_ino;
+		__entry->ip2_ino = I_INO(ip2);
 
 		ts64 = inode_get_ctime(inode2);
 		__entry->ip2_ctime = ts64.tv_sec;
@@ -5477,8 +5477,8 @@ DECLARE_EVENT_CLASS(xfs_exchmaps_estimate_class,
 	),
 	TP_fast_assign(
 		__entry->dev = req->ip1->i_mount->m_super->s_dev;
-		__entry->ino1 = req->ip1->i_ino;
-		__entry->ino2 = req->ip2->i_ino;
+		__entry->ino1 = I_INO(req->ip1);
+		__entry->ino2 = I_INO(req->ip2);
 		__entry->startoff1 = req->startoff1;
 		__entry->startoff2 = req->startoff2;
 		__entry->blockcount = req->blockcount;
@@ -5529,8 +5529,8 @@ DECLARE_EVENT_CLASS(xfs_exchmaps_intent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->ino1 = xmi->xmi_ip1->i_ino;
-		__entry->ino2 = xmi->xmi_ip2->i_ino;
+		__entry->ino1 = I_INO(xmi->xmi_ip1);
+		__entry->ino2 = I_INO(xmi->xmi_ip2);
 		__entry->flags = xmi->xmi_flags;
 		__entry->startoff1 = xmi->xmi_startoff1;
 		__entry->startoff2 = xmi->xmi_startoff2;
@@ -5625,8 +5625,8 @@ TRACE_EVENT(xfs_exchmaps_delta_nextents,
 		int whichfork = xfs_exchmaps_reqfork(req);
 
 		__entry->dev = req->ip1->i_mount->m_super->s_dev;
-		__entry->ino1 = req->ip1->i_ino;
-		__entry->ino2 = req->ip2->i_ino;
+		__entry->ino1 = I_INO(req->ip1);
+		__entry->ino2 = I_INO(req->ip2);
 		__entry->nexts1 = xfs_ifork_ptr(req->ip1, whichfork)->if_nextents;
 		__entry->nexts2 = xfs_ifork_ptr(req->ip2, whichfork)->if_nextents;
 		__entry->d_nexts1 = d_nexts1;
@@ -5656,7 +5656,7 @@ DECLARE_EVENT_CLASS(xfs_getparents_rec_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->firstu = context->firstu;
 		__entry->reclen = pptr->gpr_reclen;
 		__entry->bufsize = ppi->gp_bufsize;
@@ -5700,7 +5700,7 @@ DECLARE_EVENT_CLASS(xfs_getparents_class,
 	),
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
-		__entry->ino = ip->i_ino;
+		__entry->ino = I_INO(ip);
 		__entry->iflags = ppi->gp_iflags;
 		__entry->oflags = ppi->gp_oflags;
 		__entry->bufsize = ppi->gp_bufsize;
@@ -5739,8 +5739,8 @@ DECLARE_EVENT_CLASS(xfs_metadir_update_class,
 	),
 	TP_fast_assign(
 		__entry->dev = upd->dp->i_mount->m_super->s_dev;
-		__entry->dp_ino = upd->dp->i_ino;
-		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
+		__entry->dp_ino = I_INO(upd->dp);
+		__entry->ino = upd->ip ? I_INO(upd->ip) : NULLFSINO;
 		__assign_str(fname);
 	),
 	TP_printk("dev %d:%d dp 0x%llx fname '%s' ino 0x%llx",
@@ -5774,8 +5774,8 @@ DECLARE_EVENT_CLASS(xfs_metadir_update_error_class,
 	),
 	TP_fast_assign(
 		__entry->dev = upd->dp->i_mount->m_super->s_dev;
-		__entry->dp_ino = upd->dp->i_ino;
-		__entry->ino = upd->ip ? upd->ip->i_ino : NULLFSINO;
+		__entry->dp_ino = I_INO(upd->dp);
+		__entry->ino = upd->ip ? I_INO(upd->ip) : NULLFSINO;
 		__entry->error = error;
 		__assign_str(fname);
 	),
@@ -5807,7 +5807,7 @@ DECLARE_EVENT_CLASS(xfs_metadir_class,
 	),
 	TP_fast_assign(
 		__entry->dev = VFS_I(dp)->i_sb->s_dev;
-		__entry->dp_ino = dp->i_ino;
+		__entry->dp_ino = I_INO(dp);
 		__entry->ino = ino,
 		__entry->ftype = name->type;
 		__entry->namelen = name->len;
@@ -6325,7 +6325,7 @@ TRACE_EVENT(xfs_healthmon_report_file_ioerror,
 	TP_fast_assign(
 		__entry->dev = hm->dev;
 		__entry->type = p->type;
-		__entry->ino = XFS_I(p->inode)->i_ino;
+		__entry->ino = p->inode->i_ino;
 		__entry->gen = p->inode->i_generation;
 		__entry->pos = p->pos;
 		__entry->len = p->len;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index bcc470f56e46..b375b51831fc 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1164,7 +1164,7 @@ xfs_trans_reserve_more_inode(
 	if (error)
 		return error;
 
-	if (!XFS_IS_QUOTA_ON(mp) || xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
+	if (!XFS_IS_QUOTA_ON(mp) || xfs_is_quota_inode(&mp->m_sb, I_INO(ip)))
 		return 0;
 
 	if (tp->t_flags & XFS_TRANS_RESERVE)
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index eaf9de6e07fd..1606c614f205 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -164,7 +164,7 @@ xfs_trans_mod_ino_dquot(
 	if (xfs_hooks_switched_on(&xfs_dqtrx_hooks_switch)) {
 		struct xfs_mod_ino_dqtrx_params	p = {
 			.tx_id		= (uintptr_t)tp,
-			.ino		= ip->i_ino,
+			.ino		= I_INO(ip),
 			.q_type		= xfs_dquot_type(dqp),
 			.q_id		= dqp->q_id,
 			.delta		= delta
@@ -247,7 +247,7 @@ xfs_trans_mod_dquot_byino(
 	xfs_mount_t	*mp = tp->t_mountp;
 
 	if (!XFS_IS_QUOTA_ON(mp) ||
-	    xfs_is_quota_inode(&mp->m_sb, ip->i_ino) ||
+	    xfs_is_quota_inode(&mp->m_sb, I_INO(ip)) ||
 	    xfs_is_metadir_inode(ip))
 		return;
 
@@ -990,7 +990,7 @@ xfs_trans_reserve_quota_nblks(
 	if (xfs_is_metadir_inode(ip))
 		return 0;
 
-	ASSERT(!xfs_is_quota_inode(&mp->m_sb, ip->i_ino));
+	ASSERT(!xfs_is_quota_inode(&mp->m_sb, I_INO(ip)));
 	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
 
 	if (force)
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 544213067d59..1efe6c8139b2 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -104,7 +104,7 @@ xfs_attr_change(
 		args->op_flags |= XFS_DA_OP_LOGGED;
 	}
 
-	args->owner = args->dp->i_ino;
+	args->owner = I_INO(args->dp);
 	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	xfs_attr_sethash(args);
-- 
2.53.0

