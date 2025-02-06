Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8BC23C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881526; cv=none; b=LoVO74DyLV/Il8vbVQak/+SZIipEPSTm0ykLF+3efXm8B+W+Xe78LVsonqaRoWSJi/bh8NKcfEjAMrQw0yQaerQo+UMsOK7RxGg8PZp0vI1RrHkf/a9gO95tNSfIarY4lYFp8e6EvHfP8IA7k/wPBsPFgOFNz8DrIIOUjD4jKB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881526; c=relaxed/simple;
	bh=FEuHw4y5nGyEPCw836uxX63snVBaLWhAupxV/5b0Q1M=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GGBhQo6GEkZ4r5M9igS31XoeQs/7VNgAREuMc3kNel72bFh2yLs2xQzZ7tbrNHb6uLtkkWHEC6HAiR5kJ0u44N8/hKasZJjxQ3jJFMF0ypk5tNfVUY+nfEocckJQWHHgW7vhpCqfuYDrz/MAMZupjN2uou9SsWF+AOAN550+Yq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bv1KHD6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bv1KHD6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D41C4CEDD;
	Thu,  6 Feb 2025 22:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881526;
	bh=FEuHw4y5nGyEPCw836uxX63snVBaLWhAupxV/5b0Q1M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bv1KHD6cUnqAgTdwjh9whn2AESQa/MhdtS4ba8MFSSQZKMUMgswwalv6R+Hk/YB3J
	 BYwRbhV5/LPUfNDbxX3LBfXv31dNLL8HzrqgQHA6VTcnPncqzU509bbNbHGllG4Rql
	 V8o5//4nFy3baZWPFj1rVGFnzvkVegYNuqSxCFf981Kz1gyrA0JZNlXwIZHPuf7ZZS
	 J6SQi8lxogdVEAqV8e1Fp1sZLJ4GgKa7PI2hpGyG/9LynxHzmKYBI7W88tWuqQ4bxn
	 3DDoYXB+BPiKaRSbzP2aRkgEFxpWXcOHfmyGhBPMK1AZ+P7JWyijXH0LzoAwVhIjJ3
	 FdoS72zNrNk3A==
Date: Thu, 06 Feb 2025 14:38:45 -0800
Subject: [PATCH 14/56] xfs: realtime rmap btree transaction reservations
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888087006.2739176.18354736412984864547.stgit@frogsfrogsfrogs>
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

Source kernel commit: e1c76fce50bb750dff236aa51a3b698de4f7132c

Make sure that there's enough log reservation to handle mapping
and unmapping realtime extents.  We have to reserve enough space
to handle a split in the rtrmapbt to add the record and a second
split in the regular rmapbt to record the rtrmapbt split.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_exchmaps.c    |    4 +++-
 libxfs/xfs_trans_resv.c  |   12 ++++++++++--
 libxfs/xfs_trans_space.h |   13 +++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)


diff --git a/libxfs/xfs_exchmaps.c b/libxfs/xfs_exchmaps.c
index 08bfe6f1b3422d..2d7513549429b4 100644
--- a/libxfs/xfs_exchmaps.c
+++ b/libxfs/xfs_exchmaps.c
@@ -659,7 +659,9 @@ xfs_exchmaps_rmapbt_blocks(
 	if (!xfs_has_rmapbt(mp))
 		return 0;
 	if (XFS_IS_REALTIME_INODE(req->ip1))
-		return 0;
+		return howmany_64(req->nr_exchanges,
+					XFS_MAX_CONTIG_RTRMAPS_PER_BLOCK(mp)) *
+			XFS_RTRMAPADD_SPACE_RES(mp);
 
 	return howmany_64(req->nr_exchanges,
 					XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp)) *
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 93047e149693d6..cdfac7a12906c2 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -210,7 +210,9 @@ xfs_calc_inode_chunk_res(
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
@@ -219,10 +221,16 @@ xfs_rtalloc_block_count(
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
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 1155ff2d37e29f..d89b570aafcc64 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
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

