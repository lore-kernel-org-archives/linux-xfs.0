Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5JNsSn5087418 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 18:54:29 -0500
Received: from straum.hexapodia.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2336BDDBCC7
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 16:54:27 -0700 (PDT)
Received: from straum.hexapodia.org (straum.hexapodia.org [207.7.131.186]) by
	cuda.sgi.com with ESMTP id zRjpjToY4Qu85drj for
	<xfs@oss.sgi.com>; Sun, 19 Jun 2011 16:54:27 -0700 (PDT)
Date: Sun, 19 Jun 2011 16:55:18 -0700
From: Andy Isaacson <adi@hexapodia.org>
Subject: Re: ENOSPC but df and df -i show free space
Message-ID: <20110619235518.GA21778@hexapodia.org>
References: <20110619215039.GA17820@hexapodia.org>
	<20110619221852.GH561@dastard>
	<20110619225834.GY21778@hexapodia.org>
	<20110619232339.GK561@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110619232339.GK561@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 20, 2011 at 09:23:39AM +1000, Dave Chinner wrote:
> No allocation algorithm is perfect in all circumstances. The
> alogrithms in XFS tend to degrade when large contiguous freespace
> regions are not available, resulting in more fragmentation of data
> extents and subsequent freespace fragmentation when those files are
> removed or defragmented. The algorithms will recover if you free up
> enough space that large contiguous freespace extents re-form, but
> that can require removing a large amount of data....

Thanks for the background explanation!

> > > > % df -i /d1
> > > > Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> > > > /dev/mapper/vg0-d1   167509008 11806336 155702672    8% /d1
> > > > % sudo xfs_growfs -n /d1
> > > > meta-data=/dev/mapper/vg0-d1     isize=256    agcount=18, agsize=13107200 blks
> > > >          =                       sectsz=512   attr=2
> > > > data     =                       bsize=4096   blocks=235929600, imaxpct=25
> > > >          =                       sunit=0      swidth=0 blks
> > > > naming   =version 2              bsize=4096   ascii-ci=0
> > > > log      =internal               bsize=4096   blocks=25600, version=2
> > > >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > > % grep d1 /proc/mounts
> > > > /dev/mapper/vg0-d1 /d1 xfs rw,relatime,attr2,noquota 0 0
> > > > 
> > > > Obviously I'm missing something, but what?
> > > 
> > > Most likely is that you have no contiguous free space large enough
> > > to create a new inode chunk.  using xfs_db to dump the freespace
> > > size histogram will tell you if this is the case or not.
> > 
> > % sudo xfs_db -c freesp /dev/vg0/d1
> >    from      to extents  blocks    pct
> >       1       1  168504  168504   1.71
> >       2       3     446    1135   0.01
> >       4       7    5550   37145   0.38
> >       8      15   49159  524342   5.33
> >      16      31    1383   29223   0.30
> > 2097152 4194303       1 2931455  29.78
> > 4194304 8388607       1 6150953  62.49
> > 
> > I don't really grok that output.
> 
> It's the historgram of free space extent sizes. You have 168504
> single free block regions (4k in size) in the filesystem, 446
> between 8k and 12k (2-3 blocks), etc.

Ah, OK!  Now it makes sense.

> Inode allocation requires aligned 16k allocations (64x256 byte
> inodes), so you need free extents in the 4-7 block range or larger,
> which you appear to have so it should not be failing. Did you dump
> this histogram while touch was giving ENOSPC errors?

Yes, that was before I grew the filesystem again to get back to
a working state.  I killed all the processes using the filesystem,
unmounted it, and ran xfs_db.

> Also, it might be worthwhile dumping the per-ag histograms (use a
> for loop and the "freesp -a <x>" command) - it may be that certain
> AGs are out of contiguous freespace and that is causing the issue...

I've now grown the filesystem again to get it back into a working state;
it's obviously not "production" per se given my janky configuration, but
it is more convenient if I can create files. :)

It's a shame that we lost the chance to do more debugging though.

> FWIW, you shoul drun "echo 1 > /proc/sys/vm/drop_caches" before
> running the xfsdb comand so that it is not reading stale metadata
> from cache...

I unmounted the filesystem before running xfs_db, so it should be fine.
Didn't even occur to me that it might work to run xfs_db on a block
device that's mounted and active...

I did notice that the unmount command took a minute or two to complete.

-andy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
