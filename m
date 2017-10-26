Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:65339 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932375AbdJZIdo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 04:33:44 -0400
Received: from discord.disaster.area ([192.168.1.111])
        by dastard with esmtp (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0003DJ-RQ
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.89)
        (envelope-from <david@fromorbit.com>)
        id 1e7dbS-0005Mm-Ph
        for linux-xfs@vger.kernel.org; Thu, 26 Oct 2017 19:33:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 13/14] xfs: add suport for "thin space" filesystems
Date: Thu, 26 Oct 2017 19:33:21 +1100
Message-Id: <20171026083322.20428-14-david@fromorbit.com>
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
References: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

With separation of the device size from the usuable space, and the
metadata reservation space hidden from the user, we can now add
direct manipulation of the usable space. This involves modifying the
on-disk superblock to store the maximum usable space and allowing
growfs to change the usable space rather than the device size.

This patch adds the feature bit and superblock support for
storing the maximum usable space, growfs will be done separately.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h | 22 ++++++++++++----
 fs/xfs/libxfs/xfs_fs.h     |  4 ++-
 fs/xfs/libxfs/xfs_sb.c     | 62 ++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_fsops.c         |  7 +++++-
 fs/xfs/xfs_ondisk.h        |  2 +-
 5 files changed, 76 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3fb6d2a96d36..38972cd7b9e2 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -105,7 +105,7 @@ struct xfs_ifork;
 typedef struct xfs_sb {
 	uint32_t	sb_magicnum;	/* magic number == XFS_SB_MAGIC */
 	uint32_t	sb_blocksize;	/* logical block size, bytes */
-	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks */
+	xfs_rfsblock_t	sb_dblocks;	/* number of data blocks in device LBA */
 	xfs_rfsblock_t	sb_rblocks;	/* number of realtime blocks */
 	xfs_rtblock_t	sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
@@ -184,6 +184,8 @@ typedef struct xfs_sb {
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
+	uint64_t	sb_usable_dblocks; /* usable space limit */
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
@@ -196,7 +198,7 @@ typedef struct xfs_sb {
 typedef struct xfs_dsb {
 	__be32		sb_magicnum;	/* magic number == XFS_SB_MAGIC */
 	__be32		sb_blocksize;	/* logical block size, bytes */
-	__be64		sb_dblocks;	/* number of data blocks */
+	__be64		sb_dblocks;	/* number of data blocks in device LBA */
 	__be64		sb_rblocks;	/* number of realtime blocks */
 	__be64		sb_rextents;	/* number of realtime extents */
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
@@ -271,6 +273,8 @@ typedef struct xfs_dsb {
 	__be64		sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
+	uint64_t	sb_usable_dblocks; /* usable space limit */
+
 	/* must be padded to 64 bit alignment */
 } xfs_dsb_t;
 
@@ -478,10 +482,12 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
+#define XFS_SB_FEAT_INCOMPAT_THINSPACE	(1 << 3)	/* usable space limited */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
-		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
-		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
-		 XFS_SB_FEAT_INCOMPAT_META_UUID)
+		(XFS_SB_FEAT_INCOMPAT_FTYPE	| \
+		 XFS_SB_FEAT_INCOMPAT_SPINODES	| \
+		 XFS_SB_FEAT_INCOMPAT_META_UUID	| \
+		 XFS_SB_FEAT_INCOMPAT_THINSPACE)
 
 #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
 static inline bool
@@ -559,6 +565,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+static inline bool xfs_sb_version_hasthinspace(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_INCOMPAT_THINSPACE);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 223ec2695678..9fad678cae48 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -211,7 +211,8 @@ struct xfs_fsop_geom {
 	__u32		rtsectsize;	/* realtime sector size, bytes	*/
 	__u32		dirblocksize;	/* directory block size, bytes	*/
 	__u32		logsunit;	/* log stripe unit, bytes	*/
-	__u64		pad[16];	/* expansion space		*/
+	__u64		usable_dblocks;	/* usable space limit, fsblocks	*/
+	__u64		pad[15];	/* expansion space		*/
 };
 
 /* Output for XFS_FS_COUNTS */
@@ -252,6 +253,7 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_SPINODES	(1 << 18) /* sparse inode chunks   */
 #define XFS_FSOP_GEOM_FLAGS_RMAPBT	(1 << 19) /* reverse mapping btree */
 #define XFS_FSOP_GEOM_FLAGS_REFLINK	(1 << 20) /* files can share blocks */
+#define XFS_FSOP_GEOM_FLAGS_THINSPACE	(1 << 21) /* space limited fs	   */
 
 /*
  * Minimum and maximum sizes need for growth checks.
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 87b57abeace2..9a4593970e0a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -268,6 +268,14 @@ xfs_mount_validate_sb(
 		return -EFSCORRUPTED;
 	}
 
+	if (xfs_sb_version_hasthinspace(sbp) &&
+	    (sbp->sb_usable_dblocks > sbp->sb_dblocks ||
+	     sbp->sb_usable_dblocks < sbp->sb_fdblocks ||
+	     sbp->sb_usable_dblocks < XFS_MIN_DBLOCKS(sbp))) {
+		xfs_notice(mp, "Thinspace SB sanity check failed");
+		return -EFSCORRUPTED;
+	}
+
 	/*
 	 * Until this is fixed only page-sized or smaller data blocks work.
 	 */
@@ -417,11 +425,13 @@ __xfs_sb_from_disk(
 	to->sb_features_incompat = be32_to_cpu(from->sb_features_incompat);
 	to->sb_features_log_incompat =
 				be32_to_cpu(from->sb_features_log_incompat);
+
 	/* crc is only used on disk, not in memory; just init to 0 here. */
 	to->sb_crc = 0;
 	to->sb_spino_align = be32_to_cpu(from->sb_spino_align);
 	to->sb_pquotino = be64_to_cpu(from->sb_pquotino);
 	to->sb_lsn = be64_to_cpu(from->sb_lsn);
+
 	/*
 	 * sb_meta_uuid is only on disk if it differs from sb_uuid and the
 	 * feature flag is set; if not set we keep it only in memory.
@@ -430,9 +440,20 @@ __xfs_sb_from_disk(
 		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
 	else
 		uuid_copy(&to->sb_meta_uuid, &from->sb_uuid);
+
 	/* Convert on-disk flags to in-memory flags? */
 	if (convert_xquota)
 		xfs_sb_quota_from_disk(to);
+
+	/*
+	 * Everything in memory relies on sb_usable_dblocks having a correct
+	 * value. For non-thin filesystems, this is not set on disk but is
+	 * simply the size of the device, so use it instead.
+	 */
+	if (xfs_sb_version_hasthinspace(to))
+		to->sb_usable_dblocks = be64_to_cpu(from->sb_usable_dblocks);
+	else
+		to->sb_usable_dblocks = to->sb_dblocks;
 }
 
 void
@@ -561,19 +582,24 @@ xfs_sb_to_disk(
 	to->sb_features2 = cpu_to_be32(from->sb_features2);
 	to->sb_bad_features2 = cpu_to_be32(from->sb_bad_features2);
 
-	if (xfs_sb_version_hascrc(from)) {
-		to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
-		to->sb_features_ro_compat =
-				cpu_to_be32(from->sb_features_ro_compat);
-		to->sb_features_incompat =
-				cpu_to_be32(from->sb_features_incompat);
-		to->sb_features_log_incompat =
+	if (!xfs_sb_version_hascrc(from))
+		return;
+
+	/*
+	 * V5+ fields only after this point.
+	 */
+	to->sb_features_compat = cpu_to_be32(from->sb_features_compat);
+	to->sb_features_ro_compat = cpu_to_be32(from->sb_features_ro_compat);
+	to->sb_features_incompat = cpu_to_be32(from->sb_features_incompat);
+	to->sb_features_log_incompat =
 				cpu_to_be32(from->sb_features_log_incompat);
-		to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
-		to->sb_lsn = cpu_to_be64(from->sb_lsn);
-		if (xfs_sb_version_hasmetauuid(from))
-			uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
-	}
+	to->sb_spino_align = cpu_to_be32(from->sb_spino_align);
+	to->sb_lsn = cpu_to_be64(from->sb_lsn);
+
+	if (xfs_sb_version_hasmetauuid(from))
+		uuid_copy(&to->sb_meta_uuid, &from->sb_meta_uuid);
+	if (xfs_sb_version_hasthinspace(from))
+		to->sb_usable_dblocks = cpu_to_be64(from->sb_usable_dblocks);
 }
 
 static int
@@ -732,7 +758,7 @@ xfs_sb_mount_common(
 	 * Set up the filesystem size and addressing limits
 	 */
 	mp->m_LBA_size = sbp->sb_dblocks;
-	mp->m_usable_blocks = sbp->sb_dblocks;
+	mp->m_usable_blocks = sbp->sb_usable_dblocks;
 
 	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
@@ -824,6 +850,16 @@ xfs_initialize_perag_data(
 	sbp->sb_ifree = ifree;
 	sbp->sb_icount = ialloc;
 	sbp->sb_fdblocks = bfree + bfreelst + btree;
+
+	/*
+	 * The aggregate free space from the AGs does not take into account the
+	 * difference between the address space size and the maximum usable
+	 * space we have configured for thinspace filesystems.  Take that into
+	 * account now.
+	 */
+	if (xfs_sb_version_hasthinspace(sbp))
+		sbp->sb_fdblocks -= sbp->sb_dblocks - sbp->sb_usable_dblocks;
+
 	spin_unlock(&mp->m_sb_lock);
 
 	xfs_reinit_percpu_counters(mp);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b1659e535f7a..e0565eb01c0b 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -124,8 +124,13 @@ xfs_fs_geometry(
 		geo->logsunit = mp->m_sb.sb_logsunit;
 	}
 
-	if (new_version >= 5)
+	if (new_version >= 5) {
 		geo->version = XFS_FSOP_GEOM_VERSION_V5;
+		geo->flags |=
+			(xfs_sb_version_hasthinspace(&mp->m_sb) ?
+				XFS_FSOP_GEOM_FLAGS_THINSPACE : 0);
+		geo->usable_dblocks = mp->m_sb.sb_usable_dblocks;
+	}
 
 	return 0;
 }
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0492436a053f..5ae5dac38e6f 100644
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
-- 
2.15.0.rc0

