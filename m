Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021ABC4167B
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 15:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbjKBP2G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 11:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjKBP2F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 11:28:05 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF6B121
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 08:27:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69527C43397
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698938879;
        bh=ozQUknUyJfdYLro+WXZxCYv+w3M7XYlodjkjIVnZqnw=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=Bwhcmi4AzHIg7bOijEfHVcH7km+SEN7znjBqZl6dmxH0E4oEMv3jGHywU+s5W9gMW
         Bh+yl1dEbFTFVZohJ/MG9JZlSz/Qo2Gp20EEzdP0qVlJSvu9LC+wC7GMckLDYoOc+Z
         wYeEnghCsA0L+GeLgW/rHC4JJCr1i3K/Q80pMOsaWQ+27UkCPSaC7f+32wt6KslevW
         B2fPHkG+i2HlaHTtQ+i/TGoYQt5XqAAEHacJJeQu7Vy8aSQhHKyY4LF86lEkxqBWiU
         TsXpA1gQ0kpOrZZRgYEUG24D4oeD3SqeJyn0A96LrNFvJv4L6apC1mSEhGPsiguSNf
         Wgmv3+LC0akXg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 575EBC4332E; Thu,  2 Nov 2023 15:27:59 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217572] Initial blocked tasks causing deterioration over hours
 until (nearly) complete system lockup and data loss with PostgreSQL 13
Date:   Thu, 02 Nov 2023 15:27:58 +0000
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
Message-ID: <bug-217572-201763-LUmZsDeuuk@https.bugzilla.kernel.org/>
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

--- Comment #18 from Christian Theune (ct@flyingcircus.io) ---
We've updated a while ago and our fleet is not seeing improved results. The=
y've
actually seemed to have gotten worse according to the number of alerts we've
seen.=20

We've had a multitude of crashes in the last weeks with the following
statistics:

6.1.31 - 2 affected machines
6.1.35 - 1 affected machine
6.1.37 - 1 affected machine
6.1.51 - 5 affected machines
6.1.55 - 2 affected machines
6.1.57 - 2 affected machines

Here's the more detailed behaviour of one of the machines with 6.1.57.

$ uptime
 16:10:23  up 13 days 19:00,  1 user,  load average: 3.21, 1.24, 0.57

$ uname -a
Linux ts00 6.1.57 #1-NixOS SMP PREEMPT_DYNAMIC Tue Oct 10 20:00:46 UTC 2023
x86_64 GNU/Linux

And here' the stall:

[654042.623386] rcu: INFO: rcu_preempt self-detected stall on CPU
[654042.624109] rcu:    1-....: (21079 ticks this GP)
idle=3D380c/1/0x4000000000000000 softirq=3D136208646/136208648 fqs=3D7552
[654042.625253]         (t=3D21000 jiffies g=3D210623333 q=3D40912 ncpus=3D=
2)
[654042.625871] CPU: 1 PID: 1230375 Comm: nix-build Not tainted 6.1.57 #1-N=
ixOS
[654042.626650] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
[654042.627898] RIP: 0010:xas_descend+0x22/0x90
[654042.628379] Code: cc cc cc cc cc cc cc cc 0f b6 0e 48 8b 57 08 48 d3 ea=
 83
e2 3f 89 d0 48 83 c0 04 48 8b 44 c6 08 48 89 77 18 48 89 c1 83 e1 03 <48> 8=
3 f9
02 75 08 48 3d fd 00 00 00 76 08 88 57 12 c3 cc cc cc cc
[654042.630402] RSP: 0018:ffffa213c4c07bf8 EFLAGS: 00000202
[654042.630993] RAX: ffff8f9da3bca492 RBX: ffffa213c4c07d78 RCX:
0000000000000002
[654042.631782] RDX: 0000000000000004 RSI: ffff8f9eb8700248 RDI:
ffffa213c4c07c08
[654042.632570] RBP: 000000000000010f R08: ffffa213c4c07e70 R09:
ffff8f9e54dc2138
[654042.633352] R10: ffffa213c4c07e68 R11: ffff8f9e54dc2138 R12:
000000000000010f
[654042.634140] R13: ffff8f9d44c7ad00 R14: 0000000000000100 R15:
ffffa213c4c07e98
[654042.634934] FS:  00007faf9514ff80(0000) GS:ffff8f9ebad00000(0000)
knlGS:0000000000000000
[654042.635823] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[654042.636468] CR2: 00007faf78168000 CR3: 00000000366d2000 CR4:
00000000000006e0
[654042.637264] Call Trace:
[654042.637560]  <IRQ>
[654042.637809]  ? rcu_dump_cpu_stacks+0xc8/0x100
[654042.638305]  ? rcu_sched_clock_irq.cold+0x15b/0x2fb
[654042.638862]  ? sched_slice+0x87/0x140
[654042.639281]  ? timekeeping_update+0xdd/0x130
[654042.639781]  ? __cgroup_account_cputime_field+0x5b/0xa0
[654042.640363]  ? update_process_times+0x77/0xb0
[654042.640862]  ? update_wall_time+0xc/0x20
[654042.641305]  ? tick_sched_handle+0x34/0x50
[654042.641773]  ? tick_sched_timer+0x6f/0x80
[654042.642224]  ? tick_sched_do_timer+0xa0/0xa0
[654042.642710]  ? __hrtimer_run_queues+0x112/0x2b0
[654042.643220]  ? hrtimer_interrupt+0xfe/0x220
[654042.643703]  ? __sysvec_apic_timer_interrupt+0x7f/0x170
[654042.644286]  ? sysvec_apic_timer_interrupt+0x99/0xc0
[654042.644849]  </IRQ>
[654042.645101]  <TASK>
[654042.645353]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
[654042.645956]  ? xas_descend+0x22/0x90
[654042.646366]  xas_load+0x30/0x40
[654042.646738]  filemap_get_read_batch+0x16e/0x250
[654042.647253]  filemap_get_pages+0xa9/0x630
[654042.647714]  filemap_read+0xd2/0x340
[654042.648124]  ? __mod_memcg_lruvec_state+0x6e/0xd0
[654042.648670]  xfs_file_buffered_read+0x4f/0xd0 [xfs]
[654042.649307]  xfs_file_read_iter+0x6a/0xd0 [xfs]
[654042.649887]  vfs_read+0x23c/0x310
[654042.650276]  ksys_read+0x6b/0xf0
[654042.650658]  do_syscall_64+0x3a/0x90
[654042.651071]  entry_SYSCALL_64_after_hwframe+0x64/0xce
[654042.651650] RIP: 0033:0x7faf968ee78c
[654042.652085] Code: ec 28 48 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 a9=
 bb
f8 ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 31 c0 0f 05 <48> 3=
d 00
f0 ff ff 77 34 44 89 c7 48 89 44 24 08 e8 ff bb f8 ff 48
[654042.654113] RSP: 002b:00007fff8d7e72e0 EFLAGS: 00000246 ORIG_RAX:
0000000000000000
[654042.654954] RAX: ffffffffffffffda RBX: 00005572a3d2c5f0 RCX:
00007faf968ee78c
[654042.655745] RDX: 0000000000010000 RSI: 00005572a3d2c5f0 RDI:
000000000000000c
[654042.656540] RBP: 00007fff8d7e7380 R08: 0000000000000000 R09:
0000000000000000
[654042.657327] R10: 0000000000000022 R11: 0000000000000246 R12:
000000000000000c
[654042.658119] R13: 00007faf96dfe6a8 R14: 0000000000000001 R15:
0000000000000001
[654042.658916]  </TASK>

In previous situations this self-detected stall only happened after other
errors occured before them, afaict this is now happening "standalone" witho=
ut
those other errors, maybe this is new info?

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
