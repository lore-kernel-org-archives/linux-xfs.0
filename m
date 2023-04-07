Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7818DC77B61
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Apr 2023 17:05:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjDGRE7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Apr 2023 13:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbjDGRE6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Apr 2023 13:04:58 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50FCBBB5
        for <linux-xfs@vger.kernel.org>; Fri,  7 Apr 2023 10:04:50 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id d5-20020a923605000000b003232594207dso28121215ila.8
        for <linux-xfs@vger.kernel.org>; Fri, 07 Apr 2023 10:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680887089; x=1683479089;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TnUl47z21Nij35fj9d1jh5EYMecekHF/0+bl/JRlgg=;
        b=Xh/fOydEyZecvJZIK6ikGwAANGTVRIw7Kgtyx9t+4R3rmVd5ivT0V0Vk1hkpilwfea
         Liv5mhs8GB0oLpOI5KlI0+f5IJKbtSG1ZObN9cOtRePDE62b8hKeIuoKYXg9LTfFkuad
         x7kvmsBRClbk6/j2P//OwTk/kgIk3/cHVgWjkicLcetw/YywYauuboIGu3fjLKRV3+Wm
         jwodRjg+Hz0wcDFHOM/51uUf95VkOBE8OgWGr3q/2emnORSuVKihD0AjYnMJ6OSPIbhB
         8eTnOi9yhiKetImlO8n/dDDplM4KfhDhEA0+XgFxzTshAyDZkp7E1YaxDGZPkwHFDzSU
         vhOw==
X-Gm-Message-State: AAQBX9dCe0pAhf3aEazaNWwdfsZovTQiQLR3dgshDLvj9TC+Je8/b4qY
        w1SSZze2iHXrTlIpzYG5g5xnfzHReS6TRoSvI+Epxozdhrit
X-Google-Smtp-Source: AKy350biinDzzhkhVthNzHEgvyUE51wzgBH//6QJSL+3xEpJXEcKQzJ99r6k94HByXhCpL3u0tpGJC9mbMQJUFPotUKTtGn8XkeH
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a61:b0:326:3f06:a0d7 with SMTP id
 w1-20020a056e021a6100b003263f06a0d7mr1616499ilv.0.1680887089848; Fri, 07 Apr
 2023 10:04:49 -0700 (PDT)
Date:   Fri, 07 Apr 2023 10:04:49 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e5f10505f8c205bc@google.com>
Subject: [syzbot] [xfs?] WARNING in __queue_delayed_work
From:   syzbot <syzbot+5ed016962f5137a09c7c@syzkaller.appspotmail.com>
To:     djwong@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7e364e56293b Linux 6.3-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13241195c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e3b9dc6616d797bb
dashboard link: https://syzkaller.appspot.com/bug?extid=5ed016962f5137a09c7c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ed016962f5137a09c7c@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 102 at kernel/workqueue.c:1445 __queue_work+0xd44/0x1120 kernel/workqueue.c:1444
Modules linked in:
CPU: 1 PID: 102 Comm: kswapd0 Not tainted 6.3.0-rc5-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
RIP: 0010:__queue_work+0xd44/0x1120 kernel/workqueue.c:1444
Code: e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8 74 0c 81 00 8b 5b 2c 31 ff 83 e3 20 89 de e8 c5 fb 2f 00 85 db 75 42 e8 6c ff 2f 00 <0f> 0b e9 3c f9 ff ff e8 60 ff 2f 00 0f 0b e9 ce f8 ff ff e8 54 ff
RSP: 0000:ffffc90000ce7638 EFLAGS: 00010093
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888015f73a80 RSI: ffffffff8152d854 RDI: 0000000000000005
RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffe8ffffb03348
R13: ffff888078462000 R14: ffffe8ffffb03390 R15: ffff888078462000
FS:  0000000000000000(0000) GS:ffff88802ca80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000cfa5bb CR3: 0000000025fde000 CR4: 0000000000150ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __queue_delayed_work+0x1c8/0x270 kernel/workqueue.c:1672
 mod_delayed_work_on+0xe1/0x220 kernel/workqueue.c:1746
 xfs_inodegc_shrinker_scan fs/xfs/xfs_icache.c:2212 [inline]
 xfs_inodegc_shrinker_scan+0x250/0x4f0 fs/xfs/xfs_icache.c:2191
 do_shrink_slab+0x428/0xaa0 mm/vmscan.c:853
 shrink_slab+0x175/0x660 mm/vmscan.c:1013
 shrink_one+0x502/0x810 mm/vmscan.c:5343
 shrink_many mm/vmscan.c:5394 [inline]
 lru_gen_shrink_node mm/vmscan.c:5511 [inline]
 shrink_node+0x2064/0x35f0 mm/vmscan.c:6459
 kswapd_shrink_node mm/vmscan.c:7262 [inline]
 balance_pgdat+0xa02/0x1ac0 mm/vmscan.c:7452
 kswapd+0x677/0xd60 mm/vmscan.c:7712
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
