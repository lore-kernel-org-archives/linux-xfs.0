Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759A11465B7
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 11:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713784861; cv=none; b=Q7a0D5s2kf4Tfu3THv5mZS3ufkr/539xx2CiViArr6FO6hz4oE/qLn4ZQqmCAJXF53Wjj+H0oyEQ+QLW3/mIopcebw526kEVXI5lWLJeNyDixYAivZ05KZ3uZtjkgc6lgwY5gh6bVNvHVzLzZBAulaLgOuPFJMy42GG1jisRseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713784861; c=relaxed/simple;
	bh=GJzZoH7igAoBt9QrLvqv1RiMMeFnnI7F5E25W1Nr1bQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wb+/K7EMAG0zIpbirtKINhTiWaDBme3M4VQ9SY+StpXckcQUlFg2vY/Lu4x9Ap8DctrpU6vQcSsv7TzywwNYR/VPHvhKGHaNGg06evoXP7ZiqTmx8F3XXf1XrOZbuTaSEsedkmRRY61msRupsFcqgmt0h774PJZDF+DZNpivew8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u1KuRUlW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u1KuRUlW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kixIH5PuP4KgDe4C+iL89X3UPo22SipbTfHtshJ1cSM=; b=u1KuRUlWNlVdwPyrA91HjDhYAP
	+kPz01oDBqV8KsPxv9O50/pkJsXiN4DQu8lKk0v7LdSl4P2zjAdYZAf0IJDrImFPCPF41FsM82hSl
	Y7AOcr0YQi0kFQPs0eHioNQRdpZ89ucN8UXlsnToggCL2nNFvw88T9/CjXMGgmDCvjnadD+vgl/PH
	4H6osXVreczSZLfwzxQTsHzawsunayL7UX3TTaidfZDyREZlo0NW0halsaDtnZEe6oNMCbNL/or0V
	uG1dkHglTLhlsbmNLm5owNVjAfzVPBvdbMOFO+HGyW/E6Ll0kAGNIScEayWaSHbV2LY1dKXCTNcky
	X9PvCxtA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ryrjH-0000000DLMX-22Ed;
	Mon, 22 Apr 2024 11:21:00 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 10/13] xfs: look at m_frextents in xfs_iomap_prealloc_size for RT allocations
Date: Mon, 22 Apr 2024 13:20:16 +0200
Message-Id: <20240422112019.212467-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240422112019.212467-1-hch@lst.de>
References: <20240422112019.212467-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iomap.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 4087af7f3c9f3f..bba5a0d87d0386 100644
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
@@ -486,18 +510,13 @@ xfs_iomap_prealloc_size(
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
+		freesp = xfs_rtx_to_rtb(mp,
+			xfs_iomap_freesp(&mp->m_frextents,
+					mp->m_low_rtexts, &shift));
+	else
+		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
+				&shift);
 
 	/*
 	 * Check each quota to cap the prealloc size, provide a shift value to
-- 
2.39.2

