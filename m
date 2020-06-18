Return-Path: <SRS0=OEwr=77=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4971BC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 01:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2416922260
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Jun 2020 01:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N7fBjlHZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731735AbgFRBex (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 17 Jun 2020 21:34:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40792 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732423AbgFRBdK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Jun 2020 21:33:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592443988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TIDGi3sXPt+fhjCjxVVlP5Ysnp3g6oAAR1w/q4/ns0Q=;
        b=N7fBjlHZewQDxMzVJo5Z8NXdInXVPEKzfFAaAJQN3NqwHQHIAL/fVZNM6v901q4dEoshr1
        Jkhqfn+EzKynATQU8O6tprL/T/X10mfgL+MMquSl6JCC7m9hqOGLk/reoki0UFa2+yhpBl
        I11rvnmcapDBeVhpJXkz6xFTR3CIXzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-qpFtEkRSOOWEy4mHP7dN4A-1; Wed, 17 Jun 2020 21:33:06 -0400
X-MC-Unique: qpFtEkRSOOWEy4mHP7dN4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 076568005AD;
        Thu, 18 Jun 2020 01:33:05 +0000 (UTC)
Received: from llong.remote.csb (ovpn-117-167.rdu2.redhat.com [10.10.117.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B2E160F89;
        Thu, 18 Jun 2020 01:32:58 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] sched: Add PF_MEMALLOC_NOLOCKDEP flag
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Eric Sandeen <sandeen@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20200617175310.20912-1-longman@redhat.com>
 <20200617175310.20912-2-longman@redhat.com>
 <20200618000110.GF2005@dread.disaster.area>
From:   Waiman Long <longman@redhat.com>
Organization: Red Hat
Message-ID: <7371c5dc-7ba7-6d86-75ca-43bedfa6b24f@redhat.com>
Date:   Wed, 17 Jun 2020 21:32:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200618000110.GF2005@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/17/20 8:01 PM, Dave Chinner wrote:
> On Wed, Jun 17, 2020 at 01:53:09PM -0400, Waiman Long wrote:
>> There are cases where calling kmalloc() can lead to false positive
>> lockdep splat. One notable example that can happen in the freezing of
>> the xfs filesystem is as follows:
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(sb_internal);
>>                                 lock(fs_reclaim);
>>                                 lock(sb_internal);
>>    lock(fs_reclaim);
>>
>>   *** DEADLOCK ***
>>
>> This is a false positive as all the dirty pages are flushed out before
>> the filesystem can be frozen. However, there is no easy way to modify
>> lockdep to handle this situation properly.
>>
>> One possible workaround is to disable lockdep by setting __GFP_NOLOCKDEP
>> in the appropriate kmalloc() calls.  However, it will be cumbersome to
>> locate all the right kmalloc() calls to insert __GFP_NOLOCKDEP and it
>> is easy to miss some especially when the code is updated in the future.
>>
>> Another alternative is to have a per-process global state that indicates
>> the equivalent of __GFP_NOLOCKDEP without the need to set the gfp_t flag
>> individually. To allow the latter case, a new PF_MEMALLOC_NOLOCKDEP
>> per-process flag is now added. After adding this new bit, there are
>> still 2 free bits left.
>>
>> Suggested-by: Dave Chinner <david@fromorbit.com>
>> Signed-off-by: Waiman Long <longman@redhat.com>
>> ---
>>   include/linux/sched.h    |  7 +++++++
>>   include/linux/sched/mm.h | 15 ++++++++++-----
>>   2 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index b62e6aaf28f0..44247cbc9073 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1508,6 +1508,7 @@ extern struct pid *cad_pid;
>>   #define PF_MEMALLOC_NOIO	0x00080000	/* All allocation requests will inherit GFP_NOIO */
>>   #define PF_LOCAL_THROTTLE	0x00100000	/* Throttle writes only against the bdi I write to,
>>   						 * I am cleaning dirty pages from some other bdi. */
>> +#define __PF_MEMALLOC_NOLOCKDEP	0x00100000	/* All allocation requests will inherit __GFP_NOLOCKDEP */
> Why is this considered a safe thing to do? Any context that sets
> __PF_MEMALLOC_NOLOCKDEP will now behave differently in memory
> reclaim as it will think that PF_LOCAL_THROTTLE is set when lockdep
> is enabled.

Oh, my mistake, it should be 0x01000000 which is not currently being 
used. Thank for catching that. I will repost a new version. I have no 
intention to reuse any existing bit. As said in the commit log, there 
are actually 2 more free bits left.


>
>>   #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
>>   #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
>>   #define PF_SWAPWRITE		0x00800000	/* Allowed to write to swap */
>> @@ -1519,6 +1520,12 @@ extern struct pid *cad_pid;
>>   #define PF_FREEZER_SKIP		0x40000000	/* Freezer should not count it as freezable */
>>   #define PF_SUSPEND_TASK		0x80000000      /* This thread called freeze_processes() and should not be frozen */
>>   
>> +#ifdef CONFIG_LOCKDEP
>> +#define PF_MEMALLOC_NOLOCKDEP	__PF_MEMALLOC_NOLOCKDEP
>> +#else
>> +#define PF_MEMALLOC_NOLOCKDEP	0
>> +#endif
>> +
>>   /*
>>    * Only the _current_ task can read/write to tsk->flags, but other
>>    * tasks can access tsk->flags in readonly mode for example
>> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
>> index 480a4d1b7dd8..4a076a148568 100644
>> --- a/include/linux/sched/mm.h
>> +++ b/include/linux/sched/mm.h
>> @@ -177,22 +177,27 @@ static inline bool in_vfork(struct task_struct *tsk)
>>    * Applies per-task gfp context to the given allocation flags.
>>    * PF_MEMALLOC_NOIO implies GFP_NOIO
>>    * PF_MEMALLOC_NOFS implies GFP_NOFS
>> + * PF_MEMALLOC_NOLOCKDEP implies __GFP_NOLOCKDEP
>>    * PF_MEMALLOC_NOCMA implies no allocation from CMA region.
>>    */
>>   static inline gfp_t current_gfp_context(gfp_t flags)
>>   {
>> -	if (unlikely(current->flags &
>> -		     (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS | PF_MEMALLOC_NOCMA))) {
>> +	unsigned int pflags = current->flags;
>> +
>> +	if (unlikely(pflags & (PF_MEMALLOC_NOIO | PF_MEMALLOC_NOFS |
>> +			       PF_MEMALLOC_NOCMA | PF_MEMALLOC_NOLOCKDEP))) {
> That needs a PF_MEMALLOC_MASK.

Will add that in the next version.

Thanks,
Longman

