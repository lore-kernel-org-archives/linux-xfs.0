Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7BAonjD218677 for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 05:50:50 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id M0YRErjNyO8C4pzF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 11 Aug 2012 03:50:48 -0700 (PDT)
Received: from mailsrv.i.zmi.at (mailgate.i.zmi.at [10.72.17.3])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPS id 46E20180017C
	for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 12:50:46 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id 39C03C8C449
	for <xfs@oss.sgi.com>; Sat, 11 Aug 2012 12:50:53 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs warnings on kernel 3.2.15
Date: Sat, 11 Aug 2012 12:50:45 +0200
Message-ID: <6314061.2K1xYxIYlT@saturn>
In-Reply-To: <20120809221518.GW2877@dastard>
References: <1918987.4hlisJiio3@saturn> <20120809221518.GW2877@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7345642255742905021=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============7345642255742905021==
Content-Type: multipart/signed; boundary="nextPart2924221.JnQfrq2kbS"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart2924221.JnQfrq2kbS
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Freitag, 10. August 2012, 08:15:18 schrieb Dave Chinner:
> The freeze/thaw deadlock is not fixed in 3.5 and i think it missed
> 3.6 as well so you're going to be waiting until 3.7 for this to be
> fixed, I suspect....

OK, at least you guys have a plan for a fix. I'm happy to get that fixe=
d=20
soon. Thank you.

But when I think about it: Isn't that worth a backport fix? VMware isn'=
t=20
a seldom used piece of software, and we use NetApp Storage with =20
snapshots, which is also used a lot worldwide. I can imagine others hav=
e=20
the same problem, or is it just me?

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart2924221.JnQfrq2kbS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAlAmOQUACgkQzhSR9xwSCbS/LACgkgJ+bvB+fQlVsd2WvfDNocxu
91YAoJw0CpYJusPsnGRnczLUOuzOYvx9
=CHn4
-----END PGP SIGNATURE-----

--nextPart2924221.JnQfrq2kbS--


--===============7345642255742905021==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7345642255742905021==--
