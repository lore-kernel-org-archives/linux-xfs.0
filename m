Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9E9C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 23:05:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240765AbiETXFc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 May 2022 19:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiETXFa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 May 2022 19:05:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710E9190D21
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 16:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3216CB82E19
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 23:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE7F7C34117
        for <linux-xfs@vger.kernel.org>; Fri, 20 May 2022 23:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653087926;
        bh=h5eBAYwNiVyTZAQiUhCCQS1R0xMyiuXlZgt1yIjiCQE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=U3Vp1lM37ObO3dPeNR3GAheo5vuXYYZtoQTJ6ZY1WgrbOE0x0PzbNSp63hph1u/Jy
         NCVOU7cSZmoJuslHB9Thx369KUW4RzK8qQLCa+0Gh3b6zFJxXYJaINyAmWe4ZriJf3
         oZXMwmINwUwdyNdHavk3emSh2fbbF3ow7KP2bN5Iff1OE5ZBVlWWa4W8+HpsLYtyVh
         SipXXSgMzX5fRrzZ1bCI5WnzJV26GE09Iyd6mfCnU7bNWISVAhM64IR2VhdoKb2Jh3
         44U0iX4vSylyYCL88NCTKtXJX7BxxAizSlrWh+8LQvWcFL0BEowYSyeweIYi0f0p5n
         9J85QE80ytuhg==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id CD99ACC13B0; Fri, 20 May 2022 23:05:26 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 216007] XFS hangs in iowait when extracting large number of
 files
Date:   Fri, 20 May 2022 23:05:26 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: david@fromorbit.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-216007-201763-kKQKjnHvn2@https.bugzilla.kernel.org/>
In-Reply-To: <bug-216007-201763@https.bugzilla.kernel.org/>
References: <bug-216007-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D216007

--- Comment #3 from Dave Chinner (david@fromorbit.com) ---
On Fri, May 20, 2022 at 11:56:06AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D216007
>=20
>             Bug ID: 216007
>            Summary: XFS hangs in iowait when extracting large number of
>                     files
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.15.32
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: bugzkernelorg8392@araxon.sk
>         Regression: No
>=20
> Created attachment 301008
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D301008&action=3Dedit
> output from dmesg after echo w > /proc/sysrq-trigger
>=20
> Overview:
>=20
> When I try to extract an uncompressed tar archive (2.6 milion files, 760.3
> GiB
> in size) on newly created (empty) XFS file system, after first low tens of
> gigabytes extracted the process hangs in iowait indefinitely. One CPU cor=
e is
> 100% occupied with iowait, the other CPU core is idle (on 2-core Intel
> Celeron
> G1610T).
>=20
> I have kernel compiled with my .config file. When I try this with a more
> "standard" kernel, the problem is not reproducible.
>=20
> Steps to Reproduce:
>=20
> 1) compile the kernel with the attached .config
>=20
> 2) reboot with this kernel
>=20
> 3) create a new XFS filesystem on a spare drive (just mkfs.xfs -f <dev>)
>=20
> 4) mount this new file system
>=20
> 5) try to extract large amount of data there
>=20
> Actual results:
>=20
> After 20-40 GiB written, the process hangs in iowait indefinitely, never
> finishing the archive extraction.

[  805.233836] task:tar             state:D stack:    0 pid: 2492 ppid:  24=
91
flags:0x00004000
[  805.233840] Call Trace:
[  805.233841]  <TASK>
[  805.233842]  __schedule+0x1c9/0x510
[  805.233846]  ? lock_timer_base+0x5c/0x80
[  805.233850]  schedule+0x3f/0xa0
[  805.233853]  schedule_timeout+0x7c/0xf0
[  805.233858]  ? init_timer_key+0x30/0x30
[  805.233862]  io_schedule_timeout+0x47/0x70
[  805.233866]  congestion_wait+0x79/0xd0
[  805.233872]  ? wait_woken+0x60/0x60
[  805.233876]  xfs_buf_alloc_pages+0xd0/0x1b0
[  805.233881]  xfs_buf_get_map+0x259/0x300
[  805.233886]  ? xfs_buf_item_init+0x150/0x160
[  805.233892]  xfs_trans_get_buf_map+0xa9/0x120
[  805.233897]  xfs_ialloc_inode_init+0x129/0x2d0
[  805.233901]  ? xfs_ialloc_ag_alloc+0x1df/0x630
[  805.233904]  xfs_ialloc_ag_alloc+0x1df/0x630
[  805.233908]  xfs_dialloc+0x1b4/0x720
[  805.233912]  xfs_create+0x1d7/0x450
[  805.233917]  xfs_generic_create+0x114/0x2d0
[  805.233922]  path_openat+0x510/0xe10
[  805.233925]  do_filp_open+0xad/0x150
[  805.233929]  ? xfs_blockgc_clear_iflag+0x93/0xb0
[  805.233932]  ? xfs_iunlock+0x52/0x90
[  805.233937]  do_sys_openat2+0x91/0x150
[  805.233942]  __x64_sys_openat+0x4e/0x90
[  805.233946]  do_syscall_64+0x43/0x90
[  805.233952]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  805.233959] RIP: 0033:0x7f763ccc9572
[  805.233962] RSP: 002b:00007ffef1391530 EFLAGS: 00000246 ORIG_RAX:
0000000000000101
[  805.233966] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007f763ccc9572
[  805.233969] RDX: 00000000000809c1 RSI: 000055b1d5b19270 RDI:
0000000000000004
[  805.233971] RBP: 0000000000000180 R08: 000000000000c0c0 R09:
000055b1d5b145f0
[  805.233973] R10: 0000000000000180 R11: 0000000000000246 R12:
0000000000000000
[  805.233974] R13: 00000000000809c1 R14: 000055b1d5b19270 R15:
000055b1d59d2248
[  805.233977]  </TASK>

It's waiting on memory allocation, which is probably waiting on IO
completion somewhere to clean dirty pages. This suggests there's a
problem with the storage hardware, the storage stack below XFS or
there's an issue with memory cleaning/reclaim stalling and not
making progress.

> Expected Results:
>=20
> Archive extraction continues smoothly until done.
>=20
> Build Date & Hardware:
>=20
> 2022-05-01 on HP ProLiant MicroServer Gen8, 4GB ECC RAM
>=20
> Additional Information:
>=20
> No other filesystem tested with the same archive on the same hardware bef=
ore
> or
> after this (ext2, ext3, ext4, reiserfs3, jfs, nilfs2, f2fs, btrfs, zfs) h=
as
> shown this behavior. When I downgraded the kernel to 5.10.109, the XFS
> started
> working again. Kernel versions higher than 5.15 seem to be affected, I tr=
ied
> 5.17.1, 5.17.6 and 5.18.0-rc7, they all hang up after a few minutes.

Doesn't actually look like an XFS problem from the evidence
supplied, though.

What sort of storage subsystem does this machine have? If it's a
spinning disk then you've probably just filled memory=20

> More could be found here: https://forums.gentoo.org/viewtopic-p-8709116.h=
tml

Oh, wait:

"I compiled a more mainstream version of
sys-kernel/gentoo-sources-5.15.32-r1 (removed my .config file and
let genkernel to fill it with default options) and lo and behold, in
this kernel I could not make it go stuck anymore.
[....]
However, after I altered my old kernel config to contain these
values and rebooting, I'm still triggering the bug. It may not be a
XFS issue after all."

From the evidence presented, I'd agree that this doesn't look an
XFS problem, either.

Cheers,

Dave.

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
