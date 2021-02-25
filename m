Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD80C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF69464E6B
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 22:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhBYW0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 17:26:06 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46694 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229993AbhBYWYh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 17:24:37 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D13FD828597;
        Fri, 26 Feb 2021 09:23:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lFP34-004LHb-Bc; Fri, 26 Feb 2021 09:23:54 +1100
Date:   Fri, 26 Feb 2021 09:23:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/13] xfs:_introduce xlog_write_partial()
Message-ID: <20210225222354.GU4662@dread.disaster.area>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-12-david@fromorbit.com>
 <YDfySTvqwmvK7AOe@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDfySTvqwmvK7AOe@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=YpX6XYsgY_oz99sIGHAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 07:54:01PM +0100, Christoph Hellwig wrote:
> On Wed, Feb 24, 2021 at 05:34:57PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Handle writing of a logvec chain into an iclog that doesn't have
> > enough space to fit it all. The iclog has already been changed to
> > WANT_SYNC by xlog_get_iclog_space(), so the entire remaining space
> > in the iclog is exclusively owned by this logvec chain.
> > 
> > The difference between the single and partial cases is that
> > we end up with partial iovec writes in the iclog and have to split
> > a log vec regions across two iclogs. The state handling for this is
> > currently awful and so we're building up the pieces needed to
> > handle this more cleanly one at a time.
> 
> I did not fully grasp the refactoring yet, so just some superficial
> ramblings for now:
> 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 456ab3294621..74a1dddf1c15 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -2060,6 +2060,7 @@ xlog_state_finish_copy(
> >  
> >  	be32_add_cpu(&iclog->ic_header.h_num_logops, record_cnt);
> >  	iclog->ic_offset += copy_bytes;
> > +	ASSERT(iclog->ic_offset <= iclog->ic_size);
> 
> How is this related to the rest of the patch?  Maybe just add it
> in a prep patch?

Oh, it was debug code I added while tracking down loop iteration
bugs. I forgot to remove it - it didn't actually catch any bugs...

> > +	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> > +					   &contwr, &log_offset);
> > +	if (error)
> > +		return error;
> >  
> > +	/* start_lsn is the LSN of the first iclog written to. */
> > +	if (start_lsn)
> > +		*start_lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> >  
> > +	/*
> > +	 * iclogs containing commit records or unmount records need
> > +	 * to issue ordering cache flushes and commit immediately
> > +	 * to stable storage to guarantee journal vs metadata ordering
> > +	 * is correctly maintained in the storage media. This will always
> > +	 * fit in the iclog we have been already been passed.
> > +	 */
> > +	if (optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)) {
> > +		iclog->ic_flags |= (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
> > +		ASSERT(!contwr);
> > +	}
> >  
> > +	while (lv) {
> > +		lv = xlog_write_single(lv, ticket, iclog, &log_offset,
> > +					&len, &record_cnt, &data_cnt);
> > +		if (!lv)
> >  			break;
> >  
> > +		ASSERT(!(optype & (XLOG_COMMIT_TRANS | XLOG_UNMOUNT_TRANS)));
> > +		lv = xlog_write_partial(log, lv, ticket, &iclog, &log_offset,
> > +					&len, &record_cnt, &data_cnt, &contwr);
> > +		if (IS_ERR(lv)) {
> > +			error = PTR_ERR(lv);
> > +			break;
> >  		}
> >  	}
> 
> Maybe user IS_ERR_OR_NULL and PTR_ERR_OR_ZERO here to catch the NULL
> case as well?  e.g.
> 
> 	for (;;) {
> 		....
> 		lv = xlog_write_partial();
> 		if (IS_ERR_OR_NULL(lv)) {
> 			error = PTR_ERR_OR_ZERO(lv);
> 			break;
> 		}
> 	}

Sure.

> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index acf20c2e5018..c978c52e7ba8 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -896,7 +896,6 @@ xlog_cil_push_work(
> >  	num_iovecs += lvhdr.lv_niovecs;
> >  	num_bytes += lvhdr.lv_bytes;
> >  
> > -
> >  	/*
> 
> This seems misplaced.

Yeah, another bad debug cleanup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
