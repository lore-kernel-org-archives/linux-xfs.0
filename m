Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967F3C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  9 Oct 2022 12:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJIMIc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 9 Oct 2022 08:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiJIMIa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 9 Oct 2022 08:08:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A474326AFC
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 05:08:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31EC860AE2
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 12:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92555C43141
        for <linux-xfs@vger.kernel.org>; Sun,  9 Oct 2022 12:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665317308;
        bh=SYZkkdlCU3WGODLU3qviDXYEK5vMaJZwTPfyRxO66LU=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=jynR1Zo8uJ2ACNORwP49HNHUNMZk8Bf2eIvEUPkEKRi+XJN1zP0pIE3ihKTv80QS0
         PJdbsLJhETviLI2LdFoZWME6b9OHvqxvMOVptwqzorQz9rjNxJKdPtygUCf7X4ZSdF
         4YNGokBS8qaaQTZ5KKuSwkoBVhqXIcciboYSC7qJPiLCO1B6r+hmd0Ij0eLLFjIxcZ
         WfdmMelGsiPfx8pZD42jCHQJRx87vsRvp/NczHnJn8iadGNvbF5QAopgFFfZrGbXjS
         DVr5wP3yBp/n4++gJ2nvfGxexxqDMAIaTJhB9ipE7yqtRfHx86ALf7A9aH7H+rmqEl
         +uJIpq1vQkMsQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 623D7C433E4; Sun,  9 Oct 2022 12:08:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216563] [xfstests generic/113] memcpy: detected field-spanning
 write (size 32) of single field "efdp->efd_format.efd_extents" at
 fs/xfs/xfs_extfree_item.c:693 (size 16)
Date:   Sun, 09 Oct 2022 12:08:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216563-201763-v2RIn43NFW@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216563-201763@https.bugzilla.kernel.org/>
References: <bug-216563-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216563

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
decode_stacktrace.sh output:

[11223.467241] memcpy: detected field-spanning write (size 32) of single fi=
eld
"efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 16)=
=20=20=20=20=20=20=20
[11223.467271] WARNING: CPU: 7 PID: 604448 at fs/xfs/xfs_extfree_item.c:693
xfs_efi_item_relog (fs/xfs/xfs_extfree_item.c:693 (discriminator 3)) xfs=20=
=20=20=20=20=20=20=20
[11223.467349] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 lo=
op
dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod
 t10_pi sg ibmvscsi ibmveth scsi_transport_srp vmx_crypto [last unloaded:
scsi_debug]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467408] Workqueue: xfs-inodegc/sda5 xfs_inodegc_worker [xfs]=20=20=
=20=20=20=20=20=20=20=20=20=20=20
[11223.467478] NIP:  c008000001e001cc LR: c008000001e001c8 CTR:
0000000000000000=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467484] REGS: c000000045893610 TRAP: 0700   Not tainted  (6.0.0+)=20=
=20=20=20=20=20=20=20
[11223.467490] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
48004222  XER: 0000000a=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467514] CFAR: c000000000150060 IRQMASK: 0=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
GPR00: c008000001e001c8 c0000000458938b0 c008000001ebc000 0000000000000089
GPR04: 0000000000000000 c0000000458936b0 c0000000458936a8 00000001fbb90000=
=20=20=20=20=20=20
GPR08: 0000000000000027 0000000000000000 c000000095728800 0000000000004000=
=20=20=20=20=20=20
GPR12: 00000001fbb90000 c00000000ffc9080 0000000000000000 0000000000000000=
=20=20=20=20=20=20
GPR16: c008000001d4df14 fffffffffffff000 c000000002d40a30 c000000002d404b0
GPR20: c000000095728800 c0000000458939d8 0000000000000000 0000000000000000=
=20=20=20=20=20=20
GPR24: c000000002d40a30 0000000000000002 c000000033c654f0 0000000000000002
GPR28: 0000000000000020 c0000000488816a8 c000000033016440 c000000033c65438=
=20=20=20=20=20=20
[11223.467598] NIP [c008000001e001cc] xfs_efi_item_relog
(fs/xfs/xfs_extfree_item.c:693 (discriminator 3)) xfs=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467667] LR [c008000001e001c8] xfs_efi_item_relog
(fs/xfs/xfs_extfree_item.c:693 (discriminator 3)) xfs=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467737] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467741] [c0000000458938b0] [c008000001e001c8]
xfs_efi_item_relog+0x180/0x1d0 [xfs] unreliable=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467814] [c000000045893950] [c008000001d4d198] xfs_defer_relog
(./fs/xfs/xfs_trans.h:255 fs/xfs/libxfs/xfs_defer.c:451) xfs=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467879] [c0000000458939b0] [c008000001d4d6d8] xfs_defer_finish_noroll
(fs/xfs/libxfs/xfs_defer.c:557) xfs=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
[11223.467943] [c000000045893a80] [c008000001d4df14] xfs_defer_finish
(fs/xfs/libxfs/xfs_defer.c:591) xfs=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20
[11223.468007] [c000000045893ab0] [c008000001dcd74c]
xfs_itruncate_extents_flags (fs/xfs/xfs_inode.c:1378) xfs=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468077] [c000000045893b40] [c008000001dcde14] xfs_inactive_truncate
(fs/xfs/xfs_inode.c:1518) xfs=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20
[11223.468146] [c000000045893b90] [c008000001dcec18] xfs_inactive
(fs/xfs/xfs_inode.c:1758) xfs=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20
[11223.468214] [c000000045893be0] [c008000001dba36c] xfs_inodegc_worker
(fs/xfs/xfs_icache.c:1838 fs/xfs/xfs_icache.c:1862) xfs=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468284] [c000000045893c40] [c000000000185298] process_one_work
(kernel/workqueue.c:2289)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468294] [c000000045893d30] [c000000000185848] worker_thread
(./include/linux/list.h:292 kernel/workqueue.c:2437)=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468302] [c000000045893dc0] [c0000000001945b8] kthread
(kernel/kthread.c:376)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468309] [c000000045893e10] [c00000000000cbe4] ret_from_kernel_thread
(arch/powerpc/kernel/interrupt_64.S:718)=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20
[11223.468319] Instruction dump:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
[11223.468324] 2c0a0000 4082ff30 3d420000 38c00010 7f84e378 e8aaf9e8 3d4200=
00
e86af9f0=20=20=20=20=20=20=20=20=20
[11223.468342] 39400001 99490000 48054b35 e8410018 <0fe00000> 3d220000 e929=
f9e0
89490001=20=20
[11223.468359] irq event stamp: 97484=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
[11223.468363] hardirqs last enabled at (97483): __up_console_sem
(kernel/printk/printk.c:264 (discriminator 1))=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468371] hardirqs last disabled at (97484): interrupt_enter_prepare
(./arch/powerpc/include/asm/interrupt.h:182)=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[11223.468380] softirqs last enabled at (95310): __do_softirq
(./arch/powerpc/include/asm/current.h:20 ./include/asm-generic/preempt.h:11
kernel/softirq.c:415 kernel/softirq.c:600)=20=20=20=20=20=20=20=20=20=20=20
[11223.468388] softirqs last disabled at (95259): do_softirq_own_stack
(arch/powerpc/kernel/irq.c:206 arch/powerpc/kernel/irq.c:341)=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468395] ---[ end trace 0000000000000000 ]---=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468403] ------------[ cut here ]------------
[11223.467241] memcpy: detected field-spanning write (size 32) of single fi=
eld
"efdp->efd_format.efd_extents" at fs/xfs/xfs_extfree_item.c:693 (size 16)=
=20=20=20=20=20=20=20
[11223.467271] WARNING: CPU: 7 PID: 604448 at fs/xfs/xfs_extfree_item.c:693
xfs_efi_item_relog (fs/xfs/xfs_extfree_item.c:693 (discriminator 3)) xfs=20=
=20=20=20=20=20=20=20
[11223.467349] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 lo=
op
dm_flakey dm_mod bonding tls rfkill sunrpc pseries_rng drm fuse
drm_panel_orientation_quirks xfs libcrc32c sd_mod
 t10_pi sg ibmvscsi ibmveth scsi_transport_srp vmx_crypto [last unloaded:
scsi_debug]=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467408] Workqueue: xfs-inodegc/sda5 xfs_inodegc_worker [xfs]=20=20=
=20=20=20=20=20=20=20=20=20=20=20
[11223.467478] NIP:  c008000001e001cc LR: c008000001e001c8 CTR:
0000000000000000=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467484] REGS: c000000045893610 TRAP: 0700   Not tainted  (6.0.0+)=20=
=20=20=20=20=20=20=20
[11223.467490] MSR:  800000000282b033 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
48004222  XER: 0000000a
[11223.467514] CFAR: c000000000150060 IRQMASK: 0=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
GPR00: c008000001e001c8 c0000000458938b0 c008000001ebc000 0000000000000089
GPR04: 0000000000000000 c0000000458936b0 c0000000458936a8 00000001fbb90000
GPR08: 0000000000000027 0000000000000000 c000000095728800 0000000000004000
GPR12: 00000001fbb90000 c00000000ffc9080 0000000000000000 0000000000000000
GPR16: c008000001d4df14 fffffffffffff000 c000000002d40a30 c000000002d404b0
GPR20: c000000095728800 c0000000458939d8 0000000000000000 0000000000000000
GPR24: c000000002d40a30 0000000000000002 c000000033c654f0 0000000000000002
GPR28: 0000000000000020 c0000000488816a8 c000000033016440 c000000033c65438=
=20=20=20=20=20=20
[11223.467598] NIP [c008000001e001cc] xfs_efi_item_relog
(fs/xfs/xfs_extfree_item.c:693 (discriminator 3)) xfs
[11223.467667] LR [c008000001e001c8] xfs_efi_item_relog
(fs/xfs/xfs_extfree_item.c:693 (discriminator 3)) xfs
[11223.467737] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467741] [c0000000458938b0] [c008000001e001c8]
xfs_efi_item_relog+0x180/0x1d0 [xfs] unreliable=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.467814] [c000000045893950] [c008000001d4d198] xfs_defer_relog
(./fs/xfs/xfs_trans.h:255 fs/xfs/libxfs/xfs_defer.c:451) xfs
[11223.467879] [c0000000458939b0] [c008000001d4d6d8] xfs_defer_finish_noroll
(fs/xfs/libxfs/xfs_defer.c:557) xfs
[11223.467943] [c000000045893a80] [c008000001d4df14] xfs_defer_finish
(fs/xfs/libxfs/xfs_defer.c:591) xfs=20=20=20=20=20
[11223.468007] [c000000045893ab0] [c008000001dcd74c]
xfs_itruncate_extents_flags (fs/xfs/xfs_inode.c:1378) xfs
[11223.468077] [c000000045893b40] [c008000001dcde14] xfs_inactive_truncate
(fs/xfs/xfs_inode.c:1518) xfs
[11223.468146] [c000000045893b90] [c008000001dcec18] xfs_inactive
(fs/xfs/xfs_inode.c:1758) xfs=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468214] [c000000045893be0] [c008000001dba36c] xfs_inodegc_worker
(fs/xfs/xfs_icache.c:1838 fs/xfs/xfs_icache.c:1862) xfs
[11223.468284] [c000000045893c40] [c000000000185298] process_one_work
(kernel/workqueue.c:2289)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
[11223.468294] [c000000045893d30] [c000000000185848] worker_thread
(./include/linux/list.h:292 kernel/workqueue.c:2437)=20
[11223.468302] [c000000045893dc0] [c0000000001945b8] kthread
(kernel/kthread.c:376)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468309] [c000000045893e10] [c00000000000cbe4] ret_from_kernel_thread
(arch/powerpc/kernel/interrupt_64.S:718)=20
[11223.468319] Instruction dump:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20
[11223.468324] 2c0a0000 4082ff30 3d420000 38c00010 7f84e378 e8aaf9e8 3d4200=
00
e86af9f0=20=20
[11223.468342] 39400001 99490000 48054b35 e8410018 <0fe00000> 3d220000 e929=
f9e0
89490001
[11223.468359] irq event stamp: 97484=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20
[11223.468363] hardirqs last enabled at (97483): __up_console_sem
(kernel/printk/printk.c:264 (discriminator 1))=20=20=20=20=20=20=20
[11223.468371] hardirqs last disabled at (97484): interrupt_enter_prepare
(./arch/powerpc/include/asm/interrupt.h:182)=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20
[11223.468380] softirqs last enabled at (95310): __do_softirq
(./arch/powerpc/include/asm/current.h:20 ./include/asm-generic/preempt.h:11
kernel/softirq.c:415 kernel/softirq.c:600)=20
[11223.468388] softirqs last disabled at (95259): do_softirq_own_stack
(arch/powerpc/kernel/irq.c:206 arch/powerpc/kernel/irq.c:341)=20
[11223.468395] ---[ end trace 0000000000000000 ]---=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
[11223.468403] ------------[ cut here ]------------
...

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
