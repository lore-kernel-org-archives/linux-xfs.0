Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl6.internode.on.net ([150.101.137.143]:18387 "EHLO
        ipmail03.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725743AbeJaFa5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Oct 2018 01:30:57 -0400
Date: Wed, 31 Oct 2018 07:35:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/7] cache: prevent expansion races
Message-ID: <20181030203553.GO19305@dastard>
References: <20181030112043.6034-1-david@fromorbit.com>
 <20181030112043.6034-4-david@fromorbit.com>
 <20181030173901.GI4135@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030173901.GI4135@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 30, 2018 at 10:39:01AM -0700, Darrick J. Wong wrote:
> On Tue, Oct 30, 2018 at 10:20:39PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When a sudden buffer cache growth demand occurs from multiple
> > concurrent sources, they can all fail shaking the cache at the same
> > time and expand the cache. This results in the cache doubling in
> > size multiple times when only a single expansion was really
> > necessary. The resultant massive cache can cause repair to OOM as
> > the cache will grow to much larger than memory can actually hold.
> > 
> > Prevent this sudden and unnecessary expansion by rate limiting cache
> > growth to one size increase every tens seconds. This is sufficient
> > to prevent racing expansion calls from doing the wrong thing, but
> > not too long to prevent necesary cache growth when it is undersized.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  include/cache.h |  1 +
> >  libxfs/cache.c  | 17 ++++++++++++++---
> >  2 files changed, 15 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/cache.h b/include/cache.h
> > index 552b92489e46..1b774619f7a0 100644
> > --- a/include/cache.h
> > +++ b/include/cache.h
> > @@ -114,6 +114,7 @@ struct cache {
> >  	unsigned long long	c_misses;	/* cache misses */
> >  	unsigned long long	c_hits;		/* cache hits */
> >  	unsigned int 		c_max;		/* max nodes ever used */
> > +	time_t			expand_time;	/* time of last expansion */
> >  };
> >  
> >  struct cache *cache_init(int, unsigned int, struct cache_operations *);
> > diff --git a/libxfs/cache.c b/libxfs/cache.c
> > index 139c7c1b9e71..e10df395e60e 100644
> > --- a/libxfs/cache.c
> > +++ b/libxfs/cache.c
> > @@ -62,6 +62,7 @@ cache_init(
> >  	cache->bulkrelse = cache_operations->bulkrelse ?
> >  		cache_operations->bulkrelse : cache_generic_bulkrelse;
> >  	pthread_mutex_init(&cache->c_mutex, NULL);
> > +	time(&cache->expand_time);
> >  
> >  	for (i = 0; i < hashsize; i++) {
> >  		list_head_init(&cache->c_hash[i].ch_list);
> > @@ -77,15 +78,25 @@ cache_init(
> >  	return cache;
> >  }
> >  
> > +/*
> > + * rate limit expansion so several concurrent shakes don't instantly all
> > + * expand the cache multiple times and blow repair to OOM death.
> > + */
> >  static void
> >  cache_expand(
> > -	struct cache *		cache)
> > +	struct cache	*cache)
> >  {
> > +	time_t		now;
> > +
> >  	pthread_mutex_lock(&cache->c_mutex);
> > +	time(&now);
> > +	if (now - cache->expand_time > 10) {
> 
> At first I wondered to myself about what happens if we fill the cache
> fast enough that we run out of space in less than ten seconds, but
> (afaict) the cache_expand caller will keep trying shake/expand until it
> gets something, right?

Yes. Expansion occurs when the shaker fails to make progress because
the cache is full and nothing can be reclaimed after many attempts.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
