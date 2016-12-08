Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46974 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbcLHGfe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 01:35:34 -0500
Date: Wed, 7 Dec 2016 22:35:03 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161208063503.GJ8436@birch.djwong.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161205143906.GA16352@infradead.org>
 <20161205153625.GA20032@infradead.org>
 <20161205182802.GB8436@birch.djwong.org>
 <20161206144559.GA14623@infradead.org>
 <20161207034903.GX16813@birch.djwong.org>
 <20161207071857.GA23809@infradead.org>
 <20161207174032.GA1072@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161207174032.GA1072@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 09:40:32AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 06, 2016 at 11:18:57PM -0800, Christoph Hellwig wrote:
> > > Wellll... I cobbled together a crappy patch that flips on
> > > XFS_AG_RESV_AGFL if xfs_bmap_extents_to_btree really can't get a block.
> > > It seems to have survived ~175 iterations of xfs/109 so I'll try to
> > > clean it up tomorrow.
> > 
> > I tried it with XFS_AG_RESV_METADATA, but that didn't work.  But then
> > again I didn't add an additional reservation and I was about to head
> > out for dinner so I didn't investigate the details.  It might have been
> > the case Ross pointed out yeserday, so I'll look into the details more
> > today.
> 
> XFS_AG_RESV_AGFL works.  For some kinds of "work".  I can't see the
> original issue anymore, but I can see this related assert a lot (which
> I've also seen before, but no as often), so there is some more I need
> to look into.

I bet that assert is a result of the btree insert failing to find a new
block to expand into.  I've felt for a while that we ought to yell ENOSPC
louder when this happens, since I've hit it numerous times and grumbled
about it not being obvious that we ran out of space.

Anyway, XFS_AG_RESV_AGFL only gets a reservation if rmapbt=1 (or if you
added an additional reservation after dinner), so if you're running
reflink only then it's not surprising that it still runs out of space,
since reflink=1 only reserves RESV_METADATA space.

In any case I'm persuaded that we're failing to account for that bmbt
expansion block when we make the first allocation.  AFAICT in
xfs_bmapi_allocate we ask the allocator for exactly as many blocks as we
need to satisfy the data block write; if there are exactly that many
blocks in the last AG then we get blocks out of that last AG.  But then
we have to convert extents_to_btree, so we make a second allocation
request (and we have to start with that same AG) for another block,
which it doesn't have, so it blows up.

It might work to just increase args->minfree if we have an extents file
and think we might have to convert it to btree format.  (It's late, not
going to try this until the morning.)

--D

> [ 2594.324341] XFS: Assertion failed: fs_is_ok, file: fs/xfs/libxfs/xfs_btree.c, line: 3484
> [ 2594.329918] ------------[ cut here ]------------
> [ 2594.330309] kernel BUG at fs/xfs/xfs_message.c:113!
> [ 2594.330641] invalid opcode: 0000 [#1] SMP
> [ 2594.330912] Modules linked in:
> [ 2594.331129] CPU: 2 PID: 29744 Comm: kworker/u8:0 Tainted: G        W 4.9.0-rc1+ #1758
> [ 2594.331680] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
> [ 2594.332353] Workqueue: writeback wb_workfn (flush-252:32)
> [ 2594.332731] task: ffff88000d86ccc0 task.stack: ffffc90009f74000
> [ 2594.333127] RIP: 0010:[<ffffffff815aee1d>]  [<ffffffff815aee1d>] assfail+0x1d/0x20
> [ 2594.333214] RSP: 0018:ffffc90009f774c8  EFLAGS: 00010282
> [ 2594.333214] RAX: 00000000ffffffea RBX: ffff880132b2ac08 RCX: 0000000000000021
> [ 2594.333214] RDX: ffffc90009f773f0 RSI: 000000000000000a RDI: ffffffff8240a75b
> [ 2594.333214] RBP: ffffc90009f774c8 R08: 0000000000000000 R09: 0000000000000000
> [ 2594.333214] R10: 000000000000000a R11: f000000000000000 R12: ffff880132b2ac08
> [ 2594.333214] R13: 0000000000000000 R14: ffffc90009f774ec R15: ffffc90009f775dc
> [ 2594.333214] FS:  0000000000000000(0000) GS:ffff88013fd00000(0000) knlGS:0000000000000000
> [ 2594.333214] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2594.333214] CR2: 00007f7f7c43c6c0 CR3: 0000000002606000 CR4: 00000000000006e0
> [ 2594.333214] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 2594.333214] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 2594.333214] Stack:
> [ 2594.333214]  ffffc90009f77568 ffffffff8154fddc ffffc90009f774ec 000000000000007b
> [ 2594.333214]  0000000009f77568 ffffffffffffffff 0000000000000000 00c01e0000000000
> [ 2594.333214]  1f0000b830000000 ffffffffffffffff 600f000000000000 ffffffff8157102d
> [ 2594.333214] Call Trace:
> [ 2594.333214]  [<ffffffff8154fddc>] xfs_btree_insert+0xac/0x1f0
> [ 2594.333214]  [<ffffffff8157102d>] ? xfs_iext_insert+0xad/0x1e0
> [ 2594.333214]  [<ffffffff81536802>] ? xfs_bmap_add_extent_delay_real+0xe22/0x3670
> [ 2594.333214]  [<ffffffff8153887f>] xfs_bmap_add_extent_delay_real+0x2e9f/0x3670
> [ 2594.333214]  [<ffffffff8154072a>] xfs_bmapi_write+0xb5a/0x1200
> [ 2594.333214]  [<ffffffff815a45ad>] xfs_iomap_write_allocate+0x18d/0x370
> [ 2594.333214]  [<ffffffff81587274>] xfs_map_blocks+0x214/0x460
> [ 2594.333214]  [<ffffffff8158847c>] xfs_do_writepage+0x2bc/0x800
> [ 2594.333214]  [<ffffffff811cbfea>] write_cache_pages+0x1fa/0x5a0
> [ 2594.333214]  [<ffffffff815881c0>] ? xfs_aops_discard_page+0x140/0x140
> [ 2594.333214]  [<ffffffff8158779e>] xfs_vm_writepages+0x9e/0xd0
> [ 2594.333214]  [<ffffffff811ce77c>] do_writepages+0x1c/0x30
> [ 2594.333214]  [<ffffffff8124a84c>] __writeback_single_inode+0x5c/0x6f0
> [ 2594.333214]  [<ffffffff8124bb91>] writeback_sb_inodes+0x2a1/0x5e0
> [ 2594.333214]  [<ffffffff8124c142>] wb_writeback+0x112/0x4f0
> [ 2594.333214]  [<ffffffff8124cc05>] wb_workfn+0x115/0x5f0
> [ 2594.333214]  [<ffffffff810f70fb>] ? process_one_work+0x13b/0x600
> [ 2594.333214]  [<ffffffff810f7181>] process_one_work+0x1c1/0x600
> [ 2594.333214]  [<ffffffff810f70fb>] ? process_one_work+0x13b/0x600
> [ 2594.333214]  [<ffffffff810f7624>] worker_thread+0x64/0x4a0
> [ 2594.333214]  [<ffffffff810f75c0>] ? process_one_work+0x600/0x600
> [ 2594.333214]  [<ffffffff810f75c0>] ? process_one_work+0x600/0x600
> [ 2594.333214]  [<ffffffff810fd2e2>] kthread+0xf2/0x110
> [ 2594.333214]  [<ffffffff810d5a1e>] ? put_task_stack+0x15e/0x190
> [ 2594.333214]  [<ffffffff810fd1f0>] ? kthread_park+0x60/0x60
> [ 2594.333214]  [<ffffffff81e7156a>] ret_from_fork+0x2a/0x40
> 
