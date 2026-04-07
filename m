Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DEB340A62;
	Tue,  7 Apr 2026 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570750; cv=none; b=gbOpQ4/On3KsaDO53mn5BDpRUAUfA9CJyxHDzEI0u0ekMHMv/WEmNDKESXudxbaw36e/5WLhTrxV81DdeGNV9s73gKPMJR5DSaLq7EcLKhWrIIlaIPT6YKLUFkVXP0BAD2hGP0ZazED4LzBBJihT4/r1aA0BRNIPh47L4WfMh4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570750; c=relaxed/simple;
	bh=P1XqvrjQY8zxO5Vf1wp2R7/mu79jrAPIeAzU4yDPmz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRE5MAF2zPZwl4UMeChkkw9SBb/E0LGQtINeKBiB0S9oNNEa0JXCLgmM1ec2ZabuCUr2+HBuQzbbCCoC1IKN41ciBgs5x2ny2cB21I5aAYBAG90ac4wXAj5yO1XwJM+400HtYcdBpT7Ar0linJPBYOWjWp7rH51Kk56Ofo7aTGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sULVc04O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sULVc04O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qoC8qwCWI3E5DHzM7txatzS/50XRleO1knGD6kT7N8Y=; b=sULVc04OjDo6Izx7ndkR4/pqu3
	pOsaDp8WfJVnSrXXgSOARdY3uddDNd1ugD0csGtjXNks7PRXsbW+S+S7ZbZm2aAlXkaMkqCrlj5+Q
	+CHdaedmVmNRhst4LSD/a982M6cUSgjEgqe5jlI8Q0goDqCOOhC9oRElOekE81XG84/0ux+5wvpGN
	fa/o3m0pmoX+C15wU+s9qQU1kbOinl3Ss3TGufpijuAES6JinmrLWTXTwReE0bNZc7AZYr7uThQX7
	bMuAMeq8EgbOD7eDeX1xhyaZ+UoCtKjjNkufTymilG0jHhbTxR1+x/v0BDX6z/S9W25vij04ANx1H
	CIh+aYMg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA73s-00000006YtI-1VAW;
	Tue, 07 Apr 2026 14:05:48 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Hans Holmberg <hans.holmberg@wdc.com>
Subject: [PATCH 1/5] xfs: fix number of GC bvecs
Date: Tue,  7 Apr 2026 16:05:24 +0200
Message-ID: <20260407140538.633364-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407140538.633364-1-hch@lst.de>
References: <20260407140538.633364-1-hch@lst.de>
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
over-provisioning and generic/256 or generic/361 will now usually fail
when running against the current block tree.

Simplify the allocation to always pass the maximum value that is easier to
verify, as a saving of up to one bvec per allocation isn't worth the
effort to verify a complicated calculated value.

Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 fs/xfs/xfs_zone_gc.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 309f70098524..eebe6f4fee1f 100644
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

