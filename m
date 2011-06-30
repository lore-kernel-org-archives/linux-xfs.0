Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5U6vapi187777 for <xfs@oss.sgi.com>; Thu, 30 Jun 2011 01:57:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5046E54800
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 23:57:35 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	tCLjoWmU2t7wu53g for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 23:57:35 -0700 (PDT)
Date: Thu, 30 Jun 2011 02:57:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/27] xfs: use write_cache_pages for writeback clustering
Message-ID: <20110630065734.GB10893@infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140336.950805096@bombadil.infradead.org>
	<20110630020013.GX561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110630020013.GX561@dastard>
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

On Thu, Jun 30, 2011 at 12:00:13PM +1000, Dave Chinner wrote:
> > -	if (iohead)
> > -		xfs_cancel_ioend(iohead);
> > -
> > -	if (err == -EAGAIN)
> > -		goto redirty;
> > -
> 
> Should this EAGAIN handling be dealt with in the removing-the-non-
> blocking-mode patch?

Probably.

> > +	ret = write_cache_pages(mapping, wbc, __xfs_vm_writepage, &ctx);
> > +
> > +	if (ctx.iohead) {
> > +		if (ret)
> > +			xfs_cancel_ioend(ctx.iohead);
> > +		else
> > +			xfs_submit_ioend(wbc, ctx.iohead);
> > +	}
> 
> I think this error handling does not work. If we have put pages into
> the ioend (i.e. successful ->writepage calls) and then have a
> ->writepage call fail, we'll get all the pages under writeback (i.e.
> those on the ioend) remain in that state, and not ever get written
> back (so move into the clean state) or redirtied (so written again
> later)
> 
> xfs_cancel_ioend() was only ever called for the first page sent down
> to ->writepage, and on error that page was redirtied separately.
> Hence it doesn't handle this case at all as it never occurs in the
> existing code.
> 
> I'd suggest that regardless of whether an error is returned here,
> the existence of ctx.iohead indicates a valid ioend that needs to be
> submitted....

Ok.  That would also solve the problem of the trylock failures.  I'll
see how we can deal with it nicely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
