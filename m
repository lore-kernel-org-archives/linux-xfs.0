Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4A8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 06:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbiEEG1x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 02:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235279AbiEEG1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 02:27:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D9F2F3B4
        for <linux-xfs@vger.kernel.org>; Wed,  4 May 2022 23:24:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23F3261CC7
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:24:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B92FC385B3
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 06:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651731852;
        bh=Cs3QkqFhbp5nc7hnQXFofrR8oQCe1sIu6nkFuQ/UBQQ=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=CKE1de7PebTEfnybkfwKrJ6sf9aRgI8yxKo0l6GTRVG5mnJGd71++UCkAnQe/375q
         39UzMB2WRWrvADP7ycLpu+WlWi4ocF4nKH6UijOP6VP+EFxSo/2xe/deR7dUYPHEp8
         JKE1/jDbmDp/1OOkyd8n+D/buIxgRCU+5+4OEZK+EFlFlQXL6t224vRfwA1dCqP+R4
         iEN7UjQupkudigyQguE7S7NXRB1maFs9Slyh8dITVA8Xr5/2Z7pCBVnC/N8bWmQKwb
         VFI31EXtxYbnZe04K9SWjLXcwnc76bwYGYTrLfB+3pVKL25MeXAjMiZxECVPEgKtaU
         oXHBKlakW07zA==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id 7C1BAC05FF5; Thu,  5 May 2022 06:24:12 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 215786] unable to handle page fault BUG triggered in
 fs/xfs/xfs_log_recover.c: xlog_recover_add_to_cont_trans()  when mount a
 corrupted image
Date:   Thu, 05 May 2022 06:24:11 +0000
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
Message-ID: <bug-215786-201763-aVvqAiqNKq@https.bugzilla.kernel.org/>
In-Reply-To: <bug-215786-201763@https.bugzilla.kernel.org/>
References: <bug-215786-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D215786

--- Comment #1 from Darrick J. Wong (djwong@kernel.org) ---
If you are going to run some scripted tool to randomly
corrupt the filesystem to find failures, then you have an
ethical and moral responsibility to do some of the work to
narrow down and identify the cause of the failure, not just
throw them at someone to do all the work.

--D

On Thu, Mar 31, 2022 at 08:43:02PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D215786
>=20
>             Bug ID: 215786
>            Summary: unable to handle page fault BUG triggered in
>                     fs/xfs/xfs_log_recover.c:
>                     xlog_recover_add_to_cont_trans()  when mount a
>                     corrupted image
>            Product: File System
>            Version: 2.5
>     Kernel Version: 5.17.1, 5.15.32
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: XFS
>           Assignee: filesystem_xfs@kernel-bugs.kernel.org
>           Reporter: wenqingliu0120@gmail.com
>         Regression: No
>=20
> Created attachment 300674
>   --> https://bugzilla.kernel.org/attachment.cgi?id=3D300674&action=3Dedit
> corrupted image and .config
>=20
> - Overview=20
> unable to handle page fault BUG triggered in fs/xfs/xfs_log_recover.c:
> xlog_recover_add_to_cont_trans() when mount a corrupted image
>=20
> - Reproduce=20
> tested on kernel 5.17.1, 5.15.32
>=20
> $ mkdir mnt
> $ unzip tmp3.zip
> $ sudo mount -t xfs tmp3.img mnt
>=20
> - Kernel dump
> [  148.130068] loop0: detected capacity change from 0 to 32768
> [  148.154549] XFS (loop0): Deprecated V4 format (crc=3D0) will not be
> supported
> after September 2030.
> [  148.154968] XFS (loop0): Mounting V10 Filesystem
> [  148.186177] XFS (loop0): Starting recovery (logdev: internal)
> [  148.186257] BUG: unable to handle page fault for address: ffffffffffff=
fff8
> [  148.186282] #PF: supervisor read access in kernel mode
> [  148.186294] #PF: error_code(0x0000) - not-present page
> [  148.186305] PGD 1ff60e067 P4D 1ff60e067 PUD 1ff610067 PMD 0=20
> [  148.186319] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  148.186329] CPU: 3 PID: 894 Comm: mount Not tainted 5.17.1 #1
> [  148.186343] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.13.0-1ubuntu1.1 04/01/2014
> [  148.186360] RIP: 0010:xlog_recover_add_to_cont_trans+0x46/0x1e0 [xfs]
> [  148.186594] Code: 89 cb 48 83 ec 08 48 8b 46 30 48 39 c7 0f 84 d7 00 0=
0 00
> 4c 8b 66 38 49 63 44 24 10 49 8b 54 24 18 48 c1 e0 04 48 8d 44 02 f0 <4c>=
 63
> 78
> 08 48 8b 38 4c 89 fa 4c 89 fe 01 ca b9 c0 0c 00 00 48 63
> [  148.186630] RSP: 0018:ffffa5e600c6fac8 EFLAGS: 00010246
> [  148.186642] RAX: fffffffffffffff0 RBX: 0000000000000180 RCX:
> 0000000000000180
> [  148.186656] RDX: 0000000000000000 RSI: ffff950b9003fc40 RDI:
> ffff950b9003fc70
> [  148.186671] RBP: ffff950b9003fc40 R08: 0000000000000008 R09:
> 0000000000000001
> [  148.186685] R10: 0000000000000005 R11: ffff950b8b059ff8 R12:
> ffff950b9003f300
> [  148.186700] R13: ffff950b86c2f800 R14: ffff950b8b058058 R15:
> ffff950b8b058058
> [  148.186714] FS:  00007f366411e080(0000) GS:ffff950d75d80000(0000)
> knlGS:0000000000000000
> [  148.186730] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  148.186742] CR2: fffffffffffffff8 CR3: 000000010f138005 CR4:
> 0000000000370ee0
> [  148.186759] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  148.186773] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [  148.186788] Call Trace:
> [  148.186806]  <TASK>
> [  148.186813]  xlog_recovery_process_trans+0x6b/0xc0 [xfs]
> [  148.186899]  xlog_recover_process_data+0xab/0x130 [xfs]
> [  148.186984]  xlog_do_recovery_pass+0x2d5/0x5c0 [xfs]
> [  148.187092]  xlog_do_log_recovery+0x62/0xb0 [xfs]
> [  148.187186]  xlog_do_recover+0x34/0x190 [xfs]
> [  148.187280]  xlog_recover+0xbc/0x170 [xfs]
> [  148.187356]  xfs_log_mount+0x125/0x2d0 [xfs]
> [  148.187431]  xfs_mountfs+0x4e0/0xa50 [xfs]
> [  148.187508]  ? kmem_alloc+0x88/0x140 [xfs]
> [  148.187587]  ? xfs_filestream_get_parent+0x70/0x70 [xfs]
> [  148.187660]  xfs_fs_fill_super+0x69f/0x880 [xfs]
> [  148.187741]  ? sget_fc+0x1be/0x230
> [  148.187751]  ? xfs_fs_inode_init_once+0x70/0x70 [xfs]
> [  148.187825]  get_tree_bdev+0x16a/0x280
> [  148.187835]  vfs_get_tree+0x22/0xc0
> [  148.187844]  path_mount+0x59b/0x9a0
> [  148.187854]  do_mount+0x75/0x90
> [  148.187862]  __x64_sys_mount+0x86/0xd0
> [  148.187871]  do_syscall_64+0x37/0xb0
> [  148.187881]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  148.187893] RIP: 0033:0x7f36639df15a
> [  148.187905] Code: 48 8b 0d 31 8d 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 6=
6 2e
> 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48>=
 3d
> 01
> f0 ff ff 73 01 c3 48 8b 0d fe 8c 2c 00 f7 d8 64 89 01 48
> [  148.188671] RSP: 002b:00007ffe15780dc8 EFLAGS: 00000202 ORIG_RAX:
> 00000000000000a5
> [  148.189058] RAX: ffffffffffffffda RBX: 0000564b1f2ac420 RCX:
> 00007f36639df15a
> [  148.189481] RDX: 0000564b1f2ac600 RSI: 0000564b1f2ae320 RDI:
> 0000564b1f2b5c40
> [  148.189878] RBP: 0000000000000000 R08: 0000000000000000 R09:
> 0000564b1f2ac620
> [  148.190283] R10: 00000000c0ed0000 R11: 0000000000000202 R12:
> 0000564b1f2b5c40
> [  148.190677] R13: 0000564b1f2ac600 R14: 0000000000000000 R15:
> 00007f3663f008a4
> [  148.191071]  </TASK>
> [  148.191471] Modules linked in: joydev input_leds serio_raw iscsi_tcp
> libiscsi_tcp libiscsi qemu_fw_cfg scsi_transport_iscsi xfs autofs4 raid10
> raid456 async_raid6_recov async_memcpy async_pq hid_generic async_xor
> async_tx
> usbhid raid1 hid raid0 multipath linear qxl drm_ttm_helper ttm drm_kms_he=
lper
> syscopyarea sysfillrect sysimgblt fb_sys_fops drm crct10dif_pclmul
> crc32_pclmul
> ghash_clmulni_intel psmouse aesni_intel crypto_simd cryptd
> [  148.193140] CR2: fffffffffffffff8
> [  148.193545] ---[ end trace 0000000000000000 ]---
> [  148.193933] RIP: 0010:xlog_recover_add_to_cont_trans+0x46/0x1e0 [xfs]
> [  148.194439] Code: 89 cb 48 83 ec 08 48 8b 46 30 48 39 c7 0f 84 d7 00 0=
0 00
> 4c 8b 66 38 49 63 44 24 10 49 8b 54 24 18 48 c1 e0 04 48 8d 44 02 f0 <4c>=
 63
> 78
> 08 48 8b 38 4c 89 fa 4c 89 fe 01 ca b9 c0 0c 00 00 48 63
> [  148.195288] RSP: 0018:ffffa5e600c6fac8 EFLAGS: 00010246
> [  148.195710] RAX: fffffffffffffff0 RBX: 0000000000000180 RCX:
> 0000000000000180
> [  148.196139] RDX: 0000000000000000 RSI: ffff950b9003fc40 RDI:
> ffff950b9003fc70
> [  148.196565] RBP: ffff950b9003fc40 R08: 0000000000000008 R09:
> 0000000000000001
> [  148.196983] R10: 0000000000000005 R11: ffff950b8b059ff8 R12:
> ffff950b9003f300
> [  148.197409] R13: ffff950b86c2f800 R14: ffff950b8b058058 R15:
> ffff950b8b058058
> [  148.197833] FS:  00007f366411e080(0000) GS:ffff950d75d80000(0000)
> knlGS:0000000000000000
> [  148.198261] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  148.198692] CR2: fffffffffffffff8 CR3: 000000010f138005 CR4:
> 0000000000370ee0
> [  148.199154] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  148.199589] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
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
