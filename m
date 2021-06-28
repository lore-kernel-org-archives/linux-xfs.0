Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE327C2B9F4
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B67D761C6B
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Jun 2021 13:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhF1NFD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Jun 2021 09:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233106AbhF1NE6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Jun 2021 09:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80AFD61C67
        for <linux-xfs@vger.kernel.org>; Mon, 28 Jun 2021 13:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624885352;
        bh=6tzytkFClxGWVGQ+GSyOoCNAiRUd1Z7Hg4zH5B8eapk=;
        h=From:To:Subject:Date:From;
        b=ii4ujj1H7A78rWRubTb0z8So7pu434iiy58S58O3IJpgS59wELfg/n0S/dCP6JX8i
         ulxZXN0e9QKuten2InxeP7jyf10Zssm48NoSFI4N9NeLf/M0rAfUbFt6UvS3Q65Slf
         mD4lpb3ArEfhqlac4IqjZCxCmTj8EWCFbETypIwXCLvs+CoZhNLv1CBkZWRSRz8azt
         QcKaSL8QoukP31JKn0g4qGIxaWxrp9OvFY/WD2xFbBFp5vOwsIynJTauLEzngwclc1
         PDJhhDov8Mr70SoukDUeWy+RSXqf4yBcyzukn4A2OdDg/RtzvH/PZ/KI7Dn0NaTzMf
         t6jvzh1exKnIQ==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213609] New: [xfstests xfs/503] testing always hang on 64k
 directory size xfs
Date:   Mon, 28 Jun 2021 13:02:31 +0000
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
Message-ID: <bug-213609-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213609

            Bug ID: 213609
           Summary: [xfstests xfs/503] testing always hang on 64k
                    directory size xfs
           Product: File System
           Version: 2.5
    Kernel Version: 5.13.0-rc4 + xfs-5.14-merge-6
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

When test with 64k directory size xfs(n size=3D65536 -m
crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D0,bigtime=3D1,inobtcount=3D1), xfs/=
503 always hang
there(more than 24 hours), it takes too much long time, and never end[1]. I=
 hit
this issue on different ppc64le, aarch64 and x86_64 machines many times.

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/ppc64le ibm-p9z-26-lp3 5.13.0-rc4 #1 SMP Mon Jun 28
03:17:42 EDT 2021
MKFS_OPTIONS  -- -f -n size=3D65536 -m
crc=3D1,finobt=3D1,reflink=3D1,rmapbt=3D0,bigtime=3D1,inobtcount=3D1 /dev/s=
da3
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/sda3
/mnt/xfstests/scratch

xfs/503=20
...


[1]
[75021.992398] run fstests xfs/503 at 2021-06-26 05:49:20=20
[75046.366109] restraintd[762]: *** Current Time: Sat Jun 26 05:49:48 2021=
=20
Localwatchdog at: Sun Jun 27 09:00:46 2021=20
[-- MARK -- Sat Jun 26 09:50:00 2021]=20
[75106.279468] restraintd[762]: *** Current Time: Sat Jun 26 05:50:48 2021=
=20
Localwatchdog at: Sun Jun 27 09:00:46 2021=20
...
...
[172786.104914] restraintd[762]: *** Current Time: Sun Jun 27 08:58:48 2021=
=20
Localwatchdog at: Sun Jun 27 09:00:46 2021=20
[172846.109416] restraintd[762]: *** Current Time: Sun Jun 27 08:59:48 2021=
=20
Localwatchdog at: Sun Jun 27 09:00:46 2021=20
[-- MARK -- Sun Jun 27 13:00:00 2021]=20
[172906.039825] restraintd[762]: *** Current Time: Sun Jun 27 09:00:47 2021=
=20
Localwatchdog at: Sun Jun 27 09:00:46 2021=20
[172918.843299] sysrq: Show Memory=20
[172918.843422] Mem-Info:=20
[172918.843431] active_anon:41 inactive_anon:2731 isolated_anon:0=20
[172918.843431]  active_file:3718 inactive_file:172631 isolated_file:0=20
[172918.843431]  unevictable:0 dirty:3 writeback:48=20
[172918.843431]  slab_reclaimable:5601 slab_unreclaimable:9198=20
[172918.843431]  mapped:2436 shmem:83 pagetables:79 bounce:0=20
[172918.843431]  free:300069 free_pcp:118 free_cma:0=20
[172918.843462] Node 0 active_anon:2624kB inactive_anon:174784kB
active_file:237952kB inactive_file:11048384kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB mapped:155904kB dirty:192kB
writeback:3072kB shmem:5312kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp:=
 0kB
writeback_tmp:0kB kernel_stack:3008kB pagetables:5056kB all_unreclaimable? =
no=20
[172918.843491] Node 0 Normal free:19204416kB min:180224kB low:225280kB
high:270336kB reserved_highatomic:0KB active_anon:2624kB inactive_anon:1747=
84kB
active_file:237952kB inactive_file:11048384kB unevictable:0kB
writepending:3264kB present:33554432kB managed:33294272kB mlocked:0kB
bounce:0kB free_pcp:7552kB local_pcp:384kB free_cma:0kB=20
[172918.843522] lowmem_reserve[]: 0 0 0=20
[172918.843541] Node 0 Normal: 12805*64kB (UME) 1441*128kB (UME) 17*256kB (=
UME)
10*512kB (UME) 19*1024kB (UME) 49*2048kB (UME) 28*4096kB (UME) 34*8192kB (U=
ME)
1079*16384kB (UME) =3D 19204800kB=20
[172918.843623] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_sur=
p=3D0
hugepages_size=3D16384kB=20
[172918.843636] Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_sur=
p=3D0
hugepages_size=3D16777216kB=20
[172918.843648] 176432 total pagecache pages=20
[172918.843656] 0 pages in swap cache=20
[172918.843664] Swap cache stats: add 0, delete 0, find 0/0=20
[172918.843674] Free swap  =3D 14680000kB=20
[172918.843682] Total swap =3D 14680000kB=20
[172918.843690] 524288 pages RAM=20
[172918.843698] 0 pages HighMem/MovableOnly=20
[172918.843706] 4065 pages reserved=20
[172918.843714] 0 pages cma reserved=20
[172918.843722] 0 pages hwpoisoned=20
[172941.973583] sysrq: Show State=20
[172941.973608] task:systemd         state:S stack: 6832 pid:    1 ppid:   =
  0
flags:0x00040000=20
[172941.973735] Call Trace:=20
[172941.973744] [c0000000096d3820] [c000000009617c10] 0xc000000009617c10
(unreliable)=20
[172941.973764] [c0000000096d3a10] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.973782] [c0000000096d3a70] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.973799] [c0000000096d3b30] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.973815] [c0000000096d3b60] [c000000000fec1e4]
schedule_hrtimeout_range_clock+0x1d4/0x200=20
[172941.973831] [c0000000096d3c00] [c00000000066b8a0] ep_poll+0x510/0x550=20
[172941.973846] [c0000000096d3cf0] [c00000000066ba04] do_epoll_wait+0x124/0=
x140=20
[172941.973862] [c0000000096d3d40] [c00000000066ba88] sys_epoll_wait+0x68/0=
x130=20
[172941.973878] [c0000000096d3db0] [c000000000030bf4]
system_call_exception+0x154/0x2e0=20
[172941.973893] [c0000000096d3e10] [c00000000000ce70]
system_call_vectored_common+0xf0/0x268=20
[172941.973909] --- interrupt: 3000 at 0x7fffabb38770=20
[172941.973920] NIP:  00007fffabb38770 LR: 0000000000000000 CTR:
0000000000000000=20
[172941.973933] REGS: c0000000096d3e80 TRAP: 3000   Tainted: G        W=20=
=20=20=20=20=20=20=20
 (5.13.0-rc4)=20
[172941.973945] MSR:  800000000000d033 <SF,EE,PR,ME,IR,DR,RI,LE>  CR: 24084=
888=20
XER: 00000000=20
[172941.973988] IRQMASK: 0=20=20
[172941.973988] GPR00: 00000000000000ee 00007fffcbad9850 00007fffabc17200
0000000000000004=20=20
[172941.973988] GPR04: 0000010010e05110 0000000000000050 ffffffffffffffff
0000000000000000=20=20
[172941.973988] GPR08: 0000000000000002 0000000000000000 0000000000000000
0000000000000000=20=20
[172941.973988] GPR12: 0000000000000000 00007fffac346490 0000000000000000
0000010010d057f0=20=20
[172941.973988] GPR16: 00007fffcbad9b10 8000000000000000 00000001275f70d8
0000000000000000=20=20
[172941.973988] GPR20: 00007fffcbad98d8 7fffffffffffffff 00000000000001c2
000000000000002d=20=20
[172941.973988] GPR24: 20c49ba5e353f7cf 000000007ffffffe 000000007fffffff
7fffffffffffffff=20=20
[172941.973988] GPR28: 0000010010e05110 0000000000000004 0000000000000000
ffffffffffffffff=20=20
[172941.974156] NIP [00007fffabb38770] 0x7fffabb38770=20
[172941.974167] LR [0000000000000000] 0x0=20
[172941.974178] --- interrupt: 3000=20
[172941.974187] task:kthreadd        state:S stack: 9984 pid:    2 ppid:   =
  0
flags:0x00000800=20
[172941.974206] Call Trace:=20
[172941.974214] [c0000000096bfa60] [c000000009649710] 0xc000000009649710
(unreliable)=20
[172941.974233] [c0000000096bfc50] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.974249] [c0000000096bfcb0] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.974265] [c0000000096bfd70] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.974281] [c0000000096bfda0] [c0000000001a23b8] kthreadd+0x1d8/0x220=
=20
[172941.974297] [c0000000096bfe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.974313] task:rcu_gp          state:I stack:13920 pid:    3 ppid:   =
  2
flags:0x00000800=20
[172941.974333] Call Trace:=20
[172941.974341] [c00000000969b9a0] [c00000000969ba10] 0xc00000000969ba10
(unreliable)=20
[172941.974359] [c00000000969bb90] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.974375] [c00000000969bbf0] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.974390] [c00000000969bcb0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.974406] [c00000000969bce0] [c000000000193ff0]
rescuer_thread+0x320/0x4a0=20
[172941.974423] [c00000000969bda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.974438] [c00000000969be10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.974454] task:rcu_par_gp      state:I stack:13952 pid:    4 ppid:   =
  2
flags:0x00000800=20
[172941.974473] Call Trace:=20
[172941.974480] [c0000000096eb9a0] [c0000000096eba10] 0xc0000000096eba10
(unreliable)=20
[172941.974499] [c0000000096ebb90] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.974515] [c0000000096ebbf0] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.974531] [c0000000096ebcb0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.974546] [c0000000096ebce0] [c000000000193ff0]
rescuer_thread+0x320/0x4a0=20
[172941.974563] [c0000000096ebda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.974578] [c0000000096ebe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.974594] task:kworker/0:0H    state:I stack:12592 pid:    6 ppid:   =
  2
flags:0x00000800=20
[172941.974613] Workqueue:  0x0 (events_highpri)=20
[172941.974630] Call Trace:=20
[172941.974637] [c0000000096879d0] [c000000009687a40] 0xc000000009687a40
(unreliable)=20
[172941.974656] [c000000009687bc0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.974671] [c000000009687c20] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.974687] [c000000009687ce0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.974702] [c000000009687d10] [c0000000001938e4] worker_thread+0x134/0=
x520=20
[172941.974718] [c000000009687da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.974733] [c000000009687e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.974749] task:mm_percpu_wq    state:I stack:13952 pid:    8 ppid:   =
  2
flags:0x00000800=20
[172941.974768] Call Trace:=20
[172941.974775] [c0000000096af9a0] [c0000000096afa10] 0xc0000000096afa10
(unreliable)=20
[172941.974794] [c0000000096afb90] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.974809] [c0000000096afbf0] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.974825] [c0000000096afcb0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.974840] [c0000000096afce0] [c000000000193ff0]
rescuer_thread+0x320/0x4a0=20
[172941.974856] [c0000000096afda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.974871] [c0000000096afe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.974887] task:rcu_tasks_kthre state:S stack:12784 pid:    9 ppid:   =
  2
flags:0x00000800=20
[172941.974905] Call Trace:=20
[172941.974913] [c0000000096a7990] [c0000000096a7c48] 0xc0000000096a7c48
(unreliable)=20
[172941.974931] [c0000000096a7b80] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.974946] [c0000000096a7be0] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.974962] [c0000000096a7ca0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.974977] [c0000000096a7cd0] [c00000000024d2ac]
rcu_tasks_kthread+0x26c/0x2b0=20
[172941.974994] [c0000000096a7da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.975009] [c0000000096a7e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.975025] task:rcu_tasks_rude_ state:S stack:13008 pid:   10 ppid:   =
  2
flags:0x00000800=20
[172941.975043] Call Trace:=20
[172941.975051] [c0000000096c3990] [c00000000961e610] 0xc00000000961e610
(unreliable)=20
[172941.975069] [c0000000096c3b80] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.975085] [c0000000096c3be0] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.975100] [c0000000096c3ca0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.975116] [c0000000096c3cd0] [c00000000024d2ac]
rcu_tasks_kthread+0x26c/0x2b0=20
[172941.975132] [c0000000096c3da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.975147] [c0000000096c3e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.975163] task:rcu_tasks_trace state:S stack:11728 pid:   11 ppid:   =
  2
flags:0x00000800=20
[172941.975181] Call Trace:=20
[172941.975188] [c0000000096e7990] [c0000000096e7a00] 0xc0000000096e7a00
(unreliable)=20
[172941.975207] [c0000000096e7b80] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.975223] [c0000000096e7be0] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.975238] [c0000000096e7ca0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.975254] [c0000000096e7cd0] [c00000000024d2ac]
rcu_tasks_kthread+0x26c/0x2b0=20
[172941.975270] [c0000000096e7da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.975285] [c0000000096e7e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.975300] task:ksoftirqd/0     state:S stack: 8944 pid:   13 ppid:   =
  2
flags:0x00000800=20
[172941.975318] Call Trace:=20
[172941.975325] [c00000000969f9f0] [c00000000969fa60] 0xc00000000969fa60
(unreliable)=20
[172941.975344] [c00000000969fbe0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.975359] [c00000000969fc40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.975375] [c00000000969fd00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.975391] [c00000000969fd30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.975407] [c00000000969fda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.975422] [c00000000969fe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.975438] task:rcu_sched       state:I stack: 9568 pid:   14 ppid:   =
  2
flags:0x00000800=20
[172941.975455] Call Trace:=20
[172941.975462] [c0000000096ef830] [c00000000965a010] 0xc00000000965a010
(unreliable)=20
[172941.975480] [c0000000096efa20] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.975496] [c0000000096efa80] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.975512] [c0000000096efb40] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.975527] [c0000000096efb70] [c000000000febb3c]
schedule_timeout+0xdc/0x190=20
[172941.975543] [c0000000096efc60] [c0000000002601cc]
rcu_gp_fqs_loop+0x41c/0x480=20
[172941.975559] [c0000000096efd10] [c0000000002603b0]
rcu_gp_kthread+0x180/0x1a0=20
[172941.975574] [c0000000096efda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.975589] [c0000000096efe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.975605] task:migration/0     state:S stack:11472 pid:   15 ppid:   =
  2
flags:0x00000800=20
[172941.975623] Stopper: 0x0 <- 0x0=20
[172941.975635] Call Trace:=20
[172941.975642] [c0000000096f39f0] [c0000000096f3a60] 0xc0000000096f3a60
(unreliable)=20
[172941.975661] [c0000000096f3be0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.975676] [c0000000096f3c40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.975692] [c0000000096f3d00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.975707] [c0000000096f3d30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.975723] [c0000000096f3da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.975738] [c0000000096f3e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.975754] task:cpuhp/0         state:S stack:12528 pid:   16 ppid:   =
  2
flags:0x00000800=20
[172941.975772] Call Trace:=20
[172941.975780] [c0000000096c79f0] [c000000009671310] 0xc000000009671310
(unreliable)=20
[172941.975798] [c0000000096c7be0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.975814] [c0000000096c7c40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.975829] [c0000000096c7d00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.975845] [c0000000096c7d30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.975860] [c0000000096c7da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.975875] [c0000000096c7e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.975891] task:cpuhp/1         state:S stack:10960 pid:   17 ppid:   =
  2
flags:0x00000800=20
[172941.975909] Call Trace:=20
[172941.975917] [c0000000096b39f0] [c000000009632410] 0xc000000009632410
(unreliable)=20
[172941.975935] [c0000000096b3be0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.975950] [c0000000096b3c40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.975966] [c0000000096b3d00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.975981] [c0000000096b3d30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.975997] [c0000000096b3da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.976012] [c0000000096b3e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.976028] task:migration/1     state:S stack:11520 pid:   18 ppid:   =
  2
flags:0x00000800=20
[172941.976045] Stopper: 0x0 <- 0x0=20
[172941.976057] Call Trace:=20
[172941.976064] [c0000000096df9f0] [0000000000000001] 0x1 (unreliable)=20
[172941.976081] [c0000000096dfbe0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.976097] [c0000000096dfc40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.976112] [c0000000096dfd00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.976128] [c0000000096dfd30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.976144] [c0000000096dfda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.976159] [c0000000096dfe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.976175] task:ksoftirqd/1     state:S stack:11024 pid:   19 ppid:   =
  2
flags:0x00000800=20
[172941.976193] Call Trace:=20
[172941.976200] [c0000000096ff9f0] [c0000000096ffa60] 0xc0000000096ffa60
(unreliable)=20
[172941.976218] [c0000000096ffbe0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.976233] [c0000000096ffc40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.976249] [c0000000096ffd00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.976264] [c0000000096ffd30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.976280] [c0000000096ffda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.976295] [c0000000096ffe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.976311] task:kworker/1:0H    state:I stack:13216 pid:   21 ppid:   =
  2
flags:0x00000800=20
[172941.976329] Workqueue:  0x0 (events_highpri)=20
[172941.976345] Call Trace:=20
[172941.976353] [c0000000096cf9d0] [c00000000964f980] 0xc00000000964f980
(unreliable)=20
[172941.976371] [c0000000096cfbc0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.976386] [c0000000096cfc20] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.976402] [c0000000096cfce0] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.976418] [c0000000096cfd10] [c0000000001938e4] worker_thread+0x134/0=
x520=20
[172941.976434] [c0000000096cfda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.976448] [c0000000096cfe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.976465] task:cpuhp/2         state:S stack:12304 pid:   22 ppid:   =
  2
flags:0x00000800=20
[172941.976483] Call Trace:=20
[172941.976490] [c0000000096839f0] [c000000009683a60] 0xc000000009683a60
(unreliable)=20
[172941.976508] [c000000009683be0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.976524] [c000000009683c40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.976540] [c000000009683d00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.976555] [c000000009683d30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.976571] [c000000009683da0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.976586] [c000000009683e10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.976602] task:migration/2     state:S stack:11568 pid:   23 ppid:   =
  2
flags:0x00000800=20
[172941.976620] Stopper: 0x0 <- 0x0=20
[172941.976631] Call Trace:=20
[172941.976639] [c00000000968f9f0] [0000000000000001] 0x1 (unreliable)=20
[172941.976656] [c00000000968fbe0] [c00000000001fc80] __switch_to+0x110/0x2=
20=20
[172941.976672] [c00000000968fc40] [c000000000fe20bc] __schedule+0x2fc/0x8a=
0=20
[172941.976688] [c00000000968fd00] [c000000000fe26e8] schedule+0x88/0x160=20
[172941.976703] [c00000000968fd30] [c0000000001a9e50]
smpboot_thread_fn+0x2c0/0x330=20
[172941.976719] [c00000000968fda0] [c00000000019fb24] kthread+0x1b4/0x1c0=20
[172941.976734] [c00000000968fe10] [c00000000000d5ec]
ret_from_kernel_thread+0x5c/0x70=20
[172941.976750] task:ksoftirqd/2     state:S stack:11184 pid:   24 ppid:   =
  2
flags:0x00000800=20
[172941.976768] Call Trace:=20
...
...
[172942.734136] cfs_rq[7]:/=20
[172942.734148]   .exec_clock                    : 0.000000=20
[172942.734164]   .MIN_vruntime                  : 0.000001=20
[172942.734178]   .min_vruntime                  : 75287731.894395=20
[172942.734194]   .max_vruntime                  : 0.000001=20
[172942.734208]   .spread                        : 0.000000=20
[172942.734222]   .spread0                       : 30539243.819599=20
[172942.734238]   .nr_spread_over                : 0=20
[172942.734252]   .nr_running                    : 0=20
[172942.734266]   .load                          : 0=20
[172942.734280]   .load_avg                      : 0=20
[172942.734293]   .runnable_avg                  : 1=20
[172942.734307]   .util_avg                      : 0=20
[172942.737370]   .util_est_enqueued             : 0=20
[172942.737385]   .removed.load_avg              : 0=20
[172942.737399]   .removed.util_avg              : 0=20
[172942.737413]   .removed.runnable_avg          : 0=20
[172942.737427]   .tg_load_avg_contrib           : 0=20
[172942.737441]   .tg_load_avg                   : 0=20
[172942.737455]   .throttled                     : 0=20
[172942.737469]   .throttle_count                : 0=20
[172942.737484]=20=20
[172942.737496] rt_rq[7]:/=20
[172942.737509]   .rt_nr_running                 : 0=20
[172942.737523]   .rt_nr_migratory               : 0=20
[172942.737537]   .rt_throttled                  : 0=20
[172942.737551]   .rt_time                       : 0.000000=20
[172942.737566]   .rt_runtime                    : 950.000000=20
[172942.737581]=20=20
[172942.737591] dl_rq[7]:=20
[172942.737602]   .dl_nr_running                 : 0=20
[172942.737616]   .dl_nr_migratory               : 0=20
[172942.737630]   .dl_bw->bw                     : 996147=20
[172942.740676]   .dl_bw->total_bw               : 0=20
[172942.740691]=20=20
[172942.740701] runnable tasks:=20
[172942.740709]  S            task   PID         tree-key  switches  prio=
=20=20=20=20
wait-time             sum-exec        sum-sleep=20
[172942.740721]
---------------------------------------------------------------------------=
----------------------------------=20
[172942.740734]  S         cpuhp/7    47      2663.598398         9   120=
=20=20=20=20=20=20
  0.000000         0.379198         0.000000 0 0 /=20
[172942.740768]  S     migration/7    48         0.000000     52852     0=
=20=20=20=20=20=20
  0.000000      1771.061466         0.000000 0 0 /=20
[172942.740801]  S     ksoftirqd/7    49  75279596.163694     44606   120=
=20=20=20=20=20=20
  0.000000     33406.303986         0.000000 0 0 /=20
[172942.740833]  I    kworker/7:0H    51       358.671859         5   100=
=20=20=20=20=20=20
  0.000000         0.106600         0.000000 0 0 /=20
[172942.740865]  S      oom_reaper    59        35.224815         2   120=
=20=20=20=20=20=20
  0.000000         0.017696         0.000000 0 0 /=20
[172942.743837]  I       writeback    60        47.238399         2   100=
=20=20=20=20=20=20
  0.000000         0.016678         0.000000 0 0 /=20
[172942.743869]  S            ksmd    62        71.298389         2   125=
=20=20=20=20=20=20
  0.000000         0.023056         0.000000 0 0 /=20
[172942.743901]  S      khugepaged    63        84.362384         2   139=
=20=20=20=20=20=20
  0.000000         0.030786         0.000000 0 0 /=20
[172942.743933]  I              md   141       209.098689         2   100=
=20=20=20=20=20=20
  0.000000         0.017784         0.000000 0 0 /=20
[172942.743964]  I     edac-poller   142       221.119487         2   100=
=20=20=20=20=20=20
  0.000000         0.023726         0.000000 0 0 /=20
[172942.743996]  S       watchdogd   143         0.000000         2    49=
=20=20=20=20=20=20
  0.000000         0.038928         0.000000 0 0 /=20
[172942.744028]  I    kworker/7:1H   214  75122519.172109    682616   100=
=20=20=20=20=20=20
  0.000000     38985.686492         0.000000 0 0 /=20
[172942.744060]  S    xfsaild/sda8   392  75287719.953511   2681087   120=
=20=20=20=20=20=20
  0.000000     51054.955104         0.000000 0 0 /=20
[172942.747096]  S    xfsaild/sda2   538   2767430.522652       989   120=
=20=20=20=20=20=20
  0.000000        17.750766         0.000000 0 0 /=20
[172942.747130]  I     kworker/7:0 362694  75287666.402045      7808   120=
=20=20=20=20=20
   0.000000       366.719398         0.000000 0 0 /=20
[172942.747162]  I     kworker/7:1 362864  65388521.041562         4   120=
=20=20=20=20=20
   0.000000         0.082238         0.000000 0 0 /=20
[172942.747195]=20=20
[172942.747203]=20=20
[172942.747203] Showing all locks held in the system:=20
[172942.747218] 3 locks held by xfs_scrub/363339:=20
[172942.747229] 3 locks held by xfs_scrub/363340:=20
[172942.747239] 3 locks held by 20_sysinfo/363640:=20
[172942.747248]  #0: c00000002be4b480 (sb_writers#4){.+.+}-{0:0}, at:
ksys_write+0x84/0x140=20
[172942.747282]  #1: c000000002abd8a0 (rcu_read_lock){....}-{1:2}, at:
__handle_sysrq+0x10/0x2d0=20
[172942.747309]  #2: c000000002abd8a0 (rcu_read_lock){....}-{1:2}, at:
rcu_lock_acquire.constprop.0+0x8/0x30=20
[172942.750357]=20=20
[172942.750369] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=20
[172942.750369]=20=20
[172942.750385] Showing busy workqueues and worker pools:=20
[172942.750405] workqueue mm_percpu_wq: flags=3D0x8=20
[172942.750427]   pwq 2: cpus=3D1 node=3D0 flags=3D0x0 nice=3D0 active=3D1/=
256 refcnt=3D2=20
[172942.751053]     pending: vmstat_update=20
[172960.420967] sysrq: Show Blocked State=20
         Stopping=20=20=20=20=20=20=20=20=20
/usr/bin/bash -c =E2=80=A6ore_adj; exec ./tests/xfs/503

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
