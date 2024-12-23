Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC221D6DC8
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994803; cv=none; b=brlEbEC2/+dclVOtt4SH9M5zf48Kk4kDY4s1w/HOLKbKSD2+u5b4hgHDcKlwmVsDJSexB6K2DWlgj3Ry7Ul4fBCh2FxpL4Lb8dmENBAX4GbJ9YIC0azI2ouxG+A8MWnRj2DtwzjTX4FUZ7lHoIfBS10e+UFZ5aMu7efab0ox+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994803; c=relaxed/simple;
	bh=GA6eUfKGETYgcLkcJqHdqaYPIFL8nmVj8JVg10+SWX4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHsDNSKilV49NXk3jlxCPKUwjzK1Hps3g3b++LpUUbnrwr1FSPR517eUcheeZ+Lfl1zLEv4nr2wkNY6Q2aq/LcB3WBBsXtB67DHcaXc1tgy6cqN38GDxBCWC0HHZlFXV/888N5tnT+xkc5iXIgI/pn4z0H6E84xf/iTVUnCh1Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CtUAwl/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CtUAwl/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7222C4CED3;
	Mon, 23 Dec 2024 23:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994802;
	bh=GA6eUfKGETYgcLkcJqHdqaYPIFL8nmVj8JVg10+SWX4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CtUAwl/UXPhx6Og7pJQ5ndcgrQ32hg+GztrL6nAOtEru+t9k9Gzyih5/kUCsmr4OO
	 ma3MFsK0emOxi+oW1Y4lIR6Of9Qp0d7bOIDcQ/gtEOKE+lGwmxn/q/jEoB7nkScreZ
	 /jsVONgzyULTKe5zMqa4vEWUzE+L1hEWJMcs0qPvkLPaCvv2GoGwKzKEME3Igzg6Ez
	 QPjLvEfBezONAminxWf7WsoiWZUmLcJpP68ItaxagZ7H6+Z85/OAO+Wnc/5ucVc6AA
	 vGSjcgnw/Q2303sEgJ2BjbIqlUvCZ4MRQ62qamFOu4ebJjdDR8exLE0/juIYNmcvK6
	 XywigUeWoJG1w==
Date: Mon, 23 Dec 2024 15:00:02 -0800
Subject: [PATCH 13/37] xfs: add metadata reservations for realtime rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499418940.2380130.15926410356787015031.stgit@frogsfrogsfrogs>
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
index 22aabf326b2ccd..066deadcaac95b 100644
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
+	/* Reserve 1% of the rtgroup or enough for 1 block per record. */
+	return max_t(xfs_filblks_t, blocks / 100,
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

