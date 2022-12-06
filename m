Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66AB4C4708C
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Dec 2022 03:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiLFDMS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Dec 2022 22:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbiLFDMR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Dec 2022 22:12:17 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A71A19C10
        for <linux-xfs@vger.kernel.org>; Mon,  5 Dec 2022 19:12:16 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id e15-20020a056602158f00b006e01d8fa493so1884727iow.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Dec 2022 19:12:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UvD+MZjtUR1zcO4JD+kq1ILF5xn9xebsMtnvhQcAkAE=;
        b=4RsWiNU/pRFizWue8JwgS/UCkp0mIRqbiKMijEZcGwWJ+b4fawt1iLgmxraxTXzbH8
         Dh4SlmsSzmPcxxitR97+q4SGCpgcCHzq02gEa37RIfS2qa+f6paDo8OwgJvLIh92Re6w
         ehDM3oA7GNEtHMxV1J891uVCKQbHdAXQ9oqw40UQEnGFo73EFwWwvKDiUnw6Y9uxnxsH
         Vvp+TZqVZaDIJJ+wwn94WGXMYxfp9guXsTpH4/Xp8gy1kvTtMYiwCydyzq+T/BNNo3N5
         VL9brX/UAWmVBGSLGpsVsHGxQZHiv/S1+d8Dj058VDMFPnu8SlVVQBqKpUDkC9xxAnBD
         2IrQ==
X-Gm-Message-State: ANoB5pkEASiV6QruyYH/vesj0SOQo/v29N2ldLwohxEOWQxfV+leuvSR
        E6GfeiiekqxLi7VP9stdNE5/74JECQU/WYopjZJg8S0dZ4o8
X-Google-Smtp-Source: AA0mqf6A0GebHKYwEIp76zOIrRahHhD9zg1SBqJJFP7ufPb0tnRDBwWyKhcL9tmmAF8gUTA4P7QEV6FIh3yV6A26PFMBJA+62NY8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156c:b0:303:4885:a1fe with SMTP id
 k12-20020a056e02156c00b003034885a1femr6044451ilu.261.1670296335371; Mon, 05
 Dec 2022 19:12:15 -0800 (PST)
Date:   Mon, 05 Dec 2022 19:12:15 -0800
In-Reply-To: <20221205235827.GR3600936@dread.disaster.area>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bd587705ef202b08@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in xfs_qm_dqfree_one
From:   syzbot <syzbot+912776840162c13db1a3@syzkaller.appspotmail.com>
To:     david@fromorbit.com, djwong@kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
INFO: rcu detected stall in corrupted

rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { P4122 } 2641 jiffies s: 2877 root: 0x0/T
rcu: blocking rcu_node structures (internal RCU debug):


Tested on:

commit:         bce93322 proc: proc_skip_spaces() shouldn't think it i..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=1566216b880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d58e7fe7f9cf5e24
dashboard link: https://syzkaller.appspot.com/bug?extid=912776840162c13db1a3
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
patch:          https://syzkaller.appspot.com/x/patch.diff?x=164cad83880000

