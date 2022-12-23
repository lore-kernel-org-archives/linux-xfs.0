Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4972C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Dec 2022 10:15:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiLWKPx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Dec 2022 05:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLWKPv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Dec 2022 05:15:51 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B7D5FB9
        for <linux-xfs@vger.kernel.org>; Fri, 23 Dec 2022 02:15:49 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id n10-20020a6b590a000000b006e03471b3eeso1749633iob.11
        for <linux-xfs@vger.kernel.org>; Fri, 23 Dec 2022 02:15:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2I6O7Fbax8x8keJYdYuVSgEuRrWH/5GJgLyVKDuCNw=;
        b=WKdpgia8Ux9kQcJnBRI8/tdE79DuBqySrTcfBXZionbVpGiVfbh5Wirbfh510Ls38Z
         k89xvNosDQXxgHQUzxzYuIuZqz5UYVZ8NBWjnKa0pCs+Zcvd9iMywk5xjjO0opBEw9uK
         Hu4yugwp7TFFZfwM15q2z7ObAiMN5SoCjygUQg2H4+YDEZijK0qphVO7a7AyHdF9nZTC
         jzW8gsCdLLY/jxMXElry0XRZVdWUzIhds66KoN2V5SIlkaH7g5nKEjaZrQE67XEIJ0yL
         RbLxJV/L7VI8G6Hs09QEakHg+cZ5/tzkVBORxph02nhACAVvVyPmE7jPQCadQCcWj6Xm
         Qo1A==
X-Gm-Message-State: AFqh2krYhMubPoUp1n3mlRkAFI4UpntVVFYkN3t2EKcDKpXQZBKxZ5yL
        6VvwPBqKxMarWj80GDFkc7Oig49WLf5H4NJYAtP8yOP9gR/p
X-Google-Smtp-Source: AMrXdXv0d6fzFKX45cQwh6OE6o1qey+JnXceCyN46tP5VM49eeZqwmP4btfYpBNWwpxlW6SfM5EAJrVlHX4Kd5Llj46mXnvxBkqc
MIME-Version: 1.0
X-Received: by 2002:a92:3643:0:b0:30b:e56f:f31d with SMTP id
 d3-20020a923643000000b0030be56ff31dmr375923ilf.81.1671790548561; Fri, 23 Dec
 2022 02:15:48 -0800 (PST)
Date:   Fri, 23 Dec 2022 02:15:48 -0800
In-Reply-To: <0000000000001bebd305ee5cd30e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c937f205f07c1100@google.com>
Subject: Re: [syzbot] [xfs?] WARNING in xfs_bmapi_convert_delalloc
From:   syzbot <syzbot+53b443b5c64221ee8bad@syzkaller.appspotmail.com>
To:     chandan.babu@oracle.com, dchinner@redhat.com, djwong@kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    a5541c0811a0 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13463cac480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cbd4e584773e9397
dashboard link: https://syzkaller.appspot.com/bug?extid=53b443b5c64221ee8bad
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=169c10dd880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133e74ff880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4b7702208fb9/disk-a5541c08.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9ec0153ec051/vmlinux-a5541c08.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6f8725ad290a/Image-a5541c08.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/409d4f1e085d/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53b443b5c64221ee8bad@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9 at fs/xfs/libxfs/xfs_bmap.c:4592 xfs_bmapi_convert_delalloc+0x624/0x63c fs/xfs/libxfs/xfs_bmap.c:4592
Modules linked in:
CPU: 1 PID: 9 Comm: kworker/u4:0 Not tainted 6.1.0-rc8-syzkaller-33330-ga5541c0811a0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Workqueue: writeback wb_workfn (flush-7:0)
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : xfs_bmapi_convert_delalloc+0x624/0x63c fs/xfs/libxfs/xfs_bmap.c:4592
lr : xfs_bmapi_convert_delalloc+0x624/0x63c fs/xfs/libxfs/xfs_bmap.c:4592
sp : ffff80000f2a3450
x29: ffff80000f2a3530 x28: 0000000000000000 x27: 0000000000000000
x26: ffff80000f2a34a0 x25: ffffffffffffffff x24: ffff0000cb842000
x23: ffff0000cadcba40 x22: ffff80000f2a3898 x21: ffff0000c79800e8
x20: 0000000000000000 x19: ffff0000cadcba00 x18: 00000000000003cc
x17: 0000000000000000 x16: ffff80000dbe6158 x15: ffff0000c02c8000
x14: 0000000000000000 x13: 00000000ffffffff x12: ffff0000c02c8000
x11: ff80800008dd39a8 x10: 0000000000000000 x9 : ffff800008dd39a8
x8 : ffff0000c02c8000 x7 : ffff800008dacf34 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800008db1b34
x2 : 0000000000000009 x1 : ffffffffffffffff x0 : ffffffffffffffff
Call trace:
 xfs_bmapi_convert_delalloc+0x624/0x63c fs/xfs/libxfs/xfs_bmap.c:4592
 xfs_convert_blocks fs/xfs/xfs_aops.c:259 [inline]
 xfs_map_blocks+0x428/0x5b8 fs/xfs/xfs_aops.c:380
 iomap_writepage_map+0x190/0x8cc fs/iomap/buffered-io.c:1360
 iomap_do_writepage+0x1c0/0x560 fs/iomap/buffered-io.c:1523
 write_cache_pages+0x35c/0x8bc mm/page-writeback.c:2360
 iomap_writepages+0x44/0xec fs/iomap/buffered-io.c:1540
 xfs_vm_writepages+0x94/0xd4 fs/xfs/xfs_aops.c:500
 do_writepages+0x144/0x27c mm/page-writeback.c:2469
 __writeback_single_inode+0x64/0x2e4 fs/fs-writeback.c:1587
 writeback_sb_inodes+0x3e4/0x85c fs/fs-writeback.c:1878
 __writeback_inodes_wb+0x78/0x1c0 fs/fs-writeback.c:1949
 wb_writeback+0x1c8/0x328 fs/fs-writeback.c:2054
 wb_check_background_flush fs/fs-writeback.c:2120 [inline]
 wb_do_writeback+0x2cc/0x384 fs/fs-writeback.c:2208
 wb_workfn+0x70/0x15c fs/fs-writeback.c:2235
 process_one_work+0x2d8/0x504 kernel/workqueue.c:2289
 worker_thread+0x340/0x610 kernel/workqueue.c:2436
 kthread+0x12c/0x158 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:863
irq event stamp: 2056580
hardirqs last  enabled at (2056579): [<ffff80000990e950>] get_random_u32+0x20c/0x294 drivers/char/random.c:510
hardirqs last disabled at (2056580): [<ffff80000c084084>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (2050472): [<ffff8000080102e4>] _stext+0x2e4/0x37c
softirqs last disabled at (2050435): [<ffff800008017c88>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:80
---[ end trace 0000000000000000 ]---
XFS (loop0): page discard on page 000000006c24b16e, inode 0x50b, pos 13840384.
XFS (loop0): page discard on page 00000000c29caf09, inode 0x50b, pos 13844480.

