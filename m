Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9439CC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 01:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 677076527E
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Mar 2021 01:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbhCIBOR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 20:14:17 -0500
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:32950 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229599AbhCIBN6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Mar 2021 20:13:58 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 9367DFAA124;
        Tue,  9 Mar 2021 12:13:53 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lJQwa-000L8X-6z; Tue, 09 Mar 2021 12:13:52 +1100
Date:   Tue, 9 Mar 2021 12:13:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/45] xfs: journal IO cache flush reductions
Message-ID: <20210309011352.GD74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-9-david@fromorbit.com>
 <YEYXtqb7L1zyAHyC@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEYXtqb7L1zyAHyC@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=t_Mika3xE8SKjnU52iAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 07:25:26AM -0500, Brian Foster wrote:
> On Fri, Mar 05, 2021 at 04:11:06PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> > guarantee the ordering requirements the journal has w.r.t. metadata
> > writeback. THe two ordering constraints are:
....
> > The rm -rf times are included because I ran them, but the
> > differences are largely noise. This workload is largely metadata
> > read IO latency bound and the changes to the journal cache flushing
> > doesn't really make any noticable difference to behaviour apart from
> > a reduction in noiclog events from background CIL pushing.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Thoughts on my previous feedback to this patch, particularly the locking
> bits..? I thought I saw a subsequent patch somewhere that increased the
> parallelism of this code..

I seem to have missed that email, too.

I guess you are refering to these two hunks:

> > @@ -2416,10 +2408,21 @@ xlog_write(
> >  		ASSERT(log_offset <= iclog->ic_size - 1);
> >  		ptr = iclog->ic_datap + log_offset;
> >  
> > -		/* start_lsn is the first lsn written to. That's all we need. */
> > +		/* Start_lsn is the first lsn written to. */
> >  		if (start_lsn && !*start_lsn)
> >  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> >  
> > +		/*
> > +		 * iclogs containing commit records or unmount records need
> > +		 * to issue ordering cache flushes and commit immediately
> > +		 * to stable storage to guarantee journal vs metadata ordering
> > +		 * is correctly maintained in the storage media.
> > +		 */
> > +		if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> > +			iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH |
> > +						XLOG_ICL_NEED_FUA);
> > +		}
> > +
> >  		/*
> >  		 * This loop writes out as many regions as can fit in the amount
> >  		 * of space which was allocated by xlog_state_get_iclog_space().
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index c04d5d37a3a2..263c8d907221 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -896,11 +896,16 @@ xlog_cil_push_work(
> >  
> >  	/*
> >  	 * If the checkpoint spans multiple iclogs, wait for all previous
> > -	 * iclogs to complete before we submit the commit_iclog.
> > +	 * iclogs to complete before we submit the commit_iclog. If it is in the
> > +	 * same iclog as the start of the checkpoint, then we can skip the iclog
> > +	 * cache flush because there are no other iclogs we need to order
> > +	 * against.
> >  	 */
> >  	if (ctx->start_lsn != commit_lsn) {
> >  		spin_lock(&log->l_icloglock);
> >  		xlog_wait_on_iclog(commit_iclog->ic_prev);
> > +	} else {
> > +		commit_iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
> >  	}

.... that set/clear the flags on the iclog?  Yes, they probably
should be atomic.

On second thoughts, we can't just clear XLOG_ICL_NEED_FLUSH here
because there may be multiple commit records on this iclog and a
previous one might require the flush. I'll just remove this
optimisation from the patch right now, because it's more complex
than it initially seemed.

And looking at the aggregated code that I have now (including the
stuff I haven't sent out), the need for xlog_write() to set the
flush flags on the iclog is gone. THis is because the unmount record
flushes the iclog directly itself so it can add flags there, and
the iclog that the commit record is written to is returned to the
caller.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
