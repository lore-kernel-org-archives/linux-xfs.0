Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D753EC433FE
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 02:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJ3CiV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 29 Oct 2022 22:38:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3CiV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 29 Oct 2022 22:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C349B220DC
        for <linux-xfs@vger.kernel.org>; Sat, 29 Oct 2022 19:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E8D460B88
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 02:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DF4EC43142
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 02:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667097498;
        bh=TekbotUZY7hL1JVRtsmDmG4swqeDXuOR9AAJ02I5XM8=;
        h=From:To:Subject:Date:From;
        b=DCYDC4RaQyTdsyVeElxFLUQeUnk9lbxhr7zKR9r70+w2n3G+xz4YvVFeQ1cbGHWc3
         6cSoedk26/72VB0HHfUrmCDnzqSWcVKa4OxA0Z758q4jlVu5gEEPGnEk8O9h01TbXC
         +CRlCmXInOUrJ2wKjydsQbjuy94aQS1FDrI1Wr5knjURS25COY3mXDSzkbPhPB1Vy1
         Mjiw1oijqBGqcLuidHlm8tgxDIAwqVmwtoXDnYnvYZVj//Z16bH1BcrIJM9mcWCXaI
         b4jayGIvqVddxjoxmSm/uPqwFcMCG37AqbEWu580mASTrrVeqkKbZGu+ufpdamz1Fx
         2w80UvB/UlFKQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 5BEBCC433E4; Sun, 30 Oct 2022 02:38:18 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216639] New: [xfstests] WARNING: CPU: 1 PID: 429349 at
 mm/huge_memory.c:2465 __split_huge_page_tail+0xab0/0xce0
Date:   Sun, 30 Oct 2022 02:38:17 +0000
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
Message-ID: <bug-216639-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216639

            Bug ID: 216639
           Summary: [xfstests] WARNING: CPU: 1 PID: 429349 at
                    mm/huge_memory.c:2465
                    __split_huge_page_tail+0xab0/0xce0
           Product: File System
           Version: 2.5
    Kernel Version: v6.1-rc2+
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

Many xfstests cases fail [1] and hit below kernel
(HEAD=3D05c31d25cc9678cc173cf12e259d638e8a641f66) warning [2] (on x86_64 and
s390x). No special mkfs or mount options, just simple default xfs testing,
without any MKFS_OPTIONS or MOUNT_OPTIONS specified.

[1]
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 hp-xxxxxx-xx-xxxx 6.1.0-rc2+ #1 SMP
PREEMPT_DYNAMIC Fri Oct 28 19:52:51 EDT 2022
MKFS_OPTIONS  -- -f -m crc=3D1,finobt=3D1,rmapbt=3D0,reflink=3D1,bigtime=3D=
1,inobtcount=3D1
/dev/vda2
MOUNT_OPTIONS -- -o context=3Dsystem_u:object_r:root_t:s0 /dev/vda2
/mnt/xfstests/scratch

generic/061       _check_dmesg: something found in dmesg (see
/var/lib/xfstests/results//generic/061.dmesg)

Ran: generic/061
Failures: generic/061
Failed 1 of 1 tests

[2]
[14281.743118] run fstests generic/061 at 2022-10-29 01:00:39
[14295.930483] page:000000001065a86b refcount:0 mapcount:0
mapping:0000000064faa2f2 index:0x40 pfn:0x143040
[14295.947825] head:000000001065a86b order:5 compound_mapcount:0
compound_pincount:0
[14295.950100] memcg:ffff88817efe2000
[14295.951215] aops:xfs_address_space_operations [xfs] ino:8e dentry
name:"061.429109"
[14295.955474] flags:
0x17ffffc0010035(locked|uptodate|lru|active|head|node=3D0|zone=3D2|lastcpup=
id=3D0x1fffff)
[14295.958302] raw: 0017ffffc0010035 ffffea0004756c08 ffffea00050c1788
ffff88811e804448
[14295.960624] raw: 0000000000000040 0000000000000000 00000000ffffffff
ffff88817efe2000
[14295.962927] page dumped because: VM_WARN_ON_ONCE_PAGE(page_tail->private=
 !=3D
0)
[14295.965744] ------------[ cut here ]------------
[14295.967201] WARNING: CPU: 1 PID: 429349 at mm/huge_memory.c:2465
__split_huge_page_tail+0xab0/0xce0
[14295.970250] Modules linked in: dm_flakey dm_mod tls rfkill
snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg
snd_intel_sdw_acpi snd_hda_codec snd_hda_core qxl snd_hwdep snd_seq
snd_seq_device drm_ttm_helper ttm snd_pcm joydev drm_kms_helper syscopyarea
snd_timer sysfillrect snd virtio_balloon pcspkr sysimgblt fb_sys_fops i2c_p=
iix4
sunrpc soundcore drm fuse xfs libcrc32c crct10dif_pclmul crc32_pclmul
ata_generic crc32c_intel ata_piix ghash_clmulni_intel libata virtio_net
net_failover virtio_blk serio_raw failover virtio_console
[14295.984668] CPU: 1 PID: 429349 Comm: xfs_io Kdump: loaded Tainted: G=20=
=20=20=20=20=20=20
W          6.1.0-rc2+ #1
[14295.987390] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[14295.989144] RIP: 0010:__split_huge_page_tail+0xab0/0xce0
[14295.990785] Code: fe ff e9 8e f7 ff ff 80 3d 72 8b 90 03 00 0f 85 66 f7 =
ff
ff 48 c7 c6 40 2c 1f ae 4c 89 e7 e8 47 0f eb ff c6 05 56 8b 90 03 01 <0f> 0=
b e9
49 f7 ff ff 4c 89 ff e8 91 0c fe ff e9 56 f6 ff ff e8 07
[14295.996399] RSP: 0018:ffffc9000b46f6f8 EFLAGS: 00010082
[14295.998036] RAX: 0000000000000042 RBX: ffffea00050c1740 RCX:
0000000000000000
[14296.000212] RDX: 0000000000000003 RSI: 0000000000000004 RDI:
fffff5200168decf
[14296.002360] RBP: ffffea00050c1008 R08: 0000000000000042 R09:
ffff8881e49efceb
[14296.004528] R10: ffffed103c93df9d R11: 0000000000000001 R12:
ffffea00050c1000
[14296.006705] R13: 0000000000000000 R14: ffffea00050c1768 R15:
ffffea00050c1000
[14296.008872] FS:  00007fa85ff20740(0000) GS:ffff8881e4800000(0000)
knlGS:0000000000000000
[14296.011295] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[14296.013067] CR2: 00007fa85fa00658 CR3: 000000017541a000 CR4:
00000000000406e0
[14296.015290] Call Trace:
[14296.016083]  <TASK>
[14296.016818]  ? lru_add_page_tail+0x67e/0xb00
[14296.018235]  __split_huge_page+0x2a5/0x11b0
[14296.019675]  split_huge_page_to_list+0xb13/0xf30
[14296.021160]  ? kasan_quarantine_put+0x109/0x220
[14296.022588]  ? can_split_folio+0x280/0x280
[14296.023981]  ? truncate_inode_partial_folio+0x2d8/0x370
[14296.025973]  ? __kmem_cache_free+0xb8/0x3a0
[14296.027369]  truncate_inode_partial_folio+0x1d9/0x370
[14296.028940]  truncate_inode_pages_range+0x350/0xbc0
[14296.030519]  ? truncate_inode_partial_folio+0x370/0x370
[14296.050033]  ? lock_downgrade+0x130/0x130
[14296.051408]  ? __up_read+0x192/0x730
[14296.052569]  ? up_write+0x20/0x20
[14296.053650]  ? unmap_mapping_range+0xe0/0x250
[14296.055265]  ? free_pgtables+0x2a0/0x3e0
[14296.056544]  ? unmap_mapping_range+0xe0/0x250
[14296.057948]  ? __do_fault+0x430/0x430
[14296.059204]  truncate_pagecache+0x63/0x90
[14296.060471]  xfs_setattr_size+0x2a2/0xc50 [xfs]
[14296.062504]  ? xfs_vn_getattr+0x12f0/0x12f0 [xfs]
[14296.064442]  ? xfs_break_layouts+0xe7/0x130 [xfs]
[14296.066381]  ? setattr_prepare+0xe6/0x9e0
[14296.067749]  xfs_vn_setattr+0x1bc/0x200 [xfs]
[14296.069587]  ? xfs_setattr_size+0xc50/0xc50 [xfs]
[14296.071588]  notify_change+0x961/0xfb0
[14296.072769]  ? down_write_killable_nested+0x290/0x290
[14296.074498]  ? do_truncate+0xf0/0x1a0
[14296.075678]  do_truncate+0xf0/0x1a0
[14296.076794]  ? file_open_root+0x210/0x210
[14296.078042]  ? rcu_read_unlock+0x40/0x40
[14296.079437]  do_sys_ftruncate+0x30a/0x5c0
[14296.080755]  do_syscall_64+0x5c/0x90
[14296.081907]  ? lockdep_hardirqs_on+0x79/0x100
[14296.083304]  ? do_syscall_64+0x69/0x90
[14296.084699]  ? asm_exc_page_fault+0x22/0x30
[14296.086021]  ? lockdep_hardirqs_on+0x79/0x100
[14296.087422]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[14296.088989] RIP: 0033:0x7fa85fd464cb
[14296.090168] Code: 77 05 c3 0f 1f 40 00 48 8b 15 51 39 0b 00 f7 d8 64 89 =
02
b8 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 4d 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 21 39 0b 00 f7 d8
[14296.095662] RSP: 002b:00007fff0e111698 EFLAGS: 00000202 ORIG_RAX:
000000000000004d
[14296.097952] RAX: ffffffffffffffda RBX: 0000000000cfbfc0 RCX:
00007fa85fd464cb
[14296.100121] RDX: 0000000000000000 RSI: 0000000000050000 RDI:
0000000000000003
[14296.102272] RBP: 0000000000cfbfc0 R08: 1999999999999999 R09:
0000000000000000
[14296.104451] R10: 00007fa85fc05a48 R11: 0000000000000202 R12:
0000000000cfbfa0
[14296.106628] R13: 0000000000cfbfa0 R14: 0000000000cfbd70 R15:
0000000000000002
[14296.108934]  </TASK>
[14296.109705] irq event stamp: 13262
[14296.110819] hardirqs last  enabled at (13261): [<ffffffffac017f39>]
kasan_quarantine_put+0x109/0x220
[14296.113552] hardirqs last disabled at (13262): [<ffffffffac043ad3>]
split_huge_page_to_list+0xba3/0xf30
[14296.116556] softirqs last  enabled at (13168): [<ffffffffade00625>]
__do_softirq+0x625/0x9b0
[14296.119091] softirqs last disabled at (13161): [<ffffffffab825b7c>]
__irq_exit_rcu+0x1fc/0x2a0
[14296.121754] ---[ end trace 0000000000000000 ]---
[14301.252660] XFS (vda3): EXPERIMENTAL online scrub feature in use. Use at
your own risk!
[14302.306970] XFS (vda3): Unmounting Filesystem
[14304.275761] XFS (vda3): Mounting V5 Filesystem
[14304.385543] XFS (vda3): Ending clean mount
[14304.967072] XFS (vda3): Unmounting Filesystem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
