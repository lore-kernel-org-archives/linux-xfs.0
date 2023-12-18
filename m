Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A91C63A8
	for <linux-xfs@vger.kernel.org>; Mon, 18 Dec 2023 04:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l6N/8Ew4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D9dhRxQN/nkIzvmmdwLV38irbgRQ90rzHYChLJP17Os=; b=l6N/8Ew4W9f2dCRM+7SDlcxBW9
	qHPZFXYCe3FXHiH2GJ55nADeh5fX0d9xPVY6OQAJTh8rAT8q+cMMEM5yIlTO6k/ZUMc6QgqYtka9i
	Whww4KcDK3ccmvJPeOwQGBqciTSWGY2JMZnm1otCJoF061NU0jDmHGC8jVaJt/RtEiVMvhIeyV3uh
	5FNBidcePSmFyTeu/aJRtcLUi6FI6DTqN4XZU2BDXQfSAmXSW63kpu/Hzgpu0Bt5QCIvXURQ3Tz4f
	k5/79n0fK3R9U9alO+dv7uN6cUnTAAyqwGqReyMr2MW0eF0SAeOVrBZTsUpXJG2Ht1WeYK7QVrZXd
	rjwNRB2g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rF5i1-0095I7-38;
	Mon, 18 Dec 2023 04:58:30 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 19/22] xfs: reorder the minlen and prod calculations in xfs_bmap_rtalloc
Date: Mon, 18 Dec 2023 05:57:35 +0100
Message-Id: <20231218045738.711465-20-hch@lst.de>
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

xfs_bmap_rtalloc is a bit of a mess in terms of calculating the locally
need variables.  Reorder them a bit so that related code is located
next to each other - the raminlen calculation moves up next to where
the maximum len is calculated, and all the prod calculation is move
into a single place and rearranged so that the real prod calculation
only happens when it actually is needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index fb26ecbe34d4a3..bac8eacd628c29 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1370,7 +1370,6 @@ xfs_bmap_rtalloc(
 
 	align = xfs_get_extsz_hint(ap->ip);
 retry:
-	prod = xfs_extlen_to_rtxlen(mp, align);
 	error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 					align, 1, ap->eof, 0,
 					ap->conv, &ap->offset, &ap->length);
@@ -1388,13 +1387,6 @@ xfs_bmap_rtalloc(
 	if (ap->offset != orig_offset)
 		minlen += orig_offset - ap->offset;
 
-	/*
-	 * If the offset & length are not perfectly aligned
-	 * then kill prod, it will just get us in trouble.
-	 */
-	div_u64_rem(ap->offset, align, &mod);
-	if (mod || ap->length % align)
-		prod = 1;
 	/*
 	 * Set ralen to be the actual requested length in rtextents.
 	 *
@@ -1405,6 +1397,7 @@ xfs_bmap_rtalloc(
 	 * adjust the starting point to match it.
 	 */
 	ralen = xfs_extlen_to_rtxlen(mp, min(ap->length, XFS_MAX_BMBT_EXTLEN));
+	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
 
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes
@@ -1433,7 +1426,16 @@ xfs_bmap_rtalloc(
 		start = 0;
 	}
 
-	raminlen = max_t(xfs_rtxlen_t, 1, xfs_extlen_to_rtxlen(mp, minlen));
+	/*
+	 * Only bother calculating a real prod factor if offset & length are
+	 * perfectly aligned, otherwise it will just get us in trouble.
+	 */
+	div_u64_rem(ap->offset, align, &mod);
+	if (mod || ap->length % align)
+		prod = 1;
+	else
+		prod = xfs_extlen_to_rtxlen(mp, align);
+
 	error = xfs_rtallocate_extent(ap->tp, start, raminlen, ralen, &ralen,
 			ap->wasdel, prod, &rtx);
 	if (error == -ENOSPC) {
-- 
2.39.2

