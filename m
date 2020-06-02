Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71022C433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:17:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 523E82072F
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbgFBWRw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:17:52 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:59308 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728422AbgFBWRw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 18:17:52 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 28A836ABC20;
        Wed,  3 Jun 2020 08:17:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgFE5-0000nk-3U; Wed, 03 Jun 2020 08:17:41 +1000
Date:   Wed, 3 Jun 2020 08:17:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Message-ID: <20200602221741.GH2040@dread.disaster.area>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-14-david@fromorbit.com>
 <20200602203951.GJ8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602203951.GJ8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=DDe3YbHWxPznl9emZ_wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 01:39:51PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 02, 2020 at 07:42:34AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently when a buffer with attached log items has an IO error
> > it called ->iop_error for each attched log item. These all call
> > xfs_set_li_failed() to handle the error, but we are about to change
> > the way log items manage buffers. hence we first need to remove the
> > per-item dependency on buffer handling done by xfs_set_li_failed().
> > 
> > We already have specific buffer type IO completion routines, so move
> > the log item error handling out of the generic error handling and
> > into the log item specific functions so we can implement per-type
> > error handling easily.
> > 
> > This requires a more complex return value from the error handling
> > code so that we can take the correct action the failure handling
> > requires.  This results in some repeated boilerplate in the
> > functions, but that can be cleaned up later once all the changes
> > cascade through this code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_buf_item.c | 167 ++++++++++++++++++++++++++++--------------
> >  1 file changed, 112 insertions(+), 55 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 09bfe9c52dbdb..b6995719e877b 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -987,20 +987,18 @@ xfs_buf_do_callbacks_fail(
> >  }
> >  
> >  static bool
> > -xfs_buf_iodone_callback_error(
> > +xfs_buf_ioerror_sync(
> >  	struct xfs_buf		*bp)
> >  {
> >  	struct xfs_mount	*mp = bp->b_mount;
> >  	static ulong		lasttime;
> >  	static xfs_buftarg_t	*lasttarg;
> > -	struct xfs_error_cfg	*cfg;
> > -
> >  	/*
> 
> This should preserve the blank line between the declarations and the
> start of the code.
> 
> >  	 * If we've already decided to shutdown the filesystem because of
> >  	 * I/O errors, there's no point in giving this a retry.
> >  	 */
> >  	if (XFS_FORCED_SHUTDOWN(mp))
> > -		goto out_stale;
> > +		return true;
> >  
> >  	if (bp->b_target != lasttarg ||
> >  	    time_after(jiffies, (lasttime + 5*HZ))) {
> > @@ -1011,19 +1009,15 @@ xfs_buf_iodone_callback_error(
> >  
> >  	/* synchronous writes will have callers process the error */
> >  	if (!(bp->b_flags & XBF_ASYNC))
> > -		goto out_stale;
> > -
> > -	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
> > -
> > -	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
> > +		return true;
> > +	return false;
> 
> What does the return value mean here?  true means "let the caller deal
> with the error", false means "attempt a retry, if desired?  So this
> function decides if we're going to fail immediately or not?

Effectively, yes.
> 
> 	if (xfs_buf_ioerr_fail_immediately(bp))
> 		goto out_stale;
> 
> That's a lengthy name though.  On second inspection, I guess this
> function decides if the buffer is going to be sent through the io retry
> mechanism, and the next two functions advance it through the retry
> states until either the write succeeds or we declare permanent failure?

Pretty much. I had some difficulty in working out how to break this
large function up sanely because of the 3-4 conditional functions
it performed for error handling, I named the function originally for
handling sync IO errors vs async IO errors which (may) require
retries.

So, yeah, "fail_immediately" is probably a better description, or
"fail_no_retry" sounds like a better name.

> 
> > +}
> >  
> > -	/*
> > -	 * If the write was asynchronous then no one will be looking for the
> > -	 * error.  If this is the first failure of this type, clear the error
> > -	 * state and write the buffer out again. This means we always retry an
> > -	 * async write failure at least once, but we also need to set the buffer
> > -	 * up to behave correctly now for repeated failures.
> > -	 */
> > +static bool
> > +xfs_buf_ioerror_retry(
> 
> Might be nice to preserve some of this comment, since I initially
> missed that this function both decides whether or not to do the retry
> and sets up the buffer to do that.

I thought I preserved it somewhere... yeah, it's above the
xfs_buf_iodone_error() function now.

> 
> /*
>  * Decide if we're going to retry the write after a failure, and prepare
>  * the buffer for retrying the write.
>  */
> 
> Or, adding some newlines in the outer if body to make the two lines
> that modify the bp state stand out would also help.
> 
> (TBH I'm struggling right now to make sense of what these new functions
> do, though I'm fairly convinced that they at least aren't changing much
> of the functionality...)

I had to break up the IO error handling because the log item error
callbacks for the items attached to the buffer needed to be called
only if we want the higher level to issue retries. Later in this
series we end up with different retry error marking for each type of
buffer, but we only want to do that when the error handling code
itself hasn't done an immediate retry or marked it as a permanent
error.

So I had to break up the function in separate parts so that the
caller could tell exactly what action it needed to take on a
failure.

> > +/*
> > + * On a sync write or shutdown we just want to stale the buffer and let the
> > + * caller handle the error in bp->b_error appropriately.
> > + *
> > + * If the write was asynchronous then no one will be looking for the error.  If
> > + * this is the first failure of this type, clear the error state and write the
> > + * buffer out again. This means we always retry an async write failure at least
> > + * once, but we also need to set the buffer up to behave correctly now for
> > + * repeated failures.
> > + *
> > + * If we get repeated async write failures, then we take action according to the
> > + * error configuration we have been set up to use.
> > + *
> > + * Multi-state return value:
> > + *
> > + * 0: clear IO error retry state and run callback completions
> > + * 1: resubmitted immediately, do not run any completions
> > + * 2: transient error, run failure callback completions and then
> > + *    release the buffer
> 
> Feels odd not to use an enum here, but as this is a static function
> maybe it's not a high risk for screwing up in the callers.

I can change it to use an enum. I wrote this expecting that this
code will get further factored and moved to xfs_buf.c once all the
mods have been made and everything settles down. That's about 3-4
patch series down the road at this point, though, so <shrug>. At
least changes in this patch largely don't affect the rest of this
patchset....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
