Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58242 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbfAACZi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:25:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012Pb7G174372
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:37 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2pnxedxaxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:25:37 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x012PaIS002443
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:36 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012Pa2A009694
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:25:36 GMT
Subject: [PATCH 11/20] xfs: add realtime reverse map inode to superblock
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:25:34 -0800
Message-ID: <154630953486.8108.6134586997810335429.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a metadir path to select the realtime rmap btree inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h       |    9 +++++++-
 fs/xfs/libxfs/xfs_imeta.c        |    2 ++
 fs/xfs/libxfs/xfs_imeta.h        |    1 +
 fs/xfs/libxfs/xfs_inode_buf.c    |    6 +++++
 fs/xfs/libxfs/xfs_inode_fork.c   |    9 ++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    5 ++++
 fs/xfs/xfs_inode.c               |    9 +++++++-
 fs/xfs/xfs_inode_item.c          |    2 ++
 fs/xfs/xfs_log_recover.c         |    1 +
 fs/xfs/xfs_mount.h               |    1 +
 fs/xfs/xfs_rtalloc.c             |   43 +++++++++++++++++++++++++++++++-------
 11 files changed, 77 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1e6b1441fe5b..56311ec70bf1 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -569,6 +569,12 @@ static inline bool xfs_sb_version_hasmetadir(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
 }
 
+static inline bool xfs_sb_version_hasrtrmapbt(struct xfs_sb *sbp)
+{
+	return xfs_sb_version_hasmetadir(sbp) && sbp->sb_rblocks > 0 &&
+	       xfs_sb_version_hasrmapbt(sbp);
+}
+
 /*
  * end of superblock version macros
  */
@@ -948,7 +954,8 @@ typedef enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
+	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
+	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
 } xfs_dinode_fmt_t;
 
 #define XFS_INODE_FORMAT_STR \
diff --git a/fs/xfs/libxfs/xfs_imeta.c b/fs/xfs/libxfs/xfs_imeta.c
index 0095b86646b9..989baa4ac0b3 100644
--- a/fs/xfs/libxfs/xfs_imeta.c
+++ b/fs/xfs/libxfs/xfs_imeta.c
@@ -57,12 +57,14 @@
 /* Static metadata inode paths */
 static const char *rtbitmap_path[]	= {"realtime", "0.bitmap"};
 static const char *rtsummary_path[]	= {"realtime", "0.summary"};
+static const char *rtrmapbt_path[]	= {"realtime", "0.rmap"};
 static const char *usrquota_path[]	= {"quota", "user"};
 static const char *grpquota_path[]	= {"quota", "group"};
 static const char *prjquota_path[]	= {"quota", "project"};
 
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTBITMAP,	rtbitmap_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTSUMMARY,	rtsummary_path);
+XFS_IMETA_DEFINE_PATH(XFS_IMETA_RTRMAPBT,	rtrmapbt_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_USRQUOTA,	usrquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_GRPQUOTA,	grpquota_path);
 XFS_IMETA_DEFINE_PATH(XFS_IMETA_PRJQUOTA,	prjquota_path);
diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 33024889fc71..7e183f7c2db3 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -33,6 +33,7 @@ struct xfs_imeta_end {
 /* Lookup keys for static metadata inodes. */
 extern const struct xfs_imeta_path XFS_IMETA_RTBITMAP;
 extern const struct xfs_imeta_path XFS_IMETA_RTSUMMARY;
+extern const struct xfs_imeta_path XFS_IMETA_RTRMAPBT;
 extern const struct xfs_imeta_path XFS_IMETA_USRQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_GRPQUOTA;
 extern const struct xfs_imeta_path XFS_IMETA_PRJQUOTA;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index debacf69f126..bf4230461f0c 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -409,6 +409,12 @@ xfs_dinode_verify_fork(
 			return __this_address;
 		}
 		break;
+	case XFS_DINODE_FMT_RMAP:
+		if (!xfs_sb_version_hasrtrmapbt(&mp->m_sb))
+			return __this_address;
+		if (!(dip->di_flags2 & be64_to_cpu(XFS_DIFLAG2_METADATA)))
+			return __this_address;
+		break;
 	default:
 		return __this_address;
 	}
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index cfb68d4befc4..dddc9a6f9bc3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -76,6 +76,11 @@ xfs_iformat_fork(
 		case XFS_DINODE_FMT_BTREE:
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
+		case XFS_DINODE_FMT_RMAP:
+			if (!xfs_sb_version_hasrtrmapbt(&ip->i_mount->m_sb))
+				return -EFSCORRUPTED;
+			/* to be implemented later */
+			break;
 		default:
 			return -EFSCORRUPTED;
 		}
@@ -525,6 +530,10 @@ xfs_iflush_fork(
 		}
 		break;
 
+	case XFS_DINODE_FMT_RMAP:
+		/* to be implemented later */
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 4529dbc6545c..cb0df68c6b6a 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -324,6 +324,7 @@ xfs_rtrmapbt_verify(
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	xfs_failaddr_t		fa;
+	xfs_ino_t		ino = XFS_RMAP_OWN_UNKNOWN;
 	int			level;
 
 	if (block->bb_magic != cpu_to_be32(XFS_RTRMAP_CRC_MAGIC))
@@ -331,7 +332,9 @@ xfs_rtrmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return __this_address;
-	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	if (mp->m_rrmapip)
+		ino = mp->m_rrmapip->i_ino;
+	fa = xfs_btree_lblock_v5hdr_verify(bp, ino);
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index abd332a13d95..39b490e83c07 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2628,7 +2628,14 @@ xfs_iflush_int(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
-	if (S_ISREG(VFS_I(ip)->i_mode)) {
+	if (ip->i_d.di_format == XFS_DINODE_FMT_RMAP) {
+		if (mp->m_rrmapip && mp->m_rrmapip->i_ino != ip->i_ino) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rt rmapbt inode %Lu, ptr "PTR_FMT,
+				__func__, ip->i_ino, ip);
+			goto corrupt_out;
+		}
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index fa1c4fe2ffbf..1d2eb7bf9e04 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -46,6 +46,7 @@ xfs_inode_item_data_fork_size(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -166,6 +167,7 @@ xfs_inode_item_format_data_fork(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT | XFS_ILOG_DEV);
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 7b0fbd2be5f1..be969bbca522 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3115,6 +3115,7 @@ xlog_recover_inode_pass2(
 
 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ldip->di_format != XFS_DINODE_FMT_RMAP) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
 					 XFS_ERRLEVEL_LOW, mp, ldip,
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 95ed6c7bc3be..9c79cb87a74a 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -102,6 +102,7 @@ typedef struct xfs_mount {
 	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_rrmapip;	/* pointer to rmap inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_inode	*m_metadirip;	/* metadata inode directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index cedaf2f94362..8a7cf57d509b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1199,12 +1199,13 @@ xfs_rtmount_init(
  * Get the bitmap and summary inodes and the summary cache into the mount
  * structure at mount time.
  */
-int					/* error */
+int
 xfs_rtmount_inodes(
-	xfs_mount_t	*mp)		/* file system mount structure */
+	struct xfs_mount	*mp)
 {
-	int		error;		/* error return value */
-	xfs_sb_t	*sbp;
+	struct xfs_sb		*sbp;
+	xfs_ino_t		ino;
+	int			error;
 
 	sbp = &mp->m_sb;
 	error = xfs_imeta_iget(mp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
@@ -1215,11 +1216,28 @@ xfs_rtmount_inodes(
 
 	error = xfs_imeta_iget(mp, mp->m_sb.sb_rsumino, XFS_DIR3_FT_REG_FILE,
 			&mp->m_rsumip);
-	if (error) {
-		xfs_imeta_irele(mp->m_rbmip);
-		return error;
-	}
+	if (error)
+		goto out_rbm;
+
 	ASSERT(mp->m_rsumip != NULL);
+
+	/* If we have rmap and a realtime device, look for the rtrmapbt. */
+	if (xfs_sb_version_hasrtrmapbt(&mp->m_sb)) {
+		error = xfs_imeta_lookup(mp, &XFS_IMETA_RTRMAPBT, &ino);
+		if (error)
+			goto out_rsum;
+
+		error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE,
+				&mp->m_rrmapip);
+		if (error)
+			goto out_rsum;
+
+		if (mp->m_rrmapip->i_d.di_format != XFS_DINODE_FMT_RMAP) {
+			error = -EFSCORRUPTED;
+			goto out_rrmap;
+		}
+	}
+
 	/*
 	 * The rsum cache is initialized to all zeroes, which is trivially a
 	 * lower bound on the minimum level with any free extents. We can
@@ -1229,6 +1247,13 @@ xfs_rtmount_inodes(
 	if (!mp->m_rsum_cache)
 		xfs_warn(mp, "could not allocate realtime summary cache");
 	return 0;
+out_rrmap:
+	xfs_imeta_irele(mp->m_rrmapip);
+out_rsum:
+	xfs_imeta_irele(mp->m_rsumip);
+out_rbm:
+	xfs_imeta_irele(mp->m_rbmip);
+	return error;
 }
 
 void
@@ -1236,6 +1261,8 @@ xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
 	kmem_free(mp->m_rsum_cache);
+	if (mp->m_rrmapip)
+		xfs_imeta_irele(mp->m_rrmapip);
 	if (mp->m_rbmip)
 		xfs_imeta_irele(mp->m_rbmip);
 	if (mp->m_rsumip)
