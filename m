Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ECD54BC8
	for <linux-xfs@vger.kernel.org>; Mon, 26 Feb 2024 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708941906; cv=none; b=bI+yTmqXVY37QNGshL8G/O5qu1FztU//6Q6Afpzo2Wx28Mq5BVY+uHz2Pd1Loq4WXFDVnJ/TPt9XXRIdKxMSx3PZKFE4N6dQQ51rdKFLJs7g34popX1lzM1+IAuEiJOzsvknYJI6cZq7X1l7ECiVJMJzSwuzxHKDinhjOrCDUP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708941906; c=relaxed/simple;
	bh=cY0udRVwK1Wb4oQfbikjceDk9Z3Av2UEClcit05/eyM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Q1lNDFx0VFsO6ceXw3RE112meGL2pCTLB29flM846NEXYo78ngA9NRSQrEzugympCnaDaKMyGtD10maNPJRRDFScZEWUCAWr+m1pBS/fl3vwlhoh04aL58bvjPktRS3dQ8/34yU980dBQ4SYvZbbB9yMx28WNXAfLSEve2JGZ50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AjGBBDpW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AjGBBDpW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VqPfG349LK4m9SvK8O3naY4cvznh1bnfYeq08bNFzOE=; b=AjGBBDpWHC9nCrf9bwxNvBjzHM
	IkR2QGTZLOlEUFEaXtbVRaKZGnO7E+nJsiGtTENg9Hu8lq4vDxLDb5LQaWEqLtwJoQ2ELvPvNgfjg
	4koJG7E+kGe4FfZ8sfWjONZlDhAekFbbG7Krd+wVcwlnzP5/mUVbyBExaFzXhWlBqRQBv6OdCOX6L
	VEUpKVOYUghxYrqUVg0szKj8Poqm/tRkukQ+mDnrVALBItbWPAKpiYNOQrGdpeZzoMms/p6ACCTun
	2+eTwROViMpRbRDj+rm+0ZlfbH7V3wlGQBzaW3JEVg/sVNGiSgu4fqtHtIuetNBQwJ8xl/QVkZpZs
	sTW46mww==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reXr5-0000000HX5F-39EY;
	Mon, 26 Feb 2024 10:05:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/10] xfs: look at m_frextents in xfs_iomap_prealloc_size for RT allocations
Date: Mon, 26 Feb 2024 11:04:18 +0100
Message-Id: <20240226100420.280408-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226100420.280408-1-hch@lst.de>
References: <20240226100420.280408-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a check for files on the RT subvolume and use m_frextents instead
of m_fdblocks to adjust the preallocation size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 055cdec2e9ad64..a8267d8ef1c0ed 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -27,6 +27,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_rtbitmap.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -398,6 +399,29 @@ xfs_quota_calc_throttle(
 	}
 }
 
+static int64_t
+xfs_iomap_freesp(
+	struct percpu_counter	*counter,
+	uint64_t		low_space[XFS_LOWSP_MAX],
+	int			*shift)
+{
+	int64_t			freesp;
+
+	freesp = percpu_counter_read_positive(counter);
+	if (freesp < low_space[XFS_LOWSP_5_PCNT]) {
+		*shift = 2;
+		if (freesp < low_space[XFS_LOWSP_4_PCNT])
+			(*shift)++;
+		if (freesp < low_space[XFS_LOWSP_3_PCNT])
+			(*shift)++;
+		if (freesp < low_space[XFS_LOWSP_2_PCNT])
+			(*shift)++;
+		if (freesp < low_space[XFS_LOWSP_1_PCNT])
+			(*shift)++;
+	}
+	return freesp;
+}
+
 /*
  * If we don't have a user specified preallocation size, dynamically increase
  * the preallocation size as the size of the file grows.  Cap the maximum size
@@ -480,18 +504,12 @@ xfs_iomap_prealloc_size(
 	alloc_blocks = XFS_FILEOFF_MIN(roundup_pow_of_two(XFS_MAX_BMBT_EXTLEN),
 				       alloc_blocks);
 
-	freesp = percpu_counter_read_positive(&mp->m_fdblocks);
-	if (freesp < mp->m_low_space[XFS_LOWSP_5_PCNT]) {
-		shift = 2;
-		if (freesp < mp->m_low_space[XFS_LOWSP_4_PCNT])
-			shift++;
-		if (freesp < mp->m_low_space[XFS_LOWSP_3_PCNT])
-			shift++;
-		if (freesp < mp->m_low_space[XFS_LOWSP_2_PCNT])
-			shift++;
-		if (freesp < mp->m_low_space[XFS_LOWSP_1_PCNT])
-			shift++;
-	}
+	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
+		freesp = xfs_rtx_to_rtb(mp, xfs_iomap_freesp(&mp->m_frextents,
+				mp->m_low_rtexts, &shift));
+	else
+		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
+				&shift);
 
 	/*
 	 * Check each quota to cap the prealloc size, provide a shift value to
-- 
2.39.2

