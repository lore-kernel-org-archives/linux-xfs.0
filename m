Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C4EE7F4E
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 12:11:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F9B18F8054
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 10:11:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UFGIugjdqn5wJev2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Oct 2014 10:11:28 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9DHBRKb016209
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 13:11:28 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9DHBRFC007673
	for <xfs@oss.sgi.com>; Mon, 13 Oct 2014 13:11:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4] xfs: rework zero range to prevent invalid i_size updates
Date: Mon, 13 Oct 2014 13:11:25 -0400
Message-Id: <1413220285-24886-1-git-send-email-bfoster@redhat.com>
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
Use the existing hole punch and prealloc mechanisms as primitives for
zero range. We punch out the pagecache beforehand to eliminate
unnecessary writeback. The hole punch mechanism handles partial block
zeroing for us and facilitates the use of a single prealloc call over
the entire range, which increases the odds of contiguous allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is v4, but effectively an alternate implementation to v3 that
reduces zero range to a hole punch and preallocate operation. I
originally reproduced a hang with v3 + my unwritten conversion helper
patch that I thought somehow related to said helper, but I have seen
what appears to be the same thing with this patch after a couple hundred
cycles of generic/269. That leads me to believe that there is a more
general problem perhaps related to the increased extent manipulation
going on in either implementation (whether for conversion or removal). I
don't reproduce such a failure with focused hole punch testing on tot,
but I do reproduce other assert failures that I suspect just mask the
ability to reproduce this one.

In short, all three of these configurations pass basic correctness tests
for me. v3 has been the most reliable in stress tests. v3+unwritten
conversion and v4 seem to reproduce this hang after a while. v4 is
probably the most simple implementation of the three.

Brian

v4:
- Simplify the implementation to use hole punch.
v3: http://oss.sgi.com/archives/xfs/2014-10/msg00149.html
- Pass length to xfs_alloc_file_space() rather than end offset.
- Split up start/end page writeback branches.
- Fix up a bunch of comments.
v2: http://oss.sgi.com/archives/xfs/2014-10/msg00138.html
- Refactor the logic to punch out pagecache/delalloc first and do
  allocation last to prevent stray delalloc on ENOSPC.
v1: http://oss.sgi.com/archives/xfs/2014-10/msg00052.html

 fs/xfs/xfs_bmap_util.c | 95 +++++++++++++++++++++++++++++---------------------
 1 file changed, 55 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 92e8f99..8d178fc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1338,7 +1338,10 @@ xfs_free_file_space(
 	goto out;
 }
 
-
+/*
+ * Preallocate and zero a range of a file. This mechanism has the allocation
+ * semantics of fallocate and in addition converts data in the range to zeroes.
+ */
 int
 xfs_zero_file_space(
 	struct xfs_inode	*ip,
@@ -1346,65 +1349,77 @@ xfs_zero_file_space(
 	xfs_off_t		len)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint			granularity;
+	uint			blksize;
 	xfs_off_t		start_boundary;
 	xfs_off_t		end_boundary;
 	int			error;
+	loff_t			eof;
 
 	trace_xfs_zero_file_space(ip);
 
-	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+	blksize = 1 << mp->m_sb.sb_blocklog;
 
 	/*
-	 * Round the range of extents we are going to convert inwards.  If the
-	 * offset is aligned, then it doesn't get changed so we zero from the
-	 * start of the block offset points to.
+	 * Align the range inward to page size. This represents the range of
+	 * pages that can be tossed, even if dirty.
 	 */
-	start_boundary = round_up(offset, granularity);
-	end_boundary = round_down(offset + len, granularity);
+	start_boundary = round_up(offset, PAGE_CACHE_SIZE);
+	end_boundary = round_down(offset + len, PAGE_CACHE_SIZE);
 
 	ASSERT(start_boundary >= offset);
 	ASSERT(end_boundary <= offset + len);
 
-	if (start_boundary < end_boundary - 1) {
+	/*
+	 * If the range covers one or more full pages, punch out the pagecache
+	 * and any delalloc blocks over the range. This is an optimization to
+	 * prevent writeback and delalloc extent conversion over the zeroed
+	 * range via the hole punch or prealloc calls.
+	 *
+	 * We only handle the page aligned range here because this function does
+	 * not handle the partial block zeroing necessary to keep the cache and
+	 * on-disk data consistent. That is the responsibility of the
+	 * xfs_free_file_space() call below.
+	 */
+	if (end_boundary > start_boundary) {
 		/*
-		 * Writeback the range to ensure any inode size updates due to
-		 * appending writes make it to disk (otherwise we could just
-		 * punch out the delalloc blocks).
+		 * Flush the eof page first if it falls within the range so we
+		 * do not lose i_size updates.
 		 */
-		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-				start_boundary, end_boundary - 1);
-		if (error)
-			goto out;
+		eof = round_down(i_size_read(VFS_I(ip)) - 1, PAGE_CACHE_SIZE);
+		if (i_size_read(VFS_I(ip)) > ip->i_d.di_size &&
+		    eof >= start_boundary && eof <= end_boundary)
+			filemap_write_and_wait_range(VFS_I(ip)->i_mapping, eof,
+						     -1);
 		truncate_pagecache_range(VFS_I(ip), start_boundary,
 					 end_boundary - 1);
 
-		/* convert the blocks */
-		error = xfs_alloc_file_space(ip, start_boundary,
-					end_boundary - start_boundary - 1,
-					XFS_BMAPI_PREALLOC | XFS_BMAPI_CONVERT);
-		if (error)
-			goto out;
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
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmap_punch_delalloc_range(ip,
+				XFS_B_TO_FSBT(mp, start_boundary),
+				XFS_B_TO_FSB(mp, end_boundary - start_boundary));
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
+	/*
+	 * Punch a hole and prealloc the range. We use hole punch rather than
+	 * unwritten extent conversion for two reasons:
+	 *
+	 * 1.) Hole punch handles partial block zeroing for us. Note that we've
+	 * already tossed pagecache over the aligned range so we won't write
+	 * back too much data (only unaligned start/end pages to avoid races
+	 * with uncached I/O).
+	 *
+	 * 2.) If prealloc returns ENOSPC, the file range is still zero-valued
+	 * by virtue of the hole punch.
+	 */
+	error = xfs_free_file_space(ip, offset, len);
+	if (error)
+		goto out;
+
+	error = xfs_alloc_file_space(ip, round_down(offset, blksize),
+				     round_up(offset + len, blksize) -
+				     round_down(offset, blksize),
+				     XFS_BMAPI_PREALLOC);
 out:
 	return error;
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
