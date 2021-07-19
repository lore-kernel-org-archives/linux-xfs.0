Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F475C07E95
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 18:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 092F760FF3
	for <linux-xfs@archiver.kernel.org>; Mon, 19 Jul 2021 18:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356276AbhGSRV7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 13:21:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378416AbhGSRTl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Jul 2021 13:19:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D47060FF3;
        Mon, 19 Jul 2021 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626717615;
        bh=GOemBb60P46R2fzvNqs0m4wTD99o9GXNfGeZ54nysF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GjhuNr5+LZucPyJMJURGieaKEvI5lq2OacSJwoVj+EPgwLiWiNcnsE/uwNN2vlUWB
         YD2QDVIfRSetiHQt2L2YoGYMe4BLT+ZvuzLjLiP26JC1Rl/CNktvs2deRcOh1QQbGn
         9Q/DYFNS51HZCFpS7LNGLzh2y3pWNGyx2TsLk2d5wH0XoSJQ4l/5C3gnZL7HyGbQHO
         2SXHd/8NtbSlq1O/HhIu52Q7POWLah2oOzB6TE3j+XK/j/RVVRwHWsiHi1wBA2gScT
         fKhisWJ+iBJoK2A0oQWl+VS3uZ24fQxkr2N+52l3XTjhK0rBkDXhTMs6GXPy2PgqBq
         bGzGNyZM9X2mw==
Date:   Mon, 19 Jul 2021 11:00:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: xfs/319 vs 1k block size file systems
Message-ID: <20210719180015.GH22402@magnolia>
References: <YPVSBie+Bk5FAngH@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YPVSBie+Bk5FAngH@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 19, 2021 at 12:20:54PM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> xfs/319 keeps crashing for me when running it for a 1k block size
> file systems on x86 with debugging enabled.  The problem is that
> xfs_bmapi_remap is called on a range that is not a hole.

Hmm.  Dave sent me a warning late last night about some sort of log
recovery problem in -rc2 due to FUA changes or something.  Did this
happen in -rc1?

--D

> The (slightly garbled) dmesg is below:
> 
> xfs/319 files ... [   46.469049] run fstests xfs/319 at 2021-07-19 10:17:12
> [   52.470572] XFS (vdc): Mounting V5 Filesystem
> [   52.478587] XFS (vdc): Ending clean mount
> [   52.482375] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7ff)
> [   52.511583] XFS (vdc): Unmounting Filesystem
> [   53.901990] XFS (vdc): Mounting V5 Filesystem
> [   53.912316] XFS (vdc): Ending clean mount
> [   53.915388] xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7ff)
> [   54.067688] XFS (vdc): Injecting error (false) at file fs/xfs/libxfs/xfs_bmap.c, line 6256, on"
> [   54.070661] XFS (vdc): Corruption of in-memory data (0x8) detected at xfs_defer_finish_noroll+m
> [   54.072637] XFS (vdc): Please unmount the filesystem and rectify the problem(s)
> [   54.094779] XFS (vdc): Unmounting Filesystem
> [   54.334642] XFS (vdc): Mounting V5 Filesystem
> [   54.344167] XFS (vdc): Starting recovery (logdev: internal)
> [   54.351700] XFS: Assertion failed: got.br_startoff > bno, file: fs/xfs/libxfs/xfs_bmap.c, line5
> [   54.353014] ------------[ cut here ]------------
> [   54.353876] kernel BUG at fs/xfs/xfs_message.c:110!
> [   54.354655] invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [   54.355335] CPU: 2 PID: 4644 Comm: mount Not tainted 5.14.0-rc2+ #19
> [   54.356198] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
> [   54.357311] RIP: 0010:assfail+0x1e/0x23
> [   54.357831] Code: b8 2b 07 83 e8 85 fc ff ff 0f 0b c3 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 b8 24
> [   54.360251] RSP: 0018:ffffc9000168fb58 EFLAGS: 00010202
> [   54.360934] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [   54.361973] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff82fdbcf9
> [   54.362888] RBP: ffffc9000168fbf0 R08: 0000000000000000 R09: 000000000000000a
> [   54.363817] R10: 000000000000000a R11: f000000000000000 R12: ffff888112ba8240
> [   54.364736] R13: ffff888112a4c000 R14: 0000000000000000 R15: ffff888114dc9948
> [   54.365655] FS:  00007f65e38a7100(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> [   54.366693] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   54.367452] CR2: 00007ffc6c1d9ff8 CR3: 0000000116668000 CR4: 00000000000006e0
> [   54.368352] Call Trace:
> [   54.368658]  xfs_bmapi_remap+0x3bf/0x3f0
> [   54.369143]  xfs_bmap_finish_one+0x186/0x260
> [   54.369666]  xfs_bui_item_recover+0x266/0x370
> [   54.370200]  ? lock_release+0x13c/0x2e0
> [   54.370667]  xlog_recover_process_intents+0xd0/0x400
> [   54.371276]  xlog_recover_finish+0x14/0xc0
> [   54.371837]  xfs_log_mount_finish+0x54/0x1b0
> [   54.372503]  xfs_mountfs+0x580/0x9b0
> [   54.373008]  xfs_fs_fill_super+0x3aa/0x7e0
> [   54.373535]  ? xfs_fs_put_super+0x90/0x90
> [   54.374118]  get_tree_bdev+0x17a/0x280
> [   54.374645]  vfs_get_tree+0x23/0xc0
> [   54.375089]  path_mount+0x2b1/0xb40
> [   54.375542]  __x64_sys_mount+0xfe/0x140
> [   54.376028]  do_syscall_64+0x3b/0x90
> [   54.376482]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   54.377118] RIP: 0033:0x7f65e3aa5fea
> [   54.377575] Code: 48 8b 0d a9 0e 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 08
> [   54.379859] RSP: 002b:00007ffc6c1db238 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> [   54.380777] RAX: ffffffffffffffda RBX: 000055a56b0df970 RCX: 00007f65e3aa5fea
> [   54.381642] RDX: 000055a56b0dfb80 RSI: 000055a56b0dfbc0 RDI: 000055a56b0dfba0
> [   54.382503] RBP: 00007f65e3df31c4 R08: 0000000000000000 R09: 000055a56b0e2890
> [   54.383378] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> [   54.384254] R13: 0000000000000000 R14: 000055a56b0dfba0 R15: 000055a56b0dfb80
> [   54.385068] Modules linked in:
> [   54.385495] ---[ end trace 81c36780b0c4c649 ]---
> [   54.386033] RIP: 0010:assfail+0x1e/0x23
> [   54.386500] Code: b8 2b 07 83 e8 85 fc ff ff 0f 0b c3 41 89 c8 48 89 d1 48
> 89 f2 48 c7 c6 b8 24
> [   54.388948] RSP: 0018:ffffc9000168fb58 EFLAGS: 00010202
> [   54.389674] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [   54.390612] RDX: 00000000ffffffc0 RSI: 0000000000000000 RDI: ffffffff82fdbcf9
> [   54.391534] RBP: ffffc9000168fbf0 R08: 0000000000000000 R09: 000000000000000a
> [   54.392494] R10: 000000000000000a R11: f000000000000000 R12: ffff888112ba8240
> [   54.393400] R13: ffff888112a4c000 R14: 0000000000000000 R15: ffff888114dc9948
> [   54.394400] FS:  00007f65e38a7100(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
> [   54.395763] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   54.396425] CR2: 00007ffc6c1d9ff8 CR3: 0000000116668000 CR4: 00000000000006e0
> [   54.397302] Kernel panic - not syncing: Fatal exception
> [   54.398143] Kernel Offset: disabled
> [   54.398660] ---[ end Kernel panic - not syncing: Fatal exception ]---
