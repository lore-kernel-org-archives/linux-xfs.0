Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o04NpSXU157314 for <xfs@oss.sgi.com>; Mon, 4 Jan 2010 17:51:29 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B67E7EC6682
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2010 15:52:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	LMlUYhdUuz1GohI2 for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2010 15:52:18 -0800 (PST)
Date: Tue, 5 Jan 2010 10:52:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] XFS: Don't wake xfsbufd when idle
Message-ID: <20100104235215.GN13802@discord.disaster>
References: <1262400215-19443-1-git-send-email-david@fromorbit.com>
	<1262400215-19443-3-git-send-email-david@fromorbit.com>
	<20100104152048.GC24810@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100104152048.GC24810@infradead.org>
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

On Mon, Jan 04, 2010 at 10:20:48AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 02, 2010 at 01:43:35PM +1100, Dave Chinner wrote:
> > The xfsbufd wakes every xfsbufd_centisecs (once per second by
> > default) for each filesystem even when the filesystem is idle.
> > If the xfsbufd has nothing to do, put it into a long term sleep
> > and only wake it up when there is work pending (i.e. dirty
> > buffers to flush soon). This will make laptop power misers happy.
> > 
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_buf.c |   28 +++++++++++++++++++---------
> >  1 files changed, 19 insertions(+), 9 deletions(-)
> > 
> 
> >  STATIC int xfsbufd(void *);
> > -STATIC int xfsbufd_wakeup(int, gfp_t);
> > +STATIC int xfsbufd_wakeup_all(int, gfp_t);
> 
> this rename seems unrelated to the rest of the patch.

For memory reclaim we want to wake up the xfsbufd threads on every
single filesystem to free up as much memory as possible.  Hence with
the addition of demand flushing we have a situation now where we can
wakeup either a single xfsbufd or we need to wake up all of them.
It seemed right to make the distinction clear by renaming the
function. I can drop it if this doesn't make sense....

> > @@ -1595,6 +1595,11 @@ xfs_buf_delwri_queue(
> >  		list_del(&bp->b_list);
> >  	}
> >  
> > +	if (list_empty(dwq)) {
> > +		/* start xfsbufd as it has something to do now */
> > +		wake_up_process(bp->b_target->bt_task);
> > +	}
> 
> Does it make sense to wake xfsbufd before actually adding the item and
> unlocking the queue lock?  Shouldn't this be defered until after the
> addition?

I did it to avoid a temp var - if the xfsbufd runs before we finish
here then is will spin on the lock until we have added the buffer to
the list and dropped the lock. wake_up_process() is safe to call
under a spinlock, so that is not an issue here.

Also, the xfsbufd checks for an empty list before it sleeps, so on
wakeup it will always see the newly added buffer because it tries
unconditionally to dequeue buffers on wakeup. Hence I think this is
safe and race free.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
