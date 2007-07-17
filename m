Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 17:12:13 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6H0C8bm009028
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 17:12:10 -0700
Date: Tue, 17 Jul 2007 10:12:05 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid50 and 9TB volumes
Message-ID: <20070717001205.GI31489@sgi.com>
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com> <20070716130140.GC31489@sgi.com> <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com> <20070716221831.GE31489@sgi.com> <18076.1449.138328.66699@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18076.1449.138328.66699@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Raz <raziebe@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 17, 2007 at 09:56:25AM +1000, Neil Brown wrote:
> On Tuesday July 17, dgc@sgi.com wrote:
> > On Mon, Jul 16, 2007 at 04:53:22PM +0300, Raz wrote:
> > > 
> > > Well you are right.  /proc/partitions  says:
> > > ....
> > >   8   241  488384001 sdp1
> > >   9     1 3404964864 md1
> > >   9     2 3418684416 md2
> > >   9     3 6823647232 md3
> > > 
> > > while xfs formats md3 as 9 TB.
> > > If i am using LBD , what is the biggest size I can use on i386 ?
> > 
> > Supposedly 16TB. 32bit x 4k page size = 16TB. Given that the size is
> > not being reported correctly, I'd say that this is probably not an
> > XFS issue. The next thing to check is how large an MD device you
> > can create correctly.
> > 
> > Neil, do you know of any problems with > 8TB md devices on i386?
> 
> Should work, but the amount of testing has been limited, and bugs
> have existed.
> 
> Each component of a raid5 is limited to 2^32 K by the metadata, so
> that is 4TB.  At 490GB, you are well under that.
> There should be no problem with a 3TB raid5, providing LBD has been
> selected.
> 
> raid0 over 3TB devices should also be fine.  There was a bug fixed in
> May this year that caused problem with md/raid0 was used over
> components larger than 4TB on a 32bit host, but that shouldn't affect
> you and it does suggest that someone had success with a very large
> raid0 once this bug was fixed.
> 
> If XFS is given a 6.8TB devices and formats it as 9TB, then I would be
> looking at mkfs.xfs(??).

mkfs.xfs tries to read the last block of the device that it is given
and proceeds only if that read is successful. IOWs, mkfs.xfs has been
told the size of the device is 9TB, it's successfully read from offset
9TB, so the device must be at least 9TB.

However, internal to the kernel there appears to be some kind of
wrapping bug and typically that shows up with /proc/partition
showing an incosistent size of the partition compared to other
utilities.

We've come across this problem repeatedly over the past few years
with exactly these symptoms (the end of the FS overwriting the front
of the FS), which was why it was the first question I asked. It
has always been a block layer or partition problem and they always
show up on i386 with filesystems larger than 2TB.

FWIW, what a partitioning tool (if any) is being used here and
what does it think the size of the partitions are?.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
