Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nqtMFdW7"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE08A6
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=jFMpyvPVuQ1AWsU2OvLncWtxw1GZKIFnlrKyh8UaCU0=; b=nqtMFdW7M4TxYq3ogckyf29YUw
	pZW5imtH+XV2/1htUZcDP0EVDWNRY9IvyIBs/2qfwKehpfezj3NjbFd7jjmGbNvlQd5nZ1JpMfqsc
	htiMKlOGEeZMgPaR4XZL9zfJEr+JiYa0142NSBrCsDIwWoB2fTJZSsQ8YjT/vxk7VtIo7p7NoLpWC
	HZgkS9Baf6x5B/P1qsDOSl1lFX1w7VGRy2bAHPT/nnfcrsX+mEZa40S36teWm9EcjBTwkqlxE9oVS
	En5Jbe14p+EdADOVhPF09gyCbXYDFL/qIg7p48JTJIq6rQlr0IuAmtbhDhKSHddmAnOWazViVxMJG
	3Vi+KIKQ==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rDfJW-00GzSx-1N;
	Thu, 14 Dec 2023 06:35:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 14/19] xfs: factor out a xfs_rtalloc_sumlevel helper
Date: Thu, 14 Dec 2023 07:34:33 +0100
Message-Id: <20231214063438.290538-15-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231214063438.290538-1-hch@lst.de>
References: <20231214063438.290538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_rtallocate_extent_size has two loops with nearly identical logic
in them.  Split that logic into a separate xfs_rtalloc_sumlevel helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_rtalloc.c | 153 ++++++++++++++++++++-----------------------
 1 file changed, 70 insertions(+), 83 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index ea6f221c6a193c..2e578e726e9137 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -537,6 +537,52 @@ xfs_rtallocate_extent_near(
 	return -ENOSPC;
 }
 
+static int
+xfs_rtalloc_sumlevel(
+	struct xfs_rtalloc_args	*args,
+	int			l,	/* level number */
+	xfs_rtxlen_t		minlen,	/* minimum length to allocate */
+	xfs_rtxlen_t		maxlen,	/* maximum length to allocate */
+	xfs_rtxlen_t		prod,	/* extent product factor */
+	xfs_rtxlen_t		*len,	/* out: actual length allocated */
+	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
+{
+	xfs_fileoff_t		i;	/* bitmap block number */
+
+	for (i = 0; i < args->mp->m_sb.sb_rbmblocks; i++) {
+		xfs_suminfo_t	sum;	/* summary information for extents */
+		xfs_rtxnum_t	n;	/* next rtext to be tried */
+		int		error;
+
+		error = xfs_rtget_summary(args, l, i, &sum);
+		if (error)
+			return error;
+
+		/*
+		 * Nothing there, on to the next block.
+		 */
+		if (!sum)
+			continue;
+
+		/*
+		 * Try allocating the extent.
+		 */
+		error = xfs_rtallocate_extent_block(args, i, minlen, maxlen,
+				len, &n, prod, rtx);
+		if (error != -ENOSPC)
+			return error;
+
+		/*
+		 * If the "next block to try" returned from the allocator is
+		 * beyond the next bitmap block, skip to that bitmap block.
+		 */
+		if (xfs_rtx_to_rbmblock(args->mp, n) > i + 1)
+			i = xfs_rtx_to_rbmblock(args->mp, n) - 1;
+	}
+
+	return -ENOSPC;
+}
+
 /*
  * Allocate an extent of length minlen<=len<=maxlen, with no position
  * specified.  If we don't get maxlen then use prod to trim
@@ -551,12 +597,8 @@ xfs_rtallocate_extent_size(
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
-	struct xfs_mount	*mp = args->mp;
 	int			error;
-	xfs_fileoff_t		i;	/* bitmap block number */
 	int			l;	/* level number (loop control) */
-	xfs_rtxnum_t		n;	/* next rtext to be tried */
-	xfs_suminfo_t		sum;	/* summary information for extents */
 
 	ASSERT(minlen % prod == 0);
 	ASSERT(maxlen % prod == 0);
@@ -564,46 +606,23 @@ xfs_rtallocate_extent_size(
 
 	/*
 	 * Loop over all the levels starting with maxlen.
-	 * At each level, look at all the bitmap blocks, to see if there
-	 * are extents starting there that are long enough (>= maxlen).
-	 * Note, only on the initial level can the allocation fail if
-	 * the summary says there's an extent.
+	 *
+	 * At each level, look at all the bitmap blocks, to see if there are
+	 * extents starting there that are long enough (>= maxlen).
+	 *
+	 * Note, only on the initial level can the allocation fail if the
+	 * summary says there's an extent.
 	 */
-	for (l = xfs_highbit32(maxlen); l < mp->m_rsumlevels; l++) {
-		/*
-		 * Loop over all the bitmap blocks.
-		 */
-		for (i = 0; i < mp->m_sb.sb_rbmblocks; i++) {
-			/*
-			 * Get the summary for this level/block.
-			 */
-			error = xfs_rtget_summary(args, l, i, &sum);
-			if (error)
-				return error;
-			/*
-			 * Nothing there, on to the next block.
-			 */
-			if (!sum)
-				continue;
-			/*
-			 * Try allocating the extent.
-			 */
-			error = xfs_rtallocate_extent_block(args, i, maxlen,
-					maxlen, len, &n, prod, rtx);
-			if (error != -ENOSPC)
-				return error;
-			/*
-			 * If the "next block to try" returned from the
-			 * allocator is beyond the next bitmap block,
-			 * skip to that bitmap block.
-			 */
-			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
-				i = xfs_rtx_to_rbmblock(mp, n) - 1;
-		}
+	for (l = xfs_highbit32(maxlen); l < args->mp->m_rsumlevels; l++) {
+		error = xfs_rtalloc_sumlevel(args, l, minlen, maxlen, prod, len,
+				rtx);
+		if (error != -ENOSPC)
+			return error;
 	}
+
 	/*
-	 * Didn't find any maxlen blocks.  Try smaller ones, unless
-	 * we're asking for a fixed size extent.
+	 * Didn't find any maxlen blocks.  Try smaller ones, unless we are
+	 * looking for a fixed size extent.
 	 */
 	if (minlen > --maxlen)
 		return -ENOSPC;
@@ -612,51 +631,19 @@ xfs_rtallocate_extent_size(
 
 	/*
 	 * Loop over sizes, from maxlen down to minlen.
-	 * This time, when we do the allocations, allow smaller ones
-	 * to succeed.
+	 *
+	 * This time, when we do the allocations, allow smaller ones to succeed,
+	 * but make sure the specified minlen/maxlen are in the possible range
+	 * for this summary level.
 	 */
 	for (l = xfs_highbit32(maxlen); l >= xfs_highbit32(minlen); l--) {
-		/*
-		 * Loop over all the bitmap blocks, try an allocation
-		 * starting in that block.
-		 */
-		for (i = 0; i < mp->m_sb.sb_rbmblocks; i++) {
-			/*
-			 * Get the summary information for this level/block.
-			 */
-			error =	xfs_rtget_summary(args, l, i, &sum);
-			if (error)
-				return error;
-
-			/*
-			 * If nothing there, go on to next.
-			 */
-			if (!sum)
-				continue;
-			/*
-			 * Try the allocation.  Make sure the specified
-			 * minlen/maxlen are in the possible range for
-			 * this summary level.
-			 */
-			error = xfs_rtallocate_extent_block(args, i,
-					XFS_RTMAX(minlen, 1 << l),
-					XFS_RTMIN(maxlen, (1 << (l + 1)) - 1),
-					len, &n, prod, rtx);
-			if (error != -ENOSPC)
-				return error;
-
-			/*
-			 * If the "next block to try" returned from the
-			 * allocator is beyond the next bitmap block,
-			 * skip to that bitmap block.
-			 */
-			if (xfs_rtx_to_rbmblock(mp, n) > i + 1)
-				i = xfs_rtx_to_rbmblock(mp, n) - 1;
-		}
+		error = xfs_rtalloc_sumlevel(args, l, XFS_RTMAX(minlen, 1 << l),
+				XFS_RTMIN(maxlen, (1 << (l + 1)) - 1), prod,
+				len, rtx);
+		if (error != -ENOSPC)
+			return error;
 	}
-	/*
-	 * Got nothing, return failure.
-	 */
+
 	return -ENOSPC;
 }
 
-- 
2.39.2

