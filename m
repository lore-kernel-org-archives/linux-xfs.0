Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40251 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbeKOL5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 06:57:36 -0500
Received: by mail-pf1-f194.google.com with SMTP id x2-v6so8841802pfm.7
        for <linux-xfs@vger.kernel.org>; Wed, 14 Nov 2018 17:51:50 -0800 (PST)
Subject: Re: [PATCH] block: fix 32 bit overflow in __blkdev_issue_discard()
References: <20181113214337.20581-1-david@fromorbit.com>
 <10a8dd78-7c00-8593-9f4e-b20eb1161b92@kernel.dk>
 <20181115010651.GD32603@ming.t460p>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <80b9c4b7-1625-a1b6-0f1e-94de9d8b446b@kernel.dk>
Date: Wed, 14 Nov 2018 18:51:47 -0700
MIME-Version: 1.0
In-Reply-To: <20181115010651.GD32603@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On 11/14/18 6:06 PM, Ming Lei wrote:
> On Wed, Nov 14, 2018 at 08:18:24AM -0700, Jens Axboe wrote:
>> On 11/13/18 2:43 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> A discard cleanup merged into 4.20-rc2 causes fstests xfs/259 to
>>> fall into an endless loop in the discard code. The test is creating
>>> a device that is exactly 2^32 sectors in size to test mkfs boundary
>>> conditions around the 32 bit sector overflow region.
>>>
>>> mkfs issues a discard for the entire device size by default, and
>>> hence this throws a sector count of 2^32 into
>>> blkdev_issue_discard(). It takes the number of sectors to discard as
>>> a sector_t - a 64 bit value.
>>>
>>> The commit ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
>>> takes this sector count and casts it to a 32 bit value before
>>> comapring it against the maximum allowed discard size the device
>>> has. This truncates away the upper 32 bits, and so if the lower 32
>>> bits of the sector count is zero, it starts issuing discards of
>>> length 0. This causes the code to fall into an endless loop, issuing
>>> a zero length discards over and over again on the same sector.
>>
>> Applied, thanks. Ming, can you please add a blktests test for
>> this case? This is the 2nd time it's been broken.
> 
> OK, I will add zram discard test in blktests, which should cover the
> 1st report. For the xfs/259, I need to investigate if it is easy to
> do in blktests.

null_blk has discard support, might be an easier target in terms
of blktests.

-- 
Jens Axboe
