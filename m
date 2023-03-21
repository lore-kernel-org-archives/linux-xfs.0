Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 662C4C74A5B
	for <linux-xfs@archiver.kernel.org>; Tue, 21 Mar 2023 06:16:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjCUGQ6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 21 Mar 2023 02:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjCUGQ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Mar 2023 02:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F1F32CE0
        for <linux-xfs@vger.kernel.org>; Mon, 20 Mar 2023 23:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFEA761968
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2023 06:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F129C433A4
        for <linux-xfs@vger.kernel.org>; Tue, 21 Mar 2023 06:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679379390;
        bh=/EtFBUFo8iGXvjb+n+yYkZJysS/6As66ELE5Cu7ZyzU=;
        h=From:To:Subject:Date:From;
        b=O3ThXWPdz7QAn8g8BqEF6y1Z9ukk5yXJVIA7oNzvb5baA4bAgTJSWC723aFGIGSuj
         oM3A7GNfamUa2UHf8VMTPHOXFy00k16n0kAXfgnGOUgGH8/FL9/G/Tj0wWz8ea+wOj
         9Du8nPAOiD/TpgBPo7WuVoPIw5Ct229SwAMq70RT/+/N0/ksjZ7mmi6tqkvwMJvupt
         KrxVsRm2pbqm5nXaJ1AWq+jL3MoEOqBuEWEdU/0mUdZ/W/DplfEBB+5dZGbGUB4jk5
         3Z57Wh2dn+54ErA8dPkSYxaDSdCcPurND7MvCY1yM4icytpVIU+BDhYNRSD4J0okph
         0JqZPYkxNgf8Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 2B649C43142; Tue, 21 Mar 2023 06:16:30 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217224] New: [Syzkaller & bisect] There is
 "xfs_btree_lookup_get_block" general protection BUG in v6.3-rc3 kernel
Date:   Tue, 21 Mar 2023 06:16:29 +0000
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
Message-ID: <bug-217224-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217224

            Bug ID: 217224
           Summary: [Syzkaller & bisect] There is
                    "xfs_btree_lookup_get_block" general protection BUG in
                    v6.3-rc3 kernel
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

Platform: x86 platforms
There is "xfs_btree_lookup_get_block" general protection BUG in v6.3-rc3
kernel.

All detailed info:
https://github.com/xupengfe/syzkaller_logs/tree/main/230321_082343_xfs_btre=
e_lookup_get_block
Reproduced code:
https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btre=
e_lookup_get_block/repro.c
Kconfig:
https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btre=
e_lookup_get_block/kconfig_origin
v6.3-rc3 issue log:
https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btre=
e_lookup_get_block/e8d018dd0257f744ca50a729e3d042cf2ec9da65_dmesg.log
Bisect info:
https://github.com/xupengfe/syzkaller_logs/blob/main/230321_082343_xfs_btre=
e_lookup_get_block/bisect_info.log

Bisected and found the bad commit:
"
7993f1a431bc5271369d359941485a9340658ac3
xfs: only run COW extent recovery when there are no live extents "
It's just suspected commit, because reverted the above commit on top of
v6.3-rc3 and made kernel failed, could not double confirm for this issue's
verification with reverted kernel.

"
[   29.020016] XFS (loop3): Error -5 reserving per-AG metadata reserve pool.
[   29.022919] BUG: kernel NULL pointer dereference, address: 0000000000000=
22b
[   29.023777] #PF: supervisor read access in kernel mode
[   29.024413] #PF: error_code(0x0000) - not-present page
[   29.025081] PGD 12947067 P4D 12947067 PUD 12976067 PMD 0
[   29.025825] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   29.026465] CPU: 0 PID: 544 Comm: repro Not tainted 6.3.0-rc3-e8d018dd02=
57+
#1
[   29.026826] XFS (loop5): Starting recovery (logdev: internal)
[   29.027468] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   29.029009] XFS (loop5): Metadata corruption detected at
xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.029843] RIP: 0010:xfs_btree_lookup_get_block+0xc4/0x300
[   29.031365] XFS (loop5): Unmount and run xfs_repair
[   29.032089] Code: ff ff 31 ff 41 89 c7 89 c6 e8 48 3d 8a ff 45 85 ff 0f =
85
1d 01 00 00 e8 5a 3b 8a ff 4c 8b 75 c0 4d 85 f6 74 37 e8 4c 3b 8a ff <49> 8=
b 96
28 02 00 00 48 8b 4d c8 48 8b 12 48 89 cf 48 89 4d b0 48
[   29.032779] XFS (loop5): Failed to recover leftover CoW staging extents,=
 err
-117.
[   29.035256] RSP: 0018:ffffc9000108b910 EFLAGS: 00010246
[   29.035267] RAX: 0000000000000000 RBX: ffff888013f10000 RCX:
ffffffff81a32768
[   29.036298] XFS (loop5): Filesystem has been shut down due to log error
(0x2).
[   29.037030] RDX: 0000000000000000 RSI: ffff888013eba340 RDI:
0000000000000002
[   29.037994] XFS (loop5): Please unmount the filesystem and rectify the
problem(s).
[   29.038973] RBP: ffffc9000108b968 R08: ffffc9000108bb88 R09:
ffff888013f10000
[   29.038982] R10: 0000000000000000 R11: 0000000000000001 R12:
0000000000000007
[   29.038989] R13: ffffc9000108b9a8 R14: 0000000000000003 R15:
0000000000000000
[   29.038997] FS:  00007f44ba73a740(0000) GS:ffff88807dc00000(0000)
knlGS:0000000000000000
[   29.041082] XFS (loop7): Starting recovery (logdev: internal)
[   29.041985] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.043907] XFS (loop7): Metadata corruption detected at
xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.043955] CR2: 000000000000022b CR3: 000000000e56e003 CR4:
0000000000770ef0
[   29.045085] XFS (loop7): Unmount and run xfs_repair
[   29.045870] PKRU: 55555554
[   29.046689] XFS (loop7): Failed to recover leftover CoW staging extents,=
 err
-117.
[   29.048110] Call Trace:
[   29.049079] XFS (loop7): Filesystem has been shut down due to log error
(0x2).
[   29.049753]  <TASK>
[   29.050160] XFS (loop7): Please unmount the filesystem and rectify the
problem(s).
[   29.051195]  xfs_btree_lookup+0xfe/0x800
[   29.053556] XFS (loop1): Metadata corruption detected at
xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.053882]  ? __this_cpu_preempt_check+0x20/0x30
[   29.054487] XFS (loop1): Unmount and run xfs_repair
[   29.055921]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
[   29.056575] XFS (loop1): Failed to recover leftover CoW staging extents,=
 err
-117.
[   29.057249]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
[   29.057993] XFS (loop1): Filesystem has been shut down due to log error
(0x2).
[   29.059020]  xfs_btree_simple_query_range+0x54/0x280
[   29.059038]  ? write_comp_data+0x2f/0x90
[   29.059784] XFS (loop1): Please unmount the filesystem and rectify the
problem(s).
[   29.060778]  ? __pfx_xfs_refcount_recover_extent+0x10/0x10
[   29.062080] XFS (loop4): Metadata corruption detected at
xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.063021]  xfs_btree_query_range+0x18a/0x1a0
[   29.063773] XFS (loop4): Unmount and run xfs_repair
[   29.065266]  ? xfs_refcountbt_init_common+0x3b/0x90
[   29.065891] XFS (loop4): Failed to recover leftover CoW staging extents,=
 err
-117.
[   29.066560]  xfs_refcount_recover_cow_leftovers+0x18c/0x4a0
[   29.066583]  ? xfs_perag_grab+0x143/0x340
[   29.067266] XFS (loop4): Filesystem has been shut down due to log error
(0x2).
[   29.068299]  xfs_reflink_recover_cow+0x79/0xf0
[   29.069063] XFS (loop4): Please unmount the filesystem and rectify the
problem(s).
[   29.069623]  xlog_recover_finish+0x136/0x420
[   29.071179] XFS (loop7): Ending recovery (logdev: internal)
[   29.071227]  ? queue_delayed_work_on+0x9f/0xf0
[   29.072328] XFS (loop7): Error -5 reserving per-AG metadata reserve pool.
[   29.072876]  xfs_log_mount_finish+0x187/0x1d0
[   29.073692] XFS (loop1): Ending recovery (logdev: internal)
[   29.074252]  xfs_mountfs+0x76e/0xce0
[   29.074271]  xfs_fs_fill_super+0x7aa/0xdc0
[   29.075574] XFS (loop1): Error -5 reserving per-AG metadata reserve pool.
[   29.075809]  get_tree_bdev+0x24b/0x350
[   29.076634] XFS (loop5): Ending recovery (logdev: internal)
[   29.077084]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[   29.077676] XFS (loop5): Error -5 reserving per-AG metadata reserve pool.
[   29.078560]  xfs_fs_get_tree+0x25/0x30
[   29.078581]  vfs_get_tree+0x3b/0x140
[   29.079464] XFS (loop4): Ending recovery (logdev: internal)
[   29.079871]  path_mount+0x769/0x10f0
[   29.080533] XFS (loop4): Error -5 reserving per-AG metadata reserve pool.
[   29.081442]  ? write_comp_data+0x2f/0x90
[   29.085330]  do_mount+0xaf/0xd0
[   29.085811] XFS (loop2): Starting recovery (logdev: internal)
[   29.085825]  __x64_sys_mount+0x14b/0x160
[   29.087213]  do_syscall_64+0x3b/0x90
[   29.087534] XFS (loop2): Metadata corruption detected at
xfs_btree_lookup_get_block+0x27a/0x300, xfs_refcountbt block 0x28
[   29.087758]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   29.089249] XFS (loop2): Unmount and run xfs_repair
[   29.089936] RIP: 0033:0x7f44ba8673ae
[   29.090639] XFS (loop2): Failed to recover leftover CoW staging extents,=
 err
-117.
[   29.091112] Code: 48 8b 0d f5 8a 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 =
2e
0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d c2 8a 0c 00 f7 d8 64 89 01 48
[   29.092123] XFS (loop2): Filesystem has been shut down due to log error
(0x2).
[   29.094617] RSP: 002b:00007fffeaff1b78 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[   29.094632] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f44ba8673ae
[   29.094640] RDX: 0000000020009580 RSI: 00000000200095c0 RDI:
00007fffeaff1cb0
[   29.095630] XFS (loop2): Please unmount the filesystem and rectify the
problem(s).
[   29.096664] RBP: 00007fffeaff1d40 R08: 00007fffeaff1bb0 R09:
0000000000000000
[   29.099193] XFS (loop2): Ending recovery (logdev: internal)
[   29.099660] R10: 0000000000000800 R11: 0000000000000206 R12:
0000000000401260
[   29.100702] XFS (loop2): Error -5 reserving per-AG metadata reserve pool.
[   29.101426] R13: 00007fffeaff1e80 R14: 0000000000000000 R15:
0000000000000000
[   29.104290]  </TASK>
[   29.104623] Modules linked in:
[   29.105081] CR2: 000000000000022b
[   29.105560] ---[ end trace 0000000000000000 ]---
[   29.106207] RIP: 0010:xfs_btree_lookup_get_block+0xc4/0x300
[   29.106985] Code: ff ff 31 ff 41 89 c7 89 c6 e8 48 3d 8a ff 45 85 ff 0f =
85
1d 01 00 00 e8 5a 3b 8a ff 4c 8b 75 c0 4d 85 f6 74 37 e8 4c 3b 8a ff <49> 8=
b 96
28 02 00 00 48 8b 4d c8 48 8b 12 48 89 cf 48 89 4d b0 48
[   29.109472] RSP: 0018:ffffc9000108b910 EFLAGS: 00010246
[   29.110190] RAX: 0000000000000000 RBX: ffff888013f10000 RCX:
ffffffff81a32768
[   29.111153] RDX: 0000000000000000 RSI: ffff888013eba340 RDI:
0000000000000002
[   29.112114] RBP: ffffc9000108b968 R08: ffffc9000108bb88 R09:
ffff888013f10000
[   29.113072] R10: 0000000000000000 R11: 0000000000000001 R12:
0000000000000007
[   29.114030] R13: ffffc9000108b9a8 R14: 0000000000000003 R15:
0000000000000000
[   29.114989] FS:  00007f44ba73a740(0000) GS:ffff88807dc00000(0000)
knlGS:0000000000000000
[   29.116069] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   29.116860] CR2: 000000000000022b CR3: 000000000e56e003 CR4:
0000000000770ef0
[   29.117831] PKRU: 55555554
[   29.118220] note: repro[544] exited with irqs disabled
[   29.452491] loop0: detected capacity change from 0 to 32768
"

I see this similar issue in syzbot link:
https://syzkaller.appspot.com/bug?id=3De2907149c69cbccae0842eb502b8af4f6fac=
52a0
But it didn't provide the bisect commit info due to bisect failure.

I hope above info is helpful.

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
