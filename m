Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E94477F60
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 06:49:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BAD978F8050
	for <xfs@oss.sgi.com>; Thu, 28 Aug 2014 04:49:20 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0t49dOIBE9bgHghC for <xfs@oss.sgi.com>;
	Thu, 28 Aug 2014 04:49:18 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XMyCX-0000FL-FD
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XMyCX-0004Kb-EG
	for xfs@oss.sgi.com; Thu, 28 Aug 2014 21:49:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/7] xfs: don't dirty buffers beyond EOF
Date: Thu, 28 Aug 2014 21:49:05 +1000
Message-Id: <1409226551-16570-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1409226551-16570-1-git-send-email-david@fromorbit.com>
References: <1409226551-16570-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

generic/263 is failing fsx at this point with a page spanning
EOF that cannot be invalidated. The operations are:

1190 mapwrite   0x52c00 thru    0x5e569 (0xb96a bytes)
1191 mapread    0x5c000 thru    0x5d636 (0x1637 bytes)
1192 write      0x5b600 thru    0x771ff (0x1bc00 bytes)

where 1190 extents EOF from 0x54000 to 0x5e569. When the direct IO
write attempts to invalidate the cached page over this range, it
fails with -EBUSY and so any attempt to do page invalidation fails.

The real question is this: Why can't that page be invalidated after
it has been written to disk and cleaned?

Well, there's data on the first two buffers in the page (1k block
size, 4k page), but the third buffer on the page (i.e. beyond EOF)
is failing drop_buffers because it's bh->b_state == 0x3, which is
BH_Uptodate | BH_Dirty.  IOWs, there's dirty buffers beyond EOF. Say
what?

OK, set_buffer_dirty() is called on all buffers from
__set_page_buffers_dirty(), regardless of whether the buffer is
beyond EOF or not, which means that when we get to ->writepage,
we have buffers marked dirty beyond EOF that we need to clean.
So, we need to implement our own .set_page_dirty method that
doesn't dirty buffers beyond EOF.

This is messy because the buffer code is not meant to be shared
and it has interesting locking issues on the buffer dirty bits.
So just copy and paste it and then modify it to suit what we need.

Note: the solutions the other filesystems and generic block code use
of marking the buffers clean in ->writepage does not work for XFS.
It still leaves dirty buffers beyond EOF and invalidations still
fail. Hence rather than play whack-a-mole, this patch simply
prevents those buffers from being dirtied in the first place.

cc: <stable@kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 11e9b4c..4c79f90 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1753,11 +1753,69 @@ xfs_vm_readpages(
 	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
 }
 
+/*
+ * This is basically a copy of __set_page_dirty_buffers() with one
+ * small tweak: buffers beyond EOF do not get marked dirty. If we mark them
+ * dirty, we'll never be able to clean them because we don't write buffers
+ * beyond EOF, and that means we can't invalidate pages that span EOF
+ * that have been marked dirty. Further, the dirty state can leak into
+ * the file interior if the file is extended, resulting in all sorts of
+ * bad things happening as the state does not match the unerlying data.
+ */
+STATIC int
+xfs_vm_set_page_dirty(
+	struct page		*page)
+{
+	struct address_space	*mapping = page->mapping;
+	struct inode		*inode = mapping->host;
+	loff_t			end_offset;
+	loff_t			offset;
+	int			newly_dirty;
+
+	if (unlikely(!mapping))
+		return !TestSetPageDirty(page);
+
+	end_offset = i_size_read(inode);
+	offset = end_offset & PAGE_CACHE_MASK;
+
+	spin_lock(&mapping->private_lock);
+	if (page_has_buffers(page)) {
+		struct buffer_head *head = page_buffers(page);
+		struct buffer_head *bh = head;
+
+		do {
+			if (offset < end_offset)
+				set_buffer_dirty(bh);
+			bh = bh->b_this_page;
+			offset += 1 << inode->i_blkbits;
+		} while (bh != head);
+	}
+	newly_dirty = !TestSetPageDirty(page);
+	spin_unlock(&mapping->private_lock);
+
+	if (newly_dirty) {
+		/* sigh - __set_page_dirty() is static, so copy it here, too */
+		unsigned long flags;
+
+		spin_lock_irqsave(&mapping->tree_lock, flags);
+		if (page->mapping) {	/* Race with truncate? */
+			WARN_ON_ONCE(!PageUptodate(page));
+			account_page_dirtied(page, mapping);
+			radix_tree_tag_set(&mapping->page_tree,
+					page_index(page), PAGECACHE_TAG_DIRTY);
+		}
+		spin_unlock_irqrestore(&mapping->tree_lock, flags);
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	}
+	return newly_dirty;
+}
+
 const struct address_space_operations xfs_address_space_operations = {
 	.readpage		= xfs_vm_readpage,
 	.readpages		= xfs_vm_readpages,
 	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
+	.set_page_dirty		= xfs_vm_set_page_dirty,
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
 	.write_begin		= xfs_vm_write_begin,
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
