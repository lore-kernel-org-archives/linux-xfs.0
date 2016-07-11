Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 62C827CA0
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 10:29:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D074FAC004
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 08:29:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Qb2OlNjwkgCfS3lF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jul 2016 08:29:24 -0700 (PDT)
Date: Mon, 11 Jul 2016 11:29:22 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160711152921.GB32896@bfoster.bfoster>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160701223011.GA28130@bfoster.bfoster>
	<20160705164552.GA6317@bfoster.bfoster>
	<20160711052057.GE1922@dastard>
	<20160711135251.GA32896@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160711135251.GA32896@bfoster.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 11, 2016 at 09:52:52AM -0400, Brian Foster wrote:
> On Mon, Jul 11, 2016 at 03:20:57PM +1000, Dave Chinner wrote:
> > On Tue, Jul 05, 2016 at 12:45:52PM -0400, Brian Foster wrote:
> > > On Fri, Jul 01, 2016 at 06:30:12PM -0400, Brian Foster wrote:
> > > > On Fri, Jul 01, 2016 at 08:44:57AM +1000, Dave Chinner wrote:
> > > > > On Thu, Jun 30, 2016 at 08:53:49AM -0400, Brian Foster wrote:
> > > > > > Newly allocated XFS metadata buffers are added to the LRU once the hold
> > > > > > count is released, which typically occurs after I/O completion. There is
> > > > > > no other mechanism at current that tracks the existence or I/O state of
> > > > > > a new buffer. Further, readahead I/O tends to be submitted
> > > > > > asynchronously by nature, which means the I/O can remain in flight and
> > > > > > actually complete long after the calling context is gone. This means
> > > > > > that file descriptors or any other holds on the filesystem can be
> > > > > > released, allowing the filesystem to be unmounted while I/O is still in
> > > > > > flight. When I/O completion occurs, core data structures may have been
> > > > > > freed, causing completion to run into invalid memory accesses and likely
> > > > > > to panic.
> > > > > > 
> > > > > > This problem is reproduced on XFS via directory readahead. A filesystem
> > > > > > is mounted, a directory is opened/closed and the filesystem immediately
> > > > > > unmounted. The open/close cycle triggers a directory readahead that if
> > > > > > delayed long enough, runs buffer I/O completion after the unmount has
> > > > > > completed.
> > > > > > 
> > > > > > To work around this problem, add readahead buffers to the LRU earlier
> > > > > > than other buffers (when the buffer is allocated, specifically). The
> > > > > > buffer hold count will ultimately remain until I/O completion, which
> > > > > > means any shrinker activity will skip the buffer until then. This makes
> > > > > > the buffer visible to xfs_wait_buftarg(), however, which ensures that an
> > > > > > unmount or quiesce waits for I/O completion appropriately.
> > > > > > 
> > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > ---
> > > > > > 
> > > > > > This addresses the problem reproduced by the recently posted xfstests
> > > > > > test:
> > > > > > 
> > > > > >   http://thread.gmane.org/gmane.comp.file-systems.fstests/2740
> > > > > > 
> > > > > > This could probably be made more involved, i.e., to create another list
> > > > > > of buffers in flight or some such. This seems more simple/sane to me,
> > > > > > however, and survives my testing so far...
> > > > > > 
> > > > > > Brian
> > > > > > 
> > > > > >  fs/xfs/xfs_buf.c | 12 ++++++++++++
> > > > > >  1 file changed, 12 insertions(+)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > > > index 4665ff6..3f03df9 100644
> > > > > > --- a/fs/xfs/xfs_buf.c
> > > > > > +++ b/fs/xfs/xfs_buf.c
> > > > > > @@ -590,8 +590,20 @@ xfs_buf_get_map(
> > > > > >  		return NULL;
> > > > > >  	}
> > > > > >  
> > > > > > +	/*
> > > > > > +	 * If the buffer found doesn't match the one allocated above, somebody
> > > > > > +	 * else beat us to insertion and we can toss the new one.
> > > > > > +	 *
> > > > > > +	 * If we did add the buffer and it happens to be readahead, add to the
> > > > > > +	 * LRU now rather than waiting until the hold is released. Otherwise,
> > > > > > +	 * the buffer is not visible to xfs_wait_buftarg() while in flight and
> > > > > > +	 * nothing else prevents an unmount before I/O completion.
> > > > > > +	 */
> > > > > >  	if (bp != new_bp)
> > > > > >  		xfs_buf_free(new_bp);
> > > > > > +	else if (flags & XBF_READ_AHEAD &&
> > > > > > +		 list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
> > > > > > +		atomic_inc(&bp->b_hold);
> > > > > 
> > > > > This doesn't sit right with me. The LRU is for "unused" objects, and
> > > > > readahead objects are not unused until IO completes and nobody is
> > > > > waiting on them.
> > > > > 
> > > > > As it is, this points out another problem with readahead buffers -
> > > > > they aren't actually being cached properly because b_lru_ref == 0,
> > > > > which means they are immediately reclaimed on IO completion rather
> > > > > than being added to the LRU....
> > > > > 
> > > > > I also think that it's not sufficient to cover the generic case of
> > > > > async IO that has no waiter. i.e. we could do get_buf, submit async
> > > > > write, drop submitter reference, and now we have the same problem
> > > > > but on a write.  i.e. this problem is and async IO issue, not a
> > > > > readahead issue.
> > > > > 
> > > > > I think that it might be better to fix it by doing this:
> > > > > 
> > > > > 	1. ensure async IO submission always has b_lru_ref set, and
> > > > > 	if it isn't, set it to 1. This ensures the buffer will be
> > > > > 	added to the LRU on completion if it isn't already there.
> > > > > 
> > > > > 	2. keep a count of async buffer IO in progress. A per-cpu
> > > > > 	counter in the buftarg will be fine for this. Increment in
> > > > > 	xfs_buf_submit(), decrement in the xfs_buf_rele() call from
> > > > > 	xfs_buf_iodone() once we've determined if the buffer needs
> > > > > 	adding to the LRU or not.
> > > > > 
> > > > > 	3. make xfs_wait_buftarg() wait until the async IO count
> > > > > 	goes to zero before it gives up trying to release buffers on
> > > > > 	the LRU.
> > > > > 
...
> So what is your preference out of the possible approaches here? AFAICS,
> we have the following options:
> 
> 1.) The original "add readahead to LRU early" approach.
> 	Pros: simple one-liner
> 	Cons: bit of a hack, only covers readahead scenario
> 2.) Defer I/O count decrement to buffer release (this patch).
> 	Pros: should cover all cases (reads/writes)
> 	Cons: more complex (requires per-buffer accounting, etc.)
> 3.) Raw (buffer or bio?) I/O count (no defer to buffer release)
> 	Pros: eliminates some complexity from #2
> 	Cons: still more complex than #1, racy in that decrement does
> 	not serialize against LRU addition (requires drain_workqueue(),
> 	which still doesn't cover error conditions)
> 
> As noted above, option #3 also allows for either a buffer based count or
> bio based count, the latter of which might simplify things a bit further
> (TBD). Thoughts?
> 

FWIW, the following is a slightly cleaned up version of my initial
approach (option #3 above). Note that the flag is used to help deal with
varying ioend behavior. E.g., xfs_buf_ioend() is called once for some
buffers, multiple times for others with an iodone callback, that
behavior changes in some cases when an error is set, etc. (I'll add
comments before an official post.)

Brian

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4665ff6..45d3ddd 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1018,7 +1018,10 @@ xfs_buf_ioend(
 
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
-	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
+	if (bp->b_flags & XBF_IN_FLIGHT)
+		percpu_counter_dec(&bp->b_target->bt_io_count);
+
+	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD | XBF_IN_FLIGHT);
 
 	/*
 	 * Pull in IO completion errors now. We are guaranteed to be running
@@ -1341,6 +1344,11 @@ xfs_buf_submit(
 	 * xfs_buf_ioend too early.
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
+	if (bp->b_flags & XBF_ASYNC) {
+		percpu_counter_inc(&bp->b_target->bt_io_count);
+		bp->b_flags |= XBF_IN_FLIGHT;
+	}
+
 	_xfs_buf_ioapply(bp);
 
 	/*
@@ -1533,6 +1541,8 @@ xfs_wait_buftarg(
 	 * ensure here that all reference counts have been dropped before we
 	 * start walking the LRU list.
 	 */
+	while (percpu_counter_sum(&btp->bt_io_count))
+		delay(100);
 	drain_workqueue(btp->bt_mount->m_buf_workqueue);
 
 	/* loop until there is nothing left on the lru list. */
@@ -1629,6 +1639,8 @@ xfs_free_buftarg(
 	struct xfs_buftarg	*btp)
 {
 	unregister_shrinker(&btp->bt_shrinker);
+	ASSERT(percpu_counter_sum(&btp->bt_io_count) == 0);
+	percpu_counter_destroy(&btp->bt_io_count);
 	list_lru_destroy(&btp->bt_lru);
 
 	if (mp->m_flags & XFS_MOUNT_BARRIER)
@@ -1693,6 +1705,9 @@ xfs_alloc_buftarg(
 	if (list_lru_init(&btp->bt_lru))
 		goto error;
 
+	if (percpu_counter_init(&btp->bt_io_count, 0, GFP_KERNEL))
+		goto error;
+
 	btp->bt_shrinker.count_objects = xfs_buftarg_shrink_count;
 	btp->bt_shrinker.scan_objects = xfs_buftarg_shrink_scan;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 8bfb974..e1f95e0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -43,6 +43,7 @@ typedef enum {
 #define XBF_READ	 (1 << 0) /* buffer intended for reading from device */
 #define XBF_WRITE	 (1 << 1) /* buffer intended for writing to device */
 #define XBF_READ_AHEAD	 (1 << 2) /* asynchronous read-ahead */
+#define XBF_IN_FLIGHT	 (1 << 3)
 #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
@@ -115,6 +116,8 @@ typedef struct xfs_buftarg {
 	/* LRU control structures */
 	struct shrinker		bt_shrinker;
 	struct list_lru		bt_lru;
+
+	struct percpu_counter	bt_io_count;
 } xfs_buftarg_t;
 
 struct xfs_buf;

> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
