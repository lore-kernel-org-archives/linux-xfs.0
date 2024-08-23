Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CE018B14
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724372924; cv=none; b=AgU6CKCD0LWoMYR2Vbi0mXL9QjTsgOTcTytK/Y30tE5Hyg3NH0Q/CoM9I+uOdYnbM3kyJgGDyFTs6EFPeCGDScDYluOT4PMXl2QGLPTs7Zspdq6Ot+T1sISGnC3htLLUUcBzuSTd1VeKW/3Tni0viDvW0w6pGDgJJxAFpV2qXE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724372924; c=relaxed/simple;
	bh=MGnuWMDxrgZ8AwSNoFf+NAnsIndXpzU6mJYcDrYV67g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKoJEMveWJRUxwHW6FvELksKW+zKcdg8tb4bHfM11NAbdnpfxRA+LDmudRqKU1nxoKBYXBxrKUoPp/M6Zy7kyhtB3iCh/O/0V38I4y/wMPQQ2OkcjHhOPSE9Gjix6uc432fqMDyBRP9+Nvn+XxC/inBJ94/3jxQcLenedQ4TB90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UX9z+f/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UX9z+f/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A7DC32782;
	Fri, 23 Aug 2024 00:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724372924;
	bh=MGnuWMDxrgZ8AwSNoFf+NAnsIndXpzU6mJYcDrYV67g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UX9z+f/O4kctNfmkRZ/iG40fTYuWpJ4QbUEB6JwsGeLKfcx8S+N35aSTMRBD4ltF3
	 DtHNbM9WRVxU0s3eq8tXfsw/twWYgkJk/wf2mpepd/4C8EEpPqmHed6lQve0Zq6rNf
	 HhRKhpS8bx7hMM/Nwyay+9aAMdfCxjGyszBTKNPT/uDAAK8zD7u2ALbyWOKpY31huR
	 N5uZyvBsxlAumh02acaqx1VmWYJG+1pBSLhI1mLblPCY9HL8NE7ZAjf7z9zBJdacW/
	 iMgtke4OzkH3YLJ/JEXk2YuJK8LF3KOrK8/1m8ceg9zmKeYMry5jf/AS1W7M98Neym
	 oN56WuJFa4Ctg==
Date: Thu, 22 Aug 2024 17:28:43 -0700
Subject: [PATCH 3/6] xfs: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437089414.61495.2473580313151427630.stgit@frogsfrogsfrogs>
In-Reply-To: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
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

Enable online fsck for quota file metadata directory paths.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h  |    6 +++-
 fs/xfs/scrub/metapath.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 11fa3d0c38086..d460946cae8f1 100644
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
index e5714655152db..49ea19edc1492 100644
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

