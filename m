Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7K20K5S056335 for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 21:00:20 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CF571386396
	for <xfs@oss.sgi.com>; Fri, 19 Aug 2011 19:02:39 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	LF4vY5cAFB9JqOHw for <xfs@oss.sgi.com>;
	Fri, 19 Aug 2011 19:02:39 -0700 (PDT)
Date: Sat, 20 Aug 2011 12:00:04 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: bug: xfs_repair becomes very slow when file system has a large
	sparse file
Message-ID: <20110820020004.GG32358@dastard>
References: <4E4E9131.2050807@scalableinformatics.com>
	<20110820002657.GF32358@dastard>
	<4E4F021D.50000@scalableinformatics.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E4F021D.50000@scalableinformatics.com>
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
To: Joe Landman <landman@scalableinformatics.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 19, 2011 at 08:38:53PM -0400, Joe Landman wrote:
> On 8/19/2011 8:26 PM, Dave Chinner wrote:
> >On Fri, Aug 19, 2011 at 12:37:05PM -0400, Joe Landman wrote:
> >>(If you prefer we file this on a bug reporting system, please let me
> >>know where and I'll do this).
> >>
> >>Scenario:  xfs_repair being run against an about 17TB volume,
> >>containing 1 large sparse file.  Logical size of 7 PB, actual size,
> >>a few hundred GB.
> >>
> >>Metadata:  Kernel = 2.6.32.41, 2.6.39.4, and others. Xfstools 3.1.5.
> >>Hardware RAID ~17TB LUN.  Base OS: Centos 5.6 + updates + updated
> >>xfs tools + our kernels.  Using external journal on a different
> >>device
> >>
> >>What we observe:
> >>
> >>Running xfs_repair
> >>
> >>	xfs_repair -l /dev/md2 -vv /dev/sdd2
> >
> >can you post the actual output of xfs_repair?
> 
> [root@jr4-2 ~]# xfs_repair -l /dev/md2 -vv /dev/sdd2
> Phase 1 - find and verify superblock...
> - max_mem = 37094400, icount = 1346752, imem = 5260, dblock =
> 4391112384, dmem = 2144097
> - block cache size set to 4361880 entries
> Phase 2 - using external log on /dev/md2
> - zero log...
> zero_log: head block 126232 tail block 126232
> - scan filesystem freespace and inode maps...
> agf_freeblks 11726908, counted 11726792 in ag 1
> sb_ifree 2366, counted 2364
> sb_fdblocks 2111548832, counted 2111548716
> - found root inode chunk
> libxfs_bcache: 0x8804c0
> Max supported entries = 4361880
> Max utilized entries = 4474
> Active entries = 4474
> Hash table size = 545235
> Hits = 0
> Misses = 4474
> Hit ratio = 0.00
> MRU 0 entries = 4474 (100%)
> MRU 1 entries = 0 ( 0%)
> MRU 2 entries = 0 ( 0%)
> MRU 3 entries = 0 ( 0%)
> MRU 4 entries = 0 ( 0%)
> MRU 5 entries = 0 ( 0%)
> MRU 6 entries = 0 ( 0%)
> MRU 7 entries = 0 ( 0%)
> MRU 8 entries = 0 ( 0%)
> MRU 9 entries = 0 ( 0%)
> MRU 10 entries = 0 ( 0%)
> MRU 11 entries = 0 ( 0%)
> MRU 12 entries = 0 ( 0%)
> MRU 13 entries = 0 ( 0%)
> MRU 14 entries = 0 ( 0%)
> MRU 15 entries = 0 ( 0%)
> Hash buckets with 0 entries 541170 ( 0%)
> Hash buckets with 1 entries 3765 ( 84%)
> Hash buckets with 2 entries 242 ( 10%)
> Hash buckets with 3 entries 15 ( 1%)
> Hash buckets with 4 entries 36 ( 3%)
> Hash buckets with 5 entries 6 ( 0%)
> Hash buckets with 6 entries 1 ( 0%)
> Phase 3 - for each AG...
> - scan and clear agi unlinked lists...
> - process known inodes and perform inode discovery...
> - agno = 0
> bad magic number 0xc88 on inode 5034047
> bad version number 0x40 on inode 5034047
> bad inode format in inode 5034047
> correcting nblocks for inode 5034046, was 185195 - counted 0
> bad magic number 0xc88 on inode 5034047, resetting magic number
> bad version number 0x40 on inode 5034047, resetting version number
> bad inode format in inode 5034047
> cleared inode 5034047

That doesn't look good - something has trashed an inode cluster by
the look of it. Was this why you ran xfs_repair?

FWIW, do you know what the inode number of the large file was? I'm
wondering if it was in the same cluster as the above inode and so
was corrupted in some way that cause repair to head off into lala
land....

> >What is the CPU usage when this happens? How much memory do you
> 
> Very low.  The machine is effectively idle, user load of 0.01 or so.

OK, so repair wasn't burning up an entire CPU walking/searching
lists?

> >>This isn't a 7PB file system, its a 100TB file system across 3
> >>machines, roughly 17TB per brick or OSS.  The Gau-00000.rwf is
> >>obviously a sparse file, as could be seen with an ls -alsF
> >
> >What does du tell you about it?  xfs_io -f -c "stat"<large file>?
> >xfs_bmap -vp<large file>?
> 
> ls -alsF told me it was a few hundred GB.  Du gave a similar number.

Ok - the other commands, however, tell me more than just the disk
blocks used - they also tell me how many extents the file has and
how they were laid out, which is what I really need to know about
that sparse file. It will also help me recreate a file with a
similar layout to see if xfs_repair chokes on it here, or whether it
was something specific to a corruption encountered....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
