Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C59DA7FFF
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 16:40:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 38398AC00F
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 14:40:42 -0700 (PDT)
Received: from mail-vc0-f175.google.com (mail-vc0-f175.google.com
	[209.85.220.175]) by cuda.sgi.com with ESMTP id
	DsLUsckxNxiDFUhf (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 14:40:39 -0700 (PDT)
Received: by mail-vc0-f175.google.com with SMTP id lh14so3549862vcb.6
	for <xfs@oss.sgi.com>; Fri, 04 Apr 2014 14:40:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140404212016.GY17603@dastard>
References: <CALjwKZAJ-R8dS13Rsj3+K3hM9p0z08qvi4ZVTYbDWKT1Biu=-Q@mail.gmail.com>
	<20140404212016.GY17603@dastard>
Date: Fri, 4 Apr 2014 15:40:38 -0600
Message-ID: <CALjwKZCsBbZ27DE4m=-jN7yWPCqn=QxNgtZZpUcdFvfCPvH5tw@mail.gmail.com>
Subject: Re: xfs umount with i/o error hang/memory corruption
From: Bob Mastors <bob.mastors@solidfire.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7883166664055787948=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

--===============7883166664055787948==
Content-Type: multipart/alternative; boundary=047d7bd6c21a6436c404f63e5edd

--047d7bd6c21a6436c404f63e5edd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 4, 2014 at 3:20 PM, Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Apr 04, 2014 at 12:15:23PM -0600, Bob Mastors wrote:
> > Greetings,
> >
> > I am new to xfs and am running into a problem
> > and would appreciate any guidance on how to proceed.
> >
> > After an i/o error from the block device that xfs is using,
> > an umount results in a message like:
> > [  370.636473] XFS (sdx): Log I/O Error Detected.  Shutting down
> filesystem
> > [  370.644073] XFS (h           =EF=BF=BD=EF=BF=BD=EF=BF=BDh"h         =
 =EF=BF=BD=EF=BF=BD=EF=BF=BDH#h          =EF=BF=BD=EF=BF=BD=EF=BF=BDbsg):
> > Please umount the filesystem and rectify the problem(s)
> > Note the garbage on the previous line which suggests memory corruption.
> > About half the time I get the garbled log message. About half the time
> > umount hangs.
>
> I got an email about this last night with a different trigger - thin
> provisioning failing log IO in the unmount path. I know what the
> problem is, I just don't have a fix for it yet.
>
> To confirm it's the same problem, can you post the entirity of the
> dmesg where the error occurs?
>
Here is the console output from putting a BUG() call  in
xfs_do_force_shutdown
after the "Please umount ..." message.
Let me know if want something else.

I don't know how much help I can be on this, but I can run more tests
or try out fixes.

Thanks,
Bob

[  111.004665] XFS (sdb): Mounting Filesystem
[  111.099442] XFS (sdb): Ending clean mount
[  129.548644] XFS (sdb): metadata I/O error: block 0x19022 ("xlog_iodone")
error 19 numblks 64
[  129.618739] XFS (sdb): xfs_do_force_shutdown(0x2) called from line 1170
of file fs/xfs/xfs_log.c.  Return address =3D 0xffffffffa04c8001
[  129.699768] XFS (sdb): Log I/O Error Detected.  Shutting down filesystem
[  129.699924] XFS (sdb): Unable to update superblock counters. Freespace
may not be correct on next mount.
[  129.699927] XFS (sdb): xfs_log_force: error 5 returned.
[  129.716031] XFS (P=E5=B0=82/): Please umount the filesystem and rectify =
the
problem(s)
[  129.718411] ------------[ cut here ]------------
[  129.719120] Kernel BUG at ffffffffa04726ac [verbose debug info
unavailable]
[  129.720016] invalid opcode: 0000 [#1] SMP
[  129.720016] Modules linked in: xfs(F) libcrc32c ib_srpt tcm_qla2xxx
qla2xxx tcm_loop tcm_fc libfc scsi_transport_fc scsi_tgt iscsi_target_mod
target_core_pscsi target_core_file target_core_iblock target_core_mod
configfs ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi nfsd nfs_acl nfs lockd fscac\
he sunrpc snd_intel8x0 snd_ac97_codec parport_pc parport ac97_bus snd_pcm
psmouse snd_timer serio_raw snd joydev evbug mac_hid pcspkr i2c_piix4
soundcore hid_generic usbhid hid e1000 ahci libahci
[  129.720016] CPU: 1 PID: 234 Comm: kworker/1:1H Tainted: GF
 3.14.0+ #1
[  129.720016] Hardware name: innotek GmbH VirtualBox, BIOS VirtualBox
12/01/2006
[  129.720016] Workqueue: xfslogd xfs_buf_iodone_work [xfs]
[  129.720016] task: ffff88002f598000 ti: ffff88002fecc000 task.ti:
ffff88002fecc000
[  129.720016] RIP: 0010:[<ffffffffa04726ac>]  [<ffffffffa04726ac>]
xfs_do_force_shutdown+0x9c/0x170 [xfs]
[  129.720016] RSP: 0018:ffff88002fecdd68  EFLAGS: 00010296
[  129.720016] RAX: 0000000000000043 RBX: 0000000000000002 RCX:
0000000000000000
[  129.720016] RDX: ffff88003fd0efb0 RSI: ffff88003fd0d3d8 RDI:
ffff88003fd0d3d8
[  129.720016] RBP: ffff88002fecdd98 R08: 0000000000000000 R09:
0000000000000000
[  129.720016] R10: 00000000000001cf R11: 00000000000001ce R12:
ffff880028865000
[  129.720016] R13: 0000000000000002 R14: 0000000000000000 R15:
0000000000000000
[  129.720016] FS:  0000000000000000(0000) GS:ffff88003fd00000(0000)
knlGS:0000000000000000
[  129.720016] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  129.720016] CR2: 00000000006105e8 CR3: 0000000001c0e000 CR4:
00000000000006e0
[  129.720016] Stack:
[  129.720016]  ffffffffa04c8001 0000000000000000 ffff880030140300
ffff88003026dc00
[  129.720016]  ffff88002fa13980 0000000000000000 ffff88002fecddc8
ffffffffa04c8001
[  129.720016]  ffff88003653cf48 ffff88002fa13a20 ffff88002fa13980
ffffe8ffffd01e00
[  129.720016] Call Trace:
[  129.720016]  [<ffffffffa04c8001>] ? xlog_iodone+0x91/0xa0 [xfs]
[  129.720016]  [<ffffffffa04c8001>] xlog_iodone+0x91/0xa0 [xfs]
[  129.720016]  [<ffffffffa046ac3e>] xfs_buf_iodone_work+0x5e/0xc0 [xfs]
[  129.720016]  [<ffffffff8106ad04>] process_one_work+0x174/0x4a0
[  129.720016]  [<ffffffff8106c0ab>] worker_thread+0x11b/0x370
[  129.720016]  [<ffffffff8106bf90>] ? manage_workers.isra.20+0x2d0/0x2d0
[  129.720016]  [<ffffffff81072c29>] kthread+0xc9/0xe0
[  129.720016]  [<ffffffff81072b60>] ? flush_kthread_worker+0xb0/0xb0
[  129.720016]  [<ffffffff816d6aec>] ret_from_fork+0x7c/0xb0
[  129.720016]  [<ffffffff81072b60>] ? flush_kthread_worker+0xb0/0xb0
[  129.720016] Code: d0 45 85 ed 0f 85 a5 00 00 00 f6 c3 20 66 90 75 7e 83
e3 10 0f 84 b5 00 00 00 48 c7 c6 18 8c 4e a0 4c 89 e7 31 c0 e8 54 92 00 00
<0f> 0b 66 90 48 8b 45 08 49 89 d1 41 89 c8 48 c7 c2 d0 4f 4e a0
[  129.720016] RIP  [<ffffffffa04726ac>] xfs_do_force_shutdown+0x9c/0x170
[xfs]
[  129.720016]  RSP <ffff88002fecdd68>
[  129.777164] ---[ end trace d335180e3c345156 ]---
[  129.777953] BUG: unable to handle kernel paging request at
ffffffffffffffd8
[  129.779087] IP: [<ffffffff81072c80>] kthread_data+0x10/0x20
[  129.779960] PGD 1c0f067 PUD 1c11067 PMD 0
[  129.780900] Oops: 0000 [#2] SMP
[  129.781150] Modules linked in: xfs(F) libcrc32c ib_srpt tcm_qla2xxx
qla2xxx tcm_loop tcm_fc libfc scsi_transport_fc scsi_tgt iscsi_target_mod
target_core_pscsi target_core_file target_core_iblock target_core_mod
configfs ib_iser rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp
libiscsi_tcp libiscsi scsi_transport_iscsi nfsd nfs_acl nfs lockd fscac\
he sunrpc snd_intel8x0 snd_ac97_codec parport_pc parport ac97_bus snd_pcm
psmouse snd_timer serio_raw snd joydev evbug mac_hid pcspkr i2c_piix4
soundcore hid_generic usbhid hid e1000 ahci libahci
[  129.781150] CPU: 1 PID: 234 Comm: kworker/1:1H Tainted: GF     D
 3.14.0+ #1
[  129.781150] Hardware name: innotek GmbH VirtualBox, BIOS VirtualBox
12/01/2006
[  129.781150] task: ffff88002f598000 ti: ffff88002fecc000 task.ti:
ffff88002fecc000
[  129.781150] RIP: 0010:[<ffffffff81072c80>]  [<ffffffff81072c80>]
kthread_data+0x10/0x20
[  129.781150] RSP: 0018:ffff88002fecd9f8  EFLAGS: 00010046
[  129.781150] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffffff81e75380
[  129.781150] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
ffff88002f598000
[  129.781150] RBP: ffff88002fecd9f8 R08: 0000000000000000 R09:
0000000000000164
[  129.781150] R10: ffffffff8104c8b4 R11: 0000000000000000 R12:
0000000000000001
[  129.781150] R13: ffff88002f5984e0 R14: ffff88003d9f8000 R15:
ffff88002f5983d8
[  129.781150] FS:  0000000000000000(0000) GS:ffff88003fd00000(0000)
knlGS:0000000000000000
[  129.781150] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  129.781150] CR2: 0000000000000028 CR3: 0000000001c0e000 CR4:
00000000000006e0
[  129.781150] Stack:
[  129.781150]  ffff88002fecda18 ffffffff8106c526 ffff88003fd13140
0000000000000001
[  129.781150]  ffff88002fecda98 ffffffff816ca7cf 0000000000000001
ffff88002f598000
[  129.781150]  ffff88002f598000 0000000000013140 ffff88002fecdfd8
0000000000013140
[  129.781150] Call Trace:
[  129.781150]  [<ffffffff8106c526>] wq_worker_sleeping+0x16/0xa0
[  129.781150]  [<ffffffff816ca7cf>] __schedule+0x56f/0x7c0
[  129.781150]  [<ffffffff816caaf9>] schedule+0x29/0x70
[  129.781150]  [<ffffffff81052075>] do_exit+0x6e5/0xa70
[  129.781150]  [<ffffffff816c2303>] ? printk+0x4d/0x4f
[  129.781150]  [<ffffffff816cf0e1>] oops_end+0xa1/0xf0
[  129.781150]  [<ffffffff81006208>] die+0x58/0x90
[  129.781150]  [<ffffffff816ce93b>] do_trap+0xcb/0x170
[  129.781150]  [<ffffffff8100308d>] do_invalid_op+0xad/0x100
[  129.781150]  [<ffffffffa04726ac>] ? xfs_do_force_shutdown+0x9c/0x170
[xfs]
[  129.781150]  [<ffffffff816c2303>] ? printk+0x4d/0x4f
[  129.781150]  [<ffffffff816d8088>] invalid_op+0x18/0x20
[  129.781150]  [<ffffffffa04726ac>] ? xfs_do_force_shutdown+0x9c/0x170
[xfs]
[  129.781150]  [<ffffffffa04726ac>] ? xfs_do_force_shutdown+0x9c/0x170
[xfs]
[  129.781150]  [<ffffffffa04c8001>] ? xlog_iodone+0x91/0xa0 [xfs]
[  129.781150]  [<ffffffffa04c8001>] xlog_iodone+0x91/0xa0 [xfs]
[  129.781150]  [<ffffffffa046ac3e>] xfs_buf_iodone_work+0x5e/0xc0 [xfs]
[  129.781150]  [<ffffffff8106ad04>] process_one_work+0x174/0x4a0
[  129.781150]  [<ffffffff8106c0ab>] worker_thread+0x11b/0x370
[  129.781150]  [<ffffffff8106bf90>] ? manage_workers.isra.20+0x2d0/0x2d0
[  129.781150]  [<ffffffff81072c29>] kthread+0xc9/0xe0
[  129.781150]  [<ffffffff81072b60>] ? flush_kthread_worker+0xb0/0xb0
[  129.781150]  [<ffffffff816d6aec>] ret_from_fork+0x7c/0xb0
[  129.781150]  [<ffffffff81072b60>] ? flush_kthread_worker+0xb0/0xb0
[  129.781150] Code: 00 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 88 04 00 00 55 48 89 e5
<48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00
[  129.781150] RIP  [<ffffffff81072c80>] kthread_data+0x10/0x20
[  129.781150]  RSP <ffff88002fecd9f8>
[  129.781150] CR2: ffffffffffffffd8
[  129.781150] ---[ end trace d335180e3c345157 ]---
[  129.781150] Fixing recursive fault but reboot is needed!


> In essence, the log IO failure is triggering a shutdown, and as part
> of the shutdown process it wakes anyone waiting on a log force.
> The log quiesce code that waits for log completion during unmount
> uses a log force to ensure the log is idle before tearing down all
> the log structures and finishing the unmount. Unfortunatey, the log
> force the unmount blocks on is woken prematurely by the shutdown,
> and hence it runs before the log IO processing is completed. Hence
> the use after free.
>
> > And then I get this kind of error and the system is unresponsive:
> > Message from syslogd@debian at Apr  4 09:27:40 ...
> >  kernel:[  680.080022] BUG: soft lockup - CPU#2 stuck for 22s!
> [umount:2849]
> >
> > The problem appears to be similar to this issue:
> > http://www.spinics.net/lists/linux-xfs/msg00061.html
>
> Similar symptoms, but not the same bug.
>
> > The problem is triggered by doing an iscsi logout which causes
> > the block device to return i/o errors to xfs.
> > Steps to reproduce the problem are below.
>
> Seems similar to the thinp ENOSPC issue I mentioned above - data IO
> errors occur, then you do an unmount, which causes a log IO error
> writing the superblock, and then this happens....
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>

--047d7bd6c21a6436c404f63e5edd
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote">On F=
ri, Apr 4, 2014 at 3:20 PM, Dave Chinner <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:david@fromorbit.com" target=3D"_blank">david@fromorbit.com</a>&gt;</s=
pan> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D"">On Fri, Apr 04, 2014 at 12:15:23PM -0600, =
Bob Mastors wrote:<br>

&gt; Greetings,<br>
&gt;<br>
&gt; I am new to xfs and am running into a problem<br>
&gt; and would appreciate any guidance on how to proceed.<br>
&gt;<br>
&gt; After an i/o error from the block device that xfs is using,<br>
&gt; an umount results in a message like:<br>
&gt; [ =C2=A0370.636473] XFS (sdx): Log I/O Error Detected. =C2=A0Shutting =
down filesystem<br>
&gt; [ =C2=A0370.644073] XFS (h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =EF=BF=
=BD=EF=BF=BD=EF=BF=BDh&quot;h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=EF=BF=BD=
=EF=BF=BD=EF=BF=BDH#h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=EF=BF=BD=EF=BF=BD=
=EF=BF=BDbsg):<br>
&gt; Please umount the filesystem and rectify the problem(s)<br>
&gt; Note the garbage on the previous line which suggests memory corruption=
.<br>
&gt; About half the time I get the garbled log message. About half the time=
<br>
&gt; umount hangs.<br>
<br>
</div>I got an email about this last night with a different trigger - thin<=
br>
provisioning failing log IO in the unmount path. I know what the<br>
problem is, I just don&#39;t have a fix for it yet.<br>
<br>
To confirm it&#39;s the same problem, can you post the entirity of the<br>
dmesg where the error occurs?<br></blockquote><div>Here is the console outp=
ut from putting a BUG() call =C2=A0in xfs_do_force_shutdown</div><div>after=
 the &quot;Please umount ...&quot; message.</div><div>Let me know if want s=
omething else.</div>
<div><br></div><div>I don&#39;t know how much help I can be on this, but I =
can run more tests</div><div>or try out fixes.</div><div><br></div><div>Tha=
nks,</div><div>Bob</div><div><br></div><div><div>[ =C2=A0111.004665] XFS (s=
db): Mounting Filesystem</div>
<div>[ =C2=A0111.099442] XFS (sdb): Ending clean mount</div><div>[ =C2=A012=
9.548644] XFS (sdb): metadata I/O error: block 0x19022 (&quot;xlog_iodone&q=
uot;) error 19 numblks 64</div><div>[ =C2=A0129.618739] XFS (sdb): xfs_do_f=
orce_shutdown(0x2) called from line 1170 of file fs/xfs/xfs_log.c. =C2=A0Re=
turn address =3D 0xffffffffa04c8001</div>
<div>[ =C2=A0129.699768] XFS (sdb): Log I/O Error Detected. =C2=A0Shutting =
down filesystem</div><div>[ =C2=A0129.699924] XFS (sdb): Unable to update s=
uperblock counters. Freespace may not be correct on next mount.</div><div>[=
 =C2=A0129.699927] XFS (sdb): xfs_log_force: error 5 returned.</div>
<div>[ =C2=A0129.716031] XFS (P=E5=B0=82/): Please umount the filesystem an=
d rectify the problem(s)</div><div>[ =C2=A0129.718411] ------------[ cut he=
re ]------------</div><div>[ =C2=A0129.719120] Kernel BUG at ffffffffa04726=
ac [verbose debug info unavailable]</div>
<div>[ =C2=A0129.720016] invalid opcode: 0000 [#1] SMP</div><div>[ =C2=A012=
9.720016] Modules linked in: xfs(F) libcrc32c ib_srpt tcm_qla2xxx qla2xxx t=
cm_loop tcm_fc libfc scsi_transport_fc scsi_tgt iscsi_target_mod target_cor=
e_pscsi target_core_file target_core_iblock target_core_mod configfs ib_ise=
r rdma_cm iw_cm ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp l=
ibiscsi scsi_transport_iscsi nfsd nfs_acl nfs lockd fscac\</div>
<div>he sunrpc snd_intel8x0 snd_ac97_codec parport_pc parport ac97_bus snd_=
pcm psmouse snd_timer serio_raw snd joydev evbug mac_hid pcspkr i2c_piix4 s=
oundcore hid_generic usbhid hid e1000 ahci libahci</div><div>[ =C2=A0129.72=
0016] CPU: 1 PID: 234 Comm: kworker/1:1H Tainted: GF =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A03.14.0+ #1</div>
<div>[ =C2=A0129.720016] Hardware name: innotek GmbH VirtualBox, BIOS Virtu=
alBox 12/01/2006</div><div>[ =C2=A0129.720016] Workqueue: xfslogd xfs_buf_i=
odone_work [xfs]</div><div>[ =C2=A0129.720016] task: ffff88002f598000 ti: f=
fff88002fecc000 task.ti: ffff88002fecc000</div>
<div>[ =C2=A0129.720016] RIP: 0010:[&lt;ffffffffa04726ac&gt;] =C2=A0[&lt;ff=
ffffffa04726ac&gt;] xfs_do_force_shutdown+0x9c/0x170 [xfs]</div><div>[ =C2=
=A0129.720016] RSP: 0018:ffff88002fecdd68 =C2=A0EFLAGS: 00010296</div><div>=
[ =C2=A0129.720016] RAX: 0000000000000043 RBX: 0000000000000002 RCX: 000000=
0000000000</div>
<div>[ =C2=A0129.720016] RDX: ffff88003fd0efb0 RSI: ffff88003fd0d3d8 RDI: f=
fff88003fd0d3d8</div><div>[ =C2=A0129.720016] RBP: ffff88002fecdd98 R08: 00=
00000000000000 R09: 0000000000000000</div><div>[ =C2=A0129.720016] R10: 000=
00000000001cf R11: 00000000000001ce R12: ffff880028865000</div>
<div>[ =C2=A0129.720016] R13: 0000000000000002 R14: 0000000000000000 R15: 0=
000000000000000</div><div>[ =C2=A0129.720016] FS: =C2=A00000000000000000(00=
00) GS:ffff88003fd00000(0000) knlGS:0000000000000000</div><div>[ =C2=A0129.=
720016] CS: =C2=A00010 DS: 0000 ES: 0000 CR0: 000000008005003b</div>
<div>[ =C2=A0129.720016] CR2: 00000000006105e8 CR3: 0000000001c0e000 CR4: 0=
0000000000006e0</div><div>[ =C2=A0129.720016] Stack:</div><div>[ =C2=A0129.=
720016] =C2=A0ffffffffa04c8001 0000000000000000 ffff880030140300 ffff880030=
26dc00</div><div>
[ =C2=A0129.720016] =C2=A0ffff88002fa13980 0000000000000000 ffff88002fecddc=
8 ffffffffa04c8001</div><div>[ =C2=A0129.720016] =C2=A0ffff88003653cf48 fff=
f88002fa13a20 ffff88002fa13980 ffffe8ffffd01e00</div><div>[ =C2=A0129.72001=
6] Call Trace:</div><div>
[ =C2=A0129.720016] =C2=A0[&lt;ffffffffa04c8001&gt;] ? xlog_iodone+0x91/0xa=
0 [xfs]</div><div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffffa04c8001&gt;] xlog=
_iodone+0x91/0xa0 [xfs]</div><div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffffa0=
46ac3e&gt;] xfs_buf_iodone_work+0x5e/0xc0 [xfs]</div>
<div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffff8106ad04&gt;] process_one_work+=
0x174/0x4a0</div><div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffff8106c0ab&gt;] =
worker_thread+0x11b/0x370</div><div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffff=
8106bf90&gt;] ? manage_workers.isra.20+0x2d0/0x2d0</div>
<div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffff81072c29&gt;] kthread+0xc9/0xe0=
</div><div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffff81072b60&gt;] ? flush_kth=
read_worker+0xb0/0xb0</div><div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffff816d=
6aec&gt;] ret_from_fork+0x7c/0xb0</div>
<div>[ =C2=A0129.720016] =C2=A0[&lt;ffffffff81072b60&gt;] ? flush_kthread_w=
orker+0xb0/0xb0</div><div>[ =C2=A0129.720016] Code: d0 45 85 ed 0f 85 a5 00=
 00 00 f6 c3 20 66 90 75 7e 83 e3 10 0f 84 b5 00 00 00 48 c7 c6 18 8c 4e a0=
 4c 89 e7 31 c0 e8 54 92 00 00 &lt;0f&gt; 0b 66 90 48 8b 45 08 49 89 d1 41 =
89 c8 48 c7 c2 d0 4f 4e a0</div>
<div>[ =C2=A0129.720016] RIP =C2=A0[&lt;ffffffffa04726ac&gt;] xfs_do_force_=
shutdown+0x9c/0x170 [xfs]</div><div>[ =C2=A0129.720016] =C2=A0RSP &lt;ffff8=
8002fecdd68&gt;</div><div>[ =C2=A0129.777164] ---[ end trace d335180e3c3451=
56 ]---</div><div>[ =C2=A0129.777953] BUG: unable to handle kernel paging r=
equest at ffffffffffffffd8</div>
<div>[ =C2=A0129.779087] IP: [&lt;ffffffff81072c80&gt;] kthread_data+0x10/0=
x20</div><div>[ =C2=A0129.779960] PGD 1c0f067 PUD 1c11067 PMD 0</div><div>[=
 =C2=A0129.780900] Oops: 0000 [#2] SMP</div><div>[ =C2=A0129.781150] Module=
s linked in: xfs(F) libcrc32c ib_srpt tcm_qla2xxx qla2xxx tcm_loop tcm_fc l=
ibfc scsi_transport_fc scsi_tgt iscsi_target_mod target_core_pscsi target_c=
ore_file target_core_iblock target_core_mod configfs ib_iser rdma_cm iw_cm =
ib_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_tra=
nsport_iscsi nfsd nfs_acl nfs lockd fscac\</div>
<div>he sunrpc snd_intel8x0 snd_ac97_codec parport_pc parport ac97_bus snd_=
pcm psmouse snd_timer serio_raw snd joydev evbug mac_hid pcspkr i2c_piix4 s=
oundcore hid_generic usbhid hid e1000 ahci libahci</div><div>[ =C2=A0129.78=
1150] CPU: 1 PID: 234 Comm: kworker/1:1H Tainted: GF =C2=A0 =C2=A0 D =C2=A0=
 =C2=A0 =C2=A03.14.0+ #1</div>
<div>[ =C2=A0129.781150] Hardware name: innotek GmbH VirtualBox, BIOS Virtu=
alBox 12/01/2006</div><div>[ =C2=A0129.781150] task: ffff88002f598000 ti: f=
fff88002fecc000 task.ti: ffff88002fecc000</div><div>[ =C2=A0129.781150] RIP=
: 0010:[&lt;ffffffff81072c80&gt;] =C2=A0[&lt;ffffffff81072c80&gt;] kthread_=
data+0x10/0x20</div>
<div>[ =C2=A0129.781150] RSP: 0018:ffff88002fecd9f8 =C2=A0EFLAGS: 00010046<=
/div><div>[ =C2=A0129.781150] RAX: 0000000000000000 RBX: 0000000000000000 R=
CX: ffffffff81e75380</div><div>[ =C2=A0129.781150] RDX: 0000000000000001 RS=
I: 0000000000000001 RDI: ffff88002f598000</div>
<div>[ =C2=A0129.781150] RBP: ffff88002fecd9f8 R08: 0000000000000000 R09: 0=
000000000000164</div><div>[ =C2=A0129.781150] R10: ffffffff8104c8b4 R11: 00=
00000000000000 R12: 0000000000000001</div><div>[ =C2=A0129.781150] R13: fff=
f88002f5984e0 R14: ffff88003d9f8000 R15: ffff88002f5983d8</div>
<div>[ =C2=A0129.781150] FS: =C2=A00000000000000000(0000) GS:ffff88003fd000=
00(0000) knlGS:0000000000000000</div><div>[ =C2=A0129.781150] CS: =C2=A0001=
0 DS: 0000 ES: 0000 CR0: 000000008005003b</div><div>[ =C2=A0129.781150] CR2=
: 0000000000000028 CR3: 0000000001c0e000 CR4: 00000000000006e0</div>
<div>[ =C2=A0129.781150] Stack:</div><div>[ =C2=A0129.781150] =C2=A0ffff880=
02fecda18 ffffffff8106c526 ffff88003fd13140 0000000000000001</div><div>[ =
=C2=A0129.781150] =C2=A0ffff88002fecda98 ffffffff816ca7cf 0000000000000001 =
ffff88002f598000</div><div>
[ =C2=A0129.781150] =C2=A0ffff88002f598000 0000000000013140 ffff88002fecdfd=
8 0000000000013140</div></div><div><div>[ =C2=A0129.781150] Call Trace:</di=
v><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff8106c526&gt;] wq_worker_sleep=
ing+0x16/0xa0</div><div>
[ =C2=A0129.781150] =C2=A0[&lt;ffffffff816ca7cf&gt;] __schedule+0x56f/0x7c0=
</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff816caaf9&gt;] schedule+0x=
29/0x70</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff81052075&gt;] do_e=
xit+0x6e5/0xa70</div><div>
[ =C2=A0129.781150] =C2=A0[&lt;ffffffff816c2303&gt;] ? printk+0x4d/0x4f</di=
v><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff816cf0e1&gt;] oops_end+0xa1/0=
xf0</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff81006208&gt;] die+0x58=
/0x90</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff816ce93b&gt;] do_tra=
p+0xcb/0x170</div>
<div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff8100308d&gt;] do_invalid_op+0xa=
d/0x100</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffffa04726ac&gt;] ? xf=
s_do_force_shutdown+0x9c/0x170 [xfs]</div><div>[ =C2=A0129.781150] =C2=A0[&=
lt;ffffffff816c2303&gt;] ? printk+0x4d/0x4f</div>
<div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff816d8088&gt;] invalid_op+0x18/0=
x20</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffffa04726ac&gt;] ? xfs_do=
_force_shutdown+0x9c/0x170 [xfs]</div><div>[ =C2=A0129.781150] =C2=A0[&lt;f=
fffffffa04726ac&gt;] ? xfs_do_force_shutdown+0x9c/0x170 [xfs]</div>
<div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffffa04c8001&gt;] ? xlog_iodone+0x9=
1/0xa0 [xfs]</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffffa04c8001&gt;]=
 xlog_iodone+0x91/0xa0 [xfs]</div><div>[ =C2=A0129.781150] =C2=A0[&lt;fffff=
fffa046ac3e&gt;] xfs_buf_iodone_work+0x5e/0xc0 [xfs]</div>
<div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff8106ad04&gt;] process_one_work+=
0x174/0x4a0</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff8106c0ab&gt;] =
worker_thread+0x11b/0x370</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff=
8106bf90&gt;] ? manage_workers.isra.20+0x2d0/0x2d0</div>
<div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff81072c29&gt;] kthread+0xc9/0xe0=
</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff81072b60&gt;] ? flush_kth=
read_worker+0xb0/0xb0</div><div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff816d=
6aec&gt;] ret_from_fork+0x7c/0xb0</div>
<div>[ =C2=A0129.781150] =C2=A0[&lt;ffffffff81072b60&gt;] ? flush_kthread_w=
orker+0xb0/0xb0</div><div>[ =C2=A0129.781150] Code: 00 48 89 e5 5d 48 8b 40=
 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48=
 8b 87 88 04 00 00 55 48 89 e5 &lt;48&gt; 8b 40 d8 5d c3 66 2e 0f 1f 84 00 =
00 00 00 00 0f 1f 44 00 00</div>
<div>[ =C2=A0129.781150] RIP =C2=A0[&lt;ffffffff81072c80&gt;] kthread_data+=
0x10/0x20</div><div>[ =C2=A0129.781150] =C2=A0RSP &lt;ffff88002fecd9f8&gt;<=
/div><div>[ =C2=A0129.781150] CR2: ffffffffffffffd8</div><div>[ =C2=A0129.7=
81150] ---[ end trace d335180e3c345157 ]---</div>
<div>[ =C2=A0129.781150] Fixing recursive fault but reboot is needed!</div>=
</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px =
0px 0px 0.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);bord=
er-left-style:solid;padding-left:1ex">

<br>
In essence, the log IO failure is triggering a shutdown, and as part<br>
of the shutdown process it wakes anyone waiting on a log force.<br>
The log quiesce code that waits for log completion during unmount<br>
uses a log force to ensure the log is idle before tearing down all<br>
the log structures and finishing the unmount. Unfortunatey, the log<br>
force the unmount blocks on is woken prematurely by the shutdown,<br>
and hence it runs before the log IO processing is completed. Hence<br>
the use after free.<br>
<div class=3D""><br>
&gt; And then I get this kind of error and the system is unresponsive:<br>
&gt; Message from syslogd@debian at Apr =C2=A04 09:27:40 ...<br>
&gt; =C2=A0kernel:[ =C2=A0680.080022] BUG: soft lockup - CPU#2 stuck for 22=
s! [umount:2849]<br>
&gt;<br>
&gt; The problem appears to be similar to this issue:<br>
&gt; <a href=3D"http://www.spinics.net/lists/linux-xfs/msg00061.html" targe=
t=3D"_blank">http://www.spinics.net/lists/linux-xfs/msg00061.html</a><br>
<br>
</div>Similar symptoms, but not the same bug.<br>
<div class=3D""><br>
&gt; The problem is triggered by doing an iscsi logout which causes<br>
&gt; the block device to return i/o errors to xfs.<br>
&gt; Steps to reproduce the problem are below.<br>
<br>
</div>Seems similar to the thinp ENOSPC issue I mentioned above - data IO<b=
r>
errors occur, then you do an unmount, which causes a log IO error<br>
writing the superblock, and then this happens....<br>
<br>
Cheers,<br>
<br>
Dave.<br>
<span class=3D""><font color=3D"#888888">--<br>
Dave Chinner<br>
<a href=3D"mailto:david@fromorbit.com">david@fromorbit.com</a><br>
</font></span></blockquote></div><br></div></div>

--047d7bd6c21a6436c404f63e5edd--


--===============7883166664055787948==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7883166664055787948==--
