Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C7687F3F
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 20:14:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 061C6304039
	for <xfs@oss.sgi.com>; Sat, 18 May 2013 18:14:00 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fsWt1YZmISh57S3E for <xfs@oss.sgi.com>;
	Sat, 18 May 2013 18:13:58 -0700 (PDT)
Date: Sun, 19 May 2013 11:13:54 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 3.5+, xfs and 32bit armhf - xfs_buf_get: failed to map pages
Message-ID: <20130519011354.GE6495@dastard>
References: <20130517104529.GA12490@luxor.wired.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130517104529.GA12490@luxor.wired.org>
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

On Fri, May 17, 2013 at 12:45:29PM +0200, Paolo Pisati wrote:
> While exercising swift on a single node 32bit armhf system running a 3.5 kernel,
> i got this when i hit ~25% of fs space usage:
> 
> dmesg:
> ...
> [ 3037.399406] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
> [ 3037.399442] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
> [ 3037.399469] vmap allocation for size 2097152 failed: use vmalloc=<size> to increase size.
> [ 3037.399485] XFS (sda5): xfs_buf_get: failed to map pages
> [ 3037.399485]
> [ 3037.399501] XFS (sda5): Internal error xfs_trans_cancel at line 1466 of file /build/buildd/linux-3.5.0/fs/xfs/xfs_trans.c. Caller 0xbf0235e0
> [ 3037.399501]
> [ 3037.413789] [<c00164cc>] (unwind_backtrace+0x0/0x104) from [<c04ed624>] (dump_stack+0x20/0x24)
> [ 3037.413985] [<c04ed624>] (dump_stack+0x20/0x24) from [<bf01091c>] (xfs_error_report+0x60/0x6c [xfs])
> [ 3037.414321] [<bf01091c>] (xfs_error_report+0x60/0x6c [xfs]) from [<bf0633f8>] (xfs_trans_cancel+0xfc/0x11c [xfs])
> [ 3037.414654] [<bf0633f8>] (xfs_trans_cancel+0xfc/0x11c [xfs]) from [<bf0235e0>] (xfs_create+0x228/0x558 [xfs])
> [ 3037.414953] [<bf0235e0>] (xfs_create+0x228/0x558 [xfs]) from [<bf01a7cc>] (xfs_vn_mknod+0x9c/0x180 [xfs])
> [ 3037.415239] [<bf01a7cc>] (xfs_vn_mknod+0x9c/0x180 [xfs]) from [<bf01a8d0>] (xfs_vn_mkdir+0x20/0x24 [xfs])
> [ 3037.415393] [<bf01a8d0>] (xfs_vn_mkdir+0x20/0x24 [xfs]) from [<c0135758>] (vfs_mkdir+0xc4/0x13c)
> [ 3037.415410] [<c0135758>] (vfs_mkdir+0xc4/0x13c) from [<c013884c>] (sys_mkdirat+0xdc/0xe4)
> [ 3037.415422] [<c013884c>] (sys_mkdirat+0xdc/0xe4) from [<c0138878>] (sys_mkdir+0x24/0x28)
> [ 3037.415437] [<c0138878>] (sys_mkdir+0x24/0x28) from [<c000e320>] (ret_fast_syscall+0x0/0x30)
> [ 3037.415452] XFS (sda5): xfs_do_force_shutdown(0x8) called from line 1467 of file /build/buildd/linux-3.5.0/fs/xfs/xfs_trans.c. Return address = 0xbf06340c
> [ 3037.416892] XFS (sda5): Corruption of in-memory data detected. Shutting down filesystem
> [ 3037.425008] XFS (sda5): Please umount the filesystem and rectify the problem(s)
> [ 3047.912480] XFS (sda5): xfs_log_force: error 5 returned.

Hi Paolo,

You've already contacted me off list about this and pointed me to
this:

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1176977

which contains information that everyone looking at the problem
should know. Also, any progress on testing the backported fix
mentioned in the bug?

> and while i didn't hit the warning above, still after ~25% of
> usage, the storage node died with:
>
> May 17 06:26:00 c13 container-server ERROR __call__ error with PUT /sdb1/123172/AUTH_test/3b3d078015304a41b76b0ab083b7863a_5 : [Errno 28] No space
> left on device: '/srv/1/node/sdb1/containers/123172' (txn: tx8ea3ce392ee94df096b16-00519605b0)

You're testing swift benchmark which is probably a small file
workload with large attributes attached.  It's a good chance that
the workload is fragmenting free space because swift is doing bad
things to allocation patterns.  It's almost certainly exacerbated by
the tiny filesystem you are using (1.5GB), but you can probably work
around this problem for now with allocsize=4096.

I've got a fix that I'm testing for the underlying cause of the
problem I'm aware of with this workload, but I'll need more
information about your storage/filesystem config to confirm it is
the same root cause first. Can you include the info from here:

http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F

As well the freespace info that Jeff asked for?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
