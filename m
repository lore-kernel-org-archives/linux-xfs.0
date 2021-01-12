Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE791C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 21:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E84623123
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jan 2021 21:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438139AbhALVh3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jan 2021 16:37:29 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:57124 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437159AbhALV3l (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jan 2021 16:29:41 -0500
Received: from relay2-d.mail.gandi.net (unknown [217.70.183.194])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 23F6B3BE43D
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 21:07:37 +0000 (UTC)
X-Originating-IP: 86.192.251.148
Received: from [192.168.1.42] (lfbn-lil-1-1020-148.w86-192.abo.wanadoo.fr [86.192.251.148])
        (Authenticated sender: bastien@esrevart.net)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 9916340005
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jan 2021 21:06:35 +0000 (UTC)
Date:   Tue, 12 Jan 2021 22:06:29 +0100
From:   Bastien Traverse <bastien@esrevart.net>
Subject: [BUG] xfs_corruption_error after creating a swap file
To:     linux-xfs@vger.kernel.org
Message-Id: <TMAUMQ.RILVCKL2FQ501@esrevart.net>
X-Mailer: geary/3.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello everyone,

A couple of weeks back I got an xfs_corruption_error stack trace on my 
rootfs on Arch Linux, a few minutes after creating a swap file an 
enabling it. Here is the process I followed to do so:

    fallocate -l 4G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile none swap defaults 0 0" >> /etc/fstab

And the trace appeared a few minutes later, without me doing much at 
that moment:

```
déc. 27 21:51:01 kernel: XFS (dm-0): Internal error !link at line 491 
of file fs/xfs/xfs_iops.c. Caller xfs_vn_get_link_inline+0x12/0x50 [xfs]
déc. 27 21:51:01 kernel: CPU: 4 PID: 1923 Comm: gmain Not tainted 
5.9.14-arch1-1 #1
déc. 27 21:51:01 kernel: Hardware name: ASUSTeK COMPUTER INC. ZenBook 
UX534FAC_UX534FA/UX534FAC, BIOS UX534FAC.307 04/20/2020
déc. 27 21:51:01 kernel: Call Trace:
déc. 27 21:51:01 kernel: dump_stack+0x6b/0x83
déc. 27 21:51:01 kernel: xfs_corruption_error+0x85/0x90 [xfs]
déc. 27 21:51:01 kernel: ? xfs_vn_get_link_inline+0x12/0x50 [xfs]
déc. 27 21:51:01 kernel: xfs_vn_get_link_inline+0x44/0x50 [xfs]
déc. 27 21:51:01 kernel: ? xfs_vn_get_link_inline+0x12/0x50 [xfs]
déc. 27 21:51:01 kernel: step_into+0x579/0x720
déc. 27 21:51:01 kernel: ? xfs_vn_get_link+0x90/0x90 [xfs]
déc. 27 21:51:01 kernel: walk_component+0x83/0x1b0
déc. 27 21:51:01 kernel: path_lookupat+0x5b/0x190
déc. 27 21:51:01 kernel: filename_lookup+0xbe/0x1d0
déc. 27 21:51:01 kernel: vfs_statx+0x8f/0x140
déc. 27 21:51:01 kernel: __do_sys_newstat+0x47/0x80
déc. 27 21:51:01 kernel: do_syscall_64+0x33/0x40
déc. 27 21:51:01 kernel: entry_SYSCALL_64_after_hwframe+0x44/0xa9
déc. 27 21:51:01 kernel: RIP: 0033:0x7f5192dcc25a
déc. 27 21:51:01 kernel: Code: 00 00 75 05 48 83 c4 18 c3 e8 b2 f7 01 
00 66 90 f3 0f 1e fa 41 89 f8 48 89 f7 48 89 d6 41 83 f8 01 77 2d b8 04 
00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 8b 15 e1 
1b 0d 00 f7
déc. 27 21:51:01 kernel: RSP: 002b:00007f518f82fa68 EFLAGS: 00000246 
ORIG_RAX: 0000000000000004
déc. 27 21:51:01 kernel: RAX: ffffffffffffffda RBX: 00007f5188001650 
RCX: 00007f5192dcc25a
déc. 27 21:51:01 kernel: RDX: 00007f518f82fa70 RSI: 00007f518f82fa70 
RDI: 000055909d4528a0
déc. 27 21:51:01 kernel: RBP: 000055909d4528a0 R08: 0000000000000001 
R09: 00007f5192e630c0
déc. 27 21:51:01 kernel: R10: 00007f5192e62fc0 R11: 0000000000000246 
R12: 0000000000000001
déc. 27 21:51:01 kernel: R13: 000055909d4229b0 R14: 000055909d4229b0 
R15: 000055909d457070
déc. 27 21:51:01 kernel: XFS (dm-0): Corruption detected. Unmount and 
run xfs_repair
```

Stack is a late-2019 laptop (Asus ZenBook UX534FA) with an Intel 660p 
512GB NVMe drive, running Arch Linux with one big LUKS2-encrypted 
partition (besides the ESP) directly formatted with XFS; kernel version 
at the time of the bug was :

    5.9.14-arch1-1 (linux@archlinux) (gcc (GCC) 10.2.0, GNU ld (GNU 
Binutils) 2.35.1) #1 SMP PREEMPT Sat, 12 Dec 2020 14:37:12 +0000

The filesystem was created with the November 2020 Arch Linux ISO 
(kernel 5.9.2) and command `mkfs.xfs -m rmapbt=1 -L system 
/dev/mapper/root`.  Here is the xfs_info output for said rootfs:

```
meta-data=/dev/mapper/root isize=512 agcount=4, agsize=31224405 blks
         = sectsz=512 attr=2, projid32bit=1
         = crc=1 finobt=1, sparse=1, rmapbt=1
         = reflink=1
data = bsize=4096 blocks=124897617, imaxpct=25
         = sunit=0 swidth=0 blks
naming =version 2 bsize=4096 ascii-ci=0, ftype=1
log =internal log bsize=4096 blocks=60985, version=2
         = sectsz=512 sunit=0 blks, lazy-count=1
realtime =none extsz=4096 blocks=0, rtextents=0
```

dm-crypt is configured with `allow_discards` and periodic fstrim method 
is used; the fs is mounted only with `noatime` option besides the 
defaults:

    % findmnt /
TARGET SOURCE FSTYPE OPTIONS
/ /dev/mapper/root xfs 
rw,noatime,attr2,inode64,logbufs=8,logbsize=32k,noquota

And that's all I can think of to provide for context.

I rebooted on a Grml live ISO and ran xfs_repair, which found a few 
thing that I unfortunately didn't/couldn't copy (virtual console 
scrolling and the output disappeared...).
I haven't had any issues since, or none that I realized at least.

That's all for this report, if you have any hints please say so!

Thanks for reading,

PS: please Cc me when replying as I am not subscribed to the list!

Cheers,
Bastien


