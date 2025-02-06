Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B350D197A8E
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881981; cv=none; b=ep/17HxA6zPVeymm3PE/Wj4dnyAwPET5SbeYVi/IgtPH75eLevEE6MEt9+CtrNaqe0gwJnI4OK/kr94F8ByDgh0RB/Ps1Ag1ZaN52/FJ6BYzfVblCOs0b6DK85p2WbASLbShnJNXKwOpoFRJnfxGZ8cdqtlxZAwBiglB7x99h/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881981; c=relaxed/simple;
	bh=8uzTiCjyLl6MsuRIv4TCfk7GwZ11fjqFbitqqa7vxq0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=toeVMBEMMZbgLI45uSy+ClN2sFZE6+QkUrDuEuYWtyr32SfFv6hIey9FJgdcqrZ9ekqY1Poe7pkesSXxoB9w9NvptdK6/4Iuqe/egSzvebm/Myt/G/zhgrgamvP7J68BU/5V3ljfm0khCm6gX11hGAS6YlUf18KBEc0fWi4OmzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dt9Zbz5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dt9Zbz5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F67C4CEDD;
	Thu,  6 Feb 2025 22:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881981;
	bh=8uzTiCjyLl6MsuRIv4TCfk7GwZ11fjqFbitqqa7vxq0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dt9Zbz5LciTpI9xM3IrtsJB/I9mezcFJZaRr7JFwDbhap58nnwtuO3j9r0GAXQjMv
	 6UyVls3r2ZxtwWHT/DnVGy6X9oc0YipuE/YJiszD4BKZmMVI1urQM5OOJIoGwzkzyw
	 Xn/MjFNcvEFvYYlV+GWgF2cV+7QiBb7jB7XGZod0U3wqLXkpOr9GXBD4h9VImwggaG
	 KUvI0btfhhBkzagu6FlfG1WK0F0B3EwAmzWdvT6qfh3GP1KCyByqfWk3soHx1JiHDn
	 gscS9xwr3AooAYnEaY6Jf7qAZN24iFNlYArCMo6H5KqUz6TB2/ABb27Ya83EZ/lUra
	 VVFmr+dSj8WjA==
Date: Thu, 06 Feb 2025 14:46:20 -0800
Subject: [PATCH 43/56] xfs: compute rtrmap btree max levels when reflink
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087450.2739176.10623382823035370306.stgit@frogsfrogsfrogs>
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

Source kernel commit: c2694ff678c9b667ab4cb7c0b45d45309c4dd64b

Compute the maximum possible height of the realtime rmap btree when
reflink is enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtrmap_btree.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 10055110b8cf42..d897d140efa753 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -717,6 +717,7 @@ xfs_rtrmapbt_maxrecs(
 unsigned int
 xfs_rtrmapbt_maxlevels_ondisk(void)
 {
+	unsigned long long	max_dblocks;
 	unsigned int		minrecs[2];
 	unsigned int		blocklen;
 
@@ -725,8 +726,20 @@ xfs_rtrmapbt_maxlevels_ondisk(void)
 	minrecs[0] = xfs_rtrmapbt_block_maxrecs(blocklen, true) / 2;
 	minrecs[1] = xfs_rtrmapbt_block_maxrecs(blocklen, false) / 2;
 
-	/* We need at most one record for every block in an rt group. */
-	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_RGBLOCKS);
+	/*
+	 * Compute the asymptotic maxlevels for an rtrmapbt on any rtreflink fs.
+	 *
+	 * On a reflink filesystem, each block in an rtgroup can have up to
+	 * 2^32 (per the refcount record format) owners, which means that
+	 * theoretically we could face up to 2^64 rmap records.  However, we're
+	 * likely to run out of blocks in the data device long before that
+	 * happens, which means that we must compute the max height based on
+	 * what the btree will look like if it consumes almost all the blocks
+	 * in the data device due to maximal sharing factor.
+	 */
+	max_dblocks = -1U; /* max ag count */
+	max_dblocks *= XFS_MAX_CRC_AG_BLOCKS;
+	return xfs_btree_space_to_height(minrecs, max_dblocks);
 }
 
 int __init
@@ -765,9 +778,20 @@ xfs_rtrmapbt_compute_maxlevels(
 	 * maximum height is constrained by the size of the data device and
 	 * the height required to store one rmap record for each block in an
 	 * rt group.
+	 *
+	 * On a reflink filesystem, each rt block can have up to 2^32 (per the
+	 * refcount record format) owners, which means that theoretically we
+	 * could face up to 2^64 rmap records.  This makes the computation of
+	 * maxlevels based on record count meaningless, so we only consider the
+	 * size of the data device.
 	 */
 	d_maxlevels = xfs_btree_space_to_height(mp->m_rtrmap_mnr,
 				mp->m_sb.sb_dblocks);
+	if (xfs_has_rtreflink(mp)) {
+		mp->m_rtrmap_maxlevels = d_maxlevels + 1;
+		return;
+	}
+
 	r_maxlevels = xfs_btree_compute_maxlevels(mp->m_rtrmap_mnr,
 				mp->m_groups[XG_TYPE_RTG].blocks);
 

