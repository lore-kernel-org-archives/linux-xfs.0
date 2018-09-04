Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbeIDMuG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 4 Sep 2018 08:50:06 -0400
Date: Tue, 4 Sep 2018 09:26:00 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180904082600.GB16358@redhat.com>
References: <20180903224919.GA16358@redhat.com>
 <20180904004940.GR5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904004940.GR5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 04, 2018 at 10:49:40AM +1000, Dave Chinner wrote:
> On Mon, Sep 03, 2018 at 11:49:19PM +0100, Richard W.M. Jones wrote:
> > [This is silly and has no real purpose except to explore the limits.
> > If that offends you, don't read the rest of this email.]
> 
> We do this quite frequently ourselves, even if it is just to remind
> ourselves how long it takes to wait for millions of IOs to be done.
>
> > I am trying to create an XFS filesystem in a partition of approx
> > 2^63 - 1 bytes to see what happens.
> 
> Should just work. You might find problems with the underlying
> storage, but the XFS side of things should just work.

Great!  How do you test this normally?  I'm assuming you must use a
virtual device and don't have actual 2^6x storage systems around?

[...]
> What's the sector size of you device? This seems to imply that it is
> 1024 bytes, not the normal 512 or 4096 bytes we see in most devices.

This led me to wondering how the sector size is chosen.  NBD itself is
agnostic about sectors (it deals entirely with byte offsets).  It
seems as if the Linux kernel NBD driver chooses this, I think here:

https://github.com/torvalds/linux/blob/60c1f89241d49bacf71035470684a8d7b4bb46ea/drivers/block/nbd.c#L1320

It seems an odd choice.

> Hence if you are seeing 4GB discards on the NBD side, then the NBD
> device must be advertising 4GB to the block layer as the
> discard_max_bytes. i.e. this, at first blush, looks purely like a
> NBD issue.

The 4 GB discard limit is indeed entirely a limit in the NBD protocol
(it uses 32 bit count sizes for various things like zeroing and
trimming, where it would make more sense to use wider type because we
aren't sending data over the wire).  I will take this up with the
upstream community and see if we can get an extension added.

> > However I can use the -K option to get around that:
> > 
> >   # mkfs.xfs -K /dev/nbd0p1
> >   meta-data=/dev/nbd0p1            isize=512    agcount=8388609, agsize=268435455 blks
> >            =                       sectsz=1024  attr=2, projid32bit=1
> 
> Oh, yeah, 1kB sectors. How weird is that - I've never seen a block
> device with a 1kB sector before.
> 
> >            =                       crc=1        finobt=1, sparse=0, rmapbt=0, reflink=0
> >   data     =                       bsize=4096   blocks=2251799813684987, imaxpct=1
> >            =                       sunit=0      swidth=0 blks
> >   naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> >   log      =internal log           bsize=4096   blocks=521728, version=2
> >            =                       sectsz=1024  sunit=1 blks, lazy-count=1
> >   realtime =none                   extsz=4096   blocks=0, rtextents=0
> >   mkfs.xfs: read failed: Invalid argument
> > 
> > I guess this indicates a real bug in mkfs.xfs.
> 
> Did it fail straight away? Or after a long time?  Can you trap this
> in gdb and post a back trace so we know where it is coming from?

Yes I think I was far too hasty declaring this a problem with mkfs.xfs
last night.  It turns out that NBD on the wire can only describe a few
different errors and maps any other error to -EINVAL, which is likely
what is happening here.  I'll get the NBD server to log errors to find
out what's really going on.

[...]
> > But first I wanted to ask a broader question about whether there are
> > other mkfs options (apart from -K) which are suitable when creating
> > especially large XFS filesystems?
> 
> Use the defaults - there's nothing you can "optimise" to make
> testing like this go faster because all the time is in
> reading/writing AG headers. There's millions of them, and there are
> cases where they may have to all be read at mount time, too. Be
> prepared to wait a long time for simple things to happen...

OK this is really good to know, thanks.  I'll keep testing.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
