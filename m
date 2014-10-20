Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 88C2F7F4E
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 12:06:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7775630404E
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 10:06:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ml8GcOUuw4mqS7Oq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Oct 2014 10:06:25 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9KH6N1w012882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 13:06:24 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9KH6NIR003174
	for <xfs@oss.sgi.com>; Mon, 20 Oct 2014 13:06:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v5] xfs: rework zero range to prevent invalid i_size updates
Date: Mon, 20 Oct 2014 13:06:21 -0400
Message-Id: <1413824781-10733-1-git-send-email-bfoster@redhat.com>
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
zero range. This implementation is not efficient nor ideal as we
writeback dirty data over the range and remove existing extents rather
than convert to unwrittern. The former writeback, however, is currently
the only mechanism available to ensure consistency between pagecache and
extent state. Even a pagecache truncate/delalloc punch prior to hole
punch has lead to inconsistencies due to racing with writeback.

This provides a consistent, correct implementation of zero range that
survives fsstress/fsx testing without assert failures. The
implementation can be optimized from this point forward once the
fundamental issue of pagecache and delalloc extent state consistency is
addressed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v5:
- Further simplify to eliminate delalloc block punch.
v4: http://oss.sgi.com/archives/xfs/2014-10/msg00276.html
- Simplify the implementation to use hole punch.
v3: http://oss.sgi.com/archives/xfs/2014-10/msg00149.html
- Pass length to xfs_alloc_file_space() rather than end offset.
- Split up start/end page writeback branches.
- Fix up a bunch of comments.
v2: http://oss.sgi.com/archives/xfs/2014-10/msg00138.html
- Refactor the logic to punch out pagecache/delalloc first and do
  allocation last to prevent stray delalloc on ENOSPC.
v1: http://oss.sgi.com/archives/xfs/2014-10/msg00052.html

 fs/xfs/xfs_bmap_util.c | 72 ++++++++++++++------------------------------------
 1 file changed, 20 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 92e8f99..2810026 100644
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
@@ -1346,65 +1349,30 @@ xfs_zero_file_space(
 	xfs_off_t		len)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	uint			granularity;
-	xfs_off_t		start_boundary;
-	xfs_off_t		end_boundary;
+	uint			blksize;
 	int			error;
 
 	trace_xfs_zero_file_space(ip);
 
-	granularity = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
+	blksize = 1 << mp->m_sb.sb_blocklog;
 
 	/*
-	 * Round the range of extents we are going to convert inwards.  If the
-	 * offset is aligned, then it doesn't get changed so we zero from the
-	 * start of the block offset points to.
+	 * Punch a hole and prealloc the range. We use hole punch rather than
+	 * unwritten extent conversion for two reasons:
+	 *
+	 * 1.) Hole punch handles partial block zeroing for us.
+	 *
+	 * 2.) If prealloc returns ENOSPC, the file range is still zero-valued
+	 * by virtue of the hole punch.
 	 */
-	start_boundary = round_up(offset, granularity);
-	end_boundary = round_down(offset + len, granularity);
-
-	ASSERT(start_boundary >= offset);
-	ASSERT(end_boundary <= offset + len);
-
-	if (start_boundary < end_boundary - 1) {
-		/*
-		 * Writeback the range to ensure any inode size updates due to
-		 * appending writes make it to disk (otherwise we could just
-		 * punch out the delalloc blocks).
-		 */
-		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-				start_boundary, end_boundary - 1);
-		if (error)
-			goto out;
-		truncate_pagecache_range(VFS_I(ip), start_boundary,
-					 end_boundary - 1);
-
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
-	}
+	error = xfs_free_file_space(ip, offset, len);
+	if (error)
+		goto out;
 
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
