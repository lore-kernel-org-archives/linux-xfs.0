Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-db5eur01on0130.outbound.protection.outlook.com ([104.47.2.130]:40256
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933027AbdEXLSw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 May 2017 07:18:52 -0400
From: =?iso-8859-2?Q?Libor_Klep=E1=E8?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH] xfs_repair: junk leaf attribute if count == 0
Date: Wed, 24 May 2017 11:18:47 +0000
Message-ID: <4648960.1DrcVCcZxK@libor-nb>
References: <725190d9-6db0-4f6c-628b-76f2dca3071f@redhat.com>
 <2727630.ZS8FFPfE3C@libor-nb>
 <b6492357-4bf3-c570-be33-90010e3b1967@sandeen.net>
In-Reply-To: <b6492357-4bf3-c570-be33-90010e3b1967@sandeen.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-2"
Content-ID: <D177E154DF79CC4DAE338672B3AE6368@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Hi,=0A=
after quiet two months , another crash, trace is same as before.=0A=
There are no XFS lines before this, kern.log goes back to 23. april.=0A=
=0A=
May 24 12:05:12 vps2 kernel: [3729926.243353] XFS (dm-2): Metadata corrupti=
on detected at xfs_attr3_leaf_write_verify+0xe8/0x100 [xfs], xfs_attr3_leaf=
 block 0x171c60c0=0A=
May 24 12:05:12 vps2 kernel: [3729926.247586] XFS (dm-2): Unmount and run x=
fs_repair=0A=
May 24 12:05:12 vps2 kernel: [3729926.249022] XFS (dm-2): First 64 bytes of=
 corrupted metadata buffer:=0A=
May 24 12:05:12 vps2 kernel: [3729926.250424] ffff9fbb1d73a000: 00 00 00 00=
 00 00 00 00 fb ee 00 00 00 00 00 00  ................=0A=
May 24 12:05:12 vps2 kernel: [3729926.251870] ffff9fbb1d73a010: 10 00 00 00=
 00 20 0f e0 00 00 00 00 00 00 00 00  ..... ..........=0A=
May 24 12:05:12 vps2 kernel: [3729926.253412] ffff9fbb1d73a020: 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00  ................=0A=
May 24 12:05:12 vps2 kernel: [3729926.254941] ffff9fbb1d73a030: 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00  ................=0A=
May 24 12:05:12 vps2 kernel: [3729926.256478] CPU: 1 PID: 454 Comm: xfsaild=
/dm-2 Tainted: G            E   4.9.0-0.bpo.2-amd64 #1 Debian 4.9.13-1~bpo8=
+1=0A=
May 24 12:05:12 vps2 kernel: [3729926.256480] Hardware name: VMware, Inc. V=
Mware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/14/20=
14=0A=
May 24 12:05:12 vps2 kernel: [3729926.256483]  0000000000000000 ffffffffb13=
29cd5 ffff9fba7f543ac0 ffff9fb9cb6ca5a0=0A=
May 24 12:05:12 vps2 kernel: [3729926.256488]  ffffffffc06b4a58 00000000000=
00000 0000000004772296 0000000000000000=0A=
May 24 12:05:12 vps2 kernel: [3729926.256492]  ffffab7701f7bd40 ffffffffc06=
ff997 ffff9fbb830dbac0 ffffffffc06fdcc4=0A=
May 24 12:05:12 vps2 kernel: [3729926.256495] Call Trace:=0A=
May 24 12:05:12 vps2 kernel: [3729926.256505]  [<ffffffffb1329cd5>] ? dump_=
stack+0x5c/0x77=0A=
May 24 12:05:12 vps2 kernel: [3729926.256585]  [<ffffffffc06b4a58>] ? xfs_a=
ttr3_leaf_write_verify+0xe8/0x100 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.256645]  [<ffffffffc06ff997>] ? xfs_b=
uf_delwri_submit_buffers+0x137/0x260 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.256712]  [<ffffffffc06fdcc4>] ? _xfs_=
buf_ioapply+0x84/0x450 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.256719]  [<ffffffffb10a2b30>] ? wake_=
up_q+0x60/0x60=0A=
May 24 12:05:12 vps2 kernel: [3729926.256781]  [<ffffffffc06ff997>] ? xfs_b=
uf_delwri_submit_buffers+0x137/0x260 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.256845]  [<ffffffffc06ff6d7>] ? xfs_b=
uf_submit+0x67/0x1f0 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.256911]  [<ffffffffc06ff997>] ? xfs_b=
uf_delwri_submit_buffers+0x137/0x260 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.256975]  [<ffffffffc073177b>] ? xfsai=
ld+0x2cb/0x7b0 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.257038]  [<ffffffffc06ff365>] ? xfs_b=
uf_unlock+0x15/0x70 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.257105]  [<ffffffffc073177b>] ? xfsai=
ld+0x2cb/0x7b0 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.257174]  [<ffffffffc07314b0>] ? xfs_t=
rans_ail_cursor_first+0x80/0x80 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.257182]  [<ffffffffb10974c0>] ? kthre=
ad+0xe0/0x100=0A=
May 24 12:05:12 vps2 kernel: [3729926.257186]  [<ffffffffb102476b>] ? __swi=
tch_to+0x2bb/0x700=0A=
May 24 12:05:12 vps2 kernel: [3729926.257189]  [<ffffffffb10973e0>] ? kthre=
ad_park+0x60/0x60=0A=
May 24 12:05:12 vps2 kernel: [3729926.257194]  [<ffffffffb15fb675>] ? ret_f=
rom_fork+0x25/0x30=0A=
May 24 12:05:12 vps2 kernel: [3729926.257201] XFS (dm-2): xfs_do_force_shut=
down(0x8) called from line 1323 of file /home/zumbi/linux-4.9.13/fs/xfs/xfs=
_buf.c.  Return address =3D 0xffffffffc06fe084=0A=
May 24 12:05:12 vps2 kernel: [3729926.260093] XFS (dm-2): Corruption of in-=
memory data detected.  Shutting down filesystem=0A=
May 24 12:05:12 vps2 kernel: [3729926.262115] CPU: 1 PID: 454 Comm: xfsaild=
/dm-2 Tainted: G            E   4.9.0-0.bpo.2-amd64 #1 Debian 4.9.13-1~bpo8=
+1=0A=
May 24 12:05:12 vps2 kernel: [3729926.262117] Hardware name: VMware, Inc. V=
Mware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/14/20=
14=0A=
May 24 12:05:12 vps2 kernel: [3729926.262120]  0000000000000000 ffffffffb13=
29cd5 0000000000000008 ffff9fbc275f3000=0A=
May 24 12:05:12 vps2 kernel: [3729926.262125]  ffffffffc07061fa ffffffffc06=
fe084 0000000000000000 ffffab7701f7bd40=0A=
May 24 12:05:12 vps2 kernel: [3729926.262129]  ffffffffc06ff997 ffff9fbb830=
dbac0 ffffffffc06fe084 ffff9fb934f86080=0A=
May 24 12:05:12 vps2 kernel: [3729926.262133] Call Trace:=0A=
May 24 12:05:12 vps2 kernel: [3729926.262141]  [<ffffffffb1329cd5>] ? dump_=
stack+0x5c/0x77=0A=
May 24 12:05:12 vps2 kernel: [3729926.262228]  [<ffffffffc07061fa>] ? xfs_d=
o_force_shutdown+0x13a/0x140 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262294]  [<ffffffffc06fe084>] ? _xfs_=
buf_ioapply+0x444/0x450 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262361]  [<ffffffffc06ff997>] ? xfs_b=
uf_delwri_submit_buffers+0x137/0x260 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262427]  [<ffffffffc06fe084>] ? _xfs_=
buf_ioapply+0x444/0x450 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262433]  [<ffffffffb10a2b30>] ? wake_=
up_q+0x60/0x60=0A=
May 24 12:05:12 vps2 kernel: [3729926.262503]  [<ffffffffc06ff997>] ? xfs_b=
uf_delwri_submit_buffers+0x137/0x260 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262573]  [<ffffffffc06ff6d7>] ? xfs_b=
uf_submit+0x67/0x1f0 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262643]  [<ffffffffc06ff997>] ? xfs_b=
uf_delwri_submit_buffers+0x137/0x260 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262717]  [<ffffffffc073177b>] ? xfsai=
ld+0x2cb/0x7b0 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262789]  [<ffffffffc06ff365>] ? xfs_b=
uf_unlock+0x15/0x70 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262864]  [<ffffffffc073177b>] ? xfsai=
ld+0x2cb/0x7b0 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262939]  [<ffffffffc07314b0>] ? xfs_t=
rans_ail_cursor_first+0x80/0x80 [xfs]=0A=
May 24 12:05:12 vps2 kernel: [3729926.262944]  [<ffffffffb10974c0>] ? kthre=
ad+0xe0/0x100=0A=
May 24 12:05:12 vps2 kernel: [3729926.262948]  [<ffffffffb102476b>] ? __swi=
tch_to+0x2bb/0x700=0A=
May 24 12:05:12 vps2 kernel: [3729926.262950]  [<ffffffffb10973e0>] ? kthre=
ad_park+0x60/0x60=0A=
May 24 12:05:12 vps2 kernel: [3729926.262955]  [<ffffffffb15fb675>] ? ret_f=
rom_fork+0x25/0x30=0A=
May 24 12:05:12 vps2 kernel: [3729926.263078] XFS (dm-2): Please umount the=
 filesystem and rectify the problem(s)=0A=
=0A=
=0A=
After filesystem shutdown, before reboot i have upgraded kernel to 4.9.25-1=
~bpo8+1=0A=
=0A=
Customer was calling us, just when nagios alerted us on host problem, that =
he was copying some files between accounts (which means changing acls), i h=
ave asked him for more information.=0A=
=0A=
Libor=0A=
=0A=
