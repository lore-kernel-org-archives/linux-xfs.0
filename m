Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4745C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 06:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbiEEG1D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 02:27:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244278AbiEEG1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 02:27:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62222FE53
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 23:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6667661CD0
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6139C385B3
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651731801;
        bh=wDIx8J4kIhJmHlZCqV/1LRA7/l8Wl7E7JOuVwRQ/4RQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=aY2FpyHnybuGcwK0KFtyHtE8JjXFlnoeWXRJN7aTHqmK7+r/Gnap1+Pn3KzrgWQWW
         ooRS4jPJngDfeZ7iYzDgYom1H7hGtpZWzB9coIa2cd6sD6ebOU/VsHB+ZO6/DS4sAo
         2MAsNlIyRFxNXH/xpFWYo7JNrSiMRblEaK2MhDeMQyQBes9J/gPBIz4msbkctp51Mr
         3wyrRCMnqQw8IO1DI5fFGuZTDngu2WPuV1XEJiSmipV+pxeN1jnxZlZIdp6Ak6DLV/
         jAdyesa8q3SZgwaOZlBzqgycEDWTWWdhNO7XfKmZQs5Ddfpt8TwWK1+qe7LTuBtFNc
         ZrIoDB31p7qsA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id B3B83C05FF5; Thu,  5 May 2022 06:23:21 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215922] KASAN: null-ptr-deref in range
 [0x0000000000000000-0x0000000000000007]
Date:   Thu, 05 May 2022 06:23:21 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: djwong@kernel.org
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-215922-201763-rcZxscDBVZ@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215922-201763@https.bugzilla.kernel.org/>
References: <bug-215922-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215922

--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
If you are going to run some scripted tool to randomly
corrupt the filesystem to find failures, then you have an
ethical and moral responsibility to do some of the work to
narrow down and identify the cause of the failure, not just
throw them at someone to do all the work.

--D

On Sat, Apr 30, 2022 at 08:08:38AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215922
>=20
>             Bug ID: 215922
>            Summary: KASAN: null-ptr-deref in range
>                     [0x0000000000000000-0x0000000000000007]
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.17
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: yanming@tju.edu.cn
>         Regression: No
>=20
> Created attachment 300859
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D300859&action=3Dedit
> case.c, which contains the related file operations.
>=20
> I've encountered an issue when using XFS file system in kernel 5.17.
>=20
> When I tried to run some file operations, a segmentation fault occurred, =
and
> I
> failed to umount the XFS image.
>=20
> The related file operations are listed in case.c, and I have uploaded the=
 XFS
> image on the google net disk
>
> (https://drive.google.com/file/d/1RJMr1AKtLtev8dinHBawWa7tTvHEytr3/view?u=
sp=3Dsharing).
>=20
> The kernel should be configured with CONFIG_KASAN=3Dy and
> CONFIG_KASAN_INLINE=3Dy.
> You can reproduce this issue by running the following commands:
>=20
> gcc -o case case.c
> losetup /dev/loop0 case.img
> mount -o
> "allocsize=3D4096,attr2,discard,nogrpid,filestreams,noikeep,noalign,wsync"
> /dev/loop0 /mnt/test/
> ./case
>=20
> The kernel outputted the following messages:
>=20
> 1,1310,83736925,-;KASAN: null-ptr-deref in range
> [0x0000000000000000-0x0000000000000007]
> 4,1311,83736935,-;CPU: 6 PID: 1099 Comm: case Not tainted 5.17.0 #7
> 4,1312,83736943,-;Hardware name: Dell Inc. OptiPlex 9020/03CPWF, BIOS A14
> 09/14/2015
> 4,1313,83736951,-;RIP: 0010:xfs_dir_isempty+0xfe/0x240
> 4,1314,83736962,-;Code: 48 8d 7b 60 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 8=
5 38
> 01 00 00 48 b8 00 00 00 00 00 fc ff df 48 8b 5b 60 48 89 da 48 c1 ea 03 <=
0f>
> b6
> 04 02 48 89 da 83 e2 07 38 d0 7f 08 84 c0 0f 85 17 01 00 00
> 4,1315,83736977,-;RSP: 0018:ffff88810300fca0 EFLAGS: 00010246
> 4,1316,83736986,-;RAX: dffffc0000000000 RBX: 0000000000000000 RCX:
> 1ffff11022dc4450
> 4,1317,83736995,-;RDX: 0000000000000000 RSI: 0000000000000008 RDI:
> ffff888151cb84a0
> 4,1318,83737003,-;RBP: 00000000000000eb R08: 0000000000000000 R09:
> ffffed102a394829
> 4,1319,83737011,-;R10: ffff888151ca4147 R11: ffffed102a394828 R12:
> ffff888116e22000
> 4,1320,83737020,-;R13: 1ffff11020601f9d R14: ffff88810300fda8 R15:
> 0000000000004000
> 4,1321,83737028,-;FS:  00007f1c7b968540(0000) GS:ffff8881cff80000(0000)
> knlGS:0000000000000000
> 4,1322,83737039,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 4,1323,83737046,-;CR2: 00007f1c7b88d750 CR3: 0000000113980001 CR4:
> 00000000001706e0
> 4,1324,83737055,-;Call Trace:
> 4,1325,83737060,-; <TASK>
> 4,1326,83737065,-; xfs_remove+0x5f0/0x890
> 4,1327,83737074,-; ? try_to_take_rt_mutex+0x3bd/0xb70
> 4,1328,83737083,-; ? xfs_iunpin_wait+0x3c0/0x3c0
> 4,1329,83737091,-; ? may_link+0x2af/0x380
> 4,1330,83737099,-; ? selinux_inode_rename+0x770/0x770
> 4,1331,83737108,-; xfs_vn_unlink+0xf3/0x200
> 4,1332,83737116,-; ? xfs_vn_rename+0x400/0x400
> 4,1333,83737125,-; ? security_inode_rmdir+0x95/0xe0
> 4,1334,83737133,-; vfs_rmdir+0x219/0x560
> 4,1335,83737142,-; ? __lookup_hash+0x1b/0x150
> 4,1336,83737151,-; do_rmdir+0x246/0x300
> 4,1337,83737159,-; ? __x64_sys_mkdir+0x70/0x70
> 4,1338,83737166,-; ? kasan_unpoison+0x23/0x50
> 4,1339,83737175,-; ? kmem_cache_alloc+0x10f/0x220
> 4,1340,83737184,-; ? getname_flags+0xf8/0x4e0
> 4,1341,83737193,-; __x64_sys_rmdir+0x39/0x50
> 4,1342,83737201,-; do_syscall_64+0x3b/0x90
> 4,1343,83737209,-; entry_SYSCALL_64_after_hwframe+0x44/0xae
> 4,1344,83737219,-;RIP: 0033:0x7f1c7b88d76d
> 4,1345,83737226,-;Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e f=
a 48
> 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <=
48>
> 3d
> 01 f0 ff ff 73 01 c3 48 8b 0d f3 36 0d 00 f7 d8 64 89 01 48
> 4,1346,83737241,-;RSP: 002b:00007ffe5f49b288 EFLAGS: 00000286 ORIG_RAX:
> 0000000000000054
> 4,1347,83737252,-;RAX: ffffffffffffffda RBX: 000055a1f772e600 RCX:
> 00007f1c7b88d76d
> 4,1348,83737260,-;RDX: ffffffffffffff80 RSI: ffffffffffffff80 RDI:
> 00007ffe5f49b2b6
> 4,1349,83737268,-;RBP: 00007ffe5f89b400 R08: 00007ffe5f89b4f8 R09:
> 00007ffe5f89b4f8
> 4,1350,83737276,-;R10: 00007ffe5f89b4f8 R11: 0000000000000286 R12:
> 000055a1f772e0a0
> 4,1351,83737284,-;R13: 00007ffe5f89b4f0 R14: 0000000000000000 R15:
> 0000000000000000
> 4,1352,83737294,-; </TASK>
> 4,1353,83737299,-;Modules linked in: x86_pkg_temp_thermal efivarfs
> 4,1354,83737331,-;---[ end trace 0000000000000000 ]---
>=20
> --=20
> You may reply to this email to add a comment.
>=20
> You are receiving this mail because:
> You are watching the assignee of the bug.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
