Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EF8C11F68
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FB07613ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Jul 2021 08:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbhGBI5z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 04:57:55 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48910 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhGBI5y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jul 2021 04:57:54 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 10628867401;
        Fri,  2 Jul 2021 18:55:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lzExD-001py5-BQ; Fri, 02 Jul 2021 18:55:19 +1000
Date:   Fri, 2 Jul 2021 18:55:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/9] xfs: XLOG_STATE_IOERROR must die
Message-ID: <20210702085519.GH664593@dread.disaster.area>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-3-david@fromorbit.com>
 <YN7HivsUsXYmfBHM@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7HivsUsXYmfBHM@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=7-415B0cAAAA:8
        a=wFg6C7Fa0xZMKnIwisUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 09:00:10AM +0100, Christoph Hellwig wrote:
> >  	else
> >  		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> > -		       iclog->ic_state == XLOG_STATE_IOERROR);
> > +			xlog_is_shutdown(log));
> 
> Nit:  think doing this as:
> 
> 	else if (!xlog_is_shutdown(log))
> 		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
> 
> would be a tad cleaner.

I kill a lot of these checks in the near future. Once the log
shutdown doesn't change the iclog state, we no longer need to check
if the log is shutdown when checking state like this because
shutdown doesn't change the iclog state when we have active
references to the iclog....

IOWs, these are all figments of the horrible racy log shutdown that
changes the iclog state regardless of who is using the iclog at the
time. This pattern sucks, it's broken and it goes away soon so
there's not much point in rearranging these asserts...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
