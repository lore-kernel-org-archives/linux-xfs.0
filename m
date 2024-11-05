Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B471CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846372; cv=none; b=guPUG5sIO/vr5mge+bhIqmhB+yvJmQf/vNubT++BDJDphWSObNmz5i4NH/6GVX2qrrqj/ar15VhjuWbE2wJGg1qBwCRP7lcAG2NwbUqMt2/AryBgZoyQgKooLdrbtHYSF9JKyX23Ocj74LHwfbP1prIZ9auQZK70R8vQBBepaVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846372; c=relaxed/simple;
	bh=7GfUwpdzc0U4wBIhJ3wcU6Chv/e1f+4uJQpDUZpPib8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wj/7WvJ46VZJvIouyFXaNycrXEJnrq2NpZ2SAhlyhYJN6cDKv4oz+tDUWuTmhlD2I7gxfDI1JIHIvoSEFLDHbBLoQ6/soJvCW90fOwPIwz5GE1glRDoROHZgvGBqcLeuK/KGK4cQVRoLHrSqdy3aVJ0QPNZ+Ks/BW6kLcKNnZpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFJuGBlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFJuGBlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6158AC4CECF;
	Tue,  5 Nov 2024 22:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846372;
	bh=7GfUwpdzc0U4wBIhJ3wcU6Chv/e1f+4uJQpDUZpPib8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UFJuGBlObWf8hjwbm+CsskfYETykA+xFosRKj8yuS3OHDfYfgywTCRHXe73r98qKM
	 mwmuGtSzs9SIKn0CRDBIYLU4jnf0/bJaeBCzXDDvGmgpaBmpqqND6w3ei7xGdgv/AP
	 Sm7XVy5r2Mx4irm16uLsLY/Rc0gv9lXiLuwrtmS8YTrUPkzFRc67Ih1npXnMtYaifL
	 h68AR7uABhD6bsgl1jYtpWqhJwp0/yuAg2lZ5u3qFD/k2HNXJany1PmtfcDHmkBqhG
	 MJyjo89fynbjvtlHylQMIjDm97rSL+xsnUE4NFMcHUKessz6baKWWB20BZFoJbGVWE
	 kbff5NEIOO8Pg==
Date: Tue, 05 Nov 2024 14:39:31 -0800
Subject: [PATCH 3/4] xfs: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084399178.1873039.14519977840767252944.stgit@frogsfrogsfrogs>
In-Reply-To: <173084399117.1873039.18256038294248428421.stgit@frogsfrogsfrogs>
References: <173084399117.1873039.18256038294248428421.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Enable online fsck for quota file metadata directory paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h  |    6 +++-
 fs/xfs/scrub/metapath.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 96f7d3c95fb4bc..41ce4d3d650ec7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -825,9 +825,13 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_RTDIR	(1)  /* rtrgroups metadir */
 #define XFS_SCRUB_METAPATH_RTBITMAP	(2)  /* per-rtg bitmap */
 #define XFS_SCRUB_METAPATH_RTSUMMARY	(3)  /* per-rtg summary */
+#define XFS_SCRUB_METAPATH_QUOTADIR	(4)  /* quota metadir */
+#define XFS_SCRUB_METAPATH_USRQUOTA	(5)  /* user quota */
+#define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
+#define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(4)
+#define XFS_SCRUB_METAPATH_NR		(8)
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index b8e427fd7fa73e..b78db651346518 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -165,6 +165,74 @@ xchk_setup_metapath_rtginode(
 # define xchk_setup_metapath_rtginode(...)	(-ENOENT)
 #endif /* CONFIG_XFS_RT */
 
+#ifdef CONFIG_XFS_QUOTA
+/* Scan the /quota directory itself. */
+static int
+xchk_setup_metapath_quotadir(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_trans	*tp;
+	struct xfs_inode	*dp = NULL;
+	int			error;
+
+	error = xfs_trans_alloc_empty(sc->mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_dqinode_load_parent(tp, &dp);
+	xfs_trans_cancel(tp);
+	if (error)
+		return error;
+
+	error = xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
+			kasprintf(GFP_KERNEL, "quota"), dp);
+	xfs_irele(dp);
+	return error;
+}
+
+/* Scan a quota inode under the /quota directory. */
+static int
+xchk_setup_metapath_dqinode(
+	struct xfs_scrub	*sc,
+	xfs_dqtype_t		type)
+{
+	struct xfs_trans	*tp = NULL;
+	struct xfs_inode	*dp = NULL;
+	struct xfs_inode	*ip = NULL;
+	const char		*path;
+	int			error;
+
+	error = xfs_trans_alloc_empty(sc->mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_dqinode_load_parent(tp, &dp);
+	if (error)
+		goto out_cancel;
+
+	error = xfs_dqinode_load(tp, dp, type, &ip);
+	if (error)
+		goto out_dp;
+
+	xfs_trans_cancel(tp);
+	tp = NULL;
+
+	path = kasprintf(GFP_KERNEL, "%s", xfs_dqinode_path(type));
+	error = xchk_setup_metapath_scan(sc, dp, path, ip);
+
+	xfs_irele(ip);
+out_dp:
+	xfs_irele(dp);
+out_cancel:
+	if (tp)
+		xfs_trans_cancel(tp);
+	return error;
+}
+#else
+# define xchk_setup_metapath_quotadir(...)	(-ENOENT)
+# define xchk_setup_metapath_dqinode(...)	(-ENOENT)
+#endif /* CONFIG_XFS_QUOTA */
+
 int
 xchk_setup_metapath(
 	struct xfs_scrub	*sc)
@@ -186,6 +254,14 @@ xchk_setup_metapath(
 		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_BITMAP);
 	case XFS_SCRUB_METAPATH_RTSUMMARY:
 		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_SUMMARY);
+	case XFS_SCRUB_METAPATH_QUOTADIR:
+		return xchk_setup_metapath_quotadir(sc);
+	case XFS_SCRUB_METAPATH_USRQUOTA:
+		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_USER);
+	case XFS_SCRUB_METAPATH_GRPQUOTA:
+		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_GROUP);
+	case XFS_SCRUB_METAPATH_PRJQUOTA:
+		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_PROJ);
 	default:
 		return -ENOENT;
 	}

