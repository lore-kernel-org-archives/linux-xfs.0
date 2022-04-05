Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB1EC4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 02:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1837657AbiDFCzf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 22:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457068AbiDFAyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 20:54:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4406D19FF42
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 15:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86EC5B81E7A
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 22:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B2DEC385A9
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 22:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649199458;
        bh=mcZVUgj3LSU59KD6TZkIqbSjfAuz8Zbnd9iH6lRaW3M=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=IJLr/oGGTPtqjwNLwyDjdAKYpjHN5OkZgj5uzVMOZ9syysI31MQi+YvxbKIC4/bul
         A703hWs8z8zVzAv/+T4njLUbyPmXJDJ/AgQWSjayLoEIhCuSuP1An/wvu5FScLR0Fg
         9XbmLGiSweKvGP1eYRjzlzHAkKyQBlgjv1HjTHUYrlVE4RiBLy+uGggWTMYLKrFHQX
         OB3Vm9XUE0ZToOoG6QjMPWZs8rIJBe7NV+pL6t6nTcVuEi9bfhkuWsr/WzGyEB7sti
         VgPjteXh75VPGmPDNBXG9YDO15EhkTSFILceNCLKCpHvUHt8KSxDBpErXzAFicXlf2
         EqSj/RWBdOvXg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 12B4FC05FD4; Tue,  5 Apr 2022 22:57:38 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 22:57:37 +0000
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
Message-ID: <bug-215804-201763-WVOhU47g79@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215804-201763@https.bugzilla.kernel.org/>
References: <bug-215804-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215804

--- Comment #7 from Zorro Lang (zlang@redhat.com) ---
Get below messages from aarch64 with linux v5.18-rc1 (which reproduced this=
 bug
too):

# ./scripts/faddr2line vmlinux __split_huge_pmd+0x1d8/0x34c
__split_huge_pmd+0x1d8/0x34c:
_compound_head at
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/lin=
ux/page-flags.h:263
(inlined by) __split_huge_pmd at
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/huge_memor=
y.c:2150

# ./scripts/decode_stacktrace.sh vmlinux <crash_calltrace.log
[ 2129.736862] Unable to handle kernel paging request at virtual address
fffffd1d59000008
[ 2129.780524] KASAN: maybe wild-memory-access in range
[0x0003e8eac8000040-0x0003e8eac8000047]
[ 2129.783285] Mem abort info:
[ 2129.783997]   ESR =3D 0x96000006
[ 2129.784732]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[ 2129.786221]   SET =3D 0, FnV =3D 0
[ 2129.787015]   EA =3D 0, S1PTW =3D 0
[ 2129.787944]   FSC =3D 0x06: level 2 translation fault
[ 2129.789120] Data abort info:
[ 2129.789858]   ISV =3D 0, ISS =3D 0x00000006
[ 2129.790801]   CM =3D 0, WnR =3D 0
[ 2129.791542] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000fa88b0=
00
[ 2129.793131] [fffffd1d59000008] pgd=3D10000001bf22e003, p4d=3D10000001bf2=
2e003,
pud=3D10000001bf22d003, pmd=3D0000000000000000
[ 2129.797297] Internal error: Oops: 96000006 [#1] SMP
[ 2129.798708] Modules linked in: tls rfkill sunrpc vfat fat drm fuse xfs
libcrc32c crct10dif_ce ghash_ce sha2_ce virtio_console virtio_blk sha256_ar=
m64
sha1_ce virtio_net net_failover failover virtio_mmio
[ 2129.805211] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15
[ 2129.806925] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[ 2129.808682] pc : __split_huge_pmd
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/page-flags.h:263
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/huge_memor=
y.c:2150)=20
[ 2129.809909] lr : __split_huge_pmd
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./arch/arm64=
/include/asm/pgtable.h:387
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/huge_memor=
y.c:2150)=20
[ 2129.811003] sp : ffff80000e5a6fe0
[ 2129.811834] x29: ffff80000e5a6fe0 x28: 0000000000000000 x27:
ffff4757455eede0
[ 2129.813645] x26: 0000000000000000 x25: 0000000000000000 x24:
fffffd1d5eeb4800
[ 2129.815412] x23: 1ffff00001cb4e0a x22: ffff4757943b0a50 x21:
ffff475755a56270
[ 2129.817219] x20: ffff80000e5a7080 x19: fffffd1d59000000 x18:
0000000000000000
[ 2129.819029] x17: 0000000000000000 x16: ffffb625b8e67e20 x15:
1fffe8eaf65232e9
[ 2129.820840] x14: 0000000000000000 x13: 0000000000000000 x12:
ffff700001cb4ded
[ 2129.822654] x11: 1ffff00001cb4dec x10: ffff700001cb4dec x9 :
dfff800000000000
[ 2129.824447] x8 : ffff80000e5a6f63 x7 : 0000000000000001 x6 :
0000000000000003
[ 2129.826256] x5 : ffff80000e5a6f60 x4 : ffff700001cb4dec x3 :
1fffe8eaf8fd6c01
[ 2129.828045] x2 : 1fffffa3ab200001 x1 : 0000000000000000 x0 :
fffffd1d59000008
[ 2129.829858] Call trace:
[ 2129.830506] __split_huge_pmd
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./include/li=
nux/page-flags.h:263
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/huge_memor=
y.c:2150)=20
[ 2129.831525] split_huge_pmd_address
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/huge_memo=
ry.c:2199)=20
[ 2129.832667] try_to_unmap_one
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/internal.=
h:504
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/rmap.c:145=
2)=20
[ 2129.833719] rmap_walk_file
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/rmap.c:23=
23)=20
[ 2129.834684] try_to_unmap
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/rmap.c:23=
52
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/rmap.c:172=
6)=20
[ 2129.835628] split_huge_page_to_list
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./arch/arm64=
/include/asm/irqflags.h:70
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/./arch/arm64/=
include/asm/irqflags.h:98
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/huge_memor=
y.c:2567)=20
[ 2129.836811] truncate_inode_partial_folio
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/truncate.=
c:243)=20
[ 2129.838119] truncate_inode_pages_range
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/truncate.=
c:381)=20
[ 2129.839360] truncate_pagecache_range
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/mm/truncate.=
c:868)=20
[ 2129.840518] xfs_flush_unmap_range
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_b=
map_util.c:953)
xfs
[ 2129.842300] xfs_reflink_remap_prep
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_r=
eflink.c:1372)
xfs
[ 2129.843932] xfs_file_remap_range
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/xfs/xfs_f=
ile.c:1129)
xfs
[ 2129.845495] do_clone_file_range
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/remap_ran=
ge.c:383)=20
[ 2129.846573] vfs_clone_file_range
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/remap_ran=
ge.c:401)=20
[ 2129.847646] ioctl_file_clone
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/ioctl.c:2=
41)=20
[ 2129.848615] do_vfs_ioctl
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/ioctl.c:8=
23)=20
[ 2129.849606] __arm64_sys_ioctl
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/ioctl.c:8=
69
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/ioctl.c:856
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/fs/ioctl.c:85=
6)=20
[ 2129.850630] invoke_syscall.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:38
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/ke=
rnel/syscall.c:52)=20
[ 2129.851866] el0_svc_common.constprop.0
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:158)=20
[ 2129.853118] do_el0_svc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/syscall.c:182)=20
[ 2129.853969] el0_svc
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry-common.c:133
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/ke=
rnel/entry-common.c:142
/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/ke=
rnel/entry-common.c:617)=20
[ 2129.854850] el0t_64_sync_handler
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry-common.c:635)=20
[ 2129.855950] el0t_64_sync
(/mnt/tests/kernel/distribution/upstream-kernel/install/kernel/arch/arm64/k=
ernel/entry.S:581)=20
[ 2129.856898] Code: 91002260 d343fc02 38e16841 35000b41 (f9400660)
All code
=3D=3D=3D=3D=3D=3D=3D=3D
   0:   91002260        add     x0, x19, #0x8
   4:   d343fc02        lsr     x2, x0, #3
   8:   38e16841        ldrsb   w1, [x2, x1]
   c:   35000b41        cbnz    w1, 0x174
  10:*  f9400660        ldr     x0, [x19, #8]           <-- trapping
instruction

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:   f9400660        ldr     x0, [x19, #8]
[ 2129.858468] SMP: stopping secondary CPUs
[ 2129.862796] Starting crashdump kernel...
[ 2129.863839] Bye!

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
