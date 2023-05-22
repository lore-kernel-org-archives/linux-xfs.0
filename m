Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47893C7EE23
	for <linux-xfs@archiver.kernel.org>; Mon, 22 May 2023 02:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjEVCLJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 May 2023 22:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjEVCLI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 May 2023 22:11:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EAE3B7
        for <linux-xfs@vger.kernel.org>; Sun, 21 May 2023 19:11:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0814161946
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 02:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59DD1C433A4
        for <linux-xfs@vger.kernel.org>; Mon, 22 May 2023 02:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684721466;
        bh=CaI/8q252M/Y9VG/0tVC+71efG7A1tmEeSGxodGVjlY=;
        h=From:To:Subject:Date:From;
        b=MrchUXLWpYuZxv46Rzf18TmkIWDnkFkv0X4yHufo2ONllHt4CfwIf8U4TfjiEd88B
         K33M/aoTyDobtcpwomfnACKvUWIAOBLXdm0CCDZnlsk0zQ7BxKfy2ymskbfziHu/Ax
         WN+XELXJ+S2M4hlPQUz/F+NK6INaO02f/oqkp31j66V5dG3WCZe2biqZkfpJkD5tg8
         gVhlgLBCHdfgs4vc9+rVF91T+IGTcUJICKNAk9nBDqfMSPepI2J+J8uy7a/juaY3R4
         V8B5FsQ2mV3VpD6hWTW9XHr0NaJdW/m4qKzztnhbbD/4XU6xydiw+WCX349vhoZCVQ
         W51e0eHQIS16A==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 4A860C43144; Mon, 22 May 2023 02:11:06 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217470] New: [Syzkaller & bisect] There is BUG: unable to
 handle kernel NULL pointer dereference in xfs_extent_free_diff_items in
 v6.4-rc3
Date:   Mon, 22 May 2023 02:11:05 +0000
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
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217470-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217470

            Bug ID: 217470
           Summary: [Syzkaller & bisect] There is BUG: unable to handle
                    kernel NULL pointer dereference in
                    xfs_extent_free_diff_items in v6.4-rc3
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P3
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: pengfei.xu@intel.com
        Regression: No

There is BUG: unable to handle kernel NULL pointer dereference in
xfs_extent_free_diff_items in v6.4-rc3:

Above issue could be reproduced in v6.4-rc3 and v6.4-rc2 kernel in guest.

Bisected this issue between v6.4-rc2 and v5.11, found the problem commit is:
"
f6b384631e1e xfs: give xfs_extfree_intent its own perag reference
"

report0, repro.stat and so on detailed info is link:
https://github.com/xupengfe/syzkaller_logs/tree/main/230521_043336_xfs_exte=
nt_free_diff_items
Syzkaller reproduced code:
https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_exte=
nt_free_diff_items/repro.c
Syzkaller reproduced prog:
https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_exte=
nt_free_diff_items/repro.prog
Kconfig:
https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_exte=
nt_free_diff_items/kconfig_origin
Bisect info:
https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_exte=
nt_free_diff_items/bisect_info.log
Issue dmesg:
https://github.com/xupengfe/syzkaller_logs/blob/main/230521_043336_xfs_exte=
nt_free_diff_items/v6.4-rc3_reproduce_dmesg.log

v6.4-rc3 reproduced info:
"
[   91.419498] loop0: detected capacity change from 0 to 65536
[   91.420095] XFS: attr2 mount option is deprecated.
[   91.420500] XFS: ikeep mount option is deprecated.
[   91.422379] XFS (loop0): Deprecated V4 format (crc=3D0) will not be supp=
orted
after September 2030.
[   91.423468] XFS (loop0): Mounting V4 Filesystem
d28317a9-9e04-4f2a-be27-e55b4c413ff6
[   91.428169] XFS (loop0): Ending clean mount
[   91.429120] XFS (loop0): Quotacheck needed: Please wait.
[   91.432182] BUG: kernel NULL pointer dereference, address: 0000000000000=
008
[   91.432770] #PF: supervisor read access in kernel mode
[   91.433216] #PF: error_code(0x0000) - not-present page
[   91.433640] PGD 0 P4D 0=20
[   91.433864] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   91.434232] CPU: 0 PID: 33 Comm: kworker/u4:2 Not tainted 6.4.0-rc3-kvm =
#2
[   91.434793] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
0.0.0 02/06/2015
[   91.435445] Workqueue: xfs_iwalk-393 xfs_pwork_work
[   91.435855] RIP: 0010:xfs_extent_free_diff_items+0x27/0x40
[   91.436312] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 e5 41 54 =
49
89 f4 53 48 89 d3 e8 05 73 7d ff 49 8b 44 24 28 48 8b 53 28 5b 41 5c <8b> 4=
0 08
5d 2b 42 08 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00
[   91.437812] RSP: 0000:ffffc9000012b8c0 EFLAGS: 00010246
[   91.438250] RAX: 0000000000000000 RBX: ffff8880015826c8 RCX:
ffffffff81d71e41
[   91.438840] RDX: 0000000000000000 RSI: ffff888001ca4800 RDI:
0000000000000002
[   91.439430] RBP: ffffc9000012b8c0 R08: ffffc9000012b8e0 R09:
0000000000000000
[   91.440019] R10: ffff88800613f290 R11: ffffffff83e426c0 R12:
ffff888001582230
[   91.440610] R13: ffff888001582428 R14: ffffffff81b042c0 R15:
ffffc9000012b908
[   91.441202] FS:  0000000000000000(0000) GS:ffff88807ec00000(0000)
knlGS:0000000000000000
[   91.441864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.442343] CR2: 0000000000000008 CR3: 000000000ed22006 CR4:
0000000000770ef0
[   91.442941] PKRU: 55555554
[   91.443178] Call Trace:
[   91.443394]  <TASK>
[   91.443585]  list_sort+0xb8/0x3a0
[   91.443885]  xfs_extent_free_create_intent+0xb6/0xc0
[   91.444312]  xfs_defer_create_intents+0xc3/0x220
[   91.444711]  ? write_comp_data+0x2f/0x90
[   91.445056]  xfs_defer_finish_noroll+0x9e/0xbc0
[   91.445449]  ? list_sort+0x344/0x3a0
[   91.445768]  __xfs_trans_commit+0x4be/0x630
[   91.446135]  xfs_trans_commit+0x20/0x30
[   91.446473]  xfs_dquot_disk_alloc+0x45d/0x4e0
[   91.446860]  xfs_qm_dqread+0x2f7/0x310
[   91.447192]  xfs_qm_dqget+0xd5/0x300
[   91.447506]  xfs_qm_quotacheck_dqadjust+0x5a/0x230
[   91.447921]  xfs_qm_dqusage_adjust+0x249/0x300
[   91.448313]  xfs_iwalk_ag_recs+0x1bd/0x2e0
[   91.448671]  xfs_iwalk_run_callbacks+0xc3/0x1c0
[   91.449071]  xfs_iwalk_ag+0x32e/0x3f0
[   91.449398]  xfs_iwalk_ag_work+0xbe/0xf0
[   91.449744]  xfs_pwork_work+0x2c/0xc0
[   91.450064]  process_one_work+0x3b1/0x860
[   91.450416]  worker_thread+0x52/0x660
[   91.450739]  ? __pfx_worker_thread+0x10/0x10
[   91.451113]  kthread+0x16d/0x1c0
[   91.451406]  ? __pfx_kthread+0x10/0x10
[   91.451740]  ret_from_fork+0x29/0x50
[   91.452064]  </TASK>
[   91.452261] Modules linked in:
[   91.452530] CR2: 0000000000000008
[   91.452819] ---[ end trace 0000000000000000 ]---
[   91.487979] RIP: 0010:xfs_extent_free_diff_items+0x27/0x40
[   91.488463] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 e5 41 54 =
49
89 f4 53 48 89 d3 e8 05 73 7d ff 49 8b 44 24 28 48 8b 53 28 5b 41 5c <8b> 4=
0 08
5d 2b 42 08 c3 cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00
[   91.490021] RSP: 0000:ffffc9000012b8c0 EFLAGS: 00010246
[   91.490472] RAX: 0000000000000000 RBX: ffff8880015826c8 RCX:
ffffffff81d71e41
[   91.491080] RDX: 0000000000000000 RSI: ffff888001ca4800 RDI:
0000000000000002
[   91.491689] RBP: ffffc9000012b8c0 R08: ffffc9000012b8e0 R09:
0000000000000000
[   91.492298] R10: ffff88800613f290 R11: ffffffff83e426c0 R12:
ffff888001582230
[   91.492909] R13: ffff888001582428 R14: ffffffff81b042c0 R15:
ffffc9000012b908
[   91.493516] FS:  0000000000000000(0000) GS:ffff88807ec00000(0000)
knlGS:0000000000000000
[   91.494199] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   91.494695] CR2: 0000000000000008 CR3: 000000000ed22006 CR4:
0000000000770ef0
[   91.495306] PKRU: 55555554
[   91.495549] note: kworker/u4:2[33] exited with irqs disabled
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
  // You could change the bzImage_xxx as you want
  // Maybe you need to remove line "-drive
if=3Dpflash,format=3Draw,readonly=3Don,file=3D./OVMF_CODE.fd \" for differe=
nt qemu
version
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
yum -y install libslirp-devel.x86_64
../configure --target-list=3Dx86_64-softmmu --enable-kvm --enable-vnc
--enable-gtk --enable-sdl --enable-usb-redir --enable-slirp
make
make install

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
