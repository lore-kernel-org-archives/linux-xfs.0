Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BF62837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995444; cv=none; b=ngCZ4pOsUbDGyWf84q+pLyDzAAIUPYdh2r9NzufzlkzPDMZcd8qiIvZTizcFo1sjUxsd9THKBfd3pHD8g0MjNGnQZmLRfMDCvXGFDlSK+VjJdY67PlwWNcMktx8jmUcYdd4VkzDmIAb/BjG49nvpV4npuAx1sSSv4jeGXLULENI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995444; c=relaxed/simple;
	bh=j3L7bNVfaibxGwxiQptH4URVWyjRf1XmhjokwOyM8Ow=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pY/7yH/QsiddLYN67HHJcnpAmo2llpWc1IyNUTINhOAho+TGA8bKJwB+7lc8OfAzILAtq8kNwAtHTjg7o6A74KdCAaSD7tu+2ktsn1hDx1hMXs1TyVHubsLQMC3fOTvBvOo9bz6JvcYcYpQKc8hV6FHu2BHjVntzkKtxN0RZUzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMN8+Aht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMN8+Aht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01EBC4CED3;
	Mon, 23 Dec 2024 23:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995443;
	bh=j3L7bNVfaibxGwxiQptH4URVWyjRf1XmhjokwOyM8Ow=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WMN8+AhtH1DW4E3uTv92Q/VvZLokXRC58xpG6xyTsdJ4kmXTH5G98OFCBSWNYGA0x
	 k/wniI69p/RcrzqYCTEu9MhpgNOUhWHBsevNuEdsKjx4PbWvO/qCg9NNJbG7VU2//p
	 OILSgbeWkNzypJAvN6qV9dY69w1p5Dkn7+8UCSqn0W/m28k93mTR7vAF/Ir1HQ09vm
	 T7ZrvTPP8AZjq9U1j8x3I3i/uMcxpN4Jf9lVV7e8x4WvTg/85ys90lzUMLJsbZ/9lW
	 bowdoTchhsz2/In4zL9pzU39Txy7TXu7krYVDA/EnCXK288e3ZiX/+JMAKf5LNp1t+
	 WcWK27OE2QUEg==
Date: Mon, 23 Dec 2024 15:10:43 -0800
Subject: [PATCH 17/43] xfs: compute rtrmap btree max levels when reflink
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499420231.2381378.6054792734002389517.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Compute the maximum possible height of the realtime rmap btree when
reflink is enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index b90901e39e92ce..e4ec36943cb7cb 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -718,6 +718,7 @@ xfs_rtrmapbt_maxrecs(
 unsigned int
 xfs_rtrmapbt_maxlevels_ondisk(void)
 {
+	unsigned long long	max_dblocks;
 	unsigned int		minrecs[2];
 	unsigned int		blocklen;
 
@@ -726,8 +727,20 @@ xfs_rtrmapbt_maxlevels_ondisk(void)
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
@@ -766,9 +779,20 @@ xfs_rtrmapbt_compute_maxlevels(
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
 

