Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4K95rX4098250 for <xfs@oss.sgi.com>; Wed, 20 May 2009 04:05:54 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E9A719EF6B5
	for <xfs@oss.sgi.com>; Wed, 20 May 2009 02:06:01 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	c9TupWdIcS6QC5Cf for <xfs@oss.sgi.com>;
	Wed, 20 May 2009 02:06:01 -0700 (PDT)
Date: Wed, 20 May 2009 19:05:58 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090520090558.GQ16929@discord.disaster>
References: <20090520003745.GA27491@samad.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090520003745.GA27491@samad.com.au>
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
To: Alex Samad <alex@samad.com.au>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Wed, May 20, 2009 at 10:37:45AM +1000, Alex Samad wrote:
> Hi
> 
> I have been quit a lot of crashes on my debian amd64 box in the 2.6.29
> series of kernel. Seems for me to be when the system is under load and
> there is network action -> nfsd -> xfs.

Perhaps a use after free or a reference counting problem. Thanks for
reporting it.

> May  5 19:45:38 x kernel: ------------[ cut here ]------------
> May  5 19:45:39 x kernel: kernel BUG at lib/radix-tree.c:485!
> May  5 19:45:39 x kernel: invalid opcode: 0000 [#1] SMP
> May  5 19:45:39 x kernel: last sysfs file:
> /sys/block/sdc/queue/nr_requests
> May  5 19:45:39 x kernel: CPU 0
> May  5 19:45:39 x kernel: Pid: 335, comm: kswapd0 Not tainted 2.6.29.2 #1 S2895
> May  5 19:45:39 x kernel: RIP: 0010:[<ffffffff803916e0>] [<ffffffff803916e0>] radix_tree_tag_set+0x86/0xc6
> May  5 19:45:39 x kernel: RSP: 0018:ffff88016e2d1c88  EFLAGS: 00010246
> May  5 19:45:39 x kernel: RAX: 0000000000000004 RBX: 0000000000000000 RCX: 0000000000000000
> May  5 19:45:39 x kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88016a822b58
> May  5 19:45:39 x kernel: RBP: 0000000000000004 R08: 0000000000000000 R09: 8000000000000000
> May  5 19:45:39 x kernel: R10: ffffa5a5a5a5a5a5 R11: ffffffff8037541d R12: 0000000000000001
> May  5 19:45:39 x kernel: R13: 0000000000000000 R14: ffff88016d1bc310 R15: 0000000000000000
> May  5 19:45:39 x kernel: FS:  00007fea1903f6e0(0000) GS:ffffffff80759040(0000) knlGS:0000000000000000
> May  5 19:45:39 x kernel: CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> May  5 19:45:39 x kernel: CR2: 00007fd2df5ae8e0 CR3: 000000016bad0000 CR4: 00000000000006e0
> May  5 19:45:39 x kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> May  5 19:45:39 x kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> May  5 19:45:39 x kernel: Process kswapd0 (pid: 335, threadinfo ffff88016e2d0000, task ffff88016f23eac0)
> May  5 19:45:39 x kernel: Stack:
> May  5 19:45:39 x kernel:  000000000069d804 0000000000000000 ffff88016d1bc2d0 ffff88000a8b7400
> May  5 19:45:39 x kernel:  ffff88000a8b7400 ffff88016df30000 ffff88000a8b74f8 ffff88016d1bc30c
> May  5 19:45:39 x kernel:  ffffffff80376b02 ffff88000a8b7580 0000000000000024 ffff88016e2d1d60
> May  5 19:45:39 x kernel: Call Trace:
> May  5 19:45:39 x kernel:  [<ffffffff80376b02>] ? xfs_inode_set_reclaim_tag+0x69/0x89
> May  5 19:45:39 x kernel:  [<ffffffff8036972f>] ? xfs_reclaim+0x99/0x9f
> May  5 19:45:39 x kernel:  [<ffffffff80375453>] ? xfs_fs_destroy_inode+0x36/0x54
> May  5 19:45:39 x kernel:  [<ffffffff80290304>] ? dispose_list+0xcd/0xfb
> May  5 19:45:39 x kernel:  [<ffffffff80290526>] ? shrink_icache_memory+0x1f4/0x22a
> May  5 19:45:39 x kernel:  [<ffffffff8026242a>] ? shrink_slab+0xe4/0x157
> May  5 19:45:39 x kernel:  [<ffffffff80262b53>] ? kswapd+0x44f/0x5c9
> May  5 19:45:39 x kernel:  [<ffffffff8026063e>] ? isolate_pages_global+0x0/0x231
> May  5 19:45:39 x kernel:  [<ffffffff8024458a>] ? autoremove_wake_function+0x0/0x2e
> May  5 19:45:39 x kernel:  [<ffffffff8022a80e>] ? __wake_up_common+0x44/0x73
> May  5 19:45:39 x kernel:  [<ffffffff80262704>] ? kswapd+0x0/0x5c9
> May  5 19:45:39 x kernel:  [<ffffffff80244266>] ? kthread+0x47/0x73
> May  5 19:45:39 x kernel:  [<ffffffff8020c4ba>] ? child_rip+0xa/0x20
> May  5 19:45:39 x kernel:  [<ffffffff8024421f>] ? kthread+0x0/0x73
> May  5 19:45:39 x kernel:  [<ffffffff8020c4b0>] ? child_rip+0x0/0x20
> May  5 19:45:39 x kernel: Code: 83 e5 3f 89 ea e8 04 fc ff ff 85 c0 75
> 10 48 8b 54 24 08 48 8d 84 13 18 02 00 00 0f ab 28 48 63 c5 48 8b 5c c3
> 18 48 85 db 75 04 <0f> 0b eb fe 41 83 ed 06 41 ff cc 45$
> May  5 19:45:39 x kernel: RIP  [<ffffffff803916e0>]
> radix_tree_tag_set+0x86/0xc6
> May  5 19:45:39 x kernel:  RSP <ffff88016e2d1c88>
> May  5 19:45:39 x kernel: ---[ end trace aed81d6fef80e624 ]---
> 
> 
> I have logged a bug with debian
> ( more info http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=526406),
> there has been one other to report this problem.
> 
> we believe somebody has already reported a similar problem here
> http://groups.google.com/group/linux.kernel/browse_thread/thread/dd00f52e93397c9e/6b6814dab9b41a05?pli=1

Which no-one noticed was related to XFS (not in the subject line)
and so most people (like me) would have simply deleted it without
reading it....

> has any one else seen this problem, who do I need to raise this too ?

I've cc'd the XFS list.

> I am able to reproduce this problem on my machine (amd64 phenomem II 8G
> ram), running virtualbox, I have a vm access the local filesystem via
> nfs (udp) and when I do a rm -fr <some directory ~200M> I see the bug

I run debian, XFS and 2.6.29 on all my machines but I haven't
tripped over the problem - it all appears to be related to calling
dispose_list() during/just after removing a lot of files. If you
have a simple method of reproducing the problem (e.g. a simple shell
script) it would help track down the problem much faster....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
