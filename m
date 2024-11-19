Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA911CF2A6
	for <linux-xfs@vger.kernel.org>; Tue, 19 Nov 2024 15:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732031131; cv=none; b=WZ6HJIZCMXYRIDrPujN7xgG5qEUDblXg8aTd4ur4Bzs9+7OQt0htCzMpqXxsEtLwdyo2j9SZfq/FUv4LlEP+de6XcNoGE7XZnNocdcHKBdik7CgrqJXcUryUZuvJYWmXCqS+guuJz3stkgj3111Yi5DDl+Ambr04WkHgCvkt3fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732031131; c=relaxed/simple;
	bh=kJvpJZ2rB/n1fbKdG94ZaOzMLFaxvHxVYfCJhvP4wIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+6j13SdxEWiGeWaaerI5V5uCRWtKZHy6zX6uDX2a9/Lr1Y8wQbyBklvNm7BQQ66C2NR+CgSmBEZ6c4k5ryL4TbGEQ6OlnAnLw6vPdlD+GYBeBPQsye4+59A0DFBpW4AJTqyH5jRJR3sG0K464RErMzbDMy/Ll7yjQmf2H6uQsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SEd98ZWI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SEd98ZWI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732031126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bHqlysNI/yd9h9n6zI5JWgrvL8hrKLdDCdZulMRML+I=;
	b=SEd98ZWIsg8pX/XCWOh+NTHAVa54WyiPhuVW5vUMTQkij/2pqUdhVOVjXxGWRjEeNfbdgn
	tLSeleytmzs4ok9SByBYVnHWufHzU0yvMIQLA1C8l6+IdROES/QPTFZ0KpZj9IuHVIxgQ2
	hCr8BTxpHzwvqxW4YC/CEL1jqKjcf5g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-50-D1EBFa-LMOGKNfeK6OjVTw-1; Tue,
 19 Nov 2024 10:45:25 -0500
X-MC-Unique: D1EBFa-LMOGKNfeK6OjVTw-1
X-Mimecast-MFC-AGG-ID: D1EBFa-LMOGKNfeK6OjVTw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E2D119560AA;
	Tue, 19 Nov 2024 15:45:24 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.80.120])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 979AE1956054;
	Tue, 19 Nov 2024 15:45:23 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH RFC 2/4] iomap: optional zero range dirty folio processing
Date: Tue, 19 Nov 2024 10:46:54 -0500
Message-ID: <20241119154656.774395-3-bfoster@redhat.com>
In-Reply-To: <20241119154656.774395-1-bfoster@redhat.com>
References: <20241119154656.774395-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

The only way zero range can currently process unwritten mappings
with dirty pagecache is to check whether the range is dirty before
mapping lookup and then flush when at least one underlying mapping
is unwritten. This ordering is required to prevent iomap lookup from
racing with folio writeback and reclaim.

Since zero range can skip ranges of unwritten mappings that are
clean in cache, this operation can be improved by allowing the
filesystem to provide the set of folios backed by such mappings that
require zeroing up. In turn, rather than flush or iterate file
offsets, zero range can process each folio as normal and skip any
clean or uncached ranges in between.

As a first pass prototype solution, stuff a folio_batch in struct
iomap, provide a helper that the fs can use to populate the batch at
lookup time, and define a flag to indicate the mapping was checked.
Note that since the helper is intended for use under internal fs
locks, it trylocks folios in order to filter out clean folios. This
loosely follows the logic from filemap_range_has_writeback().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/iomap/buffered-io.c | 73 ++++++++++++++++++++++++++++++++++++++++--
 fs/iomap/iter.c        |  2 ++
 include/linux/iomap.h  |  5 +++
 3 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d1a86aea1a7a..6ed8dc8dcdd9 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1363,6 +1363,10 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 	loff_t pos = iter->pos;
 	loff_t length = iomap_length(iter);
 	loff_t written = 0;
+	bool has_folios = !!(iter->iomap.flags & IOMAP_F_HAS_FOLIOS);
+
+	if (WARN_ON_ONCE(has_folios && srcmap->type != IOMAP_UNWRITTEN))
+		return -EIO;
 
 	/*
 	 * We must zero subranges of unwritten mappings that might be dirty in
@@ -1381,7 +1385,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 	 * post-eof ranges can be dirtied via mapped write and the flush
 	 * triggers writeback time post-eof zeroing.
 	 */
-	if (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN) {
+	if (!has_folios &&
+	    (srcmap->type == IOMAP_HOLE || srcmap->type == IOMAP_UNWRITTEN)) {
 		if (*range_dirty) {
 			*range_dirty = false;
 			return iomap_zero_iter_flush_and_stale(iter);
@@ -1395,8 +1400,28 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 		int status;
 		size_t offset;
 		size_t bytes = min_t(u64, SIZE_MAX, length);
+		size_t skipped = 0;
 		bool ret;
 
+		if (has_folios) {
+			folio = folio_batch_next(&iter->iomap.fbatch);
+			if (!folio) {
+				written += length;
+				break;
+			}
+			folio_get(folio);
+			folio_lock(folio);
+			if (pos < folio_pos(folio)) {
+				skipped = folio_pos(folio) - pos;
+				if (WARN_ON_ONCE(skipped >= length))
+					break;
+				pos += skipped;
+				length -= skipped;
+				bytes = min_t(u64, SIZE_MAX, length);
+			} else
+				WARN_ON_ONCE(pos >= folio_pos(folio) + folio_size(folio));
+		}
+
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (status)
 			return status;
@@ -1417,7 +1442,7 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 
 		pos += bytes;
 		length -= bytes;
-		written += bytes;
+		written += bytes + skipped;
 	} while (length > 0);
 
 	if (did_zero)
@@ -1425,6 +1450,50 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
 	return written;
 }
 
+loff_t
+iomap_fill_dirty_folios(
+	struct inode		*inode,
+	struct iomap		*iomap,
+	loff_t			offset,
+	loff_t			length)
+{
+	struct address_space	*mapping = inode->i_mapping;
+	struct folio_batch	fbatch;
+	pgoff_t			start, end;
+	loff_t			end_pos;
+
+	folio_batch_init(&fbatch);
+	folio_batch_init(&iomap->fbatch);
+
+	end_pos = offset + length;
+	start = offset >> PAGE_SHIFT;
+	end = (end_pos - 1) >> PAGE_SHIFT;
+
+	while (filemap_get_folios(mapping, &start, end, &fbatch) &&
+	       folio_batch_space(&iomap->fbatch)) {
+		struct folio *folio;
+		while ((folio = folio_batch_next(&fbatch))) {
+			if (folio_trylock(folio)) {
+				bool clean = !folio_test_dirty(folio) &&
+					     !folio_test_writeback(folio);
+				folio_unlock(folio);
+				if (clean)
+					continue;
+			}
+
+			folio_get(folio);
+			if (!folio_batch_add(&iomap->fbatch, folio)) {
+				end_pos = folio_pos(folio) + folio_size(folio);
+				break;
+			}
+		}
+		folio_batch_release(&fbatch);
+	}
+
+	return end_pos;
+}
+EXPORT_SYMBOL_GPL(iomap_fill_dirty_folios);
+
 int
 iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 		const struct iomap_ops *ops)
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index 79a0614eaab7..3c87b5c2b1d9 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -25,6 +25,8 @@ static inline int iomap_iter_advance(struct iomap_iter *iter)
 
 	/* handle the previous iteration (if any) */
 	if (iter->iomap.length) {
+		if (iter->iomap.flags & IOMAP_F_HAS_FOLIOS)
+			folio_batch_release(&iter->iomap.fbatch);
 		if (iter->processed < 0)
 			return iter->processed;
 		if (!iter->processed && !stale)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 27048ec10e1c..7e9d86c3defa 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/mm_types.h>
 #include <linux/blkdev.h>
+#include <linux/pagevec.h>
 
 struct address_space;
 struct fiemap_extent_info;
@@ -77,6 +78,7 @@ struct vm_fault;
  */
 #define IOMAP_F_SIZE_CHANGED	(1U << 8)
 #define IOMAP_F_STALE		(1U << 9)
+#define IOMAP_F_HAS_FOLIOS	(1U << 10)
 
 /*
  * Flags from 0x1000 up are for file system specific usage:
@@ -102,6 +104,7 @@ struct iomap {
 	void			*inline_data;
 	void			*private; /* filesystem private */
 	const struct iomap_folio_ops *folio_ops;
+	struct folio_batch	fbatch;
 	u64			validity_cookie; /* used with .iomap_valid() */
 };
 
@@ -301,6 +304,8 @@ void iomap_invalidate_folio(struct folio *folio, size_t offset, size_t len);
 bool iomap_dirty_folio(struct address_space *mapping, struct folio *folio);
 int iomap_file_unshare(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
+loff_t iomap_fill_dirty_folios(struct inode *inode, struct iomap *iomap,
+		loff_t offset, loff_t length);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
 		bool *did_zero, const struct iomap_ops *ops);
 int iomap_truncate_page(struct inode *inode, loff_t pos, bool *did_zero,
-- 
2.47.0

