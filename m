Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 437227F66
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 17:35:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3C65AC003
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2015 15:35:55 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	bkaaaZjStQIBBs9t for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2015 15:35:53 -0800 (PST)
Date: Wed, 18 Feb 2015 10:32:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150217233243.GL4251@dastard>
References: <20141230112158.GA15546@dhcp22.suse.cz>
	<201502092044.JDG39081.LVFOOtFHQFOMSJ@I-love.SAKURA.ne.jp>
	<201502102258.IFE09888.OVQFJOMSFtOLFH@I-love.SAKURA.ne.jp>
	<20150210151934.GA11212@phnom.home.cmpxchg.org>
	<201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150217225430.GJ4251@dastard>
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
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, rientjes@google.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Wed, Feb 18, 2015 at 09:54:30AM +1100, Dave Chinner wrote:
> On Tue, Feb 17, 2015 at 07:53:15AM -0500, Johannes Weiner wrote:
> > On Tue, Feb 17, 2015 at 09:23:26PM +0900, Tetsuo Handa wrote:
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -2381,9 +2381,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
> > >                 /* The OOM killer does not needlessly kill tasks for lowmem */
> > >                 if (high_zoneidx < ZONE_NORMAL)
> > >                         goto out;
> > > -               /* The OOM killer does not compensate for light reclaim */
> > > -               if (!(gfp_mask & __GFP_FS))
> > > -                       goto out;
> > >                 /*
> > >                  * GFP_THISNODE contains __GFP_NORETRY and we never hit this.
> > >                  * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
> > 
> > Again, we don't want to OOM kill on behalf of allocations that can't
> > initiate IO, or even actively prevent others from doing it.  Not per
> > default anyway, because most callers can deal with the failure without
> > having to resort to killing tasks, and NOFS reclaim *can* easily fail.
> > It's the exceptions that should be annotated instead:
> > 
> > void *
> > kmem_alloc(size_t size, xfs_km_flags_t flags)
> > {
> > 	int	retries = 0;
> > 	gfp_t	lflags = kmem_flags_convert(flags);
> > 	void	*ptr;
> > 
> > 	do {
> > 		ptr = kmalloc(size, lflags);
> > 		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > 			return ptr;
> > 		if (!(++retries % 100))
> > 			xfs_err(NULL,
> > 		"possible memory allocation deadlock in %s (mode:0x%x)",
> > 					__func__, lflags);
> > 		congestion_wait(BLK_RW_ASYNC, HZ/50);
> > 	} while (1);
> > }
> > 
> > This should use __GFP_NOFAIL, which is not only designed to annotate
> > broken code like this, but also recognizes that endless looping on a
> > GFP_NOFS allocation needs the OOM killer after all to make progress.
> > 
> > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > index a7a3a63bb360..17ced1805d3a 100644
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> > @@ -45,20 +45,12 @@ kmem_zalloc_greedy(size_t *size, size_t minsize, size_t maxsize)
> >  void *
> >  kmem_alloc(size_t size, xfs_km_flags_t flags)
> >  {
> > -	int	retries = 0;
> >  	gfp_t	lflags = kmem_flags_convert(flags);
> > -	void	*ptr;
> >  
> > -	do {
> > -		ptr = kmalloc(size, lflags);
> > -		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > -			return ptr;
> > -		if (!(++retries % 100))
> > -			xfs_err(NULL,
> > -		"possible memory allocation deadlock in %s (mode:0x%x)",
> > -					__func__, lflags);
> > -		congestion_wait(BLK_RW_ASYNC, HZ/50);
> > -	} while (1);
> > +	if (!(flags & (KM_MAYFAIL | KM_NOSLEEP)))
> > +		lflags |= __GFP_NOFAIL;
> > +
> > +	return kmalloc(size, lflags);
> >  }
> 
> Hmmm - the only reason there is a focus on this loop is that it
> emits warnings about allocations failing. It's obvious that the
> problem being dealt with here is a fundamental design issue w.r.t.
> to locking and the OOM killer, but the proposed special casing
> hack^H^H^H^Hband aid^W^Wsolution is not "working" because some code
> in XFS started emitting warnings about allocations failing more
> often.
>
> So the answer is to remove the warning?  That's like killing the
> canary to stop the methane leak in the coal mine. No canary? No
> problems!

I'll also point out that there are two other identical allocation
loops in XFS, one of which is only 30 lines below this one. That's
further indication that this is a "silence the warning" patch rather
than something that actually fixes a problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
