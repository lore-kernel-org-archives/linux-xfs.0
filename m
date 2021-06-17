Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91029C2B9F4
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 21:55:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64FED61249
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 21:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhFQV52 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 17:57:28 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46089 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229816AbhFQV52 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 17:57:28 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9C9D486323B;
        Fri, 18 Jun 2021 07:55:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltzyl-00DxNE-3H; Fri, 18 Jun 2021 07:55:15 +1000
Date:   Fri, 18 Jun 2021 07:55:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: don't wait on future iclogs when pushing the CIL
Message-ID: <20210617215515.GB664593@dread.disaster.area>
References: <20210617082617.971602-1-david@fromorbit.com>
 <20210617082617.971602-3-david@fromorbit.com>
 <20210617174910.GT158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210617174910.GT158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=7yxSLlwqS3lPvJho:21 a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=ie-8wwNtej2VgU03r68A:9 a=CjuIK1q_8ugA:10 a=ryn_BjxYRQEVhTpXJPha:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 17, 2021 at 10:49:10AM -0700, Darrick J. Wong wrote:
> On Thu, Jun 17, 2021 at 06:26:11PM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 705619e9dab4..2fb0ab02dda3 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -1075,15 +1075,54 @@ xlog_cil_push_work(
> >  	ticket = ctx->ticket;
> >  
> >  	/*
> > -	 * If the checkpoint spans multiple iclogs, wait for all previous
> > -	 * iclogs to complete before we submit the commit_iclog. In this case,
> > -	 * the commit_iclog write needs to issue a pre-flush so that the
> > -	 * ordering is correctly preserved down to stable storage.
> > +	 * If the checkpoint spans multiple iclogs, wait for all previous iclogs
> > +	 * to complete before we submit the commit_iclog. We can't use state
> > +	 * checks for this - ACTIVE can be either a past completed iclog or a
> > +	 * future iclog being filled, while WANT_SYNC through SYNC_DONE can be a
> > +	 * past or future iclog awaiting IO or ordered IO completion to be run.
> > +	 * In the latter case, if it's a future iclog and we wait on it, the we
> > +	 * will hang because it won't get processed through to ic_force_wait
> > +	 * wakeup until this commit_iclog is written to disk.  Hence we use the
> > +	 * iclog header lsn and compare it to the commit lsn to determine if we
> > +	 * need to wait on iclogs or not.
> >  	 */
> >  	spin_lock(&log->l_icloglock);
> >  	if (ctx->start_lsn != commit_lsn) {
> > -		xlog_wait_on_iclog(commit_iclog->ic_prev);
> > -		spin_lock(&log->l_icloglock);
> > +		struct xlog_in_core	*iclog;
> > +
> > +		for (iclog = commit_iclog->ic_prev;
> > +		     iclog != commit_iclog;
> > +		     iclog = iclog->ic_prev) {
> > +			xfs_lsn_t	hlsn;
> > +
> > +			/*
> > +			 * If the LSN of the iclog is zero or in the future it
> > +			 * means it has passed through IO completion and
> > +			 * activation and hence all previous iclogs have also
> > +			 * done so. We do not need to wait at all in this case.
> > +			 */
> > +			hlsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > +			if (!hlsn || XFS_LSN_CMP(hlsn, commit_lsn) > 0)
> > +				break;
> > +
> > +			/*
> > +			 * If the LSN of the iclog is older than the commit lsn,
> > +			 * we have to wait on it. Waiting on this via the
> > +			 * ic_force_wait should also order the completion of all
> > +			 * older iclogs, too, but we leave checking that to the
> > +			 * next loop iteration.
> > +			 */
> > +			ASSERT(XFS_LSN_CMP(hlsn, commit_lsn) < 0);
> > +			xlog_wait_on_iclog(iclog);
> > +			spin_lock(&log->l_icloglock);
> 
> The presence of a loop here confuses me a bit -- we really only need to
> check and wait on commit->ic_prev since xlog_wait_on_iclog waits for
> both the iclog that it is given as well as all previous iclogs, right?

I originally wrote this thinking about using the ic_write_wait queue
which would require checking all iclogs in the ring because the
completion signalled at the DONE_SYNC state is not ordered against
other iclogs. Hence I had planned to walk all the iclogs. THen I
realised that checking the LSN could tell us past/future and so we
only needed to wait on the first iclog with a LSN less than the
commit iclog.

ANd so I left the loop in place to ensure that, even if my assertion
about the ring aging order was incorrect, this code would Do The
Right Thing.

> we've waited on commit->ic_prev, the next iclog iterated (i.e.
> commit->ic_prev->ic_prev) should break out of the loop?

Yes, that is what it does.

I can strip this all out - it was really just being defensive
because I wanted to make sure things were working as I expected them
to be working...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
