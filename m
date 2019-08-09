Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406588AbfHILaE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Aug 2019 07:30:04 -0400
Date: Fri, 9 Aug 2019 07:30:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] direct-io: use GFP_NOIO to avoid deadlock
In-Reply-To: <20190809013403.GY7777@dread.disaster.area>
Message-ID: <alpine.LRH.2.02.1908090725290.31061@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1908080540240.15519@file01.intranet.prod.int.rdu2.redhat.com> <20190809013403.GY7777@dread.disaster.area>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, "Darrick J. Wong" <darrick.wong@oracle.com>, Mike Snitzer <msnitzer@redhat.com>, junxiao.bi@oracle.com, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, honglei.wang@oracle.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org



On Fri, 9 Aug 2019, Dave Chinner wrote:

> And, FWIW, there's an argument to be made here that the underlying
> bug is dm_bufio_shrink_scan() blocking kswapd by waiting on IO
> completions while holding a mutex that other IO-level reclaim
> contexts require to make progress.
> 
> Cheers,
> 
> Dave.

The IO-level reclaim contexts should use GFP_NOIO. If the dm-bufio 
shrinker is called with GFP_NOIO, it cannot be blocked by kswapd, because:
* it uses trylock to acquire the mutex
* it doesn't attempt to free buffers that are dirty or under I/O (see 
  __try_evict_buffer)

I think that this logic is sufficient to prevent the deadlock.

Mikulas
