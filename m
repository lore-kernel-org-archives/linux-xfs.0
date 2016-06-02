Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B83257CA3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 09:19:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 221DDAC003
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 07:19:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id BcJd0bJA4FKEqD5b (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 07:19:19 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/3] xfs: add xfs_mp_hasreflink
Date: Thu,  2 Jun 2016 16:19:08 +0200
Message-Id: <1464877150-20457-2-git-send-email-hch@lst.de>
In-Reply-To: <1464877150-20457-1-git-send-email-hch@lst.de>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
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
To: darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Add a per-mount check for reflink capability.  We'll add a mount flag
to enable reflink post-mkfs soon and it'll need this to hook in.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c          |  4 ++--
 fs/xfs/libxfs/xfs_bmap.c           |  4 ++--
 fs/xfs/libxfs/xfs_bmap_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_format.h         |  2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |  4 ++--
 fs/xfs/libxfs/xfs_rmap.c           |  6 +++---
 fs/xfs/libxfs/xfs_rmap_btree.c     |  4 ++--
 fs/xfs/libxfs/xfs_trans_resv.c     |  8 ++++----
 fs/xfs/xfs_aops.c                  |  2 +-
 fs/xfs/xfs_fsops.c                 | 10 +++++-----
 fs/xfs/xfs_ioctl.c                 |  3 +--
 fs/xfs/xfs_mount.h                 |  5 +++++
 fs/xfs/xfs_reflink.c               |  6 +++---
 fs/xfs/xfs_super.c                 |  4 ++--
 14 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e6e32c2..b3cfa34 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -68,7 +68,7 @@ xfs_extlen_t
 xfs_prealloc_blocks(
 	struct xfs_mount	*mp)
 {
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_mp_hasreflink(mp))
 		return xfs_refc_block(mp) + 1;
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return XFS_RMAP_BLOCK(mp) + 1;
@@ -2466,7 +2466,7 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	if (xfs_mp_hasreflink(mp) &&
 	    be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS)
 		return false;
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 7e51f5c..effa8cc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -810,7 +810,7 @@ try_another_ag:
 	 * has a block reservation.  That isn't the case here, so if we run out
 	 * of space we'll try again with another AG.
 	 */
-	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
+	if (xfs_mp_hasreflink(cur->bc_mp) &&
 	    args.fsbno == NULLFSBLOCK &&
 	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
 		flist->xbf_low = 1;
@@ -972,7 +972,7 @@ try_another_ag:
 	 * has a block reservation.  That isn't the case here, so if we run out
 	 * of space we'll try again with another AG.
 	 */
-	if (xfs_sb_version_hasreflink(&ip->i_mount->m_sb) &&
+	if (xfs_mp_hasreflink(ip->i_mount) &&
 	    args.fsbno == NULLFSBLOCK &&
 	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
 		goto try_another_ag;
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index b742bd8..d07718d 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -489,7 +489,7 @@ try_another_ag:
 	 * has a block reservation.  That isn't the case here, so if we run out
 	 * of space we'll try again with another AG.
 	 */
-	if (xfs_sb_version_hasreflink(&cur->bc_mp->m_sb) &&
+	if (xfs_mp_hasreflink(cur->bc_mp) &&
 	    args.fsbno == NULLFSBLOCK &&
 	    args.type == XFS_ALLOCTYPE_NEAR_BNO) {
 		cur->bc_private.b.flist->xbf_low = 1;
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 5cc0b8c..dcfc1ee 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -550,7 +550,7 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 
 static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
 {
-	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 303f959..f83cb4b 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -218,7 +218,7 @@ xfs_refcountbt_verify(
 	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
 		return false;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_mp_hasreflink(mp))
 		return false;
 	if (!xfs_btree_sblock_v5hdr_verify(bp))
 		return false;
@@ -463,7 +463,7 @@ xfs_refcountbt_calc_reserves(
 	xfs_extlen_t		tree_len = 0;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_mp_hasreflink(mp))
 		return 0;
 
 	*ask += xfs_refcountbt_max_size(mp);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index d2bf531..e1ff7d7 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -874,7 +874,7 @@ xfs_rmap_unmap(
 	 * Only data fork extents on a reflink filesystem can overlap.
 	 * Everything else can use the regular free function.
 	 */
-	if (!xfs_sb_version_hasreflink(&mp->m_sb) ||
+	if (!xfs_mp_hasreflink(mp) ||
 	    XFS_RMAP_NON_INODE_OWNER(owner) ||
 	    (flags & XFS_RMAP_BMBT_BLOCK) ||
 	    (flags & XFS_RMAP_ATTR_FORK))
@@ -1047,7 +1047,7 @@ xfs_rmap_map(
 	 * Only data fork extents on a reflink filesystem can overlap.
 	 * Everything else can use the regular alloc function.
 	 */
-	if (!xfs_sb_version_hasreflink(&mp->m_sb) ||
+	if (!xfs_mp_hasreflink(mp) ||
 	    XFS_RMAP_NON_INODE_OWNER(owner) ||
 	    (flags & XFS_RMAP_BMBT_BLOCK) ||
 	    (flags & XFS_RMAP_ATTR_FORK))
@@ -1646,7 +1646,7 @@ xfs_rmap_convert(
 	 * Only data fork extents on a reflink filesystem can overlap.
 	 * Everything else can use the regular convert function.
 	 */
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_mp_hasreflink(mp))
 		return __xfs_rmap_convert(cur, bno, len, unwritten, oinfo);
 	oldext = unwritten ? XFS_RMAP_UNWRITTEN : 0;
 	new_endoff = offset + len;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 3d6f12f..8969722 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -65,7 +65,7 @@ xfs_rmapbt_need_reserve(
 	struct xfs_mount	*mp)
 {
 	return  xfs_sb_version_hasrmapbt(&mp->m_sb) &&
-		xfs_sb_version_hasreflink(&mp->m_sb);
+		xfs_mp_hasreflink(mp);
 }
 
 static struct xfs_btree_cur *
@@ -479,7 +479,7 @@ void
 xfs_rmapbt_compute_maxlevels(
 	struct xfs_mount		*mp)
 {
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_mp_hasreflink(mp))
 		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
 	else
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index c88395b..d53fe89 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -84,7 +84,7 @@ xfs_allocfree_log_count(
 	blocks = num_ops * 2 * (2 * mp->m_ag_maxlevels - 1);
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		blocks += num_ops * (2 * mp->m_rmap_maxlevels - 1);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_mp_hasreflink(mp))
 		blocks += 2 * num_ops * (2 * mp->m_refc_maxlevels - 1);
 
 	return blocks;
@@ -812,14 +812,14 @@ xfs_trans_resv_calc(
 	 * require a permanent reservation on space.
 	 */
 	resp->tr_write.tr_logres = xfs_calc_write_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_mp_hasreflink(mp))
 		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_write.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_write.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_itruncate.tr_logres = xfs_calc_itruncate_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_mp_hasreflink(mp))
 		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
@@ -879,7 +879,7 @@ xfs_trans_resv_calc(
 	resp->tr_growrtalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
 	resp->tr_qm_dqalloc.tr_logres = xfs_calc_qm_dqalloc_reservation(mp);
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_mp_hasreflink(mp))
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT_REFLINK;
 	else
 		resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d053a9e..a030f3e 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -698,7 +698,7 @@ xfs_is_cow_io(
 {
 	bool			is_cow;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
+	if (!xfs_mp_hasreflink(ip->i_mount))
 		return false;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 5b908dc..c2c939e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -111,7 +111,7 @@ xfs_fs_geometry(
 				XFS_FSOP_GEOM_FLAGS_SPINODES : 0) |
 			(xfs_sb_version_hasrmapbt(&mp->m_sb) ?
 				XFS_FSOP_GEOM_FLAGS_RMAPBT : 0) |
-			(xfs_sb_version_hasreflink(&mp->m_sb) ?
+			(xfs_mp_hasreflink(mp) ?
 				XFS_FSOP_GEOM_FLAGS_REFLINK : 0);
 		geo->logsectsize = xfs_sb_version_hassector(&mp->m_sb) ?
 				mp->m_sb.sb_logsectsize : BBSIZE;
@@ -266,7 +266,7 @@ xfs_growfs_data_private(
 		agf->agf_longest = cpu_to_be32(tmpsize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		if (xfs_mp_hasreflink(mp)) {
 			agf->agf_refcount_root = cpu_to_be32(
 					xfs_refc_block(mp));
 			agf->agf_refcount_level = cpu_to_be32(1);
@@ -463,7 +463,7 @@ xfs_growfs_data_private(
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account for refc btree root */
-			if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			if (xfs_mp_hasreflink(mp)) {
 				rrec = XFS_RMAP_REC_ADDR(block, 5);
 				rrec->rm_startblock = cpu_to_be32(
 						xfs_refc_block(mp));
@@ -533,7 +533,7 @@ xfs_growfs_data_private(
 		/*
 		 * refcount btree root block
 		 */
-		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		if (xfs_mp_hasreflink(mp)) {
 			bp = xfs_growfs_get_hdr_buf(mp,
 				XFS_AGB_TO_DADDR(mp, agno, xfs_refc_block(mp)),
 				BTOBB(mp->m_sb.sb_blocksize), 0,
@@ -1075,7 +1075,7 @@ xfs_getfsmap_is_shared(
 	xfs_extlen_t		flen;
 	int			error;
 
-	if (!xfs_sb_version_hasreflink(&cur->bc_mp->m_sb))
+	if (!xfs_mp_hasreflink(cur->bc_mp))
 		return false;
 
 	/* Are there any shared blocks here? */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4668ae6..cfc05ce 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1267,8 +1267,7 @@ xfs_ioctl_setattr_check_cowextsize(
 	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
 		return 0;
 
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	if (!xfs_mp_hasreflink(mp) || ip->i_d.di_version != 3)
 		return -EINVAL;
 
 	if (!S_ISREG(VFS_I(ip)->i_mode) && !S_ISDIR(VFS_I(ip)->i_mode))
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d06b192..c2e1294 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -227,6 +227,11 @@ typedef struct xfs_mount {
 #define	XFS_WSYNC_READIO_LOG	15	/* 32k */
 #define	XFS_WSYNC_WRITEIO_LOG	14	/* 16k */
 
+static inline bool xfs_mp_hasreflink(struct xfs_mount *mp)
+{
+	return xfs_sb_version_hasreflink(&mp->m_sb);
+}
+
 /*
  * Allow large block sizes to be reported to userspace programs if the
  * "largeio" mount option is used.
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 1e17d2e..e2664ea 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -852,7 +852,7 @@ xfs_reflink_recover_cow(
 	xfs_agnumber_t		agno;
 	int			error = 0;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_mp_hasreflink(mp))
 		return 0;
 
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
@@ -1416,7 +1416,7 @@ xfs_reflink_remap_range(
 	xfs_extlen_t		cowextsize;
 	bool			is_same;
 
-	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+	if (!xfs_mp_hasreflink(mp))
 		return -EOPNOTSUPP;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -1880,7 +1880,7 @@ xfs_reflink_check_flag_adjust(
 
 	if (!chg)
 		return 0;
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
+	if (!xfs_mp_hasreflink(ip->i_mount))
 		return -EOPNOTSUPP;
 	if (i_size_read(VFS_I(ip)) != 0)
 		return -EINVAL;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 58068fc..84348af 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1589,7 +1589,7 @@ xfs_fs_fill_super(
 		"Block device does not support DAX Turning DAX off.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
-		if (xfs_sb_version_hasreflink(&mp->m_sb))
+		if (xfs_mp_hasreflink(mp))
 			xfs_alert(mp,
 		"DAX and reflink have not been tested together!");
 	}
@@ -1602,7 +1602,7 @@ xfs_fs_fill_super(
 		xfs_alert(mp,
 	"EXPERIMENTAL reverse mapping btree feature enabled. Use at your own risk!");
 
-	if (xfs_sb_version_hasreflink(&mp->m_sb))
+	if (xfs_mp_hasreflink(mp))
 		xfs_alert(mp,
 	"EXPERIMENTAL reflink feature enabled. Use at your own risk!");
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
