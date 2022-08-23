Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FFD2C32774
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Aug 2022 17:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiHWRmN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbiHWRlA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Aug 2022 13:41:00 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49564AC259
        for <linux-xfs@vger.kernel.org>; Tue, 23 Aug 2022 08:38:16 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id x7-20020a056e021ca700b002ea01be6018so1922871ill.18
        for <linux-xfs@vger.kernel.org>; Tue, 23 Aug 2022 08:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc;
        bh=jj+DJXwrsYlSJItXjtgoHdex4lZY6RIyfIJzSWY+0OA=;
        b=BcCM6Ur05mtQxZQXTddMM07xYpBxGSitGiJw28o+qo+7AV4iMSNotm/Y4sB9Vevu/9
         JccZz8ntvMJOD9qXq5CldQBNvCcnfRUP4SudnvsicKk39STZosodM9J2+MUM6RNe/C0M
         40cYygh/1tbbhnDFAYkbbyd+JM2wuKtyYL4MAvuBPOKdtj7ALvOBLiKuIgV9A+YUuhi8
         k4MwBhM0PE1hizp/mJCk4PI3d8Nmdzp63s8nI/z5qgW1m9HE7N4SGgfAHAcFK2/RHsRF
         PeXb4fCrvdsTtTqoYsOeMM1jcmBICN94eyyK4DrfMlsd3DvHpAf5LZZRYJhqU1JF/3PK
         4ZQw==
X-Gm-Message-State: ACgBeo1sZ+N1xLa38tts0zF5jRb5ghsqJVTmP6p2H2re5tXmGU4RAkU0
        FfB8AcsnDOgQqUlX5W/AxqdHpu+BbmiMGMNZpu/HlEnoohV/
X-Google-Smtp-Source: AA6agR6E5kQeZsO1i1vYztRzxIpze53XHYtfM9V0vZY1WanZlXP3pyvAqhiEdhMjqZJTJnrTzmbfrJBk/YwRG3atOe+jou2IskV/
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c07:b0:2e9:221e:9c77 with SMTP id
 l7-20020a056e021c0700b002e9221e9c77mr98428ilh.176.1661269095633; Tue, 23 Aug
 2022 08:38:15 -0700 (PDT)
Date:   Tue, 23 Aug 2022 08:38:15 -0700
In-Reply-To: <20220823152101.165538-1-code@siddh.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000525beb05e6ea5aeb@google.com>
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

commit:         072e5135 Merge tag 'nfs-for-5.20-2' of git://git.linux..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=120a311d080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3f885f57a0f25c38
dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=169d8e5b080000

Note: testing is done by a robot and is best-effort only.
