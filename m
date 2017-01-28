Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:16958 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751846AbdA1Wsu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 28 Jan 2017 17:48:50 -0500
Date: Sun, 29 Jan 2017 09:42:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Quota-enabled XFS hangs during mount
Message-ID: <20170128224242.GD316@dastard>
References: <7993e9b8-6eb8-6a0d-aa72-01346cca1b63@zoner.cz>
 <20161103204049.GA28177@dastard>
 <43ca55d0-6762-d54f-5ba9-a83f9c1988f6@zoner.cz>
 <20170123134452.GA33287@bfoster.bfoster>
 <5b41d19b-1a0d-2b74-a633-30a5f6d2f14a@zoner.cz>
 <20170125221739.GA33995@bfoster.bfoster>
 <30d56003-a517-f6f0-d188-d0ada5a9fbb7@zoner.cz>
 <20170126191254.GB39683@bfoster.bfoster>
 <27c2f5aa-517d-22b5-b55f-f0ceb277e9a3@zoner.cz>
 <20170127170734.GA49571@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170127170734.GA49571@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Martin Svec <martin.svec@zoner.cz>, linux-xfs@vger.kernel.org

On Fri, Jan 27, 2017 at 12:07:34PM -0500, Brian Foster wrote:
> The problem looks like a race between dquot reclaim and quotacheck. The
> high level sequence of events is as follows:
> 
>  - During quotacheck, xfs_qm_dqiterate() walks the physical dquot
>    buffers and queues them to the delwri queue.
>  - Next, kswapd kicks in and attempts to reclaim a dquot that is backed
>    by a buffer on the quotacheck delwri queue. xfs_qm_dquot_isolate()
>    acquires the flush lock and attempts to queue to the reclaim delwri
>    queue. This silently fails because the buffer is already queued.
> 
>    From this point forward, the dquot flush lock is not going to be
>    released until the buffer is submitted for I/O and completed via
>    quotacheck.
>  - Quotacheck continues on to the xfs_qm_flush_one() pass, hits the
>    dquot in question and waits on the flush lock to issue the flush of
>    the recalculated values. *deadlock*
> 
> There are at least a few ways to deal with this. We could do something
> granular to fix up the reclaim path to check whether the buffer is
> already queued or something of that nature before we actually invoke the
> flush. I think this is effectively pointless, however, because the first
> part of quotacheck walks and queues all physical dquot buffers anyways.
> 
> In other words, I think dquot reclaim during quotacheck should probably
> be bypassed.
....

> Note that I think this does mean that you could still have low memory
> issues if you happen to have a lot of quotas defined..

Hmmm..... Really needs fixing.

I think submitting the buffer list after xfs_qm_dqiterate() and
waiting for completion will avoid this problem.

However, I suspect reclaim can still race with flushing, so we need
to detect "stuck" dquots, submit the delwri buffer queue and wait,
then flush the dquot again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
