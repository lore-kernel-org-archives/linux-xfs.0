Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5B6C00140
	for <linux-xfs@archiver.kernel.org>; Sun, 21 Aug 2022 20:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiHUU7S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Aug 2022 16:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiHUU7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Aug 2022 16:59:17 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB5512D28
        for <linux-xfs@vger.kernel.org>; Sun, 21 Aug 2022 13:59:16 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id h8-20020a92c268000000b002e95299cff0so4386955ild.23
        for <linux-xfs@vger.kernel.org>; Sun, 21 Aug 2022 13:59:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=iV6gcKM1GJJSWkpDC+Iv2PckRjW/iBIbJSlzEPuB9vg=;
        b=WoRZFPMpHvjhBEthK78t1NYdc4sNFqHcAJxsFi8lzUDQn8EPgX60LllKeGaSbvO/nT
         b+lGeOkOP1M2EykAztIvvpce11zvipSDe7oxO9CgIdoE9TvtFbtBD5nOgC1IXoocNs1f
         +BsjPWcUDf0GwClCvwVYUkOc88AU6AnY6mucB/+Pl95TZE1JTNnqMSASK0p2AUXeuC8H
         H4mDwigs4RwLS7nxCY5pGVqE6MZXjcnEzP6TnJco8su1I/mZFwsctRBoajWyPEC8jF2L
         L7X8gOv4CkRDFike4CWAe3CphLBlc+F1IKFdS3FnonUoQGeoPzGKGmcjFo1iATe3u1gW
         5/aQ==
X-Gm-Message-State: ACgBeo03bi7MN5vpGJKd9ubtQSd229B+Nkv9m1kfWOkrEiz1O+KCNtG0
        lurlq4mgNBS3Q+jOLyMIeqEjV5jpycg7z3vVNwGGuBpQeZCk
X-Google-Smtp-Source: AA6agR7l7mj/dIeDXCF3s+KvdeZo7E4WFlUBD1ZSnhSSVaC4zdn5pb++CpLMUyYPWXSln22thqPqX8FUtzhtArZ5Y6pEJDmpXKHq
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160a:b0:2e9:763c:485b with SMTP id
 t10-20020a056e02160a00b002e9763c485bmr3272522ilu.173.1661115556242; Sun, 21
 Aug 2022 13:59:16 -0700 (PDT)
Date:   Sun, 21 Aug 2022 13:59:16 -0700
In-Reply-To: <20220821114816.24193-1-code@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a92b9305e6c69a3f@google.com>
Subject: Re: [syzbot] WARNING in iomap_iter
From:   syzbot <syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com>
To:     code@siddh.me, david@fromorbit.com, djwong@kernel.org,
        fgheet255t@gmail.com, hch@infradead.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        riteshh@linux.ibm.com, syzkaller-bugs@googlegroups.com,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-and-tested-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com

Tested on:

commit:         e3f259d3 Merge tag 'i2c-for-6.0-rc2' of git://git.kern..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=16085295080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3babfbf8c1ad1951
dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=13c53aa5080000

Note: testing is done by a robot and is best-effort only.
