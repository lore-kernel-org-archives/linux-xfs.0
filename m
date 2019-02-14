Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34040 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbfBNGLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Feb 2019 01:11:16 -0500
Subject: Re: [RFC PATCH v2 2/9] block: add rd_hint to bio and request
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190213095044.29628-3-bob.liu@oracle.com>
 <f2aceac4-7626-0aa9-ec15-eeca50aac442@kernel.dk>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <f3072df4-b439-faff-3661-89f15025c1a7@oracle.com>
Date: Thu, 14 Feb 2019 14:10:45 +0800
MIME-Version: 1.0
In-Reply-To: <f2aceac4-7626-0aa9-ec15-eeca50aac442@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

On 2/14/19 12:18 AM, Jens Axboe wrote:
> On 2/13/19 2:50 AM, Bob Liu wrote:
>> rd_hint is a bitmap for stacked layer support(see patch 4/9),
>> set a bit to 1 means already read from the corresponding mirror device.
>>
>> rd_hint will be set properly recording read i/o went to which real device
>> during end_bio().
>> If the upper layer want to retry other mirrors, just preserve the returned
>> bi_rd_hint and resubmit bio.
>>
>> The upper layer e.g fs can set bitmap_zero(rd_hint) if don't care about alt
>> mirror device retry feature which is also the default setting.
> 
> You just made the bio 16 bytes bigger on my build, which is an increase
> of 12.5% and spills it into a third cacheline. That's not going to work
> at all. At least look at where you are placing this thing. That goes
> for the request as well, you can just toss members in there at random.
> 

Are you fine with an union like?
-       unsigned short          bi_write_hint;
-       DECLARE_BITMAP(bi_rd_hint, BLKDEV_MAX_MIRRORS);
+       union {
+           unsigned short              bi_write_hint;
+           unsigned long               bi_rd_hint;
+       };

But rd_hint need to be "unsigned long" which would still make bio/request bigger.

For sure can add KCONFIG option around if necessary.

> Also, why is BLKDEV_MAX_MIRRORS in types.h? That makes very little sense.
> 

Indeed, so I plan to switch back "unsigned long bi_rd_hint".
But bi_rd_hint is still a bitmap(for stacked layer support) which means this feature can not
work if more than BITS_PER_LONG copies.

> Look into options of carrying this elsewhere, or (at the very least)
> making it dependent on whoever needs it. This is NOT a negligible
> amount of wasted space.
> 
