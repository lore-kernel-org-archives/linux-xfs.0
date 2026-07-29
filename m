Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAD2480DF8
	for <linux-xfs@vger.kernel.org>; Wed, 29 Jul 2026 13:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785330183; cv=none; b=Z0qDOYvynLpxeThHmFog4rtEyr0GkqWn6LPGGe3Bk4RzjK+cztUiN0rBXxl3++sZGaDrDiw4jdPeTYBAKrKJq1RxD90/BlRxhjO0KyDdnLk6MifsEoS2SzT6UQ9AE8XeevfG9QxmiltORYPPdDZgGmU/KFjEJSHKs86Q4GEba28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785330183; c=relaxed/simple;
	bh=D9k+IXa7t6AdGrv+EgLo7GipZXpRdHI0S6tYFclbb8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMKd8YlerLgDN3S1hV8804K+T5NfjwV71rbj2n07Ct2exBiR3/AgTguGAa+xUJvSdUQBTgKo735hqgMc5qVmIM0L6YmhzLGE/d4TShuzP1nYVD5KN48opgDlfkabgpYbLZ3Y0zNw2RLsADt/KAcGSeVw9OdL6mdzxJBVNh7To5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B1gaPnoH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B1gaPnoH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=R/jLPrAouamVa/jv25RdKQONVTtZkjLW5eRvxqNJukw=; b=B1gaPnoHo1+kBa/T+vEwOqYWp6
	22pBmotwKanuRLfOoBNOiJUE/j2f/PBUJkEyjf9z7GwRBlDBWaJ+GeXL3pYHQ1BJ0jdZze01Kpd7P
	bYDD271FWbDRQ2Gg3RBl260wfQirEaOLywttF8nYuMF7ouYGbIFOF4d68yMKpGs/Yqc12uvrHYCVt
	hUyXP/Pphp//N4WFDQ2oExszLh4g0g0ECEmvkSEO3pqByp4mV50CvRDYJpYoJVMZrYREXJmsuw/7o
	v6FI6BZA0ezo3UduCLNg8/r6JaDx+3WAW8ui7Ocvc5V4qxyg29H8DI6U4hIu7hov/2/2fHAZmhxQz
	9IDhp5QA==;
Received: from 85-127-110-197.dsl.dynamic.surfer.at ([85.127.110.197] helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wp3w1-00000004Wdu-34cc;
	Wed, 29 Jul 2026 13:02:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 1/2] xfs: add a separate bio_set for spliting GC writes
Date: Wed, 29 Jul 2026 15:02:48 +0200
Message-ID: <20260729130256.2282092-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260729130256.2282092-1-hch@lst.de>
References: <20260729130256.2282092-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Allocating the new bio for a split from the same pool as the original
one can deadlock under memory pressure as the origin bio could be the
last one from the mempool.

Add a separate pool for splitting GC write bios to avoid this.

Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

