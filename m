Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D83C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Nov 2022 08:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiK2IeB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Nov 2022 03:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiK2IdZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Nov 2022 03:33:25 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282E813EB9
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 00:32:42 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id a14-20020a6b660e000000b006bd37975cdfso8058271ioc.10
        for <linux-xfs@vger.kernel.org>; Tue, 29 Nov 2022 00:32:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pjeud7OJ5rD9pAK27EgfRmQGvpYhI3NAeK4kPtLlh0Q=;
        b=essn3eIhEBGnDWkc+0fqkCRh027rGTDs1QVeXUYmiXw/yeIkHlUV8qylUPQ9ob43rs
         lDIEAUxkf4yvLTLD1OazTrciF7wnA1t4lUgUBzSTO32OuM+XW08nBSsWuoJGdA7XjkS9
         q37BOn79B1/Tv003YtREacOwhR430jr2ZXavMCT3lac78qdvCeNgMBauzgcDvLpwrVEW
         7RzVZ3LzOLW5Jz80htkZt5b3UOTo5R/iGJtPdgK8OleMa9qLpFODLh1auBaXXye7NPix
         1A1IhfTVuuRzcbXjJy5NTkdk/GpxOIWbJNt2TVETMS3s2vqi+KMY/09LZ49Vmoz27HlW
         7RUg==
X-Gm-Message-State: ANoB5pkyFD430L9O/5ZrEixXWzV1s0iivthziaofCUYWFGxXc8wwY7fN
        51m4ueJf1oHtK3AflDrAa0nXTOsrcfQldzN1v7rWgToVqszr
X-Google-Smtp-Source: AA0mqf7pqR2OQxydUqXFg1qCdfmm8sE5uTDEu0Gl8HjCO9lAu9/PjodLdzyMuwBXyKB63hyBEsWOS6yFsTY1VIEI/VCv5QUhNStU
MIME-Version: 1.0
X-Received: by 2002:a02:602f:0:b0:375:3f24:b8b7 with SMTP id
 i47-20020a02602f000000b003753f24b8b7mr27583436jac.298.1669710761516; Tue, 29
 Nov 2022 00:32:41 -0800 (PST)
Date:   Tue, 29 Nov 2022 00:32:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d1663705ee97d4d7@google.com>
Subject: [syzbot] WARNING in iomap_read_inline_data
From:   syzbot <syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com>
To:     djwong@kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    6d464646530f Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=121e694b880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=54b747d981acc7b7
dashboard link: https://syzkaller.appspot.com/bug?extid=7bb81dfa9cda07d9cd9d
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=105c8fed880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170fa303880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d75f5f77b3a3/disk-6d464646.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9382f86e4d95/vmlinux-6d464646.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cf2b5f0d51dd/Image-6d464646.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/eb9ce7b05830/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7bb81dfa9cda07d9cd9d@syzkaller.appspotmail.com

gfs2: fsid=syz:syz.0: first mount done, others may mount
------------[ cut here ]------------
WARNING: CPU: 1 PID: 3072 at fs/iomap/buffered-io.c:226 iomap_read_inline_data+0x274/0x440 fs/iomap/buffered-io.c:226
Modules linked in:
CPU: 1 PID: 3072 Comm: syz-executor694 Not tainted 6.1.0-rc6-syzkaller-32662-g6d464646530f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : iomap_read_inline_data+0x274/0x440 fs/iomap/buffered-io.c:226
lr : iomap_read_inline_data+0x274/0x440 fs/iomap/buffered-io.c:226
sp : ffff80000fb9b5a0
x29: ffff80000fb9b5a0 x28: 0000000000000000 x27: 0000000000000000
x26: 0000000000000000 x25: ffff80000fb9b6e0 x24: ffff80000fb9b6b8
x23: ffffffc000000f40 x22: 00000040000000c0 x21: 0000000000001000
x20: ffff80000fb9b6b8 x19: fffffc0003390a40 x18: fffffffffffffff5
x17: ffff80000c0cd83c x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000002 x12: ffff80000d6227e0
x11: ff808000086c12c4 x10: 0000000000000000 x9 : ffff8000086c12c4
x8 : ffff0000c6f13480 x7 : ffff80000845ec00 x6 : 0000000000000000
x5 : ffff0000c6f13480 x4 : 0000000000000000 x3 : 0000000000000002
x2 : 0000000000000000 x1 : 00000040000000c0 x0 : 0000000000001000
Call trace:
 iomap_read_inline_data+0x274/0x440 fs/iomap/buffered-io.c:226
 iomap_readpage_iter+0xdc/0x7dc fs/iomap/buffered-io.c:269
 iomap_read_folio+0x114/0x364 fs/iomap/buffered-io.c:343
 gfs2_read_folio+0x54/0x130 fs/gfs2/aops.c:456
 filemap_read_folio+0xc4/0x468 mm/filemap.c:2407
 do_read_cache_folio+0x1c8/0x588 mm/filemap.c:3534
 do_read_cache_page mm/filemap.c:3576 [inline]
 read_cache_page+0x40/0x174 mm/filemap.c:3585
 gfs2_internal_read+0x90/0x304 fs/gfs2/aops.c:494
 read_rindex_entry fs/gfs2/rgrp.c:906 [inline]
 gfs2_ri_update+0xb4/0x7e4 fs/gfs2/rgrp.c:1001
 gfs2_rindex_update+0x1b0/0x21c fs/gfs2/rgrp.c:1051
 init_inodes+0x11c/0x184 fs/gfs2/ops_fstype.c:917
 gfs2_fill_super+0x630/0x874 fs/gfs2/ops_fstype.c:1247
 get_tree_bdev+0x1e8/0x2a0 fs/super.c:1324
 gfs2_get_tree+0x30/0xc0 fs/gfs2/ops_fstype.c:1330
 vfs_get_tree+0x40/0x140 fs/super.c:1531
 do_new_mount+0x1dc/0x4e4 fs/namespace.c:3040
 path_mount+0x358/0x890 fs/namespace.c:3370
 do_mount fs/namespace.c:3383 [inline]
 __do_sys_mount fs/namespace.c:3591 [inline]
 __se_sys_mount fs/namespace.c:3568 [inline]
 __arm64_sys_mount+0x2c4/0x3c4 fs/namespace.c:3568
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:584
irq event stamp: 104804
hardirqs last  enabled at (104803): [<ffff80000c090604>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (104803): [<ffff80000c090604>] _raw_spin_unlock_irq+0x3c/0x70 kernel/locking/spinlock.c:202
hardirqs last disabled at (104804): [<ffff80000c07d8b4>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:405
softirqs last  enabled at (104756): [<ffff800009270a7c>] local_bh_enable+0x10/0x34 include/linux/bottom_half.h:32
softirqs last disabled at (104754): [<ffff800009270a48>] local_bh_disable+0x10/0x34 include/linux/bottom_half.h:19
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
