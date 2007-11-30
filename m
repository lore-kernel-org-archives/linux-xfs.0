Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 30 Nov 2007 14:32:00 -0800 (PST)
Received: from ninsei.hu (ninsei.hu [212.92.23.158])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lAUMVrCO028627
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 14:31:55 -0800
Received: from luba (lns-bzn-35-82-250-208-136.adsl.proxad.net [82.250.208.136])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id D62C07A32
	for <xfs@oss.sgi.com>; Fri, 30 Nov 2007 23:31:35 +0100 (CET)
Date: Fri, 30 Nov 2007 23:31:54 +0100
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: 2.6.24-rc3 oopses while mounting fs
Message-ID: <20071130223154.GB13589@luba>
References: <20071128134523.GF7793@luba> <474E003A.7020000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <474E003A.7020000@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Lachlan Mcilroy (lachlan@sgi.com) [20071129 10:56]:

Lachlan,

> This looks like a problem we've just fixed, try this patch.
> We'll get this to mainline soon.

Thanks for the patch.  Unfortunately, it does not seem to fix my
problem.  Attempting to mount the filesystem still results in an
oops.

Peter

-----8<---
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sdc
Starting XFS recovery on filesystem: sdc (logdev: internal)
Unable to handle kernel paging request at ffffc20001c9b000 RIP: 
 [<ffffffff881c6175>] :xfs:xlog_recover_add_to_trans+0x64/0xef
PGD 15781d067 PUD 15781c067 PMD 130fd3067 PTE 0
Oops: 0000 [1] SMP 
CPU 1 
Modules linked in: xfs sd_mod 3w_9xxx scsi_mod ohci_hcd uhci_hcd ehci_hcd ipv6 bnx2 sky2 r8169 ns838
20 dl2k acenic e100 tg3 e1000 mii
Pid: 2431, comm: mount Not tainted 2.6.24-rc3-xfsbuf #2
RIP: 0010:[<ffffffff881c6175>]  [<ffffffff881c6175>] :xfs:xlog_recover_add_to_trans+0x64/0xef
RSP: 0018:ffff8101320d9728  EFLAGS: 00010286
RAX: ffffc20001c9c000 RBX: 000000000020bd78 RCX: 00000000001cc280
RDX: 0000000000000000 RSI: ffffc20001c9b000 RDI: ffffc20001cdbaf8
RBP: ffff8101320d9758 R08: ffff810157801652 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000002 R12: ffff8101324633b8
R13: ffffc20001c5b508 R14: ffff810132463110 R15: ffffc20001c5b4fc
FS:  00002abba6e87b00(0000) GS:ffff810157801708(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffc20001c9b000 CR3: 000000013252a000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process mount (pid: 2431, threadinfo ffff8101320d8000, task ffff810131972000)
Stack:  0020bd785769c5e8 000000005769c5e8 000000000000000a ffffc20001c5b508
 000000000000011e ffffc20001c5b4fc ffff8101320d97b8 ffffffff881c79db
 ffffc20001c6a000 00000001881da0bc ffff81013188f000 ffff8101320d9828
Call Trace:
 [<ffffffff881c79db>] :xfs:xlog_recover_process_data+0x184/0x1d9
 [<ffffffff881c89cb>] :xfs:xlog_do_recovery_pass+0x74b/0x795
 [<ffffffff881c8a52>] :xfs:xlog_do_log_recovery+0x3d/0x82
 [<ffffffff881c8aa9>] :xfs:xlog_do_recover+0x12/0x11c
 [<ffffffff881c8c37>] :xfs:xlog_recover+0x84/0x92
 [<ffffffff881c3125>] :xfs:xfs_log_mount+0x8c/0xe4
 [<ffffffff881cad92>] :xfs:xfs_mountfs+0x67d/0x97b
 [<ffffffff881cbcb7>] :xfs:xfs_mru_cache_create+0x170/0x1d5
 [<ffffffff881b2f04>] :xfs:xfs_fstrm_free_func+0x0/0x81
 [<ffffffff881be67c>] :xfs:xfs_ioinit+0xb/0xd
 [<ffffffff881d0cfa>] :xfs:xfs_mount+0x2bb/0x36b
 [<ffffffff881e12d9>] :xfs:xfs_fs_fill_super+0xd2/0x245
 [<ffffffff802b7b9f>] get_filesystem+0x17/0x39
 [<ffffffff802a4659>] sget+0x3fb/0x418
 [<ffffffff802a4661>] sget+0x403/0x418
 [<ffffffff802a4d79>] set_bdev_super+0x0/0x14
 [<ffffffff802a4ec2>] get_sb_bdev+0x123/0x16f
 [<ffffffff881e1207>] :xfs:xfs_fs_fill_super+0x0/0x245
 [<ffffffff881e145f>] :xfs:xfs_fs_get_sb+0x13/0x18
 [<ffffffff802a5107>] vfs_kern_mount+0x8f/0x11c
 [<ffffffff802a51d8>] do_kern_mount+0x44/0xf4
 [<ffffffff802ba0d3>] do_mount+0x6d8/0x71e
 [<ffffffff80335682>] __up_read+0x93/0x9b
 [<ffffffff80252261>] up_read+0x23/0x27
 [<ffffffff8047a679>] do_page_fault+0x42e/0x7c7
 [<ffffffff80284d61>] zone_statistics+0x64/0x69
 [<ffffffff8027e4e0>] __alloc_pages+0x6b/0x311
 [<ffffffff802ba3c8>] sys_mount+0x8a/0xcc
 [<ffffffff8020bf8e>] system_call+0x7e/0x83

Code: f3 a4 49 89 c7 49 8b 54 24 08 8b 42 18 85 c0 74 0e 3b 42 14 

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
