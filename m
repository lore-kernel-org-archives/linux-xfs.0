Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC6B6ADC
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WK6E0Huk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4di5SakJKhqdppFmLHAryimnuEwnpJhpFyUIdi0l1Qw=; b=WK6E0HukXFKDR1o6RjjKWSfZzS
	Fc7Meyqeiyvn/Dy0E09wi0A5woK3L7Iwl06IDVcLPFJbxPEahw8oSG+XGMrUB/8IAxLb0byt8cElZ
	Ktg3zFWVB1ybnYrbeqU74pdooVsJTL/TT42+pOVCI2DvgMOOCQ6A7HYukoqSbJiGwIMrdeLpwWWki
	UwjwmXOQJLqTc0F3xhEiCU35xgYogUeaoeJ7nZt6bQus7K7DgL6bzOeqpgfetaOcsmtnO+P56/ULT
	EqeUUQbcxjlCeF1EUdDUwxyjXFgBEM1UYC3dQIMsIZNRA7iso9qu4nvFjORop1Fk29lnoXxukT4IY
	iE1DfD9g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5hW-009594-0J;
	Mon, 18 Dec 2023 04:57:58 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/22] xfs: reflow the tail end of xfs_bmap_rtalloc
Date: Mon, 18 Dec 2023 05:57:23 +0100
Message-Id: <20231218045738.711465-8-hch@lst.de>
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

Reorder the tail end of xfs_bmap_rtalloc so that the successfully
allocation is in the main path, and the error handling is on a branch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 60 ++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index dac148d53af3ec..158a631379378e 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1479,39 +1479,39 @@ xfs_bmap_rtalloc(
 	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
 	error = xfs_rtallocate_extent(ap->tp, rtx, raminlen, ralen, &ralen,
 			ap->wasdel, prod, &rtx);
-	if (!error) {
-		ap->blkno = xfs_rtx_to_rtb(mp, rtx);
-		ap->length = xfs_rtxlen_to_extlen(mp, ralen);
-		xfs_bmap_alloc_account(ap);
-		return 0;
-	}
-
-	if (error != -ENOSPC)
-		return error;
+	if (error == -ENOSPC) {
+		if (align > mp->m_sb.sb_rextsize) {
+			/*
+			 * We previously enlarged the request length to try to
+			 * satisfy an extent size hint.  The allocator didn't
+			 * return anything, so reset the parameters to the
+			 * original values and try again without alignment
+			 * criteria.
+			 */
+			ap->offset = orig_offset;
+			ap->length = orig_length;
+			minlen = align = mp->m_sb.sb_rextsize;
+			goto retry;
+		}
 
-	if (align > mp->m_sb.sb_rextsize) {
-		/*
-		 * We previously enlarged the request length to try to satisfy
-		 * an extent size hint.  The allocator didn't return anything,
-		 * so reset the parameters to the original values and try again
-		 * without alignment criteria.
-		 */
-		ap->offset = orig_offset;
-		ap->length = orig_length;
-		minlen = align = mp->m_sb.sb_rextsize;
-		goto retry;
-	}
+		if (!ignore_locality && ap->blkno != 0) {
+			/*
+			 * If we can't allocate near a specific rt extent, try
+			 * again without locality criteria.
+			 */
+			ignore_locality = true;
+			goto retry;
+		}
 
-	if (!ignore_locality && ap->blkno != 0) {
-		/*
-		 * If we can't allocate near a specific rt extent, try again
-		 * without locality criteria.
-		 */
-		ignore_locality = true;
-		goto retry;
+		ap->blkno = NULLFSBLOCK;
+		ap->length = 0;
+		return 0;
 	}
+	if (error)
+		return error;
 
-	ap->blkno = NULLFSBLOCK;
-	ap->length = 0;
+	ap->blkno = xfs_rtx_to_rtb(mp, rtx);
+	ap->length = xfs_rtxlen_to_extlen(mp, ralen);
+	xfs_bmap_alloc_account(ap);
 	return 0;
 }
-- 
2.39.2

