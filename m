Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:41826 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755283AbeD3WkI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 18:40:08 -0400
Received: by mail-pf0-f177.google.com with SMTP id v63so7841938pfk.8
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 15:40:07 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430213120.GD13766@dastard>
 <c6e9db38-51d3-ae13-58cb-2b815ddd5891@kernel.dk>
 <20180430222852.GF13766@dastard>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <87589bc6-e5f5-6247-485f-2237e0c493ad@kernel.dk>
Date: Mon, 30 Apr 2018 16:40:04 -0600
MIME-Version: 1.0
In-Reply-To: <20180430222852.GF13766@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 4/30/18 4:28 PM, Dave Chinner wrote:
> On Mon, Apr 30, 2018 at 03:42:11PM -0600, Jens Axboe wrote:
>> On 4/30/18 3:31 PM, Dave Chinner wrote:
>>> On Mon, Apr 30, 2018 at 09:32:52AM -0600, Jens Axboe wrote:
>>>> XFS recently added support for async discards. While this can be
>>>> a win for some workloads and devices, there are also cases where
>>>> async bursty discard will severly harm the latencies of reads
>>>> and writes.
>>>
>>> FWIW, convention is it document the performance regression in the
>>> commit message, not leave the reader to guess at what it was....
>>
>> Yeah I'll give you that, I can improve the commit message for sure.
>>
>>> Did anyone analyse the pattern of discards being issued to work out
>>> what pattern was worse for async vs sync discard? is it lots of
>>> little discards, large extents being discarded, perhaps a problem
>>> with the request request queue starving other IOs because we queue
>>> so many async discards in such a short time (which is the difference
>>> in behaviour vs the old code), or something else?
>>
>> What was observed was a big discard which would previously have
>> gone down as smaller discards now going down as either one or many
>> discards. Looking at the blktrace data, it's the difference between
>>
>> discard 1 queue
>> discard 1 complete
>> discatd 2 queue
>> discard 2 complete
>> [...]
>> discard n queue
>> discard n complete
>>
>> which is now
>>
>> discard 1 queue
>> discard 2 queue
>> [...]
>> discard n queue
>> [...]
>> discard 1 complete
>> discard 2 complete
>> [...]
>> discard n complete
>>
>> Note that we set a max discard size of 64MB for most devices,
>> since it's been shown to have less impact on latencies for
>> the IO that jobs actually care about.
> 
> IOWs, this has nothing to do with XFS behaviour, and everything to
> do with suboptimal scheduling control for concurrent queued discards
> in the block layer....

You could argue that, and it's fallout from XFS being the first
user of async discard. Prior to that, we've never had that use
case. I'm quite fine making all discards throttle to depth
1.

> XFS can issue discard requests of up to 8GB (on 4k block size
> filesystems), and how they are optimised is completely up to the
> block layer. blkdev_issue_discard() happens to be synchronous (for
> historical reasons) and that does not match our asynchronous log IO
> model. it's always been a cause of total filesystem stall problems
> for XFS because we can't free log space until all the pending
> discards have been issued. Hence we can see global filesystems
> stalls of *minutes* with synchronous discards on bad devices and can
> cause OOM and all sorts of other nasty cascading failures.
> 
> Async discard dispatch solves this problem for XFS - discards no
> longer block forward journal progress, and we really don't want to
> go back to having that ticking timebomb in XFS. Handling concurrent
> discard requests in an optimal manner is not a filesystem problem -
> it's an IO scheduling problem.
> 
> 
> Essentially, we've exposed yet another limitation of the block/IO
> layer handling of discard requests in the linux storage stack - it
> does not have a configurable discard queue depth.
> 
> I'd much prefer these problems get handled at the IO scheduling
> layer where there is visibulity of device capabilities and request
> queue state. i.e. we should be throttling async discards just like
> we can throttle read or write IO, especially given there are many
> devices that serialise discards at the device level (i.e. not queued
> device commands). This solves the problem for everyone and makes
> things much better for the future where hardware implementations are
> likely to get better and support more and more concurrency in
> discard operations.
> 
> IMO, the way the high level code dispatches discard requests is
> irrelevant here - this is a problem to do with queue depth and IO
> scheduling/throttling. That's why I don't think adding permanent ABI
> changes to filesystems to work around this problem is the right
> solution....

If you get off your high horse for a bit, this is essentially
a performance regression. I can either migrate folks off of XFS, or
I can come up with something that works for them. It's pretty
easy to claim this is "yet another limitation of the IO stack",
but it's really not fair to make crazy claims like that when it's
an entirely new use case. Let's try to state things objectively
and fairly.

This work should probably have been done before making XFS
discard async. This isn't the first fallout we've had from that
code.

>>> I don't think we should be changing anything - adding an opaque,
>>> user-unfriendly mount option does nothing to address the underlying
>>> problem - it's just a hack to work around the symptoms being seen...
>>>
>>> More details of the regression and the root cause analysis is
>>> needed, please.
>>
>> It brings back the same behavior as we had before, which performs
>> better for us. It's preventing users of XFS+discard from upgrading,
>> which is sad.
> 
> Yes, it does, but so would having the block layer to throttle device
> discard requests in flight to a queue depth of 1. And then we don't
> have to change XFS at all.

I'm perfectly fine with making that change by default, and much easier
for me since I don't have to patch file systems.

-- 
Jens Axboe

