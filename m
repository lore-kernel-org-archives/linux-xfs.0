Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it1-f171.google.com ([209.85.166.171]:51956 "EHLO
        mail-it1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732367AbeKOBWH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Nov 2018 20:22:07 -0500
Received: by mail-it1-f171.google.com with SMTP id f84-v6so3118385ita.1
        for <linux-xfs@vger.kernel.org>; Wed, 14 Nov 2018 07:18:27 -0800 (PST)
Subject: Re: [PATCH] block: fix 32 bit overflow in __blkdev_issue_discard()
References: <20181113214337.20581-1-david@fromorbit.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <10a8dd78-7c00-8593-9f4e-b20eb1161b92@kernel.dk>
Date: Wed, 14 Nov 2018 08:18:24 -0700
MIME-Version: 1.0
In-Reply-To: <20181113214337.20581-1-david@fromorbit.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On 11/13/18 2:43 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A discard cleanup merged into 4.20-rc2 causes fstests xfs/259 to
> fall into an endless loop in the discard code. The test is creating
> a device that is exactly 2^32 sectors in size to test mkfs boundary
> conditions around the 32 bit sector overflow region.
> 
> mkfs issues a discard for the entire device size by default, and
> hence this throws a sector count of 2^32 into
> blkdev_issue_discard(). It takes the number of sectors to discard as
> a sector_t - a 64 bit value.
> 
> The commit ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
> takes this sector count and casts it to a 32 bit value before
> comapring it against the maximum allowed discard size the device
> has. This truncates away the upper 32 bits, and so if the lower 32
> bits of the sector count is zero, it starts issuing discards of
> length 0. This causes the code to fall into an endless loop, issuing
> a zero length discards over and over again on the same sector.

Applied, thanks. Ming, can you please add a blktests test for
this case? This is the 2nd time it's been broken.

-- 
Jens Axboe
