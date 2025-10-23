Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E18E333457
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 15:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761232636; cv=none; b=h2tWbPOlmmCqze2vu3OFQwQb8bOvPDzqtTiO0cvbCr0xh6IlHFt171enQsNdMmilAOzYpScyuTl/DOxnymb1velmRPUqBkyi2urhaFg+1XH4nzU4hG2gol8ySQhN8NZCjuUqL0zNfnMPEESqTN7GfyhEzS/5iFiHS+nD3J3JrUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761232636; c=relaxed/simple;
	bh=NBYJmHJBE4kqf952lmu9De2aPqrjlSL4iU3OsSCCK8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBdpT8niPFDorV1GrNhuteBSJN17ZSfl/FyWE1+SCgzVKZoptVEb2JNSzmogttiGOBx6R+KoyPSnxbjKxmcXAlBz7NYXvLbvJQn1E3gaFNku00loBVuEd4wCqwQrkSpMGDsQgXha5Z4jHS0pFyWSoLC6SlcgsvRA+6h/wlzNIwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ioXRwY42; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ioXRwY42"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tLCWFUONW4e6FWvUxaSCT57wT/HGECIu+zbvmsHaKNs=; b=ioXRwY42Y9OOfiywwAZqGchCs5
	y4VjIkcry5IJzAXe+yxpEoBQIfTQeiSab14eRfG0z477vrH/H0oc3WWSWtxcFnN/7H69BdDFPbh96
	EV7nLR9UxWLoEaRBpiTPFcJP9lYo9ynyvCH3ogx5xWPb3C+pMVlCB6mZmFdQFofCAyP0QCYh7O+ZM
	/vu+YlbE5r87cVrIukrs2f5B+ANAK2ic8gfHAPCIXMOgBc3k2LFFkK6bh6g7HR/G0KMjRBImYzrGt
	+uHt7xEPJQ4DUoMuvGvHbjpAn9yy0Bpyzgrwb2zGmy/c8da5uWcbsGUyBCm4sXpK6cVib8krgQQVt
	sH0cVWeg==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBx3y-00000006jVH-2EZy;
	Thu, 23 Oct 2025 15:17:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Date: Thu, 23 Oct 2025 17:17:02 +0200
Message-ID: <20251023151706.136479-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023151706.136479-1-hch@lst.de>
References: <20251023151706.136479-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When we are picking a zone for gc it might already be in the pipeline
which can lead to us moving the same data twice resulting in in write
amplification and a very unfortunate case where we keep on garbage
collecting the zone we just filled with migrated data stopping all
forward progress.

Fix this by introducing a count of on-going GC operations on a zone, and
skip any zone with ongoing GC when picking a new victim.

Fixes: 080d01c41 ("xfs: implement zoned garbage collection")
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/libxfs/xfs_rtgroup.h |  6 ++++++
 fs/xfs/xfs_zone_gc.c        | 27 +++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index d36a6ae0abe5..d4fcf591e63d 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -50,6 +50,12 @@ struct xfs_rtgroup {
 		uint8_t			*rtg_rsum_cache;
 		struct xfs_open_zone	*rtg_open_zone;
 	};
+
+	/*
+	 * Count of outstanding GC operations for zoned XFS.  Any RTG with a
+	 * non-zero rtg_gccount will not be picked as new GC victim.
+	 */
+	atomic_t		rtg_gccount;
 };
 
 /*
diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 109877d9a6bf..4ade54445532 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -114,6 +114,8 @@ struct xfs_gc_bio {
 	/* Open Zone being written to */
 	struct xfs_open_zone		*oz;
 
+	struct xfs_rtgroup		*victim_rtg;
+
 	/* Bio used for reads and writes, including the bvec used by it */
 	struct bio_vec			bv;
 	struct bio			bio;	/* must be last */
@@ -264,6 +266,7 @@ xfs_zone_gc_iter_init(
 	iter->rec_count = 0;
 	iter->rec_idx = 0;
 	iter->victim_rtg = victim_rtg;
+	atomic_inc(&victim_rtg->rtg_gccount);
 }
 
 /*
@@ -362,6 +365,7 @@ xfs_zone_gc_query(
 
 	return 0;
 done:
+	atomic_dec(&iter->victim_rtg->rtg_gccount);
 	xfs_rtgroup_rele(iter->victim_rtg);
 	iter->victim_rtg = NULL;
 	return 0;
@@ -451,6 +455,20 @@ xfs_zone_gc_pick_victim_from(
 		if (!rtg)
 			continue;
 
+		/*
+		 * If the zone is already undergoing GC, don't pick it again.
+		 *
+		 * This prevents us from picking one of the zones for which we
+		 * already submitted GC I/O, but for which the remapping hasn't
+		 * concluded yet.  This won't cause data corruption, but
+		 * increases write amplification and slows down GC, so this is
+		 * a bad thing.
+		 */
+		if (atomic_read(&rtg->rtg_gccount)) {
+			xfs_rtgroup_rele(rtg);
+			continue;
+		}
+
 		/* skip zones that are just waiting for a reset */
 		if (rtg_rmap(rtg)->i_used_blocks == 0 ||
 		    rtg_rmap(rtg)->i_used_blocks >= victim_used) {
@@ -688,6 +706,9 @@ xfs_zone_gc_start_chunk(
 	chunk->scratch = &data->scratch[data->scratch_idx];
 	chunk->data = data;
 	chunk->oz = oz;
+	chunk->victim_rtg = iter->victim_rtg;
+	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
+	atomic_inc(&chunk->victim_rtg->rtg_gccount);
 
 	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
 	bio->bi_end_io = xfs_zone_gc_end_io;
@@ -710,6 +731,8 @@ static void
 xfs_zone_gc_free_chunk(
 	struct xfs_gc_bio	*chunk)
 {
+	atomic_dec(&chunk->victim_rtg->rtg_gccount);
+	xfs_rtgroup_rele(chunk->victim_rtg);
 	list_del(&chunk->entry);
 	xfs_open_zone_put(chunk->oz);
 	xfs_irele(chunk->ip);
@@ -770,6 +793,10 @@ xfs_zone_gc_split_write(
 	split_chunk->oz = chunk->oz;
 	atomic_inc(&chunk->oz->oz_ref);
 
+	split_chunk->victim_rtg = chunk->victim_rtg;
+	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
+	atomic_inc(&chunk->victim_rtg->rtg_gccount);
+
 	chunk->offset += split_len;
 	chunk->len -= split_len;
 	chunk->old_startblock += XFS_B_TO_FSB(data->mp, split_len);
-- 
2.47.3

