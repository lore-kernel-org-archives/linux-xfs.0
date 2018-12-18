Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55583 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbeLRU0u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Dec 2018 15:26:50 -0500
Received: by mail-wm1-f68.google.com with SMTP id y139so3906820wmc.5
        for <linux-xfs@vger.kernel.org>; Tue, 18 Dec 2018 12:26:49 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: XFS metadata corruption
From: Predrag Mijatovic <predmijat@gmail.com>
In-Reply-To: <5fe33e22-e034-db8c-f62d-8124e731c5dd@sandeen.net>
Date: Tue, 18 Dec 2018 21:26:45 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <6E2E81FA-9677-4385-9ADF-46E06B6F5150@gmail.com>
References: <93641AD9-AD79-4400-8C7F-14C5D7746709@gmail.com> <5fe33e22-e034-db8c-f62d-8124e731c5dd@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

It=E2=80=99s a 12T partition so it will take a while (plus I can=E2=80=99t s=
tart it before tomorrow morning)

> On Dec 18, 2018, at 5:41 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>=20
>> On 12/18/18 4:20 AM, Predrag Mijatovic wrote:
>> Hi,
>>=20
>> Few days ago my XFS filesystem broke. I have two kernels on my system - 3=
.10 installed from default repo and 4.18 installed from "elrepo". 4.18 was a=
ctive, but when I ran 'yum update', new 3.10 was installed, was automaticall=
y set as default and was active after the reboot. Not so long after, XFS bro=
ke.
>>=20
>> dmesg output:
>=20
> The condition that it tripped was in __xfs_dir3_data_check():
>=20
>                XFS_WANT_CORRUPTED_RETURN(mp, count =3D=3D
>                        be32_to_cpu(btp->count) - be32_to_cpu(btp->stale));=

>=20
> but I don't think I've seen any other reports of that problem.  The dumped=
-out
> buffer does at least look like a dir3 block.
>=20
> Any chance you could make an xfs_metadump image of this filesystem, compre=
ss it,
> and provide it to me off-list?
>=20
> -Eric
>=20
>> [683670.924618] XFS (sdc): Internal error XFS_WANT_CORRUPTED_RETURN at li=
ne 212 of file fs/xfs/libxfs/xfs_dir2_data.c.  Caller xfs_dir3_block_verify+=
0x9a/0xb0 [xfs]
>> [683670.924665] CPU: 3 PID: 5855 Comm: xfsaild/sdc Kdump: loaded Not tain=
ted 3.10.0-957.1.3.el7.x86_64 #1
>> [683670.924666] Hardware name: Gigabyte Technology Co., Ltd. B85M-D3H/B85=
M-D3H, BIOS F15 08/20/2015
>> [683670.924667] Call Trace:
>> [683670.924673]  [<ffffffff86561e41>] dump_stack+0x19/0x1b
>> [683670.924685]  [<ffffffffc0548a1b>] xfs_error_report+0x3b/0x40 [xfs]
>> [683670.924695]  [<ffffffffc052834a>] ? xfs_dir3_block_verify+0x9a/0xb0 [=
xfs]
>> [683670.924704]  [<ffffffffc052a6b9>] __xfs_dir3_data_check+0x4b9/0x5d0 [=
xfs]
>> [683670.924713]  [<ffffffffc052834a>] xfs_dir3_block_verify+0x9a/0xb0 [xf=
s]
>> [683670.924733]  [<ffffffffc0528541>] xfs_dir3_block_write_verify+0x31/0x=
c0 [xfs]
>> [683670.924746]  [<ffffffffc05462a8>] ? xfs_buf_delwri_submit_buffers+0x1=
28/0x230 [xfs]
>> [683670.924757]  [<ffffffffc05441b7>] _xfs_buf_ioapply+0x97/0x460 [xfs]
>> [683670.924761]  [<ffffffff85ed67b0>] ? wake_up_state+0x20/0x20
>> [683670.924771]  [<ffffffffc05462a8>] ? xfs_buf_delwri_submit_buffers+0x1=
28/0x230 [xfs]
>> [683670.924780]  [<ffffffffc0545fcc>] xfs_buf_submit+0x6c/0x220 [xfs]
>> [683670.924789]  [<ffffffffc05462a8>] xfs_buf_delwri_submit_buffers+0x128=
/0x230 [xfs]
>> [683670.924798]  [<ffffffffc05470c0>] ? xfs_buf_delwri_submit_nowait+0x10=
/0x20 [xfs]
>> [683670.924811]  [<ffffffffc0575c60>] ? xfs_trans_ail_cursor_first+0x90/0=
x90 [xfs]
>> [683670.924821]  [<ffffffffc05470c0>] xfs_buf_delwri_submit_nowait+0x10/0=
x20 [xfs]
>> [683670.924833]  [<ffffffffc0575ebf>] xfsaild+0x25f/0x6f0 [xfs]
>> [683670.924844]  [<ffffffffc0575c60>] ? xfs_trans_ail_cursor_first+0x90/0=
x90 [xfs]
>> [683670.924847]  [<ffffffff85ec1c31>] kthread+0xd1/0xe0
>> [683670.924849]  [<ffffffff85ec1b60>] ? insert_kthread_work+0x40/0x40
>> [683670.924853]  [<ffffffff86574c37>] ret_from_fork_nospec_begin+0x21/0x2=
1
>> [683670.924854]  [<ffffffff85ec1b60>] ? insert_kthread_work+0x40/0x40
>> [683670.924865] XFS (sdc): Metadata corruption detected at xfs_dir3_block=
_write_verify+0xad/0xc0 [xfs], xfs_dir3_block block 0x3805e7460
>> [683670.924898] XFS (sdc): Unmount and run xfs_repair
>> [683670.924910] XFS (sdc): First 64 bytes of corrupted metadata buffer:
>> [683670.924926] ffff89b0e6229000: 58 44 42 33 00 00 00 00 00 00 00 03 80 5=
e 74 60  XDB3.........^t`
>> [683670.924947] ffff89b0e6229010: 00 00 00 00 00 00 00 00 00 b6 f1 bc 1c b=
5 45 37  ..............E7
>> [683670.924968] ffff89b0e6229020: 92 a7 a1 c2 eb e6 f0 f9 00 00 00 03 90 9=
2 b5 88  ................
>> [683670.924989] ffff89b0e6229030: 00 60 0e f0 00 00 00 00 00 00 00 00 00 0=
0 00 00  .`..............
>> [683670.925011] XFS (sdc): xfs_do_force_shutdown(0x8) called from line 14=
19 of file fs/xfs/xfs_buf.c.  Return address =3D 0xffffffffc05441e7
>> [683670.926840] XFS (sdc): Corruption of in-memory data detected.  Shutti=
ng down filesystem
>> [683670.926872] XFS (sdc): Please umount the filesystem and rectify the p=
roblem(s)
>> [683670.946707] XFS (sdc): xfs_imap_to_bp: xfs_trans_read_buf() returned e=
rror -5.
>>=20
>> Is this kernel mixup the reason for it? How do I avoid it? I want to use e=
lrepo as primary.
>> If kernel mixup isn't the reason, does this log says what it was? :)
>>=20
>> Thanks!
>>=20
