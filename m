Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:41480 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751186AbeCTQQb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Mar 2018 12:16:31 -0400
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: 4.14.26 XFS: Assertion failed fs/xfs/xfs_message.c
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <6bb0952f-655a-d8a4-b10e-024f6a331722@excello.cz>
Date: Tue, 20 Mar 2018 11:16:29 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <D2466B53-F038-4C7A-95A8-E2CB56484AD9@sandeen.net>
References: <6913e48f-e4ee-0b88-80ec-ed3560cd8894@excello.cz> <d2ff7c02-3ec4-0ec0-ee36-bbfd68ac13a1@sandeen.net> <20180320154434.GC6454@bfoster.bfoster> <6bb0952f-655a-d8a4-b10e-024f6a331722@excello.cz>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tomas Charvat <tc@excello.cz>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

If it is repeatable then I wonder if an xfs_metadump image might help us investigate, as well.

-Eric

> On Mar 20, 2018, at 10:59 AM, Tomas Charvat <tc@excello.cz> wrote:
> 
> meta-data=/dev/sda2              isize=512    agcount=4, agsize=1040320 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1 spinodes=0 rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=4161280, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> log      =internal               bsize=4096   blocks=2560, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> 
> 
> Uptime is 8 days, no large number of files has been changes.
> I have just compiled 4.14.28 to give it a try.
> If you give me hint how to get & apply referenced commit to vanilla I
> will give it a try.
> 
> br
> 
> Tomas Charvat
> EXCELLO | Virusfree
> w: www.virusfree.cz
> e: tc@excello.cz
> 
>> On 03/20/2018 04:44 PM, Brian Foster wrote:
>>> On Tue, Mar 20, 2018 at 10:15:14AM -0500, Eric Sandeen wrote:
>>>> On 3/20/18 9:37 AM, Tomas Charvat wrote:
>>>> Hi in recent versions of kernle-4.14 I'm getting following error.
>>> The unlink transaction overran its reservation.
>>> 
>>> I think this post-4.14 commit may fix it, but perhaps Brian can chime in?
>>> 
>>> commit a6f485908d5210a5662f7a031bd1deeb3867e466
>>> Author: Brian Foster <bfoster@redhat.com>
>>> Date:   Mon Jan 8 10:41:36 2018 -0800
>>> 
>>>    xfs: include inobt buffers in ifree tx log reservation
>>> 
>>> 
>> This looks like a block reservation overrun rather than a log
>> reservation overrun. The above commit addresses the latter and so
>> probably won't help this case.
>> 
>> I'm wondering if you are affected by the metadata perag reservation leak
>> fixed by commit ad90bb585c ("xfs: account finobt blocks properly in
>> perag reservation"). I think that once the perag reservation is
>> depleted, further block allocs might be accounted against the
>> transaction such that an initial reservation is expected (which
>> typically doesn't occur for this transaction).
>> 
>> What is the geometry (xfs_info) of the fs? Has it been mounted for a
>> long time, or long enough to see a large number of inode allocations and
>> frees? Are you able to test the above referenced commit?
>> 
>> Brian
>> 
>>>> [Tue Mar 20 14:31:39 2018] XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 331
>>>> [Tue Mar 20 14:31:39 2018] ------------[ cut here ]------------
>>>> [Tue Mar 20 14:31:39 2018] WARNING: CPU: 0 PID: 13025 at fs/xfs/xfs_message.c:105 asswarn+0x17/0x20
>>>> [Tue Mar 20 14:31:39 2018] CPU: 0 PID: 13025 Comm: async_8 Tainted: G        W       4.14.26-gentoo #1
>>>> [Tue Mar 20 14:31:39 2018] Hardware name: Xen HVM domU, BIOS 4.9.1 01/25/2018
>>>> [Tue Mar 20 14:31:39 2018] task: ffff88003da7d940 task.stack: ffffc90008ba8000
>>>> [Tue Mar 20 14:31:39 2018] RIP: 0010:asswarn+0x17/0x20
>>>> [Tue Mar 20 14:31:39 2018] RSP: 0018:ffffc90008bab810 EFLAGS: 00010246
>>>> [Tue Mar 20 14:31:39 2018] RAX: 0000000000000000 RBX: ffff8800d3f841e0 RCX: 0000000000000000
>>>> [Tue Mar 20 14:31:39 2018] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff81d22af7
>>>> [Tue Mar 20 14:31:39 2018] RBP: ffffffffffffffff R08: 0000000000000000 R09: 0000000000000000
>>>> [Tue Mar 20 14:31:39 2018] R10: 000000000000000a R11: f000000000000000 R12: ffff880148594000
>>>> [Tue Mar 20 14:31:39 2018] R13: 0000000000200007 R14: 00000000000fdfc0 R15: ffff880148594000
>>>> [Tue Mar 20 14:31:39 2018] FS:  00007f7658155700(0000) GS:ffff88014f400000(0000) knlGS:0000000000000000
>>>> [Tue Mar 20 14:31:39 2018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>> [Tue Mar 20 14:31:39 2018] CR2: 00007f327cc05010 CR3: 0000000016b76000 CR4: 00000000000406f0
>>>> [Tue Mar 20 14:31:39 2018] Call Trace:
>>>> [Tue Mar 20 14:31:39 2018]  xfs_trans_mod_sb+0x226/0x2b0
>>>> [Tue Mar 20 14:31:39 2018]  xfs_alloc_ag_vextent+0x130/0x330
>>>> [Tue Mar 20 14:31:39 2018]  xfs_alloc_vextent+0x3ba/0x4b0
>>>> [Tue Mar 20 14:31:39 2018]  __xfs_inobt_alloc_block.isra.1+0x9f/0x130
>>>> [Tue Mar 20 14:31:39 2018]  __xfs_btree_split+0xfd/0x5c0
>>>> [Tue Mar 20 14:31:39 2018]  ? xfs_trans_read_buf_map+0x265/0x2f0
>>>> [Tue Mar 20 14:31:39 2018]  ? xfs_btree_read_buf_block.constprop.26+0xaf/0xf0
>>>> [Tue Mar 20 14:31:39 2018]  xfs_btree_split+0x66/0x110
>>>> [Tue Mar 20 14:31:39 2018]  xfs_btree_make_block_unfull+0x113/0x1d0
>>>> [Tue Mar 20 14:31:39 2018]  xfs_btree_insrec+0x419/0x500
>>>> [Tue Mar 20 14:31:39 2018]  xfs_btree_insert+0xe2/0x220
>>>> [Tue Mar 20 14:31:39 2018]  xfs_difree_finobt+0xd0/0x2d0
>>>> [Tue Mar 20 14:31:39 2018]  xfs_difree+0x162/0x220
>>>> [Tue Mar 20 14:31:39 2018]  xfs_ifree+0xd0/0x290
>>>> [Tue Mar 20 14:31:39 2018]  xfs_inactive_ifree+0xf6/0x290
>>>> [Tue Mar 20 14:31:39 2018]  xfs_inactive+0x112/0x2a0
>>>> [Tue Mar 20 14:31:39 2018]  xfs_fs_destroy_inode+0x82/0x1f0
>>>> [Tue Mar 20 14:31:39 2018]  do_unlinkat+0x1b9/0x320
>>>> [Tue Mar 20 14:31:39 2018]  do_syscall_64+0x87/0x330
>>>> [Tue Mar 20 14:31:39 2018]  ? schedule+0x2d/0x80
>>>> [Tue Mar 20 14:31:39 2018]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>>>> [Tue Mar 20 14:31:39 2018] RIP: 0033:0x7f7698c17967
>>>> [Tue Mar 20 14:31:39 2018] RSP: 002b:00007f7658154e28 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
>>>> [Tue Mar 20 14:31:39 2018] RAX: ffffffffffffffda RBX: 00007f7658781a74 RCX: 00007f7698c17967
>>>> [Tue Mar 20 14:31:39 2018] RDX: 00007f7658781a20 RSI: 00007f7658781b30 RDI: 00007f7658781b30
>>>> [Tue Mar 20 14:31:39 2018] RBP: 00007f7658154e90 R08: 0000000000000000 R09: 0000000000000000
>>>> [Tue Mar 20 14:31:39 2018] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f76587819e0
>>>> [Tue Mar 20 14:31:39 2018] R13: 00007f7658154e80 R14: 0000000000000000 R15: 00007f7658600240
>>>> [Tue Mar 20 14:31:39 2018] Code: 10 e8 8e f9 ff ff 0f 0b e8 67 06 db ff 0f 1f 80 00 00 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5 81 48 89 fa 31 ff e8 a9 fc ff ff <0f> 0b c3 66 0f 1f 44 00 00 48 89 f1 41 89 d0 48 c7 c6 68 1f d5
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

