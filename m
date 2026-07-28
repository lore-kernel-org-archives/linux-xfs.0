Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CC13D6CC5
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 08:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785226019; cv=none; b=KMiJ3QyETWCo3f5fhAA1MVQamVGmGA6wqHtLDQbHX8nUPjHS/axPRETeGpJ41hnDHX+ZeBLM38kSZKWJ3JOgyygFHb4G48V4bhWZDqAQG0ynU9DPqeIJHAqn9sU5nHEgyD84fQtCJBY82O75F8sXV98eP7x5CxoSueXo8yCQyKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785226019; c=relaxed/simple;
	bh=AvQ4dJeNTHug+vQMu1OLVShoku2tDJXcSPTVqpCy0zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqKJiTFB7bRCMEsVs18dTn9eFVVIs7DTp57+GKq/+DWyL2fAfCn0/Al4s9ZsTZeWapP+tj3yfxdJRxnV50PicB2hBbIfhK2SIfqlw8Cw2Ec+Gc4b/gK2HR59Zo+UrpRauX3tsqUGS+Wbm7qG2KqzgDJShWcm67zyAkQCPsNn5iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v8bc09WS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v8bc09WS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=L19GQxni5XOuohZ9xMtQWLunIHIRW7X7meIrkS6Qugw=; b=v8bc09WSz+J8XzsncKw97qXbFa
	9Z6yaNWY+iOMDdzUrkPrwlDtI3JYa7beEBQOc+uXdi5MKN5EU8pl6HIhdvxuGTO6li17vGRNxrTZx
	E2qC+zUVHWKHEVru0+m1w/OWpO05tJlW3Xj/JG2uqAyTpEkM0l7xn1CtbYiy3vsYIge/+vwfuh2iJ
	30bPqHhCA94CuI7Z/ti0BpI6xFHoXIaDX9657VzMAQTESYiwrftsiFXwLnU7U0v7Wyz4FZ9FXR33i
	HY0ItPkYbbFpW+jXJovHiFktJC+XX025tEXM9CT1y+EHoZzaKdKLJoCtGn7TwcwVOh01dTjRjd9jj
	+Jy2B2MQ==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wocpz-00000004g4j-2fIE;
	Tue, 28 Jul 2026 08:06:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: add a separate bio_set for spliting GC writes
Date: Tue, 28 Jul 2026 10:06:44 +0200
Message-ID: <20260728080650.1777545-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728080650.1777545-1-hch@lst.de>
References: <20260728080650.1777545-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Allocating the new bio for a split from the same pool as the original
one can deadlock under memory pressure.  Add a separate pool for
splitting GC write bios to avoid this.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index f76a09130852..e4f70e024632 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -130,6 +130,9 @@ struct xfs_zone_gc_data {
 	/* bioset used to allocate the gc_bios */
 	struct bio_set			bio_set;
 
+	/* bioset used when writes need to be split to hardware limits */
+	struct bio_set			split_bio_set;
+
 	/*
 	 * Scratchpad to buffer GC data, organized as a ring buffer over
 	 * discontiguous folios.  scratch_head is where the buffer is filled,
@@ -221,6 +224,9 @@ xfs_zone_gc_data_alloc(
 	if (bioset_init(&data->bio_set, 16, offsetof(struct xfs_gc_bio, bio),
 			BIOSET_NEED_BVECS))
 		goto out_free_recs;
+	if (bioset_init(&data->split_bio_set, 16,
+			offsetof(struct xfs_gc_bio, bio), 0))
+		goto out_exit_bio_set;
 	for (i = 0; i < XFS_GC_NR_BUFS; i++) {
 		data->scratch_folios[i] =
 			folio_alloc(GFP_KERNEL, get_order(XFS_GC_BUF_SIZE));
@@ -238,6 +244,8 @@ xfs_zone_gc_data_alloc(
 out_free_scratch:
 	while (--i >= 0)
 		folio_put(data->scratch_folios[i]);
+	bioset_exit(&data->split_bio_set);
+out_exit_bio_set:
 	bioset_exit(&data->bio_set);
 out_free_recs:
 	kfree(data->iter.recs);
@@ -254,6 +262,7 @@ xfs_zone_gc_data_free(
 
 	for (i = 0; i < XFS_GC_NR_BUFS; i++)
 		folio_put(data->scratch_folios[i]);
+	bioset_exit(&data->split_bio_set);
 	bioset_exit(&data->bio_set);
 	kfree(data->iter.recs);
 	kfree(data);
@@ -810,7 +819,8 @@ xfs_zone_gc_split_write(
 			data->mp->m_sb.sb_blocksize) >> SECTOR_SHIFT;
 	split_len = split_sectors << SECTOR_SHIFT;
 
-	split = bio_split(&chunk->bio, split_sectors, GFP_NOFS, &data->bio_set);
+	split = bio_split(&chunk->bio, split_sectors, GFP_NOFS,
+			&data->split_bio_set);
 	split_chunk = container_of(split, struct xfs_gc_bio, bio);
 	split_chunk->data = data;
 	ihold(VFS_I(chunk->ip));
-- 
2.53.0

