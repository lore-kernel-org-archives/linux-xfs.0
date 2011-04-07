Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3705WKb062779 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 19:05:33 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A093612B6D7C
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 17:08:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	mapEXtLZPfPxIbkK for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 17:08:48 -0700 (PDT)
Date: Thu, 7 Apr 2011 10:08:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] xfs: convert the xfsaild threads to a workqueue
Message-ID: <20110407000802.GO31057@dastard>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-6-git-send-email-david@fromorbit.com>
	<20110406181256.GA4356@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110406181256.GA4356@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Apr 06, 2011 at 02:12:56PM -0400, Christoph Hellwig wrote:
> On Wed, Apr 06, 2011 at 04:19:14PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Similar to the xfssyncd, the per-filesystem xfsaild threads can be
> > converted to a global workqueue and run periodically by delayed
> > works. This makes sense for the AIL pushing because it uses
> > variable timeouts depending on the work that needs to be done.
> > 
> > By removing the xfsaild, we simplify the AIL pushing code and
> > remove the need to spread the code to implement the threading
> > and pushing across multiple files.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/linux-2.6/xfs_super.c |  115 ++++++++++++------------------------
> >  fs/xfs/xfs_trans_ail.c       |  133 ++++++++++++++++++++++++------------------
> >  fs/xfs/xfs_trans_priv.h      |   15 +++--
> >  3 files changed, 121 insertions(+), 142 deletions(-)
> 
> 
> 
> 
> > +	tout = 0;
> >  	if (!count) {
> >  		/* We're past our target or empty, so idle */
> > -		last_pushed_lsn = 0;
> > +		ailp->xa_last_pushed_lsn = 0;
> > +
> > +		/*
> > +		 * Check for an updated push target before clearing the
> > +		 * XFS_AIL_PUSHING_BIT. If the target changed, we've got more
> > +		 * work to do.
> > +		 */
> > +		smp_rmb();
> > +		if (ailp->xa_target == target)
> > +			clear_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags);
> > +		else
> > +			tout = 50;
> 
> I thjink this could be simplified a bit by just returning here if we
> have matched the target, and then making the queueing up of work later
> on unconditional.

Ok, that's reasonable.

> > +/*
> > + * xfs_trans_ail_push
> > + *
> 
> Wha'ts the point of mentioning the function name like this in comments?

None really, was just being consistent with other functions. Will
fix.

> > +	/*
> > +	 * En??ure that the new target is noticed in push code before it clears
> 
> There's some weird character here which my mailer can't display.

Oops.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
