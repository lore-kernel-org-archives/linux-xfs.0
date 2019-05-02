Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:35764 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbfEBOuV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 May 2019 10:50:21 -0400
Subject: [PATCH V3] xfs: change some error-less functions to void types
References: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c12bb330-bb07-ae9c-2812-4fb39e4262dd@sandeen.net>
Date: Thu, 2 May 2019 09:50:19 -0500
MIME-Version: 1.0
In-Reply-To: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

There are several functions which have no opportunity to return
an error, and don't contain any ASSERTs which could be argued
to be better constructed as error cases.  So, make them voids
to simplify the callers.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---

V2: Drop changes to xlog_bdstrat for now, as callers still need
(added) error checking, can do that as separate patch.

V3: Fix commit log typo, drop return at end of void function()

I had sent this a while back, and Darrick had concerns about a
few functions which maybe /should/ return errors; I tried to avoid
changing anything which was remotely close to that case, and stick
to the simple/obvious ones.

 libxfs/xfs_dquot_buf.c  |    4 +---
 libxfs/xfs_quota_defs.h |    2 +-
 libxfs/xfs_sb.c         |   12 +++++-------
 libxfs/xfs_sb.h         |    2 +-
 xfs_fsops.c             |    3 +--
 xfs_fsops.h             |    2 +-
 xfs_inode.c             |   27 +++++++--------------------
 xfs_ioctl.c             |    9 ++-------
 xfs_ioctl32.c           |    5 +----
 xfs_log.c               |   20 ++++++--------------
 xfs_log_recover.c       |   10 ++--------
 xfs_super.c             |    8 ++++----
 12 files changed, 32 insertions(+), 72 deletions(-)



diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index fb5bd9a804f6..88fa11071f9f 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -110,7 +110,7 @@ xfs_dqblk_verify(
 /*
  * Do some primitive error checking on ondisk dquot data structures.
  */
-int
+void
 xfs_dqblk_repair(
 	struct xfs_mount	*mp,
 	struct xfs_dqblk	*dqb,
@@ -133,8 +133,6 @@ xfs_dqblk_repair(
 		xfs_update_cksum((char *)dqb, sizeof(struct xfs_dqblk),
 				 XFS_DQUOT_CRC_OFF);
 	}
-
-	return 0;
 }
 
 STATIC bool
diff --git a/fs/xfs/libxfs/xfs_quota_defs.h b/fs/xfs/libxfs/xfs_quota_defs.h
index 4bfdd5f4c6af..b2113b17e53c 100644
--- a/fs/xfs/libxfs/xfs_quota_defs.h
+++ b/fs/xfs/libxfs/xfs_quota_defs.h
@@ -142,7 +142,7 @@ extern xfs_failaddr_t xfs_dquot_verify(struct xfs_mount *mp,
 extern xfs_failaddr_t xfs_dqblk_verify(struct xfs_mount *mp,
 		struct xfs_dqblk *dqb, xfs_dqid_t id, uint type);
 extern int xfs_calc_dquots_per_chunk(unsigned int nbblks);
-extern int xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
+extern void xfs_dqblk_repair(struct xfs_mount *mp, struct xfs_dqblk *dqb,
 		xfs_dqid_t id, uint type);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 6fab49f6070b..e76a3e5d28d7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1085,7 +1085,7 @@ xfs_sync_sb_buf(
 	return error;
 }
 
-int
+void
 xfs_fs_geometry(
 	struct xfs_sb		*sbp,
 	struct xfs_fsop_geom	*geo,
@@ -1109,13 +1109,13 @@ xfs_fs_geometry(
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
@@ -1159,7 +1159,7 @@ xfs_fs_geometry(
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 
 	if (struct_version < 4)
-		return 0;
+		return;
 
 	if (xfs_sb_version_haslogv2(sbp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_LOGV2;
@@ -1167,11 +1167,9 @@ xfs_fs_geometry(
 	geo->logsunit = sbp->sb_logsunit;
 
 	if (struct_version < 5)
-		return 0;
+		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
-
-	return 0;
 }
 
 /* Read a secondary superblock. */
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 13564d69800a..92465a9a5162 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -33,7 +33,7 @@ extern void	xfs_sb_quota_from_disk(struct xfs_sb *sbp);
 extern int	xfs_update_secondary_sbs(struct xfs_mount *mp);
 
 #define XFS_FS_GEOM_MAX_STRUCT_VER	(4)
-extern int	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
+extern void	xfs_fs_geometry(struct xfs_sb *sbp, struct xfs_fsop_geom *geo,
 				int struct_version);
 extern int	xfs_sb_read_secondary(struct xfs_mount *mp,
 				struct xfs_trans *tp, xfs_agnumber_t agno,
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 584648582ba7..3d0e0570e3aa 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -289,7 +289,7 @@ xfs_growfs_log(
  * exported through ioctl XFS_IOC_FSCOUNTS
  */
 
-int
+void
 xfs_fs_counts(
 	xfs_mount_t		*mp,
 	xfs_fsop_counts_t	*cnt)
@@ -302,7 +302,6 @@ xfs_fs_counts(
 	spin_lock(&mp->m_sb_lock);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	spin_unlock(&mp->m_sb_lock);
-	return 0;
 }
 
 /*
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index d023db0862c2..92869f6ec8d3 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -8,7 +8,7 @@
 
 extern int xfs_growfs_data(xfs_mount_t *mp, xfs_growfs_data_t *in);
 extern int xfs_growfs_log(xfs_mount_t *mp, xfs_growfs_log_t *in);
-extern int xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
+extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4591598ca04d..71d216cf6f87 100644
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
@@ -1235,9 +1234,7 @@ xfs_create(
 		if (error)
 			goto out_trans_cancel;
 
-		error = xfs_bumplink(tp, dp);
-		if (error)
-			goto out_trans_cancel;
+		xfs_bumplink(tp, dp);
 	}
 
 	/*
@@ -1454,9 +1451,7 @@ xfs_link(
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
-	error = xfs_bumplink(tp, sip);
-	if (error)
-		goto error_return;
+	xfs_bumplink(tp, sip);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -3097,9 +3092,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp2);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp1);
 			}
 
 			/*
@@ -3123,9 +3116,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp1);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp2);
 			}
 
 			/*
@@ -3322,9 +3313,7 @@ xfs_rename(
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 		if (new_parent && src_is_directory) {
-			error = xfs_bumplink(tp, target_dp);
-			if (error)
-				goto out_trans_cancel;
+			xfs_bumplink(tp, target_dp);
 		}
 	} else { /* target_ip != NULL */
 		/*
@@ -3443,9 +3432,7 @@ xfs_rename(
 	 */
 	if (wip) {
 		ASSERT(VFS_I(wip)->i_nlink == 0);
-		error = xfs_bumplink(tp, wip);
-		if (error)
-			goto out_trans_cancel;
+		xfs_bumplink(tp, wip);
 		error = xfs_iunlink_remove(tp, wip);
 		if (error)
 			goto out_trans_cancel;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 21d6f433c375..d7dfc13f30f5 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -788,11 +788,8 @@ xfs_ioc_fsgeometry(
 {
 	struct xfs_fsop_geom	fsgeo;
 	size_t			len;
-	int			error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
-	if (error)
-		return error;
+	xfs_fs_geometry(&mp->m_sb, &fsgeo, struct_version);
 
 	if (struct_version <= 3)
 		len = sizeof(struct xfs_fsop_geom_v1);
@@ -2046,9 +2043,7 @@ xfs_file_ioctl(
 	case XFS_IOC_FSCOUNTS: {
 		xfs_fsop_counts_t out;
 
-		error = xfs_fs_counts(mp, &out);
-		if (error)
-			return error;
+		xfs_fs_counts(mp, &out);
 
 		if (copy_to_user(arg, &out, sizeof(out)))
 			return -EFAULT;
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 65997a6315e9..614fc6886d24 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -53,11 +53,8 @@ xfs_compat_ioc_fsgeometry_v1(
 	compat_xfs_fsop_geom_v1_t __user *arg32)
 {
 	struct xfs_fsop_geom	  fsgeo;
-	int			  error;
 
-	error = xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
-	if (error)
-		return error;
+	xfs_fs_geometry(&mp->m_sb, &fsgeo, 3);
 	/* The 32-bit variant simply has some padding at the end */
 	if (copy_to_user(arg32, &fsgeo, sizeof(struct compat_xfs_fsop_geom_v1)))
 		return -EFAULT;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 457ced3ee3e1..d8fb48025696 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1780,7 +1780,7 @@ xlog_cksum(
  * ensure that completes before tearing down the iclogbufs. Hence we need to
  * hold the buffer lock across the log IO to acheive that.
  */
-STATIC int
+STATIC void
 xlog_bdstrat(
 	struct xfs_buf		*bp)
 {
@@ -1797,11 +1797,11 @@ xlog_bdstrat(
 		 * doing it here. Similarly, IO completion will unlock the
 		 * buffer, so we don't do it here.
 		 */
-		return 0;
+		return;
 	}
 
 	xfs_buf_submit(bp);
-	return 0;
+	return;
 }
 
 /*
@@ -1840,7 +1840,6 @@ xlog_sync(
 	uint		count_init;	/* initial count before roundup */
 	int		roundoff;       /* roundoff to BB or stripe */
 	int		split = 0;	/* split write into two regions */
-	int		error;
 	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
 	int		size;
 
@@ -1959,11 +1958,8 @@ xlog_sync(
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
@@ -1978,11 +1974,7 @@ xlog_sync(
 
 		/* account for internal log which doesn't start at block #0 */
 		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
-		error = xlog_bdstrat(bp);
-		if (error) {
-			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
-			return error;
-		}
+		xlog_bdstrat(bp);
 	}
 	return 0;
 }	/* xlog_sync */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 3371d1ff27c4..9329f5adbfbe 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5167,7 +5167,7 @@ xlog_recover_process_iunlinks(
 	}
 }
 
-STATIC int
+STATIC void
 xlog_unpack_data(
 	struct xlog_rec_header	*rhead,
 	char			*dp,
@@ -5190,8 +5190,6 @@ xlog_unpack_data(
 			dp += BBSIZE;
 		}
 	}
-
-	return 0;
 }
 
 /*
@@ -5206,11 +5204,9 @@ xlog_recover_process(
 	int			pass,
 	struct list_head	*buffer_list)
 {
-	int			error;
 	__le32			old_crc = rhead->h_crc;
 	__le32			crc;
 
-
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 
 	/*
@@ -5249,9 +5245,7 @@ xlog_recover_process(
 			return -EFSCORRUPTED;
 	}
 
-	error = xlog_unpack_data(rhead, dp, log);
-	if (error)
-		return error;
+	xlog_unpack_data(rhead, dp, log);
 
 	return xlog_recover_process_data(log, rhash, rhead, dp, pass,
 					 buffer_list);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 86c18f2232ca..7668d57c9218 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -448,7 +448,7 @@ struct proc_xfs_info {
 	char		*str;
 };
 
-STATIC int
+STATIC void
 xfs_showargs(
 	struct xfs_mount	*mp,
 	struct seq_file		*m)
@@ -527,9 +527,8 @@ xfs_showargs(
 
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
-
-	return 0;
 }
+
 static uint64_t
 xfs_max_file_offset(
 	unsigned int		blockshift)
@@ -1449,7 +1448,8 @@ xfs_fs_show_options(
 	struct seq_file		*m,
 	struct dentry		*root)
 {
-	return xfs_showargs(XFS_M(root->d_sb), m);
+	xfs_showargs(XFS_M(root->d_sb), m);
+	return 0;
 }
 
 /*
