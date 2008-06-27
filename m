Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 21:13:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R4Ctsj001274
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:12:55 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C1C7D63698
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:13:55 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id Ngs1AMMWazh0BcRK for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 21:13:55 -0700 (PDT)
Date: Fri, 27 Jun 2008 14:13:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] Replace inode flush semaphore with a completion
Message-ID: <20080627041351.GY29319@disturbed>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-3-git-send-email-david@fromorbit.com> <20080627023011.GC7703@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627023011.GC7703@parisc-linux.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Matthew Wilcox <matthew@wil.cx>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 08:30:11PM -0600, Matthew Wilcox wrote:
> On Thu, Jun 26, 2008 at 02:41:13PM +1000, Dave Chinner wrote:
> > Use the new completion flush code to implement the inode
> > flush lock. Removes one of the final users of semaphores
> > in the XFS code base.
> 
> Let's demonstrate converting this one to completions ...

Great. I need all the help I can get. ;)

> > --- a/fs/xfs/xfs_iget.c
> > +++ b/fs/xfs/xfs_iget.c
> > @@ -216,7 +216,7 @@ finish_inode:
> >  	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
> >  	init_waitqueue_head(&ip->i_ipin_wait);
> >  	atomic_set(&ip->i_pincount, 0);
> > -	initnsema(&ip->i_flock, 1, "xfsfino");
> > +	init_completion_flush(&ip->i_flush);
> 
> +	init_completion(&ip->i_flush);
> +	complete(&ip->i_flush);

Ok, that would work. Need commenting, though.

> >  int
> >  xfs_iflock_nowait(xfs_inode_t *ip)
> >  {
> > -	return (cpsema(&(ip->i_flock)));
> > +	return completion_flush_start_nowait(&ip->i_flush);
> 
> This is where you need a new function ...
> 
> +	return nowait_for_completion(&ip->i_flush);
> 
> Yes, we probably need a better name for the down_trylock() equivalent.

I suggested try_wait_for_completion() in a different email - it's
a difficult on to say "a wait_for_completion() call that doesn't
wait"....

I think I'll stick with the try_.... version to match other "try"
operations.


> >  int
> > @@ -3070,7 +3069,7 @@ xfs_iflush(
> >  	XFS_STATS_INC(xs_iflush_count);
> >  
> >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
> > -	ASSERT(issemalocked(&(ip->i_flock)));
> > +	ASSERT(completion_flush_inprogress(&ip->i_flush));
> 
> is_complete()?

That's a little to general for my liking - I note that there
are already an existing is_complete() function in a driver.
completion_done() perhaps?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
