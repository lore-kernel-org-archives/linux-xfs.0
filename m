Return-Path: <SRS0=9l/N=DP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0068FC43467
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 08:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9DAF521775
	for <linux-xfs@archiver.kernel.org>; Thu,  8 Oct 2020 08:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbgJHIoI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 8 Oct 2020 04:44:08 -0400
Received: from mail-il1-f207.google.com ([209.85.166.207]:36647 "EHLO
        mail-il1-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgJHIoI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Oct 2020 04:44:08 -0400
Received: by mail-il1-f207.google.com with SMTP id q5so3581375ilm.3
        for <linux-xfs@vger.kernel.org>; Thu, 08 Oct 2020 01:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=6MwKd6ECqXO02glRpdlbEwUDApjYJYWG4NqQdqBh3uA=;
        b=jkjMNxMACw077p8twSSUsMo8vluQWVVs3Qava6Y/7cwn3Fsjb87RKQCPD0or/fC5pb
         t6W1BS5lMmv70A5ZIP9eHF3CsyA+OmHzJ/mxxuQ9ngyyJ9Lux0QCqLUHaC/m3oNNi673
         OAWhEabFKc9DXPpSWp5Doz2TSixaVdg5dYE9A/c62wsMJkiuNyErohHqCAV68RV3SV9w
         et/wWrbt8zvFr0K6pA13sYBzGAe4y62tTG+bH5asccvWgKRW+gpKxVYrpmIV3O1YnI58
         3q0Rxlmi1g/2NOAYETFq+ZIWgN8h9Rpl5W6PpOnakoGoYWvfHADvro7HYbnln3gZPA6e
         2Q1Q==
X-Gm-Message-State: AOAM5311EGHi95avZm++PyTOalAWf9U4jlPS9O0OHT1zSo421r7CFBcA
        s+GMKqsasIw2oH3Vd42yCI2ecw8NtOlSONUD60KdrfNUxK84
X-Google-Smtp-Source: ABdhPJwe9yGzWtEyp2QVuKoHI7i5uX++AtNA/6JCwRa0wbYTKjpni0vLIZXpzGGh3imciRcuugLUvK3o2lB6t1c1Z1qEMdkQi8ka
MIME-Version: 1.0
X-Received: by 2002:a02:a10f:: with SMTP id f15mr5972131jag.62.1602146647376;
 Thu, 08 Oct 2020 01:44:07 -0700 (PDT)
Date:   Thu, 08 Oct 2020 01:44:07 -0700
In-Reply-To: <0000000000006226c805adf16cb8@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cb8c0605b124d53c@google.com>
Subject: Re: WARNING: ODEBUG bug in exit_to_user_mode_prepare
From:   syzbot <syzbot+fbd7ba7207767ed15165@syzkaller.appspotmail.com>
To:     axboe@kernel.dk, bfoster@redhat.com, darrick.wong@oracle.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, maz@kernel.org, oleg@redhat.com,
        peterz@infradead.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot suspects this issue was fixed by commit:

commit 9c516e0e4554e8f26ab73d46cbc789d7d8db664d
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Aug 18 15:05:58 2020 +0000

    xfs: finish dfops on every insert range shift iteration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=157f71e0500000
start commit:   dcc5c6f0 Merge tag 'x86-urgent-2020-08-30' of git://git.ke..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=978db74cb30aa994
dashboard link: https://syzkaller.appspot.com/bug?extid=fbd7ba7207767ed15165
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1447c115900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1344f9fe900000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: xfs: finish dfops on every insert range shift iteration

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
