Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487ECC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 17:58:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241148AbiAKR6c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 12:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240999AbiAKR6c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 12:58:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF328C06173F
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 09:58:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97C47B81C5A
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 17:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D7DC36AE3;
        Tue, 11 Jan 2022 17:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641923909;
        bh=mxF/C17EVqc86IA9OlTEVK6mzr/eHXEdN5MKSeaqgj0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+flsEAcdIrve0xmUMkzMtx08BfvQwvnAFetCPpUy7DrTRPbOF1I89V+dZ2frOgc1
         FIB0gY1Iaq4T6GFxqL+7B+K3rLyjjdqk1oPlf+twCvaWvCp/rFdcUiPZBTqB2ZCByR
         RlreoaUhYqf8w6hLnv7vEAYiRH7TdYXB0fCWgQ6tQVq1ZbG+Rj41O05xDIt75lL5F9
         M05ynRHTSwTo2xZWyBjpvpJAA8UdJZbxrjf7X+AMQxehu1D7PQD4vVJuJwA1tn9n6a
         zkb7nQA7HO7NOzB+tESsRPPMcbEKmWdCI5AB0HL8auaFqCNkHZq4hGy4fn+H3qEkD5
         ggfRBFO6swzsg==
Date:   Tue, 11 Jan 2022 09:58:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] xfs: xlog_write rework and CIL scalability
Message-ID: <20220111175828.GC656707@magnolia>
References: <20211210000956.GO449541@dread.disaster.area>
 <20220106214033.GR656707@magnolia>
 <20220111050437.GA3290465@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220111050437.GA3290465@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 11, 2022 at 04:04:37PM +1100, Dave Chinner wrote:
> On Thu, Jan 06, 2022 at 01:40:33PM -0800, Darrick J. Wong wrote:
> > On Fri, Dec 10, 2021 at 11:09:56AM +1100, Dave Chinner wrote:
> > > Hi Darrick,
> > > 
> > > Can you please pull the following changes from the tag listed below
> > > for the XFS dev tree?
> > 
> > Hi Dave,
> > 
> > I tried, but the regressions with generic/017 persist.  It trips the
> > ticket reservation pretty consistently within 45-60 seconds of starting,
> > at least on the OCI VM that I created.  /dev/sd[ab] are (software
> > defined) disks that can sustain reads of ~50MB/s and ~5000iops; and
> > writes of about half those numbers.
> > 
> >  run fstests generic/017 at 2022-01-06 13:18:59
> >  XFS (sda4): Mounting V5 Filesystem
> >  XFS (sda4): Ending clean mount
> >  XFS (sda4): Quotacheck needed: Please wait.
> >  XFS (sda4): Quotacheck: Done.
> >  XFS (sda4): ctx ticket reservation ran out. Need to up reservation
> >  XFS (sda4): ticket reservation summary:
> >  XFS (sda4):   unit res    = 548636 bytes
> >  XFS (sda4):   current res = -76116 bytes
> >  XFS (sda4):   original count  = 1
> >  XFS (sda4):   remaining count = 1
> >  XFS (sda4): Log I/O Error (0x2) detected at xlog_write+0x5ee/0x660 [xfs] (fs/xfs/xfs_log.c:2499).  Shutting down filesystem.
> >  XFS (sda4): Please unmount the filesystem and rectify the problem(s)
> >  XFS (sda3): Unmounting Filesystem
> >  XFS (sda4): Unmounting Filesystem
> 
> Ok, I *think* I've worked out what was going on here. The patch
> below has run several hundred iterations of g/017 with an external
> log on two different fs/log size configurations that typically
> reproduced in within 10 cycles.
> 
> Essentially, the problem is largely caused by using
> XLOG_CIL_BLOCKING_SPACE_LIMIT() instead of XLOG_CIL_SPACE_LIMIT()
> when determining how much used space we can allow the percpu
> counters to accumulate before aggregating them back into the global
> counter. Using the hard limit meant that we could accumulate almost
> the entire hard limit before we aggregate even a single percpu value
> back into the global limit, resulting in failing to trigger either
> condition for aggregation until we'd effectively blown through the
> hard limit.
> 
> This then meant the extra reservations that need to be taken for
> space used beyond the hard limit didn't get stolen for the ctx
> ticket, and it then overruns.
> 
> It also means that we could overrun the hard limit substantially
> before throttling kicked in. With the percpu aggregation threshold
> brought back down to the (soft limit / num online cpus) we are
> guaranteed to always start aggregation back into the global counter
> before or at the point in time the soft limit should be hit, meaning
> that we start updating the global counter much sooner and so are it
> tracks actual space used once over the soft limit much more closely.
> 
> Darrick, can you rerun the branch with the patch below also included, and
> see if it reproduces on your setup? If it does, can you grab a trace
> of the trace_printk() calls I left in the patch?

Ok, I'll do that and report back.

> Note that this change does not make the algorithm fully correct - we
> can still have accumulation on other CPUs that isn't folded back
> into the global value. What I want is feedback on whether it makes
> the problem largely go away on configs other than my own before
> spending more time coming up with a better lockless aggregation
> algorithm...

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> ---
>  fs/xfs/xfs_log_cil.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 366c0aaad640..47d46d6e15b3 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -96,6 +96,9 @@ xlog_cil_pcp_aggregate(
>  		ctx->ticket->t_curr_res += cilpcp->space_reserved;
>  		ctx->ticket->t_unit_res += cilpcp->space_reserved;
>  		cilpcp->space_reserved = 0;
> +	trace_printk("cilpcp space used %d, reserved %d unit-res %d cur-res %d",
> +			cilpcp->space_used, cilpcp->space_reserved,
> +			ctx->ticket->t_unit_res, ctx->ticket->t_curr_res);
>  
>  		if (!list_empty(&cilpcp->busy_extents)) {
>  			list_splice_init(&cilpcp->busy_extents,
> @@ -515,11 +518,16 @@ xlog_cil_insert_items(
>  	 *
>  	 * This can steal more than we need, but that's OK.
>  	 */
> -	space_used = atomic_read(&ctx->space_used);
> +	space_used = atomic_read(&ctx->space_used) + len;
>  	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
> -	    space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> +	    space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
>  		int	split_res = log->l_iclog_hsize +
>  					sizeof(struct xlog_op_header);
> +
> +	trace_printk("space used %d, len %d iclog hdrs %d, slim %d, hlim %d",
> +			space_used, len, atomic_read(&cil->xc_iclog_hdrs),
> +			XLOG_CIL_SPACE_LIMIT(log),
> +			XLOG_CIL_BLOCKING_SPACE_LIMIT(log));
>  		if (ctx_res)
>  			ctx_res += split_res * (tp->t_ticket->t_iclog_hdrs - 1);
>  		else
> @@ -540,8 +548,9 @@ xlog_cil_insert_items(
>  	cilpcp->space_used += len;
>  	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
>  	    cilpcp->space_used >
> -			((XLOG_CIL_BLOCKING_SPACE_LIMIT(log) - space_used) /
> -					num_online_cpus())) {
> +			(XLOG_CIL_SPACE_LIMIT(log) / num_online_cpus())) {
> +	trace_printk("cilpcp space used %d, reserved %d ctxres %d",
> +			cilpcp->space_used, cilpcp->space_reserved, ctx_res);
>  		atomic_add(cilpcp->space_used, &ctx->space_used);
>  		cilpcp->space_used = 0;
>  	}
> @@ -1331,6 +1340,7 @@ xlog_cil_push_background(
>  
>  	spin_lock(&cil->xc_push_lock);
>  	if (cil->xc_push_seq < cil->xc_current_sequence) {
> +		trace_printk("push sapce used %d", space_used);
>  		cil->xc_push_seq = cil->xc_current_sequence;
>  		queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
>  	}
