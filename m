Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8N0aFct091692 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 19:36:16 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4A46418490B0
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 17:37:09 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	LRhTB2UDWrTCri5J for <xfs@oss.sgi.com>;
	Wed, 22 Sep 2010 17:37:09 -0700 (PDT)
Date: Thu, 23 Sep 2010 10:37:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 05/16] xfs: rename xfs_buf_get_nodaddr to be more
	appropriate
Message-ID: <20100923003706.GJ2614@dastard>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-6-git-send-email-david@fromorbit.com>
	<20100922172525.GC5697@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100922172525.GC5697@infradead.org>
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

On Wed, Sep 22, 2010 at 01:25:26PM -0400, Christoph Hellwig wrote:
> >  xfs_buf_t *
> > -xfs_buf_get_noaddr(
> > +xfs_buf_get_uncached(
> >  	size_t			len,
> > +	int			flags,
> >  	xfs_buftarg_t		*target)
> 
> Sorry for coming up with minor details like this again, but if we change
> the name and signature anyway, can we please make the buftarg the first
> argument, just like for the other buf helpers?

Yup, I'll fix it. I should have done that in the first place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
