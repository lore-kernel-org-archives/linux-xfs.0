Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 00:42:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O7fvqm000545
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:41:57 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 44C03965369
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:43:31 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id ZkMIeKuQnlFcxTbN for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 00:43:31 -0700 (PDT)
Date: Wed, 24 Sep 2008 17:43:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080924074317.GJ5448@disturbed>
References: <48D9C1DD.6030607@sgi.com> <20080924060508.GH5448@disturbed> <48D9E3E2.3040504@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9E3E2.3040504@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

On Wed, Sep 24, 2008 at 04:53:22PM +1000, Peter Leckie wrote:
> Dave Chinner wrote:
>> [ Pete, please wrap your text at 68-72 columns]
>>   
> Ok will do in future
>> On Wed, Sep 24, 2008 at 02:28:13PM +1000, Peter Leckie wrote:
>>   
>>> The reason the lsn had changed was due to it not being initialized
>>> by  the time a copy of the lsn was taken in xfs_qm_dqflush().
>>> The lsn was then latter updated causing the test  in
>>> xfs_qm_dqflush_done() to fail.
>>>
>>> Synchronizations between the 2 functions is done by the pincount
>>> in  struct xfs_dquot_t  and xfs_qm_dqflush() calls
>>> xfs_qm_dqunpin_wait() to wait for the pincount == 0. However after
>>> been woken up it does not validate the pincount is actually 0,
>>>     
>>
>> Sure - that's because we only ever send a wakeup when the pin count
>> falls to zero. Because we have to be holding the dquot lock when we
>> either pin a dquot or wait for it to be unpinned, the act of waiting
>> for it to be unpinned with the dquot lock held guarantees that it
>> is not pinned when we wake up.
>>
>> IOWs, the pin count cannot be incremented while we are waiting for
>> it to be unpinned, and hence it must be zero when we are woken......
>>
>>   
>>> allowing a false wake up by the scheduler to  cause
>>> xfs_qm_dqflush() to prematurely start processing the dquot.
>>>     
>>
>> .... which means I can't see how that would happen...
>>
>> What am I missing here?
>>   
> Yeah it's quite intriguing  isn't it, I added the pincount to the
> dquot tracing code and sure enough it's 1 all the way through
> xfs_qm_dqflush() I can tell you that none of the XFS code is
> causing it to wake up.

Only the XFS code can cause it to be woken....

> I was going to add some tracing code to
> the scheduler to determine who is causing us to wake up however
> I had other priorities to work on.
>
> Reading the code it appears things like a threads dying or a
> system suspending can cause it.

Wait queues are not affected by such events when they are
configured to be uninterruptable. The sv_t:

#define sv_wait(sv, pri, lock, s) \
        _sv_wait(sv, lock, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)

Is as uninterruptible as it comes. Which means only an explicit
wakeup will cause any waiters to wake up.

> However none of these had
> happened, after reading other examples in the Linux kernel
> it appeared pretty standard to always re-evaluate the condition
> after being woken so I suspect that Linux simply does not
> guarantee that we will only be woken by the thread calling
> wake_up on  us.

Not true - wake_up() will only wake tasks on the wait queue
it was called for.

> Any insight into this would be much appreciated as I'm also very curious
> as to why this is happening.

Assert fail the machine when a dquot with a non-zero pincount is
woken in xfs_qm_dqunpin_wait(). If the assert trips, then we need
to work out how the pin count is getting elevated while we have
a waiter....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
