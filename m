Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PELpOv237662 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 09:21:52 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D6E4151E649
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 07:21:47 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id JEhZFAtJJKufnNsG for
	<xfs@oss.sgi.com>; Mon, 25 Oct 2010 07:21:47 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id C6B5B17E
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 16:06:17 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 05365401C3E
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 16:06:16 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS Test Results Interpretation
Date: Mon, 25 Oct 2010 16:06:16 +0200
References: <3C5E029826A0704DB5998577FCFF46F0095A278CEB@dagobah>
	<4CC5894D.6090409@hardwarefreak.com>
In-Reply-To: <4CC5894D.6090409@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201010251606.16653@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6016030843605800027=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6016030843605800027==
Content-Type: multipart/signed;
  boundary="nextPart2664295.82zSuIWjl5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2664295.82zSuIWjl5
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 25. Oktober 2010 Stan Hoeppner wrote:
> > Kernel:  2.6.18-128.el5
>=20
> You need a much newer kernel.  2.6.18 is ancient released in 2006,
> though CentOS have patched the bejesus out of it--128 times.

Oh, I didn't look at that.

2.6.18 is a performance killer compared to an actual 2.6.36 kernel.=20
There's been so much work in between. If you can, try a 2.6.36 and=20
compare your performance. Everything will be a lot faster than with=20
2.6.18. You don't need to fiddle with mkfs/mount options, just upgrade=20
the kernel and without any other tuning you will be much faster than=20
before.

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

--nextPart2664295.82zSuIWjl5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzFjtgACgkQzhSR9xwSCbQ8uQCeJC5v/yuueR30FKliKM9DK8Na
VmkAn1G0Z3N6padt3vkQNPaWUjmMwd1d
=Fboq
-----END PGP SIGNATURE-----

--nextPart2664295.82zSuIWjl5--


--===============6016030843605800027==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6016030843605800027==--
