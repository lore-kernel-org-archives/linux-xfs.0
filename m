Return-Path: <SRS0=J6xf=ZW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7222DC43215
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 07:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5136A20833
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 07:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfK3H5J (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Nov 2019 02:57:09 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:38342 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfK3H5J (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Nov 2019 02:57:09 -0500
Received: by mail-io1-f69.google.com with SMTP id q4so21882052ion.5
        for <linux-xfs@vger.kernel.org>; Fri, 29 Nov 2019 23:57:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vizerLb0/B8eHiqw35KBdL2R/eL8WfeHEsZlco7wsrE=;
        b=N6eMoTdOp98PkbiZCm8YcCn7mj/+3rz3ZKfA1HxghW+L56zIQquNlf6rfQygt5dI2V
         Z66HwFe4D2wJ5pwLM351l0FAx0AW5yRBWcUEPLy96Om0fPgY4fwRNik5GnnN43tKSXB0
         6Bdu8kcsLCmT3T9Bzro9dbXdjbxkbr+K23gBbpkNdSfIaYdR38/+8zbd1Zf8y0U/ZcU2
         TfDP13W5V+RLEiE9LsAzmR/JRtPnUsltVQmQKMOwbu1qLTKfT9xQPadipPQVwslwU8a/
         MU3k5RnoW4ncw1NwmiyL1+ET8hx1f0BxObnYq0cuQv0ZA+0+KpoJXin9koByPkse/8wK
         yusg==
X-Gm-Message-State: APjAAAWXbfJikmqNImc8ZTY/2TvRec+jlGqyrVHG8wVjwrukRATMDboL
        vhHFJ5/CPk+Ib/wPE2DOhAWwFtHr43Rra4kFhdxbMzhRUj2V
X-Google-Smtp-Source: APXvYqz/idIT/WJw5XhCMK++RXKuxDrgBlMTqJ8w63nNOjBrl8xu1dhlPRuzHBxCAOpTyV2XviI6BovEucq/ExQasyIki0oF3N9p
MIME-Version: 1.0
X-Received: by 2002:a92:50c:: with SMTP id q12mr58576238ile.234.1575100627234;
 Fri, 29 Nov 2019 23:57:07 -0800 (PST)
Date:   Fri, 29 Nov 2019 23:57:07 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005f386305988bb15f@google.com>
Subject: BUG: unable to handle kernel paging request in xfs_sb_read_verify
From:   syzbot <syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com>
To:     allison.henderson@oracle.com, bfoster@redhat.com,
        darrick.wong@oracle.com, dchinner@redhat.com,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    419593da Add linux-next specific files for 20191129
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10cecb36e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7c04b0959e75c206
dashboard link: https://syzkaller.appspot.com/bug?extid=6be2cbddaad2e32b47a0
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: fffff52002e00000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD aa11c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 2938 Comm: kworker/0:2 Not tainted  
5.4.0-next-20191129-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: xfs-buf/loop3 xfs_buf_ioend_work
RIP: 0010:xfs_sb_read_verify+0xf0/0x540 fs/xfs/libxfs/xfs_sb.c:691
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 18 04 00 00 4d 8b ac 24 30 01  
00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e a7 03 00 00 41 8b 75 00 bf 58
RSP: 0018:ffffc90007e5faf0 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: 1ffff92000fcbf61 RCX: ffffffff82acb516
RDX: 1ffff92002e00000 RSI: ffffffff82a97e3b RDI: ffff888091bada60
RBP: ffffc90007e5fcd0 R08: ffff88809f3c2040 R09: ffffed1015cc7045
R10: ffffed1015cc7044 R11: ffff8880ae638223 R12: ffff888091bad940
R13: ffffc90017000000 R14: ffffc90007e5fca8 R15: ffff88809feb8000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff52002e00000 CR3: 0000000069ceb000 CR4: 00000000001406f0
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
CR2: fffff52002e00000
---[ end trace aef83d995322cc4a ]---
RIP: 0010:xfs_sb_read_verify+0xf0/0x540 fs/xfs/libxfs/xfs_sb.c:691
Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 18 04 00 00 4d 8b ac 24 30 01  
00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 04 02 84  
c0 74 08 3c 03 0f 8e a7 03 00 00 41 8b 75 00 bf 58
RSP: 0018:ffffc90007e5faf0 EFLAGS: 00010a06
RAX: dffffc0000000000 RBX: 1ffff92000fcbf61 RCX: ffffffff82acb516
RDX: 1ffff92002e00000 RSI: ffffffff82a97e3b RDI: ffff888091bada60
RBP: ffffc90007e5fcd0 R08: ffff88809f3c2040 R09: ffffed1015cc7045
R10: ffffed1015cc7044 R11: ffff8880ae638223 R12: ffff888091bad940
R13: ffffc90017000000 R14: ffffc90007e5fca8 R15: ffff88809feb8000
FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff52002e00000 CR3: 0000000069ceb000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
