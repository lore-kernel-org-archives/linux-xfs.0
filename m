Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B088BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbp7ISv9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAB1C433C8;
	Sun, 31 Dec 2023 21:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056868;
	bh=v/BfpKPPWrorUJeuJf2CbTCxjkvKiwRDgZ9W2lUkCMo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cbp7ISv9zNeOxeGMSHdt+vQLzimV3p3CRCnnduHNunF1z+lhqTlOqli3a8MmN7X7e
	 aShageVodNaQnvcZfBhVD9Dcc2mj2DTy3LZ5C92nZKm+l1/KTPUr5THrDXeKZHVAds
	 tqz3u3v0puiZzU/BLQaRuXveZlVkaogLiGUdxwXb4frfBKQpC91Wj9bLFCR1hD4Ss4
	 pAV5b951OIbDa2SLL/vtTGocRsq+qF11+uCIkggb9ueYVZYvRMHKQIfcZcO1vqzDCf
	 1l+M4YpVbxvvJwrJCs9tBv2RwK6zOoi9h3z/ipHZiVLrgyAJkOuEmRLBf/FgfEIrPv
	 PeeqU2s1iFFEQ==
Date: Sun, 31 Dec 2023 13:07:47 -0800
Subject: [PATCH 06/32] xfs: iget for metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844959.1760491.1091065088619570286.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
References: <170404844790.1760491.7084433932242910678.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a xfs_iget_meta function for metadata inodes to ensure that we
always check that the inobt thinks a metadata inode is in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.h |    5 +++++
 fs/xfs/xfs_icache.c       |   40 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c        |    8 +++++++
 fs/xfs/xfs_qm.c           |   50 ++++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_qm_syscalls.c  |    9 +++++++-
 fs/xfs/xfs_rtalloc.c      |   46 +++++++++++++++++++++++------------------
 6 files changed, 120 insertions(+), 38 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 7b3da865c0931..0a4361bda1c4f 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -47,4 +47,9 @@ unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_link_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 
+/* Must be implemented by the libxfs client */
+int xfs_imeta_iget(struct xfs_trans *tp, xfs_ino_t ino, unsigned char ftype,
+		struct xfs_inode **ipp);
+void xfs_imeta_irele(struct xfs_inode *ip);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f6a9c4f40cfd0..aa8516e8ab64f 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -25,6 +25,9 @@
 #include "xfs_ag.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_dir2.h"
+#include "xfs_imeta.h"
 
 #include <linux/iversion.h>
 
@@ -811,6 +814,43 @@ xfs_iget(
 	return error;
 }
 
+/*
+ * Get a metadata inode.  The ftype must match exactly.  Caller must supply
+ * a transaction (even if empty) to avoid livelocking if the inobt has a cycle.
+ */
+int
+xfs_imeta_iget(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	unsigned char		ftype,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*ip;
+	int			error;
+
+	ASSERT(ftype != XFS_DIR3_FT_UNKNOWN);
+
+	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &ip);
+	if (error == -EFSCORRUPTED)
+		goto whine;
+	if (error)
+		return error;
+
+	if (VFS_I(ip)->i_nlink == 0)
+		goto bad_rele;
+	if (xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype)
+		goto bad_rele;
+
+	*ipp = ip;
+	return 0;
+bad_rele:
+	xfs_irele(ip);
+whine:
+	xfs_err(mp, "metadata inode 0x%llx is corrupt", ino);
+	return -EFSCORRUPTED;
+}
+
 /*
  * Grab the inode for reclaim exclusively.
  *
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 789b9603989c5..f2145e2701f51 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -43,6 +43,7 @@
 #include "xfs_parent.h"
 #include "xfs_xattr.h"
 #include "xfs_inode_util.h"
+#include "xfs_imeta.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -2741,6 +2742,13 @@ xfs_irele(
 	iput(VFS_I(ip));
 }
 
+void
+xfs_imeta_irele(
+	struct xfs_inode	*ip)
+{
+	xfs_irele(ip);
+}
+
 /*
  * Ensure all commited transactions touching the inode are written to the log.
  */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 2352eed966022..2d8e420f3ad34 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -29,6 +29,7 @@
 #include "xfs_health.h"
 #include "xfs_imeta.h"
 #include "xfs_imeta_utils.h"
+#include "xfs_da_format.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -233,15 +234,15 @@ xfs_qm_unmount_quotas(
 	 */
 	if (mp->m_quotainfo) {
 		if (mp->m_quotainfo->qi_uquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_uquotaip);
+			xfs_imeta_irele(mp->m_quotainfo->qi_uquotaip);
 			mp->m_quotainfo->qi_uquotaip = NULL;
 		}
 		if (mp->m_quotainfo->qi_gquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_gquotaip);
+			xfs_imeta_irele(mp->m_quotainfo->qi_gquotaip);
 			mp->m_quotainfo->qi_gquotaip = NULL;
 		}
 		if (mp->m_quotainfo->qi_pquotaip) {
-			xfs_irele(mp->m_quotainfo->qi_pquotaip);
+			xfs_imeta_irele(mp->m_quotainfo->qi_pquotaip);
 			mp->m_quotainfo->qi_pquotaip = NULL;
 		}
 	}
@@ -767,6 +768,7 @@ xfs_qm_qino_switch(
 	unsigned int		flags,
 	bool			*need_alloc)
 {
+	struct xfs_trans	*tp;
 	xfs_ino_t		ino = NULLFSINO;
 	int			error;
 
@@ -793,7 +795,11 @@ xfs_qm_qino_switch(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+	error = xfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, ipp);
+	xfs_trans_cancel(tp);
 	if (error)
 		return error;
 
@@ -1590,6 +1596,7 @@ xfs_qm_init_quotainos(
 	struct xfs_inode	*uip = NULL;
 	struct xfs_inode	*gip = NULL;
 	struct xfs_inode	*pip = NULL;
+	struct xfs_trans	*tp = NULL;
 	int			error;
 	uint			flags = 0;
 
@@ -1599,30 +1606,37 @@ xfs_qm_init_quotainos(
 	 * Get the uquota and gquota inodes
 	 */
 	if (xfs_has_quota(mp)) {
+		error = xfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			return error;
+
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					     0, 0, &uip);
+			error = xfs_imeta_iget(tp, mp->m_sb.sb_uquotino,
+					XFS_DIR3_FT_REG_FILE, &uip);
 			if (error)
-				return error;
+				goto error_rele;
 		}
 		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					     0, 0, &gip);
+			error = xfs_imeta_iget(tp, mp->m_sb.sb_gquotino,
+					XFS_DIR3_FT_REG_FILE, &gip);
 			if (error)
 				goto error_rele;
 		}
 		if (XFS_IS_PQUOTA_ON(mp) &&
 		    mp->m_sb.sb_pquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_pquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-					     0, 0, &pip);
+			error = xfs_imeta_iget(tp, mp->m_sb.sb_pquotino,
+					XFS_DIR3_FT_REG_FILE, &pip);
 			if (error)
 				goto error_rele;
 		}
+
+		xfs_trans_cancel(tp);
+		tp = NULL;
 	} else {
 		flags |= XFS_QMOPT_SBVERSION;
 	}
@@ -1663,12 +1677,14 @@ xfs_qm_init_quotainos(
 	return 0;
 
 error_rele:
+	if (tp)
+		xfs_trans_cancel(tp);
 	if (uip)
-		xfs_irele(uip);
+		xfs_imeta_irele(uip);
 	if (gip)
-		xfs_irele(gip);
+		xfs_imeta_irele(gip);
 	if (pip)
-		xfs_irele(pip);
+		xfs_imeta_irele(pip);
 	return error;
 }
 
@@ -1677,15 +1693,15 @@ xfs_qm_destroy_quotainos(
 	struct xfs_quotainfo	*qi)
 {
 	if (qi->qi_uquotaip) {
-		xfs_irele(qi->qi_uquotaip);
+		xfs_imeta_irele(qi->qi_uquotaip);
 		qi->qi_uquotaip = NULL; /* paranoia */
 	}
 	if (qi->qi_gquotaip) {
-		xfs_irele(qi->qi_gquotaip);
+		xfs_imeta_irele(qi->qi_gquotaip);
 		qi->qi_gquotaip = NULL;
 	}
 	if (qi->qi_pquotaip) {
-		xfs_irele(qi->qi_pquotaip);
+		xfs_imeta_irele(qi->qi_pquotaip);
 		qi->qi_pquotaip = NULL;
 	}
 }
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 392cb39cc10c8..269d333736f5f 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -18,6 +18,8 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_icache.h"
+#include "xfs_imeta.h"
+#include "xfs_da_format.h"
 
 int
 xfs_qm_scall_quotaoff(
@@ -62,7 +64,12 @@ xfs_qm_scall_trunc_qfile(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, &ip);
+	xfs_trans_cancel(tp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 379462ea9a14f..7156a5b55cfb6 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -22,6 +22,8 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_da_format.h"
+#include "xfs_imeta.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1335,16 +1337,12 @@ xfs_rtalloc_reinit_frextents(
  */
 static inline int
 xfs_rtmount_iread_extents(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	unsigned int		lock_class)
 {
-	struct xfs_trans	*tp;
 	int			error;
 
-	error = xfs_trans_alloc_empty(ip->i_mount, &tp);
-	if (error)
-		return error;
-
 	xfs_ilock(ip, XFS_ILOCK_EXCL | lock_class);
 
 	error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
@@ -1359,7 +1357,6 @@ xfs_rtmount_iread_extents(
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL | lock_class);
-	xfs_trans_cancel(tp);
 	return error;
 }
 
@@ -1367,43 +1364,52 @@ xfs_rtmount_iread_extents(
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
+	struct xfs_trans	*tp;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	int			error;
 
-	sbp = &mp->m_sb;
-	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_imeta_iget(tp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rbmip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
-		return error;
+		goto out_trans;
 	ASSERT(mp->m_rbmip != NULL);
 
-	error = xfs_rtmount_iread_extents(mp->m_rbmip, XFS_ILOCK_RTBITMAP);
+	error = xfs_rtmount_iread_extents(tp, mp->m_rbmip, XFS_ILOCK_RTBITMAP);
 	if (error)
 		goto out_rele_bitmap;
 
-	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	error = xfs_imeta_iget(tp, mp->m_sb.sb_rsumino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rsumip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error)
 		goto out_rele_bitmap;
 	ASSERT(mp->m_rsumip != NULL);
 
-	error = xfs_rtmount_iread_extents(mp->m_rsumip, XFS_ILOCK_RTSUM);
+	error = xfs_rtmount_iread_extents(tp, mp->m_rsumip, XFS_ILOCK_RTSUM);
 	if (error)
 		goto out_rele_summary;
 
 	xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
+	xfs_trans_cancel(tp);
 	return 0;
 
 out_rele_summary:
-	xfs_irele(mp->m_rsumip);
+	xfs_imeta_irele(mp->m_rsumip);
 out_rele_bitmap:
-	xfs_irele(mp->m_rbmip);
+	xfs_imeta_irele(mp->m_rbmip);
+out_trans:
+	xfs_trans_cancel(tp);
 	return error;
 }
 
@@ -1413,9 +1419,9 @@ xfs_rtunmount_inodes(
 {
 	kmem_free(mp->m_rsum_cache);
 	if (mp->m_rbmip)
-		xfs_irele(mp->m_rbmip);
+		xfs_imeta_irele(mp->m_rbmip);
 	if (mp->m_rsumip)
-		xfs_irele(mp->m_rsumip);
+		xfs_imeta_irele(mp->m_rsumip);
 }
 
 /*

