Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BB4C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  9 May 2022 02:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiEICvG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 May 2022 22:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiEICuy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 22:50:54 -0400
Received: from smtp1.onthe.net.au (smtp1.onthe.net.au [203.22.196.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B3D4326E5
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 19:47:01 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 85C6E60F52
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 12:46:59 +1000 (EST)
Received: from smtp1.onthe.net.au ([10.200.63.11])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10028)
        with ESMTP id KHX1uYDZy8FU for <linux-xfs@vger.kernel.org>;
        Mon,  9 May 2022 12:46:59 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp1.onthe.net.au (Postfix) with ESMTP id 4BAC860EAB
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 12:46:59 +1000 (EST)
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id 313506802DC; Mon,  9 May 2022 12:46:59 +1000 (AEST)
Date:   Mon, 9 May 2022 12:46:59 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     linux-xfs@vger.kernel.org
Subject: Highly reflinked and fragmented considered harmful?
Message-ID: <20220509024659.GA62606@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

Is it to be expected that removing 29TB of highly reflinked and 
fragmented data could take days, the entire time blocking other tasks 
like "rm" and "df" on the same filesystem?

- is any way to see progress and make an eta estimate?
- would 4700+ processes blocked on the same fs slow things down or they're 
   not relevant?
- with a reboot/remount, does the log replay continue from where it left 
   off, or start again?
- is there anything that might improve the situation in newer kernels?

Some details:

# uname -r
5.15.34-otn-00007-g6bff5dd37abb

# xfs_info /chroot
meta-data=/dev/mapper/vg00-chroot isize=512    agcount=282, agsize=244184192 blks
          =                       sectsz=4096  attr=2, projid32bit=1
          =                       crc=1        finobt=1, sparse=1, rmapbt=1
          =                       reflink=1    bigtime=0 inobtcount=0
data     =                       bsize=4096   blocks=68719475712, imaxpct=1
          =                       sunit=128    swidth=512 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=521728, version=2
          =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

The fs is sitting on lvm and the underlying block device is a ceph 8+3 
erasure-coded rbd.

This fs was originally 30T and has been expanded to 256T:

   Limits to growth
   https://www.spinics.net/lists/linux-xfs/msg60451.html

And it's been the topic of a few other issues:

   Extreme fragmentation ho!
   https://www.spinics.net/lists/linux-xfs/msg47707.html

   Mysterious ENOSPC
   https://www.spinics.net/lists/linux-xfs/msg55446.html

The story...

I did an "rm -rf" of a directory containing a "du"-indicated 29TB spread 
over maybe 50 files. The data would have been highly reflinked and 
fragmented. A large part of the reflinking would be to files outside the 
dir in question, and I imagine maybe only 2-3TB of data would actually 
be freed by the "rm".

The "rm" completed in less than a second, but an immediately following 
"df" on that fs didn't return, even 60+ hours later(!!).

In the meantime, other background processes where also attempting to do 
various "rm"s (small amounts of non-reflinked data) and "df"s on the 
same fs which were also hanging - building up to an load average of 
4700+(!!) over time. A flame graph showed the kernel with 75% idle and 
3.75% xfsaild as the largest users, and the rest a wide variety of other 
uninteresting stuff. A "sysrq w" showed the tasks blocking in 
xfs_inodegc_flush, e.g.:

May 06 09:49:29 d5 kernel: task:df              state:D stack:    0 pid:32738 ppid:     1 flags:0x00000004
May 06 09:49:29 d5 kernel: Call Trace:
May 06 09:49:29 d5 kernel:  <TASK>
May 06 09:49:29 d5 kernel:  __schedule+0x241/0x740
May 06 09:49:29 d5 kernel:  schedule+0x3a/0xa0
May 06 09:49:29 d5 kernel:  schedule_timeout+0x271/0x310
May 06 09:49:29 d5 kernel:  ? find_held_lock+0x2d/0x90
May 06 09:49:29 d5 kernel:  ? sched_clock_cpu+0x9/0xa0
May 06 09:49:29 d5 kernel:  ? lock_release+0x214/0x350
May 06 09:49:29 d5 kernel:  wait_for_completion+0x7b/0xc0
May 06 09:49:29 d5 kernel:  __flush_work+0x217/0x350
May 06 09:49:29 d5 kernel:  ? flush_workqueue_prep_pwqs+0x120/0x120
May 06 09:49:29 d5 kernel:  ? wait_for_completion+0x1c/0xc0
May 06 09:49:29 d5 kernel:  xfs_inodegc_flush.part.24+0x62/0xc0 [xfs]
May 06 09:49:29 d5 kernel:  xfs_fs_statfs+0x37/0x1a0 [xfs]
May 06 09:49:29 d5 kernel:  statfs_by_dentry+0x3c/0x60
May 06 09:49:29 d5 kernel:  vfs_statfs+0x16/0xd0
May 06 09:49:29 d5 kernel:  user_statfs+0x44/0x80
May 06 09:49:29 d5 kernel:  __do_sys_statfs+0x10/0x30
May 06 09:49:29 d5 kernel:  do_syscall_64+0x34/0x80
May 06 09:49:29 d5 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
May 06 09:49:29 d5 kernel: RIP: 0033:0x7f2adb25ec07
May 06 09:49:29 d5 kernel: RSP: 002b:00007ffe074c81d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000089
May 06 09:49:29 d5 kernel: RAX: ffffffffffffffda RBX: 00005604e08f93c0 RCX: 00007f2adb25ec07
May 06 09:49:29 d5 kernel: RDX: 00007ffe074c8460 RSI: 00007ffe074c81e0 RDI: 00005604e08f93c0
May 06 09:49:29 d5 kernel: RBP: 00007ffe074c81e0 R08: 00005604e08f9400 R09: 0000000000000000
May 06 09:49:29 d5 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe074c8280
May 06 09:49:29 d5 kernel: R13: 0000000000000000 R14: 00005604e08f9400 R15: 00005604e08f93c0
May 06 09:49:29 d5 kernel:  </TASK>

Iostat showed consistent high %util and high latencies. E.g. a combined 
load average and iostat output at 66 hours after the initial "df" 
started:

            load %user %nice  %sys  %iow  %stl %idle  dev rrqm/s wrqm/s    r/s    w/s    rkB/s    wkB/s  arq-sz  aqu-sz    await   rwait   wwait %util
07:55:32 4772.3   0.0   0.0   0.2   0.8   0.0  98.8 rbd0    0.0    0.0    0.5   27.9     1.80   530.20   37.46   25.87   911.07   34.67   925.2  97.0
07:55:52 4772.1   0.0   0.0   0.2   0.0   0.0  99.7 rbd0    0.0    0.0    0.9   17.2     3.60   548.20   60.97    7.64   422.22   11.83   443.7  99.2
07:56:12 4772.1   0.0   0.0   0.3   1.9   0.0  97.6 rbd0    0.0    0.5    0.2   46.9     1.00   513.00   21.80   46.06   976.91  304.40   980.5  96.3
07:56:32 4773.1   0.0   0.0   0.3   1.7   0.0  97.8 rbd0    0.0    0.0    0.5   12.9     1.80   306.20   45.97    6.81   508.09    4.67   525.6  57.8
07:56:52 4773.8   0.0   0.0   0.3   1.4   0.0  98.0 rbd0    0.0    0.1    0.7   40.4     2.60   591.80   28.96   32.70   796.60  163.23   806.8  92.2
07:57:12 4774.4   0.1   0.0   0.3   1.8   0.0  97.7 rbd0    0.0    0.3    0.2   43.1     0.80   541.80   25.06   42.13   973.05   15.25   977.5  84.0
07:57:32 4774.8   0.2   0.0   0.7   2.3   0.0  96.5 rbd0    0.0    0.1    0.5   35.2     2.00   496.40   27.92   30.25   847.35    9.00   859.3  85.7
07:57:52 4775.4   0.0   0.0   0.4   1.6   0.0  97.7 rbd0    0.0    0.2    0.7   45.1     2.80   510.80   22.43   42.88   936.33   76.21   949.7  73.6

Apart from the iostat there was no other indication any progress was 
being made.

Eventually I thought that perhaps the excessive numbers of blocked 
processes might be adding to the woes by causing thundering herd 
problems and the like, and decided to reboot the box as the only way to 
remove those tasks, with the understanding the journal to be replayed 
before the fs mount would complete.

There were few more reboots and mount(-attempts) over the next day as I 
was messing around with things - turning off the background processes 
causing the ever-increasing loads, taking lvm snapshots, upgrading to 
the latest stable version of the kernel etc.

I'm now wondering if each mount continues from whence the previous 
mount(-attempt) left off, or does it start processing the replay log 
again from the very beginning?

It's now been 40 hours since the most recent reboot/mount and the mount 
process is still running. The load average is a more reasonable <10, and 
the iostat is similar to above.

Is there any way to see where the log replay is up to, and from there 
make a judgement on how much longer it might take, e.g. something in 
xfs_db, or some eBPF wizardry?

I tried using xfs_logprint but I'm not sure what it's telling me, and 
multiple versions taken 10 minutes apart don't show any differences that 
are obviously "progress" - the only differences are in q:0x[[:xdigit:]]+ 
in the TRANS entries, and in a:0x[[:xdigit:]]+ in the INO entries, e.g.:

t1:
TRANS: tid:0xcf6e0775  #items:50029  trans:0xcf6e0775  q:0x563417886560
...
INO: cnt:2 total:2 a:0x563419435920 len:56 a:0x5634194359c0 len:176
         INODE: #regs:2   ino:0x48000698b  flags:0x1   dsize:0
         CORE inode:
                 magic:IN  mode:0x81a4  ver:3  format:3
                 uid:1952  gid:1952  nlink:0 projid:0x00000000
                 atime:1616462862  mtime:1651077084  ctime:1651634628
                 flushiter:0
                 size:0x0  nblks:0xdbcfc47  exsize:0  nextents:1676364  anextents:0
                 forkoff:0  dmevmask:0x0  dmstate:0  flags:0x0  gen:4176048690
                 flags2 0x2 cowextsize 0x0

t1+10s:
TRANS: tid:0xcf6e0775  #items:50029  trans:0xcf6e0775  q:0x55b5d8815560
...
INO: cnt:2 total:2 a:0x55b5da3c4920 len:56 a:0x55b5da3c49c0 len:176
         INODE: #regs:2   ino:0x48000698b  flags:0x1   dsize:0
         CORE inode:
                 magic:IN  mode:0x81a4  ver:3  format:3
                 uid:1952  gid:1952  nlink:0 projid:0x00000000
                 atime:1616462862  mtime:1651077084  ctime:1651634628
                 flushiter:0
                 size:0x0  nblks:0xdbcfc47  exsize:0  nextents:1676364  anextents:0
                 forkoff:0  dmevmask:0x0  dmstate:0  flags:0x0  gen:4176048690
                 flags2 0x2 cowextsize 0x0


Cheers,

Chris
