Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51470 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbeEDVqe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 May 2018 17:46:34 -0400
Subject: [PATCH 6/5] xfs: make several functions void
From: Eric Sandeen <sandeen@sandeen.net>
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
 <9d126a83-c4ef-00a2-dbb6-510e2c41de73@sandeen.net>
Message-ID: <df47c5e1-0e77-55d6-eb52-8e694946c9cb@sandeen.net>
Date: Fri, 4 May 2018 16:46:33 -0500
MIME-Version: 1.0
In-Reply-To: <9d126a83-c4ef-00a2-dbb6-510e2c41de73@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Several functions can return only zero, and so we can change
their type to void and remove error handling.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Adding this as 6/5 just because it hits my other quota changes,
I can rebase as needed.

 libxfs/xfs_attr_leaf.c  |   14 +++++++-------
 libxfs/xfs_dir2.c       |    4 ++--
 libxfs/xfs_dir2_priv.h  |    2 +-
 libxfs/xfs_dir2_sf.c    |    3 +--
 libxfs/xfs_dquot_buf.c  |    4 +---
 libxfs/xfs_quota_defs.h |    2 +-
 libxfs/xfs_sb.c         |   10 +++++-----
 libxfs/xfs_sb.h         |    2 +-
 xfs_dir2_readdir.c      |   15 +++++++--------
 xfs_fsops.c             |    3 +--
 xfs_fsops.h             |    2 +-
 xfs_inode.c             |   32 +++++++++-----------------------
 xfs_ioctl.c             |   15 +++------------
 xfs_ioctl32.c           |    6 ++----
 xfs_log.c               |   26 ++++++++------------------
 xfs_log_recover.c       |   41 ++++++++++++++++-------------------------
 xfs_super.c             |    7 +++----
 17 files changed, 69 insertions(+), 119 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2135b8e67dcc..73f2c1ae2dcf 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -59,7 +59,7 @@
  */
 STATIC int xfs_attr3_leaf_create(struct xfs_da_args *args,
 				 xfs_dablk_t which_block, struct xfs_buf **bpp);
-STATIC int xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
+STATIC void xfs_attr3_leaf_add_work(struct xfs_buf *leaf_buffer,
 				   struct xfs_attr3_icleaf_hdr *ichdr,
 				   struct xfs_da_args *args, int freemap_index);
 STATIC void xfs_attr3_leaf_compact(struct xfs_da_args *args,
@@ -1247,6 +1247,7 @@ xfs_attr3_leaf_add(
 	int			entsize;
 	int			sum;
 	int			tmp;
+	int			error = 0;
 	int			i;
 
 	trace_xfs_attr_leaf_add(args);
@@ -1273,7 +1274,7 @@ xfs_attr3_leaf_add(
 		if (ichdr.freemap[i].base < ichdr.firstused)
 			tmp += sizeof(xfs_attr_leaf_entry_t);
 		if (ichdr.freemap[i].size >= tmp) {
-			tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
+			xfs_attr3_leaf_add_work(bp, &ichdr, args, i);
 			goto out_log_hdr;
 		}
 		sum += ichdr.freemap[i].size;
@@ -1298,24 +1299,24 @@ xfs_attr3_leaf_add(
 	 * free region, in freemap[0].  If it is not big enough, give up.
 	 */
 	if (ichdr.freemap[0].size < (entsize + sizeof(xfs_attr_leaf_entry_t))) {
-		tmp = -ENOSPC;
+		error = -ENOSPC;
 		goto out_log_hdr;
 	}
 
-	tmp = xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
+	xfs_attr3_leaf_add_work(bp, &ichdr, args, 0);
 
 out_log_hdr:
 	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf, &ichdr);
 	xfs_trans_log_buf(args->trans, bp,
 		XFS_DA_LOGRANGE(leaf, &leaf->hdr,
 				xfs_attr3_leaf_hdr_size(leaf)));
-	return tmp;
+	return error;
 }
 
 /*
  * Add a name to a leaf attribute list structure.
  */
-STATIC int
+STATIC void
 xfs_attr3_leaf_add_work(
 	struct xfs_buf		*bp,
 	struct xfs_attr3_icleaf_hdr *ichdr,
@@ -1429,7 +1430,6 @@ xfs_attr3_leaf_add_work(
 		}
 	}
 	ichdr->usedbytes += xfs_attr_leaf_entsize(leaf, args->index);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 92f94e190f04..bf1044aa236f 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -240,9 +240,9 @@ xfs_dir_init(
 	args->geo = dp->i_mount->m_dir_geo;
 	args->dp = dp;
 	args->trans = tp;
-	error = xfs_dir2_sf_create(args, pdp->i_ino);
+	xfs_dir2_sf_create(args, pdp->i_ino);
 	kmem_free(args);
-	return error;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 753aeeeffc18..f51a3d9924e7 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -125,7 +125,7 @@ extern int xfs_dir2_block_sfsize(struct xfs_inode *dp,
 extern int xfs_dir2_block_to_sf(struct xfs_da_args *args, struct xfs_buf *bp,
 		int size, xfs_dir2_sf_hdr_t *sfhp);
 extern int xfs_dir2_sf_addname(struct xfs_da_args *args);
-extern int xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
+extern void xfs_dir2_sf_create(struct xfs_da_args *args, xfs_ino_t pino);
 extern int xfs_dir2_sf_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_sf_removename(struct xfs_da_args *args);
 extern int xfs_dir2_sf_replace(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 0c75a7f00883..eb34948b6aef 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -736,7 +736,7 @@ xfs_dir2_sf_verify(
 /*
  * Create a new (shortform) directory.
  */
-int					/* error, always 0 */
+void					/* always succeeds */
 xfs_dir2_sf_create(
 	xfs_da_args_t	*args,		/* operation arguments */
 	xfs_ino_t	pino)		/* parent inode number */
@@ -783,7 +783,6 @@ xfs_dir2_sf_create(
 	dp->i_d.di_size = size;
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index fb23d941e799..f3a7a2d5690e 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -122,7 +122,7 @@ xfs_dqblk_verify(
 /*
  * Do some primitive error checking on ondisk dquot data structures.
  */
-int
+void
 xfs_dqblk_repair(
 	struct xfs_mount	*mp,
 	struct xfs_dqblk	*dqb,
@@ -145,8 +145,6 @@ xfs_dqblk_repair(
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
-
-	return 0;
 }
 
 STATIC bool
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 1aac52d7fef4..7ae95e7643e6 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -156,7 +156,7 @@ extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
 extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
 		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
-extern int xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
+extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d9b94bd5f689..7c578740e57d 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -888,7 +888,7 @@ xfs_sync_sb(
 	return xfs_trans_commit(tp);
 }
 
-int
+void
 xfs_fs_geometry(
 	struct xfs_sb		*sbp,
 	struct xfs_fsop_geom	*geo,
@@ -912,13 +912,13 @@ xfs_fs_geometry(
 	memcpy(geo->uuid, &sbp->sb_uuid, sizeof(sbp->sb_uuid));
 
 	if (struct_version < 2)
-		return 0;
+		return;
 
 	geo->sunit = sbp->sb_unit;
 	geo->swidth = sbp->sb_width;
 
 	if (struct_version < 3)
-		return 0;
+		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION;
 	geo->flags = XFS_FSOP_GEOM_FLAGS_NLINK |
@@ -963,12 +963,12 @@ xfs_fs_geometry(
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
 	if (struct_version < 4)
-		return 0;
+		return;
 
 	if (xfs_sb_version_haslogv2(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
 
 	geo->logsunit = sbp->sb_logsunit;
 
-	return 0;
+	return;
 }
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 63dcd2a1a657..cf384d584170 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -35,7 +35,7 @@ extern void	xfs_sb_to_disk(struct xfs_dsb *to, struct xfs_sb *from);
 extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 
 #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
-extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
+extern void	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
 				int struct_version);
 
 #endif	/* __XFS_SB_H__ */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index b6ae3597bfb0..c9ed5b6cb391 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -55,7 +55,7 @@ xfs_dir3_get_dtype(
 	return xfs_dir3_filetype_table[filetype];
 }
 
-STATIC int
+STATIC void
 xfs_dir2_sf_getdents(
 	struct xfs_da_args	*args,
 	struct dir_context	*ctx)
@@ -80,7 +80,7 @@ xfs_dir2_sf_getdents(
 	 * If the block number in the offset is out of range, we're done.
 	 */
 	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
-		return 0;
+		return;
 
 	/*
 	 * Precalculate offsets for . and .. as we will always need them.
@@ -99,7 +99,7 @@ xfs_dir2_sf_getdents(
 	if (ctx->pos <= dot_offset) {
 		ctx->pos = dot_offset & 0x7fffffff;
 		if (!dir_emit(ctx, ".", 1, dp->i_ino, DT_DIR))
-			return 0;
+			return;
 	}
 
 	/*
@@ -109,7 +109,7 @@ xfs_dir2_sf_getdents(
 		ino = dp->d_ops->sf_get_parent_ino(sfp);
 		ctx->pos = dotdot_offset & 0x7fffffff;
 		if (!dir_emit(ctx, "..", 2, ino, DT_DIR))
-			return 0;
+			return;
 	}
 
 	/*
@@ -132,13 +132,12 @@ xfs_dir2_sf_getdents(
 		ctx->pos = off & 0x7fffffff;
 		if (!dir_emit(ctx, (char *)sfep->name, sfep->namelen, ino,
 			    xfs_dir3_get_dtype(dp->i_mount, filetype)))
-			return 0;
+			return;
 		sfep = dp->d_ops->sf_nextentry(sfp, sfep);
 	}
 
 	ctx->pos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk + 1, 0) &
 								0x7fffffff;
-	return 0;
 }
 
 /*
@@ -513,7 +512,7 @@ xfs_readdir(
 	size_t			bufsize)
 {
 	struct xfs_da_args	args = { NULL };
-	int			rval;
+	int			rval = 0;
 	int			v;
 
 	trace_xfs_readdir(dp);
@@ -529,7 +528,7 @@ xfs_readdir(
 	args.trans = tp;
 
 	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
-		rval = xfs_dir2_sf_getdents(&args, ctx);
+		xfs_dir2_sf_getdents(&args, ctx);
 	else if ((rval = xfs_dir2_isblock(&args, &v)))
 		;
 	else if (v)
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 523792768080..2647a6ee7d79 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -687,7 +687,7 @@ xfs_growfs_log(
  * exported through ioctl XFS_IOC_FSCOUNTS
  */
 
-int
+void
 xfs_fs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
@@ -700,7 +700,6 @@ xfs_fs_counts(
 	spin_lock(&mp->m_sb_lock);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	spin_unlock(&mp->m_sb_lock);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 20484ed5e919..2108f2191daf 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -20,7 +20,7 @@
 
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
-extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
+extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2b70c8b4cee2..3a9b193a7e8d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1116,7 +1116,7 @@ xfs_droplink(
 /*
  * Increment the link count on an inode & log the change.
  */
-static int
+static void 
 xfs_bumplink(
 	xfs_trans_t *tp,
 	xfs_inode_t *ip)
@@ -1126,7 +1126,6 @@ xfs_bumplink(
 	ASSERT(ip->i_d.di_version > 1);
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return 0;
 }
 
 int
@@ -1238,10 +1237,7 @@ xfs_create(
 		error = xfs_dir_init(tp, ip, dp);
 		if (error)
 			goto out_bmap_cancel;
-
-		error = xfs_bumplink(tp, dp);
-		if (error)
-			goto out_bmap_cancel;
+		xfs_bumplink(tp, dp);
 	}
 
 	/*
@@ -1468,9 +1464,7 @@ xfs_link(
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
-	error = xfs_bumplink(tp, sip);
-	if (error)
-		goto error_return;
+	xfs_bumplink(tp, sip);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -2815,9 +2809,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp2);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp1);
 			}
 
 			/*
@@ -2842,9 +2834,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp1);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp2);
 			}
 
 			/*
@@ -3048,11 +3038,9 @@ xfs_rename(
 		xfs_trans_ichgtime(tp, target_dp,
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
-		if (new_parent && src_is_directory) {
-			error = xfs_bumplink(tp, target_dp);
-			if (error)
-				goto out_bmap_cancel;
-		}
+		if (new_parent && src_is_directory)
+			xfs_bumplink(tp, target_dp);
+
 	} else { /* target_ip != NULL */
 		/*
 		 * If target exists and it's a directory, check that both
@@ -3172,9 +3160,7 @@ xfs_rename(
 	 */
 	if (wip) {
 		ASSERT(VFS_I(wip)->i_nlink == 0);
-		error = xfs_bumplink(tp, wip);
-		if (error)
-			goto out_bmap_cancel;
+		xfs_bumplink(tp, wip);
 		error = xfs_iunlink_remove(tp, wip);
 		if (error)
 			goto out_bmap_cancel;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 89fb1eb80aae..4ba8939145b8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -808,11 +808,8 @@ xfs_ioc_fsgeometry_v1(
 	void			__user *arg)
 {
 	xfs_fsop_geom_t         fsgeo;
-	int			error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
-	if (error)
-		return error;
+	xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
 
 	/*
 	 * Caller should have passed an argument of type
@@ -830,11 +827,8 @@ xfs_ioc_fsgeometry(
 	void			__user *arg)
 {
 	xfs_fsop_geom_t		fsgeo;
-	int			error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 4);
-	if (error)
-		return error;
+	xfs_fs_geometry(&mp->m_sb, &fsgeo, 4);
 
 	if (copy_to_user(arg, &fsgeo, sizeof(fsgeo)))
 		return -EFAULT;
@@ -1963,10 +1957,7 @@ xfs_file_ioctl(
 	case XFS_IOC_FSCOUNTS: {
 		xfs_fsop_counts_t out;
 
-		error = xfs_fs_counts(mp, &out);
-		if (error)
-			return error;
-
+		xfs_fs_counts(mp, &out);
 		if (copy_to_user(arg, &out, sizeof(out)))
 			return -EFAULT;
 		return 0;
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 10fbde359649..bb868ca31319 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -65,11 +65,9 @@ xfs_compat_ioc_fsgeometry_v1(
 	compat_xfs_fsop_geom_v1_t __user *arg32)
 {
 	xfs_fsop_geom_t		  fsgeo;
-	int			  error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
-	if (error)
-		return error;
+	xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
+
 	/* The 32-bit variant simply has some padding at the end */
 	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
 		return -EFAULT;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2fcd9ed5d075..65121e587e95 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -56,7 +56,7 @@ STATIC int
 xlog_space_left(
 	struct xlog		*log,
 	atomic64_t		*head);
-STATIC int
+STATIC void
 xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog);
@@ -1769,7 +1769,7 @@ xlog_cksum(
  * ensure that completes before tearing down the iclogbufs. Hence we need to
  * hold the buffer lock across the log IO to acheive that.
  */
-STATIC int
+STATIC void
 xlog_bdstrat(
 	struct xfs_buf		*bp)
 {
@@ -1786,11 +1786,10 @@ xlog_bdstrat(
 		 * doing it here. Similarly, IO completion will unlock the
 		 * buffer, so we don't do it here.
 		 */
-		return 0;
+		return;
 	}
 
 	xfs_buf_submit(bp);
-	return 0;
 }
 
 /*
@@ -1818,7 +1817,7 @@ xlog_bdstrat(
  * is added immediately before calling bwrite().
  */
 
-STATIC int
+STATIC void
 xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
@@ -1829,7 +1828,6 @@ xlog_sync(
 	uint		count_init;	/* initial count before roundup */
 	int		roundoff;       /* roundoff to BB or stripe */
 	int		split = 0;	/* split write into two regions */
-	int		error;
 	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
 	int		size;
 
@@ -1948,11 +1946,8 @@ xlog_sync(
 	 * Don't call xfs_bwrite here. We do log-syncs even when the filesystem
 	 * is shutting down.
 	 */
-	error = xlog_bdstrat(bp);
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_sync");
-		return error;
-	}
+	xlog_bdstrat(bp);
+
 	if (split) {
 		bp = iclog->ic_log->l_xbuf;
 		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
@@ -1967,13 +1962,8 @@ xlog_sync(
 
 		/* account for internal log which doesn't start at block #0 */
 		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
-		error = xlog_bdstrat(bp);
-		if (error) {
-			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
-			return error;
-		}
+		xlog_bdstrat(bp);
 	}
-	return 0;
 }	/* xlog_sync */
 
 /*
@@ -3220,7 +3210,7 @@ xlog_state_release_iclog(
 	 * flags after this point.
 	 */
 	if (sync)
-		return xlog_sync(log, iclog);
+		xlog_sync(log, iclog);
 	return 0;
 }	/* xlog_state_release_iclog */
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 06a09cb948b5..a0f11bab3add 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2011,7 +2011,7 @@ xlog_recover_reorder_trans(
  * record in the table to tell us how many times we expect to see this
  * record during the second pass.
  */
-STATIC int
+STATIC void
 xlog_recover_buffer_pass1(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
@@ -2025,7 +2025,7 @@ xlog_recover_buffer_pass1(
 	 */
 	if (!(buf_f->blf_flags & XFS_BLF_CANCEL)) {
 		trace_xfs_log_recover_buf_not_cancel(log, buf_f);
-		return 0;
+		return;
 	}
 
 	/*
@@ -2038,7 +2038,7 @@ xlog_recover_buffer_pass1(
 		    bcp->bc_len == buf_f->blf_len) {
 			bcp->bc_refcount++;
 			trace_xfs_log_recover_buf_cancel_ref_inc(log, buf_f);
-			return 0;
+			return;
 		}
 	}
 
@@ -2049,7 +2049,6 @@ xlog_recover_buffer_pass1(
 	list_add_tail(&bcp->bc_list, bucket);
 
 	trace_xfs_log_recover_buf_cancel_add(log, buf_f);
-	return 0;
 }
 
 /*
@@ -3270,7 +3269,7 @@ xlog_recover_inode_pass2(
  * structure, so that we know not to do any dquot item or dquot buffer recovery,
  * of that type.
  */
-STATIC int
+STATIC void
 xlog_recover_quotaoff_pass1(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
@@ -3288,8 +3287,6 @@ xlog_recover_quotaoff_pass1(
 		log->l_quotaoffs_flag |= XFS_DQ_PROJ;
 	if (qoff_f->qf_flags & XFS_GQUOTA_ACCT)
 		log->l_quotaoffs_flag |= XFS_DQ_GROUP;
-
-	return 0;
 }
 
 /*
@@ -3449,7 +3446,7 @@ xlog_recover_efi_pass2(
  * equal to that in the EFD format structure. If we find it we drop the EFD
  * reference, which removes the EFI from the AIL and frees it.
  */
-STATIC int
+STATIC void
 xlog_recover_efd_pass2(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
@@ -3493,8 +3490,6 @@ xlog_recover_efd_pass2(
 
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-
-	return 0;
 }
 
 /*
@@ -3545,7 +3540,7 @@ xlog_recover_rui_pass2(
  * equal to that in the RUD format structure. If we find it we drop the RUD
  * reference, which removes the RUI from the AIL and frees it.
  */
-STATIC int
+STATIC void
 xlog_recover_rud_pass2(
 	struct xlog			*log,
 	struct xlog_recover_item	*item)
@@ -3586,8 +3581,6 @@ xlog_recover_rud_pass2(
 
 	xfs_trans_ail_cursor_done(&cur);
 	spin_unlock(&ailp->ail_lock);
-
-	return 0;
 }
 
 /*
@@ -4072,9 +4065,11 @@ xlog_recover_commit_pass1(
 
 	switch (ITEM_TYPE(item)) {
 	case XFS_LI_BUF:
-		return xlog_recover_buffer_pass1(log, item);
+		xlog_recover_buffer_pass1(log, item);
+		return 0;
 	case XFS_LI_QUOTAOFF:
-		return xlog_recover_quotaoff_pass1(log, item);
+		xlog_recover_quotaoff_pass1(log, item);
+		return 0;
 	case XFS_LI_INODE:
 	case XFS_LI_EFI:
 	case XFS_LI_EFD:
@@ -4115,11 +4110,13 @@ xlog_recover_commit_pass2(
 	case XFS_LI_EFI:
 		return xlog_recover_efi_pass2(log, item, trans->r_lsn);
 	case XFS_LI_EFD:
-		return xlog_recover_efd_pass2(log, item);
+		xlog_recover_efd_pass2(log, item);
+		return 0;
 	case XFS_LI_RUI:
 		return xlog_recover_rui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_RUD:
-		return xlog_recover_rud_pass2(log, item);
+		xlog_recover_rud_pass2(log, item);
+		return 0;
 	case XFS_LI_CUI:
 		return xlog_recover_cui_pass2(log, item, trans->r_lsn);
 	case XFS_LI_CUD:
@@ -5162,7 +5159,7 @@ xlog_recover_process_iunlinks(
 	}
 }
 
-STATIC int
+STATIC void
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
 	char			*dp,
@@ -5185,8 +5182,6 @@ xlog_unpack_data(
 			dp += BBSIZE;
 		}
 	}
-
-	return 0;
 }
 
 /*
@@ -5201,11 +5196,9 @@ xlog_recover_process(
 	int			pass,
 	struct list_head	*buffer_list)
 {
-	int			error;
 	__le32			old_crc = rhead->h_crc;
 	__le32			crc;
 
-
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 
 	/*
@@ -5244,9 +5237,7 @@ xlog_recover_process(
 			return -EFSCORRUPTED;
 	}
 
-	error = xlog_unpack_data(rhead, dp, log);
-	if (error)
-		return error;
+	xlog_unpack_data(rhead, dp, log);
 
 	return xlog_recover_process_data(log, rhash, rhead, dp, pass,
 					 buffer_list);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d71424052917..efb6c1d5f0bc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -475,7 +475,7 @@ struct proc_xfs_info {
 	char		*str;
 };
 
-STATIC int
+STATIC void
 xfs_showargs(
 	struct xfs_mount	*mp,
 	struct seq_file		*m)
@@ -555,8 +555,6 @@ xfs_showargs(
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
-
-	return 0;
 }
 static uint64_t
 xfs_max_file_offset(
@@ -1462,7 +1460,8 @@ xfs_fs_show_options(
 	struct seq_file		*m,
 	struct dentry		*root)
 {
-	return xfs_showargs(XFS_M(root->d_sb), m);
+	xfs_showargs(XFS_M(root->d_sb), m);
+	return 0;
 }
 
 /*

