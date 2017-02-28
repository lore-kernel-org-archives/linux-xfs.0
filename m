Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50836 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751441AbdB1QLc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 11:11:32 -0500
Date: Tue, 28 Feb 2017 11:10:37 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: LTP write03 writev07 xfs failures
Message-ID: <20170228161036.GB13377@bfoster.bfoster>
References: <20170227042220.syhudcilvyettwnf@XZHOUW.usersys.redhat.com>
 <20170227160901.GB9344@bfoster.bfoster>
 <20170227201334.GC9344@bfoster.bfoster>
 <20170228140455.GB9371@infradead.org>
 <20170228145940.GA13377@bfoster.bfoster>
 <20170228151135.GA17880@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228151135.GA17880@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Xiong Zhou <xzhou@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Feb 28, 2017 at 07:11:35AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 28, 2017 at 09:59:40AM -0500, Brian Foster wrote:
> > Heh. I've appended what I'm currently playing around with. It's
> > certainly uglier, but not terrible IMO (outside of the fact that we have
> > to look at the buffer_heads). This seems to address the problem, but
> > still only lightly tested...
> > 
> > An entirely different approach may be to somehow or another
> > differentiate allocated delalloc blocks from "found" delalloc blocks in
> > the iomap_begin() handler, and then perhaps encode that into the iomap
> > such that the iomap_end() handler has an explicit reference of what to
> > punch. Personally, I wouldn't mind doing something like the below short
> > term to fix the regression and then incorporate an iomap enhancement to
> > break the buffer_head dependency.
> 
> We actually have a IOMAP_F_NEW for this already, but so far it's
> only used by the DIO and DAX code.

Ok. I think that has the potential to provide a more clean and simple
solution. I don't think it's as straightforward of a change to enable
that for the buffered write code, however. I don't think we can just set
the NEW flag when we do xfs_bmapi_reserve_delalloc() because something
like the following would still break:

  xfs_io -fc "pwrite 16k 4k" -c "pwrite -b 32k 0 32k" <file>

If the second write happened to fail, AFAICT it would still punch out
the block allocated by the first. So I suppose we'd have to tweak
reserve_delalloc() to trim the returned extent, or perhaps add a flag
that skips the xfs_bmbt_get_all() call to update got after we insert the
extent, and thus only return what was allocated..?

(The latter actually seems to work on a very quick test, see appended
diff..).

Brian

---8<---

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index a9c66d4..18b927d 100644
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
@@ -4242,7 +4243,8 @@ xfs_bmapi_reserve_delalloc(
 	 * Update our extent pointer, given that xfs_bmap_add_extent_hole_delay
 	 * might have merged it into one of the neighbouring ones.
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
index 41662fb..9b1b2a4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -613,7 +613,8 @@ xfs_file_iomap_begin_delay(
 
 retry:
 	error = xfs_bmapi_reserve_delalloc(ip, XFS_DATA_FORK, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks, &got, &idx, eof);
+			end_fsb - offset_fsb, prealloc_blocks, &got, &idx,
+			eof, 0);
 	switch (error) {
 	case 0:
 		break;
@@ -629,7 +630,7 @@ xfs_file_iomap_begin_delay(
 	default:
 		goto out_unlock;
 	}
-
+	iomap->flags = IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
 done:
 	if (isnullstartblock(got.br_startblock))
@@ -1071,16 +1072,22 @@ xfs_file_iomap_end_delalloc(
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
 
+	trace_printk("%d: ino 0x%llx offset %llu len %llu writ %ld new %d\n", __LINE__,
+		     ip->i_ino, offset, length, written, !!(iomap->flags & IOMAP_F_NEW));
+
 	/* behave as if the write failed if drop writes is enabled */
-	if (xfs_mp_drop_writes(mp))
+	if (xfs_mp_drop_writes(mp)) {
+		iomap->flags |= IOMAP_F_NEW;
 		written = 0;
+	}
 
 	/*
 	 * start_fsb refers to the first unused block after a short write. If
@@ -1101,7 +1108,7 @@ xfs_file_iomap_end_delalloc(
 	 * across the reserve/allocate/unreserve calls. If there are delalloc
 	 * blocks in the range, they are ours.
 	 */
-	if (start_fsb < end_fsb) {
+	if (iomap->flags & IOMAP_F_NEW && start_fsb < end_fsb) {
 		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
 					 XFS_FSB_TO_B(mp, end_fsb) - 1);
 
@@ -1131,7 +1138,7 @@ xfs_file_iomap_end(
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
