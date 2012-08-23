Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N54CGI135603 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:04:12 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	SwOheoDZ7sl9tDyL for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:04:56 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PbA-0003Io-EO
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PbA-0003hc-BK
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:04:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 076/102] xfs: punch new delalloc blocks out of failed writes
	inside
Date: Thu, 23 Aug 2012 15:02:34 +1000
Message-Id: <1345698180-13612-77-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Upstream commit: d3bc815afb549eecb3679a4b2f0df216e34df998
 EOF.

When a partial write inside EOF fails, it can leave delayed
allocation blocks lying around because they don't get punched back
out. This leads to assert failures like:

XFS: Assertion failed: XFS_FORCED_SHUTDOWN(ip->i_mount) || ip->i_delayed_blks == 0, file: fs/xfs/linux-2.6/xfs_super.c, line: 847

when evicting inodes from the cache. This can be trivially triggered
by xfstests 083, which takes between 5 and 15 executions on a 512
byte block size filesystem to trip over this. Debugging shows a
failed write due to ENOSPC calling xfs_vm_write_failed such as:

[ 5012.329024] ino 0xa0026: vwf to 0x17000, sze 0x1c85ae

and no action is taken on it. This leaves behind a delayed
allocation extent that has no page covering it and no data in it:

[ 5015.867162] ino 0xa0026: blks: 0x83 delay blocks 0x1, size 0x2538c0
[ 5015.868293] ext 0: off 0x4a, fsb 0x50306, len 0x1
[ 5015.869095] ext 1: off 0x4b, fsb 0x7899, len 0x6b
[ 5015.869900] ext 2: off 0xb6, fsb 0xffffffffe0008, len 0x1
                                    ^^^^^^^^^^^^^^^
[ 5015.871027] ext 3: off 0x36e, fsb 0x7a27, len 0xd
[ 5015.872206] ext 4: off 0x4cf, fsb 0x7a1d, len 0xa

So the delayed allocation extent is one block long at offset
0x16c00. Tracing shows that a bigger write:

xfs_file_buffered_write: size 0x1c85ae offset 0x959d count 0x1ca3f ioflags

allocates the block, and then fails with ENOSPC trying to allocate
the last block on the page, leading to a failed write with stale
delalloc blocks on it.

Because we've had an ENOSPC when trying to allocate 0x16e00, it
means that we are never goinge to call ->write_end on the page and
so the allocated new buffer will not get marked dirty or have the
buffer_new state cleared. In other works, what the above write is
supposed to end up with is this mapping for the page:

    +------+------+------+------+------+------+------+------+
      UMA    UMA    UMA    UMA    UMA    UMA    UND    FAIL

where:  U = uptodate
        M = mapped
        N = new
        A = allocated
        D = delalloc
        FAIL = block we ENOSPC'd on.

and the key point being the buffer_new() state for the newly
allocated delayed allocation block. Except it doesn't - we're not
marking buffers new correctly.

That buffer_new() problem goes back to the xfs_iomap removal days,
where xfs_iomap() used to return a "new" status for any map with
newly allocated blocks, so that __xfs_get_blocks() could call
set_buffer_new() on it. We still have the "new" variable and the
check for it in the set_buffer_new() logic - except we never set it
now!

Hence that newly allocated delalloc block doesn't have the new flag
set on it, so when the write fails we cannot tell which blocks we
are supposed to punch out. WHy do we need the buffer_new flag? Well,
that's because we can have this case:

    +------+------+------+------+------+------+------+------+
      UMD    UMD    UMD    UMD    UMD    UMD    UND    FAIL

where all the UMD buffers contain valid data from a previously
successful write() system call. We only want to punch the UND buffer
because that's the only one that we added in this write and it was
only this write that failed.

That implies that even the old buffer_new() logic was wrong -
because it would result in all those UMD buffers on the page having
set_buffer_new() called on them even though they aren't new. Hence
we shoul donly be calling set_buffer_new() for delalloc buffers that
were allocated (i.e. were a hole before xfs_iomap_write_delay() was
called).

So, fix this set_buffer_new logic according to how we need it to
work for handling failed writes correctly. Also, restore the new
buffer logic handling for blocks allocated via
xfs_iomap_write_direct(), because it should still set the buffer_new
flag appropriately for newly allocated blocks, too.

SO, now we have the buffer_new() being set appropriately in
__xfs_get_blocks(), we can detect the exact delalloc ranges that
we allocated in a failed write, and hence can now do a walk of the
buffers on a page to find them.

Except, it's not that easy. When block_write_begin() fails, it
unlocks and releases the page that we just had an error on, so we
can't use that page to handle errors anymore. We have to get access
to the page while it is still locked to walk the buffers. Hence we
have to open code block_write_begin() in xfs_vm_write_begin() to be
able to insert xfs_vm_write_failed() is the right place.

With that, we can pass the page and write range to
xfs_vm_write_failed() and walk the buffers on the page, looking for
delalloc buffers that are either new or beyond EOF and punch them
out. Handling buffers beyond EOF ensures we still handle the
existing case that xfs_vm_write_failed() handles.

Of special note is the truncate_pagecache() handling - that only
should be done for pages outside EOF - pages within EOF can still
contain valid, dirty data so we must not punch them out of the
cache.

That just leaves the xfs_vm_write_end() failure handling.
The only failure case here is that we didn't copy the entire range,
and generic_write_end() handles that by zeroing the region of the
page that wasn't copied, we don't have to punch out blocks within
the file because they are guaranteed to contain zeros. Hence we only
have to handle the existing "beyond EOF" case and don't need access
to the buffers on the page. Hence it remains largely unchanged.

Note that xfs_getbmap() can still trip over delalloc blocks beyond
EOF that are left there by speculative delayed allocation. Hence
this bug fix does not solve all known issues with bmap vs delalloc,
but it does fix all the the known accidental occurances of the
problem.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Ben Myers <bpm@sgi.com>
---
 fs/xfs/linux-2.6/xfs_aops.c |  173 +++++++++++++++++++++++++++++++------------
 1 file changed, 127 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 51f7db1..e4acb6b 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -1235,11 +1235,18 @@ __xfs_get_blocks(
 						       &imap, nimaps);
 			if (error)
 				return -error;
+			new = 1;
 		} else {
 			/*
 			 * Delalloc reservations do not require a transaction,
-			 * we can go on without dropping the lock here.
+			 * we can go on without dropping the lock here. If we
+			 * are allocating a new delalloc block, make sure that
+			 * we set the new flag so that we mark the buffer new so
+			 * that we know that it is newly allocated if the write
+			 * fails.
 			 */
+			if (nimaps && imap.br_startblock == HOLESTARTBLOCK)
+				new = 1;
 			error = xfs_iomap_write_delay(ip, offset, size, &imap);
 			if (error)
 				goto out_unlock;
@@ -1456,52 +1463,91 @@ out_destroy_ioend:
 	return ret;
 }
 
+/*
+ * Punch out the delalloc blocks we have already allocated.
+ *
+ * Don't bother with xfs_setattr given that nothing can have made it to disk yet
+ * as the page is still locked at this point.
+ */
+STATIC void
+xfs_vm_kill_delalloc_range(
+	struct inode		*inode,
+	loff_t			start,
+	loff_t			end)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	xfs_fileoff_t		start_fsb;
+	xfs_fileoff_t		end_fsb;
+	int			error;
+
+	start_fsb = XFS_B_TO_FSB(ip->i_mount, start);
+	end_fsb = XFS_B_TO_FSB(ip->i_mount, end);
+	if (end_fsb <= start_fsb)
+		return;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+						end_fsb - start_fsb);
+	if (error) {
+		/* something screwed, just bail */
+		if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+			xfs_alert(ip->i_mount,
+		"xfs_vm_write_failed: unable to clean up ino %lld",
+					ip->i_ino);
+		}
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+}
+
 STATIC void
 xfs_vm_write_failed(
-	struct address_space	*mapping,
-	loff_t			to)
+	struct inode		*inode,
+	struct page		*page,
+	loff_t			pos,
+	unsigned		len)
 {
-	struct inode		*inode = mapping->host;
+	loff_t			block_offset = pos & PAGE_MASK;
+	loff_t			block_start;
+	loff_t			block_end;
+	loff_t			from = pos & (PAGE_CACHE_SIZE - 1);
+	loff_t			to = from + len;
+	struct buffer_head	*bh, *head;
 
-	if (to > inode->i_size) {
-		/*
-		 * Punch out the delalloc blocks we have already allocated.
-		 *
-		 * Don't bother with xfs_setattr given that nothing can have
-		 * made it to disk yet as the page is still locked at this
-		 * point.
-		 */
-		struct xfs_inode	*ip = XFS_I(inode);
-		xfs_fileoff_t		start_fsb;
-		xfs_fileoff_t		end_fsb;
-		int			error;
+	ASSERT(block_offset + from == pos);
 
-		truncate_pagecache(inode, to, inode->i_size);
+	head = page_buffers(page);
+	block_start = 0;
+	for (bh = head; bh != head || !block_start;
+	     bh = bh->b_this_page, block_start = block_end,
+				   block_offset += bh->b_size) {
+		block_end = block_start + bh->b_size;
 
-		/*
-		 * Check if there are any blocks that are outside of i_size
-		 * that need to be trimmed back.
-		 */
-		start_fsb = XFS_B_TO_FSB(ip->i_mount, inode->i_size);
-		end_fsb = XFS_B_TO_FSB(ip->i_mount, to);
-		if (end_fsb <= start_fsb)
-			return;
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-							end_fsb - start_fsb);
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_alert(ip->i_mount,
-			"xfs_vm_write_failed: unable to clean up ino %lld",
-						ip->i_ino);
-			}
-		}
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		/* skip buffers before the write */
+		if (block_end <= from)
+			continue;
+
+		/* if the buffer is after the write, we're done */
+		if (block_start >= to)
+			break;
+
+		if (!buffer_delay(bh))
+			continue;
+
+		if (!buffer_new(bh) && block_offset < i_size_read(inode))
+			continue;
+
+		xfs_vm_kill_delalloc_range(inode, block_offset,
+					   block_offset + bh->b_size);
 	}
+
 }
 
+/*
+ * This used to call block_write_begin(), but it unlocks and releases the page
+ * on error, and we need that page to be able to punch stale delalloc blocks out
+ * on failure. hence we copy-n-waste it here and call xfs_vm_write_failed() at
+ * the appropriate point.
+ */
 STATIC int
 xfs_vm_write_begin(
 	struct file		*file,
@@ -1512,15 +1558,40 @@ xfs_vm_write_begin(
 	struct page		**pagep,
 	void			**fsdata)
 {
-	int			ret;
+	pgoff_t			index = pos >> PAGE_CACHE_SHIFT;
+	struct page		*page;
+	int			status;
 
-	ret = block_write_begin(mapping, pos, len, flags | AOP_FLAG_NOFS,
-				pagep, xfs_get_blocks);
-	if (unlikely(ret))
-		xfs_vm_write_failed(mapping, pos + len);
-	return ret;
+	ASSERT(len <= PAGE_CACHE_SIZE);
+
+	page = grab_cache_page_write_begin(mapping, index,
+					   flags | AOP_FLAG_NOFS);
+	if (!page)
+		return -ENOMEM;
+
+	status = __block_write_begin(page, pos, len, xfs_get_blocks);
+	if (unlikely(status)) {
+		struct inode	*inode = mapping->host;
+
+		xfs_vm_write_failed(inode, page, pos, len);
+		unlock_page(page);
+
+		if (pos + len > i_size_read(inode))
+			truncate_pagecache(inode, pos + len, i_size_read(inode));
+
+		page_cache_release(page);
+		page = NULL;
+	}
+
+	*pagep = page;
+	return status;
 }
 
+/*
+ * On failure, we only need to kill delalloc blocks beyond EOF because they
+ * will never be written. For blocks within EOF, generic_write_end() zeros them
+ * so they are safe to leave alone and be written with all the other valid data.
+ */
 STATIC int
 xfs_vm_write_end(
 	struct file		*file,
@@ -1533,9 +1604,19 @@ xfs_vm_write_end(
 {
 	int			ret;
 
+	ASSERT(len <= PAGE_CACHE_SIZE);
+
 	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
-	if (unlikely(ret < len))
-		xfs_vm_write_failed(mapping, pos + len);
+	if (unlikely(ret < len)) {
+		struct inode	*inode = mapping->host;
+		size_t		isize = i_size_read(inode);
+		loff_t		to = pos + len;
+
+		if (to > isize) {
+			truncate_pagecache(inode, to, isize);
+			xfs_vm_kill_delalloc_range(inode, isize, to);
+		}
+	}
 	return ret;
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
