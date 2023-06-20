Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1AF6EB64D7
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Jun 2023 15:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjFTPNV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 11:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbjFTPNV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Jun 2023 11:13:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91919C0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 08:13:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 091A0612D0
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 15:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65E83C433C9
        for <linux-xfs@vger.kernel.org>; Tue, 20 Jun 2023 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687273997;
        bh=KzwMUc3oZHWW+ue1OvWzaAtQHKYNF+wjdLguquJcxi4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Yju/03KuJksbkpz4bCyxaUOyDeArdNxF+jaXPqbbj5it55RL1sjNgUujbvwW++7AB
         0hTjIpdVdzEpZfDOQNa6eiK7Mx58GuqyoKm2omLpTAThX59IzJT6Eovl2485S3NKXp
         zH6WYSoCAhXdY4wpgzcjVatiMc/KR2+nk4CIyxr+S1vbGMMiEORojdU1SUH45lC1Zc
         l7yzAcs7nUDZFfHkCNtGUndDkrGduCP8UdQMPLM15mtekTt1BG2xXpkLnfWd5+o7TJ
         KDmmkWu78SlBevuzR6LGYIEJ8ZkyvFnPHEdxnUNopUPv4n8heP/bGHsO2lWCtAyPGG
         o/6wBelZpDxiA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 56793C53BCD; Tue, 20 Jun 2023 15:13:17 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Tue, 20 Jun 2023 15:13:16 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: ct@flyingcircus.io
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217572-201763-3cS9mjxovW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217572-201763@https.bugzilla.kernel.org/>
References: <bug-217572-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217572

--- Comment #2 from Christian Theune (ct@flyingcircus.io) ---
Argh. Sorry. My brain is a bit fried today and I - for some reason - though=
t I
did the bug reports last week and not yesterday. I didn=E2=80=99t want to a=
ppear pushy,
so, sorry for the early follow-up.

*ducks*

> On 20. Jun 2023, at 17:10, Christian Theune <ct@flyingcircus.io> wrote:
>=20
> Hi,
>=20
> is there anything I can do to raise interest on this one? :)
>=20
>> On 19. Jun 2023, at 10:29, bugzilla-daemon@kernel.org wrote:
>>=20
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D217572
>>=20
>>           Bug ID: 217572
>>          Summary: Initial blocked tasks causing deterioration over hours
>>                   until (nearly) complete system lockup and data loss
>>                   with PostgreSQL 13
>>          Product: File System
>>          Version: 2.5
>>         Hardware: All
>>               OS: Linux
>>           Status: NEW
>>         Severity: high
>>         Priority: P3
>>        Component: XFS
>>         Assignee: filesystem_xfs@kernel-bugs.kernel.org
>>         Reporter: ct@flyingcircus.io
>>       Regression: No
>>=20
>> Last Friday we experienced the following hung task messages with Postgre=
SQL
>> while performing our nightly backup using pg_dump. Normally this takes at
>> most
>> a few minutes with IO being stressed. This time it caused high SYS CPU t=
ime,
>> went on for almost 20 minutes and caused the PostgreSQL dump to fail with
>> inconsistent data.
>>=20
>> Around 3:50 AM we got this:
>>=20
>> [330289.821046] INFO: task .postgres-wrapp:11884 blocked for more than 1=
22
>> seconds.
>> [330289.821830]       Not tainted 6.1.31 #1-NixOS
>> [330289.822285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
>> this message.
>> [330289.823098] task:.postgres-wrapp state:D stack:0     pid:11884
>> ppid:11881=20
>> flags:0x00000002
>> [330289.823911] Call Trace:
>> [330289.824221]  <TASK>
>> [330289.824451]  __schedule+0x35d/0x1370
>> [330289.824858]  ? mntput_no_expire+0x4a/0x250
>> [330289.825307]  schedule+0x5d/0xe0
>> [330289.825630]  rwsem_down_write_slowpath+0x34e/0x730
>> [330289.826128]  xfs_ilock+0xeb/0xf0 [xfs]
>> [330289.826599]  xfs_file_buffered_write+0x119/0x300 [xfs]
>> [330289.827212]  ? selinux_file_permission+0x10b/0x150
>> [330289.827683]  vfs_write+0x244/0x400
>> [330289.828049]  __x64_sys_pwrite64+0x94/0xc0
>> [330289.828459]  do_syscall_64+0x3a/0x90
>> [330289.828801]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [330289.829302] RIP: 0033:0x7ff8de90e7f7
>> [330289.829681] RSP: 002b:00007fff52069b08 EFLAGS: 00000202 ORIG_RAX:
>> 0000000000000012
>> [330289.830408] RAX: ffffffffffffffda RBX: 0000562bb434f510 RCX:
>> 00007ff8de90e7f7
>> [330289.831073] RDX: 0000000000002000 RSI: 00007ff888b52e80 RDI:
>> 000000000000003b
>> [330289.831762] RBP: 00000000000021b0 R08: 000000000a000010 R09:
>> 0000000000000040
>> [330289.832440] R10: 0000000004ed8000 R11: 0000000000000202 R12:
>> 0000000000002000
>> [330289.833130] R13: 0000000004ed8000 R14: 00007ff8de8176c8 R15:
>> 0000562bb434af75
>> [330289.833803]  </TASK>
>> [330289.834064] INFO: task .postgres-wrapp:1245532 blocked for more than=
 122
>> seconds.
>> [330289.834771]       Not tainted 6.1.31 #1-NixOS
>> [330289.835209] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les
>> this message.
>> [330289.835926] task:.postgres-wrapp state:D stack:0     pid:1245532
>> ppid:11881
>> flags:0x00000002
>> [330289.836752] Call Trace:
>> [330289.837010]  <TASK>
>> [330289.837258]  __schedule+0x35d/0x1370
>> [330289.837622]  ? page_add_file_rmap+0xba/0x2f0
>> [330289.838047]  ? do_set_pte+0x174/0x1c0
>> [330289.838420]  ? unix_stream_read_generic+0x223/0xa60
>> [330289.838887]  schedule+0x5d/0xe0
>> [330289.839265]  schedule_preempt_disabled+0x14/0x30
>> [330289.839758]  rwsem_down_read_slowpath+0x29e/0x4f0
>> [330289.840521]  down_read+0x47/0xb0
>> [330289.840853]  xfs_ilock+0x79/0xf0 [xfs]
>> [330289.841346]  xfs_file_buffered_read+0x44/0xd0 [xfs]
>> [330289.841945]  xfs_file_read_iter+0x6a/0xd0 [xfs]
>> [330289.842496]  vfs_read+0x23c/0x310
>> [330289.842845]  __x64_sys_pread64+0x94/0xc0
>> [330289.843303]  do_syscall_64+0x3a/0x90
>> [330289.843857]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [330289.844420] RIP: 0033:0x7ff8de90e747
>> [330289.844898] RSP: 002b:00007fff5206aae8 EFLAGS: 00000202 ORIG_RAX:
>> 0000000000000011
>> [330289.845705] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
>> 00007ff8de90e747
>> [330289.846488] RDX: 0000000000002000 RSI: 00007ff8896e0e80 RDI:
>> 0000000000000010
>> [330289.847133] RBP: 0000000000000001 R08: 000000000a00000d R09:
>> 0000000000000000
>> [330289.847627] R10: 0000000018fb8000 R11: 0000000000000202 R12:
>> 00007ff8cdd91278
>> [330289.848113] R13: 0000562bb434af75 R14: 0000562bb434f510 R15:
>> 0000562bb5e89e70
>> [330289.848631]  </TASK>
>>=20
>>=20
>> This keeps going on for a few minutes until:
>>=20
>> [330584.618978] rcu: INFO: rcu_preempt self-detected stall on CPU
>> [330584.619413] rcu:    1-....: (20999 ticks this GP)
>> idle=3D1204/1/0x4000000000000000 softirq=3D53073547/53073547 fqs=3D5231
>> [330584.620052]         (t=3D21000 jiffies g=3D142859597 q=3D21168 ncpus=
=3D3)
>> [330584.620409] CPU: 1 PID: 1246481 Comm: .postgres-wrapp Not tainted 6.=
1.31
>> #1-NixOS
>> [330584.620880] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS
>> rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>> [330584.621588] RIP: 0010:xas_load+0xb/0x40
>> [330584.621844] Code: 04 48 8b 44 c2 08 c3 cc cc cc cc 48 8b 07 48 8b 40=
 08
>> c3
>> cc cc cc cc 0f 1f 84 00 00 00 00 00 e8 3b ff ff ff 48 89 c2 83 e2 03 <48=
> 83
>> fa
>> 02 75 08 48 3d 00 10 00 00 77 05 c3 cc cc cc cc 0f b6 4f
>> [330584.622996] RSP: 0018:ffffb427c3387bf8 EFLAGS: 00000202
>> [330584.623337] RAX: ffff988876d3c002 RBX: ffffb427c3387d70 RCX:
>> 0000000000000002
>> [330584.623787] RDX: 0000000000000002 RSI: ffff98871f9d2920 RDI:
>> ffffb427c3387c00
>> [330584.624239] RBP: 000000000000f161 R08: ffffb427c3387e68 R09:
>> ffffda1444482000
>> [330584.624686] R10: 0000000000000001 R11: 0000000000000001 R12:
>> 000000000000f161
>> [330584.625136] R13: ffff9887ad3c2700 R14: 000000000000f160 R15:
>> ffffb427c3387e90
>> [330584.625591] FS:  00007ff8de817800(0000) GS:ffff98887ac80000(0000)
>> knlGS:0000000000000000
>> [330584.626097] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [330584.626467] CR2: 0000562bb434e2d8 CR3: 0000000104bd6000 CR4:
>> 00000000000006e0
>> [330584.626954] Call Trace:
>> [330584.627125]  <IRQ>
>> [330584.627281]  ? rcu_dump_cpu_stacks+0xc8/0x100
>> [330584.627567]  ? rcu_sched_clock_irq.cold+0x15b/0x2fb
>> [330584.627882]  ? sched_slice+0x87/0x140
>> [330584.628126]  ? timekeeping_update+0xdd/0x130
>> [330584.628414]  ? __cgroup_account_cputime_field+0x5b/0xa0
>> [330584.628751]  ? update_process_times+0x77/0xb0
>> [330584.629036]  ? update_wall_time+0xc/0x20
>> [330584.629300]  ? tick_sched_handle+0x34/0x50
>> [330584.629564]  ? tick_sched_timer+0x6f/0x80
>> [330584.629823]  ? tick_sched_do_timer+0xa0/0xa0
>> [330584.630103]  ? __hrtimer_run_queues+0x112/0x2b0
>> [330584.630404]  ? hrtimer_interrupt+0xfe/0x220
>> [330584.630678]  ? __sysvec_apic_timer_interrupt+0x7f/0x170
>> [330584.631016]  ? sysvec_apic_timer_interrupt+0x99/0xc0
>> [330584.631339]  </IRQ>
>> [330584.631485]  <TASK>
>> [330584.631631]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>> [330584.631974]  ? xas_load+0xb/0x40
>> [330584.632195]  ? xas_load+0x30/0x40
>> [330584.632415]  filemap_get_read_batch+0x16e/0x250
>> [330584.632710]  filemap_get_pages+0xa9/0x630
>> [330584.632972]  ? memcg_check_events+0xda/0x210
>> [330584.633259]  ? free_unref_page_commit+0x7c/0x170
>> [330584.633560]  ? _raw_spin_unlock_irqrestore+0x23/0x40
>> [330584.633880]  ? free_unref_page+0x1ac/0x220
>> [330584.634146]  filemap_read+0xd2/0x340
>> [330584.634389]  xfs_file_buffered_read+0x4f/0xd0 [xfs]
>> [330584.634778]  xfs_file_read_iter+0x6a/0xd0 [xfs]
>> [330584.635123]  vfs_read+0x23c/0x310
>> [330584.635354]  __x64_sys_pread64+0x94/0xc0
>> [330584.635609]  do_syscall_64+0x3a/0x90
>> [330584.635846]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [330584.636174] RIP: 0033:0x7ff8de90e747
>> [330584.636437] Code: 48 e8 9d dc f2 ff 41 b8 02 00 00 00 e9 38 f6 ff ff=
 66
>> 90
>> f3 0f 1e fa 80 3d bd ac 0e 00 00 49 89 ca 74 10 b8 11 00 00 00 0f 05 <48=
> 3d
>> 00
>> f0 ff ff 77 59 c3 48 83 ec 28 48 89 54 24 10 48 89 74 24
>> [330584.637582] RSP: 002b:00007fff5206aaa8 EFLAGS: 00000202 ORIG_RAX:
>> 0000000000000011
>> [330584.638056] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
>> 00007ff8de90e747
>> [330584.638506] RDX: 0000000000002000 RSI: 00007ff888b68e80 RDI:
>> 0000000000000230
>> [330584.638954] RBP: 0000000000000001 R08: 000000000a00000d R09:
>> 0000000000000000
>> [330584.639411] R10: 000000000f160000 R11: 0000000000000202 R12:
>> 00007ff8cdd92688
>> [330584.639862] R13: 0000562bb434af75 R14: 0000562bb434f510 R15:
>> 0000562bb5fe04d0
>> [330584.640313]  </TASK>
>> [330584.721995] rcu: INFO: rcu_preempt detected expedited stalls on
>> CPUs/tasks:
>> { 1-.... } 21015 jiffies s: 7297 root: 0x2/.
>> [330584.722930] rcu: blocking rcu_node structures (internal RCU debug):
>> [330584.723428] Sending NMI from CPU 0 to CPUs 1:
>> [330584.723763] NMI backtrace for cpu 1
>> [330584.723769] CPU: 1 PID: 1246481 Comm: .postgres-wrapp Not tainted 6.=
1.31
>> #1-NixOS
>> [330584.723772] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS
>> rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>> [330584.723775] RIP: 0010:xas_load+0x29/0x40
>> [330584.723783] Code: 00 e8 3b ff ff ff 48 89 c2 83 e2 03 48 83 fa 02 75=
 08
>> 48
>> 3d 00 10 00 00 77 05 c3 cc cc cc cc 0f b6 4f 10 48 8d 70 fe 38 48 fe <72=
> ee
>> e8
>> 20 fe ff ff 80 3e 00 75 d0 c3 cc cc cc cc 66 0f 1f 44 00
>> [330584.723785] RSP: 0018:ffffb427c3387bf8 EFLAGS: 00000246
>> [330584.723787] RAX: ffff98871f8dbdaa RBX: ffffb427c3387d70 RCX:
>> 0000000000000000
>> [330584.723788] RDX: 0000000000000002 RSI: ffff98871f8dbda8 RDI:
>> ffffb427c3387c00
>> [330584.723789] RBP: 000000000000f161 R08: ffffb427c3387e68 R09:
>> ffffda1444482000
>> [330584.723790] R10: 0000000000000001 R11: 0000000000000001 R12:
>> 000000000000f161
>> [330584.723791] R13: ffff9887ad3c2700 R14: 000000000000f160 R15:
>> ffffb427c3387e90
>> [330584.723793] FS:  00007ff8de817800(0000) GS:ffff98887ac80000(0000)
>> knlGS:0000000000000000
>> [330584.723794] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [330584.723795] CR2: 0000562bb434e2d8 CR3: 0000000104bd6000 CR4:
>> 00000000000006e0
>> [330584.723798] Call Trace:
>> [330584.723801]  <NMI>
>> [330584.723805]  ? nmi_cpu_backtrace.cold+0x1b/0x76
>> [330584.723810]  ? nmi_cpu_backtrace_handler+0xd/0x20
>> [330584.723814]  ? nmi_handle+0x5d/0x120
>> [330584.723817]  ? xas_load+0x29/0x40
>> [330584.723818]  ? default_do_nmi+0x69/0x170
>> [330584.723821]  ? exc_nmi+0x13c/0x170
>> [330584.723823]  ? end_repeat_nmi+0x16/0x67
>> [330584.723828]  ? xas_load+0x29/0x40
>> [330584.723830]  ? xas_load+0x29/0x40
>> [330584.723832]  ? xas_load+0x29/0x40
>> [330584.723834]  </NMI>
>> [330584.723834]  <TASK>
>> [330584.723835]  filemap_get_read_batch+0x16e/0x250
>> [330584.723840]  filemap_get_pages+0xa9/0x630
>> [330584.723842]  ? memcg_check_events+0xda/0x210
>> [330584.723845]  ? free_unref_page_commit+0x7c/0x170
>> [330584.723849]  ? _raw_spin_unlock_irqrestore+0x23/0x40
>> [330584.723851]  ? free_unref_page+0x1ac/0x220
>> [330584.723852]  filemap_read+0xd2/0x340
>> [330584.723857]  xfs_file_buffered_read+0x4f/0xd0 [xfs]
>> [330584.723935]  xfs_file_read_iter+0x6a/0xd0 [xfs]
>> [330584.723990]  vfs_read+0x23c/0x310
>> [330584.723995]  __x64_sys_pread64+0x94/0xc0
>> [330584.723997]  do_syscall_64+0x3a/0x90
>> [330584.724000]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [330584.724003] RIP: 0033:0x7ff8de90e747
>> [330584.724019] Code: 48 e8 9d dc f2 ff 41 b8 02 00 00 00 e9 38 f6 ff ff=
 66
>> 90
>> f3 0f 1e fa 80 3d bd ac 0e 00 00 49 89 ca 74 10 b8 11 00 00 00 0f 05 <48=
> 3d
>> 00
>> f0 ff ff 77 59 c3 48 83 ec 28 48 89 54 24 10 48 89 74 24
>> [330584.724020] RSP: 002b:00007fff5206aaa8 EFLAGS: 00000202 ORIG_RAX:
>> 0000000000000011
>> [330584.724021] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
>> 00007ff8de90e747
>> [330584.724022] RDX: 0000000000002000 RSI: 00007ff888b68e80 RDI:
>> 0000000000000230
>> [330584.724023] RBP: 0000000000000001 R08: 000000000a00000d R09:
>> 0000000000000000
>> [330584.724023] R10: 000000000f160000 R11: 0000000000000202 R12:
>> 00007ff8cdd92688
>> [330584.724024] R13: 0000562bb434af75 R14: 0000562bb434f510 R15:
>> 0000562bb5fe04d0
>> [330584.724026]  </TASK>
>>=20
>>=20
>> This keeps repeating until around 4:03 which ends in systemd-journal get=
ting
>> coredumped:
>>=20
>> [331277.846966] rcu: INFO: rcu_preempt self-detected stall on CPU
>> [331277.847413] rcu:    1-....: (713858 ticks this GP)
>> idle=3D1204/1/0x4000000000000000 softirq=3D53073547/53073547 fqs=3D311996
>> [331277.848088]         (t=3D714253 jiffies g=3D142859597 q=3D1821602 nc=
pus=3D3)
>> [331277.848462] CPU: 1 PID: 1246481 Comm: .postgres-wrapp Not tainted 6.=
1.31
>> #1-NixOS
>> [331277.848941] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS
>> rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>> [331277.849667] RIP: 0010:xas_descend+0x22/0x70
>> [331277.849952] Code: cc cc cc cc cc cc cc cc 0f b6 0e 48 8b 57 08 48 d3=
 ea
>> 83
>> e2 3f 89 d0 48 83 c0 04 48 8b 44 c6 08 48 89 77 18 48 89 c1 83 e1 03 <48=
> 83
>> f9
>> 02 75 08 48 3d fd 00 00 00 76 08 88 57 12 c3 cc cc cc cc
>> [331277.851120] RSP: 0018:ffffb427c3387bf0 EFLAGS: 00000202
>> [331277.851468] RAX: ffff988876d3c002 RBX: ffffb427c3387d70 RCX:
>> 0000000000000002
>> [331277.851928] RDX: 000000000000000f RSI: ffff98871f9d2920 RDI:
>> ffffb427c3387c00
>> [331277.852386] RBP: 000000000000f161 R08: ffffb427c3387e68 R09:
>> ffffda1444482000
>> [331277.852847] R10: 0000000000000001 R11: 0000000000000001 R12:
>> 000000000000f161
>> [331277.853303] R13: ffff9887ad3c2700 R14: 000000000000f160 R15:
>> ffffb427c3387e90
>> [331277.853766] FS:  00007ff8de817800(0000) GS:ffff98887ac80000(0000)
>> knlGS:0000000000000000
>> [331277.854278] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [331277.854653] CR2: 0000562bb434e2d8 CR3: 0000000104bd6000 CR4:
>> 00000000000006e0
>> [331277.855111] Call Trace:
>> [331277.855284]  <IRQ>
>> [331277.855433]  ? rcu_dump_cpu_stacks+0xc8/0x100
>> [331277.855730]  ? rcu_sched_clock_irq.cold+0x15b/0x2fb
>> [331277.856049]  ? sched_slice+0x87/0x140
>> [331277.856294]  ? timekeeping_update+0xdd/0x130
>> [331277.856587]  ? __cgroup_account_cputime_field+0x5b/0xa0
>> [331277.856930]  ? update_process_times+0x77/0xb0
>> [331277.857222]  ? update_wall_time+0xc/0x20
>> [331277.857482]  ? tick_sched_handle+0x34/0x50
>> [331277.857758]  ? tick_sched_timer+0x6f/0x80
>> [331277.858024]  ? tick_sched_do_timer+0xa0/0xa0
>> [331277.858306]  ? __hrtimer_run_queues+0x112/0x2b0
>> [331277.858613]  ? hrtimer_interrupt+0xfe/0x220
>> [331277.858891]  ? __sysvec_apic_timer_interrupt+0x7f/0x170
>> [331277.859235]  ? sysvec_apic_timer_interrupt+0x99/0xc0
>> [331277.859558]  </IRQ>
>> [331277.859710]  <TASK>
>> [331277.859857]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>> [331277.860206]  ? xas_descend+0x22/0x70
>> [331277.860446]  xas_load+0x30/0x40
>> [331277.860665]  filemap_get_read_batch+0x16e/0x250
>> [331277.860967]  filemap_get_pages+0xa9/0x630
>> [331277.861233]  ? memcg_check_events+0xda/0x210
>> [331277.861517]  ? free_unref_page_commit+0x7c/0x170
>> [331277.861834]  ? _raw_spin_unlock_irqrestore+0x23/0x40
>> [331277.862158]  ? free_unref_page+0x1ac/0x220
>> [331277.862427]  filemap_read+0xd2/0x340
>> [331277.862677]  xfs_file_buffered_read+0x4f/0xd0 [xfs]
>> [331277.863072]  xfs_file_read_iter+0x6a/0xd0 [xfs]
>> [331277.863424]  vfs_read+0x23c/0x310
>> [331277.863657]  __x64_sys_pread64+0x94/0xc0
>> [331277.863917]  do_syscall_64+0x3a/0x90
>> [331277.864159]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [331277.864488] RIP: 0033:0x7ff8de90e747
>> [331277.864752] Code: 48 e8 9d dc f2 ff 41 b8 02 00 00 00 e9 38 f6 ff ff=
 66
>> 90
>> f3 0f 1e fa 80 3d bd ac 0e 00 00 49 89 ca 74 10 b8 11 00 00 00 0f 05 <48=
> 3d
>> 00
>> f0 ff ff 77 59 c3 48 83 ec 28 48 89 54 24 10 48 89 74 24
>> [331277.865917] RSP: 002b:00007fff5206aaa8 EFLAGS: 00000202 ORIG_RAX:
>> 0000000000000011
>> [331277.866395] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
>> 00007ff8de90e747
>> [331277.866848] RDX: 0000000000002000 RSI: 00007ff888b68e80 RDI:
>> 0000000000000230
>> [331277.867298] RBP: 0000000000000001 R08: 000000000a00000d R09:
>> 0000000000000000
>> [331277.867750] R10: 000000000f160000 R11: 0000000000000202 R12:
>> 00007ff8cdd92688
>> [331277.868199] R13: 0000562bb434af75 R14: 0000562bb434f510 R15:
>> 0000562bb5fe04d0
>> [331277.868658]  </TASK>
>> Fri Jun 16 04:03:23 AM CEST 2023 -- SERIAL CONSOLE IS LIVE --
>> [331289.987247] systemd[1]: Starting Serial console liveness marker...
>> [331289.992645] systemd[1]: nscd.service: Deactivated successfully.
>> [331290.011838] systemd[1]: nscd.service: Consumed 3min 16.251s CPU time,
>> received 12.0M IP traffic, sent 8.2M IP traffic.
>> [331290.020289] systemd[1]: serial-console-liveness.service: Deactivated
>> successfully.
>> [331290.035818] systemd[1]: Finished Serial console liveness marker.
>> [331290.068776] systemd[1]: Started Logrotate Service.
>> [331290.069700] systemd[1]: systemd-journald.service: Watchdog timeout
>> (limit
>> 3min)!
>> [331290.070475] systemd[1]: systemd-journald.service: Killing process 528
>> (systemd-journal) with signal SIGABRT.
>> [331290.096246] systemd[1]: logrotate.service: Deactivated successfully.
>> [331290.285285] systemd-coredump[1267441]: Process 528 (systemd-journal)=
 of
>> user 0 dumped core.
>> [331290.286002] systemd-coredump[1267441]: Coredump diverted to
>>
>> /var/lib/systemd/coredump/core.systemd-journal.0.39df468c96764e8c8fffc53=
a0d0a47d1.528.1686881003000000.zst
>> [331290.287045] systemd-coredump[1267441]: Module libaudit.so.1 without
>> build-id.
>> [331290.287574] systemd-coredump[1267441]: Module libnftnl.so.11 without
>> build-id.
>> [331290.288111] systemd-coredump[1267441]: Module libmnl.so.0 without
>> build-id.
>> [331290.288587] systemd-coredump[1267441]: Module libgpg-error.so.0 with=
out
>> build-id.
>> [331290.289076] systemd-coredump[1267441]: Module libattr.so.1 without
>> build-id.
>> [331290.289541] systemd-coredump[1267441]: Module libzstd.so.1 without
>> build-id.
>> [331290.289991] systemd-coredump[1267441]: Module liblzma.so.5 without
>> build-id.
>> [331290.290446] systemd-coredump[1267441]: Module libseccomp.so.2 without
>> build-id.
>> [331290.290940] systemd-coredump[1267441]: Module libpam.so.0 without
>> build-id.
>> [331290.291419] systemd-coredump[1267441]: Module liblz4.so.1 without
>> build-id.
>> [331290.291893] systemd-coredump[1267441]: Module libkmod.so.2 without
>> build-id.
>> [331290.292370] systemd-coredump[1267441]: Module libip4tc.so.2 without
>> build-id.
>> [331290.295165] systemd-coredump[1267441]: Module libgcrypt.so.20 without
>> build-id.
>> [331290.295678] systemd-coredump[1267441]: Module libcrypt.so.2 without
>> build-id.
>> [331290.296160] systemd-coredump[1267441]: Module libcap.so.2 without
>> build-id.
>> [331290.296708] systemd-coredump[1267441]: Module libacl.so.1 without
>> build-id.
>> [331290.297206] systemd-coredump[1267441]: Module libsystemd-shared-253.=
so
>> without build-id.
>> [331290.297768] systemd-coredump[1267441]: Module systemd-journald witho=
ut
>> build-id.
>> [331290.298273] systemd-coredump[1267441]: Stack trace of thread 528:
>> [331290.298714] systemd-coredump[1267441]: #0  0x00007f3e96431de8
>> check_object_header (libsystemd-shared-253.so + 0x231de8)
>> [331290.299435] systemd-coredump[1267441]: #1  0x00007f3e964330d2
>> journal_file_move_to_object (libsystemd-shared-253.so + 0x2330d2)
>> [331290.300199] systemd-coredump[1267441]: #2  0x00007f3e96434a71
>> journal_file_find_data_object_with_hash (libsystemd-shared-253.so +
>> 0x234a71)
>> [331290.302207] systemd-coredump[1267441]: #3  0x00007f3e96434d3b
>> journal_file_append_data (libsystemd-shared-253.so + 0x234d3b)
>> [331290.302983] systemd-coredump[1267441]: #4  0x00007f3e96437243
>> journal_file_append_entry (libsystemd-shared-253.so + 0x237243)
>> [331290.303767] systemd-coredump[1267441]: #5  0x000056536a4a7cd5
>> server_dispatch_message_real (systemd-journald + 0x10cd5)
>> [331290.304504] systemd-coredump[1267441]: #6  0x000056536a4a134b
>> dev_kmsg_record (systemd-journald + 0xa34b)
>> [331290.305195] systemd-coredump[1267441]: #7  0x000056536a4a182b
>> server_read_dev_kmsg (systemd-journald + 0xa82b)
>> [331290.305922] systemd-coredump[1267441]: #8  0x00007f3e9645c140
>> source_dispatch (libsystemd-shared-253.so + 0x25c140)
>> [331290.306640] systemd-coredump[1267441]: #9  0x00007f3e9645c42d
>> sd_event_dispatch (libsystemd-shared-253.so + 0x25c42d)
>> [331290.307350] systemd-coredump[1267441]: #10 0x00007f3e9645cb48
>> sd_event_run
>> (libsystemd-shared-253.so + 0x25cb48)
>> [331290.308043] systemd-coredump[1267441]: #11 0x000056536a4a0568 main
>> (systemd-journald + 0x9568)
>> [331290.308652] systemd-coredump[1267441]: #12 0x00007f3e9603dace
>> __libc_start_call_main (libc.so.6 + 0x23ace)
>> [331290.309292] systemd-coredump[1267441]: #13 0x00007f3e9603db89
>> __libc_start_main@@GLIBC_2.34 (libc.so.6 + 0x23b89)
>> [331290.310048] systemd-coredump[1267441]: #14 0x000056536a4a0835 _start
>> (systemd-journald + 0x9835)
>> [331290.310692] systemd-coredump[1267441]: ELF object binary architectur=
e:
>> AMD
>> x86-64
>>=20
>>=20
>> This go back to normal until around 20:03 (around 14 hours later):
>>=20
>> [389370.873026] rcu: INFO: rcu_preempt self-detected stall on CPU
>> [389370.873481] rcu:    0-....: (21000 ticks this GP)
>> idle=3D91fc/1/0x4000000000000000 softirq=3D85252827/85252827 fqs=3D4704
>> [389370.874126]         (t=3D21002 jiffies g=3D167843445 q=3D13889 ncpus=
=3D3)
>> [389370.874500] CPU: 0 PID: 2202919 Comm: .postgres-wrapp Not tainted 6.=
1.31
>> #1-NixOS
>> [389370.874979] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS
>> rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>> [389370.875710] RIP: 0010:xas_descend+0x26/0x70
>> [389370.875991] Code: cc cc cc cc 0f b6 0e 48 8b 57 08 48 d3 ea 83 e2 3f=
 89
>> d0
>> 48 83 c0 04 48 8b 44 c6 08 48 89 77 18 48 89 c1 83 e1 03 48 83 f9 02 <75=
> 08
>> 48
>> 3d fd 00 00 00 76 08 88 57 12 c3 cc cc cc cc 48 c1 e8 02
>> [389370.877164] RSP: 0018:ffffb427c4917bf0 EFLAGS: 00000246
>> [389370.877512] RAX: ffff98871f8dbdaa RBX: ffffb427c4917d70 RCX:
>> 0000000000000002
>> [389370.877967] RDX: 0000000000000005 RSI: ffff988876d3c000 RDI:
>> ffffb427c4917c00
>> [389370.878426] RBP: 000000000000f177 R08: ffffb427c4917e68 R09:
>> ffff988846485d38
>> [389370.878880] R10: ffffb427c4917e60 R11: ffff988846485d38 R12:
>> 000000000000f177
>> [389370.879341] R13: ffff988827b4ae00 R14: 000000000000f176 R15:
>> ffffb427c4917e90
>> [389370.879798] FS:  00007ff8de817800(0000) GS:ffff98887ac00000(0000)
>> knlGS:0000000000000000
>> [389370.880308] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [389370.880683] CR2: 00007ff881c8c000 CR3: 000000010dfea000 CR4:
>> 00000000000006f0
>> [389370.881139] Call Trace:
>> [389370.881309]  <IRQ>
>> [389370.881463]  ? rcu_dump_cpu_stacks+0xc8/0x100
>> [389370.881755]  ? rcu_sched_clock_irq.cold+0x15b/0x2fb
>> [389370.882077]  ? sched_slice+0x87/0x140
>> [389370.882325]  ? perf_event_task_tick+0x64/0x370
>> [389370.882629]  ? __cgroup_account_cputime_field+0x5b/0xa0
>> [389370.882968]  ? update_process_times+0x77/0xb0
>> [389370.883258]  ? tick_sched_handle+0x34/0x50
>> [389370.883538]  ? tick_sched_timer+0x6f/0x80
>> [389370.883802]  ? tick_sched_do_timer+0xa0/0xa0
>> [389370.884084]  ? __hrtimer_run_queues+0x112/0x2b0
>> [389370.884388]  ? hrtimer_interrupt+0xfe/0x220
>> [389370.884666]  ? __sysvec_apic_timer_interrupt+0x7f/0x170
>> [389370.885006]  ? sysvec_apic_timer_interrupt+0x99/0xc0
>> [389370.885338]  </IRQ>
>> [389370.885488]  <TASK>
>> [389370.885636]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>> [389370.885983]  ? xas_descend+0x26/0x70
>> [389370.886224]  xas_load+0x30/0x40
>> [389370.886456]  filemap_get_read_batch+0x16e/0x250
>> [389370.886758]  filemap_get_pages+0xa9/0x630
>> [389370.887026]  ? atime_needs_update+0x104/0x180
>> [389370.887317]  ? touch_atime+0x46/0x1f0
>> [389370.887573]  filemap_read+0xd2/0x340
>> [389370.887817]  xfs_file_buffered_read+0x4f/0xd0 [xfs]
>> [389370.888210]  xfs_file_read_iter+0x6a/0xd0 [xfs]
>> [389370.888571]  vfs_read+0x23c/0x310
>> [389370.888797]  __x64_sys_pread64+0x94/0xc0
>> [389370.889058]  do_syscall_64+0x3a/0x90
>> [389370.889299]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> [389370.889634] RIP: 0033:0x7ff8de90e747
>> [389370.889900] Code: 48 e8 9d dc f2 ff 41 b8 02 00 00 00 e9 38 f6 ff ff=
 66
>> 90
>> f3 0f 1e fa 80 3d bd ac 0e 00 00 49 89 ca 74 10 b8 11 00 00 00 0f 05 <48=
> 3d
>> 00
>> f0 ff ff 77 59 c3 48 83 ec 28 48 89 54 24 10 48 89 74 24
>> [389370.891063] RSP: 002b:00007fff5206a848 EFLAGS: 00000202 ORIG_RAX:
>> 0000000000000011
>> [389370.891549] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
>> 00007ff8de90e747
>> [389370.892003] RDX: 0000000000002000 RSI: 00007ff881c8ce80 RDI:
>> 00000000000001c7
>> [389370.892466] RBP: 0000000000000001 R08: 000000000a00000d R09:
>> 0000000000000000
>> [389370.892923] R10: 000000000f176000 R11: 0000000000000202 R12:
>> 00007ff8cdd91278
>> [389370.893386] R13: 0000562bb434af75 R14: 0000562bb434f510 R15:
>> 0000562bb5e55828
>> [389370.893843]  </TASK>
>>=20
>>=20
>> At this point we have to restart the VM externally because it didn't res=
pond
>> properly any longer.
>>=20
>> --=20
>> You may reply to this email to add a comment.
>>=20
>> You are receiving this mail because:
>> You are watching the assignee of the bug.
>=20
>=20
> Liebe Gr=C3=BC=C3=9Fe,
> Christian Theune
>=20
> --=20
> Christian Theune =C2=B7 ct@flyingcircus.io =C2=B7 +49 345 219401 0
> Flying Circus Internet Operations GmbH =C2=B7 https://flyingcircus.io
> Leipziger Str. 70/71 =C2=B7 06108 Halle (Saale) =C2=B7 Deutschland
> HR Stendal HRB 21169 =C2=B7 Gesch=C3=A4ftsf=C3=BChrer: Christian Theune, =
Christian
> Zagrodnick
>=20

Liebe Gr=C3=BC=C3=9Fe,
Christian Theune

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
