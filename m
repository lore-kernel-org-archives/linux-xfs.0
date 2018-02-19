Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:42439 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbeBSEsD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Feb 2018 23:48:03 -0500
Date: Mon, 19 Feb 2018 15:48:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_buf_lock vs aio
Message-ID: <20180219044800.GX7000@dastard>
References: <30274e7a-4029-73b8-0d8b-cdfda450e3bc@scylladb.com>
 <20180209231015.GI20266@dastard>
 <697bf891-e7c4-4d60-e2ce-f1ba6935b38b@scylladb.com>
 <20180213051850.GE6778@dastard>
 <f8b3b7a4-eba4-d5ab-1748-a8382a2a8fd6@scylladb.com>
 <20180214235616.GM7000@dastard>
 <1f90f49b-e11d-3140-f73b-5834e52b5f8a@scylladb.com>
 <20180215213030.GO7000@dastard>
 <946349de-471f-f766-47d8-f32959990cc6@scylladb.com>
 <20180219024055.GW7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180219024055.GW7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Avi Kivity <avi@scylladb.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Feb 19, 2018 at 01:40:55PM +1100, Dave Chinner wrote:
> On Fri, Feb 16, 2018 at 10:07:55AM +0200, Avi Kivity wrote:
> > On 02/15/2018 11:30 PM, Dave Chinner wrote:
> > >On Thu, Feb 15, 2018 at 11:36:54AM +0200, Avi Kivity wrote:
> > >>On 02/15/2018 01:56 AM, Dave Chinner wrote:
> > >>A little bird whispered in my ear to try XFS_IOC_OPEN_BY_HANDLE to
> > >>avoid the the time update lock, so we'll be trying that next, to
> > >>emulate lazytime.
> > >Biggest problem with that is it requires root permissions. It's not
> > >a solution that can be deployed in practice, so I haven't bothered
> > >suggesting it as something to try.
> > >
> > >If you want to try lazytime, an easier test might be to rebuild the
> > >kernel with this change below to support the lazytime mount option
> > >and not log the timestamp updates. This is essentially the mechanism
> > >that I'll use for this, but it will need to grow more stuff to have
> > >the correct lazytime semantics...
> > >
> > 
> > We tried open by handle to see if lazytime would provide relief, but
> > it looks like it just pushes the lock acquisition to another place:
> 
> Whack-a-mole.
> 
> This is the whole problem with driving the "nowait" semantics into
> the filesystem implementations - every time we fix one blocking
> point, we find a deeper one, and we have to drive the "nowait"
> semantics deeper into code that should not have to care about IO
> level blocking semantics. And by doing it in a "slap-a-bandaid on
> it" process, we end up with spagetti code that is fragile and
> unmaintainable...
> 
> > However, that function can EAGAIN (it does for IOLOCK) so maybe we
> > can change xfs_ilock to xfs_ilock_nowait and teach it about not
> > waiting for ILOCK too.
> 
> If only it were that simple. Why, exactly, does the direct IO write
> code require the ILOCK exclusive? Indeed, if it goes to allocate
> blocks, we do this:
> 
>                 /*
>                  * xfs_iomap_write_direct() expects the shared lock. It
>                  * is unlocked on return.
>                  */
>                 if (lockmode == XFS_ILOCK_EXCL)
>                         xfs_ilock_demote(ip, lockmode);
> 
> We demote the lock to shared before we call into the allocation
> code. And for pure direct IO writes, all we care about is ensuring
> the extent map does not change while we do the lookup and check.
> That only requires a shared lock.
> 
> So now I've got to go work out why need_excl_ilock() says we need
> an exclusive ilock for direct IO writes when it looks pretty clear
> to me that we don't. 
> 
> But that's only half the problem. The other problem is that even if
> we take it shared, we're still going to block on IO completion
> taking the ILOCK exclusive to do things like unwritten extent
> completion. So we still need to hack about with "trylock" operations
> into functions into various functions (xfs_ilock_data_map_shared()
> for one).
> 
> What a mess....

Try the patch below on top of the lazytime stuff. Let's see where
the next layer of the onion is found.

-Dave.
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
