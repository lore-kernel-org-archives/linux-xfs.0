Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1HEoJFX230177 for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 08:50:20 -0600
Received: from smtp.welcomes-you.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 593581954CF4
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:49:42 -0800 (PST)
Received: from smtp.welcomes-you.com (welcomes-you.com [85.214.50.128]) by
	cuda.sgi.com with ESMTP id CdnGA3GzkTp0n6Fz for
	<xfs@oss.sgi.com>; Tue, 17 Feb 2009 06:49:42 -0800 (PST)
Message-ID: <499ACE6C.4060304@aei.mpg.de>
Date: Tue, 17 Feb 2009 15:49:16 +0100
From: Carsten Aulbert <carsten.aulbert@aei.mpg.de>
MIME-Version: 1.0
Subject: xfs problems (possibly after upgrading from linux kernel 2.6.27.10
	to .14)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Cc: linux-kernel@vger.kernel.org

Hi all,

within the past few days we hit many XFS internal errors like these. Are these
errors known (and possibly already fixed)? I checked the commits till 
2.6.27.17 and there does not seem anything related to this.

Do you need more information or can I send these nodes into a re-install?

Cheers

Carsten

PS: Please CC me, as I'm currently not on this list.

Feb 16 20:34:49 n0035 kernel: [275873.335916] Filesystem "sda6": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_
trans.c.  Caller 0xffffffff8031b704
Feb 16 20:34:49 n0035 kernel: [275873.336262] Pid: 20060, comm: lalapps_Makefak Not tainted 2.6.27.14-nodes #1
Feb 16 20:34:49 n0035 kernel: [275873.336452]
Feb 16 20:34:49 n0035 kernel: [275873.336452] Call Trace:
Feb 16 20:34:49 n0035 kernel: [275873.336814]  [<ffffffff8031b704>] xfs_create+0x3ee/0x47b
Feb 16 20:34:49 n0035 kernel: [275873.337003]  [<ffffffff803167c6>] xfs_trans_cancel+0x55/0xed
Feb 16 20:34:49 n0035 kernel: [275873.337191]  [<ffffffff8031b704>] xfs_create+0x3ee/0x47b
Feb 16 20:34:49 n0035 kernel: [275873.341237]  [<ffffffff802dfc91>] xfs_attr_get+0x90/0xa1
Feb 16 20:34:49 n0035 kernel: [275873.341424]  [<ffffffff803249e4>] xfs_vn_mknod+0x14b/0x214
Feb 16 20:34:49 n0035 kernel: [275873.341612]  [<ffffffff8027c6b1>] vfs_create+0x71/0xb9
Feb 16 20:34:49 n0035 kernel: [275873.341798]  [<ffffffff8027ec64>] do_filp_open+0x1e6/0x733
Feb 16 20:34:49 n0035 kernel: [275873.341990]  [<ffffffff802738c7>] do_sys_open+0x48/0xcc
Feb 16 20:34:49 n0035 kernel: [275873.342177]  [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
Feb 16 20:34:49 n0035 kernel: [275873.342366]
Feb 16 20:34:49 n0035 kernel: [275873.342548] xfs_force_shutdown(sda6,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return
address = 0xffffffff803167df
Feb 16 20:34:49 n0035 kernel: [275873.343158] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return add
ress = 0xffffffff8030d17b
Feb 16 20:34:49 n0035 kernel: [275873.343508] Filesystem "sda6": Corruption of in-memory data detected.  Shutting down filesystem: sd
a6
Feb 16 20:34:49 n0035 kernel: [275873.343909] Please umount the filesystem, and rectify the problem(s)
Feb 16 20:34:53 n0035 kernel: [275877.000013] Filesystem "sda6": xfs_log_force: error 5 returned.

***********************************8

Feb 16 22:01:28 n0260 kernel: [1129250.851451] Filesystem "sda6": xfs_iflush: Bad inode 1176564060 magic number 0x36b5, ptr 0xffff880
1a7c06c00
Feb 16 22:01:28 n0260 kernel: [1129250.852132] xfs_force_shutdown(sda6,0x8) called from line 3215 of file fs/xfs/xfs_inode.c.  Return
 address = 0xffffffff803077b2
Feb 16 22:01:28 n0260 kernel: [1129250.871943] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return ad
dress = 0xffffffff8030d17b
Feb 16 22:01:28 n0260 kernel: [1129250.872270] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return ad
dress = 0xffffffff8030d17b
Feb 16 22:01:28 n0260 kernel: [1129250.872632] Filesystem "sda6": Corruption of in-memory data detected.  Shutting down filesystem: s
da6
Feb 16 22:01:28 n0260 kernel: [1129250.872955] Filesystem "sda6": xfs_inactive: xfs_trans_commit() returned error 5
Feb 16 22:01:28 n0260 kernel: [1129250.873317] Please umount the filesystem, and rectify the problem(s)
Feb 16 22:01:28 n0260 kernel: [1129250.942070] Filesystem "sda6": xfs_log_force: error 5 returned.

*****************************************

Feb 17 07:48:08 n0393 kernel: [1163760.030411] Filesystem "sda6": xfs_iflush: Bad inode 2117711358 magic number 0x8334, ptr 0xffff880
06883de00
Feb 17 07:48:08 n0393 kernel: [1163760.030750] xfs_force_shutdown(sda6,0x8) called from line 3215 of file fs/xfs/xfs_inode.c.  Return
 address = 0xffffffff803077b2
Feb 17 07:48:08 n0393 kernel: [1163760.092840] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return ad
dress = 0xffffffff8030d17b
Feb 17 07:48:08 n0393 kernel: [1163760.093211] Filesystem "sda6": Corruption of in-memory data detected.  Shutting down filesystem: s
da6
Feb 17 07:48:08 n0393 kernel: [1163760.093645] Please umount the filesystem, and rectify the problem(s)
Feb 17 07:48:09 n0393 kernel: [1163761.100176] Filesystem "sda6": xfs_log_force: error 5 returned.

****************************************

Feb 17 05:57:44 n0463 kernel: [1156816.912129] Filesystem "sda6": XFS internal error xfs_btree_check_sblock at line 307 of file fs/xf
s/xfs_btree.c.  Caller 0xffffffff802dd15b
Feb 17 05:57:44 n0463 kernel: [1156816.912566] Pid: 31011, comm: rm Not tainted 2.6.27.14-nodes #1
Feb 17 05:57:44 n0463 kernel: [1156816.912774]
Feb 17 05:57:44 n0463 kernel: [1156816.912775] Call Trace:
Feb 17 05:57:44 n0463 kernel: [1156816.913177]  [<ffffffff802dd15b>] xfs_alloc_lookup+0x135/0x36a
Feb 17 05:57:44 n0463 kernel: [1156816.913385]  [<ffffffff802f15da>] xfs_btree_check_sblock+0xaf/0xbf
Feb 17 05:57:44 n0463 kernel: [1156816.913593]  [<ffffffff802dd15b>] xfs_alloc_lookup+0x135/0x36a
Feb 17 05:57:44 n0463 kernel: [1156816.913802]  [<ffffffff802f110a>] xfs_btree_init_cursor+0x31/0x1a5
Feb 17 05:57:44 n0463 kernel: [1156816.914011]  [<ffffffff802dadeb>] xfs_free_ag_extent+0x351/0x6bb
Feb 17 05:57:44 n0463 kernel: [1156816.914218]  [<ffffffff802dc7df>] xfs_free_extent+0xa9/0xc9
Feb 17 05:57:44 n0463 kernel: [1156816.914426]  [<ffffffff802e52de>] xfs_bmap_finish+0xee/0x15f
Feb 17 05:57:44 n0463 kernel: [1156816.914633]  [<ffffffff80305505>] xfs_itruncate_finish+0x190/0x2ba
Feb 17 05:57:44 n0463 kernel: [1156816.914844]  [<ffffffff8031d49b>] xfs_inactive+0x1de/0x40f
Feb 17 05:57:44 n0463 kernel: [1156816.915050]  [<ffffffff80327957>] xfs_fs_clear_inode+0xb0/0xf3
Feb 17 05:57:44 n0463 kernel: [1156816.915257]  [<ffffffff8028654a>] clear_inode+0x6d/0xc4
Feb 17 05:57:44 n0463 kernel: [1156816.915461]  [<ffffffff8028662a>] generic_delete_inode+0x89/0xe3
Feb 17 05:57:44 n0463 kernel: [1156816.915670]  [<ffffffff8027e278>] do_unlinkat+0xda/0x157
Feb 17 05:57:44 n0463 kernel: [1156816.915878]  [<ffffffff8034a017>] __up_read+0x13/0x8a
Feb 17 05:57:44 n0463 kernel: [1156816.916086]  [<ffffffff804a0c39>] error_exit+0x0/0x51
Feb 17 05:57:44 n0463 kernel: [1156816.916294]  [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
Feb 17 05:57:44 n0463 kernel: [1156816.916500]
Feb 17 05:57:44 n0463 kernel: [1156816.916700] xfs_force_shutdown(sda6,0x8) called from line 4269 of file fs/xfs/xfs_bmap.c.  Return
address = 0xffffffff802e5313
Feb 17 05:57:44 n0463 kernel: [1156816.920788] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return ad
dress = 0xffffffff8030d17b
Feb 17 05:57:44 n0463 kernel: [1156816.921144] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return ad
dress = 0xffffffff8030d17b
Feb 17 05:57:44 n0463 kernel: [1156816.921564] Filesystem "sda6": Corruption of in-memory data detected.  Shutting down filesystem: s
da6
Feb 17 05:57:44 n0463 kernel: [1156816.921937] Please umount the filesystem, and rectify the problem(s)
Feb 17 05:57:48 n0463 kernel: [1156821.731882] Filesystem "sda6": xfs_log_force: error 5 returned.

*************************************************************************8

Feb 17 07:49:47 n0770 kernel: [1162181.596030] Filesystem "sda6": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs
_trans.c.  Caller 0xffffffff8031b704
Feb 17 07:49:47 n0770 kernel: [1162181.596379] Pid: 15905, comm: lalapps_Makefak Not tainted 2.6.27.14-nodes #1
Feb 17 07:49:47 n0770 kernel: [1162181.596717]
Feb 17 07:49:47 n0770 kernel: [1162181.596717] Call Trace:
Feb 17 07:49:47 n0770 kernel: [1162181.597080]  [<ffffffff8031b704>] xfs_create+0x3ee/0x47b
Feb 17 07:49:47 n0770 kernel: [1162181.597275]  [<ffffffff803167c6>] xfs_trans_cancel+0x55/0xed
Feb 17 07:49:47 n0770 kernel: [1162181.597477]  [<ffffffff8031b704>] xfs_create+0x3ee/0x47b
Feb 17 07:49:47 n0770 kernel: [1162181.597675]  [<ffffffff802dfc91>] xfs_attr_get+0x90/0xa1
Feb 17 07:49:47 n0770 kernel: [1162181.597876]  [<ffffffff803249e4>] xfs_vn_mknod+0x14b/0x214
Feb 17 07:49:47 n0770 kernel: [1162181.598079]  [<ffffffff8027c6b1>] vfs_create+0x71/0xb9
Feb 17 07:49:47 n0770 kernel: [1162181.598278]  [<ffffffff8027ec64>] do_filp_open+0x1e6/0x733
Feb 17 07:49:47 n0770 kernel: [1162181.598477]  [<ffffffff802738c7>] do_sys_open+0x48/0xcc
Feb 17 07:49:47 n0770 kernel: [1162181.598672]  [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
Feb 17 07:49:47 n0770 kernel: [1162181.598871]
Feb 17 07:49:47 n0770 kernel: [1162181.599061] xfs_force_shutdown(sda6,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return
 address = 0xffffffff803167df
Feb 17 07:49:47 n0770 kernel: [1162181.605374] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return ad
dress = 0xffffffff8030d17b
Feb 17 07:49:47 n0770 kernel: [1162181.605775] Filesystem "sda6": Corruption of in-memory data detected.  Shutting down filesystem: s
da6
Feb 17 07:49:47 n0770 kernel: [1162181.606227] Please umount the filesystem, and rectify the problem(s)
Feb 17 07:49:49 n0770 kernel: [1162182.911372] Filesystem "sda6": xfs_log_force: error 5 returned.

***************************************************************************

Feb 17 00:47:33 n0986 kernel: [1136074.667418] Filesystem "sda6": xfs_iflush: Bad inode 1223835676 magic number 0xe5e5, ptr 0xffff880
1763f6c00
Feb 17 00:47:33 n0986 kernel: [1136074.667833] xfs_force_shutdown(sda6,0x8) called from line 3215 of file fs/xfs/xfs_inode.c.  Return
 address = 0xffffffff803077b2
Feb 17 00:47:33 n0986 kernel: [1136074.678958] xfs_force_shutdown(sda6,0x2) called from line 818 of file fs/xfs/xfs_log.c.  Return ad
dress = 0xffffffff8030d17b
Feb 17 00:47:33 n0986 kernel: [1136074.679430] Filesystem "sda6": Log I/O Error Detected.  Shutting down filesystem: sda6
Feb 17 00:47:33 n0986 kernel: [1136074.679783] Please umount the filesystem, and rectify the problem(s)
Feb 17 00:47:33 n0986 kernel: [1136075.686618] Filesystem "sda6": xfs_log_force: error 5 returned.

*******************************************************************************

Feb 17 01:18:08 n1003 kernel: [1137811.535542] Filesystem "sda6": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs
_trans.c.  Caller 0xffffffff8031b704
Feb 17 01:18:08 n1003 kernel: [1137811.535925] Pid: 28435, comm: lalapps_Makefak Not tainted 2.6.27.14-nodes #1
Feb 17 01:18:08 n1003 kernel: [1137811.536287]
Feb 17 01:18:08 n1003 kernel: [1137811.536288] Call Trace:
Feb 17 01:18:08 n1003 kernel: [1137811.536684]  [<ffffffff8031b704>] xfs_create+0x3ee/0x47b
Feb 17 01:18:08 n1003 kernel: [1137811.536890]  [<ffffffff803167c6>] xfs_trans_cancel+0x55/0xed
Feb 17 01:18:08 n1003 kernel: [1137811.537096]  [<ffffffff8031b704>] xfs_create+0x3ee/0x47b
Feb 17 01:18:08 n1003 kernel: [1137811.537301]  [<ffffffff802dfc91>] xfs_attr_get+0x90/0xa1
Feb 17 01:18:08 n1003 kernel: [1137811.537506]  [<ffffffff803249e4>] xfs_vn_mknod+0x14b/0x214
Feb 17 01:18:08 n1003 kernel: [1137811.537711]  [<ffffffff8027c6b1>] vfs_create+0x71/0xb9
Feb 17 01:18:08 n1003 kernel: [1137811.537917]  [<ffffffff8027ec64>] do_filp_open+0x1e6/0x733
Feb 17 01:18:08 n1003 kernel: [1137811.538143]  [<ffffffff802738c7>] do_sys_open+0x48/0xcc
Feb 17 01:18:08 n1003 kernel: [1137811.538361]  [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
Feb 17 01:18:08 n1003 kernel: [1137811.538566]
Feb 17 01:18:08 n1003 kernel: [1137811.538764] xfs_force_shutdown(sda6,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return
 address = 0xffffffff803167df
Feb 17 01:18:08 n1003 kernel: [1137811.622631] Filesystem "sda6": Corruption of in-memory data detected.  Shutting down filesystem: s
da6
Feb 17 01:18:08 n1003 kernel: [1137811.622996] Please umount the filesystem, and rectify the problem(s)
Feb 17 01:18:12 n1003 kernel: [1137815.196767] Filesystem "sda6": xfs_log_force: error 5 returned.

******************************8

plus a few more nodes showing the same characteristics 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
