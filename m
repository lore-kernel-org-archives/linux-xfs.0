Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C06D1A08CC
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637048; cv=none; b=SXU+iMSicbzdTWAwWAw10SPOvifOd1GmLD57jtna1/a4XRAdH1T+ABy5B344xX+tVtFp47PDx6NIJri8U4XO5YmmW36qmtaTLZYsvAy54krZqjgLWuN5UHskIfqvJgWI9upFh51bh9YcTDohqc76mwmjP2n+btQXz1Cy6HZfz24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637048; c=relaxed/simple;
	bh=E33NpwMg35NquW8dRlbAcvuMrYYS5rxRlCKt3lzwikg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AnXbg2c415FCN8xEE0yGqQh/9ndbNHq18eqgI1ZfGXYD+T4r8VMKOAjdpWw2hpi0jJCGPlpe+Jn6TlC4NMNionHRjM5uNNjV2LSYHAIOklceYsFT1H+3DhWKBhBc0E2Mug+XRCWxAQdr4osJys+KLQ6PVVDcKfRhTVk0PwDWsrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmBcm/XZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmBcm/XZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49FC2C4CECE;
	Thu, 19 Dec 2024 19:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637048;
	bh=E33NpwMg35NquW8dRlbAcvuMrYYS5rxRlCKt3lzwikg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pmBcm/XZfx2Mcq0TCOABZBkR8rmaEA7XUE8jswKEjqan+BvjNkQIz4mTWf8vr1/2A
	 iKGfPhjcxCZ/e/74XTcj7inLdctg9fsdZ/jCFLZ8fJPS0bYXY0Y5Errhu7kfBRn12F
	 helxBjNToc7qA3mZR7hQqTvrkm/JrQ78d6H4E/Um4EZ21vqr4aHjnFBuubvOytOLup
	 4PQQPlO4g7GxXSnae9vZDNiTHT9i0KnCx1eqTRtuiG5nmw3KJh5O3/bD1LR0+zAGpb
	 lT5WI4DvgZB22TqllxMQwgZmgqDrQYQtMs1ocXY8FjFhh+0yI2I/jmclFcQ9Sl1qO9
	 Ug2ozG9CW46tA==
Date: Thu, 19 Dec 2024 11:37:27 -0800
Subject: [PATCH 17/43] xfs: compute rtrmap btree max levels when reflink
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463581270.1572761.16688976269157812588.stgit@frogsfrogsfrogs>
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

Compute the maximum possible height of the realtime rmap btree when
reflink is enabled.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 3cb8f126b9ce16..04b9c76380adb0 100644
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
 

