Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD086C4338F
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Aug 2021 03:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A45C613E8
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Aug 2021 03:47:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhHPDrm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 15 Aug 2021 23:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhHPDrm (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 15 Aug 2021 23:47:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0B97A61980
        for <linux-xfs@vger.kernel.org>; Mon, 16 Aug 2021 03:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629085631;
        bh=ALmsuBPI3H900DL2S/+nKjaQkvEzW9RdxfKouBYl7A4=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ZDkj7W2KGtqTi3D9WFQQn6yAf0BYhm2qkpz8+7/XDZedQEKiG6QPpmV+e7TpDQHE8
         pi148i9Ldc46CHjwOo8hb4kBJ5UvSCllYUybFuZOydrKS+r5rdnyVU0a3gQmfknU6h
         V2XJBaanpd8ytx+z5op3kc24XkBwvbWfZsEoW5fGOAP9E/PtEqM8TIurzl3x0+7eo6
         arfbhgqxsQaBYstMtOn85mmZbh4eiG9eG4JHG2TynCAIhDzmBaEMM7E2QU4dTId8I+
         z7mqtHjz1oPl2ZGNqeGw6zJYp0bm+cS+qdcfrAUI078KmZ8K/TOZcvttmFIghvG1Fz
         GCQ9bBRKA7Spw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 213941] [xfstests xfs/104] XFS: Assertion failed: agno <
 mp->m_sb.sb_agcount, file: fs/xfs/libxfs/xfs_types.c, line: 22
Date:   Mon, 16 Aug 2021 03:47:10 +0000
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
Message-ID: <bug-213941-201763-lPGl1rfBSL@https.bugzilla.kernel.org/>
In-Reply-To: <bug-213941-201763@https.bugzilla.kernel.org/>
References: <bug-213941-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D213941

--- Comment #1 from Zorro Lang (zlang@redhat.com) ---
FYI: Hit again:

[38631.895571] run fstests xfs/104 at 2021-08-13 01:26:58
[38638.618323] XFS (sda3): Mounting V5 Filesystem
[38638.669558] XFS (sda3): Ending clean mount
[38641.815797] XFS (sda3): xlog_verify_grant_tail: space > BBTOB(tail_block=
s)
[38654.539685] XFS: Assertion failed: agno < mp->m_sb.sb_agcount, file:
fs/xfs/libxfs/xfs_types.c, line: 22
[38654.544409] ------------[ cut here ]------------
[38654.545856] WARNING: CPU: 1 PID: 779087 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[38654.549424] Modules linked in: dm_flakey dm_mod rfkill snd_hda_codec_gen=
eric
ledtrig_audio snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core
snd_hwdep kvm_intel qxl snd_seq sunrpc drm_ttm_helper ttm snd_seq_device kvm
drm_kms_helper snd_pcm syscopyarea snd_timer sysfillrect snd sysimgblt
fb_sys_fops irqbypass cec virtio_balloon joydev soundcore i2c_piix4 pcspkr =
drm
fuse xfs libcrc32c sd_mod t10_pi ata_generic ata_piix crct10dif_pclmul liba=
ta
crc32_pclmul crc32c_intel virtio_console 8139too ghash_clmulni_intel 8139cp
serio_raw mii
[38654.564435] CPU: 1 PID: 779087 Comm: xfsaild/sda3 Kdump: loaded Not tain=
ted
5.14.0-rc4+ #1
[38654.566837] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[38654.568542] RIP: 0010:assfail+0x56/0x59 [xfs]
[38654.570389] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 4c 91 a0 c0 e8 bb 53 ca d0 80 3d b0 06 17 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 40 6c 8c c0
[38654.576770] RSP: 0018:ffffc90001837818 EFLAGS: 00010246
[38654.578744] RAX: 0000000000000004 RBX: 000000000000000f RCX:
1ffffffff8141229
[38654.581257] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI:
fffff52000306ef5
[38654.583635] RBP: 00000000000e6440 R08: ffffc900018376a8 R09:
ffff8881793f1647
[38654.586213] R10: ffffed102f27e2c8 R11: 0000000000000001 R12:
ffff88810f10c000
[38654.588768] R13: ffffed1021e2180b R14: ffff88810f10c1e7 R15:
dffffc0000000000
[38654.591376] FS:  0000000000000000(0000) GS:ffff888179200000(0000)
knlGS:0000000000000000
[38654.594278] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[38654.596388] CR2: 00000000008e3000 CR3: 00000001022e2004 CR4:
00000000000206e0
[38654.599058] Call Trace:
[38654.600445]  xfs_verify_icount+0x262/0x3c0 [xfs]
[38654.602559]  ? xfs_validate_sb_common+0x98e/0x1160 [xfs]
[38654.604801]  xfs_validate_sb_write.isra.0+0xf2/0x3c0 [xfs]
[38654.607036]  xfs_sb_write_verify+0x1ac/0x3b0 [xfs]
[38654.609016]  ? xfs_validate_sb_common+0x1160/0x1160 [xfs]
[38654.617256]  ? validate_chain+0x14c/0xde0
[38654.618986]  _xfs_buf_ioapply+0x15f/0x5b0 [xfs]
[38654.620708]  ? xfs_buf_wait_unpin+0xc3/0x2a0 [xfs]
[38654.622410]  ? xfs_buf_ioapply_map+0x690/0x690 [xfs]
[38654.624207]  ? __lock_contended+0x910/0x910
[38654.625541]  ? _xfs_buf_map_pages+0x420/0x420 [xfs]
[38654.627298]  ? do_raw_spin_trylock+0xb5/0x180
[38654.628875]  ? wake_up_q+0xf0/0xf0
[38654.630327]  ? __xfs_buf_submit+0x128/0x690 [xfs]
[38654.632046]  ? xfs_buf_delwri_submit_buffers+0x329/0xac0 [xfs]
[38654.634045]  __xfs_buf_submit+0x21c/0x690 [xfs]
[38654.635805]  xfs_buf_delwri_submit_buffers+0x329/0xac0 [xfs]
[38654.637787]  ? __lock_release+0x494/0xa40
[38654.639094]  ? xfs_buf_ioend_work+0x20/0x20 [xfs]
[38654.640764]  ? xfsaild_push+0x424/0x1bf0 [xfs]
[38654.642656]  xfsaild_push+0x42e/0x1bf0 [xfs]
[38654.644274]  ? xfs_trans_ail_cursor_first+0x180/0x180 [xfs]
[38654.646182]  xfsaild+0x136/0x950 [xfs]
[38654.647614]  ? xfsaild_push+0x1bf0/0x1bf0 [xfs]
[38654.649246]  kthread+0x329/0x3e0
[38654.650260]  ? _raw_spin_unlock_irq+0x24/0x30
[38654.651915]  ? set_kthread_struct+0x100/0x100
[38654.653433]  ret_from_fork+0x22/0x30
[38654.654782] irq event stamp: 13451
[38654.656026] hardirqs last  enabled at (13461): [<ffffffff90f7bdbd>]
console_unlock+0x4dd/0x5f0
[38654.658549] hardirqs last disabled at (13470): [<ffffffff90f7bd4e>]
console_unlock+0x46e/0x5f0
[38654.661126] softirqs last  enabled at (13070): [<ffffffff930005ca>]
__do_softirq+0x5ca/0x90f
[38654.663561] softirqs last disabled at (13065): [<ffffffff90dfb8a7>]
__irq_exit_rcu+0x207/0x280
[38654.666485] ---[ end trace 64794ca72522b1a1 ]---
[38768.778662] XFS (sda3): Unmounting Filesystem
[38769.401075] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 195
[38769.404514] ------------[ cut here ]------------
[38769.406150] WARNING: CPU: 5 PID: 779398 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[38769.410661] Modules linked in: dm_flakey dm_mod rfkill snd_hda_codec_gen=
eric
ledtrig_audio snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hda_core
snd_hwdep kvm_intel qxl snd_seq sunrpc drm_ttm_helper ttm snd_seq_device kvm
drm_kms_helper snd_pcm syscopyarea snd_timer sysfillrect snd sysimgblt
fb_sys_fops irqbypass cec virtio_balloon joydev soundcore i2c_piix4 pcspkr =
drm
fuse xfs libcrc32c sd_mod t10_pi ata_generic ata_piix crct10dif_pclmul liba=
ta
crc32_pclmul crc32c_intel virtio_console 8139too ghash_clmulni_intel 8139cp
serio_raw mii
[38769.426722] CPU: 5 PID: 779398 Comm: umount Kdump: loaded Tainted: G=20=
=20=20=20=20=20=20
W         5.14.0-rc4+ #1
[38769.429849] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[38769.431565] RIP: 0010:assfail+0x56/0x59 [xfs]
[38769.433184] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 4c 91 a0 c0 e8 bb 53 ca d0 80 3d b0 06 17 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 40 6c 8c c0
[38769.438438] RSP: 0018:ffffc900026afcf8 EFLAGS: 00010246
[38769.439999] RAX: 0000000000000004 RBX: ffff88810bbd9000 RCX:
1ffffffff8141229
[38769.442033] RDX: dffffc0000000000 RSI: dffffc0000000000 RDI:
fffff520004d5f91
[38769.444123] RBP: 0000000000000010 R08: ffffc900026afb88 R09:
ffff88817a3f1647
[38769.446191] R10: ffffed102f47e2c8 R11: 0000000000000001 R12:
ffff88810f10c6c8
[38769.448223] R13: ffff88810f10c000 R14: ffff88810bbd900c R15:
ffff88810f10c670
[38769.450245] FS:  00007f00b1d834c0(0000) GS:ffff88817a200000(0000)
knlGS:0000000000000000
[38769.452525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[38769.454183] CR2: 00007f41f9342000 CR3: 0000000105ae6002 CR4:
00000000000206e0
[38769.456221] Call Trace:
[38769.457078]  xfs_free_perag+0x152/0x1a0 [xfs]
[38769.458588]  xfs_unmountfs+0x112/0x1b0 [xfs]
[38769.460120]  ? xfs_mountfs+0x1a50/0x1a50 [xfs]
[38769.461687]  ? kfree+0xe0/0x4b0
[38769.462782]  xfs_fs_put_super+0x67/0x340 [xfs]
[38769.464422]  generic_shutdown_super+0x136/0x330
[38769.466072]  kill_block_super+0x95/0xd0
[38769.467291]  deactivate_locked_super+0x8d/0x140
[38769.468630]  cleanup_mnt+0x31f/0x4a0
[38769.469759]  task_work_run+0xce/0x170
[38769.470918]  exit_to_user_mode_loop+0x180/0x190
[38769.472297]  exit_to_user_mode_prepare+0xf4/0x170
[38769.473741]  syscall_exit_to_user_mode+0x19/0x60
[38769.475162]  do_syscall_64+0x48/0x90
[38769.476275]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[38769.477772] RIP: 0033:0x7f00b1f8f74b
[38769.478893] Code: e3 86 0e 00 f7 d8 64 89 01 48 83 c8 ff c3 90 f3 0f 1e =
fa
31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3=
d 00
f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 a9 86 0e 00 f7 d8
[38769.484046] RSP: 002b:00007ffee1af3fd8 EFLAGS: 00000246 ORIG_RAX:
00000000000000a6
[38769.486368] RAX: 0000000000000000 RBX: 000055e495a8b630 RCX:
00007f00b1f8f74b
[38769.488421] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
000055e495a900e0
[38769.490456] RBP: 000055e495a8b400 R08: 0000000000000000 R09:
00007ffee1af2d60
[38769.492492] R10: 0000000000000000 R11: 0000000000000246 R12:
0000000000000000
[38769.494524] R13: 000055e495a900e0 R14: 000055e495a8b510 R15:
000055e495a8b400
[38769.496678] irq event stamp: 709585
[38769.497757] hardirqs last  enabled at (709595): [<ffffffff90f7bdbd>]
console_unlock+0x4dd/0x5f0
[38769.500215] hardirqs last disabled at (709604): [<ffffffff90f7bd4e>]
console_unlock+0x46e/0x5f0
[38769.502653] softirqs last  enabled at (709272): [<ffffffff930005ca>]
__do_softirq+0x5ca/0x90f
[38769.505156] softirqs last disabled at (709263): [<ffffffff90dfb8a7>]
__irq_exit_rcu+0x207/0x280
[38769.507670] ---[ end trace 64794ca72522b1a2 ]---
[38769.521736] XFS: Assertion failed: atomic_read(&pag->pag_ref) =3D=3D 0, =
file:
fs/xfs/libxfs/xfs_ag.c, line: 176
[38769.524773] ------------[ cut here ]------------
[38769.526538] WARNING: CPU: 5 PID: 0 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
