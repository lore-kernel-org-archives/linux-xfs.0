Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBE7ICEv086345 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 01:18:12 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30438144882E
	for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 23:20:02 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id d634rHbVtjEIFqqM for
	<xfs@oss.sgi.com>; Mon, 13 Dec 2010 23:20:02 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: inode64 mount option added after data exists
Date: Tue, 14 Dec 2010 08:19:57 +0100
References: <C92BDD2E.1C75%ivan.novick@emc.com>
	<20101214044355.GB16267@dastard>
In-Reply-To: <20101214044355.GB16267@dastard>
MIME-Version: 1.0
Message-Id: <201012140819.58723@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0396608567917766619=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Ivan.Novick@emc.com

--===============0396608567917766619==
Content-Type: multipart/signed;
  boundary="nextPart3245705.9MkWnFbgBt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3245705.9MkWnFbgBt
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 14. Dezember 2010 Dave Chinner wrote:
> > Will it still work as intended in this case (use 64 bit inodes)?
>=20
> Yes, for newly created inodes and data.

When you have the existing files/dirs, would it help to take an existing=20
dir "$path/old", create a new dir "$path/new", and then do

cd $path/old
find . -type f -exec "ln {}  ../new/" \;
rm *
mv ../new/* .

to get the inodes created in the new space? This could be necessary in=20
case the first 1TB is full, and no more inodes can be created. I'm just=20
not sure if that would be enough.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3245705.9MkWnFbgBt
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0HGp4ACgkQzhSR9xwSCbShuQCg8i4/s4sdSnbGbJZczZXOnvPO
7YYAoM31N6wvXMpkULJSW4sM3bUKQdfa
=i7uX
-----END PGP SIGNATURE-----

--nextPart3245705.9MkWnFbgBt--


--===============0396608567917766619==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0396608567917766619==--
