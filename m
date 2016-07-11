Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 77E877CA0
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 08:52:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04BD1AC001
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2016 06:52:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yDSaGWIVgsE5eF6l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jul 2016 06:52:54 -0700 (PDT)
Date: Mon, 11 Jul 2016 09:52:52 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160711135251.GA32896@bfoster.bfoster>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160701223011.GA28130@bfoster.bfoster>
	<20160705164552.GA6317@bfoster.bfoster>
	<20160711052057.GE1922@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160711052057.GE1922@dastard>
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

On Mon, Jul 11, 2016 at 03:20:57PM +1000, Dave Chinner wrote:
> On Tue, Jul 05, 2016 at 12:45:52PM -0400, Brian Foster wrote:
> > On Fri, Jul 01, 2016 at 06:30:12PM -0400, Brian Foster wrote:
> > > On Fri, Jul 01, 2016 at 08:44:57AM +1000, Dave Chinner wrote:
> > > > On Thu, Jun 30, 2016 at 08:53:49AM -0400, Brian Foster wrote:
> > > > > Newly allocated XFS metadata buffers are added to the LRU once the hold
> > > > > count is released, which typically occurs after I/O completion. There is
> > > > > no other mechanism at current that tracks the existence or I/O state of
> > > > > a new buffer. Further, readahead I/O tends to be submitted
> > > > > asynchronously by nature, which means the I/O can remain in flight and
> > > > > actually complete long after the calling context is gone. This means
> > > > > that file descriptors or any other holds on the filesystem can be
> > > > > released, allowing the filesystem to be unmounted while I/O is still in
> > > > > flight. When I/O completion occurs, core data structures may have been
> > > > > freed, causing completion to run into invalid memory accesses and likely
> > > > > to panic.
> > > > > 
> > > > > This problem is reproduced on XFS via directory readahead. A filesystem
> > > > > is mounted, a directory is opened/closed and the filesystem immediately
> > > > > unmounted. The open/close cycle triggers a directory readahead that if
> > > > > delayed long enough, runs buffer I/O completion after the unmount has
> > > > > completed.
> > > > > 
> > > > > To work around this problem, add readahead buffers to the LRU earlier
> > > > > than other buffers (when the buffer is allocated, specifically). The
> > > > > buffer hold count will ultimately remain until I/O completion, which
> > > > > means any shrinker activity will skip the buffer until then. This makes
> > > > > the buffer visible to xfs_wait_buftarg(), however, which ensures that an
> > > > > unmount or quiesce waits for I/O completion appropriately.
> > > > > 
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > > 
> > > > > This addresses the problem reproduced by the recently posted xfstests
> > > > > test:
> > > > > 
> > > > >   http://thread.gmane.org/gmane.comp.file-systems.fstests/2740
> > > > > 
> > > > > This could probably be made more involved, i.e., to create another list
> > > > > of buffers in flight or some such. This seems more simple/sane to me,
> > > > > however, and survives my testing so far...
> > > > > 
> > > > > Brian
> > > > > 
> > > > >  fs/xfs/xfs_buf.c | 12 ++++++++++++
> > > > >  1 file changed, 12 insertions(+)
> > > > > 
> > > > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > > > index 4665ff6..3f03df9 100644
> > > > > --- a/fs/xfs/xfs_buf.c
> > > > > +++ b/fs/xfs/xfs_buf.c
> > > > > @@ -590,8 +590,20 @@ xfs_buf_get_map(
> > > > >  		return NULL;
> > > > >  	}
> > > > >  
> > > > > +	/*
> > > > > +	 * If the buffer found doesn't match the one allocated above, somebody
> > > > > +	 * else beat us to insertion and we can toss the new one.
> > > > > +	 *
> > > > > +	 * If we did add the buffer and it happens to be readahead, add to the
> > > > > +	 * LRU now rather than waiting until the hold is released. Otherwise,
> > > > > +	 * the buffer is not visible to xfs_wait_buftarg() while in flight and
> > > > > +	 * nothing else prevents an unmount before I/O completion.
> > > > > +	 */
> > > > >  	if (bp != new_bp)
> > > > >  		xfs_buf_free(new_bp);
> > > > > +	else if (flags & XBF_READ_AHEAD &&
> > > > > +		 list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
> > > > > +		atomic_inc(&bp->b_hold);
> > > > 
> > > > This doesn't sit right with me. The LRU is for "unused" objects, and
> > > > readahead objects are not unused until IO completes and nobody is
> > > > waiting on them.
> > > > 
> > > > As it is, this points out another problem with readahead buffers -
> > > > they aren't actually being cached properly because b_lru_ref == 0,
> > > > which means they are immediately reclaimed on IO completion rather
> > > > than being added to the LRU....
> > > > 
> > > > I also think that it's not sufficient to cover the generic case of
> > > > async IO that has no waiter. i.e. we could do get_buf, submit async
> > > > write, drop submitter reference, and now we have the same problem
> > > > but on a write.  i.e. this problem is and async IO issue, not a
> > > > readahead issue.
> > > > 
> > > > I think that it might be better to fix it by doing this:
> > > > 
> > > > 	1. ensure async IO submission always has b_lru_ref set, and
> > > > 	if it isn't, set it to 1. This ensures the buffer will be
> > > > 	added to the LRU on completion if it isn't already there.
> > > > 
> > > > 	2. keep a count of async buffer IO in progress. A per-cpu
> > > > 	counter in the buftarg will be fine for this. Increment in
> > > > 	xfs_buf_submit(), decrement in the xfs_buf_rele() call from
> > > > 	xfs_buf_iodone() once we've determined if the buffer needs
> > > > 	adding to the LRU or not.
> > > > 
> > > > 	3. make xfs_wait_buftarg() wait until the async IO count
> > > > 	goes to zero before it gives up trying to release buffers on
> > > > 	the LRU.
> > > > 
> > > 
> > > After playing with this a bit this afternoon, I don't think it is so
> > > straightforward to maintain consistency between xfs_buf_submit() and
> > > xfs_buf_rele(). Some buffers are actually never released (superblock,
> > > log buffers). Other buffers can actually be submitted for I/O multiple
> > > times before they are ultimately released (e.g., log recovery buffer
> > > read -> delwri submission).
> > > 
> > 
> > I think I can get around these problems by skipping all uncached I/O and
> > maintaining a per-buffer I/O count that is sunk into the global buftarg
> > count once the buffer is released. E.g., something like the following
> > patch. Not fully tested, but works on some quick tests...
> ....
...
> > @@ -1277,6 +1298,18 @@ _xfs_buf_ioapply(
> >  	rw |= REQ_META;
> >  
> >  	/*
> > +	 * XXX: uncached check indirectly filters out the sb buffer and log
> > +	 * buffers (possibly others?), that are held and never released to the
> > +	 * LRU
> > +	 */
> > +	if (bp->b_flags & XBF_ASYNC &&
> > +	    bp->b_bn != XFS_BUF_DADDR_NULL &&	/* uncached */
> > +	    atomic_read(&bp->b_lru_ref) && list_empty(&bp->b_lru)) {
> > +		percpu_counter_inc(&bp->b_target->bt_io_count);
> > +		atomic_inc(&bp->b_io_count);
> > +	}
> 
> This seems rather specific and potentially fragile. Why not just
> count /all/ IO using the per-cpu counter? If you're worried about
> overhead, just use a large custom batch value so they are almost
> never folded back into the global count and so the vast majority of
> counter updates are single unlocked CPU instructions.
> 

I'm not really worried about overhead (yet). I'm just trying to come up
with a relatively straightforward scheme that solves the problem. The
extra checks here are basically the cost of deferring the I/O count
decrement to buffer release.

> Counting everything is far better than needing to run through 4
> branch tests on every buffer we submit IO on. i.e. counting
> everything with an appropriately configured percpu counter is likely
> to have a lower fast path overhead testing every buffer to capture
> only the specific case in question...
> 

See my immediately previous reply to this thread. I hadn't posted code,
but the initial variant of this patch uses more of a pure I/O count. The
primary drawback with that is that it is racy in that the I/O count is
decremented before the buffer is added to the LRU. The workqueue drain
helps prevent the original problem, but at the same time I'm not sure it
makes this approach any more robust than the original one-liner patch.

I also defined a new buffer flag in that version to help simplify
dealing with variable behavior between error cases and iodone handlers
and whatnot. That trickiness might be avoided by pushing the counter
further down to more of a bio count (e.g., a global variant of
bp>b_io_remaining count), but I haven't experimented with that as of
yet.

> > @@ -1533,6 +1566,8 @@ xfs_wait_buftarg(
> >  	 * ensure here that all reference counts have been dropped before we
> >  	 * start walking the LRU list.
> >  	 */
> > +	wait_event(btp->bt_io_wait,
> > +		   (percpu_counter_sum(&btp->bt_io_count) == 0));
> >  	drain_workqueue(btp->bt_mount->m_buf_workqueue);
> 
> I also don't think that per-buffer IO accounting is justified for
> this. This:
> 
> 	while(percpu_counter_sum(&btp->bt_io_count))
> 		delay(100);
> 
> Will do the same thing without adding an atomic counter inc/dec to
> every buffer we want to capture here.
> 

The purpose of the per-buffer I/O accounting is not to drive the
synchronization mechanism. The purpose is to cover the cases where
buffers are submitted for I/O multiple times before they are released
(also mentioned in my immediately previous reply). Otherwise, the
counter gets out of whack and never returns to 0.

This is required for an implementation that defers decrementing the I/O
count to buffer release time (when the buffer is added to the LRU). I
actually think this patch as posted doesn't quite order things correctly
in that regard, but the broader point holds I think. This additional
accounting isn't required for a pure I/O counter (inc on submit, dec on
complete).

> The waiting should probably also happen after we drain all the
> workqueues, because the bt_io_count won't drop to zero until we
> process all the pending IO completions on the work queues and
> release the buffers...
> 

I'm not sure it matters much for this implementation. I figured it more
natural to wait for pending I/O followed by completions. Note that this
order might be more critical with a pure I/O count approach because the
drain_workqueue() is what ends up serializing the addition to the LRU,
and that only happens if we wait for the I/O to complete first.

But I'll look at this more closely once we've established a direction...

> > +	/* XXX: would atomic_t suffice? */
> > +	struct percpu_counter	bt_io_count;
> 
> Too much cacheline contention in large machines to use an atomic_t
> as a global counter.
> 

Ok.

So what is your preference out of the possible approaches here? AFAICS,
we have the following options:

1.) The original "add readahead to LRU early" approach.
	Pros: simple one-liner
	Cons: bit of a hack, only covers readahead scenario
2.) Defer I/O count decrement to buffer release (this patch).
	Pros: should cover all cases (reads/writes)
	Cons: more complex (requires per-buffer accounting, etc.)
3.) Raw (buffer or bio?) I/O count (no defer to buffer release)
	Pros: eliminates some complexity from #2
	Cons: still more complex than #1, racy in that decrement does
	not serialize against LRU addition (requires drain_workqueue(),
	which still doesn't cover error conditions)

As noted above, option #3 also allows for either a buffer based count or
bio based count, the latter of which might simplify things a bit further
(TBD). Thoughts?

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
