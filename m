Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53455 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726650AbfEGVWT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 17:22:19 -0400
Date: Wed, 8 May 2019 07:22:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
Message-ID: <20190507212213.GO29573@dread.disaster.area>
References: <20190507130528.1d3d471b@imladris.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507130528.1d3d471b@imladris.surriel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Rik van Riel <riel@surriel.com>
Cc: linux-xfs@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <dchinner@redhat.com>

On Tue, May 07, 2019 at 01:05:28PM -0400, Rik van Riel wrote:
> The code in xlog_wait uses the spinlock to make adding the task to
> the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
> with respect to the waker.
> 
> Doing the wakeup after releasing the spinlock opens up the following
> race condition:
> 
> - add task to wait queue
> 
> -                                      wake up task
> 
> - set task state to UNINTERRUPTIBLE
> 
> Simply moving the spin_unlock to after the wake_up_all results
> in the waker not being able to see a task on the waitqueue before
> it has set its state to UNINTERRUPTIBLE.

Yup, seems like an issue. Good find, Rik.

So, what problem is this actually fixing? Was it noticed by
inspection, or is it actually manifesting on production machines?
If it is manifesting IRL, what are the symptoms (e.g. hang running
out of log space?) and do you have a test case or any way to
exercise it easily?

And, FWIW, did you check all the other xlog_wait() users for the
same problem?

> The lock ordering of taking the waitqueue lock inside the l_icloglock
> is already used inside xlog_wait; it is unclear why the waker was doing
> things differently.

Historical, most likely, and the wakeup code has changed in years
gone by and a race condition that rarely manifests is unlikely to be
noticed.

....

Yeah, the conversion from counting semaphore outside the iclog lock
to use wait queues in 2008 introduced this bug. The wait queue
addition was moved inside the lock, the wakeup left outside. So:

Fixes: d748c62367eb ("[XFS] Convert l_flushsema to a sv_t")

Apart from the commit message, the change looks fine.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
