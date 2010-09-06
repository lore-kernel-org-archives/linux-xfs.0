Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o86Mw2Dr205425 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 17:58:02 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5252A51188
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 15:58:42 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id FrtEmm4zrehkeSr5 for
	<xfs@oss.sgi.com>; Mon, 06 Sep 2010 15:58:42 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Date: Tue, 7 Sep 2010 00:58:40 +0200
References: <201008191312.49346@zmi.at>
	<20100906154254.5542426c@harpe.intellique.com>
	<20100906220410.GD7362@dastard>
In-Reply-To: <20100906220410.GD7362@dastard>
MIME-Version: 1.0
Message-Id: <201009070058.40849@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6910811468103351559=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6910811468103351559==
Content-Type: multipart/signed;
  boundary="nextPart4570324.df362lkYyj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4570324.df362lkYyj
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. September 2010 Dave Chinner wrote:
> # mkfs.xfs -d size=3D64k
>=20
> Will speed up large directory operations by at least an order of
> magnitude.
=20
I've read the man page for mkfs.xfs, but I couldn't find out if using=20
mkfs -d su=3D64k,sw=3D2
would be a redundant (and superior) option for that? I'd guess so,=20
reading the description of sunit:

sunit=3Dvalue
This  is  used  to specify the stripe unit for a RAID device or a=20
logical volume. The value has to be specified in 512-byte block units.=20
Use the su suboption to specify the stripe unit size in bytes. This
suboption ensures that data allocations will be stripe unit aligned when=20
the current end of file is being extended and the file size is larger=20
than 512KiB. Also inode allocations and the internal log will
be stripe unit aligned.

Or would I still need to use size=3D64k?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart4570324.df362lkYyj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyFciAACgkQzhSR9xwSCbQ6iwCeKSyi5unGkl/FpNAsG/mGzE9/
uzQAn26pCr5FKLf6NHWSgVl12gC5UfeR
=h7mc
-----END PGP SIGNATURE-----

--nextPart4570324.df362lkYyj--


--===============6910811468103351559==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6910811468103351559==--
