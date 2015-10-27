Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A6F8E7F37
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 14:39:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 96E49304032
	for <xfs@oss.sgi.com>; Tue, 27 Oct 2015 12:39:27 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	OCjTztlDrotppZzI for <xfs@oss.sgi.com>;
	Tue, 27 Oct 2015 12:39:22 -0700 (PDT)
Date: Wed, 28 Oct 2015 06:38:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Speeding up xfs_repair on filesystem with millions of inodes
Message-ID: <20151027193855.GM8773@dastard>
References: <562F699E.2050002@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <562F699E.2050002@dermichi.com>
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

On Tue, Oct 27, 2015 at 01:10:06PM +0100, Michael Weissenbacher wrote:
> Hi List!
> I have an xfs filesystem which probably suffered a corruption due to a
> bad UPS (even though the RAID controller has a good BBU). At the time
> the power loss occurred the filesystem was mounted with the "nobarrier"
> option.
> 
> We noticed the problem several weeks later, when some rsync-based backup
> jobs started to hang for days without progress when doing a simple "rm".
> This was accompanied by some messages in dmesg like this one:

[cleanup line-wrapped paste mess]

>  INFO: task kswapd0:38 blocked for more than 120 seconds.
>  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>  kswapd0         D ffffffff8180bea0     0    38      2 0x00000000
>   ffff880225f73968 0000000000000046 ffff880225c42e20 0000000000013180
>   ffff880225f73fd8 ffff880225f72010 0000000000013180 0000000000013180
>   ffff880225f73fd8 0000000000013180 ffff880225c42e20 ffff88022611dc40
>  Call Trace:
>   [<ffffffff8166a8e9>] schedule+0x29/0x70
>   [<ffffffff8166a9bc>] io_schedule+0x8c/0xd0
>   [<ffffffff8126c5ef>] __xfs_iflock+0xdf/0x110
>   [<ffffffff8106b070>] ?  autoremove_wake_function+0x40/0x40
>   [<ffffffff812273b4>] xfs_reclaim_inode+0xc4/0x330
>   [<ffffffff81227816>] xfs_reclaim_inodes_ag+0x1f6/0x330
>   [<ffffffff81227983>] xfs_reclaim_inodes_nr+0x33/0x40
>   [<ffffffff81230085>] xfs_fs_free_cached_objects+0x15/0x20
>   [<ffffffff8117943e>] prune_super+0x11e/0x1a0
>   [<ffffffff8112903f>] shrink_slab+0x19f/0x2d0
>   [<ffffffff8112c3c8>] kswapd+0x698/0xae0
>   [<ffffffff8106b030>] ?  wake_up_bit+0x40/0x40
>   [<ffffffff8112bd30>] ?  zone_reclaim+0x410/0x410
>   [<ffffffff8106a97e>] kthread+0xce/0xe0
>   [<ffffffff8106a8b0>] ?  kthread_freezable_should_stop+0x70/0x70
>   [<ffffffff8167475c>] ret_from_fork+0x7c/0xb0
>   [<ffffffff8106a8b0>] ?  kthread_freezable_should_stop+0x70/0x70

It's waiting on inode IO to complete in memory reclaim. I'd say you
have a problem with lots of dirty inodes in memory and very slow
writeback due to using something like RAID5/6 (this can be
*seriously* slow as mentioned recently here:
http://oss.sgi.com/archives/xfs/2015-10/msg00560.html).

> So i decided to unmount the fs and run xfs_repair on it. Unfortunately,
> after almost a week, this hasn't finished yet. It seems to do so much
> swapping that it hardly makes any progress. Currently it has been in
> Phase 6 (traversing filesystem) for several days.

Was it making progress, just burning CPU, or was it just hung?
Attaching the actual output of repair is also helpful, as are all
the things here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

> I found a thread suggesting to add an ssd as swap drive, which i did
> yesterday. I also added the "-P" option to xfs_repair since it helped in
> some cases similar in the past.

"-P" slows xfs_repair down greatly.

> I am using the latest xfs_repair version 3.2.4, compiled myself.
> 
> The filesystem is 16TB in size and contains about 150 million inodes.
> The machine has 8GB of RAM available.

http://xfs.org/index.php/XFS_FAQ#Q:_Which_factors_influence_the_memory_usage_of_xfs_repair.3F

> The kernel version at the time of the power loss was 3.10.44 and was
> upgraded to 3.10.90 afterwards.
> 
> My questions are the following:
> - Is there anything else i could try to speed up the progress besides
> beefing up the RAM of the machine? Currently it has 8GB which is not
> very much for the task i suppose. I read about the "-m" option and about

If repair is swapping, then adding more RAM and/or faster swap space
will help. There is nothing that you can tweak that changes the
runtime or behaviour of phase 6 - it is single threaded and requires
traversal of the entire filesystem directory heirarchy to find all
the disconnected inodes so they can be moved to lost+found. And it
does write inodes, so if you have a slow SATA RAID5/6...

> "-o bhash=" but i am unsure if they could help in this case.

It can, but increasing it makes repair use more memory. You might
like to try "-o ag_stride=-1" to reduce phase 2-5 memory usage, but
that does not affect phase 6 behaviour...

> - Are there any rough guidelines on how much RAM is needed for
> xfs_repair on a given filesystem? How does it depend on the number of
> inodes or on the size of the file system?

See above. Those numbers don't include reclaimable memory like the
buffer cache footprint, which is affected by bhash and concurrency....

> - How long could the quota check on mount take when the repair is
> finished (the filesystem is mounted with usrquota, grpquota).

As long as it takes to read all the inodes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
