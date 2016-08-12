Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E60817CA0
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 12:07:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9D1DD304048
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 10:07:21 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9vANMWNS9jo84jfJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Aug 2016 10:07:17 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 1407285543
	for <xfs@oss.sgi.com>; Fri, 12 Aug 2016 17:07:17 +0000 (UTC)
Date: Fri, 12 Aug 2016 13:07:15 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: XFS: Assertion failed: bp->b_flags & XBF_ASYNC, file:
	fs/xfs/xfs_buf.c, line: 118 on 4.8-rc1 kernel
Message-ID: <20160812170714.GA64450@bfoster.bfoster>
References: <20160812140414.GV27776@eguan.usersys.redhat.com>
	<20160812144752.GW27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160812144752.GW27776@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Aug 12, 2016 at 10:47:52PM +0800, Eryu Guan wrote:
> On Fri, Aug 12, 2016 at 10:04:14PM +0800, Eryu Guan wrote:
> > Hi,
> > 
> > I hit oops while building kernel on XFS, 4.8-rc1 kernel, hit twice in
> > six kernel builds. I'm not sure if it's a regression since 4.7 kernel
> > yet, will do more testings.
> 
> Just hit again on 4.8-rc1 kernel, I was doing
> 
> # clean partial builds from previous run and build again
> make clean
> make -j 8
> 
> Seems I have to do kernel build on 4.7 kernel to finish the bisect.
> 
> Thanks,
> Eryu
> 
> [ 2515.752039] XFS: Assertion failed: bp->b_flags & XBF_ASYNC, file: fs/xfs/xfs_buf.c, line: 118

This is commit 9c7504aa7 ("xfs: track and serialize in-flight async
buffers against unmount"). The assert is actually incorrect, as Dave had
previously pointed out[1]. A patch was posted[2] to fix it, but hasn't
been merged yet.

Brian

[1] http://oss.sgi.com/pipermail/xfs/2016-August/050613.html
[2] http://oss.sgi.com/pipermail/xfs/2016-August/050634.html

> [ 2515.752649] ------------[ cut here ]------------
> [ 2515.752949] kernel BUG at fs/xfs/xfs_message.c:113!
> [ 2515.753010] invalid opcode: 0000 [#1] SMP
> [ 2515.753010] Modules linked in: btrfs xor raid6_pq ppdev i2c_piix4 parport_pc sg pcspkr i2c_core parport virtio_balloon acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrp
> c ip_tables xfs libcrc32c sd_mod ata_generic pata_acpi virtio_scsi serio_raw ata_piix virtio_pci 8139too floppy libata virtio_ring virtio 8139cp mii
> [ 2515.753010] CPU: 1 PID: 57 Comm: kswapd0 Not tainted 4.8.0-rc1 #17
> [ 2515.753010] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> [ 2515.753010] task: ffff880215cde680 task.stack: ffff880210a98000
> [ 2515.753010] RIP: 0010:[<ffffffffa01489a2>]  [<ffffffffa01489a2>] assfail+0x22/0x30 [xfs]
> [ 2515.753010] RSP: 0000:ffff880210a9ba00  EFLAGS: 00010246
> [ 2515.753010] RAX: 0000000000000000 RBX: ffff8801289fb9d8 RCX: 0000000000000000
> [ 2515.753010] RDX: ffff880210a9b908 RSI: 000000000000000a RDI: ffffffffa017ab95
> [ 2515.753010] RBP: ffff880210a9ba00 R08: 0000000000000000 R09: 0000000000000000
> [ 2515.753010] R10: 000000000000000a R11: f000000000000000 R12: ffff8801289fb980
> [ 2515.753010] R13: ffff88020f701c98 R14: ffff88020f701c00 R15: 0000000000000000
> [ 2515.753010] FS:  0000000000000000(0000) GS:ffff88021fc80000(0000) knlGS:0000000000000000
> [ 2515.753010] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2515.753010] CR2: 00002ab2aa17d000 CR3: 0000000208cd6000 CR4: 00000000000006e0
> [ 2515.753010] Stack:
> [ 2515.753010]  ffff880210a9ba38 ffffffffa012f332 ffff880103b4b000 ffff880103b4b124
> [ 2515.753010]  ffff8801289fb980 ffff88020f701c00 0000000000000000 ffff880210a9ba88
> [ 2515.753010]  ffffffffa013a05d 0000000008405ead ffff8801289fb980 000000009df3522a
> [ 2515.753010] Call Trace:
> [ 2515.753010]  [<ffffffffa012f332>] xfs_buf_rele+0x2f2/0x380 [xfs]
> [ 2515.753010]  [<ffffffffa013a05d>] xfs_reclaim_inode+0x38d/0x3a0 [xfs]
> [ 2515.753010]  [<ffffffffa013a293>] xfs_reclaim_inodes_ag+0x223/0x360 [xfs]
> [ 2515.753010]  [<ffffffff810b5638>] ? try_to_wake_up+0x58/0x390
> [ 2515.753010]  [<ffffffff810b5985>] ? wake_up_process+0x15/0x20
> [ 2515.753010]  [<ffffffffa013a4b3>] xfs_reclaim_inodes_nr+0x33/0x40 [xfs]
> [ 2515.753010]  [<ffffffffa014b709>] xfs_fs_free_cached_objects+0x19/0x20 [xfs]
> [ 2515.753010]  [<ffffffff81225f81>] super_cache_scan+0x181/0x190
> [ 2515.753010]  [<ffffffff811a8837>] shrink_slab+0x237/0x400
> [ 2515.753010]  [<ffffffff811ad4c3>] shrink_node+0x303/0x310
> [ 2515.753010]  [<ffffffff811ae2d2>] kswapd+0x302/0x6f0
> [ 2515.753010]  [<ffffffff811adfd0>] ? mem_cgroup_shrink_node+0x180/0x180
> [ 2515.753010]  [<ffffffff810aa198>] kthread+0xd8/0xf0
> [ 2515.753010]  [<ffffffff816d797f>] ret_from_fork+0x1f/0x40
> [ 2515.753010]  [<ffffffff810aa0c0>] ? kthread_park+0x60/0x60
> [ 2515.753010] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 c7 c6 30 69 18 a0 48 89 fa 31 c0 48 89 e5 31 ff e8 ae f8 ff ff <0f> 0b 66 90 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
> [ 2515.753010] RIP  [<ffffffffa01489a2>] assfail+0x22/0x30 [xfs]
> [ 2515.753010]  RSP <ffff880210a9ba00>
> [ 2515.773793] ---[ end trace d8064b1e521d0bfb ]---
> [ 2515.774123] Kernel panic - not syncing: Fatal exception
> [ 2515.774534] Kernel Offset: disabled
> [ 2515.774774] ---[ end Kernel panic - not syncing: Fatal exception
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
