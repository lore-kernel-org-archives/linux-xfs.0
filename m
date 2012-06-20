Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5KMaCF2179193 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 17:36:12 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	EkiGPTC6l8YkfxIg for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 15:36:10 -0700 (PDT)
Date: Thu, 21 Jun 2012 08:35:48 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120620223548.GK30705@dastard>
References: <1339087793-45731-1-git-send-email-bfoster@redhat.com>
	<20120620080523.GA26167@infradead.org>
	<4FE1F37E.6090706@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4FE1F37E.6090706@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jun 20, 2012 at 11:59:58AM -0400, Brian Foster wrote:
> On 06/20/2012 04:05 AM, Christoph Hellwig wrote:
> > On Thu, Jun 07, 2012 at 12:49:53PM -0400, Brian Foster wrote:
> [snip]
> >>  	spin_lock(&ailp->xa_lock);
> >> +
> >> +	/* barrier matches the xa_target update in xfs_ail_push() */
> >> +	smp_rmb();
> >> +	target = ailp->xa_target;
> >> +	ailp->xa_target_prev = target;
> >> +
> >>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
> >>  	if (!lip) {
> >>  		/*
> >> +
> >> +		spin_lock(&ailp->xa_lock);
> >> +
> >> +		/*
> >> +		 * Idle if the AIL is empty and we are not racing with a target
> >> +		 * update. The barrier matches the xa_target update in
> >> +		 * xfs_ail_push().
> >> +		 */
> >> +		smp_rmb();
> > 
> > Given that both sides are under xa_lock I can't see any need for
> > barriers here.
> > 
> 
> Actually now that I look at it, it appears xfs_trans_ail_copy_lsn() does
> not necessarily acquire the xa_lock...

Right, it does not acquire the lock on 64 bit systems as reads and
writes are single instructions on 64 bit systems. The lock is
required for 32 bit systems because the write requires separate 32
bit writes to the LSN which can result in unlocked accesses seeing
partially updated (and hence incorrect) LSN values.

So the memory barriers are definitely needed for 64 bit machines
because there is no locking on the update and spinlocks only provide
memory barriers via unlock->lock transitions, not via a single
spin_lock() call.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
