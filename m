Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9FACD29DFA
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 03:14:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3B8B0AC003
	for <linux-xfs@oss.sgi.com>; Mon,  6 May 2013 01:14:42 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id w1cvRPdD7chBtPEs (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Mon, 06 May 2013 01:14:41 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1UZGZ9-0003rH-Uc
	for linux-xfs@oss.sgi.com; Mon, 06 May 2013 10:14:35 +0200
Received: from tc-gate1.pci.uni-heidelberg.de ([129.206.21.241])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 06 May 2013 10:14:35 +0200
Received: from bernd.schubert by tc-gate1.pci.uni-heidelberg.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Mon, 06 May 2013 10:14:35 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: 3.9.0: general protection fault
Date: Mon, 06 May 2013 10:14:22 +0200
Message-ID: <km7oop$28c$1@ger.gmane.org>
References: <kltu6o$33j$1@ger.gmane.org>
Mime-Version: 1.0
In-Reply-To: <kltu6o$33j$1@ger.gmane.org>
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

And anpther protection fault, this time with 3.9.0. Always happens on 
one of the servers. Its ECC memory, so I don't suspect a faulty memory 
bank. Going to fsck now-


> [303340.514052] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [303340.517913] Modules linked in: fhgfs(O) fhgfs_client_opentk(O) nfsd xfs ext4 mbcache jbd2 crc16 sg mlx4_ib mlx4_core ib_umad rdma_ucm rdma_cm iw_cm ib_addr ib_uverbs ib_ipoib ib_cm ib_sa loop arcmsr dm_mod md_mod evdev tpm_tis tpm tpm_bios psmouse serio_raw shpchp pcspkr pci_hotplug amd64_edac_mod edac_core edac_mce_amd k8temp ib_mthca ib_mad ib_core processor ehci_pci thermal_sys button i2c_nforce2 i2c_core fuse btrfs sd_mod crc_t10dif raid6_pq xor zlib_deflate crc32c libcrc32c ata_generic pata_amd sata_nv ohci_hcd libata e1000 ehci_hcd scsi_mod floppy
> [303340.532909] CPU 1
> [303340.532909] Pid: 256, comm: kworker/1:1H Tainted: G           O 3.9.0-debug+ #10 Supermicro H8DCE/H8DCE
> [303340.532909] RIP: 0010:[<ffffffff812d45d4>]  [<ffffffff812d45d4>] __list_del_entry+0x76/0xd4
> [303340.532909] RSP: 0018:ffff8801f502dbb8  EFLAGS: 00010a83
> [303340.532909] RAX: 6b6b6b6b6b6b6b6b RBX: ffff880099159c18 RCX: dead000000200200
> [303340.532909] RDX: 6b6b6b6b6b6b6b6b RSI: ffff880099159c18 RDI: ffff880099159c18
> [303340.532909] RBP: ffff8801f502dbb8 R08: ffff8801a2c1de08 R09: 0000000000000000
> [303340.532909] R10: 0000000000000008 R11: ffffffff81608e11 R12: ffff8800b65ddf00
> [303340.532909] R13: 0000000000000001 R14: 0000000000000001 R15: ffff8800b65ddf00
> [303340.532909] FS:  00007fcac7da5700(0000) GS:ffff8801fe800000(0000) knlGS:0000000000000000
> [303340.532909] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [303340.532909] CR2: ffffffffff600400 CR3: 00000000ae02e000 CR4: 00000000000007e0
> [303340.532909] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [303340.532909] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [303340.532909] Process kworker/1:1H (pid: 256, threadinfo ffff8801f502c000, task ffff8801f5029480)
> [303340.532909] Stack:
> [303340.532909]  ffff8801f502dbd8 ffffffff812d4643 ffff8801f502dc28 ffff880099159c18
> [303340.532909]  ffff8801f502dbf8 ffffffffa053876c ffff880099159c18 ffff8801f502dc78
> [303340.532909]  ffff8801f502dc58 ffffffffa053883e ffff8800b65ddf58 00000008f502dc70
> [303340.532909] Call Trace:
> [303340.532909]  [<ffffffff812d4643>] list_del+0x11/0x33
> [303340.532909]  [<ffffffffa053876c>] xfs_ail_delete+0x24/0x3a [xfs]
> [303340.532909]  [<ffffffffa053883e>] xfs_trans_ail_delete_bulk+0xbc/0x149 [xfs]
> [303340.532909]  [<ffffffffa05382a3>] xfs_iflush_done+0x121/0x1be [xfs]
> [303340.532909]  [<ffffffffa0538196>] ? xfs_iflush_done+0x14/0x1be [xfs]
> [303340.532909]  [<ffffffffa0535cb0>] xfs_buf_do_callbacks+0x39/0x4c [xfs]
> [303340.532909]  [<ffffffffa0536707>] xfs_buf_iodone_callbacks+0x2bd/0x2ee [xfs]
> [303340.532909]  [<ffffffffa04d8e9a>] xfs_buf_iodone_work+0x46/0x76 [xfs]
> [303340.532909]  [<ffffffff8107740f>] process_one_work+0x2ff/0x4f5
> [303340.532909]  [<ffffffff81077355>] ? process_one_work+0x245/0x4f5
> [303340.532909]  [<ffffffff810782bf>] ? worker_thread+0x56/0x2d4
> [303340.532909]  [<ffffffff8107847c>] worker_thread+0x213/0x2d4
> [303340.532909]  [<ffffffff81078269>] ? busy_worker_rebind_fn+0x92/0x92
> [303340.532909]  [<ffffffff8107e150>] kthread+0xe1/0xe9
> [303340.532909]  [<ffffffff81563483>] ? _raw_spin_unlock_irq+0x30/0x4e
> [303340.532909]  [<ffffffff8107e06f>] ? __init_kthread_worker+0x6b/0x6b
> [303340.532909]  [<ffffffff8156be7c>] ret_from_fork+0x7c/0xb0
> [303340.532909]  [<ffffffff8107e06f>] ? __init_kthread_worker+0x6b/0x6b
> [303340.532909] Code: de 48 39 c8 75 25 49 89 c8 48 89 f9 48 c7 c2 28 6c 7f 81 be 38 00 00 00 48 c7 c7 72 66 7f 81 b8 00 00 00 00 e8 18 22 d8 ff eb 5c <4c> 8b 00 4c 39 c7 74 22 48 89 f9 48 c7 c2 60 6c 7f 81 be 3b 00
> [303340.532909] RIP  [<ffffffff812d45d4>] __list_del_entry+0x76/0xd4
> [303340.532909]  RSP <ffff8801f502dbb8>
> [303340.848041] ---[ end trace 0d0b800e14608360 ]---


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
