Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DAZNdc048511 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 05:35:23 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B810B17015F3
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 03:35:47 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id NJlp9PADayesbwE8 for
	<xfs@oss.sgi.com>; Fri, 13 Aug 2010 03:35:47 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: observed significant performance improvement using "delaylog" in
Date: Fri, 13 Aug 2010 12:35:44 +0200
References: <201008121346.30760.eye.of.the.8eholder@gmail.com>
	<i41q43$6td$1@dough.gmane.org> <4C6516CA.2010602@hardwarefreak.com>
In-Reply-To: <4C6516CA.2010602@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201008131235.45050@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7976163758385455507=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>

--===============7976163758385455507==
Content-Type: multipart/signed;
  boundary="nextPart2865155.WHU4dXdg73";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2865155.WHU4dXdg73
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 13. August 2010 Stan Hoeppner wrote:
> Some benchmark results maybe worth a look:
> http://btrfs.boxacle.net/repository/raid/2.6.35-rc5/2.6.35-rc5/
=20
Thanks - it would have been great to see xfs with delaylog in that=20
comparison, but the graphs are very very nice.

XFS seems performing better the more threads there are, just in "large=20
file random reads" it's the slowest - why this?

A test with "lots of small files in a dir" would be great, something=20
like the squid cachedir or just a single dir with >5.000 files in it.

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

--nextPart2865155.WHU4dXdg73
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxlIAAACgkQzhSR9xwSCbTcvwCg9ZKY69RHMfnDV8H8SFS63o8L
pCIAoI6TjQsBxFPym5dbmFv1/z0ITLKz
=vn0r
-----END PGP SIGNATURE-----

--nextPart2865155.WHU4dXdg73--


--===============7976163758385455507==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7976163758385455507==--
