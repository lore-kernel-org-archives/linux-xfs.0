Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Oct 2007 06:50:06 -0700 (PDT)
Received: from sargon.lncsa.com (sargon.lncsa.com [212.99.8.251])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l94Do2pk029591
	for <xfs@oss.sgi.com>; Thu, 4 Oct 2007 06:50:03 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by sargon.lncsa.com (Postfix) with ESMTP id 60368303773A
	for <xfs@oss.sgi.com>; Thu,  4 Oct 2007 15:33:03 +0200 (CEST)
Received: from sargon.lncsa.com ([127.0.0.1])
	by localhost (sargon.lncsa.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mPdNBRtTcwWE for <xfs@oss.sgi.com>;
	Thu,  4 Oct 2007 15:33:03 +0200 (CEST)
Received: from zenon.apartia.fr (zenon.apartia.fr [10.0.3.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "zenon.apartia.fr", Issuer "ca.apartia.fr" (verified OK))
	by sargon.lncsa.com (Postfix) with ESMTP id 2CA333000314
	for <xfs@oss.sgi.com>; Thu,  4 Oct 2007 15:33:03 +0200 (CEST)
Date: Thu, 4 Oct 2007 15:33:02 +0200
From: vindex+lists-xfs@apartia.org
Subject: Crash on 2.6.21.7 Vanilla + DRBD 0.7
Message-ID: <20071004133302.GA5058@apartia.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Hi,

I did compile a fresh 2.6.21.7 kernel from kernel.org (no distro patch,
....), and latest svn (3062) 0.7.X drbd.

After just 2 days of uptime, I did experience another crash.

I wonder if it is an XFS related bug, a DRBD one, or related to XFS on
top of DRBD.

This bug seems to occur with intensive IO operations.

What do you think about it ?

Thanks


Oct  3 18:55:23  kernel: Oops: 0002 [#1]
Oct  3 18:55:23  kernel: SMP 
Oct  3 18:55:23  kernel: CPU:    7
Oct  3 18:55:23  kernel: EIP:    0060:[<c016540c>]    Not tainted VLI
Oct  3 18:55:23  kernel: EFLAGS: 00010046   (2.6.21-dl380-g5-20071001 #1)
Oct  3 18:55:23  kernel: EIP is at cache_alloc_refill+0x11c/0x4f0
Oct  3 18:55:23  kernel: eax: f79c2940   ebx: 00000015   ecx: 00000005   edx: 65b567b0
Oct  3 18:55:23  kernel: esi: 0000000a   edi: d5d26000   ebp: f79d03c0   esp: d2531c98
Oct  3 18:55:23  kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Oct  3 18:55:23  kernel: Process rsync (pid: 22409, ti=d2530000 task=da1e8070 task.ti=d2530000)
Oct  3 18:55:23  kernel: Stack: 00000010 000002d0 ce9ca0b8 000002d0 f79cfe00 f79d1c00 f79c2940 00000000 
Oct  3 18:55:23  kernel: 00000001 d2531cd4 ce9ca088 c022aade d5d2601c 00000282 f79cfe00 000002d0 
Oct  3 18:55:23  kernel: f79cfe00 c01652e6 00000000 00000001 c0265a4e 00000011 d2531d60 d7acfb40 
Oct  3 18:55:23  kernel: Call Trace:
Oct  3 18:55:23  kernel: [<c022aade>] xfs_da_brelse+0x6e/0xb0
Oct  3 18:55:23  kernel: [<c01652e6>] kmem_cache_alloc+0x46/0x50
Oct  3 18:55:23  kernel: [<c0265a4e>] kmem_zone_alloc+0x4e/0xc0
Oct  3 18:55:23  kernel: [<c027015f>] xfs_fs_alloc_inode+0xf/0x20
Oct  3 18:55:23  kernel: [<c017bbd6>] alloc_inode+0x16/0x170
Oct  3 18:55:23  kernel: [<c017bd89>] iget_locked+0x59/0x130
Oct  3 18:55:23  kernel: [<c023fa38>] xfs_iget+0x78/0x160
Oct  3 18:55:23  kernel: [<c020a49c>] xfs_acl_vget+0x6c/0x160
Oct  3 18:55:23  kernel: [<c025b143>] xfs_dir_lookup_int+0x93/0xf0
Oct  3 18:55:23  kernel: [<c025ea55>] xfs_lookup+0x75/0xa0
Oct  3 18:55:23  kernel: [<c026d0c2>] xfs_vn_lookup+0x52/0x90
Oct  3 18:55:23  kernel: [<c016fd08>] do_lookup+0x148/0x190
Oct  3 18:55:23  kernel: [<c0171cb4>] __link_path_walk+0x814/0xe40
Oct  3 18:55:23  kernel: [<c0172325>] link_path_walk+0x45/0xc0
Oct  3 18:55:23  kernel: [<c0172581>] do_path_lookup+0x81/0x1c0
Oct  3 18:55:23  kernel: [<c01712c3>] getname+0xb3/0xe0
Oct  3 18:55:23  kernel: [<c0172f8b>] __user_walk_fd+0x3b/0x60
Oct  3 18:55:23  kernel: [<c016bcdf>] vfs_lstat_fd+0x1f/0x50
Oct  3 18:55:23  kernel: [<c016bd5f>] sys_lstat64+0xf/0x30
Oct  3 18:55:23  kernel: [<c01040b0>] sysenter_past_esp+0x5d/0x81
Oct  3 18:55:23  kernel: =======================
Oct  3 18:55:23  kernel: Code: 10 8b 77 14 01 c2 8b 44 24 30 8b 34 b0 89 77 14 89 54 8d 14 8d 51 01 89 55 00 8b 44 24 10 8b 77 10 3b 70 5c 72 c0 8b 17 8b 47 04 <89> 42 04 89 10 83 7f 14 ff c7 07 00 01 10 00 c7 47 04 00 02 20 
Oct  3 18:55:23  kernel: EIP: [<c016540c>] cache_alloc_refill+0x11c/0x4f0 SS:ESP 0068:d2531c98
Oct  3 18:55:26  kernel: Oops: 0002 [#2]
Oct  3 18:55:26  kernel: SMP 
Oct  3 18:55:26  kernel: CPU:    7
Oct  3 18:55:26  kernel: EIP:    0060:[<c017bbe0>]    Not tainted VLI
Oct  3 18:55:26  kernel: EFLAGS: 00210282   (2.6.21-dl380-g5-20071001 #1)
Oct  3 18:55:26  kernel: EIP is at alloc_inode+0x20/0x170
Oct  3 18:55:26  kernel: eax: b4fd89ba   ebx: b4fd89ba   ecx: b4fd89ba   edx: b4fd89ba
Oct  3 18:55:26  kernel: esi: f29bb000   edi: f29bb000   ebp: ca743575   esp: d6747c64
Oct  3 18:55:26  kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Oct  3 18:55:26  kernel: Process imapd (pid: 20054, ti=d6746000 task=e04a20b0 task.ti=d6746000)
Oct  3 18:55:26  kernel: Stack: 00000000 c76fe0dc f29bb000 c017bd89 ffffffff ffffffff c04abda0 ca743575 
Oct  3 18:55:26  kernel: ca743575 f53b5800 c023fa38 cb2b4524 1b2595f3 00000020 f0dd7400 ded8b7a8 
Oct  3 18:55:26  kernel: 00000000 f53b5800 c04abda0 cb2b4524 cb2b4524 ca743575 00000000 00000004 
Oct  3 18:55:26  kernel: Call Trace:
Oct  3 18:55:26  kernel: [<c017bd89>] iget_locked+0x59/0x130
Oct  3 18:55:26  kernel: [<c023fa38>] xfs_iget+0x78/0x160
Oct  3 18:55:26  kernel: [<c025a697>] xfs_trans_iget+0x117/0x190
Oct  3 18:55:26  kernel: [<c0243d87>] xfs_ialloc+0xc7/0x570
Oct  3 18:55:26  kernel: [<c024aabc>] xlog_grant_push_ail+0x3c/0x150
Oct  3 18:55:26  kernel: [<c025b261>] xfs_dir_ialloc+0x81/0x2d0
Oct  3 18:55:26  kernel: [<c025855b>] xfs_trans_reserve+0xab/0x230
Oct  3 18:55:26  kernel: [<c0261aa5>] xfs_create+0x395/0x6a0
Oct  3 18:55:26  kernel: [<c023eac5>] xfs_iunlock+0x85/0xa0
Oct  3 18:55:26  kernel: [<c026d6b5>] xfs_vn_mknod+0x235/0x360
Oct  3 18:55:26  kernel: [<c01705cd>] vfs_create+0xdd/0x140
Oct  3 18:55:26  kernel: [<c01738ae>] open_namei+0x58e/0x5f0
Oct  3 18:55:26  kernel: [<c016716e>] do_filp_open+0x2e/0x60
Oct  3 18:55:26  kernel: [<c0166e4f>] get_unused_fd+0x4f/0xb0
Oct  3 18:55:26  kernel: [<c01671ea>] do_sys_open+0x4a/0xe0
Oct  3 18:55:26  kernel: [<c01672bc>] sys_open+0x1c/0x20
Oct  3 18:55:26  kernel: [<c01040b0>] sysenter_past_esp+0x5d/0x81
Oct  3 18:55:26  kernel: =======================
Oct  3 18:55:26  kernel: Code: 90 90 90 90 90 90 90 90 90 90 90 57 56 89 c6 53 8b 40 20 8b 10 85 d2 0f 84 1e 01 00 00 89 f0 ff d2 89 c3 85 db 0f 84 ee 00 00 00 <89> b3 98 00 00 00 b9 02 00 00 00 0f b6 46 10 8d bb f8 00 00 00 
Oct  3 18:55:26  kernel: EIP: [<c017bbe0>] alloc_inode+0x20/0x170 SS:ESP 0068:d6747c64
