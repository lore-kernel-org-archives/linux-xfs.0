Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p41FTOrq181751 for <xfs@oss.sgi.com>; Sun, 1 May 2011 10:29:25 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37D8442466E
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 08:32:58 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 9HLnSSWKdvJnH5hs for
	<xfs@oss.sgi.com>; Sun, 01 May 2011 08:32:58 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 54760522
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 17:32:57 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 8A319401C3A
	for <xfs@oss.sgi.com>; Sun,  1 May 2011 17:32:56 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs performance problem
Date: Sun, 1 May 2011 17:32:51 +0200
References: <4DB72084.8020205@inf.ethz.ch> <20110501084919.GE13542@dastard>
	<19901.28769.553575.864887@tree.ty.sabi.co.UK>
In-Reply-To: <19901.28769.553575.864887@tree.ty.sabi.co.UK>
MIME-Version: 1.0
Message-Id: <201105011732.56226@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1577989966402129292=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1577989966402129292==
Content-Type: multipart/signed;
  boundary="nextPart2760581.x8BJke0XJx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2760581.x8BJke0XJx
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sonntag, 1. Mai 2011 Peter Grandi wrote:
>   But when one sees comical "performance" comparisons without
>   even cache flushing, explaining the difference between a
>   performance problem and different safety/speed tradeoffs seems
>   a bit wasted.

Before people run aroung peeing each other on the leg, I'd like to bring=20
this back from "benchmarking" to "user experience". The OP didn't=20
benchmark, he just noticed that on ext3 unpacking the kernel source was=20
much faster than on XFS, on his machine.

Step back from "benchmarking", and just read the words, forget about=20
benchmarks. With ext3, the user can start "make menuconfig" much earlier=20
than with xfs. In this specific case, the user is not interested if it's=20
safer, or already on disk, or running in the background. The user want's=20
to do his work, period. And that is - for this specific case on his=20
hardware (and probably on every hardware?) - much quicker with ext3 than=20
with xfs.

I'd be interested why it is like that, and if there is anything to do=20
about it in xfs to become faster, or as-fast-as ext3, for this specific=20
case?

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

--nextPart2760581.x8BJke0XJx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk29fSgACgkQzhSR9xwSCbRJxQCgmMvPxVYaTFYZKZAgihu9X1Ot
CAIAn31dlmYVDPcThwIzgn/Otb7MZaF2
=PTRe
-----END PGP SIGNATURE-----

--nextPart2760581.x8BJke0XJx--


--===============1577989966402129292==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1577989966402129292==--
