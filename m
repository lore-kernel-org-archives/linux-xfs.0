Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43728 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbeH0Aq1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 20:46:27 -0400
Subject: Re: [PATCH 2/2] xfs: Use wake_q for waking up log space waiters
From: Waiman Long <longman@redhat.com>
References: <1535041570-24102-1-git-send-email-longman@redhat.com>
 <1535041570-24102-3-git-send-email-longman@redhat.com>
 <20180824003017.GZ2234@dastard>
 <bbdaf330-ce6b-bc53-eb97-93b34359bd3d@redhat.com>
Message-ID: <36d1f3f5-9a4a-2511-4dce-c3ae30022d4a@redhat.com>
Date: Sun, 26 Aug 2018 17:02:44 -0400
MIME-Version: 1.0
In-Reply-To: <bbdaf330-ce6b-bc53-eb97-93b34359bd3d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>

On 08/24/2018 05:54 PM, Waiman Long wrote:
> On 08/23/2018 08:30 PM, Dave Chinner wrote:
>>
>> That's racy. You can't drop the spin lock between
>> xlog_grant_head_wake() and xlog_grant_head_wait(), because
>> free_bytes is only valid while while the spinlock is held.  Same for
>> the "wake_all" variable you added. i..e. while waking up the
>> waiters, we could have run out of space again and had more tasks
>> queued, or had the AIL tail move and now have space available.
>> Either way, we can do the wrong thing because we dropped the lock
>> and free_bytes and wake_all are now stale and potentially incorrect.
>>
>>> @@ -1068,6 +1088,7 @@
>>>  {
>>>  	struct xlog		*log = mp->m_log;
>>>  	int			free_bytes;
>>> +	DEFINE_WAKE_Q(wakeq);
>>>  
>>>  	if (XLOG_FORCED_SHUTDOWN(log))
>>>  		return;
>>> @@ -1077,8 +1098,11 @@
>>>  
>>>  		spin_lock(&log->l_write_head.lock);
>>>  		free_bytes = xlog_space_left(log, &log->l_write_head.grant);
>>> -		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes);
>>> +		xlog_grant_head_wake(log, &log->l_write_head, &free_bytes,
>>> +				     &wakeq);
>>>  		spin_unlock(&log->l_write_head.lock);
>>> +		wake_up_q(&wakeq);
>>> +		wake_q_init(&wakeq);
>> That's another landmine. Just define the wakeq in the context where
>> it is used rather than use a function wide variable that requires
>> reinitialisation.
>>
>>>  	}
>>>  
>>>  	if (!list_empty_careful(&log->l_reserve_head.waiters)) {
>>> @@ -1086,8 +1110,10 @@
>>>  
>>>  		spin_lock(&log->l_reserve_head.lock);
>>>  		free_bytes = xlog_space_left(log, &log->l_reserve_head.grant);
>>> -		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes);
>>> +		xlog_grant_head_wake(log, &log->l_reserve_head, &free_bytes,
>>> +				     &wakeq);
>>>  		spin_unlock(&log->l_reserve_head.lock);
>>> +		wake_up_q(&wakeq);
>>>  	}
>>>  }
>> Ok, what about xlog_grant_head_wake_all()? You didn't convert that
>> to use wake queues, and so that won't remove tickets for the grant
>> head waiter list, and so those tasks will never get out of the new
>> inner loop you added to xlog_grant_head_wait(). That means
>> filesystem shutdowns will just hang the filesystem and leave it
>> unmountable. Did you run this through fstests?
>>
>> Cheers,
>>
>> Dave
> OK, I need more time to think about some of the questions that you
> raise.  Thanks for reviewing the patch.
>
> Cheers,
> Longman

Thanks for your detailed review of the patch. I now have a better
understanding of what should and shouldn't be done. I have sent out a
more conservative v2 patchset which, hopefully, can address the concerns
that you raised.

Cheers,
Longman
