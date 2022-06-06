Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5901C433EF
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 22:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiFFWNU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 18:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiFFWNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 18:13:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 945826D4C4
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 15:13:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F25EB81BEE
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 22:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA22AC341CA
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 22:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654553594;
        bh=U0XenELfgc0Hegxyjb7Oy2FQEC/sF+tKbU7lYYXxIJM=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=igr5mGAei9paW6EU/wgt6AJeHWtwXoS1jZvG2di9SQmilp704uASRmrkxHDvnaZIQ
         LKq0fvJpX/HRS5MJHPPAPBD5qobQFfCYFQejyO0sJRbyi1L+IoXPZ48WdcEjBVrZGT
         P2yqRaYWv7LblnflhdhuKi6xieqD1N//qcCRrmtrx1P/oRmGqbnw2Gww9ex2F7Z7al
         +9T6O7CZeGQBe3DJ014LuxAekSwfcilxCN88dRUhCAcHJispJE8UPBmBigjpKAN2lR
         3tlpzjMpnOTHGjNolh37Ort6r+kEH6HaPx430iKcOj3Ku68qDSvLMl15cQmZ9b17FB
         IV5xak940EKqw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id C0DA5C05FD4; Mon,  6 Jun 2022 22:13:14 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Mon, 06 Jun 2022 22:13:14 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: akpm@linux-foundation.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-bZMTj6K6Vb@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216073-201763@https.bugzilla.kernel.org/>
References: <bug-216073-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216073

--- Comment #3 from Andrew Morton (akpm@linux-foundation.org) ---
(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sun, 05 Jun 2022 01:00:15 +0000 bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=3D216073
>=20
>             Bug ID: 216073
>            Summary: [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
>                     Kernel memory exposure attempt detected from vmalloc
>                     'n  o area' (offset 0, size 1)!
>            Product: Memory Management
>            Version: 2.5
>     Kernel Version: 5.19-rc0
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: akpm@linux-foundation.org
>           Reporter: zlang@redhat.com
>         Regression: No
>=20
> Recently xfstests on s390x always hit below kernel BUG:
>  usercopy: Kernel memory exposure attempt detected from vmalloc 'no area'
> (offset 0, size 1)!

Thanks.  Do you know if this is specific to s390?


> It's reproducible on xfs with default mkfs options. But it's easier and 1=
00%
> reproducible (for me) on xfs with 64k directory block size (-n size=3D655=
36).
>=20
> The kernel HEAD commit is:
> commit 032dcf09e2bf7c822be25b4abef7a6c913870d98
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Fri Jun 3 20:01:25 2022 -0700
>=20
>     Merge tag 'gpio-fixes-for-v5.19-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux
>=20
>=20
> [20797.425894] XFS (loop1): Mounting V5 Filesystem=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20797.433354] XFS (loop1): Ending clean mount=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.669300] usercopy: Kernel memory exposure attempt detected from vma=
lloc
> 'n=20
> o area' (offset 0, size 1)!=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20
> [20823.669339] ------------[ cut here ]------------=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.669340] kernel BUG at mm/usercopy.c:101!=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.669385] monitor event: 0040 ilc:2 [#1] SMP=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.669415] Modules linked in: ext2 overlay dm_zero dm_log_writes
> dm_thin_poo=20
> l dm_persistent_data dm_bio_prison sd_mod t10_pi crc64_rocksoft_generic
> crc64_ro=20
> cksoft crc64 sg dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey tls loop=
 lcs
> ct=20
> cm fsm zfcp scsi_transport_fc dasd_fba_mod rfkill sunrpc vfio_ccw mdev
> vfio_iomm=20
> u_type1 zcrypt_cex4 vfio drm fuse i2c_core fb font
> drm_panel_orientation_quirks=20
> xfs libcrc32c ghash_s390 prng aes_s390 des_s390 sha3_512_s390 sha3_256_s3=
90
> dasd=20
> _eckd_mod dasd_mod qeth_l2 bridge stp llc qeth qdio ccwgroup dm_mirror
> dm_region=20
> _hash dm_log dm_mod pkey zcrypt [last unloaded: scsi_debug]=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.669520] CPU: 0 PID: 3774731 Comm: rm Kdump: loaded Tainted: G    B=
   W=20
>       5.18.0+ #1=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.669530] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672501] Krnl PSW : 0704d00180000000 000000009df4a85a
> (usercopy_abort+0xaa=20
> /0xb0)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672564]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 P=
M:0
> RI:=20
> 0 EA:3=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672575] Krnl GPRS: 0000000000000001 001c000018090e00 0000000000000=
05c
> 000=20
> 0000000000004=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672584]            001c000000000000 000000009d332024 000000009e14b=
1a0
> 001=20
> bff8000000000=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672593]            0000000000000001 0000000000000001 0000000000000=
000
> 000=20
> 000009e14b1e0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672601]            000000009e70d070 00000000a87bdac0 000000009df4a=
856
> 001=20
> bff8001f5f720=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672621] Krnl Code: 000000009df4a84c: b9040031            lgr=20=20=
=20=20
> %r3,%r1=20
> [20823.672621]            000000009df4a850: c0e5ffffbbfc        brasl=20=
=20
> %r14,000=20
> 000009df42048=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672621]           #000000009df4a856: af000000            mc      0=
,0=20=20=20
> [20823.672621]           >000000009df4a85a: 0707                bcr     0=
,%r7=20
> [20823.672621]            000000009df4a85c: 0707                bcr     0=
,%r7=20
> [20823.672621]            000000009df4a85e: 0707                bcr     0=
,%r7=20
> [20823.672621]            000000009df4a860: c0040007b0a4        brcl=20=
=20=20
> 0,000000=20
> 009e0409a8=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672621]            000000009df4a866: eb6ff0480024        stmg=20=
=20=20
> %r6,%r15=20
> ,72(%r15)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672789] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672794]  [<000000009df4a85a>] usercopy_abort+0xaa/0xb0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672817] ([<000000009df4a856>] usercopy_abort+0xa6/0xb0)=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672825]  [<000000009cd30c34>] check_heap_object+0x474/0x480=20=20=
=20=20=20=20=20=20=20=20=20=20
> [20823.672833]  [<000000009cd30cb4>] __check_object_size+0x74/0x150=20=20=
=20=20=20=20=20=20=20=20=20
> [20823.672840]  [<000000009cd8de06>] filldir64+0x296/0x530=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.672849]  [<001bffff805957dc>] xfs_dir2_leaf_getdents+0x40c/0xca0 [=
xfs]=20
> [20823.673277]  [<001bffff80596e18>] xfs_readdir+0x3f8/0x740 [xfs]=20=20=
=20=20=20=20=20=20=20=20=20=20
> [20823.673522]  [<000000009cd8c7ac>] iterate_dir+0x41c/0x580=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.673529]  [<000000009cd8d6b4>] __do_sys_getdents64+0xc4/0x1c0=20=20=
=20=20=20=20=20=20=20=20=20
> [20823.673537]  [<000000009c4bda8c>] do_syscall+0x22c/0x330=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.673546]  [<000000009df5e8be>] __do_syscall+0xce/0xf0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.673554]  [<000000009df87402>] system_call+0x82/0xb0=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.673563] INFO: lockdep is turned off.=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.673568] Last Breaking-Event-Address:=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.673572]  [<000000009df420f4>] _printk+0xac/0xb8=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20823.673581] ---[ end trace 0000000000000000 ]---=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.875273] usercopy: Kernel memory exposure attempt detected from vma=
lloc
> 'n=20
> o area' (offset 0, size 1)!=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20
> [20829.875316] ------------[ cut here ]------------=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.875318] kernel BUG at mm/usercopy.c:101!=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.875448] monitor event: 0040 ilc:2 [#2] SMP=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.875468] Modules linked in: ext2 overlay dm_zero dm_log_writes
> dm_thin_poo=20
> l dm_persistent_data dm_bio_prison sd_mod t10_pi crc64_rocksoft_generic
> crc64_r=20
> cksoft crc64 sg dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey tls loop=
 lcs
> ct=20
> cm fsm zfcp scsi_transport_fc dasd_fba_mod rfkill sunrpc vfio_ccw mdev
> vfio_iomm=20
> u_type1 zcrypt_cex4 vfio drm fuse i2c_core fb font
> drm_panel_orientation_quirks=20
> xfs libcrc32c ghash_s390 prng aes_s390 des_s390 sha3_512_s390 sha3_256_s3=
90
> dasd=20
> _eckd_mod dasd_mod qeth_l2 bridge stp llc qeth qdio ccwgroup dm_mirror
> dm_region=20
> _hash dm_log dm_mod pkey zcrypt [last unloaded: scsi_debug]=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.875616] CPU: 0 PID: 3776251 Comm: find Kdump: loaded Tainted: G   =
 B D
> W=20
>         5.18.0+ #1=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.875629] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879533] Krnl PSW : 0704d00180000000 000000009df4a85a
> (usercopy_abort+0xaa=20
> /0xb0)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879554]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 P=
M:0
> RI:=20
> 0 EA:3=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879573] Krnl GPRS: 0000000000000001 001c000018090e00 0000000000000=
05c
> 000=20
> 0000000000004=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879578]            001c000000000000 000000009d332024 000000009e14b=
1a0
> 001=20
> bff8000000000=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879583]            0000000000000001 0000000000000001 0000000000000=
000
> 000=20
> 000009e14b1e0=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879587]            000000009e70d070 00000000a21852c0 000000009df4a=
856
> 001=20
> bff8004fef728=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879599] Krnl Code: 000000009df4a84c: b9040031            lgr=20=20=
=20=20
> %r3,%r1=20
> [20829.879599]            000000009df4a850: c0e5ffffbbfc        brasl=20=
=20
> %r14,000=20
> 000009df42048=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879599]           #000000009df4a856: af000000            mc      0=
,0=20=20=20
> [20829.879599]           >000000009df4a85a: 0707                bcr     0=
,%r7=20
> [20829.879599]            000000009df4a85c: 0707                bcr     0=
,%r7=20
> [20829.879599]            000000009df4a85e: 0707                bcr     0=
,%r7=20
> [20829.879599]            000000009df4a860: c0040007b0a4        brcl=20=
=20=20
> 0,000000=20
> 009e0409a8=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879599]            000000009df4a866: eb6ff0480024        stmg=20=
=20=20
> %r6,%r15=20
> ,72(%r15)=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879631] Call Trace:=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879634]  [<000000009df4a85a>] usercopy_abort+0xaa/0xb0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879639] ([<000000009df4a856>] usercopy_abort+0xa6/0xb0)=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879644]  [<000000009cd30c34>] check_heap_object+0x474/0x480=20=20=
=20=20=20=20=20=20=20=20=20=20
> [20829.879650]  [<000000009cd30cb4>] __check_object_size+0x74/0x150=20=20=
=20=20=20=20=20=20=20=20=20
> [20829.879654]  [<000000009cd8de06>] filldir64+0x296/0x530=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.879661]  [<001bffff805957dc>] xfs_dir2_leaf_getdents+0x40c/0xca0 [=
xfs]=20
> [20829.879971]  [<001bffff80596e18>] xfs_readdir+0x3f8/0x740 [xfs]=20=20=
=20=20=20=20=20=20=20=20=20=20
> [20829.880107]  [<000000009cd8c7ac>] iterate_dir+0x41c/0x580=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.880112]  [<000000009cd8d6b4>] __do_sys_getdents64+0xc4/0x1c0=20=20=
=20=20=20=20=20=20=20=20=20
> [20829.880117]  [<000000009c4bda8c>] do_syscall+0x22c/0x330=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.880124]  [<000000009df5e8be>] __do_syscall+0xce/0xf0=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.880129]  [<000000009df87402>] system_call+0x82/0xb0=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.880135] INFO: lockdep is turned off.=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.880138] Last Breaking-Event-Address:=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.880141]  [<000000009df420f4>] _printk+0xac/0xb8=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.880148] ---[ end trace 0000000000000000 ]---=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20
> [20829.975537] XFS (loop0): Unmounting Filesystem
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are the assignee for the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
