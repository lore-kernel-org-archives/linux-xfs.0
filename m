Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBNHDYHr013836 for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 11:13:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B7271780F02
	for <xfs@oss.sgi.com>; Tue, 23 Dec 2008 09:13:32 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Bn24hcLtGIiYKwSl for
	<xfs@oss.sgi.com>; Tue, 23 Dec 2008 09:13:32 -0800 (PST)
Date: Tue, 23 Dec 2008 12:12:59 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20081223171259.GA11945@infradead.org>
References: <gifgp1$8ic$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <gifgp1$8ic$1@ger.gmane.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Roman Kononov <kernel@kononov.ftml.net>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, xfs@oss.sgi.com


Nick, I've seen various reports like this by Roman.  It seems to be
caused by an interaction of the lockless pagecache with the xfs
I/O code.  Any idea what might be wrong here:

BUG: soft lockup - CPU#0 stuck for 61s! [postmaster:23237]
Modules linked in: xd1000
CPU 0:
Modules linked in: xd1000
Pid: 23237, comm: postmaster Not tainted 2.6.27.9 #1
RIP: 0010:[<ffffffff8026c872>]  [<ffffffff8026c872>] find_get_pages+0x72/0x120
RSP: 0018:ffff88012e9f3498  EFLAGS: 00000297
RAX: ffff8800a4d752a0 RBX: 000000000000000c RCX: 0000000000000003
RDX: 0000000000000004 RSI: 0000000000000000 RDI: ffffe200004ab780
RBP: ffff88023f6b5028 R08: ffffe200004ab280 R09: 000000000000000d
R10: 0000000000000021 R11: 00000000000aef22 R12: ffffffff80273e3c
R13: ffffe20001208608 R14: 0100000000000286 R15: ffff88023f6b5028
FS:  00007fd397fb5700(0000) GS:ffffffff806d7540(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00002aaaaba00000 CR3: 000000017911c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 kernel:  [<ffffffff8026c842>] ? find_get_pages+0x42/0x120
 [<ffffffff80276107>] ? pagevec_lookup+0x17/0x20
 [<ffffffff803a6701>] ? xfs_cluster_write+0x91/0x160
 [<ffffffff803a6e73>] ? xfs_page_state_convert+0x523/0x6c0
 [<ffffffff803a7301>] ? xfs_vm_writepage+0x71/0x120
 [<ffffffff80278092>] ? shrink_page_list+0x592/0x700
 [<ffffffff802784b7>] ? shrink_zone+0x2b7/0xc70
 [<ffffffff802798c4>] ? try_to_free_pages+0x244/0x3b0
 [<ffffffff80277920>] ? isolate_pages_global+0x0/0x40
 [<ffffffff8027b2d3>] ? congestion_wait+0x83/0xa0
 [<ffffffff8024f5f0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff80273668>] ? __alloc_pages_internal+0x218/0x4e0
 [<ffffffff8026d08f>] ? __grab_cache_page+0x6f/0xc0
 [<ffffffff802c69ad>] ? block_write_begin+0x7d/0xe0
 [<ffffffff803a71e2>] ? xfs_vm_write_begin+0x22/0x30
 [<ffffffff803a5e10>] ? xfs_get_blocks+0x0/0x10
 [<ffffffff8026df5b>] ? generic_file_buffered_write+0x1cb/0x790
 [<ffffffff8059145f>] ? _spin_lock_irqsave+0x1f/0x50
 [<ffffffff803ae63c>] ? xfs_write+0x65c/0x950
 [<ffffffff80591681>] ? _spin_unlock_irq+0x11/0x40
 [<ffffffff8029c0cb>] ? do_sync_write+0xdb/0x120
 [<ffffffff8025c169>] ? do_futex+0x109/0x9f0
 [<ffffffff8024f5f0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff802315f0>] ? wake_up_new_task+0xc0/0x100
 [<ffffffff8029caeb>] ? vfs_write+0xcb/0x170
 [<ffffffff8029cc93>] ? sys_write+0x53/0xa0
 [<ffffffff8020c44b>] ? system_call_fastpath+0x16/0x1b
 [<ffffffff8020c44b>] ? system_call_fastpath+0x16/0x1b

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
