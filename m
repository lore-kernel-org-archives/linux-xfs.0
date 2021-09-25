Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66700C433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 23:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278736108C
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Sep 2021 23:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbhIYXUf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Sep 2021 19:20:35 -0400
Received: from sandeen.net ([63.231.237.45]:58358 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230127AbhIYXUf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 25 Sep 2021 19:20:35 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 0F1DF477537;
        Sat, 25 Sep 2021 18:18:29 -0500 (CDT)
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        djwong@kernel.org
References: <20210924140912.201481-1-chandan.babu@oracle.com>
 <20210924140912.201481-4-chandan.babu@oracle.com>
 <80546d48-9018-e374-2a0b-caf84e521ebd@sandeen.net>
 <20210925231500.GZ1756565@dread.disaster.area>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: [PATCH V2 3/5] atomic: convert to uatomic
Message-ID: <058f370e-8973-3049-c168-904cad17d090@sandeen.net>
Date:   Sat, 25 Sep 2021 18:18:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210925231500.GZ1756565@dread.disaster.area>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 9/25/21 6:15 PM, Dave Chinner wrote:
> On Fri, Sep 24, 2021 at 05:13:30PM -0500, Eric Sandeen wrote:
>> On 9/24/21 9:09 AM, Chandan Babu R wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Now we have liburcu, we can make use of it's atomic variable
>>> implementation. It is almost identical to the kernel API - it's just
>>> got a "uatomic" prefix. liburcu also provides all the same aomtic
>>> variable memory barriers as the kernel, so if we pull memory barrier
>>> dependent kernel code across, it will just work with the right
>>> barrier wrappers.
>>>
>>> This is preparation the addition of more extensive atomic operations
>>> the that kernel buffer cache requires to function correctly.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
>>> [chandan.babu@oracle.com: Swap order of arguments provided to atomic[64]_[add|sub]()]
>>> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
>>> ---
>>>    include/atomic.h | 65 ++++++++++++++++++++++++++++++++++++++++--------
>>>    1 file changed, 54 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/atomic.h b/include/atomic.h
>>> index e0e1ba84..99cb85d3 100644
>>> --- a/include/atomic.h
>>> +++ b/include/atomic.h
>>> @@ -7,21 +7,64 @@
>>>    #define __ATOMIC_H__
>>>    /*
>>> - * Warning: These are not really atomic at all. They are wrappers around the
>>> - * kernel atomic variable interface. If we do need these variables to be atomic
>>> - * (due to multithreading of the code that uses them) we need to add some
>>> - * pthreads magic here.
>>> + * Atomics are provided by liburcu.
>>> + *
>>> + * API and guidelines for which operations provide memory barriers is here:
>>> + *
>>> + * https://github.com/urcu/userspace-rcu/blob/master/doc/uatomic-api.md
>>> + *
>>> + * Unlike the kernel, the same interface supports 32 and 64 bit atomic integers.
>>
>> Given this, anyone have any objection to putting the #defines together at the
>> top, rather than hiding the 64 variants at the end of the file?
> 
> I wanted to keep the -APIs- separate, because all the kernel
> atomic/atomic64 stuff is already separate and type checked. I don't
> see any point in commingling the two different atomic type APIs
> just because the implementation ends up being the same and that some
> wrappers are defines and others are static inline code.
> 
> Ideally, the wrappers should all be static inlines so we get correct
> atomic_t/atomic64_t type checking in userspace. Those are the types
> we care about in terms of libxfs, so to typecheck the API properly
> these should -all- be static inlines. The patch as it stands was a
> "get it working properly" patch, not a "finalised, strictly correct
> API" patch. That was somethign for "down the road" as I polished the
> patchset ready for eventual review.....

Ok. Well, I was only talking about moving lines in your patch, nothing functional
at all. And ... that's why I had asked earlier (I think?) if your patch was
considered ready for review/merge, or just a demonstration of things to come.

So I guess changing it to a static inline as you suggest should be done before
merge.  Anything else like that that you don't actually consider quite ready,
in the first 3 patches?

Thanks,
-Eric
