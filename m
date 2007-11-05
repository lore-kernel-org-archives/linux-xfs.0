Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 04 Nov 2007 23:01:51 -0800 (PST)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA571cYT019277
	for <xfs@oss.sgi.com>; Sun, 4 Nov 2007 23:01:41 -0800
Received: by py-out-1112.google.com with SMTP id u77so3004464pyb
        for <xfs@oss.sgi.com>; Sun, 04 Nov 2007 23:01:43 -0800 (PST)
Message-ID: <64bb37e0711042301l54f1aca4qc36b184be5caa12b@mail.gmail.com>
Date: Mon, 5 Nov 2007 08:01:41 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: writeout stalls in current -git
In-Reply-To: <20071105014510.GU66820511@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <393060478.03650@ustc.edu.cn> <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost> <1193998532.27652.343.camel@twins>
	 <64bb37e0711021222q7d12c825mc62d433c4fe19e8@mail.gmail.com>
	 <20071102204258.GR995458@sgi.com>
	 <64bb37e0711040319l5de285c3xea64474540a51b6e@mail.gmail.com>
	 <20071105014510.GU66820511@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>, Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 11/5/07, David Chinner <dgc@sgi.com> wrote:
> On Sun, Nov 04, 2007 at 12:19:19PM +0100, Torsten Kaiser wrote:
> > I can now confirm, that I see this also with the current mainline-git-version
> > I used 2.6.24-rc1-git-b4f555081fdd27d13e6ff39d455d5aefae9d2c0c
> > plus the fix for the sg changes in ieee1394.
>
> Ok, so it's probably a side effect of the writeback changes.
>
> Attached are two patches (two because one was in a separate patchset as
> a standalone change) that should prevent async writeback from blocking
> on locked inode cluster buffers. Apply the xfs-factor-inotobp patch first.
> Can you see if this fixes the problem?

Applied both patches against the kernel mentioned above.
This blows up at boot:
[   80.807589] Filesystem "dm-0": Disabling barriers, not supported by
the underlying device
[   80.820241] XFS mounting filesystem dm-0
[   80.913144] ------------[ cut here ]------------
[   80.914932] kernel BUG at drivers/md/raid5.c:143!
[   80.916751] invalid opcode: 0000 [1] SMP
[   80.918338] CPU 3
[   80.919142] Modules linked in:
[   80.920345] Pid: 974, comm: md1_raid5 Not tainted 2.6.24-rc1 #3
[   80.922628] RIP: 0010:[<ffffffff804b6ee4>]  [<ffffffff804b6ee4>]
__release_stripe+0x164/0x170
[   80.925935] RSP: 0018:ffff8100060e7dd0  EFLAGS: 00010002
[   80.927987] RAX: 0000000000000000 RBX: ffff81010141c288 RCX: 0000000000000000
[   80.930738] RDX: 0000000000000000 RSI: ffff81010141c288 RDI: ffff810004fb3200
[   80.933488] RBP: ffff810004fb3200 R08: 0000000000000000 R09: 0000000000000005
[   80.936240] R10: 0000000000000e00 R11: ffffe200038465e8 R12: ffff81010141c298
[   80.938990] R13: 0000000000000286 R14: ffff810004fb3330 R15: 0000000000000000
[   80.941741] FS:  000000000060c870(0000) GS:ffff810100313700(0000)
knlGS:0000000000000000
[   80.944861] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   80.947080] CR2: 00007fff7b295000 CR3: 0000000101842000 CR4: 00000000000006e0
[   80.949830] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   80.952580] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   80.955332] Process md1_raid5 (pid: 974, threadinfo
ffff8100060e6000, task ffff81000645c730)
[   80.958584] Stack:  ffff81010141c288 00000000000001f4
ffff810004fb3200 ffffffff804b6f2d
[   80.961761]  00000000000001f4 ffff81010141c288 ffffffff804c8bd0
0000000000000000
[   80.964681]  ffff8100060e7ee8 ffffffff804bd094 ffff81000645c730
ffff8100060e7e70
[   80.967518] Call Trace:
[   80.968558]  [<ffffffff804b6f2d>] release_stripe+0x3d/0x60
[   80.970677]  [<ffffffff804c8bd0>] md_thread+0x0/0x100
[   80.972629]  [<ffffffff804bd094>] raid5d+0x344/0x450
[   80.974549]  [<ffffffff8023df10>] process_timeout+0x0/0x10
[   80.976668]  [<ffffffff805ae1ca>] schedule_timeout+0x5a/0xd0
[   80.978855]  [<ffffffff804c8bd0>] md_thread+0x0/0x100
[   80.980807]  [<ffffffff804c8c00>] md_thread+0x30/0x100
[   80.982794]  [<ffffffff80249f20>] autoremove_wake_function+0x0/0x30
[   80.985214]  [<ffffffff804c8bd0>] md_thread+0x0/0x100
[   80.987167]  [<ffffffff80249b3b>] kthread+0x4b/0x80
[   80.989054]  [<ffffffff8020c9c8>] child_rip+0xa/0x12
[   80.990972]  [<ffffffff80249af0>] kthread+0x0/0x80
[   80.992824]  [<ffffffff8020c9be>] child_rip+0x0/0x12
[   80.994743]
[   80.995588]
[   80.995588] Code: 0f 0b eb fe 0f 1f 84 00 00 00 00 00 48 83 ec 28
48 89 5c 24
[   80.999307] RIP  [<ffffffff804b6ee4>] __release_stripe+0x164/0x170
[   81.001711]  RSP <ffff8100060e7dd0>

Switching back to unpatched 2.6.23-mm1 boots sucessfull...

Torsten
