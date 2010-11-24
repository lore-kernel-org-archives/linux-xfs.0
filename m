Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAO5QnS0063381 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 23:26:50 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5B36F1A0E2C
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 21:28:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail20.adl6.internode.on.net
	[150.101.137.105]) by cuda.sgi.com with ESMTP id
	E7jcb08GEbcsAe3f for <xfs@oss.sgi.com>;
	Tue, 23 Nov 2010 21:28:25 -0800 (PST)
Date: Wed, 24 Nov 2010 16:28:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] Re: XFS performance oddity
Message-ID: <20101124052823.GD22876@dastard>
References: <20101123122449.GA4812@amd> <20101123205804.GX22876@dastard>
	<20101124005003.GB3168@amd> <20101124031524.GC22876@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101124031524.GC22876@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nick Piggin <npiggin@kernel.dk>
Cc: xfs@oss.sgi.com

On Wed, Nov 24, 2010 at 02:15:24PM +1100, Dave Chinner wrote:
> On Wed, Nov 24, 2010 at 11:50:03AM +1100, Nick Piggin wrote:
> > On Wed, Nov 24, 2010 at 07:58:04AM +1100, Dave Chinner wrote:
> > > On Tue, Nov 23, 2010 at 11:24:49PM +1100, Nick Piggin wrote:
> > > > Hi,
> > > > 
> > > > Running parallel fs_mark (0 size inodes, fsync on close) on a ramdisk
> > > > ends up with XFS in funny patterns.
> > > > 
> > > > procs -----------memory---------- ---swap-- -----io---- -system--
> > > > ----cpu----
> > > >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
> > > > id wa
> > > > 24  1   6576 166396    252 393676  132  140 16900 80666 21308 104333  1 84 14  1
> > > > 21  0   6712 433856    256 387080  100  224  9152 53487 13677 53732  0 55 45  0
> > > >  2  0   7068 463496    248 389100    0  364  2940 17896 4485 26122  0 33 65  2
> > > >  1  0   7068 464340    248 388928    0    0     0     0   66  207  0  0 100  0
> > > >  0  0   7068 464340    248 388928    0    0     0     0   79  200  0  0 100  0
> > > >  0  0   7068 464544    248 388928    0    0     0     0   65  199  0  0 100  0
> > > >  1  0   7068 464748    248 388928    0    0     0     0   79  201  0  0 100  0
> > > >  0  0   7068 465064    248 388928    0    0     0     0   66  202  0  0 100  0
> > > >  0  0   7068 465312    248 388928    0    0     0     0   80  200  0  0 100  0
> > > >  0  0   7068 465500    248 388928    0    0     0     0   65  199  0  0 100  0
> > > >  0  0   7068 465500    248 388928    0    0     0     0   80  202  0  0 100  0
> > > >  1  0   7068 465500    248 388928    0    0     0     0   66  203  0  0 100  0
> > > >  0  0   7068 465500    248 388928    0    0     0     0   79  200  0  0 100  0
> > > > 23  0   7068 460332    248 388800    0    0  1416  8896 1981 7142  0  1 99  0
> > > >  6  0   6968 360248    248 403736   56    0 15568 95171 19438 110825  1 79 21  0
> > > > 23  0   6904 248736    248 419704  392    0 17412 118270 20208 111396  1 82 17  0
> > > >  9  0   6884 266116    248 435904  128    0 14956 79756 18554 118020  1 76 23  0
> > > >  0  0   6848 219640    248 445760  212    0  9932 51572 12622 76491  0 60 40  0
> > > > 
> > > > Got a dump of sleeping tasks. Any ideas?
> > > 
> > > It is stuck waiting for log space to be freed up. Generally this is
> > > caused by log IO completion not occurring or an unflushable object
> > > preventing the tail from being moved forward.  What:
> > 
> > Yeah it's strage, it seems like it hits some timeout or gets kicked
> > along by background writeback or something. Missed wakeup somewhere?
> 
> No idea yet.

It's a maze of twisty passages. Essentially, though, the problem is
that the inode (or inode buffer) at the tail of the log cannot be flushed
because the inode buffer is stale, pinned and locked. Hence it
cannot be flushed by the xfsaild (can't lock the buffer) and
everything stopsi because there is no log space available.

There's a burst of activity every 30s because the xfssyncd forces
the log which causes unpinning, unlocking and freeing of the
troublesome buffer which them frees up some log space.
Unfortunately, once in this state, there's a good chance it will
immediately get stuck on another buffer as soon as the load ramps up
again.

I think the problem is in _xfs_buf_find() where we do the trylock
operation on the buffer. In xfs_buf_lock() (where we block on the
lock) we do this:

        if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
		xfs_log_force(bp->b_target->bt_mount, 0);

That is, if the buffer is pinned and stale, we do an async log force
before going to sleep on the lock. This prevents having to wait for
a long time for the buffer to become unlocked and was introduced in
commit ed3b4d6c ("xfs: Improve scalability of busy extent tracking).
The reason was:


    The only problem with this approach is that when a metadata buffer is
    marked stale (e.g. a directory block is removed), then buffer remains
    pinned and locked until the log goes to disk. The issue here is that
    if that stale buffer is reallocated in a subsequent transaction, the
    attempt to lock that buffer in the transaction will hang waiting
    the log to go to disk to unlock and unpin the buffer. Hence if
    someone tries to lock a pinned, stale, locked buffer we need to
    push on the log to get it unlocked ASAP. Effectively we are trading
    off a guaranteed log force for a much less common trigger for log
    force to occur.

What we are seeing here is exactly the same problem, only it hasn't
been noticed because we are doing a trylock operation and most of
the time failure to obtain the lock does not matter. however, it
certainly appears as we need to also trigger a log force if the
trylock fails on a pinned, stale buffer.

The patch below should fix the problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: push stale, pinned buffers on trylock failures

From: Dave Chinner <dchinner@redhat.com>

As reported by Nick Piggin, XFS is suffering from long pauses under
highly concurrent workloads when hosted on ramdisks. The problem is
that an inode buffer is stuck in the pinned state in memory and as a
result either the inode buffer or one of the inodes within the
buffer is stopping the tail of the log from being moved forward.

The system remains in this state until a periodic log force issued
by xfssyncd causes the buffer to be unpinned. The main problem is
that these are stale buffers, and are hence held locked until the
transaction/checkpoint that marked them state has been committed to
disk. When the filesystem gets into this state, only the xfssyncd
can cause the async transactions to be committed to disk and hence
unpin the inode buffer.

This problem was encountered when scaling the busy extent list, but
only the blocking lock interface was fixed to solve the problem.
Extend the same fix to the buffer trylock operations - if we fail to
lock a pinned, stale buffer, then force the log immediately so that
when the next attempt to lock it comes around, it will have been
unpinned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index aa1d353..94e69a7 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -488,29 +488,21 @@ found:
 	spin_unlock(&pag->pag_buf_lock);
 	xfs_perag_put(pag);
 
-	/* Attempt to get the semaphore without sleeping,
-	 * if this does not work then we need to drop the
-	 * spinlock and do a hard attempt on the semaphore.
+	/*
+	 * Attempt to get the semaphore without sleeping first. if we fail then
+	 * do a blocking lock if requested.
 	 */
-	if (down_trylock(&bp->b_sema)) {
+	if (xfs_buf_cond_lock(bp)) {
 		if (!(flags & XBF_TRYLOCK)) {
 			/* wait for buffer ownership */
 			xfs_buf_lock(bp);
 			XFS_STATS_INC(xb_get_locked_waited);
 		} else {
-			/* We asked for a trylock and failed, no need
-			 * to look at file offset and length here, we
-			 * know that this buffer at least overlaps our
-			 * buffer and is locked, therefore our buffer
-			 * either does not exist, or is this buffer.
-			 */
+			/* We asked for a trylock and failed.  */
 			xfs_buf_rele(bp);
 			XFS_STATS_INC(xb_busy_locked);
 			return NULL;
 		}
-	} else {
-		/* trylock worked */
-		XB_SET_OWNER(bp);
 	}
 
 	if (bp->b_flags & XBF_STALE) {
@@ -876,10 +868,18 @@ xfs_buf_rele(
  */
 
 /*
- *	Locks a buffer object, if it is not already locked.
- *	Note that this in no way locks the underlying pages, so it is only
- *	useful for synchronizing concurrent use of buffer objects, not for
- *	synchronizing independent access to the underlying pages.
+ *	Locks a buffer object, if it is not already locked.  Note that this in
+ *	no way locks the underlying pages, so it is only useful for
+ *	synchronizing concurrent use of buffer objects, not for synchronizing
+ *	independent access to the underlying pages.
+ *
+ *	If we come across a stale, pinned, locked buffer, we know that we are
+ *	being asked to lock a buffer that has been reallocated. Because it is
+ *	pinned, we know that the log has not been pushed to disk and hence it
+ *	will still be locked.  Rather than continuing to have trylock attempts
+ *	fail until someone else pushes the log, push it ourselves before
+ *	returning.  This means that the xfsaild will not get stuck trying
+ *	to push on stale inode buffers.
  */
 int
 xfs_buf_cond_lock(
@@ -890,6 +890,8 @@ xfs_buf_cond_lock(
 	locked = down_trylock(&bp->b_sema) == 0;
 	if (locked)
 		XB_SET_OWNER(bp);
+	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+		xfs_log_force(bp->b_target->bt_mount, 0);
 
 	trace_xfs_buf_cond_lock(bp, _RET_IP_);
 	return locked ? 0 : -EBUSY;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
