Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9MECRtk095555 for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 09:12:27 -0500
Received: from smtp-tls.univ-nantes.fr (smtptls1-cha.cpub.univ-nantes.fr
	[193.52.103.113]) by cuda.sgi.com with ESMTP id
	rD86dbBLzmY46djz for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 07:14:08 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTP id 80D36401483
	for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 16:14:07 +0200 (CEST)
Received: from smtp-tls.univ-nantes.fr ([127.0.0.1])
	by localhost (smtptls1-cha.cpub.univ-nantes.fr [127.0.0.1])
	(amavisd-new, port 10024)
	with LMTP id USUDAFaGbNSQ for <xfs@oss.sgi.com>;
	Mon, 22 Oct 2012 16:14:07 +0200 (CEST)
Received: from [IPv6:2001:660:7220:0:8991:bb6a:1c27:8ad0] (unknown
	[IPv6:2001:660:7220:0:8991:bb6a:1c27:8ad0])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-tls.univ-nantes.fr (Postfix) with ESMTPSA id 5C0924016E4
	for <xfs@oss.sgi.com>; Mon, 22 Oct 2012 16:14:07 +0200 (CEST)
Message-ID: <508554AF.5050005@univ-nantes.fr>
Date: Mon, 22 Oct 2012 16:14:07 +0200
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Is kernel 3.6.1 or filestreams option toxic ?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,
Last week, I encountered problems with xfs volumes on several machines. =

Kernel hanged under heavy load, I hard to hard reset. After reboot, xfs =

volume was not able to mount, and xfs_repair didn't managed to recover =

the volume cleanly on 2 different machines.

Just to relax things, It wasn't production data, so it don't matter if I =

recover data or not. But more important to me is to understand why =

things went wrong...

I'm using XFS since a long time, on lots of data, it's the first time I =

encounter such a problem, but I was using unusual option : filestreams, =

and was using kernel 3.6.1. So I wonder if it has something to do with =

the crash.

I have nothing very conclusive in the kernel logs, apart this :

Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569890] =

INFO: task ceph-osd:17856 blocked for more than 120 seconds.
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569941] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569987] =

ceph-osd        D ffff88056416b1a0     0 17856      1 0x00000000
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.569993] =

ffff88056416aed0 0000000000000086 ffff880590751fd8 ffff88000c67eb00
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570047] =

ffff880590751fd8 ffff880590751fd8 ffff880590751fd8 ffff88056416aed0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570101] =

0000000000000001 ffff88056416aed0 ffff880a15240d00 ffff880a15240d60
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570156] Call =

Trace:
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570187] =

[<ffffffff81041335>] ? exit_mm+0x85/0x120
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570216] =

[<ffffffff81042a94>] ? do_exit+0x154/0x8e0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570248] =

[<ffffffff8114ec79>] ? file_update_time+0xa9/0x100
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570278] =

[<ffffffff81043568>] ? do_group_exit+0x38/0xa0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570309] =

[<ffffffff81051bc6>] ? get_signal_to_deliver+0x1a6/0x5e0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570341] =

[<ffffffff8100223e>] ? do_signal+0x4e/0x970
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570371] =

[<ffffffff81170e2e>] ? fsnotify+0x24e/0x340
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570402] =

[<ffffffff8100c995>] ? fpu_finit+0x15/0x30
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570431] =

[<ffffffff8100db34>] ? restore_i387_xstate+0x64/0x1c0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570464] =

[<ffffffff8108e0d2>] ? sys_futex+0x92/0x1b0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570493] =

[<ffffffff81002bf5>] ? do_notify_resume+0x75/0xc0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570525] =

[<ffffffff813c60fa>] ? int_signal+0x12/0x17
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570553] =

INFO: task ceph-osd:17857 blocked for more than 120 seconds.
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570583] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570628] =

ceph-osd        D ffff8801161fe720     0 17857      1 0x00000000
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570632] =

ffff8801161fe450 0000000000000086 ffffffffffffffe0 ffff880a17c73c30
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570687] =

ffff88011347ffd8 ffff88011347ffd8 ffff88011347ffd8 ffff8801161fe450
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570740] =

ffff8801161fe450 ffff8801161fe450 ffff880a15240d00 ffff880a15240d60
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570794] Call =

Trace:
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570818] =

[<ffffffff81041335>] ? exit_mm+0x85/0x120
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570846] =

[<ffffffff81042a94>] ? do_exit+0x154/0x8e0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570875] =

[<ffffffff81043568>] ? do_group_exit+0x38/0xa0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570905] =

[<ffffffff81051bc6>] ? get_signal_to_deliver+0x1a6/0x5e0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570935] =

[<ffffffff8100223e>] ? do_signal+0x4e/0x970
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570967] =

[<ffffffff81302d24>] ? sys_sendto+0x114/0x150
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.570996] =

[<ffffffff8108e0d2>] ? sys_futex+0x92/0x1b0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571024] =

[<ffffffff81002bf5>] ? do_notify_resume+0x75/0xc0
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571054] =

[<ffffffff813c60fa>] ? int_signal+0x12/0x17
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571082] =

INFO: task ceph-osd:17858 blocked for more than 120 seconds.
Oct 14 14:37:21 hanyu.u14.univ-nantes.prive kernel: [532905.571111] =

"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

Wasn't able to cleanly shutdown the servers after that. On 2 machines, =

xfs volumes (12 TB each) couldn't be mounted anymore, after hardreset, =

needed xfs_repair -L ...

On 1 machine, xfs_repair goes to end, but with millions errors, and this =

gives this in the end :(
344010712    /XCEPH-PROD/data/osd.8
6841649480    /XCEPH-PROD/data/lost+found/

I understand xfs_repair -L always lead to data loss, but not to that point ?

on the other one, xfs_repairs segfaults, after lots of messages like =

that (I mean, really lots):

block (0,1008194-1008194) multiply claimed by cnt space tree, state - 2
block (0,1008200-1008200) multiply claimed by cnt space tree, state - 2
block (0,1012323-1012323) multiply claimed by cnt space tree, state - 2
...

agf_freeblks 87066179, counted 87066033 in ag 0
agi_freecount 489403, counted 488952 in ag 0
agi unlinked bucket 1 is 7681 in ag 0 (inode=3D7681)
agi unlinked bucket 5 is 67781 in ag 0 (inode=3D67781)
agi unlinked bucket 6 is 10950 in ag 0 (inode=3D10950)
...

block (3,30847085-30847085) multiply claimed by cnt space tree, state - 2
block (3,27384823-27384823) multiply claimed by cnt space tree, state - 2
block (3,30115747-30115747) multiply claimed by cnt space tree, state - 2
...
agf_freeblks 90336213, counted 302201427 in ag 3
agf_longest 6144, counted 167772160 in ag 3
inode chunk claims used block, inobt block - agno 3, bno 2380, inopb 16
inode chunk claims used block, inobt block - agno 3, bno 280918, inopb 16
...

Phase 3 - for each AG...
         - scan (but don't clear) agi unlinked lists...
found inodes not in the inode allocation tree
         - process known inodes and perform inode discovery...
         - agno =3D 0
7f1738c17700: Badness in key lookup (length)
bp=3D(bno 2848, len 16384 bytes) key=3D(bno 2848, len 8192 bytes)
7f1738c17700: Badness in key lookup (length)
bp=3D(bno 3840, len 16384 bytes) key=3D(bno 3840, len 8192 bytes)
7f1738c17700: Badness in key lookup (length)
bp=3D(bno 5456, len 16384 bytes) key=3D(bno 5456, len 8192 bytes)
...
and in the end, xfs_repair segfaults.


Those machines are part of a 12 machine ceph cluster (Ceph itself is =

pure user-space). All nodes are independant (not on the same computer =

room), but were all running 3.6.1 since some days, and all were using =

xfs with filestreams option (I was trying to prevent xfs fragmentation). =

Could it be related , as it's the first time I encounter such a =

disastrous data loss ?

I don't have much more relevant details, making this mail a poor bug =

report ...

If that matters, I can anyway furnish more details about the way those =

kernels hanged (ceph nodes reweights, stressing the hardware, lots of =

I/O), details about servers & fibre channels disks, and so on.

Cheers,

-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
