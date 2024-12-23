Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957661422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994990; cv=none; b=jA652xLtnyGjpwCQ/EBMy5ZofR6BhsG2aPENPTDLH0RV8wBfzB/5Ye8pppv4uIy8Dl7aiLa7YImIaNUIeeJ3Nix1gX9TRzPVFNyfAknHYjaV2gZSXFPL5He59EndH5V2Tp8pPzwmb2XrDws14l3PHX6YfwtyExF+Y6jyl+Wp1+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994990; c=relaxed/simple;
	bh=LJeeT8vzjOfPK1AQLMoUW6goHcDwk6tBYUGWmd0C5NM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jWLh0wS3yIpY/VErU+dOlEWLLFrnE325/4if82NisU29FxHMoJ1nhi73GdROQIhhwnl770YCZSjG6aRGSAIqY7Ri+2Vo7+IbNpThyABozluXR4wf6zWB3xstmAzhn+frpwg5ioUXenZzBHPLIFQOhkl9KMzyBss9QgKABLsqqp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEKkN5tk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEKkN5tk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1FBC4CED3;
	Mon, 23 Dec 2024 23:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994990;
	bh=LJeeT8vzjOfPK1AQLMoUW6goHcDwk6tBYUGWmd0C5NM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HEKkN5tkY3Mf0wApfrXnF0fnxum/a0zHAAs6SUJT0yVM+vLi0ByWYxpkxk6gCxVh5
	 rEHCTUXtOZAFz2nXf/96fx6l68j63s6pBryJupaT42s+UzVrYaMVmG1TtmWXuAvmSp
	 9izCm9VOa2bsccNbxd+6M5kJ6M6FjQeTqH3lP68GGSSwykmfNUyv9PGbLaX93rs68x
	 jtcApS4I3LUz9PVvLwaCfzwGB5Kxd4mhofWv8bqr+qKg8NugaA41wOlgX4b4XuZmfb
	 meTOPNVPTzle2DcLg/Q1lq9H0+L+hfd3HQwX+/941hMbZS5yPm6IMqn+DXMPas8Yd/
	 Rv2DRb1w+j0WQ==
Date: Mon, 23 Dec 2024 15:03:09 -0800
Subject: [PATCH 25/37] xfs: scrub the metadir path of rt rmap btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419147.2380130.2235252449459437274.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 ++-
 fs/xfs/scrub/metapath.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 34fcbcd0bcd5e3..d42d3a5617e314 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -830,9 +830,10 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_USRQUOTA	(5)  /* user quota */
 #define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
 #define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
+#define XFS_SCRUB_METAPATH_RTRMAPBT	(8)  /* realtime reverse mapping */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(8)
+#define XFS_SCRUB_METAPATH_NR		(9)
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index c678cba1ffc3f7..74d71373e7edf1 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -21,6 +21,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_attr.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -246,6 +247,8 @@ xchk_setup_metapath(
 		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_GROUP);
 	case XFS_SCRUB_METAPATH_PRJQUOTA:
 		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_PROJ);
+	case XFS_SCRUB_METAPATH_RTRMAPBT:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_RMAP);
 	default:
 		return -ENOENT;
 	}

