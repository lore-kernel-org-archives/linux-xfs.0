Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EBAC636D4
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Feb 2023 10:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjBMK5f (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Feb 2023 05:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBMK5f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Feb 2023 05:57:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76A9CA20
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 02:57:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 408F460F95
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 10:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B630C433A4
        for <linux-xfs@vger.kernel.org>; Mon, 13 Feb 2023 10:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676285852;
        bh=UFIlQvnpRw3u9KeVhuN+Ee7v3e2qkuz5/3vlnC1Wyb8=;
        h=From:To:Subject:Date:From;
        b=Unf12Ss7MtiuYi4TTbv4XOTL59W1+upUYPymNwJetI9hF9vQQhFE7eEET48vJJKB6
         KCvfX8Y73oZjkV0o34o0QxsuBYh7BYTPg/d/2ZzWsMnutL4l/Xr1z1+9o7s74j/fY0
         ZN/M1ikbfn/rJ4eOMt7CQO4ryYijzdcVwLAGJBN2N/5X16rI7dRkrcZmnERJ54KXWe
         zn4KlnzeSczbKU0AIRHuEG6i1C/arL8kAEVET0tO9jTnLJ/QpILSxgD9gzMl3Xshss
         V0Ru1a5WyuEYsxNxF9xD2sweTFXM9PJjvQgnQACwJ0TRExAhVCOxiBeGvY83Ygrn4g
         6urrVh/tRRgzw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 872F5C43145; Mon, 13 Feb 2023 10:57:32 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 217030] New: [Syzkaller & bisect] There is
 "xfs_bmapi_convert_delalloc" WARNING in v6.2-rc7 kernel
Date:   Mon, 13 Feb 2023 10:57:31 +0000
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
Message-ID: <bug-217030-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217030

            Bug ID: 217030
           Summary: [Syzkaller & bisect] There is
                    "xfs_bmapi_convert_delalloc" WARNING in v6.2-rc7
                    kernel
           Product: File System
           Version: 2.5
    Kernel Version: v6.2-rc7
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

userspace arch: x86

There is "xfs_bmapi_convert_delalloc" WARNING in v6.2-rc7 kernel in guest:
[   31.180821] ------------[ cut here ]------------
[   31.181101] WARNING: CPU: 0 PID: 550 at fs/xfs/libxfs/xfs_bmap.c:4544
xfs_bmapi_convert_delalloc+0x793/0xf20
[   31.181692] Modules linked in:
[   31.181886] CPU: 0 PID: 550 Comm: repro Not tainted 6.2.0-rc7-4ec5183ec4=
86
#1
[   31.182310] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[   31.182989] RIP: 0010:xfs_bmapi_convert_delalloc+0x793/0xf20
[   31.183342] Code: f9 ff ff e8 0f fd 08 ff 44 89 e6 bf 02 00 00 00 41 bf =
f5
ff ff ff e8 dc fe 08 ff 41 83 fc 02 0f 84 eb fe ff ff e8 ed fc 08 ff <0f> 0=
b e9
df 0
[   31.184391] RSP: 0018:ff1100000d03ef20 EFLAGS: 00010246
[   31.184703] RAX: 0000000000000000 RBX: ff1100001eb47800 RCX:
ffffffff82521274
[   31.185118] RDX: 0000000000000000 RSI: ff1100000efc8000 RDI:
0000000000000002
[   31.185531] RBP: ff1100000d03f120 R08: ff1100000d03f048 R09:
fffffbfff0eb4055
[   31.185946] R10: ffffffff875a02a7 R11: fffffbfff0eb4054 R12:
0000000000000000
[   31.186363] R13: ff1100000d03f0f8 R14: ff1100000e544000 R15:
00000000fffffff5
[   31.186774] FS:  00007fd840a14700(0000) GS:ff1100006ca00000(0000)
knlGS:0000000000000000
[   31.187306] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   31.187648] CR2: 00007f6e90b65000 CR3: 0000000013fa2004 CR4:
0000000000771ef0
[   31.188069] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   31.188482] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7:
0000000000000400
[   31.188897] PKRU: 55555554
[   31.189069] Call Trace:
[   31.189222]  <TASK>
[   31.189370]  ? __pfx_xfs_bmapi_convert_delalloc+0x10/0x10
[   31.189707]  ? __pfx_rwsem_wake+0x10/0x10
[   31.189996]  ? write_comp_data+0x2f/0x90
[   31.190260]  xfs_map_blocks+0x562/0xe40
[   31.190527]  ? __pfx_xfs_map_blocks+0x10/0x10
[   31.190800]  ? __this_cpu_preempt_check+0x20/0x30
[   31.191113]  ? lock_is_held_type+0xe6/0x140
[   31.191371]  ? rcu_lockdep_current_cpu_online+0x4b/0x160
[   31.191710]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   31.192012]  ? write_comp_data+0x2f/0x90
[   31.192270]  iomap_do_writepage+0xc6f/0x2ba0
[   31.192537]  ? write_comp_data+0x2f/0x90
[   31.192805]  ? __pfx_iomap_do_writepage+0x10/0x10
[   31.193093]  ? rcu_read_lock_sched_held+0xa9/0xd0
[   31.193389]  ? __pfx_rcu_read_lock_sched_held+0x10/0x10
[   31.193714]  ? write_comp_data+0x2f/0x90
[   31.193970]  write_cache_pages+0x573/0x12c0
[   31.194247]  ? __pfx_iomap_do_writepage+0x10/0x10
[   31.194543]  ? __pfx_write_cache_pages+0x10/0x10
[   31.194831]  ? __pfx_rcu_read_lock_sched_held+0x10/0x10
[   31.195173]  ? ncsi_channel_monitor.cold.17+0x204/0x3f7
[   31.195488]  ? lock_release+0x3f8/0x7d0
[   31.195729]  ? __this_cpu_preempt_check+0x20/0x30
[   31.196026]  ? xfs_vm_writepages+0x123/0x1c0
[   31.196298]  ? __pfx_lock_release+0x10/0x10
[   31.196561]  ? do_raw_spin_lock+0x132/0x2a0
[   31.196824]  ? __pfx_do_raw_spin_lock+0x10/0x10
[   31.197117]  ? __kasan_check_read+0x15/0x20
[   31.197381]  iomap_writepages+0x5b/0xc0
[   31.197626]  xfs_vm_writepages+0x13c/0x1c0
[   31.197885]  ? __pfx_xfs_vm_writepages+0x10/0x10
[   31.198189]  ? lock_release+0x3f8/0x7d0
[   31.198429]  ? __pfx_rcu_read_lock_sched_held+0x10/0x10
[   31.198752]  ? write_comp_data+0x2f/0x90
[   31.199021]  ? __pfx_xfs_vm_writepages+0x10/0x10
[   31.199310]  do_writepages+0x1c5/0x690
[   31.199550]  ? __pfx_do_writepages+0x10/0x10
[   31.199816]  ? do_raw_spin_unlock+0x154/0x230
[   31.200096]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   31.200393]  ? wbc_attach_and_unlock_inode+0x585/0x8f0
[   31.200714]  filemap_fdatawrite_wbc+0x163/0x1d0
[   31.201005]  __filemap_fdatawrite_range+0xc9/0x100
[   31.201305]  ? __pfx___filemap_fdatawrite_range+0x10/0x10
[   31.201651]  ? write_comp_data+0x2f/0x90
[   31.201908]  filemap_write_and_wait_range.part.72+0x93/0x100
[   31.202264]  filemap_write_and_wait_range+0x48/0x60
[   31.202575]  __iomap_dio_rw+0x65e/0x1c80
[   31.202819]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   31.203131]  ? timestamp_truncate+0x1ee/0x2f0
[   31.203424]  ? __pfx___iomap_dio_rw+0x10/0x10
[   31.203697]  ? write_comp_data+0x2f/0x90
[   31.203952]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   31.204251]  ? write_comp_data+0x2f/0x90
[   31.204537]  iomap_dio_rw+0x4d/0xb0
[   31.204765]  xfs_file_dio_write_aligned+0x1e9/0x450
[   31.205077]  ? __pfx_xfs_file_dio_write_aligned+0x10/0x10
[   31.205412]  ? lock_is_held_type+0xe6/0x140
[   31.205676]  ? write_comp_data+0x2f/0x90
[   31.205932]  xfs_file_write_iter+0x530/0x750
[   31.206208]  ? __sanitizer_cov_trace_pc+0x25/0x60
[   31.206513]  vfs_write+0xa65/0xe60
[   31.206736]  ? __pfx_vfs_write+0x10/0x10
[   31.206999]  ? __fget_files+0x270/0x400
[   31.207259]  ? write_comp_data+0x2f/0x90
[   31.207515]  ksys_write+0x143/0x280
[   31.207742]  ? __pfx_ksys_write+0x10/0x10
[   31.208013]  __x64_sys_write+0x7c/0xc0
[   31.208248]  ? syscall_enter_from_user_mode+0x51/0x60
[   31.208561]  do_syscall_64+0x3b/0x90
[   31.208791]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   31.209103] RIP: 0033:0x7fd846f5b59d
[   31.209324] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 =
89
f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3=
d 01
f0 8
[   31.210373] RSP: 002b:00007fd840a13e98 EFLAGS: 00000246 ORIG_RAX:
0000000000000001
[   31.210814] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fd846f5b59d
[   31.211248] RDX: 0000000000001400 RSI: 0000000020000000 RDI:
0000000000000005
[   31.211663] RBP: 00007fd840a13ec0 R08: 0000000000000005 R09:
0000000000000000
[   31.212077] R10: 0000000000000000 R11: 0000000000000246 R12:
00007ffc9b897cce
[   31.212491] R13: 00007ffc9b897ccf R14: 00007ffc9b897d60 R15:
00007fd840a14700
[   31.212929]  </TASK>
[   31.213072] irq event stamp: 995
[   31.213269] hardirqs last  enabled at (1003): [<ffffffff813dd0a1>]
__up_console_sem+0x91/0xb0
[   31.213769] hardirqs last disabled at (1010): [<ffffffff813dd086>]
__up_console_sem+0x76/0xb0
[   31.214272] softirqs last  enabled at (286): [<ffffffff8536af3f>]
__do_softirq+0x53f/0x836
[   31.214754] softirqs last disabled at (211): [<ffffffff812498b0>]
irq_exit_rcu+0x100/0x140
[   31.215258] ---[ end trace 0000000000000000 ]---

Bisected and found the first bad commit is:
7348b322332d8602a4133f0b861334ea021b134a
xfs: xfs_bmap_punch_delalloc_range() should take a byte range

After reverted above commit on top of v6.2-rc7 kernel, this issue was gone.

Reproduced code from syzkaller, kconfig, v6.2-rc7 kernel reproduced dmesg a=
re
in attached.

More detailed bisect info is in link:
https://github.com/xupengfe/syzkaller_logs/tree/main/230207_175127_xfs_bmap=
i_convert_delalloc

And previous syzbot seems repored the similar issue in email name:
"[syzbot] [xfs?] WARNING in xfs_bmapi_convert_delalloc"
And I just updated the above bisected info for this issue.

I hope it's helpful.

---
If you need the reproduced virtual machine environment:

git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.=
1.0
   // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65
v6.2-rc5 kernel
   // You could change the bzImage_xxx as you want In vm and login with roo=
t,=20
there is no password for root.

After login vm successfully, you could transfer reproduced binary to the VM=
 by
below way, and reproduce the problem:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use attached kconfig and copy it to kernel_src/.config make olddefco=
nfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel vm.


Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git cd qemu git checkout -f v7.1.0 m=
kdir
build cd build yum install -y ninja-build.x86_64 ../configure
--target-list=3Dx86_64-softmmu --enable-kvm --enable-vnc --enable-gtk
--enable-sdl make make install

---
Thanks!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
