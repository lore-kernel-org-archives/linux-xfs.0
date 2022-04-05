Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BDBC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Apr 2022 05:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiDEFPK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiDEFPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Apr 2022 01:15:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9190DAC
        for <linux-xfs@vger.kernel.org>; Mon,  4 Apr 2022 22:13:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50F2B614D8
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 05:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5B77C34113
        for <linux-xfs@vger.kernel.org>; Tue,  5 Apr 2022 05:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649135589;
        bh=mkfPGRV/j1RPxV47byWykCkkdolEglCyJi7DMYqqeBc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CwkVQK1mWGjuidfR2idyIYMNoR/UV+8MyOy3vMC6I4fxVS0hO8Mubb8iGOvc4pVrK
         5q8wEUI6zajH7Zit8Bavg5CcFqaClzhium4hmgXz4S2fwQWfX66xISYNB7cwJt8M5F
         dR+ycuPf99A/l6yj8qx42vBQoQtO5hfxLM1ve64eBY4WnpwiwvLfntdB+pp+n8Ltt2
         I5znesdesaXf7jiQAX0WxxLo3Gs9N8NkrfweD54TgJYMKD0twsNMpBmOok9EFmmY45
         TKCuk+NvbKTbcsu2wijAmlIc8UvOMq6z12imUaXz0nQ2rx9ua/C+Qtw3XykTB/GpQt
         8HHWjMDTDjs5Q==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id A3E15C05FCE; Tue,  5 Apr 2022 05:13:09 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215804] [xfstests generic/670] Unable to handle kernel paging
 request at virtual address fffffbffff000008
Date:   Tue, 05 Apr 2022 05:13:09 +0000
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
Message-ID: <bug-215804-201763-GnXdtcIYV5@https.bugzilla.kernel.org/>
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

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
Hmm... another similar panic testing job, triggered by trinity test tool on=
 XFS
(-m reflink=3D1,rmapbt=3D1). It's rmapbt enabled again, and on aarch64 too:

[43380.585988] XFS (vda3): Mounting V5 Filesystem=20
[43380.596159] XFS (vda3): Ending clean mount=20
[43397.622777] futex_wake_op: trinity-c1 tries to shift op by -1; fix this
program=20
[43408.337391] futex_wake_op: trinity-c1 tries to shift op by 525; fix this
program=20
[43434.008520] restraintd[2046]: *** Current Time: Sun Apr 03 18:09:11 2022=
=20
Localwatchdog at: Tue Apr 05 00:08:11 2022=20
[43439.502831] Unable to handle kernel paging request at virtual address
fffffbffff000008=20
[43439.503774] KASAN: maybe wild-memory-access in range
[0x0003dffff8000040-0x0003dffff8000047]=20
[43439.504287] Mem abort info:=20
[43439.504461]   ESR =3D 0x96000006=20
[43439.504651]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits=20
[43439.504978]   SET =3D 0, FnV =3D 0=20
[43439.505168]   EA =3D 0, S1PTW =3D 0=20
[43439.505364]   FSC =3D 0x06: level 2 translation fault=20
[43439.505661] Data abort info:=20
[43439.505842]   ISV =3D 0, ISS =3D 0x00000006=20
[43439.506081]   CM =3D 0, WnR =3D 0=20
[43439.506267] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D000000072e56b0=
00=20
[43439.506672] [fffffbffff000008] pgd=3D000000072fcf1003, p4d=3D000000072fc=
f1003,
pud=3D000000072fcf2003, pmd=3D0000000000000000=20
[43439.507533] Internal error: Oops: 96000006 [#1] SMP=20
[43439.507845] Modules linked in: can_isotp 8021q garp mrp bridge stp llc
vsock_loopback vmw_vsock_virtio_transport_common vsock af_key mpls_router
ip_tunnel qrtr can_bcm can_raw can pptp gre l2tp_ppp l2tp_netlink l2tp_core
pppoe pppox ppp_generic slhc crypto_user ib_core nfnetlink scsi_transport_i=
scsi
atm sctp ip6_udp_tunnel udp_tunnel tls rfkill sunrpc vfat fat drm fuse xfs
libcrc32c crct10dif_ce ghash_ce sha2_ce sha256_arm64 virtio_console virtio_=
blk
sha1_ce virtio_net net_failover failover virtio_mmio=20
[43439.510640] CPU: 6 PID: 518132 Comm: trinity-c3 Kdump: loaded Not tainted
5.17.0+ #1=20
[43439.511121] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/20=
15=20
[43439.511551] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)=20
[43439.511984] pc : __split_huge_pmd+0x1d8/0x34c=20
[43439.512265] lr : __split_huge_pmd+0x174/0x34c=20
[43439.512540] sp : ffff80000e267140=20
[43439.512750] x29: ffff80000e267140 x28: 0000000000000000 x27:
ffff000148b01780=20
[43439.513208] x26: 0000000000000000 x25: 0000000000000000 x24:
fffffc0005828700=20
[43439.513655] x23: 1ffff00001c4ce36 x22: ffff0000d7bb0108 x21:
ffff000116c94220=20
[43439.514103] x20: ffff80000e2671e0 x19: fffffbffff000000 x18:
1ffff00001c4cd43=20
[43439.514551] x17: 8f0100002d0e0000 x16: ffffb2d9f2347da0 x15:
0000000000000000=20
[43439.514999] x14: 0000000000000000 x13: 0000000000000000 x12:
ffff700001c4ce19=20
[43439.515449] x11: 1ffff00001c4ce18 x10: ffff700001c4ce18 x9 :
dfff800000000000=20
[43439.515897] x8 : ffff80000e2670c3 x7 : 0000000000000001 x6 :
0000000000000003=20
[43439.516346] x5 : ffff80000e2670c0 x4 : ffff700001c4ce18 x3 :
1fffe0019b499e01=20
[43439.516796] x2 : 1fffff7fffe00001 x1 : 0000000000000000 x0 :
fffffbffff000008=20
[43439.517244] Call trace:=20
[43439.517400]  __split_huge_pmd+0x1d8/0x34c=20
[43439.517655]  split_huge_pmd_address+0x10c/0x1a0=20
[43439.517943]  try_to_unmap_one+0xb64/0x125c=20
[43439.518206]  rmap_walk_file+0x1dc/0x4b0=20
[43439.518450]  try_to_unmap+0x134/0x16c=20
[43439.518695]  split_huge_page_to_list+0x5ec/0xcbc=20
[43439.518987]  truncate_inode_partial_folio+0x194/0x2ec=20
[43439.519307]  truncate_inode_pages_range+0x2e8/0x870=20
[43439.519615]  truncate_pagecache+0x6c/0xa0=20
[43439.519869]  truncate_setsize+0x50/0x90=20
[43439.520111]  xfs_setattr_size+0x280/0x93c [xfs]=20
[43439.520545]  xfs_vn_setattr_size+0xd4/0x124 [xfs]=20
[43439.520979]  xfs_vn_setattr+0x100/0x24c [xfs]=20
[43439.521390]  notify_change+0x720/0xbf0=20
[43439.521630]  do_truncate+0xf4/0x194=20
[43439.521854]  do_sys_ftruncate+0x1d8/0x2b4=20
[43439.522109]  __arm64_sys_ftruncate+0x58/0x7c=20
[43439.522380]  invoke_syscall.constprop.0+0x74/0x1e0=20
[43439.522685]  el0_svc_common.constprop.0+0x224/0x2c0=20
[43439.522993]  do_el0_svc+0xa4/0xf0=20
[43439.523212]  el0_svc+0x5c/0x160=20
[43439.523415]  el0t_64_sync_handler+0x9c/0x120=20
[43439.523684]  el0t_64_sync+0x174/0x178=20
[43439.523920] Code: 91002260 d343fc02 38e16841 35000b41 (f9400660)=20=20
[43439.524304] SMP: stopping secondary CPUs=20
[43439.525427] Starting crashdump kernel...=20
[43439.525668] Bye!=20
[    0.000000] Booting Linux on physical CPU 0x0000000006 [0x413fd0c1]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
