Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01B51E0DC3
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729192096; cv=none; b=r2zdijWJnYWu6P6AkSzT/bnLGKC0+JUqf7GDBXSpKFe4IGyKWQflV5aVQYlMCFSF7HiI4UyJjOx8vNbGQ2dOI30DOXv5oMHaVVyv17CqSDq0X4lQF58N8M8bl4fz+JxqaHFxT364nztvBrKSNuZJVFjWYgn/RqcOJEysRMGXx1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729192096; c=relaxed/simple;
	bh=DCclybK8wzM0Nc0Qu6mAf43naRWPiYtjjY5Gi+T5GUs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQTeYth0v98bg7viobC9stbKzJtGCtRzHJQqC4QP/vwxh5NdElZ0wYPtH92ca3OPrEIGkMJZ7TSRODiz7v8s+I+uUQxOwb1VrA9lYpJvjDwLmiTqBia3Y+9YEP5Wo7nmKu9G09EAN/m9UI4Nhvl1freNIlyTNqrnBX8byp2+usM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S5loYs3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S5loYs3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE79C4CEC3;
	Thu, 17 Oct 2024 19:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729192095;
	bh=DCclybK8wzM0Nc0Qu6mAf43naRWPiYtjjY5Gi+T5GUs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=S5loYs3xQJ86D+1o5Xmat+/AoobBuZ74EzOiG0DbKjsc0bayaw1MUMdatFbF84cIW
	 rFHQbHwJbot67rQ2oSAAWhzRoPJhA6JWqkKgd4Ho4BB6yGyh2VUt5UQ5iyFRHlNiMb
	 N6ZdqDFPdZ6Tg1OX0ahgDactYysDWvxsaVpaVeawHcogY/L3BDHrAauY4u4wWRjyBK
	 o6UyQTORZ4viAb/X8Bb4Uw4ffee3cPzTaaxjhpwI7pvNQAYqUIiOILjApWROOvKRR9
	 iAWEVzf/KIw98wbYji4D5KTvHggACYoxGfNNsexZkSXZ1RKWpeV6M/7+LD5NZTdJg4
	 hzK6Iuu7MemoA==
Date: Thu, 17 Oct 2024 12:08:15 -0700
Subject: [PATCH 25/34] xfs: scrub metadir paths for rtgroup metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919072100.3453179.3999964281736504018.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
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

