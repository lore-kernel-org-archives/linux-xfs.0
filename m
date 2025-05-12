Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD0422A7E3
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747060991; cv=none; b=fg7BeD026jYWgjB/O1H2yS9TAzq7YBkzLxxRIysP/4PT9Kt8wIohKpQ2n2fMJScbUhCToGo7RJUOGzaL3GTnQWaw5f3TpHpaJXFeGpd9Tes0iDz8Qfd9eibQN2FyHwGnJ/W5dmQ7EgY6GT5I8XTdJDDzWmPos++11iZCA1tCG7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747060991; c=relaxed/simple;
	bh=k4IDaIufkxISMrxCgg5d29YPSukyHk0LfY/04rM6IoU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VbYSraVXNx6PYFp6Bx2E4aUycFJXFxmDjVQRzIokx/xe7EqDYaMD4H27wZqRjLmYtqNbK70ewPxN4WLb1dEiHjYDVCmxr6Kg3VxkAYHNx3vy+O6BavuK8QUd43x8k6TOr4H5immWdYICM5ucSvV4vvEpEHS73QQe1h5E8FlgljQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Cxd3tEOx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Cxd3tEOx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=OCr4ZrjMggWFX2T2Z88IsX0X7+f/O+uWLihdLvZBz64=; b=Cxd3tEOxBFMsCRCphyBOGyxyzo
	2R8jYNxskA444A5lJ+U4Fa55ShI/s/N2CuksiRhT/GZmD7Y1PQwbRlCnraRQL7W91lQotT9GwVAkT
	mPj0tI9Lg1t5/RRn96yKBh5yLRTdLotwixrbHJWz1nXRWWW2BCndtzopxVPKduP9GOAFMXIKbtu/8
	2RmKv7L14CdnTlKAGr6cuWBQbHA/7sXooNSLEz/Ii8IuwoGyB7lPPFz4CfE2pTLIiTRBybXymxnxE
	qtRfUbRC1AbtH3H3CaMGnljY6WsKBjA8jaSucfoGRC0lrjKLxiyf4gLL4zQe2iK6oZv335NP+206y
	aD8VhzVg==;
Received: from 2a02-8389-2341-5b80-e9d3-2d8e-37c8-bd0d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e9d3:2d8e:37c8:bd0d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uEUN2-00000009liJ-3C0h;
	Mon, 12 May 2025 14:43:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: djwong@kernel.org,
	hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: [PATCH] xfs: fix zoned GC data corruption due to wrong bv_offset
Date: Mon, 12 May 2025 16:43:05 +0200
Message-ID: <20250512144306.647922-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_zone_gc_write_chunk writes out the data buffer read in earlier using
the same bio, and currenly looks at bv_offset for the offset into the
scratch folio for that.  But commit 26064d3e2b4d ("block: fix adding
folio to bio") changed how bv_page and bv_offset are calculated for
adding larger folios, breaking this fragile logic.

Switch to extracting the full physical address from the old bio_vec,
and calculate the offset into the folio from that instead.

This fixes data corruption during garbage collection with heavy rockdsb
workloads.  Thanks to Hans for tracking down the culprit commit during
long bisection sessions.

Fixes: 26064d3e2b4d ("block: fix adding folio to bio")
Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Reported-by: Hans Holmberg <Hans.Holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 8c541ca71872..a045b1dedd68 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -801,7 +801,8 @@ xfs_zone_gc_write_chunk(
 {
 	struct xfs_zone_gc_data	*data = chunk->data;
 	struct xfs_mount	*mp = chunk->ip->i_mount;
-	unsigned int		folio_offset = chunk->bio.bi_io_vec->bv_offset;
+	phys_addr_t		bvec_paddr =
+		bvec_phys(bio_first_bvec_all(&chunk->bio));
 	struct xfs_gc_bio	*split_chunk;
 
 	if (chunk->bio.bi_status)
@@ -816,7 +817,7 @@ xfs_zone_gc_write_chunk(
 
 	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
 	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
-			folio_offset);
+			offset_in_folio(chunk->scratch->folio, bvec_paddr));
 
 	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
 		xfs_zone_gc_submit_write(data, split_chunk);
-- 
2.47.2

