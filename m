Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:39799 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751704AbeAHWB4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jan 2018 17:01:56 -0500
Date: Tue, 9 Jan 2018 09:01:39 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Growing RAID10 with active XFS filesystem
Message-ID: <20180108220139.GB16421@dastard>
References: <f289da8f-96ec-7db4-abb1-b151d553c088@gmail.com>
 <20180108192607.GS5602@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180108192607.GS5602@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs.pkoch@dfgh.net, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org

[cc linux-raid, like the OP intended to do]

[For XFS folk, the original linux-raid thread is here:
 https://marc.info/?l=linux-raid&m=151525346428531&w=2 ]

On Mon, Jan 08, 2018 at 11:26:07AM -0800, Darrick J. Wong wrote:
> On Mon, Jan 08, 2018 at 08:08:09PM +0100, xfs.pkoch@dfgh.net wrote:
> > Dear Linux-Raid and Linux-XFS experts:
> > 
> > I'm posting this on both the linux-raid and linux-xfs
> > mailing list as it's not clear at this point wether
> > this is a MD- od XFS-problem.
> > 
> > I have described my problem in a recent posting on
> > linux-raid and Wol's conclusion was:
> > 
> > >In other words, one or more of the following three are true :-
> > >1) The OP has been caught by some random act of God
> > >2) There's a serious flaw in "mdadm --grow"
> > >3) There's a serious flaw in xfs
> > >
> > >Cheers,
> > >Wol
> > 
> > There's very important data on our RAID10 device but I doubt
> > it's important enough for God to take a hand into our storage.
> > 
> > But let me first summarize what happened and why I believe that
> > this is an XFS-problem:

The evidence doesn't support that claim.

tl;dr: block device IO errors occurred immediately after a MD
reshape started and the filesystem simply reported and responded
appropriately to those MD device IO errors.

> > Machine running Linux 3.14.69 with no kernel-patches.

So really old kernel....

> > XFS filesystem was created with XFS userutils 3.1.11.

And a really old userspace, too.

> > I did a fresh compile of xfsprogs-4.9.0 yesterday when
> > I realized that the 3.1.11 xfs_repair did not help.
> > 
> > mdadm is V3.3
> > 
> > /dev/md5 is a RAID10-device that was created in Feb 2013
> > with 10 2TB disks and an ext3 filesystem on it. Once in a
> > while I added two more 2TB disks. Reshaping was done
> > while the ext3 filesystem was mounted. Then the ext3
> > filesystem was unmounted resized and mounted again. That
> > worked until I resized the RAID10 from 16 to 20 disks and
> > realized that ext3 does not support filesystems >16TB.
> > 
> > I switched to XFS and created a 20TB filesystem. Here are
> > the details:
> > 
> > # xfs_info /dev/md5
> > meta-data=/dev/md5               isize=256    agcount=32, agsize=152608128 blks
> >           =                       sectsz=512   attr=2
> > data     =                       bsize=4096   blocks=4883457280, imaxpct=5
> >           =                       sunit=128    swidth=1280 blks
> > naming   =version 2              bsize=4096   ascii-ci=0
> > log      =internal               bsize=4096   blocks=521728, version=2
> >           =                       sectsz=512   sunit=8 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > Please notice: Ths XFS-filesystem has a size of
> > 4883457280*4K = 19,533,829,120K
> > 
> > On saturday I tried to add two more 2TB disks to the RAID10
> > and the XFS filesystem was mounted (and in medium use) at that
> > time. Commands were:
> > 
> > # mdadm /dev/md5 --add /dev/sdo
> > # mdadm --grow /dev/md5 --raid-devices=21

You added one device, not two. That's a recipe for a reshape that
moves every block of data in the device to a different location.

> > # mdadm -D /dev/md5
> > /dev/md5:
> >          Version : 1.2
> >    Creation Time : Sun Feb 10 16:58:10 2013
> >       Raid Level : raid10
> >       Array Size : 19533829120 (18628.91 GiB 20002.64 GB)
> >    Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
> >     Raid Devices : 21
> >    Total Devices : 21
> >      Persistence : Superblock is persistent
> > 
> >      Update Time : Sat Jan  6 15:08:37 2018
> >            State : clean, reshaping
> >   Active Devices : 21
> > Working Devices : 21
> >   Failed Devices : 0
> >    Spare Devices : 0
> > 
> >           Layout : near=2
> >       Chunk Size : 512K
> > 
> >   Reshape Status : 1% complete
> >    Delta Devices : 1, (20->21)

Yup, 21 devices in a RAID 10. That's a really nasty config for
RAID10 which requires an even number of disks to mirror correctly.
Why does MD even allow this sort of whacky, sub-optimal
configuration?

[....]

> > Immediately after the RAID10 reshape operation started the
> > XFS-filesystem reported I/O-errors and was severly damaged.
> > I waited for the reshape operation to finish and tried to repair
> > the filesystem with xfs_repair (version 3.1.11) but xfs_repair
> > crashed, so I tried 4.9.0-version aif xfs_reapair with no luck
> > either.

[...]

> > Here are the relevant log messages:
> > 
> > >Jan  6 14:45:00 backup kernel: md: reshape of RAID array md5
> > >Jan  6 14:45:00 backup kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> > >Jan  6 14:45:00 backup kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
> > >Jan  6 14:45:00 backup kernel: md: using 128k window, over a total of 19533829120k.
> > >Jan  6 14:45:00 backup kernel: XFS (md5): metadata I/O error: block 0x12c08f360 ("xfs_trans_read_buf_map") error 5 numblks 16
> > >Jan  6 14:45:00 backup kernel: XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> > >Jan  6 14:45:00 backup kernel: XFS (md5): metadata I/O error: block 0x12c08f360 ("xfs_trans_read_buf_map") error 5 numblks 16
> > >Jan  6 14:45:00 backup kernel: XFS (md5): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
> > >... hundreds of the above XFS-messages deleted
> > >Jan  6 14:45:00 backup kernel: XFS (md5): Log I/O Error Detected.  Shutting down filesystem
> > >Jan  6 14:45:00 backup kernel: XFS (md5): Please umount the filesystem and rectify the problem(s)

IOWs, within /a second/ of the reshape starting, the active, error
free XFS filesystem received hundreds of IO errors on both read and
write IOs from the MD device and shut down the filesystem.

XFS is just the messenger here - something has gone badly wrong at
the MD layer when the reshape kicked off.

> > Please notice: no error message about hardware-problems.
> > All 21 disks are fine and the next messages from the
> > md-driver was:
> > 
> > >Jan  7 02:28:02 backup kernel: md: md5: reshape done.
> > >Jan  7 02:28:03 backup kernel: md5: detected capacity change from 20002641018880 to 21002772807680

Ok, so the reshape took about 12 hours to run, and it grew to 21TB.
A 12 hour long operation is what I'd expect for a major
rearrangement of every block in the MD device....

> > I'm wondering about one thing: the first xfs message is about a
> > meatadata I/O error on block 0x12c08f360. Since the xfs filesystem
> 
> I'm sure Dave will have more to say about this, but...
> 
> "block 0x12c08f360" == units of sectors, not fs blocks.
> 
> IOWs, this IO error happened at offset 2,577,280,712,704 (~2.5TB)

That's correct, Darrick - it's well within the known fileysetm
bounds.

> XFS doesn't change the fs size until you tell it to (via growfs);
> even if the underlying storage geometry changes, XFS won't act on it
> until the admin tells it to.
> 
> What did xfs_repair do?

Yeah, I'd like to see that output (from 4.9.0) too, but experience
tells me it did nothing helpful w.r.t data recovery from a badly
corrupted device.... :/

> > This looks like a severe XFS-problem to me.

I'll say this again: tHe evidence does not support that conclusion.

XFS has done exactly the right thing to protect the filesystem when
fatal IO errors started occurring at the block layer: it shut down
and stopped trying to modify the filesystem.  What caused those
errors and any filesystem and/or data corruption to occur, OTOH, has
nothing to do with XFS.

> > But my hope is that all the data taht was within the filesystem
> > before Jan 6 14:45 is not involved in the corruption. If xfs
> > started to use space beyond the end of the underlying raid
> > device this should have affected only data that was created,
> > modified or deleted after Jan 6 14:45.

Experience tells me that you cannot trust a single byte of data in
that block device now, regardless of it's age and when it was last
modified. The MD reshape may have completed, but what it did is
highly questionable and you need to verify the contents of every
single directory and file.

When this sort of things happens, often the best data recovery
strategy (i.e. fastest and most reliable) is to simply throw
everything away and restore from known good backups...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
