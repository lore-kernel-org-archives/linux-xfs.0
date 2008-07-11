Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Jul 2008 16:37:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6BNbUmQ029816
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 16:37:30 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CC67DFE816
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 16:38:35 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id cHcac6LIPPlRgvdE for <xfs@oss.sgi.com>; Fri, 11 Jul 2008 16:38:35 -0700 (PDT)
Date: Sat, 12 Jul 2008 09:38:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs leaking?
Message-ID: <20080711233832.GH11558@disturbed>
References: <4877928A.1020008@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4877928A.1020008@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Jul 11, 2008 at 12:04:10PM -0500, Eric Sandeen wrote:
> after my  fill-the-1T-fs-with-20k-files test I tried an xfs_repair, and
> it was sorrowfully slow compared to e2fsck of ext4 - I stopped it after
> almost 2 hours, and only half complete.
> 
> I noticed that during the run, I was about out of memory (8G) and
> swapping badly.
> 
> So I unmounted the fs, dropped caches, and was astounded to find
> 10492540 buffer heads still in the slab caches.

Curious - that implies buffer heads aren't being freed. But
if the pages have been freed, then the bufferheads should have
been. Generic code or VM bug perhaps?

> This was all  on 2.6.26-rc2 (I need to update) and lazy-count=1, 1T fs,
> 32 ags, mounted with inode64, nobarriers, and maximal logbuf count & size.
> 
> Rebooted, let the fs_mark test run just a bit, then tried removing the
> xfs module because I forgot to load the one with dave's  fix, and:
> 
> slab error in kmem_cache_destroy(): cache `xfs_inode': Can't free all objects
> Pid: 3676, comm: rmmod Not tainted 2.6.26-rc2 #3
> 
> Call Trace:
>  [<ffffffff80287e18>] kmem_cache_destroy+0x7d/0xb9
>  [<ffffffffa03e6708>] :xfs:xfs_cleanup+0x5c/0xf9
>  [<ffffffffa03e67bf>] :xfs:exit_xfs_fs+0x1a/0x28
>  [<ffffffff80250b1f>] sys_delete_module+0x186/0x1de
>  [<ffffffff8020bee2>] tracesys+0xd5/0xda

....

That's rather unhealthy. I'm running a 2.6.26-rc9-git? on
my uml system, and when no filesystems are mounted all the XFS
slab caches have zero objects in them, even after several runs
on xfsqa. So I don't see any obvious leak here. You did unmount
the filesystem(s) first, right?

I'd suggest updating to 2.6.26-rc9 and repeating the test.  After
unmounting all the filesystems and before you rmmod the kernel
module, dump /proc/slabinfo so we can see if there are remaining
objects in the XFs slabs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
