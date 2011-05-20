Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KAOZuW086459 for <xfs@oss.sgi.com>; Fri, 20 May 2011 05:24:36 -0500
Date: Fri, 20 May 2011 06:24:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] xfs: add online discard support
Message-ID: <20110520102430.GA18199@infradead.org>
References: <20110504185513.136746538@bombadil.infradead.org>
	<20110504190011.156999943@bombadil.infradead.org>
	<1305842024.2825.86.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1305842024.2825.86.camel@doink>
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

On Thu, May 19, 2011 at 04:53:44PM -0500, Alex Elder wrote:
> The first is, why not support it for non-delaylog?

Because:

 a) performance is going to suck even more horribly with the
    amount of trim commands needed, with no chance of actually
    fixing it
 b) the async discard code in patch 3 not easily applyable to
    the non-delaylog case, we'd need to keep two parallel codebases,
    one of them guaranteed to be untested.

> Second, why is it a two phase operation (marking an
> extent for discard, then doing all the discards at
> once)?  Is it just so you can do the discards without
> holding the perag lock?

Because we must prevent the allocation code from reusing an extent
that is undergoing a discard right now to prevent corruption, thus
we need to mark it as do not touch first. 

> >  	xfs_trans_committed_bulk(ctx->cil->xc_log->l_ailp, ctx->lv_chain,
> >  					ctx->start_lsn, abort);
> >  
> >  	xfs_alloc_busy_sort(&ctx->busy_extents);
> 
> I still think sorting the list belongs inside xfs_alloc_busy_clear().
> I see that list_sort() is not necessarily trivial for an already
> sorted list though...

It's a bad idea to do the sort twice for no good reason, and adding
another parameter to further overload xfs_alloc_busy_clear behaviour
doesn't seem smart either.

> 		if (error == EOPNOTSUPP) {
> 			/*
> 			 * Report this once per mount point somehow?
> 			 * If so, turn off the mount option?
> 			 */
> 			break;

We've been through this discussion again lately with dm and ext4
folks, and the conclusion is that EOPNOTSUPP is perfectly fine to happen
here.

> > +	 * performing the discard a chance to mark the extent unbusy
> > +	 * and retry.
> > +	 */
> > +	if (busyp->flags & XFS_ALLOC_BUSY_DISCARDED) {
> > +		spin_unlock(&pag->pagb_lock);
> > +		delay(1);
> 
> I hate seeing calls to delay() although sometimes
> it's the right thing to do...  I don't have a feel
> for how long a discard is likely to take so I don't
> know whether waiting here instead would be worth
> the effort.

It's not nice, but if the block layer gets fixed and we do asynchronous
discards it simply goes away.

> If this option is to only be available for delaylog, it should
> say so here (and maybe report that it's being ignored if it's
> supplied with nodelaylog at mount time).

ok.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
