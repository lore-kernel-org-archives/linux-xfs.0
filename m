Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF22C77B73
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 03:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjEYDE1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 23:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238004AbjEYDEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 23:04:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F19A9
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 20:04:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 597F364210
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 03:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B52CBC433EF
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 03:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684983858;
        bh=lifu/tzgKgjAWQKAT9IERdwAdc5PyZ45ilNWQKbGWj4=;
        h=From:To:Subject:Date:From;
        b=U+wveFPluDRZaBXFQECRtDFnnx6lz/l82LoraDHUHTZx26Rv9Gc7dMUtkBdsNkG7z
         xZ7IroNAObmdG4WSu6ipdkhCyf6nX6GkGNxjFrGUZPJhdQZsvOV/fev/ApGiI4nBqn
         lRb1P6rIAnC/vZrKClMnXKMqhdTwd5B4PvidshYLlpRcPniDhwqKOpOd3PzFLx+3DL
         Yk3ErEkATlGsiGmG+7bOsV3w28lF12zDI75wuLjDvfboAJgEmAdpmFIZ1+E2xsHFCx
         rrJNYqmh9iyKWoCUsuXpv2D1yHIM9np+ZhI4kRgexcdF33S/F0ZkMRJZsdtBin0bMX
         +qaWrobcIx6Sg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A3197C43144; Thu, 25 May 2023 03:04:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217483] New: [Syzkaller & bisect] There is "soft lockup in
 __cleanup_mnt" in v6.4-rc3 kernel
Date:   Thu, 25 May 2023 03:04:18 +0000
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
Message-ID: <bug-217483-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217483

            Bug ID: 217483
           Summary: [Syzkaller & bisect] There is "soft lockup in
                    __cleanup_mnt" in v6.4-rc3 kernel
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

Platform: Alder lake
There is "soft lockup in __cleanup_mnt" in v6.4-rc3 kernel.

Syzkaller analysis repro.report and bisect detailed info:
https://github.com/xupengfe/syzkaller_logs/tree/main/230524_140757___cleanu=
p_mnt
Guest machine info:
https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanu=
p_mnt/machineInfo0
Reproduced code:
https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanu=
p_mnt/repro.c
Reproduced syscall:
https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanu=
p_mnt/repro.prog
Bisect info:
https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanu=
p_mnt/bisect_info.log
Kconfig origin:
https://github.com/xupengfe/syzkaller_logs/blob/main/230524_140757___cleanu=
p_mnt/kconfig_origin

Suspected commit is as follow due to 2 skip commits:
 # possible first bad commit: [f8f1ed1ab3babad46b25e2dbe8de43b33fe7aaa6] xf=
s:
return a referenced perag from filestreams allocator
 # possible first bad commit: [571e259282a43f58b1f70dcbf2add20d8c83a72b] xf=
s:
pass perag to filestreams tracing  (skip)
"
fs/xfs/xfs_filestream.c: In function =E2=80=98xfs_filestream_pick_ag=E2=80=
=99:
fs/xfs/xfs_filestream.c:92:4: error: label =E2=80=98next_ag=E2=80=99 used b=
ut not defined
    goto next_ag;
    ^~~~
make[3]: *** [scripts/Makefile.build:252: fs/xfs/xfs_filestream.o] Error 1
make[2]: *** [scripts/Makefile.build:504: fs/xfs] Error 2
make[1]: *** [scripts/Makefile.build:504: fs] Error 2
make: *** [Makefile:2021: .] Error 2
"

 # possible first bad commit: [eb70aa2d8ed9a6fc3525f305226c550524390cd2] xf=
s:
use for_each_perag_wrap in xfs_filestream_pick_ag (skip)
"
fs/xfs/xfs_filestream.c: In function =E2=80=98xfs_filestream_pick_ag=E2=80=
=99:
fs/xfs/xfs_filestream.c:111:4: error: label =E2=80=98next_ag=E2=80=99 used =
but not defined
    goto next_ag;
    ^~~~
make[3]: *** [scripts/Makefile.build:252: fs/xfs/xfs_filestream.o] Error 1
make[2]: *** [scripts/Makefile.build:504: fs/xfs] Error 2
make[1]: *** [scripts/Makefile.build:504: fs] Error 2
make: *** [Makefile:2021: .] Error 2
"

"
[   29.223473] XFS (loop0): Unmounting Filesystem
d408de26-55fb-48ab-a8ab-aacedb20f9dd
[   29.223942] XFS (loop0): SB summary counter sanity check failed
[   29.224173] XFS (loop0): Metadata corruption detected at
xfs_sb_write_verify+0x7d/0x180, xfs_sb block 0x0=20
[   29.224544] XFS (loop0): Unmount and run xfs_repair
[   29.224731] XFS (loop0): First 128 bytes of corrupted metadata buffer:
[   29.224979] 00000000: 58 46 53 42 00 00 04 00 00 00 00 00 00 00 80 00=20
XFSB............
[   29.225304] 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=20
................
[   29.225603] 00000020: d4 08 de 26 55 fb 48 ab a8 ab aa ce db 20 f9 dd=20
...&U.H...... ..
[   29.225902] 00000030: 00 00 00 00 00 00 40 08 00 00 00 00 00 00 00 20=20
......@........=20
[   29.226200] 00000040: 00 00 00 00 00 00 00 21 00 00 00 00 00 00 00 22=20
.......!......."
[   29.226503] 00000050: 00 00 00 04 00 00 40 00 00 00 00 02 00 00 00 00=20
......@.........
[   29.226802] 00000060: 00 00 04 98 b4 f5 02 00 02 00 00 02 00 00 00 00=20
................
[   29.227101] 00000070: 00 00 00 00 00 00 00 00 0a 09 09 01 0e 00 00 14=20
................
[   29.228273] XFS (loop0): Corruption of in-memory data (0x8) detected at
_xfs_buf_ioapply+0x5d8/0x5f0 (fs/xfs/xfs_buf.c:1552).  Shutting down
filesystem.
[   29.228788] XFS (loop0): Please unmount the filesystem and rectify the
problem(s)
[   56.322257] watchdog: BUG: soft lockup - CPU#1 stuck for 26s! [repro:529]
[   56.322608] Modules linked in:
[   56.322733] irq event stamp: 22632
[   56.322866] hardirqs last  enabled at (22631): [<ffffffff82fad69e>]
irqentry_exit+0x3e/0xa0
[   56.323185] hardirqs last disabled at (22632): [<ffffffff82fab7b3>]
sysvec_apic_timer_interrupt+0x13/0xe0
[   56.323550] softirqs last  enabled at (9060): [<ffffffff82fcf8e9>]
__do_softirq+0x2d9/0x3c3
[   56.323865] softirqs last disabled at (8463): [<ffffffff81126714>]
irq_exit_rcu+0xc4/0x100
[   56.324179] CPU: 1 PID: 529 Comm: repro Not tainted 6.4.0-rc3-44c026a73b=
e8+
#1
[   56.324455] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   56.324877] RIP: 0010:write_comp_data+0x0/0x90
[   56.325056] Code: 85 d2 74 0b 8b 86 c8 1d 00 00 39 f8 0f 94 c0 5d c3 cc =
cc
cc cc 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 <55> 4=
8 89
e5 41 57 49 89 d7 41 56 49 89 fe bf 03 00 00 00 41 55 49
[   56.325736] RSP: 0018:ffffc90000f5bc60 EFLAGS: 00000246
[   56.325936] RAX: 0000000000000001 RBX: 0000000000000001 RCX:
ffffffff81a138ea
[   56.326204] RDX: 0000000000000001 RSI: 0000000000000000 RDI:
0000000000000001
[   56.326475] RBP: ffffc90000f5bc68 R08: 0000000000000000 R09:
000000000000001c
[   56.326744] R10: 0000000000000001 R11: ffffffff83d64580 R12:
ffffffff81ac0c81
[   56.327011] R13: 0000000000000000 R14: 0000000000000001 R15:
ffff8880134bf900
[   56.327278] FS:  00007f85f5814740(0000) GS:ffff88807dd00000(0000)
knlGS:0000000000000000
[   56.327580] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   56.327798] CR2: 00007fe75831f000 CR3: 000000000deb4004 CR4:
0000000000770ee0
[   56.328067] PKRU: 55555554
[   56.328176] Call Trace:
[   56.328273]  <TASK>
[   56.328359]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[   56.328571]  xfs_perag_grab_tag+0x27a/0x460
[   56.328745]  xfs_icwalk+0x31/0xf0
[   56.328884]  xfs_reclaim_inodes+0xc6/0x140
[   56.329051]  xfs_unmount_flush_inodes+0x63/0x80
[   56.329235]  xfs_unmountfs+0x69/0x1f0
[   56.329389]  xfs_fs_put_super+0x5a/0x120
[   56.329548]  ? __pfx_xfs_fs_put_super+0x10/0x10
[   56.329730]  generic_shutdown_super+0xac/0x240
[   56.329909]  kill_block_super+0x46/0x90
[   56.330063]  deactivate_locked_super+0x52/0xb0
[   56.330242]  deactivate_super+0xb3/0xd0
[   56.330400]  cleanup_mnt+0x15e/0x1e0
[   56.330553]  __cleanup_mnt+0x1f/0x30
[   56.330704]  task_work_run+0xb6/0x120
[   56.330853]  exit_to_user_mode_prepare+0x200/0x210
[   56.331045]  syscall_exit_to_user_mode+0x2d/0x60
[   56.331229]  do_syscall_64+0x4a/0x90
[   56.331379]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   56.331575] RIP: 0033:0x7f85f59407db
[   56.331718] Code: 96 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 90 f3 0f 1e =
fa
31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d 95 96 0c 00 f7 d8 64 89 01 48
[   56.332395] RSP: 002b:00007ffd74badbc8 EFLAGS: 00000202 ORIG_RAX:
00000000000000a6
[   56.332680] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
00007f85f59407db
[   56.332945] RDX: 0000000000000000 RSI: 000000000000000a RDI:
00007ffd74badc70
[   56.333216] RBP: 00007ffd74baecb0 R08: 0000000000fb4333 R09:
0000000000000009
[   56.333486] R10: 0000000000404071 R11: 0000000000000202 R12:
00000000004012c0
[   56.333752] R13: 00007ffd74baedf0 R14: 0000000000000000 R15:
0000000000000000
[   56.334026]  </TASK>
[   56.334116] Kernel panic - not syncing: softlockup: hung tasks
"
I hope this time is accurate and helpful.

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

Thanks!
BR.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
