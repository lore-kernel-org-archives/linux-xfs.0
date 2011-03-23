Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2NCNXgi091565 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 07:23:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DE19436D99A
	for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:26:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id othbR1CKY4QlfKW1 for
	<xfs@oss.sgi.com>; Wed, 23 Mar 2011 05:26:34 -0700 (PDT)
Date: Wed, 23 Mar 2011 08:26:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] xfs: allow reusing busy extents where safe
Message-ID: <20110323122634.GE468@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200137.837735220@bombadil.infradead.org>
	<20110323002024.GF15270@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110323002024.GF15270@dastard>
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

On Wed, Mar 23, 2011 at 11:20:24AM +1100, Dave Chinner wrote:
> >  		overlap = xfs_alloc_busy_try_reuse(pag, busyp,
> >  						   fbno, fbno + flen);
> > -		if (overlap) {
> > +		if (overlap == -1 || (overlap && userdata)) {
> >  			spin_unlock(&pag->pagb_lock);
> >  			xfs_log_force(tp->t_mountp, XFS_LOG_SYNC);
> >  			goto restart;
> 
> Ok, so the only time we'll do a log force now is on an complete
> overlap or a partial userdata overlap?

We do it if we would have to split the busy extent, or reallocate
metadata to userdata.

> > +		if (!args->userdata ||
> > +		    (busyp->flags & XFS_ALLOC_BUSY_USERDATA)) {
> > +			int overlap;
> > +
> > +			overlap = xfs_alloc_busy_try_reuse(args->pag, busyp,
> > +							   fbno, fbno + flen);
> > +			if (unlikely(overlap == -1)) {
> > +				spin_unlock(&args->pag->pagb_lock);
> > +				xfs_log_force(args->mp, XFS_LOG_SYNC);
> > +				goto restart;
> > +			}
> 
> Hmmmm - I'm not so sure we can reuse overlapped data extents for
> data allocations without a log force at all as there is no guarantee
> that the data will not be overwritten before the original free
> transaction is on disk.
> 
> That is, recovery may not replay the original data extent free
> transaction or the new allocation transaction, but there is nothing
> stopping us from having written the new data into the extent before
> the crash occurred, especially as delayed allocation places the
> allocation very close the data IO issue. e.g.:
> 
> 	thread X		thread Y
> 	free data extent ABC
> 				allocate data extent BCD
> 				partial overlap, no log force
> 				issue data IO
> 				.....
> 
> 		 <crash>
> 
> That leads to corruption of the data in the original file because
> neither transaction is written to disk, but new data is....

You're right.  It's fine from the transaction point of view, but
it could leave wrong data in a file.  I'll disallow this case, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
