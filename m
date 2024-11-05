Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8988118E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730846185; cv=none; b=BzAsO1GgujnHbh5HkVozeqU4kd/JOv/GvyOM9GfL1nXa/shVXdBtMaasF++mPkzQr1zjmbLKGEjBIR4YN1Cg9ir0OIhi6MRPZPIEt/jlA94LecDbjNdj7iZ1UDbVPDbLMmMkahxrY//MDT3v+ZPmLozLgRaHxnn7HXbjqza/mmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730846185; c=relaxed/simple;
	bh=DCclybK8wzM0Nc0Qu6mAf43naRWPiYtjjY5Gi+T5GUs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dJfB3KPKtHHpxiSarogJ/Ewy58sIlxR8M9QcEcnNSlwhcrEzx9LO442x60yKppKVr5oO1V1whMZZWQv43H+K5K56OyADO1dMNlHw5nwXMZcVk2hTR2FKNgBZObandwwM1NtLTiP2uxj0Xz3C2MAAmIE85f1DQn3N/A+TdvuzwGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDGSWzKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDGSWzKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B96C4CECF;
	Tue,  5 Nov 2024 22:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730846185;
	bh=DCclybK8wzM0Nc0Qu6mAf43naRWPiYtjjY5Gi+T5GUs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=oDGSWzKanAz7YGgcGQjfuUqRvg1EvEnpG5kSNl5EKR5hmB9c9DNqw/yrV7DY+SVRj
	 nxCPWMqZ+PX1I20+OI4CyesAuEXhFcfhfTmAZDGh/V3YuLWC9YWLoHj7udq3JzTeLW
	 m8aap9X8LvlQYjVCNm7MeLKkp3qjN3+zRLqRoL+BXFH2Ync08sQq3AGwAzKtu+V8cy
	 8QpdMKcIkUEdTxTzFC8Wgtuk6JYW92g0Xxma2VU41TUSLj7OTeRSN6BzgIkx0oV6/C
	 asiiXKHnBquEV6bFGYj+uVD+281Tuy0gP2Ch9Eljo5g/oylUp8dIIratwqGfR0VQl/
	 lJ+WbeE8fQCYA==
Date: Tue, 05 Nov 2024 14:36:24 -0800
Subject: [PATCH 25/34] xfs: scrub metadir paths for rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398612.1871887.14413264868812765172.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the code we need to scan the metadata directory paths of rt group
metadata files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h  |    5 ++-
 fs/xfs/scrub/metapath.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 96 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 50de6ad88dbe45..96f7d3c95fb4bc 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -822,9 +822,12 @@ struct xfs_scrub_vec_head {
  * path checking.
  */
 #define XFS_SCRUB_METAPATH_PROBE	(0)  /* do we have a metapath scrubber? */
+#define XFS_SCRUB_METAPATH_RTDIR	(1)  /* rtrgroups metadir */
+#define XFS_SCRUB_METAPATH_RTBITMAP	(2)  /* per-rtg bitmap */
+#define XFS_SCRUB_METAPATH_RTSUMMARY	(3)  /* per-rtg summary */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(1)
+#define XFS_SCRUB_METAPATH_NR		(4)
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index edc1a395c4015a..b8e427fd7fa73e 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -20,6 +20,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_attr.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -79,6 +80,91 @@ xchk_metapath_cleanup(
 	kfree(mpath->path);
 }
 
+/* Set up a metadir path scan.  @path must be dynamically allocated. */
+static inline int
+xchk_setup_metapath_scan(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	const char		*path,
+	struct xfs_inode	*ip)
+{
+	struct xchk_metapath	*mpath;
+	int			error;
+
+	if (!path)
+		return -ENOMEM;
+
+	error = xchk_install_live_inode(sc, ip);
+	if (error) {
+		kfree(path);
+		return error;
+	}
+
+	mpath = kzalloc(sizeof(struct xchk_metapath), XCHK_GFP_FLAGS);
+	if (!mpath) {
+		kfree(path);
+		return -ENOMEM;
+	}
+
+	mpath->sc = sc;
+	sc->buf = mpath;
+	sc->buf_cleanup = xchk_metapath_cleanup;
+
+	mpath->dp = dp;
+	mpath->path = path; /* path is now owned by mpath */
+
+	mpath->xname.name = mpath->path;
+	mpath->xname.len = strlen(mpath->path);
+	mpath->xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
+
+	return 0;
+}
+
+#ifdef CONFIG_XFS_RT
+/* Scan the /rtgroups directory itself. */
+static int
+xchk_setup_metapath_rtdir(
+	struct xfs_scrub	*sc)
+{
+	if (!sc->mp->m_rtdirip)
+		return -ENOENT;
+
+	return xchk_setup_metapath_scan(sc, sc->mp->m_metadirip,
+			kasprintf(GFP_KERNEL, "rtgroups"), sc->mp->m_rtdirip);
+}
+
+/* Scan a rtgroup inode under the /rtgroups directory. */
+static int
+xchk_setup_metapath_rtginode(
+	struct xfs_scrub	*sc,
+	enum xfs_rtg_inodes	type)
+{
+	struct xfs_rtgroup	*rtg;
+	struct xfs_inode	*ip;
+	int			error;
+
+	rtg = xfs_rtgroup_get(sc->mp, sc->sm->sm_agno);
+	if (!rtg)
+		return -ENOENT;
+
+	ip = rtg->rtg_inodes[type];
+	if (!ip) {
+		error = -ENOENT;
+		goto out_put_rtg;
+	}
+
+	error = xchk_setup_metapath_scan(sc, sc->mp->m_rtdirip,
+			xfs_rtginode_path(rtg_rgno(rtg), type), ip);
+
+out_put_rtg:
+	xfs_rtgroup_put(rtg);
+	return error;
+}
+#else
+# define xchk_setup_metapath_rtdir(...)		(-ENOENT)
+# define xchk_setup_metapath_rtginode(...)	(-ENOENT)
+#endif /* CONFIG_XFS_RT */
+
 int
 xchk_setup_metapath(
 	struct xfs_scrub	*sc)
@@ -94,6 +180,12 @@ xchk_setup_metapath(
 		if (sc->sm->sm_agno)
 			return -EINVAL;
 		return 0;
+	case XFS_SCRUB_METAPATH_RTDIR:
+		return xchk_setup_metapath_rtdir(sc);
+	case XFS_SCRUB_METAPATH_RTBITMAP:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_BITMAP);
+	case XFS_SCRUB_METAPATH_RTSUMMARY:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_SUMMARY);
 	default:
 		return -ENOENT;
 	}

