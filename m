Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6JvmbA085142 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 13:57:48 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	4qzfmAbL6L9qNWC7 for <xfs@oss.sgi.com>;
	Tue, 06 Nov 2012 11:59:44 -0800 (PST)
Date: Wed, 7 Nov 2012 06:59:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/6] xfs: fix buffer shudown reference count mismatch
Message-ID: <20121106195940.GA24575@dastard>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
	<20121102024351.GU29378@dastard>
	<20121102131326.GG12578@infradead.org>
	<20121102234741.GB29378@dastard>
	<20121106125949.GA32329@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121106125949.GA32329@infradead.org>
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

On Tue, Nov 06, 2012 at 07:59:49AM -0500, Christoph Hellwig wrote:
> On Sat, Nov 03, 2012 at 10:47:41AM +1100, Dave Chinner wrote:
> > I think that's irrelevant here - there will *never* be an IO waiter
> > at this point in time.  This processing is in log buffer IO
> > completion context, so the buffers are still pinned in memory. Hence
> > anyone trying to do IO on it will be waiting in xfs_buf_wait_unpin()
> > and never get to xfs_buf_iowait(). And because xfs_buf_wait_unpin()
> > is called with the buffer lock held, we'll never do the failure
> > handling in xfs_buf_item_unpin until the buffer IO is completed and
> > it is unlocked.
> 
> How do we manage to submit it synchronously then?

I don't follow what problem you are talking about here.
Fundamentally, races with IO are resolved like this regardless of
whether the racing Io is sync or async

				xfs_buf_lock
				make modifications
				.....
 xfs_buf_lock
 .....
				xfs_trans_commit
				....
				IOP_PIN()
				IOP_UNLOCK()
 
 xfs_buf_iorequest
   xfs_buf_wait_unpin()
.....

<shutdown, no new buffers can get to xfs_buf_iorequest>

				IOP_UNPIN(remove)
				xfs_buf_item_unpin(remove)
				wake_up_all(pin waiters)
				xfs_buf_lock()
				.....
 submit IO
 ......
 xfs_buf_ioend()
   wakeup(b_iowait)
 .....
 xfs_buf_relse()
 				xfs_buf_hold
 				xfs_buf_stale
				ASYNC
				xfs_buf_ioend()
				  bp->b_iodone()
				    xfs_buf_rele
				    xfs_buf_ioend()
				      xfs_buf_rele
				        xfs_buf_free


What this also points out is that we shoul dbe checking for shutdown
after xfs_buf_wait_unpin(), too, because otherwise we are submitting
IO after the shutdown is initiated....

> The inode and dquot
> reclaim xfs_bwrite calls already wait for an unpin first, so I don't
> think these are the problem.  The only other call on a live fs seems
> to xfs_qm_shake -> xfs_buf_delwri_submit, but that one does wait
> for the complete() call on b_iowait.  I suspect we are hitting that
> and due to it skipping the wait if b_ioerror is set and waiting on
> multiple buffers that complete together might hide the issue.

We are in a shutdown situation. xfs_buf_delwri_submit() goes via
xfs_bdstrat_cb() which will stop any new IOs from being submitted
via this path. If it is blocked on the above case, then it is
also resolved by the above case...

> __xfs_buf_delwri_submit for the wait == true case also seems to be
> the only place that actually skips the ispinned check.

Sure, but that we're in a shutdown situation, so it doesn't matter -
the buffer will never get to xfs_buf_wait_unpin() because of the
shutdown check in xfs_bdstrat_cb().

I still don't see the problem you are trying to explain to me. Maybe
I'm just being dense....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
