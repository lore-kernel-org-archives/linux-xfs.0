Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 465CC8419
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:59:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E01B38F8037
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:51 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 3zljgclq5fcPfxCp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:59:50 -0700 (PDT)
Subject: [PATCH 11/29] xfs: add realtime reverse map inode to superblock
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:59:45 -0700
Message-ID: <147216958525.7022.10338035699781363413.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
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

Add a field to the superblock to record the rt rmap inode and load
it at mount time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_mount.h       |    1 +
 libxfs/init.c             |    6 ++++--
 libxfs/xfs_format.h       |   10 +++++++++-
 libxfs/xfs_inode_fork.c   |   11 +++++++++++
 libxfs/xfs_rtrmap_btree.c |    2 +-
 libxfs/xfs_sb.c           |    2 ++
 6 files changed, 28 insertions(+), 4 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index fcc0d95..8e9c9f0 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -42,6 +42,7 @@ typedef struct xfs_mount {
 	uint			m_rsumsize;	/* size of rt summary, bytes */
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
+	struct xfs_inode	*m_rrmapip;	/* realtime rmap inode */
 	struct xfs_buftarg	*m_ddev_targp;
 	struct xfs_buftarg	*m_logdev_targp;
 	struct xfs_buftarg	*m_rtdev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index e3f8a5d..3217ec7 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -458,7 +458,7 @@ rtmount_init(
 		(uint)sizeof(xfs_suminfo_t) * mp->m_rsumlevels *
 		sbp->sb_rbmblocks;
 	mp->m_rsumsize = roundup(mp->m_rsumsize, sbp->sb_blocksize);
-	mp->m_rbmip = mp->m_rsumip = NULL;
+	mp->m_rbmip = mp->m_rsumip = mp->m_rrmapip = NULL;
 
 	/*
 	 * Allow debugger to be run without the realtime device present.
@@ -830,11 +830,13 @@ libxfs_mount(
 void
 libxfs_rtmount_destroy(xfs_mount_t *mp)
 {
+	if (mp->m_rrmapip)
+		IRELE(mp->m_rrmapip);
 	if (mp->m_rsumip)
 		IRELE(mp->m_rsumip);
 	if (mp->m_rbmip)
 		IRELE(mp->m_rbmip);
-	mp->m_rsumip = mp->m_rbmip = NULL;
+	mp->m_rsumip = mp->m_rbmip = mp->m_rrmapip = NULL;
 }
 
 /*
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 82ff6fc..5fb5e52 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 6ed0254..b006e2f 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -191,6 +191,13 @@ xfs_iformat_fork(
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
@@ -793,6 +800,10 @@ xfs_iflush_fork(
 		}
 		break;
 
+	case XFS_DINODE_FMT_RMAP:
+		/* to be implemented later */
+		break;
+
 	default:
 		ASSERT(0);
 		break;
diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 66c9190..e4dbe88 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -352,7 +352,7 @@ xfs_rtrmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return false;
-	if (!xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN))
+	if (!xfs_btree_lblock_v5hdr_verify(bp, mp->m_sb.sb_rrmapino))
 		return false;
 	level = be16_to_cpu(block->bb_level);
 	if (level > mp->m_rtrmap_maxlevels)
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 2e6afe9..14ec707 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
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
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
