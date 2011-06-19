Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5JNNiQo081634 for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 18:23:44 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68F3A51EA27
	for <xfs@oss.sgi.com>; Sun, 19 Jun 2011 16:23:42 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	Lo7YvLWacJ7XTRoV for <xfs@oss.sgi.com>;
	Sun, 19 Jun 2011 16:23:42 -0700 (PDT)
Date: Mon, 20 Jun 2011 09:23:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: ENOSPC but df and df -i show free space
Message-ID: <20110619232339.GK561@dastard>
References: <20110619215039.GA17820@hexapodia.org>
	<20110619221852.GH561@dastard>
	<20110619225834.GY21778@hexapodia.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110619225834.GY21778@hexapodia.org>
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
To: Andy Isaacson <adi@hexapodia.org>
Cc: xfs@oss.sgi.com

On Sun, Jun 19, 2011 at 03:58:34PM -0700, Andy Isaacson wrote:
> On Mon, Jun 20, 2011 at 08:18:52AM +1000, Dave Chinner wrote:
> > > % touch /d1/tmp/foo
> > > touch: cannot touch `/d1/tmp/foo': No space left on device
> > > % df /d1
> > > Filesystem           1K-blocks      Used Available Use% Mounted on
> > > /dev/mapper/vg0-d1   943616000 904690332  38925668  96% /d1
> > 
> > Problems like this will occur if you run your filesystem at > 85-90%
> > full for extented periods....
> 
> Ah, yes, that's definitely been the case.  I grow the filesystem when it
> hits 95% utilization or thereabouts.  Hadn't realized that's such an
> awful use case for xfs.

No allocation algorithm is perfect in all circumstances. The
alogrithms in XFS tend to degrade when large contiguous freespace
regions are not available, resulting in more fragmentation of data
extents and subsequent freespace fragmentation when those files are
removed or defragmented. The algorithms will recover if you free up
enough space that large contiguous freespace extents re-form, but
that can require removing a large amount of data....

> > > % df -i /d1
> > > Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> > > /dev/mapper/vg0-d1   167509008 11806336 155702672    8% /d1
> > > % sudo xfs_growfs -n /d1
> > > meta-data=/dev/mapper/vg0-d1     isize=256    agcount=18, agsize=13107200 blks
> > >          =                       sectsz=512   attr=2
> > > data     =                       bsize=4096   blocks=235929600, imaxpct=25
> > >          =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0
> > > log      =internal               bsize=4096   blocks=25600, version=2
> > >          =                       sectsz=512   sunit=0 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > % grep d1 /proc/mounts
> > > /dev/mapper/vg0-d1 /d1 xfs rw,relatime,attr2,noquota 0 0
> > > 
> > > Obviously I'm missing something, but what?
> > 
> > Most likely is that you have no contiguous free space large enough
> > to create a new inode chunk.  using xfs_db to dump the freespace
> > size histogram will tell you if this is the case or not.
> 
> % sudo xfs_db -c freesp /dev/vg0/d1
>    from      to extents  blocks    pct
>       1       1  168504  168504   1.71
>       2       3     446    1135   0.01
>       4       7    5550   37145   0.38
>       8      15   49159  524342   5.33
>      16      31    1383   29223   0.30
> 2097152 4194303       1 2931455  29.78
> 4194304 8388607       1 6150953  62.49
> 
> I don't really grok that output.

It's the historgram of free space extent sizes. You have 168504
single free block regions (4k in size) in the filesystem, 446
between 8k and 12k (2-3 blocks), etc.

Inode allocation requires aligned 16k allocations (64x256 byte
inodes), so you need free extents in the 4-7 block range or larger,
which you appear to have so it should not be failing. Did you dump
this histogram while touch was giving ENOSPC errors?

Also, it might be worthwhile dumping the per-ag histograms (use a
for loop and the "freesp -a <x>" command) - it may be that certain
AGs are out of contiguous freespace and that is causing the issue...

FWIW, you shoul drun "echo 1 > /proc/sys/vm/drop_caches" before
running the xfsdb comand so that it is not reading stale metadata
from cache...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
