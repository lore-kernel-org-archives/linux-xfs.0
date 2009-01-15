Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0FC81LD010915 for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 06:08:01 -0600
Received: from ngcobalt07.manitu.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 514418E19A
	for <xfs@oss.sgi.com>; Thu, 15 Jan 2009 04:07:54 -0800 (PST)
Received: from ngcobalt07.manitu.net (ngcobalt07.manitu.net [217.11.48.107])
	by cuda.sgi.com with ESMTP id ba5nBzuEgXMvG3gJ for
	<xfs@oss.sgi.com>; Thu, 15 Jan 2009 04:07:54 -0800 (PST)
From: Roland Eggner <edvx1@systemanalysen.net>
Subject: xfs regression in linux_2.6.28,
	"XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c"
Date: Thu, 15 Jan 2009 04:02:39 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901150402.39801.edvx1@systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
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
To: SGI Project XFS mailing list <xfs@oss.sgi.com>

Latest (so far) working linux_2.6.27.9
linux_2.6.28 seems to introduce a xfs regression:
$  egrep -i '(Linux|gcc) version|corrupted' /var/log/messages
Jan 10 14:27:29 roland kernel: Linux version 2.6.28.roland.1 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #3 Fri Jan 9 16:51:21 CET 2009
Jan 11 02:00:14 roland kernel: Linux version 2.6.28-git7.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Sun Jan 11 01:29:14 CET 2009
Jan 11 02:36:56 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 11 02:39:14 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 11 02:52:14 roland kernel: Linux version 2.6.28-git7.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Sun Jan 11 01:29:14 CET 2009
Jan 11 14:43:10 roland kernel: Linux version 2.6.28-git7.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Sun Jan 11 01:29:14 CET 2009
Jan 11 15:12:43 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 11 16:30:57 roland kernel: Linux version 2.6.23.12roland2 (roland@roland) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #2 Tue Apr 15 17:10:52 CEST 2008
Jan 11 18:53:04 roland kernel: Linux version 2.6.23.12.roland3 (root@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Sun Jan 11 18:26:14 CET 2009
Jan 12 03:49:24 roland kernel: Linux version 2.6.27.9.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Mon Jan 12 00:22:32 CET 2009
Jan 12 04:26:46 roland kernel: Linux version 2.6.27.9.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #2 Mon Jan 12 04:20:10 CET 2009
Jan 12 12:21:14 roland kernel: Linux version 2.6.27.9.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #2 Mon Jan 12 04:20:10 CET 2009
Jan 12 21:17:49 roland kernel: Linux version 2.6.27.9.roland.1 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #3 Mon Jan 12 20:26:09 CET 2009
Jan 13 03:28:16 roland kernel: Linux version 2.6.27.9.roland.1 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #3 Mon Jan 12 20:26:09 CET 2009
Jan 13 20:49:59 roland kernel: Linux version 2.6.27.9.roland.1 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #3 Mon Jan 12 20:26:09 CET 2009
Jan 13 21:06:48 roland kernel: Linux version 2.6.28-git7.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Sun Jan 11 01:29:14 CET 2009
Jan 13 21:21:25 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 14 12:09:18 roland kernel: Linux version 2.6.28-git7.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Sun Jan 11 01:29:14 CET 2009
Jan 14 12:33:13 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 14 12:38:31 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 14 12:46:32 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 14 12:52:25 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 14 13:02:59 roland kernel: Linux version 2.6.27.9.roland.1 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #3 Mon Jan 12 20:26:09 CET 2009
Jan 14 15:06:51 roland kernel: Linux version 2.6.28-git9.roland.0 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 Wed Jan 14 14:22:09 CET 2009
Jan 14 18:15:22 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc024972c
Jan 14 18:23:23 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc024972c
Jan 14 18:39:27 roland kernel: Linux version 2.6.27.9.roland.1 (roland@roland) (gcc version 4.2.3 (Debian 4.2.3-3)) #3 Mon Jan 12 20:26:09 CET 2009


linux_2.6.28 base version gives me ..
Jan 10 14:27:29 roland kernel: PCI: PCI BIOS revision 2.10 entry at 0xfd981, last bus=4
Jan 10 14:27:29 roland kernel: PCI: Using configuration type 1 for base access
Jan 10 14:27:29 roland kernel: resource map sanity check conflict: 0x1ff6adca 0x1ff6bbff 0x1ff6b000 0x1ff6ffff ACPI Non-volatile Storage

therefore need another one, but any linux_2.6.28-git[1-9] so far tried is unusable for me:
it boots but sooner or later xfs error occurs, seems to be triggered by xfs write activity, both plane partitions with internal xfs log and loop-aes encrypted partitions with external xfs log affected.
Jan 11 02:36:56 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc02488bc
Jan 11 02:36:56 roland kernel: Pid: 5436, comm: opera Tainted: P           2.6.28-git7.roland.0 #1
Jan 11 02:36:56 roland kernel: Call Trace:
Jan 11 02:36:56 roland kernel:  [<c024869f>] xfs_btree_delrec+0xadf/0xcd0
Jan 11 02:36:56 roland kernel:  [<c02488bc>] xfs_btree_delete+0x2c/0xa0
Jan 11 02:36:56 roland kernel:  [<c0244bd2>] xfs_btree_lookup_get_block+0xa2/0xd0
Jan 11 02:36:56 roland kernel:  [<c0243837>] xfs_bmbt_init_key_from_rec+0x17/0x40
Jan 11 02:36:56 roland kernel:  [<c02465a2>] xfs_btree_lookup+0x202/0x3e0
Jan 11 02:36:56 roland kernel:  [<c02488bc>] xfs_btree_delete+0x2c/0xa0
Jan 11 02:36:56 roland kernel:  [<c023f23c>] xfs_bmap_del_extent+0x76c/0xb90
Jan 11 02:36:56 roland kernel:  [<c025c53e>] xfs_iext_bno_to_ext+0xae/0x1e0
Jan 11 02:36:56 roland kernel:  [<c027a6d0>] kmem_zone_alloc+0x50/0xc0
Jan 11 02:36:56 roland kernel:  [<c027a769>] kmem_zone_zalloc+0x29/0x60
Jan 11 02:36:56 roland kernel:  [<c02405fa>] xfs_bunmapi+0x6ba/0xb30
Jan 11 02:36:56 roland kernel:  [<c024b134>] xfs_da_shrink_inode+0xb4/0x150
Jan 11 02:36:56 roland kernel:  [<c024ca55>] xfs_da_join+0x95/0x190
Jan 11 02:36:56 roland kernel:  [<c0252f10>] xfs_dir2_node_removename+0x280/0x4f0
Jan 11 02:36:56 roland kernel:  [<c0272e07>] _xfs_trans_commit+0x237/0x330
Jan 11 02:36:56 roland kernel:  [<c024db07>] xfs_dir_removename+0x117/0x120
Jan 11 02:36:56 roland kernel:  [<c027778b>] xfs_remove+0x20b/0x370
Jan 11 02:36:56 roland kernel:  [<c0281950>] xfs_vn_unlink+0x30/0x70
Jan 11 02:36:56 roland kernel:  [<c0180018>] vfs_unlink+0x78/0xe0
Jan 11 02:36:56 roland kernel:  [<c01820be>] do_unlinkat+0x13e/0x150
Jan 11 02:36:56 roland kernel:  [<c01031fa>] syscall_call+0x7/0xb
Jan 11 02:36:56 roland kernel: Filesystem "loop17": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xc027770e
Jan 11 02:36:56 roland kernel:
Jan 11 02:36:56 roland kernel: Pid: 5436, comm: opera Tainted: P           2.6.28-git7.roland.0 #1
Jan 11 02:36:56 roland kernel: Call Trace:
Jan 11 02:36:56 roland kernel:  [<c0272744>] xfs_trans_cancel+0xd4/0x100
Jan 11 02:36:56 roland kernel:  [<c027770e>] xfs_remove+0x18e/0x370
Jan 11 02:36:56 roland kernel:  [<c027770e>] xfs_remove+0x18e/0x370
Jan 11 02:36:56 roland kernel:  [<c0281950>] xfs_vn_unlink+0x30/0x70
Jan 11 02:36:56 roland kernel:  [<c0180018>] vfs_unlink+0x78/0xe0
Jan 11 02:36:56 roland kernel:  [<c01820be>] do_unlinkat+0x13e/0x150
Jan 11 02:36:56 roland kernel:  [<c01031fa>] syscall_call+0x7/0xb
Jan 11 02:36:56 roland kernel: xfs_force_shutdown(loop17,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xc027275c
Jan 11 02:36:56 roland kernel: Filesystem "loop17": Corruption of in-memory data detected.  Shutting down filesystem: loop17


Jan 14 18:15:22 roland kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc024972c
Jan 14 18:15:22 roland kernel: Pid: 8760, comm: wwwoffled Tainted: P           2.6.28-git9.roland.0 #1
Jan 14 18:15:22 roland kernel: Call Trace:
Jan 14 18:15:22 roland kernel:  [<c024950f>] xfs_btree_delrec+0xadf/0xcd0
Jan 14 18:15:22 roland kernel:  [<c024972c>] xfs_btree_delete+0x2c/0xa0
Jan 14 18:15:22 roland kernel:  [<c0245a42>] xfs_btree_lookup_get_block+0xa2/0xd0
Jan 14 18:15:22 roland kernel:  [<c02446a7>] xfs_bmbt_init_key_from_rec+0x17/0x40
Jan 14 18:15:22 roland kernel:  [<c0247412>] xfs_btree_lookup+0x202/0x3e0
Jan 14 18:15:22 roland kernel:  [<c024972c>] xfs_btree_delete+0x2c/0xa0
Jan 14 18:15:22 roland kernel:  [<c02400cc>] xfs_bmap_del_extent+0x76c/0xb90
Jan 14 18:15:22 roland kernel:  [<c027e61f>] _xfs_buf_find+0xaf/0x170
Jan 14 18:15:22 roland kernel:  [<c025d40e>] xfs_iext_bno_to_ext+0xae/0x1e0
Jan 14 18:15:22 roland kernel:  [<c027b630>] kmem_zone_alloc+0x50/0xc0
Jan 14 18:15:22 roland kernel:  [<c027b6c9>] kmem_zone_zalloc+0x29/0x60
Jan 14 18:15:22 roland kernel:  [<c024146a>] xfs_bunmapi+0x6ba/0xb30
Jan 14 18:15:22 roland kernel:  [<c024daee>] xfs_dir2_shrink_inode+0x8e/0x180
Jan 14 18:15:22 roland kernel:  [<c024b841>] xfs_da_read_buf+0x31/0x40
Jan 14 18:15:22 roland kernel:  [<c0253efa>] xfs_dir2_node_removename+0x3ea/0x4f0
Jan 14 18:15:22 roland kernel:  [<c024e987>] xfs_dir_removename+0x117/0x120
Jan 14 18:15:22 roland kernel:  [<c0278769>] xfs_remove+0x209/0x370
Jan 14 18:15:22 roland kernel:  [<c02828d0>] xfs_vn_unlink+0x30/0x70
Jan 14 18:15:22 roland kernel:  [<c0180c82>] vfs_unlink+0x72/0xe0
Jan 14 18:15:22 roland kernel:  [<c0182ccf>] do_unlinkat+0x13f/0x150
Jan 14 18:15:22 roland kernel:  [<c01031fa>] syscall_call+0x7/0xb
Jan 14 18:15:22 roland kernel: Filesystem "hda6": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xc02786ee
Jan 14 18:15:22 roland kernel:
Jan 14 18:15:22 roland kernel: Pid: 8760, comm: wwwoffled Tainted: P           2.6.28-git9.roland.0 #1
Jan 14 18:15:22 roland kernel: Call Trace:
Jan 14 18:15:22 roland kernel:  [<c02736a4>] xfs_trans_cancel+0xd4/0x100
Jan 14 18:15:22 roland kernel:  [<c02786ee>] xfs_remove+0x18e/0x370
Jan 14 18:15:22 roland kernel:  [<c02786ee>] xfs_remove+0x18e/0x370
Jan 14 18:15:22 roland kernel:  [<c02828d0>] xfs_vn_unlink+0x30/0x70
Jan 14 18:15:22 roland kernel:  [<c0180c82>] vfs_unlink+0x72/0xe0
Jan 14 18:15:22 roland kernel:  [<c0182ccf>] do_unlinkat+0x13f/0x150
Jan 14 18:15:22 roland kernel:  [<c01031fa>] syscall_call+0x7/0xb
Jan 14 18:15:22 roland kernel: xfs_force_shutdown(hda6,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xc02736bc
Jan 14 18:15:22 roland kernel: Filesystem "hda6": Corruption of in-memory data detected.  Shutting down filesystem: hda6


-- 
Roland Eggner

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
