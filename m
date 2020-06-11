Return-Path: <SRS0=ihlG=7Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B560CC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 03:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E1EE207C3
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Jun 2020 03:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFKDBw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 10 Jun 2020 23:01:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5817 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbgFKDBw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Jun 2020 23:01:52 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 00293EE64CDBDF1ADB57;
        Thu, 11 Jun 2020 11:01:49 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.204) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 11 Jun 2020
 11:01:39 +0800
Subject: Re: [RFC PATCH] fix use after free in xlog_wait()
To:     Dave Chinner <david@fromorbit.com>
CC:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>
References: <20200611013952.2589997-1-yukuai3@huawei.com>
 <20200611022848.GQ2040@dread.disaster.area>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <c07ba74e-81a4-2060-db82-8d11c6400be8@huawei.com>
Date:   Thu, 11 Jun 2020 11:01:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200611022848.GQ2040@dread.disaster.area>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.204]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2020/6/11 10:28, Dave Chinner wrote
> Actually, it's a lot simpler:
> 
> thread1			thread2
> 
> __xfs_trans_commit
>   xfs_log_commit_cil
>    xlog_wait
>     schedule
> 			xlog_cil_push_work
> 			wake_up_all
> 			<shutdown aborts commit>
> 			xlog_cil_committed
> 			kmem_free
> 
>     remove_wait_queue
>      spin_lock_irqsave --> UAF
> 

It's ture in this case, however, I got another result when I
tried to reporduce it, which seems 'ctx' can be freed in a
different path:

[   64.975996] run fstests generic/019 at 2020-06-10 16:13:44
[   69.126208] xfs filesystem being mounted at /tmp/scratch supports 
timestamps until 2038 (0x7fffffff)
[   99.166846] XFS (sdb): log I/O error -5
[   99.170111] XFS (sdb): Log I/O Error Detected. Shutting down filesystem
[   99.171071] XFS (sdb): Please unmount the filesystem and rectify the 
problem(s)
[   99.179569] ------------[ cut here ]------------
[   99.180432] WARNING: CPU: 7 PID: 2705 at fs/iomap/buffered-io.c:1030 
iomap_page_mkwrite_actor+0x17d/0x1b0
[   99.181273] 
==================================================================
[   99.181758] Modules linked in:
[   99.182806] BUG: KASAN: use-after-free in do_raw_spin_trylock+0x67/0x180
[   99.183255] CPU: 7 PID: 2705 Comm: fio Not tainted 
5.7.0-next-20200602+ #29
[   99.184166] Read of size 4 at addr ffff888115f28868 by task fio/2704
[   99.184171]
[   99.185142] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 
04/01/2014
[   99.185995] CPU: 6 PID: 2704 Comm: fio Not tainted 
5.7.0-next-20200602+ #29
[   99.186227] RIP: 0010:iomap_page_mkwrite_actor+0x17d/0x1b0
[   99.188199] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.fedoraproject.org-3.fc31 
04/01/2014
[   99.189178] Code: 89 ef e8 a6 d4 c7 ff e9 3f ff ff ff e8 fc 64 ad ff 
89 da 31 f6 48 89 ef e8 b0 1e f2 ff 49 89 dc e9 26 ff ff ff e8 e3 64 ad 
ff <0f> 0b eb be e8 da 64 ad ff 4d 8d 67 ffe
[   99.189899] Call Trace:
[   99.191748] RSP: 0000:ffff88810599fa18 EFLAGS: 00010293
[   99.194218]  dump_stack+0xf6/0x16e
[   99.194574] RAX: ffff888106df3680 RBX: 0000000000001000 RCX: 
ffffffff94338cad
[   99.195301]  ? do_raw_spin_trylock+0x67/0x180
[   99.195777] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 
0000000000000001
[   99.195786] RBP: ffffea0002544800 R08: ffff888106df3680 R09: 
fffff940004a8901
[   99.196764]  ? do_raw_spin_trylock+0x67/0x180
[   99.196778]  print_address_description.constprop.0.cold+0xd3/0x415
[   99.197393] R10: ffffea0002544807 R11: fffff940004a8900 R12: 
0000000000000000
[   99.198380]  ? do_raw_spin_trylock+0x67/0x180
[   99.199349] R13: 0000000000000000 R14: ffff8880b6ee7280 R15: 
ffffea00025447c8
[   99.199939]  kasan_report.cold+0x1f/0x37
[   99.199949]  ? __switch_to+0x510/0xef0
[   99.200812] FS:  00007ff7d8562740(0000) GS:ffff88811a400000(0000) 
knlGS:0000000000000000
[   99.201755]  ? do_raw_spin_trylock+0x67/0x180
[   99.201765]  check_memory_region+0x14e/0x1b0
[   99.202378] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   99.203319]  do_raw_spin_trylock+0x67/0x180
[   99.203858] CR2: 00007ff7ae3e4ff0 CR3: 00000001028be000 CR4: 
00000000000006e0
[   99.204374]  ? do_raw_spin_lock+0x290/0x290
[   99.205470] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   99.206069]  _raw_spin_lock_irqsave+0x44/0x80
[   99.206641] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[   99.206647] Call Trace:
[   99.207420]  ? remove_wait_queue+0x22/0x190
[   99.208014]  iomap_apply+0x2d7/0xc00
[   99.208949]  remove_wait_queue+0x22/0x190
[   99.209539]  ? iomap_page_create+0x350/0x350
[   99.210510]  xfs_log_commit_cil+0x1c7e/0x2940
[   99.211115]  ? trace_event_raw_event_iomap_apply+0x430/0x430
[   99.212073]  ? xlog_cil_empty+0x90/0x90
[   99.212421]  ? down_write_trylock+0x2f0/0x2f0
[   99.212979]  ? check_flags.part.0+0x430/0x430
[   99.213486]  ? update_time+0xc0/0xc0
[   99.214025]  ? wake_up_q+0x140/0x140
[   99.214610]  iomap_page_mkwrite+0x26a/0x3b0
[   99.215201]  ? xlog_ticket_alloc+0x3e0/0x3e0
[   99.215966]  ? iomap_page_create+0x350/0x350
[   99.216487]  ? __kasan_kmalloc.constprop.0+0xc2/0xd0
[   99.217097]  __xfs_filemap_fault.constprop.0+0x32f/0x4e0
[   99.217675]  __xfs_trans_commit+0x2b3/0xf20
[   99.218206]  do_page_mkwrite+0x1b1/0x470
[   99.218681]  ? xfs_trans_unreserve_and_mod_sb+0xab0/0xab0
[   99.219259]  do_wp_page+0x9e7/0x1b10
[   99.219838]  ? xfs_isilocked+0x8c/0x2f0
[   99.220439]  ? finish_mkwrite_fault+0x4b0/0x4b0
[   99.221102]  ? xfs_trans_log_inode+0x1b2/0x480
[   99.221817]  ? do_user_addr_fault+0x2fd/0xd42
[   99.222382]  xfs_vn_update_time+0x40a/0x730
[   99.222922]  handle_mm_fault+0x1c9f/0x3600
[   99.223634]  ? xfs_setattr_mode.isra.0+0xb0/0xb0
[   99.224140]  ? __pmd_alloc+0x390/0x390
[   99.224653]  ? current_time+0xad/0x110
[   99.225278]  ? vmacache_find+0x5a/0x2a0
[   99.225861]  ? timestamp_truncate+0x2f0/0x2f0
[   99.226461]  do_user_addr_fault+0x635/0xd42
[   99.227019]  ? xfs_setattr_mode.isra.0+0xb0/0xb0
[   99.227029]  update_time+0x75/0xc0
[   99.227760]  exc_page_fault+0x12a/0x6f0
[   99.228377]  file_update_time+0x2bc/0x490
[   99.228889]  ? asm_exc_page_fault+0x8/0x30
[   99.229414]  ? update_time+0xc0/0xc0
[   99.229933]  asm_exc_page_fault+0x1e/0x30
[   99.230515]  ? __sb_start_write+0x225/0x3f0
[   99.231099] RIP: 0033:0x7ff7d709636a
[   99.231743]  ? __sb_start_write+0x1a3/0x3f0
[   99.231755]  __xfs_filemap_fault.constprop.0+0x313/0x4e0
[   99.232230] Code: Bad RIP value.
[   99.232747]  do_page_mkwrite+0x1b1/0x470
[   99.233296] RSP: 002b:00007ffd89c6e2a8 EFLAGS: 00010206
[   99.233841]  do_wp_page+0x9e7/0x1b10
[   99.234333] RAX: 00007ff7ae3e4000 RBX: 000000000159c280 RCX: 
000000000159d3d0
[   99.234863]  ? finish_mkwrite_fault+0x4b0/0x4b0
[   99.235432] RDX: 0000000000000fc0 RSI: 000000000159c420 RDI: 
00007ff7ae3e4000
[   99.235906]  ? _raw_spin_unlock_irq+0x24/0x30
[   99.236485] RBP: 00007ff7af493190 R08: 0000000000000000 R09: 
00007ff7ae3e4ff0
[   99.237198]  handle_mm_fault+0x1c9f/0x3600
[   99.237638] R10: 00007ffd89d04000 R11: 00007ff7ae3e4ff0 R12: 
0000000000000001
[   99.238163]  ? __pmd_alloc+0x390/0x390
[   99.238861] R13: 0000000000001000 R14: 000000000159c2a8 R15: 
00007ff7af493198
[   99.238874] irq event stamp: 0
[   99.239368]  ? vmacache_find+0x5a/0x2a0
[   99.240324] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   99.240946]  do_user_addr_fault+0x635/0xd42
[   99.241903] hardirqs last disabled at (0): [<ffffffff93b3715c>] 
copy_process+0x182c/0x64b0
[   99.242488]  exc_page_fault+0x12a/0x6f0
[   99.243447] softirqs last  enabled at (0): [<ffffffff93b371fd>] 
copy_process+0x18cd/0x64b0
[   99.244001]  ? asm_exc_page_fault+0x8/0x30
[   99.244959] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   99.244965] ---[ end trace a1aa182be3fbd861 ]---
[   99.245482]  asm_exc_page_fault+0x1e/0x30
[   99.254277] RIP: 0033:0x7ff7d709636a
[   99.254749] Code: Bad RIP value.
[   99.255182] RSP: 002b:00007ffd89c6e2a8 EFLAGS: 00010206
[   99.255879] RAX: 00007ff7ae7f5000 RBX: 000000000159c280 RCX: 
000000000159d3d0
[   99.256815] RDX: 0000000000000fc0 RSI: 000000000159c420 RDI: 
00007ff7ae7f5000
[   99.257760] RBP: 00007ff7af47a3a0 R08: 0000000000000000 R09: 
00007ff7ae7f5ff0
[   99.258720] R10: 00007ffd89d04000 R11: 00007ff7ae7f5ff0 R12: 
0000000000000001
[   99.259727] R13: 0000000000001000 R14: 000000000159c2a8 R15: 
00007ff7af47a3a8
[   99.260722]
[   99.260934] Allocated by task 986:
[   99.261403]  save_stack+0x1b/0x40
[   99.261843]  __kasan_kmalloc.constprop.0+0xc2/0xd0
[   99.262483]  __kmalloc+0x179/0x3e0
[   99.262937]  kmem_alloc+0x175/0x4a0
[   99.263416]  xlog_cil_push_work+0x104/0x1250
[   99.264038]  process_one_work+0xa62/0x1840
[   99.264583]  worker_thread+0xa3/0x1050
[   99.265087]  kthread+0x35a/0x470
[   99.265520]  ret_from_fork+0x22/0x30
[   99.266021]
[   99.266238] Freed by task 1123:
[   99.266658]  save_stack+0x1b/0x40
[   99.267095]  __kasan_slab_free+0x117/0x160
[   99.267652]  kfree+0xdf/0x320
[   99.268070]  kvfree+0x47/0x50
[   99.268500]  xlog_cil_committed+0xaf0/0xf80
[   99.269104]  xlog_cil_process_committed+0xfe/0x1e0
[   99.269743]  xlog_state_do_callback+0x513/0x9b0
[   99.270335]  xfs_log_force_umount+0x2d6/0x4a0
[   99.270925]  xfs_do_force_shutdown+0xa2/0x220
[   99.271514]  xlog_ioend_work+0x13a/0x240
[   99.272042]  process_one_work+0xa62/0x1840
[   99.272582]  worker_thread+0xa3/0x1050
[   99.273104]  kthread+0x35a/0x470
[   99.273527]  ret_from_fork+0x22/0x30
[   99.274008]
[   99.274221] The buggy address belongs to the object at ffff888115f28800
[   99.274221]  which belongs to the cache kmalloc-512 of size 512
[   99.275821] The buggy address is located 104 bytes inside of
[   99.275821]  512-byte region [ffff888115f28800, ffff888115f28a00)
[   99.277477] The buggy address belongs to the page:
[   99.278121] page:ffffea000457ca00 refcount:1 mapcount:0 
mapping:0000000000000000 index:0x0 head:ffffea000457ca00 order:3 
compound_mapcount:0 compound_pincount:0
[   99.279988] flags: 0x200000000010200(slab|head)
[   99.280582] raw: 0200000000010200 ffffea0004156c00 0000000400000004 
ffff888117c0e580
[   99.281615] raw: 0000000000000000 0000000080200020 00000001ffffffff 
0000000000000000
[   99.282615] page dumped because: kasan: bad access detected
[   99.283364]
[   99.283585] Memory state around the buggy address:
[   99.284227]  ffff888115f28700: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[   99.285206]  ffff888115f28780: fc fc fc fc fc fc fc fc fc fc fc fc fc 
fc fc fc
[   99.286164] >ffff888115f28800: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[   99.287116]                                                           ^
[   99.287962]  ffff888115f28880: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[   99.288915]  ffff888115f28900: fb fb fb fb fb fb fb fb fb fb fb fb fb 
fb fb fb
[   99.289874] 
==================================================================

Thanks!
Yu Kuai

