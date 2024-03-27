Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7017C374C6
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 11:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537444; cv=none; b=lxe1Max9XbW4UQEYjf/KB2oxGLpXF3S+1BKDfDFh+8lZF99ddP4cUzztYduRiEQy5IN5FScgOpiCDVAXMtddAYcXc9Lyha2mxwwFV3RhhcHmebG7QsjHTmHfUu18gJt28Nb4Ajn4pvJrr7ymvrBoadNc4yOzGywGQnvHfXH91T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537444; c=relaxed/simple;
	bh=tDDimlK3KcS14Ap4er9L9iP0ow7XzrUDHYjI4OHeeR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rjsM/vbq4Z3jkNOnjy4XAuzPwB5Yz9bfUag03KAdRl9AQsIMdWpmPgJajxRa3yi1gNHebbL4nNcMXlVy/PWPhKL8FoL4WYgcekqvPHRNWLKf/GT+4w4QfHQzMEvvm7pFCN0J+JB3/FyLQscLJ3T7NryuUJTGchYsTL4pwg5+PMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cYJ2nAYy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cYJ2nAYy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QaS8g5QdZcxipFIWuQjNfQfy+LH0uqF5iFeBJ5awSM4=; b=cYJ2nAYy0jw86Wr9uBX/uAr+LG
	7AIYIATWdTK75LeNKiE3bj6wly1SbbftXqUXuSskp8Pf+EfSnuyikBL9MJadgk7aZlS5HiP5q0b94
	dUNT1LOT/3d4dWLeP9dR+4fj2u2aU9cvg/RA8IuZJ4MNsSSw8CPD0LjIcPYzcaVvPSUzPrAicf89B
	q2mgHBGXymmlhzshlHWuyPjVoOFqqwUsQJAf+MrUWRKw229gEUKJfw8Khpb0ggYALDkCJf93dm+rn
	1KznIaFd1z6wtl0TDWOXlT/qIQw+6wtLdxHY1Rw+BwRCPmZmCIThBPmVOIq+IsMPxyRwgD942actJ
	1vJBik/w==;
Received: from [89.144.223.137] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rpR4c-00000008WlE-0zJE;
	Wed, 27 Mar 2024 11:04:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 10/13] xfs: look at m_frextents in xfs_iomap_prealloc_size for RT allocations
Date: Wed, 27 Mar 2024 12:03:15 +0100
Message-Id: <20240327110318.2776850-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240327110318.2776850-1-hch@lst.de>
References: <20240327110318.2776850-1-hch@lst.de>
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
index 4087af7f3c9f3f..e0c205bcf03404 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -28,6 +28,7 @@
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
 #include "xfs_health.h"
+#include "xfs_rtbitmap.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -404,6 +405,29 @@ xfs_quota_calc_throttle(
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
@@ -486,18 +510,12 @@ xfs_iomap_prealloc_size(
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

