Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5K85QUl004299 for <xfs@oss.sgi.com>; Wed, 20 Jun 2012 03:05:26 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8EGqPe4tcZloj2hI (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 20 Jun 2012 01:05:25 -0700 (PDT)
Date: Wed, 20 Jun 2012 04:05:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: re-enable xfsaild idle mode and fix associated
	races
Message-ID: <20120620080523.GA26167@infradead.org>
References: <1339087793-45731-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1339087793-45731-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

On Thu, Jun 07, 2012 at 12:49:53PM -0400, Brian Foster wrote:
> xfsaild idle mode logic currently leads to a couple hangs:
> 
> 1.) If xfsaild is rescheduled in during an incremental scan
>     (i.e., tout != 0) and the target has been updated since
>     the previous run, we can hit the new target and go into
>     idle mode with a still populated ail.
> 2.) A wake up is only issued when the target is pushed forward.
>     The wake up can race with xfsaild if it is currently in the
>     process of entering idle mode, causing future wake up
>     events to be lost.
> 
> Both hangs are reproducible by running xfstests 273 in a loop.
> Modify xfsaild to enter idle mode only when the ail is empty
> and the push target has not been moved forward since the last
> push.

What tree is this against?  The current XFS tree never fully idles,
so something is missing here, probably just in the patch description.

>  	spin_lock(&ailp->xa_lock);
> +
> +	/* barrier matches the xa_target update in xfs_ail_push() */
> +	smp_rmb();
> +	target = ailp->xa_target;
> +	ailp->xa_target_prev = target;
> +
>  	lip = xfs_trans_ail_cursor_first(ailp, &cur, ailp->xa_last_pushed_lsn);
>  	if (!lip) {
>  		/*
> +
> +		spin_lock(&ailp->xa_lock);
> +
> +		/*
> +		 * Idle if the AIL is empty and we are not racing with a target
> +		 * update. The barrier matches the xa_target update in
> +		 * xfs_ail_push().
> +		 */
> +		smp_rmb();

Given that both sides are under xa_lock I can't see any need for
barriers here.

> +		if (!xfs_ail_min(ailp) && (ailp->xa_target == ailp->xa_target_prev)) {
> +			spin_unlock(&ailp->xa_lock);
> +			schedule();
> +			tout = 0;
> +			continue;
> +		}

This seems to add the actual idling, but in a rather confusing way.

Can you add the xfs_ail_min and target checks to the end of xfsaild_push
so that they are in one place with the other decisions for the timeout.

Please also add a comment explaining the conditions when we want to
idle.

Also two small style nipicks:

 - please make sure lines are shorter than 80 characters
 - no need for the braces around the target comparism above.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
