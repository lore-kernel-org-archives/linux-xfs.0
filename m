Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD8C155330;
	Wed,  1 May 2024 18:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714588885; cv=none; b=Abr4S1B5sRaevX+9k8J3TNZi9iOtPQFfJxlahRIFgZdoVYlb4tu3TDjx6EE9TTdg5xK7XvfO/1sZQsEza4yDn0KTFqxcUs9MntvDYeAEoBaGMcGeLS7eKe5AcBfbjzhzUp9ecrKBBZNvIDbzyxYFMjVrTxq0YhZOSqs3345AclM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714588885; c=relaxed/simple;
	bh=QoVlDW4AZ7bUWVXK9GWOVII4y/bayOMF31eSmAhtxlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5BoYhUkh+I+7e4C1QUYeBkrskotJ7eZiPxHZ7zdodsUhrd3I72RCIDIpJr8QCoKABkH1o0mNCPDJkbEdcVVcYpGrvHuca2wQZCd3YSjqrZuLDGyO6MZnz943CgxGKUFZsZMB46AF5HXbqLnig37vKfin+jDR9mVLIY6M87KXSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BZZ/tz2g; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BZZ/tz2g"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f28bb6d747so6014528b3a.3;
        Wed, 01 May 2024 11:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714588883; x=1715193683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XSmjTtH4oUem2We+rwLTTfLEIZE7iPOqSSQUvJHKAs=;
        b=BZZ/tz2gr/h2eNde3pqHPqSx52IRnybZ1ghbp4kLhawcNaTTtQDu+LdxZO8sjNaTqz
         pN9BWhTd1pwO6NynuDjss6aEtqY0JL4qV6rYKS59Ubifjcira6dOQa+rERYF5jONRqsH
         g/Qc4iFiJJXcQRKun9fDNI809vMviNgnVQamzE3MvmM6/47TU1t1YLygx8y7xCUgAEgw
         9okKDHu5/GDxpDa47ncK8bCUdGdOakn7ZK2oH4Ltg/uCNiVB/E7g3ETqKxlRmQx0VmvL
         8dWqcDZI2DfB/FU8nu6toE6eb8xoO2u/kRd9X/3B1M+qMtHTEDoty8MszS1g3SSFzLXj
         Xhvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714588883; x=1715193683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1XSmjTtH4oUem2We+rwLTTfLEIZE7iPOqSSQUvJHKAs=;
        b=IkBI/kzMfexeH1wL575/8n7PEw+s1SN4uzgsfmxpmuBKd32x8J8W7YDLgIy+NMvsJu
         5rVHJUQwl5X6WqQMx7DAGkFbXZ8wYhlIicfAHrZ+Uas1DIYAFa9I5ec8ppsRWzE/W/CC
         BIPNSsm4MGEKW5G7U1BMT1dirEvdE7nZgvpY77I0PBZDg1mYSKgdUfAt2/5xiNhSJy/V
         ZyV8Fhix0+mk5znIeyRyZE8wukbzxPKA091rqXSNehyUmZ/qEq7YsbmtRhl8ocGW0Xzw
         tSStLaoIrmV2Cx97YWRuefoeZIwjnZ3L2fpLf51kEQlA8nBVwlT18i564+a21QWnA6nU
         XvTA==
X-Gm-Message-State: AOJu0YyMQ6uYY6VZ+AbdGwV7jbN8uE8me27aKDFbiAwy79c7DlyIqsvf
	TYtXyBk0BivC3y/4JUzw3FtVy8Eik1qGvooW4PjUYzvzFVyIvyx8XISrL5w+
X-Google-Smtp-Source: AGHT+IFdKDgevuISlMHrJUjTC+AKLG81F6VnmzJ2WVDBIsFKnQWP2g0ft37cwsiQ+R1kJ31V1452Xw==
X-Received: by 2002:a05:6a00:1786:b0:6ea:f05d:d2e9 with SMTP id s6-20020a056a00178600b006eaf05dd2e9mr4584042pfg.15.1714588882846;
        Wed, 01 May 2024 11:41:22 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:9dbc:724d:6e88:fb08])
        by smtp.gmail.com with ESMTPSA id j18-20020a62e912000000b006e681769ee0sm23687369pfh.145.2024.05.01.11.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 11:41:22 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 07/24] iomap: write iomap validity checks
Date: Wed,  1 May 2024 11:40:55 -0700
Message-ID: <20240501184112.3799035-7-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240501184112.3799035-1-leah.rumancik@gmail.com>
References: <20240501184112.3799035-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit d7b64041164ca177170191d2ad775da074ab2926 ]

A recent multithreaded write data corruption has been uncovered in
the iomap write code. The core of the problem is partial folio
writes can be flushed to disk while a new racing write can map it
and fill the rest of the page:

writeback			new write

allocate blocks
  blocks are unwritten
submit IO
.....
				map blocks
				iomap indicates UNWRITTEN range
				loop {
				  lock folio
				  copyin data
.....
IO completes
  runs unwritten extent conv
    blocks are marked written
				  <iomap now stale>
				  get next folio
				}

Now add memory pressure such that memory reclaim evicts the
partially written folio that has already been written to disk.

When the new write finally gets to the last partial page of the new
write, it does not find it in cache, so it instantiates a new page,
sees the iomap is unwritten, and zeros the part of the page that
it does not have data from. This overwrites the data on disk that
was originally written.

The full description of the corruption mechanism can be found here:

https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/

To solve this problem, we need to check whether the iomap is still
valid after we lock each folio during the write. We have to do it
after we lock the page so that we don't end up with state changes
occurring while we wait for the folio to be locked.

Hence we need a mechanism to be able to check that the cached iomap
is still valid (similar to what we already do in buffered
writeback), and we need a way for ->begin_write to back out and
tell the high level iomap iterator that we need to remap the
remaining write range.

The iomap needs to grow some storage for the validity cookie that
the filesystem provides to travel with the iomap. XFS, in
particular, also needs to know some more information about what the
iomap maps (attribute extents rather than file data extents) to for
the validity cookie to cover all the types of iomaps we might need
to validate.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 29 +++++++++++++++++++++++++++-
 fs/iomap/iter.c        | 19 ++++++++++++++++++-
 include/linux/iomap.h  | 43 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 60bd16f1a23f..dac1a5c110c0 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -579,7 +579,7 @@ static int iomap_write_begin_inline(const struct iomap_iter *iter,
 	return iomap_read_inline_data(iter, folio);
 }
 
-static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
+static int iomap_write_begin(struct iomap_iter *iter, loff_t pos,
 		size_t len, struct folio **foliop)
 {
 	const struct iomap_page_ops *page_ops = iter->iomap.page_ops;
@@ -613,6 +613,27 @@ static int iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 		status = (iter->flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOMEM;
 		goto out_no_page;
 	}
+
+	/*
+	 * Now we have a locked folio, before we do anything with it we need to
+	 * check that the iomap we have cached is not stale. The inode extent
+	 * mapping can change due to concurrent IO in flight (e.g.
+	 * IOMAP_UNWRITTEN state can change and memory reclaim could have
+	 * reclaimed a previously partially written page at this index after IO
+	 * completion before this write reaches this file offset) and hence we
+	 * could do the wrong thing here (zero a page range incorrectly or fail
+	 * to zero) and corrupt data.
+	 */
+	if (page_ops && page_ops->iomap_valid) {
+		bool iomap_valid = page_ops->iomap_valid(iter->inode,
+							&iter->iomap);
+		if (!iomap_valid) {
+			iter->iomap.flags |= IOMAP_F_STALE;
+			status = 0;
+			goto out_unlock;
+		}
+	}
+
 	if (pos + len > folio_pos(folio) + folio_size(folio))
 		len = folio_pos(folio) + folio_size(folio) - pos;
 
@@ -768,6 +789,8 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			break;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		page = folio_file_page(folio, pos >> PAGE_SHIFT);
 		if (mapping_writably_mapped(mapping))
@@ -1076,6 +1099,8 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (unlikely(status))
 			return status;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		status = iomap_write_end(iter, pos, bytes, bytes, folio);
 		if (WARN_ON_ONCE(status == 0))
@@ -1131,6 +1156,8 @@ static loff_t iomap_zero_iter(struct iomap_iter *iter, bool *did_zero)
 		status = iomap_write_begin(iter, pos, bytes, &folio);
 		if (status)
 			return status;
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
 
 		offset = offset_in_folio(folio, pos);
 		if (bytes > folio_size(folio) - offset)
diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index a1c7592d2ade..79a0614eaab7 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -7,12 +7,28 @@
 #include <linux/iomap.h>
 #include "trace.h"
 
+/*
+ * Advance to the next range we need to map.
+ *
+ * If the iomap is marked IOMAP_F_STALE, it means the existing map was not fully
+ * processed - it was aborted because the extent the iomap spanned may have been
+ * changed during the operation. In this case, the iteration behaviour is to
+ * remap the unprocessed range of the iter, and that means we may need to remap
+ * even when we've made no progress (i.e. iter->processed = 0). Hence the
+ * "finished iterating" case needs to distinguish between
+ * (processed = 0) meaning we are done and (processed = 0 && stale) meaning we
+ * need to remap the entire remaining range.
+ */
 static inline int iomap_iter_advance(struct iomap_iter *iter)
 {
+	bool stale = iter->iomap.flags & IOMAP_F_STALE;
+
 	/* handle the previous iteration (if any) */
 	if (iter->iomap.length) {
-		if (iter->processed <= 0)
+		if (iter->processed < 0)
 			return iter->processed;
+		if (!iter->processed && !stale)
+			return 0;
 		if (WARN_ON_ONCE(iter->processed > iomap_length(iter)))
 			return -EIO;
 		iter->pos += iter->processed;
@@ -33,6 +49,7 @@ static inline void iomap_iter_done(struct iomap_iter *iter)
 	WARN_ON_ONCE(iter->iomap.offset > iter->pos);
 	WARN_ON_ONCE(iter->iomap.length == 0);
 	WARN_ON_ONCE(iter->iomap.offset + iter->iomap.length <= iter->pos);
+	WARN_ON_ONCE(iter->iomap.flags & IOMAP_F_STALE);
 
 	trace_iomap_iter_dstmap(iter->inode, &iter->iomap);
 	if (iter->srcmap.type != IOMAP_HOLE)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 0698c4b8ce0e..0983dfc9a203 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -49,26 +49,35 @@ struct vm_fault;
  *
  * IOMAP_F_BUFFER_HEAD indicates that the file system requires the use of
  * buffer heads for this mapping.
+ *
+ * IOMAP_F_XATTR indicates that the iomap is for an extended attribute extent
+ * rather than a file data extent.
  */
-#define IOMAP_F_NEW		0x01
-#define IOMAP_F_DIRTY		0x02
-#define IOMAP_F_SHARED		0x04
-#define IOMAP_F_MERGED		0x08
-#define IOMAP_F_BUFFER_HEAD	0x10
-#define IOMAP_F_ZONE_APPEND	0x20
+#define IOMAP_F_NEW		(1U << 0)
+#define IOMAP_F_DIRTY		(1U << 1)
+#define IOMAP_F_SHARED		(1U << 2)
+#define IOMAP_F_MERGED		(1U << 3)
+#define IOMAP_F_BUFFER_HEAD	(1U << 4)
+#define IOMAP_F_ZONE_APPEND	(1U << 5)
+#define IOMAP_F_XATTR		(1U << 6)
 
 /*
  * Flags set by the core iomap code during operations:
  *
  * IOMAP_F_SIZE_CHANGED indicates to the iomap_end method that the file size
  * has changed as the result of this write operation.
+ *
+ * IOMAP_F_STALE indicates that the iomap is not valid any longer and the file
+ * range it covers needs to be remapped by the high level before the operation
+ * can proceed.
  */
-#define IOMAP_F_SIZE_CHANGED	0x100
+#define IOMAP_F_SIZE_CHANGED	(1U << 8)
+#define IOMAP_F_STALE		(1U << 9)
 
 /*
  * Flags from 0x1000 up are for file system specific usage:
  */
-#define IOMAP_F_PRIVATE		0x1000
+#define IOMAP_F_PRIVATE		(1U << 12)
 
 
 /*
@@ -89,6 +98,7 @@ struct iomap {
 	void			*inline_data;
 	void			*private; /* filesystem private */
 	const struct iomap_page_ops *page_ops;
+	u64			validity_cookie; /* used with .iomap_valid() */
 };
 
 static inline sector_t iomap_sector(const struct iomap *iomap, loff_t pos)
@@ -128,6 +138,23 @@ struct iomap_page_ops {
 	int (*page_prepare)(struct inode *inode, loff_t pos, unsigned len);
 	void (*page_done)(struct inode *inode, loff_t pos, unsigned copied,
 			struct page *page);
+
+	/*
+	 * Check that the cached iomap still maps correctly to the filesystem's
+	 * internal extent map. FS internal extent maps can change while iomap
+	 * is iterating a cached iomap, so this hook allows iomap to detect that
+	 * the iomap needs to be refreshed during a long running write
+	 * operation.
+	 *
+	 * The filesystem can store internal state (e.g. a sequence number) in
+	 * iomap->validity_cookie when the iomap is first mapped to be able to
+	 * detect changes between mapping time and whenever .iomap_valid() is
+	 * called.
+	 *
+	 * This is called with the folio over the specified file position held
+	 * locked by the iomap code.
+	 */
+	bool (*iomap_valid)(struct inode *inode, const struct iomap *iomap);
 };
 
 /*
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog

