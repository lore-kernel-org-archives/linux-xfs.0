Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6GI7bVH030488 for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 13:07:37 -0500
Received: from mail.jquigley.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35A21A79F58
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 11:15:58 -0700 (PDT)
Received: from mail.jquigley.com (main.jquigley.com [67.23.32.156]) by
	cuda.sgi.com with ESMTP id Ng2eyXIB25CjVCHw for
	<xfs@oss.sgi.com>; Thu, 16 Jul 2009 11:15:58 -0700 (PDT)
Received: from jquigley.cleversafe.org (67-129-215-3.dia.static.qwest.net
	[67.129.215.3]) (Authenticated sender: jquigley@mail.jquigley.com)
	by mail.jquigley.com (Postfix) with ESMTPSA id 82C6520411C
	for <xfs@oss.sgi.com>; Thu, 16 Jul 2009 18:08:12 +0000 (UTC)
Message-ID: <4A5F6C8C.609@jquigley.com>
Date: Thu, 16 Jul 2009 13:08:12 -0500
From: John Quigley <jquigley@jquigley.com>
MIME-Version: 1.0
Subject: File system corruption
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
To: XFS Development <xfs@oss.sgi.com>

Hey Folks:

I'm periodically encountering an issue with XFS that you might perhaps be interested in.  The environment in which this manifests itself is on a CentOS Linux machine (custom 2.6.28.7 kernel), which is serving the XFS mount point in question with the standard Linux nfsd.  The XFS file system lives on an LVM device in a striping configuration (2 wide stripe), with two iSCSI volumes acting as the constituent physical volumes.  This configuration is somewhat baroque, I know.

I'm experiencing periodic file system corruption, which manifests in the XFS file system going offline, and refusing subsequent mounts.  The only way to recover from this has been to perform a xfs_repair -L, which has resulted in data loss on each occasion, as expected.

Now, here's what I witness in the system logs:

<snip>
kernel: XFS: bad magic number
kernel: XFS: SB validate failed

kernel: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
kernel: Filesystem "dm-0": XFS internal error xfs_ialloc_read_agi at line 1408 of file fs/xfs/xfs_ialloc.c.  Caller 0xffffffff8118711a
kernel: Pid: 3842, comm: nfsd Not tainted 2.6.28.7.cs.8 #3 
kernel: Call Trace:
kernel:  [<ffffffff8118711a>] xfs_ialloc_ag_select+0x22a/0x320
kernel:  [<ffffffff81186481>] xfs_ialloc_read_agi+0xe1/0x140
kernel:  [<ffffffff8118711a>] xfs_ialloc_ag_select+0x22a/0x320
kernel:  [<ffffffff811f5bfd>] swiotlb_map_single_attrs+0x1d/0xf0
kernel:  [<ffffffff8118711a>] xfs_ialloc_ag_select+0x22a/0x320
kernel:  [<ffffffff81187bfc>] xfs_dialloc+0x31c/0xa90
kernel:  [<ffffffff81076be5>] __alloc_pages_internal+0xf5/0x4f0
kernel:  [<ffffffff8109ac46>] cache_alloc_refill+0x96/0x5a0
kernel:  [<ffffffff8119012f>] xfs_ialloc+0x7f/0x6f0
kernel:  [<ffffffff811ad0c6>] kmem_zone_alloc+0x86/0xc0
kernel:  [<ffffffff811a66d8>] xfs_dir_ialloc+0xa8/0x360
kernel:  [<ffffffff811a4008>] xfs_trans_reserve+0xa8/0x220
kernel:  [<ffffffff813a29e7>] __down_write_nested+0x17/0xa0
kernel:  [<ffffffff811a952f>] xfs_create+0x2ef/0x4e0
kernel:  [<ffffffff811b523c>] xfs_vn_mknod+0x14c/0x1a0
kernel:  [<ffffffff810a864c>] vfs_create+0xec/0x160
kernel:  [<ffffffffa00c53c3>] nfsd_create_v3+0x3b3/0x500 [nfsd]
kernel:  [<ffffffffa00cc178>] nfsd3_proc_create+0x118/0x1b0 [nfsd]
kernel:  [<ffffffffa00be22a>] nfsd_dispatch+0xba/0x270 [nfsd]
kernel:  [<ffffffffa0061fde>] svc_process+0x49e/0x800 [sunrpc]
kernel:  [<ffffffff8102efc0>] default_wake_function+0x0/0x10
kernel:  [<ffffffff813a2a97>] __down_read+0x17/0xa6
kernel:  [<ffffffffa00be9a9>] nfsd+0x199/0x2c0 [nfsd]
kernel:  [<ffffffffa00be810>] nfsd+0x0/0x2c0 [nfsd]
kernel:  [<ffffffff8104a4b7>] kthread+0x47/0x90
kernel:  [<ffffffff810322a7>] schedule_tail+0x27/0x70
kernel:  [<ffffffff8100d0d9>] child_rip+0xa/0x11
kernel:  [<ffffffff8104a470>] kthread+0x0/0x90
kernel:  [<ffffffff8100d0cf>] child_rip+0x0/0x11

</snip>

The resultant stack trace coming from "XFS internal error xfs_ialloc_read_agi" repeats itself numerous times, at which point, the following is seen:

<snip>

kernel: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
kernel: Filesystem "dm-0": XFS internal error xfs_alloc_read_agf at line 2194 of file fs/xfs/xfs_alloc.c.  Caller 0xffffffff8115cf09
kernel: Pid: 3756, comm: nfsd Not tainted 2.6.28.7.cs.8 #3
kernel: Call Trace:
kernel:  [<ffffffff8115cf09>] xfs_alloc_fix_freelist+0x3e9/0x480
kernel:  [<ffffffff8115abe3>] xfs_alloc_read_agf+0xd3/0x1e0
kernel:  [<ffffffff8115cf09>] xfs_alloc_fix_freelist+0x3e9/0x480
kernel:  [<ffffffff8100d0cf>] child_rip+0x0/0x11
kernel:  [<ffffffff8115cf09>] xfs_alloc_fix_freelist+0x3e9/0x480
kernel:  [<ffffffff811e8033>] vsnprintf+0x743/0x890
kernel:  [<ffffffff81268a8a>] wait_for_xmitr+0x5a/0xc0
kernel:  [<ffffffff8100d0cf>] child_rip+0x0/0x11
kernel:  [<ffffffff813a2a97>] __down_read+0x17/0xa6
kernel:  [<ffffffff8115d215>] xfs_alloc_vextent+0x1b5/0x4e0
kernel:  [<ffffffff8116c0e8>] xfs_bmap_btalloc+0x608/0xb00
kernel:  [<ffffffff8116f60a>] xfs_bmapi+0xa4a/0x12a0
kernel:  [<ffffffff8118e93c>] xfs_imap_to_bp+0xac/0x130
kernel:  [<ffffffff8117a37a>] xfs_dir2_grow_inode+0x15a/0x410
kernel:  [<ffffffff8117b26f>] xfs_dir2_sf_to_block+0x9f/0x5c0
kernel:  [<ffffffff811ad0c6>] kmem_zone_alloc+0x86/0xc0
kernel:  [<ffffffff811ad132>] kmem_zone_zalloc+0x32/0x50
kernel:  [<ffffffff811918ce>] xfs_inode_item_init+0x1e/0x80
kernel:  [<ffffffff81183880>] xfs_dir2_sf_addname+0x430/0x5d0
kernel:  [<ffffffff811903c8>] xfs_ialloc+0x318/0x6f0
kernel:  [<ffffffff8117b0a2>] xfs_dir_createname+0x182/0x1e0
kernel:  [<ffffffff811a95df>] xfs_create+0x39f/0x4e0
kernel:  [<ffffffff811b523c>] xfs_vn_mknod+0x14c/0x1a0
kernel:  [<ffffffff810a864c>] vfs_create+0xec/0x160
kernel:  [<ffffffffa00c53c3>] nfsd_create_v3+0x3b3/0x500 [nfsd]
kernel:  [<ffffffffa00cc178>] nfsd3_proc_create+0x118/0x1b0 [nfsd]
kernel:  [<ffffffffa00be22a>] nfsd_dispatch+0xba/0x270 [nfsd]
kernel:  [<ffffffffa0061fde>] svc_process+0x49e/0x800 [sunrpc]
kernel:  [<ffffffff813a2a97>] __down_read+0x17/0xa6
kernel:  [<ffffffffa00be9a9>] nfsd+0x199/0x2c0 [nfsd]
kernel:  [<ffffffffa00be810>] nfsd+0x0/0x2c0 [nfsd]
kernel:  [<ffffffff8104a4b7>] kthread+0x47/0x90
kernel:  [<ffffffff810322a7>] schedule_tail+0x27/0x70
kernel:  [<ffffffff8100d0d9>] child_rip+0xa/0x11
kernel:  [<ffffffff8104a470>] kthread+0x0/0x90
kernel:  [<ffffffff8100d0cf>] child_rip+0x0/0x11

kernel: Filesystem "dm-0": XFS internal error xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xffffffff811a9411
kernel: Pid: 3756, comm: nfsd Not tainted 2.6.28.7.cs.8 #3
kernel: Call Trace:
kernel:  [<ffffffff811a9411>] xfs_create+0x1d1/0x4e0
kernel:  [<ffffffff811a3475>] xfs_trans_cancel+0xe5/0x110
kernel:  [<ffffffff811a9411>] xfs_create+0x1d1/0x4e0
kernel:  [<ffffffff811b523c>] xfs_vn_mknod+0x14c/0x1a0
kernel:  [<ffffffff810a864c>] vfs_create+0xec/0x160
kernel:  [<ffffffffa00c53c3>] nfsd_create_v3+0x3b3/0x500 [nfsd]
kernel:  [<ffffffffa00cc178>] nfsd3_proc_create+0x118/0x1b0 [nfsd]
kernel:  [<ffffffffa00be22a>] nfsd_dispatch+0xba/0x270 [nfsd]
kernel:  [<ffffffffa0061fde>] svc_process+0x49e/0x800 [sunrpc]
kernel:  [<ffffffff813a2a97>] __down_read+0x17/0xa6
kernel:  [<ffffffffa00be9a9>] nfsd+0x199/0x2c0 [nfsd]
kernel:  [<ffffffffa00be810>] nfsd+0x0/0x2c0 [nfsd]
kernel:  [<ffffffff8104a4b7>] kthread+0x47/0x90
kernel:  [<ffffffff810322a7>] schedule_tail+0x27/0x70
kernel:  [<ffffffff8100d0d9>] child_rip+0xa/0x11
kernel:  [<ffffffff8104a470>] kthread+0x0/0x90
kernel:  [<ffffffff8100d0cf>] child_rip+0x0/0x11
kernel: xfs_force_shutdown(dm-0,0x8) called from line 1165 of file fs/xfs/xfs_trans.c.  Return address = 0xffffffff811a348e
kernel: Filesystem "dm-0": Corruption of in-memory data detected.  Shutting down filesystem: dm-0
kernel: Please umount the filesystem, and rectify the problem(s)
kernel: nfsd: non-standard errno: -117

kernel: Filesystem "dm-0": xfs_log_force: error 5 returned.

</snip>

I'm somewhat at a loss with this one - it's been experienced on a customer's installation, so I don't have ready access to the machine.  All internal tests to attempt reproduction with identical hardware/software configurations has been unfruitful.  I'm concerned about the custom kernel, and may attempt to downgrade to the stock CentOS 5.3 kernel (2.6.18, if I remember correctly).

Any insight would be hugely appreciated, and of course tell me how I can help further.  Thanks so much.

John Quigley
jquigley.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
