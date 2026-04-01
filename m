Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CC644CACA
	for <linux-xfs@vger.kernel.org>; Wed,  1 Apr 2026 13:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775051893; cv=none; b=YFTXg2Soy2ou56C3Ba1Z1j9ct4nsi1pUh0umIvSH3mcXpVkiUJt8YVdinCl4JsaFjuW60ta1t7RcqhCAmycyHpffWVw/9vGI+A8Khb6fF4XeV12vhUbINLWG+LhFktwx/ZSU2w8+lg00qmW5lR/hyjaVQijRCpapfUbT0keZBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775051893; c=relaxed/simple;
	bh=wYY0Hu0t69tAik+hMjhtTGHQz5xVFepOq2ZgO9g4DN4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mUNVqlcxDMJYr3MlSfO/6lA+1awZqE5+3cDySuPV1GgSx+djjxXsu0kJrcM3IGEY5TbahO5IVZeizTeddDsHp/mo0/5FVB5jNl4MD+ew+tIEMXNtZPmOYOMNTdOomZlsUXPgyEylBP+RvMzJ2ufObLy4fjd1tYeKa6XoeQgeRwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ck63h4cu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ck63h4cu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=E55TArHHjpcZ3Fr/XaEnUThXR52KeezJtGLeIRNFiYM=; b=ck63h4cufRd79C6T8wU43gqIFk
	lQl5x57VbtlhWDiSxVCPIKnbD1LbDu2fj94Zt0d32BkqhTz5FceCLKYP/u8Wcr8TUas1Qucfo2EC2
	Z91XTxoFcKvDOy02LF0xtZ+9u7yAb4WZnJIaPTsOSJrqH15vhTDeNzBH0gQUfMJ/N6OWQe70oxWJo
	Mktw7MdYqfRjr+9yJGQ1pIbtVB8fz5zhxFAzZ/pmZEMP9EsA7ERESNOsuDxLmFcQSiGOhfPf8jSh+
	GA3Ue2QAn/54IDi1T0PNxNe9eeYbraVNDMhotPa8/ewxc2ySNTF8OuXWNQxqOnAyw492KOSvK1OEr
	L96qQAoQ==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7w59-0000000FMrK-3pEn;
	Wed, 01 Apr 2026 13:58:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: cem@kernel.org
Cc: dlemoal@kernel.org,
	hans.holmberg@wdc.com,
	linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix number of GC bvecs
Date: Wed,  1 Apr 2026 15:58:01 +0200
Message-ID: <20260401135801.124987-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

GC scratch allocations can wrap around and use the same buffer twice, and
the current code fails to account for that.  So far this worked due to
rounding in the block layer, but changes to the bio allocator drop the
over-provisioning and generic/256 or generic/361 will not usually fail
when running against the current block tree.

Simply the allocation to always pass the maximum value that is easier to
verify, as a saving of up to one bvec per allocation isn't worth the
effort to verify a complicated calculated value.

Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 5fe84e82ff1e..b2626a482563 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -670,7 +670,6 @@ xfs_zone_gc_start_chunk(
 	struct xfs_inode	*ip;
 	struct bio		*bio;
 	xfs_daddr_t		daddr;
-	unsigned int		len;
 	bool			is_seq;
 
 	if (xfs_is_shutdown(mp))
@@ -685,15 +684,16 @@ xfs_zone_gc_start_chunk(
 		return false;
 	}
 
-	len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
-	bio = bio_alloc_bioset(bdev,
-			min(howmany(len, XFS_GC_BUF_SIZE) + 1, XFS_GC_NR_BUFS),
-			REQ_OP_READ, GFP_NOFS, &data->bio_set);
-
+	/*
+	 * Scratch allocation can wrap around to the same buffer again,
+	 * provision an extra bvec for that case.
+	 */
+	bio = bio_alloc_bioset(bdev, XFS_GC_NR_BUFS + 1, REQ_OP_READ, GFP_NOFS,
+			&data->bio_set);
 	chunk = container_of(bio, struct xfs_gc_bio, bio);
 	chunk->ip = ip;
 	chunk->offset = XFS_FSB_TO_B(mp, irec.rm_offset);
-	chunk->len = len;
+	chunk->len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
 	chunk->old_startblock =
 		xfs_rgbno_to_rtb(iter->victim_rtg, irec.rm_startblock);
 	chunk->new_daddr = daddr;
@@ -707,8 +707,9 @@ xfs_zone_gc_start_chunk(
 	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
 	bio->bi_end_io = xfs_zone_gc_end_io;
 	xfs_zone_gc_add_data(chunk);
-	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
-	data->scratch_available -= len;
+	data->scratch_head =
+		(data->scratch_head + chunk->len) % data->scratch_size;
+	data->scratch_available -= chunk->len;
 
 	XFS_STATS_INC(mp, xs_gc_read_calls);
 
-- 
2.47.3

