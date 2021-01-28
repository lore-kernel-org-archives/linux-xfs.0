Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC202C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E70964DEB
	for <linux-xfs@archiver.kernel.org>; Thu, 28 Jan 2021 21:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhA1Vrk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 16:47:40 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38896 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231564AbhA1Vrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 16:47:37 -0500
Received: from dread.disaster.area (pa49-181-52-82.pa.nsw.optusnet.com.au [49.181.52.82])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 70CB63C2878;
        Fri, 29 Jan 2021 08:46:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1l5F7t-003W64-SF; Fri, 29 Jan 2021 08:46:53 +1100
Date:   Fri, 29 Jan 2021 08:46:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: journal IO cache flush reductions
Message-ID: <20210128214653.GQ4662@dread.disaster.area>
References: <20210128044154.806715-1-david@fromorbit.com>
 <20210128044154.806715-4-david@fromorbit.com>
 <20210128151205.GC2599027@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128151205.GC2599027@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=7pwokN52O8ERr2y46pWGmQ==:117 a=7pwokN52O8ERr2y46pWGmQ==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=9z4X3TFZ8JHAbs_4P88A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 28, 2021 at 10:12:05AM -0500, Brian Foster wrote:
> On Thu, Jan 28, 2021 at 03:41:52PM +1100, Dave Chinner wrote:
> ...
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c      | 34 ++++++++++++++++++++++------------
> >  fs/xfs/xfs_log_priv.h |  3 +++
> >  2 files changed, 25 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index c5e3da23961c..8de93893e0e6 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> ...
> > @@ -2464,9 +2465,18 @@ xlog_write(
> >  		ASSERT(log_offset <= iclog->ic_size - 1);
> >  		ptr = iclog->ic_datap + log_offset;
> >  
> > -		/* start_lsn is the first lsn written to. That's all we need. */
> > -		if (!*start_lsn)
> > +		/*
> > +		 * Start_lsn is the first lsn written to. That's all the caller
> > +		 * needs to have returned. Setting it indicates the first iclog
> > +		 * of a new checkpoint or the commit record for a checkpoint, so
> > +		 * also mark the iclog as requiring a pre-flush to ensure all
> > +		 * metadata writeback or journal IO in the checkpoint is
> > +		 * correctly ordered against this new log write.
> > +		 */
> > +		if (!*start_lsn) {
> >  			*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > +			iclog->ic_flags |= XLOG_ICL_NEED_FLUSH;
> > +		}
> 
> My understanding is that one of the reasons for the preflush per iclog
> approach is that we don't have any submission -> completion ordering
> guarantees across iclogs. This is why we explicitly order commit record
> completions and whatnot, to ensure the important bits are ordered
> correctly. The fact we implement that ordering ourselves suggests that
> PREFLUSH|FUA itself do not provide such ordering, though that's not
> something I've investigated.

PREFLUSH provides ordering between completed IOs and the IO to be
submitted. It does not provide any ordering guarantees against IO
currently in flight, so the application needs to wait for the IOs it
needs to order against to complete before issuing an IO with
PREFLUSH.

i.e. PREFLUSH provides a "many" completion to "single" submission
ordering guarantee on stable storage.

REQ_FUA only guarantees that when the write IO completes, it is on
stable storage. It does not provide ordering guarantees against any
IO in flight, nor IOs submitted while it is in flight. Once it
completes, however, it is guaranteed taht any latter IO submission
will hit stable storage after that IO.

i.e. REQ_FUA provides a "single" completion to "many" submission
ordering guarantee on stable storage.

> In any event, if the purpose fo the PREFLUSH is to ensure that metadata
> in the targeted LSN range is committed to stable storage, and we have no
> submission ordering guarantees across non-commit record iclogs, what
> prevents a subsequent iclog from the same checkpoint from completing
> before the first iclog with a PREFLUSH?

Fair point. I suspect that we should just do an explicit cache flush
before we start the checkpoint, and then we don't have to worry
about REQ_PREFLUSH for the first iclog in the checkpoint at all.

Actually, I wonder if we can pipeline that - submit an async cache
flush bio as soon as we enter the push work, then once we're ready
to call xlog_write() having pulled the hundreds of thousands of log
vectors off the CIL, we wait on the cache flush bio to complete.
THis gets around the first iclog in a long checkpoint requiring 
cache flushing or FUA. It also means that if there is a single
iclog for the checkpoint, we only need a FUA write as the cache
flush has already been done...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
