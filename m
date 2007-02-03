Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 03 Feb 2007 15:39:38 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l13NdVqw029755
	for <xfs@oss.sgi.com>; Sat, 3 Feb 2007 15:39:33 -0800
Date: Sun, 4 Feb 2007 10:38:28 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS "no space left" problem
Message-ID: <20070203233828.GD44411608@melbourne.sgi.com>
References: <20070203183723.GA1652@dunno.espix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070203183723.GA1652@dunno.espix.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: wildcat <wildcat@espix.org>
Cc: xfs@oss.sgi.com

On Sat, Feb 03, 2007 at 07:37:23PM +0100, wildcat wrote:
> Hi dear list,
> 
> 
> I recently migrated a 1.3Tbyte partition from reiserfs to XFS.
> As the 1.3Tb partition was full, my idea was to shrink reiserfs
> partition of 100Gig at a time, and then grow the XFS one.

So you've filled up the lower terabyte of the partition
before you added the space above 1TB. The problem
is almost certainly going to be that there's no room left
to allocate inodes below the 1TB mark (32 bit inode filesystem)
because all that space is taken up by data....

> dunno jail2 # xfs_info /jail2
> meta-data=/dev/crypt/data        isize=256    agcount=188,
> agsize=1638400 blks
>          =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=306708480,
> imaxpct=25
>          =                       sunit=0      swidth=0 blks, unwritten=1
> naming   =version 2              bsize=4096  
> log      =internal               bsize=4096   blocks=12800, version=1
>          =                       sectsz=512   sunit=0 blks
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 
> dunno / # xfs_db /dev/crypt/data 
> xfs_db> frag
> actual 140099, ideal 134926, fragmentation factor 3.69%
> xfs_db> freesp
>    from      to extents  blocks    pct
>       1       1     801     801   0.00
>       2       3       2       5   0.00
>      32      63       2      89   0.00
>     128     255       3     517   0.00
>     256     511       4    1676   0.00
>     512    1023       5    3776   0.01
>    1024    2047       7   10765   0.03
>  262144  524287      23 9200216  26.21
> 1048576 1638400      16 25888649  73.74
> xfs_db> 

Mostly large blocks. I bet they are all in AGs above the 1TB mark.
One thing you can do is look at the freespace per AG:

# for ag in `seq 0 1 188`; do
> echo freespace in AG $ag
> xfs_db ­r -c "freesp -s -a $ag" /dev/crypt/data | grep "total free"
> done

And see how many of the AGs below 1TB (~6.4GB per AG, so those below about
about AG 160) have no free space. To allocate new inodes you need a contiguous
extent of 16k plus another 4 free blocks, so you need at _least_ 8 free
blocks in an AG to allocate a new inode chunk on disk.

If this is the case, then you need to delete some files to get space
free below 1TB for more inodes and then copy a large file or two so
they are moved above the 1TB mark, then remove the original copy
to make space for inodes below 1TB.

Or get a 64bit machine and use inode64. ;)

HTH.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
