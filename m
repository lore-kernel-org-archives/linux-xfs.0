Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Mar 2008 17:08:00 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m2A07m6Q014035
	for <xfs@oss.sgi.com>; Sun, 9 Mar 2008 17:07:52 -0700
Date: Mon, 10 Mar 2008 11:08:09 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
Message-ID: <20080310000809.GU155407@sgi.com>
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com> <20080213214551.GR155407@sgi.com> <1a4a774c0803050553h7f6294cfq41c38f34ea92ceae@mail.gmail.com> <1a4a774c0803060310w2642224w690ac8fa13f96ec@mail.gmail.com> <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a4a774c0803070319j1eb8790ek3daae4a16b3e6256@mail.gmail.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian =?iso-8859-1?Q?R=F8snes?= <christian.rosnes@gmail.com>
Cc: xfs@oss.sgi.com

On Fri, Mar 07, 2008 at 12:19:28PM +0100, Christian Røsnes wrote:
> >  Actually, a single mkdir command is enough to trigger the filesystem
> >  shutdown when its 99% full (according to df -k):
> >
> >  /data# mkdir test
> >  mkdir: cannot create directory `test': No space left on device

Ok, that's helpful ;)

So, can you dump the directory inode with xfs_db? i.e.

# ls -ia /data

The directory inode is the inode at ".", and if this is the root of
the filesystem it will probably be 128.

Then run:

# xfs_db -r -c 'inode 128' -c p /dev/sdb1

> >  --------
> >  meta-data=/dev/sdb1              isize=512    agcount=16, agsize=4476752 blks
> >          =                       sectsz=512   attr=0
> >  data     =                       bsize=4096   blocks=71627792, imaxpct=25
> >          =                       sunit=16     swidth=32 blks, unwritten=1
> >  naming   =version 2              bsize=4096
> >  log      =internal               bsize=4096   blocks=32768, version=2
> >          =                       sectsz=512   sunit=16 blks, lazy-count=0
> >  realtime =none                   extsz=65536  blocks=0, rtextents=0
> >
> >  xfs_db -r -c 'sb 0' -c p /dev/sdb1
> >  ----------------------------------
.....
> >  fdblocks = 847484

Apparently there are still lots of free blocks. I wonder if you are out of
space in the metadata AGs.

Can you do this for me:

-------
#!/bin/bash

for i in `seq 0 1 15`; do
	echo freespace histogram for AG $i
	xfs_db -r -c "freesp -bs -a $i" /dev/sdb1
done
------

> Instrumenting the code, I found that this occurs on my system when I
> do a 'mkdir /data/test' on the partition in question:
> 
> in xfs_mkdir  (xfs_vnodeops.c):
> 
>   error = xfs_dir_ialloc(&tp, dp, mode, 2,
>                         0, credp, prid, resblks > 0,
>                 &cdp, NULL);
> 
>         if (error) {
>                 if (error == ENOSPC)
>                         goto error_return;   <=== this is hit and then
> execution jumps to error_return
>                 goto abort_return;
>         }

Ah - you can ignore my last email, then. You're already one step ahead
of me ;)

This does not appear to be the case I was expecting, though I can
see how we can get an ENOSPC here with plenty of blocks free - none
are large enough to allocate an inode chunk. What would be worth
knowing is the value of resblks when this error is reported.

This tends to imply we are returning an ENOSPC with a dirty
transaction. Right now I can't see how that would occur, though
the fragmented free space is something I can try to reproduce with.

> Is this the correct behavior for this type of situation: mkdir command
> fails due to no available space on filesystem,
> and xfs_mkdir goes to label error_return  ? (And after this the
> filesystem is shutdown)

The filesystem should not be shutdown here. We need to trace through
further to the source of the error....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
