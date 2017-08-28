Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22260 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751241AbdH1Rms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 13:42:48 -0400
Date: Mon, 28 Aug 2017 10:42:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: null pointer reference after crash
Message-ID: <20170828174238.GE4757@magnolia>
References: <ED0CA266-63AF-4A99-A8B9-DC4C452EC217@flyingcircus.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ED0CA266-63AF-4A99-A8B9-DC4C452EC217@flyingcircus.io>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christian Theune <ct@flyingcircus.io>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 28, 2017 at 07:23:19PM +0200, Christian Theune wrote:
> Hi,
> 
> we stumbled over this today as a host rebooted with an unrelated (iommu)
> kernel crash and got completely stuck after this:
> 
> I’m currently running xfs_repair on all disks and will then see whether this
> will resolve, still I guess you want to know about it. Kernel is 4.9.43
> vanilla. Let me know if you need more data.

Does commit cd87d8679201 ("xfs: don't crash on unexpected holes in dir/attr
btrees") fix this problem?  It'll be in 4.13, maybe someone can backport it
to 4.9?

(Assuming you can get it to reproduce reliably?)

((Wish I could figure out how we end up with a corrupt-looking xattr tree
in the first place...))

--D

> 
> Aug 28 15:27:00 cartman09 kernel: [  637.746484] IP: [<ffffffff81312320>] xfs_da3_node_read+0x30/0xb0
> Aug 28 15:27:00 cartman09 kernel: [  637.758513] PGD f325ae067
> Aug 28 15:27:00 cartman09 kernel: [  637.763573] PUD 0
> Aug 28 15:27:00 cartman09 kernel: [  637.767593]
> Aug 28 15:27:00 cartman09 kernel: [  637.770576] Oops: 0000 [#1] SMP
> Aug 28 15:27:00 cartman09 kernel: [  637.776852] Modules linked in: nf_log_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 nf_log_ipv6 nf_log_common xt_LOG xt_limit nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack sch_fq x86_pkg_temp_thermal kvm_intel kvm ixgbe irqbypass nvme crc32c_intel mdio nvme_core acpi_cpufreq nbd nf_conntrack_ftp nf_conntr
> ack dm_zero dm_thin_pool dm_persistent_data dm_bio_prison dm_round_robin dm_multipath xts aesni_intel glue_helper lrw ablk_helper cryptd aes_x86_64 fuse dm_snapshot dm_bufio dm_crypt dm_mirror dm_region_hash dm_log
> Aug 28 15:27:00 cartman09 kernel: [  637.868058] CPU: 1 PID: 10011 Comm: ceph-osd Not tainted 4.9.43 #1
> Aug 28 15:27:00 cartman09 kernel: [  637.880398] Hardware name: Thomas-Krenn.AG X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
> Aug 28 15:27:00 cartman09 kernel: [  637.895168] task: ffff8805de20b900 task.stack: ffffc9002e470000
> Aug 28 15:27:00 cartman09 kernel: [  637.906989] RIP: 0010:[<ffffffff81312320>]  [<ffffffff81312320>] xfs_da3_node_read+0x30/0xb0
> Aug 28 15:27:00 cartman09 kernel: [  637.923869] RSP: 0018:ffffc9002e473cb8  EFLAGS: 00010282
> Aug 28 15:27:00 cartman09 kernel: [  637.934479] RAX: 0000000000000000 RBX: ffff88083fe0d220 RCX: 0000000000000001
> Aug 28 15:27:00 cartman09 kernel: [  637.948724] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc9002e473c70
> Aug 28 15:27:00 cartman09 kernel: [  637.962972] RBP: ffffc9002e473cd8 R08: 000000003a0d15aa R09: ffffc9002e473b50
> Aug 28 15:27:00 cartman09 kernel: [  637.977219] R10: fffffffffffffffe R11: 0000000000000001 R12: ffffc9002e473d08
> Aug 28 15:27:00 cartman09 kernel: [  637.991469] R13: ffff880658318f00 R14: 0000000000000003 R15: 000000003a0d15aa
> Aug 28 15:27:00 cartman09 kernel: [  638.005715] FS:  00007f37c7dd8700(0000) GS:ffff88085fa40000(0000) knlGS:0000000000000000
> Aug 28 15:27:00 cartman09 kernel: [  638.021871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> Aug 28 15:27:00 cartman09 kernel: [  638.033345] CR2: 00000000000000a0 CR3: 0000000f32506000 CR4: 00000000001406e0
> Aug 28 15:27:00 cartman09 kernel: [  638.047592] Stack:
> Aug 28 15:27:00 cartman09 kernel: [  638.051615]  ffffffff81a44fe0 ffffc9002e473cd8 ffffc9002e473dd0 0000000000000003
> Aug 28 15:27:00 cartman09 kernel: [  638.066521]  ffffc9002e473d48 ffffffff81337404 0000000300000008 ffff88076d846040
> Aug 28 15:27:00 cartman09 kernel: [  638.081426]  00000000d2fc5128 ffff880649f47d80 0000000000000000 0000000000000000
> Aug 28 15:27:00 cartman09 kernel: [  638.096331] Call Trace:
> Aug 28 15:27:00 cartman09 kernel: [  638.101226]  [<ffffffff81337404>] xfs_attr3_node_inactive+0x174/0x210
> Aug 28 15:27:00 cartman09 kernel: [  638.114083]  [<ffffffff8133744a>] xfs_attr3_node_inactive+0x1ba/0x210
> Aug 28 15:27:00 cartman09 kernel: [  638.126944]  [<ffffffff813376da>] xfs_attr_inactive+0x23a/0x250
> Aug 28 15:27:00 cartman09 kernel: [  638.138767]  [<ffffffff81350a4b>] xfs_inactive+0x7b/0x110
> Aug 28 15:27:00 cartman09 kernel: [  638.149547]  [<ffffffff81359344>] xfs_fs_destroy_inode+0xa4/0x210
> Aug 28 15:27:00 cartman09 kernel: [  638.161714]  [<ffffffff811c46cb>] destroy_inode+0x3b/0x60
> Aug 28 15:27:00 cartman09 kernel: [  638.172493]  [<ffffffff811c4819>] evict+0x129/0x190
> Aug 28 15:27:00 cartman09 kernel: [  638.182238]  [<ffffffff811c4c4a>] iput+0x19a/0x200
> Aug 28 15:27:00 cartman09 kernel: [  638.191805]  [<ffffffff811b9129>] do_unlinkat+0x129/0x2d0
> Aug 28 15:27:00 cartman09 kernel: [  638.202584]  [<ffffffff811b9d26>] SyS_unlink+0x16/0x20
> Aug 28 15:27:00 cartman09 kernel: [  638.212847]  [<ffffffff81885260>] entry_SYSCALL_64_fastpath+0x13/0x94
> Aug 28 15:27:00 cartman09 kernel: [  638.225706] Code: 55 48 89 e5 41 54 53 4d 89 c4 48 89 fb 48 83 ec 10 48 c7 04 24 e0 4f a4 81 e8 fd fe ff ff 85 c0 75 46 48 85 db 74 41 49 8b 34 24 <48> 8b 96 a0 00 00 00 0f b7 52 08 66 c1 c2 08 66 81 fa be 3e 74
> Aug 28 15:27:00 cartman09 kernel: [  638.265605] RIP  [<ffffffff81312320>] xfs_da3_node_read+0x30/0xb0
> Aug 28 15:27:00 cartman09 kernel: [  638.277809]  RSP <ffffc9002e473cb8>
> Aug 28 15:27:00 cartman09 kernel: [  638.284776] CR2: 00000000000000a0
> Aug 28 15:27:00 cartman09 kernel: [  638.291941] ---[ end trace 4dd737d8c717c6f3 ]—
> 
> . This also lead to more problems in the kernel, specifically:
> 
> Aug 28 15:57:36 cartman09 kernel: [ 2464.661772] swapper/0:
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662250] swapper/8:
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662253] page allocation failure: order:0, mode:0x2080020(GFP_ATOMIC)
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662257] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G      D         4.9.43 #1
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662258] Hardware name: Thomas-Krenn.AG X9DR3-F/X9DR3-F, BIOS 3.0a 07/31/2013
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662259]  ffff88107fa83ba8
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662260]  ffffffff813ebcf8 ffffffff81c56c40 0000000000000000 ffff88107fa83c28
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662262]  ffffffff8114835c 020800207fa83b01 ffffffff81c56c40 ffff88107fa83bd0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662263]  ffff881000000010 ffff88107fa83c38 ffff88107fa83be8Call Trace:
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662266]  <IRQ>
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662273]  [<ffffffff813ebcf8>] dump_stack+0x4d/0x65
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662279]  [<ffffffff8114835c>] warn_alloc+0x11c/0x140
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662281]  [<ffffffff8114862d>] __alloc_pages_slowpath+0x23d/0xb70
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662285]  [<ffffffff814f0d33>] ? dma_pte_clear_level+0x113/0x190
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662288]  [<ffffffff81149112>] __alloc_pages_nodemask+0x1b2/0x240
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662290]  [<ffffffff81149312>] __alloc_page_frag+0x172/0x1a0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662293]  [<ffffffff8172da86>] __napi_alloc_skb+0x86/0xd0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662303]  [<ffffffffa05b3558>] ixgbe_clean_rx_irq+0xf8/0x950 [ixgbe]
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662306]  [<ffffffffa05b4a5d>] ixgbe_poll+0x3cd/0x780 [ixgbe]
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662309]  [<ffffffff8173c963>] net_rx_action+0x203/0x350
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662314]  [<ffffffff81887957>] __do_softirq+0xe7/0x256
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662317]  [<ffffffff810637ba>] irq_exit+0x9a/0xa0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662319]  [<ffffffff818876c4>] do_IRQ+0x54/0xd0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662321]  [<ffffffff81885bbf>] common_interrupt+0x7f/0x7f
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662322]  <EOI>
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662327]  [<ffffffff816f060f>] ? cpuidle_enter_state+0x10f/0x250
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662328]  [<ffffffff816f0787>] cpuidle_enter+0x17/0x20
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662332]  [<ffffffff8109ad43>] call_cpuidle+0x23/0x40
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662334]  [<ffffffff8109af61>] cpu_startup_entry+0x101/0x1d0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662338]  [<ffffffff8103ef78>] start_secondary+0xe8/0xf0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662339] Mem-Info:
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662346] active_anon:2251029 inactive_anon:358089 isolated_anon:0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662346]  active_file:551559 inactive_file:11813633 isolated_file:64
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662346]  unevictable:540 dirty:15786 writeback:968 unstable:0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662346]  slab_reclaimable:904481 slab_unreclaimable:150538
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662346]  mapped:308954 shmem:309 pagetables:13475 bounce:0
> Aug 28 15:57:36 cartman09 kernel: [ 2464.662346]  free:35590 free_pcp:5360 free_cma:0
> 
> The system became mostly unusable (with load going into 1000+) after that and I hard-rebooted with disabled services for further diagnostics. xfs_repair seems to finish without finding any major issues.
> 
> Cheers,
> Christian
> 
> --
> Christian Theune · ct@flyingcircus.io · +49 345 219401 0
> Flying Circus Internet Operations GmbH · http://flyingcircus.io
> Forsterstraße 29 · 06112 Halle (Saale) · Deutschland
> HR Stendal HRB 21169 · Geschäftsführer: Christian Theune, Christian Zagrodnick
> 


