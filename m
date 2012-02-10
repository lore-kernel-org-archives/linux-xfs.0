Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1AGueCB009606 for <xfs@oss.sgi.com>; Fri, 10 Feb 2012 10:56:40 -0600
Date: Fri, 10 Feb 2012 10:56:46 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/7] xfs: use a normal shrinker for the dquot freelist
Message-ID: <20120210165646.GO7762@sgi.com>
References: <20120201135719.202171828@bombadil.infradead.org>
	<20120201140039.011990931@bombadil.infradead.org>
	<20120209220320.GL7762@sgi.com>
	<20120209225626.GA844@infradead.org>
	<20120210014947.GE12836@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120210014947.GE12836@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Feb 10, 2012 at 12:49:47PM +1100, Dave Chinner wrote:
> On Thu, Feb 09, 2012 at 05:56:26PM -0500, Christoph Hellwig wrote:
> > On Thu, Feb 09, 2012 at 04:03:20PM -0600, Ben Myers wrote:
> > > > +	LIST_HEAD		(dispose_list);
> > > > +	struct xfs_dquot	*dqp;
> > > >  
> > > > -	if (nfree <= ndqused && nfree < ndquot)
> > > > +	if ((sc->gfp_mask & (__GFP_FS|__GFP_WAIT)) != (__GFP_FS|__GFP_WAIT))
> > > >  		return 0;
> > > > +	if (!nr_to_scan)
> > > > +		goto out;
> > > 
> > > I suggest something more like:
> > > 
> > > 	if (!nr_to_scan)
> > > 		goto out;
> > >         if ((sc->gfp_mask...
> > > 		return -1;
> > 
> > Why?  Counting the number of objects when we can't actually do anything
> > is just a waste of time, and -1 vs 0 for the sizing pass seem to be
> > treateds the same in the calling code.
> 
> .....
> 
> > >  * The callback must not return -1 if nr_to_scan is zero.
> > 
> > this is against your suggestion of using -1 for the estimation pass
> > above, btw.
> 
> Technically, if the shrinker cannot make progress or the gfp mask
> means it cannot enter the filesystem code, then it should return -1,
> not zero. Yes, the calc code treats 0 and -1 the same because it is
> defensive - for the calculation a shrinker can validly return 0 to
> mean "I have no work to do" rather than "I cannot do any work in
> this context", but both mean the same thing - don't try to run the
> shrinker here.
> 
> However, the later shrinker callout to do work (i.e. nr_to_scan !=
> 0) relies on this distinction to break out of the shrink loop early
> whenteh shrinker says "can't do any work". If you just keep
> returning zero there then it will just looping uselessly until the
> scan count runs out.
> 
> The interface is a piece of shit, and I need to get back to my patch
> series that fixes this all up by separating the calculation callback
> from the work callback...

Ok... so it'll be sorted out in a different patch.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
