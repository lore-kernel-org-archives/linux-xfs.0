Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p380bwcC141665 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 19:37:58 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FD2DBA1234
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2011 17:41:14 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	axtUMWeBbcTIJvl9 for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2011 17:41:14 -0700 (PDT)
Date: Fri, 8 Apr 2011 10:41:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/9] xfs: introduce a xfssyncd workqueue
Message-ID: <20110408004111.GI30279@dastard>
References: <1302141445-27457-1-git-send-email-david@fromorbit.com>
	<1302141445-27457-3-git-send-email-david@fromorbit.com>
	<1302212093.2576.610.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1302212093.2576.610.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 07, 2011 at 04:34:53PM -0500, Alex Elder wrote:
> On Thu, 2011-04-07 at 11:57 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > All of the work xfssyncd does is background functionality. There is
> > no need for a thread per filesystem to do this work - it can al be
> > managed by a global workqueue now they manage concurrency
> > effectively.
> > 
> > Introduce a new gglobal xfssyncd workqueue, and convert the periodic
> > work to use this new functionality. To do this, use a delayed work
> > construct to schedule the next running of the periodic sync work
> > for the filesystem. When the sync work is complete, queue a new
> > delayed work for the next running of the sync work.
> > 
> > For laptop mode, we wait on completion for the sync works, so ensure
> > that the sync work queuing interface can flush and wait for work to
> > complete to enable the work queue infrastructure to replace the
> > current sequence number and wakeup that is used.
> > 
> > Because the sync work does non-trivial amounts of work, mark the
> > new work queue as CPU intensive.
> 
> (I've now seen your next patch so my confusion is I
> think resolved.  I'm sending the following as I originally
> wrote it anyway.)
> 
> I have two comments below.  One is something that can be
> fixed later and another I think may be a problem.  I also
> was just a little confused about something.
> 
> The confusing thing is that you still are spawning a kernel
> thread per filesystem in xfs_syncd_init(), which is still
> waiting xfs_syncd_centisecs between runs, and which is
> then running work queued on the mount point's m_sync_list.
> 
> I *think* the reason it's confusing is just that your
> description talks about "all of the work xfssyncd does,"

".. is background functionality." The rest of the patch description
talks only about introducing the workqueue and converting a single
operation to use it:

> while this patch just pulls out the data syncing portion
> of what it does.
>
> The patch preserves the ability to make
> use of the per-FS periodic syncer thread to flush inodes
> (via xfs_flush_inodes()).

Right - that's converted in the next patch, and the unused syncd
thread is removed.

> 
> In any case, with the exception of the timeout thing
> below (which ought to be easy to fix) the code looks
> correct to me.  It just took me a little while to
> reconcile the what the delayed workqueues (named
> "xfssyncd") do, versus what the xfssyncd" threads
> that remain do.
> 
> Despite the above, you can consider this reviewed by me.
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/linux-2.6/xfs_super.c |   24 +++++------
> >  fs/xfs/linux-2.6/xfs_sync.c  |   86 ++++++++++++++++++++---------------------
> >  fs/xfs/linux-2.6/xfs_sync.h  |    2 +
> >  fs/xfs/xfs_mount.h           |    4 +-
> >  4 files changed, 56 insertions(+), 60 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
> > index 1ba5c45..99dded9 100644
> > --- a/fs/xfs/linux-2.6/xfs_super.c
> > +++ b/fs/xfs/linux-2.6/xfs_super.c
> 
> . . .
> 
> > @@ -1833,13 +1822,21 @@ init_xfs_fs(void)
> >  	if (error)
> >  		goto out_cleanup_procfs;
> >  
> > +	xfs_syncd_wq = alloc_workqueue("xfssyncd", WQ_CPU_INTENSIVE, 8);
> 
> The value (8) for max_active here is arbitrary, and maybe
> justified with some magic words in a comment or something.
> But I really think it should be configurable, I suppose
> via a module parameter, for the benefit of unusual (i.e.
> large) configurations.

I'll add a comment. FYI, it's a per-cpu number, not a global number.
>From Documentation/workqueue.txt:

"@max_active determines the maximum number of execution contexts per
CPU which can be assigned to the work items of a wq.  For example,
with @max_active of 16, at most 16 work items of the wq can be
executing at the same time per CPU."

Which means it does scale with machine size already. Essentially, we
have a maximum of 3 work concurrent work items executing on the
syncd work queue per filesystem, so I don't think there'll be any
shortage of worker contexts on a typical system....


> > @@ -535,27 +511,12 @@ xfssyncd(
> >  			break;
> >  
> >  		spin_lock(&mp->m_sync_lock);
> > -		/*
> > -		 * We can get woken by laptop mode, to do a sync -
> > -		 * that's the (only!) case where the list would be
> > -		 * empty with time remaining.
> > -		 */
> > -		if (!timeleft || list_empty(&mp->m_sync_list)) {
> > -			if (!timeleft)
> > -				timeleft = xfs_syncd_centisecs *
> > -							msecs_to_jiffies(10);
> > -			INIT_LIST_HEAD(&mp->m_sync_work.w_list);
> > -			list_add_tail(&mp->m_sync_work.w_list,
> > -					&mp->m_sync_list);
> > -		}
> 
> Does timeleft have to be re-initialized in here somewhere?
> It looks to me like it will become zero pretty quickly and
> stay there.

Yeah, you're right, though the code is completely removed in the
next patch so it's not noticable. I'll just set it unconditionally
so that bisects don't do strange things if they land on this commit.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
