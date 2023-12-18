Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C0C63A3
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t8+Nk3Pm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bgNIfjQV8zJB6hl7G0OLBT33poVhBXXnICH44qwH/NY=; b=t8+Nk3Pmap1nURiYBwemdmdWeK
	2oaQTrpvyf+jyYVwnDckU8uGzV09hBwWVs6hXRiYk4M6esiCJwDlyk2ewcNJevPEICkPGXVDOtvgS
	QjR3K3M+jKq5mWNtujorC2Gh7ViPEZsnsw8Kec9jIwScgdI3bzrDVE9zbMsJ3KzmHrJBAKvGVL1tF
	PV/RalhY/CTrVTYXsbJw922OBZXOCSnZbltG7hJFisI2vsTj12TSw/VME4z5ctWrP64DLIiOzuyGw
	/xQA2+dV/JyjVdr5I1SDd6FAKnAFS4K+EnhfgO0BDtMDtg2QlEOpBA9EQp5tODDK5yAVDcm7Hkr6j
	grlGK8Lg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hz-0095H4-0R;
	Mon, 18 Dec 2023 04:58:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 18/22] xfs: remove XFS_RTMIN/XFS_RTMAX
Date: Mon, 18 Dec 2023 05:57:34 +0100
Message-Id: <20231218045738.711465-19-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231218045738.711465-1-hch@lst.de>
References: <20231218045738.711465-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use the kernel min/max helpers instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_format.h   | 6 ------
 fs/xfs/libxfs/xfs_rtbitmap.c | 8 ++++----
 fs/xfs/xfs_rtalloc.c         | 7 ++++---
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 82a4ab2d89e9f0..f11e7c8d336993 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1156,12 +1156,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
-/*
- * RT bit manipulation macros.
- */
-#define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
-#define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
-
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 4185ccf83bab68..31100120b2c586 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -184,7 +184,7 @@ xfs_rtfind_back(
 		 * Calculate first (leftmost) bit number to look at,
 		 * and mask for all the relevant bits in this word.
 		 */
-		firstbit = XFS_RTMAX((xfs_srtblock_t)(bit - len + 1), 0);
+		firstbit = max_t(xfs_srtblock_t, bit - len + 1, 0);
 		mask = (((xfs_rtword_t)1 << (bit - firstbit + 1)) - 1) <<
 			firstbit;
 		/*
@@ -338,7 +338,7 @@ xfs_rtfind_forw(
 		 * Calculate last (rightmost) bit number to look at,
 		 * and mask for all the relevant bits in this word.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
 		/*
 		 * Calculate the difference between the value there
@@ -573,7 +573,7 @@ xfs_rtmodify_range(
 		/*
 		 * Compute first bit not changed and mask of relevant bits.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
 		/*
 		 * Set/clear the active bits.
@@ -787,7 +787,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute first bit not examined.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		/*
 		 * Mask of relevant bits.
 		 */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index dac6f17e4f0305..fb26ecbe34d4a3 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -638,9 +638,10 @@ xfs_rtallocate_extent_size(
 	 * for this summary level.
 	 */
 	for (l = xfs_highbit32(maxlen); l >= xfs_highbit32(minlen); l--) {
-		error = xfs_rtalloc_sumlevel(args, l, XFS_RTMAX(minlen, 1 << l),
-				XFS_RTMIN(maxlen, (1 << (l + 1)) - 1), prod,
-				len, rtx);
+		error = xfs_rtalloc_sumlevel(args, l,
+				max_t(xfs_rtxlen_t, minlen, 1 << l),
+				min_t(xfs_rtxlen_t, maxlen, (1 << (l + 1)) - 1),
+				prod, len, rtx);
 		if (error != -ENOSPC)
 			return error;
 	}
-- 
2.39.2

