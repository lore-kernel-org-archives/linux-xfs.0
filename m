Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577421B2EF7
	for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2024 14:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725029744; cv=none; b=Nv32bzgAb5SeuaTjEBP//ZcpDFmOW1+RcEEuW2JbM2NXbq7LTM+VbtVyjWtZPlzmCX1PSEu0qrprxy/NFHkw2sOtSOGIFtPPaoqHALRAMv5Wm9jMo7Vvb9+A7HINGNBNZu9pkOZYTnXflG1KqTBJj2r1LB+a2wUr488twWSdZpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725029744; c=relaxed/simple;
	bh=Sim23GsykPo8oEnVnMADH2f5Uy7gDj8aPFtqshqfpSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qp/fhxjnC/wrBsEssA+8EsWBudvhqV5d/47+2sMgWyE9NXaEZqyBDQIMUdwcVQ7+06O+4oLGo2uIGyjNldNuApwb9m5nHdbAbzjU+i/1RrgINF1+xBw0jcjukLRfy0xGnt7mkP0cjVdmUYRsmaOjdr1pZhRtF3AN3UKM8fUzq08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FF+2Svix; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FF+2Svix"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725029741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DgkPQX0M24PaUalwTPazBb2RMlrdmVmBYV+5swHHgTw=;
	b=FF+2SvixbQOAHpUYbKMtEBimzd9NCxdrffIyDfn/WoqcGN564zA1WEaOp1VzUcvULwQ890
	x3MAh9PAQvCFfYDygKoNfdnLKSF+t5431H2bIABpfGu5jN7Bm8bPkUvdxC19K+YLnD8Lwn
	egmfmlOG6sJQUCyVG18CwDXY6FjRXCQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-g-wIInIwPbKkhwHKDPAvwg-1; Fri,
 30 Aug 2024 10:55:38 -0400
X-MC-Unique: g-wIInIwPbKkhwHKDPAvwg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4BF91955D48;
	Fri, 30 Aug 2024 14:55:36 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.95])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C483519560AA;
	Fri, 30 Aug 2024 14:55:35 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	josef@toxicpanda.com,
	david@fromorbit.com
Subject: [PATCH v3 2/2] iomap: make zero range flush conditional on unwritten mappings
Date: Fri, 30 Aug 2024 10:56:34 -0400
Message-ID: <20240830145634.138439-3-bfoster@redhat.com>
In-Reply-To: <20240830145634.138439-1-bfoster@redhat.com>
References: <20240830145634.138439-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

iomap_zero_range() flushes pagecache to mitigate consistency
problems with dirty pagecache and unwritten mappings. The flush is
unconditional over the entire range because checking pagecache state
after mapping lookup is racy with writeback and reclaim. There are
ways around this using iomap's mapping revalidation mechanism, but
this is not supported by all iomap based filesystems and so is not a
generic solution.

There is another way around this limitation that is good enough to
filter the flush for most cases in practice. If we check for dirty
pagecache over the target range (instead of unconditionally flush),
we can keep track of whether the range was dirty before lookup and
defer the flush until/unless we see a combination of dirty cache
backed by an unwritten mapping. We don't necessarily know whether
the dirty cache was backed by the unwritten maping or some other
(written) part of the range, but the impliciation of a false
positive here is a spurious flush and thus relatively harmless.

Note that we also flush for hole mappings because iomap_zero_range()
is used for partial folio zeroing in some cases. For example, if a
folio straddles EOF on a sub-page FSB size fs, the post-eof portion
is hole-backed and dirtied/written via mapped write, and then i_size
increases before writeback can occur (which otherwise zeroes the
post-eof portion of the EOF folio), then the folio becomes
inconsistent with disk until reclaimed. A flush in this case
executes partial zeroing from writeback, and iomap knows that there
is otherwise no I/O to submit for hole backed mappings.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/iomap/buffered-io.c | 63 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 54 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 3e846f43ff48..1ace16181ecf 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1393,16 +1393,53 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 }
 EXPORT_SYMBOL_GPL(iomap_file_unshare);
 
-static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
+/*
+ * Flush the remaining range of the iter and mark the current mapping stale.
+ * This is used when zero range sees an unwritten mapping that may have had
+ * dirty pagecache over it.
+ */
+static inline int iomap_zero_iter_flush_and_stale(struct iomap_iter *i)
+{
+	struct address_space *mapping = i->inode->i_mapping;
+	loff_t end = i->pos + i->len - 1;
+
+	i->iomap.flags |= IOMAP_F_STALE;
+	return filemap_write_and_wait_range(mapping, i->pos, end);
+}
+
+static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
+		bool *range_dirty)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
 	loff_t written = 0;
 
-	/* already zeroed?  we're done. */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
+	/*
+	 * We must zero subranges of unwritten mappings that might be dirty in
+	 * pagecache from previous writes. We only know whether the entire range
+	 * was clean or not, however, and dirty folios may have been written
+	 * back or reclaimed at any point after mapping lookup.
+	 *
+	 * The easiest way to deal with this is to flush pagecache to trigger
+	 * any pending unwritten conversions and then grab the updated extents
+	 * from the fs. The flush may change the current mapping, so mark it
+	 * stale for the iterator to remap it for the next pass to handle
+	 * properly.
+	 *
+	 * Note that holes are treated the same as unwritten because zero range
+	 * is (ab)used for partial folio zeroing in some cases. Hole backed
+	 * post-eof ranges can be dirtied via mapped write and the flush
+	 * triggers writeback time post-eof zeroing.
+	 */
+	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) {
+		if (*range_dirty) {
+			*range_dirty = false;
+			return iomap_zero_iter_flush_and_stale(iter);
+		}
+		/* range is clean and already zeroed, nothing to do */
 		return length;
+	}
 
 	do {
 		struct folio *folio;
@@ -1450,19 +1487,27 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		.flags		= IOMAP_ZERO,
 	};
 	int ret;
+	bool range_dirty;
 
 	/*
 	 * Zero range wants to skip pre-zeroed (i.e. unwritten) mappings, but
 	 * pagecache must be flushed to ensure stale data from previous
-	 * buffered writes is not exposed.
+	 * buffered writes is not exposed. A flush is only required for certain
+	 * types of mappings, but checking pagecache after mapping lookup is
+	 * racy with writeback and reclaim.
+	 *
+	 * Therefore, check the entire range first and pass along whether any
+	 * part of it is dirty. If so and an underlying mapping warrants it,
+	 * flush the cache at that point. This trades off the occasional false
+	 * positive (and spurious flush, if the dirty data and mapping don't
+	 * happen to overlap) for simplicity in handling a relatively uncommon
+	 * situation.
 	 */
-	ret = filemap_write_and_wait_range(inode->i_mapping,
-			pos, pos + len - 1);
-	if (ret)
-		return ret;
+	range_dirty = filemap_range_needs_writeback(inode->i_mapping,
+					pos, pos + len - 1);
 
 	while ((ret = iomap_iter(&iter, ops)) > 0)
-		iter.processed = iomap_zero_iter(&iter, did_zero);
+		iter.processed = iomap_zero_iter(&iter, did_zero, &range_dirty);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(iomap_zero_range);
-- 
2.45.0

