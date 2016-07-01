Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 37DD37CA0
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 23:34:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EF2E08F8040
	for <xfs@oss.sgi.com>; Thu, 30 Jun 2016 21:34:00 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	wPECkIYQ2NQhWhhM for <xfs@oss.sgi.com>;
	Thu, 30 Jun 2016 21:33:54 -0700 (PDT)
Date: Fri, 1 Jul 2016 14:33:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: add readahead bufs to lru early to prevent
	post-unmount panic
Message-ID: <20160701043331.GV12670@dastard>
References: <1467291229-13548-1-git-send-email-bfoster@redhat.com>
	<20160630224457.GT12670@dastard>
	<20160630235621.GA44823@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160630235621.GA44823@bfoster.bfoster>
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

On Thu, Jun 30, 2016 at 07:56:21PM -0400, Brian Foster wrote:
> On Fri, Jul 01, 2016 at 08:44:57AM +1000, Dave Chinner wrote:
> > On Thu, Jun 30, 2016 at 08:53:49AM -0400, Brian Foster wrote:
> > > Newly allocated XFS metadata buffers are added to the LRU once the hold
> > > count is released, which typically occurs after I/O completion. There is
> > > no other mechanism at current that tracks the existence or I/O state of
> > > a new buffer. Further, readahead I/O tends to be submitted
> > > asynchronously by nature, which means the I/O can remain in flight and
> > > actually complete long after the calling context is gone. This means
> > > that file descriptors or any other holds on the filesystem can be
> > > released, allowing the filesystem to be unmounted while I/O is still in
> > > flight. When I/O completion occurs, core data structures may have been
> > > freed, causing completion to run into invalid memory accesses and likely
> > > to panic.
> > > 
> > > This problem is reproduced on XFS via directory readahead. A filesystem
> > > is mounted, a directory is opened/closed and the filesystem immediately
> > > unmounted. The open/close cycle triggers a directory readahead that if
> > > delayed long enough, runs buffer I/O completion after the unmount has
> > > completed.
> > > 
> > > To work around this problem, add readahead buffers to the LRU earlier
> > > than other buffers (when the buffer is allocated, specifically). The
> > > buffer hold count will ultimately remain until I/O completion, which
> > > means any shrinker activity will skip the buffer until then. This makes
> > > the buffer visible to xfs_wait_buftarg(), however, which ensures that an
> > > unmount or quiesce waits for I/O completion appropriately.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > This addresses the problem reproduced by the recently posted xfstests
> > > test:
> > > 
> > >   http://thread.gmane.org/gmane.comp.file-systems.fstests/2740
> > > 
> > > This could probably be made more involved, i.e., to create another list
> > > of buffers in flight or some such. This seems more simple/sane to me,
> > > however, and survives my testing so far...
> > > 
> > > Brian
> > > 
> > >  fs/xfs/xfs_buf.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index 4665ff6..3f03df9 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -590,8 +590,20 @@ xfs_buf_get_map(
> > >  		return NULL;
> > >  	}
> > >  
> > > +	/*
> > > +	 * If the buffer found doesn't match the one allocated above, somebody
> > > +	 * else beat us to insertion and we can toss the new one.
> > > +	 *
> > > +	 * If we did add the buffer and it happens to be readahead, add to the
> > > +	 * LRU now rather than waiting until the hold is released. Otherwise,
> > > +	 * the buffer is not visible to xfs_wait_buftarg() while in flight and
> > > +	 * nothing else prevents an unmount before I/O completion.
> > > +	 */
> > >  	if (bp != new_bp)
> > >  		xfs_buf_free(new_bp);
> > > +	else if (flags & XBF_READ_AHEAD &&
> > > +		 list_lru_add(&bp->b_target->bt_lru, &bp->b_lru))
> > > +		atomic_inc(&bp->b_hold);
> > 
> > This doesn't sit right with me. The LRU is for "unused" objects, and
> > readahead objects are not unused until IO completes and nobody is
> > waiting on them.
> > 
> 
> Sure, but don't buffers remain on the LRU once they are reused?

Yes, but that's once the contents have been used.

> My
> impression is that this patch really doesn't change behavior in that
> regard.

Not really - but it makes the readahead buffers completely different
to the rest of the buffers on the LRU in that they don't contain
valid data.

For the same reason we also don't add buffers at creation time
because they don't hold valid data until after the code that has
created/read in the data has released it.....

> IOWs, the buffer is going to end up on the LRU either way and
> either end up disposed if it is never actually accessed or "used"
> otherwise and the hold count is bumped. Further, isn't the hold count
> mechanism precisely to handle "used" buffers on the LRU?

... hence we only add the buffer to the LRU once the initial hold
count reaches zero and the owner has indicated that the buffer
should be moved to the LRU by setting b_lru_ref. Once we've added
the buffer to the LRU, we add a reference count that persists untile
b_lru_ref is decremented to zero. At that point, we remove the
euffer from the LRU and release it. That (b_lru_ref == 0) then
triggers the buffer to be freed....

Note also that buffers that contain stale data (i.e. XBF_STALE) are
not added to the LRU and xfs_buf_stale() removes buffers from the
LRU, so shortcutting the above reclaim lifecycle in the case where a
user invalidates the contents of the buffer. The end result is the
same - there are no buffers with stale contents on the LRU.

readahead is a special case - there is no accessor to say "cache
this buffer for N references", but we have to keep it around for
some time so that readahead is effective. We don't want to add it
before we've done IO on it, and realistically we should only add it
to the LRU if there was no IO error. We've had to work around bugs
introduced by caching failed readahead buffers on the LRU in the
past....

> > As it is, this points out another problem with readahead buffers -
> > they aren't actually being cached properly because b_lru_ref == 0,
> > which means they are immediately reclaimed on IO completion rather
> > than being added to the LRU....
> > 
> 
> Not following... _xfs_buf_alloc() sets b_lru_ref to 1 and I don't see it
> set/decremented unless we stale or dispose it. What am I missing?

Sorry, I misread the cscope output I was looking at to quickly
remind me of how it all worked - xfs_buf_stale() sets it to zero,
not _xfs_buf_alloc().

> > I also think that it's not sufficient to cover the generic case of
> > async IO that has no waiter. i.e. we could do get_buf, submit async
> > write, drop submitter reference, and now we have the same problem
> > but on a write.  i.e. this problem is and async IO issue, not a
> > readahead issue.
> > 
> 
> Indeed. I thought about making the current patch check for ASYNC, but
> opted to try and make it more isolated (I suppose ASYNC|READAHEAD would
> have been moreso).
> 
> The other thought I had was to change where buffers are added to the LRU
> altogether, but didn't want to jump right to that. Is there any issue
> with populating the LRU with initially held buffers as such, or any
> particular reason LRU addition was deferred to I/O completion in the
> first place?

Yes, because then we have to deal with buffers that fail memory
allocation, read IO or are allocated just to invalidate a range of
disk blocks during a transaction (e.g. removing a remote attribute).
There are probably other cases where we don't want to put buffers we
allocate onto the LRU, but I can't think of any more right now.

> > I think that it might be better to fix it by doing this:
> > 
> > 	1. ensure async IO submission always has b_lru_ref set, and
> > 	if it isn't, set it to 1. This ensures the buffer will be
> > 	added to the LRU on completion if it isn't already there.
> > 
> 
> See above. I'm not following why this is necessary (if it is, it seems
> indicative of a bug).
> 
> > 	2. keep a count of async buffer IO in progress. A per-cpu
> > 	counter in the buftarg will be fine for this. Increment in
> > 	xfs_buf_submit(), decrement in the xfs_buf_rele() call from
> > 	xfs_buf_iodone() once we've determined if the buffer needs
> > 	adding to the LRU or not.
> > 
> > 	3. make xfs_wait_buftarg() wait until the async IO count
> > 	goes to zero before it gives up trying to release buffers on
> > 	the LRU.
> > 
> 
> This is along the lines of what I was thinking wrt to a list (explicit
> I/O tracking one way or another). The count is more simple and does
> cover the arbitrary read/write case, but is still more code and seems
> slightly duplicative to me because in most cases the LRU wait already
> handles this.

Sure, but adding a list means you need global locks and when you
have lots of concurrent readahead going on that will be a problem.
readahead is supposed to have minimal overhead, so anything that
adds submission serialisation is not the best idea...  The counter
has almost no overhead for the async IO case, read or write, and
that's all we need to allow the IO to complete safely during
unmount.

> I'm also not totally sure we need to handle the write
> case. Are we susceptible to this issue anywhere that isn't already
> protected by the sb write protection mechanism, for example?

We can do metadata buffer writes outside the superblock write
protection context.  A good example of that is log recovery on
read-only filesystems....

> OTOH, explicit tracking might provide a more generic way to deal with
> uncached buffers as opposed to lock cycling.

Well, only if those uncached buffers are using async IO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
