Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0967C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 29 May 2022 09:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbiE2Jqe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 29 May 2022 05:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiE2Jqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 May 2022 05:46:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451C210E8
        for <linux-xfs@vger.kernel.org>; Sun, 29 May 2022 02:46:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5950B80AED
        for <linux-xfs@vger.kernel.org>; Sun, 29 May 2022 09:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59AFBC3411F
        for <linux-xfs@vger.kernel.org>; Sun, 29 May 2022 09:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653817588;
        bh=6hKVx9GF6sasGlrnXG44xmRaLufE+Th7JTvPpm0s5yE=;
        h=From:To:Subject:Date:From;
        b=qdztNyjwPzSkse7F8VXMhqxSIponvteZ/jEHLhZx8dpBfr6Q/++D+ZfWedy1odEQT
         +sYAHT4bYBmUIBFfD/9xCs2gx/Kq9iMfFletAb/+W12H631RHMg0887qzX8hKW6+KY
         AUUhAodzUUJTuRj2oWm1B79BWpmuO4PHwmirV8sCg3nvInKXUtmZEtkwiVN1GU6+sj
         rZk2U4mfRiBfiM441nbXEaZs3358oUFKaUnDIJKgFCgF75qD3btWPI5n/M/R77ZFtO
         PZ+z31zYhmILlc8owW7awMrpDtiiS8z8wOpVXl0WUAClWE8OVGTm1xWiYg3trenkFA
         3nYj9/QY2ttVg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 46622C05FD5; Sun, 29 May 2022 09:46:28 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216047] New: [generic/623 DAX with XFS] kernel BUG at
 mm/page_table_check.c:51!
Date:   Sun, 29 May 2022 09:46:27 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression
Message-ID: <bug-216047-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216047

            Bug ID: 216047
           Summary: [generic/623 DAX with XFS] kernel BUG at
                    mm/page_table_check.c:51!
           Product: File System
           Version: 2.5
    Kernel Version: 5.19.0-0.rc0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: XFS
          Assignee: filesystem_xfs@kernel-bugs.kernel.org
          Reporter: zlang@redhat.com
        Regression: No

On Fedora rawhide system with kernel
5.19.0-0.rc0.20220526gitbabf0bb978e3.4.fc37.x86_64, which base on latest
upstream mailine linux which HEAD is:
babf0bb978e3 Merge tag 'xfs-5.19-for-linus' of
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux

I hit a bug with DAX testing on xfs. Not sure if it's a bug from XFS side o=
r mm
side. Report to xfs list at first, feel free to change it to other componen=
t if
it's not a xfs/iomap bug.

# ./check generic/623 generic/139 generic/591 generic/506
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 hp-xxxxxx-xx
5.19.0-0.rc0.20220526gitbabf0bb978e3.4.fc37.x86_64 #1 SMP PREEMPT_DYNAMIC T=
hu
May 26 16:02:31 UTC 2022
MKFS_OPTIONS  -- -f -m reflink=3D0 /dev/pmem0p2
MOUNT_OPTIONS -- -o dax=3Dalways -o context=3Dsystem_u:object_r:root_t:s0
/dev/pmem0p2 /mnt/scratch

generic/139 5s ... [not run] Reflink not supported by test filesystem type:=
 xfs
generic/506 6s ...  5s
generic/591 3s ...  2s
generic/623 4s ... ^C^C

# dmesg
[91876.709062] run fstests generic/623 at 2022-05-29 17:32:56
[91877.213522] systemd[1]: Started fstests-generic-623.scope - /usr/bin/bas=
h -c
test -w /proc/self/oom_score_adj && echo 250 > /proc/self/oom_score_adj; ex=
ec
./tests/generic/623.
[91878.417157] XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at yo=
ur
own risk
[91878.417443] XFS (pmem0p2): Mounting V5 Filesystem
[91878.486455] XFS (pmem0p2): Ending clean mount
[91878.497348] XFS (pmem0p2): User initiated shutdown received.
[91878.497467] XFS (pmem0p2): Metadata I/O Error (0x4) detected at
xfs_fs_goingdown+0x6b/0xa0 [xfs] (fs/xfs/xfs_fsops.c:485).  Shutting down
filesystem.
[91878.497651] XFS (pmem0p2): Please unmount the filesystem and rectify the
problem(s)
[91878.513406] systemd[1]: mnt-scratch.mount: Deactivated successfully.
[91878.534953] XFS (pmem0p2): Unmounting Filesystem
[91878.966315] XFS (pmem0p2): DAX enabled. Warning: EXPERIMENTAL, use at yo=
ur
own risk
[91878.966650] XFS (pmem0p2): Mounting V5 Filesystem
[91878.979236] XFS (pmem0p2): Ending clean mount
[91879.014998] ------------[ cut here ]------------
[91879.015001] kernel BUG at mm/page_table_check.c:51!
[91879.015012] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[91879.015019] CPU: 12 PID: 48184 Comm: xfs_io Tainted: G S        I=20=20=
=20=20=20
--------  ---  5.19.0-0.rc0.20220526gitbabf0bb978e3.4.fc37.x86_64 #1
[91879.015022] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 08/02/2014
[91879.015024] RIP: 0010:page_table_check_set.part.0+0x89/0xe0
[91879.015037] Code: 75 64 44 89 c1 f0 0f c1 08 83 c1 01 83 f9 01 7e 04 84 =
db
75 67 48 83 c6 01 48 03 15 41 a4 e6 01 4c 39 e6 74 4f 48 85 d2 75 c2 <0f> 0=
b f7
c5 ff 0f 00 00 75 a4 48 8b 45 00
a9 00 00 01 00 74 99 48
[91879.015040] RSP: 0000:ffffbdb2a1437b30 EFLAGS: 00010246
[91879.015044] RAX: ffff970cc3dbdd30 RBX: 0000000000000001 RCX:
0000000000000000
[91879.015047] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
0000000000000000
[91879.015048] RBP: fffff49809008300 R08: 0000000000000000 R09:
0000000000000000
[91879.015050] R10: 0000000000000001 R11: 0000000000000001 R12:
0000000000000001
[91879.015052] R13: fffff49809008300 R14: ffff9711fe8d7bb0 R15:
ffff971191976200
[91879.015054] FS:  00007fceec2f4740(0000) GS:ffff9714eae00000(0000)
knlGS:0000000000000000
[91879.015056] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[91879.015058] CR2: 00007fceec576000 CR3: 000000053742a001 CR4:
00000000001706e0
[91879.015061] Call Trace:
[91879.015063]  <TASK>
[91879.015066]  insert_pfn+0x10e/0x160
[91879.015074]  __vm_insert_mixed+0xb0/0xd0
[91879.015079]  dax_fault_iter+0x742/0xa40
[91879.015088]  ? lock_is_held_type+0xd0/0x140
[91879.015101]  dax_iomap_pte_fault+0x1c9/0x640
[91879.015113]  __xfs_filemap_fault+0x305/0x410 [xfs]
[91879.015265]  __do_fault+0x36/0x1a0
[91879.015270]  __handle_mm_fault+0xc66/0x1470
[91879.015277]  handle_mm_fault+0x11a/0x3a0
[91879.015282]  do_user_addr_fault+0x1e0/0x6a0
[91879.015292]  exc_page_fault+0x77/0x2d0
[91879.015297]  asm_exc_page_fault+0x27/0x30
[91879.015304] RIP: 0033:0x558d1bd1488e
[91879.015330] Code: c0 0f 84 e1 00 00 00 48 8b 05 8e c2 02 00 48 2b 58 10 =
49
8d 14 1c 45 85 f6 75 55 4d 85 e4 0f 8e c7 fe ff ff 48 8b 00 44 89 ee <44> 8=
8 2c
18 48 8d 43 01 49 83 fc 01 0f 8e af fe ff ff 48 8b 0d 59
[91879.015333] RSP: 002b:00007ffd5dc58990 EFLAGS: 00010206
[91879.015336] RAX: 00007fceec576000 RBX: 0000000000000000 RCX:
0000000000001000
[91879.015338] RDX: 0000000000001000 RSI: 0000000000000058 RDI:
0000000000000000
[91879.015340] RBP: 0000558d1c2e83e0 R08: 1999999999999999 R09:
0000000000000000
[91879.015342] R10: 00007fceec4a0ac0 R11: 00007fceec4a13c0 R12:
0000000000001000
[91879.015343] R13: 0000000000000058 R14: 0000000000000000 R15:
0000000000001000
[91879.015350]  </TASK>
[91879.015352] Modules linked in: scsi_debug nls_utf8 hfsplus hfs vfat fat
isofs binfmt_misc tls dm_dust nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib
nft_reject_inet nf_reject_ipv4 nf_rejec
t_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack iTCO_wdt
nf_defrag_ipv6 intel_pmc_bxt nf_defrag_ipv4 intel_rapl_msr iTCO_vendor_supp=
ort
intel_rapl_common sb_edac x86_pkg_temp_thermal ip_set intel_powerclamp core=
temp
rfkill nf_tables nfnetlink qrtr kvm_intel kvm irqbypass rapl sunrpc
intel_cstate lpc_ich hpilo ipmi_ssif pktcdvd intel_uncore dax_pmem acpi_ipmi
ioatdma tg
3 dca ipmi_si acpi_power_meter fuse zram xfs nd_pmem nd_btt crct10dif_pclmul
crc32_pclmul crc32c_intel hpsa nd_e820 libnvdimm ghash_clmulni_intel serio_=
raw
mgag200 scsi_transport_sas hpwdt at
a_generic pata_acpi scsi_dh_rdac scsi_dh_emc scsi_dh_alua dm_multipath
ipmi_devintf ipmi_msghandler
[91879.015432] ---[ end trace 0000000000000000 ]---
[91879.042514] RIP: 0010:page_table_check_set.part.0+0x89/0xe0
[91879.042522] Code: 75 64 44 89 c1 f0 0f c1 08 83 c1 01 83 f9 01 7e 04 84 =
db
75 67 48 83 c6 01 48 03 15 41 a4 e6 01 4c 39 e6 74 4f 48 85 d2 75 c2 <0f> 0=
b f7
c5 ff 0f 00 00 75 a4 48 8b 45 00=20
a9 00 00 01 00 74 99 48
[91879.042524] RSP: 0000:ffffbdb2a1437b30 EFLAGS: 00010246
[91879.042527] RAX: ffff970cc3dbdd30 RBX: 0000000000000001 RCX:
0000000000000000
[91879.042528] RDX: 0000000000000000 RSI: 0000000000000001 RDI:
0000000000000000
[91879.042529] RBP: fffff49809008300 R08: 0000000000000000 R09:
0000000000000000
[91879.042531] R10: 0000000000000001 R11: 0000000000000001 R12:
0000000000000001
[91879.042532] R13: fffff49809008300 R14: ffff9711fe8d7bb0 R15:
ffff971191976200
[91879.042534] FS:  00007fceec2f4740(0000) GS:ffff9714eae00000(0000)
knlGS:0000000000000000
[91879.042536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[91879.042537] CR2: 00007fceec576000 CR3: 000000053742a001 CR4:
00000000001706e0
[91879.042539] note: xfs_io[48184] exited with preempt_count 1
[91882.423346] systemd[1]: Created slice
system-dbus\x2d:1.2\x2dorg.freedesktop.problems.slice - Slice
/system/dbus-:1.2-org.freedesktop.problems.
[91882.429366] systemd[1]: Started dbus-:1.2-org.freedesktop.problems@0.ser=
vice
[92015.775618] systemd[1]: dbus-:1.2-org.freedesktop.problems@0.service:
Deactivated successfully.
[92332.353087] systemd[1]: Starting dnf-makecache.service - dnf makecache...
[92347.887809] systemd[1]: dnf-makecache.service: Deactivated successfully.
[92347.934938] systemd[1]: Finished dnf-makecache.service - dnf makecache.
[92347.935805] systemd[1]: dnf-makecache.service: Consumed 6.327s CPU time.

[92397.345084] sysrq: Show Blocked State
[92397.365912] task:xfs_io          state:D stack:14528 pid:48187 ppid: 479=
65
flags:0x00004006
[92397.408219] Call Trace:
[92397.420926]  <TASK>
[92397.430899]  __schedule+0x492/0x1640
[92397.447320]  ? lock_acquire+0x26a/0x2d0
[92397.464582]  ? rcu_read_lock_sched_held+0x10/0x70
[92397.485899]  ? lock_release+0x215/0x460
[92397.503192]  schedule+0x4e/0xb0
[92397.517338]  rwsem_down_write_slowpath+0x35a/0x710
[92397.538897]  down_write+0xad/0x110
[92397.554207]  exit_mmap+0x46/0x1a0
[92397.569167]  ? uprobe_clear_state+0x25/0x120
[92397.588450]  ? __mutex_unlock_slowpath+0x2a/0x260
[92397.610111]  ? uprobe_clear_state+0x68/0x120
[92397.630130]  mmput+0x71/0x150
[92397.643507]  do_exit+0x324/0xc40
[92397.658063]  ? rcu_read_lock_sched_held+0x10/0x70
[92397.679239]  do_group_exit+0x33/0xb0
[92397.695338]  get_signal+0xbbc/0xbc0
[92397.711029]  arch_do_signal_or_restart+0x30/0x770
[92397.732360]  ? __schedule+0x49a/0x1640
[92397.749793]  ? lock_is_held_type+0xe8/0x140
[92397.768690]  exit_to_user_mode_prepare+0x172/0x270
[92397.790278]  syscall_exit_to_user_mode+0x16/0x50
[92397.811059]  do_syscall_64+0x67/0x80
[92397.827127]  ? sched_clock_cpu+0xb/0xb0
[92397.844438]  ? lock_release+0x14f/0x460
[92397.861976]  ? _raw_spin_unlock_irq+0x24/0x50
[92397.883664]  ? lock_is_held_type+0xe8/0x140
[92397.904426]  ? do_syscall_64+0x67/0x80
[92397.922912]  ? lockdep_hardirqs_on+0x7d/0x100
[92397.944397]  ? do_syscall_64+0x67/0x80
[92397.961255]  ? lockdep_hardirqs_on+0x7d/0x100
[92397.981189]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[92398.004672] RIP: 0033:0x7fceec3fc422
[92398.020394] RSP: 002b:00007fceec2f2e30 EFLAGS: 00000293 ORIG_RAX:
0000000000000022
[92398.054524] RAX: fffffffffffffdfe RBX: 00007fceec2f3640 RCX:
00007fceec3fc422
[92398.086955] RDX: 0000000000000002 RSI: 0000000000000000 RDI:
0000000000000000
[92398.119583] RBP: 0000000000000000 R08: 0000000000000000 R09:
00007ffd5dc5891f
[92398.151800] R10: 0000000000000008 R11: 0000000000000293 R12:
ffffffffffffff80
[92398.183959] R13: 0000000000000016 R14: 00007ffd5dc58820 R15:
00007fceebaf3000
[92398.216164]  </TASK>

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
