Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7A8KDQq046956 for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 03:20:14 -0500
Received: from v007470.home.net.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 442651D557D5
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2009 01:21:06 -0700 (PDT)
Received: from v007470.home.net.pl (v007470.home.net.pl [212.85.125.104]) by
	cuda.sgi.com with SMTP id 8jCpSqznRAtDIiwu for
	<xfs@oss.sgi.com>; Mon, 10 Aug 2009 01:21:06 -0700 (PDT)
From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: Re: XFS filesystem shutting down on linux 2.6.28.10 (xfs_rename)
Date: Mon, 10 Aug 2009 10:20:41 +0200
References: <1367391532.793061249444829356.JavaMail.root@mail.vpac.org>
In-Reply-To: <1367391532.793061249444829356.JavaMail.root@mail.vpac.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908101020.42098.kb@sysmikro.com.pl>
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
To: xfs@oss.sgi.com
Cc: Chris Samuel <csamuel@vpac.org>

Hi all,

this may be a bit off topic but i want to point out that included xfs_objdump 
seems to be corrupted. I think there are too many branches and calls and no 
other instructions. i couldn't see also any function's prolog and my dump 
looks quite different.

Regards,
Krzysztof Blaszkowski


On Wednesday 05 August 2009 06:00, Chris Samuel wrote:
> Hi folks,
>
> I believe we've been hitting the same issue that
> Gabriel Barazer reported in 2.6.28.9 on the 22nd
> of July on our NFS server for our HPC Linux clusters.
>
> Here is the backtrace we got this morning:
>
> Aug  5 11:44:27 stg7 kernel: [680506.864506] Pid: 5271, comm: nfsd Not
> tainted 2.6.28.10-vpac-1 #1 Aug  5 11:44:27 stg7 kernel: [680506.864508]
> Call Trace:
> Aug  5 11:44:27 stg7 kernel: [680506.864541]  [<ffffffffa032c8d5>]
> xfs_rename+0x5ac/0x5af [xfs] Aug  5 11:44:27 stg7 kernel: [680506.864567] 
> [<ffffffffa032d793>] xfs_trans_cancel+0x56/0xee [xfs] Aug  5 11:44:27 stg7
> kernel: [680506.864589]  [<ffffffffa032c8d5>] xfs_rename+0x5ac/0x5af [xfs]
> Aug  5 11:44:27 stg7 kernel: [680506.864609]  [<ffffffffa033b8d0>]
> xfs_vn_rename+0x61/0x69 [xfs] Aug  5 11:44:27 stg7 kernel: [680506.864615] 
> [<ffffffff8029a798>] vfs_rename+0x28a/0x404 Aug  5 11:44:27 stg7 kernel:
> [680506.864642]  [<ffffffffa045322c>] nfsd_rename+0x2ba/0x35f [nfsd] Aug  5
> 11:44:27 stg7 kernel: [680506.864654]  [<ffffffffa045a898>]
> nfsd3_proc_rename+0x120/0x131 [nfsd] Aug  5 11:44:27 stg7 kernel:
> [680506.864681]  [<ffffffffa044f23b>] nfsd_dispatch+0xdd/0x1b9 [nfsd] Aug 
> 5 11:44:27 stg7 kernel: [680506.864706]  [<ffffffffa03b3cdd>]
> svc_process+0x3e6/0x70e [sunrpc] Aug  5 11:44:27 stg7 kernel:
> [680506.864711]  [<ffffffff8022f9f2>] default_wake_function+0x0/0xe Aug  5
> 11:44:27 stg7 kernel: [680506.864717]  [<ffffffff8040dfac>]
> __down_read+0x15/0x99 Aug  5 11:44:27 stg7 kernel: [680506.864740] 
> [<ffffffffa044f7d1>] nfsd+0x1a0/0x26c [nfsd] Aug  5 11:44:27 stg7 kernel:
> [680506.864750]  [<ffffffffa044f631>] nfsd+0x0/0x26c [nfsd] Aug  5 11:44:27
> stg7 kernel: [680506.864754]  [<ffffffff802470de>] kthread+0x47/0x73 Aug  5
> 11:44:27 stg7 kernel: [680506.864757]  [<ffffffff80232f9a>]
> schedule_tail+0x27/0x60 Aug  5 11:44:27 stg7 kernel: [680506.864761] 
> [<ffffffff8020ccd9>] child_rip+0xa/0x11 Aug  5 11:44:27 stg7 kernel:
> [680506.864764]  [<ffffffff80247097>] kthread+0x0/0x73 Aug  5 11:44:27 stg7
> kernel: [680506.864766]  [<ffffffff8020cccf>] child_rip+0x0/0x11 Aug  5
> 11:44:27 stg7 kernel: [680506.864770] xfs_force_shutdown(md25,0x8) called
> from line 1165 of file fs/xfs/xfs _trans.c.  Return address =
> 0xffffffffa032d7ac
>
> Here's another backtrace from a week ago (same kernel):
>
> Jul 28 13:27:22 stg7 kernel: [3528649.232700] Pid: 5414, comm: nfsd Not
> tainted 2.6.28.10-vpac-1 #1 Jul 28 13:27:22 stg7 kernel: [3528649.232702]
> Call Trace:
> Jul 28 13:27:22 stg7 kernel: [3528649.232734]  [<ffffffffa03728d5>]
> xfs_rename+0x5ac/0x5af [xfs] Jul 28 13:27:22 stg7 kernel: [3528649.232756] 
> [<ffffffffa0373793>] xfs_trans_cancel+0x56/0xee [xfs] Jul 28 13:27:22 stg7
> kernel: [3528649.232778]  [<ffffffffa03728d5>] xfs_rename+0x5ac/0x5af [xfs]
> Jul 28 13:27:22 stg7 kernel: [3528649.232809]  [<ffffffffa03818d0>]
> xfs_vn_rename+0x61/0x69 [xfs] Jul 28 13:27:22 stg7 kernel: [3528649.232814]
>  [<ffffffff8029a798>] vfs_rename+0x28a/0x404 Jul 28 13:27:22 stg7 kernel:
> [3528649.232829]  [<ffffffffa03f822c>] nfsd_rename+0x2ba/0x35f [nfsd] Jul
> 28 13:27:22 stg7 kernel: [3528649.232855]  [<ffffffffa03ff898>]
> nfsd3_proc_rename+0x120/0x131 [nfsd] Jul 28 13:27:22 stg7 kernel:
> [3528649.232879]  [<ffffffffa03f423b>] nfsd_dispatch+0xdd/0x1b9 [nfsd] Jul
> 28 13:27:22 stg7 kernel: [3528649.232902]  [<ffffffffa03abcdd>]
> svc_process+0x3e6/0x70e [sunrpc] Jul 28 13:27:22 stg7 kernel:
> [3528649.232907]  [<ffffffff8022f9f2>] default_wake_function+0x0/0xe Jul 28
> 13:27:22 stg7 kernel: [3528649.232912]  [<ffffffff8040dfac>]
> __down_read+0x15/0x99 Jul 28 13:27:22 stg7 kernel: [3528649.232922] 
> [<ffffffffa03f47d1>] nfsd+0x1a0/0x26c [nfsd] Jul 28 13:27:22 stg7 kernel:
> [3528649.232948]  [<ffffffffa03f4631>] nfsd+0x0/0x26c [nfsd] Jul 28
> 13:27:22 stg7 kernel: [3528649.232952]  [<ffffffff802470de>]
> kthread+0x47/0x73 Jul 28 13:27:22 stg7 kernel: [3528649.232955] 
> [<ffffffff80232f9a>] schedule_tail+0x27/0x60 Jul 28 13:27:22 stg7 kernel:
> [3528649.232959]  [<ffffffff8020ccd9>] child_rip+0xa/0x11 Jul 28 13:27:22
> stg7 kernel: [3528649.232962]  [<ffffffff80247097>] kthread+0x0/0x73 Jul 28
> 13:27:22 stg7 kernel: [3528649.232964]  [<ffffffff8020cccf>]
> child_rip+0x0/0x11 Jul 28 13:27:22 stg7 kernel: [3528649.232967]
> xfs_force_shutdown(md25,0x8) called from line 1165 of file fs/xfs/xf
> s_trans.c.  Return address = 0xffffffffa03737ac
>
> This kernel is built with XFS as a kernel module so I've
> been able to attach the objdump output that Eric Sandeen
> had originally requested from Gabriel.
>
> Like Gabriel we're stuck on 2.6.28.x as the last working
> NFS exporting XFS kernel due to kernel bug #13375 (the
> radix bug), so I hope this helps!
>
> cheers,
> Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
