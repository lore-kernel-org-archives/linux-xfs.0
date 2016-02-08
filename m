Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 487C27CA2
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 13:55:08 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F3798F8049
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 11:55:07 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	7Ebu5Clmo1B0jCAU for <xfs@oss.sgi.com>;
	Mon, 08 Feb 2016 11:55:05 -0800 (PST)
Date: Tue, 9 Feb 2016 06:54:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 6/7] libxfs: keep unflushable buffers off the cache MRUs
Message-ID: <20160208195437.GJ27429@dastard>
References: <1454627108-19036-1-git-send-email-david@fromorbit.com>
	<1454627108-19036-7-git-send-email-david@fromorbit.com>
	<20160208100636.GA27683@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160208100636.GA27683@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Mon, Feb 08, 2016 at 02:06:36AM -0800, Christoph Hellwig wrote:
> > --- a/include/cache.h
> > +++ b/include/cache.h
> > @@ -51,6 +51,7 @@ enum {
> >  #define CACHE_BASE_PRIORITY	0
> >  #define CACHE_PREFETCH_PRIORITY	8
> >  #define CACHE_MAX_PRIORITY	15
> > +#define CACHE_DIRTY_PRIORITY	(CACHE_MAX_PRIORITY + 1)
> 
> Sizing arrays based on, and iterating up to CACHE_DIRTY_PRIORITY seems
> rather odd.  Maybe add a new
> 
> #define CACHE_NR_PRIORITIES		CACHE_DIRTY_PRIORITY
> 
> and a comment explaining the magic to make it more obvious?

Ok.

> > +cache_move_to_dirty_mru(
> > +	struct cache		*cache,
> > +	struct cache_node	*node)
> > +{
> > +	struct cache_mru	*mru;
> > +
> > +	mru = &cache->c_mrus[CACHE_DIRTY_PRIORITY];
> > +
> > +	pthread_mutex_lock(&mru->cm_mutex);
> > +	node->cn_priority = CACHE_DIRTY_PRIORITY;
> > +	list_move(&node->cn_mru, &mru->cm_list);
> > +	mru->cm_count++;
> > +	pthread_mutex_unlock(&mru->cm_mutex);
> > +}
> 
> Maybe it would better to just do a list_add here and leave the
> list_del to the caller to avoid needing to nest two different
> cm_mutex instances.

I'll have a look at it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
