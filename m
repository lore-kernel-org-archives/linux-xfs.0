Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0886032A3C8;
	Thu, 18 Dec 2025 06:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766039568; cv=none; b=ivndtHrLosuezPSWlBCc4GufQdohXKIiVZS4BYtIiCIGqv8txwDGykjr9IJIcpCy4fOWUVYe3H23R47lTphQ6UoK3lyHqVzL/Hpr2Z430chIN2ysgRSQE+a+blGDnoOOVgYFJ5aUBHfvAaAarjgpCKFGcruhAdnqO5bjcAeK8Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766039568; c=relaxed/simple;
	bh=kriQvrshwbnU+5sVA+YFTCmpAuTlFRpau+JTmL13yYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKYkc63753SodL9Qe8Dq7BMvSo1l2v/k+uGmStZviNicgyz/QGCpPJUeQizlJ77A2M6jP0Yhw+VRDWFbUU6/r5FKgMyEnVA0YDtezOyrgCnGvgM11Ar90WQ6BuJahREW/eV5EFuF2jVAKJgeUY6+lCD5mDPrq/faNElSiXb93Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vb50Zpyh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vb50Zpyh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PfGVZDHtaTVTH+MffKS+0NvOe1zdN80fDH5Tg28W5B8=; b=Vb50ZpyhKQdlvg270EFWQyo7wT
	gBnTfcaSEB6cMfzZwyI5WmcMM822MwBCCKlHExI8Yue3/9ezF3w1Qn1R8NRqpflpyBUT6f3iqbNgr
	aWfWYtaeKx7Yt4N11Abxd/XTnVEyWPAD8BiRia4ebu493T8TBsrnmGmmToKBsz36x28xCwBHOjRIA
	RNPJWD1b8Y1dnmifU5npZh75wfbpZwYoxcqsOdon6rQ3ZwHFbCO+/rggj1ruKMKh9ZNMh2t9uuVPz
	RTIFW3sQVrr3atISjVd0UY+gvIVZLxfC+GmssluP0WOXWsxXDPGLuhjrwqRjDKmEoS6KtKjmdguXX
	Jqyas76w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW7Z8-00000007tzE-0v8j;
	Thu, 18 Dec 2025 06:32:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Date: Thu, 18 Dec 2025 07:31:46 +0100
Message-ID: <20251218063234.1539374-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218063234.1539374-1-hch@lst.de>
References: <20251218063234.1539374-1-hch@lst.de>
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
---
 fs/xfs/xfs_zone_gc.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 065005f13fe1..f3dec13a620c 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -812,8 +812,6 @@ xfs_zone_gc_write_chunk(
 {
 	struct xfs_zone_gc_data	*data = chunk->data;
 	struct xfs_mount	*mp = chunk->ip->i_mount;
-	phys_addr_t		bvec_paddr =
-		bvec_phys(bio_first_bvec_all(&chunk->bio));
 	struct xfs_gc_bio	*split_chunk;
 
 	if (chunk->bio.bi_status)
@@ -826,10 +824,7 @@ xfs_zone_gc_write_chunk(
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

