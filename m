Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A0EC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 21:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234933AbiKVV2l (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Nov 2022 16:28:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234887AbiKVV2k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Nov 2022 16:28:40 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D33326D3
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 13:28:37 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id h21-20020a05660224d500b006debd7dedccso4254343ioe.9
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 13:28:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1BxnaN+kby2QoU1gsXQmJvuJ4fwkuZ15Ed9J43+NGoA=;
        b=XPIGL/hZ1VMvc0/19tcN9oJLmvlN58UWvhjs2t9u+laYQ49Vze/QnExyXgjJ7/LYh1
         vyuQwkgGGyyV+SyHw2jh8EBHj/IVjUqPkUVc4kIXEXNhCtzDLCNTZD5KndlFE8+6urWG
         XRm03F0b94mZ0+QrhWGQhB1Yx+VRWgefDEmD0OKVnMribaRJBQaMfrlRBYTweUpmfsIV
         AtFqdFYE4XOGieyeGvJjm4nI1HRzOfoDjMN9pjoG87k4OUR3R1L7eHQZfqb5dVNhraBf
         3wqlCRTxZ2NP520hMbYhdSB/lDmYIOpdkgZWFBNtWMEfCad3xCLVH75PkeTEs0/NpEv2
         VPFw==
X-Gm-Message-State: ANoB5pndLe9h7etZ6tVtoOQm2JQ58ZMrMAS2B80raJsumaQedxTQMgqC
        7RxXMNuSlL3S9tVYNOrJR+GRSVtmy4sG59L89z3ABF04l8pa
X-Google-Smtp-Source: AA0mqf5ocmJekITAuBLG1Gb6K9/qaAqAo2KuMEnYw0GbGaW2w9xPXu6d8udpVHvzvbaRmAeDL6OPlAvVKWfwEbhh2SzBHrnEvaqs
MIME-Version: 1.0
X-Received: by 2002:a92:c809:0:b0:302:b4c8:dd5d with SMTP id
 v9-20020a92c809000000b00302b4c8dd5dmr7436451iln.126.1669152517070; Tue, 22
 Nov 2022 13:28:37 -0800 (PST)
Date:   Tue, 22 Nov 2022 13:28:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000db25f305ee15daf0@google.com>
Subject: [syzbot] WARNING in xfs_qm_dqget_cache_insert
From:   syzbot <syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com>
To:     djwong@kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    eb7081409f94 Linux 6.1-rc6
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=100fe5ed880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cdf448d3b35234
dashboard link: https://syzkaller.appspot.com/bug?extid=6ae213503fb12e87934f
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c00fe9880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1052d639880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4a019f55c517/disk-eb708140.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eb36e890aa8b/vmlinux-eb708140.xz
kernel image: https://storage.googleapis.com/syzbot-assets/feee2c23ec64/bzImage-eb708140.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d8a4f3231ed0/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6ae213503fb12e87934f@syzkaller.appspotmail.com

XFS (loop0): Ending clean mount
XFS (loop0): Quotacheck needed: Please wait.
XFS (loop0): Quotacheck: Done.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 3655 at fs/xfs/xfs_dquot.c:801 xfs_qm_dqget_cache_insert+0xff/0x110
Modules linked in:
CPU: 1 PID: 3655 Comm: syz-executor106 Not tainted 6.1.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:xfs_qm_dqget_cache_insert+0xff/0x110 fs/xfs/xfs_dquot.c:801
Code: 38 c1 7c a3 48 89 ef e8 5f 46 a1 fe eb 99 44 89 e1 80 e1 07 80 c1 03 38 c1 7c a8 4c 89 e7 e8 d8 45 a1 fe eb 9e e8 f1 2d 4d fe <0f> 0b eb b8 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 55 41 57 41 56
RSP: 0018:ffffc90003c7f710 EFLAGS: 00010293
RAX: ffffffff833d6a7f RBX: 000000000000ee01 RCX: ffff888021afba80
RDX: 0000000000000000 RSI: ffffffff8d794b70 RDI: 00000000fffffff4
RBP: ffff888023674680 R08: 0000000000000005 R09: ffffffff833d69c8
R10: 0000000000000002 R11: ffff888021afba80 R12: ffff8880779c8800
R13: ffff888023674680 R14: ffff8880779c88f0 R15: 00000000fffffff4
FS:  0000555556ce6300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0ba7315000 CR3: 0000000079452000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xfs_qm_dqget+0x2dd/0x510 fs/xfs/xfs_dquot.c:874
 xfs_qm_vop_dqalloc+0x598/0xe70 fs/xfs/xfs_qm.c:1679
 xfs_setattr_nonsize+0x41a/0x1220 fs/xfs/xfs_iops.c:702
 xfs_vn_setattr+0x2f5/0x340 fs/xfs/xfs_iops.c:1022
 notify_change+0xe38/0x10f0 fs/attr.c:420
 chown_common+0x586/0x8f0 fs/open.c:736
 do_fchownat+0x165/0x240 fs/open.c:767
 __do_sys_lchown fs/open.c:792 [inline]
 __se_sys_lchown fs/open.c:790 [inline]
 __x64_sys_lchown+0x81/0x90 fs/open.c:790
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f0ba7363a09
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc267deac8 EFLAGS: 00000246 ORIG_RAX: 000000000000005e
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f0ba7363a09
RDX: 0000000000000000 RSI: 000000000000ee01 RDI: 0000000020000100
RBP: 00007ffc267deaf0 R08: 0000000000000002 R09: 00007ffc267deb00
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 00007ffc267deb30 R14: 00007ffc267deb10 R15: 0000000000000002
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
