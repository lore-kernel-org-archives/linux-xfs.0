Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbfEAPz4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 May 2019 11:55:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5ACA7307D91F
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 15:55:56 +0000 (UTC)
Received: from Liberator-6.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B3BF690A8
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 15:55:55 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: change some error-less functions to void types
Message-ID: <a8eec37c-0cb1-0dc6-aa65-7248e367fc08@redhat.com>
Date: Wed, 1 May 2019 10:55:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

There are several functions which have no opportunity to retun
an error, and don't contain any ASSERTs which could be argued
to be better constructed as error cases.  So, make them voids
to simplify the callers.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I had sent this a while back, and Darrick had concerns about a
few functions which maybe /should/ return errors; I tried to avoid
changing anything which was remotely close to that case, and stick
to the simple/obvious ones.

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index fb5bd9a804f6..e12f2962f80f 100644
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
@@ -134,7 +134,7 @@ xfs_dqblk_repair(
 				 XFS_DQUOT_CRC_OFF);
 	}
 
-	return 0;
+	return;
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
index 6fab49f6070b..fb3e22462cec 100644
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
@@ -1167,11 +1167,11 @@ xfs_fs_geometry(
 	geo->logsunit = sbp->sb_logsunit;
 
 	if (struct_version < 5)
-		return 0;
+		return;
 
 	geo->version = XFS_FSOP_GEOM_VERSION_V5;
 
-	return 0;
+	return;
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
index 584648582ba7..944e22c98dda 100644
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
@@ -302,7 +302,7 @@ xfs_fs_counts(
 	spin_lock(&mp->m_sb_lock);
 	cnt->freertx = mp->m_sb.sb_frextents;
 	spin_unlock(&mp->m_sb_lock);
-	return 0;
+	return;
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
index 4591598ca04d..c3f036ff50d8 100644
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
@@ -1126,7 +1126,7 @@ xfs_bumplink(
 	ASSERT(ip->i_d.di_version > 1);
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return 0;
+	return;
 }
 
 int
@@ -1235,9 +1235,7 @@ xfs_create(
 		if (error)
 			goto out_trans_cancel;
 
-		error = xfs_bumplink(tp, dp);
-		if (error)
-			goto out_trans_cancel;
+		xfs_bumplink(tp, dp);
 	}
 
 	/*
@@ -1454,9 +1452,7 @@ xfs_link(
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
-	error = xfs_bumplink(tp, sip);
-	if (error)
-		goto error_return;
+	xfs_bumplink(tp, sip);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -3097,9 +3093,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp2);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp1);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp1);
 			}
 
 			/*
@@ -3123,9 +3117,7 @@ xfs_cross_rename(
 				error = xfs_droplink(tp, dp1);
 				if (error)
 					goto out_trans_abort;
-				error = xfs_bumplink(tp, dp2);
-				if (error)
-					goto out_trans_abort;
+				xfs_bumplink(tp, dp2);
 			}
 
 			/*
@@ -3322,9 +3314,7 @@ xfs_rename(
 					XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 
 		if (new_parent && src_is_directory) {
-			error = xfs_bumplink(tp, target_dp);
-			if (error)
-				goto out_trans_cancel;
+			xfs_bumplink(tp, target_dp);
 		}
 	} else { /* target_ip != NULL */
 		/*
@@ -3443,9 +3433,7 @@ xfs_rename(
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
index 3371d1ff27c4..1036e1a620db 100644
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
@@ -5191,7 +5191,7 @@ xlog_unpack_data(
 		}
 	}
 
-	return 0;
+	return;
 }
 
 /*
@@ -5206,11 +5206,9 @@ xlog_recover_process(
 	int			pass,
 	struct list_head	*buffer_list)
 {
-	int			error;
 	__le32			old_crc = rhead->h_crc;
 	__le32			crc;
 
-
 	crc = xlog_cksum(log, rhead, dp, be32_to_cpu(rhead->h_len));
 
 	/*
@@ -5249,9 +5247,7 @@ xlog_recover_process(
 			return -EFSCORRUPTED;
 	}
 
-	error = xlog_unpack_data(rhead, dp, log);
-	if (error)
-		return error;
+	xlog_unpack_data(rhead, dp, log);
 
 	return xlog_recover_process_data(log, rhash, rhead, dp, pass,
 					 buffer_list);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 86c18f2232ca..5f05f227494c 100644
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
@@ -528,7 +528,7 @@ xfs_showargs(
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, ",noquota");
 
-	return 0;
+	return;
 }
 static uint64_t
 xfs_max_file_offset(
@@ -1449,7 +1449,8 @@ xfs_fs_show_options(
 	struct seq_file		*m,
 	struct dentry		*root)
 {
-	return xfs_showargs(XFS_M(root->d_sb), m);
+	xfs_showargs(XFS_M(root->d_sb), m);
+	return 0;
 }
 
 /*
