Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751172AbeEVMzQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 May 2018 08:55:16 -0400
Date: Tue, 22 May 2018 08:55:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: kernel BUG at fs/xfs/xfs_message.c:113
Message-ID: <20180522125514.GD3751@bfoster.bfoster>
References: <20180516195621.GC54864@canopus.corp.1gb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180516195621.GC54864@canopus.corp.1gb.ru>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alexey Vlasov <renton@renton.name>
Cc: linux-xfs@vger.kernel.org

On Wed, May 16, 2018 at 10:56:21PM +0300, Alexey Vlasov wrote:
> Hi,
> 
> I have got from time to time this bug on my server. I can not reproduce
> it that happens randomly. 
> 
> I found similar issue:
> https://www.spinics.net/lists/xfs/msg42484.html
> but that patch already merged with kernel 4.9.95 which I use.
> 
> Any ideas how to fix this?
> 

For anything finobt related I'd probably start with trying upstream
commit ad90bb585c ("xfs: account finobt blocks properly in perag
reservation"). It looks like the commit it fixes (referenced in the
commit log) is present in v4.9.95, but I don't see this one anywhere in
the v4.9 stable branch (not sure if it came in a later branch or not at
all...).

Brian

> trace in attach

> May 12 04:10:39 ul14 kernel: XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
> May 12 04:10:39 ul14 kernel: ------------[ cut here ]------------
> May 12 04:10:39 ul14 kernel: kernel BUG at fs/xfs/xfs_message.c:113!
> May 12 04:10:39 ul14 kernel: invalid opcode: 0000 [#1] SMP
> May 12 04:10:39 ul14 kernel: Modules linked in: dm_cache_smq ixgbe mdio x86_pkg_temp_thermal dm_cache dm_bio_prison dm_persistent_data dm_bufio sg
> May 12 04:10:39 ul14 kernel: CPU: 3 PID: 15696 Comm: unlink Not tainted 4.9.95-gcm-efi #1
> May 12 04:10:39 ul14 kernel: Hardware name: Intel Corporation S2600WTTR/S2600WTTR, BIOS SE5C610.86B.01.01.0020.122820161512 12/28/2016
> May 12 04:10:39 ul14 kernel: task: ffff880a20e00000 task.stack: ffffc9001c914000
> May 12 04:10:39 ul14 kernel: RIP: 0010:[<ffffffff812b273d>]  [<ffffffff812b273d>] assfail+0x1d/0x20
> May 12 04:10:39 ul14 kernel: RSP: 0018:ffffc9001c9177b0  EFLAGS: 00010282
> May 12 04:10:39 ul14 kernel: RAX: 00000000ffffffea RBX: ffff88074c9bb000 RCX: 0000000000000021
> May 12 04:10:39 ul14 kernel: RDX: ffffc9001c9176d8 RSI: 000000000000000a RDI: ffffffff819a735b
> May 12 04:10:39 ul14 kernel: RBP: ffffc9001c9177b0 R08: 0000000000000000 R09: 0000000000000000
> May 12 04:10:39 ul14 kernel: R10: 000000000000000a R11: f000000000000000 R12: ffffffffffffffff
> May 12 04:10:39 ul14 kernel: R13: ffff88180f5f1000 R14: ffff88180f5f1000 R15: ffffc9001c917868
> May 12 04:10:39 ul14 kernel: FS:  00007fd35c567700(0000) GS:ffff88181f8c0000(0000) knlGS:0000000000000000
> May 12 04:10:39 ul14 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> May 12 04:10:39 ul14 kernel: CR2: 00007fd35c08fb20 CR3: 00000006695de000 CR4: 0000000000360670
> May 12 04:10:39 ul14 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> May 12 04:10:39 ul14 kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> May 12 04:10:39 ul14 kernel: Stack:
> May 12 04:10:39 ul14 kernel:  ffffc9001c9177d8 ffffffff812bb9be ffffc9001c917868 0000000000000000
> May 12 04:10:39 ul14 kernel:  0000000000000000 ffffc9001c917800 ffffffff81288cbb ffffc9001c917868
> May 12 04:10:39 ul14 kernel:  0000000000c80000 0000000001000000 ffffc9001c917818 ffffffff81247ed0
> May 12 04:10:39 ul14 kernel: Call Trace:
> May 12 04:10:39 ul14 kernel:  [<ffffffff812bb9be>] xfs_trans_mod_sb+0x1fe/0x290
> May 12 04:10:39 ul14 kernel:  [<ffffffff81288cbb>] xfs_ag_resv_alloc_extent+0x9b/0xc0
> May 12 04:10:39 ul14 kernel:  [<ffffffff81247ed0>] xfs_alloc_ag_vextent+0x130/0x330
> May 12 04:10:39 ul14 kernel:  [<ffffffff81249044>] xfs_alloc_vextent+0x544/0x6a0
> May 12 04:10:39 ul14 kernel:  [<ffffffff812836f1>] __xfs_inobt_alloc_block+0x91/0x110
> May 12 04:10:39 ul14 kernel:  [<ffffffff8128378f>] xfs_finobt_alloc_block+0xf/0x20
> May 12 04:10:39 ul14 kernel:  [<ffffffff81267246>] __xfs_btree_split+0xb6/0xae0
> May 12 04:10:39 ul14 kernel:  [<ffffffff8134e5ed>] ? list_del+0xd/0x30
> May 12 04:10:39 ul14 kernel:  [<ffffffff8113e766>] ? memcg_kmem_charge+0x56/0xd0
> May 12 04:10:39 ul14 kernel:  [<ffffffff812bd54e>] ? uuid_equal+0xe/0x20
> May 12 04:10:39 ul14 kernel:  [<ffffffff81262167>] ? xfs_btree_check_sblock+0xc7/0x1b0
> May 12 04:10:39 ul14 kernel:  [<ffffffff81267d34>] xfs_btree_split+0x34/0xc0
> May 12 04:10:39 ul14 kernel:  [<ffffffff8112bf15>] ? kmem_cache_alloc+0xb5/0x100
> May 12 04:10:39 ul14 kernel:  [<ffffffff81268d3f>] xfs_btree_make_block_unfull+0xef/0x160
> May 12 04:10:39 ul14 kernel:  [<ffffffff812691ad>] xfs_btree_insrec+0x3fd/0xbd0
> May 12 04:10:39 ul14 kernel:  [<ffffffff812d16d8>] ? xfs_trans_read_buf_map+0x268/0x300
> May 12 04:10:39 ul14 kernel:  [<ffffffff81269a1f>] xfs_btree_insert+0x9f/0x220
> May 12 04:10:39 ul14 kernel:  [<ffffffff812837d9>] ? xfs_inobt_init_cursor+0x39/0xc0
> May 12 04:10:39 ul14 kernel:  [<ffffffff812804a5>] xfs_difree_finobt+0xa5/0x290
> May 12 04:10:39 ul14 kernel:  [<ffffffff812826d7>] xfs_difree+0xf7/0x1e0
> May 12 04:10:39 ul14 kernel:  [<ffffffff812ae9a6>] xfs_ifree+0xb6/0x260
> May 12 04:10:39 ul14 kernel:  [<ffffffff812aebf7>] xfs_inactive_ifree+0xa7/0x250
> May 12 04:10:39 ul14 kernel:  [<ffffffff812aee90>] xfs_inactive+0xf0/0x250
> May 12 04:10:39 ul14 kernel:  [<ffffffff812b7491>] xfs_fs_destroy_inode+0xa1/0x210
> May 12 04:10:39 ul14 kernel:  [<ffffffff8115f966>] destroy_inode+0x36/0x60
> May 12 04:10:39 ul14 kernel:  [<ffffffff8115faa7>] evict+0x117/0x170
> May 12 04:10:39 ul14 kernel:  [<ffffffff81160143>] iput+0x133/0x1a0
> May 12 04:10:39 ul14 kernel:  [<ffffffff8115551b>] do_unlinkat+0x17b/0x290
> May 12 04:10:39 ul14 kernel:  [<ffffffff81155da1>] SyS_unlink+0x11/0x20
> May 12 04:10:39 ul14 kernel:  [<ffffffff81001426>] do_syscall_64+0x56/0xc0
> May 12 04:10:39 ul14 kernel:  [<ffffffff8166f93e>] entry_SYSCALL_64_after_swapgs+0x58/0xc6
> May 12 04:10:39 ul14 kernel: Code: 48 c7 c7 1f d9 9c 81 e8 72 dc d9 ff 5d c3 55 48 89 f1 41 89 d0 48 c7 c6 e0 84 9e 81 48 89 fa 48 89 e5 31 ff 31 c0 e8 63 fa ff ff <0f> 0b 90 55 48 63 f6 49 89 f9 41 b8 01 00 00 00 48 89 e5 48 83
> May 12 04:10:39 ul14 kernel: RIP  [<ffffffff812b273d>] assfail+0x1d/0x20
> May 12 04:10:39 ul14 kernel:  RSP <ffffc9001c9177b0>
> May 12 04:10:39 ul14 kernel: ---[ end trace ca888781a46423f8 ]---

