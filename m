Return-Path: <SRS0=K1zF=AH=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB214C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 22:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAF6420885
	for <linux-xfs@archiver.kernel.org>; Fri, 26 Jun 2020 22:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgFZWc7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 26 Jun 2020 18:32:59 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52214 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725833AbgFZWc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 26 Jun 2020 18:32:59 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 323005ACCA8;
        Sat, 27 Jun 2020 08:32:55 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jowty-00010b-Ac; Sat, 27 Jun 2020 08:32:54 +1000
Date:   Sat, 27 Jun 2020 08:32:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [Bug, sched, 5.8-rc2]: PREEMPT kernels crashing in
 check_preempt_wakeup() running fsx on XFS
Message-ID: <20200626223254.GH2005@dread.disaster.area>
References: <20200626004722.GF2005@dread.disaster.area>
 <20200626073345.GI4800@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626073345.GI4800@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=zrXb6hoR0iLImkmByFsA:9 a=ZW6ll2N9l6e1T70Y:21 a=2mTpRhB-JAkS_8Dw:21
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 26, 2020 at 09:33:45AM +0200, Peter Zijlstra wrote:
> On Fri, Jun 26, 2020 at 10:47:22AM +1000, Dave Chinner wrote:
> > [ 1102.169209] BUG: kernel NULL pointer dereference, address: 0000000000000150
> > [ 1102.171270] #PF: supervisor read access in kernel mode
> > [ 1102.172894] #PF: error_code(0x0000) - not-present page
> > [ 1102.174408] PGD 0 P4D 0
> > [ 1102.175136] Oops: 0000 [#1] PREEMPT SMP
> > [ 1102.176293] CPU: 2 PID: 909 Comm: kworker/2:1H Not tainted 5.8.0-rc2-dgc+ #2469
> > [ 1102.178395] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
> > [ 1102.180762] Workqueue: xfs-log/pmem0 xlog_ioend_work
> > [ 1102.182286] RIP: 0010:check_preempt_wakeup+0xc8/0x1e0
> > [ 1102.183804] Code: 39 c2 75 f2 89 d0 39 d0 7d 20 83 ea 01 4d 8b a4 24 48 01 00 00 39 d0 75 f1 eb 0f 48 8b 9b 48 01 00 00 4d 8b a4 24 48 01 00 00 <48> 8b bb 50 01 00 00 49 39 bc 24 b
> > [ 1102.189125] RSP: 0018:ffffc9000071cea0 EFLAGS: 00010006
> > [ 1102.190625] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff822305a0
> > [ 1102.192737] RDX: 0000000000000000 RSI: ffff88853337cd80 RDI: ffff88853ea2a940
> > [ 1102.194827] RBP: ffffc9000071ced8 R08: ffffffff822305a0 R09: ffff88853ec2b2d0
> > [ 1102.196886] R10: ffff88800f74b010 R11: ffff88853ec2a970 R12: 0000000000000000
> > [ 1102.199040] R13: ffff88853ea2a8c0 R14: 0000000000000001 R15: ffff88853e3b0000
> > [ 1102.200883] FS:  0000000000000000(0000) GS:ffff88853ea00000(0000) knlGS:0000000000000000
> > [ 1102.203306] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 1102.205024] CR2: 0000000000000150 CR3: 00000000ae7b5004 CR4: 0000000000060ee0
> > [ 1102.207117] Call Trace:
> > [ 1102.207895]  <IRQ>
> > [ 1102.208500]  ? enqueue_task_fair+0x1d7/0x9f0
> > [ 1102.209709]  check_preempt_curr+0x74/0x80
> > [ 1102.210931]  ttwu_do_wakeup+0x1e/0x170
> > [ 1102.212064]  ttwu_do_activate+0x5b/0x70
> > [ 1102.213225]  sched_ttwu_pending+0x94/0xe0
> > [ 1102.214410]  flush_smp_call_function_queue+0xf1/0x190
> > [ 1102.215885]  generic_smp_call_function_single_interrupt+0x13/0x20
> > [ 1102.217790]  __sysvec_call_function_single+0x2b/0xe0
> > [ 1102.219375]  asm_call_on_stack+0xf/0x20
> > [ 1102.220599]  </IRQ>
> > [ 1102.221280]  sysvec_call_function_single+0x7e/0x90
> > [ 1102.222854]  asm_sysvec_call_function_single+0x12/0x20
> 
> https://git.kernel.org/tip/964ed98b075263faabe416eeebac99a9bef3f06c
> 
> Should be headed to Linus soon.

Testing it now.

Observation from the outside:

"However I'm having trouble convincing myself that's actually
possible on x86_64.... "

This scheduler code has fallen off a really high ledge on the memory
barrier cliff, hasn't it?

Having looked at this code over the past 24 hours and the recent
history, I know that understanding it - let alone debugging and
fixing problem in it - is way beyond my capabilities.  And I say
that as an experienced kernel developer with a pretty good grasp of
concurrent programming and a record of implementing a fair number of
non-trivial lockless algorithms over the years....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
