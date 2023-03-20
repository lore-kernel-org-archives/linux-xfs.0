Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82B7C6FD1D
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Mar 2023 05:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjCTFUp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Mar 2023 01:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCTFUo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2023 01:20:44 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F8AE3AF
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 22:20:42 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s19so591098pgi.0
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 22:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679289641;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T9HTYkz9UZ4i3XAvgU8XyjHSLEnB2A6ypPsG2QB1Qjw=;
        b=hjaYTEOlPWNFEuOxxM4TMoPqEWD6nG6Sn3veK5UqUQeForn9a+xieQmYN0CSoKPvRQ
         Slbq70BSeWUyWhFg1JHe6NqSrmCcJEzonXK4zi74PnbYx1yUDrtWq+SvSpXCh3mWA3lT
         rOT44B39Wyr+eCLC1BuG0cNxsJ5A3FA4hm2qa2OgeaUd5AhEhAeezR25QxbyJOJOx4tm
         oV+t+G0eTk2GxFsevCXpEtfGAzfgkc0u+WqYzCJUMNPVZPpe/ngY7tII/9s4y2rROWD0
         eW+N/rGVokMRtQSkHS4EQNOkjW6MXtkCItwbfR6B39CFXDFwmQ1cSBSWIgGiIT3Z9ZJc
         8RUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679289641;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T9HTYkz9UZ4i3XAvgU8XyjHSLEnB2A6ypPsG2QB1Qjw=;
        b=SalcqEKwbQs/fnXZyECrsIS+yB1iyjpDY1e+1XuPU6DYScJlpIj5it2ARGeIEmSBgw
         ekqRu6te8IqwXIYzQ+/LGmQUTdst1Ntix3qC2Kj8Iwmx/oZp8LoxpOu8d0oWIiGA07nI
         tqwn86IIF0p+plQkrxB5l8AO4arCmOO2Yqsc17EBdezbn6t6V7OZrbSbErs3MXo0bnRC
         6/e/9L7MmVjSN0Q3eqmoVZEM/LLC05kQfx3+o5ysRjylhNGD2wya24q/frD3mZvkBbFB
         YghAElrFvGe/Lom8Gvc/ZhyTbzIi4ZCH1jnxXHIVcmHatBYTj1DvbevzBSdkxjmDdK5y
         Hovg==
X-Gm-Message-State: AO0yUKX5CrPxzPyxW3/iPiUUITw1QW1Vft0fbP91TzF2zFvU3E1Ak9Wd
        O5RMODSG2kqi7NgoYP45SiSl8zakIHs=
X-Google-Smtp-Source: AK7set96U6/T4YIRYDEACgvrq1yXlykZ0CxIi9N+US61F7f1THuP8tAsYjFor+zEuiDVwnkHCAXSrA==
X-Received: by 2002:a05:6a00:4287:b0:625:524b:9712 with SMTP id bx7-20020a056a00428700b00625524b9712mr10490238pfb.2.1679289641448;
        Sun, 19 Mar 2023 22:20:41 -0700 (PDT)
Received: from rh-tp ([129.41.58.22])
        by smtp.gmail.com with ESMTPSA id j6-20020a62e906000000b00625e885a6ffsm5557082pfh.18.2023.03.19.22.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 22:20:40 -0700 (PDT)
Date:   Mon, 20 Mar 2023 10:50:07 +0530
Message-Id: <87zg88atiw.fsf@doe.com>
From:   Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     shrikanth hegde <sshegde@linux.vnet.ibm.com>, dchinner@redhat.com,
        linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
Subject: Re: xfs: system fails to boot up due to Internal error xfs_trans_cancel
In-Reply-To: <20230318192059.GX11376@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"Darrick J. Wong" <djwong@kernel.org> writes:

> On Sat, Mar 18, 2023 at 10:20:28PM +0530, Ritesh Harjani wrote:
>> "Darrick J. Wong" <djwong@kernel.org> writes:
>>
>> > On Wed, Mar 15, 2023 at 10:20:37PM -0700, Darrick J. Wong wrote:
>> >> On Thu, Mar 16, 2023 at 10:16:02AM +0530, Ritesh Harjani wrote:
>> >> > "Darrick J. Wong" <djwong@kernel.org> writes:
>> >> >
>> >> > Hi Darrick,
>> >> >
>> >> > Thanks for your analysis and quick help on this.
>> >> >
>> >> > >>
>> >> > >> Hi Darrick,
>> >> > >>
>> >> > >> Please find the information collected from the system. We added some
>> >> > >> debug logs and looks like it is exactly what is happening which you
>> >> > >> pointed out.
>> >> > >>
>> >> > >> We added a debug kernel patch to get more info from the system which
>> >> > >> you had requested [1]
>> >> > >>
>> >> > >> 1. We first breaked into emergency shell where root fs is first getting
>> >> > >> mounted on /sysroot as "ro" filesystem. Here are the logs.
>> >> > >>
>> >> > >> [  OK  ] Started File System Check on /dev/mapper/rhel_ltcden3--lp1-root.
>> >> > >>          Mounting /sysroot...
>> >> > >> [    7.203990] SGI XFS with ACLs, security attributes, quota, no debug enabled
>> >> > >> [    7.205835] XFS (dm-0): Mounting V5 Filesystem 7b801289-75a7-4d39-8cd3-24526e9e9da7
>> >> > >> [   ***] A start job is running for /sysroot (15s / 1min 35s)[   17.439377] XFS (dm-0): Starting recovery (logdev: internal)
>> >> > >> [  *** ] A start job is running for /sysroot (16s / 1min 35s)[   17.771158] xfs_log_mount_finish: Recovery needed is set
>> >> > >> [   17.771172] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:0
>> >> > >> [   17.771179] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:1
>> >> > >> [   17.771184] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:2
>> >> > >> [   17.771190] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:3
>> >> > >> [   17.771196] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:4
>> >> > >> [   17.771201] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:5
>> >> > >> [   17.801033] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:6
>> >> > >> [   17.801041] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:7
>> >> > >> [   17.801046] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:8
>> >> > >> [   17.801052] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:9
>> >> > >> [   17.801057] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:10
>> >> > >> [   17.801063] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:11
>> >> > >> [   17.801068] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:12
>> >> > >> [   17.801272] xlog_recover_iunlink_bucket: bucket: 13, agino: 3064909, ino: 3064909, iget ret: 0, previno:18446744073709551615, prev_agino:4294967295
>> >> > >>
>> >> > >> <previno, prev_agino> is just <-1 %ull and -1 %u> in above. That's why
>> >> > >> the huge value.
>> >> > >
>> >> > > Ok, so log recovery finds 3064909 and clears it...
>> >> > >
>> >> > >> [   17.801281] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:13
>> >> > >> [   17.801287] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:0, bucket:14
>> >> > >
>> >> > > <snip the rest of these...>
>> >> > >
>> >> > >> [   17.844910] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:62
>> >> > >> [   17.844916] xlog_recover_iunlink_ag: ran xlog_recover_iunlink_bucket for agi:3, bucket:63
>> >> > >> [   17.886079] XFS (dm-0): Ending recovery (logdev: internal)
>> >> > >> [  OK  ] Mounted /sysroot.
>> >> > >> [  OK  ] Reached target Initrd Root File System.
>> >> > >>
>> >> > >>
>> >> > >> 2. Then these are the logs from xfs_repair -n /dev/dm-0
>> >> > >> Here you will notice the same agi 3064909 in bucket 13 (from phase-2) which got also
>> >> > >> printed in above xlog_recover_iunlink_ag() function.
>> >> > >>
>> >> > >> switch_root:/# xfs_repair -n /dev/dm-0
>> >> > >> Phase 1 - find and verify superblock...
>> >> > >> Phase 2 - using internal log
>> >> > >>         - zero log...
>> >> > >>         - scan filesystem freespace and inode maps...
>> >> > >> agi unlinked bucket 13 is 3064909 in ag 0 (inode=3064909)
>> >> > >
>> >> > > ...yet here we find that 3064909 is still on the unlinked list?
>> >> > >
>> >> > > Just to confirm -- you ran xfs_repair -n after the successful recovery
>> >> > > above, right?
>> >> > >
>> >> > Yes, that's right.
>> >> >
>> >> > >>         - found root inode chunk
>> >> > >> Phase 3 - for each AG...
>> >> > >>         - scan (but don't clear) agi unlinked lists...
>> >> > >>         - process known inodes and perform inode discovery...
>> >> > >>         - agno = 0
>> >> > >>         - agno = 1
>> >> > >>         - agno = 2
>> >> > >>         - agno = 3
>> >> > >>         - process newly discovered inodes...
>> >> > >> Phase 4 - check for duplicate blocks...
>> >> > >>         - setting up duplicate extent list...
>> >> > >>         - check for inodes claiming duplicate blocks...
>> >> > >>         - agno = 0
>> >> > >>         - agno = 2
>> >> > >>         - agno = 1
>> >> > >>         - agno = 3
>> >> > >> No modify flag set, skipping phase 5
>> >> > >> Phase 6 - check inode connectivity...
>> >> > >>         - traversing filesystem ...
>> >> > >>         - traversal finished ...
>> >> > >>         - moving disconnected inodes to lost+found ...
>> >> > >> Phase 7 - verify link counts...
>> >> > >> would have reset inode 3064909 nlinks from 4294967291 to 2
>> >> > >
>> >> > > Oh now that's interesting.  Inode on unlinked list with grossly nonzero
>> >> > > (but probably underflowed) link count.  That might explain why iunlink
>> >> > > recovery ignores the inode.  Is inode 3064909 reachable via the
>> >> > > directory tree?
>> >> > >
>> >> > > Would you mind sending me a metadump to play with?  metadump -ago would
>> >> > > be best, if filenames/xattrnames aren't sensitive customer data.
>> >> >
>> >> > Sorry about the delay.
>> >> > I am checking for any permissions part internally.
>> >> > Meanwhile - I can help out if you would like me to try anything.
>> >>
>> >> Ok.  I'll try creating a filesystem with a weirdly high refcount
>> >> unlinked inode and I guess you can try it to see if you get the same
>> >> symptoms.  I've finished with my parent pointers work for the time
>> >> being, so I might have some time tomorrow (after I kick the tires on
>> >> SETFSUUID) to simulate this and see if I can adapt the AGI repair code
>> >> to deal with this.
>> >
>> > If you uncompress and mdrestore the attached file to a blockdev, mount
>> > it, and run some creat() exerciser, do you get the same symptoms?  I've
>> > figured out how to make online fsck deal with it. :)
>> >
>> > A possible solution for runtime would be to make it so that
>> > xfs_iunlink_lookup could iget the inode if it's not in cache at all.
>> >
>>
>> Hello Darrick,
>>
>> I did xfs_mdrestore the metadump you provided on a loop mounted
>> blockdev. I ran fsstress on the root dir of the mounted filesystem,
>> but I was unable to hit the issue.
>>
>> I tried the same with the original FS metadump as well and I am unable
>> to hit the issue while running fsstress on the filesystem.
>>
>> I am thinking of identifying which file unlink operation was in progress
>> when we see the issue during mounting. Maybe that will help in
>> recreating the issue.
>
> Yeah, creating a bunch of O_TMPFILE files will exercise the unlinked
> lists, possibly enough to trip over the affected agi bucket.  See
> t_open_tmpfiles.c in the fstests repo.


Hello Darrick,

Yes, I am tripping over the issue very easily when I run t_open_tmpfiles
testcase for the metadump you shared. (Not hitting with the original dump
though. Will try to fetch more information on whay is that).

Here is the call stack with your metadump when we try to run
t_open_tmpfiles test case.
Its the same warning message which we were hitting too in the original
case too.

xfs_iunlink_lookup()
<...>
    /*
	 * Inode not in memory or in RCU freeing limbo should not happen.
	 * Warn about this and let the caller handle the failure.
	 */
	if (WARN_ON_ONCE(!ip || !ip->i_ino)) {
		rcu_read_unlock();
		return NULL;
	}
<...>

[43873.070585] xfs filesystem being mounted at /mnt1/scratch supports timestamps until 2038 (0x7fffffff)
root@ubuntu:~# [43905.483065] ------------[ cut here ]------------
[43905.485250] WARNING: CPU: 0 PID: 2379 at fs/xfs/xfs_inode.c:1839 xfs_iunlink_lookup+0x14c/0x1e0
[43905.488325] Modules linked in:
[43905.489594] CPU: 0 PID: 2379 Comm: t_open_tmpfiles Not tainted 6.3.0-rc2-xfstests-00051-gc1940a43e595 #57
[43905.492828] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[43905.496604] RIP: 0010:xfs_iunlink_lookup+0x14c/0x1e0
[43905.498341] Code: 0f 85 6e ff ff ff 48 c7 c2 a8 95 be 82 be 22 03 00 00 48 c7 c7 30 23 b7 82 c6 05 c8 71 84 01 01 e8 e9 d3 91 ff e9 6
[43905.504324] RSP: 0018:ffffc9000405fb98 EFLAGS: 00010246
[43905.506224] RAX: 0000000000000000 RBX: 0000000000001b43 RCX: 0000000000000000
[43905.508624] RDX: ffff8891f1edf488 RSI: ffff8891f1edf4c8 RDI: 0000000000001b43
[43905.511087] RBP: 0000000000001b43 R08: 0000000000000000 R09: ffff88931446ba80
[43905.514465] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[43905.517947] R13: ffff889313f67840 R14: ffff8892c0155b00 R15: ffff8889dc9b2900
[43905.521519] FS:  00007ffff7fb2740(0000) GS:ffff889dc7600000(0000) knlGS:0000000000000000
[43905.525570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[43905.528402] CR2: 0000555555556060 CR3: 00000011b4790006 CR4: 0000000000170ef0
[43905.532008] Call Trace:
[43905.533399]  <TASK>
[43905.534473]  xfs_iunlink_insert_inode+0x7a/0x100
[43905.536663]  xfs_iunlink+0xa4/0x190
[43905.537962]  xfs_create_tmpfile+0x277/0x2e0
[43905.539654]  xfs_generic_create+0x100/0x350
[43905.541303]  xfs_vn_tmpfile+0x1f/0x40
[43905.542920]  vfs_tmpfile+0x10e/0x1b0
[43905.544307]  path_openat+0x157/0x200
[43905.545813]  do_filp_open+0xad/0x150
[43905.547213]  ? alloc_fd+0x12d/0x220
[43905.548646]  ? alloc_fd+0x12d/0x220
[43905.550014]  ? lock_release+0x7f/0x130
[43905.551435]  ? do_raw_spin_unlock+0x4f/0xa0
[43905.553045]  ? _raw_spin_unlock+0x2d/0x50
[43905.554554]  ? alloc_fd+0x12d/0x220
[43905.556264]  do_sys_openat2+0x9b/0x160
[43905.557680]  __x64_sys_openat+0x58/0xa0
[43905.559065]  do_syscall_64+0x3f/0x90
[43905.560589]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[43905.562377] RIP: 0033:0x7ffff7d0ca45
[43905.563970] Code: 75 53 89 f0 25 00 00 41 00 3d 00 00 41 00 74 45 80 3d a6 1b 0f 00 00 74 69 89 da 48 89 ee bf 9c ff ff ff b8 01 01 5
[43905.570038] RSP: 002b:00007fffffffe2c0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
[43905.572747] RAX: ffffffffffffffda RBX: 0000000000410002 RCX: 00007ffff7d0ca45
[43905.575246] RDX: 0000000000410002 RSI: 0000555555556057 RDI: 00000000ffffff9c
[43905.577782] RBP: 0000555555556057 R08: 000000000000ab7f R09: 00007ffff7fc1080
[43905.580315] R10: 00000000000001a4 R11: 0000000000000202 R12: 0000000000000000
[43905.582850] R13: 00007fffffffe4a0 R14: 0000555555557d68 R15: 00007ffff7ffd020
[43905.585438]  </TASK>
[43905.586528] irq event stamp: 14045
[43905.587828] hardirqs last  enabled at (14055): [<ffffffff8121bc02>] __up_console_sem+0x52/0x60
[43905.590861] hardirqs last disabled at (14066): [<ffffffff8121bbe7>] __up_console_sem+0x37/0x60
[43905.593856] softirqs last  enabled at (13920): [<ffffffff82231b5a>] __do_softirq+0x2ea/0x3e1
[43905.596813] softirqs last disabled at (13909): [<ffffffff8119573f>] irq_exit_rcu+0xdf/0x140
[43905.599766] ---[ end trace 0000000000000000 ]---
[43905.601450] XFS (loop7): Internal error xfs_trans_cancel at line 1097 of file fs/xfs/xfs_trans.c.  Caller xfs_create_tmpfile+0x1c6/00
[43905.606100] CPU: 0 PID: 2379 Comm: t_open_tmpfiles Tainted: G        W          6.3.0-rc2-xfstests-00051-gc1940a43e595 #57
[43905.609797] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.15.0-0-g2dd4b9b3f840-prebuilt.qemu.org 04/01/2014
[43905.614562] Call Trace:
[43905.616112]  <TASK>
[43905.617245]  dump_stack_lvl+0x66/0x80
[43905.619054]  xfs_trans_cancel+0x138/0x1f0
[43905.620898]  xfs_create_tmpfile+0x1c6/0x2e0
[43905.623140]  xfs_generic_create+0x100/0x350
[43905.625483]  xfs_vn_tmpfile+0x1f/0x40
[43905.627372]  vfs_tmpfile+0x10e/0x1b0
[43905.629413]  path_openat+0x157/0x200
[43905.631204]  do_filp_open+0xad/0x150
[43905.633050]  ? alloc_fd+0x12d/0x220
[43905.634844]  ? alloc_fd+0x12d/0x220
[43905.636602]  ? lock_release+0x7f/0x130
[43905.638479]  ? do_raw_spin_unlock+0x4f/0xa0
[43905.640726]  ? _raw_spin_unlock+0x2d/0x50
[43905.642916]  ? alloc_fd+0x12d/0x220
[43905.644375]  do_sys_openat2+0x9b/0x160
[43905.645763]  __x64_sys_openat+0x58/0xa0
[43905.647145]  do_syscall_64+0x3f/0x90
[43905.648685]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[43905.650430] RIP: 0033:0x7ffff7d0ca45
[43905.651731] Code: 75 53 89 f0 25 00 00 41 00 3d 00 00 41 00 74 45 80 3d a6 1b 0f 00 00 74 69 89 da 48 89 ee bf 9c ff ff ff b8 01 01 5
[43905.657637] RSP: 002b:00007fffffffe2c0 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
[43905.660141] RAX: ffffffffffffffda RBX: 0000000000410002 RCX: 00007ffff7d0ca45
[43905.662525] RDX: 0000000000410002 RSI: 0000555555556057 RDI: 00000000ffffff9c
[43905.665086] RBP: 0000555555556057 R08: 000000000000ab7f R09: 00007ffff7fc1080
[43905.667455] R10: 00000000000001a4 R11: 0000000000000202 R12: 0000000000000000
[43905.669830] R13: 00007fffffffe4a0 R14: 0000555555557d68 R15: 00007ffff7ffd020
[43905.672193]  </TASK>
[43905.689666] XFS (loop7): Corruption of in-memory data (0x8) detected at xfs_trans_cancel+0x151/0x1f0 (fs/xfs/xfs_trans.c:1098).  Shu.
[43905.694215] XFS (loop7): Please unmount the filesystem and rectify the problem(s)


-ritesh


>
> --D
>
>> Although the xfs_repair -n does show a similar log of unlinked inode
>> with the metadump you provided.
>>
>> root@ubuntu:~# xfs_repair -n -o force_geometry /dev/loop7
>> Phase 1 - find and verify superblock...
>> Phase 2 - using internal log
>>         - zero log...
>>         - scan filesystem freespace and inode maps...
>> agi unlinked bucket 3 is 6979 in ag 0 (inode=6979)
>> agi unlinked bucket 4 is 6980 in ag 0 (inode=6980)
>>         - found root inode chunk
>> Phase 3 - for each AG...
>>         - scan (but don't clear) agi unlinked lists...
>>         - process known inodes and perform inode discovery...
>>         - agno = 0
>>         - process newly discovered inodes...
>> Phase 4 - check for duplicate blocks...
>>         - setting up duplicate extent list...
>>         - check for inodes claiming duplicate blocks...
>>         - agno = 0
>> No modify flag set, skipping phase 5
>> Phase 6 - check inode connectivity...
>>         - traversing filesystem ...
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
>> disconnected inode 6979, would move to lost+found
>> disconnected inode 6980, would move to lost+found
>> Phase 7 - verify link counts...
>> would have reset inode 6979 nlinks from 5555 to 1
>> would have reset inode 6980 nlinks from 0 to 1
>> No modify flag set, skipping filesystem flush and exiting.
>>
>> Thanks again for the help. Once I have more info I will update the
>> thread!
>>
>> -ritesh
