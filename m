Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7DAC3A5A9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 21:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FCC921726
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 21:14:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfIDVO6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 17:14:58 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52252 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbfIDVO6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 17:14:58 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9AC4843EBC2;
        Thu,  5 Sep 2019 07:14:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5ccA-0007Vk-Ag; Thu, 05 Sep 2019 07:14:54 +1000
Date:   Thu, 5 Sep 2019 07:14:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: factor debug code out of
 xlog_state_do_callback()
Message-ID: <20190904211454.GF1119@dread.disaster.area>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-4-david@fromorbit.com>
 <20190904061038.GC12591@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904061038.GC12591@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=J70Eh1EUuV4A:10
        a=7-415B0cAAAA:8 a=ZgVjJpqDj-T1eQ5lgFAA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 03, 2019 at 11:10:38PM -0700, Christoph Hellwig wrote:
> > + * Note that SYNCING|IOABORT is a valid state so we cannot just check for
> > + * ic_state == SYNCING.
> 
> I've removed the IOABORT flag recently, but it seems I forgot to remove
> this comment. 

I think the comment is still relevant for SYNCING|IOERROR state,
so I s/ABORT/ERROR/

> That beeing said the IOERR flag is still a complete mess
> as we sometimes use it as a flag and sometimes as a separate state.
> I've been wanting to sort that out, but always got preempted.

Yes, I started cleaning that up (eg. using XLOG_FORCED_SHUTDOWN
instead of checking the IOERROR state of the first iclog for
shutdown) but it's not that simple unfortunately - it's a bit of a
mess - and so I dropped that from the series to get the fixes out.
I have an idea of what is wrong, but it's not ready yet.

> > + */
> > +static void
> > +xlog_state_callback_check_state(
> > +	struct xlog		*log,
> > +	int			did_callbacks)
> > +{
> > +	struct xlog_in_core	*iclog;
> > +	struct xlog_in_core	*first_iclog;
> > +
> > +	if (!did_callbacks)
> > +		return;
> > +
> > +	first_iclog = iclog = log->l_iclog;
> 
> I'd keep the did_callbacks check in the caller.  For the non-debug case
> it will be optimized away, but it saves an argument, and allows
> initializing the iclog variables on the declaration line.

Fixed.

FWIW, I started cleaning that up to with xlog_for_each_iclog()
for all the places where we iterate like this. But that's also
dependent on the IOERROR cleanup I shelved for the moment....

> > +	do {
> > +		ASSERT(iclog->ic_state != XLOG_STATE_DO_CALLBACK);
> > +		/*
> > +		 * Terminate the loop if iclogs are found in states
> > +		 * which will cause other threads to clean up iclogs.
> > +		 *
> > +		 * SYNCING - i/o completion will go through logs
> > +		 * DONE_SYNC - interrupt thread should be waiting for
> > +		 *              l_icloglock
> > +		 * IOERROR - give up hope all ye who enter here
> > +		 */
> > +		if (iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> > +		    iclog->ic_state & XLOG_STATE_SYNCING ||
> > +		    iclog->ic_state == XLOG_STATE_DONE_SYNC ||
> > +		    iclog->ic_state == XLOG_STATE_IOERROR )
> > +			break;
> > +		iclog = iclog->ic_next;
> 
> No new, but if we list the states we should not miss one..

Which one if missing?

Cheers,
-- 
Dave Chinner
david@fromorbit.com
