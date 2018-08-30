Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59396 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeH3Wg1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Aug 2018 18:36:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7UIShoh150412
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:58 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2m2xhu6f1s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:58 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIWqOH013505
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:52 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7UIWqqA020876
        for <linux-xfs@vger.kernel.org>; Thu, 30 Aug 2018 18:32:52 GMT
Subject: [PATCH 11/18] xfs: add realtime reverse map inode to superblock
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Aug 2018 11:32:51 -0700
Message-ID: <153565397113.32612.16430496768209026040.stgit@magnolia>
In-Reply-To: <153565389576.32612.11057291402738397706.stgit@magnolia>
References: <153565389576.32612.11057291402738397706.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a field to the superblock to record the rt rmapbt inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h       |   10 +++++++++-
 fs/xfs/libxfs/xfs_inode_buf.c    |    6 ++++++
 fs/xfs/libxfs/xfs_inode_fork.c   |   11 +++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    2 +-
 fs/xfs/libxfs/xfs_sb.c           |    2 ++
 fs/xfs/libxfs/xfs_types.c        |    1 +
 fs/xfs/xfs_inode.c               |    9 ++++++++-
 fs/xfs/xfs_inode_item.c          |    2 ++
 fs/xfs/xfs_log_recover.c         |   14 +++++++++++++-
 fs/xfs/xfs_mount.h               |    1 +
 fs/xfs/xfs_ondisk.h              |    2 +-
 fs/xfs/xfs_rtalloc.c             |   21 +++++++++++++++++++++
 12 files changed, 76 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index ad767b27dbb3..bb5ea9d46c07 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -174,6 +174,7 @@ typedef struct xfs_sb {
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
+	xfs_ino_t	sb_rrmapino;	/* realtime reverse map inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -261,6 +262,7 @@ typedef struct xfs_dsb {
 	__be64		sb_pquotino;	/* project quota inode */
 	__be64		sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
+	__be64		sb_rrmapino;	/* realtime reverse map inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -544,6 +546,11 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline bool xfs_sb_version_hasrtrmapbt(struct xfs_sb *sbp)
+{
+	return sbp->sb_rblocks > 0 && xfs_sb_version_hasrmapbt(sbp);
+}
+
 static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
@@ -926,7 +933,8 @@ typedef enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* added long ago, but never used */
+	XFS_DINODE_FMT_UUID,		/* added long ago, but never used */
+	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
 } xfs_dinode_fmt_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 30d1d60f1d46..e33e3fa22b14 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -480,6 +480,12 @@ xfs_dinode_verify(
 			return __this_address;
 		break;
 	case S_IFREG:
+		if (dip->di_format == XFS_DINODE_FMT_RMAP) {
+			if (ino != mp->m_sb.sb_rrmapino)
+				return __this_address;
+			break;
+		}
+		/* fall through */
 	case S_IFLNK:
 	case S_IFDIR:
 		fa = xfs_dinode_verify_fork(dip, mp, XFS_DATA_FORK);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index cfb68d4befc4..d1401cbdd266 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -76,6 +76,13 @@ xfs_iformat_fork(
 		case XFS_DINODE_FMT_BTREE:
 			error = xfs_iformat_btree(ip, dip, XFS_DATA_FORK);
 			break;
+		case XFS_DINODE_FMT_RMAP:
+			if (!xfs_sb_version_hasrtrmapbt(&ip->i_mount->m_sb))
+				return -EFSCORRUPTED;
+			if (ip->i_ino != ip->i_mount->m_sb.sb_rrmapino)
+				return -EFSCORRUPTED;
+			/* to be implemented later */
+			break;
 		default:
 			return -EFSCORRUPTED;
 		}
@@ -525,6 +532,10 @@ xfs_iflush_fork(
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
index 4529dbc6545c..ce9932397aa1 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -331,7 +331,7 @@ xfs_rtrmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return __this_address;
-	fa = xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN);
+	fa = xfs_btree_lblock_v5hdr_verify(bp, mp->m_sb.sb_rrmapino);
 	if (fa)
 		return fa;
 	level = be16_to_cpu(block->bb_level);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 733bb7e5409c..e21fc6e0d2aa 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -522,6 +522,7 @@ __xfs_sb_from_disk(
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	else
 		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
+	to->sb_rrmapino = be64_to_cpu(from->sb_rrmapino);
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
@@ -665,6 +666,7 @@ xfs_sb_to_disk(
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
 		if (xfs_sb_version_hasmetauuid(from))
 			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+		to->sb_rrmapino = cpu_to_be64(from->sb_rrmapino);
 	}
 }
 
diff --git a/fs/xfs/libxfs/xfs_types.c b/fs/xfs/libxfs/xfs_types.c
index 33a5ca346baf..3679ca947954 100644
--- a/fs/xfs/libxfs/xfs_types.c
+++ b/fs/xfs/libxfs/xfs_types.c
@@ -142,6 +142,7 @@ xfs_internal_inum(
 	xfs_ino_t		ino)
 {
 	return ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
+	       ino == mp->m_sb.sb_rrmapino ||
 		(xfs_sb_version_hasquota(&mp->m_sb) &&
 		 xfs_is_quota_inode(&mp->m_sb, ino));
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0e142787138c..f53e9488e796 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3524,7 +3524,14 @@ xfs_iflush_int(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
-	if (S_ISREG(VFS_I(ip)->i_mode)) {
+	if (ip->i_ino == mp->m_sb.sb_rrmapino) {
+		if (ip->i_d.di_format != XFS_DINODE_FMT_RMAP) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rtrmap inode %llu, ptr 0x%p",
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
index f269c96cb0ab..95af44487b6c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3123,7 +3123,19 @@ xlog_recover_inode_pass2(
 	/* Take the opportunity to reset the flush iteration count */
 	ldip->di_flushiter = 0;
 
-	if (unlikely(S_ISREG(ldip->di_mode))) {
+	if (in_f->ilf_ino == mp->m_sb.sb_rrmapino) {
+		if (ldip->di_format != XFS_DINODE_FMT_RMAP) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
+					 XFS_ERRLEVEL_LOW, mp, ldip,
+					 sizeof(*ldip));
+			xfs_alert(mp,
+		"%s: Bad rtrmapbt inode log record, rec ptr 0x%p, "
+		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
+				__func__, item, dip, bp, in_f->ilf_ino);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	} else if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 5a4df6b860e2..712bec475c5d 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -91,6 +91,7 @@ typedef struct xfs_mount {
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_rrmapip;	/* pointer to rmap inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 23c9b6f047c5..0840ec7e58aa 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -33,7 +33,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			272);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 926ed314ffba..1ac69ff79a22 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1211,6 +1211,25 @@ xfs_rtmount_inodes(
 		return error;
 	}
 	ASSERT(mp->m_rsumip != NULL);
+
+	/* If we have rmap and a realtime device, look for the rtrmapbt. */
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) && mp->m_sb.sb_rblocks > 0) {
+		ASSERT(sbp->sb_rrmapino != NULLFSINO);
+		error = xfs_iget(mp, NULL, sbp->sb_rrmapino, 0, 0,
+				&mp->m_rrmapip);
+		if (error) {
+			if (mp->m_rrmapip)
+				xfs_irele(mp->m_rrmapip);
+			return error;
+		}
+		ASSERT(mp->m_rrmapip != NULL);
+		if (mp->m_rrmapip->i_d.di_format != XFS_DINODE_FMT_RMAP) {
+			xfs_irele(mp->m_rrmapip);
+			mp->m_rrmapip = NULL;
+			return -EFSCORRUPTED;
+		}
+	}
+
 	return 0;
 }
 
@@ -1218,6 +1237,8 @@ void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
+	if (mp->m_rrmapip)
+		xfs_irele(mp->m_rrmapip);
 	if (mp->m_rbmip)
 		xfs_irele(mp->m_rbmip);
 	if (mp->m_rsumip)
