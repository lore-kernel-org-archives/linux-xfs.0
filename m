Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5CAdOou192726 for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 05:39:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C0F7D12A9F54
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 03:45:12 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id WVs2fVkAgLEuZ2J1 for
	<xfs@oss.sgi.com>; Sat, 12 Jun 2010 03:45:12 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 463562490E
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 12:41:54 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id E91EC83C829
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 12:41:49 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.1.2 crashing
Date: Sat, 12 Jun 2010 12:41:48 +0200
References: <201006101306.07587@zmi.at> <201006120138.22265@zmi.at>
	<4C12E520.6040008@sandeen.net>
In-Reply-To: <4C12E520.6040008@sandeen.net>
MIME-Version: 1.0
Message-Id: <201006121241.52336@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4529870786118491662=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4529870786118491662==
Content-Type: multipart/signed;
  boundary="nextPart3390362.PifhOLhOaN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3390362.PifhOLhOaN
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 12. Juni 2010 Eric Sandeen wrote:
> >  du: cannot access
> > `samba/backup/uranus/WindowsImageBackup/uranus/Backup  2010-06-05
> > 010014/852c2690-cf1a-11de-b09b-806e6f6e6963.vhd': Structure needs
> > cleaning
> dmesg would be the right thing to do here ...

There are a lot, here the last two:

[157312.699958] XFS mounting filesystem dm-0                               =
                                                                           =
                                                      =20
[157312.891010] Ending clean XFS mount for filesystem: dm-0                =
                                                                           =
                                                      =20
[157340.953238] Filesystem "dm-0": corrupt inode 2195133988 ((a)extents =3D=
 5).  Unmount and run xfs_repair.                                          =
                                                        =20
[157340.953250] ffff8800928b6400: 49 4e 81 c0 02 02 00 00 00 00 03 e8 00 00=
 00 64  IN.............d                                                   =
                                                      =20
[157340.953268] Filesystem "dm-0": XFS internal error xfs_iformat_extents(1=
) at line 558 of file /usr/src/packages/BUILD/kernel-desktop-2.6.31.12/linu=
x-2.6.31/fs/xfs/xfs_inode.c.  Caller 0xffffffffa03380ad
[157340.953271]                                                            =
                                                                           =
                                                      =20
[157340.953285] Pid: 27034, comm: du Not tainted 2.6.31.12-0.2-desktop #1  =
                                                                           =
                                                      =20
[157340.953292] Call Trace:                                                =
                                                                           =
                                                      =20
[157340.953308]  [<ffffffff81011a19>] try_stack_unwind+0x189/0x1b0         =
                                                                           =
                                                      =20
[157340.953316]  [<ffffffff8101025d>] dump_trace+0xad/0x3a0                =
                                                                           =
                                                      =20
[157340.953324]  [<ffffffff81011524>] show_trace_log_lvl+0x64/0x90         =
                                                                           =
                                                      =20
[157340.953331]  [<ffffffff81011573>] show_trace+0x23/0x40                 =
                                                                           =
                                                      =20
[157340.953339]  [<ffffffff81552b46>] dump_stack+0x81/0x9e                 =
                                                                           =
                                                      =20
[157340.953369]  [<ffffffffa032db4a>] xfs_error_report+0x5a/0x70 [xfs]     =
                                                                           =
                                                      =20
[157340.953427]  [<ffffffffa032dbcc>] xfs_corruption_error+0x6c/0x90 [xfs] =
                                                                           =
                                                      =20
[157340.953482]  [<ffffffffa0337b84>] xfs_iformat_extents+0x234/0x280 [xfs]=
                                                                           =
                                                      =20
[157340.953543]  [<ffffffffa03380ad>] xfs_iformat+0x28d/0x5a0 [xfs]        =
                                                                           =
                                                      =20
[157340.953600]  [<ffffffffa0338542>] xfs_iread+0x182/0x1c0 [xfs]          =
                                                                           =
                                                      =20
[157340.953658]  [<ffffffffa0333938>] xfs_iget_cache_miss+0x78/0x250 [xfs] =
                                                                           =
                                                      =20
[157340.953712]  [<ffffffffa0333c3c>] xfs_iget+0x12c/0x1b0 [xfs]           =
                                                                           =
                                                      =20
[157340.953768]  [<ffffffffa0353b8e>] xfs_lookup+0xce/0x100 [xfs]          =
                                                                           =
                                                      =20
[157340.953843]  [<ffffffffa0360e6c>] xfs_vn_lookup+0x6c/0xc0 [xfs]        =
                                                                           =
                                                      =20
[157340.953922]  [<ffffffff81157782>] real_lookup+0x102/0x180              =
                                                                           =
                                                      =20
[157340.953931]  [<ffffffff811598c0>] do_lookup+0xd0/0x100                 =
                                                                           =
                                                      =20
[157340.953938]  [<ffffffff81159e12>] __link_path_walk+0x522/0x880         =
                                                                           =
                                                      =20
[157340.953945]  [<ffffffff8115a6f6>] path_walk+0x66/0xd0                  =
                                                                           =
                                                      =20
[157340.953953]  [<ffffffff8115a7cb>] do_path_lookup+0x6b/0xb0             =
                                                                           =
                                                      =20
[157340.953957]  [<ffffffff8115a9d1>] user_path_at+0x61/0xc0               =
                                                                           =
                                                      =20
[157340.953962]  [<ffffffff811514d1>] vfs_fstatat+0x41/0x90                =
                                                                           =
                                                      =20
[157340.953967]  [<ffffffff81151549>] sys_newfstatat+0x29/0x60             =
                                                                           =
                                                      =20
[157340.953973]  [<ffffffff8100c682>] system_call_fastpath+0x16/0x1b       =
                                                                           =
                                                      =20
[157340.953986]  [<00007fd51c9e50ee>] 0x7fd51c9e50ee                       =
                                                                           =
                                                      =20


[157573.164556] Filesystem "dm-0": corrupt inode 2195133988 ((a)extents =3D=
 5).  Unmount and run xfs_repair.                                          =
                                                        =20
[157573.164584] ffff8800928b6400: 49 4e 81 c0 02 02 00 00 00 00 03 e8 00 00=
 00 64  IN.............d                                                   =
                                                      =20
[157573.164608] Filesystem "dm-0": XFS internal error xfs_iformat_extents(1=
) at line 558 of file /usr/src/packages/BUILD/kernel-desktop-2.6.31.12/linu=
x-2.6.31/fs/xfs/xfs_inode.c.  Caller 0xffffffffa03380ad
[157573.164615]                                                            =
                                                                           =
                                                      =20
[157573.164646] Pid: 27064, comm: du Not tainted 2.6.31.12-0.2-desktop #1  =
                                                                           =
                                                      =20
[157573.164659] Call Trace:                                                =
                                                                           =
                                                      =20
[157573.164688]  [<ffffffff81011a19>] try_stack_unwind+0x189/0x1b0         =
                                                                           =
                                                      =20
[157573.164710]  [<ffffffff8101025d>] dump_trace+0xad/0x3a0                =
                                                                           =
                                                      =20
[157573.164729]  [<ffffffff81011524>] show_trace_log_lvl+0x64/0x90         =
                                                                           =
                                                      =20
[157573.164747]  [<ffffffff81011573>] show_trace+0x23/0x40                 =
                                                                           =
                                                      =20
[157573.164765]  [<ffffffff81552b46>] dump_stack+0x81/0x9e
[157573.164833]  [<ffffffffa032db4a>] xfs_error_report+0x5a/0x70 [xfs]
[157573.164988]  [<ffffffffa032dbcc>] xfs_corruption_error+0x6c/0x90 [xfs]
[157573.165151]  [<ffffffffa0337b84>] xfs_iformat_extents+0x234/0x280 [xfs]
[157573.165317]  [<ffffffffa03380ad>] xfs_iformat+0x28d/0x5a0 [xfs]
[157573.165477]  [<ffffffffa0338542>] xfs_iread+0x182/0x1c0 [xfs]
[157573.165640]  [<ffffffffa0333938>] xfs_iget_cache_miss+0x78/0x250 [xfs]
[157573.165794]  [<ffffffffa0333c3c>] xfs_iget+0x12c/0x1b0 [xfs]
[157573.165951]  [<ffffffffa0353b8e>] xfs_lookup+0xce/0x100 [xfs]
[157573.166169]  [<ffffffffa0360e6c>] xfs_vn_lookup+0x6c/0xc0 [xfs]
[157573.166366]  [<ffffffff81157782>] real_lookup+0x102/0x180
[157573.166387]  [<ffffffff811598c0>] do_lookup+0xd0/0x100
[157573.166406]  [<ffffffff81159e12>] __link_path_walk+0x522/0x880
[157573.166425]  [<ffffffff8115a6f6>] path_walk+0x66/0xd0
[157573.166443]  [<ffffffff8115a7cb>] do_path_lookup+0x6b/0xb0
[157573.166461]  [<ffffffff8115a9d1>] user_path_at+0x61/0xc0
[157573.166481]  [<ffffffff811514d1>] vfs_fstatat+0x41/0x90
[157573.166500]  [<ffffffff81151549>] sys_newfstatat+0x29/0x60
[157573.166520]  [<ffffffff8100c682>] system_call_fastpath+0x16/0x1b
[157573.166551]  [<00007f63d57480ee>] 0x7f63d57480ee

> >               xfs_repair version 3.1.2
> which kernel, again?  The fork offset problems smell like something
>  that's fixed.

openSUSE 11.2 with it's latest kernel, 2.6.31.12-0.2-desktop

But as I said: fresh disks, fresh XFS, copied from another server with rsyn=
c, no crashes,=20
not even a reboot. Why the problems?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart3390362.PifhOLhOaN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwTZHAACgkQzhSR9xwSCbRfdwCbB36ivGbfEmelU8v7xbdNrDRo
2QgAn1CgWHT4SfQ3Xr2PTA7xbngeN3ae
=thCi
-----END PGP SIGNATURE-----

--nextPart3390362.PifhOLhOaN--


--===============4529870786118491662==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4529870786118491662==--
