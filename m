Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43176 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbeIRVGc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 17:06:32 -0400
Date: Tue, 18 Sep 2018 08:33:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: dm-writecache issue
Message-ID: <20180918153324.GB13016@infradead.org>
References: <20180911221147.GA23308@redhat.com>
 <alpine.LRH.2.02.1809180741001.6599@file01.intranet.prod.int.rdu2.redhat.com>
 <20180918123238.GI27618@dastard>
 <alpine.LRH.2.02.1809181014500.28565@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1809181014500.28565@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, David Teigland <teigland@redhat.com>

On Tue, Sep 18, 2018 at 10:22:15AM -0400, Mikulas Patocka wrote:
> > On Tue, Sep 18, 2018 at 07:46:47AM -0400, Mikulas Patocka wrote:
> > > I would ask the XFS developers about this - why does mkfs.xfs select 
> > > sector size 512 by default?
> > 
> > Because the underlying device told it that it supported a
> > sector size of 512 bytes?
> 
> SSDs lie about this. They have 4k sectors internally, but report 512.

SSDs can't lie about the sector size because they don't even have
sectors in the disk sense, they have program and erase block size,
and some kind of FTL granularity (think of it like a file system block
size - even a 4k block size file can do smaller writes with
read-modify-write cycles, so can SSDs).

SSDs can just properly implement the guarantees they inherited from
disk by other means.  So if an SSD claims it supports 512 byte blocks
it better can deal with them atomically.  If they have issues in that
area (like Intel did recently where they corrupted data left right
and center if you actually did 512byte writes) they are simply buggy.

SATA and SAS SSDs can always use the same trick as modern disks to
support 512 byte access where really needed (e.g. BIOS and legacy
OSes) but give a strong hint to modern OSes that they don't want that
to be actually used with the physical block exponent.  NVMe doesn't
have anything like that yet, but we are working on something like
that in the NVMe TWG.
