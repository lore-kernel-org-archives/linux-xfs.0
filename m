Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385001990BA
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637314; cv=none; b=WY+nPWbdjIgs5Lz57VPVcdSgKCO+oJu1UklvMaT7e5pziSnrrmydNA3r/axfCZaReALWAT0/XUKkvPfz3/JUXJRL0+omZ0gEqEeP9oPIgdCOhur9uRgxLKqIDND1PUDx1l8t1mDvozp8nnZ54BXOKhYS3CvMP0EYDZ9g3ax+1YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637314; c=relaxed/simple;
	bh=YfET5qqKv8cthm8Hyiw3a6tY5ZS8Y4Bkk3pZuWIwf80=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOmGu0MwtpQUa2ouie87nbSftD7/hCyKAaBFB/i2Mmc3U2Wr7WtlE1HdB6FWu/pceTJPvtH6/9uYgX3GQO8bFRyN54QZ0JnVK+8Y++eBGv24f0ZImdAH2Y0qnIBxLO6p6yZjy+lar2LUDSoNAFyhDCedpjVsl50MCY6qBoaap6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VS3l+1Ov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VS3l+1Ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100BFC4CECE;
	Thu, 19 Dec 2024 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637314;
	bh=YfET5qqKv8cthm8Hyiw3a6tY5ZS8Y4Bkk3pZuWIwf80=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VS3l+1OvEk1Xt8Pn8/T5vnDg0peYUrji1hQsJMNTwZ6fHIp1hPQWWwfq1vnP8a6sk
	 nRwGg237w3S/Nv8JKHbaHPGw2X5RezS5/AgMYsI7JPu6vrKM4wp5qCAE+xpQBnkZRF
	 5czB/XoiuJPKfxOnW8oWbiwrSDyUMVfeREKNtjJW8lAoFQZHx76Bz0CdzqVCmyVTfu
	 vAj14AgODEQFYEQdda2WrRwlTPM/YcBBd7S/PxYf3U0JHHrBnjVp1iHABDE1nofdvY
	 xuSNqdQnb+tXJvau1aqAQIKcfiAKaH2Nw3funEBFzmxvyslW9bUnIfu8zuqxZCIKzu
	 NzzBAE2XPlOMA==
Date: Thu, 19 Dec 2024 11:41:53 -0800
Subject: [PATCH 34/43] xfs: scrub the metadir path of rt refcount btree files
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581560.1572761.417473933224932628.stgit@frogsfrogsfrogs>
In-Reply-To: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
References: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_fs.h  |    3 ++-
 fs/xfs/scrub/metapath.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index a4bd6a39c6ba71..2c3171262b445b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -832,9 +832,10 @@ struct xfs_scrub_vec_head {
 #define XFS_SCRUB_METAPATH_GRPQUOTA	(6)  /* group quota */
 #define XFS_SCRUB_METAPATH_PRJQUOTA	(7)  /* project quota */
 #define XFS_SCRUB_METAPATH_RTRMAPBT	(8)  /* realtime reverse mapping */
+#define XFS_SCRUB_METAPATH_RTREFCOUNTBT	(9)  /* realtime refcount */
 
 /* Number of metapath sm_ino values */
-#define XFS_SCRUB_METAPATH_NR		(9)
+#define XFS_SCRUB_METAPATH_NR		(10)
 
 /*
  * ioctl limits
diff --git a/fs/xfs/scrub/metapath.c b/fs/xfs/scrub/metapath.c
index 74d71373e7edf1..e21c16fbd15d90 100644
--- a/fs/xfs/scrub/metapath.c
+++ b/fs/xfs/scrub/metapath.c
@@ -22,6 +22,7 @@
 #include "xfs_attr.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rtrmap_btree.h"
+#include "xfs_rtrefcount_btree.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -249,6 +250,8 @@ xchk_setup_metapath(
 		return xchk_setup_metapath_dqinode(sc, XFS_DQTYPE_PROJ);
 	case XFS_SCRUB_METAPATH_RTRMAPBT:
 		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_RMAP);
+	case XFS_SCRUB_METAPATH_RTREFCOUNTBT:
+		return xchk_setup_metapath_rtginode(sc, XFS_RTGI_REFCOUNT);
 	default:
 		return -ENOENT;
 	}

