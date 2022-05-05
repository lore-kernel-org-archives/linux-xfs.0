Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2690C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 06:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244257AbiEEG1Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 02:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238683AbiEEG1P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 02:27:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A692FE53
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 23:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50EE361949
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3056C385B3
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651731815;
        bh=l6bmBRZLn2PnF+F1BmlWlT5/IMNmumKDbG+4o+l2mEE=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=pu3yxXlcizrB4SUJpz+A993kBsFL/wrmYsCmf9dWtpGo8MTJ1Ya2TG6Sds2lIpHg7
         BCnteehy+G/RAYwcyQC8fgZOByRp83I6nNyrdMC601DYEj5F3yW+yvoddnBZT4T3fO
         bYc0hpnP++QPSK1umqfX6h5YVyq1ZgYklA47w5w6muu7tOx9tPR+agXSjFfarvroUQ
         4hZupv+X2q1ETt2MQWIqwTmIVWcE2x2D3KsCyiu9RwN9vyEvQfNIY19Fi3yi5KKQxB
         rn3JcIoLCFdLC15Go8tyFOmfll/zU4T0JDP+oDVMkaH+n21y4q2YQPIArNXUEJ/MVK
         gFl5aKU4IpMGw==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 9CA0CC05FCE; Thu,  5 May 2022 06:23:35 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215921] kernel BUG at fs/xfs/xfs_message.c:110!
Date:   Thu, 05 May 2022 06:23:35 +0000
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
Message-ID: <bug-215921-201763-70tOwUHKOy@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215921-201763@https.bugzilla.kernel.org/>
References: <bug-215921-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215921

--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
If you are going to run some scripted tool to randomly
corrupt the filesystem to find failures, then you have an
ethical and moral responsibility to do some of the work to
narrow down and identify the cause of the failure, not just
throw them at someone to do all the work.

--D

On Sat, Apr 30, 2022 at 07:17:27AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215921
>=20
>             Bug ID: 215921
>            Summary: kernel BUG at fs/xfs/xfs_message.c:110!
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
> Created attachment 300858
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D300858&action=3Dedit
> case.c, contains file operations to reproduce the bug
>=20
> I have encountered a XFS bug in the kernel v5.17.
>=20
> I have uploaded the system call sequence as case.c, and a modified image =
can
> be
> found on google net disk
>
> (https://drive.google.com/file/d/1EzzOv74RIXjRdjMD1emDYN3241goinlp/view?u=
sp=3Dsharing).
> You can reproduce this bug by running the following commands:
>=20
> gcc -o case case.c
> losetup /dev/loop0 case.img
> mount -o
> "allocsize=3D4096,attr2,discard,nogrpid,filestreams,noikeep,noalign,wsync"
> /dev/loop0 /mnt/test/
> ./case
>=20
> The kernel crash log is shown below:
>=20
> 4,918,9602591861,-;XFS (loop0): correcting sb_features alignment problem
> 0,919,9602592537,-;XFS: Assertion failed: mp->m_sb.sb_versionnum &
> XFS_SB_VERSION_DIRV2BIT, file: fs/xfs/libxfs/xfs_dir2.c, line: 99
> 4,920,9602592552,-;------------[ cut here ]------------
> 2,921,9602592553,-;kernel BUG at fs/xfs/xfs_message.c:110!
> 4,922,9602592559,-;invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
> 4,923,9602592564,-;CPU: 7 PID: 2786 Comm: mount Not tainted 5.17.0 #7
> 4,924,9602592567,-;Hardware name: Dell Inc. OptiPlex 9020/03CPWF, BIOS A14
> 09/14/2015
> 4,925,9602592569,-;RIP: 0010:assfail+0x4f/0x54
> 4,926,9602592576,-;Code: c1 e2 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f =
10
> 84
> d2 74 0c 48 c7 c7 ac 72 da a9 e8 79 f7 7d fd 80 3d 7e 4e 3c 01 00 74 02 <=
0f>
> 0b
> 0f 0b c3 48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 00 a3
> 4,927,9602592579,-;RSP: 0018:ffff88810f897b40 EFLAGS: 00010202
> 4,928,9602592583,-;RAX: 0000000000000004 RBX: ffff88811c8d0000 RCX:
> 1ffffffff53b4e55
> 4,929,9602592585,-;RDX: dffffc0000000000 RSI: 000000000000000a RDI:
> ffffed1021f12f5a
> 4,930,9602592588,-;RBP: ffff88810f897cb0 R08: 00000000ffffffea R09:
> ffffed103aafe4eb
> 4,931,9602592590,-;R10: ffff8881d57f2757 R11: ffffed103aafe4ea R12:
> ffff88811c8d05b8
> 4,932,9602592592,-;R13: ffff88811c8d0000 R14: ffff88811c8d00c8 R15:
> 000000002800c9fa
> 4,933,9602592594,-;FS:  00007fa6c6b2a840(0000) GS:ffff8881d57c0000(0000)
> knlGS:0000000000000000
> 4,934,9602592597,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 4,935,9602592599,-;CR2: 00007fffe0409d30 CR3: 0000000112a58004 CR4:
> 00000000001706e0
> 4,936,9602592602,-;Call Trace:
> 4,937,9602592604,-; <TASK>
> 4,938,9602592605,-; xfs_da_mount+0x7e5/0xad0
> 4,939,9602592612,-; ? xfs_uuid_mount+0x290/0x3a0
> 4,940,9602592616,-; xfs_mountfs+0xab5/0x19f0
> 4,941,9602592619,-; ? create_object+0x649/0xaf0
> 4,942,9602592623,-; ? kasan_unpoison+0x23/0x50
> 4,943,9602592627,-; ? xfs_mount_reset_sbqflags+0x100/0x100
> 4,944,9602592631,-; ? kmem_alloc+0x8e/0x290
> 4,945,9602592634,-; ? xfs_filestream_put_ag+0x30/0x30
> 4,946,9602592638,-; ? xfs_mru_cache_create+0x339/0x540
> 4,947,9602592642,-; xfs_fs_fill_super+0xc24/0x1710
> 4,948,9602592646,-; get_tree_bdev+0x379/0x650
> 4,949,9602592650,-; ? xfs_fs_sync_fs+0x210/0x210
> 4,950,9602592654,-; vfs_get_tree+0x7f/0x2b0
> 4,951,9602592658,-; ? ns_capable_common+0x52/0xd0
> 4,952,9602592662,-; path_mount+0x47e/0x19b0
> 4,953,9602592667,-; ? finish_automount+0x5d0/0x5d0
> 4,954,9602592671,-; ? user_path_at_empty+0x40/0x50
> 4,955,9602592674,-; ? kmem_cache_free+0xa5/0x300
> 4,956,9602592677,-; do_mount+0xc5/0xe0
> 4,957,9602592681,-; ? path_mount+0x19b0/0x19b0
> 4,958,9602592684,-; ? _copy_from_user+0x38/0x70
> 4,959,9602592690,-; ? copy_mount_options+0x69/0x120
> 4,960,9602592694,-; __x64_sys_mount+0x127/0x190
> 4,961,9602592698,-; do_syscall_64+0x3b/0x90
> 4,962,9602592702,-; entry_SYSCALL_64_after_hwframe+0x44/0xae
> 4,963,9602592707,-;RIP: 0033:0x7fa6c6d89cae
> 4,964,9602592710,-;Code: 48 8b 0d e5 c1 0c 00 f7 d8 64 89 01 48 83 c8 ff =
c3
> 66
> 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89 ca b8 a5 00 00 00 0f 05 <=
48>
> 3d
> 01 f0 ff ff 73 01 c3 48 8b 0d b2 c1 0c 00 f7 d8 64 89 01 48
> 4,965,9602592713,-;RSP: 002b:00007fffe040b588 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000a5
> 4,966,9602592716,-;RAX: ffffffffffffffda RBX: 00007fa6c6ebb204 RCX:
> 00007fa6c6d89cae
> 4,967,9602592719,-;RDX: 0000557359be6830 RSI: 0000557359be6870 RDI:
> 0000557359be6850
> 4,968,9602592721,-;RBP: 0000557359be6530 R08: 0000557359be6790 R09:
> 00007fffe040a300
> 4,969,9602592723,-;R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000000000000
> 4,970,9602592725,-;R13: 0000557359be6850 R14: 0000557359be6830 R15:
> 0000557359be6530
> 4,971,9602592728,-; </TASK>
> 4,972,9602592729,-;Modules linked in: x86_pkg_temp_thermal efivarfs
> 4,973,9602592736,-;---[ end trace 0000000000000000 ]---
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
