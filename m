Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:53180 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754618AbeD3SbE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 14:31:04 -0400
Received: by mail-it0-f44.google.com with SMTP id i136-v6so2050801ita.2
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 11:31:04 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430171945.GB22176@bfoster.bfoster>
 <24df628d-c861-6f39-96a8-d759902d1fe3@kernel.dk>
 <20180430182525.GE27875@wotan.suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bd113078-d3a9-6490-b9b4-1319a6963e2b@kernel.dk>
Date: Mon, 30 Apr 2018 12:31:00 -0600
MIME-Version: 1.0
In-Reply-To: <20180430182525.GE27875@wotan.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 4/30/18 12:25 PM, Luis R. Rodriguez wrote:
> On Mon, Apr 30, 2018 at 12:07:31PM -0600, Jens Axboe wrote:
>> On 4/30/18 11:19 AM, Brian Foster wrote:
>>> On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
>>>> XFS recently added support for async discards. While this can be
>>>> a win for some workloads and devices, there are also cases where
>>>> async bursty discard will severly harm the latencies of reads
>>>> and writes.
>>>>
>>>> Add a 'discard_sync' mount flag to revert to using sync discard,
>>>> issuing them one at the time and waiting for each one. This fixes
>>>> a big performance regression we had moving to kernels that include
>>>> the XFS async discard support.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>
>>> Hm, I figured the async discard stuff would have been a pretty clear win
>>> all around, but then again I'm not terribly familiar with what happens
>>> with discards beneath the fs. I do know that the previous behavior would
>>> cause fs level latencies due to holding up log I/O completion while
>>> discards completed one at a time. My understanding is that this lead to
>>> online discard being pretty much universally "not recommended" in favor
>>> of fstrim.
>>
>> It's not a secret that most devices suck at discard.
> 
> How can we know if a device sucks at discard?

This test usually works well - does it support discard? Then it probably
sucks :-)

But seriously, synthetic test case with reads/writes (the actual workload)
and then mix in trims. If the performance suffers, then discards suck.
Just consider this series - it was a 25% latency win.

>> While the async
>> discard is nifty and I bet works well for some cases, it can also cause
>> a flood of discards on the device side which does not work well for
>> other cases.
> 
> Shouldn't async then be only enabled if the device used supports it well?
> Or should a blacklist per device be more suitable? Which is more popular?

You'd be left with nothing... My general recommendation is to not use
discards at all, unless there's a proven case that it makes a write
amplification difference for you - from at all, to "big enough that I'd
suffer the latency consequences".

-- 
Jens Axboe

