Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1AFC07E95
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 01:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BDC2613B1
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jul 2021 01:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhGEBtd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 4 Jul 2021 21:49:33 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:45418 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229681AbhGEBtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Jul 2021 21:49:33 -0400
Received: from dread.disaster.area (pa49-179-204-119.pa.nsw.optusnet.com.au [49.179.204.119])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id DD0D680B10D;
        Mon,  5 Jul 2021 11:46:54 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m0DhF-002rHZ-By; Mon, 05 Jul 2021 11:46:53 +1000
Date:   Mon, 5 Jul 2021 11:46:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: separate out log shutdown callback processing
Message-ID: <20210705014653.GJ664593@dread.disaster.area>
References: <20210630063813.1751007-1-david@fromorbit.com>
 <20210630063813.1751007-8-david@fromorbit.com>
 <YN7QDC8j7YEl02JJ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YN7QDC8j7YEl02JJ@infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=Xomv9RKALs/6j/eO6r2ntA==:117 a=Xomv9RKALs/6j/eO6r2ntA==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=6bk3udEsaISfcsgfk74A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jul 02, 2021 at 09:36:28AM +0100, Christoph Hellwig wrote:
> On Wed, Jun 30, 2021 at 04:38:11PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > The iclog callback processing done during a forced log shutdown has
> > different logic to normal runtime IO completion callback processing.
> > Separate out eh shutdown callbacks into their own function and call
> > that from the shutdown code instead.
> > 
> > We don't need this shutdown specific logic in the normal runtime
> > completion code - we'll always run the shutdown version on shutdown,
> > and it will do what shutdown needs regardless of whether there are
> > racing IO completion callbacks scheduled or in progress. Hence we
> > can also simplify the normal IO completion callpath and only abort
> > if shutdown occurred while we actively were processing callbacks.
> 
> What prevents a log shutdown from coming in during the callback
> processing?  Or is there a reason why we simply don't care for that
> case?

We simpy don't care. IO completion based callbacks can already race
with shutdown driven callbacks. RIght now, both cases will process
all iclogs, so it just depends on which one gets to the iclog first
as to which one runs the callbacks. We don't actually pass the
shutdown state to the callbacks, so the callbacks are none-the-wiser
for whether they are being called from shutdown or IO completion
when they see the shutdown state.

With the code as per this patch, a racing shutdown will result in
the callbacks from IO completion seeing the shutdown state, but IO
completion will now avoid processing iclogs out of order/statei
because the shutdown state is set. Hence by taking out the shutdown
check from IO completion, we avoid having IO completion based
callbacks racing with referenced iclogs that have just attached
callbacks to the iclog but haven't yet released their reference and
submitted the iclog for IO...

IOWs, it's not just the callbacks running from shutdown that trigger
the UAF problems with callbacks, it can also occur from IO
completion, too. Hence we really need to separate out the
shutdown case from the IO completion path to avoid it from having
the same problem(s) as the shutdown path...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
