Return-Path: <SRS0=J6xf=ZW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A4CC432C0
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 08:00:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0F4120833
	for <linux-xfs@archiver.kernel.org>; Sat, 30 Nov 2019 08:00:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fmxbj52I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfK3IAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 30 Nov 2019 03:00:55 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:40794 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbfK3IAw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 30 Nov 2019 03:00:52 -0500
Received: by mail-qv1-f67.google.com with SMTP id i3so12505941qvv.7
        for <linux-xfs@vger.kernel.org>; Sat, 30 Nov 2019 00:00:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o46WZxPqRgJv0aRTEdOKQ8kVdntcooFcgI2XD+4wx4c=;
        b=fmxbj52Idh7zKou+i+4k/rF8G9wb1b4spShT5Cc2rOzy+se4ZH08HpBZ/plDnseeXz
         ULZf/Vl5kUbXPZ6Mg+/efEHRHS0qNmxieFWVGxwU5I+mXpYmr6I8w/Xahk20JTu4+en+
         TU/mKY0GYb5uI6bmE6FVhH/sxi+ozxgLT0NEwwfq/FDIFxnLQWkE4vWGmvVvDldgA32Y
         XEdMhYP0so2h1fPc8QpiJsAHI5yHBVIN78LlE/bYPSA64eqaF0RlTetgQYzYtpkSu4T7
         zC5LOCWmBuwA58jwOz3ZxWM13BRiBJRlndUDcz0CZaI/5/1NcVvdwbEWw/hxk9p6SwBw
         9UEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o46WZxPqRgJv0aRTEdOKQ8kVdntcooFcgI2XD+4wx4c=;
        b=GA5y29x/FUilxvijfb3TsTfwt00GjzJ2blJZqNgjuyQTWQ1fBcQc0mT9jbDovNFk2K
         h/DwIb5M6PWLfXcquj0209Fzzyv5sjaZ9Rjya1G1g7eFnfLS+KXpR5LgZgsPWhlZRMRj
         ChbwXmzc5G8XpGRtsEjruDxMR5pqbKNgs2MBvaaUOCApYHrL31v7OGCj8+ozQfJ4fzE5
         JXqIrXInqe402GXkKJ5P1A6ewtIuzlk7y1kLRUrxKY7kObdjxucy1W87GoRp6B0kR5EO
         xYfdlI3cCw2xYUTGkAQzhcmEHZjZpCFAMxo6Y49F+4nDwTatjjxAwhKBKDx+EgAo7Sqm
         pyxQ==
X-Gm-Message-State: APjAAAUkDkvLrSMDEJqumfPiWi4w+Am/Z1kDcfbxfFQnc6yBo2+AJCkw
        KmCgN+B/DjovPd39NIy6Y5eT6CLrM5tWkBcYKl6ObQ==
X-Google-Smtp-Source: APXvYqwS5Ft1b1k9/rtnobhPkk0IKn+Onq8VpQ6aeJ5wn0hqJ6gpuB/A5X4j4BoHf9Ia28C0qVJxK7kyiPJfMA+zjVA=
X-Received: by 2002:a0c:c125:: with SMTP id f34mr21651241qvh.22.1575100849562;
 Sat, 30 Nov 2019 00:00:49 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005f386305988bb15f@google.com> <CACT4Y+aQic2aM1gPOp_1Nh0ydAeeJk=KVbRZJpo9S1Zdt7SuzQ@mail.gmail.com>
In-Reply-To: <CACT4Y+aQic2aM1gPOp_1Nh0ydAeeJk=KVbRZJpo9S1Zdt7SuzQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sat, 30 Nov 2019 09:00:38 +0100
Message-ID: <CACT4Y+aM7Jy=+Fq-yzUo-3WMchhtua9wWvqyL21VPh2b0cZtRg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in xfs_sb_read_verify
To:     syzbot <syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com>,
        Daniel Axtens <dja@axtens.net>,
        kasan-dev <kasan-dev@googlegroups.com>
Cc:     allison.henderson@oracle.com, Brian Foster <bfoster@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>, dchinner@redhat.com,
        LKML <linux-kernel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>, sandeen@redhat.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 30, 2019 at 8:58 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Sat, Nov 30, 2019 at 8:57 AM syzbot
> <syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    419593da Add linux-next specific files for 20191129
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10cecb36e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=7c04b0959e75c206
> > dashboard link: https://syzkaller.appspot.com/bug?extid=6be2cbddaad2e32b47a0
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+6be2cbddaad2e32b47a0@syzkaller.appspotmail.com
>
> +Daniel, kasan-dev
> This is presumably from the new CONFIG_KASAN_VMALLOC

This should be:
#syz fix: kasan: support vmalloc backing of vm_map_ram()

> > BUG: unable to handle page fault for address: fffff52002e00000
> > #PF: supervisor read access in kernel mode
> > #PF: error_code(0x0000) - not-present page
> > PGD 21ffee067 P4D 21ffee067 PUD aa11c067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 2938 Comm: kworker/0:2 Not tainted
> > 5.4.0-next-20191129-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Workqueue: xfs-buf/loop3 xfs_buf_ioend_work
> > RIP: 0010:xfs_sb_read_verify+0xf0/0x540 fs/xfs/libxfs/xfs_sb.c:691
> > Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 18 04 00 00 4d 8b ac 24 30 01
> > 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 04 02 84
> > c0 74 08 3c 03 0f 8e a7 03 00 00 41 8b 75 00 bf 58
> > RSP: 0018:ffffc90007e5faf0 EFLAGS: 00010a06
> > RAX: dffffc0000000000 RBX: 1ffff92000fcbf61 RCX: ffffffff82acb516
> > RDX: 1ffff92002e00000 RSI: ffffffff82a97e3b RDI: ffff888091bada60
> > RBP: ffffc90007e5fcd0 R08: ffff88809f3c2040 R09: ffffed1015cc7045
> > R10: ffffed1015cc7044 R11: ffff8880ae638223 R12: ffff888091bad940
> > R13: ffffc90017000000 R14: ffffc90007e5fca8 R15: ffff88809feb8000
> > FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: fffff52002e00000 CR3: 0000000069ceb000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >   xfs_buf_ioend+0x3f9/0xde0 fs/xfs/xfs_buf.c:1162
> >   xfs_buf_ioend_work+0x19/0x20 fs/xfs/xfs_buf.c:1183
> >   process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
> >   worker_thread+0x98/0xe40 kernel/workqueue.c:2410
> >   kthread+0x361/0x430 kernel/kthread.c:255
> >   ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Modules linked in:
> > CR2: fffff52002e00000
> > ---[ end trace aef83d995322cc4a ]---
> > RIP: 0010:xfs_sb_read_verify+0xf0/0x540 fs/xfs/libxfs/xfs_sb.c:691
> > Code: fc ff df 48 c1 ea 03 80 3c 02 00 0f 85 18 04 00 00 4d 8b ac 24 30 01
> > 00 00 48 b8 00 00 00 00 00 fc ff df 4c 89 ea 48 c1 ea 03 <0f> b6 04 02 84
> > c0 74 08 3c 03 0f 8e a7 03 00 00 41 8b 75 00 bf 58
> > RSP: 0018:ffffc90007e5faf0 EFLAGS: 00010a06
> > RAX: dffffc0000000000 RBX: 1ffff92000fcbf61 RCX: ffffffff82acb516
> > RDX: 1ffff92002e00000 RSI: ffffffff82a97e3b RDI: ffff888091bada60
> > RBP: ffffc90007e5fcd0 R08: ffff88809f3c2040 R09: ffffed1015cc7045
> > R10: ffffed1015cc7044 R11: ffff8880ae638223 R12: ffff888091bad940
> > R13: ffffc90017000000 R14: ffffc90007e5fca8 R15: ffff88809feb8000
> > FS:  0000000000000000(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: fffff52002e00000 CR3: 0000000069ceb000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >
> >
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> >
> > --
> > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/0000000000005f386305988bb15f%40google.com.
