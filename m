Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 229947F3F
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 02:32:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DBD058F8052
	for <xfs@oss.sgi.com>; Sat,  8 Feb 2014 00:32:40 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0BTta5XAjyLpTCCL for <xfs@oss.sgi.com>;
	Sat, 08 Feb 2014 00:32:39 -0800 (PST)
Date: Sat, 8 Feb 2014 19:32:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: lockdep warning in 3.14-rc1
Message-ID: <20140208083234.GJ13647@dastard>
References: <52F57E6C.10907@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52F57E6C.10907@linux.vnet.ibm.com>
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
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: xfs@oss.sgi.com

On Fri, Feb 07, 2014 at 04:46:36PM -0800, Cody P Schafer wrote:
> Appears consistently during boot up.
....

> [    2.080292]        CPU0                    CPU1
> [    2.080295]        ----                    ----
> [    2.080298]   lock(&(&ip->i_lock)->mr_lock);
> [    2.080303]                                lock(&mm->mmap_sem);
> [    2.080307]                                lock(&(&ip->i_lock)->mr_lock);
> [    2.080312]   lock(&mm->mmap_sem);
> [    2.080316] 
>  *** DEADLOCK ***
> 
> [    2.080321] 2 locks held by systemd/1:
> [    2.080323]  #0:  (&type->i_mutex_dir_key#2){+.+.+.}, at: [<c000000000297470>] .iterate_dir+0xa0/0x160
> [    2.080334]  #1:  (&(&ip->i_lock)->mr_lock){++++..}, at: [<c00000000042e7ec>] .xfs_ilock+0x15c/0x1b0
> [    2.080343] 
> stack backtrace:
> [    2.080348] CPU: 2 PID: 1 Comm: systemd Tainted: G        W    3.14.0-rc1-24x7+ #8
> [    2.080353] Call Trace:
> [    2.080357] [c0000001fa103370] [c000000000016590] .show_stack+0x170/0x290 (unreliable)
> [    2.080364] [c0000001fa103460] [c000000000934f5c] .dump_stack+0xa0/0xdc
> [    2.080370] [c0000001fa1034e0] [c00000000092b6b4] .print_circular_bug+0x364/0x39c
> [    2.080376] [c0000001fa103590] [c00000000010ba70] .check_prev_add+0x8d0/0x8e0
> [    2.080381] [c0000001fa1036a0] [c00000000010c364] .validate_chain.isra.31+0x8e4/0xc40
> [    2.080386] [c0000001fa103790] [c00000000010de08] .__lock_acquire+0x488/0xd40
> [    2.080391] [c0000001fa1038b0] [c00000000010f08c] .lock_acquire+0xac/0x190
> [    2.080397] [c0000001fa103980] [c00000000021fe44] .might_fault+0xa4/0xe0
> [    2.080402] [c0000001fa1039f0] [c000000000297924] .filldir+0x1f4/0x290
> [    2.080407] [c0000001fa103ab0] [c0000000003cebc8] .xfs_dir2_block_getdents+0x218/0x2b0
> [    2.080413] [c0000001fa103b80] [c0000000003cf1e8] .xfs_readdir+0x168/0x1d0
> [    2.080418] [c0000001fa103c30] [c0000000003d2508] .xfs_file_readdir+0x48/0x80
> [    2.080423] [c0000001fa103cc0] [c0000000002974ec] .iterate_dir+0x11c/0x160
> [    2.080428] [c0000001fa103d60] [c000000000297df0] .SyS_getdents+0xa0/0x190
> [    2.080433] [c0000001fa103e30] [c00000000000a164] syscall_exit+0x0/0x98

False positive. We need to add new lockdep annotations because
lockdep doesn't know the difference between directory locking and
file IO path locking.

Ben, can you look at this? It is being caused by the addition of the
iolock to the directory readdir code, so directory inodes need a
different lockdep context to regular file inodes...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
