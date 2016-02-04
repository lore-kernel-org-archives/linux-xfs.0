Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 31AA47CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 01:46:24 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1615C8F8033
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 23:46:21 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id ynL8neNKLYdj9iGV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 23:46:18 -0800 (PST)
Date: Thu, 4 Feb 2016 08:46:17 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: reflink log reservations
Message-ID: <20160204074617.GB20496@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

Hi Darrick,

I'm running into the following log reservation assert after a few
xfstests runs over NFS.  I'll try to understand the reservation
calculations, but in case this is still fresh in your head here's
a headsup:

generic/167 11s ...
[  640.924891] XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 315
[  640.925750] ------------[ cut here ]------------
[  640.926164] kernel BUG at fs/xfs/xfs_message.c:113!
[  640.926583] invalid opcode: 0000 [#1] SMP 
[  640.926995] Modules linked in:
[  640.927385] CPU: 3 PID: 3719 Comm: nfsd Not tainted 4.5.0-rc2+ #424
[  640.928036] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[  640.928098] task: ffff88007b614380 ti: ffff880077cd4000 task.ti: ffff880077cd4000
[  640.928098] RIP: 0010:[<ffffffff814cdd1d>]  [<ffffffff814cdd1d>] assfail+0x1d/0x20
[  640.928098] RSP: 0018:ffff880077cd72e0  EFLAGS: 00010282
[  640.928098] RAX: 00000000ffffffea RBX: ffff88007afc9130 RCX: 0000000000000021
[  640.928098] RDX: ffff880077cd7208 RSI: 000000000000000a RDI: ffffffff81fdc510
[  640.928098] RBP: ffff880077cd72e0 R08: 0000000000000000 R09: 0000000000000000
[  640.928098] R10: 000000000000000a R11: f000000000000000 R12: ffffffffffffffff
[  640.928098] R13: ffff88007b2cd000 R14: 00000000000a0000 R15: 0000000000000001
[  640.928098] FS:  0000000000000000(0000) GS:ffff88007fd80000(0000) knlGS:0000000000000000
[  640.928098] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  640.928098] CR2: 00000000013e10f8 CR3: 0000000075b18000 CR4: 00000000000006e0
[  640.928098] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  640.928098] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  640.928098] Stack:
[  640.928098]  ffff880077cd7308 ffffffff814d7d00 ffff880077cd7390 0000000000000001
[  640.928098]  ffff880077cd7390 ffff880077cd7328 ffffffff8146059d ffff88007b2cd000
[  640.928098]  0000000000000020 ffff880077cd7378 ffffffff814617cd ffff880077cd7378
[  640.928098] Call Trace:
[  640.928098]  [<ffffffff814d7d00>] xfs_trans_mod_sb+0x250/0x290
[  640.928098]  [<ffffffff8146059d>] xfs_alloc_ag_vextent+0x28d/0x330
[  640.928098]  [<ffffffff814617cd>] xfs_alloc_vextent+0x70d/0x800
[  640.928098]  [<ffffffff814a7a51>] xfs_refcountbt_alloc_block+0xd1/0x1a0
[  640.928098]  [<ffffffff81480aa6>] __xfs_btree_split+0xb6/0xbd0
[  640.928098]  [<ffffffff814eb6e6>] ? xfs_trans_read_buf_map+0x1e6/0x370
[  640.928098]  [<ffffffff814816a4>] xfs_btree_split+0x34/0xc0
[  640.928098]  [<ffffffff8148287f>] xfs_btree_make_block_unfull+0xef/0x170
[  640.928098]  [<ffffffff814832f9>] xfs_btree_insrec+0x9f9/0xc50
[  640.928098]  [<ffffffff8147d6f4>] ? xfs_btree_read_buf_block+0xa4/0xd0
[  640.928098]  [<ffffffff814ebe1f>] ? xfs_trans_log_buf+0x15f/0x1b0
[  640.928098]  [<ffffffff814835b9>] xfs_btree_insert+0x69/0x1d0
[  640.928098]  [<ffffffff814a509e>] xfs_refcountbt_insert+0x4e/0x90
[  640.928098]  [<ffffffff814a58af>] try_split_right_rcextent+0x17f/0x200
[  640.928098]  [<ffffffff814a6afc>] xfs_refcountbt_adjust_refcount+0x4c/0x100
[  640.928098]  [<ffffffff814a6cac>] xfs_refcount_decrease+0x5c/0xa0
[  640.928098]  [<ffffffff814a6d73>] xfs_refcount_put_extent+0x83/0xb0
[  640.928098]  [<ffffffff8147706f>] xfs_bmap_del_extent+0x57f/0x1160
[  640.928098]  [<ffffffff814d965b>] ? kmem_zone_alloc+0x7b/0x120
[  640.928098]  [<ffffffff814d965b>] ? kmem_zone_alloc+0x7b/0x120
[  640.928098]  [<ffffffff8147b8ef>] ? xfs_bmbt_init_cursor+0x5f/0x190
[  640.928098]  [<ffffffff81478bf5>] xfs_bunmapi+0x845/0x10d0
[  640.928098]  [<ffffffff814c8ad8>] xfs_itruncate_extents+0x218/0x3e0
[  640.928098]  [<ffffffff814c8e8d>] xfs_inactive_truncate+0xbd/0x130
[  640.928098]  [<ffffffff814ca6db>] xfs_inactive+0x1ab/0x1e0
[  640.928098]  [<ffffffff814d3a49>] xfs_fs_evict_inode+0x109/0x160
[  640.928098]  [<ffffffff811d79db>] evict+0xbb/0x180
[  640.928098]  [<ffffffff811d8314>] iput+0x174/0x1e0
[  640.928098]  [<ffffffff811d39be>] d_delete+0x11e/0x160
[  640.928098]  [<ffffffff811ca203>] vfs_unlink+0x133/0x160
[  640.928098]  [<ffffffff811ca74a>] ? lookup_one_len+0xca/0x120
[  640.928098]  [<ffffffff81359897>] nfsd_unlink+0x127/0x210
[  640.928098]  [<ffffffff81364d69>] nfsd4_remove+0x49/0x130
[  640.928098]  [<ffffffff8136593a>] nfsd4_proc_compound+0x31a/0x570
[  640.928098]  [<ffffffff813549d9>] nfsd_dispatch+0x89/0x170
[  640.928098]  [<ffffffff81b9968a>] svc_process_common+0x39a/0x520
[  640.928098]  [<ffffffff81b99960>] svc_process+0x150/0x1a0
[  640.928098]  [<ffffffff8135446a>] nfsd+0xea/0x150
[  640.928098]  [<ffffffff81354380>] ? nfsd_destroy+0x60/0x60
[  640.928098]  [<ffffffff810dedf6>] kthread+0xd6/0xf0
[  640.928098]  [<ffffffff810ded20>] ? kthread_create_on_node+0x170/0x170
[  640.928098]  [<ffffffff81bc8a8f>] ret_from_fork+0x3f/0x70
[  640.928098]  [<ffffffff810ded20>] ? kthread_create_on_node+0x170/0x170


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
