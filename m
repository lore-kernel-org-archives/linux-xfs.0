Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Jul 2007 17:59:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6H0x0bm005839
	for <xfs@oss.sgi.com>; Mon, 16 Jul 2007 17:59:02 -0700
Date: Tue, 17 Jul 2007 10:58:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: raid50 and 9TB volumes
Message-ID: <20070717005854.GL31489@sgi.com>
References: <5d96567b0707160542t2144c382mbfe3da92f0990694@mail.gmail.com> <20070716130140.GC31489@sgi.com> <5d96567b0707160653m5951fac9v5a56bb4c92174d63@mail.gmail.com> <20070716221831.GE31489@sgi.com> <18076.1449.138328.66699@notabene.brown> <20070717001205.GI31489@sgi.com> <18076.4940.845633.149160@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18076.4940.845633.149160@notabene.brown>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Raz <raziebe@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Jul 17, 2007 at 10:54:36AM +1000, Neil Brown wrote:
> On Tuesday July 17, dgc@sgi.com wrote:
> > On Tue, Jul 17, 2007 at 09:56:25AM +1000, Neil Brown wrote:
> > > On Tuesday July 17, dgc@sgi.com wrote:
> > > > On Mon, Jul 16, 2007 at 04:53:22PM +0300, Raz wrote:
> > > > > 
> > > > > Well you are right.  /proc/partitions  says:
> > > > > ....
> > > > >   8   241  488384001 sdp1
> > > > >   9     1 3404964864 md1
> > > > >   9     2 3418684416 md2
> > > > >   9     3 6823647232 md3
> > > > > 
> > > > > while xfs formats md3 as 9 TB.
> ..
> > > 
> > > If XFS is given a 6.8TB devices and formats it as 9TB, then I would be
> > > looking at mkfs.xfs(??).
> > 
> > mkfs.xfs tries to read the last block of the device that it is given
> > and proceeds only if that read is successful. IOWs, mkfs.xfs has been
> > told the size of the device is 9TB, it's successfully read from offset
> > 9TB, so the device must be at least 9TB.
> 
> Odd.
> Given that the drives are 490GB, and there are 8 in a raid5 array,
> the raid5 arrays are really under 3.5GB.  And two of them is less than
> 7GB.  So there definitely are not 9TB worth of bytes..
> 
> mkfs.xfs uses the BLKGETSIZE64 ioctl which returns
> bdev->bi_inode->i_size, where as /proc/partitions uses get_capacity
> which uses disk->capacity, so there is some room for them to return
> different values... Except that on open, it calls
>    bd_set_size(bdev, (loff_t)get_capacity(disk)<<9);
> which makes sure the two have the same value.
> 
> I cannot see where the size difference comes from.
> What does
>    /sbin/blockdev --getsize64
> report for each of the different devices, as compared to what
> /proc/partitions reports?

And add to that the output of `xfs_growfs -n <mntpt>` so we can
see what XFS really thinks the size of the filesystem is.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
