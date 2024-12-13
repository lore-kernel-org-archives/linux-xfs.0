Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FB18472
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051839; cv=none; b=ultuVoOqeNnL2kA2KLy/pv6uLwO/fna9D00yoKz77rOs364QxKd/S/xMMl6SuRAuaOBMkvNHrMo8QDQ1hG0T2NmqdBSHjUGBHg15G8CQIvSJ88hgG4+voqLx3T3P4l8IJ6JBJXTG99yLaScECEpRO9oCnpsFgtffqZTzJVQC5rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051839; c=relaxed/simple;
	bh=WVQuGzDDEV//jhR1uAaL3qWlfnoSYPR5jLUqi14YEjk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AdzbjD8jMuaqEE5gjJuDwZV7JuEzHvSB3alhcuyly9CtgaS+D3gjfz6ZVz8/9HqLLi+OawWuyncomvN4DsBFaFanvquTBzPH96s62F6ECfUls1yAdg6ba907W3jWXfitqfykn07LEWNH3RLCVk0j1xlplW8xl54ECzJw5MqUnX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbloeqow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbloeqow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF307C4CECE;
	Fri, 13 Dec 2024 01:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051838;
	bh=WVQuGzDDEV//jhR1uAaL3qWlfnoSYPR5jLUqi14YEjk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cbloeqowIXJ2WEdphdZJ4iu7OwwfyC3AIPgmmAir7IeBrvOK7L51adXSz3/cYZaGl
	 AUXKKqm4msA6/rUaBPlUCT+XDijYKzbVsAtqhCyDBITVvhl3XhJ17Bqkk94ihqgKjy
	 ckqd6XHVQOM+zp3Uf0MrZqcgSIkUvlqPFwD8EET6bwuxeTvUg/ZGd3x2hcUGV6PIx4
	 feumntfVMnxPbIK4iimAk8GWv1xagfVl23+7tw6Oh4O6PDzn3cd5U7u6Xn32nlAUHp
	 ejQsSAQQ9M6p9BT1PYZw315KvoP7L5K163VSDpMhZnQYMzC4o06ZdX6+jmzDjRJvDy
	 v2KAiehnYbzGQ==
Date: Thu, 12 Dec 2024 17:03:58 -0800
Subject: [PATCH 13/37] xfs: add metadata reservations for realtime rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123537.1181370.15688658549010481316.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
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
index 63aabae2e09db1..ad5cb1078bc1a0 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.h
@@ -79,4 +79,6 @@ unsigned int xfs_rtrmapbt_maxlevels_ondisk(void);
 int __init xfs_rtrmapbt_init_cur_cache(void);
 void xfs_rtrmapbt_destroy_cur_cache(void);
 
+xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
+
 #endif	/* __XFS_RTRMAP_BTREE_H__ */
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

