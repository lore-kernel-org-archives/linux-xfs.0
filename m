Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CA7C07E98
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 05:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FA0661205
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 05:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhGEFwB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jul 2021 01:52:01 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:54857 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229734AbhGEFwA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jul 2021 01:52:00 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id BC2D21059E7;
        Mon,  5 Jul 2021 15:49:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m0HTr-002vDI-Q0; Mon, 05 Jul 2021 15:49:19 +1000
Date:   Mon, 5 Jul 2021 15:49:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: attached iclog callbacks in
 xlog_cil_set_ctx_write_state()
Message-ID: <20210705054919.GM664593@dread.disaster.area>
References: <20210630072108.1752073-1-david@fromorbit.com>
 <20210630072108.1752073-5-david@fromorbit.com>
 <YN7ZxfrWoCjNFv3g@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7ZxfrWoCjNFv3g@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=HYrEM92qZhgqfVRdgh0A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 10:17:57AM +0100, Christoph Hellwig wrote:
> On Wed, Jun 30, 2021 at 05:21:07PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Now that we have a mechanism to guarantee that the callbacks
> > attached to an iclog are owned by the context that attaches them
> > until they drop their reference to the iclog via
> > xlog_state_release_iclog(), we can attach callbacks to the iclog at
> > any time we have an active reference to the iclog.
> > 
> > xlog_state_get_iclog_space() always guarantees that the commit
> > record will fit in the iclog it returns, so we can move this IO
> > callback setting to xlog_cil_set_ctx_write_state(), record the
> > commit iclog in the context and remove the need for the commit iclog
> > to be returned by xlog_write() altogether.
> > 
> > This, in turn, allows us to move the wakeup for ordered commit
> > recrod writes up into xlog_cil_set_ctx_write_state(), too, because
> 
> s/recrod/record/
> 
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -646,11 +646,41 @@ xlog_cil_set_ctx_write_state(
> >  	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> >  
> >  	ASSERT(!ctx->commit_lsn);
> > +	if (!ctx->start_lsn) {
> > +		spin_lock(&cil->xc_push_lock);
> >  		ctx->start_lsn = lsn;
> > +		spin_unlock(&cil->xc_push_lock);
> > +		return;
> 
> What does xc_push_lock protect here?  None of the read of
> ->start_lsn are under xc_push_lock, and this patch moves one of the
> two readers to be under l_icloglock.

For this patch - nothing. It just maintains the consistency
introduced in the previous patch of doing the CIL context updates
under the xc_push_lock. I did that in the previous patch for
simplicity: the next patch adds the start record ordering which,
like the commit record ordering, needs to set ctx->start_lsn and run
the waiter wakeup under the xc_push_lock.

> Also I wonder if the comment about what is done if start_lsn is not
> set would be better right above the if instead of on top of the function
> so that it stays closer to the code it documents.

I think it's better to document calling conventions at the top of
the function, rather than having to read the implementation of the
function to determine how it is supposed to be called. i.e. we
expect two calls to this function per CIL checkpoint - the first for
the start record ordering, the second for the commit record
ordering...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
