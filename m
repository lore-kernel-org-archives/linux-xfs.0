Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9460627442
	for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2024 12:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732624286; cv=none; b=dt3hR1v2x27sh94UcWe1Gmkz+9D7+2Vvirwn2mMG7TaFODheJCCGHtGxFqEABVvwTE2aVHB7Zl1qZfGpoQRS1579cViGRSnnW7F8jCddeUEic1/f3+eLcXXdsxVrSZ066tg/nBDUpFp1BGVgHm4Ai1KKmjphsm7YaPBEfXnWPYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732624286; c=relaxed/simple;
	bh=Brx2GU6ky8pPdoe864NqJL65A3KR9cO23cxvOvasVM8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gOS7EwMDNULlSZuvX1xVJL8uDfq3F9AtWRvNcruTa5GALLvlRyLfIfgKuuJP2W+wRppuWzvL+ykxLtl7OLB8GzEV/nBXrJ0u+qEDfFjOnOKeCHvPeQ1I6bewRBW37sKE8o+Kpi6avP1ypdhdUJcSatlRL9nk/k5DXqcTyIuJ93g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JtQfBQ9u; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JtQfBQ9u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=7y850qLtTz5qzLFVnnY5P+tkDAIXtkRPeDdUDFSp0NU=; b=JtQfBQ9uKqY3VTcDAef0D1K22v
	QKiXEdB2JmQKfknIPysi/uWGQcYhT5KxHj4uIL6ZeCFp/SSgu9eNEjBc1dj2226TVCs8rK2clNfHn
	cG+MNVcR9s0xPuRxjaJAcaz4dmhZFiINKcY9Eo3UYJsdTL8HRw81KdsiKAClqGVTnx/tN+bcuso7Y
	kiqcOTBL+7yEc/lpZt7Hd1MEKs93luzcgFNl2TmrG5kMmfFIQKjTFGB0iE2eIuupv4HMULKxNrssC
	THdx3qKdEbGNu1N8ATDixTrzBXmUJ+xZEtkR3LcIVQ6vHnlj5lCPDI3mHM5O0CZBOCF4IpMSbvTD/
	M4gTy7eg==;
Received: from 2a02-8389-2341-5b80-8f90-0002-7d3f-174e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8f90:2:7d3f:174e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tFuiu-0000000AZhR-2RUD;
	Tue, 26 Nov 2024 12:31:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH] xfs: don't call xfs_bmap_same_rtgroup in xfs_bmap_add_extent_hole_delay
Date: Tue, 26 Nov 2024 13:31:06 +0100
Message-ID: <20241126123117.631675-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_bmap_add_extent_hole_delay works entirely on delalloc extents, for
which xfs_bmap_same_rtgroup doesn't make sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e7f768a43724..d1e700213550 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2617,8 +2617,7 @@ xfs_bmap_add_extent_hole_delay(
 	 */
 	if ((state & BMAP_LEFT_VALID) && (state & BMAP_LEFT_DELAY) &&
 	    left.br_startoff + left.br_blockcount == new->br_startoff &&
-	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
-	    xfs_bmap_same_rtgroup(ip, whichfork, &left, new))
+	    left.br_blockcount + new->br_blockcount <= XFS_MAX_BMBT_EXTLEN)
 		state |= BMAP_LEFT_CONTIG;
 
 	if ((state & BMAP_RIGHT_VALID) && (state & BMAP_RIGHT_DELAY) &&
@@ -2626,8 +2625,7 @@ xfs_bmap_add_extent_hole_delay(
 	    new->br_blockcount + right.br_blockcount <= XFS_MAX_BMBT_EXTLEN &&
 	    (!(state & BMAP_LEFT_CONTIG) ||
 	     (left.br_blockcount + new->br_blockcount +
-	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)) &&
-	    xfs_bmap_same_rtgroup(ip, whichfork, new, &right))
+	      right.br_blockcount <= XFS_MAX_BMBT_EXTLEN)))
 		state |= BMAP_RIGHT_CONTIG;
 
 	/*
-- 
2.45.2

