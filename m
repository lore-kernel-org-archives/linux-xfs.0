Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459A1296BCB;
	Tue, 14 Apr 2026 02:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776133403; cv=none; b=ohesYXuMbO/109GS3uVeJmdLn5OFmyAwn+GSntZE1mCVwlnSRQ6CcO886blhR81mzwfBWnro7+vVK9CpYvCLQZvmOg2bKnhUap9A/bmpY0g+wUfMhbJvLemWr2A/JYsgcDl9HcjwHe1GHqVclzNKcWj/DgDHgwvgfRN7miMD818=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776133403; c=relaxed/simple;
	bh=8JFQO1UOjzQs4UukxhVltbj6zV7FF5UO9BfAAoV6JHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pZ8zMKi+bYCPh+VZY3GAg/p/HzbEsFbj9SiDfweEXApG/nIGQWQu/+dm4QtvUFqVMSRX2pb6WuqGSi/wB1asdvI6yA8Ul68d/JR+xETEeY7M5buqyWigU3DPs6ejia8nXZ1/pzMBX8ZmMUspJzq9mKzkHuMGja+keGMKlTa3qZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=huHC6bO2; arc=none smtp.client-ip=115.124.30.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="huHC6bO2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776133396; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=N5c08oqpW8xInrDeySZRyRa+d0wZsG8dfZpf7bL6oRM=;
	b=huHC6bO2k9CGeeYB/gfWatfo7N5avmnQ/f02Id5Q5ufjnHtjeRHUavmPRT04xajfhmYgcM2JJNtBNpZEs59lHwsLXMKyx6YeVvXD8F4rWhvVXa5SJiIbaBfnW8d1q/3TMw6UzMEMcNNs7E4p94STdWyohgg8o/oi4R+Bniqiixk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X1.p49D_1776133393;
Received: from 30.221.131.198(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1.p49D_1776133393 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Apr 2026 10:23:14 +0800
Message-ID: <a7a74185-df02-4906-a0ec-f87e2394aa5f@linux.alibaba.com>
Date: Tue, 14 Apr 2026 10:23:13 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/8] RFC: use a TASK_FIFO kthread for read completion
 support
To: Dave Chinner <dgc@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Tal Zussman <tz2294@columbia.edu>,
 Jens Axboe <axboe@kernel.dk>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Christian Brauner <brauner@kernel.org>,
 "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Sandeep Dhavale <dhavale@google.com>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-9-hch@lst.de> <adl1iqhldFvJwSw-@dread>
 <7f0d072b-97a7-405f-bff5-d3819de2e3dd@linux.alibaba.com>
 <ad2RKNo2FGhpzJQp@dread>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <ad2RKNo2FGhpzJQp@dread>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/4/14 08:58, Dave Chinner wrote:
> On Sat, Apr 11, 2026 at 07:44:43AM +0800, Gao Xiang wrote:
>>
>>
>> On 2026/4/11 06:11, Dave Chinner wrote:
>>> On Thu, Apr 09, 2026 at 06:02:21PM +0200, Christoph Hellwig wrote:
>>>> Commit 3fffb589b9a6 ("erofs: add per-cpu threads for decompression as an
>>>> option") explains why workqueue aren't great for low-latency completion
>>>> handling.  Switch to a per-cpu kthread to handle it instead.  This code
>>>> is based on the erofs code in the above commit, but further simplified
>>>> by directly using a kthread instead of a kthread_work.
>>>>
>>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>
>>> Can we please not go back to the (bad) old days of individual
>>> subsystems needing their own set of per-cpu kernel tasks just
>>> sitting around idle most of of the time?  The whole point of the
>>> workqueue infrastructure was to get rid of this widely repeated
>>> anti-pattern.
>>>
>>> If there's a latency problem with workqueue scheduling, then we
>>> should be fixing that problem rather than working around it in every
>>> subsystem that thinkgs it has a workqueue scheduling latency
>>> issue...
>>
>> It has been "fixed" but never actually get fixed:
>> https://lore.kernel.org/r/CAB=BE-QaNBn1cVK6c7LM2cLpH_Ck_9SYw-YDYEnNrtwfoyu81Q@mail.gmail.com
>>
>> and workqueues don't have any plan to introduce RT threads;
> 
> They don't need to (or should) introduce RT threads. Per-cpu kernel
> threads already get priority over normal user tasks on scheduling
> decisions.  However, they do not pre-empt running kernel tasks of
> the same priority.
> 
> In general, kernel threads should not use RT scheduling at all - if
> the kernel uses RT prioprity tasks then that can interfere with user
> scheduled RT tasks. This is especially true in this case where a
> non-RT tasks issue the IO, and the IO completion is then scheduled
> with RT priority. IOWs, any unprivileged user can now impact the
> processing time available to, and the response latency of, other
> RT scheduled tasks the system is running.

All softirq IO completion already works like this although
softirq tasks are not strictly called "RT tasks" (i.e. a non-RT
task issues the IO, and the softirq IO completion will interrupt
all ongoing tasks).

Basically what we want is to get a non-atomic context instead of
using the current softirq context for read post-processing and
switch to the task context immediately as you said, because:

  - Our post-processing needs to work in task contexts since
    advanced features like compression deduplication need it;

  - Even regardless of our specific requirement needing task
    contexts, using a dedicated task context for read
    post-processing is much better than run in the original
    softirq context:

    - Algorithmic work could take extra time (especially slow
      LZMA algorithm could take milliseconds on low devices
      (however, we need a common workflow for all algorithms,
      including fast algorithms like lz4) and verify work for
      example); and long processing time will interfere with
      other remaining softirq tasks like sound-playback
      / network softirqs;

    - If it is then deferred to softirqd, it just makes this
      latency issue _worse_.


Thus, if there is another dedicated mechanism which can provide
a lightweight task context and is scheduled to run immediately
after the softirq: that would fit our requirement and I believe
it's useful for other various use cases, but currently there is
no such clean infra; RT threads can just fulfill our requirement
in a less elegant way.

> 
> Tejun asked Sandeep if setting the workqueue thread priority to
> -19 through sysfs (i.e. making them higher priority than normal
> kernel threads) had the same effect on latency as using a dedicated
> per-cpu RT task thread. THere was no followup.

I think the issue is that people are not already working on the
same topic:

  - Unlike large subsystems like XFS, people don't already work on
    EROFS unless they have new requirements or urgent production
    issues;

  - The original latency issue was already considered as "done" in
    2023, and I'm not sure if Sandeep could have the bandwidth to
    pause his current work and test more setups according to this
    ongoing discussion in 2026.

> 
> In theory, this should provide the same benefit, because what RT
> scheduling is doing is pre-empting any user and kernel task that was
> running when the interrupt was delivered to execute the completion
> task immediately.

But anyway, I think nice -19 can be evaluated if Sandeep have time,
but such nice value should be set by the filesystem instead of
the userspace since the reason is as above.

Additionally, we also need a way to set nice if we decide to switch
to the new BIO_COMPLETE_IN_TASK approach as well if the nice way
really works.

> 
> Setting the workqueue to use kernel threads of a higher scheduler
> prioirty should do the same thing, without the need to use dedicated
> per-cpu RT threads.
> 
>> If Sandeep has more time, I hope he could have more time to
>> test since I don't work on Android anymore: In principle,
>> I still think RT thread is needed somewhere for such usage
>> since lowest latencies is needed.
> 
> All that is needed is for the kworker thread to be scheduled to run
> immeidately after the interrupt that scheduled the work exits. This
> does not require dedicated per-cpu kernel tasks or RT scheduling....

Right and not sure, it needs some latency evaluation with
heavy background/foreground app pressures.

> 
>> Compared to the scheduling latency issues, interested users
>> don't care "individual subsystems needing their own set of
>> per-cpu kernel tasks just sitting around idle most of of
>> the time". If end users care it more, they can just turn
>> it off by Kconfig.
> 
> Distros enable all these subsystems all the time, so saying
> "turn it off via kconfig" is not a viable mitigation
> strategy. Proliferation of dedicated per-CPU worker task pools is a
> known problem, and we really don't want to regress back to those
> days when a typical system had thousands of dedicated per-cpu work
> queues that largely did nothing most of the time.

That kconfig is off by default, but all Android vendors
turn it on, and that latency issue is particularly vital
for Android ecosystem.

Currently RT threads won't be used for other use cases even
desktop use cases: Android workloads are pretty harsh
even compared to desktops for example.

Thanks,
Gao Xiang

> 
> -Dave.
> 

