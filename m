Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E73E67F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 19:02:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C45EC304039
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 17:02:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hmclijtFkOauRqJQ for <xfs@oss.sgi.com>;
	Mon, 20 May 2013 17:02:12 -0700 (PDT)
Date: Tue, 21 May 2013 10:02:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130521000208.GF24543@dastard>
References: <20130517104529.GA12490@luxor.wired.org>
	<20130519011354.GE6495@dastard>
	<20130520170710.GA2591@luxor.wired.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130520170710.GA2591@luxor.wired.org>
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
To: Paolo Pisati <p.pisati@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 20, 2013 at 07:07:10PM +0200, Paolo Pisati wrote:
> On Sun, May 19, 2013 at 11:13:54AM +1000, Dave Chinner wrote:
> > 
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1176977
> > 
> > which contains information that everyone looking at the problem
> > should know. Also, any progress on testing the backported fix
> > mentioned in the bug?
> 
> the problem with the 'fix' is that it prevents xfs from erroring out, but
> swift-test fails regardless after ~25% of fs usage and i think having a bold
> 'xfs error' and a stack trace is more useful.

I think your logic is misguided.  There's a major difference
between ENOSPC and a filesystem shutdown. After a shutdown you need
to unmount, remount, and then work out what didn't make it to disk
before you can restart.

Not to mention that the  ENOMEM that triggers the shutdown is highly
system dependent - it will occur at different times on different
machines and will be highly unpredictable. That's not a good thing.

Compare that to a plain ENOSPC error: you can just remove files and
keep going.

> > You're testing swift benchmark which is probably a small file
> > workload with large attributes attached.  It's a good chance that
> > the workload is fragmenting free space because swift is doing bad
> > things to allocation patterns.  It's almost certainly exacerbated by
> > the tiny filesystem you are using (1.5GB), but you can probably work
> > around this problem for now with allocsize=4096.
> 
> ok, i repartitioned my disk but i can still reprodue it fairly easily:
> 
> df -h:
> /dev/sda6       216G  573M  215G   1% /mnt/sdb1
> 
> df -i:
> /dev/sda6      56451072 235458 56215614    1% /mnt/sdb1
> 
> dmesg:
> ...
> [  363.130877] XFS (sda6): Mounting Filesystem
> [  363.146708] XFS (sda6): Ending clean mount
> [ 3055.520769] alloc_vmap_area: 18 callbacks suppressed
> [ 3055.520783] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
> [ 3055.520817] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
> [ 3055.520845] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
> [ 3055.520861] XFS (sda6): xfs_buf_get: failed to map pages

Which is your ENOMEM error, not an ENOSPC error. So the larger
filesystem meant you didn't hit the ENOSPC problem like I suspected
it would....

> > I've got a fix that I'm testing for the underlying cause of the
> > problem I'm aware of with this workload, but I'll need more
> > information about your storage/filesystem config to confirm it is
> > the same root cause first. Can you include the info from here:

And that fix I mentioned will be useless if you don't apply the
patch that avoids the vmap allocation problem....

> > http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> 
> flag@c13:~$ uname -a
> Linux c13 3.5.0-30-highbank #51-Ubuntu SMP Tue May 14 22:57:15 UTC 2013 armv7l armv7l armv7l GNU/Linux
> 
> lag@c13:~$ xfs_repair -V
> xfs_repair version 3.1.7
> 
> armhf highbank node, 4 cores, 4GB mem
> 
> flag@c13:~$ cat /proc/meminfo
> MemTotal:        4137004 kB
> MemFree:         2719752 kB
> Buffers:           39688 kB
> Cached:           580508 kB
> SwapCached:            0 kB
> Active:           631136 kB
> Inactive:         204552 kB
> Active(anon):     215520 kB
> Inactive(anon):      232 kB
> Active(file):     415616 kB
> Inactive(file):   204320 kB
> Unevictable:           0 kB
> Mlocked:               0 kB
> HighTotal:       3408896 kB
> HighFree:        2606516 kB
> LowTotal:         728108 kB

Oh, there's a likely cause of the vmalloc issue.  You have 3.4GB of
high memory, which means the kernel only has 700MB of low memory for
slab caches, vmap regions, etc.

An ia32 box has, by default 960MB of low memory which will be why
you are seeing this more frequently than anyone using an ia32
machine. And an ia32 machine can be configured with 2G/2G or 3G/1G
kernel/user address space splits, so most vmalloc problems can
be worked around.

> Slab:             317000 kB
> SReclaimable:     230392 kB
> SUnreclaim:        86608 kB

And so you have 300MB in slab caches in low memory

> KernelStack:        2192 kB
> PageTables:         2284 kB
> NFS_Unstable:          0 kB
> Bounce:                0 kB
> WritebackTmp:          0 kB
> CommitLimit:    10446864 kB
> Committed_AS:    1049624 kB
> VmallocTotal:     245760 kB
> VmallocUsed:        2360 kB
> VmallocChunk:     241428 kB

and 240MB in vmalloc space. so there's not much left of that 700MB
of low memory space. So, you really need that vmap fix, and you need
to configure your kernel with more low memory space.

> > As well the freespace info that Jeff asked for?
> 
> flag@c13:~$ sudo xfs_db -r "-c freesp -s" /dev/sda6 
>    from      to extents  blocks    pct
>       1       1     423     423   0.00
>       2       3     897    2615   0.01
>       4       7     136     915   0.00
>       8      15   24833  365797   0.86
> 8388608 14112768       3 41928421  99.13
> total free extents 26292
> total free blocks 42298171
> average free extent size 1608.78

We need this information after the ENOSPC error occurs, not soon
after mkfs or after the ENOMEM error. If this is after ENOSPC,
please unmount the filesystem, drop caches and rerun the freesp
command...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
