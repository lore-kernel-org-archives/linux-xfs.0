Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 20:28:16 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q3SCoX001115
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 20:28:13 -0700
Message-ID: <48DC5945.9060506@sgi.com>
Date: Fri, 26 Sep 2008 13:38:45 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed> <48DC3BBB.4080807@sgi.com> <20080926025718.GJ27997@disturbed>
In-Reply-To: <20080926025718.GJ27997@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

Dave Chinner wrote:
> On Fri, Sep 26, 2008 at 11:32:43AM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Thu, Sep 25, 2008 at 06:43:43PM +1000, Peter Leckie wrote:
>>>> However xfssyncd has had a long history of the task being woken up 
>>>> from  other code,
>>>> so it looks like it's simply not safe for either the aild or xfssyncd 
>>>> to  sleep on a queue assuming that
>>>> no one else will wake the processes up.
>>> Given that both xfsaild and xfssyncd are supposed to be doing
>>> non-blocking flushes, neither of them should ever be waiting on a
>>> pinned item, therefore fixing that problem in xfs_qm_dqflush()
>>> should make this problem go away. It will also substantially
>>> reduce tehnumber of log forces being triggered by dquot writeback
>>> which will have positive impact on performance, too.
>>>
>>>> So I would say the fix I proposed is a good solution for this issue.
>>> but it doesn't fix the underlying problem that was causing the
>>> spurious wakeups, which is the fact that xfs_qm_dqflush() is not
>>> obeying non-blocking flush directions.
>> The underlying problem has nothing to do with xfs_qm_dqflush() - the
>> spurious wakeups are caused by calls to wake_up_process() that arbitrarily
>> wake up a process that is in a state where it shouldn't be woken up.
> 
> Spurious wakeups are causing problems in a place where we should not 
> even be sleeping. If you don't sleep there, you can't get spurious
> wakeups....
> 
>> If we don't fix the spurious wakeups then we could easily re-introduce this
>> problem again.
> 
> Right, but keep in mind that the patch doesn't prevent spurious
> wakeups - it merely causes the thread to wakeup and go back to sleep
Yes that's right and it's why I suggested replacing the uses of wake_up_process
with wake_up and a wait queue where both the xfsaild and xfssyncd threads can
have a wait queue specific to them.  This way we only wake them up if they are
sleeping on that wait queue and not somewhere else waiting for a different event.
I'm pretty sure that will be a safe change to make.

> when a spurious wakeup occurs. The patch I posted avoids the
> spurious wakeup problem completely, which is what we should be
> aiming to do given it avoids the overhead of 2 context switches
> and speeds up the rate at which we can flush unpinned dquots.
> 
> That being said, I agree that the original patch is still desirable,
> though not from a bug-fix perspective. It's a cleanup and
> optimisation patch, with the nice side effect of preventing future
> occurrences of the spurious wakeup problem....
> 
> Cheers,
> 
> Dave.
