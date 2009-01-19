Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0JJ1UMD016235 for <xfs@oss.sgi.com>; Mon, 19 Jan 2009 13:01:30 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B29149E2E6
	for <xfs@oss.sgi.com>; Mon, 19 Jan 2009 11:01:27 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id KkdDsHNHKRr4wJ7M for <xfs@oss.sgi.com>;
	Mon, 19 Jan 2009 11:01:27 -0800 (PST)
Message-ID: <4974CA20.6050308@sandeen.net>
Date: Mon, 19 Jan 2009 12:44:48 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
References: <497468C1.3000001@gmail.com>
In-Reply-To: <497468C1.3000001@gmail.com>
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
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: hch@infradead.org, LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Jacek Luczak wrote:
> Hi All,
> 
> I've stepped into XFS issue/bug. Yesterday I've compiled 2.6.29-rc2 and no
> didn't found errors. Today I've booted my notebook and XFS bug have occurred.
> System reboot didn't helped, same error appeared.
> 
> Some info:
> [1] config: http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2.config
> [2] kernel logs:
> http://pin.if.uz.zgora.pl/~difrost/linux-next/2.6.29-rc2_XFS-bug.log
> [3] most interesting part of log below.

so this happens every mount?  Reproducible is good.  How large is the
filesystem (too large to extract elsewhere for analysis...?) (plus I
suppose it'll be hard to get to it when you can't even boot....)

-Eric

> Regards,
> -Jacek
> 
> ----------- BUG START HERE -----------
> Jan 19 11:18:32 difrost kernel: XFS internal error XFS_WANT_CORRUPTED_GOTO at
> line 3327 of file fs/xfs/xfs_btree.c.  Caller 0xc01b047c
> Jan 19 11:18:32 difrost kernel: Pid: 680, comm: mount Not tainted 2.6.29-rc2 #1
> Jan 19 11:18:32 difrost kernel: Call Trace:
> Jan 19 11:18:32 difrost kernel:  [<c01afef0>] xfs_btree_delrec+0x657/0xbc2
> Jan 19 11:18:32 difrost kernel:  [<c01b047c>] xfs_btree_delete+0x21/0x66
> Jan 19 11:18:32 difrost kernel:  [<c01ac0b0>] xfs_bmbt_init_key_from_rec+0xa/0x16
> Jan 19 11:18:32 difrost kernel:  [<c01b047c>] xfs_btree_delete+0x21/0x66
> Jan 19 11:18:32 difrost kernel:  [<c01a8de3>] xfs_bmap_del_extent+0x309/0x974
> Jan 19 11:18:32 difrost kernel:  [<c01d8d33>] kmem_zone_alloc+0x53/0x90
> Jan 19 11:18:32 difrost kernel:  [<c01a9b28>] xfs_bunmapi+0x59c/0x95d
> Jan 19 11:18:32 difrost kernel:  [<c01c1ac1>] xfs_itruncate_finish+0x1c7/0x2f3
> Jan 19 11:18:32 difrost kernel:  [<c01d742b>] xfs_inactive+0x1d2/0x3ce
> Jan 19 11:18:32 difrost kernel:  [<c01c23b5>] xfs_imap_to_bp+0x5d/0xcb
> Jan 19 11:18:32 difrost kernel:  [<c0171bc4>] clear_inode+0x6c/0xb8
> Jan 19 11:18:32 difrost kernel:  [<c01720f1>] generic_delete_inode+0x72/0xcc
> Jan 19 11:18:32 difrost kernel:  [<c0171703>] iput+0x48/0x4a
> Jan 19 11:18:32 difrost kernel:  [<c01cba97>]
> xlog_recover_process_one_iunlink+0xb0/0xda
> Jan 19 11:18:32 difrost kernel:  [<c01cbb38>]
> xlog_recover_process_iunlinks+0x77/0xd8
> Jan 19 11:18:32 difrost kernel:  [<c01cbbd8>] xlog_recover_finish+0x3f/0x8d
> Jan 19 11:18:32 difrost kernel:  [<c01cff74>] xfs_mountfs+0x44e/0x54b
> Jan 19 11:18:32 difrost kernel:  [<c01d8e3a>] kmem_alloc+0x57/0xa8
> Jan 19 11:18:32 difrost kernel:  [<c01d06e9>] xfs_mru_cache_create+0xe6/0x11c
> Jan 19 11:18:32 difrost kernel:  [<c01e1616>] xfs_fs_fill_super+0x182/0x2d8
> Jan 19 11:18:32 difrost kernel:  [<c0165a80>] get_sb_bdev+0xe8/0x130
> Jan 19 11:18:32 difrost kernel:  [<c01750e6>] alloc_vfsmnt+0x69/0xf5
> Jan 19 11:18:32 difrost kernel:  [<c01dfe39>] xfs_fs_get_sb+0x12/0x16
> Jan 19 11:18:32 difrost kernel:  [<c01e1494>] xfs_fs_fill_super+0x0/0x2d8
> Jan 19 11:18:32 difrost kernel:  [<c0164cca>] vfs_kern_mount+0x39/0x72
> Jan 19 11:18:32 difrost kernel:  [<c0164d41>] do_kern_mount+0x2f/0xb4
> Jan 19 11:18:32 difrost kernel:  [<c0175c6a>] do_mount+0x632/0x66d
> Jan 19 11:18:32 difrost kernel:  [<c0175d14>] sys_mount+0x6f/0xaf
> Jan 19 11:18:32 difrost kernel:  [<c0102d05>] sysenter_do_call+0x12/0x25
> Jan 19 11:18:32 difrost kernel: Filesystem "sda5": XFS internal error
> xfs_trans_cancel at line 1164 of file fs/xfs/xfs_trans.c.  Caller 0xc01d7444
> Jan 19 11:18:32 difrost kernel:
> Jan 19 11:18:32 difrost kernel: Pid: 680, comm: mount Not tainted 2.6.29-rc2 #1
> Jan 19 11:18:32 difrost kernel: Call Trace:
> Jan 19 11:18:32 difrost kernel:  [<c01d2255>] xfs_trans_cancel+0x49/0xcf
> Jan 19 11:18:32 difrost kernel:  [<c01d7444>] xfs_inactive+0x1eb/0x3ce
> Jan 19 11:18:32 difrost kernel:  [<c01d7444>] xfs_inactive+0x1eb/0x3ce
> Jan 19 11:18:32 difrost kernel:  [<c01c23b5>] xfs_imap_to_bp+0x5d/0xcb
> Jan 19 11:18:32 difrost kernel:  [<c0171bc4>] clear_inode+0x6c/0xb8
> Jan 19 11:18:32 difrost kernel:  [<c01720f1>] generic_delete_inode+0x72/0xcc
> Jan 19 11:18:32 difrost kernel:  [<c0171703>] iput+0x48/0x4a
> Jan 19 11:18:32 difrost kernel:  [<c01cba97>]
> xlog_recover_process_one_iunlink+0xb0/0xda
> Jan 19 11:18:32 difrost kernel:  [<c01cbb38>]
> xlog_recover_process_iunlinks+0x77/0xd8
> Jan 19 11:18:32 difrost kernel:  [<c01cbbd8>] xlog_recover_finish+0x3f/0x8d
> Jan 19 11:18:32 difrost kernel:  [<c01cff74>] xfs_mountfs+0x44e/0x54b
> Jan 19 11:18:32 difrost kernel:  [<c01d8e3a>] kmem_alloc+0x57/0xa8
> Jan 19 11:18:32 difrost kernel:  [<c01d06e9>] xfs_mru_cache_create+0xe6/0x11c
> Jan 19 11:18:32 difrost kernel:  [<c01e1616>] xfs_fs_fill_super+0x182/0x2d8
> Jan 19 11:18:32 difrost kernel:  [<c0165a80>] get_sb_bdev+0xe8/0x130
> Jan 19 11:18:32 difrost kernel:  [<c01750e6>] alloc_vfsmnt+0x69/0xf5
> Jan 19 11:18:32 difrost kernel:  [<c01dfe39>] xfs_fs_get_sb+0x12/0x16
> Jan 19 11:18:32 difrost kernel:  [<c01e1494>] xfs_fs_fill_super+0x0/0x2d8
> Jan 19 11:18:32 difrost kernel:  [<c0164cca>] vfs_kern_mount+0x39/0x72
> Jan 19 11:18:32 difrost kernel:  [<c0164d41>] do_kern_mount+0x2f/0xb4
> Jan 19 11:18:32 difrost kernel:  [<c0175c6a>] do_mount+0x632/0x66d
> Jan 19 11:18:32 difrost kernel:  [<c0175d14>] sys_mount+0x6f/0xaf
> Jan 19 11:18:32 difrost kernel:  [<c0102d05>] sysenter_do_call+0x12/0x25
> Jan 19 11:18:32 difrost kernel: Filesystem "sda5": Corruption of in-memory data
> detected.  Shutting down filesystem: sda5
> Jan 19 11:18:32 difrost kernel: Please umount the filesystem, and rectify the
> problem(s)
> Jan 19 11:18:32 difrost kernel: BUG: unable to handle kernel NULL pointer
> dereference at 0000005c
> Jan 19 11:18:32 difrost kernel: IP: [<c01cbb51>]
> xlog_recover_process_iunlinks+0x90/0xd8
> Jan 19 11:18:32 difrost kernel: *pde = 00000000
> Jan 19 11:18:32 difrost kernel: Oops: 0000 [#1] SMP
> Jan 19 11:18:32 difrost kernel: last sysfs file:
> /sys/devices/platform/i8042/modalias
> Jan 19 11:18:32 difrost kernel: Modules linked in: psmouse arc4 ecb cryptomgr
> aead crypto_blkcipher crypto_hash crypto_algapi iwl3945 rfkill mac80211 lib80211
> cfg80211 sky2 sg
> Jan 19 11:18:32 difrost kernel:
> Jan 19 11:18:32 difrost kernel: Pid: 680, comm: mount Not tainted (2.6.29-rc2
> #1) AMILO Pro Edition V3505
> Jan 19 11:18:32 difrost kernel: EIP: 0060:[<c01cbb51>] EFLAGS: 00010286 CPU: 0
> Jan 19 11:18:32 difrost kernel: EIP is at xlog_recover_process_iunlinks+0x90/0xd8
> Jan 19 11:18:32 difrost kernel: EAX: 00000000 EBX: f6a71e40 ECX: 00000005 EDX:
> f695fe20
> Jan 19 11:18:32 difrost kernel: ESI: ffffffff EDI: f6825400 EBP: 00000026 ESP:
> f695fe14
> Jan 19 11:18:32 difrost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Jan 19 11:18:32 difrost kernel: Process mount (pid: 680, ti=f695e000
> task=f6aa5980 task.ti=f695e000)
> Jan 19 11:18:32 difrost kernel: Stack:
> Jan 19 11:18:32 difrost kernel:  00000026 00000002 00000000 00000000 f699c500
> 00000000 00000003 f6825400
> Jan 19 11:18:32 difrost kernel:  c01cbbd8 00000003 00000000 00000000 c01cff74
> 00000013 00000246 00400004
> Jan 19 11:18:32 difrost kernel:  00000000 00000000 00000001 00000058 00000000
> c01d8e3a 00000001 00000058
> Jan 19 11:18:32 difrost kernel: Call Trace:
> Jan 19 11:18:32 difrost kernel:  [<c01cbbd8>] xlog_recover_finish+0x3f/0x8d
> Jan 19 11:18:32 difrost kernel:  [<c01cff74>] xfs_mountfs+0x44e/0x54b
> Jan 19 11:18:32 difrost kernel:  [<c01d8e3a>] kmem_alloc+0x57/0xa8
> Jan 19 11:18:32 difrost kernel:  [<c01d06e9>] xfs_mru_cache_create+0xe6/0x11c
> Jan 19 11:18:32 difrost kernel:  [<c01e1616>] xfs_fs_fill_super+0x182/0x2d8
> Jan 19 11:18:32 difrost kernel:  [<c0165a80>] get_sb_bdev+0xe8/0x130
> Jan 19 11:18:32 difrost kernel:  [<c01750e6>] alloc_vfsmnt+0x69/0xf5
> Jan 19 11:18:32 difrost kernel:  [<c01dfe39>] xfs_fs_get_sb+0x12/0x16
> Jan 19 11:18:32 difrost kernel:  [<c01e1494>] xfs_fs_fill_super+0x0/0x2d8
> Jan 19 11:18:32 difrost kernel:  [<c0164cca>] vfs_kern_mount+0x39/0x72
> Jan 19 11:18:32 difrost kernel:  [<c0164d41>] do_kern_mount+0x2f/0xb4
> Jan 19 11:18:32 difrost kernel:  [<c0175c6a>] do_mount+0x632/0x66d
> Jan 19 11:18:32 difrost kernel:  [<c0175d14>] sys_mount+0x6f/0xaf
> Jan 19 11:18:32 difrost kernel:  [<c0102d05>] sysenter_do_call+0x12/0x25
> Jan 19 11:18:32 difrost kernel: Code: 1d fd 00 00 89 f1 55 89 f8 8b 54 24 04 e8
> af fe ff ff 31 d2 89 c6 8d 44 24 0c 50 89 f8 8b 4c 24 08 e8 0b 14 ff ff 8b 44 24
> 10 5a <8b> 40 5c 59 83 fe ff 75 b8 45 83 fd 40 75 aa 8b 5c 24 08 83 7b
> Jan 19 11:18:32 difrost kernel: EIP: [<c01cbb51>]
> xlog_recover_process_iunlinks+0x90/0xd8 SS:ESP 0068:f695fe14
> Jan 19 11:18:32 difrost kernel: ---[ end trace 0d722cd205608c78 ]---
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
