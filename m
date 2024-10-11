Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3BD23CE
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728609110; cv=none; b=IRupN+yd5fAPQWH5NKu4RIUTzj3DqwqPnpYDiLPDWJVWJ4fFlH/lYpEuNMSmF7KLLQ05G/iWutvP2yvR88QVIIlm3MRuSOj3KDYfOHIJctyH57JmiNuUnrLdin2PnCuGiDrPMqQOa+ArXNCPtGURN2D467Jgh2kBbBPEFd+u708=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728609110; c=relaxed/simple;
	bh=DfZdJlt35Pt4byfusuv43YzRV3eBwUCOfc2LPAmj87M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X40K2qvmTeIvcSD37IxHfsMkxvvhK/9hInuR6fV/Zvl1Q+uhbXDeDxdeB9Ye63xcvOnTUY5hJGlItMg+IDfTBid+L0ZBUCXyWHT7cpTgc9MZuAoDsPa4Cm6eogUlDt9kUwqDSofu+IqSvK85XCMMEOJZ1i/Bj6986uJDIVQ/Tu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sKsAgpav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sKsAgpav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55948C4CEC5;
	Fri, 11 Oct 2024 01:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728609110;
	bh=DfZdJlt35Pt4byfusuv43YzRV3eBwUCOfc2LPAmj87M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sKsAgpav0oXZW1Y+CJp+dY/lMwzPw0vPRnd3LJ5cbU1KKAn5boimL2uX9Rd1KDheO
	 7DwmoTzD8Ml5/jwRQUmy3FfaOjfo06V3PVYMWB6k7tOCr2hL6gjD0A3ZtGwdjd+Dal
	 9V0lXusty2w130yu/YjeNscArv8oqGhs69Rcb+99PzGO4m1IE8ExazQiRo0iExzHHS
	 Z5H3U1HepqDw2ZKA/5S82uLWKm0VRdK6ATEi6Pjq7E9nejKeW1bJXTncD2wg66nrMJ
	 Z9Zq8b/HViEVnz7paOOfKf+v/EzEFLSev4KEk4IbsIkWdOrCrAah1pNe5a7NDym8tC
	 PR+nQ+fuVfPEQ==
Date: Thu, 10 Oct 2024 18:11:49 -0700
Subject: [PATCH 3/4] xfs: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860645283.4179917.17833294466846585744.stgit@frogsfrogsfrogs>
In-Reply-To: <172860645220.4179917.14075452764287165701.stgit@frogsfrogsfrogs>
References: <172860645220.4179917.14075452764287165701.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h  |    6 +++-
 fs/xfs/scrub/metapath.c |   76 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6ed4b38e864d22..23511fecc07d75 100644
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

