Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:37009 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbeIDNgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Sep 2018 09:36:47 -0400
Date: Tue, 4 Sep 2018 19:12:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: mkfs.xfs options suitable for creating absurdly large XFS
 filesystems?
Message-ID: <20180904091230.GU5631@dastard>
References: <20180903224919.GA16358@redhat.com>
 <20180904004940.GR5631@dastard>
 <20180904082332.GS5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180904082332.GS5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Sep 04, 2018 at 06:23:32PM +1000, Dave Chinner wrote:
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
> > I'm trying to reproduce it here:
> > 
> > $ grep vdd /proc/partitions 
> >  253       48 9007199254739968 vdd
> > $ sudo mkfs.xfs -f -s size=1024 -d size=2251799813684887b -N /dev/vdd
> > meta-data=/dev/vdd               isize=512    agcount=8388609, agsize=268435455 blks
> >          =                       sectsz=1024  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=0
> >          =                       reflink=0
> > data     =                       bsize=4096   blocks=2251799813684887, imaxpct=1
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=521728, version=2
> >          =                       sectsz=1024  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > 
> > And it is running now without the "-N" and I have to wait for tens
> > of millions of IOs to be issued. The write rate is currently about
> > 13,000 IOPS, so I'm guessing it'll take at least an hour to do
> > this. Next time I'll run it on the machine with faster SSDs.
> > 
> > I haven't seen any error after 20 minutes, though.
> 
> I killed it after 2 and half hours, and started looking at why it
> was taking that long. That's the above.

Or the below. Stand on your head if you're confused.

-Dave.

> But it's not fast. This is the first time I've looked at whether we
> perturbed the IO patterns in the recent mkfs.xfs refactoring. I'm
> not sure we made them any worse (the algorithms are the same), but
> it's now much more obvious how we can improve them drastically with
> a few small mods.
> 
> Firstly, there's the force overwrite alogrithm that zeros the old
> filesystem signature. One an 8EB device with an existing 8EB
> filesystem, there's 8+ million single sector IOs right there.
> So for the moment, zero the first 1MB of the device to whack the
> old superblock and you can avoid this step. I've got a fix for that
> now:
> 
> 	Time to mkfs a 1TB filsystem on a big device after it held another
> 	larger filesystem:
> 
> 	previous FS size	10PB	100PB	 1EB
> 	old mkfs time		1.95s	8.9s	81.3s
> 	patched			0.95s	1.2s	 1.2s
> 
> 
> Second, use -K to avoid discard (which you already know).
> 
> Third, we do two passes over the AG headers to initialise them.
> Unfortunately, with a large number of AGs, they don't stay in the
> buffer cache and so the second pas involves RMW cycles. This means
> we do at least 5 extra read and 5 extra write IOs per AG than we
> need to. I've got a fix for this, too:
> 
> 	Time to make a filesystem from scratch, using a zeroed device so the
> 	force overwrite algorithms are not triggered and -K to avoid
> 	discards:
> 
> 	FS size         10PB    100PB    1EB
> 	current mkfs    26.9s   214.8s  2484s
> 	patched         11.3s    70.3s	 709s
> 
> From that projection, the 8EB mkfs would have taken somewhere around
> 7-8 hours to complete. The new code should only take a couple of
> hours. Still not all that good....
> 
> .... and I think that's because we are using direct IO. That means
> the IO we issue is effectively synchronous, even though we sorta
> doing delayed writeback. The problem is that mkfs is not threaded so
> writeback happens when the cache fills up and we run out of buffers
> on the free list. Basically it's "direct delayed writeback" at that
> point.
> 
> Worse, because it's synchronous, we don't drive more than one IO at
> a time and so we don't get adjacent sector merging, even though most
> ofhte AG header writes are to adjacent sectors. That would cut the
> amount of IOs from ~10 per AG down to 2 for sectorsize < blocksize
> filesysetms and 1 for sectorsize = blocksize filesystems.
> 
> This isn't so easy to fix. I either need to:
> 
> 	1) thread the libxfs buffer cache so we can do this
> 	  writeback in the background.
> 	2) thread mkfs so it can process multiple AGs at once; or
> 	3) libxfs needs to use AIO via delayed write infrastructure
> 	similar to what we have in the kernel (buffer lists)
> 
> Approach 1) does not solve the queue depth = 1 issue, so
> it's of limited value. Might be quick, but doesn't really get us
> much improvement.
> 
> Approach 2) drives deeper queues, but it doesn't solve the adjacent
> sector IO merging problem because each thread only has a queue depth
> of one. So we'll be able to do more IO, but IO efficiency won't
> improve. And, realistically, this isn't a good idea because OOO AG
> processing doesn't work on spinning rust - it just causes seek
> storms and things go slower. To make things faster on spinning rust,
> we need single threaded, in order dispatch, asynchronous writeback.
> Which is almost what 1) is, except it's not asynchronous.
> 
> That's what 3) solves - single threaded, in-order, async writeback,
> controlled by the context creating the dirty buffers in a limited
> AIO context.  I'll have to think about this a bit more....
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

-- 
Dave Chinner
david@fromorbit.com
