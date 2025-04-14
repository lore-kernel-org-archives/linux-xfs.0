Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67BF2CCC1
	for <linux-xfs@vger.kernel.org>; Mon, 14 Apr 2025 05:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744609000; cv=none; b=o9lBOu5xD0k1QXBMEzlATcTn41WgOBb0DmMyk7S+1aBPauy02hvlSFwCeaNRBafqOmxnDY4JG07g6gKkkAbtmFIV4ty7qv2Eg8VnjA35VH185+P9rQ1haUtI80nLnaH0JtslA0QheqLjnAiWrF/NjBamSsxv2tCanY5Vgd4MhlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744609000; c=relaxed/simple;
	bh=FMnAOuScMSrl1nXMcb9ZIC7EOx5z2kz92bwF0eaGch4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLV7UICHJdPFavHt194Gs7p4AARutigu2LveIr/Wa5ToeCbHL+3hl3elFyaWTdqbvtiCMU6OOB4r9J0KR8Xr6l72V7WuYf5AEmYs43CNl6G37kum338129u5NBqlFU5/eDwwQP33CArQRIPVxM2iTj5IySseflwcHTXqimeYftM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FybN+yOp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FybN+yOp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mUHquEnJEuAaXddqlxGDDgXZ9KRiPvvj7LqtssH/+98=; b=FybN+yOp/JJHD/T4iwDyPR7WK6
	rRNdUBm4scVN2qY7hVFVzujE6u9Fdyt9kHQOjFQwBOKT7cVmhBGOds4YNdZo/aBhMbOIg4RfqGaqJ
	xvwTQbfeBfk3pRYMwMq8ln4210lF1aDIuAy819kapLqsar2OS1dGFD/34yrIxIN+UrxLpXI6/qgA3
	ThUUXqneXWbn8SlFNPWi6fFHIZXwhLio/m/hMioW8skCOVy70ZteryEbzac1VgSjZxgKpmUIKxjW0
	pvoMTIoqEaXNeOVV8GN8ktlT07y5XWtGSUFo1ptW7uvVrZJXY70cjW47ANgLpGRuyzZbjhL5FfQOw
	zvfm+R9w==;
Received: from 2a02-8389-2341-5b80-9d44-dd57-c276-829a.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9d44:dd57:c276:829a] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1u4CUm-00000000i73-3oGo;
	Mon, 14 Apr 2025 05:36:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: "Darrick J . Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 01/43] xfs: generalize the freespace and reserved blocks handling
Date: Mon, 14 Apr 2025 07:35:44 +0200
Message-ID: <20250414053629.360672-2-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250414053629.360672-1-hch@lst.de>
References: <20250414053629.360672-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Source kernel commit: 712bae96631852c1a1822ee4f57a08ccd843358b

xfs_{add,dec}_freecounter already handles the block and RT extent
percpu counters, but it currently hardcodes the passed in counter.

Add a freecounter abstraction that uses an enum to designate the counter
and add wrappers that hide the actual percpu_counters.  This will allow
expanding the reserved block handling to the RT extent counter in the
next step, and also prepares for adding yet another such counter that
can share the code.  Both these additions will be needed for the zoned
allocator.

Also switch the flooring of the frextents counter to 0 in statfs for the
rthinherit case to a manual min_t call to match the handling of the
fdblocks counter for normal file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ialloc.c   |  2 +-
 libxfs/xfs_metafile.c |  2 +-
 libxfs/xfs_sb.c       |  8 ++++----
 libxfs/xfs_types.h    | 17 +++++++++++++++++
 4 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 63ce76755eb7..b401299ad933 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1922,7 +1922,7 @@ xfs_dialloc(
 	 * that we can immediately allocate, but then we allow allocation on the
 	 * second pass if we fail to find an AG with free inodes in it.
 	 */
-	if (percpu_counter_read_positive(&mp->m_fdblocks) <
+	if (xfs_estimate_freecounter(mp, XC_FREE_BLOCKS) <
 			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
 		ok_alloc = false;
 		low_space = true;
diff --git a/libxfs/xfs_metafile.c b/libxfs/xfs_metafile.c
index 4488e38a8734..7673265510fd 100644
--- a/libxfs/xfs_metafile.c
+++ b/libxfs/xfs_metafile.c
@@ -93,7 +93,7 @@ xfs_metafile_resv_can_cover(
 	 * There aren't enough blocks left in the inode's reservation, but it
 	 * isn't critical unless there also isn't enough free space.
 	 */
-	return __percpu_counter_compare(&ip->i_mount->m_fdblocks,
+	return xfs_compare_freecounter(ip->i_mount, XC_FREE_BLOCKS,
 			rhs - ip->i_delayed_blks, 2048) >= 0;
 }
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 50a43c0328cb..1781ca36b2cc 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1262,8 +1262,7 @@ xfs_log_sb(
 		mp->m_sb.sb_ifree = min_t(uint64_t,
 				percpu_counter_sum_positive(&mp->m_ifree),
 				mp->m_sb.sb_icount);
-		mp->m_sb.sb_fdblocks =
-				percpu_counter_sum_positive(&mp->m_fdblocks);
+		mp->m_sb.sb_fdblocks = xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
 	}
 
 	/*
@@ -1272,9 +1271,10 @@ xfs_log_sb(
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
 	 */
-	if (xfs_has_rtgroups(mp))
+	if (xfs_has_rtgroups(mp)) {
 		mp->m_sb.sb_frextents =
-				percpu_counter_sum_positive(&mp->m_frextents);
+				xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
+	}
 
 	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index ca2401c1facd..76f3c31573ec 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -233,6 +233,23 @@ enum xfs_group_type {
 	{ XG_TYPE_AG,	"ag" }, \
 	{ XG_TYPE_RTG,	"rtg" }
 
+enum xfs_free_counter {
+	/*
+	 * Number of free blocks on the data device.
+	 */
+	XC_FREE_BLOCKS,
+
+	/*
+	 * Number of free RT extents on the RT device.
+	 */
+	XC_FREE_RTEXTENTS,
+	XC_FREE_NR,
+};
+
+#define XFS_FREECOUNTER_STR \
+	{ XC_FREE_BLOCKS,		"blocks" }, \
+	{ XC_FREE_RTEXTENTS,		"rtextents" }
+
 /*
  * Type verifier functions
  */
-- 
2.47.2

