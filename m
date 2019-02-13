Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33756 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730572AbfBMQSO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Feb 2019 11:18:14 -0500
Received: by mail-ot1-f66.google.com with SMTP id i20so5166142otl.0
        for <linux-xfs@vger.kernel.org>; Wed, 13 Feb 2019 08:18:14 -0800 (PST)
Subject: Re: [RFC PATCH v2 2/9] block: add rd_hint to bio and request
References: <20190213095044.29628-1-bob.liu@oracle.com>
 <20190213095044.29628-3-bob.liu@oracle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f2aceac4-7626-0aa9-ec15-eeca50aac442@kernel.dk>
Date: Wed, 13 Feb 2019 09:18:10 -0700
MIME-Version: 1.0
In-Reply-To: <20190213095044.29628-3-bob.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bob Liu <bob.liu@oracle.com>, linux-block@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca

On 2/13/19 2:50 AM, Bob Liu wrote:
> rd_hint is a bitmap for stacked layer support(see patch 4/9),
> set a bit to 1 means already read from the corresponding mirror device.
> 
> rd_hint will be set properly recording read i/o went to which real device
> during end_bio().
> If the upper layer want to retry other mirrors, just preserve the returned
> bi_rd_hint and resubmit bio.
> 
> The upper layer e.g fs can set bitmap_zero(rd_hint) if don't care about alt
> mirror device retry feature which is also the default setting.

You just made the bio 16 bytes bigger on my build, which is an increase
of 12.5% and spills it into a third cacheline. That's not going to work
at all. At least look at where you are placing this thing. That goes
for the request as well, you can just toss members in there at random.

Also, why is BLKDEV_MAX_MIRRORS in types.h? That makes very little sense.

Look into options of carrying this elsewhere, or (at the very least)
making it dependent on whoever needs it. This is NOT a negligible
amount of wasted space.

-- 
Jens Axboe
