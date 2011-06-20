Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5KBjYOJ143033 for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 06:45:35 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BE37E1D0BD
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2011 04:45:33 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id uJUf9mHuY1QDSCRu for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2011 04:45:33 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: long hangs when deleting large directories (3.0-rc3)
Date: Mon, 20 Jun 2011 13:45:28 +0200
References: <20110618141950.GA1685@x4.trippels.de>
	<20110620060351.GC1730@x4.trippels.de>
	<20110620111359.GA12632@x4.trippels.de>
In-Reply-To: <20110620111359.GA12632@x4.trippels.de>
MIME-Version: 1.0
Message-Id: <201106201345.30271@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3953391230250184466=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>

--===============3953391230250184466==
Content-Type: multipart/signed;
  boundary="nextPart6937668.O5YjFQhyis";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6937668.O5YjFQhyis
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 20. Juni 2011 Markus Trippelsdorf wrote:
> Here are two more examples. The time when the hang occurs is marked

Could it be that some sectors on the disk are not easy to read for the=20
drive, and that it simply retries several times until it works again?=20
SATA disks can show that behaviour. You could try with "dd" with=20
seek/skip parameters so you read 1gb at once, then skip 1gb and read 1gb=20
again etc, and compare the throughput over all 1gb areas. If there's one=20
slower, that might be the problem.

Maybe a check with "smartctl" could help, too.

Just an idea because during your hang, no CPU or I/O is done, so I guess=20
it wouldn't be the fault of Linux/XFS or other software, but more=20
hardware.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart6937668.O5YjFQhyis
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3/MtoACgkQzhSR9xwSCbSLLQCgkAMc1l0dAvG1Zqfu51d12KzJ
CysAn2fBRYzIZTlayXuhY1h2Ox1QPxx1
=yuN6
-----END PGP SIGNATURE-----

--nextPart6937668.O5YjFQhyis--


--===============3953391230250184466==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3953391230250184466==--
