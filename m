Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdCAPe7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 10:34:59 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: use iomap new flag for newly allocated delalloc blocks
Date: Wed,  1 Mar 2017 09:36:49 -0500
Message-Id: <1488379009-4972-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Xiong Zhou <xzhou@redhat.com>, Christoph Hellwig <hch@infradead.org>

Commit fa7f138 ("xfs: clear delalloc and cache on buffered write
failure") fixed one regression in the iomap error handling code and
exposed another. The fundamental problem is that if a buffered write
is a rewrite of preexisting delalloc blocks and the write fails, the
failure handling code can punch out preexisting blocks with valid
file data.

This was reproduced directly by sub-block writes in the LTP
kernel/syscalls/write/write03 test. A first 100 byte write allocates
a single block in a file. A subsequent 100 byte write fails and
punches out the block, including the data successfully written by
the previous write.

To address this problem, update the ->iomap_begin() handler to
distinguish newly allocated delalloc blocks from preexisting
delalloc blocks via the IOMAP_F_NEW flag. Use this flag in the
->iomap_end() handler to decide when a failed or short write should
punch out delalloc blocks.

This introduces the subtle requirement that ->iomap_begin() should
never combine newly allocated delalloc blocks with existing blocks
in the resulting iomap descriptor. This can occur when a new
delalloc reservation merges with a neighboring extent that is part
of the current write, for example. Therefore, update
xfs_bmapi_reserve_delalloc() to conditionally return the merged
extent vs. the allocated extent and map the latter into the iomap.
This ensures that preexisting delalloc blocks are always handled as
"found" blocks and not punched out on a failed rewrite.

Reported-by: Xiong Zhou <xzhou@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is a stab at fixing the regression discussed in this[1] thread
based on what Christoph mentioned regarding use of the IOMAP_F_NEW flag.
I decided to co-opt the XFS_BMAPI_ENTIRE flag for the delalloc res bit
since it seems logically equivalent, but we could define a new flag too.
I considered as such to preserve default behavior of
_reserve_delalloc(), but otoh there is only one other caller. Otherwise,
this passes all of my testing so far. Thoughts?

Brian

[1] http://www.spinics.net/lists/linux-xfs/msg04500.html

 fs/xfs/libxfs/xfs_bmap.c | 11 +++++++----
 fs/xfs/libxfs/xfs_bmap.h |  3 ++-
 fs/xfs/xfs_iomap.c       | 31 ++++++++++++++++++++++---------
 fs/xfs/xfs_reflink.c     |  3 ++-
 4 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a9c66d4..f44ebc4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4159,7 +4159,8 @@ xfs_bmapi_reserve_delalloc(
 	xfs_filblks_t		prealloc,
 	struct xfs_bmbt_irec	*got,
 	xfs_extnum_t		*lastx,
-	int			eof)
+	int			eof,
+	int			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
@@ -4239,10 +4240,12 @@ xfs_bmapi_reserve_delalloc(
 	xfs_bmap_add_extent_hole_delay(ip, whichfork, lastx, got);
 
 	/*
-	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
-	 * might have merged it into one of the neighbouring ones.
+	 * Update our extent pointer if the caller asked for entire extents.
+	 * xfs_bmap_add_extent_hole_delay() might have merged it into one of
+	 * the neighbouring ones.
 	 */
-	xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), got);
+	if (flags & XFS_BMAPI_ENTIRE)
+		xfs_bmbt_get_all(xfs_iext_get_ext(ifp, *lastx), got);
 
 	/*
 	 * Tag the inode if blocks were preallocated. Note that COW fork
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index cdef87d..459ba6b 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -243,7 +243,8 @@ int	xfs_bmap_shift_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
-		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof);
+		struct xfs_bmbt_irec *got, xfs_extnum_t *lastx, int eof,
+		int flags);
 
 enum xfs_bmap_intent_type {
 	XFS_BMAP_MAP = 1,
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 41662fb..4a94895 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -612,8 +612,15 @@ xfs_file_iomap_begin_delay(
 	}
 
 retry:
+	/*
+	 * In order to distinguish newly allocated delalloc blocks from
+	 * preexisting delalloc blocks via IOMAP_F_NEW, it is required that got
+	 * returns _only_ blocks allocated by this write. Hence, do not pass
+	 * BMAPI_ENTIRE to the reserve call.
+	 */
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
+			end_fsb - offset_fsb, prealloc_blocks, &got, &idx,
+			eof, 0);
 	switch (error) {
 	case 0:
 		break;
@@ -629,7 +636,7 @@ xfs_file_iomap_begin_delay(
 	default:
 		goto out_unlock;
 	}
-
+	iomap->flags = IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
 done:
 	if (isnullstartblock(got.br_startblock))
@@ -1071,16 +1078,22 @@ xfs_file_iomap_end_delalloc(
 	struct xfs_inode	*ip,
 	loff_t			offset,
 	loff_t			length,
-	ssize_t			written)
+	ssize_t			written,
+	struct iomap		*iomap)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		start_fsb;
 	xfs_fileoff_t		end_fsb;
 	int			error = 0;
 
-	/* behave as if the write failed if drop writes is enabled */
-	if (xfs_mp_drop_writes(mp))
+	/*
+	 * Behave as if the write failed if drop writes is enabled. Set the NEW
+	 * flag to force delalloc cleanup.
+	 */
+	if (xfs_mp_drop_writes(mp)) {
+		iomap->flags |= IOMAP_F_NEW;
 		written = 0;
+	}
 
 	/*
 	 * start_fsb refers to the first unused block after a short write. If
@@ -1094,14 +1107,14 @@ xfs_file_iomap_end_delalloc(
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	/*
-	 * Trim back delalloc blocks if we didn't manage to write the whole
-	 * range reserved.
+	 * Trim delalloc blocks if they were allocated by this write and we
+	 * didn't manage to write the whole range.
 	 *
 	 * We don't need to care about racing delalloc as we hold i_mutex
 	 * across the reserve/allocate/unreserve calls. If there are delalloc
 	 * blocks in the range, they are ours.
 	 */
-	if (start_fsb < end_fsb) {
+	if (iomap->flags & IOMAP_F_NEW && start_fsb < end_fsb) {
 		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
 					 XFS_FSB_TO_B(mp, end_fsb) - 1);
 
@@ -1131,7 +1144,7 @@ xfs_file_iomap_end(
 {
 	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
 		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
-				length, written);
+				length, written, iomap);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index da6d08f..d76a2b6 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -313,7 +313,8 @@ xfs_reflink_reserve_cow(
 		return error;
 
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_COW_FORK, imap->br_startoff,
-			imap->br_blockcount, 0, &got, &idx, eof);
+			imap->br_blockcount, 0, &got, &idx, eof,
+			XFS_BMAPI_ENTIRE);
 	if (error == -ENOSPC || error == -EDQUOT)
 		trace_xfs_reflink_cow_enospc(ip, imap);
 	if (error)
-- 
2.7.4

