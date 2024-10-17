Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57511E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192224; cv=none; b=qIc71a8pEFXZnKAjzx6yqe2P9lWWm3CyIai99xhBwTg2E2hWyzmFnnrP+qTAMlaZ42Ovd9mrxRA+Tpg0+YKGwnvzwUdFlae9469qaJ965ufWZNlaxLCgjb5lwgrdrxgsKe7Gj8kEFQ6JFxo7oa134djx5qf9A0W6nRVnfiEONUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192224; c=relaxed/simple;
	bh=7GfUwpdzc0U4wBIhJ3wcU6Chv/e1f+4uJQpDUZpPib8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fG+bCBw58JmxxyLNp8lioNU0EmDcN0DyLP8VNHgGbl2cuoejnE4KFpzyo/XEEPrN46cFFDfSJprderJ0c9NTc1i0L4A1BLU0ffgdSweF2g7EuAI2NCodvMEhVS+pFnO7BBqUQQ5QG8iLGwJAM6qLvUEwafgKHrlgRD6lzSbXPdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pfJDsWAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pfJDsWAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F59BC4CEC3;
	Thu, 17 Oct 2024 19:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192224;
	bh=7GfUwpdzc0U4wBIhJ3wcU6Chv/e1f+4uJQpDUZpPib8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pfJDsWAat4DMakqGmRCiPO9pi1iOO75h0haQO9R5DDCixwXRc/X7ehAODzFbONLiN
	 jeNHqoH8gy4emh6WQCutl8ttydeuFfm9+XKxYnfFRd2r5bLro4/13PwC1RuozPS/Ie
	 3byEnQwbR/8ACHrrH3kAWpUlMx2OxYDdGsEZO3UlyPD0K0gKQu3D1UDb+Lth7znejc
	 TSrxJNOR18ZS8mm4M2VeRVpdlLivrOqQIv0CoPURQJ2cx0hyhwsUljmklDE7rSbEuI
	 ulEANtO5nLNZCn4o81Cl0Xcq9+8JOEwqAcxQdHdWwskCBbTGu99RTCuzEmXBE+weEK
	 RUNoWRBe8oBfA==
Date: Thu, 17 Oct 2024 12:10:22 -0700
Subject: [PATCH 3/4] xfs: scrub quota file metapaths
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072680.3454331.8597389388936694218.stgit@frogsfrogsfrogs>
In-Reply-To: <172919072618.3454331.12971255439040173668.stgit@frogsfrogsfrogs>
References: <172919072618.3454331.12971255439040173668.stgit@frogsfrogsfrogs>
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

