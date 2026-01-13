Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77177369972;
	Tue, 13 Jan 2026 07:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768288768; cv=none; b=tJnUwgqdBGXEvp8frEmIIc2nux3Fisht5XxRfQaMa45nBKH0yJlAcdCeJevP7SjRImtLWvfDaX5jsQ5QaNVgLGDEoZg/jlaIcSCn+g70CFHScr03L+dgmLnk/pzsxbXK6nfhRkYmSHn+74pS0kYPHJkt4ICK2hJhB12ja/mmado=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768288768; c=relaxed/simple;
	bh=J7rzfGsN9zpXRcnmzbZda0B/3lgMfpKZrrDJPfHyq3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRPWFKR3VsmGC3bRxMLXpVhbsclHbONdT4lsGOLDooNilgvzGoQUJFrkX38qS9t8IYTrG7rPqcP+jpPTddPQoQSljIOSWo1IKkYdmexuh/rbRvA8uToop9Coh3tvaafUGbJDP4lMGazyQ6+YeGD3pKuYdUknxHjrfQomATH+WeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bwjKqz7s; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bwjKqz7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ReWnGaR2ck2wGGR50JdNvPoo418UvcF/Z1to11jUH4A=; b=bwjKqz7s5ZgwlqMBsEdMef0ONV
	is4+neGYhVWWRc+M3dYiLvxdEdJPi01uNCnDFTUgUuLguaEzUuExm9FRKP9+s7owN5t8IwDkLJ1WB
	ZR8zOQfB8lxmEgE2dhgnakblUua873xRzSuSlFmZAqR76gO5yZj5zrFfYSjosT9E5TEtVVnGCEeHe
	faxB68hBkxg5AhcoP4g1cs1bqfPqw5sMFJ7mG4sDdDGZo1CghTIJlJImdhBNpKa5lOSVrIqo94h5g
	RVUFdm6T1o2JUBWUY+6mn3m6wW0NhDU0mkC4G1KiUsLOKbKV35BZBkncvXF6xcO6ulQa9HwIhXmxZ
	iN6nRTcw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vfYgY-00000006dYG-33qN;
	Tue, 13 Jan 2026 07:19:27 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Date: Tue, 13 Jan 2026 08:19:02 +0100
Message-ID: <20260113071912.3158268-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113071912.3158268-1-hch@lst.de>
References: <20260113071912.3158268-1-hch@lst.de>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
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

