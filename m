Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9FC64A
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991219; cv=none; b=lNiilaOEoLXHm8QbFF1CsedghjZa2jms5YVTyGDzoD52NuVfOkCTaHL1a9F6jDuvlrii8gGrTjF84K5VL6voAjePjypjM/ZVlvY0PDU3fbjz15M2MdPyUWTn/Wn/idgRe2O621po+ZIkl2VgLhOl1EVe0B2pCvDHVhleZgsLpjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991219; c=relaxed/simple;
	bh=JBdssH5IClUZ80jFlJDu34IOjLmephdZnzplWLSP+yg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WD0IkP0lMB1C9mvwFjPekN6xRaUBhzjJqaM+1/OfBnaVyFCa5PHNCq5cetX0Q6frDroqiok9jobLgjL9QZy91w0QM4Zidd/Lj42wD66iMu00BxWuG7j8etgNSKP7BVqb5VGBqJdwULrcxuT5JtqSspEHnMQlTGpiLzk7f52jA40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OBNVUHTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OBNVUHTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEC2C4CED3;
	Mon, 23 Dec 2024 22:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991218;
	bh=JBdssH5IClUZ80jFlJDu34IOjLmephdZnzplWLSP+yg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OBNVUHTZtHXS65ZppLm8SdZmDDHVqYlyO/JJ5fBQAntvuqdk/PTrs0xxZcTr9HFHt
	 c3tpgCV0DklHB6HoRdV/Mqw546cA1LStOvtIgBH7WCEAgnvIaJX9u8QMLmxfxbAq1g
	 65mijLN4EqLxcFJgKlXG1lxvuianTdG4Lv1iSqo+7eUaGaBPBptOBmPMg+KnP67ffO
	 2WfeOnOUBsw/bZFI5rUbzoyV6zNWJksNHZJ7oCIL1buhhbgjRuV0u+aGKodlS+dLZ5
	 jn/zNo0heZgkgt4P7Qi8da+2VtE3hXGBy6dtthq8OzrhVFTYEufObaEQ0a0C3fJkfF
	 nPRTel4iNw7oA==
Date: Mon, 23 Dec 2024 14:00:18 -0800
Subject: [PATCH 08/52] xfs: refactor xfs_rtbitmap_blockcount
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942617.2295836.9838745869385310870.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 5a7566c8d6b9b5c0aac34882f30448d29d9deafc

Rename the existing xfs_rtbitmap_blockcount to
xfs_rtbitmap_blockcount_len and add a new xfs_rtbitmap_blockcount wrapper
around it that takes the number of extents from the mount structure.

This will simplify the move to per-rtgroup bitmaps as those will need to
pass in the number of extents per rtgroup instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_rtbitmap.c   |   12 +++++++++++-
 libxfs/xfs_rtbitmap.h   |    7 ++++---
 libxfs/xfs_trans_resv.c |    2 +-
 3 files changed, 16 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index c686cd5309e87c..cebeef5134e666 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1147,13 +1147,23 @@ xfs_rtalloc_extent_is_free(
  * extents.
  */
 xfs_filblks_t
-xfs_rtbitmap_blockcount(
+xfs_rtbitmap_blockcount_len(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
 	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
 }
 
+/*
+ * Compute the number of rtbitmap blocks used for a given file system.
+ */
+xfs_filblks_t
+xfs_rtbitmap_blockcount(
+	struct xfs_mount	*mp)
+{
+	return xfs_rtbitmap_blockcount_len(mp, mp->m_sb.sb_rextents);
+}
+
 /* Compute the number of rtsummary blocks needed to track the given rt space. */
 xfs_filblks_t
 xfs_rtsummary_blockcount(
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index e4994a3e461d33..58672863053a94 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -307,8 +307,9 @@ int xfs_rtfree_extent(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 int xfs_rtfree_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		xfs_fsblock_t rtbno, xfs_filblks_t rtlen);
 
-xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
-		rtextents);
+xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
+xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
+		xfs_rtbxlen_t rtextents);
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
@@ -336,7 +337,7 @@ static inline int xfs_rtfree_blocks(struct xfs_trans *tp,
 # define xfs_rtbuf_cache_relse(a)			(0)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 static inline xfs_filblks_t
-xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
+xfs_rtbitmap_blockcount_len(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 {
 	/* shut up gcc */
 	return 0;
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 3da18fb4027420..93047e149693d6 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -221,7 +221,7 @@ xfs_rtalloc_block_count(
 	xfs_rtxlen_t		rtxlen;
 
 	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
-	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
+	rtbmp_blocks = xfs_rtbitmap_blockcount_len(mp, rtxlen);
 	return (rtbmp_blocks + 1) * num_ops;
 }
 

