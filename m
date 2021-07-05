Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42830C07E95
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 02:04:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26ACC613B9
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 02:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhGECGy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jul 2021 22:06:54 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52025 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229689AbhGECGy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jul 2021 22:06:54 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 4CD0780B8F3;
        Mon,  5 Jul 2021 12:04:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m0Dy3-002rd8-3m; Mon, 05 Jul 2021 12:04:15 +1000
Date:   Mon, 5 Jul 2021 12:04:15 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: don't run shutdown callbacks on active iclogs
Message-ID: <20210705020415.GK664593@dread.disaster.area>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-9-david@fromorbit.com>
 <YN7S1/ZAd4IwP8aE@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7S1/ZAd4IwP8aE@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=oS9dJJxzm0Lt3C4JumUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 09:48:23AM +0100, Christoph Hellwig wrote:
> On Wed, Jun 30, 2021 at 04:38:12PM +1000, Dave Chinner wrote:
> > The problem is that xlog_state_release_iclog() aborts before doing
> > anything if the log is already shut down. It assumes that the
> > callbacks have already been cleaned up, and it doesn't need to do
> > any cleanup.
> > 
> > Hence the fix is to remove the xlog_is_shutdown() check from
> > xlog_state_release_iclog() so that reference counts are correctly
> > released from the iclogs, and when the reference count is zero we
> > always transition to SYNCING if the log is shut down. Hence we'll
> > always enter the xlog_sync() path in a shutdown and eventually end
> > up erroring out the iclog IO and running xlog_state_do_callback() to
> > process the callbacks attached to the iclog.
> 
> Ok, this answers my question to the previous patch.  Maybe add a little
> blurb there?

Done.

> > +	if (xlog_is_shutdown(log)) {
> > +		/*
> > +		 * No more references to this iclog, so process the pending
> > +		 * iclog callbacks that were waiting on the release of this
> > +		 * iclog.
> > +		 */
> > +		spin_unlock(&log->l_icloglock);
> > +		xlog_state_shutdown_callbacks(log);
> > +		spin_lock(&log->l_icloglock);
> > +	} else if (xlog_state_want_sync(log, iclog)) {
> >  		spin_unlock(&log->l_icloglock);
> >  		xlog_sync(log, iclog);
> >  		spin_lock(&log->l_icloglock);
> 
> >  
> > +out_check_shutdown:
> > +	if (xlog_is_shutdown(log))
> > +		return -EIO;
> >  	return 0;
> 
> Nit: we can just return -EIO directly in the first xlog_is_shutdown
> block..  It's not going to make any difference for the CPU, but makes
> the code a little easier to follow.

Fixed.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
