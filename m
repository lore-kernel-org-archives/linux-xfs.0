Return-Path: <SRS0=tsMC=CJ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC79C433E6
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83CE120EDD
	for <linux-xfs@archiver.kernel.org>; Mon, 31 Aug 2020 19:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NeVXwcHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbgHaTWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:22:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33299 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgHaTWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Aug 2020 15:22:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598901739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=R7PBr5r7gHbAh5anLZPvJGvsxr1dZnoNAcE4WBTZb/w=;
        b=NeVXwcHTknr0lTOeiJPMyziKrRyODSHK1H3fqnmj+2nTgIQQ4jr+ekoEAE4ntilHKmbWYM
        9+nSZOUNrty5SRImp4w6U/R6jGmXhNwQvuDCF1Hu+QHiN/E06pSpmEiDisg0oL6hSex3j4
        eadxzl2Joes/vP77D8s1iedec3PqXro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-BqS2p38-PHKv44U8YjVz4A-1; Mon, 31 Aug 2020 15:22:16 -0400
X-MC-Unique: BqS2p38-PHKv44U8YjVz4A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18A621084C85;
        Mon, 31 Aug 2020 19:22:16 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF17860C15;
        Mon, 31 Aug 2020 19:22:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 07VJMF9o008638;
        Mon, 31 Aug 2020 15:22:15 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 07VJMFrU008634;
        Mon, 31 Aug 2020 15:22:15 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Mon, 31 Aug 2020 15:22:15 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: RCU stall when using XFS
Message-ID: <alpine.LRH.2.02.2008311513150.7870@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi

I report this RCU stall when working with one 512GiB file the XFS 
filesystem on persistent memory. Except for the warning, there was no 
observed misbehavior.

Perhaps, it is missing cond_resched() somewhere.

Mikulas


[187395.754249] XFS (pmem3): Mounting V5 Filesystem
[187395.766583] XFS (pmem3): Ending clean mount
[187395.771434] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[188226.398260] rcu: INFO: rcu_sched self-detected stall on CPU
[188226.404609] rcu: 	11-....: (37223 ticks this GP) idle=5a2/1/0x4000000000000000 softirq=259495/259495 fqs=13202 
[188226.416134] 	(t=60017 jiffies g=8444929 q=28811)
[188226.421405] NMI backtrace for cpu 11
[188226.425492] CPU: 11 PID: 36509 Comm: kworker/11:0 Tainted: G S         O      5.9.0-rc2 #3
[188226.434886] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS PLYXCRB1.86B.0576.D20.1902150028 02/15/2019
[188226.446099] Workqueue: xfs-conv/pmem3 xfs_end_io [xfs]
[188226.451966] Call Trace:
[188226.454818]  <IRQ>
[188226.457184]  dump_stack+0x57/0x70
[188226.460980]  nmi_cpu_backtrace.cold.8+0x13/0x4f
[188226.466135]  ? lapic_can_unplug_cpu.cold.36+0x37/0x37
[188226.471870]  nmi_trigger_cpumask_backtrace+0xc8/0xca
[188226.477512]  rcu_dump_cpu_stacks+0xae/0xdc
[188226.482182]  rcu_sched_clock_irq.cold.94+0x10a/0x366
[188226.487822]  ? trigger_load_balance+0x3c/0x240
[188226.492881]  ? tick_sched_do_timer+0x70/0x70
[188226.497742]  ? tick_sched_do_timer+0x70/0x70
[188226.502620]  update_process_times+0x24/0x60
[188226.507401]  tick_sched_handle.isra.26+0x35/0x40
[188226.512651]  tick_sched_timer+0x65/0x80
[188226.517083]  __hrtimer_run_queues+0x100/0x280
[188226.522042]  hrtimer_interrupt+0x100/0x220
[188226.526710]  ? rcu_iw_handler+0x19/0x40
[188226.531089]  __sysvec_apic_timer_interrupt+0x5d/0xf0
[188226.536720]  asm_call_on_stack+0xf/0x20
[188226.541098]  </IRQ>
[188226.543540]  sysvec_apic_timer_interrupt+0x73/0x80
[188226.548984]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[188226.554844] RIP: 0010:_raw_spin_unlock_irqrestore+0xe/0x10
[188226.561062] Code: 00 8b 07 85 c0 75 0b ba 01 00 00 00 f0 0f b1 17 74 03 31 c0 c3 b8 01 00 00 00 c3 90 0f 1f 44 00 00 c6 07 00 0f 1f 40 00 56 9d <c3> 90 0f 1f 44 00 00 8b 07 a9 ff 01 00 00 75 1e ba 00 02 00 00 f0
[188226.582119] RSP: 0000:ffffb013ce1dbd28 EFLAGS: 00000206
[188226.588049] RAX: 0000000000000000 RBX: ffffefef65cd7f40 RCX: 0000000000000180
[188226.596109] RDX: ffff8956c7d1fa38 RSI: 0000000000000206 RDI: ffff896c5dcd4db0
[188226.604171] RBP: 0000000000000001 R08: ffffb013ce1dbcf0 R09: 0000000000000206
[188226.612232] R10: 00000000000313d5 R11: 0000000000000001 R12: ffff896a0bbe4000
[188226.620293] R13: ffff896d59ae4800 R14: ffff896c5dcd4da8 R15: ffff8c9234c54860
[188226.628399]  test_clear_page_writeback+0xd7/0x300
[188226.633750]  end_page_writeback+0x43/0x60
[188226.638326]  iomap_finish_ioend+0x17f/0x200
[188226.643103]  ? xfs_iomap_write_unwritten+0x18a/0x2c0 [xfs]
[188226.649322]  iomap_finish_ioends+0x43/0xa0
[188226.653999]  xfs_end_ioend+0x6b/0x100 [xfs]
[188226.658825]  ? xfs_setfilesize_ioend+0x60/0x60 [xfs]
[188226.664482]  xfs_end_io+0xad/0xe0 [xfs]
[188226.668860]  process_one_work+0x206/0x3d0
[188226.673431]  ? process_one_work+0x3d0/0x3d0
[188226.678197]  worker_thread+0x2d/0x3d0
[188226.682380]  ? process_one_work+0x3d0/0x3d0
[188226.687146]  kthread+0x116/0x130
[188226.690844]  ? kthread_park+0x80/0x80
[188226.695029]  ret_from_fork+0x1f/0x30
[188510.467258] XFS (pmem3): Unmounting Filesystem
[188514.316739] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[188514.325229] XFS (pmem3): Mounting V5 Filesystem
[188514.338115] XFS (pmem3): Ending clean mount
[188514.342969] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[188547.273256] XFS (pmem3): Unmounting Filesystem
[188551.349615] XFS (pmem3): Mounting V5 Filesystem
[188551.362393] XFS (pmem3): Ending clean mount
[188551.367259] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[188623.505834] XFS (pmem3): Unmounting Filesystem
[188627.935790] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[188627.944297] XFS (pmem3): Mounting V5 Filesystem
[188627.957588] XFS (pmem3): Ending clean mount
[188627.962455] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[188727.574325] XFS (pmem3): Unmounting Filesystem
[188730.257546] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[188730.266029] XFS (pmem3): Mounting V5 Filesystem
[188730.277924] XFS (pmem3): Ending clean mount
[188730.282780] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[188731.157151] XFS (pmem3): Unmounting Filesystem
[188732.031577] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[188732.040047] XFS (pmem3): Mounting V5 Filesystem
[188732.049865] XFS (pmem3): Ending clean mount
[188732.054673] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[188752.654883] XFS (pmem3): Unmounting Filesystem
[188753.536132] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[188753.544610] XFS (pmem3): Mounting V5 Filesystem
[188753.556100] XFS (pmem3): Ending clean mount
[188753.560954] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[189643.193075] XFS (pmem3): Unmounting Filesystem
[189646.828861] XFS (pmem3): Mounting V5 Filesystem
[189646.841023] XFS (pmem3): Ending clean mount
[189646.845865] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)
[189703.029858] XFS (pmem3): Unmounting Filesystem
[189705.756862] XFS (pmem3): DAX enabled. Warning: EXPERIMENTAL, use at your own risk
[189705.765342] XFS (pmem3): Mounting V5 Filesystem
[189705.777044] XFS (pmem3): Ending clean mount
[189705.781896] xfs filesystem being mounted at /mnt/xfs supports timestamps until 2038 (0x7fffffff)

