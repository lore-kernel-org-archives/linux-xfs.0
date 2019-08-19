Return-Path: <SRS0=Z/aa=WP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A0BDC3A59D
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 05:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F6FB2186A
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Aug 2019 05:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725308AbfHSFcg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Aug 2019 01:32:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:44390 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbfHSFce (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Aug 2019 01:32:34 -0400
Received: from dread.disaster.area (pa49-195-190-67.pa.nsw.optusnet.com.au [49.195.190.67])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6BF4E43CA07;
        Mon, 19 Aug 2019 15:32:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hzaGI-0002dO-UK; Mon, 19 Aug 2019 15:31:22 +1000
Date:   Mon, 19 Aug 2019 15:31:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "hch@lst.de" <hch@lst.de>
Cc:     "Verma, Vishal L" <vishal.l.verma@intel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "darrick.wong@oracle.com" <darrick.wong@oracle.com>
Subject: Re: 5.3-rc1 regression with XFS log recovery
Message-ID: <20190819053122.GK7777@dread.disaster.area>
References: <e49a6a3a244db055995769eb844c281f93e50ab9.camel@intel.com>
 <20190818071128.GA17286@lst.de>
 <20190818074140.GA18648@lst.de>
 <20190818173426.GA32311@lst.de>
 <20190819000831.GX6129@dread.disaster.area>
 <20190819034948.GA14261@lst.de>
 <20190819041132.GA14492@lst.de>
 <20190819042259.GZ6129@dread.disaster.area>
 <20190819042905.GA15613@lst.de>
 <20190819044012.GA15800@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190819044012.GA15800@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=TR82T6zjGmBjdfWdGgpkDw==:117 a=TR82T6zjGmBjdfWdGgpkDw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=xAeBvYnfuLZ8Kf4c2UMA:9 a=AxqAjZ1by4VIfd6S:21
        a=UqQ2pm4bXvWXesqj:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 19, 2019 at 06:40:12AM +0200, hch@lst.de wrote:
> On Mon, Aug 19, 2019 at 06:29:05AM +0200, hch@lst.de wrote:
> > On Mon, Aug 19, 2019 at 02:22:59PM +1000, Dave Chinner wrote:
> > > That implies a kmalloc heap issue.
> > > 
> > > Oh, is memory poisoning or something that modifies the alignment of
> > > slabs turned on?
> > > 
> > > i.e. 4k/8k allocations from the kmalloc heap slabs might not be
> > > appropriately aligned for IO, similar to the problems we have with
> > > the xen blk driver?
> > 
> > That is what I suspect, and as you can see in the attached config I
> > usually run with slab debuggig on.
> 
> Yep, looks like an unaligned allocation:

*nod*

> With the following debug patch.  Based on that I think I'll just
> formally submit the vmalloc switch as we're at -rc5, and then we
> can restart the unaligned slub allocation drama..

But I'm not so sure that's all there is to it. I turned KASAN on and
it works for the first few mkfs/mount cycles, then a mount basically
pegs a CPU and it's spending most of it's time inside KASAN
accouting code like this:

.....
  save_stack+0x19/0x80
  __kasan_kmalloc.constprop.10+0xc1/0xd0
  kmem_cache_alloc+0xd2/0x220
  mempool_alloc+0xda/0x230
  bio_alloc_bioset+0x12d/0x2d0
  xfs_rw_bdev+0x53/0x290
  xlog_do_io+0xd1/0x1c0
  xlog_bread+0x23/0x70
  xlog_rseek_logrec_hdr+0x207/0x2a0

After a couple of minutes, the mount fails an ASSERT:

XFS: Assertion failed: head_blk != tail_blk, file: fs/xfs/xfs_log_recover.c, line: 5236

And moments after KASAN spews this:

 BUG: KASAN: use-after-free in rwsem_down_read_slowpath+0x685/0x8f0
 Read of size 4 at addr ffff88806f152778 by task systemd-udevd/2231
 
 CPU: 4 PID: 2231 Comm: systemd-udevd Tainted: G      D           5.3.0-rc5-dgc+ #1506
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
 Call Trace:
  dump_stack+0x7c/0xc0
  print_address_description+0x6c/0x322
  ? rwsem_down_read_slowpath+0x685/0x8f0
  __kasan_report.cold.6+0x1c/0x3e
  ? rwsem_down_read_slowpath+0x685/0x8f0
  ? rwsem_down_read_slowpath+0x685/0x8f0
  kasan_report+0xe/0x12
  rwsem_down_read_slowpath+0x685/0x8f0
  ? unwind_get_return_address_ptr+0x50/0x50
  ? unwind_next_frame+0x6d6/0x8a0
  ? __down_timeout+0x1c0/0x1c0
  ? unwind_next_frame+0x6d6/0x8a0
  ? _raw_spin_lock+0x87/0xe0
  ? _raw_spin_lock+0x87/0xe0
  ? __cpuidle_text_end+0x5/0x5
  ? set_init_blocksize+0xe0/0xe0
  ? preempt_count_sub+0x43/0x50
  ? __might_sleep+0x31/0xd0
  ? set_init_blocksize+0xe0/0xe0
  ? ___might_sleep+0xc8/0xe0
  down_read+0x18d/0x1a0
  ? refcount_sub_and_test_checked+0xaf/0x150
  ? rwsem_down_read_slowpath+0x8f0/0x8f0
  ? _raw_spin_lock+0x87/0xe0
  __get_super.part.12+0xf8/0x130
  fsync_bdev+0xf/0x60
  invalidate_partition+0x1e/0x40
  rescan_partitions+0x8a/0x420
  blkdev_reread_part+0x1e/0x30
  blkdev_ioctl+0xb0b/0xe60
  ? __blkdev_driver_ioctl+0x80/0x80
  ? __bpf_prog_run64+0xc0/0xc0
  ? stack_trace_save+0x8a/0xb0
  ? save_stack+0x4d/0x80
  ? __seccomp_filter+0x133/0xa10
  ? preempt_count_sub+0x43/0x50
  block_ioctl+0x6d/0x80
  do_vfs_ioctl+0x134/0x9c0
  ? ioctl_preallocate+0x140/0x140
  ? selinux_file_ioctl+0x2b7/0x360
  ? selinux_capable+0x20/0x20
  ? syscall_trace_enter+0x233/0x540
  ksys_ioctl+0x60/0x90
  __x64_sys_ioctl+0x3d/0x50
  do_syscall_64+0x70/0x230
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
 RIP: 0033:0x7fade328a427
 Code: 00 00 90 48 8b 05 69 aa 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 39 aa 0c 00 8
 RSP: 002b:00007ffdc4755928 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007fade328a427
 RDX: 0000000000000000 RSI: 000000000000125f RDI: 000000000000000e
 RBP: 0000000000000000 R08: 0000559597306140 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000246 R12: 000055959736dbc0
 R13: 0000000000000000 R14: 00007ffdc47569c8 R15: 000055959730dac0

 Allocated by task 4739:
  save_stack+0x19/0x80
  __kasan_kmalloc.constprop.10+0xc1/0xd0
  kmem_cache_alloc_node+0xf3/0x240
  copy_process+0x1f91/0x2f20
  _do_fork+0xe0/0x530
  __x64_sys_clone+0x10e/0x160
  do_syscall_64+0x70/0x230
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

 Freed by task 0:
  save_stack+0x19/0x80
  __kasan_slab_free+0x12e/0x180
  kmem_cache_free+0x84/0x2c0
  rcu_core+0x35f/0x810
  __do_softirq+0x15f/0x476

 The buggy address belongs to the object at ffff888237048000
  which belongs to the cache task_struct of size 9792
 The buggy address is located 56 bytes inside of
  9792-byte region [ffff888237048000, ffff88823704a640)
 The buggy address belongs to the page:
 page:ffffea0008dc1200 refcount:1 mapcount:0 mapping:ffff888078a91800 index:0x0 compound_mapcount: 0
 flags: 0x57ffffc0010200(slab|head)
 raw: 0057ffffc0010200 dead000000000100 dead000000000122 ffff888078a91800
 raw: 0000000000000000 0000000000030003 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff888237047f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff888237047f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff888237048000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                         ^
  ffff888237048080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888237048100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ==================================================================

Oh, hell, it's an rwsem that is referencing a free task.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
