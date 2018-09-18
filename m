Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729037AbeIRXNe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Sep 2018 19:13:34 -0400
Date: Tue, 18 Sep 2018 13:39:53 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-writecache issue
In-Reply-To: <20180918153324.GB13016@infradead.org>
Message-ID: <alpine.LRH.2.02.1809181316230.7172@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180911221147.GA23308@redhat.com> <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com> <20180918123238.GI27618@dastard> <alpine.LRH.2.02.1809181014500.28565@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918153324.GB13016@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>



On Tue, 18 Sep 2018, Christoph Hellwig wrote:

> On Tue, Sep 18, 2018 at 10:22:15AM -0400, Mikulas Patocka wrote:
> > > On Tue, Sep 18, 2018 at 07:46:47AM -0400, Mikulas Patocka wrote:
> > > > I would ask the XFS developers about this - why does mkfs.xfs select 
> > > > sector size 512 by default?
> > > 
> > > Because the underlying device told it that it supported a
> > > sector size of 512 bytes?
> > 
> > SSDs lie about this. They have 4k sectors internally, but report 512.
> 
> SSDs can't lie about the sector size because they don't even have
> sectors in the disk sense, they have program and erase block size,

They have remapping table that maps each 4k block to a location on the 
NAND flash.

> and some kind of FTL granularity (think of it like a file system block
> size - even a 4k block size file can do smaller writes with
> read-modify-write cycles, so can SSDs).
> 
> SSDs can just properly implement the guarantees they inherited from
> disk by other means.  So if an SSD claims it supports 512 byte blocks
> it better can deal with them atomically.  If they have issues in that
> area (like Intel did recently where they corrupted data left right
> and center if you actually did 512byte writes) they are simply buggy.
> 
> SATA and SAS SSDs can always use the same trick as modern disks to
> support 512 byte access where really needed (e.g. BIOS and legacy
> OSes) but give a strong hint to modern OSes that they don't want that
> to be actually used with the physical block exponent.  NVMe doesn't
> have anything like that yet, but we are working on something like
> that in the NVMe TWG.

The question is - why do you want to use 512-byte writes if they perform 
badly? For example, the Kingston NVME SSD has 242k IOPS for 4k writes and 
45k IOPS for 2k writes.

The same problem is with dm-writecache - it can run with 512-byte sectors, 
but there's unnecessary overhead. It would be much better if XFS did 4k 
aligned writes.


You can do 4k writes and assume that only 512-byte units are written 
atomically - that would be safe for old 512-byte sector disk and it 
wouldn't degrade performance on SSDs.

If the XFS data blocks are aligned on 4k boundary, you can do 4k-aligned 
I/Os on the metadata as well. You could allocate metadata in 512-byte 
quantities and you could do 4k reads and writes on them. You would 
over-read and over-write a bit, but it will perform better due to avoiding 
the read-modify-write logic in the SSD.

I'm not an expert in the XFS journal - but could the journal writes be 
just padded to 4k boundary (even if the journal space is allocated in 
512-byte quantities)?

Mikulas
