Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24871A0728;
	Thu, 19 Mar 2026 17:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939778; cv=none; b=b1qVTls0m1IB7J2G5z4739vWDwBIN61T+v7SwLrLXLzrI6g0RyfUeoe2nZU2W/hO0zFGPYQP0GR/VemPvQChrjBu7VkHjdfqmdqUPgBX8i1vFedRsIphbINeUdAZBq+OT678NpFcRzIqIOC2ogct76yWwUrVWQPpidFzfqz9Jgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939778; c=relaxed/simple;
	bh=/KyyQpUCy8P4vlPNAPcDv3/5gJAVOfqGcmPf/jxigwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KTalSLHHPydFnVBOQmZ6kr+v3cgwvWIvWOySN+UaD2fXJ54gsT/tXFSSVNaTA2+eZrsQEP4HBgXdakRWOWRQK890eKDLnHT69Qolhn/6zt3O1cwfjJA2HD1gHK0Wqyrjn0d87WYetfVbrHewYZ0kDYwLbp8uwrKwnKI5z6uhJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFXWgNmw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFXWgNmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549D8C19425;
	Thu, 19 Mar 2026 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773939778;
	bh=/KyyQpUCy8P4vlPNAPcDv3/5gJAVOfqGcmPf/jxigwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nFXWgNmwlxmzx19/18jyVcIs8wiRZiyLAREPu4rQjmwGunVGE78BkHOhyu5iHFctl
	 E9n6NyzupRaKHkzaKXUsXLMgMyjRLl9a1+zO8zeus/0ipRhB62DJxI2jTvxXJlS9nd
	 JIgDyVyLrtvmyewqrWIJWOzIHJ//FWibuYr056qaTVsfKRNgo3ZzxVjwHt6pcJaNOO
	 EBSA/1tZmBuMrJ/DQFCptefYu6rYmUlDpe/KS7kCXhfQsVzT4UiaFRKq687dPQ9y7o
	 V2UuPzaW8EOV4c4MEbekg0ylnKJ3X4KLlSqcjjVSbEv6j3AIfywFyLFNivTVGD8ajL
	 PiYmPDbVYSHfA==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>,
	hch@lst.de,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org,
	djwong@kernel.org
Subject: [PATCH v5 07/25] iomap: introduce IOMAP_F_FSVERITY and teach writeback to handle fsverity
Date: Thu, 19 Mar 2026 18:01:54 +0100
Message-ID: <20260319170231.1455553-8-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260319170231.1455553-1-aalbersh@kernel.org>
References: <20260319170231.1455553-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag indicates that I/O is for fsverity metadata.

In the write path skip i_size check and i_size updates as metadata is
past EOF. In writeback don't update i_size and continue writeback if
even folio is beyond EOF. In read path don't zero fsverity folios, again
they are past EOF.

The iomap_block_needs_zeroing() is also called from write path. For
folios of larger order we don't want to zero out pages in the folio as
these could contain other merkle tree blocks. For fsverity, filesystem
will request to read PAGE_SIZE memory regions. For data folios, iomap
will zero the rest of the folio for anything which is beyond EOF. We
don't want this for fsverity folios.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 33 ++++++++++++++++++++++++---------
 fs/iomap/trace.h       |  3 ++-
 include/linux/iomap.h  |  5 +++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 3cf93ab2e38a..6d17858ffaae 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -353,9 +353,16 @@ static inline bool iomap_block_needs_zeroing(const struct iomap_iter *iter,
 {
 	const struct iomap *srcmap = iomap_iter_srcmap(iter);
 
-	return srcmap->type != IOMAP_MAPPED ||
-		(srcmap->flags & IOMAP_F_NEW) ||
-		pos >= i_size_read(iter->inode);
+	if (srcmap->type != IOMAP_MAPPED)
+		return true;
+
+	if (srcmap->flags & IOMAP_F_NEW)
+		return true;
+
+	if (srcmap->flags & IOMAP_F_FSVERITY)
+		return false;
+
+	return pos >= i_size_read(iter->inode);
 }
 
 /**
@@ -1162,13 +1169,14 @@ static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		 * unlock and release the folio.
 		 */
 		old_size = iter->inode->i_size;
-		if (pos + written > old_size) {
+		if (pos + written > old_size &&
+		    !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
 			i_size_write(iter->inode, pos + written);
 			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		}
 		__iomap_put_folio(iter, write_ops, written, folio);
 
-		if (old_size < pos)
+		if (old_size < pos && !(iter->iomap.flags & IOMAP_F_FSVERITY))
 			pagecache_isize_extended(iter->inode, old_size, pos);
 
 		cond_resched();
@@ -1796,13 +1804,20 @@ static int iomap_writeback_range(struct iomap_writepage_ctx *wpc,
  * Check interaction of the folio with the file end.
  *
  * If the folio is entirely beyond i_size, return false.  If it straddles
- * i_size, adjust end_pos and zero all data beyond i_size.
+ * i_size, adjust end_pos and zero all data beyond i_size. Don't skip fsverity
+ * folios as those are beyond i_size.
  */
-static bool iomap_writeback_handle_eof(struct folio *folio, struct inode *inode,
-		u64 *end_pos)
+static bool iomap_writeback_handle_eof(struct folio *folio,
+		struct iomap_writepage_ctx *wpc, u64 *end_pos)
 {
+	struct inode *inode = wpc->inode;
 	u64 isize = i_size_read(inode);
 
+	if (wpc->iomap.flags & IOMAP_F_FSVERITY) {
+		WARN_ON_ONCE(folio_pos(folio) < isize);
+		return true;
+	}
+
 	if (*end_pos > isize) {
 		size_t poff = offset_in_folio(folio, isize);
 		pgoff_t end_index = isize >> PAGE_SHIFT;
@@ -1868,7 +1883,7 @@ int iomap_writeback_folio(struct iomap_writepage_ctx *wpc, struct folio *folio)
 
 	trace_iomap_writeback_folio(inode, pos, folio_size(folio));
 
-	if (!iomap_writeback_handle_eof(folio, inode, &end_pos))
+	if (!iomap_writeback_handle_eof(folio, wpc, &end_pos))
 		return 0;
 	WARN_ON_ONCE(end_pos <= pos);
 
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index 532787277b16..5252051cc137 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -118,7 +118,8 @@ DEFINE_RANGE_EVENT(iomap_zero_iter);
 	{ IOMAP_F_ATOMIC_BIO,	"ATOMIC_BIO" }, \
 	{ IOMAP_F_PRIVATE,	"PRIVATE" }, \
 	{ IOMAP_F_SIZE_CHANGED,	"SIZE_CHANGED" }, \
-	{ IOMAP_F_STALE,	"STALE" }
+	{ IOMAP_F_STALE,	"STALE" }, \
+	{ IOMAP_F_FSVERITY,	"FSVERITY" }
 
 
 #define IOMAP_DIO_STRINGS \
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 531f9ebdeeae..dc39837b0d45 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -87,6 +87,11 @@ struct vm_fault;
 #define IOMAP_F_INTEGRITY	0
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+/*
+ * IO happens beyond inode EOF, fsverity metadata is stored there
+ */
+#define IOMAP_F_FSVERITY	(1U << 10)
+
 /*
  * Flag reserved for file system specific usage
  */
-- 
2.51.2

