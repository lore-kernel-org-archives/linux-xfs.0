Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37057 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727150AbfHMQfx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Aug 2019 12:35:53 -0400
Date: Tue, 13 Aug 2019 12:35:49 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] direct-io: use GFP_NOIO to avoid deadlock
In-Reply-To: <20190809215733.GZ7777@dread.disaster.area>
Message-ID: <alpine.LRH.2.02.1908131231010.6852@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com> <20190809013403.GY7777@dread.disaster.area> <alpine.LRH.2.02.1908090725290.31061@file01.intranet.prod.int.rdu2.redhat.com>
 <20190809215733.GZ7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <msnitzer@redhat.com>, junxiao.bi@oracle.com, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, honglei.wang@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org



On Sat, 10 Aug 2019, Dave Chinner wrote:

> No, you misunderstand. I'm talking about blocking kswapd being
> wrong.  i.e. Blocking kswapd in shrinkers causes problems
> because th ememory reclaim code does not expect kswapd to be
> arbitrarily delayed by waiting on IO. We've had this problem with
> the XFS inode cache shrinker for years, and there are many reports
> of extremely long reclaim latencies for both direct and kswapd
> reclaim that result from kswapd not making progress while waiting
> in shrinkers for IO to complete.
> 
> The work I'm currently doing to fix this XFS problem can be found
> here:
> 
> https://lore.kernel.org/linux-fsdevel/20190801021752.4986-1-david@fromorbit.com/
> 
> 
> i.e. the point I'm making is that waiting for IO in kswapd reclaim
> context is considered harmful - kswapd context shrinker reclaim
> should be as non-blocking as possible, and any back-off to wait for
> IO to complete should be done by the high level reclaim core once
> it's completed an entire reclaim scan cycle of everything....
> 
> What follows from that, and is pertinent for in this situation, is
> that if you don't block kswapd, then other reclaim contexts are not
> going to get stuck waiting for it regardless of the reclaim context
> they use.
> 
> Cheers,
> 
> Dave.

So, what do you think the dm-bufio shrinker should do?

Currently it tries to free buffers on the clean list and if there are not 
enough buffers on the clean list, it goes into the dirty list - it writes 
the buffers back and then frees them.

What should it do? Should it just start writeback of the dirty list 
without waiting for it? What should it do if all the buffers are under 
writeback?

Mikulas
