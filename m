Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0AMgdVu010955 for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 16:42:40 -0600
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 776867970D
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 14:42:36 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.154])
	by cuda.sgi.com with ESMTP id djr1XGVrQFVRk5Mu for
	<xfs@oss.sgi.com>; Sat, 10 Jan 2009 14:42:36 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id 19so1480165fgg.8
	for <xfs@oss.sgi.com>; Sat, 10 Jan 2009 14:42:35 -0800 (PST)
Date: Sun, 11 Jan 2009 01:14:59 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [xfs-masters] 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Message-ID: <20090110221459.GA8873@orion>
References: <20090109044121.GA31280@orion> <20090109053858.GP9448@disturbed>
	<a4423d670901091353s7ff12207gcb38eb093d77d401@mail.gmail.com>
	<a4423d670901091418j5c7fdfb2oeba2f4640f8e29d0@mail.gmail.com>
	<a4423d670901091511y68a53808rfaab8148526224c6@mail.gmail.com>
	<a4423d670901100419s2ae106bexac1a538caf654153@mail.gmail.com>
	<20090110143924.GA25900@infradead.org>
	<a4423d670901100709v1e7ce0bfs167547c5001787ac@mail.gmail.com>
	<20090110152803.GA7469@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090110152803.GA7469@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-masters@oss.sgi.com, kernel-testers@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jan 10, 2009 at 10:28:03AM -0500, Christoph Hellwig wrote:
> On Sat, Jan 10, 2009 at 06:09:05PM +0300, Alexander Beregalov wrote:
> > > That would be odd as 7f7c39ccb6045cf1fd5e7684a484c445291b44d4 only
> > > changes the tracing code which currently isn't enabled.  Or we
> > > get some sort of miscompilation due slightly different noop
> > > macros.
> > I meant the first bad commit is between these two commits. All of them
> > fail to compile as is,
> > I added xfs_btree_trace.h manually to compile it, I got different bugs
> > on these commits,
> > but I am not sure if they are really different. Like this:
> 
> Ah crap.  When lachlan checked in the btree tracing he forgot to
> add that header and it only got in after that.  Can you bisect
> further between those commit by just using xfs_btree_trce.h from
> a newer version?  It hasn't had a single change yet since it was
> commited.
> 
> This is quite important as all changes between these two revisions
> are quite large and deal with consolidating the btree code.
> 

I can not reproduce it now, I get the following message instead:
I will try to repair the filesystem.

Filesystem "sdb1": XFS internal error xfs_btree_check_lblock at line 86 of file fs/xfs/xfs_btree.c.  Caller 0xc024af42

Pid: 251, comm: pdflush Not tainted 2.6.28-09244-g3d14bda #4
Call Trace:
 [<c0261462>] ? xfs_cmn_err+0x32/0x60
 [<c02614de>] xfs_error_report+0x4e/0x50
 [<c024af42>] ? xfs_btree_check_block+0x32/0x40
 [<c024adcd>] xfs_btree_check_lblock+0x4d/0x190
 [<c024af42>] ? xfs_btree_check_block+0x32/0x40
 [<c0286bf0>] ? xfs_trans_read_buf+0x470/0x530
 [<c024af42>] xfs_btree_check_block+0x32/0x40
 [<c024b124>] xfs_btree_read_buf_block+0xe4/0x100
 [<c024ce2d>] xfs_btree_lshift+0xbd/0x580
 [<c026157b>] ? xfs_error_test+0x1b/0xc0
 [<c024f29b>] xfs_btree_make_block_unfull+0x5b/0x140
 [<c0248972>] ? xfs_bmbt_recs_inorder+0x32/0x70
 [<c024f9be>] xfs_btree_insrec+0x63e/0x6c0
 [<c024faa9>] xfs_btree_insert+0x69/0x190
 [<c024276b>] xfs_bmap_add_extent_delay_real+0x141b/0x16f0
 [<c0181dcc>] ? slab_pad_check+0x3c/0x120
 [<c02319f4>] ? xfs_alloc_vextent+0x2d4/0x730
 [<c018305d>] ? check_object+0x13d/0x200
 [<c0243716>] xfs_bmap_add_extent+0x626/0x670
 [<c024873c>] ? xfs_bmbt_init_cursor+0x2c/0x100
 [<c0247138>] xfs_bmapi+0xfc8/0x1c80
 [<c014ccd6>] ? __lock_acquire+0x2b6/0x1190
 [<c014ccd6>] ? __lock_acquire+0x2b6/0x1190
 [<c0270b24>] xfs_iomap_write_allocate+0x254/0x450
 [<c0275350>] ? xfs_log_move_tail+0x190/0x1d0
 [<c0271c57>] xfs_iomap+0x3a7/0x3f0
 [<c014ccd6>] ? __lock_acquire+0x2b6/0x1190
 [<c0290d3d>] xfs_page_state_convert+0x3fd/0x790
 [<c014c51c>] ? mark_held_locks+0x4c/0x90
 [<c02911fa>] xfs_vm_writepage+0x5a/0xf0
 [<c016580b>] __writepage+0xb/0x40
 [<c01662ab>] write_cache_pages+0x19b/0x350
 [<c0165800>] ? __writepage+0x0/0x40
 [<c0166483>] generic_writepages+0x23/0x30
 [<c028f2d1>] xfs_vm_writepages+0x41/0x50
 [<c028f290>] ? xfs_vm_writepages+0x0/0x50
 [<c01664be>] do_writepages+0x2e/0x50
 [<c01a2b02>] __writeback_single_inode+0x82/0x340
 [<c01a2f16>] ? generic_sync_sb_inodes+0x26/0x390
 [<c0413246>] ? _spin_lock+0x66/0x70
 [<c01a31e2>] generic_sync_sb_inodes+0x2f2/0x390
 [<c01a3426>] writeback_inodes+0x56/0xe0
 [<c01665fb>] wb_kupdate+0x7b/0xf0
 [<c0167060>] ? pdflush+0x0/0x190
 [<c0167130>] pdflush+0xd0/0x190
 [<c0166580>] ? wb_kupdate+0x0/0xf0
 [<c013ba2a>] kthread+0x3a/0x70
 [<c013b9f0>] ? kthread+0x0/0x70
 [<c0103b83>] kernel_thread_helper+0x7/0x14
Filesystem "sdb1": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xc0270c1c

Pid: 251, comm: pdflush Not tainted 2.6.28-09244-g3d14bda #4
Call Trace:
 [<c0261462>] ? xfs_cmn_err+0x32/0x60
 [<c02614de>] xfs_error_report+0x4e/0x50
 [<c0270c1c>] ? xfs_iomap_write_allocate+0x34c/0x450
 [<c02843e6>] xfs_trans_cancel+0x106/0x1e0
 [<c0270c1c>] ? xfs_iomap_write_allocate+0x34c/0x450
 [<c0270c1c>] xfs_iomap_write_allocate+0x34c/0x450
 [<c0275350>] ? xfs_log_move_tail+0x190/0x1d0
 [<c0271c57>] xfs_iomap+0x3a7/0x3f0
 [<c014ccd6>] ? __lock_acquire+0x2b6/0x1190
 [<c0290d3d>] xfs_page_state_convert+0x3fd/0x790
 [<c014c51c>] ? mark_held_locks+0x4c/0x90
 [<c02911fa>] xfs_vm_writepage+0x5a/0xf0
 [<c016580b>] __writepage+0xb/0x40
 [<c01662ab>] write_cache_pages+0x19b/0x350
 [<c0165800>] ? __writepage+0x0/0x40
 [<c0166483>] generic_writepages+0x23/0x30
 [<c028f2d1>] xfs_vm_writepages+0x41/0x50
 [<c028f290>] ? xfs_vm_writepages+0x0/0x50
 [<c01664be>] do_writepages+0x2e/0x50
 [<c01a2b02>] __writeback_single_inode+0x82/0x340
 [<c01a2f16>] ? generic_sync_sb_inodes+0x26/0x390
 [<c0413246>] ? _spin_lock+0x66/0x70
 [<c01a31e2>] generic_sync_sb_inodes+0x2f2/0x390
 [<c01a3426>] writeback_inodes+0x56/0xe0
 [<c01665fb>] wb_kupdate+0x7b/0xf0
 [<c0167060>] ? pdflush+0x0/0x190
 [<c0167130>] pdflush+0xd0/0x190
 [<c0166580>] ? wb_kupdate+0x0/0xf0
 [<c013ba2a>] kthread+0x3a/0x70
 [<c013b9f0>] ? kthread+0x0/0x70
 [<c0103b83>] kernel_thread_helper+0x7/0x14
xfs_force_shutdown(sdb1,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xc02843ff
XFS: Transforming an alert into a BUG.
Filesystem "sdb1": Corruption of in-memory data detected.  Shutting down filesystem: sdb1
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:101!
invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
last sysfs file: /sys/devices/platform/w83627hf.656/name
Modules linked in: w83627hf hwmon_vid i2c_nforce2

Pid: 251, comm: pdflush Not tainted (2.6.28-09244-g3d14bda #4)  
EIP: 0060:[<c029c559>] EFLAGS: 00010246 CPU: 0
EIP is at xfs_fs_vcmn_err+0xc9/0xd0
EAX: f6b06000 EBX: f73e3aa0 ECX: 10000000 EDX: 10000000
ESI: 00000000 EDI: c04b9fc8 EBP: f6b07b74 ESP: f6b07b58
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process pdflush (pid: 251, ti=f6b06000 task=f6b0bd50 task.ti=f6b06000)
Stack:
 c04c2605 c0488fe5 c0aeafc0 00000292 00000008 00000000 f73e3aa0 f6b07b84
 c0261462 f6b07b9c c04b4c58 f6b07bb8 c028e2c2 00000010 00000000 f73e3aa0
 c04b9fc8 f7345cb0 c049d105 c02843ff 00000000 00000008 f6b07c70 00000001
Call Trace:
 [<c0261462>] ? xfs_cmn_err+0x32/0x60
 [<c028e2c2>] ? xfs_do_force_shutdown+0x152/0x1e0
 [<c02843ff>] ? xfs_trans_cancel+0x11f/0x1e0
 [<c02843ff>] ? xfs_trans_cancel+0x11f/0x1e0
 [<c0270c1c>] ? xfs_iomap_write_allocate+0x34c/0x450
 [<c0270c1c>] ? xfs_iomap_write_allocate+0x34c/0x450
 [<c0275350>] ? xfs_log_move_tail+0x190/0x1d0
 [<c0271c57>] ? xfs_iomap+0x3a7/0x3f0
 [<c014ccd6>] ? __lock_acquire+0x2b6/0x1190
 [<c0290d3d>] ? xfs_page_state_convert+0x3fd/0x790
 [<c014c51c>] ? mark_held_locks+0x4c/0x90
 [<c02911fa>] ? xfs_vm_writepage+0x5a/0xf0
 [<c016580b>] ? __writepage+0xb/0x40
 [<c01662ab>] ? write_cache_pages+0x19b/0x350
 [<c0165800>] ? __writepage+0x0/0x40
 [<c0166483>] ? generic_writepages+0x23/0x30
 [<c028f2d1>] ? xfs_vm_writepages+0x41/0x50
 [<c028f290>] ? xfs_vm_writepages+0x0/0x50
 [<c01664be>] ? do_writepages+0x2e/0x50
 [<c01a2b02>] ? __writeback_single_inode+0x82/0x340
 [<c01a2f16>] ? generic_sync_sb_inodes+0x26/0x390
 [<c0413246>] ? _spin_lock+0x66/0x70
 [<c01a31e2>] ? generic_sync_sb_inodes+0x2f2/0x390
 [<c01a3426>] ? writeback_inodes+0x56/0xe0
 [<c01665fb>] ? wb_kupdate+0x7b/0xf0
 [<c0167060>] ? pdflush+0x0/0x190
 [<c0167130>] ? pdflush+0xd0/0x190
 [<c0166580>] ? wb_kupdate+0x0/0xf0
 [<c013ba2a>] ? kthread+0x3a/0x70
 [<c013b9f0>] ? kthread+0x0/0x70
 [<c0103b83>] ? kernel_thread_helper+0x7/0x14
Code: e8 06 43 17 00 8b 55 f0 b8 20 b0 51 c0 e8 f0 75 17 00 85 f6 74 15 83 c4 10 5b 5e 5f c9 c3 8d 74 26 00 c6 81 c0 af ae c0 00 eb bb <0f> 0b eb fe 8d 76 00 55 b8 20 b0 51 c0 89 e5 57 56 53 83 ec 0c 
EIP: [<c029c559>] xfs_fs_vcmn_err+0xc9/0xd0 SS:ESP 0068:f6b07b58
e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
  Tx Queue             <0>
  TDH                  <3f>
  TDT                  <3f>
  next_to_use          <3f>
  next_to_clean        <ca>
buffer_info[next_to_clean]
  time_stamp           <ce70>
  next_to_watch        <ca>
  jiffies              <cfc6>
  next_to_watch.status <1>
---[ end trace 81071308b66cb6c7 ]---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
