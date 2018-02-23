Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:2403 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751317AbeBWAIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 19:08:22 -0500
Date: Fri, 23 Feb 2018 11:08:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: don't block on the ilock for RWF_NOWAIT
Message-ID: <20180223000819.GJ7000@dastard>
References: <20180222150653.18479-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222150653.18479-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Feb 22, 2018 at 07:06:53AM -0800, Christoph Hellwig wrote:
> Fix xfs_file_iomap_begin to trylock the ilock if IOMAP_NOWAIT is passed,
> so that we don't block io_submit callers.

I'm testing a patch that cleans this up - it moves all
this trylock crap out into a helper function and reworks the
rest of the function to be clear about non-blocking operations
i.e. gets rid of most of the IOMAP_NOWAIT checks
nested inside the different conditions in this code.

I'm much prefer to clean this us properly than layer yet another
undocumented set of non-blocking hacks into this code.

There's also a bug in the code where we take the ILOCK exclusive for
direct IO writes only to then have to demote it before calling
xfs_iomap_write_direct() if allocation is required.  This was a
regression introduced with the iomap direct IO path rework...

Current patch I have been testing is below. I need to split it up
into a set of smaller patches for submission, though.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com


xfs: clean up xfs_file_iomap_begin, make it non-blocking

From: Dave Chinner <dchinner@redhat.com>

Gah, what a friggin' mess.

Signed-Off-By: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_iomap.c | 166 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 101 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 66e1edbfb2b2..9c7398c8f7e7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -955,19 +955,52 @@ static inline bool imap_needs_alloc(struct inode *inode,
 		(IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN);
 }
 
-static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
+static int
+xfs_ilock_for_iomap(
+	struct xfs_inode	*ip,
+	unsigned		flags,
+	unsigned		*lockmode)
 {
+	unsigned		mode = XFS_ILOCK_SHARED;
+
+	/* Modifications to reflink files require exclusive access */
+	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO))) {
+		/*
+		 * A reflinked inode will result in CoW alloc.
+		 * FIXME: It could still overwrite on unshared extents
+		 * and not need allocation in the direct IO path.
+		 */
+		if ((flags & IOMAP_NOWAIT) && (flags & IOMAP_DIRECT))
+			return -EAGAIN;
+		mode = XFS_ILOCK_EXCL;
+	}
+
+	/* Non-direct IO modifications require exclusive access */
+	if (!(flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
+		mode = XFS_ILOCK_EXCL;
+
 	/*
-	 * COW writes will allocate delalloc space, so we need to make sure
-	 * to take the lock exclusively here.
+	 * Extents not yet cached requires exclusive access, don't block.
+	 * This is an opencoded xfs_ilock_data_map_shared() call but with
+	 * non-blocking behaviour.
 	 */
-	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
-		return true;
-	if ((flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
-		return true;
-	return false;
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+		if (flags & IOMAP_NOWAIT)
+			return -EAGAIN;
+		mode = XFS_ILOCK_EXCL;
+	}
+
+	if (!xfs_ilock_nowait(ip, mode)) {
+		if (flags & IOMAP_NOWAIT)
+			return -EAGAIN;
+		xfs_ilock(ip, mode);
+	}
+
+	*lockmode = mode;
+	return 0;
 }
 
+
 static int
 xfs_file_iomap_begin(
 	struct inode		*inode,
@@ -993,17 +1026,15 @@ xfs_file_iomap_begin(
 		return xfs_file_iomap_begin_delay(inode, offset, length, iomap);
 	}
 
-	if (need_excl_ilock(ip, flags)) {
-		lockmode = XFS_ILOCK_EXCL;
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
-	} else {
-		lockmode = xfs_ilock_data_map_shared(ip);
-	}
-
-	if ((flags & IOMAP_NOWAIT) && !(ip->i_df.if_flags & XFS_IFEXTENTS)) {
-		error = -EAGAIN;
-		goto out_unlock;
-	}
+	/*
+	 * Lock the inode in the manner required for the specified operation and
+	 * check for as many conditions that would result in blocking as
+	 * possible. This removes most of the non-blocking checks from the
+	 * mapping code below.
+	 */
+	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
+	if (error)
+		return error;
 
 	ASSERT(offset <= mp->m_super->s_maxbytes);
 	if (offset > mp->m_super->s_maxbytes - length)
@@ -1024,17 +1055,16 @@ xfs_file_iomap_begin(
 			goto out_unlock;
 	}
 
-	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
+	/* Non-modifying mapping requested, so we are done */
+	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
+		goto iomap_found;
+
+	/*
+	 * Break shared extents if necessary. Checks for blocking in the direct
+	 * IO case have been done up front, so we don't need to do them here.
+	 */
+	if (xfs_is_reflink_inode(ip)) {
 		if (flags & IOMAP_DIRECT) {
-			/*
-			 * A reflinked inode will result in CoW alloc.
-			 * FIXME: It could still overwrite on unshared extents
-			 * and not need allocation.
-			 */
-			if (flags & IOMAP_NOWAIT) {
-				error = -EAGAIN;
-				goto out_unlock;
-			}
 			/* may drop and re-acquire the ilock */
 			error = xfs_reflink_allocate_cow(ip, &imap, &shared,
 					&lockmode);
@@ -1050,46 +1080,45 @@ xfs_file_iomap_begin(
 		length = XFS_FSB_TO_B(mp, end_fsb) - offset;
 	}
 
-	if ((flags & IOMAP_WRITE) && imap_needs_alloc(inode, &imap, nimaps)) {
-		/*
-		 * If nowait is set bail since we are going to make
-		 * allocations.
-		 */
-		if (flags & IOMAP_NOWAIT) {
-			error = -EAGAIN;
-			goto out_unlock;
-		}
-		/*
-		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
-		 * pages to keep the chunks of work done where somewhat symmetric
-		 * with the work writeback does. This is a completely arbitrary
-		 * number pulled out of thin air as a best guess for initial
-		 * testing.
-		 *
-		 * Note that the values needs to be less than 32-bits wide until
-		 * the lower level functions are updated.
-		 */
-		length = min_t(loff_t, length, 1024 * PAGE_SIZE);
-		/*
-		 * xfs_iomap_write_direct() expects the shared lock. It
-		 * is unlocked on return.
-		 */
-		if (lockmode == XFS_ILOCK_EXCL)
-			xfs_ilock_demote(ip, lockmode);
-		error = xfs_iomap_write_direct(ip, offset, length, &imap,
-				nimaps);
-		if (error)
-			return error;
+	/* Don't need to allocate over holes when doing zeroing operations. */
+	if (flags & IOMAP_ZERO)
+		goto iomap_found;
+	ASSERT(flags & IOMAP_WRITE);
 
-		iomap->flags = IOMAP_F_NEW;
-		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
-	} else {
-		ASSERT(nimaps);
+	if (!imap_needs_alloc(inode, &imap, nimaps))
+		goto iomap_found;
 
-		xfs_iunlock(ip, lockmode);
-		trace_xfs_iomap_found(ip, offset, length, 0, &imap);
+	/* Don't block on allocation if we are doing non-blocking IO */
+	if (flags & IOMAP_NOWAIT) {
+		error = -EAGAIN;
+		goto out_unlock;
 	}
 
+	/*
+	 * We cap the maximum length we map here to a sane size keep the chunks
+	 * of work done where somewhat symmetric with the work writeback does.
+	 * This is a completely arbitrary number pulled out of thin air as a
+	 * best guess for initial testing.
+	 *
+	 * Note that the values needs to be less than 32-bits wide until the
+	 * lower level functions are updated.
+	 */
+	length = min_t(loff_t, length, 1024 * PAGE_SIZE);
+
+	/*
+	 * xfs_iomap_write_direct() expects the shared lock. It is unlocked on
+	 * return.
+	 */
+	if (lockmode == XFS_ILOCK_EXCL)
+		xfs_ilock_demote(ip, lockmode);
+	error = xfs_iomap_write_direct(ip, offset, length, &imap, nimaps);
+	if (error)
+		return error;
+
+	iomap->flags = IOMAP_F_NEW;
+	trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
+
+iomap_finish:
 	if (xfs_ipincount(ip) && (ip->i_itemp->ili_fsync_fields
 				& ~XFS_ILOG_TIMESTAMP))
 		iomap->flags |= IOMAP_F_DIRTY;
@@ -1099,6 +1128,13 @@ xfs_file_iomap_begin(
 	if (shared)
 		iomap->flags |= IOMAP_F_SHARED;
 	return 0;
+
+iomap_found:
+	ASSERT(nimaps);
+	xfs_iunlock(ip, lockmode);
+	trace_xfs_iomap_found(ip, offset, length, 0, &imap);
+	goto iomap_finish;
+
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 	return error;
