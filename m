Return-Path: <SRS0=bIZx=BU=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937CFC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 07:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 747272075D
	for <linux-xfs@archiver.kernel.org>; Mon, 10 Aug 2020 07:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgHJHIO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Aug 2020 03:08:14 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:39960 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725846AbgHJHIO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Aug 2020 03:08:14 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D2C1D7607A1;
        Mon, 10 Aug 2020 17:08:10 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k51uh-0002Rj-OI; Mon, 10 Aug 2020 17:08:07 +1000
Date:   Mon, 10 Aug 2020 17:08:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     bugzilla-daemon@bugzilla.kernel.org
Cc:     linux-xfs@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Bug 208827] [fio io_uring] io_uring write data crc32c verify
 failed
Message-ID: <20200810070807.GJ2114@dread.disaster.area>
References: <bug-208827-201763@https.bugzilla.kernel.org/>
 <bug-208827-201763-ubSctIQBY4@https.bugzilla.kernel.org/>
 <20200810000932.GH2114@dread.disaster.area>
 <20200810035605.GI2114@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810035605.GI2114@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Ffbtf2zaSdpkXfyAulUA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

[cc Jens]

[Jens, data corruption w/ io_uring and simple fio reproducer. see
the bz link below.]

On Mon, Aug 10, 2020 at 01:56:05PM +1000, Dave Chinner wrote:
> On Mon, Aug 10, 2020 at 10:09:32AM +1000, Dave Chinner wrote:
> > On Fri, Aug 07, 2020 at 03:12:03AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> > > --- Comment #1 from Dave Chinner (david@fromorbit.com) ---
> > > On Thu, Aug 06, 2020 at 04:57:58AM +0000, bugzilla-daemon@bugzilla.kernel.org
> > > wrote:
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=208827
> > > > 
> > > >             Bug ID: 208827
> > > >            Summary: [fio io_uring] io_uring write data crc32c verify
> > > >                     failed
> > > >            Product: File System
> > > >            Version: 2.5
> > > >     Kernel Version: xfs-linux xfs-5.9-merge-7 + v5.8-rc4
> > 
> > FWIW, I can reproduce this with a vanilla 5.8 release kernel,
> > so this isn't related to contents of the XFS dev tree at all...
> > 
> > In fact, this bug isn't a recent regression. AFAICT, it was
> > introduced between in 5.4 and 5.5 - 5.4 did not reproduce, 5.5 did
> > reproduce. More info once I've finished bisecting it....
> 
> f67676d160c6ee2ed82917fadfed6d29cab8237c is the first bad commit
> commit f67676d160c6ee2ed82917fadfed6d29cab8237c
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Dec 2 11:03:47 2019 -0700
> 
>     io_uring: ensure async punted read/write requests copy iovec

....

Ok, I went back to vanilla 5.8 to continue debugging and adding
tracepoints, and it's proving strangely difficult to reproduce now.

However, I did just hit this:

[ 4980.136032] ------------[ cut here ]------------
[ 4980.137665] do not call blocking ops when !TASK_RUNNING; state=1 set at [<00000000ef911b51>] prepare_to_wait_exclusive+0x3d/0xd0
[ 4980.141403] WARNING: CPU: 13 PID: 6800 at kernel/sched/core.c:6888 __might_sleep+0x74/0x80
[ 4980.143940] CPU: 13 PID: 6800 Comm: fio Not tainted 5.8.0-dgc+ #2549
[ 4980.146147] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
[ 4980.148774] RIP: 0010:__might_sleep+0x74/0x80
[ 4980.150455] Code: ff 41 5c 41 5d 41 5e 5d c3 48 8b 90 30 22 00 00 48 c7 c7 a8 b9 50 82 c6 05 38 e4 9a 01 01 48 8b 70 10 48 89 d1 e8 fa 5c fc ff <0f> 0b eb c5 0f 1f 84 00 00 00 002
[ 4980.156255] RSP: 0018:ffffc90005383c58 EFLAGS: 00010282
[ 4980.158299] RAX: 0000000000000000 RBX: 0000561a18122000 RCX: 0000000000000000
[ 4980.160817] RDX: ffff88883eca7de0 RSI: ffff88883ec97a80 RDI: ffff88883ec97a80
[ 4980.163162] RBP: ffffc90005383c70 R08: ffff88883ec97a80 R09: ffff8888070f3000
[ 4980.165635] R10: ffff8888070f3434 R11: ffff8888070f3434 R12: ffffffff8251f46e
[ 4980.168115] R13: 00000000000001ba R14: 0000000000000000 R15: ffff888235647740
[ 4980.170714] FS:  00007f80de7af700(0000) GS:ffff88883ec80000(0000) knlGS:0000000000000000
[ 4980.173442] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 4980.175371] CR2: 00007f80d4005008 CR3: 00000005eb01c004 CR4: 0000000000060ee0
[ 4980.177607] Call Trace:
[ 4980.178583]  change_protection+0x827/0x9e0
[ 4980.180063]  ? kvm_clock_read+0x18/0x30
[ 4980.181654]  ? kvm_sched_clock_read+0x9/0x20
[ 4980.183426]  ? sysvec_apic_timer_interrupt+0x46/0x90
[ 4980.185160]  change_prot_numa+0x19/0x30
[ 4980.186607]  task_numa_work+0x1c7/0x2e0
[ 4980.188003]  task_work_run+0x64/0xb0
[ 4980.189488]  io_cqring_wait+0x118/0x290
[ 4980.191136]  ? io_uring_poll+0x80/0x80
[ 4980.192430]  __x64_sys_io_uring_enter+0x158/0x2d0
[ 4980.194033]  do_syscall_64+0x46/0x90
[ 4980.195278]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 4980.197092] RIP: 0033:0x7f8135c59a79
[ 4980.198412] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b8
[ 4980.203953] RSP: 002b:00007f80de7aacd8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
[ 4980.206596] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f8135c59a79
[ 4980.208924] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000008
[ 4980.211334] RBP: 00007f80defb1000 R08: 0000000000000000 R09: 0000000000000000
[ 4980.213656] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
[ 4980.216045] R13: 0000000000000001 R14: 0000561a1820cd60 R15: 0000000000000000
[ 4980.218469] ---[ end trace 4a8ca123102be9c2 ]---

No idea if it is relevant to the data corruption, but there's
definitely something not right here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
