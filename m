Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 Mar 2007 12:56:20 -0700 (PDT)
Received: from mail.gatrixx.com (mail.gatrixx.com [217.111.11.44])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2SJuD6p007683
	for <xfs@oss.sgi.com>; Wed, 28 Mar 2007 12:56:15 -0700
Message-ID: <460AC857.6040305@j-o-a.de>
Date: Wed, 28 Mar 2007 21:56:07 +0200
From: Oliver Joa <oliver@j-o-a.de>
MIME-Version: 1.0
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
References: <46094344.4090007@j-o-a.de> <20070328113141.GQ32597093@melbourne.sgi.com> <460A6298.4040702@j-o-a.de> <460A821B.4080308@sandeen.net>
In-Reply-To: <460A821B.4080308@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

Hi,

Eric Sandeen wrote:

[...]

> For one reason or another, xfs has detected a corrupted on-disk inode 
> format which it cannot recognize, and shuts down.  It is likely the 
> result of something which has gone wrong previously.  xfs_repair should 
> fix it.  Are there other non-xfs messages in your logs indicating other 
> problems prior to this?

i sent already the dmesg output to the list. there is nothing else.

I made a xfs_repair. Now I have some Files in lost+found.

So I tried it again with a new cable:

test:/# find / -xdev | cpio -padm /test/
3648526 blocks
test:/# rm -rf test
test:/# find / -xdev | cpio -padm /test/
find: /usr/src/linux-2.6.19.2/arch/sh/kernel/cpufreq.c: Structure needs 
cleaning
find: /usr/src/linux-2.6.19.2/arch/sh/kernel/head.S: Structure needs 
cleaning
find: /usr/src/linux-2.6.19.2/arch/sh/kernel/irq.c: Structure needs cleaning
3653268 blocks
test:/#

Since the reboot I did not get any bus-reset, but the following:

[ 1878.777203] Filesystem "sda3": XFS internal error xfs_iformat(6) at 
line 492 of file fs/xfs/xfs_inode.c.  Caller 0xc0211f94
[ 1878.777264]  [<c0216dba>] xfs_iread+0x4ee/0x6e8
[ 1878.777298]  [<c0211f94>] xfs_iget+0x2e4/0x714
[ 1878.777451]  [<c0211f94>] xfs_iget+0x2e4/0x714
[ 1878.777513]  [<c02293be>] xfs_dir_lookup_int+0x7d/0xd4
[ 1878.777576]  [<c022cc6b>] xfs_lookup+0x52/0x78
[ 1878.777636]  [<c0238a22>] xfs_vn_lookup+0x3b/0x70
[ 1878.777696]  [<c0153e6d>] do_lookup+0xa3/0x140
[ 1878.777757]  [<c015578e>] __link_path_walk+0x73d/0xb5e
[ 1878.777819]  [<c015ff0e>] mntput_no_expire+0x11/0x63
[ 1878.777879]  [<c0155c58>] link_path_walk+0xa9/0xb3
[ 1878.777941]  [<c0155bf3>] link_path_walk+0x44/0xb3
[ 1878.778001]  [<c014ca81>] nameidata_to_filp+0x24/0x33
[ 1878.778074]  [<c014cac2>] do_filp_open+0x32/0x39
[ 1878.778145]  [<c0155efe>] do_path_lookup+0x176/0x191
[ 1878.778209]  [<c0154ef8>] getname+0x59/0x8f
[ 1878.778270]  [<c01566b8>] __user_walk_fd+0x2f/0x45
[ 1878.778334]  [<c0150a09>] vfs_lstat_fd+0x16/0x3d
[ 1878.778397]  [<c014ca81>] nameidata_to_filp+0x24/0x33
[ 1878.778461]  [<c014cac2>] do_filp_open+0x32/0x39
[ 1878.778524]  [<c0150a75>] sys_lstat64+0xf/0x23
[ 1878.778585]  [<c014ecb7>] __fput+0x112/0x13c
[ 1878.778647]  [<c015ff0e>] mntput_no_expire+0x11/0x63
[ 1878.778709]  [<c014c793>] filp_close+0x51/0x58
[ 1878.778771]  [<c014d772>] sys_close+0x67/0x9e
[ 1878.778832]  [<c0102bd8>] syscall_call+0x7/0xb
[ 1878.778895]  =======================
[ 1878.974434] Filesystem "sda3": XFS internal error xfs_iformat(6) at 
line 492 of file fs/xfs/xfs_inode.c.  Caller 0xc0211f94
[ 1878.974493]  [<c0216dba>] xfs_iread+0x4ee/0x6e8
[ 1878.974599]  [<c0211f94>] xfs_iget+0x2e4/0x714
[ 1878.974692]  [<c0211f94>] xfs_iget+0x2e4/0x714
[ 1878.974759]  [<c02293be>] xfs_dir_lookup_int+0x7d/0xd4
[ 1878.974799]  [<c022cc6b>] xfs_lookup+0x52/0x78
[ 1878.974888]  [<c0238a22>] xfs_vn_lookup+0x3b/0x70
[ 1878.974950]  [<c0153e6d>] do_lookup+0xa3/0x140
[ 1878.975015]  [<c015578e>] __link_path_walk+0x73d/0xb5e
[ 1878.975080]  [<c03645e7>] _spin_unlock_irqrestore+0xf/0x23
[ 1878.975145]  [<c0285ad3>] n_tty_receive_buf+0xc77/0xd1a
[ 1878.975210]  [<c0155bf3>] link_path_walk+0x44/0xb3
[ 1878.975275]  [<c0155efe>] do_path_lookup+0x176/0x191
[ 1878.975338]  [<c0154ef8>] getname+0x59/0x8f
[ 1878.975399]  [<c01566b8>] __user_walk_fd+0x2f/0x45
[ 1878.975461]  [<c0150a09>] vfs_lstat_fd+0x16/0x3d
[ 1878.975525]  [<c0150a75>] sys_lstat64+0xf/0x23
[ 1878.975588]  [<c0102bd8>] syscall_call+0x7/0xb
[ 1878.975650]  [<c0360033>] rsc_parse+0x6f/0x37f
[ 1878.975712]  =======================
[ 1878.975956] Filesystem "sda3": XFS internal error xfs_iformat(6) at 
line 492 of file fs/xfs/xfs_inode.c.  Caller 0xc0211f94
[ 1878.976012]  [<c0216dba>] xfs_iread+0x4ee/0x6e8
[ 1878.976111]  [<c0211f94>] xfs_iget+0x2e4/0x714
[ 1878.976184]  [<c0211f94>] xfs_iget+0x2e4/0x714
[ 1878.976249]  [<c02293be>] xfs_dir_lookup_int+0x7d/0xd4
[ 1878.976314]  [<c022cc6b>] xfs_lookup+0x52/0x78
[ 1878.976376]  [<c0238a22>] xfs_vn_lookup+0x3b/0x70
[ 1878.976438]  [<c0153e6d>] do_lookup+0xa3/0x140
[ 1878.976500]  [<c015578e>] __link_path_walk+0x73d/0xb5e
[ 1878.976564]  [<c03645e7>] _spin_unlock_irqrestore+0xf/0x23
[ 1878.976629]  [<c0285ad3>] n_tty_receive_buf+0xc77/0xd1a
[ 1878.976701]  [<c0155bf3>] link_path_walk+0x44/0xb3
[ 1878.976766]  [<c0155efe>] do_path_lookup+0x176/0x191
[ 1878.976835]  [<c0154ef8>] getname+0x59/0x8f
[ 1878.976898]  [<c01566b8>] __user_walk_fd+0x2f/0x45
[ 1878.976961]  [<c0150a09>] vfs_lstat_fd+0x16/0x3d
[ 1878.977024]  [<c0150a75>] sys_lstat64+0xf/0x23
[ 1878.977088]  [<c0102bd8>] syscall_call+0x7/0xb
[ 1878.977150]  [<c0360033>] rsc_parse+0x6f/0x37f
[ 1878.977212]  =======================

Thanks

Oliver
