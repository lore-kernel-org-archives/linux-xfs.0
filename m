Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53636 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755650AbeFOLxh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 07:53:37 -0400
Date: Fri, 15 Jun 2018 07:53:35 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 2/2] xfs: use sync buffer I/O for sync delwri queue
 submission
Message-ID: <20180615115334.GC2857@bfoster>
References: <20180613110516.65494-1-bfoster@redhat.com>
 <20180613110516.65494-3-bfoster@redhat.com>
 <20180615112820.GB3230@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615112820.GB3230@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 04:28:20AM -0700, Christoph Hellwig wrote:
> On Wed, Jun 13, 2018 at 07:05:16AM -0400, Brian Foster wrote:
> > If a delwri queue occurs of a buffer that sits on a delwri queue
> > wait list, the queue sets _XBF_DELWRI_Q without changing the state
> > of ->b_list. This occurs, for example, if another thread beats the
> > current delwri waiter thread to the buffer lock after I/O
> > completion. Once the waiter acquires the lock, it removes the buffer
> > from the wait list and leaves a buffer with _XBF_DELWRI_Q set but
> > not populated on a list. This results in a lost buffer submission
> > and in turn can result in assert failures due to _XBF_DELWRI_Q being
> > set on buffer reclaim or filesystem lockups if the buffer happens to
> > cover an item in the AIL.
> > 
> > This problem has been reproduced by repeated iterations of xfs/305
> > on high CPU count (28xcpu) systems with limited memory (~1GB). Dirty
> > dquot reclaim races with an xfsaild push of a separate dquot backed
> > by the same buffer such that the buffer sits on the reclaim wait
> > list at the time xfsaild attempts to queue it. Since the latter
> > dquot has been flush locked but the underlying buffer not submitted
> > for I/O, the dquot pins the AIL and causes the filesystem to
> > livelock.
> > 
> > This race is essentially made possible by the buffer lock cycle
> > involved with waiting on a synchronous delwri queue submission.
> > Close the race by using synchronous buffer I/O for respective delwri
> > queue submission. This means the buffer remains locked across the
> > I/O and so is inaccessible from other contexts while in the
> > intermediate wait list state. The sync buffer I/O wait mechanism is
> > factored into a helper such that sync delwri buffer submission and
> > serialization are batched operations.
> > 
> > Designed-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_buf.c | 78 +++++++++++++++++++++++++-----------------------
> >  1 file changed, 41 insertions(+), 37 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index 112999ddb75e..113ab6426a40 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -1530,6 +1530,21 @@ xfs_buf_submit(
> >  	xfs_buf_rele(bp);
> >  }
> >  
> > +/*
> > + * Wait on a sync buffer.
> > + */
> > +static int
> > +xfs_buf_iowait(
> > +	struct xfs_buf	*bp)
> > +{
> > +	/* wait for completion before gathering the error from the buffer */
> 
> That comments seems to state the obvious based on the function name
> and top of function comment.  I'd just remove it.
> 

Ok, I'll fold it into the above.

> > @@ -2013,21 +2017,22 @@ xfs_buf_delwri_submit_buffers(
> >  		trace_xfs_buf_delwri_split(bp, _RET_IP_);
> >  
> >  		/*
> > +		 * If we have a wait list, each buffer (and associated delwri
> > +		 * queue reference) transfers to it and is submitted
> > +		 * synchronously. Otherwise, drop the buffer from the delwri
> > +		 * queue and submit async.
> >  		 */
> >  		bp->b_flags &= ~(_XBF_DELWRI_Q | XBF_WRITE_FAIL);
> > +		bp->b_flags |= XBF_WRITE;
> >  		if (wait_list) {
> > +			bp->b_flags &= ~XBF_ASYNC;
> >  			list_move_tail(&bp->b_list, wait_list);
> > +			__xfs_buf_submit(bp);
> > +		} else {
> > +			bp->b_flags |= XBF_ASYNC;
> >  			list_del_init(&bp->b_list);
> > +			xfs_buf_submit(bp);
> > +		}
> 
> Ok, that breaks my idea of just checking XBF_ASYNC in the previous
> reply.  But we could still do that with an explicit flag instead of
> the duplication.

Not totally sure I follow... do you essentially mean to rename
xfs_buf_submit_wait() -> xfs_buf_submit() and make the iowait
conditional on !XBF_ASYNC and absence of some new "sync_nowait"
parameter to the function? Could you clarify how you envision the
updated xfs_buf_submit() function signature to look?

If I'm following correctly, that seems fairly reasonable at first
thought. This is a separate patch though (refactoring the interface vs.
refactoring the implementation to fix a bug).

Brian

> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
