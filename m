Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6TEx0Cq259647 for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 09:59:03 -0500
Received: from intranet.easterngraphics.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3D78D10DA279
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 08:08:37 -0700 (PDT)
Received: from intranet.easterngraphics.com (intranet.easterngraphics.com
	[62.80.28.49]) by cuda.sgi.com with ESMTP id 7ZISm26uz2OgykD8
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2009 08:08:37 -0700 (PDT)
From: Christian Fischer <Christian.Fischer@easterngraphics.com>
Subject: Re: [xfs crash] Kernel BUG at /fs/xfs/support/debug.c:57
Date: Wed, 29 Jul 2009 16:59:40 +0200
References: <200907271657.55226.Christian.Fischer@easterngraphics.com>
	<4A705160.7040709@sandeen.net>
In-Reply-To: <4A705160.7040709@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907291659.41314.Christian.Fischer@easterngraphics.com>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

On Wednesday 29 July 2009, Eric Sandeen wrote:
> Christian Fischer wrote:
> > Hello,
> >
> > we had the 4th xfs crash during the last 4 month on last friday.
> > Maybe someone of you can give me some hints to get out what happens here.
[snip]

Hello Eric,

many thanks for the reply.

> >
> > We got xfs_suspend of the data partition one time, probably lost of the
> > root
>
> I don't know what "xfs_suspend" is ...

Yes, probably it was xfs_shutdown, or something similar, i can't remember 
exactly.

[snip]
> > All kernel versions (gentoo 2.6.18-xen-r12) and configurations are equal.
>
> pretty ancient kernel in fs terms too i'm afraid.

2.6.18 is the official xen kernel for now.

>
> > Thanks for any help
> > Christian
> >
> >
> >
> > Jul 24 11:33:30 ganges Access to block zero: fs: <sde1> inode: 2550198361
> > start_block : 0 start_off : 0 blkcnt : 0 extent-state : 0
> > Jul 24 11:33:30 ganges ----------- [cut here ] --------- [please bite
> > here ] ---------
>
> Well, what this means is that some data tried to write to block 0, which
> should never happen, since that's the superblock.  it's telling you
> which inode the write was for.
>
> It could be memory corruption or something, but more likely some extent
> handling bug in xfs.
>
> If so, it's almost certainly been fixed since, I've not seen this assert
> go of for years.  But to be honest, the reality is that nobody working
> on xfs today is going to be able to go back and debug a vendor kernel
> from 3 years ago, I'm afraid.
>
> Do you have a chance to run something more recent?

I'll try a xen patched 2.6.30 this weekend, hope there are no other issues.

Thanks for the explanation.
Christian

>
> -Eric
>
> > Jul 24 11:33:30 ganges Kernel BUG
> > at ...sr/src/linux-2.6.18-xen-r12/fs/xfs/support/debug.c:57
> > Jul 24 11:33:30 ganges invalid opcode: 0000 [1] SMP
> > Jul 24 11:33:30 ganges CPU 0
> > Jul 24 11:33:30 ganges Modules linked in:
> > Jul 24 11:33:30 ganges Pid: 15340, comm: smbd Not tainted 2.6.18-xen-r12
> > #8 Jul 24 11:33:30 ganges RIP: e030:[<ffffffff8039383c>] 
> > [<ffffffff8039383c>] cmn_err+0xdc/0x120
> > Jul 24 11:33:30 ganges RSP: e02b:ffff8800a4b2d5c8  EFLAGS: 00010246
> > Jul 24 11:33:30 ganges RAX: 0000000000000000 RBX: ffffffff8051cbf0 RCX:
> > 0000000000000001
> > Jul 24 11:33:30 ganges RDX: ffffffffff5fd000 RSI: 0000000000000000 RDI:
> > ffffffff805826ac
> > Jul 24 11:33:30 ganges RBP: 0000000000000000 R08: 0000000000000000 R09:
> > 0000000000000080
> > Jul 24 11:33:30 ganges R10: ffffffff8062c4c0 R11: ffffffff80213660 R12:
> > 0000000000000000
> > Jul 24 11:33:30 ganges R13: ffff8800f6a03bc0 R14: 0000000000000005 R15:
> > 0000000000000000
> > Jul 24 11:33:30 ganges FS:  00002ac859d276a0(0000)
> > GS:ffffffff805e7000(0000) knlGS:0000000000000000
> > Jul 24 11:33:30 ganges CS:  e033 DS: 0000 ES: 0000
> > Jul 24 11:33:30 ganges Process smbd (pid: 15340, threadinfo
> > ffff8800a4b2c000, task ffff880011892850)
> > Jul 24 11:33:30 ganges Stack:  0000003000000030 ffff8800a4b2d6c8
> > ffff8800a4b2d5e8 000000000000b5a0
> > Jul 24 11:33:30 ganges 00000002000001bc ffffffff80367438 ffff8800ff7ecfc0
> > 000000009800f059
> > Jul 24 11:33:30 ganges 0000000000000000 0000000000000000 ffff8800e6d8ca30
> > ffff8800a4b2d8b8
> > Jul 24 11:33:30 ganges Call Trace:
> > Jul 24 11:33:30 ganges [<ffffffff80367438>]
> > xfs_iext_bno_to_ext+0x138/0x160 Jul 24 11:33:30 ganges
> > [<ffffffff80366dd3>] xfs_iext_get_ext+0x43/0x70 Jul 24 11:33:30 ganges
> > [<ffffffff80348c4d>]
> > xfs_bmap_search_multi_extents+0xad/0x120
> > Jul 24 11:33:30 ganges [<ffffffff80348d8e>]
> > xfs_bmap_search_extents+0xce/0xf0 Jul 24 11:33:30 ganges
> > [<ffffffff80349201>] xfs_bmapi+0x2f1/0x1cf0 Jul 24 11:33:30 ganges
> > [<ffffffff8020aaef>] error_exit+0x0/0x71
> > Jul 24 11:33:30 ganges [<ffffffff8036d61e>]
> > xfs_iomap_write_delay+0x30e/0x490 Jul 24 11:33:30 ganges
> > [<ffffffff80209426>] __switch_to+0x3e6/0x560 Jul 24 11:33:30 ganges
> > [<ffffffff8036cc78>] xfs_iomap+0x228/0x570 Jul 24 11:33:30 ganges
> > [<ffffffff803884fb>] __xfs_get_blocks+0x7b/0x200 Jul 24 11:33:30 ganges
> > [<ffffffff8027df19>] alloc_page_buffers+0xa9/0x110 Jul 24 11:33:30 ganges
> > [<ffffffff8027f074>] __block_prepare_write+0x1d4/0x490 Jul 24 11:33:30
> > ganges [<ffffffff803886a0>] xfs_get_blocks+0x0/0x10 Jul 24 11:33:30
> > ganges [<ffffffff8027f34a>] block_prepare_write+0x1a/0x30 Jul 24 11:33:30
> > ganges [<ffffffff802567f8>]
> > generic_file_buffered_write+0x288/0x680
> > Jul 24 11:33:30 ganges [<ffffffff804a7dbe>]
> > tcp_rcv_established+0x49e/0x7a0 Jul 24 11:33:30 ganges
> > [<ffffffff8047a268>] memcpy_toiovec+0x38/0x70 Jul 24 11:33:30 ganges
> > [<ffffffff8023346b>] current_fs_time+0x3b/0x40 Jul 24 11:33:30 ganges
> > [<ffffffff803ad561>] __up_write+0x21/0x120 Jul 24 11:33:30 ganges
> > [<ffffffff803917d3>] xfs_write+0x7a3/0xb40 Jul 24 11:33:30 ganges
> > [<ffffffff804a05db>] tcp_recvmsg+0x76b/0x8a0 Jul 24 11:33:30 ganges
> > [<ffffffff8047190b>] do_sock_read+0xab/0xc0 Jul 24 11:33:30 ganges
> > [<ffffffff8047217f>] sock_aio_read+0x4f/0x60 Jul 24 11:33:30 ganges
> > [<ffffffff8038d3cf>] xfs_file_aio_write+0x6f/0x80 Jul 24 11:33:30 ganges
> > [<ffffffff8027b9d7>] do_sync_write+0xc7/0x110 Jul 24 11:33:30 ganges
> > [<ffffffff8028ee43>] fasync_helper+0x63/0x150 Jul 24 11:33:30 ganges
> > [<ffffffff80293089>] __posix_lock_file_conf+0x3d9/0x430 Jul 24 11:33:30
> > ganges [<ffffffff80244970>] autoremove_wake_function+0x0/0x30 Jul 24
> > 11:33:30 ganges [<ffffffff80293cc6>] fcntl_setlk+0x286/0x2c0 Jul 24
> > 11:33:30 ganges [<ffffffff8027c3cd>] vfs_write+0xbd/0x180 Jul 24 11:33:30
> > ganges [<ffffffff8027cc1d>] sys_pwrite64+0x5d/0x90 Jul 24 11:33:30 ganges
> > [<ffffffff8020a3b0>] system_call+0x68/0x6d Jul 24 11:33:30 ganges
> > [<ffffffff8020a348>] system_call+0x0/0x6d Jul 24 11:33:30 ganges
> > Jul 24 11:33:30 ganges
> > Jul 24 11:33:30 ganges Code: 0f 0b 68 f0 f7 51 80 c2 39 00 eb 2b 48 c7 c6
> > a6 3a 52 80 48
> > Jul 24 11:33:30 ganges RIP  [<ffffffff8039383c>] cmn_err+0xdc/0x120
> > Jul 24 11:33:30 ganges RSP <ffff8800a4b2d5c8>
> >
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
