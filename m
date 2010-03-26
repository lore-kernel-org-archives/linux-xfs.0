Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2QBu30s232327 for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 06:56:04 -0500
Received: from mailsrv13.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64A0F1D39241
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 04:57:43 -0700 (PDT)
Received: from mailsrv13.zmi.at (mailsrv1.zmi.at [195.202.151.133]) by
	cuda.sgi.com with ESMTP id qxBUPKO564TeGHde for
	<xfs@oss.sgi.com>; Fri, 26 Mar 2010 04:57:43 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv13.zmi.at (Postfix) with ESMTP id E415C17698
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 12:57:41 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id B4E9A83C804
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 12:57:41 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: xfs_repair 3.0.3 crash and abort
Date: Fri, 26 Mar 2010 12:57:37 +0100
MIME-Version: 1.0
Message-Id: <201003261257.41233@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2901666221064143833=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>

--===============2901666221064143833==
Content-Type: multipart/signed;
  boundary="nextPart1619247.g2psBomT0f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1619247.g2psBomT0f
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I tried a repair on one server, but it crashes:

# xfs_repair /dev/sharestore/public                =20
Phase 1 - find and verify superblock...                               =20
Phase 2 - using internal log                                          =20
        - zero log...                                                 =20
        - scan filesystem freespace and inode maps...                 =20
        - found root inode chunk                                      =20
Phase 3 - for each AG...                                              =20
        - scan and clear agi unlinked lists...                        =20
        - process known inodes and perform inode discovery...         =20
        - agno =3D 0                                                    =20
        - agno =3D 1                                                    =20
        - agno =3D 2                                                    =20
        - agno =3D 3                                                    =20
        - agno =3D 4                                                    =20
        - agno =3D 5                                                    =20
        - agno =3D 6                                                    =20
        - agno =3D 7                                                    =20
        - agno =3D 8                                                    =20
        - agno =3D 9                                                    =20
        - agno =3D 10                                                   =20
attr fork in regular inode 10790641420 claims used block 337609       =20
bad attribute fork in inode 10790641420, clearing attr fork           =20
clearing inode 10790641420 attributes                                 =20
correcting nblocks for inode 10790641420, was 1147457 - counted 1147456
cleared inode 10790641420                                             =20
        - agno =3D 11                                                   =20
        - agno =3D 12                                                   =20
inode 12926632060 - bad extent starting block number 3940649673949450,=20
offset 2942236164344
bad attribute fork in inode 12926632060, clearing attr fork                =
               =20
clearing inode 12926632060 attributes                                      =
               =20
correcting nblocks for inode 12926632060, was 1147457 - counted 1147456    =
               =20
cleared inode 12926632060                                                  =
               =20
inode 12926632061 - bad extent starting block number 2867526325240071,=20
offset 3558442336524
bad attribute fork in inode 12926632061, clearing attr fork                =
               =20
clearing inode 12926632061 attributes                                      =
               =20
correcting nblocks for inode 12926632061, was 1147457 - counted 1147456    =
               =20
cleared inode 12926632061                                                  =
               =20
        - agno =3D 13                                                      =
                 =20
        - agno =3D 14
data fork in regular inode 15032385909 claims used block 261
bad data fork in inode 15032385909
cleared inode 15032385909
        - agno =3D 15
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
attr fork in ino 312 claims dup extent, off - 0, start - 337609, cnt 1
bad attribute fork in inode 312, clearing attr fork
clearing inode 312 attributes
correcting nblocks for inode 312, was 1 - counted 0
cleared inode 312
        - agno =3D 1
entry "zmi_power2u.goelsen.net_old.tar.bz2" at block 0 offset 296 in=20
directory inode 1468243215 references free inode 15032385909
        clearing inode number in entry at offset 296...
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
data fork in inode 10790641420 claims metadata block 537051648
xfs_repair: dinode.c:2121: process_inode_data_fork: Zusicherung =C2=BBerr =
=3D=3D=20
0=C2=AB nicht erf=C3=BCllt.
Abgebrochen

What can I do?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1619247.g2psBomT0f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkusoTUACgkQzhSR9xwSCbQCOgCg1FWnw12bQ1JY4Ff0aV9awLiA
w4oAoI59Fx3/+NAWCWDgA/AJWUBnKchN
=MrDG
-----END PGP SIGNATURE-----

--nextPart1619247.g2psBomT0f--


--===============2901666221064143833==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2901666221064143833==--
