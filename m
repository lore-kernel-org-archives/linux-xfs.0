Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:14:09 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8DsSY005352
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:13:54 -0700
Message-ID: <48D9F718.4010905@sgi.com>
Date: Wed, 24 Sep 2008 18:15:20 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed>
In-Reply-To: <20080924074604.GK5448@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, xfs-dev@sgi.com

Dave Chinner wrote:
> No, it is not yet good. Pete cannot explain the underlying problem
> and we need to understand if this is fixing the problem or just
>
>   
No this patch does not change the timing so it does not happen, it fixes 
a problem
we don't properly understand. Using wait_event prevents the thread from 
waking up
unless the test condition is actually true. The the bug here is we are 
being woken up
with our test condition still being false.

And this patch catches that case and hence fixes the problem the 
question is
why is this happening in the first place. And yes that is an unanswered 
question.

> Only the XFS code can cause it to be woken....
Do you know this for sure?

> Wait queues are not affected by such events when they are
> configured to be uninterruptable. The sv_t:
>
> #define sv_wait(sv, pri, lock, s) \
>         _sv_wait(sv, lock, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT)
>
> Is as uninterruptible as it comes. Which means only an explicit
> wakeup will cause any waiters to wake up.
>
>   

I added some tracing to sv_broadcast to trace anyone waking up the 
thread however
the only time it was called was from the unpinning code well after the 
thread had already
been woken up.

> Assert fail the machine when a dquot with a non-zero pincount is
> woken in xfs_qm_dqunpin_wait(). If the assert trips, then we need
> to work out how the pin count is getting elevated while we have
> a waiter....
Done that, and it trips however it does not help us as there is no 
insight into
who woke us.


XFS does have references to wake_up in other spots for example in 
xfs_super.c and xfs_buf.c
so I could add some tracing there, however the most ideal spot is in 
__wake_up_common()
so as soon as I have a chance I'll add some tracing there so we can work 
out what's going on here.


Either way this patch resolves this issue and is a nice code cleanup.

Thanks,
Pete
