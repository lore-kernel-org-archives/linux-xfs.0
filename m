Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0KK1vTD012073 for <xfs@oss.sgi.com>; Tue, 20 Jan 2009 14:01:57 -0600
Message-ID: <497626F9.2080605@sandeen.net>
Date: Tue, 20 Jan 2009 13:33:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at	fs/xfs/support/debug.c:108
References: <a4423d670901091511y68a53808rfaab8148526224c6@mail.gmail.com>	<20090110143924.GA25900@infradead.org>	<a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>	<20090110152803.GA7469@infradead.org>
	<20090110221459.GA8873@orion>	<20090111104659.GB8071@disturbed>	<a4423d670901111648w26e86baajcf7b6d98ff37d043@mail.gmail.com>	<20090112034550.GI8071@disturbed>	<a4423d670901120008j728af9cdrbed8bbb938117ea3@mail.gmail.com>	<20090112211848.GL8071@disturbed>
	<a4423d670901201054t3e48ece2ned4a7e3254250fce@mail.gmail.com>
In-Reply-To: <a4423d670901201054t3e48ece2ned4a7e3254250fce@mail.gmail.com>
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
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

Alexander Beregalov wrote:
> Hi
> 
> Is it a new bug?
> It is pre-2.6.29-rc1 kernel, which was supossed to be free of the bug
> "fs_is_ok, file: fs/xfs/xfs_btree.c, line: 3327"

Do you have CONFIG_LBD on, and if not, can you enable it and retest?
hch narrowed a btree bug down to this...

-Eric

>  Assertion failed: fsbno != NULLFSBLOCK, file: fs/xfs/xfs_btree.c, line: 816
>  ------------[ cut here ]------------
>  kernel BUG at fs/xfs/support/debug.c:81!
>  invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
>  last sysfs file: /sys/devices/platform/w83627hf.656/name
>  Modules linked in: w83627hf hwmon_vid i2c_nforce2
> 
>  Pid: 10156, comm: pdflush Not tainted (2.6.28-rc2-00207-g278d0ca #5)
>  EIP: 0060:[<c029dbee>] EFLAGS: 00010282 CPU: 0
>  EIP is at assfail+0x1e/0x30
>  EAX: 0000005f EBX: f7325a10 ECX: d3a24000 EDX: 00000000
>  ESI: ffffffff EDI: 00000001 EBP: d3a25880 ESP: d3a25870
>   DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>  Process pdflush (pid: 10156, ti=d3a24000 task=f6223cf0 task.ti=d3a24000)
>  Stack:
>   c04d6c04 c04b6a80 c04b6da8 00000330 d3a2589c c024c01e f6aca408 00cc8bc4
>   00000001 ffffffff 00000001 d3a258b4 c024c0e5 f0a45000 f0a45000 00000000
>   00000001 d3a258cc c024c161 00000003 d3a25a04 f0a45000 f0a45000 d3a2590c
>  Call Trace:
>   [<c024c01e>] ? xfs_btree_reada_bufl+0x2e/0x80
>   [<c024c0e5>] ? xfs_btree_readahead_lblock+0x75/0x80
>   [<c024c161>] ? xfs_btree_readahead+0x71/0x90
>   [<c024ca2c>] ? xfs_btree_decrement+0x3c/0x2e0
>   [<c024998c>] ? xfs_bmbt_delete+0x2c/0xa0
>   [<c0240d24>] ? xfs_bmap_add_extent_delay_real+0x1674/0x1700
>   [<c040e987>] ? _spin_unlock+0x27/0x50
>   [<c022a0cb>] ? xfs_alloc_search_busy+0x8b/0xd0
>   [<c0180cfc>] ? slab_pad_check+0x3c/0x120
>   [<c022dc19>] ? xfs_alloc_vextent+0x2e9/0x760
>   [<c01806bd>] ? check_object+0x13d/0x200
>   [<c0241a86>] ? xfs_bmap_add_extent+0x626/0x670
>   [<c0246bac>] ? xfs_bmbt_init_cursor+0x2c/0x100
>   [<c02454cb>] ? xfs_bmapi+0xfcb/0x1c90
>   [<c01806bd>] ? check_object+0x13d/0x200
>   [<c02711d4>] ? xfs_iomap_write_allocate+0x254/0x450
>   [<c02723d7>] ? xfs_iomap+0x3a7/0x3f0
>   [<c02b32e6>] ? submit_bio+0x66/0x100
>   [<c029117e>] ? xfs_map_blocks+0x3e/0x90
>   [<c0292cda>] ? xfs_page_state_convert+0x2ea/0x740
>   [<c029325e>] ? xfs_vm_writepage+0x5e/0xf0
>   [<c016420b>] ? __writepage+0xb/0x40
>   [<c01651b1>] ? write_cache_pages+0x1f1/0x330
>   [<c0164200>] ? __writepage+0x0/0x40
>   [<c0165313>] ? generic_writepages+0x23/0x30
>   [<c0291133>] ? xfs_vm_writepages+0x43/0x50
>   [<c02910f0>] ? xfs_vm_writepages+0x0/0x50
>   [<c016534e>] ? do_writepages+0x2e/0x50
>   [<c019ff72>] ? __writeback_single_inode+0x82/0x320
>   [<c040e3c3>] ? _spin_lock+0x63/0x70
>   [<c01a057a>] ? generic_sync_sb_inodes+0x23a/0x320
>   [<c01a0836>] ? writeback_inodes+0x56/0xe0
>   [<c01644cb>] ? wb_kupdate+0x7b/0xf0
>   [<c01658f0>] ? pdflush+0x0/0x180
>   [<c01659b0>] ? pdflush+0xc0/0x180
>   [<c0164450>] ? wb_kupdate+0x0/0xf0
>   [<c013b6ea>] ? kthread+0x3a/0x70
>   [<c013b6b0>] ? kthread+0x0/0x70
>   [<c0104157>] ? kernel_thread_helper+0x7/0x10
>  Code: 00 e8 97 73 02 00 c9 c3 90 8d 74 26 00 55 89 e5 83 ec 10 89 4c
> 24 0c 89 54 24 08 89 44 24 04 c7 04 24 04 6c 4d c0 e8 fb de 16 00 <0f>
> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5
>  EIP: [<c029dbee>] assfail+0x1e/0x30 SS:ESP 0068:d3a25870
> 
> _______________________________________________
> xfs-masters mailing list
> xfs-masters@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs-masters
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
