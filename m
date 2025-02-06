Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0124923C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881636; cv=none; b=HAyotKWAb8txfkTLnUtE9FfWNRbqXkO+2EGlgc1UI08DYu3geix4zlbq3WhD0fFQbD/rYDpSTuKP5MQ3Ls+A6QbVTFjlgVEQI3qoHweq83OtvwD2ym/K1P1vRW1EYjjyEBe2p4L+qbZtseaSzAkaViV47CwHLItTCMPkOAom2kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881636; c=relaxed/simple;
	bh=NhrYF2SEhlmAIS1i+RjMcPWqjMwRPrN+57OTUHNj+WM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOcbhC4ymFMPNrd1TiyNbCnwDlGMQuJpiFaq44O9JeZeGuU2T2fJlOAmChoyv6/UBOl+9eYz57s1NhHiBHs3CAL1yMsLhq6bybp0/4t4tlBz9nIAYqUnG7rlOBRR7LHolk3LxznC4RRXikUgPexdrsDhYEc7aAb3gp9cZGIGrWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3c0g2AO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3c0g2AO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71218C4CEDD;
	Thu,  6 Feb 2025 22:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881635;
	bh=NhrYF2SEhlmAIS1i+RjMcPWqjMwRPrN+57OTUHNj+WM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L3c0g2AOkKbVl89evdBnjjCIvi3armvuhlUOrJgH1irsQrHjblMw8I+x2YUgVzn7a
	 cRe97vvc/iwA4xwwID0kb42FhtxievvkNlNj3i+DxnRYdQ/B57cfLlEqb6p4ohbvk4
	 9HBkBO9C9BCJVnpnpO5OiscopLeRYZ0maCDFLsvYBB76OY4MB7PF5GcOWbrcBP3YXL
	 r2vtWITg/bLW26rs7WCAwFdDozGZkCd3Q6sQv/PS8WM3BUTZaFetSknrWiREBKMm9/
	 ia7x8lhnLhzJnNYW/TWXdzAh1Esc2Fasb1H0tITvaaVFQ5abulIXTSL2mN0DiCG6Va
	 OIMrnppRzHrvg==
Date: Thu, 06 Feb 2025 14:40:35 -0800
Subject: [PATCH 21/56] xfs: add metadata reservations for realtime rmap btrees
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087113.2739176.14379016236246212798.stgit@frogsfrogsfrogs>
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

Source kernel commit: 8491a55cfc73ff5c2c637a70ade51d4d08abb90a

Reserve some free blocks so that we will always have enough free blocks
in the data volume to handle expansion of the realtime rmap btree.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtrmap_btree.c |   41 +++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rtrmap_btree.h |    2 ++
 2 files changed, 43 insertions(+)


diff --git a/libxfs/xfs_rtrmap_btree.c b/libxfs/xfs_rtrmap_btree.c
index 4c3b4a302bd778..08d1e75f190854 100644
--- a/libxfs/xfs_rtrmap_btree.c
+++ b/libxfs/xfs_rtrmap_btree.c
@@ -538,3 +538,44 @@ xfs_rtrmapbt_compute_maxlevels(
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
diff --git a/libxfs/xfs_rtrmap_btree.h b/libxfs/xfs_rtrmap_btree.h
index 7d1a3a49a2d69b..eaa2942297e20c 100644
--- a/libxfs/xfs_rtrmap_btree.h
+++ b/libxfs/xfs_rtrmap_btree.h
@@ -79,4 +79,6 @@ unsigned int xfs_rtrmapbt_maxlevels_ondisk(void);
 int __init xfs_rtrmapbt_init_cur_cache(void);
 void xfs_rtrmapbt_destroy_cur_cache(void);
 
+xfs_filblks_t xfs_rtrmapbt_calc_reserves(struct xfs_mount *mp);
+
 #endif /* __XFS_RTRMAP_BTREE_H__ */

