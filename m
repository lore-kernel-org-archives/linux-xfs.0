Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727846AbeIRTlr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 15:41:47 -0400
Date: Tue, 18 Sep 2018 10:09:00 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-writecache issue
In-Reply-To: <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
Message-ID: <alpine.LRH.2.02.1809180934040.28565@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180911221147.GA23308@redhat.com> <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com> <20180918123238.GI27618@dastard> <817349b8-b54e-a16a-276f-7a977f29b449@sandeen.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>



On Tue, 18 Sep 2018, Eric Sandeen wrote:

> On 9/18/18 7:32 AM, Dave Chinner wrote:
> > On Tue, Sep 18, 2018 at 07:46:47AM -0400, Mikulas Patocka wrote:
> >> I would ask the XFS developers about this - why does mkfs.xfs select 
> >> sector size 512 by default?
> > 
> > Because the underlying device told it that it supported a
> > sector size of 512 bytes?
> 
> Not only that, but it must have told us that it had a /physical/ 512 sector.
> If it had even said physical/logical 4096/512, we would have chosen 4096.
> 
> What does please check blockdev --getpbsz --getss /dev/$FOO say at mkfs time?

On SSDs, physical sector size is not detectable - the ATA and NVME 
standards allows reporting physical sector size, but some SSD vendors 
report this as 512-bytes despite the fact that the SSD has 4k sectors 
internally.

I tested 5 SSDs (Samsung SSD 960 EVO NVME, KINGSTON SKC1000240G NVME, 
Samsung SSD 850 EVO SATA, Crucial MX100 SATA, Intel 520 SATA) - all of 
them have 4k sectors internally (i.e. the SSDs have higher IOPS for 4k 
writes than for 2k writes), but only the Crucial SSD reports 4096 in 
/sys/block/*/queue/physical_block_size. Intel and Samsung report 512.

The SSDs use 4k sectors to reduce the size of the mapping table (hardly 
any SSD vendor would want to use real 512-byte sectors and increase the 
size of the table 8 times) and they do read-modify-write for sub-4k 
writes. So, why do you want to do sub-4k writes in XFS? - they are slower.

For example, the Kingston NVME SSD has 5-times lower IOPS for 2k writes 
than for 4k writes. And if I use mkfs.xfs directly on it, it selects 
sectsz=512 for both metadata and log.

Mikulas
