Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07BDBE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f2mwfihD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66F8C433C8;
	Sun, 31 Dec 2023 21:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058761;
	bh=S16yVOAcnYwnGXujtaQ2PZx5qhOmCPIQiGs09HbFoZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=f2mwfihDyBBNS3uuWH5Rw1uVJPxlqr1g2Fc0cWWbtf96Ybxx+WoIsHMO3IqGRN7e7
	 jS9/P+hbQ7qN5UkQtKTDwcKCRWQT5u55DvDXmJtD53SSDdv1AvGS+eUiwzXMqkxVfM
	 NvoLsWZ8GVVZKp/LeAgpf3CIn6W585mIFU9J5q546urhhbqUZ33Lz5qOqC1VvEZmPN
	 wGr+aQNIpIWZTPtRgO5TtUNXNic8aA3ny0B7GPeRmyG9utYV1uFuVmCnLGGJrfcwdk
	 bMuM41KOPjLDb7MJOUWly7VK3l0TKOEj4Jqk6ppRMzDr46AV/Jde0BUmzf6a6y0C56
	 0ukBQTW4RqcDg==
Date: Sun, 31 Dec 2023 13:39:21 -0800
Subject: [PATCH 29/39] xfs: scrub the metadir path of rt rmap btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850367.1764998.11204405675323358106.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Add a new XFS_SCRUB_METAPATH subtype so that we can scrub the metadata
directory tree path to the rmap btree file for each rt group.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 ++-
 fs/xfs/scrub/metapath.c |   27 ++++++++++++++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index dcf048aae8c17..0bbdbfb0a8ae7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -804,9 +804,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_METAPATH_USRQUOTA	2
 #define XFS_SCRUB_METAPATH_GRPQUOTA	3
 #define XFS_SCRUB_METAPATH_PRJQUOTA	4
+#define XFS_SCRUB_METAPATH_RTRMAPBT	5
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		5
+#define XFS_SCRUB_METAPATH_NR		6
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 5a669a1a8ad17..6afd117c890e9 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -21,6 +21,8 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_attr.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -93,13 +95,25 @@ xchk_setup_metapath(
 	struct xchk_metapath	*mpath;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_inode	*ip = NULL;
+	struct xfs_rtgroup	*rtg;
+	struct xfs_imeta_path	*path;
 	int			error;
 
 	if (!xfs_has_metadir(mp))
 		return -ENOENT;
-	if (sc->sm->sm_gen || sc->sm->sm_agno)
+	if (sc->sm->sm_gen)
 		return -EINVAL;
 
+	switch (sc->sm->sm_ino) {
+	case XFS_SCRUB_METAPATH_RTRMAPBT:
+		/* empty */
+		break;
+	default:
+		if (sc->sm->sm_agno)
+			return -EINVAL;
+		break;
+	}
+
 	mpath = kzalloc(sizeof(struct xchk_metapath), XCHK_GFP_FLAGS);
 	if (!mpath)
 		return -ENOMEM;
@@ -132,6 +146,17 @@ xchk_setup_metapath(
 		if (XFS_IS_PQUOTA_ON(mp))
 			ip = xfs_quota_inode(mp, XFS_DQTYPE_PROJ);
 		break;
+	case XFS_SCRUB_METAPATH_RTRMAPBT:
+		error = xfs_rtrmapbt_create_path(mp, sc->sm->sm_agno, &path);
+		if (error)
+			return error;
+		mpath->path = path;
+		rtg = xfs_rtgroup_get(mp, sc->sm->sm_agno);
+		if (rtg) {
+			ip = rtg->rtg_rmapip;
+			xfs_rtgroup_put(rtg);
+		}
+		break;
 	default:
 		return -EINVAL;
 	}

