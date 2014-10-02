Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 388D87F63
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 08:12:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 27522304077
	for <xfs@oss.sgi.com>; Thu,  2 Oct 2014 06:12:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nUlcSxuyJf0Csr36 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 Oct 2014 06:12:17 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s92DCFBw012809
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 2 Oct 2014 09:12:16 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s92DCEpa005908
	for <xfs@oss.sgi.com>; Thu, 2 Oct 2014 09:12:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: fix zero range i_size problems
Date: Thu,  2 Oct 2014 09:12:13 -0400
Message-Id: <1412255533-8357-1-git-send-email-bfoster@redhat.com>
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

The zero range operation is analogous to fallocate with the exception of
converting the range to zeroes. E.g., it attempts to allocate zeroed
blocks over the range specified by the caller. The XFS implementation
kills all delalloc blocks currently over the aligned range, converts the
range to allocated zero blocks (unwritten extents) and handles the
partial pages at the ends of the range by sending writes through the
pagecache.

The current implementation suffers from several problems associated with
inode size. If the aligned range covers an extending I/O, said I/O is
discarded and an inode size update from a previous write never makes it
to disk. Further, if an unaligned zero range extends beyond eof, the
page write induced for the partial end page can itself increase the
inode size, even if the zero range request is not supposed to update
i_size (via KEEP_SIZE, similar to an fallocate beyond EOF).

Update xfs_zero_file_space() to forego using buffered I/O for partial
pages. Instead, convert the block aligned (rather than page aligned)
range to unwritten extents, update the partial blocks on disk and use
existing pagecache functionality to ensure cached pages are consistent
with data on disk.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This passes xfstests and survived an overnight fsx run (+300m ops) on a
1k fsb fs. The tradeoff that I've observed from this implementation is
that fzero is now also likely to trigger the problem described in the
recently posted xfs/053 test:

http://oss.sgi.com/archives/xfs/2014-09/msg00473.html

This is slightly unfortunate, but as I understand it that problem is
more fundamentally associated with extent conversion and writeback vs.
any particular fs operation that might expose it.

Brian

 fs/xfs/xfs_bmap_util.c | 110 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d8b77b5..f2d58e2 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1364,7 +1364,17 @@ xfs_free_file_space(
 	goto out;
 }
 
-
+/*
+ * Preallocate and zero a range of a file. This mechanism has the allocation
+ * semantics of fallocate and in addition converts data in the range to zeroes.
+ * This is done using unwritten extent conversion for complete blocks within the
+ * range. Partial start/end blocks cannot be converted to unwritten as they
+ * contain valid data. Therefore, partial blocks are preallocated and explicitly
+ * zeroed on-disk.
+ *
+ * Note that all allocation occurs in file sequential order (e.g., partial
+ * start, middle, partial end) to help the allocator create contiguous extents.
+ */
 int
 xfs_zero_file_space(
 	struct xfs_inode	*ip,
@@ -1372,63 +1382,99 @@ xfs_zero_file_space(
 	xfs_off_t		len)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint			granularity;
+	uint			blksize;
 	xfs_off_t		start_boundary;
 	xfs_off_t		end_boundary;
 	int			error;
+	loff_t			eof;
+	xfs_off_t		endoffset;
 
 	trace_xfs_zero_file_space(ip);
 
-	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+	blksize = 1 << mp->m_sb.sb_blocklog;
 
 	/*
-	 * Round the range of extents we are going to convert inwards.  If the
-	 * offset is aligned, then it doesn't get changed so we zero from the
-	 * start of the block offset points to.
+	 * Align the range inward to blocksize. This represents the range that
+	 * can be converted to unwritten extents.
 	 */
-	start_boundary = round_up(offset, granularity);
-	end_boundary = round_down(offset + len, granularity);
+	start_boundary = round_up(offset, blksize);
+	end_boundary = round_down(offset + len, blksize);
 
 	ASSERT(start_boundary >= offset);
 	ASSERT(end_boundary <= offset + len);
 
-	if (start_boundary < end_boundary - 1) {
+	/*
+	 * Flush the eof page before we start so we don't lose an i_size update
+	 * due to discarding an appending I/O in cache.
+	 */
+	eof = round_down(i_size_read(VFS_I(ip)) - 1, PAGE_CACHE_SIZE);
+	if (eof >= start_boundary && eof <= end_boundary)
+		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, eof, -1);
+
+	/*
+	 * Writeback the partial pages if either the start or end is not page
+	 * aligned to prevent writeback races with partial block zeroing.
+	 * truncate_pagecache_range() handles partial page zeroing if the pages
+	 * are cached.
+	 */
+	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(offset + len)) {
+		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, offset,
+					     start_boundary);
+		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, end_boundary,
+					     offset + len);
+	}
+	truncate_pagecache_range(VFS_I(ip), offset, offset + len - 1);
+
+	/* handle a partial start block */
+	if (offset < start_boundary) {
+		/* don't go past the end offset if it's within the block */
+		endoffset = min_t(xfs_off_t, start_boundary, offset + len);
+
+		/* preallocate the block and zero the partial range on disk */
+		error = xfs_alloc_file_space(ip, offset,
+				start_boundary - offset, XFS_BMAPI_PREALLOC);
+		if (error)
+			goto out;
+		error = xfs_zero_remaining_bytes(ip, offset, endoffset - 1);
+		if (error)
+			goto out;
+
+		/* if we've hit the end offset, we're done */
+		if (endoffset == offset + len)
+			goto out;
+	}
+
+	/* handle complete blocks */
+	if (end_boundary > start_boundary) {
 		/*
-		 * punch out delayed allocation blocks and the page cache over
-		 * the conversion range
+		 * Punch out any delalloc extents first. We don't need the data
+		 * and this is more efficient than converting them all to
+		 * written->unwritten.
 		 */
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_bmap_punch_delalloc_range(ip,
 				XFS_B_TO_FSBT(mp, start_boundary),
-				XFS_B_TO_FSB(mp, end_boundary - start_boundary));
+				XFS_B_TO_FSB(mp,
+					     end_boundary - start_boundary));
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		truncate_pagecache_range(VFS_I(ip), start_boundary,
-					 end_boundary - 1);
 
-		/* convert the blocks */
+		/* convert the range to unwritten extents */
 		error = xfs_alloc_file_space(ip, start_boundary,
 					end_boundary - start_boundary - 1,
 					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT);
 		if (error)
 			goto out;
+	}
 
-		/* We've handled the interior of the range, now for the edges */
-		if (start_boundary != offset) {
-			error = xfs_iozero(ip, offset, start_boundary - offset);
-			if (error)
-				goto out;
-		}
-
-		if (end_boundary != offset + len)
-			error = xfs_iozero(ip, end_boundary,
-					   offset + len - end_boundary);
-
-	} else {
-		/*
-		 * It's either a sub-granularity range or the range spanned lies
-		 * partially across two adjacent blocks.
-		 */
-		error = xfs_iozero(ip, offset, len);
+	/* handle a partial end block */
+	if (offset + len > end_boundary) {
+		error = xfs_alloc_file_space(ip, end_boundary,
+				offset + len - end_boundary,
+				XFS_BMAPI_PREALLOC);
+		if (error)
+			goto out;
+		error = xfs_zero_remaining_bytes(ip, end_boundary,
+						 offset + len - 1);
 	}
 
 out:
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
