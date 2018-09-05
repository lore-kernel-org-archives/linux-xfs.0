Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1465 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726401AbeIEMMs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Sep 2018 08:12:48 -0400
Date: Wed, 5 Sep 2018 17:43:49 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180905074349.GX5631@dastard>
References: <20180903224919.GA16358@redhat.com>
 <8045369.1GWcTSHGau@merkaba>
 <20180904222345.GV5631@dastard>
 <4003432.r53nhXgZDq@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4003432.r53nhXgZDq@merkaba>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: "Richard W.M. Jones" <rjones@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Sep 05, 2018 at 09:09:28AM +0200, Martin Steigerwald wrote:
> Dave Chinner - 05.09.18, 00:23:
> > On Tue, Sep 04, 2018 at 05:36:43PM +0200, Martin Steigerwald wrote:
> > > Dave Chinner - 04.09.18, 02:49:
> > > > On Mon, Sep 03, 2018 at 11:49:19PM +0100, Richard W.M. Jones 
> wrote:
> > > > > [This is silly and has no real purpose except to explore the
> > > > > limits.
> > > > > If that offends you, don't read the rest of this email.]
> > > > 
> > > > We do this quite frequently ourselves, even if it is just to
> > > > remind
> > > > ourselves how long it takes to wait for millions of IOs to be
> > > > done.
> > > 
> > > Just for the fun of it during an Linux Performance analysis & tuning
> > > course I held I created a 1 EiB XFS filesystem a sparse file on
> > > another XFS filesystem on an SSD of a ThinkPad T520. It took
> > > several hours to create, but then it was there and mountable. AFAIR
> > > the sparse file was a bit less than 20 GiB.
> > 
> > Yup, 20GB of single sector IOs takes a long time.
> 
> Yeah. It was interesting to see that neither the CPU nor the SSD was 
> fully utilized during that time tough.

Right - it's not CPU bound because it's always waiting on a single
IO, and it's not IO bound because it's only issuing a single IO at a
time.

Speaking of which, I just hacked an delayed write buffer list
construct similar to the kernel code into mkfs/libxfs to batch
writeback. Then I added a
hacky AIO ring to allow it to drive deep IO queues. I'm seeing
sustained request queue depths of ~100 and the SSDs are about 80%
busy at 100,000 write IOPS. But mkfs is only consuming about 60% of
a single CPU.

Which means that, instead of 7-8 hours to make an 8EB filesystem, we
can get it down to:

$ time sudo ~/packages/mkfs.xfs -K  -d size=8191p /dev/vdd
meta-data=/dev/vdd               isize=512    agcount=8387585, agsize=268435455 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=0
         =                       reflink=0
data     =                       bsize=4096 blocks=2251524935778304, imaxpct=1
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
	 =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

real    15m18.090s
user    5m54.162s
sys     3m49.518s

Around 15 minutes on a couple of cheap consumer nvme SSDs.

xfs_repair is going to need some help to scale up to this many AGs,
though - phase 1 is doing a huge amount of IO just to verify the
primary superblock...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
