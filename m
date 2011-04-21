Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L6oOGh141929 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 01:50:24 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 54DD0150833D
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2011 23:53:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Svq5jnJYIneWVI9S for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2011 23:53:51 -0700 (PDT)
Date: Thu, 21 Apr 2011 16:53:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] xfs: reset buffer pointers before freeing them
Message-ID: <20110421065349.GJ1814@dastard>
References: <1303360144-10632-1-git-send-email-david@fromorbit.com>
	<1303360144-10632-4-git-send-email-david@fromorbit.com>
	<20110421045203.GB28859@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110421045203.GB28859@infradead.org>
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

On Thu, Apr 21, 2011 at 12:52:03AM -0400, Christoph Hellwig wrote:
> >  		ealign = round_down(end_block, sectbb);
> >  		if (j == 0 && (start_block + endcount > ealign)) {
> > -			offset = XFS_BUF_PTR(bp);
> > -			balign = BBTOB(ealign - start_block);
> > -			error = XFS_BUF_SET_PTR(bp, offset + balign,
> > -						BBTOB(sectbb));
> > +			balign = ealign - start_block;
> > +			offset = XFS_BUF_PTR(bp) + BBTOB(balign);
> > +			error = xlog_bread_offset(log, ealign, sectbb,
> > +							bp, offset);
> 
> I'd remove the use of balign entirely here.  The first use of this
> variable earlier in the functions is for something entirely different,
> so it's rather confusing.  (I only looked into that because I remember
> some align variable beeing used later on, but that was elsewhere)

Ok, will do.

> Otherwise looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
