Return-Path: <SRS0=6H2z=7S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9706FC433E0
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 00:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76BEC20738
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Jun 2020 00:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgFEA7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 20:59:45 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:41851 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725943AbgFEA7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 20:59:44 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 766B1D5A016;
        Fri,  5 Jun 2020 10:59:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jh0hx-0001v4-JG; Fri, 05 Jun 2020 10:59:41 +1000
Date:   Fri, 5 Jun 2020 10:59:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Message-ID: <20200605005941.GY2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-14-david@fromorbit.com>
 <20200604140520.GD17815@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604140520.GD17815@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=2Sx8kMDp2BgGTo8Dmc8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 04, 2020 at 10:05:20AM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:45:49PM +1000, Dave Chinner wrote:
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
> >  fs/xfs/xfs_buf_item.c | 215 ++++++++++++++++++++++++++++--------------
> >  1 file changed, 145 insertions(+), 70 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 09bfe9c52dbdb..3560993847b7c 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> ...
> > @@ -1011,91 +1014,115 @@ xfs_buf_iodone_callback_error(
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
> > +}
> >  
> > -	/*
> > -	 * If the write was asynchronous then no one will be looking for the
> > -	 * error.  If this is the first failure of this type, clear the error
> > -	 * state and write the buffer out again. This means we always retry an
> > -	 * async write failure at least once, but we also need to set the buffer
> > -	 * up to behave correctly now for repeated failures.
> > -	 */
> > -	if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) ||
> > -	     bp->b_last_error != bp->b_error) {
> > -		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> > -		bp->b_last_error = bp->b_error;
> > -		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> > -		    !bp->b_first_retry_time)
> > -			bp->b_first_retry_time = jiffies;
> > +static bool
> > +xfs_buf_ioerror_retry(
> > +	struct xfs_buf		*bp,
> > +	struct xfs_error_cfg	*cfg)
> > +{
> > +	if (bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL))
> > +		return false;
> > +	if (bp->b_last_error == bp->b_error)
> > +		return false;
> 
> This looks like a subtle logic change. The current code issues the
> internal retry if the flag isn't set (i.e. first ioerror in the
> sequence) or if the current error code differs from the previous. This
> code only looks at ->b_last_error if the fail flag wasn't set.

Yeah, well spotted. Brain fart: !A||!B == !(A && B). It should be:

	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
	    bp->b_last_error == bp->b_error)
		return false;

> >  
> > -		xfs_buf_ioerror(bp, 0);
> > -		xfs_buf_submit(bp);
> > -		return true;
> > -	}
> > +	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
> > +	bp->b_last_error = bp->b_error;
> > +	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
> > +	    !bp->b_first_retry_time)
> > +		bp->b_first_retry_time = jiffies;
> > +	return true;
> > +}
> >  
> ...
> > -static inline bool
> > -xfs_buf_had_callback_errors(
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
> > + * XBF_IOERROR_FINISH: clear IO error retry state and run callback completions
> > + * XBF_IOERROR_DONE: resubmitted immediately, do not run any completions
> > + * XBF_IOERROR_FAIL: transient error, run failure callback completions and then
> > + *    release the buffer
> > + */
> > +enum {
> > +	XBF_IOERROR_FINISH,
> > +	XBF_IOERROR_DONE,
> 
> I like the enum, but I have a hard time distinguishing what the
> difference is between FINISH and DONE based on the naming. I think

It was really just describing the action the caller needs to take.
i.e. "buffer IO still needs finishing" vs "buffer IO is done,
nothing more to do" vs "Buffer IO needs failure completion".

> RESUBMIT would be more clear than DONE and perhaps have the resubmit in
> the caller, but then we'd have to duplicate that as well. Eh, perhaps it
> makes sense to defer such potential cleanups to the end.

Yeah, renaming just cascades the rename through multiple patches at
this point. I'll take a note for later.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
