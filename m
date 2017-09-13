Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37976 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750992AbdIMQgL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Sep 2017 12:36:11 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8DGZHgS192670
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2017 12:36:11 -0400
Received: from e23smtp07.au.ibm.com (e23smtp07.au.ibm.com [202.81.31.140])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2cy89f8552-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Sep 2017 12:36:10 -0400
Received: from localhost
        by e23smtp07.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 14 Sep 2017 02:36:03 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: Re: [BUG] xfs/104 triggered NULL pointer dereference in iomap based dio
Date: Wed, 13 Sep 2017 22:06:46 +0530
In-Reply-To: <20170913105823.GD8034@eguan.usersys.redhat.com>
References: <20170913105823.GD8034@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Message-Id: <8010113.2DyTjQuL2r@localhost.localdomain>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Wednesday, September 13, 2017 4:28:23 PM IST Eryu Guan wrote:
> Hi all,
> 
> Recently I noticed multiple crashes triggered by xfs/104 on ppc64 hosts
> in my upstream 4.13 kernel testings. The block layer is involved in the
> call trace so I add linux-block to cc list too. I append the full
> console log to the end of this mail.
> 
> Now I can reproduce the crash on x86_64 hosts too by running xfs/104
> many times (usually within 100 iterations). A git-bisect run (I ran it
> for 500 iterations before calling it good in bisect run to be safe)
> pointed the first bad commit to commit acdda3aae146 ("xfs: use
> iomap_dio_rw").
> 
> I confirmed the bisect result by checking out a new branch with commit
> acdda3aae146 as HEAD, xfs/104 would crash kernel within 100 iterations,
> then reverting HEAD, xfs/104 passed 1500 iterations.

I am able to recreate the issue on my ppc64 guest. I added some printk()
statements and got this,

xfs_fs_fill_super:1670: Filled up sb c0000006344db800.
iomap_dio_bio_end_io:784: sb = c0000006344db800; inode->i_sb->s_dio_done_wq =           (null), &dio->aio.work = c0000006344bb5b0.


In iomap_dio_rw(), I had added the following printk() statement,

               ret = sb_init_dio_done_wq(inode->i_sb);
                if (ret < 0)
                        iomap_dio_set_error(dio, ret);
                printk("%s:%d: sb = %p; Created s_dio_done_wq.\n",
                        __func__, __LINE__, inode->i_sb);

In the case of crash, I don't see the above message being printed. 

Btw, I am unable to recreate this issue on today's linux-next though. Maybe
it is because the race condition is accidently masked out.

I will continue debugging this and provide an update.

> 
> On one of my test vms, the crash happened as
> 
> [  340.419429] BUG: unable to handle kernel NULL pointer dereference at 0000000000000102
> [  340.420408] IP: __queue_work+0x32/0x420
> 
> and that IP points to
> 
> (gdb) l *(__queue_work+0x32)
> 0x9cf32 is in __queue_work (kernel/workqueue.c:1383).
> 1378            WARN_ON_ONCE(!irqs_disabled());
> 1379
> 1380            debug_work_activate(work);
> 1381
> 1382            /* if draining, only works from the same workqueue are allowed */
> 1383            if (unlikely(wq->flags & __WQ_DRAINING) &&
> 1384                WARN_ON_ONCE(!is_chained_work(wq)))
> 1385                    return;
> 1386    retry:
> 1387            if (req_cpu == WORK_CPU_UNBOUND)
> 
> So looks like "wq" is null. The test vm is a kvm guest running 4.13
> kernel with 4 vcpus and 8G memory.
> 
> If more information is needed please let me know.
> 
> Thanks,
> Eryu
> 
> P.S. console log when crashing
> 
> [  339.746983] run fstests xfs/104 at 2017-09-13 17:38:26
> [  340.027352] XFS (vda6): Unmounting Filesystem
> [  340.207107] XFS (vda6): Mounting V5 Filesystem
> [  340.217553] XFS (vda6): Ending clean mount
> [  340.419429] BUG: unable to handle kernel NULL pointer dereference at 0000000000000102
> [  340.420408] IP: __queue_work+0x32/0x420
> [  340.420408] PGD 215373067
> [  340.420408] P4D 215373067
> [  340.420408] PUD 21210d067
> [  340.420408] PMD 0
> [  340.420408]
> [  340.420408] Oops: 0000 [#1] SMP
> [  340.420408] Modules linked in: xfs ip6t_rpfilter ipt_REJECT nf_reject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack libcrc32c ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_mangle ip6table_security ip6table_raw iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter btrfs xor raid6_pq ppdev i2c_piix4 parport_pc i2c_core parport virtio_balloon pcspkr nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables ext4 mbcache jbd2 ata_generic pata_acpi virtio_net virtio_blk ata_piix libata virtio_pci virtio_ring serio_raw virtio floppy
> [  340.420408] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 4.13.0 #64
> [  340.420408] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
> [  340.420408] task: ffff8b1d96222500 task.stack: ffffb06bc0cb8000
> [  340.420408] RIP: 0010:__queue_work+0x32/0x420
> [  340.420408] RSP: 0018:ffff8b1d9fd83d18 EFLAGS: 00010046
> [  340.420408] RAX: 0000000000000096 RBX: 0000000000000002 RCX: ffff8b1d9489e6d8
> [  340.420408] RDX: ffff8b1d903c2090 RSI: 0000000000000000 RDI: 0000000000002000
> [  340.420408] RBP: ffff8b1d9fd83d58 R08: 0000000000000400 R09: 0000000000000009
> [  340.420408] R10: ffff8b1d9532b400 R11: 0000000000000000 R12: 0000000000002000
> [  340.420408] R13: 0000000000000000 R14: ffff8b1d903c2090 R15: 0000000000007800
> [  340.420408] FS:  0000000000000000(0000) GS:ffff8b1d9fd80000(0000) knlGS:0000000000000000
> [  340.420408] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  340.420408] CR2: 0000000000000102 CR3: 00000002152ce000 CR4: 00000000000006e0
> [  340.420408] Call Trace:
> [  340.420408]  <IRQ>
> [  340.420408]  ? __slab_free+0x8e/0x260
> [  340.420408]  queue_work_on+0x38/0x40
> [  340.420408]  iomap_dio_bio_end_io+0x86/0x120
> [  340.420408]  bio_endio+0x9f/0x120
> [  340.420408]  blk_update_request+0xa8/0x2f0
> [  340.420408]  blk_mq_end_request+0x1e/0x70
> [  340.420408]  virtblk_request_done+0x22/0x30 [virtio_blk]
> [  340.420408]  __blk_mq_complete_request+0x8f/0x140
> [  340.420408]  blk_mq_complete_request+0x2a/0x30
> [  340.420408]  virtblk_done+0x71/0x100 [virtio_blk]
> [  340.420408]  vring_interrupt+0x34/0x80 [virtio_ring]
> [  340.420408]  __handle_irq_event_percpu+0x7e/0x190
> [  340.420408]  handle_irq_event_percpu+0x32/0x80
> [  340.420408]  handle_irq_event+0x3b/0x60
> [  340.420408]  handle_edge_irq+0x72/0x180
> [  340.420408]  handle_irq+0x6f/0x110
> [  340.420408]  do_IRQ+0x46/0xd0
> [  340.420408]  common_interrupt+0x93/0x93
> [  340.420408] RIP: 0010:native_safe_halt+0x6/0x10
> [  340.420408] RSP: 0018:ffffb06bc0cbbe70 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffae
> [  340.420408] RAX: 0000000000000000 RBX: ffff8b1d96222500 RCX: 0000000000000000
> [  340.420408] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [  340.420408] RBP: ffffb06bc0cbbe70 R08: 000000000679cadf R09: 0000000000000001
> [  340.420408] R10: 000000000001fdfd R11: 0000000000000000 R12: 0000000000000003
> [  340.420408] R13: ffff8b1d96222500 R14: 0000000000000000 R15: 0000000000000000
> [  340.420408]  </IRQ>
> [  340.420408]  default_idle+0x20/0x100
> [  340.420408]  arch_cpu_idle+0xf/0x20
> [  340.420408]  default_idle_call+0x23/0x30
> [  340.420408]  do_idle+0x174/0x1e0
> [  340.420408]  cpu_startup_entry+0x73/0x80
> [  340.420408]  start_secondary+0x156/0x190
> [  340.420408]  secondary_startup_64+0x9f/0x9f
> [  340.420408] Code: 89 e5 41 57 41 56 41 55 41 54 49 89 f5 53 49 89 d6 41 89 fc 48 83 ec 18 89 7d d4 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 0a 03 00 00 <41> f6 85 02 01 00 00 01 0f 85 0c 03 00 00 48 b8 eb 83 b5 80 46
> [  340.420408] RIP: __queue_work+0x32/0x420 RSP: ffff8b1d9fd83d18
> [  340.420408] CR2: 0000000000000102
> [  340.420408] ---[ end trace 4ae4f080188b0b36 ]---
> [  340.420408] Kernel panic - not syncing: Fatal exception in interrupt
> [  340.420408] Shutting down cpus with NMI
> [  340.420408] Kernel Offset: 0x6000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> [  340.420408] ---[ end Kernel panic - not syncing: Fatal exception in interrupt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
chandan

