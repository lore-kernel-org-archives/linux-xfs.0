Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 809118036
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:44:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 51BDE304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:50 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mjpmi6IVC0uxd9Hn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:44:48 -0700 (PDT)
Subject: [PATCH 12/20] xfs: add realtime reverse map inode to superblock
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:44:42 -0700
Message-ID: <147216868259.3688.1952034016958084309.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Add a field to the superblock to record the rt rmapbt inode and load
it at mount time.  The rtrmapbt inode will have a unique extent format
code, which means that we also have to update the inode validation and
flush routines to look for it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h       |   10 +++++++++-
 fs/xfs/libxfs/xfs_inode_fork.c   |   11 +++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c |    2 +-
 fs/xfs/libxfs/xfs_sb.c           |    2 ++
 fs/xfs/xfs_inode.c               |    9 ++++++++-
 fs/xfs/xfs_inode_item.c          |    2 ++
 fs/xfs/xfs_itable.c              |    1 +
 fs/xfs/xfs_log_recover.c         |   13 ++++++++++++-
 fs/xfs/xfs_mount.h               |    1 +
 fs/xfs/xfs_ondisk.h              |    2 +-
 fs/xfs/xfs_rtalloc.c             |   21 +++++++++++++++++++++
 11 files changed, 69 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 7f30781..4ae3537 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -183,6 +183,7 @@ typedef struct xfs_sb {
 	xfs_ino_t	sb_pquotino;	/* project quota inode */
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
+	xfs_ino_t	sb_rrmapino;	/* realtime reverse map inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
@@ -270,6 +271,7 @@ typedef struct xfs_dsb {
 	__be64		sb_pquotino;	/* project quota inode */
 	__be64		sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
+	__be64		sb_rrmapino;	/* realtime reverse map inode */
 
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
@@ -553,6 +555,11 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline bool xfs_sb_version_hasrtrmapbt(struct xfs_sb *sbp)
+{
+	return sbp->sb_rblocks > 0 && xfs_sb_version_hasrmapbt(sbp);
+}
+
 static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
@@ -948,7 +955,8 @@ typedef enum xfs_dinode_fmt {
 	XFS_DINODE_FMT_LOCAL,		/* bulk data */
 	XFS_DINODE_FMT_EXTENTS,		/* struct xfs_bmbt_rec */
 	XFS_DINODE_FMT_BTREE,		/* struct xfs_bmdr_block */
-	XFS_DINODE_FMT_UUID		/* uuid_t */
+	XFS_DINODE_FMT_UUID,		/* uuid_t */
+	XFS_DINODE_FMT_RMAP,		/* reverse mapping btree */
 } xfs_dinode_fmt_t;
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 2de6cb5..c09c048 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -195,6 +195,13 @@ xfs_iformat_fork(
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
 			XFS_ERROR_REPORT("xfs_iformat(6)", XFS_ERRLEVEL_LOW,
 					 ip->i_mount);
@@ -797,6 +804,10 @@ xfs_iflush_fork(
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
index 71f954a..8f75691 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -354,7 +354,7 @@ xfs_rtrmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return false;
-	if (!xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN))
+	if (!xfs_btree_lblock_v5hdr_verify(bp, mp->m_sb.sb_rrmapino))
 		return false;
 	level = be16_to_cpu(block->bb_level);
 	if (level > mp->m_rtrmap_maxlevels)
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index eb33ec9..87c867e4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -426,6 +426,7 @@ __xfs_sb_from_disk(
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	else
 		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
+	to->sb_rrmapino = be64_to_cpu(from->sb_rrmapino);
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
@@ -569,6 +570,7 @@ xfs_sb_to_disk(
 		to->sb_lsn = cpu_to_be64(from->sb_lsn);
 		if (xfs_sb_version_hasmetauuid(from))
 			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+		to->sb_rrmapino = cpu_to_be64(from->sb_rrmapino);
 	}
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8c2f9a7..e31310b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3514,7 +3514,14 @@ xfs_iflush_int(
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
 		goto corrupt_out;
 	}
-	if (S_ISREG(VFS_I(ip)->i_mode)) {
+	if (ip->i_ino == mp->m_sb.sb_rrmapino) {
+		if (ip->i_d.di_format != XFS_DINODE_FMT_RMAP) {
+			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
+				"%s: Bad rtrmap inode %Lu, ptr 0x%p",
+				__func__, ip->i_ino, ip);
+			goto corrupt_out;
+		}
+	} else if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
 		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 9610e9c..632ea87 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -56,6 +56,7 @@ xfs_inode_item_data_fork_size(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		if ((iip->ili_fields & XFS_ILOG_DBROOT) &&
 		    ip->i_df.if_broot_bytes > 0) {
 			*nbytes += ip->i_df.if_broot_bytes;
@@ -179,6 +180,7 @@ xfs_inode_item_format_data_fork(
 		}
 		break;
 	case XFS_DINODE_FMT_BTREE:
+	case XFS_DINODE_FMT_RMAP:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DEXT |
 			  XFS_ILOG_DEV | XFS_ILOG_UUID);
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4fd5fe1..8b2150d 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -37,6 +37,7 @@ xfs_internal_inum(
 	xfs_ino_t	ino)
 {
 	return (ino == mp->m_sb.sb_rbmino || ino == mp->m_sb.sb_rsumino ||
+		ino == mp->m_sb.sb_rrmapino ||
 		(xfs_sb_version_hasquota(&mp->m_sb) &&
 		 xfs_is_quota_inode(&mp->m_sb, ino)));
 }
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index dc2c80e..fa3a0fb 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3039,7 +3039,18 @@ xlog_recover_inode_pass2(
 	/* Take the opportunity to reset the flush iteration count */
 	ldip->di_flushiter = 0;
 
-	if (unlikely(S_ISREG(ldip->di_mode))) {
+	if (in_f->ilf_ino == mp->m_sb.sb_rrmapino) {
+		if (ldip->di_format != XFS_DINODE_FMT_RMAP) {
+			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
+					 XFS_ERRLEVEL_LOW, mp, ldip);
+			xfs_alert(mp,
+		"%s: Bad rtrmapbt inode log record, rec ptr 0x%p, "
+		"ino ptr = 0x%p, ino bp = 0x%p, ino %Ld",
+				__func__, item, dip, bp, in_f->ilf_ino);
+			error = -EFSCORRUPTED;
+			goto out_release;
+		}
+	} else 	if (unlikely(S_ISREG(ldip->di_mode))) {
 		if ((ldip->di_format != XFS_DINODE_FMT_EXTENTS) &&
 		    (ldip->di_format != XFS_DINODE_FMT_BTREE)) {
 			XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(3)",
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 70d3cc3..5128ec0 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -97,6 +97,7 @@ typedef struct xfs_mount {
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_rrmapip;	/* pointer to rmap inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_quotainfo	*m_quotainfo;	/* disk quota information */
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 88c771e..779b5f0 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -45,7 +45,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dinode,		176);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_disk_dquot,		104);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dqblk,			136);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			264);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dsb,			272);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 802bcc3..401cb17 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1235,6 +1235,25 @@ xfs_rtmount_inodes(
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
+				IRELE(mp->m_rrmapip);
+			return error;
+		}
+		ASSERT(mp->m_rrmapip != NULL);
+		if (mp->m_rrmapip->i_d.di_format != XFS_DINODE_FMT_RMAP) {
+			IRELE(mp->m_rrmapip);
+			mp->m_rrmapip = NULL;
+			return -EFSCORRUPTED;
+		}
+	}
+
 	return 0;
 }
 
@@ -1242,6 +1261,8 @@ void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
+	if (mp->m_rrmapip)
+		IRELE(mp->m_rrmapip);
 	if (mp->m_rbmip)
 		IRELE(mp->m_rbmip);
 	if (mp->m_rsumip)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
