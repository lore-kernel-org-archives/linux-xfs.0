Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493AF397AAA;
	Wed, 14 Jan 2026 13:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768396030; cv=none; b=huvyPY5+wU8DX8oaaTXIS6yLw13z3du2OhLQWUqgB6ZPwxMf8itT4wP5AKz/W11xkURZ2O9Odl0ILnrHA6YD7//84wc9uZVcyTu3G+mSVR7eJQnraNFTXkYJQPddiz7DzywSQ/+ImqjB/OLxOaMr8+AmWZ+5Dgid1NjGGs1odmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768396030; c=relaxed/simple;
	bh=i+jKQbYLjHqNCBU3BwopuP2jXAgAl5Uv+Q1GJaEeFv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlqBWTtOpOrtDuteJekOr2dMk2WUmtzGNy4ven0V2katJ5Fij9VA0HZUUayzUQdhWMi+DMtaeMeV2RSryChBN8pmVo/M2sjbVGFzGX9OLGTgf9Bh09u9puAnaYtWQPsfqiZdj56YPU45b27uPTJelwZpWRzkVs4WT8RPkwXsG0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q2JiQ2Rq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q2JiQ2Rq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=S7Ixkt0t/w6JMRPAenV5qtrjGUItDGzIXcTopdvz4fM=; b=q2JiQ2RqmjLTJ4EWfzYdngBMR9
	mRt0ypU2a8bbZiyZUsB6u08Ov/0A8UuzJVbkTolDswtk7fTe3kcMR34tdJp5qADE2dLuhQN0ubMeq
	Lnrvq4MhhrfrF8beXtDzrUJqzqOMSTEt0VeuVd1r3v9DbQkjP3D2FwuN/twTALl2eo+3h5rPqcsef
	MnXN2CJL9U0Lx7O9Vc3UvnVO3YqywixcUNCppI+X3J34alnCSEnUB8FOKoqYdNf7nSITdN1qYV8bZ
	1DlHZ8iqF5mKfMJWFpGI9fGqCy/ft2yMq0rMpoGuVUsBVkyTVx93AOBbrIwupnqzS1bueU3+HDdrU
	5XsfkH+w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vg0aY-00000009H07-1pfM;
	Wed, 14 Jan 2026 13:07:06 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Date: Wed, 14 Jan 2026 14:06:42 +0100
Message-ID: <20260114130651.3439765-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260114130651.3439765-1-hch@lst.de>
References: <20260114130651.3439765-1-hch@lst.de>
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
index 3c52cc1497d4..c9a3df6a5289 100644
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
+	bio_reuse(&chunk->bio, REQ_OP_WRITE);
 	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
 		xfs_zone_gc_submit_write(data, split_chunk);
 	xfs_zone_gc_submit_write(data, chunk);
-- 
2.47.3

