Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718BEC77B72
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 02:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbjDFCgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbjDFCgM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 22:36:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6C55BA0
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 19:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC81B6421B
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 02:36:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60EA5C433A0
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 02:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680748570;
        bh=EsPxDLSF05mJPJVirKeh6IIJ50949Ya/cWg8wLXnzKA=;
        h=From:To:Subject:Date:From;
        b=P1ia1PPNS9v2bnc2CChCDrfL97Y1LeC7FvondZOekPJW5w1XUaes0+ol6c+tRbbER
         9UC7TefLXwc7pf8BfCaSvC6o9+mUJMAptwtSj4GPxoTLMAqIGTrMPhwnP0ViyMYyap
         VVHVA3q+hYXuATT5fYdhI4sp4ISFWdoIwS+2PPYEYMPzbbKJ66IghFrMXYODoD6yK+
         nGh1d3iDDHPitq2H/ujA6qxh8ShHGvjpXp3sZj6bEZ9EzokZsCyzPKCQwGB0Z8xC8b
         /WmuxZv8xGvraQpTeeWanW9Pt8uiMize3S4U0cNES7Y2lmJU3VFzjEigl2MCf/c/VY
         ZCKJCO6Xhv24w==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5233AC43145; Thu,  6 Apr 2023 02:36:10 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217303] New: [Syzkaller & bisect] There is task hung in
 xlog_grant_head_check in v6.3-rc5
Date:   Thu, 06 Apr 2023 02:36:09 +0000
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version rep_platform
 op_sys bug_status bug_severity priority component assigned_to reporter
 cf_regression
Message-ID: <bug-217303-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217303

            Bug ID: 217303
           Summary: [Syzkaller & bisect] There is task hung in
                    xlog_grant_head_check in v6.3-rc5
           Product: File System
           Version: 2.5
          Hardware: All
                OS: Linux
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: pengfei.xu@intel.com
        Regression: No

There is task hung in xlog_grant_head_check in v6.3-rc5 kernel.

Platform: x86 platforms

All detailed info:
https://github.com/xupengfe/syzkaller_logs/tree/main/230405_094839_xlog_gra=
nt_head_check
Syzkaller reproduced code:
https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_gra=
nt_head_check/repro.c
Syzkaller analysis repro.report:
https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_gra=
nt_head_check/repro.report
Syzkaller analysis repro.stats:
https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_gra=
nt_head_check/repro.stats
Reproduced prog repro.prog:
https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_gra=
nt_head_check/repro.prog
Kconfig:
https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_gra=
nt_head_check/kconfig_origin
Bisect info:
https://github.com/xupengfe/syzkaller_logs/blob/main/230405_094839_xlog_gra=
nt_head_check/bisect_info.log

It could be reproduced in maximum 2100s.
Bisected and found bad commit was:
"
fe08cc5044486096bfb5ce9d3db4e915e53281ea
xfs: open code sb verifier feature checks
"
It's just the suspected commit, because reverted above commit on top of
v6.3-rc5
kernel then made kernel failed, could not double confirm for the issue.

"
[   24.818100] memfd_create() without MFD_EXEC nor MFD_NOEXEC_SEAL, pid=3D3=
39
'systemd'
[   28.230533] loop0: detected capacity change from 0 to 65536
[   28.232522] XFS (loop0): Deprecated V4 format (crc=3D0) will not be supp=
orted
after September 2030.
[   28.233447] XFS (loop0): Mounting V10 Filesystem
d28317a9-9e04-4f2a-be27-e55b4c413ff6
[   28.234235] XFS (loop0): Log size 66 blocks too small, minimum size is 1=
968
blocks
[   28.234856] XFS (loop0): Log size out of supported range.
[   28.235289] XFS (loop0): Continuing onwards, but if log hangs are
experienced then please report this message in the bug report.
[   28.239290] XFS (loop0): Starting recovery (logdev: internal)
[   28.240979] XFS (loop0): Ending recovery (logdev: internal)
[  300.150944] INFO: task repro:541 blocked for more than 147 seconds.
[  300.151523]       Not tainted 6.3.0-rc5-7e364e56293b+ #1
[  300.152102] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables =
this
message.
[  300.152716] task:repro           state:D stack:0     pid:541   ppid:540=
=20=20=20
flags:0x00004004
[  300.153373] Call Trace:
[  300.153580]  <TASK>
[  300.153765]  __schedule+0x40a/0xc30
[  300.154078]  schedule+0x5b/0xe0
[  300.154349]  xlog_grant_head_wait+0x53/0x3a0
[  300.154715]  xlog_grant_head_check+0x1a5/0x1c0
[  300.155113]  xfs_log_reserve+0x145/0x380
[  300.155442]  xfs_trans_reserve+0x226/0x270
[  300.155780]  xfs_trans_alloc+0x147/0x470
[  300.156112]  xfs_qm_qino_alloc+0xcf/0x510
[  300.156441]  ? write_comp_data+0x2f/0x90
[  300.156770]  xfs_qm_init_quotainos+0x30a/0x400
[  300.157139]  xfs_qm_init_quotainfo+0x9d/0x4b0
[  300.157499]  ? write_comp_data+0x2f/0x90
[  300.157827]  xfs_qm_mount_quotas+0x40/0x3c0
[  300.158167]  xfs_mountfs+0xc37/0xce0
[  300.158467]  xfs_fs_fill_super+0x7aa/0xdc0
[  300.158817]  get_tree_bdev+0x24b/0x350
[  300.159126]  ? __pfx_xfs_fs_fill_super+0x10/0x10
[  300.159503]  xfs_fs_get_tree+0x25/0x30
[  300.159815]  vfs_get_tree+0x3b/0x140
[  300.160118]  path_mount+0x769/0x10f0
[  300.160415]  ? write_comp_data+0x2f/0x90
[  300.160743]  do_mount+0xaf/0xd0
[  300.161009]  __x64_sys_mount+0x14b/0x160
[  300.161331]  do_syscall_64+0x3b/0x90
[  300.161632]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  300.162041] RIP: 0033:0x7fece24223ae
[  300.162333] RSP: 002b:00007fff584561e8 EFLAGS: 00000206 ORIG_RAX:
00000000000000a5
[  300.162937] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fece24223ae
[  300.163494] RDX: 000000002000ad00 RSI: 000000002000ad40 RDI:
00007fff58456320
[  300.164051] RBP: 00007fff584563b0 R08: 00007fff58456220 R09:
0000000000000000
[  300.164612] R10: 0000000000000003 R11: 0000000000000206 R12:
0000000000401240
[  300.165168] R13: 00007fff584564f0 R14: 0000000000000000 R15:
0000000000000000
[  300.165732]  </TASK>
[  300.165919]=20
[  300.165919] Showing all locks held in the system:
[  300.166402] 1 lock held by rcu_tasks_kthre/11:
[  300.166773]  #0: ffffffff83d63450 (rcu_tasks.tasks_gp_mutex){+.+.}-{3:3},
at: rcu_tasks_one_gp+0x31/0x420
[  300.167530] 1 lock held by rcu_tasks_rude_/12:
[  300.167886]  #0: ffffffff83d631d0
(rcu_tasks_rude.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0x420
[  300.168683] 1 lock held by rcu_tasks_trace/13:
[  300.169039]  #0: ffffffff83d62f10
(rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at: rcu_tasks_one_gp+0x31/0x4=
20
[  300.169839] 1 lock held by khungtaskd/29:
[  300.170160]  #0: ffffffff83d63e60 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x1b/0x1e0
[  300.170891] 2 locks held by repro/541:
[  300.171194]  #0: ffff88800de780e0 (&type->s_umount_key#47/1){+.+.}-{3:3},
at: alloc_super+0x12b/0x480
[  300.171926]  #1: ffff88800de78638 (sb_internal#2){.+.+}-{0:0}, at:
xfs_qm_qino_alloc+0xcf/0x510
[  300.172634]=20
[  300.172769] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
"

I hope the info is helpful.

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
../configure --target-list=3Dx86_64-softmmu --enable-kvm --enable-vnc
--enable-gtk --enable-sdl
make
make install

Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
