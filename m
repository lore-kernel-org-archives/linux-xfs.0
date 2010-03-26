Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2QCwFMl237305 for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 07:58:16 -0500
Received: from mailsrv13.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4430E15305B0
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 05:59:56 -0700 (PDT)
Received: from mailsrv13.zmi.at (mailsrv1.zmi.at [195.202.151.133]) by
	cuda.sgi.com with ESMTP id wkskbOJ2suGhNHbN for
	<xfs@oss.sgi.com>; Fri, 26 Mar 2010 05:59:56 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv13.zmi.at (Postfix) with ESMTP id D32021961C
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 13:59:55 +0100 (CET)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id A660983C804
	for <xfs@oss.sgi.com>; Fri, 26 Mar 2010 13:59:55 +0100 (CET)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.0.3 crash and abort
Date: Fri, 26 Mar 2010 13:59:51 +0100
References: <201003261257.41233@zmi.at> <201003261333.51599@zmi.at>
In-Reply-To: <201003261333.51599@zmi.at>
MIME-Version: 1.0
Message-Id: <201003261359.55208@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1867288638075148102=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1867288638075148102==
Content-Type: multipart/signed;
  boundary="nextPart2729315.MgAISd26j3";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2729315.MgAISd26j3
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Freitag, 26. M=C3=A4rz 2010 Michael Monnerie wrote:
> I found xfsprogs 3.1.1 now, just downloaded & compiled, and running
>  the disk check again. Will report later. Hope it works!

3.1.1 could successfuly repair all errors. Sorry for the noise.=20

# LANG=3DC xfs_repair /dev/sharestore/public             =20
Phase 1 - find and verify superblock...                                   =
=20
Phase 2 - using internal log                                              =
=20
        - zero log...                                                     =
=20
        - scan filesystem freespace and inode maps...                     =
=20
        - found root inode chunk                                          =
=20
Phase 3 - for each AG...                                                  =
=20
        - scan and clear agi unlinked lists...                            =
=20
        - process known inodes and perform inode discovery...             =
=20
        - agno =3D 0                                                       =
 =20
bad attribute format 1 in inode 312, resetting value                      =
=20
        - agno =3D 1                                                       =
 =20
entry "/mi_power2u.goelsen.net_old.tar.bz2" at block 0 offset 296 in=20
directory inode 1468243215 references invalid inode 18374686479671623679
        clearing inode number in entry at offset 296...                    =
                                                                 =20
entry at block 0 offset 296 in directory inode 1468243215 has illegal=20
name "/mi_power2u.goelsen.net_old.tar.bz2":         - agno =3D 2        =20
        - agno =3D 3                                                       =
                                                                   =20
        - agno =3D 4                                                       =
                                                                   =20
        - agno =3D 5                                                       =
                                                                   =20
        - agno =3D 6                                                       =
                                                                   =20
        - agno =3D 7                                                       =
                                                                   =20
        - agno =3D 8                                                       =
                                                                   =20
        - agno =3D 9                                                       =
                                                                   =20
        - agno =3D 10                                                      =
                                                                   =20
data fork in inode 10790641420 claims metadata block 537051648             =
                                                                 =20
bad data fork in inode 10790641420                                         =
                                                                 =20
cleared inode 10790641420                                                  =
                                                                 =20
        - agno =3D 11                                                      =
                                                                   =20
        - agno =3D 12                                                      =
                                                                   =20
data fork in inode 12926632060 claims metadata block 536915728             =
                                                                 =20
bad data fork in inode 12926632060                                         =
                                                                 =20
cleared inode 12926632060                                                  =
                                                                 =20
data fork in inode 12926632061 claims metadata block 536886032             =
                                                                 =20
bad data fork in inode 12926632061                                         =
                                                                 =20
cleared inode 12926632061                                                  =
                                                                 =20
        - agno =3D 13                                                      =
                                                                   =20
        - agno =3D 14                                                      =
                                                                   =20
imap claims a free inode 15032385909 is in use, correcting imap and=20
clearing inode                                                          =20
cleared inode 15032385909                                                  =
                                                                 =20
        - agno =3D 15                                                      =
                                                                   =20
        - process newly discovered inodes...                               =
                                                                 =20
Phase 4 - check for duplicate blocks...                                    =
                                                                 =20
        - setting up duplicate extent list...                              =
                                                                 =20
        - check for inodes claiming duplicate blocks...                    =
                                                                 =20
        - agno =3D 0                                                       =
                                                                   =20
        - agno =3D 1                                                       =
                                                                   =20
        - agno =3D 2                                                       =
                                                                   =20
        - agno =3D 3                                                       =
                                                                   =20
        - agno =3D 4                                                       =
                                                                   =20
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 8
        - agno =3D 9
        - agno =3D 10
entry "Mario Tennis GC.iso" at block 0 offset 720 in directory inode=20
10789746786 references free inode 10790641420
        clearing inode number in entry at offset 720...
entry "Family_Ski.iso" at block 0 offset 1416 in directory inode=20
10789746786 references free inode 12926632060
        clearing inode number in entry at offset 1416...
entry "Geometry Wars Galaxies.iso" at block 0 offset 1448 in directory=20
inode 10789746786 references free inode 12926632061
        clearing inode number in entry at offset 1448...
        - agno =3D 11
        - agno =3D 12
        - agno =3D 13
        - agno =3D 14
        - agno =3D 15
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
bad hash table for directory inode 1468243215 (no data entry):=20
rebuilding
rebuilding directory inode 1468243215
bad hash table for directory inode 10789746786 (no data entry):=20
rebuilding
rebuilding directory inode 10789746786
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done


=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2729315.MgAISd26j3
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkusr8sACgkQzhSR9xwSCbR55gCgmZA+yEG/bqNhrhyZsDOwflw+
XfMAniPdolQjO9ZxjamsMugk37DrZv0W
=0Rva
-----END PGP SIGNATURE-----

--nextPart2729315.MgAISd26j3--


--===============1867288638075148102==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1867288638075148102==--
