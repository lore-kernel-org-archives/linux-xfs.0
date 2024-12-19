Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E8A1AA790
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636283; cv=none; b=EfAkU+dLXBxd5iNPomKIkACauDI5d+kp13+uxFmi7sEh1WRhefB9niLtjMdEw0yjCkDTA2P4cbeVtabHuISanjP9v/+ve1dlObRthSX2c7iuW5+OAiSRpodkF9KRtrgwIABCXL9NiiIYQqrmtRWJ41SCIiWQsPuvka+NyZ+FjVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636283; c=relaxed/simple;
	bh=ly3rw/jQOeqCoO8zlJ0yiWDyoU4GCJL5Jz9L2AvNG34=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=On8dTyUaBORi/5025FMfMTcrg70PeTYSrecjFvyqClngWonmz3+NK8FguVY4/7hXYXWwpBuY+PgRg4szosg9Y1rd8S275JAVGuPRYCVM8LbZUtuKIe5HduRZi1ovEooePs4t9q2rhMh0Mwhc3nnJi46MpC3ujUZVM5rSQvsPOMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rp28gl7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rp28gl7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03A3C4CECE;
	Thu, 19 Dec 2024 19:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636282;
	bh=ly3rw/jQOeqCoO8zlJ0yiWDyoU4GCJL5Jz9L2AvNG34=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rp28gl7nUbyLsykfGvhf1OzEuOZfs7f+1vWjAvJJFsqmNqvNR6V+sSV4mFIgDfXU/
	 xDA8gyj7p+duU4yR3b8v/PzCiIgoMcSIyUjAYpJ3ZVsYAXujK+ggVGDUNF4NOnH2W6
	 nSqEYVxka0RPL3aeJyRf+6gneIQgPIVS2bAgaAbad8xA1ycHx5gqvqH+yn+FtCxXEX
	 sgU89kM9O7h+DFPJgFwyyONkf3rDP/XoL1Ecm7GNC0S+o/PkYqEhWX9j40IwibGP9P
	 AKro/5bL4iTL7MoDEo6cXSqek48qZkmDXCzCfpY/voFKZyEOrLWZgu5uh3hkrefYo6
	 zZgn8MDbDBASg==
Date: Thu, 19 Dec 2024 11:24:42 -0800
Subject: [PATCH 05/37] xfs: realtime rmap btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463579839.1571512.8627084048399912783.stgit@frogsfrogsfrogs>
In-Reply-To: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
References: <173463579653.1571512.7862891421559358642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrmapbt to add the record and a second
split in the regular rmapbt to record the rtrmapbt split.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_exchmaps.c    |    4 +++-
 fs/xfs/libxfs/xfs_trans_resv.c  |   12 ++++++++++--
 fs/xfs/libxfs/xfs_trans_space.h |   13 +++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 2021396651de27..3f1d6a98c11819 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -662,7 +662,9 @@ xfs_exchmaps_rmapbt_blocks(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 	if (XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
+		return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) *
+			XFS_RTRMAPADD_SPACE_RES(mp);
 
 	return howmany_64(req->nr_exchanges,
 					XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) *
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index bab402340b5da8..f3392eb2d7f41f 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -213,7 +213,9 @@ xfs_calc_inode_chunk_res(
  * Per-extent log reservation for the btree changes involved in freeing or
  * allocating a realtime extent.  We have to be able to log as many rtbitmap
  * blocks as needed to mark inuse XFS_BMBT_MAX_EXTLEN blocks' worth of realtime
- * extents, as well as the realtime summary block.
+ * extents, as well as the realtime summary block (t1).  Realtime rmap btree
+ * operations happen in a second transaction, so factor in a couple of rtrmapbt
+ * splits (t2).
  */
 static unsigned int
 xfs_rtalloc_block_count(
@@ -222,10 +224,16 @@ xfs_rtalloc_block_count(
 {
 	unsigned int		rtbmp_blocks;
 	xfs_rtxlen_t		rtxlen;
+	unsigned int		t1, t2 = 0;
 
 	rtxlen = xfs_extlen_to_rtxlen(mp, XFS_MAX_BMBT_EXTLEN);
 	rtbmp_blocks = xfs_rtbitmap_blockcount_len(mp, rtxlen);
-	return (rtbmp_blocks + 1) * num_ops;
+	t1 = (rtbmp_blocks + 1) * num_ops;
+
+	if (xfs_has_rmapbt(mp))
+		t2 = num_ops * (2 * mp->m_rtrmap_maxlevels - 1);
+
+	return max(t1, t2);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 1155ff2d37e29f..d89b570aafcc64 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -14,6 +14,19 @@
 #define XFS_MAX_CONTIG_BMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_bmap_dmxr[0]) - ((mp)->m_bmap_dmnr[0]))
 
+/* Worst case number of realtime rmaps that can be held in a block. */
+#define XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)    \
+		(((mp)->m_rtrmap_mxr[0]) - ((mp)->m_rtrmap_mnr[0]))
+
+/* Adding one realtime rmap could split every level to the top of the tree. */
+#define XFS_RTRMAPADD_SPACE_RES(mp) ((mp)->m_rtrmap_maxlevels)
+
+/* Blocks we might need to add "b" realtime rmaps to a tree. */
+#define XFS_NRTRMAPADD_SPACE_RES(mp, b) \
+	((((b) + XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp) - 1) / \
+	  XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) * \
+	  XFS_RTRMAPADD_SPACE_RES(mp))
+
 /* Worst case number of rmaps that can be held in a block. */
 #define XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)    \
 		(((mp)->m_rmap_mxr[0]) - ((mp)->m_rmap_mnr[0]))

