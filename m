Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2652613D281
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 13:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307697; cv=none; b=GgL//sjv4LOkftPQtiR5mVe87z4a4zahEZRH4Bcp1KPSdYY7NTUZhj/GA/tvvvxreXrlFGEiBoiRXYycQ05rOn+CStSgZI1SPxzXaltR56B6a6CVDirXyyR+is4vca0aqVn/tweeR01TksZabQfQx+mEUnUzH6ZkdIvKnJs1lgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307697; c=relaxed/simple;
	bh=R0ttCVkJiqg1sJadYviwHgpVplEYAU31EcY4SLeC6Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gUBA2loJrHvhB0ScAS9wWBzn5TN1obK037cn5//gbBpiWT6r8UIrFwbqY4Q0qqMll8pEiIrqD3x5OdWhy33UfNDmCNKv1PMrvm6l748V5M3erwkEqaEVe1imrHH+FME1cqH1Q4WymDyuElWkGHPeF5yme52r1kjbVoxKo+VheyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Twh4v449; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Twh4v449"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721307695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bx5WayJveBqE7cRKQVT93Q4qPgEATb10VO9hHxn66JQ=;
	b=Twh4v449LUeCGfGWtkMywqLBb9JMDbqrn2cat+1dQklT6HGWN5yhS8rq+vwrKJJJy6Xmdt
	f1fXigI4XfYdtvfJXFeZzc+c+X5od+YG0CHcHCuFIMCnVbvRX7knntOfx/D9W718KbV05W
	iCUHv6WWT80VF3O5G0wMK8bypfaTUa4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-505-6HTZOMWZN3qNicmmPh7_1Q-1; Thu,
 18 Jul 2024 09:01:31 -0400
X-MC-Unique: 6HTZOMWZN3qNicmmPh7_1Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8B781955F06;
	Thu, 18 Jul 2024 13:01:30 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.39])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A137519560B2;
	Thu, 18 Jul 2024 13:01:29 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] iomap: fix handling of dirty folios over unwritten extents
Date: Thu, 18 Jul 2024 09:02:11 -0400
Message-ID: <20240718130212.23905-4-bfoster@redhat.com>
In-Reply-To: <20240718130212.23905-1-bfoster@redhat.com>
References: <20240718130212.23905-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

iomap_zero_range() does not correctly handle unwritten mappings with
dirty folios in pagecache. It skips unwritten mappings
unconditionally as if they were already zeroed, and thus potentially
exposes stale data from a previous write if affected folios are not
written back before the zero range.

Most callers already flush the target range of the zero for
unrelated, context specific reasons, so this problem is not
necessarily prevalent. The known outliers (in XFS) are file
extension via buffered write and truncate. The truncate path issues
a flush to work around this iomap problem, but the file extension
path does not and thus can expose stale data if current EOF is
unaligned and has a dirty folio over an unwritten block.

This patch implements a mechanism for making zero range pagecache
aware for filesystems that support mapping validation (i.e.
folio_ops->iomap_valid()). Instead of just skipping unwritten
mappings, scan the corresponding pagecache range for dirty or
writeback folios. If found, explicitly zero them via buffered write.
Clean or uncached subranges of unwritten mappings are skipped, as
before.

The quirk with a post-iomap_begin() pagecache scan is that it is
racy with writeback and reclaim activity. Even if the higher level
code holds the invalidate lock, nothing prevents a dirty folio from
being written back, cleaned, and even reclaimed sometime after
iomap_begin() returns an unwritten map but before a pagecache scan
might find the dirty folio. To handle this situation, we can rely on
the fact that writeback completion converts unwritten extents in the
fs before writeback state is cleared on the folio.

This means that a pagecache scan followed by a mapping revalidate of
an unwritten mapping should either find a dirty folio if it exists,
or detect a mapping change if a dirty folio did exist and had been
cleaned sometime before the scan but after the unwritten mapping was
found. If the revalidation succeeds then we can safely assume
nothing has been written back and skip the range. If the
revalidation fails then we must assume any offset in the range could
have been modified by writeback. In other words, we must be
particularly careful to make sure that any uncached range we intend
to skip does not make it into iter.processed until the mapping is
revalidated.

Altogether, this allows zero range to handle dirty folios over
unwritten extents without needing to flush and wait for writeback
completion.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 53 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a9425170df72..ea1d396ef445 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1385,6 +1385,23 @@ iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 }
 EXPORT_SYMBOL_GPL(iomap_file_unshare);
 
+/*
+ * Scan an unwritten mapping for dirty pagecache and return the length of the
+ * clean or uncached range leading up to it. This is the range that zeroing may
+ * skip once the mapping is validated.
+ */
+static inline loff_t
+iomap_zero_iter_unwritten(struct iomap_iter *iter, loff_t pos, loff_t length)
+{
+	struct address_space *mapping = iter->inode->i_mapping;
+	loff_t fpos = pos;
+
+	if (!filemap_range_has_writeback(mapping, &fpos, length))
+		return length;
+	/* fpos can be smaller if the start folio is dirty */
+	return max(fpos, pos) - pos;
+}
+
 static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
@@ -1393,16 +1410,46 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 	loff_t written = 0;
 
 	/* already zeroed?  we're done. */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)
+	if (srcmap->type == IOMAP_HOLE)
 		return length;
 
 	do {
 		struct folio *folio;
 		int status;
 		size_t offset;
-		size_t bytes = min_t(u64, SIZE_MAX, length);
+		size_t bytes;
+		loff_t pending = 0;
 		bool ret;
 
+		/*
+		 * Determine the range of the unwritten mapping that is clean in
+		 * pagecache. We can skip this range, but only if the mapping is
+		 * still valid after the pagecache scan. This is because
+		 * writeback may have cleaned folios after the mapping lookup
+		 * but before we were able to find them here. If that occurs,
+		 * then the mapping must now be stale and we must reprocess the
+		 * range.
+		 */
+		if (srcmap->type == IOMAP_UNWRITTEN) {
+			pending = iomap_zero_iter_unwritten(iter, pos, length);
+			if (pending == length) {
+				/* no dirty cache, revalidate and bounce as we're
+				 * either done or the mapping is stale */
+				if (iomap_revalidate(iter))
+					written += pending;
+				break;
+			}
+
+			/*
+			 * Found a dirty folio. Update pos/length to point at
+			 * it. written is updated only after the mapping is
+			 * revalidated by iomap_write_begin().
+			 */
+			pos += pending;
+			length -= pending;
+		}
+
+		bytes = min_t(u64, SIZE_MAX, length);
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (status)
 			return status;
@@ -1422,7 +1469,7 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 
 		pos += bytes;
 		length -= bytes;
-		written += bytes;
+		written += bytes + pending;
 	} while (length > 0);
 
 	if (did_zero)
-- 
2.45.0

