Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1JDGlaJ248590 for <xfs@oss.sgi.com>; Sun, 19 Feb 2012 07:16:48 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id j5Zgf02gYPHOlrEu (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 19 Feb 2012 05:16:44 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS memory recomendation?
Date: Sun, 19 Feb 2012 14:16:32 +0100
Message-ID: <5722408.cXkY2gHLh8@saturn>
In-Reply-To: <4F3F0A4A.7050708@redhat.com>
References: <2BF070A7A2375D46BA1B6087F8D5DCB68BEA721CA3@seldmbx01.corpusers.net>
	<4F3F05D4.1020705@hardwarefreak.com> <4F3F0A4A.7050708@redhat.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4310857409117144917=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@redhat.com>, stan@hardwarefreak.com, "Assarsson,
	Emil" <Emil.Assarsson@sonyericsson.com>


--===============4310857409117144917==
Content-Type: multipart/signed; boundary="nextPart38005935.cipAypyCf7"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart38005935.cipAypyCf7
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 17. Februar 2012, 18:17:46 schrieb Eric Sandeen:
> http://xfs.org/index.php/XFS_FAQ#Q:_Which_factors_influence_the_memor=
y
> _usage_of_xfs_repair.3F

I tried that, and it said "use 434":

xfs_repair -n -vv -m 1 /dev/mapper/vg_orion-lv_orion_data=20
Phase 1 - find and verify superblock...
        - max_mem =3D 1024, icount =3D 339648, imem =3D 1326, dblock =3D=
=20
805304256, dmem =3D 393214
Required memory for repair is greater that the maximum specified with=20=

the -m option. Please increase it to at least 434.

But when I tried with=20
# xfs_repair -n -vv -m 434 /dev/mapper/vg_orion-lv_orion_data=20
it said the same again. It only worked with 435:
# xfs_repair -n -vv -m 435 /dev/mapper/vg_orion-lv_orion_data=20
(is that what you call an off-by-1 error?)

Maybe that has been fixed already? This is
# xfs_repair -V
xfs_repair Version 3.1.6

BTW, this XFS is 3219644160 KB (3,2TB), used 2,9TB, has (df -i) 325364=20=

inodes used, 293884 files in 31643 dirs. It seems mem usage primarily=20=

comes from inodes, not from the size of the filesystem.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531
--nextPart38005935.cipAypyCf7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9A9jkACgkQzhSR9xwSCbQXRQCgzBp93nhscjDjNWRpktZKekNl
zbAAoKY5pHKUHDC80AsqxDkcAnpNPqFD
=0kP3
-----END PGP SIGNATURE-----

--nextPart38005935.cipAypyCf7--


--===============4310857409117144917==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4310857409117144917==--
