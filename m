Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABAEAC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:12:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiLaBMA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236024AbiLaBL4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:11:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C4B178B4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:11:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A1761D5E
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ABB7C433D2;
        Sat, 31 Dec 2022 01:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449114;
        bh=RPR1flVvYiSx8hRhDI2nWEQKVfbis1CxFvMvU/JaADk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EZ/wl2wrw6fegP5yQvS5LLxqoVdq838K1NL7NpY48HRdpbngwDc+YdVBl7w2WQ2Y2
         NgiSIsr0l6jAaCCNQBuJl7a4wwfF3BVEYRvsaiRQg1ouruBJwM+LBNpdiMKD3vlwca
         TtZVwlFJPM9Sg7eLzqD8ZKhb1GeTG36C1SgBNa5/2MyxQXBUEmrtuzZpZ/HR+saXWf
         qvWdm75vqNlXJv4hwQHIfDxVONRca6A+9lXlyrMMiEX0eDXvAzgOriPDKhmQaurspG
         OcXbgze2hBVevRELO1MB/Vy5B8GMleAIgwADSP+M7qbBEJUXXTC+rNesipT48u0vvi
         NgZAJr3hyHNsg==
Subject: [PATCH 06/23] xfs: iget for metadata inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864541.708110.2165213946448505881.stgit@magnolia>
In-Reply-To: <167243864431.708110.1688096566212843499.stgit@magnolia>
References: <167243864431.708110.1688096566212843499.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a xfs_iget_meta function for metadata inodes to ensure that we
always check that the inobt thinks a metadata inode is in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_imeta.h |    5 +++++
 fs/xfs/xfs_icache.c       |   36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.c        |    8 ++++++++
 fs/xfs/xfs_qm.c           |   33 +++++++++++++++++----------------
 fs/xfs/xfs_qm_syscalls.c  |    4 +++-
 fs/xfs/xfs_rtalloc.c      |   16 ++++++++++------
 6 files changed, 79 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_imeta.h b/fs/xfs/libxfs/xfs_imeta.h
index 9d54cb0d7962..312e3a6fdb96 100644
--- a/fs/xfs/libxfs/xfs_imeta.h
+++ b/fs/xfs/libxfs/xfs_imeta.h
@@ -48,4 +48,9 @@ int xfs_imeta_mount(struct xfs_mount *mp);
 unsigned int xfs_imeta_create_space_res(struct xfs_mount *mp);
 unsigned int xfs_imeta_unlink_space_res(struct xfs_mount *mp);
 
+/* Must be implemented by the libxfs client */
+int xfs_imeta_iget(struct xfs_mount *mp, xfs_ino_t ino, unsigned char ftype,
+		struct xfs_inode **ipp);
+void xfs_imeta_irele(struct xfs_inode *ip);
+
 #endif /* __XFS_IMETA_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 06b3de67d791..bccdaf51cd67 100644
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
 
@@ -905,6 +908,39 @@ xfs_icache_inode_is_allocated(
 	return error;
 }
 
+/* Get a metadata inode.  The ftype must match exactly. */
+int
+xfs_imeta_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	unsigned char		ftype,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_inode	*ip;
+	int			error;
+
+	ASSERT(ftype != XFS_DIR3_FT_UNKNOWN);
+
+	error = xfs_iget(mp, NULL, ino, XFS_IGET_UNTRUSTED, 0, &ip);
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
index fdd5e5c89e62..83127fed2b10 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -40,6 +40,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_inode_util.h"
+#include "xfs_imeta.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -2709,6 +2710,13 @@ xfs_irele(
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
index 0f193e85294b..8828e8cafca5 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -28,6 +28,7 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_imeta.h"
+#include "xfs_da_format.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -232,15 +233,15 @@ xfs_qm_unmount_quotas(
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
@@ -791,7 +792,7 @@ xfs_qm_qino_switch(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, ipp);
+	error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, ipp);
 	if (error)
 		return error;
 
@@ -1576,24 +1577,24 @@ xfs_qm_init_quotainos(
 		if (XFS_IS_UQUOTA_ON(mp) &&
 		    mp->m_sb.sb_uquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_uquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_uquotino,
-					     0, 0, &uip);
+			error = xfs_imeta_iget(mp, mp->m_sb.sb_uquotino,
+					XFS_DIR3_FT_REG_FILE, &uip);
 			if (error)
 				return error;
 		}
 		if (XFS_IS_GQUOTA_ON(mp) &&
 		    mp->m_sb.sb_gquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_gquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_gquotino,
-					     0, 0, &gip);
+			error = xfs_imeta_iget(mp, mp->m_sb.sb_gquotino,
+					XFS_DIR3_FT_REG_FILE, &gip);
 			if (error)
 				goto error_rele;
 		}
 		if (XFS_IS_PQUOTA_ON(mp) &&
 		    mp->m_sb.sb_pquotino != NULLFSINO) {
 			ASSERT(mp->m_sb.sb_pquotino > 0);
-			error = xfs_iget(mp, NULL, mp->m_sb.sb_pquotino,
-					     0, 0, &pip);
+			error = xfs_imeta_iget(mp, mp->m_sb.sb_pquotino,
+					XFS_DIR3_FT_REG_FILE, &pip);
 			if (error)
 				goto error_rele;
 		}
@@ -1638,11 +1639,11 @@ xfs_qm_init_quotainos(
 
 error_rele:
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
 
@@ -1651,15 +1652,15 @@ xfs_qm_destroy_quotainos(
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
index 392cb39cc10c..30474d67bf82 100644
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
@@ -62,7 +64,7 @@ xfs_qm_scall_trunc_qfile(
 	if (ino == NULLFSINO)
 		return 0;
 
-	error = xfs_iget(mp, NULL, ino, 0, 0, &ip);
+	error = xfs_imeta_iget(mp, ino, XFS_DIR3_FT_REG_FILE, &ip);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 883333036519..726e3cec34d5 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -22,6 +22,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
 #include "xfs_trace.h"
+#include "xfs_da_format.h"
+#include "xfs_imeta.h"
 
 /*
  * Read and return the summary information for a given extent size,
@@ -1375,7 +1377,8 @@ xfs_rtmount_inodes(
 	xfs_sb_t	*sbp;
 
 	sbp = &mp->m_sb;
-	error = xfs_iget(mp, NULL, sbp->sb_rbmino, 0, 0, &mp->m_rbmip);
+	error = xfs_imeta_iget(mp, mp->m_sb.sb_rbmino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rbmip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
 	if (error)
@@ -1386,7 +1389,8 @@ xfs_rtmount_inodes(
 	if (error)
 		goto out_rele_bitmap;
 
-	error = xfs_iget(mp, NULL, sbp->sb_rsumino, 0, 0, &mp->m_rsumip);
+	error = xfs_imeta_iget(mp, mp->m_sb.sb_rsumino, XFS_DIR3_FT_REG_FILE,
+			&mp->m_rsumip);
 	if (xfs_metadata_is_sick(error))
 		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
 	if (error)
@@ -1401,9 +1405,9 @@ xfs_rtmount_inodes(
 	return 0;
 
 out_rele_summary:
-	xfs_irele(mp->m_rsumip);
+	xfs_imeta_irele(mp->m_rsumip);
 out_rele_bitmap:
-	xfs_irele(mp->m_rbmip);
+	xfs_imeta_irele(mp->m_rbmip);
 	return error;
 }
 
@@ -1413,9 +1417,9 @@ xfs_rtunmount_inodes(
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

