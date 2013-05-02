Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 577D57F54
	for <linux-xfs@oss.sgi.com>; Thu,  2 May 2013 09:46:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3352A30405F
	for <linux-xfs@oss.sgi.com>; Thu,  2 May 2013 07:46:04 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id p9JycJ9g1zgAribB (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 02 May 2013 07:46:03 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1UXull-0003od-EP
	for linux-xfs@oss.sgi.com; Thu, 02 May 2013 16:46:01 +0200
Received: from tc-gate1.pci.uni-heidelberg.de ([129.206.21.241])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 02 May 2013 16:46:01 +0200
Received: from bernd.schubert by tc-gate1.pci.uni-heidelberg.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 02 May 2013 16:46:01 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: 3.8.7: general protection fault
Date: Thu, 02 May 2013 16:45:48 +0200
Message-ID: <kltu6o$33j$1@ger.gmane.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

I just got this issue on one of my test servers:

> [784650.537576] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [784650.540018] Modules linked in: fhgfs(O) fhgfs_client_opentk(O) nfsd xfs ext4 mbcache jbd2 crc16 mlx4_ib mlx4_core ib_umad rdma_ucm rdma_cm iw_cm ib_addr ib_uverbs sg ib_ipoib ib_cm ib_sa loop arcmsr dm_mod md_mod evdev snd_pcm snd_timer snd soundcore tpm_tis snd_page_alloc tpm psmouse tpm_bios pcspkr shpchp serio_raw pci_hotplug ib_mthca ib_mad parport_pc parport amd64_edac_mod ib_core i2c_nforce2 processor k8temp edac_core thermal_sys edac_mce_amd button i2c_core ehci_pci fuse sd_mod crc_t10dif btrfs zlib_deflate crc32c libcrc32c ata_generic e1000 pata_amd sata_nv ohci_hcd floppy ehci_hcd libata scsi_mod usbcore usb_common
> [784650.540018] CPU 1
> [784650.540018] Pid: 247, comm: kworker/1:1H Tainted: G           O 3.8.7 #34 Supermicro H8DCE/H8DCE
> [784650.540018] RIP: 0010:[<ffffffffa05b38ba>]  [<ffffffffa05b38ba>] xfs_trans_ail_delete_bulk+0x7a/0x1d0 [xfs]
> [784650.540018] RSP: 0018:ffff8801f29ddbf8  EFLAGS: 00010202
> [784650.540018] RAX: 0000000000000001 RBX: ffff8801f319bf00 RCX: 0000000000000000
> [784650.540018] RDX: ffff8801f29ddc68 RSI: 6b6b6b6b6b6b6b6b RDI: 6b6b6b6b6b6b6b6b
> [784650.540018] RBP: ffff8801f29ddc48 R08: 0000000000000001 R09: 0000000000000000
> [784650.540018] R10: 0000000000000001 R11: ffffffffa05ccb35 R12: 0000000000000002
> [784650.540018] R13: 0000000000000008 R14: ffff8801f319bf10 R15: ffff8801f7951550
> [784650.540018] FS:  00007f10717f4700(0000) GS:ffff8801ff600000(0000) knlGS:0000000000000000
> [784650.540018] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [784650.540018] CR2: 00007fe7eed59000 CR3: 00000000ae5e4000 CR4: 00000000000007e0
> [784650.540018] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [784650.540018] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [784650.540018] Process kworker/1:1H (pid: 247, threadinfo ffff8801f29dc000, task ffff8801f2f14980)
> [784650.540018] Stack:
> [784650.540018]  ffff880100000000 ffff880100000000 ffff8801f29ddc60 ffff88005ff27838
> [784650.540018]  ffff8801f29ddc48 ffff88014c4c0b20 ffff8801f319bf00 ffff8801f29ddc78
> [784650.540018]  ffff8801f29ddc60 ffff8801f29ddd58 ffff8801f29ddca8 ffffffffa05b3320
> [784650.540018] Call Trace:
> [784650.540018]  [<ffffffffa05b3320>] xfs_iflush_done+0x1c0/0x1f0 [xfs]
> [784650.540018]  [<ffffffffa05b3174>] ? xfs_iflush_done+0x14/0x1f0 [xfs]
> [784650.540018]  [<ffffffffa05b0d8c>] xfs_buf_do_callbacks+0x3c/0x50 [xfs]
> [784650.540018]  [<ffffffffa05b145e>] xfs_buf_iodone_callbacks+0x3e/0x250 [xfs]
> [784650.540018]  [<ffffffffa0554309>] xfs_buf_iodone_work+0x59/0xa0 [xfs]
> [784650.540018]  [<ffffffff8107b744>] process_one_work+0x204/0x550
> [784650.540018]  [<ffffffff8107b6d0>] ? process_one_work+0x190/0x550
> [784650.540018]  [<ffffffff8107ddeb>] worker_thread+0x12b/0x3d0
> [784650.540018]  [<ffffffff8107dcc0>] ? manage_workers+0x2f0/0x2f0
> [784650.540018]  [<ffffffff810836ce>] kthread+0xee/0x100
> [784650.540018]  [<ffffffff810835e0>] ? __init_kthread_worker+0x70/0x70
> [784650.540018]  [<ffffffff8158dabc>] ret_from_fork+0x7c/0xb0
> [784650.540018]  [<ffffffff810835e0>] ? __init_kthread_worker+0x70/0x70
> [784650.540018] Code: 00 00 48 89 f2 31 c0 31 c9 eb 19 66 0f 1f 44 00 00 4c 8b 7a 08 48 83 c2 08 41 f6 47 34 01 0f 84 ad 00 00 00 49 8b 3f 49 8b 77 08 <48> 89 77 08 48 89 3e 48 bf 00 01 10 00 00 00 ad de 48 be 00 02
> [784650.540018] RIP  [<ffffffffa05b38ba>] xfs_trans_ail_delete_bulk+0x7a/0x1d0 [xfs]
> [784650.540018]  RSP <ffff8801f29ddbf8>
> [784650.849642] ---[ end trace 38cae66ea9b6d0f5 ]---
> [784650.854439] BUG: sleeping function called from invalid context at kernel/rwsem.c:20
> [784650.862280] in_atomic(): 1, irqs_disabled(): 0, pid: 247, name: kworker/1:1H

[... further messages and tracing causing a panic skipped]

I can resolve line numbers if required, but I don't have any minute to 
look into it myself.


Cheers,
Bernd






_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
