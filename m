Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43792 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726219AbfHIV6p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:58:45 -0400
Date: Sat, 10 Aug 2019 07:57:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] direct-io: use GFP_NOIO to avoid deadlock
Message-ID: <20190809215733.GZ7777@dread.disaster.area>
References: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com>
 <20190809013403.GY7777@dread.disaster.area>
 <alpine.LRH.2.02.1908090725290.31061@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1908090725290.31061@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <msnitzer@redhat.com>, junxiao.bi@oracle.com, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, honglei.wang@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 07:30:00AM -0400, Mikulas Patocka wrote:
> 
> 
> On Fri, 9 Aug 2019, Dave Chinner wrote:
> 
> > And, FWIW, there's an argument to be made here that the underlying
> > bug is dm_bufio_shrink_scan() blocking kswapd by waiting on IO
> > completions while holding a mutex that other IO-level reclaim
> > contexts require to make progress.
> > 
> > Cheers,
> > 
> > Dave.
> 
> The IO-level reclaim contexts should use GFP_NOIO. If the dm-bufio 
> shrinker is called with GFP_NOIO, it cannot be blocked by kswapd, because:

No, you misunderstand. I'm talking about blocking kswapd being
wrong.  i.e. Blocking kswapd in shrinkers causes problems
because th ememory reclaim code does not expect kswapd to be
arbitrarily delayed by waiting on IO. We've had this problem with
the XFS inode cache shrinker for years, and there are many reports
of extremely long reclaim latencies for both direct and kswapd
reclaim that result from kswapd not making progress while waiting
in shrinkers for IO to complete.

The work I'm currently doing to fix this XFS problem can be found
here:

https://lore.kernel.org/linux-fsdevel/20190801021752.4986-1-david@fromorbit.com/


i.e. the point I'm making is that waiting for IO in kswapd reclaim
context is considered harmful - kswapd context shrinker reclaim
should be as non-blocking as possible, and any back-off to wait for
IO to complete should be done by the high level reclaim core once
it's completed an entire reclaim scan cycle of everything....

What follows from that, and is pertinent for in this situation, is
that if you don't block kswapd, then other reclaim contexts are not
going to get stuck waiting for it regardless of the reclaim context
they use.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
