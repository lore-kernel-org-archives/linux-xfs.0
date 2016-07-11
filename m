Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C22D47CA0
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 00:21:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 78B5D8F8230
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2016 22:21:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jRgBgUx5KkarVvxw for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2016 22:21:01 -0700 (PDT)
Date: Mon, 11 Jul 2016 15:20:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160711052057.GE1922@dastard>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160701223011.GA28130@bfoster.bfoster>
	<20160705164552.GA6317@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160705164552.GA6317@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 05, 2016 at 12:45:52PM -0400, Brian Foster wrote:
> On Fri, Jul 01, 2016 at 06:30:12PM -0400, Brian Foster wrote:
> > On Fri, Jul 01, 2016 at 08:44:57AM +1000, Dave Chinner wrote:
> > > On Thu, Jun 30, 2016 at 08:53:49AM -0400, Brian Foster wrote:
> > > > Newly allocated XFS metadata buffers are added to the LRU once the hold
> > > > count is released, which typically occurs after I/O completion. There is
> > > > no other mechanism at current that tracks the existence or I/O state of
> > > > a new buffer. Further, readahead I/O tends to be submitted
> > > > asynchronously by nature, which means the I/O can remain in flight and
> > > > actually complete long after the calling context is gone. This means
> > > > that file descriptors or any other holds on the filesystem can be
> > > > released, allowing the filesystem to be unmounted while I/O is still in
> > > > flight. When I/O completion occurs, core data structures may have been
> > > > freed, causing completion to run into invalid memory accesses and likely
> > > > to panic.
> > > > 
> > > > This problem is reproduced on XFS via directory readahead. A filesystem
> > > > is mounted, a directory is opened/closed and the filesystem immediately
> > > > unmounted. The open/close cycle triggers a directory readahead that if
> > > > delayed long enough, runs buffer I/O completion after the unmount has
> > > > completed.
> > > > 
> > > > To work around this problem, add readahead buffers to the LRU earlier
> > > > than other buffers (when the buffer is allocated, specifically). The
> > > > buffer hold count will ultimately remain until I/O completion, which
> > > > means any shrinker activity will skip the buffer until then. This makes
> > > > the buffer visible to xfs_wait_buftarg(), however, which ensures that an
> > > > unmount or quiesce waits for I/O completion appropriately.
> > > > 
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > This addresses the problem reproduced by the recently posted xfstests
> > > > test:
> > > > 
> > > >   http://thread.gmane.org/gmane.comp.file-systems.fstests/2740
> > > > 
> > > > This could probably be made more involved, i.e., to create another list
> > > > of buffers in flight or some such. This seems more simple/sane to me,
> > > > however, and survives my testing so far...
> > > > 
> > > > Brian
> > > > 
> > > >  fs/xfs/xfs_buf.c | 12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > index 4665ff6..3f03df9 100644
> > > > --- a/fs/xfs/xfs_buf.c
> > > > +++ b/fs/xfs/xfs_buf.c
> > > > @@ -590,8 +590,20 @@ xfs_buf_get_map(
> > > >  		return NULL;
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * If the buffer found doesn't match the one allocated above, somebody
> > > > +	 * else beat us to insertion and we can toss the new one.
> > > > +	 *
> > > > +	 * If we did add the buffer and it happens to be readahead, add to the
> > > > +	 * LRU now rather than waiting until the hold is released. Otherwise,
> > > > +	 * the buffer is not visible to xfs_wait_buftarg() while in flight and
> > > > +	 * nothing else prevents an unmount before I/O completion.
> > > > +	 */
> > > >  	if (bp != new_bp)
> > > >  		xfs_buf_free(new_bp);
> > > > +	else if (flags & XBF_READ_AHEAD &&
> > > > +		 list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
> > > > +		atomic_inc(&bp->b_hold);
> > > 
> > > This doesn't sit right with me. The LRU is for "unused" objects, and
> > > readahead objects are not unused until IO completes and nobody is
> > > waiting on them.
> > > 
> > > As it is, this points out another problem with readahead buffers -
> > > they aren't actually being cached properly because b_lru_ref == 0,
> > > which means they are immediately reclaimed on IO completion rather
> > > than being added to the LRU....
> > > 
> > > I also think that it's not sufficient to cover the generic case of
> > > async IO that has no waiter. i.e. we could do get_buf, submit async
> > > write, drop submitter reference, and now we have the same problem
> > > but on a write.  i.e. this problem is and async IO issue, not a
> > > readahead issue.
> > > 
> > > I think that it might be better to fix it by doing this:
> > > 
> > > 	1. ensure async IO submission always has b_lru_ref set, and
> > > 	if it isn't, set it to 1. This ensures the buffer will be
> > > 	added to the LRU on completion if it isn't already there.
> > > 
> > > 	2. keep a count of async buffer IO in progress. A per-cpu
> > > 	counter in the buftarg will be fine for this. Increment in
> > > 	xfs_buf_submit(), decrement in the xfs_buf_rele() call from
> > > 	xfs_buf_iodone() once we've determined if the buffer needs
> > > 	adding to the LRU or not.
> > > 
> > > 	3. make xfs_wait_buftarg() wait until the async IO count
> > > 	goes to zero before it gives up trying to release buffers on
> > > 	the LRU.
> > > 
> > 
> > After playing with this a bit this afternoon, I don't think it is so
> > straightforward to maintain consistency between xfs_buf_submit() and
> > xfs_buf_rele(). Some buffers are actually never released (superblock,
> > log buffers). Other buffers can actually be submitted for I/O multiple
> > times before they are ultimately released (e.g., log recovery buffer
> > read -> delwri submission).
> > 
> 
> I think I can get around these problems by skipping all uncached I/O and
> maintaining a per-buffer I/O count that is sunk into the global buftarg
> count once the buffer is released. E.g., something like the following
> patch. Not fully tested, but works on some quick tests...
....
> +static inline void
> +xfs_buf_rele_iocount(
> +	struct xfs_buf	*bp)
> +{
> +	int		val;
> +
> +	val = atomic_read(&bp->b_io_count);
> +	if (!val)
> +		return;
> +
> +	atomic_sub(val, &bp->b_io_count);
> +	percpu_counter_add(&bp->b_target->bt_io_count, -val);
> +	wake_up(&bp->b_target->bt_io_wait);
> +}
> +
>  /*
>   *	Releases a hold on the specified buffer.  If the
>   *	the hold count is 1, calls xfs_buf_free.
> @@ -880,8 +896,10 @@ xfs_buf_rele(
>  	if (!pag) {
>  		ASSERT(list_empty(&bp->b_lru));
>  		ASSERT(RB_EMPTY_NODE(&bp->b_rbnode));
> -		if (atomic_dec_and_test(&bp->b_hold))
> +		if (atomic_dec_and_test(&bp->b_hold)) {
> +			xfs_buf_rele_iocount(bp);
>  			xfs_buf_free(bp);
> +		}
>  		return;
>  	}
>  
> @@ -890,6 +908,9 @@ xfs_buf_rele(
>  	ASSERT(atomic_read(&bp->b_hold) > 0);
>  	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
>  		spin_lock(&bp->b_lock);
> +
> +		xfs_buf_rele_iocount(bp);
> +
>  		if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
>  			/*
>  			 * If the buffer is added to the LRU take a new
> @@ -1277,6 +1298,18 @@ _xfs_buf_ioapply(
>  	rw |= REQ_META;
>  
>  	/*
> +	 * XXX: uncached check indirectly filters out the sb buffer and log
> +	 * buffers (possibly others?), that are held and never released to the
> +	 * LRU
> +	 */
> +	if (bp->b_flags & XBF_ASYNC &&
> +	    bp->b_bn != XFS_BUF_DADDR_NULL &&	/* uncached */
> +	    atomic_read(&bp->b_lru_ref) && list_empty(&bp->b_lru)) {
> +		percpu_counter_inc(&bp->b_target->bt_io_count);
> +		atomic_inc(&bp->b_io_count);
> +	}

This seems rather specific and potentially fragile. Why not just
count /all/ IO using the per-cpu counter? If you're worried about
overhead, just use a large custom batch value so they are almost
never folded back into the global count and so the vast majority of
counter updates are single unlocked CPU instructions.

Counting everything is far better than needing to run through 4
branch tests on every buffer we submit IO on. i.e. counting
everything with an appropriately configured percpu counter is likely
to have a lower fast path overhead testing every buffer to capture
only the specific case in question...

> @@ -1533,6 +1566,8 @@ xfs_wait_buftarg(
>  	 * ensure here that all reference counts have been dropped before we
>  	 * start walking the LRU list.
>  	 */
> +	wait_event(btp->bt_io_wait,
> +		   (percpu_counter_sum(&btp->bt_io_count) == 0));
>  	drain_workqueue(btp->bt_mount->m_buf_workqueue);

I also don't think that per-buffer IO accounting is justified for
this. This:

	while(percpu_counter_sum(&btp->bt_io_count))
		delay(100);

Will do the same thing without adding an atomic counter inc/dec to
every buffer we want to capture here.

The waiting should probably also happen after we drain all the
workqueues, because the bt_io_count won't drop to zero until we
process all the pending IO completions on the work queues and
release the buffers...

> +	/* XXX: would atomic_t suffice? */
> +	struct percpu_counter	bt_io_count;

Too much cacheline contention in large machines to use an atomic_t
as a global counter.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
