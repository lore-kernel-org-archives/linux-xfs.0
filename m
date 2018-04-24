Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36452 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752510AbeDXRer (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Apr 2018 13:34:47 -0400
Date: Tue, 24 Apr 2018 10:34:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180424173444.GA25233@infradead.org>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-5-david@fromorbit.com>
 <20180421125405.hyx3bbkohdgvducq@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180421125405.hyx3bbkohdgvducq@quack2.suse.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On Sat, Apr 21, 2018 at 02:54:05PM +0200, Jan Kara wrote:
> > -		if (iocb->ki_flags & IOCB_DSYNC)
> > +		if (iocb->ki_flags & IOCB_DSYNC) {
> >  			dio->flags |= IOMAP_DIO_NEED_SYNC;
> > +			/*
> > +			 * We optimistically try using FUA for this IO.  Any
> > +			 * non-FUA write that occurs will clear this flag, hence
> > +			 * we know before completion whether a cache flush is
> > +			 * necessary.
> > +			 */
> > +			dio->flags |= IOMAP_DIO_WRITE_FUA;
> > +		}
> 
> So I don't think this is quite correct. IOCB_DSYNC gets set also for O_SYNC
> writes (in that case we also set IOCB_SYNC). And for those we cannot use
> the FUA optimization AFAICT (definitely IOMAP_F_DIRTY isn't a safe
> indicator of a need of full fsync for O_SYNC). Other than that the patch
> looks good to me.

Oops, good catch. I think the above if should just be

		if (iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC) == IOCB_DSYNC)) {

and we are fine. 

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
