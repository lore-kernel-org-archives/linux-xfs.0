Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5795156659
	for <linux-xfs@vger.kernel.org>; Mon, 25 Mar 2024 02:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711333487; cv=none; b=Xd2EgbfnW3S34xjZrgFeo7X1QCiuqxbqJsrzsEtiAO7xqDndGZFJQdPzNr5LTA1bJfgpAeS1yJjN25VG4KMQdAmmVWAxbi7i2YEOJrjbqBeo6n1BZXT2ZeSsP6YrYKZnsV/cPwD1gCXD5FelADkf81cPtX/4vetEzjcrxAwl6JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711333487; c=relaxed/simple;
	bh=tDDimlK3KcS14Ap4er9L9iP0ow7XzrUDHYjI4OHeeR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SG/H25oMKi7sZjKZCsku+g2FrIEyGKL9cqbThZKtMbJc/jLAsPQ8K7ertcVTsw3KEW96otLj3cJmIWG1dS7pS5TXM2PPZgHeZmxHU1fjI2rJKruw0jZ8fqSYuAW13HXqBSFk1xDijofY3UlYmhgLnm01A+VnUDcyrrBwPk+5EcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=pL9eH866; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="pL9eH866"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QaS8g5QdZcxipFIWuQjNfQfy+LH0uqF5iFeBJ5awSM4=; b=pL9eH866/pjmAlcYRiFdFeg7Di
	TCI5fXtUX6dryxAME34o2rSq0xGL55rGMyx1auHJCZdo95gWfzD70Q+hCh4tkaD8a+NO3kfK2rXPF
	IbfqnhGlgvAkgYSubj7+6aWlRB649q2PnI7mjGc6ZqClYB+sg+FKiBByO6ZVqZuUwJjn7Aoq99GIw
	ehY5zHvZqtzPBb0Hoj3WfdqvXj4lut/BVue7iSZIk2cGzPsviVTScIIHOwI24NxR6uu4oGzZyTCsG
	02qR2AoHuvTkmsR17H43bINcRWypo8FNr/hXnTtvDUKaMmu4MsYHOVyNX2Jdue0acdyHKqxTOv0VP
	JOFXENoQ==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roa0y-0000000EeXA-0NUk;
	Mon, 25 Mar 2024 02:24:44 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 08/11] xfs: look at m_frextents in xfs_iomap_prealloc_size for RT allocations
Date: Mon, 25 Mar 2024 10:24:08 +0800
Message-Id: <20240325022411.2045794-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240325022411.2045794-1-hch@lst.de>
References: <20240325022411.2045794-1-hch@lst.de>
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

