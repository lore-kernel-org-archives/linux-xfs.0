Return-Path: <SRS0=76Wm=2X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8793C2D0C2
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 19:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21F020863
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Jan 2020 19:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TWASf5K0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgABTPi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Jan 2020 14:15:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38258 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgABTPi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Jan 2020 14:15:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vluhWNX3j2FfQDLbdk+NxlWrmmkIqj11g81oWJAiPoo=; b=TWASf5K0BiF2pNGtAG7jAlypQ8
        OHmnuM9FO3/W+eJGN4qQwSsN0oBRds5pDDiqjJFF+0c+eR4iS8BBaksoWlp5WI3/2qo+HqhyQOdCi
        GiFWsff6gvdTMHfsPYRBpwqXwgNX2Bb5JxoLGeY/6SyjEosWK1bH2wKDsecJfF/C57xubTXnzlVo4
        SAB/gWOpC/TKWQUxu3GMMjC3ziRBa70HVVDsARL1K0SUJ4ulDZtF54r/Q8ykEmKmrfj5XkzjO56t5
        N7+nEBNC6Ozep5ZhJwU+iEhbopuHIEbsjWJFfcfZiIkrai1rvJqLJXjuHJKswEm0xi/gz9D0V97Vz
        Z1CCZ9SA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1in5wX-0007gh-K2
        for linux-xfs@vger.kernel.org; Thu, 02 Jan 2020 19:15:37 +0000
Date:   Thu, 2 Jan 2020 11:15:37 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-xfs@vger.kernel.org
Subject: assertion failure when running generic/019
Message-ID: <20200102191537.GG6788@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


I've hit a few of these.  Occurs in maybe 10-20% of the runs so it can
take a while to decide whether a kernel is good or bad doing a bisect.
Here's one from commit 6210469417fd967ec72dea56723593beefeecafb in
Linus' tree.  I'm using the 01.org build-bot config & job-script.

job=/lkp/jobs/scheduled/vm-snb-ea9f97a663a6/xfstests-4HDD-xfs-generic-group00-debian-x86_64-2019-11-14.cgz-72273b2-20191222-10497-fw38k8-2.yaml
...
        run_test test='generic-group00' $LKP_SRC/tests/wrapper xfstests


[   65.455593] run fstests generic/019 at 2020-01-02 13:24:44
[   65.651992] XFS (vda): Mounting V5 Filesystem
[   65.657920] XFS (vda): Ending clean mount
[   65.660127] xfs filesystem being mounted at /fs/vda supports timestamps until 2038 (0x7fffffff)
[   66.108165] XFS (vdd): Mounting V5 Filesystem
[   66.112144] XFS (vdd): Ending clean mount
[   66.114597] xfs filesystem being mounted at /fs/scratch supports timestamps until 2038 (0x7fffffff)
[   75.759802] XFS (vdd): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[   96.133916] vdd: writeback error on inode 562692, offset 0, sector 578584
[   96.135397] vdd: writeback error on inode 134277997, offset 1638400, sector 193107816
[   96.144409] XFS (vdd): log I/O error -5
[   96.149853] XFS (vdd): xfs_do_force_shutdown(0x2) called from line 1297 of file fs/xfs/xfs_log.c. Return address = ffffffffc044d773
[   96.154022] XFS (vdd): Log I/O Error Detected. Shutting down filesystem
[   96.156382] XFS (vdd): Please unmount the filesystem and rectify the problem(s)
[   96.164120] XFS (vdd): log I/O error -5
[   96.170256] XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_private.b.allocated == 0, file: fs/xfs/libxfs/xfs_btree.c, line: 380
[   96.177104] ------------[ cut here ]------------
[   96.179178] kernel BUG at fs/xfs/xfs_message.c:110!
[   96.181561] invalid opcode: 0000 [#1] SMP PTI
[   96.183267] CPU: 1 PID: 11823 Comm: fio Not tainted 5.5.0-rc2-00351-g6210469417fd #7
[   96.185909] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
[   96.189730] RIP: 0010:assfail+0x23/0x28 [xfs]
[   96.192215] Code: 67 fc ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 98 0b 4a c0 e8 82 f9 ff ff 80 3d 54 0c 09 00 00 74 02 <0f> 0b 0f 0b c3 48 8b 33 48 c7 c7 10 10 4a c0 c6 05 40 7a 0a 00 01
[   96.197036] RSP: 0018:ffffb9e50527b7c0 EFLAGS: 00010202
[   96.198841] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[   96.200900] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc04932f7
[   96.202952] RBP: ffff8edc7d03b620 R08: 0000000000000000 R09: 0000000000000000
[   96.205053] R10: 000000000000000a R11: f000000000000000 R12: 00000000fffffffb
[   96.207106] R13: 0000000000c347cc R14: ffffb9e50527b860 R15: 0000000000000000
[   96.209148] FS:  00007fd2450c1a80(0000) GS:ffff8edd0f500000(0000) knlGS:0000000000000000
[   96.211385] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   96.213342] CR2: 00007f1fcb1617f0 CR3: 00000000bcac4000 CR4: 00000000000006e0
[   96.215409] Call Trace:
[   96.216830]  xfs_btree_del_cursor+0x83/0x90 [xfs]
[   96.218574]  xfs_bmapi_write+0x754/0xaf0 [xfs]
[   96.220390]  xfs_iomap_write_direct+0x1c1/0x2e0 [xfs]
[   96.222208]  xfs_direct_write_iomap_begin+0x423/0x5d0 [xfs]
[   96.224025]  iomap_apply+0x98/0x370
[   96.225640]  ? iomap_dio_bio_actor+0x3a0/0x3a0
[   96.227326]  ? iomap_dio_rw+0x2d8/0x480
[   96.228962]  iomap_dio_rw+0x2d8/0x480
[   96.230836]  ? iomap_dio_bio_actor+0x3a0/0x3a0
[   96.232504]  ? xfs_file_dio_aio_write+0x110/0x320 [xfs]
[   96.234364]  xfs_file_dio_aio_write+0x110/0x320 [xfs]
[   96.236186]  xfs_file_write_iter+0x93/0xe0 [xfs]
[   96.237898]  aio_write+0xec/0x1a0
[   96.239388]  ? __switch_to_asm+0x40/0x70
[   96.240982]  ? account_kernel_stack+0x69/0x120
[   96.242607]  ? put_task_stack+0x49/0x190
[   96.244150]  ? _copy_to_user+0x76/0x90
[   96.245666]  __io_submit_one.constprop.0+0x39c/0x710
[   96.247387]  ? io_submit_one+0xe8/0x580
[   96.248913]  io_submit_one+0xe8/0x580
[   96.250412]  __x64_sys_io_submit+0x91/0x1a0
[   96.252015]  do_syscall_64+0x5b/0x1f0
[   96.253527]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   96.255226] RIP: 0033:0x7fd2315e2717
[   96.256614] Code: 00 75 08 8b 47 0c 39 47 08 74 08 e9 c3 ff ff ff 0f 1f 00 31 c0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 d1 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 d2 00 00 00 0f 05 c3 0f 1f 84 00 00
[   96.261250] RSP: 002b:00007ffcd13e1558 EFLAGS: 00000202 ORIG_RAX: 00000000000000d1
[   96.263295] RAX: ffffffffffffffda RBX: 00007fd2183e7418 RCX: 00007fd2315e2717
[   96.265267] RDX: 000055d2ff0f19f0 RSI: 0000000000000001 RDI: 00007fd245021000
[   96.267218] RBP: 00000000000000a0 R08: 0000000000000001 R09: 000055d2ff0e2f60
[   96.269089] R10: 00007ffcd13e1550 R11: 0000000000000202 R12: 0000000000000000
[   96.271042] R13: 00007fd2183e7418 R14: 000055d2ff0f1d60 R15: 000055d2ff0d3f40
[   96.272940] Modules linked in: xfs libcrc32c sr_mod cdrom sg bochs_drm ppdev drm_vram_helper ata_generic pata_acpi drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm joydev serio_raw pcspkr ata_piix libata i2c_piix4 parport_pc floppy parport ip_tables
[   96.279526] ---[ end trace 64727b1562864575 ]---
[   96.281463] RIP: 0010:assfail+0x23/0x28 [xfs]
[   96.283045] Code: 67 fc ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 98 0b 4a c0 e8 82 f9 ff ff 80 3d 54 0c 09 00 00 74 02 <0f> 0b 0f 0b c3 48 8b 33 48 c7 c7 10 10 4a c0 c6 05 40 7a 0a 00 01
[   96.287609] RSP: 0018:ffffb9e50527b7c0 EFLAGS: 00010202
[   96.289265] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[   96.291403] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc04932f7
[   96.293492] RBP: ffff8edc7d03b620 R08: 0000000000000000 R09: 0000000000000000
[   96.295507] R10: 000000000000000a R11: f000000000000000 R12: 00000000fffffffb
[   96.297504] R13: 0000000000c347cc R14: ffffb9e50527b860 R15: 0000000000000000
[   96.299493] FS:  00007fd2450c1a80(0000) GS:ffff8edd0f500000(0000) knlGS:0000000000000000
[   96.301628] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   96.303404] CR2: 00007f1fcb1617f0 CR3: 00000000bcac4000 CR4: 00000000000006e0
[   96.305387] Kernel panic - not syncing: Fatal exception
[   96.307129] Kernel Offset: 0x14400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

-- earlier from a tree with some of my patches in it --

[   64.961563] run fstests generic/019 at 2020-01-02 10:20:48
[   65.153636] XFS (vda): Mounting V5 Filesystem
[   65.159796] XFS (vda): Ending clean mount
[   65.161731] xfs filesystem being mounted at /fs/vda supports timestamps until 2038 (0x7fffffff)
[   65.621885] XFS (vdd): Mounting V5 Filesystem
[   65.626777] XFS (vdd): Ending clean mount
[   65.629441] xfs filesystem being mounted at /fs/scratch supports timestamps until 2038 (0x7fffffff)
[   77.556762] XFS (vdd): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[   95.664553] vdd: writeback error on inode 268698003, offset 585728, sector 403860000
[   95.667287] XFS (vdd): log I/O error -5
[   95.673012] XFS (vdd): xfs_do_force_shutdown(0x2) called from line 1297 of file fs/xfs/xfs_log.c. Return address = ffffffffc06fbbd3
[   95.676868] XFS (vdd): Log I/O Error Detected. Shutting down filesystem
[   95.678914] XFS (vdd): Please unmount the filesystem and rectify the problem(s)
[   95.684242] XFS (vdd): log I/O error -5
[   95.688913] XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_private.b.allocated == 0, file: fs/xfs/libxfs/xfs_btree.c, line: 380
[   95.696002] ------------[ cut here ]------------
[   95.697775] kernel BUG at fs/xfs/xfs_message.c:110!
[   95.700572] invalid opcode: 0000 [#1] SMP PTI
[   95.702419] CPU: 1 PID: 11840 Comm: fio Not tainted 5.5.0-rc4-00074-g927ecff81368-dirty #6
[   95.705563] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
[   95.708482] RIP: 0010:assfail+0x23/0x28 [xfs]
[   95.710573] Code: 67 fc ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 00 fc 74 c0 e8 82 f9 ff ff 80 3d 54 29 09 00 00 74 02 <0f> 0b 0f 0b c3 48 8b 33 48 c7 c7 f0 00 75 c0 c6 05 00 98 0a 00 01
[   95.718459] RSP: 0018:ffffb6aac51fb7c0 EFLAGS: 00010202
[   95.720407] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[   95.722637] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc0742350
[   95.724841] RBP: ffff89dbbc2f7a80 R08: 0000000000000000 R09: 0000000000000000
[   95.727079] R10: 000000000000000a R11: f000000000000000 R12: 00000000fffffffb
[   95.729347] R13: 0000000000fc776d R14: ffffb6aac51fb860 R15: 0000000000000000
[   95.731521] FS:  00007fcf2b620a80(0000) GS:ffff89dc2fd00000(0000) knlGS:0000000000000000
[   95.733864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.735845] CR2: 00007fb5b5aa95e0 CR3: 00000000bd5dc000 CR4: 00000000000006e0
[   95.738042] Call Trace:
[   95.739565]  xfs_btree_del_cursor+0x83/0x90 [xfs]
[   95.741399]  xfs_bmapi_write+0x754/0xaf0 [xfs]
[   95.743181]  xfs_iomap_write_direct+0x1c1/0x2e0 [xfs]
[   95.745141]  xfs_direct_write_iomap_begin+0x423/0x5d0 [xfs]
[   95.747187]  iomap_apply+0x98/0x370
[   95.748849]  ? iomap_dio_bio_actor+0x3a0/0x3a0
[   95.750689]  ? iomap_dio_rw+0x2d8/0x480
[   95.752377]  iomap_dio_rw+0x2d8/0x480
[   95.754084]  ? iomap_dio_bio_actor+0x3a0/0x3a0
[   95.756321]  ? xfs_file_dio_aio_write+0x110/0x320 [xfs]
[   95.758234]  xfs_file_dio_aio_write+0x110/0x320 [xfs]
[   95.760236]  xfs_file_write_iter+0x93/0xe0 [xfs]
[   95.762076]  aio_write+0xec/0x1a0
[   95.763714]  ? __switch_to_asm+0x34/0x70
[   95.765344]  ? __switch_to_asm+0x34/0x70
[   95.767020]  ? __switch_to_asm+0x40/0x70
[   95.768694]  ? __switch_to_asm+0x34/0x70
[   95.770329]  ? __switch_to_asm+0x40/0x70
[   95.771960]  ? __switch_to_asm+0x34/0x70
[   95.773572]  ? __switch_to_asm+0x40/0x70
[   95.775109]  ? __switch_to_asm+0x34/0x70
[   95.776670]  ? __switch_to_asm+0x40/0x70
[   95.778162]  ? __switch_to_asm+0x34/0x70
[   95.779623]  ? __switch_to_asm+0x40/0x70
[   95.781091]  ? _copy_to_user+0x76/0x90
[   95.782745]  __io_submit_one.constprop.0+0x39c/0x710
[   95.784385]  ? io_submit_one+0xe8/0x580
[   95.785800]  io_submit_one+0xe8/0x580
[   95.787189]  __x64_sys_io_submit+0x91/0x1a0
[   95.788689]  do_syscall_64+0x5b/0x1f0
[   95.789975]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   95.791561] RIP: 0033:0x7fcf17b3d717
[   95.792893] Code: 00 75 08 8b 47 0c 39 47 08 74 08 e9 c3 ff ff ff 0f 1f 00 31 c0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 d1 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 d2 00 00 00 0f 05 c3 0f 1f 84 00 00
[   95.797521] RSP: 002b:00007fff8d6e48c8 EFLAGS: 00000206 ORIG_RAX: 00000000000000d1
[   95.799617] RAX: ffffffffffffffda RBX: 00007fcefe934810 RCX: 00007fcf17b3d717
[   95.801574] RDX: 000055c818e1bc08 RSI: 0000000000000001 RDI: 00007fcf2b581000
[   95.803498] RBP: 00000000000002b8 R08: 0000000000000001 R09: 000055c818e0aa20
[   95.805404] R10: 00007fff8d6e48c0 R11: 0000000000000206 R12: 0000000000000000
[   95.807242] R13: 00007fcefe934810 R14: 000055c818e1bd60 R15: 000055c818dfdf40
[   95.809113] Modules linked in: xfs libcrc32c sr_mod cdrom bochs_drm sg drm_vram_helper drm_ttm_helper ttm ata_generic pata_acpi ppdev drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops pcspkr joydev ata_piix serio_raw drm libata i2c_piix4 parport_pc parport floppy ip_tables
[   95.815578] ---[ end trace a8509ddc8ad5e877 ]---
[   95.817134] RIP: 0010:assfail+0x23/0x28 [xfs]
[   95.818634] Code: 67 fc ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 00 fc 74 c0 e8 82 f9 ff ff 80 3d 54 29 09 00 00 74 02 <0f> 0b 0f 0b c3 48 8b 33 48 c7 c7 f0 00 75 c0 c6 05 00 98 0a 00 01
[   95.823345] RSP: 0018:ffffb6aac51fb7c0 EFLAGS: 00010202
[   95.824984] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[   95.826893] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc0742350
[   95.828938] RBP: ffff89dbbc2f7a80 R08: 0000000000000000 R09: 0000000000000000
[   95.830984] R10: 000000000000000a R11: f000000000000000 R12: 00000000fffffffb
[   95.832878] R13: 0000000000fc776d R14: ffffb6aac51fb860 R15: 0000000000000000
[   95.834896] FS:  00007fcf2b620a80(0000) GS:ffff89dc2fd00000(0000) knlGS:0000000000000000
[   95.837106] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.838941] CR2: 00007fb5b5aa95e0 CR3: 00000000bd5dc000 CR4: 00000000000006e0
[   95.840926] Kernel panic - not syncing: Fatal exception
[   95.842747] Kernel Offset: 0x15000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)


[   64.141329] run fstests generic/019 at 2020-01-02 11:52:59
[   64.333664] XFS (vda): Mounting V5 Filesystem
[   64.339484] XFS (vda): Ending clean mount
[   64.343071] xfs filesystem being mounted at /fs/vda supports timestamps until 2038 (0x7fffffff)
[   64.830077] XFS (vdd): Mounting V5 Filesystem
[   64.843176] XFS (vdd): Ending clean mount
[   64.851589] xfs filesystem being mounted at /fs/scratch supports timestamps until 2038 (0x7fffffff)
[   75.545765] XFS (vdd): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[   94.884746] XFS (vdd): log I/O error -5
[   94.885861] vdd: writeback error on inode 268697721, offset 36864, sector 268774616
[   94.891453] XFS (vdd): xfs_do_force_shutdown(0x2) called from line 1297 of file fs/xfs/xfs_log.c. Return address = ffffffffc04debd3
[   94.894365] XFS: Assertion failed: cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_private.b.allocated == 0, file: fs/xfs/libxfs/xfs_btree.c, line: 380
[   94.896511] XFS (vdd): Log I/O Error Detected. Shutting down filesystem
[   94.896513] XFS (vdd): Please unmount the filesystem and rectify the problem(s)
[   94.900797] ------------[ cut here ]------------
[   94.905374] XFS (vdd): log I/O error -5
[   94.907952] kernel BUG at fs/xfs/xfs_message.c:110!
[   94.908014] invalid opcode: 0000 [#1] SMP PTI
[   94.914891] CPU: 1 PID: 11830 Comm: fio Not tainted 5.5.0-rc4-00074-g927ecff81368-dirty #6
[   94.917056] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
[   94.919335] RIP: 0010:assfail+0x23/0x28 [xfs]
[   94.920987] Code: 67 fc ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 00 2c 53 c0 e8 82 f9 ff ff 80 3d 54 29 09 00 00 74 02 <0f> 0b 0f 0b c3 48 8b 33 48 c7 c7 f0 30 53 c0 c6 05 00 98 0a 00 01
[   94.926838] RSP: 0000:ffffb975c549b7c0 EFLAGS: 00010202
[   94.928738] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[   94.930957] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc0525350
[   94.933124] RBP: ffff9f52fbd6c620 R08: 0000000000000000 R09: 0000000000000000
[   94.935230] R10: 000000000000000a R11: f000000000000000 R12: 00000000fffffffb
[   94.937382] R13: 000000000104d6d7 R14: ffffb975c549b860 R15: 0000000000000000
[   94.939490] FS:  00007f46ecfefa80(0000) GS:ffff9f5377500000(0000) knlGS:0000000000000000
[   94.941730] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   94.943567] CR2: 00000000017eb298 CR3: 00000000bc0e2000 CR4: 00000000000006e0
[   94.945668] Call Trace:
[   94.947341]  xfs_btree_del_cursor+0x83/0x90 [xfs]
[   94.949202]  xfs_bmapi_write+0x754/0xaf0 [xfs]
[   94.950900]  xfs_iomap_write_direct+0x1c1/0x2e0 [xfs]
[   94.952724]  xfs_direct_write_iomap_begin+0x423/0x5d0 [xfs]
[   94.954588]  iomap_apply+0x98/0x370
[   94.956139]  ? iomap_dio_bio_actor+0x3a0/0x3a0
[   94.957828]  ? iomap_dio_rw+0x2d8/0x480
[   94.959358]  iomap_dio_rw+0x2d8/0x480
[   94.960926]  ? iomap_dio_bio_actor+0x3a0/0x3a0
[   94.962612]  ? xfs_file_dio_aio_write+0x110/0x320 [xfs]
[   94.965422]  xfs_file_dio_aio_write+0x110/0x320 [xfs]
[   94.967192]  xfs_file_write_iter+0x93/0xe0 [xfs]
[   94.968935]  aio_write+0xec/0x1a0
[   94.970484]  ? __switch_to_asm+0x34/0x70
[   94.972109]  ? __switch_to_asm+0x34/0x70
[   94.973723]  ? __switch_to_asm+0x40/0x70
[   94.975292]  ? __switch_to_asm+0x34/0x70
[   94.976811]  ? __switch_to_asm+0x40/0x70
[   94.978316]  ? __switch_to_asm+0x34/0x70
[   94.979800]  ? __switch_to_asm+0x40/0x70
[   94.981356]  ? __switch_to_asm+0x34/0x70
[   94.982776]  ? __switch_to_asm+0x40/0x70
[   94.984177]  ? __switch_to_asm+0x34/0x70
[   94.985854]  ? __switch_to_asm+0x40/0x70
[   94.987202]  ? _copy_to_user+0x76/0x90
[   94.988472]  __io_submit_one.constprop.0+0x39c/0x710
[   94.989929]  ? io_submit_one+0xe8/0x580
[   94.991199]  io_submit_one+0xe8/0x580
[   94.992957]  __x64_sys_io_submit+0x91/0x1a0
[   94.995349]  do_syscall_64+0x5b/0x1f0
[   94.996651]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   94.998193] RIP: 0033:0x7f46d950c717
[   94.999383] Code: 00 75 08 8b 47 0c 39 47 08 74 08 e9 c3 ff ff ff 0f 1f 00 31 c0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 b8 d1 00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 d2 00 00 00 0f 05 c3 0f 1f 84 00 00
[   95.003580] RSP: 002b:00007ffc20e20678 EFLAGS: 00000202 ORIG_RAX: 00000000000000d1
[   95.005616] RAX: ffffffffffffffda RBX: 00007f46c0311418 RCX: 00007f46d950c717
[   95.007379] RDX: 000055fe8bcc3ca0 RSI: 0000000000000001 RDI: 00007f46ecf4f000
[   95.009117] RBP: 0000000000000350 R08: 0000000000000001 R09: 000055fe8bcbb9e0
[   95.010810] R10: 00007ffc20e20670 R11: 0000000000000202 R12: 0000000000000000
[   95.012506] R13: 00007f46c0311418 R14: 000055fe8bcc3d60 R15: 000055fe8bca5f40
[   95.014708] Modules linked in: xfs libcrc32c sr_mod cdrom sg ata_generic pata_acpi bochs_drm drm_vram_helper drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt ppdev fb_sys_fops drm ata_piix joydev libata pcspkr serio_raw i2c_piix4 floppy parport_pc parport ip_tables
[   95.020735] ---[ end trace 1ab5851cbc576936 ]---
[   95.022308] RIP: 0010:assfail+0x23/0x28 [xfs]
[   95.023713] Code: 67 fc ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 00 2c 53 c0 e8 82 f9 ff ff 80 3d 54 29 09 00 00 74 02 <0f> 0b 0f 0b c3 48 8b 33 48 c7 c7 f0 30 53 c0 c6 05 00 98 0a 00 01
[   95.027624] RSP: 0000:ffffb975c549b7c0 EFLAGS: 00010202
[   95.028955] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
[   95.031863] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffc0525350
[   95.033737] RBP: ffff9f52fbd6c620 R08: 0000000000000000 R09: 0000000000000000
[   95.035559] R10: 000000000000000a R11: f000000000000000 R12: 00000000fffffffb
[   95.037478] R13: 000000000104d6d7 R14: ffffb975c549b860 R15: 0000000000000000
[   95.039368] FS:  00007f46ecfefa80(0000) GS:ffff9f5377500000(0000) knlGS:0000000000000000
[   95.041412] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   95.043199] CR2: 00000000017eb298 CR3: 00000000bc0e2000 CR4: 00000000000006e0
[   95.045355] Kernel panic - not syncing: Fatal exception
[   95.047008] Kernel Offset: 0x2ec00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)

