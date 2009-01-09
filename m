Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n094fXUM008645 for <xfs@oss.sgi.com>; Thu, 8 Jan 2009 22:41:34 -0600
Date: Fri, 9 Jan 2009 07:41:21 +0300
From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: 2.6.29-rc: kernel BUG at fs/xfs/support/debug.c:108
Message-ID: <20090109044121.GA31280@orion>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, kernel-testers@vger.kernel.org

Hi

I got this with the latest git (2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f).

Assertion failed: fs_is_ok, file: fs/xfs/xfs_btree.c, line: 3327
------------[ cut here ]------------
kernel BUG at fs/xfs/support/debug.c:108!
invalid opcode: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
last sysfs file: /sys/devices/platform/w83627hf.656/name
Modules linked in: w83627hf hwmon_vid i2c_nforce2

Pid: 250, comm: pdflush Not tainted (2.6.28-07966-g2150edc #1)
EIP: 0060:[<c029cfce>] EFLAGS: 00010282 CPU: 0
EIP is at assfail+0x1e/0x30
EAX: 00000053 EBX: ef2ed170 ECX: 10000000 EDX: 10000000
ESI: 00000000 EDI: f6b158a4 EBP: f6b15838 ESP: f6b15828
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process pdflush (pid: 250, ti=f6b14000 task=f6b0d1c0 task.ti=f6b14000)
Stack:
 c04bbeb0 c049ba44 c049c4d3 00000cff f6b158f0 c024f3ed 00000008 f0ba7000
 f6b15894 f6b15878 f6b158e0 f0ba7000 00000010 f6b158fc 00000000 ef2ed170
 00000000 f0b98000 f0ba7000 00000000 0000000b c024bb8d f6b158e8 f6b15890
Call Trace:
 [<c024f3ed>] ? xfs_btree_delrec+0xebd/0x1270
 [<c024bb8d>] ? xfs_btree_lookup_get_block+0x9d/0x100
 [<c02492bd>] ? xfs_bmbt_init_key_from_rec+0xd/0x20
 [<c024a260>] ? xfs_lookup_get_search_key+0x40/0x80
 [<c024f7cc>] ? xfs_btree_delete+0x2c/0xa0
 [<c02431bb>] ? xfs_bmap_add_extent_delay_real+0x14bb/0x16f0
 [<c01838fc>] ? slab_pad_check+0x3c/0x120
 [<c01832ed>] ? check_object+0x13d/0x200
 [<c02440c6>] ? xfs_bmap_add_extent+0x626/0x670
 [<c02490ec>] ? xfs_bmbt_init_cursor+0x2c/0x100
 [<c0247ae8>] ? xfs_bmapi+0xfc8/0x1c80
 [<c014d076>] ? __lock_acquire+0x2b6/0x1190
 [<c014d076>] ? __lock_acquire+0x2b6/0x1190
 [<c02714c4>] ? xfs_iomap_write_allocate+0x254/0x450
 [<c0275cd0>] ? xfs_log_move_tail+0x190/0x1d0
 [<c02725f7>] ? xfs_iomap+0x3a7/0x3f0
 [<c014d076>] ? __lock_acquire+0x2b6/0x1190
 [<c02916fd>] ? xfs_page_state_convert+0x32d/0x7b0
 [<c014c8bc>] ? mark_held_locks+0x4c/0x90
 [<c0291cae>] ? xfs_vm_writepage+0x5e/0xf0
 [<c0165c3b>] ? __writepage+0xb/0x40
 [<c0166ceb>] ? write_cache_pages+0x1ab/0x370
 [<c0165c30>] ? __writepage+0x0/0x40
 [<c0166ed3>] ? generic_writepages+0x23/0x30
 [<c028faa1>] ? xfs_vm_writepages+0x41/0x50
 [<c028fa60>] ? xfs_vm_writepages+0x0/0x50
 [<c0166f0e>] ? do_writepages+0x2e/0x50
 [<c01a3342>] ? __writeback_single_inode+0x82/0x340
 [<c01a3756>] ? generic_sync_sb_inodes+0x26/0x390
 [<c04142d6>] ? _spin_lock+0x66/0x70
 [<c01a3a22>] ? generic_sync_sb_inodes+0x2f2/0x390
 [<c01a3c66>] ? writeback_inodes+0x56/0xe0
 [<c0165f0b>] ? wb_kupdate+0x7b/0xf0
 [<c0167530>] ? pdflush+0x0/0x190
 [<c0167600>] ? pdflush+0xd0/0x190
 [<c0165e90>] ? wb_kupdate+0x0/0xf0
 [<c013be0a>] ? kthread+0x3a/0x70
 [<c013bdd0>] ? kthread+0x0/0x70
 [<c0103b83>] ? kernel_thread_helper+0x7/0x14
Code: 00 e8 17 87 02 00 c9 c3 90 8d 74 26 00 55 89 e5 83 ec 10 89 4c 24 0c 89 54 24 08 89 44 24 04 c7 04 24 b0 be 4b c0 e8 fb 48 17 00 <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5
EIP: [<c029cfce>] assfail+0x1e/0x30 SS:ESP 0068:f6b15828

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
