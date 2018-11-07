Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:63760 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728024AbeKGQBQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:16 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/16] iomap: introduce zero-around functionality
Date: Wed,  7 Nov 2018 17:31:20 +1100
Message-Id: <20181107063127.3902-10-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For block size > page size, a single page write is a sub-block
write. Hence they have to be treated differently when these writes
land in a hole or unwritten extent. The underlying block is going to
be allocated, but if we only write a single page to it the rest of
the block is going to be uninitialised. This creates a stale data
exposure problem.

To avoid this, when we write into the middle of a new block, we need
to instantiate and zero the pages in the block around the current
page. When writeback occurs, all the pages will get written back and
the block will be fully initialised.

When we are doing zero-around, we may find pages already in the
cache over that range (e.g. from reading). We don't want to zero
those pages - they will already be up-to-date if they contain data,
and so we skip the zeroing if we find an up-to-date page.

Zeroing is done from the iomap_apply() actor function, so we use
iomap_zero() directly to instantiate page cache pages and zero them.
The iomap we are supplied with will always span the range the actor
needs to zero, so there's no need to recurse through
iomap_zero_range() here.

The zero-around functionality will be triggered by the
IOMAP_F_ZERO_AROUND flag returned by the filesystem's ->iomap_begin
mapping function. It will do so when it knows that zero-around will
be required for the mapped region being returned.

This commit introduces the zero-around functionality and patches it
into the buffered write path. Future commits will add the
functionality to other iomap write paths.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c            | 88 ++++++++++++++++++++++++++++++++++++++++++-
 include/linux/iomap.h |  2 +
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index e417a5911239..56f40177ed17 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -793,6 +793,84 @@ static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 			iomap_sector(iomap, pos & PAGE_MASK), offset, bytes);
 }
 
+/*
+ * We need to zero around the write if the write lands in a hole or an unwritten
+ * extent and the IOMAP_F_ZERO_AROUND flag is set. If we are in newly allocated
+ * space (i.e. write landed in a hole), IOMAP_F_NEW will be set. If we landed
+ * in an unwritten extent, the type will be IOMAP_UNWRITTEN.
+ */
+static bool
+iomap_need_zero_around(struct iomap *iomap)
+{
+	if (!(iomap->flags & IOMAP_F_ZERO_AROUND))
+		return false;
+	if (iomap->flags & IOMAP_F_NEW)
+		return true;
+	if (iomap->type == IOMAP_UNWRITTEN)
+		return true;
+	return false;
+}
+
+/*
+ * If we need to do zero-around, we zero the partial leading block that the
+ * data_start lands in, and if the iomap extends past the end of the write, we
+ * zero that partial block, too. Don't zero tail blocks beyond EOF.
+ */
+static loff_t
+iomap_zero_around(struct inode *inode, loff_t data_start, loff_t length,
+		struct iomap *iomap)
+{
+	loff_t data_end = data_start + length;
+	loff_t pos;
+	loff_t end = data_end;
+	loff_t status;
+	unsigned long offset;	/* Offset into pagecache page */
+	unsigned long bytes;	/* Bytes to write to page */
+
+	pos = round_down(data_start, i_blocksize(inode));
+	if (end < i_size_read(inode))
+		end = round_up(end, i_blocksize(inode));
+
+	/*
+	 * If the end is now past EOF, it means this write is at or
+	 * completely inside EOF and so we only zero from the end of the
+	 * write to EOF. If we are extending the file this avoids tail
+	 * zeroing altogether.
+	 */
+	if (end >= i_size_read(inode))
+		end = max(data_end, i_size_read(inode));
+
+	WARN_ON_ONCE(pos < iomap->offset);
+	WARN_ON_ONCE(offset_in_page(pos));
+	WARN_ON_ONCE(end > iomap->offset + iomap->length);
+	WARN_ON_ONCE(end < data_end);
+
+	/* zero start */
+	while (pos < data_start) {
+		offset = offset_in_page(pos);
+		bytes = min_t(unsigned long, data_start - pos,
+							PAGE_SIZE - offset);
+
+		status = iomap_zero(inode, pos, offset, bytes, iomap);
+		if (status < 0)
+			return status;
+		pos += bytes;
+	}
+
+	/* zero end */
+	pos = data_end;
+	while (pos < end) {
+		offset = offset_in_page(pos);
+		bytes = min_t(unsigned long, end - pos, PAGE_SIZE - offset);
+
+		status = iomap_zero(inode, pos, offset, bytes, iomap);
+		if (status < 0)
+			return status;
+		pos += bytes;
+	}
+	return 0;
+}
+
 static loff_t
 iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 		void *data, struct iomap *iomap)
@@ -849,14 +927,20 @@ iomap_zero_range(struct inode *inode, loff_t pos, loff_t len, bool *did_zero,
 EXPORT_SYMBOL_GPL(iomap_zero_range);
 
 static loff_t
-iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+iomap_write_actor(struct inode *inode, loff_t pos, loff_t length,
+		void *data, struct iomap *iomap)
 {
 	struct iov_iter *i = data;
 	long status = 0;
 	ssize_t written = 0;
 	unsigned int flags = AOP_FLAG_NOFS;
 
+	if (iomap_need_zero_around(iomap)) {
+		status = iomap_zero_around(inode, pos, length, iomap);
+		if (status)
+			return status;
+	}
+
 	do {
 		struct page *page;
 		unsigned long offset;	/* Offset into pagecache page */
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 671c0c387450..afdbeb12ed6e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -35,6 +35,8 @@ struct vm_fault;
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
 #define IOMAP_F_BUFFER_HEAD	0x04	/* file system requires buffer heads */
+#define IOMAP_F_ZERO_AROUND	0x08	/* file system requires zeroed data
+					   around written data in map */
 
 /*
  * Flags that only need to be reported for IOMAP_REPORT requests:
-- 
2.19.1
