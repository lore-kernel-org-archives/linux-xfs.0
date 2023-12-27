Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A27384
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uj/X7Cdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E42C433C7;
	Mon,  1 Jan 2024 00:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068988;
	bh=xOlyN2BErffcrtIpDWlrsNEmM243k2d6OnmeVBpr8cU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Uj/X7Cdl7FL1eGZvd6D0Rq86h14W/0poRP/ss9Yi9j13zKqAPdCld92JlHWbZJ+9/
	 mIUPsJEF/B5yfTwgB6dgEm/7TFvuojpQXoWvm7VXbt2xb/PQSUPkrVA4ivMPO/SFL7
	 a7PH9R8RAh1A0CPpX/CNd/m39ZSr8CWhs8aq1uWfT8XXSj8C6xfCeJrQUmWW84tami
	 xi5sFSpxkEqFZCGDCYeb3SUSKDB+ad1U+uBvR8UdJQKkrKHvra+M8yKClcaPCv1HJs
	 0aczKOULqmkR5Q0/geYRe1hn9poGuwR28t5HByN8w85LG5uJbXAQvFlorHljXbDzlV
	 m+mR1sguH5VXQ==
Date: Sun, 31 Dec 2023 16:29:47 +9900
Subject: [PATCH 14/42] xfs: compute rtrmap btree max levels when reflink
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017313.1817107.1104272035732046289.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_rtrmap_btree.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index b5adfe362a7..b339526a77d 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -736,6 +736,7 @@ xfs_rtrmapbt_maxrecs(
 unsigned int
 xfs_rtrmapbt_maxlevels_ondisk(void)
 {
+	unsigned long long	max_dblocks;
 	unsigned int		minrecs[2];
 	unsigned int		blocklen;
 
@@ -744,8 +745,20 @@ xfs_rtrmapbt_maxlevels_ondisk(void)
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
@@ -784,9 +797,20 @@ xfs_rtrmapbt_compute_maxlevels(
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
 

