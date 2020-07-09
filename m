Return-Path: <SRS0=XuOj=AU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E36DFC433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:36:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6908206A5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Jul 2020 22:36:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgGIWgc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Jul 2020 18:36:32 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:34206 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726269AbgGIWgc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jul 2020 18:36:32 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 42B553A3E0E;
        Fri, 10 Jul 2020 08:36:27 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jtf9V-0000xz-G4; Fri, 10 Jul 2020 08:36:25 +1000
Date:   Fri, 10 Jul 2020 08:36:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 2/2] xfs: don't access AGI on unlinked inodes if it
 can
Message-ID: <20200709223625.GX2005@dread.disaster.area>
References: <20200707135741.487-1-hsiangkao@redhat.com>
 <20200707135741.487-3-hsiangkao@redhat.com>
 <20200708233311.GP2005@dread.disaster.area>
 <20200709005526.GC15249@xiangao.remote.csb>
 <20200709023246.GR2005@dread.disaster.area>
 <20200709103621.GD15249@xiangao.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709103621.GD15249@xiangao.remote.csb>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=7-415B0cAAAA:8
        a=0BR7uAlELlXKADm1tZoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 09, 2020 at 06:36:21PM +0800, Gao Xiang wrote:
> Hi Dave,
> 
> On Thu, Jul 09, 2020 at 12:32:46PM +1000, Dave Chinner wrote:
> 
> ...
> 
> > > > 	if (trylock AGI)
> > > > 		return;
> > > 
> > > (adding some notes here, this patch doesn't use try lock here
> > >  finally but unlock perag and take AGI and relock and recheck tail_empty....
> > >  since the tail non-empty is rare...)
> > 
> > *nod*
> > 
> > My point was largely that this sort of thing is really obvious and
> > easy to optimise once the locking is cleanly separated. Adding a
> > trylock rather than drop/relock is another patch for the series :P
> 
> I thought trylock way yesterday as well...
> Apart from that we don't have the AGI trylock method yet, it seems
> not work as well...
> 
> Thinking about one thread is holding a AGI lock and wants to lock perag.
> And another thread holds a perag, but the trylock will fail and the second
> wait-lock will cause deadlock... like below:
> 
> Thread 1			Thread 2
>  lock AGI
>                                  lock perag
>  lock perag
>                                  trylock AGI
>                                  lock AGI           <- dead lock here

You forgot to unlock the perag before locking the AGI, so of course
it will deadlock.

Yes, I know my psuedocode example didn't explicitly unlock the perag
because I simply forgot to write it in as I was going. It's pretty
common that quickly written psuedo code to explain a concept is not
perfect, so you still need to think about whether it is correct,
complete, etc.  i.e. if you do:

Thread 1			Thread 2
 lock AGI
                                 lock perag
 lock perag
                                 trylock AGI
				 unlock perag
                                 lock AGI
				 <blocks>

There is no deadlock in this algorithm.

> And trylock perag instead seems not work well as well, since it fails
> more frequently so we need lock AGI and then lock perag as a fallback.

That's kind of what I'd expect - if there is contention on the AGI,
the trylock will fail and we know we are about to sleep. The point
is that "trylock fails" now gives us a point at which we can measure
contention that puts us into the slow path. And because we are now
in the slow path, the overhead of backing out just doesn't matter
because we are going to sleep anyway.

We use this pattern all over XFS to attempt to get locks in reverse
order with minimal overhead in fast paths...

> So currently, I think it's better to use unlock, do something, regrab,
> recheck method for now...

I think that's a mistake - it's smells of trying to optimise the
implementation around immediately observed behaviour instead of
designing a clean, well structured locking scheme that will not need
to be re-optimised over and over again as the algorithm it protects
changes over time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
