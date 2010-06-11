Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BNZqc7168309 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 18:35:52 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C8453C0B03
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 16:38:24 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 3RMTynPHNc1NO30f for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 16:38:24 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 06AA617C
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 01:38:23 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 896CA83C804
	for <xfs@oss.sgi.com>; Sat, 12 Jun 2010 01:38:19 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair 3.1.2 crashing
Date: Sat, 12 Jun 2010 01:38:17 +0200
References: <201006101306.07587@zmi.at> <4C11127C.3030907@sandeen.net>
In-Reply-To: <4C11127C.3030907@sandeen.net>
MIME-Version: 1.0
Message-Id: <201006120138.22265@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5541835434737684411=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5541835434737684411==
Content-Type: multipart/signed;
  boundary="nextPart10730052.8qNjOU9pan";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart10730052.8qNjOU9pan
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 10. Juni 2010 Eric Sandeen wrote:
> It'd be great to at least capture the issue by creating an
>  xfs_metadump image for analysis...

I sent it to you in private.

But now I'm really puzzled: I bought 2 2TB drives, installed an lvm with=20
xfs on them to have 4TB, and copied the contents from the server to=20
these 4TB via rsync -aHAX. And now I have a broken XFS on that brand new=20
created drives, without any crash, not even a reboot!

I got this message after making a "du -s" on the new disks:
 du: cannot access `samba/backup/uranus/WindowsImageBackup/uranus/Backup=20
2010-06-05 010014/852c2690-cf1a-11de-b09b-806e6f6e6963.vhd': Structure=20
needs cleaning

So I umounted and xfs_repaired (v3.1.2) it:
# xfs_repair -V                                                            =
                  =20
xfs_repair version 3.1.2                                                   =
                           =20
# xfs_repair /dev/swraid0/backup=20
Phase 1 - find and verify superblock...  =20
Phase 2 - using internal log             =20
        - zero log...                    =20
        - scan filesystem freespace and inode maps...
        - found root inode chunk                    =20
Phase 3 - for each AG...                            =20
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
local inode 2195133988 attr too small (size =3D 3, min size =3D 4)
bad attribute fork in inode 2195133988, clearing attr fork
clearing inode 2195133988 attributes
cleared inode 2195133988
        - agno =3D 2
        - agno =3D 3
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 2
        - agno =3D 4
        - agno =3D 5
        - agno =3D 6
        - agno =3D 7
        - agno =3D 3
        - agno =3D 1
        - agno =3D 0
data fork in inode 2195133988 claims metadata block 537122652
xfs_repair: dinode.c:2101: process_inode_data_fork: Assertion `err =3D=3D 0=
'=20
failed.
Aborted

What's this now? I copied the error from the source via rsync? ;-)

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart10730052.8qNjOU9pan
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwSyO4ACgkQzhSR9xwSCbQ4cQCgla1RssZYXSPqUHu582MfYkqf
w4sAn3b5pSxJEBqLQ/uD7ci4CbkZiC5S
=OjUM
-----END PGP SIGNATURE-----

--nextPart10730052.8qNjOU9pan--


--===============5541835434737684411==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5541835434737684411==--
