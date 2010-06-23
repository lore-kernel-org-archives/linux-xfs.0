Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5NIUD3n035197 for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 13:30:14 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F3F3152E608
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 11:32:53 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id FXEFAO2QL8y28Fbq for
	<xfs@oss.sgi.com>; Wed, 23 Jun 2010 11:32:53 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.1.2 crashing
Date: Wed, 23 Jun 2010 20:32:46 +0200
References: <201006101306.07587@zmi.at> <4C12E520.6040008@sandeen.net>
	<201006121241.52336@zmi.at>
In-Reply-To: <201006121241.52336@zmi.at>
MIME-Version: 1.0
Message-Id: <201006232032.51016@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3023438379444634854=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>

--===============3023438379444634854==
Content-Type: multipart/signed;
  boundary="nextPart4180749.6qIoClEGSH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4180749.6qIoClEGSH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Samstag, 12. Juni 2010 Michael Monnerie wrote:
> openSUSE 11.2 with it's latest kernel, 2.6.31.12-0.2-desktop

Any news here? I'd need a fix, is there a chance to get back the contents o=
f this file?

[212428.619676] Filesystem "dm-0": corrupt inode 2267035928 ((a)extents =3D=
 7).  Unmount and run xfs_repair.                                          =
                                                                           =
            =20
[212428.619681] ffff8800f3a9a800: 49 4e 81 fc 02 02 00 00 00 00 04 e5 00 00=
 00 64  IN.............d                                                   =
                                                                           =
          =20
[212428.619686] Filesystem "dm-0": XFS internal error xfs_iformat_extents(1=
) at line 558 of file /usr/src/packages/BUILD/kernel-xen-2.6.31.12/linux-2.=
6.31/fs/xfs/xfs_inode.c.  Caller 0xffffffffa019c44d
[212428.619688]
[212428.619691] Pid: 13006, comm: ls Not tainted 2.6.31.12-0.2-xen #1
[212428.619694] Call Trace:
[212428.619707]  [<ffffffff800119b9>] try_stack_unwind+0x189/0x1b0
[212428.619714]  [<ffffffff8000f466>] dump_trace+0xa6/0x1e0
[212428.619718]  [<ffffffff800114c4>] show_trace_log_lvl+0x64/0x90
[212428.619722]  [<ffffffff80011513>] show_trace+0x23/0x40
[212428.619727]  [<ffffffff8046b92c>] dump_stack+0x81/0x9e
[212428.619761]  [<ffffffffa0191d5a>] xfs_error_report+0x5a/0x70 [xfs]
[212428.619810]  [<ffffffffa0191ddc>] xfs_corruption_error+0x6c/0x90 [xfs]
[212428.619853]  [<ffffffffa019bf24>] xfs_iformat_extents+0x234/0x280 [xfs]
[212428.619903]  [<ffffffffa019c44d>] xfs_iformat+0x28d/0x5a0 [xfs]
[212428.619951]  [<ffffffffa019c8e2>] xfs_iread+0x182/0x1c0 [xfs]
[212428.620000]  [<ffffffffa0197cc8>] xfs_iget_cache_miss+0x78/0x200 [xfs]
[212428.620046]  [<ffffffffa0197f79>] xfs_iget+0x129/0x1d0 [xfs]
[212428.620094]  [<ffffffffa01b888e>] xfs_lookup+0xce/0x100 [xfs]
[212428.620158]  [<ffffffffa01c5cac>] xfs_vn_lookup+0x6c/0xc0 [xfs]
[212428.620220]  [<ffffffff80124702>] real_lookup+0x102/0x180
[212428.620225]  [<ffffffff80126bc0>] do_lookup+0xd0/0x100
[212428.620229]  [<ffffffff80127a98>] __link_path_walk+0x7f8/0xf40
[212428.620233]  [<ffffffff801283f6>] path_walk+0x66/0xd0
[212428.620237]  [<ffffffff801285cb>] do_path_lookup+0x6b/0xb0
[212428.620240]  [<ffffffff80129531>] user_path_at+0x61/0xc0
[212428.620244]  [<ffffffff8011e501>] vfs_fstatat+0x41/0x90
[212428.620248]  [<ffffffff8011e5dc>] vfs_lstat+0x2c/0x50
[212428.620251]  [<ffffffff8011e62e>] sys_newlstat+0x2e/0x70
[212428.620254]  [<ffffffff8000c868>] system_call_fastpath+0x16/0x1b
[212428.620263]  [<00007fcb58264e65>] 0x7fcb58264e65


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart4180749.6qIoClEGSH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwiU1IACgkQzhSR9xwSCbRwVACeNLi96zjHR8F82fmeWN5fykOi
LIcAoMlZsaVB/awpejS9hjQ1b9P7XrtE
=99i8
-----END PGP SIGNATURE-----

--nextPart4180749.6qIoClEGSH--


--===============3023438379444634854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3023438379444634854==--
