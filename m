Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7BD0C7F90
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 13:53:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2335430407B
	for <xfs@oss.sgi.com>; Fri,  6 Feb 2015 11:53:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DB8Ela8bi5XgRL6P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Feb 2015 11:53:08 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t16Jr7bX003239
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:07 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t16Jr63N023187
	for <xfs@oss.sgi.com>; Fri, 6 Feb 2015 14:53:06 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 03/18] xfs: sparse inode chunks feature helpers and mount
	requirements
Date: Fri,  6 Feb 2015 14:52:50 -0500
Message-Id: <1423252385-3063-4-git-send-email-bfoster@redhat.com>
In-Reply-To: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The sparse inode chunks feature uses the helper function to enable the
allocation of sparse inode chunks. The incompatible feature bit is set
on disk at mkfs time to prevent mount from unsupported kernels.

Also, enforce the inode alignment requirements required for sparse inode
chunks at mount time. When enabled, full inode chunks (and all inode
record) alignment is increased from cluster size to inode chunk size.
Sparse inode alignment must match the cluster size of the fs. Both
superblock alignment fields are set as such by mkfs when sparse inode
support is enabled.

Finally, warn that sparse inode chunks is an experimental feature until
further notice.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_format.h |  7 +++++++
 fs/xfs/libxfs/xfs_sb.c     | 22 ++++++++++++++++++++++
 fs/xfs/xfs_mount.c         | 16 ++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 051c24d..26e5d92 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -519,6 +519,7 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE)
 
@@ -568,6 +569,12 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
 }
 
+static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
+}
+
 /*
  * end of superblock version macros
  */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d6b4dbeb..90d252a 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -182,6 +182,28 @@ xfs_mount_validate_sb(
 			return -EFSCORRUPTED;
 	}
 
+	/*
+	 * Full inode chunks must be aligned to inode chunk size when
+	 * sparse inodes are enabled to support the sparse chunk
+	 * allocation algorithm and prevent overlapping inode records.
+	 */
+	if (xfs_sb_version_hassparseinodes(sbp)) {
+		uint32_t	align;
+
+		xfs_alert(mp,
+		"v5 superblock with sparse inode chunk support detected.\n"
+		"This feature is EXPERIMENTAL. Use at your own risk!");
+
+		align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
+				>> sbp->sb_blocklog;
+		if (sbp->sb_inoalignmt != align) {
+			xfs_warn(mp, "Invalid inode alignment (%u blks). "
+		"Must match inode chunk size (%u blks) with sparse inodes.",
+				 sbp->sb_inoalignmt, align);
+			return -EINVAL;
+		}
+	}
+
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 4fa80e6..7ac52a3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -738,6 +738,22 @@ xfs_mountfs(
 	}
 
 	/*
+	 * If enabled, sparse inode chunk alignment is expected to match the
+	 * cluster size. Full inode chunk alignment must match the chunk size,
+	 * but that is checked on sb read verification...
+	 */
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb) &&
+	    mp->m_sb.sb_spinoalignmt !=
+	    XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size)) {
+		xfs_warn(mp, "Invalid sparse inode chunk alignment (%u blks). "
+			 "Must match cluster size (%llu blks).",
+			 mp->m_sb.sb_spinoalignmt,
+			 XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size));
+		error = -EINVAL;
+		goto out_remove_uuid;
+	}
+
+	/*
 	 * Set inode alignment fields
 	 */
 	xfs_set_inoalignment(mp);
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
