Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191B6BE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YYtcvK8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998A7C433C8;
	Sun, 31 Dec 2023 21:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059340;
	bh=g37AKD5TOaDimrqUdEYXJ49MNbyRZg8ykHpAFqHlW2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YYtcvK8gNVGtUMpmwZJRBRJ5QK7A9bPB5C4Ub/xjQw7ZrnVFZy0V2iKwP9n+I2E7I
	 e8B+10Q8MHJtYn5QliHO8LxhRVSrobC+J2rWDM+/hww/85BWTkvlMle6gZjPWFE9zz
	 53AdurI3Ig6iGboK9RVqAE/XMc4GxbOEMjyoFLhPt1JPShBzb90ltdtu7M5rVGhT7B
	 OPkOY/zO7l+DqYM4TiiWGonnU2ObyMGVXTxkUZ0w0Th5Ap+wAM2Y9DCBjlh71TXfPQ
	 mbfEZMfeFD65EuELzTL3s2MSZbUYzvSQwKO3ictfqCWsT5Oh2NJbh+ISzhMjggy6TD
	 +qRYIJaPx1Wrw==
Date: Sun, 31 Dec 2023 13:49:00 -0800
Subject: [PATCH 17/44] xfs: compute rtrmap btree max levels when reflink
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851857.1766284.10018189499117315739.stgit@frogsfrogsfrogs>
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

Compute the maximum possible height of the realtime rmap btree when
reflink is enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rtrmap_btree.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtrmap_btree.c b/fs/xfs/libxfs/xfs_rtrmap_btree.c
index 3084153af3a43..87ea5e3ca8937 100644
--- a/fs/xfs/libxfs/xfs_rtrmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rtrmap_btree.c
@@ -738,6 +738,7 @@ xfs_rtrmapbt_maxrecs(
 unsigned int
 xfs_rtrmapbt_maxlevels_ondisk(void)
 {
+	unsigned long long	max_dblocks;
 	unsigned int		minrecs[2];
 	unsigned int		blocklen;
 
@@ -746,8 +747,20 @@ xfs_rtrmapbt_maxlevels_ondisk(void)
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
@@ -786,9 +799,20 @@ xfs_rtrmapbt_compute_maxlevels(
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
 				mp->m_sb.sb_rgblocks);
 

