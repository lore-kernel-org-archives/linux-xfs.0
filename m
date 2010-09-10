Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8A0PEci123256 for <xfs@oss.sgi.com>; Thu, 9 Sep 2010 19:25:15 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8552E5FA1D
	for <xfs@oss.sgi.com>; Thu,  9 Sep 2010 17:25:58 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id yTei7O3HnCzKXkEw for
	<xfs@oss.sgi.com>; Thu, 09 Sep 2010 17:25:58 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS over LVM over md RAID
Date: Fri, 10 Sep 2010 02:25:55 +0200
References: <4C89668E.6010800@sauce.co.nz>
In-Reply-To: <4C89668E.6010800@sauce.co.nz>
MIME-Version: 1.0
Message-Id: <201009100225.55562@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5252161915916266435=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Richard Scobie <richard@sauce.co.nz>

--===============5252161915916266435==
Content-Type: multipart/signed;
  boundary="nextPart2528604.4v7vTErqGj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2528604.4v7vTErqGj
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 10. September 2010 Richard Scobie wrote:
> Limited testing using dd and bonnie++ shows no difference in write=20
> performance
=20
=46or dd it should always show the same, as you just sequentially write a=20
large file. Only with bonnie you would see differences due to stripe=20
sets, as the speed only drops when doing I/O not on boundaries and/or=20
smaller than the stripe size, as the stripe size is the smallest=20
possible I/O for the RAID.

I don't know why you don't see any difference with bonnie though.

=46WIW, a stripe set of 256k means you do read/write 256k from a single=20
drive on each I/O, then the next 256k from the next drive. I hope you=20
have very few small accesses and mostly very large files. If you'd use a=20
database on that system it would crawl...

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

--nextPart2528604.4v7vTErqGj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyJexMACgkQzhSR9xwSCbSFBQCcDb66Gf1DQbvjwNm1ZKCkf/r6
f84Ani5C9YmoYTWjFYz+mDru5z+0X0G7
=19TG
-----END PGP SIGNATURE-----

--nextPart2528604.4v7vTErqGj--


--===============5252161915916266435==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5252161915916266435==--
