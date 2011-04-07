Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p3703Qa0062670 for <xfs@oss.sgi.com>; Wed, 6 Apr 2011 19:03:26 -0500
Received: from ipmail04.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E741A3A6A1A
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 17:06:41 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	wcQbnUGkid4ByvPw for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 17:06:41 -0700 (PDT)
Date: Thu, 7 Apr 2011 10:06:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/9] xfs: introduce background inode reclaim work
Message-ID: <20110407000633.GN31057@dastard>
References: <1302070758-17312-1-git-send-email-david@fromorbit.com>
	<1302070758-17312-5-git-send-email-david@fromorbit.com>
	<20110406181426.GB4356@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110406181426.GB4356@infradead.org>
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

On Wed, Apr 06, 2011 at 02:14:26PM -0400, Christoph Hellwig wrote:
> > + * We can have inodes enter reclaim after we've shut down the syncd workqueue
> > + * during unmount, so don't allow reclaim work to be queued during unmount.
> 
> Nipick: this part of the comment would be better just above the
> MS_ACTIVE check.  I just tried to figure out what it was for, and it
> took me a while to realize the explanation was in the block comment
> above the function.

Will fix.

> > +static void
> > +xfs_syncd_queue_reclaim(
> > +	struct xfs_mount        *mp)
> > +{
> > +	if (!(mp->m_super->s_flags & MS_ACTIVE))
> > +		return;
> 
> Otherwise looks good.

I'll assume you meant to add a Reviewed-by tag there and include it
in the next posting.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
