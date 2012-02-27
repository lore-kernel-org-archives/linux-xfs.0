Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1RBv39s053254 for <xfs@oss.sgi.com>; Mon, 27 Feb 2012 05:57:03 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id trYID5XrJ2g1PeEQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 27 Feb 2012 03:57:00 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: creating a new 80 TB XFS
Date: Mon, 27 Feb 2012 12:56:57 +0100
Message-ID: <2897177.rcH5T34bLh@saturn>
In-Reply-To: <4F478818.4050803@cape-horn-eng.com>
References: <4F478818.4050803@cape-horn-eng.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6444359729370014012=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Richard Ems <richard.ems@cape-horn-eng.com>


--===============6444359729370014012==
Content-Type: multipart/signed; boundary="nextPart5630910.kUIWtkkh4g"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart5630910.kUIWtkkh4g
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 24. Februar 2012, 13:52:40 schrieb Richard Ems:
> The raw storage space will then be 28 x 3 TB =3D 84 TB.

Please remember that it will be 2,79 TiB per drive, that's 78 TiB=20
overall. So it's missing 6 TB in reality, depending on how you=20
calculated the source space you have and backup space you need. In=20
Multi-TB environments people still are surprised by the big "rounding=20=

error" from harddisk TB to real TiB. And I've had customers who couldn'=
t=20
even do their first backup, as the backup system was full already. They=
=20
calculated backup space only for one backup, and without the TB->TiB=20=

conversion.

https://en.wikipedia.org/wiki/Byte

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart5630910.kUIWtkkh4g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk9Lb4kACgkQzhSR9xwSCbT3XQCdGs+7lqZcIm7kiTARX+8njT3V
RoIAoKwEC+nlkItlbnXIyQhk53Q1wLmQ
=NV2l
-----END PGP SIGNATURE-----

--nextPart5630910.kUIWtkkh4g--


--===============6444359729370014012==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6444359729370014012==--
