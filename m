Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 18:01:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8P11ntK002134
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 18:01:49 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 636689779A4
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 18:03:23 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id AJ0AbAJbAq5tEz4r for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 18:03:23 -0700 (PDT)
Date: Thu, 25 Sep 2008 11:03:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080925010318.GB27997@disturbed>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D9F718.4010905@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Peter Leckie <pleckie@sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

[ Pete, please wrap your text at 68-72 columns. ]

On Wed, Sep 24, 2008 at 06:15:20PM +1000, Peter Leckie wrote:
> Dave Chinner wrote:
>> No, it is not yet good. Pete cannot explain the underlying problem
>> and we need to understand if this is fixing the problem or just
>>
>>   
> No this patch does not change the timing so it does not happen, it fixes  
> a problem
> we don't properly understand.

Therein lies my objection - you can't fix what you don't understand.
What you are proposing is a work-around. The root cause has not yet
been found....

A recent example, perhaps. We discovered that the way semaphores are
implemented on x86_64 can result in a thread calling up() still
using the semaphore when the waiting down() has already been woken
and hence can free the semaphore while we are still using it. The
first patch I saw fixed the symptom seen in the buffer cache by
adding an extra reference to the xfs_buf_t across I/O so that
the up() in I/O completion was guaranteed to complete before we
dropped the reference and freed the xfs_buf_t.

However, looking at it more deeply lead us to the fundamental problem
that semaphores are optimised in an non-obvious way that lead to
this problem (i.e. that down() can complete before up()). The result
of understanding this is that semaphores were not safe for use
within XFS for flush locks, I/O completion semaphores, etc, so we
had to replace them all with completions.

This is a similar situation - if the sv_t is broken, we need to
replace all users, not just work around one symptom of the
brokenness. This is expecially important as the remaining users
of sv_t's are in the log for iclog synchronisation....

>> Only the XFS code can cause it to be woken....
> Do you know this for sure?

Yes! wake_up() can only wake tasks on that wait queue's task list.
Each different wait queue has it's own task list....

> I added some tracing to sv_broadcast to trace anyone waking up the  
> thread however
> the only time it was called was from the unpinning code well after the  
> thread had already
> been woken up.

So did the unpin wait even sleep? i.e. did the unpin waiter
receive a wakeup to get into the state it was in or did it just pass
straight through the wait code?

>> Assert fail the machine when a dquot with a non-zero pincount is
>> woken in xfs_qm_dqunpin_wait(). If the assert trips, then we need
>> to work out how the pin count is getting elevated while we have
>> a waiter....
> Done that, and it trips however it does not help us as there is no  
> insight into
> who woke us.

Ok - so what was the pin count value before it went to sleep?
i.e. Did it change at all across the sleep?

> Either way this patch resolves this issue and is a nice code cleanup.

Still, don't check it in until we understand whether sv_t's are
completely broken or not...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
