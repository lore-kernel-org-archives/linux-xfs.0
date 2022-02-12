Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46AFC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Feb 2022 20:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiBLUle (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 12 Feb 2022 15:41:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiBLUlc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 12 Feb 2022 15:41:32 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFF64A920
        for <linux-xfs@vger.kernel.org>; Sat, 12 Feb 2022 12:41:27 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id f18-20020a926a12000000b002be48b02bc6so8235720ilc.17
        for <linux-xfs@vger.kernel.org>; Sat, 12 Feb 2022 12:41:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0q5NHgNKF/DDJR309GaSKrvp8mmMs6IJLxYkxs2KXOQ=;
        b=lssmsuDSx/jmfUdqVxpmE9RUMMoFBQKGo/xgAx0euSguGkdouHp81lGjLchUe7vzsl
         toANxCWVuMCxlmIOjunxclErWfCqCvssNWOCb/CUFJBNHl8Xglg4NDPfx5D7YmAJQ2n3
         0Zwsjd7Gh7kvVVE9QFA0gJIWSJSa0W58Q1g1rIffjLG+QI1oqDec85IT0p9mkEWByPBZ
         u4cJuoVjuufsz2Vv8oVA3Tz8Ibz8fn5dkkkDi8Obdidgc+hUNowV7bbGDo9qV79bbs62
         spX2TSSg5fEBdhVoqyZ2uZ6BbXKVcYV0XUsMLiN9p9ukJZEKUQ22oy2mGuUjXvHUZ092
         fD/Q==
X-Gm-Message-State: AOAM530iffxZ2HR7tDoabh8OaUXj7R1JyZpVpcF16etWlAigtv2q4fcK
        AgGkjbGAqjmMK+Jlt6IxwWkaOWyD2/CXThVDKyoH4kb7l/Vc
X-Google-Smtp-Source: ABdhPJyKaC/VWVtJRdxpc3ez0Z4+1kLzmtBjDcEqf1peJbkyB/ayWMnCw49aWrQ+TVvuSgWLUi9Gs1WaXi9F/ROp1GQrml9E3+za
MIME-Version: 1.0
X-Received: by 2002:a05:6638:d0c:: with SMTP id q12mr4162402jaj.310.1644698486828;
 Sat, 12 Feb 2022 12:41:26 -0800 (PST)
Date:   Sat, 12 Feb 2022 12:41:26 -0800
In-Reply-To: <000000000000f2075605d04f9964@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000011f55805d7d8352c@google.com>
Subject: Re: [syzbot] WARNING in iomap_iter
From:   syzbot <syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com>
To:     djwong@kernel.org, fgheet255t@gmail.com, hch@infradead.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    83e396641110 Merge tag 'soc-fixes-5.17-1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11fe01a4700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88e0a6a3dbf057cf
dashboard link: https://syzkaller.appspot.com/bug?extid=a8e049cd3abd342936b6
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14f8cad2700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132c16ba700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a8e049cd3abd342936b6@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 10 at fs/iomap/iter.c:33 iomap_iter_done fs/iomap/iter.c:33 [inline]
WARNING: CPU: 1 PID: 10 at fs/iomap/iter.c:33 iomap_iter+0x7ca/0x890 fs/iomap/iter.c:78
Modules linked in:
CPU: 1 PID: 10 Comm: kworker/u4:1 Not tainted 5.17.0-rc3-syzkaller-00247-g83e396641110 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: loop0 loop_rootcg_workfn
RIP: 0010:iomap_iter_done fs/iomap/iter.c:33 [inline]
RIP: 0010:iomap_iter+0x7ca/0x890 fs/iomap/iter.c:78
Code: e8 3b 81 83 ff eb 0c e8 34 81 83 ff eb 05 e8 2d 81 83 ff 44 89 e8 48 83 c4 40 5b 41 5c 41 5d 41 5e 41 5f 5d c3 e8 16 81 83 ff <0f> 0b e9 9e fe ff ff e8 0a 81 83 ff 0f 0b e9 d0 fe ff ff e8 fe 80
RSP: 0018:ffffc90000cf73c8 EFLAGS: 00010293
RAX: ffffffff82022d4a RBX: ffffffff80000000 RCX: ffff888011fe9d00
RDX: 0000000000000000 RSI: ffffffff80000000 RDI: 00000fff80000000
RBP: 00000fff80000000 R08: ffffffff82022be1 R09: ffffed100fd4dc19
R10: ffffed100fd4dc19 R11: 0000000000000000 R12: ffffc90000cf75c8
R13: 1ffff9200019eebe R14: 1ffff9200019eeb9 R15: ffffc90000cf75f0
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbf80df2b88 CR3: 000000007e8f6000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __iomap_dio_rw+0xa8e/0x1e00 fs/iomap/direct-io.c:589
 iomap_dio_rw+0x38/0x80 fs/iomap/direct-io.c:680
 ext4_dio_read_iter fs/ext4/file.c:77 [inline]
 ext4_file_read_iter+0x52f/0x6c0 fs/ext4/file.c:128
 lo_rw_aio+0xc75/0x1060
 loop_handle_cmd drivers/block/loop.c:1846 [inline]
 loop_process_work+0x6a4/0x22b0 drivers/block/loop.c:1886
 process_one_work+0x850/0x1130 kernel/workqueue.c:2307
 worker_thread+0xab1/0x1300 kernel/workqueue.c:2454
 kthread+0x2a3/0x2d0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30
 </TASK>

