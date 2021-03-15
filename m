Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F98FC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 06:38:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A25A64E38
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 06:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCOGiE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 02:38:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229679AbhCOGh7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Mar 2021 02:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 22E2364E46
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 06:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615790279;
        bh=Qa+EkRmfyH/FWrUp4F5QZ2wqb/UbgncAIQY13vWRJNc=;
        h=From:To:Subject:Date:From;
        b=YplfwYiM2omW5azO7IXNnBoiQyN37RKRlv4wlC4oGpj9ksZUzBNQkLKAdK/VNULci
         Jk4daMjJvrCiQZAWNx9hwn+IBw4Oz3VxviuTY9AueXaKKvkS1UmlLenmtQQRCPw8Za
         Etd8L5oT4L0QcucyGxUFVT4jmuGNoc7QAiTlpNWE5IuE80zxWMV+y+IHzqdawFCd4o
         DZlY5jJKYIQBAKZbOykJ2FigsUB5IJSz0mjtuOEyA6pwqB2pGPXnnFvVtsHb+vpOU9
         sSiJENrbCDlA81tNFe7sKaTe7KSB53LRDN/JhRbC4eRXqAY5HI/yKyPlphYdYRJDCi
         AlySSJS1mrKFw==
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 212289] New: XFS: Assertion failed: current->journal_info ==
 NULL, file: fs/xfs/xfs_trans.h, line: 288
Date:   Mon, 15 Mar 2021 06:37:58 +0000
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
Message-ID: <bug-212289-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D212289

            Bug ID: 212289
           Summary: XFS: Assertion failed: current->journal_info =3D=3D NUL=
L,
                    file: fs/xfs/xfs_trans.h, line: 288
           Product: File System
           Version: 2.5
    Kernel Version: linux v5.12-rc2 + xfs-5.12-fixes-1
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

xfstests generic/013 hit below XFS Assertion failure, other cases likes g/0=
51,
g/068, g/232, g/269 hit chance to trigger this bug too:

[26229.179743] XFS: Assertion failed: current->journal_info =3D=3D NULL, fi=
le:
fs/xfs/xfs_trans.h, line: 288
[26229.221446] ------------[ cut here ]------------
[26229.242454] WARNING: CPU: 0 PID: 1196931 at fs/xfs/xfs_message.c:112
assfail+0x56/0x59 [xfs]
[26229.281431] Modules linked in: dm_snapshot dm_bufio ext4 mbcache jbd2 lo=
op
dm_flakey dm_mod rfkill intel_rapl_msr intel_rapl_common sb_edac
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel mgag200 i2c_algo_b=
it
kvm drm_kms_helper irqbypass syscopyarea iTCO_wdt sunrpc sysfillrect rapl
iTCO_vendor_support ipmi_ssif intel_cstate sysimgblt fb_sys_fops acpi_ipmi
intel_uncore ioatdma cec i2c_i801 pcspkr ipmi_si hpilo lpc_ich i2c_smbus hp=
wdt
ipmi_devintf dca ipmi_msghandler acpi_tad acpi_power_meter drm fuse ip_tabl=
es
xfs libcrc32c sd_mod t10_pi crct10dif_pclmul crc32_pclmul crc32c_intel hpsa=
 tg3
ghash_clmulni_intel serio_raw scsi_transport_sas wmi [last unloaded:
scsi_debug]
[26229.559900] CPU: 0 PID: 1196931 Comm: fsstress Tainted: G        W=20=20=
=20=20=20=20=20=20
5.12.0-rc2+ #1
[26229.599322] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 03/05/2015
[26229.630137] RIP: 0010:assfail+0x56/0x59 [xfs]
[26229.650227] Code: 2a 83 e0 07 48 c1 e9 03 8a 14 11 38 c2 7f 10 84 d2 74 =
0c
48 c7 c7 4c 20 8f c0 e8 c6 c6 b6 db 80 3d 5b 7b 16 00 00 74 02 0f 0b <0f> 0=
b c3
48 8d 45 10 48 8d 54 24 28 4c 89 f6 48 c7 c7 60 82 7b c0
[26229.734583] RSP: 0018:ffffc9000314f2b0 EFLAGS: 00010246
[26229.758375] RAX: 0000000000000004 RBX: ffff88813a7522fc RCX:
1ffffffff811e409
[26229.790633] RDX: dffffc0000000000 RSI: ffffc9000314f0a0 RDI:
fffff52000629e48
[26229.822713] RBP: ffff88815a04a000 R08: 00000000ffffffea R09:
ffff8883dd7f08e7
[26229.854915] R10: ffffed107bafe11c R11: 0000000000000001 R12:
ffff88813a752000
[26229.887303] R13: 0000000000000001 R14: dffffc0000000000 R15:
0000000000000000
[26229.919544] FS:  00007fcfac488080(0000) GS:ffff8883dd600000(0000)
knlGS:0000000000000000
[26229.956137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[26229.982158] CR2: 00007fcfac692000 CR3: 000000011a61c005 CR4:
00000000001706f0
[26230.014627] Call Trace:
[26230.025669]  xfs_trans_alloc+0x4e8/0x9e0 [xfs]
[26230.045958]  xfs_inactive_truncate+0x91/0x240 [xfs]
[26230.070142]  ? xfs_itruncate_extents_flags+0xcd0/0xcd0 [xfs]
[26230.098308]  ? xfs_inactive+0xdf/0x580 [xfs]
[26230.119538]  xfs_inactive+0x426/0x580 [xfs]
[26230.139004]  xfs_fs_destroy_inode+0x334/0x8d0 [xfs]
[26230.161108]  destroy_inode+0xbc/0x190
[26230.177645]  xfs_bulkstat_one_int+0xb32/0x10f0 [xfs]
[26230.200120]  ? lock_is_held_type+0x9a/0x110
[26230.218921]  ? xfs_inumbers_walk+0x3a0/0x3a0 [xfs]
[26230.240656]  ? xfs_buf_rele+0x382/0xc50 [xfs]
[26230.260691]  ? do_raw_spin_unlock+0x55/0x1f0
[26230.279892]  xfs_bulkstat_iwalk+0x67/0xb0 [xfs]
[26230.300438]  xfs_iwalk_ag_recs+0x396/0x680 [xfs]
[26230.321396]  xfs_iwalk_run_callbacks+0x291/0x520 [xfs]
[26230.344688]  xfs_iwalk_ag+0x5b7/0x780 [xfs]
[26230.363639]  ? xfs_iwalk_run_callbacks+0x520/0x520 [xfs]
[26230.387886]  ? __kasan_kmalloc+0x7a/0x90
[26230.405643]  ? kmem_alloc+0x10b/0x350 [xfs]
[26230.424711]  xfs_iwalk+0x1ce/0x310 [xfs]
[26230.442627]  ? xfs_iwalk_ag_work+0x140/0x140 [xfs]
[26230.464499]  ? rcu_read_lock_sched_held+0x3f/0x70
[26230.485802]  ? xfs_bulkstat_one_int+0x10f0/0x10f0 [xfs]
[26230.509940]  ? xfs_trans_alloc_empty+0x7d/0xa0 [xfs]
[26230.532595]  ? xfs_trans_alloc+0x9e0/0x9e0 [xfs]
[26230.553840]  xfs_bulkstat+0x2c6/0x450 [xfs]
[26230.573291]  ? xfs_bulkstat_one+0x270/0x270 [xfs]
[26230.596650]  ? lock_is_held_type+0x9a/0x110
[26230.617539]  ? xfs_attrmulti_attr_set+0x1e0/0x1e0 [xfs]
[26230.643682]  ? __might_fault+0xba/0x160
[26230.662550]  ? lock_release+0x11e/0x2a0
[26230.680158]  xfs_ioc_fsbulkstat.isra.0+0x206/0x370 [xfs]
[26230.704376]  ? xfs_ioc_setxflags+0x1e0/0x1e0 [xfs]
[26230.726146]  ? find_held_lock+0x33/0x110
[26230.744135]  ? kmem_cache_free+0x9e/0x320
[26230.762308]  xfs_file_ioctl+0xf26/0x18b0 [xfs]
[26230.782686]  ? xfs_ioc_swapext+0x4d0/0x4d0 [xfs]
[26230.803616]  ? find_held_lock+0x33/0x110
[26230.820895]  ? avc_ss_reset+0x130/0x130
[26230.838220]  ? lock_downgrade+0x100/0x100
[26230.856459]  ? mark_lock+0xd3/0x1470
[26230.872674]  ? do_raw_spin_trylock+0xb5/0x180
[26230.892310]  ? check_prev_add+0x20f0/0x20f0
[26230.911166]  ? lockdep_hardirqs_on_prepare.part.0+0x198/0x340
[26230.937148]  ? __lock_acquire+0xb77/0x18d0
[26230.955731]  ? sched_clock+0x5/0x10
[26230.971496]  ? selinux_file_ioctl+0x380/0x520
[26230.991289]  ? generic_block_fiemap+0x60/0x60
[26231.011042]  ? selinux_inode_getsecctx+0x80/0x80
[26231.031823]  ? lock_is_held_type+0x9a/0x110
[26231.050663]  ? lock_release+0x11e/0x2a0
[26231.068003]  ? __fget_files+0x1bf/0x2d0
[26231.085370]  ? tg3_read_fw_ver+0x105/0x620 [tg3]
[26231.108124]  __x64_sys_ioctl+0x127/0x190
[26231.127745]  do_syscall_64+0x33/0x40
[26231.145321]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[26231.168797] RIP: 0033:0x7fcfac58065b
[26231.184885] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 =
e0
41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3=
d 01
f0 ff ff 73 01 c3 48 8b 0d e5 b7 0c 00 f7 d8 64 89 01 48
[26231.269880] RSP: 002b:00007ffd9b7921c8 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[26231.304683] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fcfac58065b
[26231.336965] RDX: 00007ffd9b7921e0 RSI: ffffffffc0205865 RDI:
0000000000000004
[26231.369207] RBP: 0000000002378720 R08: 0000000002378720 R09:
00007fcfac64ca60
[26231.402804] R10: 0000000000000000 R11: 0000000000000246 R12:
000000000000035a
[26231.435873] R13: 0000000000000042 R14: 0000000000000004 R15:
0000000000000000
[26231.468496]  ? tg3_read_fw_ver+0x105/0x620 [tg3]
[26231.489516] irq event stamp: 43243
[26231.505201] hardirqs last  enabled at (43253): [<ffffffff9bd673d5>]
console_unlock+0x435/0x5d0
[26231.544607] hardirqs last disabled at (43276): [<ffffffff9bd6745e>]
console_unlock+0x4be/0x5d0
[26231.583522] softirqs last  enabled at (43274): [<ffffffff9de00608>]
__do_softirq+0x608/0x940
[26231.623065] softirqs last disabled at (43295): [<ffffffff9bbedee3>]
__irq_exit_rcu+0x1f3/0x2d0
[26231.665504] ---[ end trace 800c1415edc514b2 ]---

    284 static inline void
    285 xfs_trans_set_context(
    286         struct xfs_trans        *tp)
    287 {
    288         ASSERT(current->journal_info =3D=3D NULL);
    289         tp->t_pflags =3D memalloc_nofs_save();
    290         current->journal_info =3D tp;
    291 }

meta-data=3D/dev/sda2              isize=3D512    agcount=3D8, agsize=3D326=
40 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D1
         =3D                       crc=3D1        finobt=3D1, sparse=3D1, r=
mapbt=3D0
         =3D                       reflink=3D1    bigtime=3D0
data     =3D                       bsize=3D2048   blocks=3D261120, imaxpct=
=3D25
         =3D                       sunit=3D128    swidth=3D512 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0, ftype=3D1
log      =3Dinternal log           bsize=3D2048   blocks=3D8832, version=3D2
         =3D                       sectsz=3D512   sunit=3D128 blks, lazy-co=
unt=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
