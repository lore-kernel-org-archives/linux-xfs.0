Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44260 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753046AbeDYNCQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Apr 2018 09:02:16 -0400
Date: Wed, 25 Apr 2018 15:02:10 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] iomap: Use FUA for pure data O_DSYNC DIO writes
Message-ID: <20180425130210.i6drajub4yrbmubf@quack2.suse.cz>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-5-david@fromorbit.com>
 <20180421125405.hyx3bbkohdgvducq@quack2.suse.cz>
 <20180424173444.GA25233@infradead.org>
 <2fb29b95-a39d-3ee7-249b-86614a8dcbb4@applied-asynchrony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2fb29b95-a39d-3ee7-249b-86614a8dcbb4@applied-asynchrony.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de, rdorr@microsoft.com

On Wed 25-04-18 00:07:07, Holger Hoffstätte wrote:
> On 04/24/18 19:34, Christoph Hellwig wrote:
> > On Sat, Apr 21, 2018 at 02:54:05PM +0200, Jan Kara wrote:
> > > > -		if (iocb->ki_flags & IOCB_DSYNC)
> > > > +		if (iocb->ki_flags & IOCB_DSYNC) {
> > > >   			dio->flags |= IOMAP_DIO_NEED_SYNC;
> > > > +			/*
> > > > +			 * We optimistically try using FUA for this IO.  Any
> > > > +			 * non-FUA write that occurs will clear this flag, hence
> > > > +			 * we know before completion whether a cache flush is
> > > > +			 * necessary.
> > > > +			 */
> > > > +			dio->flags |= IOMAP_DIO_WRITE_FUA;
> > > > +		}
> > > 
> > > So I don't think this is quite correct. IOCB_DSYNC gets set also for O_SYNC
> > > writes (in that case we also set IOCB_SYNC). And for those we cannot use
> > > the FUA optimization AFAICT (definitely IOMAP_F_DIRTY isn't a safe
> > > indicator of a need of full fsync for O_SYNC). Other than that the patch
> > > looks good to me.
> > 
> > Oops, good catch. I think the above if should just be
> > 
> > 		if (iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC) == IOCB_DSYNC)) {
> > 
> > and we are fine.
> 
> The above line just gives parenthesis salad errors, so why not compromise
> on:
> 
> 	if ((iocb->ki_flags & (IOCB_DSYNC | IOCB_SYNC)) == IOCB_DSYNC) {
> 
> Unless my bit twiddling has completely left me I think this is what was
> intended, and it actually compiles too.

Yup, I agree this is what needs to happen.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
