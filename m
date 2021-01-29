Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69812C433DB
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 21:21:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F173664E06
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 21:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhA2VVk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 29 Jan 2021 16:21:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbhA2VVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Jan 2021 16:21:33 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393B3C061574
        for <linux-xfs@vger.kernel.org>; Fri, 29 Jan 2021 13:20:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=IkAETo6jLAfJV7V4JpoA3d74tamrOvBzSKGQCWTOsiI=; b=a8z6AcGL8s3BgPJRDRwTqxhgcq
        RRmWTD51SmBz5iS7HXJTEyYlqvloqhLpGcARwdn356NG69jAPt6hproGT2F0Z/iPvAeyX6+9SAb31
        DWOfkHFqOkdMP4eMvLZIUqaRI997ctUqvCS3yvxksCpf74CdTQmKpydV40rQPtP+x7/PQMrwt97lC
        VJE33sVjsZWVTvYw1Fj9SvHsf7V1S4sWFtS4ctz1C07edo88wV4PLNFEpofA0Udrwebn6/ptirLU5
        EXTsbDNdeiie/ignHwbWHiIEqW5kTFjA/v2UXLxFOmBwWttpTUu7zIo4c4tGBwIKkuOWcLGQYW5wD
        vz+glTmg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l5bCC-00ALjq-9T
        for linux-xfs@vger.kernel.org; Fri, 29 Jan 2021 21:20:49 +0000
Date:   Fri, 29 Jan 2021 21:20:48 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-xfs@vger.kernel.org
Subject: freeing a non-slab pointer
Message-ID: <20210129212048.GC308988@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I'm trying to bisect a different problem in today's linux-next and
hit this which i think i've hit before during generic/019.

I believe this is a double-free which we hit during an unmount after
an error.

------------[ cut here ]------------
kernel BUG at mm/slub.c:4118!
invalid opcode: 0000 [#1] SMP NOPTI
CPU: 5 PID: 7745 Comm: umount Kdump: loaded Tainted: G        W         5.11.0-rc5-03555-g7b7f6e418b71 #99
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
RIP: 0010:kfree+0x35a/0x410
Code: 00 00 49 8b 04 24 45 31 ed a9 00 00 01 00 74 06 45 0f b6 6c 24 51 49 8b 04 24 a9 00 00 01 00 75 0b 49 8b 44 24 08 a8 01 75 02 <0f> 0b 44 89 e9 48 c7 c2 00 f0 ff ff be 06 00 00 00 48 d3 e2 48 c7
RSP: 0018:ffff888017dfbca0 EFLAGS: 00010246
RAX: ffffea0000244c88 RBX: ffff888033668800 RCX: 00000000000008c1
RDX: 0000000000000000 RSI: ffffffff811640b5 RDI: ffff888033668800
RBP: ffff888017dfbcd0 R08: ffffffff8136853c R09: ffffffff81367b00
R10: ffff88800adeb080 R11: 0000000000000001 R12: ffffea0000cd9a00
R13: 0000000000000000 R14: ffff88800833b4a0 R15: 0000000000000000
FS:  00007fb4abfad080(0000) GS:ffff88807d940000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558873d0a7e8 CR3: 00000000089c0001 CR4: 0000000000770ea0
PKRU: 55555554
Call Trace:
 kvfree+0x25/0x30
 xfs_buf_free+0x105/0x170
 xfs_buf_rele+0x1fa/0x490
 xfs_buftarg_drain+0xaf/0x1a0
 xfs_log_unmount+0x25/0x70
 xfs_unmountfs+0xbd/0x150
 xfs_fs_put_super+0x35/0xa0
 generic_shutdown_super+0x65/0x100
 kill_block_super+0x22/0x50
 deactivate_locked_super+0x2b/0x90
 deactivate_super+0x3b/0x50
 cleanup_mnt+0x130/0x190
 __cleanup_mnt+0xd/0x10
 task_work_run+0x5e/0x90
 exit_to_user_mode_loop+0xe0/0xf0
 syscall_exit_to_user_mode+0x67/0x80
 do_syscall_64+0x3f/0x50
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7fb4ac3d3507
Code: 19 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 59 19 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffe30d27798 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000558873d04970 RCX: 00007fb4ac3d3507
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000558873d08a50
RBP: 0000000000000000 R08: 0000558873d089c0 R09: 00007fb4ac454e80
R10: 0000000000000000 R11: 0000000000000246 R12: 0000558873d08a50
R13: 00007fb4ac4f91c4 R14: 0000558873d04a68 R15: 0000558873d04b80


some of the previous errors:

xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7
fffffff)
XFS (sdc): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
sdc: writeback error on inode 16797734, offset 6889472, sector 14837598
sdc: writeback error on inode 8388674, offset 4116480, sector 14631950
sdc: writeback error on inode 8388674, offset 5459968, sector 12889094
XFS (sdc): log I/O error -5
XFS (sdc): xfs_do_force_shutdown(0x2) called from line 1273 of file fs/xfs/xfs_l
og.c. Return address = ffffffff8139233f
XFS (sdc): Log I/O Error Detected. Shutting down filesystem
XFS (sdc): Please unmount the filesystem and rectify the problem(s)
XFS (sdc): log I/O error -5
XFS (sdc): log I/O error -5
XFS (sdc): log I/O error -5
XFS (sdc): log I/O error -5
XFS (sdc): log I/O error -5
XFS (sdc): log I/O error -5
XFS (sdc): log I/O error -5

