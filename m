Return-Path: <SRS0=K1zF=AH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36E0C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 05:57:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91DF02076E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 05:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgFZF5h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Jun 2020 01:57:37 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56407 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726392AbgFZF5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jun 2020 01:57:36 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id A1F4C1060AE;
        Fri, 26 Jun 2020 15:57:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1johMd-0003aJ-Ay; Fri, 26 Jun 2020 15:57:27 +1000
Date:   Fri, 26 Jun 2020 15:57:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200626055727.GG2005@dread.disaster.area>
References: <20200626004722.GF2005@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626004722.GF2005@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=r4WhLfbNE1kVJq11wAEA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 26, 2020 at 10:47:22AM +1000, Dave Chinner wrote:
> Hi folks,
> 
> I turned on CONFIG_PREEMPT=y yesterday to try to reproduce problems
> Darrick was having with one of my patchsets. We've both been seeing
> a dead stop panic on these configs, and I managed to find a
> relatively reliable reproducer in fstests generic/127. It's
> basically just single fsx process exercising a single file, and it
> results in this happening within 15 minutes of starting the test
> running in a loop:
> 
> [ 1102.169209] BUG: kernel NULL pointer dereference, address: 0000000000000150
> [ 1102.171270] #PF: supervisor read access in kernel mode
> [ 1102.172894] #PF: error_code(0x0000) - not-present page
> [ 1102.174408] PGD 0 P4D 0
> [ 1102.175136] Oops: 0000 [#1] PREEMPT SMP
> [ 1102.176293] CPU: 2 PID: 909 Comm: kworker/2:1H Not tainted 5.8.0-rc2-dgc+ #2469
> [ 1102.178395] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> [ 1102.180762] Workqueue: xfs-log/pmem0 xlog_ioend_work
> [ 1102.182286] RIP: 0010:check_preempt_wakeup+0xc8/0x1e0
> [ 1102.183804] Code: 39 c2 75 f2 89 d0 39 d0 7d 20 83 ea 01 4d 8b a4 24 48 01 00 00 39 d0 75 f1 eb 0f 48 8b 9b 48 01 00 00 4d 8b a4 24 48 01 00 00 <48> 8b bb 50 01 00 00 49 39 bc 24 b
> [ 1102.189125] RSP: 0018:ffffc9000071cea0 EFLAGS: 00010006
> [ 1102.190625] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822305a0
> [ 1102.192737] RDX: 0000000000000000 RSI: ffff88853337cd80 RDI: ffff88853ea2a940
> [ 1102.194827] RBP: ffffc9000071ced8 R08: ffffffff822305a0 R09: ffff88853ec2b2d0
> [ 1102.196886] R10: ffff88800f74b010 R11: ffff88853ec2a970 R12: 0000000000000000
> [ 1102.199040] R13: ffff88853ea2a8c0 R14: 0000000000000001 R15: ffff88853e3b0000
> [ 1102.200883] FS:  0000000000000000(0000) GS:ffff88853ea00000(0000) knlGS:0000000000000000
> [ 1102.203306] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1102.205024] CR2: 0000000000000150 CR3: 00000000ae7b5004 CR4: 0000000000060ee0
> [ 1102.207117] Call Trace:
> [ 1102.207895]  <IRQ>
> [ 1102.208500]  ? enqueue_task_fair+0x1d7/0x9f0
> [ 1102.209709]  check_preempt_curr+0x74/0x80
> [ 1102.210931]  ttwu_do_wakeup+0x1e/0x170
> [ 1102.212064]  ttwu_do_activate+0x5b/0x70
> [ 1102.213225]  sched_ttwu_pending+0x94/0xe0
> [ 1102.214410]  flush_smp_call_function_queue+0xf1/0x190
> [ 1102.215885]  generic_smp_call_function_single_interrupt+0x13/0x20
> [ 1102.217790]  __sysvec_call_function_single+0x2b/0xe0
> [ 1102.219375]  asm_call_on_stack+0xf/0x20
> [ 1102.220599]  </IRQ>
> [ 1102.221280]  sysvec_call_function_single+0x7e/0x90
> [ 1102.222854]  asm_sysvec_call_function_single+0x12/0x20
> [ 1102.224515] RIP: 0010:_raw_spin_unlock_irqrestore+0x14/0x30
> [ 1102.226350] Code: e8 e8 20 25 ff 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 66 66 66 66 90 55 48 89 e5 53 48 89 f3 e8 5e 11 39 ff 53 9d <65> ff 0d c5 72 26 7e 74 03 5b 5d f
> [ 1102.232213] RSP: 0018:ffffc900020b7cc8 EFLAGS: 00000246
> [ 1102.233902] RAX: 0000000000000001 RBX: 0000000000000246 RCX: 0000000000000000
> [ 1102.236134] RDX: 0000000000000002 RSI: 0000000000000246 RDI: ffff88852679a400
> [ 1102.238402] RBP: ffffc900020b7cd0 R08: ffff88852679a400 R09: ffffc900020b7ce8
> [ 1102.240598] R10: ffff88852a04e480 R11: 0000000000000001 R12: 00000000ffffffff
> [ 1102.242906] R13: 0000000000000246 R14: 0000000000000000 R15: 0000000000000003
> [ 1102.245191]  __wake_up_common_lock+0x8a/0xc0
> [ 1102.246572]  __wake_up+0x13/0x20
> [ 1102.247636]  xlog_state_clean_iclog+0xf7/0x1a0
> [ 1102.249075]  xlog_state_do_callback+0x257/0x300
> [ 1102.250548]  xlog_state_done_syncing+0x69/0xb0
> [ 1102.251958]  xlog_ioend_work+0x6c/0xc0
> [ 1102.253151]  process_one_work+0x1a6/0x390
> [ 1102.254403]  worker_thread+0x50/0x3b0
> [ 1102.255595]  ? process_one_work+0x390/0x390
> [ 1102.256913]  kthread+0x131/0x170
> [ 1102.257993]  ? __kthread_create_on_node+0x1b0/0x1b0
> [ 1102.259546]  ret_from_fork+0x1f/0x30
> [ 1102.260707] CR2: 0000000000000150
> [ 1102.261779] ---[ end trace d5f0aeef2eb333bd ]---
> [ 1102.263238] RIP: 0010:check_preempt_wakeup+0xc8/0x1e0
> [ 1102.264848] Code: 39 c2 75 f2 89 d0 39 d0 7d 20 83 ea 01 4d 8b a4 24 48 01 00 00 39 d0 75 f1 eb 0f 48 8b 9b 48 01 00 00 4d 8b a4 24 48 01 00 00 <48> 8b bb 50 01 00 00 49 39 bc 24 b
> [ 1102.270645] RSP: 0018:ffffc9000071cea0 EFLAGS: 00010006
> [ 1102.272237] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822305a0
> [ 1102.274439] RDX: 0000000000000000 RSI: ffff88853337cd80 RDI: ffff88853ea2a940
> [ 1102.276613] RBP: ffffc9000071ced8 R08: ffffffff822305a0 R09: ffff88853ec2b2d0
> [ 1102.278797] R10: ffff88800f74b010 R11: ffff88853ec2a970 R12: 0000000000000000
> [ 1102.280930] R13: ffff88853ea2a8c0 R14: 0000000000000001 R15: ffff88853e3b0000
> [ 1102.283094] FS:  0000000000000000(0000) GS:ffff88853ea00000(0000) knlGS:0000000000000000
> [ 1102.285648] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1102.287415] CR2: 0000000000000150 CR3: 00000000ae7b5004 CR4: 0000000000060ee0
> [ 1102.289606] Kernel panic - not syncing: Fatal exception in interrupt
> [ 1102.291850] Kernel Offset: disabled
> [ 1102.293002] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
> 
> This was from a vanilla 5.8-rc2 kernel, a current linus tree also
> fails like this. It looks like it is taking a scheduler preempt IPI
> and trying to do a task akeup while already processing tasks wakeups
> on that CPU....
> 
> A 5.7 kernel survived for about 20 minutes - not conclusive that the
> bug didn't exist on that kernel, but in general it reproduces within
> 5 minutes of starting the test looping.  Pre-empt related config
> options:
> 
> $ grep PREEMPT .config
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_PREEMPTION=y
> CONFIG_PREEMPT_RCU=y
> CONFIG_PREEMPT_NOTIFIERS=y
> # CONFIG_DEBUG_PREEMPT is not set
> # CONFIG_PREEMPTIRQ_EVENTS is not set
> # CONFIG_PREEMPT_TRACER is not set
> $
> 
> I just reproduced it on commit d479c5a1919b ("Merge tag
> 'sched-core-2020-06-02' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip"), and I'm
> going to try to do a bisect it. I'm not sure this is going to be
> reliable, because running for 20+ minutes isn't a guarantee the
> problem isn't there...
> 
> More info will follow as I find it.

Ok, so this is definitely caused by a commit inside the above merge;
the prior merge commit does not show this issue.

After wasting the entire day on two failed bisects (i.e. three hours
of testing to get to "first bad commit", test previous "good"
commit, watch it fail instantly) manual testing indicates that
this commit:

2ebb17717550 sched/core: Offload wakee task activation if it the wakee is descheduling

Is the first commit that I have been able to reproduce the failure.
The prior commit:

c6e7bd7afaeb sched/core: Optimize ttwu() spinning on p->on_cpu

Has run for almost an hour now without failing, and it was tested in
one of the bisecs for half an hour without failing, too.

Hence I'd say it's most likely a regression introduced by
2ebb17717550.

Cheers,

-Dave.
-- 
Dave Chinner
david@fromorbit.com
