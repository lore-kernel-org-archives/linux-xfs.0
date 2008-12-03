Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB33rkoL013524 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 21:53:46 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2785D166E543
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 19:53:42 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	j4Dd5KoRBsVfFnsY for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2008 19:53:42 -0800 (PST)
Date: Wed, 3 Dec 2008 14:20:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: 2.6.27.7 vanilla, project quota enabled and process stuck in D
	state (repeatable every time)
Message-ID: <20081203032013.GS18236@disturbed>
References: <200812021949.55463.arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200812021949.55463.arekm@maven.pl>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Tue, Dec 02, 2008 at 07:49:55PM +0100, Arkadiusz Miskiewicz wrote:
> 
> Hello,
> 
> I'm trying to use xfs project quota on kernel 2.6.27.7 (vanilla, no additional 
> patches), x86_64 UP machine (SMP kernel). 
> 
> Now some processes that are using /home/users/arekm/rpm are hanging in D-state 
> like:
> 
> SysRq : Show Blocked State
>   task                        PC stack   pid father
> patch         D ffff88003a7dd080     0  3971   3965
>  ffff880034453cd8 0000000000000086 0000000000000000 ffff8800344770d0
>  ffff880034453cd8 ffff8800354d2440 ffffffff805d0340 ffff8800354d27b8
>  00000000000041ed 00000000fffc7a61 ffff8800354d27b8 0000000000000250
> Call Trace:
>  [<ffffffffa00af4c4>] ? kmem_zone_alloc+0x94/0xe0 [xfs]
>  [<ffffffff804a51cd>] __down_write_nested+0x8d/0xd0
>  [<ffffffff804a521b>] __down_write+0xb/0x10
>  [<ffffffff804a4229>] down_write+0x9/0x10
>  [<ffffffffa008deb6>] xfs_ilock+0x76/0x90 [xfs]
>  [<ffffffffa00aa7d0>] xfs_lock_two_inodes+0x70/0x120 [xfs]
>  [<ffffffffa00ac651>] xfs_remove+0x141/0x3a0 [xfs]
>  [<ffffffff804a54c9>] ? _spin_lock+0x9/0x10
>  [<ffffffffa00b7c13>] xfs_setup_inode+0x673/0xa00 [xfs]
>  [<ffffffff802d0849>] vfs_unlink+0xf9/0x140
>  [<ffffffff802d3313>] do_unlinkat+0x1a3/0x1c0
>  [<ffffffff80287ce0>] ? audit_syscall_entry+0x150/0x180
>  [<ffffffff802d3341>] sys_unlink+0x11/0x20
>  [<ffffffff8020c5aa>] system_call_fastpath+0x16/0x1b

Can you enable lockdep in your kernel and retest? That will give
use much more information about the locks that are causing problems
here....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
