Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92050C7618A
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Mar 2023 06:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCTGwm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Mar 2023 02:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCTGwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2023 02:52:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB501352F
        for <linux-xfs@vger.kernel.org>; Sun, 19 Mar 2023 23:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4F1D6122D
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 06:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43F06C433A1
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 06:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679295151;
        bh=eX4cIU9B7UYJleHiRPw3/a52VeR9X7StUuPYM9Hk77c=;
        h=From:To:Subject:Date:From;
        b=deRpH1ILG51Q1t7aP6XXnm0hdAoOuD+ZcGAulAY4hTcPPHM/fMMAyETXequebU9Ox
         vP1W201XOaeg2g25K9M/7inw1myyTLmfbEIXj6QDA1Rn+4kT6kRvS0x1nJbtMmXiZr
         K5HLldN2y9pXA4qBTsQqRGZtwCsifpcYxC+hCakqIsfY7X+SRXclx+BJdMiTmtKxgS
         rW4qw2/AZt05A9Nxm8FXVEhDRbJkviAUxyOhnZp7SOl61f5qMEys985zCHy4zMrJaS
         2PV7ggC0e9lxFtn9wc0YYDKr8CYimaHy7Vksyh8vxtZW33A+5PMdXTb65OXNvXysGl
         pDrQ2rMQl4Y9A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 351BAC43141; Mon, 20 Mar 2023 06:52:31 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217216] New: [Syzkaller & bisect] There is BUG: unable to
 handle kernel NULL pointer dereference in xfs_filestream_select_ag in
 v6.3-rc3
Date:   Mon, 20 Mar 2023 06:52:30 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: pengfei.xu@intel.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-217216-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217216

            Bug ID: 217216
           Summary: [Syzkaller & bisect] There is BUG: unable to handle
                    kernel NULL pointer dereference in
                    xfs_filestream_select_ag in v6.3-rc3
           Product: File System
           Version: 2.5
    Kernel Version: v6.3-rc3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: pengfei.xu@intel.com
        Regression: No

There is BUG: unable to handle kernel NULL pointer dereference in
xfs_filestream_select_ag in v6.3-rc3:

All detailed info:
https://github.com/xupengfe/syzkaller_logs/tree/main/230319_210525_xfs_file=
stream_select_ag
Reproduced code:
https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_file=
stream_select_ag/repro.c
Kconfig:
https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_file=
stream_select_ag/kconfig_origin
v6.3-rc3 issue dmesg:
https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_file=
stream_select_ag/v6.3-rc3_issue_dmesg.log
Bisect info:
https://github.com/xupengfe/syzkaller_logs/blob/main/230319_210525_xfs_file=
stream_select_ag/bisect_info.log

Bisected between v6.3-rc2 and v5.11 and found the bad commit:
"
8ac5b996bf5199f15b7687ceae989f8b2a410dda
xfs: fix off-by-one-block in xfs_discard_folio() "
Reverted the commit on top of v6.3-rc2 kernel, at least the BUG dmesg was g=
one.

And this issue could be reproduced in v6.3-rc3 kernel also.
Is it possible that the above commit involves a new issue?

"
[   62.318653] loop0: detected capacity change from 0 to 65536
[   62.320459] XFS (loop0): Mounting V5 Filesystem
d6f69dbd-8c5d-46be-b88e-92c0ae88ceb2
[   62.325152] XFS (loop0): Ending clean mount
[   62.326049] XFS (loop0): Quotacheck needed: Please wait.
[   62.328884] XFS (loop0): Quotacheck: Done.
[   62.363656] XFS (loop0): Metadata CRC error detected at
xfs_agf_read_verify+0x10e/0x140, xfs_agf block 0x8001=20
[   62.364489] XFS (loop0): Unmount and run xfs_repair
[   62.364881] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[   62.365398] 00000000: 58 41 47 46 00 00 00 01 00 00 00 01 00 00 40 00=20
XAGF..........@.
[   62.366026] 00000010: 00 00 00 02 00 00 00 03 00 00 00 00 00 00 00 01=20
................
[   62.366657] 00000020: 00 00 00 01 00 00 00 00 00 00 00 01 00 00 00 04=20
................
[   62.367285] 00000030: 00 00 00 04 00 00 3b 5f 00 00 3b 5c 00 00 00 00=20
......;_..;\....
[   62.367927] 00000040: d6 f6 9d bd 8c 5d 46 be b8 8e 92 c0 ae 88 ce b2=20
.....]F.........
[   62.368554] 00000050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................
[   62.369180] 00000060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................
[   62.369806] 00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................
[   62.370471] XFS (loop0): metadata I/O error in "xfs_read_agf+0xd0/0x200"=
 at
daddr 0x8001 len 1 error 74
[   62.371312] XFS (loop0): page discard on page 00000000a6a1237b, inode 0x=
46,
pos 0.
[   62.385968] BUG: kernel NULL pointer dereference, address: 0000000000000=
010
[   62.386541] #PF: supervisor write access in kernel mode
[   62.386960] #PF: error_code(0x0002) - not-present page
[   62.387370] PGD 0 P4D 0=20
[   62.387588] Oops: 0002 [#1] PREEMPT SMP NOPTI
[   62.387945] CPU: 1 PID: 74 Comm: kworker/u4:3 Not tainted
6.3.0-rc3-kvm-e8d018dd #1
[   62.388545] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   62.389426] Workqueue: writeback wb_workfn (flush-7:0)
[   62.389845] RIP: 0010:xfs_filestream_select_ag+0x5d5/0xac0
[   62.390285] Code: 83 ff 49 89 5d 18 be 08 00 00 00 bf 20 00 00 00 e8 20 =
94
03 00 48 89 c3 48 85 c0 0f 84 57 04 00 00 e8 2f 30 83 ff 49 8b 45 18 <f0> f=
f 40
10 49 8b 45 18 48 8b 75 b8 48 89 da 48 89 43 18 48 8b 45
[   62.391712] RSP: 0018:ffffc9000092f4c0 EFLAGS: 00010246
[   62.392128] RAX: 0000000000000000 RBX: ffff88800b858940 RCX:
0000000000006cc0
[   62.392688] RDX: 0000000000000000 RSI: ffff88800a02a340 RDI:
0000000000000002
[   62.393246] RBP: ffffc9000092f548 R08: ffffc9000092f400 R09:
0000000000000000
[   62.393805] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000001
[   62.394363] R13: ffffc9000092f588 R14: 0000000000000001 R15:
ffffc9000092f708
[   62.394924] FS:  0000000000000000(0000) GS:ffff88807dd00000(0000)
knlGS:0000000000000000
[   62.395553] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.396008] CR2: 0000000000000010 CR3: 000000000ad7c003 CR4:
0000000000770ee0
[   62.396569] PKRU: 55555554
[   62.396793] Call Trace:
[   62.396996]  <TASK>
[   62.397179]  xfs_bmap_btalloc+0x706/0xb90
[   62.397512]  xfs_bmapi_allocate+0x25b/0x5e0
[   62.397850]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   62.398239]  xfs_bmapi_convert_delalloc+0x335/0x6c0
[   62.398649]  xfs_map_blocks+0x2ff/0x740
[   62.398971]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   62.399362]  iomap_do_writepage+0x43f/0xf10
[   62.399709]  write_cache_pages+0x2b8/0x7e0
[   62.400047]  ? __pfx_iomap_do_writepage+0x10/0x10
[   62.400438]  iomap_writepages+0x3e/0x80
[   62.400757]  xfs_vm_writepages+0x97/0xe0
[   62.401088]  ? __pfx_xfs_vm_writepages+0x10/0x10
[   62.401470]  do_writepages+0x10f/0x240
[   62.401783]  ? write_comp_data+0x2f/0x90
[   62.402112]  __writeback_single_inode+0x9f/0x780
[   62.402492]  ? write_comp_data+0x2f/0x90
[   62.402823]  writeback_sb_inodes+0x301/0x800
[   62.403184]  wb_writeback+0x18b/0x580
[   62.403495]  wb_workfn+0xca/0x880
[   62.403778]  ? __this_cpu_preempt_check+0x20/0x30
[   62.404171]  ? lock_acquire+0xe6/0x2b0
[   62.404484]  ? __this_cpu_preempt_check+0x20/0x30
[   62.404872]  ? write_comp_data+0x2f/0x90
[   62.405202]  process_one_work+0x3b1/0x860
[   62.405538]  worker_thread+0x52/0x660
[   62.405846]  ? __pfx_worker_thread+0x10/0x10
[   62.406202]  kthread+0x161/0x1a0
[   62.406475]  ? __pfx_kthread+0x10/0x10
[   62.406787]  ret_from_fork+0x29/0x50
[   62.407094]  </TASK>
[   62.407281] Modules linked in:
[   62.407535] CR2: 0000000000000010
[   62.407808] ---[ end trace 0000000000000000 ]---
[   62.408178] RIP: 0010:xfs_filestream_select_ag+0x5d5/0xac0
[   62.408619] Code: 83 ff 49 89 5d 18 be 08 00 00 00 bf 20 00 00 00 e8 20 =
94
03 00 48 89 c3 48 85 c0 0f 84 57 04 00 00 e8 2f 30 83 ff 49 8b 45 18 <f0> f=
f 40
10 49 8b 45 18 48 8b 75 b8 48 89 da 48 89 43 18 48 8b 45
[   62.410052] RSP: 0018:ffffc9000092f4c0 EFLAGS: 00010246
[   62.410469] RAX: 0000000000000000 RBX: ffff88800b858940 RCX:
0000000000006cc0
[   62.411032] RDX: 0000000000000000 RSI: ffff88800a02a340 RDI:
0000000000000002
[   62.411594] RBP: ffffc9000092f548 R08: ffffc9000092f400 R09:
0000000000000000
[   62.412155] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000001
[   62.412716] R13: ffffc9000092f588 R14: 0000000000000001 R15:
ffffc9000092f708
[   62.413278] FS:  0000000000000000(0000) GS:ffff88807dd00000(0000)
knlGS:0000000000000000
[   62.413909] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.414368] CR2: 0000000000000010 CR3: 000000000ad7c003 CR4:
0000000000770ee0
[   62.414934] PKRU: 55555554
[   62.415159] note: kworker/u4:3[74] exited with irqs disabled
[   62.415642] ------------[ cut here ]------------
[   62.416012] WARNING: CPU: 1 PID: 74 at kernel/exit.c:814
do_exit+0xe8a/0x12b0
[   62.416580] Modules linked in:
[   62.416833] CPU: 1 PID: 74 Comm: kworker/u4:3 Tainted: G      D=20=20=20=
=20=20=20=20=20=20=20=20
6.3.0-rc3-kvm-e8d018dd #1
[   62.417546] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   62.418432] Workqueue: writeback wb_workfn (flush-7:0)
[   62.418861] RIP: 0010:do_exit+0xe8a/0x12b0
[   62.419197] Code: 00 65 01 05 b4 ba f0 7e e9 f4 fd ff ff e8 be 1e 1b 00 =
48
8b bb 98 09 00 00 31 f6 e8 30 b0 ff ff e9 74 fb ff ff e8 a6 1e 1b 00 <0f> 0=
b e9
3e f2 ff ff e8 9a 1e 1b 00 4c 89 ee bf 05 06 00 00 e8 bd
[   62.420652] RSP: 0018:ffffc9000092feb0 EFLAGS: 00010246
[   62.421072] RAX: 0000000000000000 RBX: ffff88800a02a340 RCX:
0000000000000001
[   62.421635] RDX: 0000000000000000 RSI: ffff88800a02a340 RDI:
0000000000000002
[   62.422195] RBP: ffffc9000092ff18 R08: 0000000000000000 R09:
0000000000000000
[   62.422758] R10: 34752f72656b726f R11: 776b203a65746f6e R12:
0000000000000000
[   62.423323] R13: 0000000000000009 R14: ffff88800a009900 R15:
ffff8880093a1180
[   62.423902] FS:  0000000000000000(0000) GS:ffff88807dd00000(0000)
knlGS:0000000000000000
[   62.424539] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   62.425000] CR2: 0000000000000010 CR3: 000000000ad7c003 CR4:
0000000000770ee0
[   62.425568] PKRU: 55555554
[   62.425794] Call Trace:
[   62.426000]  <TASK>
[   62.426183]  ? write_comp_data+0x2f/0x90
[   62.426513]  make_task_dead+0x100/0x290
[   62.426832]  rewind_stack_and_make_dead+0x17/0x20
[   62.427227]  </TASK>
[   62.427414] irq event stamp: 122544
[   62.427715] hardirqs last  enabled at (122543): [<ffffffff821395dd>]
get_random_u32+0x1dd/0x360
[   62.428409] hardirqs last disabled at (122544): [<ffffffff82f8d76e>]
exc_page_fault+0x4e/0x3b0
[   62.429094] softirqs last  enabled at (114870): [<ffffffff82fb01a9>]
__do_softirq+0x2d9/0x3c3
[   62.429771] softirqs last disabled at (114849): [<ffffffff81126724>]
irq_exit_rcu+0xc4/0x100
[   62.430443] ---[ end trace 0000000000000000 ]---
"

I hope it's helpful.

Thanks!

---

If you don't need the following environment to reproduce the problem or if =
you
already have one, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.=
1.0
   // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65
v6.2-rc5 kernel
   // You could change the bzImage_xxx as you want You could use below comm=
and
to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config make olddefconf=
ig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git cd qemu git checkout -f v7.1.0 m=
kdir
build cd build yum install -y ninja-build.x86_64 ../configure
--target-list=3Dx86_64-softmmu --enable-kvm --enable-vnc --enable-gtk
--enable-sdl make make install

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
