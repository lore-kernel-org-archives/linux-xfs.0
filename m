Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A8E687F6C
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 13:42:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 281C6AC002
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 11:42:06 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fxXEHvvMp552Q9WK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 11:42:05 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 88978B8149
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 18:42:04 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t52Ig4XW016939
	for <xfs@oss.sgi.com>; Tue, 2 Jun 2015 14:42:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 06/28] xfs: sparse inode chunks feature helpers and mount
	requirements
Date: Tue,  2 Jun 2015 14:41:39 -0400
Message-Id: <1433270521-62026-7-git-send-email-bfoster@redhat.com>
In-Reply-To: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
References: <1433270521-62026-1-git-send-email-bfoster@redhat.com>
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

[xfsprogs:
 Dropped the experimental feature warning to reduce userspace noise and
 facilitate testing.]

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_format.h |  7 +++++++
 libxfs/xfs_sb.c     | 18 ++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 20acbc4..f5b3499 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -457,6 +457,7 @@ xfs_sb_has_ro_compat_feature(
 }
 
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
+#define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE)
 
@@ -506,6 +507,12 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index fe16e8f..d528a3f 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -172,6 +172,24 @@ xfs_mount_validate_sb(
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
+		align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
+				>> sbp->sb_blocklog;
+		if (sbp->sb_inoalignmt != align) {
+			xfs_warn(mp,
+"Inode block alignment (%u) must match chunk size (%u) for sparse inodes.",
+				 sbp->sb_inoalignmt, align);
+			return -EINVAL;
+		}
+	}
+
 	if (unlikely(
 	    sbp->sb_logstart == 0 && mp->m_logdev_targp == mp->m_ddev_targp)) {
 		xfs_warn(mp,
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
