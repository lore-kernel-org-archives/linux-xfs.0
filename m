Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9C5mdo152757 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 06:05:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B779160C2E
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 04:07:15 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	vfCOGP7d4N9BRbko for <xfs@oss.sgi.com>;
	Tue, 09 Nov 2010 04:07:15 -0800 (PST)
Date: Tue, 9 Nov 2010 23:07:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: vmap allocation for size 1048576 failed
Message-ID: <20101109120701.GN2715@dastard>
References: <4CD924A6.6040200@dermichi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4CD924A6.6040200@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On Tue, Nov 09, 2010 at 11:38:30AM +0100, Michael Weissenbacher wrote:
> Dear List!
> 
> On one of my machines i started getting errors like this after upgrading
> from Kernel 2.6.35 to 2.6.36.
> --- --- snip --- ---
> Nov  9 11:25:57 xxxxx kernel: [591880.880679] vmap allocation for size
> 1048576 failed: use vmalloc=<size> to increase size.
> ... (repeats a few times, with differing sizes)
> Nov  9 11:25:57 xxxxx kernel: [591880.881651] xfs_buf_get: failed to map
> pages
> ... (repeats a few times)
> Nov  9 11:25:57 xxxxx kernel: [591881.111625] Filesystem "loop0": XFS
> internal error xfs_trans_cancel at line 1796 of file fs/xfs/xfs_trans.c.
>  Caller 0xc0270288
> Nov  9 11:25:57 xxxxx kernel: [591881.111629]
> Nov  9 11:25:57 xxxxx kernel: [591881.111636] Pid: 24899, comm: rsync
> Not tainted 2.6.36 #1
> Nov  9 11:25:57 xxxxx kernel: [591881.111640] Call Trace:
> Nov  9 11:25:57 xxxxx kernel: [591881.111653]  [<c0254756>]
> xfs_error_report+0x2c/0x2e
> Nov  9 11:25:57 xxxxx kernel: [591881.111663]  [<c026c691>]
> xfs_trans_cancel+0x4b/0xc9
> Nov  9 11:25:57 xxxxx kernel: [591881.111674]  [<c0270288>] ?
> xfs_create+0x473/0x4ef

I didn't think anything other than log recovery tries to vmap
buffers. This is clearly not in log recovery. Can you post an
unedited error log, how much data you are rsyncing, the
configuration of your filesystem (xfs_info, mount options, loop dev
config, etc) to give us an idea of what you are doing to trigger
this?

> A few thoughts:
>  * It always happens when i run "rsync" on the machine.
>  * I've already tried setting vmalloc=256M and vmalloc=512M which both
> delayed the problem but didn't cure it.
>  * It's a 32-bit machine and the problem only occurs on a loop'ed XFS,
> never on the root XFS.

Can't you run on a 64-bit machine?

>  * I've used the experimental "delaylog" mount option, which may be
> important.

Should be completely irrelevant.

>  * I'm not sure if the problem is 100% related to the kernel upgrade
> because i didn't use a loop XFS on this machine before the kernel upgrade.

Can you downgrade your kernel and run the loop device there to tell
us whether this is actually a regression or not? If it is a
regression, then if you could run a bisect to find the exact patch
that causes it woul dbe very helpful....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
