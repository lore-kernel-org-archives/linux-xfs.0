Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D1D427F87
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 04:44:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 81110AC003
	for <xfs@oss.sgi.com>; Fri,  1 Feb 2013 02:44:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 2y9OKKMLh1pV1DGV for
	<xfs@oss.sgi.com>; Fri, 01 Feb 2013 02:44:20 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 13/18] ext4: use ext4_zero_partial_blocks in punch_hole
Date: Fri,  1 Feb 2013 11:43:39 +0100
Message-Id: <1359715424-32318-14-git-send-email-lczerner@redhat.com>
In-Reply-To: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

We're doing to get rid of ext4_discard_partial_page_buffers() since it is
duplicating some code and also partially duplicating work of
truncate_pagecache_range(), moreover the old implementation was much
clearer.

Now when the truncate_inode_pages_range() can handle truncating non page
aligned regions we can use this to invalidate and zero out block aligned
region of the punched out range and then use ext4_block_truncate_page()
to zero the unaligned blocks on the start and end of the range. This
will greatly simplify the punch hole code. Moreover after this commit we
can get rid of the ext4_discard_partial_page_buffers() completely.

This has been tested on ppc64 with 1k block size with fsx and xfstests
without any problems.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h    |    2 +
 fs/ext4/extents.c |   79 ++++++-----------------------------------------------
 fs/ext4/inode.c   |   31 +++++++++++++++++++++
 3 files changed, 42 insertions(+), 70 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4246a55..665b975 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2090,6 +2090,8 @@ extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length);
+extern int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
+			     loff_t lstart, loff_t lend);
 extern int ext4_discard_partial_page_buffers(handle_t *handle,
 		struct address_space *mapping, loff_t from,
 		loff_t length, int flags);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 5ce5a14..7b44dc1 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4639,7 +4639,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
 	handle_t *handle;
-	loff_t first_page, last_page, page_len;
 	loff_t first_page_offset, last_page_offset;
 	int credits, err = 0;
 
@@ -4680,17 +4679,13 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 		   offset;
 	}
 
-	first_page = (offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	last_page = (offset + length) >> PAGE_CACHE_SHIFT;
+	first_page_offset = round_up(offset, sb->s_blocksize);
+	last_page_offset = round_down((offset + length), sb->s_blocksize) - 1;
 
-	first_page_offset = first_page << PAGE_CACHE_SHIFT;
-	last_page_offset = last_page << PAGE_CACHE_SHIFT;
-
-	/* Now release the pages */
-	if (last_page_offset > first_page_offset) {
+	/* Now release the pages and zero block aligned part of pages*/
+	if (last_page_offset > first_page_offset)
 		truncate_pagecache_range(inode, first_page_offset,
-					 last_page_offset - 1);
-	}
+					 last_page_offset);
 
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	ext4_inode_block_unlocked_dio(inode);
@@ -4707,66 +4702,10 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	}
 
 
-	/*
-	 * Now we need to zero out the non-page-aligned data in the
-	 * pages at the start and tail of the hole, and unmap the buffer
-	 * heads for the block aligned regions of the page that were
-	 * completely zeroed.
-	 */
-	if (first_page > last_page) {
-		/*
-		 * If the file space being truncated is contained within a page
-		 * just zero out and unmap the middle of that page
-		 */
-		err = ext4_discard_partial_page_buffers(handle,
-			mapping, offset, length, 0);
-
-		if (err)
-			goto out;
-	} else {
-		/*
-		 * zero out and unmap the partial page that contains
-		 * the start of the hole
-		 */
-		page_len  = first_page_offset - offset;
-		if (page_len > 0) {
-			err = ext4_discard_partial_page_buffers(handle, mapping,
-						   offset, page_len, 0);
-			if (err)
-				goto out;
-		}
-
-		/*
-		 * zero out and unmap the partial page that contains
-		 * the end of the hole
-		 */
-		page_len = offset + length - last_page_offset;
-		if (page_len > 0) {
-			err = ext4_discard_partial_page_buffers(handle, mapping,
-					last_page_offset, page_len, 0);
-			if (err)
-				goto out;
-		}
-	}
-
-	/*
-	 * If i_size is contained in the last page, we need to
-	 * unmap and zero the partial page after i_size
-	 */
-	if (inode->i_size >> PAGE_CACHE_SHIFT == last_page &&
-	   inode->i_size % PAGE_CACHE_SIZE != 0) {
-
-		page_len = PAGE_CACHE_SIZE -
-			(inode->i_size & (PAGE_CACHE_SIZE - 1));
-
-		if (page_len > 0) {
-			err = ext4_discard_partial_page_buffers(handle,
-			  mapping, inode->i_size, page_len, 0);
-
-			if (err)
-				goto out;
-		}
-	}
+	err = ext4_zero_partial_blocks(handle, inode, offset,
+				       offset + length - 1);
+	if (err)
+		goto out;
 
 	first_block = (offset + sb->s_blocksize - 1) >>
 		EXT4_BLOCK_SIZE_BITS(sb);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5ccf556..5df9716 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3672,6 +3672,37 @@ unlock:
 	return err;
 }
 
+int ext4_zero_partial_blocks(handle_t *handle, struct inode *inode,
+			     loff_t lstart, loff_t lend)
+{
+	struct super_block *sb = inode->i_sb;
+	struct address_space *mapping = inode->i_mapping;
+	unsigned partial = lstart & (sb->s_blocksize - 1);
+	ext4_fsblk_t start = lstart >> sb->s_blocksize_bits;
+	ext4_fsblk_t end = lend >> sb->s_blocksize_bits;
+	int err = 0;
+
+	/* Handle partial zero within the single block */
+	if (start == end) {
+		err = ext4_block_zero_page_range(handle, mapping,
+						 lstart, lend - lstart + 1);
+		return err;
+	}
+	/* Handle partial zero out on the start of the range */
+	if (partial) {
+		err = ext4_block_zero_page_range(handle, mapping,
+						 lstart, sb->s_blocksize);
+		if (err)
+			return err;
+	}
+	/* Handle partial zero out on the end of the range */
+	partial = lend & (sb->s_blocksize - 1);
+	if (partial != sb->s_blocksize - 1)
+		err = ext4_block_zero_page_range(handle, mapping,
+						 lend - partial, partial + 1);
+	return err;
+}
+
 int ext4_can_truncate(struct inode *inode)
 {
 	if (S_ISREG(inode->i_mode))
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
