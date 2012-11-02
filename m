Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2Njo7v205521 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 18:45:51 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wl1zsJ1NOU2ZlnwU for <xfs@oss.sgi.com>;
	Fri, 02 Nov 2012 16:47:43 -0700 (PDT)
Date: Sat, 3 Nov 2012 10:47:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: fix buffer shudown reference count mismatch
Message-ID: <20121102234741.GB29378@dastard>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
	<20121102024351.GU29378@dastard>
	<20121102131326.GG12578@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121102131326.GG12578@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, Nov 02, 2012 at 09:13:26AM -0400, Christoph Hellwig wrote:
> > The fix that I've done here means all buffers going through this
> > path will take an extra reference, but that reference is only
> > dropped on async buffers. Because all the buffers are markd stale,
> > they are removed from the LRU, and so xfs_buftarg_wait() during
> > unmount does not find them and hence the remaining reference is
> > never removed. Hence the perag reference still remains, and we
> > assert fail there.
> > 
> > Solution seems simple - set the XBF_ASYNC flag on all buffers so
> > that the last reference is taken away correctly. Testing that now.
> 
> I don't like this.  ioend processing is very different for synchrous
> writes, with the most important difference being that synchronous
> writes need to wake the submitter at I/O completion.

I think that's irrelevant here - there will *never* be an IO waiter
at this point in time.  This processing is in log buffer IO
completion context, so the buffers are still pinned in memory. Hence
anyone trying to do IO on it will be waiting in xfs_buf_wait_unpin()
and never get to xfs_buf_iowait(). And because xfs_buf_wait_unpin()
is called with the buffer lock held, we'll never do the failure
handling in xfs_buf_item_unpin until the buffer IO is completed and
it is unlocked.

FWIW, this also indicates problem in IO submission -
xfs_buf_wait_unpin() occurs after the shutdown checks, so we could
wake a pinned waiter that then issues IO after the shutdown has
started because there are no shutdown checks after
xfs_buf_wait_unpin() is called....

> From all I can
> see your v2 patch breaks that beahviour.  For 3.7-rc I'd suggest
> taking the additional reference conditionally.

It's not a conditional reference - every buffer needs it. Right now
we have an unconditional use after free because bp->b_iodone() drops
the last reference on the buffer, then calls xfs_buf_iodone() again.
The only thing the XBF_ASYNC flag cwcurrently determines is is
whether we get an assert failure by calling xfs_buf_rele() on a
freed buffer or not.

What we are doing here is ioend processing without actually having
issued an IO. i.e. we are using the ioend processing for error
handling, not for IO completion. Hence we have to set the buffer up
as though it has been under IO so that ioend processing does exactly
what we want. And what we want is the buffer to be unconditionally
freed at the end of ioend processing.

What we end up with when we hit the "remove && freed" case is
a buffer that is not pinned, is not under IO and will have
no new references because we are in a shutdown situation. We need to
mark the buffer stale to ensure it is not written, and free the
buffer when the last reference goes away. That reference is the
reference the transaction subsystem owns and it guarantees that
there is no IO completion waiters on the buffer.

IOWs, we have two options after taking an extra reference:

	1. clear the XBF_ASYNC flag unconditionally and call
	xfs_buf_relse() ourselves to unlock and free the buffer
	2. set the XBF_ASYNC flag unconditionally and let
	xfs_buf_ioend() call xfs_buf_relse() itself.

I tossed a coin, and it came down on #2. Either way will work, but
we need that extra reference on all buffers passing through this
code...

> For 3.8 I'm going to look into simply acquiring an additional reference
> for synchronous writes during I/O submission to kill these special cases
> all over the buffer code.

Sure, but that's a different issue, not directly realted to fixing
the bug at hand. It would also mean that if we choose #1, we'll need
to take 2 references for the IO for this error handling path. That
seems like a much stranger special case than just using async buffer
IO completion to do the work we need...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
