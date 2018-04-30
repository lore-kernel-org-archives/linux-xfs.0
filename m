Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:50910 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753482AbeD3TVa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 15:21:30 -0400
Received: by mail-it0-f45.google.com with SMTP id p3-v6so11255327itc.0
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 12:21:30 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430171945.GB22176@bfoster.bfoster>
 <24df628d-c861-6f39-96a8-d759902d1fe3@kernel.dk>
 <20180430182525.GE27875@wotan.suse.de>
 <4cb68c8e-bf6c-b717-73f0-20e850582004@sandeen.net>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <210ebc4e-780a-1cf2-92e0-2482b98704a2@kernel.dk>
Date: Mon, 30 Apr 2018 13:21:28 -0600
MIME-Version: 1.0
In-Reply-To: <4cb68c8e-bf6c-b717-73f0-20e850582004@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 4/30/18 1:19 PM, Eric Sandeen wrote:
> 
> 
> On 4/30/18 1:25 PM, Luis R. Rodriguez wrote:
>> On Mon, Apr 30, 2018 at 12:07:31PM -0600, Jens Axboe wrote:
>>> On 4/30/18 11:19 AM, Brian Foster wrote:
>>>> On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
>>>>> XFS recently added support for async discards. While this can be
>>>>> a win for some workloads and devices, there are also cases where
>>>>> async bursty discard will severly harm the latencies of reads
>>>>> and writes.
>>>>>
>>>>> Add a 'discard_sync' mount flag to revert to using sync discard,
>>>>> issuing them one at the time and waiting for each one. This fixes
>>>>> a big performance regression we had moving to kernels that include
>>>>> the XFS async discard support.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>
>>>> Hm, I figured the async discard stuff would have been a pretty clear win
>>>> all around, but then again I'm not terribly familiar with what happens
>>>> with discards beneath the fs. I do know that the previous behavior would
>>>> cause fs level latencies due to holding up log I/O completion while
>>>> discards completed one at a time. My understanding is that this lead to
>>>> online discard being pretty much universally "not recommended" in favor
>>>> of fstrim.
>>>
>>> It's not a secret that most devices suck at discard.
>>
>> How can we know if a device sucks at discard?
> 
> I was going to ask the same thing.  ;)  "Meh, punt to the admin!"
> 
> I'm having deja vu but can't remember why.  Seems like this has come up
> before and we thought it should be a block device tunable, not pushed down
> from the filesystem.  Is that possible?

The problem is that it'll depend on the workload as well. The device in
may laptop is fine with discard for my workload, which is very light.
But if you are running RocksDB on it, and doing heavy compactions and
deletes, it probably would not be.

-- 
Jens Axboe

