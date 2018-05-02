Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:11272 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751069AbeEBCfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 22:35:00 -0400
Date: Wed, 2 May 2018 12:34:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/4] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180502023450.GZ23861@dastard>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-5-david@fromorbit.com>
 <20180421125405.hyx3bbkohdgvducq@quack2.suse.cz>
 <20180424173444.GA25233@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180424173444.GA25233@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On Tue, Apr 24, 2018 at 10:34:44AM -0700, Christoph Hellwig wrote:
> On Sat, Apr 21, 2018 at 02:54:05PM +0200, Jan Kara wrote:
> > > -		if (iocb->ki_flags & IOCB_DSYNC)
> > > +		if (iocb->ki_flags & IOCB_DSYNC) {
> > >  			dio->flags |= IOMAP_DIO_NEED_SYNC;
> > > +			/*
> > > +			 * We optimistically try using FUA for this IO.  Any
> > > +			 * non-FUA write that occurs will clear this flag, hence
> > > +			 * we know before completion whether a cache flush is
> > > +			 * necessary.
> > > +			 */
> > > +			dio->flags |= IOMAP_DIO_WRITE_FUA;
> > > +		}
> > 
> > So I don't think this is quite correct. IOCB_DSYNC gets set also for O_SYNC
> > writes (in that case we also set IOCB_SYNC). And for those we cannot use
> > the FUA optimization AFAICT (definitely IOMAP_F_DIRTY isn't a safe
> > indicator of a need of full fsync for O_SYNC). Other than that the patch
> > looks good to me.
> 
> Oops, good catch. I think the above if should just be
> 
> 		if (iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC) == IOCB_DSYNC)) {
> 
> and we are fine. 

Ah, not exactly. IOMAP_DIO_NEED_SYNC needs to be set for either
DYSNC or SYNC writes, while IOMAP_DIO_WRITE_FUA should only be set
for DSYNC.

I'll fix this up appropriately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
