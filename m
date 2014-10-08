Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 73F9A7F3F
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 13:51:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 60739304039
	for <xfs@oss.sgi.com>; Wed,  8 Oct 2014 11:51:29 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id eQuyeMgIt12wf7vy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 08 Oct 2014 11:51:28 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s98IpQRO019128
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Wed, 8 Oct 2014 14:51:27 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s98IpPrp002958
	for <xfs@oss.sgi.com>; Wed, 8 Oct 2014 14:51:25 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3] xfs: rework zero range to prevent invalid i_size updates
Date: Wed,  8 Oct 2014 14:51:24 -0400
Message-Id: <1412794284-52268-1-git-send-email-bfoster@redhat.com>
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

The latter behavior not only incorrectly increases the inode size, but
can lead to stray delalloc blocks on the inode. Typically, post-eof
preallocation blocks are either truncated on release or inode eviction
or explicitly written to by xfs_zero_eof() on natural file size
extension. If the inode size increases due to zero range, however,
associated blocks leak into the address space having never been
converted or mapped to pagecache pages. A direct I/O to such an
uncovered range cannot convert the extent via writeback and will BUG().
For example:

$ xfs_io -fc "pwrite 0 128k" -c "fzero -k 1m 54321" <file>
...
$ xfs_io -d -c "pread 128k 128k" <file>
<BUG>

If the entire delalloc extent happens to not have page coverage
whatsoever (e.g., delalloc conversion couldn't find a large enough free
space extent), even a full file writeback won't convert what's left of
the extent and we'll assert on inode eviction.

Rework xfs_zero_file_space() to avoid buffered I/O for partial pages.
Align to blocksize rather than page size and use uncached buffers to
zero partial blocks. Preallocate the outward block-aligned range to
provide fallocate allocation semantics and convert the inward range to
unwritten extents to zero the range.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v3:
- Pass length to xfs_alloc_file_space() rather than end offset.
- Split up start/end page writeback branches.
- Fix up a bunch of comments.
v2: http://oss.sgi.com/archives/xfs/2014-10/msg00138.html
- Refactor the logic to punch out pagecache/delalloc first and do
  allocation last to prevent stray delalloc on ENOSPC.
v1: http://oss.sgi.com/archives/xfs/2014-10/msg00052.html

 fs/xfs/xfs_bmap_util.c | 133 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 92 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 92e8f99..a69df91 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1338,7 +1338,18 @@ xfs_free_file_space(
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
+ * NOTE: We explicitly avoid going through page cache (i.e., xfs_iozero()) for
+ * partial page zeroing because ioend completion can incorrectly update the
+ * inode size and cause data corruption.
+ */
 int
 xfs_zero_file_space(
 	struct xfs_inode	*ip,
@@ -1346,65 +1357,105 @@ xfs_zero_file_space(
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
-		/*
-		 * Writeback the range to ensure any inode size updates due to
-		 * appending writes make it to disk (otherwise we could just
-		 * punch out the delalloc blocks).
-		 */
-		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-				start_boundary, end_boundary - 1);
+	/*
+	 * We generally want to avoid writeback here but must take a few things
+	 * into consideration. If file extending I/O is cached and the eof page
+	 * falls within the aligned range, write it back so we don't lose i_size
+	 * updates. Also writeback unaligned start/end pages to avoid races with
+	 * uncached I/O.
+	 */
+	eof = round_down(i_size_read(VFS_I(ip)) - 1, PAGE_CACHE_SIZE);
+	if (i_size_read(VFS_I(ip)) > ip->i_d.di_size &&
+	    eof >= start_boundary && eof <= end_boundary)
+		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, eof, -1);
+	if (!PAGE_ALIGNED(offset))
+		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, offset,
+					     start_boundary);
+	if (!PAGE_ALIGNED(offset + len))
+		filemap_write_and_wait_range(VFS_I(ip)->i_mapping, end_boundary,
+					     offset + len);
+
+	/*
+	 * Punch out the pagecache and delalloc extents in the range.
+	 * truncate_pagecache_range() handles partial page zeroing for us if the
+	 * pages happen to be cached. Note that this will not cache fill or mark
+	 * pages dirty so we must still make the blocks consistent on disk.
+	 */
+	truncate_pagecache_range(VFS_I(ip), offset, offset + len - 1);
+	if (end_boundary > start_boundary) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmap_punch_delalloc_range(ip,
+				XFS_B_TO_FSBT(mp, start_boundary),
+				XFS_B_TO_FSB(mp,
+					     end_boundary - start_boundary));
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	}
+
+	/*
+	 * Now handle start and end sub-block zeroing. We do this before
+	 * allocation because we want the blocks on disk consistent with
+	 * pagecache if we hit ENOSPC.
+	 */
+	if (offset < start_boundary) {
+		/* don't go past the end offset if it's within the block */
+		endoffset = min_t(xfs_off_t, start_boundary, offset + len);
+
+		error = xfs_zero_remaining_bytes(ip, offset, endoffset - 1);
 		if (error)
 			goto out;
-		truncate_pagecache_range(VFS_I(ip), start_boundary,
-					 end_boundary - 1);
-
-		/* convert the blocks */
-		error = xfs_alloc_file_space(ip, start_boundary,
-					end_boundary - start_boundary - 1,
-					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT);
+	}
+	if (end_boundary >= start_boundary && offset + len > end_boundary) {
+		error = xfs_zero_remaining_bytes(ip, end_boundary,
+						 offset + len - 1);
 		if (error)
 			goto out;
-
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
 	}
 
+	/*
+	 * First, preallocate the unaligned range to ensure the entire range is
+	 * allocated. This does not convert extents because we cannot convert
+	 * partial blocks. Second, convert the block-aligned range to unwritten
+	 * extents. We do this as such because passing the entire range for
+	 * allocation facilitates ideal contiguity from the allocator.
+	 *
+	 * Note that we attempt unwritten conversion even if we fail to
+	 * preallocate space. This is an effort to convert as many extents as
+	 * possible before we inevitably return ENOSPC.
+	 *
+	 * XXX: A helper that converts existing extents but does not preallocate
+	 * would help clean all this up. We could convert extents first,
+	 * preallocate second, and thus guarantee a zero-value range on ENOSPC.
+	 */
+	error = xfs_alloc_file_space(ip, round_down(offset, blksize),
+				     round_up(offset + len, blksize) -
+				     round_down(offset, blksize),
+				     XFS_BMAPI_PREALLOC);
+	if (end_boundary > start_boundary)
+		error = xfs_alloc_file_space(ip, start_boundary,
+					end_boundary - start_boundary,
+					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT);
+
 out:
 	return error;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
