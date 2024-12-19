Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AA31AAE19
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636407; cv=none; b=NNj/vVBA7UDx/ZcIW9sXWJ1X9gLh5DOz4Ixj5BENX/UmmJ0h04pDUJWOQPRX/3dDoeQClouzBx7lKZFT1+ZUot5iRNe9X5GpgajeqY29+XQVssLa2i86trdWIrIgX8t7vICu93xJkFPANavChzoliRfnACGIRL9zqpo3W0FyFIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636407; c=relaxed/simple;
	bh=kXp/yViZV+/bK0sS55Tw5XhDfGf9N0+vhI80MdfuwLY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2adRofIP5KkUcH3CsLUs5p+cAwivq8CuzUb0EWliu937F2qAF0g3lEZyEPlYIWgLycgPe6nzr8kVkubVEv7+W9ST5pziK3UPvwatmiQ//HTrZcjUgy7puOczOhQQQlnoUstVnqmGDP8aY7i5mpezt5Cfk1DF0GzA4uasW2dpsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lw/5inCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lw/5inCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938D0C4CECE;
	Thu, 19 Dec 2024 19:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636407;
	bh=kXp/yViZV+/bK0sS55Tw5XhDfGf9N0+vhI80MdfuwLY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lw/5inCcAj9kk+oQzX16bAxAMmrgTx/2yWjoZoKTD5BSpygphKBBsRMmE++LqHaZN
	 eR/GCgAkxX4Paj0Bw8Ew4SKbPWgGb6fblr76MP0A4d5BBtMIKaQBbj3AP1nW39LB1/
	 jDPXosU8mvePuoIUST5le2PRbVAIurXmCHrj5Ca/EbyjKttK6ErYDJeZJIuYkOtQ/l
	 rLKunGIcRgc614rJDMxF+lKklDnZofR4JgXqY3qUJ96SvZUS521PwKmOkC5lnC+uQ/
	 LCsaIB1C19ihLu0Ds341KjbKZxHLlrc+JYz7BB2KZ9MjHKU+qKotZhzg58xqfsbFW0
	 jzd7qoYxhP/uQ==
Date: Thu, 19 Dec 2024 11:26:47 -0800
Subject: [PATCH 13/37] xfs: add metadata reservations for realtime rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579979.1571512.993288971376759003.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime rmap btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   41 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.h |    2 ++
 fs/xfs/xfs_rtalloc.c             |   23 ++++++++++++++++++++-
 3 files changed, 65 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 22aabf326b2ccd..08c4014a75a42c 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -540,3 +540,44 @@ xfs_rtrmapbt_compute_maxlevels(
 	/* Add one level to handle the inode root level. */
 	mp->m_rtrmap_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
 }
+
+/* Calculate the rtrmap btree size for some records. */
+static unsigned long long
+xfs_rtrmapbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrmap_mnr, len);
+}
+
+/*
+ * Calculate the maximum rmap btree size.
+ */
+static unsigned long long
+xfs_rtrmapbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrmap_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrmapbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ */
+xfs_filblks_t
+xfs_rtrmapbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	uint32_t		blocks = mp->m_groups[XG_TYPE_RTG].blocks;
+
+	if (!xfs_has_rtrmapbt(mp))
+		return 0;
+
+	/* 1/64th (~1.5%) of the space, and enough for 1 record per block. */
+	return max_t(xfs_filblks_t, blocks >> 6,
+			xfs_rtrmapbt_max_size(mp, blocks));
+}
diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.h b/fs/xfs/libxfs/xfs_rtrmap_btree.h
index 7d1a3a49a2d69b..eaa2942297e20c 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -79,4 +79,6 @@ unsigned int xfs_rtrmapbt_maxlevels_ondisk(void);
 int __init xfs_rtrmapbt_init_cur_cache(void);
 void xfs_rtrmapbt_destroy_cur_cache(void);
 
+xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4cd2f32aa70a0a..2245f9ecaa3398 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -22,6 +22,7 @@
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtrmap_btree.h"
 #include "xfs_quota.h"
 #include "xfs_log_priv.h"
 #include "xfs_health.h"
@@ -1498,6 +1499,13 @@ void
 xfs_rt_resv_free(
 	struct xfs_mount	*mp)
 {
+	struct xfs_rtgroup	*rtg = NULL;
+	unsigned int		i;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		for (i = 0; i < XFS_RTGI_MAX; i++)
+			xfs_metafile_resv_free(rtg->rtg_inodes[i]);
+	}
 }
 
 /* Reserve space for rt metadata inodes' space expansion. */
@@ -1505,7 +1513,20 @@ int
 xfs_rt_resv_init(
 	struct xfs_mount	*mp)
 {
-	return 0;
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_filblks_t		ask;
+	int			error = 0;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		int		err2;
+
+		ask = xfs_rtrmapbt_calc_reserves(mp);
+		err2 = xfs_metafile_resv_init(rtg_rmap(rtg), ask);
+		if (err2 && !error)
+			error = err2;
+	}
+
+	return error;
 }
 
 /*

