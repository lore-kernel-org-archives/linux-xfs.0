Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8G0Rxbx219201 for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 19:28:00 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 863049C6F5A
	for <xfs@oss.sgi.com>; Wed, 15 Sep 2010 17:40:41 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	q57XjD758VFquxMR for <xfs@oss.sgi.com>;
	Wed, 15 Sep 2010 17:40:41 -0700 (PDT)
Date: Thu, 16 Sep 2010 10:28:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 16/18] xfs: convert xfsbud shrinker to a per-buftarg
	shrinker.
Message-ID: <20100916002845.GG24409@dastard>
References: <1284461777-1496-1-git-send-email-david@fromorbit.com>
	<1284461777-1496-17-git-send-email-david@fromorbit.com>
	<1284581967.2452.25.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1284581967.2452.25.camel@doink>
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

On Wed, Sep 15, 2010 at 03:19:27PM -0500, Alex Elder wrote:
> On Tue, 2010-09-14 at 20:56 +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Before we introduce per-buftarg LRU lists, split the shrinker
> > implementation into per-buftarg shrinker callbacks. At the moment
> > we wake all the xfsbufds to run the delayed write queues to free
> > the dirty buffers and make their pages available for reclaim.
> > However, with an LRU, we want to be able to free clean, unused
> > buffers as well, so we need to separate the xfsbufd from the
> > shrinker callbacks.
> 
> I have one comment/question embedded below.
> 
> Your new shrinker is better than the old one (and would
> have been even if you didn't make them per-buftarg).
> It doesn't initiate flushing when it's passed 0 for
> nr_to_scan (though to be honest I'm not sure what
> practical effect that will have).

shrinkers are a strange beast. When nr_to_scan is zero, it means
"tell me how many reclaimable objects you have" rather than "shrink
the cache". The calling code does some magic and calls the shrinker
again a great number of times with nr_to_scan == 128 until it
completes. If the shrinker does not want to be called again, then it
should return -1 instead of the number of reclaimable objects.

> > ---
> >  fs/xfs/linux-2.6/xfs_buf.c |   89 ++++++++++++--------------------------------
> >  fs/xfs/linux-2.6/xfs_buf.h |    4 +-
> >  2 files changed, 27 insertions(+), 66 deletions(-)
> > 
> > diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> > index cce427d..3b54fee 100644
> > --- a/fs/xfs/linux-2.6/xfs_buf.c
> > +++ b/fs/xfs/linux-2.6/xfs_buf.c
> 
> . . .
> 
> > @@ -337,7 +332,6 @@ _xfs_buf_lookup_pages(
> >  					__func__, gfp_mask);
> >  
> >  			XFS_STATS_INC(xb_page_retries);
> > -			xfsbufd_wakeup(NULL, 0, gfp_mask);
> 
> Why is it OK not to wake up the shrinker(s) here
> now, when it was called for previously?

It's redundant. The shrinker loops will be called once per priority
level in reclaim (12 levels, IIRC, trying harder to free memory as
priority increases), so adding a 13th call after an allocation
failure does not really provide any extra benefit.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
