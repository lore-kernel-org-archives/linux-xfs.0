Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1247B7F56
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 17:03:47 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 86F47AC004
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 15:03:43 -0800 (PST)
Received: from ozlabs.org (ozlabs.org [103.22.144.67]) by cuda.sgi.com with
	ESMTP id x1z249qbggHbs1DW (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 15:03:40 -0800 (PST)
From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
In-Reply-To: <20141107080416.0837a88c@tlielax.poochiereds.net>
References: <20141107080416.0837a88c@tlielax.poochiereds.net>
Date: Mon, 10 Nov 2014 20:29:50 +1030
Message-ID: <87bnofnzop.fsf@rustcorp.com.au>
MIME-Version: 1.0
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
To: Jeff Layton <jlayton@poochiereds.net>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
Cc: xfs@oss.sgi.com, virtualization@lists.linux-foundation.org

Jeff Layton <jlayton@poochiereds.net> writes:

> In the latest Fedora rawhide kernel in the repos, I'm seeing the
> following oops when mounting xfs. rc2-ish kernels seem to be fine:
>
> [   64.669633] ------------[ cut here ]------------
> [   64.670008] kernel BUG at drivers/block/virtio_blk.c:172!

Hmm, that's:

	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);

But during our probe routine we said:

	/* We can handle whatever the host told us to handle. */
	blk_queue_max_segments(q, vblk->sg_elems-2);

Jens?

Thanks,
Rusty.

> [   64.670008] invalid opcode: 0000 [#1] SMP 
> [   64.670008] Modules linked in: xfs libcrc32c snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm ppdev snd_timer snd virtio_net virtio_balloon soundcore serio_raw parport_pc virtio_console pvpanic parport i2c_piix4 nfsd auth_rpcgss nfs_acl lockd grace sunrpc qxl virtio_blk drm_kms_helper ttm drm ata_generic virtio_pci virtio_ring virtio pata_acpi
> [   64.670008] CPU: 1 PID: 705 Comm: mount Not tainted 3.18.0-0.rc3.git2.1.fc22.x86_64 #1
> [   64.670008] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [   64.670008] task: ffff8800d94a4ec0 ti: ffff8800d9f38000 task.ti: ffff8800d9f38000
> [   64.670008] RIP: 0010:[<ffffffffa00287c0>]  [<ffffffffa00287c0>] virtio_queue_rq+0x290/0x2a0 [virtio_blk]
> [   64.670008] RSP: 0018:ffff8800d9f3b778  EFLAGS: 00010202
> [   64.670008] RAX: 0000000000000082 RBX: ffff8800d8375700 RCX: dead000000200200
> [   64.670008] RDX: 0000000000000001 RSI: ffff8800d8375700 RDI: ffff8800d82c4c00
> [   64.670008] RBP: ffff8800d9f3b7b8 R08: ffff8800d8375700 R09: 0000000000000001
> [   64.670008] R10: 0000000000000001 R11: 0000000000000004 R12: ffff8800d9f3b7e0
> [   64.670008] R13: ffff8800d82c4c00 R14: ffff880118629200 R15: 0000000000000000
> [   64.670008] FS:  00007f5c64dfd840(0000) GS:ffff88011b000000(0000) knlGS:0000000000000000
> [   64.670008] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   64.670008] CR2: 00007fffe6458fb8 CR3: 00000000d06d3000 CR4: 00000000000006e0
> [   64.670008] Stack:
> [   64.670008]  ffff880000000001 ffff8800d8375870 0000000000000001 ffff8800d82c4c00
> [   64.670008]  ffff8800d9f3b7e0 0000000000000000 ffff8800d8375700 ffff8800d82c4c48
> [   64.670008]  ffff8800d9f3b828 ffffffff813ec258 ffff8800d82c8000 0000000000000001
> [   64.670008] Call Trace:
> [   64.670008]  [<ffffffff813ec258>] __blk_mq_run_hw_queue+0x1c8/0x330
> [   64.670008]  [<ffffffff813ecd80>] blk_mq_run_hw_queue+0x70/0x90
> [   64.670008]  [<ffffffff813ee0cd>] blk_sq_make_request+0x24d/0x5c0
> [   64.670008]  [<ffffffff813dec68>] generic_make_request+0xf8/0x150
> [   64.670008]  [<ffffffff813ded38>] submit_bio+0x78/0x190
> [   64.670008]  [<ffffffffa02fc27e>] _xfs_buf_ioapply+0x2be/0x5f0 [xfs]
> [   64.670008]  [<ffffffffa0333628>] ? xlog_bread_noalign+0xa8/0xe0 [xfs]
> [   64.670008]  [<ffffffffa02ffe21>] xfs_buf_submit_wait+0x91/0x840 [xfs]
> [   64.670008]  [<ffffffffa0333628>] xlog_bread_noalign+0xa8/0xe0 [xfs]
> [   64.670008]  [<ffffffffa0333ea7>] xlog_bread+0x27/0x60 [xfs]
> [   64.670008]  [<ffffffffa03357f3>] xlog_find_verify_cycle+0xf3/0x1b0 [xfs]
> [   64.670008]  [<ffffffffa0335de5>] xlog_find_head+0x2f5/0x3e0 [xfs]
> [   64.670008]  [<ffffffffa0335f0c>] xlog_find_tail+0x3c/0x410 [xfs]
> [   64.670008]  [<ffffffffa033b12d>] xlog_recover+0x2d/0x120 [xfs]
> [   64.670008]  [<ffffffffa033cfdb>] ? xfs_trans_ail_init+0xcb/0x100 [xfs]
> [   64.670008]  [<ffffffffa0329c3d>] xfs_log_mount+0xdd/0x2c0 [xfs]
> [   64.670008]  [<ffffffffa031f744>] xfs_mountfs+0x514/0x9c0 [xfs]
> [   64.670008]  [<ffffffffa0320c8d>] ? xfs_mru_cache_create+0x18d/0x1f0 [xfs]
> [   64.670008]  [<ffffffffa0322ed0>] xfs_fs_fill_super+0x330/0x3b0 [xfs]
> [   64.670008]  [<ffffffff8126d4ac>] mount_bdev+0x1bc/0x1f0
> [   64.670008]  [<ffffffffa0322ba0>] ? xfs_parseargs+0xbe0/0xbe0 [xfs]
> [   64.670008]  [<ffffffffa0320fd5>] xfs_fs_mount+0x15/0x20 [xfs]
> [   64.670008]  [<ffffffff8126de58>] mount_fs+0x38/0x1c0
> [   64.670008]  [<ffffffff81202c15>] ? __alloc_percpu+0x15/0x20
> [   64.670008]  [<ffffffff812908f8>] vfs_kern_mount+0x68/0x160
> [   64.670008]  [<ffffffff81293d6c>] do_mount+0x22c/0xc20
> [   64.670008]  [<ffffffff8120d92e>] ? might_fault+0x5e/0xc0
> [   64.670008]  [<ffffffff811fcf1b>] ? memdup_user+0x4b/0x90
> [   64.670008]  [<ffffffff81294a8e>] SyS_mount+0x9e/0x100
> [   64.670008]  [<ffffffff8185e169>] system_call_fastpath+0x12/0x17
> [   64.670008] Code: 00 00 c7 86 78 01 00 00 02 00 00 00 48 c7 86 80 01 00 00 00 00 00 00 89 86 7c 01 00 00 e9 02 fe ff ff 66 0f 1f 84 00 00 00 00 00 <0f> 0b 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
> [   64.670008] RIP  [<ffffffffa00287c0>] virtio_queue_rq+0x290/0x2a0 [virtio_blk]
> [   64.670008]  RSP <ffff8800d9f3b778>
> [   64.715347] ---[ end trace c0ff4a0f2fb21f7f ]---
>
> It's reliably reproducible and I don't see this oops when I convert the
> same block device to ext4 and mount it. In this setup, the KVM guest
> has a virtio block device that has a LVM2 PV on it with an LV on it
> that contains the filesystem.
>
> Let me know if you need any other info to chase this down.
>
> Thanks!
> -- 
> Jeff Layton <jlayton@poochiereds.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
