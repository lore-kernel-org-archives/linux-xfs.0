Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:57076 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726719AbfA1Uli (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Jan 2019 15:41:38 -0500
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 5A1242C38F
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jan 2019 20:41:37 +0000 (UTC)
From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 202441] New: Possibly vfs cache related replicable xfs
 regression since 4.19.0  on sata hdd:s
Date: Mon, 28 Jan 2019 20:41:36 +0000
Message-ID: <bug-202441-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202441

            Bug ID: 202441
           Summary: Possibly vfs cache related replicable xfs regression
                    since 4.19.0  on sata hdd:s
           Product: File System
           Version: 2.5
    Kernel Version: 4.19.0 - 5.0-rc3
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: rogan6710@gmail.com
        Regression: Yes

I have a file system related problem where a compile job on a sata hdd almost
stops and ui becomes unresponsive when copying large files at the same time,
regardless of to what disk or from where they are copied.

All testing has been done on "bare metal" without even md, lvm or similar.
I have done a lot of testing of many different kernel versions on two different
systems (Slackware 14.2 and "current") and I feel confident that this is a
kernel regression.

The problem is _very_ pronounced when using xfs and it is only present from
kernel version 4.19.0 and all following versions NOT before (I have not tested
any 4.19 rc versions). I have tested many of them including the latest 4.19.18
and 5.0-rc3 with varying configurations and some very limited testing on
4.20.4.

It affects jfs, ext2, ext3, ext4 also but to a much lesser extent.
btrfs and reiserfs does not seem to be affected at all, at least not on the
4.19 series.

After adding another 16GB ram on one of my testing machines I noticed that it
took much more time before the compile job slowed down and ui became
unresponsive, so I suspected some cache related issue.
I made a few test runs and while watching "top" I observed that as soon as
buff/cache passed ~ 23G (total 24G) while copying, the compile job slowed down
to almost a halt, while the copying also slowed down significantly.

After echo 0 >/proc/sys/vm/vfs_cache_pressure the compilation runs without
slowdown all the way through, while copying retains its steady +100MB/sec.
This "solution" is tested on 4.19.17-18 with "generic" Slackware config
and 5.0-rc3 both on xfs.

Here's how I hit this issue every time on a pre-zen AMD:

1. A decent amount of data to copy, probably at least 5-10 times as much as ram
and reasonably fast media (~100Mb/sec) to copy from and to (Gbit nfs mount,
usb3 drive, regular hard drive...).

2. A dedicated xfs formatted regular rotating hard drive for the compile job (I
suppose any io-latency sensitive parallellizable job will do), This problem is
probably present for ssd's as well, but because they are so fast, cache becomes
less of an issue and you will maybe not notice much, at least I don't.

Compile job: defconfig linux kernel compile (parallellizable easy to redo).
Now open a few terminals with "top" in one of them, start copying in another
(use mc, easy to start and stop). Watch buff/cache grow in top, as is reaches
to within 70-80% of your ram, start compilation in another terminal, I use
"time make -j16" on my eight core 9590 AMD.

Under these circumstances a defconfig kernel compile (ver 4.19.17) takes about
3min 35s on 4.18.20 (xfs) and sometimes more than an hour using any version
after it. On Slackware "current" I use gcc 8.2.0 multilib, on 14.2 regular gcc
5.5.0 which seemed to produce slightly better results.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
