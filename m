Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD33226541
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881903; cv=none; b=BZaLfJB6x0GuAszxAsCv44KTm0CsLYkJz8ZkA0XCN/0Pt27pF01ZQ1ET6Fh5rO6/PEkr3zGBFJN8fwu4sym48OvnyyitLrI9LXDkfozVRRunybXCuNbKpkI7WFkNe4luJs31ULQfVdGANNbdYslrkL75H0RF7cw9mGvyStNUYOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881903; c=relaxed/simple;
	bh=miHVP3RZTHmoX7B+GvGaG5HmrXgXbD4uZclvG1YDAq4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxAnSlsI7+ZVCoMkrY6Or/Mu/l5PpjzeqX2vGicwzJz1ekcNHrrESxdVk20UlH2qIz5GpGHTqqaRQAqKfpalAVeCxy6g8ahctmhTXNn10jXxQicJFooU3tiOypgXV+mVXYUxn671PXdRCKMXyhMlEKsRsMAXpariYWEVukcZ+ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZkzJsRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZkzJsRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAD4C4CEDD;
	Thu,  6 Feb 2025 22:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881903;
	bh=miHVP3RZTHmoX7B+GvGaG5HmrXgXbD4uZclvG1YDAq4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sZkzJsRlyIHPqTQynuRiROtZu+xm9SrjruduOfetSboMtPg2kVMvC6pamaZNMu/uS
	 lCTs/R/Wtl/iaqIC6P+ZT4OPkKQqpvJX028JGhQjR2XxcmRU6OGyyAZemUcehmggEn
	 Djl7X3AeLWOmzmFEAxko+17S/9Rr50y8u/Zc0Zf3jMQzyrGw+P7Mm5KfyVwkLyVV/5
	 GSGmuEuNWtMOjKzBsi7/LjcGLBRRAK2akuXzoCknkZMR/te7OdZlbyx97OBtx+uFhI
	 zuwE/qSR1QFkmYoioJQZBMXyAASEE9FLltQVtZBOwtMyEwTi5iWFou39ZD1tuIkmh1
	 cxRYGgYbYsJmA==
Date: Thu, 06 Feb 2025 14:45:02 -0800
Subject: [PATCH 38/56] xfs: add metadata reservations for realtime refcount
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087374.2739176.11651391688203232421.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: bf0b99411335db18a9ed4fcef278ce9e313f6076

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime refcount btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtrefcount_btree.c |   38 ++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrefcount_btree.h |    4 ++++
 2 files changed, 42 insertions(+)


diff --git a/libxfs/xfs_rtrefcount_btree.c b/libxfs/xfs_rtrefcount_btree.c
index 46c62bd63458f4..9fa8f1d6eb6749 100644
--- a/libxfs/xfs_rtrefcount_btree.c
+++ b/libxfs/xfs_rtrefcount_btree.c
@@ -417,3 +417,41 @@ xfs_rtrefcountbt_compute_maxlevels(
 	/* Add one level to handle the inode root level. */
 	mp->m_rtrefc_maxlevels = min(d_maxlevels, r_maxlevels) + 1;
 }
+
+/* Calculate the rtrefcount btree size for some records. */
+unsigned long long
+xfs_rtrefcountbt_calc_size(
+	struct xfs_mount	*mp,
+	unsigned long long	len)
+{
+	return xfs_btree_calc_size(mp->m_rtrefc_mnr, len);
+}
+
+/*
+ * Calculate the maximum refcount btree size.
+ */
+static unsigned long long
+xfs_rtrefcountbt_max_size(
+	struct xfs_mount	*mp,
+	xfs_rtblock_t		rtblocks)
+{
+	/* Bail out if we're uninitialized, which can happen in mkfs. */
+	if (mp->m_rtrefc_mxr[0] == 0)
+		return 0;
+
+	return xfs_rtrefcountbt_calc_size(mp, rtblocks);
+}
+
+/*
+ * Figure out how many blocks to reserve and how many are used by this btree.
+ * We need enough space to hold one record for every rt extent in the rtgroup.
+ */
+xfs_filblks_t
+xfs_rtrefcountbt_calc_reserves(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtreflink(mp))
+		return 0;
+
+	return xfs_rtrefcountbt_max_size(mp, mp->m_sb.sb_rgextents);
+}
diff --git a/libxfs/xfs_rtrefcount_btree.h b/libxfs/xfs_rtrefcount_btree.h
index b713b33818800c..3cd44590c9304c 100644
--- a/libxfs/xfs_rtrefcount_btree.h
+++ b/libxfs/xfs_rtrefcount_btree.h
@@ -67,4 +67,8 @@ unsigned int xfs_rtrefcountbt_maxlevels_ondisk(void);
 int __init xfs_rtrefcountbt_init_cur_cache(void);
 void xfs_rtrefcountbt_destroy_cur_cache(void);
 
+xfs_filblks_t xfs_rtrefcountbt_calc_reserves(struct xfs_mount *mp);
+unsigned long long xfs_rtrefcountbt_calc_size(struct xfs_mount *mp,
+		unsigned long long len);
+
 #endif	/* __XFS_RTREFCOUNT_BTREE_H__ */

