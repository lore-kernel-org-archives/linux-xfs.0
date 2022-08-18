Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A8E1C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 19:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345497AbiHRTJM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 15:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245578AbiHRTJK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 15:09:10 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB89AC00E1
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 12:09:08 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id d6-20020a056e020c0600b002deca741bc2so1696430ile.18
        for <linux-xfs@vger.kernel.org>; Thu, 18 Aug 2022 12:09:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=QUXH+lX3oULeMPlpniIOe/Q0nv+D1dRLUrR/j75zlr0=;
        b=PBBgQPCgshFuLGkdoVvypbyph4vctfMcZ5HJqYJ5kdJgte9GsCkyToYS7/G8Y+Qzsn
         KirRV0tTLs3enStyHGHft/KLjqmXQhGWsxPrD3bfKaTrYfpZbZ7X+MeJB6FNOQj7x5Gd
         Ym6slyxrX/g0Tuf7UKpKWKtwsOVh6u7DQrDF5BzBbjxdrAVQdW+eSwHOert00INuqtOI
         BsMjVIba/C6nUbuMJUX4ykm5zBDBEVPYgk9kjz9sFW9eIJbM7XcIZv8aKrvOHlHnDD+n
         Ig1ux342J6oE1/YoQJK5xLdlToIBU8J+KqDnK+Q2/m9n9siWMIhyPrksWNgwZeU8gvNx
         3mCA==
X-Gm-Message-State: ACgBeo1l4pQvJxhjQHpSQCyolwv2CtlJBzlLC7lkea04dOzJm3s3d+ec
        +WoLkQM8OsTnt+WItcAqsZHvFtn+1/GtVA8yUMBjw67R2Yw8
X-Google-Smtp-Source: AA6agR4hMKwNK0pL6It4a5YyUKx1x4WqiZ9bx8NxTz4LJ0szJel9fneotzoL5nhB0WbZSCxk5N6zlIv8dT3pDiXpeJaforTVk0N8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:14ce:b0:2e5:3548:aaaf with SMTP id
 o14-20020a056e0214ce00b002e53548aaafmr1965344ilk.192.1660849748264; Thu, 18
 Aug 2022 12:09:08 -0700 (PDT)
Date:   Thu, 18 Aug 2022 12:09:08 -0700
In-Reply-To: <20220818110031.89467-1-code@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045503f05e688b7b0@google.com>
Subject: Re: [syzbot] WARNING in iomap_iter
From:   syzbot <syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com>
To:     code@siddh.me, david@fromorbit.com, djwong@kernel.org,
        fgheet255t@gmail.com, hch@infradead.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        riteshh@linux.ibm.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in iomap_iter

------------[ cut here ]------------
WARNING: CPU: 1 PID: 11 at fs/iomap/iter.c:33 iomap_iter_done fs/iomap/iter.c:33 [inline]
WARNING: CPU: 1 PID: 11 at fs/iomap/iter.c:33 iomap_iter+0xd8c/0x1100 fs/iomap/iter.c:78
Modules linked in:
CPU: 1 PID: 11 Comm: kworker/u4:1 Not tainted 6.0.0-rc1-syzkaller-00067-g573ae4f13f63-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
Workqueue: loop3 loop_workfn
RIP: 0010:iomap_iter_done fs/iomap/iter.c:33 [inline]
RIP: 0010:iomap_iter+0xd8c/0x1100 fs/iomap/iter.c:78
Code: ff e8 28 60 87 ff 0f 0b e9 f1 f9 ff ff e8 1c 60 87 ff 0f 0b e9 86 f7 ff ff e8 10 60 87 ff 0f 0b e9 5e f7 ff ff e8 04 60 87 ff <0f> 0b e9 1a f7 ff ff e8 f8 5f 87 ff e8 73 b4 8a 07 31 ff 89 c5 89
RSP: 0018:ffffc90000107668 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90000107800 RCX: 0000000000000000
RDX: ffff888011a9bb00 RSI: ffffffff81f4ab4c RDI: 0000000000000006
RBP: 0000000000000000 R08: 0000000000000006 R09: 0000000000000000
R10: d70e000000000000 R11: 0000000000000004 R12: 0000000000000000
R13: d70e000000000000 R14: ffffc90000107828 R15: ffffc90000107870
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fae015980a0 CR3: 000000007f2cd000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 __iomap_dio_rw+0x6c6/0x1c20 fs/iomap/direct-io.c:601
 iomap_dio_rw+0x3c/0xa0 fs/iomap/direct-io.c:690
 ext4_dio_read_iter fs/ext4/file.c:79 [inline]
 ext4_file_read_iter+0x434/0x600 fs/ext4/file.c:130
 call_read_iter include/linux/fs.h:2181 [inline]
 lo_rw_aio.isra.0+0xa54/0xc50 drivers/block/loop.c:454
 do_req_filebacked drivers/block/loop.c:498 [inline]
 loop_handle_cmd drivers/block/loop.c:1859 [inline]
 loop_process_work+0x969/0x2050 drivers/block/loop.c:1894
 process_one_work+0x991/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


Tested on:

commit:         573ae4f1 tee: add overflow check in register_shm_helpe..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=11c4af0d080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9d854f607a68b32
dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13ba8e5b080000

