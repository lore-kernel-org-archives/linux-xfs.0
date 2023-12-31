Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2849BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuRxRk0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B5DC433C8;
	Sun, 31 Dec 2023 21:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056852;
	bh=Cx1PCHko8eMo3VZ/vfsw3jstOqOJFo/hyUrod3gG1UM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VuRxRk0ZTJcVlxLYqw1sXUtctOgJN2dAzAJo3ukmD1JWhcgHDK9LXGtIVWA/injKL
	 er19vic/gB6xpWm9EkEcAPqEnRlxTvCNaxPM+7/zBYQsC4K2WuSp35/XI5qv0CfGey
	 EMHNZHjDBOPvV/p5kkF6gWHxcCKmFHFEr03TYUZfnBapelQGgdu7F7L4EtArUkDGjg
	 CglK3lYq4M5qRrvy1i9gwVIVUQhmLgWFaLb9u2WFMFdoQeIjh+jDhkH77NZfib605c
	 ptoXWWT49jMvvmCcEuySKUAXpm2sSZDBFlN+HNmcMvBXEgc7bNSbDckqzgLYuOOe4w
	 CZxLZsu9Ewxxg==
Date: Sun, 31 Dec 2023 13:07:31 -0800
Subject: [PATCH 05/32] xfs: convert quota file creation to use imeta methods
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844943.1760491.3637638667256999821.stgit@frogsfrogsfrogs>
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

Convert the quota file creation code to use xfs_imeta_create instead of
open-coding a bunch of logic.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   91 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 57 insertions(+), 34 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3e7e0f9cecc0e..2352eed966022 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -27,6 +27,8 @@
 #include "xfs_ialloc.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
+#include "xfs_imeta.h"
+#include "xfs_imeta_utils.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -732,6 +734,18 @@ xfs_qm_destroy_quotainfo(
 	mp->m_quotainfo = NULL;
 }
 
+static inline const struct xfs_imeta_path *
+xfs_qflags_to_imeta_path(
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
@@ -739,6 +753,12 @@ xfs_qm_destroy_quotainfo(
  * between gquota and pquota. If the on-disk superblock has GQUOTA and the
  * filesystem is now mounted with PQUOTA, just use sb_gquotino for sb_pquotino
  * and vice-versa.
+ *
+ * We tolerate the direct manipulation of the in-core sb quota inode pointers
+ * here because calling xfs_imeta_ functions is only really required for
+ * filesystems with the metadata directory feature.  That feature requires a v5
+ * superblock, which always supports simultaneous group and project quotas, so
+ * we'll never get here.
  */
 STATIC int
 xfs_qm_qino_switch(
@@ -777,8 +797,13 @@ xfs_qm_qino_switch(
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
@@ -793,7 +818,8 @@ xfs_qm_qino_alloc(
 	struct xfs_inode	**ipp,
 	unsigned int		flags)
 {
-	struct xfs_trans	*tp;
+	struct xfs_imeta_update	upd = { };
+	const struct xfs_imeta_path *path = xfs_qflags_to_imeta_path(flags);
 	int			error;
 	bool			need_alloc = true;
 
@@ -803,29 +829,14 @@ xfs_qm_qino_alloc(
 	if (error)
 		return error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create,
-			need_alloc ? XFS_QM_QINOCREATE_SPACE_RES(mp) : 0,
-			0, 0, &tp);
-	if (error)
-		return error;
-
 	if (need_alloc) {
-		struct xfs_icreate_args	args = {
-			.nlink		= 1,
-		};
-		xfs_ino_t	ino;
-
-		xfs_icreate_args_rootfile(&args, mp, S_IFREG,
-				xfs_has_parent(mp));
-
-		error = xfs_dialloc(&tp, 0, S_IFREG, &ino);
-		if (!error)
-			error = xfs_icreate(tp, ino, &args, ipp);
-		if (error) {
-			xfs_trans_cancel(tp);
-			return error;
-		}
+		error = xfs_imeta_start_create(mp, path, &upd);
+	} else {
+		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_create, 0, 0, 0,
+				&upd.tp);
 	}
+	if (error)
+		goto out_end;
 
 	/*
 	 * Make the changes in the superblock, and log those too.
@@ -844,23 +855,35 @@ xfs_qm_qino_alloc(
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
-	xfs_log_sb(tp);
+	xfs_log_sb(upd.tp);
 
-	error = xfs_trans_commit(tp);
+	if (need_alloc) {
+		error = xfs_imeta_create(&upd, S_IFREG, ipp);
+		if (error)
+			goto out_cancel;
+	}
+
+	error = xfs_imeta_commit_update(&upd);
 	if (error) {
 		ASSERT(xfs_is_shutdown(mp));
 		xfs_alert(mp, "%s failed (error %d)!", __func__, error);
+		goto out_end;
 	}
-	if (need_alloc) {
-		xfs_iunlock(*ipp, XFS_ILOCK_EXCL);
+
+	if (need_alloc)
 		xfs_finish_inode_setup(*ipp);
+
+	return 0;
+
+out_cancel:
+	xfs_imeta_cancel_update(&upd, error);
+out_end:
+	/* Have to finish setting up the inode to ensure it's deleted. */
+	if (*ipp) {
+		xfs_finish_inode_setup(*ipp);
+		xfs_irele(*ipp);
+		*ipp = NULL;
 	}
 	return error;
 }

