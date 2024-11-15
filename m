Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D051E1C0F
	for <linux-xfs@vger.kernel.org>; Fri, 15 Nov 2024 20:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731700832; cv=none; b=gkTu2ktCNGu5jjqzrBgPAN6eTIJW9z4HG+rqtv7dcKoSGh7N/8V0DF+GoJKZBbailyC/ODFY83kaAO76xzGTvKslZVcHBwmMX4djFQy+wsC7B/eOkthHOkYt9BgSNy9jfV5PeTtcB6xc0Zd8zYTSr3A3N+VsSkHs6/vJ1EuFIZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731700832; c=relaxed/simple;
	bh=F4qOIZVk3I5gzPnIcsEx8l+r24HQDhXGOVfaqqhpqR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gLQDGBFGWkbXSIUHc5s8WlKKW7p1/Yiz3vlPId5b3nnF9CrWaBHsVBoJrUgZWXtqSbL7PQCtLf3/GXWqWUEeDzug/lgJoF5/esZCpuycTrg3I69O2SS9ACEPF5ag24xv7mVSfBKozsTpnxOqLZbqbQ5tSvBmrpV+gesNhJ2r6x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fhaeYCTS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fhaeYCTS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731700829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kKMNJ4/x9WaGOxZMAfsms4wNZwr76fM4wXHUOA3gfpk=;
	b=fhaeYCTSXhTULQGh7RNBj+8vEdhSBcSYVH1uCu5Y6xvAXirAb8YU5w9NjQFibjBcSw6iYX
	PjyiVB5k452chm6J2cmCb4PByE3DAfMc2KYqHsN9n1BTg7i4JYECF8s+oiQBlkW5Egc8Cq
	aF/2OcNSC1OeNwFb078m/EkcQPn3bpI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-PexXpOENNwOuA03MGwY3Bw-1; Fri,
 15 Nov 2024 15:00:27 -0500
X-MC-Unique: PexXpOENNwOuA03MGwY3Bw-1
X-Mimecast-MFC-AGG-ID: PexXpOENNwOuA03MGwY3Bw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C3C3195394C;
	Fri, 15 Nov 2024 20:00:25 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BD9D1953882;
	Fri, 15 Nov 2024 20:00:24 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	hch@infradead.org,
	djwong@kernel.org
Subject: [PATCH v4 2/3] iomap: lift zeroed mapping handling into iomap_zero_range()
Date: Fri, 15 Nov 2024 15:01:54 -0500
Message-ID: <20241115200155.593665-3-bfoster@redhat.com>
In-Reply-To: <20241115200155.593665-1-bfoster@redhat.com>
References: <20241115200155.593665-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

In preparation for special handling of subranges, lift the zeroed
mapping logic from the iterator into the caller. Since this puts the
pagecache dirty check and flushing in the same place, streamline the
comments a bit as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 66 +++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ef0b68bccbb6..9c1aa0355c71 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1350,40 +1350,12 @@ static inline int iomap_zero_iter_flush_and_stale(struct iomap_iter *i)
 	return filemap_write_and_wait_range(mapping, i->pos, end);
 }
 
-static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
-		bool *range_dirty)
+static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
-	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
 	loff_t written = 0;
 
-	/*
-	 * We must zero subranges of unwritten mappings that might be dirty in
-	 * pagecache from previous writes. We only know whether the entire range
-	 * was clean or not, however, and dirty folios may have been written
-	 * back or reclaimed at any point after mapping lookup.
-	 *
-	 * The easiest way to deal with this is to flush pagecache to trigger
-	 * any pending unwritten conversions and then grab the updated extents
-	 * from the fs. The flush may change the current mapping, so mark it
-	 * stale for the iterator to remap it for the next pass to handle
-	 * properly.
-	 *
-	 * Note that holes are treated the same as unwritten because zero range
-	 * is (ab)used for partial folio zeroing in some cases. Hole backed
-	 * post-eof ranges can be dirtied via mapped write and the flush
-	 * triggers writeback time post-eof zeroing.
-	 */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) {
-		if (*range_dirty) {
-			*range_dirty = false;
-			return iomap_zero_iter_flush_and_stale(iter);
-		}
-		/* range is clean and already zeroed, nothing to do */
-		return length;
-	}
-
 	do {
 		struct folio *folio;
 		int status;
@@ -1433,24 +1405,34 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 	bool range_dirty;
 
 	/*
-	 * Zero range wants to skip pre-zeroed (i.e. unwritten) mappings, but
-	 * pagecache must be flushed to ensure stale data from previous
-	 * buffered writes is not exposed. A flush is only required for certain
-	 * types of mappings, but checking pagecache after mapping lookup is
-	 * racy with writeback and reclaim.
+	 * Zero range can skip mappings that are zero on disk so long as
+	 * pagecache is clean. If pagecache was dirty prior to zero range, the
+	 * mapping converts on writeback completion and so must be zeroed.
 	 *
-	 * Therefore, check the entire range first and pass along whether any
-	 * part of it is dirty. If so and an underlying mapping warrants it,
-	 * flush the cache at that point. This trades off the occasional false
-	 * positive (and spurious flush, if the dirty data and mapping don't
-	 * happen to overlap) for simplicity in handling a relatively uncommon
-	 * situation.
+	 * The simplest way to deal with this across a range is to flush
+	 * pagecache and process the updated mappings. To avoid an unconditional
+	 * flush, check pagecache state and only flush if dirty and the fs
+	 * returns a mapping that might convert on writeback.
 	 */
 	range_dirty = filemap_range_needs_writeback(inode->i_mapping,
 					pos, pos + len - 1);
+	while ((ret = iomap_iter(&iter, ops)) > 0) {
+		const struct iomap *srcmap = iomap_iter_srcmap(&iter);
 
-	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.processed = iomap_zero_iter(&iter, did_zero, &range_dirty);
+		if (srcmap->type == IOMAP_HOLE ||
+		    srcmap->type == IOMAP_UNWRITTEN) {
+			loff_t proc = iomap_length(&iter);
+
+			if (range_dirty) {
+				range_dirty = false;
+				proc = iomap_zero_iter_flush_and_stale(&iter);
+			}
+			iter.processed = proc;
+			continue;
+		}
+
+		iter.processed = iomap_zero_iter(&iter, did_zero);
+	}
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_zero_range);
-- 
2.47.0

