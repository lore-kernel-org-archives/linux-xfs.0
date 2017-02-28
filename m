Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19763 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752117AbdB1O7m (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 09:59:42 -0500
Date: Tue, 28 Feb 2017 09:59:40 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: LTP write03 writev07 xfs failures
Message-ID: <20170228145940.GA13377@bfoster.bfoster>
References: <20170227042220.syhudcilvyettwnf@XZHOUW.usersys.redhat.com>
 <20170227160901.GB9344@bfoster.bfoster>
 <20170227201334.GC9344@bfoster.bfoster>
 <20170228140455.GB9371@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228140455.GB9371@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Feb 28, 2017 at 06:04:55AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 27, 2017 at 03:13:35PM -0500, Brian Foster wrote:
> > After playing around a bit, I don't think using i_size is the right
> > approach either. It just exacerbates the original problem on buffered
> > writes into sparse files. We can end up leaving around however many
> > delalloc blocks we've allocated.
> > 
> > I think we need a way to differentiate preexisting (previously written)
> > delalloc blocks from those allocated and unused by the current write. We
> > might be able to do that by looking at the pagecache, but I think that
> > means looking at the buffer state to make sure we handle sub-page block
> > sizes correctly. I.e., make *_iomap_end_delalloc() punch out all
> > delalloc blocks in the non-written range that are either not page backed
> > or not dirty+delalloc buffer backed. Hm?
> 
> That sounds ugly, but right off my mind I see no other way.  I'll need
> to take a look at what the old pre-iomap code did there, as I think
> none of these issues happened there.

Heh. I've appended what I'm currently playing around with. It's
certainly uglier, but not terrible IMO (outside of the fact that we have
to look at the buffer_heads). This seems to address the problem, but
still only lightly tested...

An entirely different approach may be to somehow or another
differentiate allocated delalloc blocks from "found" delalloc blocks in
the iomap_begin() handler, and then perhaps encode that into the iomap
such that the iomap_end() handler has an explicit reference of what to
punch. Personally, I wouldn't mind doing something like the below short
term to fix the regression and then incorporate an iomap enhancement to
break the buffer_head dependency.

Brian

---8<---

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 41662fb..5761dc6 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1066,6 +1066,30 @@ xfs_file_iomap_begin(
 	return error;
 }
 
+/* grab the bh for a page offset */
+static struct buffer_head *
+bh_for_pgoff(
+	struct page		*page,
+	loff_t			offset)
+{
+	struct buffer_head	*bh, *head;
+
+	ASSERT(offset < PAGE_SIZE);
+	ASSERT(page_has_buffers(page));
+
+	bh = head = page_buffers(page);
+	do {
+		struct buffer_head	*next = bh->b_this_page;
+		if (next == head)
+			break;
+		if (bh_offset(next) > offset)
+		       break;
+		bh = next;
+	} while (true);
+
+	return bh;
+}
+
 static int
 xfs_file_iomap_end_delalloc(
 	struct xfs_inode	*ip,
@@ -1074,13 +1098,21 @@ xfs_file_iomap_end_delalloc(
 	ssize_t			written)
 {
 	struct xfs_mount	*mp = ip->i_mount;
+	struct address_space	*mapping = VFS_I(ip)->i_mapping;
+	struct page		*page;
+	struct buffer_head	*bh;
 	xfs_fileoff_t		start_fsb;
 	xfs_fileoff_t		end_fsb;
 	int			error = 0;
 
-	/* behave as if the write failed if drop writes is enabled */
-	if (xfs_mp_drop_writes(mp))
+	/*
+	 * Behave as if the write failed if drop writes is enabled. Punch out
+	 * the pagecache to trigger delalloc cleanup.
+	 */
+	if (xfs_mp_drop_writes(mp)) {
 		written = 0;
+		truncate_pagecache_range(VFS_I(ip), offset, offset + length);
+	}
 
 	/*
 	 * start_fsb refers to the first unused block after a short write. If
@@ -1094,22 +1126,29 @@ xfs_file_iomap_end_delalloc(
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	/*
-	 * Trim back delalloc blocks if we didn't manage to write the whole
-	 * range reserved.
+	 * We have to clear out any unused delalloc blocks in the event of a
+	 * failed or short write. Otherwise, these blocks linger indefinitely as
+	 * they are not fronted by dirty pagecache.
 	 *
-	 * We don't need to care about racing delalloc as we hold i_mutex
-	 * across the reserve/allocate/unreserve calls. If there are delalloc
-	 * blocks in the range, they are ours.
+	 * To filter out blocks that were successfully written by a previous
+	 * write, walk the unwritten range and only punch out blocks that are
+	 * not backed by dirty+delalloc buffers.
 	 */
-	if (start_fsb < end_fsb) {
-		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
-					 XFS_FSB_TO_B(mp, end_fsb) - 1);
+	for (; start_fsb < end_fsb; start_fsb++) {
+		offset = XFS_FSB_TO_B(mp, start_fsb);
+		page = find_get_page(mapping, offset >> PAGE_SHIFT);
+		if (page) {
+			bh = bh_for_pgoff(page, offset & ~PAGE_MASK);
+			if ((buffer_dirty(bh) && buffer_delay(bh))) {
+				put_page(page);
+				continue;
+			}
+			put_page(page);
+		}
 
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-					       end_fsb - start_fsb);
+		error = xfs_bmap_punch_delalloc_range(ip, start_fsb, 1);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
 		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_alert(mp, "%s: unable to clean up ino %lld",
 				__func__, ip->i_ino);
