Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FFB2C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 17:26:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 789A964F2A
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Feb 2021 17:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbhBEPnX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Feb 2021 10:43:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233054AbhBEPa7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Feb 2021 10:30:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27A3364FFE;
        Fri,  5 Feb 2021 17:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612545161;
        bh=PGUbTKJGC3IJETql5sdcdws/eatml+cWThaawbY7Vio=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=pTM4MckjBISyEr71CkRuMX1O56DUso3qtpKYizBdO7X4Ht7A1JPsPM735b8lvAN2M
         rWEgk8EjMVYupoBe4Fj88mjV88aXhtPrmVsNJWfWVNRX1gCTl0iXQuiBaboeMSvA3x
         wKgS56S55PM5tvupSsFVVmdBJHMhvFEQHflTRHzer9E4VLr1GzurUJt4R9TvhndfK+
         +92xtFw7Oc5um+SlRXshufvSPWGmwfqiwj4Ijcou3GausOidAsM6iP7zU7qsgjDyAu
         yFyY50dFs/eIEgV0ezkPFpUBq+8fqvQtoBH0oPpaEpfOxYEl6m6ohkhvclfM3XaItD
         oeQpncGQWYkWA==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 1D366352271B; Fri,  5 Feb 2021 09:12:40 -0800 (PST)
Date:   Fri, 5 Feb 2021 09:12:40 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        rcu@vger.kernel.org, it+linux-rcu@molgen.mpg.de,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rcu: INFO: rcu_sched self-detected stall on CPU: Workqueue:
 xfs-conv/md0 xfs_end_io
Message-ID: <20210205171240.GN2743@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <1b07e849-cffd-db1f-f01b-2b8b45ce8c36@molgen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b07e849-cffd-db1f-f01b-2b8b45ce8c36@molgen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 05, 2021 at 08:29:06AM +0100, Paul Menzel wrote:
> Dear Linux folks,
> 
> 
> On a Dell PowerEdge T630/0NT78X, BIOS 2.8.0 05/23/2018 with Linux 5.4.57, we
> twice saw a self-detected stall on a CPU (October 27th, 2020, January 18th,
> 2021).
> 
> Both times, the workqueue is `xfs-conv/md0 xfs_end_io`.
> 
> ```
> [    0.000000] Linux version 5.4.57.mx64.340
> (root@theinternet.molgen.mpg.de) (gcc version 7.5.0 (GCC)) #1 SMP Tue Aug 11
> 13:20:33 CEST 2020
> […]
> [48962.981257] rcu: INFO: rcu_sched self-detected stall on CPU
> [48962.987511] rcu: 	4-....: (20999 ticks this GP)
> idle=fe6/1/0x4000000000000002 softirq=3630188/3630188 fqs=4696
> [48962.998805] 	(t=21017 jiffies g=14529009 q=32263)
> [48963.004074] Task dump for CPU 4:
> [48963.007689] kworker/4:2     R  running task        0 25587      2
> 0x80004008
> [48963.015591] Workqueue: xfs-conv/md0 xfs_end_io
> [48963.020570] Call Trace:
> [48963.023311]  <IRQ>
> [48963.025560]  sched_show_task+0x11e/0x150
> [48963.029957]  rcu_dump_cpu_stacks+0x70/0xa0
> [48963.034545]  rcu_sched_clock_irq+0x502/0x770
> [48963.039322]  ? tick_sched_do_timer+0x60/0x60
> [48963.044106]  update_process_times+0x24/0x60
> [48963.048791]  tick_sched_timer+0x37/0x70
> [48963.053089]  __hrtimer_run_queues+0x11f/0x2b0
> [48963.057960]  ? recalibrate_cpu_khz+0x10/0x10
> [48963.062744]  hrtimer_interrupt+0xe5/0x240
> [48963.067235]  smp_apic_timer_interrupt+0x6f/0x130
> [48963.072407]  apic_timer_interrupt+0xf/0x20
> [48963.076994]  </IRQ>
> [48963.079347] RIP: 0010:_raw_spin_unlock_irqrestore+0xa/0x10
> [48963.085491] Code: f3 90 83 e8 01 75 e8 65 8b 3d 42 0f 56 7e e8 ed ea 5e
> ff 48 29 e8 4c 39 e8 76 cf 80 0b 08 eb 8c 0f 1f 44 00 00 c6 07 00 56 9d <c3>
> 0f 1f 44 00 00 0f 1f 44 00 00 b8 00 fe ff ff f0 0f c1 07 56 9d
> [48963.106524] RSP: 0018:ffffc9000738fd40 EFLAGS: 00000202 ORIG_RAX:
> ffffffffffffff13
> [48963.115003] RAX: ffffffff82407588 RBX: ffffffff82407580 RCX:
> ffffffff82407588
> [48963.122994] RDX: ffffffff82407588 RSI: 0000000000000202 RDI:
> ffffffff82407580
> [48963.130989] RBP: 0000000000000202 R08: ffffffff8203ea00 R09:
> 0000000000000001
> [48963.138982] R10: ffffc9000738fbb8 R11: 0000000000000001 R12:
> ffffffff82407588
> [48963.146976] R13: ffffea005e7ae600 R14: ffff8897b7e5a040 R15:
> ffffea005e7ae600
> [48963.154971]  wake_up_page_bit+0xe0/0x100
> [48963.159366]  xfs_destroy_ioend+0xce/0x1c0
> [48963.163857]  xfs_end_ioend+0xcf/0x1a0
> [48963.167958]  xfs_end_io+0xa4/0xd0
> [48963.171672]  process_one_work+0x1e5/0x410
> [48963.176163]  worker_thread+0x2d/0x3c0
> [48963.180265]  ? cancel_delayed_work+0x90/0x90
> [48963.185048]  kthread+0x117/0x130
> [48963.188663]  ? kthread_create_worker_on_cpu+0x70/0x70
> [48963.194321]  ret_from_fork+0x35/0x40
> ```
> 
> As it’s just log level INFO, is there anything what should be done, or was
> the system probably just “overloaded”?

I am assuming that you are building your kernel with CONFIG_PREEMPT_NONE=y
rather than CONFIG_PREEMPT_VOLUNTARY=y.

If so, and if the problem is that you are temporarily overdriving xfs I/O,
one approach would be as follows:

------------------------------------------------------------------------

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f16d5f1..06be426 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -390,6 +390,7 @@ xfs_end_io(
 		list_del_init(&ioend->io_list);
 		xfs_ioend_try_merge(ioend, &completion_list);
 		xfs_end_ioend(ioend);
+		cond_resched();
 	}
 }
 
------------------------------------------------------------------------

If you have instead built with CONFIG_PREEMPT_VOLUNTARY=y, then your
problem is likely massive lock contention in wake_up_page_bit(), or
perhaps someone having failed to release that lock.  The usual way to
work this out is by enabling lockdep (CONFIG_PROVE_LOCKING=y), but this
is often not what you want enabled in production.

Darrick, thoughts from an xfs perspective?

							Thanx, Paul
