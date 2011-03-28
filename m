Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2SCev9A166597 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 07:40:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C521143CDB1
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 05:44:07 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IO1EAOeWi1YoLqXl for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 05:44:07 -0700 (PDT)
Date: Mon, 28 Mar 2011 08:44:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/6] xfs: make discard operations asynchronous
Message-ID: <20110328124405.GA11909@infradead.org>
References: <20110322195550.260682574@bombadil.infradead.org>
	<20110322200138.216042448@bombadil.infradead.org>
	<20110323004323.GH15270@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110323004323.GH15270@dastard>
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

On Wed, Mar 23, 2011 at 11:43:23AM +1100, Dave Chinner wrote:
> > +	struct xfs_cil_ctx	*ctx = bio->bi_private;
> > +
> > +	if (err && err != -EOPNOTSUPP) {
> > +		xfs_info(ctx->cil->xc_log->l_mp,
> > +			 "I/O error during discard\n");
> > +	}
> 
> Same comment about the bno/len in the error message as the previous
> patch.

We don't have the len information available anymore at this point,
but I've added the startblock.

> > +	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
> > +	if (q->limits.discard_granularity) {
> > +		unsigned int disc_sects = q->limits.discard_granularity >> 9;
> > +
> > +		max_discard_sectors &= ~(disc_sects - 1);
> > +	}
> 
> This is asking for a helper function....

Yes, but that helper needs to be shared with the block layer discard
code, so I'll send it through Jens' tree later.

> > +	if (keep_alive)
> > +		xfs_cil_discard_done(ctx);
> > +	else
> > +		kmem_free(ctx);
> 
> You could probably just call xfs_cil_discard_done(ctx) here as the
> busy extent list will be empty in the !keep_alive case and so it
> will simply do the kmem_free(ctx) call there.

This means we clear the busy list a little later in the non-discard
case, but it cleans up the code nicely.  I've added it to the series
as a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
