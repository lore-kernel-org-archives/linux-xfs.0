Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:38216 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753594AbeD3XDC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 19:03:02 -0400
Received: by mail-pf0-f194.google.com with SMTP id o76so7884617pfi.5
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 16:03:01 -0700 (PDT)
Subject: Re: [PATCH 2/2] xfs: add 'discard_sync' mount flag
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
 <1525102372-8430-3-git-send-email-axboe@kernel.dk>
 <20180430171945.GB22176@bfoster.bfoster>
 <24df628d-c861-6f39-96a8-d759902d1fe3@kernel.dk>
 <20180430182525.GE27875@wotan.suse.de>
 <4cb68c8e-bf6c-b717-73f0-20e850582004@sandeen.net>
 <210ebc4e-780a-1cf2-92e0-2482b98704a2@kernel.dk>
 <c149cd30-97ba-cd86-de8d-efb83825521a@sandeen.net>
 <6f4137ac-d7c2-2727-d1da-649df30f3682@kernel.dk>
 <5d5d6d6a-f312-a2ad-8718-97a2f334ec7f@sandeen.net>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <500ec71a-786a-321a-5a24-f28bc1efe0a0@kernel.dk>
Date: Mon, 30 Apr 2018 17:02:57 -0600
MIME-Version: 1.0
In-Reply-To: <5d5d6d6a-f312-a2ad-8718-97a2f334ec7f@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, hch@lst.de

On 4/30/18 4:59 PM, Eric Sandeen wrote:
> On 4/30/18 2:58 PM, Jens Axboe wrote:
>> On 4/30/18 1:57 PM, Eric Sandeen wrote:
>>> On 4/30/18 2:21 PM, Jens Axboe wrote:
> 
> ...
> 
>>> Ok, but I'm not sure how that precludes a block device tunable?  You'd tune
>>> it for your workload, right?
>>
>> What kind of tunable are you thinking of? Right now we have one tunable,
>> which is the max discard size. Patch #1 actually helps make this do what
>> it should for sync discards, instead of just building a bio chain and
>> submitting that all at once.
>>
>>> Or is the concern that it could only be for the entire block device, and
>>> perhaps different partitions have different workloads?
>>>
>>> Sorry, caveman filesystem guy doesn't completely understand block devices.
>>
>> I just don't know what you are trying to tune :-)
> 
> I'm wondering if "make discards synchronous" couldn't just be a block device
> tunable, rather than a filesystem mount option tunable.

See e-mail I just sent out. With that, you get that tunable bundled with
the discard_max_bytes tunable. If you leave it at the default, which is
generally very high, then you get huge discards. If you tune it down,
they become basically sync. I don't think we need a separate tunable
for this.

It's still per-caller, which is good enough for us. I don't want to
make it more complicated until people show up with a valid use case
that shows we need it strictly throttled per-device.

-- 
Jens Axboe

