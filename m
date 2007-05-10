Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 23:52:02 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4A6pufB013695
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 23:51:57 -0700
Date: Thu, 10 May 2007 16:51:53 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: unwritten extent conversion vs synchronous direct I/O
Message-ID: <20070510065153.GY85884050@sgi.com>
References: <20070508065126.GK32602149@melbourne.sgi.com> <AA27F76178127851854604F7@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AA27F76178127851854604F7@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, May 10, 2007 at 04:11:01PM +1000, Timothy Shimmin wrote:
> Hi Dave,
> 
> --On 8 May 2007 4:51:26 PM +1000 David Chinner <dgc@sgi.com> wrote:
> 
> >
> >Back in 2.6.13, unwritten extent conversion was changed to be done
> >via a workqueue because we can't do conversion in interrupt context
> >(AIO issue). The problem was that the changes extent conversion to
> >run asynchronously w.r.t I/o completion.
> 
> Oh ok, and at the same time they used the workqueue also (apart
> from AIO) for synchronous direct writes even though they didn't have to.
> i.e the existing comment:
>     * This is not necessary for synchronous direct I/O, but we do
>     * it anyway to keep the code uniform and simpler.

Yes, exactly.

> So you were tossing up whether to flush the queue as in the patch given
> or to effectively call the code of xfs_end_bio_unwritten to
> do the unwritten extent conversion straight away.
> Hmmm....I dunno :)
>  Does it matter? What are the pros and cons? :)

I think with async buffered writes we are doing I/O completion in
IRQ context as well so it seems to me that we have to push the
unwritten extent conversion off to a workqueue in that case.

I don't think there's any great overhead from flushing only when
we are doing sync dio writes - all that calling
xfs_end_bio_unwritten() directly saves us is a couple of context
switches. However, that could promote I/o completion ahead of
other I/Os waiting in the workqueue....

I think I'm convincing myself that the workqueue flush is the
correct thing to do here ;)


>  Does it matter if we flush the whole queue now or later?

We have to wait for it to complete, and that's what the flush does;
it waits for the queued work up to the flush entrance sequence
to complete. It's really the only way we can wait for a specific
item in a workqueue to be run. So yes, it needs to be run now,
not later.

>  Is it nicer/simpler for this to always happen in the queue?

I think so.

>  Is it a bit silly to queue and immediately flush?

I think that's the way you're supposed to do things ;)

> * Possible typo in comment:
>  s/passed to use to determine/passed to us to determine/
> 
> * Don't really need the "? 1 : 0"
>   is_sync_kiocb(iocb) ? 1 : 0
> =>
>   is_sync_kiocb(iocb)

Right - I'll fix that.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
