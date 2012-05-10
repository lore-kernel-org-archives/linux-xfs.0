Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4AFjp7C021021
	for <linux-xfs@oss.sgi.com>; Thu, 10 May 2012 10:45:53 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id Novi25gf5QFOYlFI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Thu, 10 May 2012 08:45:50 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1SSVYo-0006AY-4f
	for linux-xfs@oss.sgi.com; Thu, 10 May 2012 17:45:46 +0200
Received: from tc-gate1.pci.uni-heidelberg.de ([129.206.21.241])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 10 May 2012 17:45:46 +0200
Received: from bernd.schubert by tc-gate1.pci.uni-heidelberg.de with local
	(Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Thu, 10 May 2012 17:45:46 +0200
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: kernel panic / NULL pointer dereference
Date: Thu, 10 May 2012 17:45:26 +0200
Message-ID: <jognqm$o21$1@dough.gmane.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi all,

I'm just playing with an SRP connected NetApp system and just got an XFS 
related kernel panic. I guess it is due to large IO (32MiB). At least it 
just came up after enabling 32MiB device max_sectors.
As the tests are running in a RHEL6 image and as I needed at least 
2.6.39 to get a large srp_tablsize with SRP, I simply installed the 
lasted oracle uek kernel. If needed I'm going to update to a vanilla 
version.


> May 10 17:31:49 sgi01 kernel: XFS (sdb): Mounting Filesystem
> May 10 17:31:49 sgi01 kernel: XFS (sdb): Ending clean mount
> May 10 17:33:00 sgi01 kernel: BUG: unable to handle kernel NULL pointer dereference at           (null)
> May 10 17:33:00 sgi01 kernel: IP: [<ffffffffa07f5483>] xfs_alloc_ioend_bio+0x33/0x50 [xfs]
> May 10 17:33:00 sgi01 kernel: PGD 0
> May 10 17:33:00 sgi01 kernel: Oops: 0002 [#1] SMP
> May 10 17:33:00 sgi01 kernel: CPU 16
> May 10 17:33:00 sgi01 kernel: Modules linked in: xfs ib_srp scsi_dh_rdac scsi_transport_srp ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_connt
> rack ip6table_filter ip6_tables ib_ucm iw_cxgb4 iw_cxgb3 rdma_ucm rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad mlx4_ib mlx4_en mlx4_core i
> b_mthca ib_mad ib_core dm_round_robin isci libsas sg microcode qla2xxx scsi_transport_fc scsi_tgt pcspkr ghes hed wmi i2c_i801 i2c_core iTCO_wdt iTCO_vend
> or_support qla3xxx cciss e1000e megaraid_sas aacraid aic79xx aic7xxx ata_piix mptspi scsi_transport_spi mptsas mptscsih mptbase arcmsr sata_nv sata_svw 3w
> _9xxx 3w_xxxx bnx2 forcedeth ext4 jbd2 ext3 jbd mbcache sata_sil tg3 e1000 nfs lockd fscache auth_rpcgss nfs_acl sunrpc sd_mod crc_t10dif mpt2sas scsi_tra
> nsport_sas raid_class ahci libahci igb dca dm_multipath dm_mirror dm_region_hash dm_log dm_mod be2iscsi bnx2i cnic uio ipv6 cxgb4i cxgb4 cxgb3i libcxgbi c
> xgb3 mdio libiscsi_tcp qla4xxx iscsi_boot_sysfs libiscsi scsi_transport_iscsi [last unloaded: ib_srp]
> May 10 17:33:00 sgi01 kernel:
> May 10 17:33:00 sgi01 kernel: Pid: 76245, comm: flush-8:16 Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1 SGI.COM SUMMIT/S2600GZ
> May 10 17:33:00 sgi01 kernel: RIP: 0010:[<ffffffffa07f5483>]  [<ffffffffa07f5483>] xfs_alloc_ioend_bio+0x33/0x50 [xfs]
> May 10 17:33:00 sgi01 kernel: RSP: 0018:ffff8806687ff8b0  EFLAGS: 00010206
> May 10 17:33:00 sgi01 kernel: RAX: 0000000000000000 RBX: ffff8807a9e3b5a8 RCX: ffff88080ed51b80
> May 10 17:33:00 sgi01 kernel: RDX: 00000000006c6800 RSI: ffff880669c34780 RDI: 0000000000000282
> May 10 17:33:00 sgi01 kernel: RBP: ffff8806687ff8c0 R08: 1e00000000000000 R09: 0000000000000002
> May 10 17:33:00 sgi01 kernel: R10: ffff88083ffece00 R11: 000000000000006c R12: 0000000000000000
> May 10 17:33:00 sgi01 kernel: R13: ffff88080b422f28 R14: ffff8806687ffd20 R15: 0000000000000000
> May 10 17:33:00 sgi01 kernel: FS:  0000000000000000(0000) GS:ffff88083f700000(0000) knlGS:0000000000000000
> May 10 17:33:00 sgi01 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> May 10 17:33:00 sgi01 kernel: CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000406e0
> May 10 17:33:00 sgi01 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> May 10 17:33:00 sgi01 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> May 10 17:33:00 sgi01 kernel: Process flush-8:16 (pid: 76245, threadinfo ffff8806687fe000, task ffff8806687d2400)
> May 10 17:33:00 sgi01 kernel: Stack:
> May 10 17:33:00 sgi01 kernel: ffffea00133f70f0 ffff8807a9e3b5a8 ffff8806687ff910 ffffffffa07f561e
> May 10 17:33:00 sgi01 kernel: ffffea00133f69f0 ffffea00133f5d78 0000000000000000 ffff8807a9e3b5a8
> May 10 17:33:00 sgi01 kernel: ffffea0012ba90a8 ffff8806e0137190 0000000000000000 ffff88080b422f28
> May 10 17:33:00 sgi01 kernel: Call Trace:
> May 10 17:33:00 sgi01 kernel: [<ffffffffa07f561e>] xfs_submit_ioend+0xfe/0x110 [xfs]
> May 10 17:33:00 sgi01 kernel: [<ffffffffa07f696b>] xfs_vm_writepage+0x26b/0x510 [xfs]
> May 10 17:33:00 sgi01 kernel: [<ffffffff81112377>] __writepage+0x17/0x40
> May 10 17:33:00 sgi01 kernel: [<ffffffff81113696>] write_cache_pages+0x246/0x520
> May 10 17:33:00 sgi01 kernel: [<ffffffff81112360>] ? set_page_dirty+0x70/0x70
> May 10 17:33:00 sgi01 kernel: [<ffffffff811139c1>] generic_writepages+0x51/0x80
> May 10 17:33:00 sgi01 kernel: [<ffffffffa07f537d>] xfs_vm_writepages+0x5d/0x80 [xfs]
> May 10 17:33:00 sgi01 kernel: [<ffffffff81113a11>] do_writepages+0x21/0x40
> May 10 17:33:00 sgi01 kernel: [<ffffffff8118df2e>] writeback_single_inode+0x10e/0x270
> May 10 17:33:00 sgi01 kernel: [<ffffffff8118e333>] writeback_sb_inodes+0xe3/0x1b0
> May 10 17:33:00 sgi01 kernel: [<ffffffff8118e4a4>] writeback_inodes_wb+0xa4/0x170
> May 10 17:33:00 sgi01 kernel: [<ffffffff8118e863>] wb_writeback+0x2f3/0x430
> May 10 17:33:00 sgi01 kernel: [<ffffffff814fb28f>] ? _raw_spin_lock_irqsave+0x2f/0x40
> May 10 17:33:00 sgi01 kernel: [<ffffffff811129ba>] ? determine_dirtyable_memory+0x1a/0x30
> May 10 17:33:00 sgi01 kernel: [<ffffffff8118eafb>] wb_do_writeback+0x15b/0x280
> May 10 17:33:00 sgi01 kernel: [<ffffffff8118ecca>] bdi_writeback_thread+0xaa/0x270
> May 10 17:33:00 sgi01 kernel: [<ffffffff8118ec20>] ? wb_do_writeback+0x280/0x280
> May 10 17:33:00 sgi01 kernel: [<ffffffff81089ef6>] kthread+0x96/0xa0
> May 10 17:33:00 sgi01 kernel: [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
> May 10 17:33:00 sgi01 kernel: [<ffffffff81089e60>] ? kthread_worker_fn+0x1a0/0x1a0
> May 10 17:33:00 sgi01 kernel: [<ffffffff815046a0>] ? gs_change+0x13/0x13
> May 10 17:33:00 sgi01 kernel: Code: 08 66 66 66 66 90 48 89 fb 48 8b 7f 30 e8 56 3a 9a e0 bf 10 00 00 00 89 c6 e8 ca 56 9a e0 48 8b 53 20 48 c1 ea 09 48 0f af 53 18
> May 10 17:33:00 sgi01 kernel: RIP  [<ffffffffa07f5483>] xfs_alloc_ioend_bio+0x33/0x50 [xfs]
> May 10 17:33:00 sgi01 kernel: RSP <ffff8806687ff8b0>
> May 10 17:33:00 sgi01 kernel: CR2: 0000000000000000
> May 10 17:33:00 sgi01 kernel: ---[ end trace e6b492c98aa66902 ]---
> May 10 17:33:00 sgi01 kernel: Kernel panic - not syncing: Fatal exception
> May 10 17:33:00 sgi01 kernel: Pid: 76245, comm: flush-8:16 Tainted: G      D     2.6.39-100.6.1.el6uek.x86_64 #1
> May 10 17:33:00 sgi01 kernel: Call Trace:
> May 10 17:33:00 sgi01 kernel: [<ffffffff814f83c6>] panic+0x91/0x1a8



Any idea or do I need to dig myself?

Thanks,
Bernd

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
