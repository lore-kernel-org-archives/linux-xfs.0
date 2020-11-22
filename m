Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D29C5519F
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 07:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF922078E
	for <linux-xfs@archiver.kernel.org>; Sun, 22 Nov 2020 07:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727318AbgKVH0c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 Nov 2020 02:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgKVH0c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 Nov 2020 02:26:32 -0500
X-Greylist: delayed 497 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 21 Nov 2020 23:26:31 PST
Received: from h2n1.swapon.de (h2n1.swapon.de [IPv6:2a01:238:42c8:7b00::21:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED636C0613CF
        for <linux-xfs@vger.kernel.org>; Sat, 21 Nov 2020 23:26:31 -0800 (PST)
Received: from mail.lab.swapon.de (mail.lab.swapon.de [IPv6:2a01:238:42c8:7b40::25:25])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.lab.swapon.de", Issuer "Swapon Root CA" (verified OK))
        by h2n1.swapon.de (Postfix) with ESMTPS id 4Cf1pV52L3zbbmC
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 08:18:10 +0100 (CET)
Received: from defiant.lab.swapon.de (defiant.lab.swapon.de [IPv6:2a01:238:42c8:7b41:56ee:75ff:fe07:e689])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "defiant.lab.swapon.de", Issuer "Swapon Root CA" (verified OK))
        by mail.lab.swapon.de (Postfix) with ESMTPS id C4C60206373
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 08:18:01 +0100 (CET)
Received: from defiant.lab.swapon.de (localhost [IPv6:::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by defiant.lab.swapon.de (Postfix) with ESMTPS id 7ED321044
        for <linux-xfs@vger.kernel.org>; Sun, 22 Nov 2020 08:18:01 +0100 (CET)
Date:   Sun, 22 Nov 2020 08:18:00 +0100
From:   Friedemann Stoyan <fstoyan+xfs@swapon.de>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: Internal error ltrec.rm_startblock > bno since Kernel 5.9.9
Message-ID: <20201122071800.GA13313@defiant.lab.swapon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-message-flag: Please send plain text messages only. Thank you.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

After Upgrading to kernel 5.9.9 I got three crashes at two computers
with the same error:

Nov 22 06:07:54 kernel: XFS (dm-3): Internal error ltrec.rm_startblock > bno || ltrec.rm_startblock + ltrec.rm_blockcount < bno + len at line 575 of file fs/xfs/libxfs/xfs_rmap.c.  Caller xfs_rmap_unmap+0x737/0xab0 [xfs]
Nov 22 06:07:54 kernel: CPU: 1 PID: 4211 Comm: pacman Tainted: G        W         5.9.9-arch1-1 #1
Nov 22 06:07:54 kernel: Hardware name: LENOVO 20F6S0C400/20F6S0C400, BIOS R02ET71W (1.44 ) 05/08/2019
Nov 22 06:07:54 kernel: Call Trace:
Nov 22 06:07:54 kernel:  dump_stack+0x6b/0x83
Nov 22 06:07:54 kernel:  xfs_corruption_error+0x85/0x90 [xfs]
Nov 22 06:07:54 kernel:  ? xfs_rmap_unmap+0x737/0xab0 [xfs]
Nov 22 06:07:54 kernel:  xfs_rmap_unmap+0x767/0xab0 [xfs]
Nov 22 06:07:54 kernel:  ? xfs_rmap_unmap+0x737/0xab0 [xfs]
Nov 22 06:07:54 kernel:  xfs_rmap_finish_one+0x280/0x300 [xfs]
Nov 22 06:07:54 kernel:  xfs_rmap_update_finish_item+0x37/0x60 [xfs]
Nov 22 06:07:54 kernel:  xfs_defer_finish_noroll+0x170/0x4a0 [xfs]
Nov 22 06:07:54 kernel:  xfs_defer_finish+0x11/0x70 [xfs]
Nov 22 06:07:54 kernel:  xfs_itruncate_extents_flags+0xcf/0x2c0 [xfs]
Nov 22 06:07:54 kernel:  xfs_inactive_truncate+0xaf/0xe0 [xfs]
Nov 22 06:07:54 kernel:  xfs_inactive+0xb4/0x140 [xfs]
Nov 22 06:07:54 kernel:  xfs_fs_destroy_inode+0xaa/0x1f0 [xfs]
Nov 22 06:07:54 kernel:  destroy_inode+0x3b/0x70
Nov 22 06:07:54 kernel:  do_unlinkat+0x207/0x310
Nov 22 06:07:54 kernel:  do_syscall_64+0x33/0x40
Nov 22 06:07:54 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 22 06:07:54 kernel: RIP: 0033:0x7f495d7babbb
Nov 22 06:07:54 kernel: Code: f0 ff ff 73 01 c3 48 8b 0d b2 f2 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 f2 0c 00 f7 d8 64 89 01 48
Nov 22 06:07:54 kernel: RSP: 002b:00007fff7832a0b8 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
Nov 22 06:07:54 kernel: RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f495d7babbb
Nov 22 06:07:54 kernel: RDX: 0000000000000003 RSI: 0000000000000004 RDI: 00007fff7832a270
Nov 22 06:07:54 kernel: RBP: 000055e9d8325300 R08: 0000000000000001 R09: 000055e9d83273a0
Nov 22 06:07:54 kernel: R10: 000055e9d691f440 R11: 0000000000000206 R12: 00007fff7832a270
Nov 22 06:07:54 kernel: R13: 0000000000000000 R14: 00007fff7832a150 R15: 000055e9d691f440
Nov 22 06:07:54 kernel: XFS (dm-3): Corruption detected. Unmount and run xfs_repair
Nov 22 06:07:54 kernel: XFS (dm-3): xfs_do_force_shutdown(0x8) called from line 461 of file fs/xfs/libxfs/xfs_defer.c. Return address = 000000004ce3c3c5
Nov 22 06:07:54 kernel: XFS (dm-3): Corruption of in-memory data detected.  Shutting down filesystem
Nov 22 06:07:54 kernel: XFS (dm-3): Please unmount the filesystem and rectify the problem(s)

# cat /proc/version
Linux version 5.9.9-arch1-1 (linux@archlinux) (gcc (GCC) 10.2.0, GNU ld (GNU Binutils) 2.35.1) #1 SMP PREEMPT Wed, 18 Nov 2020 19:52:04 +0000

# xfs_info /usr
meta-data=/dev/mapper/vg0-usr    isize=512    agcount=4, agsize=524288 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1
data     =                       bsize=4096   blocks=2097152, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=3693, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

All crashes occured during system updating with pacman. In all cases the /usr
filesystem was affected.

Regards
Friedemann
