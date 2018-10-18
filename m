Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f49.google.com ([209.85.128.49]:35723 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728422AbeJSANL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 20:13:11 -0400
Received: by mail-wm1-f49.google.com with SMTP id o17-v6so167305wmh.0
        for <linux-xfs@vger.kernel.org>; Thu, 18 Oct 2018 09:11:30 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
From: Avi Kivity <avi@scylladb.com>
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <5516031c-6c4f-072f-e9f9-9f0ecee9927d@scylladb.com>
Message-ID: <2e49a425-e81c-f5ba-2ff1-6fe69fe47055@scylladb.com>
Date: Thu, 18 Oct 2018 19:11:23 +0300
MIME-Version: 1.0
In-Reply-To: <5516031c-6c4f-072f-e9f9-9f0ecee9927d@scylladb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


On 18/10/2018 18.44, Avi Kivity wrote:
>
> On 18/10/2018 14.00, Avi Kivity wrote:
>>
>>
>> This can happen, and indeed I see our default hint is 1MB, so our 
>> small files use a 1MB hint. Looks like we should remove that 1MB hint 
>> since it's reducing allocation flexibility for XFS without a good 
>> return.
>
>
> I convinced myself that this is the root cause, it fits perfectly with 
> your explanation. I still think that XFS should allocate *something* 
> rather than ENOSPC, but I can also understand someone wanting a 
> guarantee.
>

A small twist: there were in fact lots of small files on that system, 
caused by snapshots that the user did not remove. But I think the 
explanation still holds.
