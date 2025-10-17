Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECD3334689
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 06:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760681242; cv=none; b=RDvldeVQnYnkbaADy63P6r0i8PCS9nlNsI4e5r8/qitDa9Agv6kCKZp6wA5hYu6C+XqghTDwwFbM+yDi6bd11oC/U0fAJQyky1TA772D4f1GquA5L4pD7pvysf6quXSiMoclR31dIzLceA5hBxx764rHLbaSya7XXj6afg2go0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760681242; c=relaxed/simple;
	bh=msASnUSFyKgne9tokam80ycekljTfrzkuHRLCY8wiW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBWIR9d3qieha60AO1iurqPdK9DCP+wRbThZ3bg9bU3VJsefls5V2KXJqZk4XcoQ1hXOGCJS40d7dC8aExStTRrKEeKnLpOiG93LWCVuGqbss5jNpGdfnYcR9R1Q1XZCOrkqeptQSGWLw2Rf9DIfw/szjedC6gIZk6xRpt1w748=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mfm2gEgB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mfm2gEgB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=c9OS5/V3uHw1/uVAVcE70iDlID+YHnhlwrB/cH2wE3s=; b=mfm2gEgBW3+5YKgTSxsGwXH3im
	lBnPp4hLudXFlqPHheHK4EQ/a0nFd5XSXf5Xa3KFx3zgb3/bZYrHh39sS5SLvmJo4dcB+hF5O2925
	d6Msg8WRDuv3bjZ/F12KIHdRAIquAeTp84OY4zeShyVAxo7ng8Y9DbGYSfR/oTtOxY5N4wJ0/OPfg
	v+BZ7Urtm3EHt60cIeEJHa+ZdlZdCGDNx3VQA5cWp6LceTo2/CQmR7TrW9zg4cW3pelwxY2Hi8Llh
	o6r+ziMhj/9/CbBVLTJqhvMyPHRS2eMKMZ/SMMVw/zFDslrD5s7AtF3S+ZMMZtg0iOsarUPghXf19
	b2lIORcQ==;
Received: from 5-226-109-134.static.ip.netia.com.pl ([5.226.109.134] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dcV-00000006hEG-2l5y;
	Fri, 17 Oct 2025 06:07:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Hans Holmberg <hans.holmberg@wdc.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Date: Fri, 17 Oct 2025 08:07:02 +0200
Message-ID: <20251017060710.696868-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251017060710.696868-1-hch@lst.de>
References: <20251017060710.696868-1-hch@lst.de>
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
amplification and a very unfortunate case where keep on garbage
collecting the zone we just filled with migrated data stopping all
forward progress.

Fix this by introducing a count of on-going GC operations on a zone, so
and skip any zone with ongoing GC when picking a new victim.

Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index 109877d9a6bf..efcb52796d05 100644
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
+		 * concluded again.  This won't cause data corruption, but
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

