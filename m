Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1E09Tgu052737 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 18:09:29 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	K0OVUpqebSPPeEDz for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 16:09:27 -0800 (PST)
Date: Tue, 14 Feb 2012 11:09:24 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120214000924.GF14132@dastard>
References: <4F394116.8080200@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F394116.8080200@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 05:57:58PM +0100, Richard Ems wrote:
> Hello list !
> 
> I ran a "find dir" on one directory with 11 million files and dirs in it
> and it took 100 minutes. Is this a "normal" run time to be expected?

It certainly can be, depending on the way the directory is
fragmented, how sequential the inodes the directory references are
how slow the seek time of your disks are.

Just to put this in context, a directory with 11 million entries
with an average of 20 bytes per name results in roughly *350MB* of
directory data. That's likely to be fragmented into single 4k
blocks, so reading the entire directory contents will take you
something like 75,000 IOs.

If you then have to randomly read each of those 11 million inodes.
Assume we get a 50% hit rate (i.e. good!), we're reading 16 inodes
per IO.  That brings it down to about 680,000 IOs to read all the
inodes. So to read all the directory entries and inodes, you're
looking at about 750,000 IOs.

Given you have SATA drives, an average seek time of 5ms would be
pretty good. that gives 3,500,000ms of IO time to do all that IO.
That's just under an hour. Given that the IO is mostly serialised,
with CPU time between each IO and the io times will vary a bit, as
will cache hit rates, then taking 100 minutes to run find across the
directory is about right for your given storage.

> I am running openSUSE 12.1, kernel 3.1.9-1.4-default. The 20 TB XFS
> partition is 100% full

Running filesystems to 100% full is always a bad idea - it causes
significant increases in fragementation of both data and metadata
compared to a filesystem that doesn't get past ~90% full.

> and is on an external InforTrend RAID system with
> 24 x 1 TB SATA HDDs on RAID 6 with one hot-spare HDD, so 21 data discs
> plus 2 parity discs plus 1 hot-spare disc. The case is connected through
> SCSI.
> 
> The system was not running anything else on that discs and the load on
> the server was around 1 because of only this one find command running.
> 
> I am asking because I am seeing very long times while removing big
> directory trees. I thought on kernels above 3.0 removing dirs and files
> had improved a lot, but I don't see that improvement.

You won't if the directory traversal is seek bound and that is the
limiting factor for performance.

> This is a backup system running dirvish, so most files in the dirs I am
> removing are hard links. Almost all of the files do have ACLs set.

The unlink will have an extra IO to read per inode - the out-of-line
attribute block, so you've just added 11 million IOs to the 800,000
the traversal already takes to the unlink overhead. So it's going to
take roughly ten hours because the unlink is gong to be read IO seek
bound....

Christophs suggestions to use larger inodes to keep the attribute
data inline is a very good one - whenever you have a workload that
is attribute heavy you should use larger inodes to try to keep the
attributes in-line if possible. The down side is that increasing the
inode size increases the amount of IO required to read/write inodes,
though this typically isn't a huge penalty compared to the penalty
of out-of-line attributes.

Also, for large directories like this (millions of entries) you
should also consider using a larger directory block size (mkfs -n
size=xxxx option) as that can be scaled independently to the
filesystem block size. This will significantly decrease the amount
of IO and fragmentation large directories cause. Peak modification
performance of small directories will be reduced because larger
block size directories consume more CPU to process, but for large
directories performance will be significantly better as they will
spend much less time waiting for IO.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
