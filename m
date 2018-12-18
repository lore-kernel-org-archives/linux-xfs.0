Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50395 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbeLRKUJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 05:20:09 -0500
Received: by mail-wm1-f66.google.com with SMTP id n190so2075849wmd.0
        for <linux-xfs@vger.kernel.org>; Tue, 18 Dec 2018 02:20:06 -0800 (PST)
Received: from [192.168.0.186] ([89.216.104.84])
        by smtp.gmail.com with ESMTPSA id c8sm1797151wrx.42.2018.12.18.02.20.04
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Dec 2018 02:20:04 -0800 (PST)
From: Predrag Mijatovic <predmijat@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: XFS metadata corruption
Message-Id: <93641AD9-AD79-4400-8C7F-14C5D7746709@gmail.com>
Date: Tue, 18 Dec 2018 11:20:03 +0100
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

Few days ago my XFS filesystem broke. I have two kernels on my system - =
3.10 installed from default repo and 4.18 installed from "elrepo". 4.18 =
was active, but when I ran 'yum update', new 3.10 was installed, was =
automatically set as default and was active after the reboot. Not so =
long after, XFS broke.

dmesg output:

[683670.924618] XFS (sdc): Internal error XFS_WANT_CORRUPTED_RETURN at =
line 212 of file fs/xfs/libxfs/xfs_dir2_data.c.  Caller =
xfs_dir3_block_verify+0x9a/0xb0 [xfs]
[683670.924665] CPU: 3 PID: 5855 Comm: xfsaild/sdc Kdump: loaded Not =
tainted 3.10.0-957.1.3.el7.x86_64 #1
[683670.924666] Hardware name: Gigabyte Technology Co., Ltd. =
B85M-D3H/B85M-D3H, BIOS F15 08/20/2015
[683670.924667] Call Trace:
[683670.924673]  [<ffffffff86561e41>] dump_stack+0x19/0x1b
[683670.924685]  [<ffffffffc0548a1b>] xfs_error_report+0x3b/0x40 [xfs]
[683670.924695]  [<ffffffffc052834a>] ? xfs_dir3_block_verify+0x9a/0xb0 =
[xfs]
[683670.924704]  [<ffffffffc052a6b9>] __xfs_dir3_data_check+0x4b9/0x5d0 =
[xfs]
[683670.924713]  [<ffffffffc052834a>] xfs_dir3_block_verify+0x9a/0xb0 =
[xfs]
[683670.924733]  [<ffffffffc0528541>] =
xfs_dir3_block_write_verify+0x31/0xc0 [xfs]
[683670.924746]  [<ffffffffc05462a8>] ? =
xfs_buf_delwri_submit_buffers+0x128/0x230 [xfs]
[683670.924757]  [<ffffffffc05441b7>] _xfs_buf_ioapply+0x97/0x460 [xfs]
[683670.924761]  [<ffffffff85ed67b0>] ? wake_up_state+0x20/0x20
[683670.924771]  [<ffffffffc05462a8>] ? =
xfs_buf_delwri_submit_buffers+0x128/0x230 [xfs]
[683670.924780]  [<ffffffffc0545fcc>] xfs_buf_submit+0x6c/0x220 [xfs]
[683670.924789]  [<ffffffffc05462a8>] =
xfs_buf_delwri_submit_buffers+0x128/0x230 [xfs]
[683670.924798]  [<ffffffffc05470c0>] ? =
xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
[683670.924811]  [<ffffffffc0575c60>] ? =
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[683670.924821]  [<ffffffffc05470c0>] =
xfs_buf_delwri_submit_nowait+0x10/0x20 [xfs]
[683670.924833]  [<ffffffffc0575ebf>] xfsaild+0x25f/0x6f0 [xfs]
[683670.924844]  [<ffffffffc0575c60>] ? =
xfs_trans_ail_cursor_first+0x90/0x90 [xfs]
[683670.924847]  [<ffffffff85ec1c31>] kthread+0xd1/0xe0
[683670.924849]  [<ffffffff85ec1b60>] ? insert_kthread_work+0x40/0x40
[683670.924853]  [<ffffffff86574c37>] =
ret_from_fork_nospec_begin+0x21/0x21
[683670.924854]  [<ffffffff85ec1b60>] ? insert_kthread_work+0x40/0x40
[683670.924865] XFS (sdc): Metadata corruption detected at =
xfs_dir3_block_write_verify+0xad/0xc0 [xfs], xfs_dir3_block block =
0x3805e7460
[683670.924898] XFS (sdc): Unmount and run xfs_repair
[683670.924910] XFS (sdc): First 64 bytes of corrupted metadata buffer:
[683670.924926] ffff89b0e6229000: 58 44 42 33 00 00 00 00 00 00 00 03 80 =
5e 74 60  XDB3.........^t`
[683670.924947] ffff89b0e6229010: 00 00 00 00 00 00 00 00 00 b6 f1 bc 1c =
b5 45 37  ..............E7
[683670.924968] ffff89b0e6229020: 92 a7 a1 c2 eb e6 f0 f9 00 00 00 03 90 =
92 b5 88  ................
[683670.924989] ffff89b0e6229030: 00 60 0e f0 00 00 00 00 00 00 00 00 00 =
00 00 00  .`..............
[683670.925011] XFS (sdc): xfs_do_force_shutdown(0x8) called from line =
1419 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffffc05441e7
[683670.926840] XFS (sdc): Corruption of in-memory data detected.  =
Shutting down filesystem
[683670.926872] XFS (sdc): Please umount the filesystem and rectify the =
problem(s)
[683670.946707] XFS (sdc): xfs_imap_to_bp: xfs_trans_read_buf() returned =
error -5.

Is this kernel mixup the reason for it? How do I avoid it? I want to use =
elrepo as primary.
If kernel mixup isn't the reason, does this log says what it was? :)

Thanks!
