Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BDBC47087
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 23:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 008FE6140F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 May 2021 23:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhEZAAv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 20:00:51 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34026 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232155AbhEZAAt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 20:00:49 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 571F31B09B8;
        Wed, 26 May 2021 09:59:15 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1llgx8-005Emk-4L; Wed, 26 May 2021 09:59:14 +1000
Date:   Wed, 26 May 2021 09:59:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: centralize page allocation and freeing for
 buffers
Message-ID: <20210525235914.GM664593@dread.disaster.area>
References: <20210519190900.320044-1-hch@lst.de>
 <20210519190900.320044-9-hch@lst.de>
 <20210519232245.GG664593@dread.disaster.area>
 <20210520053504.GA21318@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520053504.GA21318@lst.de>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=7-415B0cAAAA:8
        a=0FGCbQyZzI59JlaFn_wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 20, 2021 at 07:35:04AM +0200, Christoph Hellwig wrote:
> On Thu, May 20, 2021 at 09:22:45AM +1000, Dave Chinner wrote:
> > Up until this point in the patch set you are pulling code out
> > of xfs_buf_alloc_pages() into helpers. Now you are getting rid of
> > the helpers and putting the slightly modified code back into
> > xfs_buf_alloc_pages(). This doesn't make any sense at all.
> 
> It makes a whole lot of sense, but it seems you don't like the
> structure :)
> 
> As stated in the commit log we now have one helper that sets a
> _XBF_PAGES backing with pages and the map, and one helper to
> tear it down.   I think it makes a whole lot of sense this way.

I don't like the way the patchset is built. It creates temporary
infrastructure, then tears it down again to return the code to
almost exactly the same structure that it originally had. In doing
this, you change the semantics of functions and helpers multiple
times yet, eventually, we end up with the same semantics as we
started with.

It's much more obvious to factor out the end helpers first, with the
exact semantics that the current have and will end up with, and then
just convert and clean up the code in and around those helpers. It's
much easier to follow and very correct if the function call
semnatics and behaviour don't keep changing...

> > The freeing helper now requires the buffer state to be
> > manipulated on allocation failure so that the free function doesn't
> > run off the end of the bp->b_pages array. That's a bit of a
> > landmine, and it doesn't really clean anything up much at all.
> 
> It is something we also do elsewhere in the kernel.  Another
> alternative would be to do a NULL check on the page, or to just
> pointlessly duplicate the freeing loop.

A null check in the freeing code is much simpler to understand at a
glance. It's easy to miss that the error handling only works because
callers have a single extra line of code that makes error handling
work correctly. This is a bad pattern because it's easy for new code
to get it wrong and have nobody notice that it's wrong.

> > And on the allocation side there is new "fail fast" behaviour
> > because you've lifted the readahead out of xfs_buf_alloc_pages. You
> > also lifted the zeroing checks, which I note that you immediately
> > put back inside xfs_buf_alloc_pages() in the next patch.
> 
> This is to clearly split code consolidatation from behavior changes.
> I could move both earlier at the downside of adding a lot of new
> code first that later gets removed.

Ah, what new code? factoring out the _alloc_pages() code at the same
time as the alloc_kmem() code is the only "new" code that is
necessary. Everything else is then consolidation, and this doesn't
require repeatedly changing behaviour and moving code out and back
into helpers....

> > I mean, like the factoring of xfs_buf_alloc_slab(), you could have
> > just factored out xfs_buf_alloc_pages(bp, page_count) from
> > xfs_buf_allocate_memory() and used that directly in
> > xfs_buf_get_uncached() and avoided a bunch of this factoring, make a
> > slight logic modification and recombine churn. And it would be
> > trivial to do on top of the bulk allocation patch which already
> > converts both of these functions to use bulk allocation....
> 
> As mentioned in the cover letter: the bulk allocation review is what
> trigger this as it tripped me following various lose ends.  And as
> usual I'd rather have that kind of change at the end where the
> surrounding code makes sense, so the rebased version is now is patch 11
> of this series.

I've re-written my patch based on this cleanup series. It largely
does all the same things, and ends up largely in the same place, but
does things in an order that doesn't keep changing behaviour and
repeatedly moving the same code around. I'll post it once I've QA'd
it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
