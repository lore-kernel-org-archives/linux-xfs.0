Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7A8C07E95
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 21:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 115F56128C
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Jul 2021 21:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhGMVYU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:24:20 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:49027 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbhGMVYU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 17:24:20 -0400
Received: by mail-io1-f70.google.com with SMTP id f2-20020a6b62020000b02905094eaa65fdso15552916iog.15
        for <linux-xfs@vger.kernel.org>; Tue, 13 Jul 2021 14:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ctUZDxscRnndzpGH2QsdyHbqI2iOuV+I7hKSyzYBZzg=;
        b=LxnfcpTNV0x9CbNl8JbQjcvFEzalGNisRIxzoypitqfNR5h/yWs4POGjp0hVOIfw6H
         Z6REejk+1U9pOP1CeVYGW2bn3sD5XRN2CY6hXSvpGe/fk+8sHrIiemA/lsO4D66sHLiM
         QqsN+3EijLZyNWvYmg8ZLnnGgBiqQBGhonuGKMskjXfS/sFE72Bl2v7jSM3h3akRwScQ
         S721mwNv/gh5CAsmHguRWEut51NqCCEA+285xsKTPtzYTbKo67D51Yub5r27/E3Rc+eV
         ZvxaVv84rMdRKuoUwN5IvXEawohGDYA5IB57Hs0DQzKlBbcbcjkqbTYOqThhbDgk1FF7
         xAvg==
X-Gm-Message-State: AOAM532GkRVlyKT5RHtNDb5MSUBMtE/q5yeQEpDj0S2JIbfggWyKf9zB
        YGMxadv/sXwBjEtk3GVjL+RLyTji04hYtFnk1QHztRra3lna
X-Google-Smtp-Source: ABdhPJwRzw/yhTammAmdVfQ9FxPSsREVIOOfv//GCnLfmbDTQdD3pdztoLMz1wtBoBseoa35r0nINGd3PXgjDLRX1nGR5VawSOk+
MIME-Version: 1.0
X-Received: by 2002:a92:cf03:: with SMTP id c3mr4387883ilo.195.1626211289982;
 Tue, 13 Jul 2021 14:21:29 -0700 (PDT)
Date:   Tue, 13 Jul 2021 14:21:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044ed0305c707d219@google.com>
Subject: [syzbot] WARNING in iomap_page_release
From:   syzbot <syzbot+5ea720fb6b767fbcab6d@syzkaller.appspotmail.com>
To:     djwong@kernel.org, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    92510a7f Add linux-next specific files for 20210709
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14fa5bc4300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=505de2716f052686
dashboard link: https://syzkaller.appspot.com/bug?extid=5ea720fb6b767fbcab6d

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ea720fb6b767fbcab6d@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8462 at fs/iomap/buffered-io.c:77 iomap_page_release+0x687/0x790 fs/iomap/buffered-io.c:77
Modules linked in:
CPU: 1 PID: 8462 Comm: syz-executor.1 Tainted: G        W         5.13.0-next-20210709-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:iomap_page_release+0x687/0x790 fs/iomap/buffered-io.c:77
Code: 4f 8d 8a ff 49 8d 6d ff e9 1b fe ff ff e8 41 8d 8a ff 0f 0b e9 71 fe ff ff e8 35 8d 8a ff 0f 0b e9 97 fd ff ff e8 29 8d 8a ff <0f> 0b e9 32 fd ff ff 4c 89 ef e8 3a 9a d0 ff e9 96 f9 ff ff 48 89
RSP: 0018:ffffc9000169f830 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000001000 RCX: 0000000000000000
RDX: ffff8880265f8000 RSI: ffffffff81eb0f77 RDI: 0000000000000003
RBP: ffffea0001380bc0 R08: 0000000000000000 R09: ffff88808995165b
R10: ffffffff81eb0ca7 R11: 000000000000003f R12: ffff888089951658
R13: ffffea0001380bc8 R14: 000000000000000c R15: 0000000000000031
FS:  00000000027d1400(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000544038 CR3: 00000000702a5000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 iomap_invalidatepage fs/iomap/buffered-io.c:489 [inline]
 iomap_invalidatepage+0x46d/0x670 fs/iomap/buffered-io.c:478
 do_invalidatepage mm/truncate.c:167 [inline]
 truncate_cleanup_page+0x393/0x560 mm/truncate.c:186
 truncate_inode_pages_range+0x26c/0x1030 mm/truncate.c:335
 gfs2_evict_inode+0x1e1/0x1ff0 fs/gfs2/super.c:1467
 evict+0x2ed/0x6b0 fs/inode.c:590
 iput_final fs/inode.c:1670 [inline]
 iput.part.0+0x539/0x850 fs/inode.c:1696
 iput+0x58/0x70 fs/inode.c:1686
 gfs2_put_super+0x29a/0x650 fs/gfs2/super.c:668
 generic_shutdown_super+0x14c/0x370 fs/super.c:465
 kill_block_super+0x97/0xf0 fs/super.c:1395
 gfs2_kill_sb+0x104/0x160 fs/gfs2/ops_fstype.c:1682
 deactivate_locked_super+0x94/0x160 fs/super.c:335
 deactivate_super+0xad/0xd0 fs/super.c:366
 cleanup_mnt+0x3a2/0x540 fs/namespace.c:1136
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:209
 __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x467a37
Code: ff d0 48 89 c7 b8 3c 00 00 00 0f 05 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeb202ad98 EFLAGS: 00000246
 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000467a37
RDX: 00007ffeb202ae6b RSI: 0000000000000002 RDI: 00007ffeb202ae60
RBP: 00007ffeb202ae60 R08: 00000000ffffffff R09: 00007ffeb202ac30
R10: 00000000027d28e3 R11: 0000000000000246 R12: 00000000004bee70
R13: 00007ffeb202bf30 R14: 00000000027d2810 R15: 00007ffeb202bf70


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
