Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:44039 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728851AbfHEXo3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 19:44:29 -0400
Date: Tue, 6 Aug 2019 09:43:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 01/24] mm: directed shrinker work deferral
Message-ID: <20190805234318.GB7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-2-david@fromorbit.com>
 <20190802152709.GA60893@bfoster>
 <20190804014930.GR7777@dread.disaster.area>
 <20190805174226.GB14760@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805174226.GB14760@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Mon, Aug 05, 2019 at 01:42:26PM -0400, Brian Foster wrote:
> On Sun, Aug 04, 2019 at 11:49:30AM +1000, Dave Chinner wrote:
> > On Fri, Aug 02, 2019 at 11:27:09AM -0400, Brian Foster wrote:
> > > On Thu, Aug 01, 2019 at 12:17:29PM +1000, Dave Chinner wrote:
> > > >  };
> > > >  
> > > >  #define SHRINK_STOP (~0UL)
> > > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > > index 44df66a98f2a..ae3035fe94bc 100644
> > > > --- a/mm/vmscan.c
> > > > +++ b/mm/vmscan.c
> > > > @@ -541,6 +541,13 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
> > > >  	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
> > > >  				   freeable, delta, total_scan, priority);
> > > >  
> > > > +	/*
> > > > +	 * If the shrinker can't run (e.g. due to gfp_mask constraints), then
> > > > +	 * defer the work to a context that can scan the cache.
> > > > +	 */
> > > > +	if (shrinkctl->will_defer)
> > > > +		goto done;
> > > > +
> > > 
> > > Who's responsible for clearing the flag? Perhaps we should do so here
> > > once it's acted upon since we don't call into the shrinker again?
> > 
> > Each shrinker invocation has it's own shrink_control context - they
> > are not shared between shrinkers - the higher level is responsible
> > for setting up the control state of each individual shrinker
> > invocation...
> > 
> 
> Yes, but more specifically, it appears to me that each level is
> responsible for setting up control state managed by that level. E.g.,
> shrink_slab_memcg() initializes the unchanging state per iteration and
> do_shrink_slab() (re)sets the scan state prior to ->scan_objects().

do_shrink_slab() is responsible for iterating the scan in
shrinker->batch sizes, that's all it's doing there. We have to do
some accounting work from scan to scan. However, if ->will_defer is
set, we skip that entire loop, so it's largely irrelevant IMO.

> > > Granted the deferred state likely hasn't
> > > changed, but the fact that we'd call back into the count callback to set
> > > it again implies the logic could be a bit more explicit, particularly if
> > > this will eventually be used for more dynamic shrinker state that might
> > > change call to call (i.e., object dirty state, etc.).
> > > 
> > > BTW, do we need to care about the ->nr_cached_objects() call from the
> > > generic superblock shrinker (super_cache_scan())?
> > 
> > No, and we never had to because it is inside the superblock shrinker
> > and the superblock shrinker does the GFP_NOFS context checks.
> > 
> 
> Ok. Though tbh this topic has me wondering whether a shrink_control
> boolean is the right approach here. Do you envision ->will_defer being
> used for anything other than allocation context restrictions? If not,

Not at this point. If there are other control flags needed, we can
ad them in future - I don't like the idea of having a single control
flag mean different things in different contexts.

> perhaps we should do something like optionally set alloc flags required
> for direct scanning in the struct shrinker itself and let the core
> shrinker code decide when to defer to kswapd based on the shrink_control
> flags and the current shrinker. That way an arbitrary shrinker can't
> muck around with core behavior in unintended ways. Hm?

Arbitrary shrinkers can't "muck about" with the core behaviour any
more than they already could with this code. If you want to screw up
the core reclaim by always returning SHRINK_STOP to ->scan_objects
instead of doing work, then there is nothing stopping you from doing
that right now. Formalising there work deferral into a flag in the
shrink_control doesn't really change that at all, adn as such I
don't see any need for over-complicating the mechanism here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
