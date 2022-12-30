Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C74C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:11:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbiLaBLn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:11:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiLaBLm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:11:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161CD16588
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:11:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C959DB81DEF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82199C433D2;
        Sat, 31 Dec 2022 01:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449098;
        bh=aqEZmjTKymTa0nef860KHokbppmCxrfUdQtiImiRCbw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WRwkPDCd3ht9jQSKqoOUimxj2rPpnXoCeefbzOD6/WygMg75YoiGVkQXQAWfNP8CE
         WqHs3myIcmEnHotL1nRmd8zWVnjIq7ONDbdE7WzXm8sSryX6t1ZrkhCFf5t9Oe+4gE
         0MKRCgI25q3a1+OdoXNHJwftD5fq5SfLYadbgeyf9mBe7hE9Y8SmJ3Nxgr0v4AAYDB
         W8DjC+Br39st1Nby5AOR4NJD5DBm0Iydjcm6mPTvNVbACmta4g8uLJqctDhDSmKr/T
         AOfICrK5Mo/9vOkf/w9IJltImSQaVtFvHebUPXFu2VFBuvDN5pCJOw4ac7dsMTijxy
         visKB9EOmv82w==
Subject: [PATCH 05/23] xfs: convert all users to xfs_imeta_log
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:25 -0800
Message-ID: <167243864527.708110.250814978271493655.stgit@magnolia>
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

Convert all open-coded sb metadata inode pointer logging to use
xfs_imeta_log.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   85 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 4c629a3bc69e..0f193e85294b 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -27,6 +27,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_imeta.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -731,6 +732,18 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+static inline const struct xfs_imeta_path *
+xfs_qflags_to_imeta(
+	unsigned int	qflags)
+{
+	if (qflags & XFS_QMOPT_UQUOTA)
+		return &XFS_IMETA_USRQUOTA;
+	else if (qflags & XFS_QMOPT_GQUOTA)
+		return &XFS_IMETA_GRPQUOTA;
+	else
+		return &XFS_IMETA_PRJQUOTA;
+}
+
 /*
  * Switch the group and project quota in-core inode pointers if needed.
  *
@@ -738,6 +751,12 @@ xfs_qm_destroy_quotainfo(
  * between gquota and pquota. If the on-disk superblock has GQUOTA and the
  * filesystem is now mounted with PQUOTA, just use sb_gquotino for sb_pquotino
  * and vice-versa.
+ *
+ * We tolerate the direct manipulation of the in-core sb quota inode pointers
+ * here because calling xfs_imeta_log is only really required for filesystems
+ * with the metadata directory feature.  That feature requires a v5 superblock,
+ * which always supports simultaneous group and project quotas, so we'll never
+ * get here.
  */
 STATIC int
 xfs_qm_qino_switch(
@@ -776,8 +795,13 @@ xfs_qm_qino_switch(
 	if (error)
 		return error;
 
-	mp->m_sb.sb_gquotino = NULLFSINO;
-	mp->m_sb.sb_pquotino = NULLFSINO;
+	if (flags & XFS_QMOPT_PQUOTA) {
+		mp->m_sb.sb_gquotino = NULLFSINO;
+		mp->m_sb.sb_pquotino = ino;
+	} else if (flags & XFS_QMOPT_GQUOTA) {
+		mp->m_sb.sb_gquotino = ino;
+		mp->m_sb.sb_pquotino = NULLFSINO;
+	}
 	*need_alloc = false;
 	return 0;
 }
@@ -792,7 +816,9 @@ xfs_qm_qino_alloc(
 	struct xfs_inode	**ipp,
 	unsigned int		flags)
 {
+	struct xfs_imeta_update	upd;
 	struct xfs_trans	*tp;
+	const struct xfs_imeta_path *path = xfs_qflags_to_imeta(flags);
 	int			error;
 	bool			need_alloc = true;
 
@@ -802,28 +828,15 @@ xfs_qm_qino_alloc(
 	if (error)
 		return error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
-			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
+	error = xfs_imeta_start_update(mp, path, &upd);
+	if (error)
+		return error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_imeta_create,
+			need_alloc ? xfs_imeta_create_space_res(mp) : 0,
 			0, 0, &tp);
 	if (error)
-		return error;
-
-	if (need_alloc) {
-		struct xfs_icreate_args	args = {
-			.nlink		= 1,
-		};
-		xfs_ino_t	ino;
-
-		xfs_icreate_args_rootfile(&args, S_IFREG);
-
-		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
-		if (!error)
-			error = xfs_icreate(tp, ino, &args, ipp);
-		if (error) {
-			xfs_trans_cancel(tp);
-			return error;
-		}
-	}
+		goto out_end;
 
 	/*
 	 * Make the changes in the superblock, and log those too.
@@ -842,22 +855,38 @@ xfs_qm_qino_alloc(
 		/* qflags will get updated fully _after_ quotacheck */
 		mp->m_sb.sb_qflags = mp->m_qflags & XFS_ALL_QUOTA_ACCT;
 	}
-	if (flags & XFS_QMOPT_UQUOTA)
-		mp->m_sb.sb_uquotino = (*ipp)->i_ino;
-	else if (flags & XFS_QMOPT_GQUOTA)
-		mp->m_sb.sb_gquotino = (*ipp)->i_ino;
-	else
-		mp->m_sb.sb_pquotino = (*ipp)->i_ino;
 	spin_unlock(&mp->m_sb_lock);
 	xfs_log_sb(tp);
 
+	if (need_alloc) {
+		error = xfs_imeta_create(&tp, path, S_IFREG,
+				XFS_IMETA_CREATE_NOQUOTA, ipp, &upd);
+		if (error)
+			goto out_cancel;
+	}
+
 	error = xfs_trans_commit(tp);
 	if (error) {
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
+		goto out_end;
 	}
+
+	xfs_imeta_end_update(mp, &upd, error);
 	if (need_alloc)
 		xfs_finish_inode_setup(*ipp);
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_end:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (*ipp) {
+		xfs_finish_inode_setup(*ipp);
+		xfs_irele(*ipp);
+		*ipp = NULL;
+	}
+	xfs_imeta_end_update(mp, &upd, error);
 	return error;
 }
 

