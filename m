Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:44928 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfAACXH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:23:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012DnDJ018621
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:06 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2pp0btp7bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:23:06 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012N5uQ013678
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:05 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012N53P028919
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:23:05 GMT
Subject: [PATCH 06/13] xfs: define the on-disk format for the metadir feature
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:23:04 -0800
Message-ID: <154630938409.21716.18345212801449500981.stgit@magnolia>
In-Reply-To: <154630934595.21716.17416691804044507782.stgit@magnolia>
References: <154630934595.21716.17416691804044507782.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define the on-disk layout and feature flags for the metadata inode
directory feature.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h |   30 ++++++++++++++++++++++++++++--
 fs/xfs/xfs_inode.h         |    5 +++++
 2 files changed, 33 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3d9f5d8e4e25..c85a2f2e4c83 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -175,6 +175,14 @@ typedef struct xfs_sb {
 	xfs_lsn_t	sb_lsn;		/* last write sequence */
 	uuid_t		sb_meta_uuid;	/* metadata file system unique id */
 
+	/*
+	 * Metadata Directory Inode.  On disk this lives in the sb_rbmino slot,
+	 * but we continue to use the in-core superblock to cache the classic
+	 * inodes (rt bitmap; rt summary; user, group, and project quotas) so
+	 * we cache the metadir inode value here too.
+	 */
+	xfs_ino_t	sb_metadirino;
+
 	/* must be padded to 64 bit alignment */
 } xfs_sb_t;
 
@@ -193,7 +201,14 @@ typedef struct xfs_dsb {
 	uuid_t		sb_uuid;	/* user-visible file system unique id */
 	__be64		sb_logstart;	/* starting block of log if internal */
 	__be64		sb_rootino;	/* root inode number */
-	__be64		sb_rbmino;	/* bitmap inode for realtime extents */
+	/*
+	 * bitmap inode for realtime extents.
+	 *
+	 * The metadata inode directory feature uses the sb_rbmino field to
+	 * point to the root of the metadata directory tree.  All other sb
+	 * inode pointers are cancelled.
+	 */
+	__be64		sb_rbmino;
 	__be64		sb_rsumino;	/* summary inode for rt bitmap */
 	__be32		sb_rextsize;	/* realtime extent size, blocks */
 	__be32		sb_agblocks;	/* size of an allocation group */
@@ -465,6 +480,7 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
+#define XFS_SB_FEAT_INCOMPAT_METADIR	(1 << 3)	/* metadata ino dir */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -546,6 +562,12 @@ static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
+static inline bool xfs_sb_version_hasmetadir(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
+}
+
 /*
  * end of superblock version macros
  */
@@ -1055,12 +1077,16 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
 #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
 #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
+#define XFS_DIFLAG2_METADATA_BIT 3	/* filesystem metadata */
+
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
 #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
 #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
+#define XFS_DIFLAG2_METADATA	(1 << XFS_DIFLAG2_METADATA_BIT)
 
 #define XFS_DIFLAG2_ANY \
-	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)
+	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
+	 XFS_DIFLAG2_METADATA)
 
 /*
  * Inode number format:
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 211b7d85bf62..5f8375424f62 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -170,6 +170,11 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
 }
 
+static inline bool xfs_is_metadata_inode(struct xfs_inode *ip)
+{
+	return ip->i_d.di_flags2 & XFS_DIFLAG2_METADATA;
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
