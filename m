Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC7DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 15:59:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbiERP7K (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 11:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239760AbiERP7H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 11:59:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CFA1312BE
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 08:59:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 025E0B81E98
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 15:59:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9139C385A9;
        Wed, 18 May 2022 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652889540;
        bh=Ooljdpo1Mls7J2uEpbX7KdzSswWRfopmEB0o7Pv7LEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BkZytvtAbNvD6LUqmDlepzZeLRiuCvyga5yQfGU4e/Zni/r6yQIdmP3cdQN4uyEUi
         /qwOWGFy2PwzbUyb/DObM7PWZcr3W+Hi//33vFrLbaqWixh1GlDgzk8aedsY1XvvdR
         h+lzutwjJmYr1uvKgNcXjwcjw49FEQqUQS0e4ANtwq8y5elicwyXW+jO42gNNt1WCY
         ++kCaiaIUWdXJzlF4AO9EBXJjrpl7tlIZfF09D+HLrwYhBFF2M6TmhO5CBZ53jAL5d
         sp92JF+lUfBzLKULls1uulFbIrKR+D16Gz0+RzbYgQX0iSheVe+oQ6LIHGnBEXcPFJ
         vEEqLbpHqhdmw==
Date:   Wed, 18 May 2022 08:59:00 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: fstrim and strace considered harmful?
Message-ID: <YoUXxBe1d7b29wif@magnolia>
References: <20220518065949.GA1237408@onthe.net.au>
 <20220518070713.GA1238882@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518070713.GA1238882@onthe.net.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 05:07:13PM +1000, Chris Dunlop wrote:
> Oh, sorry... on linux v5.15.34
> 
> On Wed, May 18, 2022 at 04:59:49PM +1000, Chris Dunlop wrote:
> > Hi,
> > 
> > I have an fstrim that's been running for over 48 hours on a 256T thin
> > provisioned XFS fs containing around 55T of actual data on a slow
> > subsystem (ceph 8,3 erasure-encoded rbd). I don't think there would be
> > an an enourmous amount of data to trim, maybe a few T, but I've no idea
> > how long how long it might be expected to take. In an attempt to see
> > what the what the fstrim was doing, I ran an strace on it. The strace
> > has been sitting there without output and unkillable since then, now 5+
> > hours ago.  Since the strace, on that same filesystem I now have 123 df
> > processes and 615 rm processes -- and growing -- that are blocked in
> > xfs_inodegc_flush, e.g.:
> > 
> > May 18 15:31:52 d5 kernel: task:df              state:D stack:    0 pid:31741 ppid:     1 flags:0x00004004
> > May 18 15:31:52 d5 kernel: Call Trace:
> > May 18 15:31:52 d5 kernel:  <TASK>
> > May 18 15:31:52 d5 kernel:  __schedule+0x241/0x740
> > May 18 15:31:52 d5 kernel:  ? lock_is_held_type+0x97/0x100
> > May 18 15:31:52 d5 kernel:  schedule+0x3a/0xa0
> > May 18 15:31:52 d5 kernel:  schedule_timeout+0x271/0x310
> > May 18 15:31:52 d5 kernel:  ? find_held_lock+0x2d/0x90
> > May 18 15:31:52 d5 kernel:  ? sched_clock_cpu+0x9/0xa0
> > May 18 15:31:52 d5 kernel:  ? lock_release+0x214/0x350
> > May 18 15:31:52 d5 kernel:  wait_for_completion+0x7b/0xc0
> > May 18 15:31:52 d5 kernel:  __flush_work+0x217/0x350
> > May 18 15:31:52 d5 kernel:  ? flush_workqueue_prep_pwqs+0x120/0x120
> > May 18 15:31:52 d5 kernel:  ? wait_for_completion+0x1c/0xc0
> > May 18 15:31:52 d5 kernel:  xfs_inodegc_flush.part.24+0x62/0xc0 [xfs]
> > May 18 15:31:52 d5 kernel:  xfs_fs_statfs+0x37/0x1a0 [xfs]
> > May 18 15:31:52 d5 kernel:  statfs_by_dentry+0x3c/0x60
> > May 18 15:31:52 d5 kernel:  vfs_statfs+0x16/0xd0
> > May 18 15:31:52 d5 kernel:  user_statfs+0x44/0x80
> > May 18 15:31:52 d5 kernel:  __do_sys_statfs+0x10/0x30
> > May 18 15:31:52 d5 kernel:  do_syscall_64+0x34/0x80
> > May 18 15:31:52 d5 kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > May 18 15:31:52 d5 kernel: RIP: 0033:0x7fe9e9db3c07
> > May 18 15:31:52 d5 kernel: RSP: 002b:00007ffe08f50178 EFLAGS: 00000246 ORIG_RAX: 0000000000000089
> > May 18 15:31:52 d5 kernel: RAX: ffffffffffffffda RBX: 0000555963fcae40 RCX: 00007fe9e9db3c07
> > May 18 15:31:52 d5 kernel: RDX: 00007ffe08f50400 RSI: 00007ffe08f50180 RDI: 0000555963fcae40
> > May 18 15:31:52 d5 kernel: RBP: 00007ffe08f50180 R08: 0000555963fcae80 R09: 0000000000000000
> > May 18 15:31:52 d5 kernel: R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe08f50220
> > May 18 15:31:52 d5 kernel: R13: 0000000000000000 R14: 0000555963fcae80 R15: 0000555963fcae40
> > May 18 15:31:52 d5 kernel:  </TASK>
> > 
> > Full 1.5M sysrq output at: https://file.io/bWOL8F7mzKI6

 task:fstrim          state:D stack:    0 pid: 3552 ppid:  2091 flags:0x00004006
 Call Trace:
  <TASK>
  __schedule+0x241/0x740
  schedule+0x3a/0xa0
  schedule_timeout+0x1c9/0x310
  ? del_timer_sync+0x90/0x90
  io_schedule_timeout+0x19/0x40
  wait_for_completion_io_timeout+0x75/0xd0
  submit_bio_wait+0x63/0x90
  ? wait_for_completion_io_timeout+0x1f/0xd0
  blkdev_issue_discard+0x6a/0xa0
  ? _raw_spin_unlock+0x1f/0x30
  xfs_trim_extents+0x1a7/0x3d0 [xfs]
  xfs_ioc_trim+0x161/0x1e0 [xfs]
  xfs_file_ioctl+0x914/0xbf0 [xfs]
  ? __do_sys_newfstat+0x2d/0x40
  __x64_sys_ioctl+0x71/0xb0
  do_syscall_64+0x34/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7fa84e61ae57
 RSP: 002b:00007ffe90fa1da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00007ffe90fa1f10 RCX: 00007fa84e61ae57
 RDX: 00007ffe90fa1db0 RSI: 00000000c0185879 RDI: 0000000000000003
 RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe90fa3d10
 R13: 00007ffe90fa3d10 R14: 0000000000000000 R15: 00007fa84e1fdff8
  </TASK>

It looks like the storage device is stalled on the discard, and most
everything else is stuck waiting for buffer locks?  The statfs threads
are the same symptom as last time.

--D

> > 
> > That stack trace is uncomfortably familiar:
> > 
> > Subject: Highly reflinked and fragmented considered harmful?
> > https://lore.kernel.org/linux-xfs/20220509024659.GA62606@onthe.net.au/
> > 
> > FYI:
> > 
> > # xfs_info /vol
> > meta-data=/dev/vg01/vol          isize=512    agcount=257, agsize=268434432 blks
> >         =                       sectsz=4096  attr=2, projid32bit=1
> >         =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >         =                       reflink=1    bigtime=1 inobtcount=1
> > data     =                       bsize=4096   blocks=68719475712, imaxpct=1
> >         =                       sunit=1024   swidth=8192 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=521728, version=2
> >         =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > 
> > Is there something I can do to "unstick" things, or is it time to hit
> > the reset, and hope the recovery on mount isn't onerous?
> > 
> > Aside from that immediate issue, what has gone wrong here?
> > 
> > Cheers,
> > 
> > Chris
