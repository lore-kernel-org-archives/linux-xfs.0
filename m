Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4PGH8gj008682 for <xfs@oss.sgi.com>; Tue, 25 May 2010 11:17:08 -0500
Received: from smtp4-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A52F36F64B
	for <xfs@oss.sgi.com>; Tue, 25 May 2010 09:19:29 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id ZSuSv0HMw0HIIj4r for
	<xfs@oss.sgi.com>; Tue, 25 May 2010 09:19:29 -0700 (PDT)
Date: Tue, 25 May 2010 18:19:09 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: LVM snapshot not mountable
Message-ID: <20100525181909.70496ce1@harpe.intellique.com>
In-Reply-To: <201005251725.48452@zmi.at>
References: <201005251725.48452@zmi.at>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5756785827042947528=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

--===============5756785827042947528==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=+k0FWBg/FEN135IOAsvHTM"; protocol="application/pgp-signature"

--Sig_/=+k0FWBg/FEN135IOAsvHTM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Le Tue, 25 May 2010 17:25:44 +0200
Michael Monnerie <michael.monnerie@is.it-management.at> =E9crivait:

> but the mount fails, dmesg says:
> [  598.440324] XFS: Filesystem dm-1 has duplicate UUID - can't mount
>=20
> How could I mount it?

Simply read the message : you cannot mount 2 xfs filesystems with the
same UUID at the same time. Obviously the snapshot carries the same UUID
as the original. Use the "nouuid" option to mount it.

--=20
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

--Sig_/=+k0FWBg/FEN135IOAsvHTM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv7+H0ACgkQX3jQXNUicVZRKQCghEnAmMpMDCiK3nb6JsMwbrq7
yK8AnR/i2yXgC0rziXk3t2JPkygPDIy/
=Pzm7
-----END PGP SIGNATURE-----

--Sig_/=+k0FWBg/FEN135IOAsvHTM--


--===============5756785827042947528==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5756785827042947528==--
