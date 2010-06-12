Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5CDV6PR197823 for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 08:31:07 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 31F501D59D62
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 06:33:39 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id YsKHCm87BLLWxpoP for
	<xfs@oss.sgi.com>; Sat, 12 Jun 2010 06:33:39 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id DEFEE17D
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 15:33:37 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 5952783C829
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 15:33:33 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.1.2 crashing
Date: Sat, 12 Jun 2010 15:33:31 +0200
References: <201006101306.07587@zmi.at> <201006120138.22265@zmi.at>
	<4C12E520.6040008@sandeen.net>
In-Reply-To: <4C12E520.6040008@sandeen.net>
MIME-Version: 1.0
Message-Id: <201006121533.36684@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0643286219845670268=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0643286219845670268==
Content-Type: multipart/signed;
  boundary="nextPart2255904.frkgb0dbxY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2255904.frkgb0dbxY
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 12. Juni 2010 Eric Sandeen wrote:
> > I got this message after making a "du -s" on the new disks:
> >  du: cannot access
> > `samba/backup/uranus/WindowsImageBackup/uranus/Backup 2010-06-05
> > 010014/852c2690-cf1a-11de-b09b-806e6f6e6963.vhd': Structure needs
> > cleaning
>=20
> dmesg would be the right thing to do here ...

Here a similar problem on the original server, with the file=20
/disks/daten/samba/tmp/installtemp/askalani-20100526.tib
This is the server that crashed, so I forgive XFS the error.
It looks the same to me, and I wonder if I triggered a bug somewhere.

dmesg says:

[167981.222124] Filesystem "dm-0": corrupt inode 2267035928 ((a)extents =3D=
 7).  Unmount and run xfs_repair.                                          =
                                                    =20
[167981.222130] ffff8800c068c800: 49 4e 81 fc 02 02 00 00 00 00 04 e5 00 00=
 00 64  IN.............d                                                   =
                                                  =20
[167981.222134] Filesystem "dm-0": XFS internal error xfs_iformat_extents(1=
) at line 558 of file /usr/src/packages/BUILD/kernel-xen-2.6.31.12/linux-2.=
6.31/fs/xfs/xfs_inode.c.  Caller 0xffffffffa019c44d
[167981.222136]                                                            =
                                                                           =
                                                  =20
[167981.222140] Pid: 13802, comm: ls Not tainted 2.6.31.12-0.2-xen #1      =
                                                                           =
                                                  =20
[167981.222142] Call Trace:                                                =
                                                                           =
                                                  =20
[167981.222156]  [<ffffffff800119b9>] try_stack_unwind+0x189/0x1b0         =
                                                                           =
                                                  =20
[167981.222163]  [<ffffffff8000f466>] dump_trace+0xa6/0x1e0                =
                                                                           =
                                                  =20
[167981.222167]  [<ffffffff800114c4>] show_trace_log_lvl+0x64/0x90         =
                                                                           =
                                                  =20
[167981.222171]  [<ffffffff80011513>] show_trace+0x23/0x40                 =
                                                                           =
                                                  =20
[167981.222176]  [<ffffffff8046b92c>] dump_stack+0x81/0x9e                 =
                                                                           =
                                                  =20
[167981.222213]  [<ffffffffa0191d5a>] xfs_error_report+0x5a/0x70 [xfs]     =
                                                                           =
                                                  =20
[167981.222309]  [<ffffffffa0191ddc>] xfs_corruption_error+0x6c/0x90 [xfs] =
                                                                           =
                                                  =20
[167981.222355]  [<ffffffffa019bf24>] xfs_iformat_extents+0x234/0x280 [xfs]=
                                                                           =
                                                  =20
[167981.222407]  [<ffffffffa019c44d>] xfs_iformat+0x28d/0x5a0 [xfs]        =
                                                                           =
                                                  =20
[167981.222458]  [<ffffffffa019c8e2>] xfs_iread+0x182/0x1c0 [xfs]          =
                                                                           =
                                                  =20
[167981.222541]  [<ffffffffa0197cc8>] xfs_iget_cache_miss+0x78/0x200 [xfs] =
                                                                           =
                                                  =20
[167981.222590]  [<ffffffffa0197f79>] xfs_iget+0x129/0x1d0 [xfs]           =
                                                                           =
                                                  =20
[167981.222640]  [<ffffffffa01b888e>] xfs_lookup+0xce/0x100 [xfs]          =
                                                                           =
                                                  =20
[167981.222711]  [<ffffffffa01c5cac>] xfs_vn_lookup+0x6c/0xc0 [xfs]        =
                                                                           =
                                                  =20
[167981.222825]  [<ffffffff80124702>] real_lookup+0x102/0x180              =
                                                                           =
                                                  =20
[167981.222830]  [<ffffffff80126bc0>] do_lookup+0xd0/0x100                 =
                                                                           =
                                                  =20
[167981.222835]  [<ffffffff80127a98>] __link_path_walk+0x7f8/0xf40         =
                                                                           =
                                                  =20
[167981.222838]  [<ffffffff801283f6>] path_walk+0x66/0xd0                  =
                                                                           =
                                                  =20
[167981.222842]  [<ffffffff801285cb>] do_path_lookup+0x6b/0xb0             =
                                                                           =
                                                  =20
[167981.222846]  [<ffffffff80129531>] user_path_at+0x61/0xc0               =
                                                                           =
                                                  =20
[167981.222850]  [<ffffffff8011e501>] vfs_fstatat+0x41/0x90                =
                                                                           =
                                                  =20
[167981.222853]  [<ffffffff8011e5dc>] vfs_lstat+0x2c/0x50                  =
                                                                           =
                                                  =20
[167981.222857]  [<ffffffff8011e62e>] sys_newlstat+0x2e/0x70               =
                                                                           =
                                                  =20
[167981.222861]  [<ffffffff8000c868>] system_call_fastpath+0x16/0x1b       =
                                                                           =
                                                  =20
[167981.222870]  [<00007f9decb1ce65>] 0x7f9decb1ce65                 =20


                                                                           =
                                                       =20
[167985.423311] Filesystem "dm-0": corrupt inode 2267035928 ((a)extents =3D=
 7).  Unmount and run xfs_repair.                                          =
                                                    =20
[167985.423317] ffff8800c068c800: 49 4e 81 fc 02 02 00 00 00 00 04 e5 00 00=
 00 64  IN.............d                                                   =
                                                  =20
[167985.423322] Filesystem "dm-0": XFS internal error xfs_iformat_extents(1=
) at line 558 of file /usr/src/packages/BUILD/kernel-xen-2.6.31.12/linux-2.=
6.31/fs/xfs/xfs_inode.c.  Caller 0xffffffffa019c44d
[167985.423324]                                                            =
                                                                           =
                                                  =20
[167985.423328] Pid: 13803, comm: ls Not tainted 2.6.31.12-0.2-xen #1      =
                                                                           =
                                                  =20
[167985.423330] Call Trace:
[167985.423344]  [<ffffffff800119b9>] try_stack_unwind+0x189/0x1b0
[167985.423397]  [<ffffffff8000f466>] dump_trace+0xa6/0x1e0
[167985.423402]  [<ffffffff800114c4>] show_trace_log_lvl+0x64/0x90
[167985.423406]  [<ffffffff80011513>] show_trace+0x23/0x40
[167985.423411]  [<ffffffff8046b92c>] dump_stack+0x81/0x9e
[167985.423446]  [<ffffffffa0191d5a>] xfs_error_report+0x5a/0x70 [xfs]
[167985.423495]  [<ffffffffa0191ddc>] xfs_corruption_error+0x6c/0x90 [xfs]
[167985.423538]  [<ffffffffa019bf24>] xfs_iformat_extents+0x234/0x280 [xfs]
[167985.423588]  [<ffffffffa019c44d>] xfs_iformat+0x28d/0x5a0 [xfs]
[167985.423636]  [<ffffffffa019c8e2>] xfs_iread+0x182/0x1c0 [xfs]
[167985.423727]  [<ffffffffa0197cc8>] xfs_iget_cache_miss+0x78/0x200 [xfs]
[167985.423775]  [<ffffffffa0197f79>] xfs_iget+0x129/0x1d0 [xfs]
[167985.423824]  [<ffffffffa01b888e>] xfs_lookup+0xce/0x100 [xfs]
[167985.423924]  [<ffffffffa01c5cac>] xfs_vn_lookup+0x6c/0xc0 [xfs]
[167985.423985]  [<ffffffff80124702>] real_lookup+0x102/0x180
[167985.423991]  [<ffffffff80126bc0>] do_lookup+0xd0/0x100
[167985.423995]  [<ffffffff80127a98>] __link_path_walk+0x7f8/0xf40
[167985.423999]  [<ffffffff801283f6>] path_walk+0x66/0xd0
[167985.424003]  [<ffffffff801285cb>] do_path_lookup+0x6b/0xb0
[167985.424007]  [<ffffffff80129531>] user_path_at+0x61/0xc0
[167985.424011]  [<ffffffff8011e501>] vfs_fstatat+0x41/0x90
[167985.424014]  [<ffffffff8011e5dc>] vfs_lstat+0x2c/0x50
[167985.424018]  [<ffffffff8011e62e>] sys_newlstat+0x2e/0x70
[167985.424022]  [<ffffffff8000c868>] system_call_fastpath+0x16/0x1b
[167985.424031]  [<00007f56f3525e65>] 0x7f56f3525e65



=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2255904.frkgb0dbxY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwTjLAACgkQzhSR9xwSCbRdIwCbBFHSaOFKFd2edZZP37N7nSbS
6vUAn1uEnz3tQQf3ZgTmkGO5ake8ywYM
=x30q
-----END PGP SIGNATURE-----

--nextPart2255904.frkgb0dbxY--


--===============0643286219845670268==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0643286219845670268==--
