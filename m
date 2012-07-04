Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64JDbgG247296 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 14:13:37 -0500
Received: from trent.utfs.org (trent.utfs.org [94.185.90.103]) by cuda.sgi.com
	with ESMTP id tHMUjHZCNKWGwLid for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 12:13:34 -0700 (PDT)
Received: from trent.utfs.org (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 9C1043E0DB
	for <xfs@oss.sgi.com>; Wed,  4 Jul 2012 21:13:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by trent.utfs.org (Postfix) with ESMTP id 874613DAC3
	for <xfs@oss.sgi.com>; Wed,  4 Jul 2012 21:13:32 +0200 (CEST)
Date: Wed, 4 Jul 2012 12:13:32 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: 3.5.0-rc5: inconsistent lock state
Message-ID: <alpine.DEB.2.01.1207041206390.5568@trent.utfs.org>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

this powerpc machine is running 3.5.0-rc5 for 2 days now and this happened 
today:

=================================
[ INFO: inconsistent lock state ]
3.5.0-rc5-00003-gca24a14-dirty #1 Not tainted
---------------------------------
inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
kswapd0/237 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (xfs_iolock_reclaimable){+.+.?.}, at: [<c01d0a24>] xfs_ilock+0x84/0xc0
{RECLAIM_FS-ON-W} state was registered at:
  [<c00766e8>] lockdep_trace_alloc+0xac/0xe4
  [<c00d33e0>] kmem_cache_alloc+0x3c/0x134
  [<c01e25dc>] kmem_zone_alloc+0xa4/0x114
  [<c01e2668>] kmem_zone_zalloc+0x1c/0x58
  [<c0221ca4>] _xfs_trans_alloc+0x40/0x84
  [<c0222a0c>] xfs_trans_alloc+0xa0/0xbc
  [<c01e7148>] xfs_attr_inactive+0x5c/0x1a4
  [<c01e19d8>] xfs_inactive_attrs+0x58/0x10c
  [<c01e1c74>] xfs_inactive+0x1e8/0x440
  [<c01da5e4>] xfs_fs_evict_inode+0x98/0xac
  [<c00f5a90>] evict+0xc8/0x1b0
  [<c00f20d0>] d_delete+0x1cc/0x1f8
  [<c00e8100>] vfs_rmdir+0x138/0x13c
  [<c00e8220>] do_rmdir+0x11c/0x12c
  [<c00117e8>] ret_from_syscall+0x0/0x38
irq event stamp: 183359685
hardirqs last  enabled at (183359685): [<c0539f20>] _raw_spin_unlock_irqrestore+0x40/0x9c
hardirqs last disabled at (183359684): [<c053952c>] _raw_spin_lock_irqsave+0x30/0x84
softirqs last  enabled at (183358622): [<c000f3e8>] call_do_softirq+0x14/0x24
softirqs last disabled at (183358603): [<c000f3e8>] call_do_softirq+0x14/0x24


My mount options:

# grep xfs /proc/mounts 
/dev/mapper/wdc1 /mnt/media xfs rw,nosuid,nodev,noexec,relatime,attr2,noquota 0 0
/dev/mapper/sam0 /mnt/vault0 xfs ro,nosuid,nodev,noexec,relatime,attr2,noquota 0 0
/dev/mapper/sam1 /mnt/vault1 xfs ro,nosuid,nodev,noexec,relatime,attr2,noquota 0 0

The whole dmesg & .config is here: 

  http://nerdbynature.de/bits/3.5.0-rc5/soft_lockup/xfs/

Note: the -dirty flag in the kernel version comes from a single patch 
applied so that the system would boot: https://lkml.org/lkml/2012/7/2/32

Thanks,
Christian.
-- 
BOFH excuse #339:

manager in the cable duct

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
