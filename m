Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAQE4IOH168861 for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 08:04:19 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCB9515D9789
	for <xfs@oss.sgi.com>; Fri, 26 Nov 2010 06:05:54 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ESnBmIjoaMqu87t0 for
	<xfs@oss.sgi.com>; Fri, 26 Nov 2010 06:05:54 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Verify filesystem is aligned to stripes
Date: Fri, 26 Nov 2010 15:05:41 +0100
References: <4CED5BFC.8000906@shiftmail.org>
	<20101126091622.264830fa@galadriel.home>
	<20101126122218.GH12187@dastard>
In-Reply-To: <20101126122218.GH12187@dastard>
MIME-Version: 1.0
Message-Id: <201011261505.50658@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2007558401837647749=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

--===============2007558401837647749==
Content-Type: multipart/signed;
  boundary="nextPart1361904.07iAanGdv0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1361904.07iAanGdv0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 26. November 2010 Dave Chinner wrote:
> FWIW, for workloads that do random, small IO, XFS works best when you
> turn off aligned allocation and just let it spray the IO at the
> disks. This works best if you are using RAID 0/1/10. All the numbers
> I've been posting are with aligned allocation turned off (i.e. no
> sunit/swidth set).

That's interesting to read.

Why would sunit/swidth be slower then? I'd thought that XFS then would=20
know one stripe is 64k and I have 8 disks so it should try to pack=20
8*64=3D512kb in one junk on disk, and that especially for small files it=20
would write them like that.

The man page just says inodes, log are stripe aligned, and file tails=20
>512k extended to full stripes on append. I thought that even the=20
inode/log alignment alone would help a lot.

Now what is the advantage on skipping sunit/swidth altogether?
And what is the difference when it's on RAID10 to RAID6?

I'm always eager to understand performance issues ;-)

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

--nextPart1361904.07iAanGdv0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzvvr4ACgkQzhSR9xwSCbThiQCffgjuLp/GIWTeA81J7aj5ooGW
SSIAoLe1AsOF8pLQVHELm4M541o5YGqv
=90Un
-----END PGP SIGNATURE-----

--nextPart1361904.07iAanGdv0--


--===============2007558401837647749==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2007558401837647749==--
