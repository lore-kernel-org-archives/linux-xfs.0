Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f46.google.com ([209.85.221.46]:46333 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbeJURN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Oct 2018 13:13:56 -0400
Received: by mail-wr1-f46.google.com with SMTP id i4-v6so2893093wrr.13
        for <linux-xfs@vger.kernel.org>; Sun, 21 Oct 2018 02:00:19 -0700 (PDT)
Subject: Re: ENSOPC on a 10% used disk
References: <40c52a7b-2520-8ae4-11d5-ae4b33e1dc29@scylladb.com>
 <20181018013727.GE6311@dastard>
 <39c3af2d-d591-c6bc-d586-245f1ca69a71@scylladb.com>
 <20181018100504.GH6311@dastard>
 <87bf239a-29c2-6db5-6781-42743c9c7d5d@scylladb.com>
 <5516031c-6c4f-072f-e9f9-9f0ecee9927d@scylladb.com>
 <20181019012423.GK6311@dastard>
From: Avi Kivity <avi@scylladb.com>
Message-ID: <0fcfc274-fbb1-5a3e-6335-6993d616df97@scylladb.com>
Date: Sun, 21 Oct 2018 12:00:16 +0300
MIME-Version: 1.0
In-Reply-To: <20181019012423.GK6311@dastard>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org


On 19/10/2018 04.24, Dave Chinner wrote:
> On Thu, Oct 18, 2018 at 06:44:54PM +0300, Avi Kivity wrote:
>> On 18/10/2018 14.00, Avi Kivity wrote:
>>>
>>> This can happen, and indeed I see our default hint is 1MB, so our
>>> small files use a 1MB hint. Looks like we should remove that 1MB
>>> hint since it's reducing allocation flexibility for XFS without a
>>> good return.
>>
>> I convinced myself that this is the root cause, it fits perfectly
>> with your explanation. I still think that XFS should allocate
>> *something* rather than ENOSPC, but I can also understand someone
>> wanting a guarantee.
> Yup, it's a classic catch 22.
>
>>> On the other hand, I worry that because we bypass the page cache,
>>> XFS doesn't get to see the entire file at one time and so it will
>>> get fragmented.
>>
>> That's what happens. I write 1000 4k writes to 400 files, in
>> parallel, AIO+DIO. I got 400 perfectly-fragmented files, each had
>> 1000 extents.
> Yup, you wrote them all in the one directory, didn't you? :)


Yes :(


But if I have more concurrently-written files than AGs, I'd get the same 
behavior with multiple directories, no?


>> So I'll remove the default hint for small files, and replace it with
>> larger buffer sizes so we batch more and don't get 8k-sized extents
>> (which is our default buffer size).
> Or you could just mount with the "noalign" mount option to turn off
> stripe alignment. After all, you don't need stripe alignment for a
> single spindle....


For a single spindle, sure. But most deployments have multiple spindles.


Since these aren't real spindles, the advantages of alignment are not as 
great, but they still exist. The files are written with aligned offsets, 
and some of the reads are also aligned, so it saves IOPS whenever we 
cross an alignment boundary.
