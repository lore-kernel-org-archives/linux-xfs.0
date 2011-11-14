Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEEasuT213873 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 08:36:54 -0600
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EFEAC1E9BA8B
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 06:36:52 -0800 (PST)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	4EqpYZtHgzmTDULM for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 06:36:52 -0800 (PST)
Received: by gyd10 with SMTP id 10so6669169gyd.26
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 06:36:52 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 14 Nov 2011 15:36:51 +0100
Message-ID: <CAFhwj5=N_yLUxthheD8+3bYO8UTxJgHujZJLe73NFJZqtWqU1A@mail.gmail.com>
Subject: XFS with project quota support in Kernel 2.6.28(.9)
From: Maarten Vergouwe <Maarten.Vergouwe@tass.be>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3458291112211966871=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3458291112211966871==
Content-Type: multipart/alternative; boundary=f46d04190c6c35061d04b1b2cd6f

--f46d04190c6c35061d04b1b2cd6f
Content-Type: text/plain; charset=ISO-8859-1

Hi

I have problems in writes that hang for more than 7 seconds because of the
the kthreadd daemon keeping a mutex locked for too long.
Is there someone who might be able to help me with that?
I saw that a lot of changes were done on the XFS quota support in later
kernels, but the patch list is too long between my kernel and the changed
quota system.

process 411 ([khubd], kthreadd)
  pid = 411, tgid = 411, parent = 2, real parent = 2
  baduaddr = 0x00000000, badvaddr = 0x00000000, state = 2, flags =
0x80208040
  policy = 0, prio = 115, static prio = 115, normal prio = 115, rt prio = 0
  pc = vmlinux_flash.elf/context_switch+0x3ac (kernel/sched.c:2668)
                schedule (kernel/sched.c:4496)
  kernel stack
    vmlinux_flash.elf/schedule_timeout+0x24 (kernel/timer.c:1264)
    vmlinux_flash.elf/do_wait_for_common+0xd8 (kernel/sched.c:4715)
                wait_for_common (kernel/sched.c:4732)
    vmlinux_flash.elf/xfs_qm_sync+0x110 (fs/xfs/quota/xfs_qm.c:1076)
    vmlinux_flash.elf/xfs_sync+0x1c (fs/xfs/xfs_vfsops.c:255)
    vmlinux_flash.elf/xfs_fs_sync_super+0x3c
(fs/xfs/linux-2.6/xfs_super.c:1202)
    vmlinux_flash.elf/fsync_super+0xc (fs/super.c:270)


process 1082 *(this one takes too long and my watchdog doesn't like that)*
  pid = 1082, tgid = 230, parent = 228, real parent = 228
  baduaddr = 0x00000000, badvaddr = 0x00000000, state = 2, flags =
0x00422140
  policy = 0, prio = 120, static prio = 120, normal prio = 120, rt prio = 0
  pc = vmlinux_flash.elf/context_switch+0x3ac (kernel/sched.c:2668)
                schedule (kernel/sched.c:4496)
  kernel stack
    vmlinux_flash.elf/__mutex_lock_common+0x108 (kernel/mutex.c:182)
                __mutex_lock_slowpath (kernel/mutex.c:321)
    vmlinux_flash.elf/xfs_trans_dqresv+0x50
(fs/xfs/quota/xfs_trans_dquot.c:628)
    vmlinux_flash.elf/xfs_trans_reserve_quota_bydquots+0xc0
(fs/xfs/quota/xfs_trans_dquot.c:792)
    vmlinux_flash.elf/xfs_trans_reserve_quota_nblks+0x40
(fs/xfs/quota/xfs_trans_dquot.c:847)
    vmlinux_flash.elf/xfs_iomap_write_direct+0x36c (fs/xfs/xfs_iomap.c:486)
    vmlinux_flash.elf/xfs_iomap+0x250 (fs/xfs/xfs_iomap.c:247)
    vmlinux_flash.elf/__xfs_get_blocks+0xb8
(fs/xfs/linux-2.6/xfs_aops.c:1345)
    vmlinux_flash.elf/xfs_get_blocks_direct+0x14
(fs/xfs/linux-2.6/xfs_aops.c:1426)
    vmlinux_flash.elf/get_more_blocks+0x54c (fs/direct-io.c:535)
                do_direct_IO (fs/direct-io.c:816)
                direct_io_worker (fs/direct-io.c:998)
                __blockdev_direct_IO (fs/direct-io.c:1209)
    vmlinux_flash.elf/blockdev_direct_IO_no_locking+0xf0
(include/linux/fs.h:2010)
                xfs_vm_direct_IO (fs/xfs/linux-2.6/xfs_aops.c:1506)
    vmlinux_flash.elf/generic_file_direct_write+0x148 (mm/filemap.c:2102)
    vmlinux_flash.elf/xfs_write+0x460 (fs/xfs/linux-2.6/xfs_lrw.c:745)
    vmlinux_flash.elf/do_sync_write+0xc8 (fs/read_write.c:305)
    vmlinux_flash.elf/sys_write+0x50 (fs/read_write.c:386)
    vmlinux_flash.elf/stack_done+0xdc (arch/mips/kernel/scall32-o32.S:59)


Best regards

Maarten Vergouwe
TASS Belgium

--f46d04190c6c35061d04b1b2cd6f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>Hi</div><div><br></div><div>I have problems in writes that hang for mo=
re than 7 seconds because of the the kthreadd daemon keeping a mutex locked=
 for too long.</div><div>Is there someone who might be able to help me with=
 that?</div>
<div>I saw that a lot of changes were done on the XFS quota support in late=
r kernels, but the patch list is too long between my kernel and the changed=
 quota system.</div><div><br></div><div>process 411 ([khubd], kthreadd)</di=
v>
<div>=A0 pid =3D 411, tgid =3D 411, parent =3D 2, real parent =3D 2</div><d=
iv>=A0 baduaddr =3D 0x00000000, badvaddr =3D 0x00000000, state =3D 2, flags=
 =3D 0x80208040</div><div>=A0 policy =3D 0, prio =3D 115, static prio =3D 1=
15, normal prio =3D 115, rt prio =3D 0</div>
<div>=A0 pc =3D vmlinux_flash.elf/context_switch+0x3ac (kernel/sched.c:2668=
)</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule (kernel/sched.c:4496)<=
/div><div>=A0 kernel stack</div><div>=A0 =A0 vmlinux_flash.elf/schedule_tim=
eout+0x24 (kernel/timer.c:1264)</div>
<div>=A0 =A0 vmlinux_flash.elf/do_wait_for_common+0xd8 (kernel/sched.c:4715=
)</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wait_for_common (kernel/sched.c=
:4732)</div><div>=A0 =A0 vmlinux_flash.elf/xfs_qm_sync+0x110 (fs/xfs/quota/=
xfs_qm.c:1076)</div>
<div>=A0 =A0 vmlinux_flash.elf/xfs_sync+0x1c (fs/xfs/xfs_vfsops.c:255)</div=
><div>=A0 =A0 vmlinux_flash.elf/xfs_fs_sync_super+0x3c (fs/xfs/linux-2.6/xf=
s_super.c:1202)</div><div>=A0 =A0 vmlinux_flash.elf/fsync_super+0xc (fs/sup=
er.c:270)</div>
<div><br></div><div><br></div><div><div>process 1082 <b>(this one takes too=
 long and my watchdog doesn&#39;t like that)</b></div><div>=A0 pid =3D 1082=
, tgid =3D 230, parent =3D 228, real parent =3D 228</div><div>=A0 baduaddr =
=3D 0x00000000, badvaddr =3D 0x00000000, state =3D 2, flags =3D 0x00422140<=
/div>
<div>=A0 policy =3D 0, prio =3D 120, static prio =3D 120, normal prio =3D 1=
20, rt prio =3D 0</div><div>=A0 pc =3D vmlinux_flash.elf/context_switch+0x3=
ac (kernel/sched.c:2668)</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule=
 (kernel/sched.c:4496)</div>
<div>=A0 kernel stack</div><div>=A0 =A0 vmlinux_flash.elf/__mutex_lock_comm=
on+0x108 (kernel/mutex.c:182)</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __m=
utex_lock_slowpath (kernel/mutex.c:321)</div><div>=A0 =A0 vmlinux_flash.elf=
/xfs_trans_dqresv+0x50 (fs/xfs/quota/xfs_trans_dquot.c:628)</div>
<div>=A0 =A0 vmlinux_flash.elf/xfs_trans_reserve_quota_bydquots+0xc0 (fs/xf=
s/quota/xfs_trans_dquot.c:792)</div><div>=A0 =A0 vmlinux_flash.elf/xfs_tran=
s_reserve_quota_nblks+0x40 (fs/xfs/quota/xfs_trans_dquot.c:847)</div><div>=
=A0 =A0 vmlinux_flash.elf/xfs_iomap_write_direct+0x36c (fs/xfs/xfs_iomap.c:=
486)</div>
<div>=A0 =A0 vmlinux_flash.elf/xfs_iomap+0x250 (fs/xfs/xfs_iomap.c:247)</di=
v><div>=A0 =A0 vmlinux_flash.elf/__xfs_get_blocks+0xb8 (fs/xfs/linux-2.6/xf=
s_aops.c:1345)</div><div>=A0 =A0 vmlinux_flash.elf/xfs_get_blocks_direct+0x=
14 (fs/xfs/linux-2.6/xfs_aops.c:1426)</div>
<div>=A0 =A0 vmlinux_flash.elf/get_more_blocks+0x54c (fs/direct-io.c:535)</=
div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 do_direct_IO (fs/direct-io.c:816)<=
/div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 direct_io_worker (fs/direct-io.c:=
998)</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __blockdev_direct_IO (fs/dir=
ect-io.c:1209)</div>
<div>=A0 =A0 vmlinux_flash.elf/blockdev_direct_IO_no_locking+0xf0 (include/=
linux/fs.h:2010)</div><div>=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 xfs_vm_direct_IO=
 (fs/xfs/linux-2.6/xfs_aops.c:1506)</div><div>=A0 =A0 vmlinux_flash.elf/gen=
eric_file_direct_write+0x148 (mm/filemap.c:2102)</div>
<div>=A0 =A0 vmlinux_flash.elf/xfs_write+0x460 (fs/xfs/linux-2.6/xfs_lrw.c:=
745)</div><div>=A0 =A0 vmlinux_flash.elf/do_sync_write+0xc8 (fs/read_write.=
c:305)</div><div>=A0 =A0 vmlinux_flash.elf/sys_write+0x50 (fs/read_write.c:=
386)</div>
<div>=A0 =A0 vmlinux_flash.elf/stack_done+0xdc (arch/mips/kernel/scall32-o3=
2.S:59)</div></div><div><br></div><div><br></div><div>Best regards</div><di=
v><br></div><div>Maarten Vergouwe</div><div>TASS Belgium</div>

--f46d04190c6c35061d04b1b2cd6f--


--===============3458291112211966871==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3458291112211966871==--
