Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BE6947F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 19:17:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 50003AC002
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 17:17:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dqznXW1z2p7JDW6z for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 17:17:46 -0700 (PDT)
Date: Wed, 28 Oct 2015 11:17:44 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Speeding up xfs_repair on filesystem with millions of inodes
Message-ID: <20151028001744.GO19199@dastard>
References: <562F699E.2050002@dermichi.com> <20151027193855.GM8773@dastard>
	<562FFFF7.4010908@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <562FFFF7.4010908@dermichi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Oct 27, 2015 at 11:51:35PM +0100, Michael Weissenbacher wrote:
> Hi Dave!
> First of all, today i cancelled the running xfs_repair (CTRL-C) and
> upped the system RAM from 8GB to 16GB - the maximum possible with this
> hardware.
> 
> Dave Chinner wrote:
> > It's waiting on inode IO to complete in memory reclaim. I'd say you
> > have a problem with lots of dirty inodes in memory and very slow
> > writeback due to using something like RAID5/6 (this can be
> > *seriously* slow as mentioned recently here:
> > http://oss.sgi.com/archives/xfs/2015-10/msg00560.html).
> Unfortunately, this is a rather slow RAID-6 setup with 7200RPM disks.
> However, before the power loss occurred it performed quite OK for our
> use case and without any hiccups. But some time after the power loss
> some "rm" commands hung and didn't proceed at all. There was no CPU
> usage and there was hardly any I/O on the file system. That's why I
> suspected some sort of corruption.

Maybe you have a disk that is dying. Do your drives have TLER
enabled on them?

> Dave Chinner wrote:
> > Was it (xfs_repair) making progress, just burning CPU, or was it just hung?
> > Attaching the actual output of repair is also helpful, as are all
> > the things here:
> > ...
> The xfs_repair seemed to be making progress, albeit very very slowly. In
> iotop i saw about 99% I/O usage on kswapd0. Looking at the HDD LED's of
> the array, i could see that there was hardly any access to it at all
> (only once about every 10-15 seconds).

kswapd is tryingto reclaim kernel memory, which has nothing directly
to do with xfs_repair IO or cpu usage. Unless, of course, it is
trying to do reclaim for grab more memory for xfs_repair...

> I didn't include xfs_repair output, since it showed nothing unusual.
> ---snip---
> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>         - zero log...
>         - scan filesystem freespace and inode maps...
>         - found root inode chunk
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         ...
>         - agno = 14
>         - process newly discovered inodes...
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         ...
>         - agno = 14
> Phase 5 - rebuild AG headers and trees...
>         - reset superblock...
> Phase 6 - check inode connectivity...
>         - resetting contents of realtime bitmap and summary inodes
>         - traversing filesystem ...
> ---snip---
> (and sitting there for about 72 hours)

It really hasn't made much progress if it's still traversing the fs
after 72 hours.

> Dave Chinner wrote:
> > If repair is swapping, then adding more RAM and/or faster swap space
> > will help. There is nothing that you can tweak that changes the
> > runtime or behaviour of phase 6 - it is single threaded and requires
> > traversal of the entire filesystem directory heirarchy to find all
> > the disconnected inodes so they can be moved to lost+found. And it
> > does write inodes, so if you have a slow SATA RAID5/6...
> Ok, so if i understand you correctly, none of the parameters will help
> for phase 6? I know that RAID-6 has slow write characteristics. But in
> fact I didn't see any writes at all with iotop and iostat.

If kswapd is doing all the work, then it's essentially got no memory
available. I would add significantly more swap space as well (e.g.
add swap files to the root filesystem - you can do this while repair
is running, too). If there's sufficient swap space, then repair
should use it fairly efficiently - it doesn't tend to thrash swap
because most of it's memory usage is for information that is only
accessed once per phase or is parked until it is needed in a later
phase so it doesn't need to be read from disk again...

> Dave Chinner wrote:
> > 
> > See above. Those numbers don't include reclaimable memory like the
> > buffer cache footprint, which is affected by bhash and concurrency....
> > 
> As said above, i did now double the RAM of the machine from 8GB to 16GB.
> Now I started xfs_repair again with the following options. I hope that
> the verbose output will help to understand better what's actually going on.
> # xfs_repair -m 8192 -vv /dev/sdb1
> 
> Besides, is it wise to limit the memory with "-m" to keep the system
> from swapping or should I be better using the defaults (which would use
> 75% of RAM)?

Defaults, but it's really only a guideline for cache sizing. If
repair needs more memory to store metadata it is validating (like
the directory structure) then it will consume as much as it needs.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
