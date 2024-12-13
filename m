Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB8B8472
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052481; cv=none; b=Diov8u6T7dQImje+qDGEnHzKD2A7MWeDAxjkuX9s3VAzHuFaqZlMIL5r/T0SL8ay7bbyIC6N1Eih9bf9csO8BmkDSyQ4IzLjNN2yo7oW18HWCx4YdhXp+OWMmojuJDoCzyVWDB3EXd6TUv5CP8aEStw89E1sO80Pf0m/FhrNU4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052481; c=relaxed/simple;
	bh=vXJdDWrdMgbWWeUq8ovGxr2ZpE3YpItyBiRXjJPqpTU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DR4b/7YQyWLAVNXFst6zINhiJEgfcYQTUfZzs3KxsTSR0hbEm6qSejp16FPow1hVoOkj6bZU7lyPGRRe8Ak6k6el/4JVG1hWyu0NrbK7f1BIvOBYBambpIHaZv+r8YXoktDfVSV2k580fP8SpCCtlyk/PE2zXzAIcX1jPHc6JJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rsrm7eHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rsrm7eHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3FEC4CECE;
	Fri, 13 Dec 2024 01:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052480;
	bh=vXJdDWrdMgbWWeUq8ovGxr2ZpE3YpItyBiRXjJPqpTU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rsrm7eHaQ+28nmjBWwvOhAhA3cRrSdflIZ6QKo/JZxoMxrl7LWiMTyiCFMO4nm+SS
	 RugtbxDy8hp/QfaDq8mtBa/d/lfCyhmhzfgtADKh/GHPDt2zOlnSpbSR7msd3fdVbE
	 5TMTtth1Ytv6Mm0O6XmPe3TaB/3lz3wti1fIiEC4d4GD0Ab38/gTU2Ue7Kjg9FxyoM
	 Oguxc8I0aK/05HolV9q2EVK2ENGs0xOBybtqbNTzOXFUS6TUVnIt66+/ANqPuAK9u4
	 ytEZZz0YotONhMSTAbqruHrFGQPbhWDkksaDwQ0iNobeYwGa+rDTuxfDwG/A8sj3w2
	 K90hmMynOGUAg==
Date: Thu, 12 Dec 2024 17:14:40 -0800
Subject: [PATCH 17/43] xfs: compute rtrmap btree max levels when reflink
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405124859.1182620.14450652763894339074.stgit@frogsfrogsfrogs>
In-Reply-To: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
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
 

