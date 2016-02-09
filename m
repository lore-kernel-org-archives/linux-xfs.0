Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 63C3C29DF6
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 15:52:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4713A8F8064
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 13:52:47 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	ee6bG7mBA9H4HTmF for <xfs@oss.sgi.com>;
	Tue, 09 Feb 2016 13:52:41 -0800 (PST)
Date: Wed, 10 Feb 2016 08:52:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: don't chain ioends during writepage submission
Message-ID: <20160209215240.GG14668@dastard>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
	<1454910258-7578-6-git-send-email-david@fromorbit.com>
	<20160209134930.GD13357@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160209134930.GD13357@infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, Feb 09, 2016 at 05:49:30AM -0800, Christoph Hellwig wrote:
> > +STATIC struct xfs_ioend *
> >  xfs_add_to_ioend(
> >  	struct inode		*inode,
> >  	struct buffer_head	*bh,
> >  	xfs_off_t		offset,
> >  	struct xfs_writepage_ctx *wpc)
> >  {
> > +	struct xfs_ioend	*ioend_to_submit = NULL;
> 
> Maybe just
> 
> 	struct xfs_ioend	*prev = NULL;
> 
> to be a little less verbose?

*nod*

> > +	if (wpc->ioend)
> > +		xfs_submit_ioend(wbc, wpc->ioend, status);
> >  	return status;
> >  }
> 
> With this change xfs_writepage_submit is rather pointless, I'd
> rather open code it in the callers.

Yup.

> 
> > +			ioend = xfs_add_to_ioend(inode, bh, offset, wpc);
> > +			if (ioend) {
> > +				ioend->io_list = NULL;
> > +				if (!ioend_to_submit)
> > +					ioend_to_submit = ioend;
> > +				else
> > +					ioend_tail->io_list = ioend;
> > +				ioend_tail = ioend;
> > +			}
> 
> Just using a list_head for this is a lot easier to read and less
> error prone at the cost of a single additional pointer in the ioend.

OK. I'll see what I can do here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
