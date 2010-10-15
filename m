Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9F6oK4Z109695 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 01:50:20 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8843FF0B83C
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 00:06:00 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id rR5sBhsXewfNtAd7 for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 00:06:00 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 964FF612
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 08:51:26 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 289CA401C3D
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 08:51:26 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: allocsize mount option,
	was: [PATCH 1/2] xfs: dynamic speculative EOF preallocation
Date: Fri, 15 Oct 2010 08:51:24 +0200
References: <1286187236-16682-1-git-send-email-david@fromorbit.com>
	<1287076965.2362.520.camel@doink> <20101014213325.GF4681@dastard>
In-Reply-To: <20101014213325.GF4681@dastard>
MIME-Version: 1.0
Message-Id: <201010150851.25327@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5861106196354021829=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5861106196354021829==
Content-Type: multipart/signed;
  boundary="nextPart1443033.DaVMIT4RC6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1443033.DaVMIT4RC6
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 14. Oktober 2010 Dave Chinner wrote:
> > I guess the reason one might want the "allocsize" mount
> > option now becomes the opposite of why one might have
> > wanted it before.  I.e., it would be used to reduce
> > the size of the preallocated range beyond EOF, which I
> > could envision might be reasonable in some circumstances.
>=20
> It now becomes the minimum preallocation size, rather than both the
> minimum and the maximum....

Until now, I often set allocsize to be <nr of data disks>*<stripe size>,=20
i.e. in a 8 disk RAID-6 with 64KB stripe size =3D 6*64 =3D 384KB
I guess this should provide the best performance.

Is my assumption true?
Will it change with the new code?
Does XFS automatically use allocsize=3D<1 full stripe> so I can skip my=20
manual allocsize options?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1443033.DaVMIT4RC6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAky3+e0ACgkQzhSR9xwSCbRh5wCgqTAOJbn1vd1YMMdNBlR35V6f
LsEAoNMCfJQiOKzFfhTDPfQOBGPwX6Zc
=Y1nm
-----END PGP SIGNATURE-----

--nextPart1443033.DaVMIT4RC6--


--===============5861106196354021829==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5861106196354021829==--
