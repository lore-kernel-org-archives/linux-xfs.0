Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0ULuvDr054634 for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 15:56:58 -0600
Received: from mo-p05-ob.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F23BA1894BCB
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2009 13:56:16 -0800 (PST)
Received: from mo-p05-ob.rzone.de (mo-p05-ob.rzone.de [81.169.146.181]) by
	cuda.sgi.com with ESMTP id pdrNqYVDEbKnvgyN for
	<xfs@oss.sgi.com>; Fri, 30 Jan 2009 13:56:16 -0800 (PST)
Received: from [10.1.1.65] ([213.39.240.61])
	by post.strato.de (mrclete mo46) (RZmta 18.15)
	with ESMTP id D00a04l0UKAQDv for <xfs@oss.sgi.com>;
	Fri, 30 Jan 2009 22:54:18 +0100 (MET)
Message-ID: <498376CF.8020806@renderforce.de>
Date: Fri, 30 Jan 2009 22:53:19 +0100
From: Steffen Knauf <Steffen.Knauf@renderforce.de>
MIME-Version: 1.0
Subject: xfs_force_shutdown after Raid crash
Reply-To: steffen.knauf@renderforce.de
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

after a raid crash (Raid Controller problem, 3 Disks of the Disk Group 
were kicked out oft the diskgroup), 2 of 3 partitions (XFS FS) were 
shutdown immediately.
Perhaps somebody has a idea, what's the best solution (xfs_repair?).

here a small output of the logfile:
------------------------------------------------------------------------------------------
kernel: Call Trace: <ffffffff882c4d21>{:xfs:xfs_free_ag_extent+1081}
 kernel:        <ffffffff882c632e>{:xfs:xfs_free_extent+186} 
<ffffffff882ebf66>{:xfs:xfs_efd_init+54}
kernel:        <ffffffff88303acd>{:xfs:xfs_trans_get_efd+36} 
<ffffffff882d26a5>{:xfs:xfs_bmap_finish+240}
kernel:        <ffffffff882f3bb9>{:xfs:xfs_itruncate_finish+365} 
<ffffffff8830bb87>{:xfs:xfs_inactive+558}
kernel:        <ffffffff88311605>{:xfs:validate_fields+39} 
<ffffffff8831406e>{:xfs:linvfs_clear_inode+165}
kernel:        <ffffffff8019194a>{clear_inode+210} 
<ffffffff80191a62>{generic_delete_inode+231}
kernel:        <ffffffff80189f64>{do_unlinkat+213} 
<ffffffff8010a7be>{system_call+126}
kernel: xfs_force_shutdown(sdb2,0x8) called from line 4200 of file 
fs/xfs/xfs_bmap.c.  Return address = 0xffffffff882d26e7
kernel: Filesystem "sdb2": Corruption of in-memory data detected.  
Shutting down filesystem: sdb2
kernel: Please umount the filesystem, and rectify the problem(s)
kernel: XFS internal error XFS_WANT_CORRUPTED_RETURN at line 298 of file 
fs/xfs/xfs_alloc.c.  Caller 0xffffffff882c5b35
munich kernel:
munich kernel: Call Trace: 
<ffffffff882c42a8>{:xfs:xfs_alloc_fixup_trees+700}
munich kernel:        <ffffffff882db2b7>{:xfs:xfs_btree_init_cursor+49} 
<ffffffff882c5b35>{:xfs:xfs_alloc_ag_vextent+3015}
munich kernel:        <ffffffff802d035d>{__down_read+18} 
<ffffffff882c661b>{:xfs:xfs_alloc_vextent+719}
munich kernel:        <ffffffff882d43e8>{:xfs:xfs_bmapi+5590} 
<ffffffff882f8f94>{:xfs:xlog_write+1518}
munich kernel:        <ffffffff88316edd>{:xfs:kmem_zone_zalloc+30} 
<ffffffff8830dae5>{:xfs:xfs_iomap_write_allocate+521}
munich kernel:        <ffffffff8015aaf2>{mempool_alloc+49} 
<ffffffff8830cc1a>{:xfs:xfs_iomap+762}
munich kernel:        <ffffffff8830e5ea>{:xfs:xfs_map_blocks+53} 
<ffffffff80177086>{alternate_node_alloc+112}
munich kernel:        <ffffffff8830e940>{:xfs:xfs_page_state_convert+695}
munich kernel:        <ffffffff80177086>{alternate_node_alloc+112} 
<ffffffff801e478d>{cfq_set_request+619}
munich kernel:        <ffffffff801eedd3>{swiotlb_map_sg+55} 
<ffffffff880b16a3>{:mptscsih:mptscsih_qcmd+1399}
munich kernel:        <ffffffff8830f3fd>{:xfs:linvfs_writepage+167} 
<ffffffff8019bb7b>{mpage_writepages+435}
munich kernel:        <ffffffff8830f356>{:xfs:linvfs_writepage+0} 
<ffffffff801da7c1>{generic_make_request+339}
munich kernel:        <ffffffff801dc34c>{submit_bio+186} 
<ffffffff8015db47>{do_writepages+41}
munich kernel:        <ffffffff8019a4c2>{__writeback_single_inode+449} 
<ffffffff801293ea>{default_wake_function+0}
munich kernel:        <ffffffff88312420>{:xfs:xfs_bdstrat_cb+55} 
<ffffffff882fa6f2>{:xfs:xfs_log_need_covered+82}
munich kernel:        <ffffffff8019aa62>{sync_sb_inodes+469} 
<ffffffff80143b81>{keventd_create_kthread+0}
munich kernel:        <ffffffff8019af12>{writeback_inodes+130} 
<ffffffff8015dcc6>{wb_kupdate+218}
munich kernel:        <ffffffff802cf340>{thread_return+0} 
<ffffffff8015e506>{pdflush+0}
munich kernel:        <ffffffff8015e674>{pdflush+366} 
<ffffffff8015dbec>{wb_kupdate+0}
munich kernel:        <ffffffff80143e66>{kthread+236} 
<ffffffff8010b84e>{child_rip+8}
munich kernel:        <ffffffff80143b81>{keventd_create_kthread+0} 
<ffffffff80143d7a>{kthread+0}
munich kernel:        <ffffffff8010b846>{child_rip+0}
------------------------------------------------------------------------------------------

greets

Steffen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
