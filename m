Return-Path: <SRS0=kies=2K=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3C7C43603
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 06:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0154E24682
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Dec 2019 06:04:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="I8riZzVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLTGEA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Dec 2019 01:04:00 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39470 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbfLTGEA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Dec 2019 01:04:00 -0500
Received: by mail-pj1-f66.google.com with SMTP id t101so3645885pjb.4
        for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2019 22:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:subject:in-reply-to:references:date:message-id:mime-version;
        bh=AMPB7ShRq26cjcwcJP9t45jKBX3IyVrTQyCL756tp90=;
        b=I8riZzVk/K2+pnrgpWFE1uZQLo+TNx4sVlk/qjoiA4YqJLEt061dszIV+0U/r2TdWE
         9k043b3Xrp4h8IexCbkjlDyqRhHz6PCBV2U2DrqfVto2v680PLjO2J/CiyKPL955+EEQ
         B9b4DWKXAkj/aiOjOeN1zMKc7Ba77qz8ITRF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=AMPB7ShRq26cjcwcJP9t45jKBX3IyVrTQyCL756tp90=;
        b=qk55EApyoYuEbIdoLVURZWIV0hZqwS8Mrp8bwlHtP8a0TBBJhAolHhp1h/kwZvVwkb
         lQjfNUuW0GkQCsl6n8usNbI4e+mNeNS1x7MPex1M6XTC3YJhwkLE00cNci8XJdESjObM
         tOyniokROtXviKpObp9t2AYG9nN7DUBpsVBb9JDIhBZf6r/SuQ5Pmb5JGaSiT69VZcEL
         Z7r6wlZIcBlHZy0zEOFFAzi0Wv7CNq7DdI19hEzKooThS56sAvAfRkd42H+DDzLpSAnu
         xRe/+KS+wYI0CfUnlhM1vX9oeofS646O5QZSy1RBdVrIuAYLFUxW5dl51TQOFsfZsMz5
         3j2g==
X-Gm-Message-State: APjAAAUsj9PJ+zaKX5uLM23FAwsMhUt1fzIAhufq6j2a66eGQeMwnB9K
        E+CCAoO8J/zrUvuZG6ID3jiZcQ==
X-Google-Smtp-Source: APXvYqxUrLwIm/01UvhThpcINxVbqFsuTmtTW9/Tide7dNhWID9p4Y5Ph9VZw/nVK8390ESYSEapVA==
X-Received: by 2002:a17:90a:5ac4:: with SMTP id n62mr14478392pji.59.1576821839745;
        Thu, 19 Dec 2019 22:03:59 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-b05d-cbfe-b2ee-de17.static.ipv6.internode.on.net. [2001:44b8:1113:6700:b05d:cbfe:b2ee:de17])
        by smtp.gmail.com with ESMTPSA id y38sm9527104pgk.33.2019.12.19.22.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 22:03:58 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     syzbot <syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, allison.henderson@oracle.com,
        aryabinin@virtuozzo.com, bfoster@redhat.com,
        darrick.wong@oracle.com, dchinner@redhat.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@redhat.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org
Subject: Re: BUG: unable to handle kernel paging request in xfs_sb_quiet_read_verify
In-Reply-To: <000000000000d99340059a100686@google.com>
References: <000000000000d99340059a100686@google.com>
Date:   Fri, 20 Dec 2019 17:03:55 +1100
Message-ID: <874kxvttx0.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot <syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com> writes:

> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    2187f215 Merge tag 'for-5.5-rc2-tag' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11059951e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ab2ae0615387ef78
> dashboard link: https://syzkaller.appspot.com/bug?extid=4722bf4c6393b73a792b
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12727c71e00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ff5151e00000
>
> The bug was bisected to:
>
> commit 0609ae011deb41c9629b7f5fd626dfa1ac9d16b0
> Author: Daniel Axtens <dja@axtens.net>
> Date:   Sun Dec 1 01:55:00 2019 +0000
>
>      x86/kasan: support KASAN_VMALLOC

Looking at the log, it's an access of fffff52000680000 that goes wrong.

Reversing the shadow calculation, it looks like an attempted access of
FFFFC90003400000, which is in vmalloc space. I'm not sure what that
memory represents.

Looking at the instruction pointer, it seems like we're here:

static void
xfs_sb_quiet_read_verify(
	struct xfs_buf	*bp)
{
	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);

	if (dsb->sb_magicnum == cpu_to_be32(XFS_SB_MAGIC)) {     <<<< fault here
		/* XFS filesystem, verify noisily! */
		xfs_sb_read_verify(bp);


Is it possible that dsb is junk?

Regards,
Daniel

>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=161240aee00000
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=151240aee00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=111240aee00000
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+4722bf4c6393b73a792b@syzkaller.appspotmail.com
> Fixes: 0609ae011deb ("x86/kasan: support KASAN_VMALLOC")
>
> BUG: unable to handle page fault for address: fffff52000680000
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD 21ffee067 P4D 21ffee067 PUD aa51c067 PMD a85e1067 PTE 0
> Oops: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 3088 Comm: kworker/1:2 Not tainted 5.5.0-rc2-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> Workqueue: xfs-buf/loop0 xfs_buf_ioend_work
> RIP: 0010:xfs_sb_quiet_read_verify+0x47/0xc0 fs/xfs/libxfs/xfs_sb.c:735
> Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7f 49 8b 9c 24 30 01  
> 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 84  
> c0 74 04 3c 03 7e 50 8b 1b bf 58 46 53 42 89 de e8
> RSP: 0018:ffffc90008187cc0 EFLAGS: 00010a06
> RAX: dffffc0000000000 RBX: ffffc90003400000 RCX: ffffffff82ad3c26
> RDX: 1ffff92000680000 RSI: ffffffff82aa0a0f RDI: ffff8880a2cdba70
> RBP: ffffc90008187cd0 R08: ffff88809eb6c500 R09: ffffed1015d2703d
> R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a2cdb940
> R13: ffff8880a2cdb95c R14: ffff8880a2cdbb74 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffff52000680000 CR3: 000000009f5ab000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   xfs_buf_ioend+0x3f9/0xde0 fs/xfs/xfs_buf.c:1162
>   xfs_buf_ioend_work+0x19/0x20 fs/xfs/xfs_buf.c:1183
>   process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
>   worker_thread+0x98/0xe40 kernel/workqueue.c:2410
>   kthread+0x361/0x430 kernel/kthread.c:255
>   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> Modules linked in:
> CR2: fffff52000680000
> ---[ end trace 744ceb50d377bf94 ]---
> RIP: 0010:xfs_sb_quiet_read_verify+0x47/0xc0 fs/xfs/libxfs/xfs_sb.c:735
> Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7f 49 8b 9c 24 30 01  
> 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 da 48 c1 ea 03 <0f> b6 04 02 84  
> c0 74 04 3c 03 7e 50 8b 1b bf 58 46 53 42 89 de e8
> RSP: 0018:ffffc90008187cc0 EFLAGS: 00010a06
> RAX: dffffc0000000000 RBX: ffffc90003400000 RCX: ffffffff82ad3c26
> RDX: 1ffff92000680000 RSI: ffffffff82aa0a0f RDI: ffff8880a2cdba70
> RBP: ffffc90008187cd0 R08: ffff88809eb6c500 R09: ffffed1015d2703d
> R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: ffff8880a2cdb940
> R13: ffff8880a2cdb95c R14: ffff8880a2cdbb74 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffff52000680000 CR3: 000000009f5ab000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches
