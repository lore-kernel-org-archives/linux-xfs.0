Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17490 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726210AbeIDNf3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 09:35:29 -0400
Date: Tue, 4 Sep 2018 19:11:12 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180904091112.GT5631@dastard>
References: <20180903224919.GA16358@redhat.com>
 <20180904004940.GR5631@dastard>
 <20180904082600.GB16358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904082600.GB16358@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 04, 2018 at 09:26:00AM +0100, Richard W.M. Jones wrote:
> On Tue, Sep 04, 2018 at 10:49:40AM +1000, Dave Chinner wrote:
> > On Mon, Sep 03, 2018 at 11:49:19PM +0100, Richard W.M. Jones wrote:
> > > [This is silly and has no real purpose except to explore the limits.
> > > If that offends you, don't read the rest of this email.]
> > 
> > We do this quite frequently ourselves, even if it is just to remind
> > ourselves how long it takes to wait for millions of IOs to be done.
> >
> > > I am trying to create an XFS filesystem in a partition of approx
> > > 2^63 - 1 bytes to see what happens.
> > 
> > Should just work. You might find problems with the underlying
> > storage, but the XFS side of things should just work.
> 
> Great!  How do you test this normally?

The usual: it's turtles all the way down.

> I'm assuming you must use a
> virtual device and don't have actual 2^6x storage systems around?

Right. I use XFS on XFS configurations. i.e. XFS is the storage pool
on physical storage (SSDs in RAID0 in this case). The disk images
are sparse files w/ extent size hints to minimise fragmentation and
allocation overhead. And the QEMU config uses AIO/DIO so it can do
concurrent, deeply queued async read/write IO from the guest to the
host - the guest block device behaves exactly like it is hosted on
real disks.

Apart from reflink and extent size hints, I'm using the defaults for
everything.

> > > I guess this indicates a real bug in mkfs.xfs.
> > 
> > Did it fail straight away? Or after a long time?  Can you trap this
> > in gdb and post a back trace so we know where it is coming from?
> 
> Yes I think I was far too hasty declaring this a problem with mkfs.xfs
> last night.  It turns out that NBD on the wire can only describe a few
> different errors and maps any other error to -EINVAL, which is likely

Urk. It should map them to -EIO, because then we know it's come from
the IO layer and isn't a problem related to userspace passing the
kernel invalid parameters.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
