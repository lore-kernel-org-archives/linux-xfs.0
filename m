Return-Path: <SRS0=RLxe=2J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F22C43603
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 15:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4877021D7D
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Dec 2019 15:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfLSPPM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Dec 2019 10:15:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:50867 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfLSPPL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Dec 2019 10:15:11 -0500
Received: by mail-il1-f197.google.com with SMTP id z12so4819801ilh.17
        for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2019 07:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VjstBJC/J7dIYqK7+U4bFc27tLQDjJ0UFLhGs3+2y08=;
        b=H5yZRvJ3H098agtz/wLYhXgP0mMh4Qpwz372rYL0bOP7BaMhQ6peQ4NdVtnbzUiy0O
         JpaNmjydmnvZaicJB9PWETkDoUGq3sqacfFv3HlOdO8v3xaifxlyPanlN2dLjK8dGW/f
         2grce3/fLMdTn9S7d58l8Wt/fWfoHMxzgXM+UKhzwen4waDqg53zmMaTH0zbi6DNL54m
         n3Mn1wHH1SwmILpAOmiYOoxN6LO2Q175rF7yZvdoevgP9wKAg0D2DYTKaLT2sVik2WHg
         tnNnc1D9Ur9kMtjxPt4dz4NvmvSrbEgKIXxMggbaoOnsKQ3WtkQRrr2HQsQOqR/jgIR7
         Hjfw==
X-Gm-Message-State: APjAAAX/RyzqsHAVhd4jyk1HvvwnJSvP0VY95qPAt9la7c0pVppNYq3f
        jschg2XfnoQshf3AVfRgg6oZ1DjQNAKNfDrE1UyDJE1wikn4
X-Google-Smtp-Source: APXvYqwynkGgK81TYmuCv4AYKxZFQshQr/rGLliweNYYSpYa56ie3B7daOP5Ncmx3XBGWlyFmVrPq9UiTjr6wM851PQKomtZFwmH
MIME-Version: 1.0
X-Received: by 2002:a6b:bbc4:: with SMTP id l187mr6252569iof.234.1576768508627;
 Thu, 19 Dec 2019 07:15:08 -0800 (PST)
Date:   Thu, 19 Dec 2019 07:15:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d99340059a100686@google.com>
Subject: BUG: unable to handle kernel paging request in xfs_sb_quiet_read_verify
From:   syzbot <syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, allison.henderson@oracle.com,
        aryabinin@virtuozzo.com, bfoster@redhat.com,
        darrick.wong@oracle.com, dchinner@redhat.com, dja@axtens.net,
        dvyukov@google.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, sandeen@redhat.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    2187f215 Merge tag 'for-5.5-rc2-tag' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11059951e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ab2ae0615387ef78
dashboard link: https://syzkaller.appspot.com/bug?extid=4722bf4c6393b73a792b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12727c71e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ff5151e00000

The bug was bisected to:

commit 0609ae011deb41c9629b7f5fd626dfa1ac9d16b0
Author: Daniel Axtens <dja@axtens.net>
Date:   Sun Dec 1 01:55:00 2019 +0000

     x86/kasan: support KASAN_VMALLOC

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=161240aee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=151240aee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=111240aee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com
Fixes: 0609ae011deb ("x86/kasan: support KASAN_VMALLOC")

BUG: unable to handle page fault for address: fffff52000680000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD aa51c067 PMD a85e1067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3088 Comm: kworker/1:2 Not tainted 5.5.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: xfs-buf/loop0 xfs_buf_ioend_work
RIP: 0010:xfs_sb_quiet_read_verify+0x47/0xc0 fs/xfs/libxfs/xfs_sb.c:735
Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7f 49 8b 9c 24 30 01  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 04 3c 03 7e 50 8b 1b bf 58 46 53 42 89 de e8
RSP: 0018:ffffc90008187cc0 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffffc90003400000 RCX: ffffffff82ad3c26
RDX: 1ffff92000680000 RSI: ffffffff82aa0a0f RDI: ffff8880a2cdba70
RBP: ffffc90008187cd0 R08: ffff88809eb6c500 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a2cdb940
R13: ffff8880a2cdb95c R14: ffff8880a2cdbb74 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff52000680000 CR3: 000000009f5ab000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  xfs_buf_ioend+0x3f9/0xde0 fs/xfs/xfs_buf.c:1162
  xfs_buf_ioend_work+0x19/0x20 fs/xfs/xfs_buf.c:1183
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
CR2: fffff52000680000
---[ end trace 744ceb50d377bf94 ]---
RIP: 0010:xfs_sb_quiet_read_verify+0x47/0xc0 fs/xfs/libxfs/xfs_sb.c:735
Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7f 49 8b 9c 24 30 01  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 04 3c 03 7e 50 8b 1b bf 58 46 53 42 89 de e8
RSP: 0018:ffffc90008187cc0 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: ffffc90003400000 RCX: ffffffff82ad3c26
RDX: 1ffff92000680000 RSI: ffffffff82aa0a0f RDI: ffff8880a2cdba70
RBP: ffffc90008187cd0 R08: ffff88809eb6c500 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a2cdb940
R13: ffff8880a2cdb95c R14: ffff8880a2cdbb74 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff52000680000 CR3: 000000009f5ab000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
