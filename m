Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NCLdx0091473 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:21:50 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1550436D409
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:24:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CkJpvFhvqRo8jVJC for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:24:39 -0700 (PDT)
Date: Wed, 23 Mar 2011 08:24:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] xfs: exact busy extent tracking
Message-ID: <20110323122438.GD468@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.657110761@bombadil.infradead.org>
	<20110322234728.GE15270@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110322234728.GE15270@dastard>
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
Cc: xfs@oss.sgi.com

On Wed, Mar 23, 2011 at 10:47:28AM +1100, Dave Chinner wrote:
> BUG_ON() inside a spinlock will effectively lock up the machine as
> other CPUs try to take the spinlock that was held by the thread that
> went bad. It causes the machine to die a horrible, undebuggable death
> rather than just kill the thread that caused the oops and leaving
> everything else still functional.
> 
> If it were an ASSERT(), that's probably OK because it is only debug
> systems that woul dhave this problem, but the use of BUG(_ON) means
> it will cause production systems to die as well.

I've changed it to asserts.

> > +		 * We would have to split the busy extent to be able
> > +		 * to track it correct, which we cannot do because we
> > +		 * would have to modify the list of busy extents
> > +		 * attached to the transaction/CIL context, which
> > +		 * is mutable.
> 
> 		      immutable?

Yes.

> > +		 *
> > +		 * Force out the log to clear the busy extents
> > +		 * and retry the search.
> > +		 */
> 
> BTW, these comments appear to wrap at 68 columns - any particular
> reason?

They used to sit one more tab to the right and I didn't fix them up
when splitting the function.  I've rewrapped them now.

> > +		overlap = xfs_alloc_busy_try_reuse(pag, busyp,
> > +						   fbno, fbno + flen);
> > +		if (overlap) {
> > +			spin_unlock(&pag->pagb_lock);
> > +			xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> > +			goto restart;
> > +		}
> 
> xfs_alloc_busy_try_reuse() only ever returns -1 or 1, which means
> this will always trigger a log force on overlap....

At least for now, yes.  In the next patch we will treat -1 vs 1
differently.  Maybe it should be changed to 0 vs 1, but even that
isn't quite intuitive.  I'll think about it a bit more.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
