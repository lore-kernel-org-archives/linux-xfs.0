Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751C3C433EF
	for <linux-xfs@archiver.kernel.org>; Sun,  5 Jun 2022 05:32:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349073AbiFEFca (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 5 Jun 2022 01:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiFEFc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 5 Jun 2022 01:32:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498EB41F97
        for <linux-xfs@vger.kernel.org>; Sat,  4 Jun 2022 22:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 60B6DCE0944
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 05:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A6A76C341CA
        for <linux-xfs@vger.kernel.org>; Sun,  5 Jun 2022 05:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654407142;
        bh=ymETfsZuY0v7ePbLjVv2224E18K1HyaudcR2Gp8u2Bo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=l2izg24KqH1SjttFjsiIB5L2721yNAiKspjLgaJGSiMlLlb//Z6wRiCQitHIZQTyy
         UmzxVjZxPLq3+wI1OcNN2zMQvM6OWiiZsFHUdGHgHIN+KlNgvz1guHIYYIwU9CZeDA
         1iRCGMGME2w/b5+NaeHaK023F5g6vwdjM+b71mXJ6nExjnuYeVM5XM5YjGmonhCyUc
         ALn7urNxhoFW2d6otnRI0ItzfyMVUIsuyV0DOrHkoiXW8cjG/q6qS5KQZVAS1rH/up
         qcXmnkkCMO+yZh1GIGiXc7VtCVlMcYqhR+vL+uG5MQ1cUgoYjK9vknI/5IE4tNWlRy
         8oy1YFvuhsGSQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 950ADC05FF5; Sun,  5 Jun 2022 05:32:22 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216073] [s390x] kernel BUG at mm/usercopy.c:101! usercopy:
 Kernel memory exposure attempt detected from vmalloc 'n  o area' (offset 0,
 size 1)!
Date:   Sun, 05 Jun 2022 05:32:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: CC filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: Memory Management
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: zlang@redhat.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: akpm@linux-foundation.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216073-201763-aTV8ZfvA20@https.bugzilla.kernel.org/>
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

--- Comment #2 from Zorro Lang (zlang@redhat.com) ---
Default xfs (no specified mkfs options) can reproduce this bug with xfstests
xfs/294. The decode_stacktrace.sh output as below[1], HEAD=3D032dcf09e ("Me=
rge
tag 'gpio-fixes-for-v5.19-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/brgl/linux")

[1]
# ./scripts/decode_stacktrace.sh vmlinux < console.log
[30523.215443] run fstests xfs/294 at 2022-06-05 00:40:48
[30525.371171] XFS (loop1): Mounting V5 Filesystem
[30525.388258] XFS (loop1): Ending clean mount
[30574.012385] restraintd[1854]: *** Current Time: Sun Jun 05 00:41:38 2022=
=20
Loc
alwatchdog at: Mon Jun 06 16:13:37 2022
[30604.239628] usercopy: Kernel memory exposure attempt detected from vmall=
oc
'n
o area' (offset 0, size 1)!
[30604.239677] ------------[ cut here ]------------
[30604.239679] kernel BUG at mm/usercopy.c:101!
[30604.239731] monitor event: 0040 ilc:2 [#1] SMP
[30604.239774] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_poo
l dm_persistent_data dm_bio_prison sd_mod t10_pi crc64_rocksoft_generic
crc64_ro
cksoft crc64 sg dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey tls loop l=
cs
ct
cm fsm zfcp scsi_transport_fc dasd_fba_mod rfkill vfio_ccw mdev
vfio_iommu_type1
zcrypt_cex4 vfio sunrpc drm i2c_core fb fuse font drm_panel_orientation_qui=
rks
xfs libcrc32c ghash_s390 prng aes_s390 des_s390 sha3_512_s390 sha3_256_s390
qeth
_l2 bridge stp llc dasd_eckd_mod dasd_mod qeth qdio ccwgroup dm_mirror
dm_region
_hash dm_log dm_mod pkey zcrypt [last unloaded: scsi_debug]
5.18.0+ #1
[30604.240048] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
[30604.240155] Krnl PSW : 0704d00180000000 00000000255ca85a
(usercopy_abort+0xaa
/0xb0)
[30604.240177]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0
RI:
0 EA:3
[30604.240188] Krnl GPRS: 0000000000000001 001c000018090e00 000000000000005c
000
0000000000004
[30604.240196]            001c000000000000 00000000249b2024 00000000257cb1a0
001
bff8000000000
[30604.240204]            0000000000000001 0000000000000001 0000000000000000
000
00000257cb1e0
[30604.240213]            0000000025d8d070 00000000973502c0 00000000255ca856
001
bff80041af730
[30604.240231] Krnl Code: 00000000255ca84c: b9040031 lgr %r3,%r1

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[30604.240231]            00000000255ca850: c0e5ffffbbfc        brasl=20=20
%r14,000
00000255c2048
[30604.240231]           #00000000255ca856: af000000            mc      0,0
[30604.240231]           >00000000255ca85a: 0707                bcr     0,%=
r7
[30604.240231]            00000000255ca85c: 0707                bcr     0,%=
r7
[30604.240231]            00000000255ca85e: 0707                bcr     0,%=
r7
[30604.240231]            00000000255ca860: c0040007b0a4        brcl=20=20=
=20
0,000000
00256c09a8
[30604.240231]            00000000255ca866: eb6ff0480024        stmg=20=20=
=20
%r6,%r15
,72(%r15)
[30604.240369] Call Trace:
[30604.240375] usercopy_abort (??:?)=20
[30604.240382] usercopy_abort (mm/usercopy.c:101 (discriminator 24))=20
[30604.240400] check_heap_object (mm/usercopy.c:180)=20
[30604.240409] __check_object_size (mm/usercopy.c:123 mm/usercopy.c:255
mm/usercopy.c:214)=20
[30604.240415] filldir64 (./include/linux/uaccess.h:108 fs/readdir.c:339)=20
[30604.240424] xfs_dir2_leaf_getdents (./include/linux/fs.h:3430
fs/xfs/xfs_dir2_readdir.c:472) xfs
[30604.240830] xfs_readdir (fs/xfs/xfs_dir2_readdir.c:547) xfs
[30604.241036] iterate_dir (fs/readdir.c:65)=20
[30604.241042] __do_sys_getdents64 (fs/readdir.c:369)=20
[30604.241047] do_syscall (arch/s390/kernel/syscall.c:144 (discriminator 1)=
)=20
[30604.241053] __do_syscall (arch/s390/kernel/syscall.c:169)=20
[30604.241058] system_call (arch/s390/kernel/entry.S:335)=20
[30604.241064] INFO: lockdep is turned off.
[30604.241067] Last Breaking-Event-Address:
[30604.241070] _printk (kernel/printk/printk.c:2426)=20
[30604.241077] ---[ end trace 0000000000000000 ]---
[30609.984847] usercopy: Kernel memory exposure attempt detected from vmall=
oc
'n
o area' (offset 0, size 1)!
[30609.984894] ------------[ cut here ]------------
[30609.984896] kernel BUG at mm/usercopy.c:101!
[30609.984945] monitor event: 0040 ilc:2 [#2] SMP
[30609.984984] Modules linked in: ext2 overlay dm_zero dm_log_writes
dm_thin_poo
l dm_persistent_data dm_bio_prison sd_mod t10_pi crc64_rocksoft_generic crc=
64_r
cksoft crc64 sg dm_snapshot dm_bufio ext4 mbcache jbd2 dm_flakey tls loop l=
cs
ct
cm fsm zfcp scsi_transport_fc dasd_fba_mod rfkill vfio_ccw mdev
vfio_iommu_type1
zcrypt_cex4 vfio sunrpc drm i2c_core fb fuse font drm_panel_orientation_qui=
rks
xfs libcrc32c ghash_s390 prng aes_s390 des_s390 sha3_512_s390 sha3_256_s390
qeth
_l2 bridge stp llc dasd_eckd_mod dasd_mod qeth qdio ccwgroup dm_mirror
dm_region
_hash dm_log dm_mod pkey zcrypt [last unloaded: scsi_debug]
5.18.0+ #1
[30609.985151] Hardware name: IBM 8561 LT1 400 (z/VM 7.2.0)
[30609.985211] Krnl PSW : 0704d00180000000 00000000255ca85a
(usercopy_abort+0xaa
/0xb0)
[30609.985249]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0
RI:
0 EA:3
[30609.985258] Krnl GPRS: 0000000000000001 001c000018090e00 000000000000005c
000
0000000000004
[30609.985264]            001c000000000000 00000000249b2024 00000000257cb1a0
001
bff8000000000
[30609.985271]            0000000000000001 0000000000000001 0000000000000000
000
00000257cb1e0
[30609.985276]            0000000025d8d070 00000000a2d652c0 00000000255ca856
001
bff800810f668
[30609.985293] Krnl Code: 00000000255ca84c: b9040031 lgr %r3,%r1

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[30609.985293]            00000000255ca850: c0e5ffffbbfc        brasl=20=20
%r14,000
00000255c2048
[30609.985293]           #00000000255ca856: af000000            mc      0,0
[30609.985293]           >00000000255ca85a: 0707                bcr     0,%=
r7
[30609.985293]            00000000255ca85c: 0707                bcr     0,%=
r7
[30609.985293]            00000000255ca85e: 0707                bcr     0,%=
r7
[30609.985293]            00000000255ca860: c0040007b0a4        brcl=20=20=
=20
0,000000
00256c09a8
[30609.985293]            00000000255ca866: eb6ff0480024        stmg=20=20=
=20
%r6,%r15
,72(%r15)
[30609.985340] Call Trace:
[30609.985345] usercopy_abort (??:?)=20
[30609.985352] usercopy_abort (mm/usercopy.c:101 (discriminator 24))=20
[30609.985358] check_heap_object (mm/usercopy.c:180)=20
[30609.985367] __check_object_size (mm/usercopy.c:123 mm/usercopy.c:255
mm/usercopy.c:214)=20
[30609.985374] filldir64 (./include/linux/uaccess.h:108 fs/readdir.c:339)=20
[30609.985383] xfs_dir2_leaf_getdents (./include/linux/fs.h:3430
fs/xfs/xfs_dir2_readdir.c:472) xfs
[30609.985780] xfs_readdir (fs/xfs/xfs_dir2_readdir.c:547) xfs
[30609.986002] iterate_dir (fs/readdir.c:65)=20
[30609.986009] __do_sys_getdents64 (fs/readdir.c:369)=20
[30609.986017] do_syscall (arch/s390/kernel/syscall.c:144 (discriminator 1)=
)=20
[30609.986026] __do_syscall (arch/s390/kernel/syscall.c:169)=20
[30609.986033] system_call (arch/s390/kernel/entry.S:335)=20
[30609.986041] INFO: lockdep is turned off.
[30609.986046] Last Breaking-Event-Address:
[30609.986050] _printk (kernel/printk/printk.c:2426)=20
[30609.986059] ---[ end trace 0000000000000000 ]---
[30610.050449] XFS (loop0): Unmounting Filesystem

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching someone on the CC list of the bug.=
