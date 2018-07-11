Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56216 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389745AbeGKToO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jul 2018 15:44:14 -0400
Date: Wed, 11 Jul 2018 15:38:21 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: t_firstblock assert triggered from dedup in generic/051
Message-ID: <20180711193821.GA6841@killians.ges.redhat.com>
References: <20180711184241.GA4949@lst.de>
 <20180711190925.GI32415@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180711190925.GI32415@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Jul 11, 2018 at 12:09:25PM -0700, Darrick J. Wong wrote:
> On Wed, Jul 11, 2018 at 08:42:41PM +0200, Christoph Hellwig wrote:
> > I ran into this when testing the rebase of my cow optimization
> > series to the 4.19-merge branch, but from a quick glance it really
> > looks like the t_firstblock series might be at faul.  Feel free
> > to discard if you think it is not, I will retest with my patches
> > tomorrow.
> > 
> > [  635.600041] run fstests generic/051 at 2018-07-11 18:25:22
> > [  635.802443] XFS (vdb): Mounting V5 Filesystem
> > [  635.814103] XFS (vdb): Ending clean mount
> > [  635.992757] XFS (vdc): Mounting V5 Filesystem
> > [  636.000955] XFS (vdc): Ending clean mount
> > [  636.031583] XFS (vdc): Unmounting Filesystem
> > [  636.115131] XFS (vdc): Mounting V5 Filesystem
> > [  636.123271] XFS (vdc): Ending clean mount
> > [  639.538434] XFS: Assertion failed: tp->t_firstblock == NULLFSBLOCK, file: fs/xfs/libxfs5
> > [  639.539893] ------------[ cut here ]------------
> > [  639.540516] kernel BUG at fs/xfs/xfs_message.c:102!
> > [  639.541168] invalid opcode: 0000 [#1] SMP PTI
> > [  639.541814] CPU: 2 PID: 20757 Comm: fsstress Not tainted 4.18.0-rc4+ #3969
> > [  639.542744] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.1-1 04/01/4
> > [  639.543848] RIP: 0010:assfail+0x23/0x30
> > [  639.544470] Code: c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 88 e0 8c 82 48 89 fa  
> > [  639.546396] RSP: 0018:ffff88012dc43c08 EFLAGS: 00010202
> > [  639.546899] RAX: 0000000000000000 RBX: ffff88012dc43ca0 RCX: 0000000000000000
> > [  639.547582] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff828480eb
> > [  639.548273] RBP: ffff88012aa92758 R08: 0000000000000000 R09: 0000000000000000
> > [  639.548954] R10: 0000000000000000 R11: f000000000000000 R12: 0000000000000000
> > [  639.549704] R13: ffff88012dc43d48 R14: ffff88013092e7e8 R15: 0000000000000014
> > [  639.550397] FS:  00007f8d689b8e80(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
> > [  639.551166] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  639.551795] CR2: 00007f8d689c7000 CR3: 000000012ba6a000 CR4: 00000000000006e0
> > [  639.552604] Call Trace:
> > [  639.552896]  xfs_defer_init+0xff/0x160
> > [  639.553331]  xfs_reflink_remap_extent+0x31b/0xa00
> 
> Hmmm, this is one of those functions that does:
> 
> xfs_trans_alloc
> while(...)
> 	xfs_defer_init
> 	...
> 	xfs_defer_finish
> xfs_trans_commit
> 
> Hmm, we set t_firstblock to NULLFSBLOCK in _trans_alloc and _trans_dup,
> which should take care of the preconditions and the defer_finis...
> 
> ...oh, you know what I think it is?  We don't roll the transaction after
> successfully finishing the while (xfs_defer_has_unfinished_work) loop in
> _defer_finish, which means that t_firstblock can be non-null at the
> bottom of that loop, which means that we then trip the assert at the top
> of the loop, just like you saw.
> 
> An extra downside is that _defer_finish returns with a dirty transaction,
> which means that whatever happens afterwards can (in theory) exceed the
> transaction reservation and blow up.  Yikes.
> 

My first thought was whether we could get through that loop with an
allocation or something but without deferring anything, but what you
describe above seems much more likely. Given the next series of
refactoring buries the final defer_finish() in trans_commit(), I'm
wondering if we should just have a defer_finish() wrapper that rolls the
tx a final time, which we can bypass in the trans_commit() case because
we aren't making any more changes to the transaction. Hm?

Brian

> --D
> 
> > [  639.553887]  xfs_reflink_remap_blocks+0xec/0x4a0
> > [  639.554594]  xfs_reflink_remap_range+0x3a1/0x650
> > [  639.555090]  xfs_file_dedupe_range+0x39/0x50
> > [  639.555507]  vfs_dedupe_file_range+0x218/0x260
> > [  639.555943]  do_vfs_ioctl+0x262/0x6a0
> > [  639.556304]  ? __se_sys_newfstat+0x3c/0x60
> > [  639.556698]  ksys_ioctl+0x35/0x60
> > [  639.557024]  __x64_sys_ioctl+0x11/0x20
> > [  639.557392]  do_syscall_64+0x4b/0x190
> > [  639.557752]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > [  639.558271] RIP: 0033:0x7f8d67ec9e07
> > [  639.558621] Code: 00 00 00 48 8b 05 91 80 2b 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff  
> > [  639.560447] RSP: 002b:00007ffd6f26e8c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > [  639.561158] RAX: ffffffffffffffda RBX: 0000000000000044 RCX: 00007f8d67ec9e07
> > [  639.561807] RDX: 000055f7e6801970 RSI: 00000000c0189436 RDI: 0000000000000003
> > [  639.562453] RBP: 000000000000000b R08: 000055f7e67ded60 R09: 000055f7e67ded4c
> > [  639.563098] R10: 0000000000000078 R11: 0000000000000246 R12: 0000000000017000
> > [  639.563740] R13: 000055f7e67dec30 R14: 000055f7e681d118 R15: 0000000000000044
> > [  639.564436] Modules linked in:
> > [  639.564929] ---[ end trace 67fc0dc4de4b6f64 ]---
> > [  639.565471] RIP: 0010:assfail+0x23/0x30
> > [  639.565947] Code: c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 88 e0 8c 82 48 89 fa  
> > [  639.568255] RSP: 0018:ffff88012dc43c08 EFLAGS: 00010202
> > [  639.568823] RAX: 0000000000000000 RBX: ffff88012dc43ca0 RCX: 0000000000000000
> > [  639.569604] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff828480eb
> > [  639.570369] RBP: ffff88012aa92758 R08: 0000000000000000 R09: 0000000000000000
> > [  639.571161] R10: 0000000000000000 R11: f000000000000000 R12: 0000000000000000
> > [  639.571928] R13: ffff88012dc43d48 R14: ffff88013092e7e8 R15: 0000000000000014
> > [  639.572678] FS:  00007f8d689b8e80(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
