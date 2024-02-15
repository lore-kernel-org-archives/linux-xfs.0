Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B8B12C52D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707998978; cv=none; b=DnVTMekP5+UeY34olyCIz03/7HLu4/XkBcnbRD4sodbT4cfQhUjNixms3A0Bf+aol2BbCwcdvhtgHptLmGsSOHzNpmVenPEdWRoXWgz8fcBO4TACAo56oD8TWlXY25lztslzzIecdyqUbRjH6KpHd0dfkko0aogFbd8x9JvGXGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707998978; c=relaxed/simple;
	bh=Y/yn3sAcjhMIy3/jQ7defAH55IyOPTHBNnj7zVT7jGY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8O34HeJSuV+pcSME/Yfk5olosqVlXBXs+Heq4CcL+dT9Xjk+gXP3hd4s0YgdGKJho0OKKSLoCdLk//0BvRfGY92tHxIb/aed1drYvFb6INoEwo21IUEEHJP1qnqZUPA9MC2VqLniXHlm4mVetj5lT9Xzu7MEel3gA5oNFFgBS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9i0rb50; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9i0rb50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87E1C433C7
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 12:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707998978;
	bh=Y/yn3sAcjhMIy3/jQ7defAH55IyOPTHBNnj7zVT7jGY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=D9i0rb50uByngULnoHD5g1+uyROQ1b4cuW00EGXJ28KaLhgnQMHpBZPKa1Q9XOMtt
	 2XVS1uCP/rGXKIBG4XXGAsf7sMG2DliImva8vtNEcgT/BKzCSy0YU88Mn6+W6flbjM
	 UVGf6RFYZObOQPdsNokMSNsQoG3fkoewQvWEZEBsKH95EUg4LKNY1eZn6v6ebqFiSc
	 mvWhqM78RxythUisFaDeMQriMd+PrFw1jXG+3JC9mMJOzPOkEA0LXnDFGGDYqvUmyr
	 S9Ssf/A+zQbi4vhiKz+J23CFQOa/7JSOZxasaIvwAiwE6hcfZ6oWaeAEla33Erp2XR
	 BHxakNOczeCUQ==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Subject: [PATCH 22/35] xfs: create helpers for rtbitmap block/wordcount computations
Date: Thu, 15 Feb 2024 13:08:34 +0100
Message-ID: <20240215120907.1542854-23-cem@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215120907.1542854-1-cem@kernel.org>
References: <20240215120907.1542854-1-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: d0448fe76ac1a9ccbce574577a4c82246d17eec4

Create helper functions that compute the number of blocks or words
necessary to store the rt bitmap.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_rtbitmap.c   | 27 +++++++++++++++++++++++++++
 libxfs/xfs_rtbitmap.h   | 12 ++++++++++++
 libxfs/xfs_trans_resv.c |  9 +++++----
 3 files changed, 44 insertions(+), 4 deletions(-)

diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 9a8bd93b7..92473d4a5 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -1137,3 +1137,30 @@ xfs_rtalloc_extent_is_free(
 	*is_free = matches;
 	return 0;
 }
+
+/*
+ * Compute the number of rtbitmap blocks needed to track the given number of rt
+ * extents.
+ */
+xfs_filblks_t
+xfs_rtbitmap_blockcount(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtextents)
+{
+	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
+}
+
+/*
+ * Compute the number of rtbitmap words needed to populate every block of a
+ * bitmap that is large enough to track the given number of rt extents.
+ */
+unsigned long long
+xfs_rtbitmap_wordcount(
+	struct xfs_mount	*mp,
+	xfs_rtbxlen_t		rtextents)
+{
+	xfs_filblks_t		blocks;
+
+	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
+	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
+}
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 167ea6a08..618c96468 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -283,6 +283,11 @@ xfs_rtfree_extent(
 /* Same as above, but in units of rt blocks. */
 int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 		xfs_filblks_t rtlen);
+
+xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
+		rtextents);
+unsigned long long xfs_rtbitmap_wordcount(struct xfs_mount *mp,
+		xfs_rtbxlen_t rtextents);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
 # define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
@@ -290,6 +295,13 @@ int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
 # define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+static inline xfs_filblks_t
+xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
+{
+	/* shut up gcc */
+	return 0;
+}
+# define xfs_rtbitmap_wordcount(mp, r)			(0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 53c190b72..82b3d1522 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -217,11 +217,12 @@ xfs_rtalloc_block_count(
 	struct xfs_mount	*mp,
 	unsigned int		num_ops)
 {
-	unsigned int		blksz = XFS_FSB_TO_B(mp, 1);
-	unsigned int		rtbmp_bytes;
+	unsigned int		rtbmp_blocks;
+	xfs_rtxlen_t		rtxlen;
 
-	rtbmp_bytes = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN) / NBBY;
-	return (howmany(rtbmp_bytes, blksz) + 1) * num_ops;
+	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
+	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, rtxlen);
+	return (rtbmp_blocks + 1) * num_ops;
 }
 
 /*
-- 
2.43.0

