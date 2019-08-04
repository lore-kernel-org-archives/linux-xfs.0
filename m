Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33297 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728274AbfHDCGn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Aug 2019 22:06:43 -0400
Date: Sun, 4 Aug 2019 12:05:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 03/24] mm: factor shrinker work calculations
Message-ID: <20190804020532.GT7777@dread.disaster.area>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-4-david@fromorbit.com>
 <e07bf57b-a9cb-cb7b-b2be-3ec1b355a184@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e07bf57b-a9cb-cb7b-b2be-3ec1b355a184@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

On Fri, Aug 02, 2019 at 06:08:37PM +0300, Nikolay Borisov wrote:
> 
> 
> On 1.08.19 г. 5:17 ч., Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Start to clean up the shrinker code by factoring out the calculation
> > that determines how much work to do. This separates the calculation
> > from clamping and other adjustments that are done before the
> > shrinker work is run.
> > 
> > Also convert the calculation for the amount of work to be done to
> > use 64 bit logic so we don't have to keep jumping through hoops to
> > keep calculations within 32 bits on 32 bit systems.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  mm/vmscan.c | 74 ++++++++++++++++++++++++++++++++++-------------------
> >  1 file changed, 47 insertions(+), 27 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index ae3035fe94bc..b7472953b0e6 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -464,13 +464,45 @@ EXPORT_SYMBOL(unregister_shrinker);
> >  
> >  #define SHRINK_BATCH 128
> >  
> > +/*
> > + * Calculate the number of new objects to scan this time around. Return
> > + * the work to be done. If there are freeable objects, return that number in
> > + * @freeable_objects.
> > + */
> > +static int64_t shrink_scan_count(struct shrink_control *shrinkctl,
> > +			    struct shrinker *shrinker, int priority,
> > +			    int64_t *freeable_objects)
> 
> nit: make the return parm definition also uin64_t, also we have u64 types.

SHRINK_EMPTY is actually a negative number (-2), and it gets whacked
back into a signed long value in the caller. So returning a signed
integer is actually correct.

> > +{
> > +	uint64_t delta;
> > +	uint64_t freeable;
> > +
> > +	freeable = shrinker->count_objects(shrinker, shrinkctl);
> > +	if (freeable == 0 || freeable == SHRINK_EMPTY)
> > +		return freeable;
> > +
> > +	if (shrinker->seeks) {
> > +		delta = freeable >> (priority - 2);
> > +		do_div(delta, shrinker->seeks);
> 
> a comment about the reasoning behind this calculation would be nice.

I'm just moving code here.

The reason for this calculation requires an awfully long description
that isn't actually appropriate here or in this patch set.

If there should be any comment describing how shrinker work biasing
should be configured, it needs to be in include/linux/shrinker.h
around the definition of DEFAULT_SEEKS and shrinker->seeks as this
code requires shrinker->seeks to be configured appropriately by the
code that registers the shrinker.

> >  static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
> >  				    struct shrinker *shrinker, int priority)
> >  {
> >  	unsigned long freed = 0;
> > -	unsigned long long delta;
> >  	long total_scan;
> > -	long freeable;
> > +	int64_t freeable_objects = 0;
> > +	int64_t scan_count;
> 
> why int and not uint64 ? We can never have negative object count, right?

SHRINK_STOP, SHRINK_EMPTY are negative numbers, and the higher level
interface uses longs, not unsigned longs. So we have to treat
numbers greater than LONG_MAX as invalid for object/scan counts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
