Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34CC26C3BE;
	Tue,  6 Jan 2026 07:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767686373; cv=none; b=CQLVrnVNym8LhE0qLvzNmA1iLnFnvotbmEL93eTr+RkZUHhgjp89vJE4IiJCCVs8c6+1aOGHKKrBIA0YjOz+akMiRviNlvl25DvGPjYr5fpgOWQxlxqiJIUJKArFPRSqYPLOxRmzZ76RPIx2OHBj8tO1+BrgGDxLfkCe/EuV108=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767686373; c=relaxed/simple;
	bh=alMxi2mn/Ws1pat4hsN58ET+7G8vWIaSHjfnstSQx7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J57fQQPZVmJPfUxonlObSCAE7FVPQIIR82xbVIHQP4B1XucB/mBRoI1hNMZ3HRy5/lL7cPgrChJ5Kbknok3R7KpVGsBo8qadeV6yOZ+Iy69Tkwl3ffnHgceTxxDnnJcokomSXZD9STI9+z+o2nof/Fpfr9cRlLv/EgkJhR5iIxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=GSAAGyjk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GSAAGyjk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BvkGodNvyABANn7wnM6ncUGXv6MX6uivNR2B3hSPhig=; b=GSAAGyjkCknZDFtG2/x1RcUkTd
	w5TGAve6VlQlnCnZeGiKDAKGVSFfsOEQMZJoQqOAyO+iYvyb1audzovhVXDBCq31XKir/SlMg5HQp
	YfmhXCy25ISsLs1yHeuxSBKzyp5zNB3CVD2iBMGN3Smmh7QBRvGUDSEu6C87/NB4oXX4t9be75fL5
	KnwF5V/UT86Uzn00ipXqwkKeRrifzBNeKNgeYhxGYMF0ygXDduw+2CU2Tn2DhZXhJiCs3+lkMeRgA
	Se6+5kd6edFTZ0A89ZFJZZLd625o+b6EmgFGPxSMEiIfAZkzSl+7EuazpuEBnRV6P6YBVMiKefdi1
	/eg4EFWQ==;
Received: from [2001:4bb8:2af:87cb:5562:685f:c094:6513] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vd1yV-0000000Ca0w-0Xxd;
	Tue, 06 Jan 2026 07:59:31 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Date: Tue,  6 Jan 2026 08:58:53 +0100
Message-ID: <20260106075914.1614368-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260106075914.1614368-1-hch@lst.de>
References: <20260106075914.1614368-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace our somewhat fragile code to reuse the bio, which caused a
regression in the past with the block layer bio_reuse helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 3c52cc1497d4..40408b1132e0 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -811,8 +811,6 @@ xfs_zone_gc_write_chunk(
 {
 	struct xfs_zone_gc_data	*data = chunk->data;
 	struct xfs_mount	*mp = chunk->ip->i_mount;
-	phys_addr_t		bvec_paddr =
-		bvec_phys(bio_first_bvec_all(&chunk->bio));
 	struct xfs_gc_bio	*split_chunk;
 
 	if (chunk->bio.bi_status)
@@ -825,10 +823,7 @@ xfs_zone_gc_write_chunk(
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_move_tail(&chunk->entry, &data->writing);
 
-	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
-	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
-			offset_in_folio(chunk->scratch->folio, bvec_paddr));
-
+	bio_reuse(&chunk->bio);
 	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
 		xfs_zone_gc_submit_write(data, split_chunk);
 	xfs_zone_gc_submit_write(data, chunk);
-- 
2.47.3

