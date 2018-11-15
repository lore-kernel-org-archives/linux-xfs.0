Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51604 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbeKOLMq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Nov 2018 06:12:46 -0500
Date: Thu, 15 Nov 2018 09:06:52 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH] block: fix 32 bit overflow in __blkdev_issue_discard()
Message-ID: <20181115010651.GD32603@ming.t460p>
References: <20181113214337.20581-1-david@fromorbit.com>
 <10a8dd78-7c00-8593-9f4e-b20eb1161b92@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10a8dd78-7c00-8593-9f4e-b20eb1161b92@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Wed, Nov 14, 2018 at 08:18:24AM -0700, Jens Axboe wrote:
> On 11/13/18 2:43 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > A discard cleanup merged into 4.20-rc2 causes fstests xfs/259 to
> > fall into an endless loop in the discard code. The test is creating
> > a device that is exactly 2^32 sectors in size to test mkfs boundary
> > conditions around the 32 bit sector overflow region.
> > 
> > mkfs issues a discard for the entire device size by default, and
> > hence this throws a sector count of 2^32 into
> > blkdev_issue_discard(). It takes the number of sectors to discard as
> > a sector_t - a 64 bit value.
> > 
> > The commit ba5d73851e71 ("block: cleanup __blkdev_issue_discard")
> > takes this sector count and casts it to a 32 bit value before
> > comapring it against the maximum allowed discard size the device
> > has. This truncates away the upper 32 bits, and so if the lower 32
> > bits of the sector count is zero, it starts issuing discards of
> > length 0. This causes the code to fall into an endless loop, issuing
> > a zero length discards over and over again on the same sector.
> 
> Applied, thanks. Ming, can you please add a blktests test for
> this case? This is the 2nd time it's been broken.

OK, I will add zram discard test in blktests, which should cover the
1st report. For the xfs/259, I need to investigate if it is easy to
do in blktests.

Thanks,
Ming
