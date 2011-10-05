Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p95IMQ2C132874 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 13:22:26 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F4551C6B06B
	for <xfs@oss.sgi.com>; Wed,  5 Oct 2011 11:22:22 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id UKAnMDZ9a57glwll for
	<xfs@oss.sgi.com>; Wed, 05 Oct 2011 11:22:22 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Date: Wed, 5 Oct 2011 20:22:18 +0200
References: <4E887D7F.2010306@oracle.com> <201110050934.28021@zmi.at>
	<20111005093615.GQ3159@dastard>
In-Reply-To: <20111005093615.GQ3159@dastard>
MIME-Version: 1.0
Message-Id: <201110052022.19953@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1629795682993800905=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Liu <jeff.liu@oracle.com>

--===============1629795682993800905==
Content-Type: multipart/signed;
  boundary="nextPart1865917.jtnClSfrVT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1865917.jtnClSfrVT
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 5. Oktober 2011 Dave Chinner wrote:
> It's a data corruption problem, pure and simple....

Thanks for the thorough explanation. So it's a problem when a file has=20
recently been modified and not yet been written back to disk. Would it=20
be worth to force a flush to disk before SEEK_* operations can start? I=20
don't know if it's easier to do all the lookups you suggested, or do an=20
fsync. That could have it's own impacts, though.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1865917.jtnClSfrVT
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6MoFsACgkQzhSR9xwSCbSbAQCfbv/RCH3Q1kvzFvi1FJX8MOck
aJkAn1rmPX1eLAJE93cRKzaaCl1uClpJ
=bS6w
-----END PGP SIGNATURE-----

--nextPart1865917.jtnClSfrVT--


--===============1629795682993800905==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1629795682993800905==--
