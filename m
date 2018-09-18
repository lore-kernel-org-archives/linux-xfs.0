Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727756AbeIRUCD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 16:02:03 -0400
Date: Tue, 18 Sep 2018 10:29:11 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-writecache issue
In-Reply-To: <d2d949ec-b3b6-cba3-66f8-c225784d5951@sandeen.net>
Message-ID: <alpine.LRH.2.02.1809181024150.28565@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180911221147.GA23308@redhat.com> <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com> <20180918123238.GI27618@dastard> <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net> <alpine.LRH.2.02.1809180934040.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <8975ad6d-bfde-0a50-e60c-59228493f1b2@sandeen.net> <d2d949ec-b3b6-cba3-66f8-c225784d5951@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>



On Tue, 18 Sep 2018, Eric Sandeen wrote:

> 
> 
> On 9/18/18 9:16 AM, Eric Sandeen wrote:
> > On 9/18/18 9:09 AM, Mikulas Patocka wrote:
> >>
> >>
> >> On Tue, 18 Sep 2018, Eric Sandeen wrote:
> >>
> >>> On 9/18/18 7:32 AM, Dave Chinner wrote:
> >>>> On Tue, Sep 18, 2018 at 07:46:47AM -0400, Mikulas Patocka wrote:
> >>>>> I would ask the XFS developers about this - why does mkfs.xfs select 
> >>>>> sector size 512 by default?
> >>>>
> >>>> Because the underlying device told it that it supported a
> >>>> sector size of 512 bytes?
> >>>
> >>> Not only that, but it must have told us that it had a /physical/ 512 sector.
> >>> If it had even said physical/logical 4096/512, we would have chosen 4096.
> >>>
> >>> What does please check blockdev --getpbsz --getss /dev/$FOO say at mkfs time?
> >>
> >> On SSDs, physical sector size is not detectable - the ATA and NVME 
> >> standards allows reporting physical sector size, but some SSD vendors 
> >> report this as 512-bytes despite the fact that the SSD has 4k sectors 
> >> internally.
> > 
> > There's a difference between "detecting" and "observing what the
> > device reports."
> > 
> > All we have to go on is the geometry reported by the device.
> > 
> > # cat /sys/block/sdc/device/model 
> > Samsung SSD 850 
> > # blockdev --getpbsz --getss /dev/sdc
> > 512
> > 512
> > 
> > If the device lies to us, there's nothing to be done about it.
> > 
> >> I tested 5 SSDs (Samsung SSD 960 EVO NVME, KINGSTON SKC1000240G NVME, 
> >> Samsung SSD 850 EVO SATA, Crucial MX100 SATA, Intel 520 SATA) - all of 
> >> them have 4k sectors internally (i.e. the SSDs have higher IOPS for 4k 
> >> writes than for 2k writes), but only the Crucial SSD reports 4096 in 
> >> /sys/block/*/queue/physical_block_size. Intel and Samsung report 512.
> 
> See also 
> https://www.intel.com/content/www/us/en/support/articles/000006392/memory-and-storage.html
> 
> -Eric

And does it really support native 512-byte writes? Or does it emulate 
512-byte writes by doing read-modify-write? That needs to be benchmarked, 
the paper doesn't say that.

Memory is expensive and reducing SSD sector size increases memory 
requirement on the SSD. I doubt that any SSD vendor would want to use 
8-times more memory just to support 512-byte sectors natively.

Mikulas
