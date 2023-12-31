Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D7CDDC9
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nJfQpP8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B33C433C7;
	Sun, 31 Dec 2023 21:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059622;
	bh=yjMc713lFK8as+VvzfCOMa2Cg1yCuw3PTjb4D8+DjTM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nJfQpP8k1mViKrGPNll11lGHE9snEzPR+etOrzkbZO2PABxghjUJ2/QxjKPsZLLQv
	 V25+FMBFROg+FUxcYgGs/yqiiO3t+vGsZkZfIw1oCQLUnJYozKJkmeMdHo+HCZQDln
	 hS8SMAn/e2zDtK1Bs8DPHxdCkJKPuE6i/Q3n8EWLz34/HpRdCbi8rZ1iPq9DATF0Lf
	 sWQVa+vE2hJMMxyfGsYYJWyzexmT8/o8DIMLkqnPYrWgs+JCvrgp7gvAAjeUf/V4Ba
	 ieZ/7iTsm51w3eqU8h5qYZ6ymrhS6CCjiOsX2+0utFjoY77J5ll3ABf/b398sPWt0w
	 gN9b33TXdJ1bQ==
Date: Sun, 31 Dec 2023 13:53:41 -0800
Subject: [PATCH 35/44] xfs: scrub the metadir path of rt refcount btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852144.1766284.6583152944581273036.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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
directory tree path to the refcount btree file for each rt group.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 ++-
 fs/xfs/scrub/metapath.c |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7847da61db232..4159e96d01ae6 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -806,9 +806,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_METAPATH_GRPQUOTA	3
 #define XFS_SCRUB_METAPATH_PRJQUOTA	4
 #define XFS_SCRUB_METAPATH_RTRMAPBT	5
+#define XFS_SCRUB_METAPATH_RTREFCBT	6
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		6
+#define XFS_SCRUB_METAPATH_NR		7
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 6afd117c890e9..447bdbea210d2 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -23,6 +23,7 @@
 #include "xfs_attr.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -106,6 +107,7 @@ xchk_setup_metapath(
 
 	switch (sc->sm->sm_ino) {
 	case XFS_SCRUB_METAPATH_RTRMAPBT:
+	case XFS_SCRUB_METAPATH_RTREFCBT:
 		/* empty */
 		break;
 	default:
@@ -157,6 +159,18 @@ xchk_setup_metapath(
 			xfs_rtgroup_put(rtg);
 		}
 		break;
+	case XFS_SCRUB_METAPATH_RTREFCBT:
+		error = xfs_rtrefcountbt_create_path(mp, sc->sm->sm_agno,
+				&path);
+		if (error)
+			return error;
+		mpath->path = path;
+		rtg = xfs_rtgroup_get(mp, sc->sm->sm_agno);
+		if (rtg) {
+			ip = rtg->rtg_refcountip;
+			xfs_rtgroup_put(rtg);
+		}
+		break;
 	default:
 		return -EINVAL;
 	}

