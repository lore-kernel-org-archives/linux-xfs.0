Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9OILZNv146973 for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 13:21:35 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EDF734EC5F6
	for <xfs@oss.sgi.com>; Sun, 24 Oct 2010 11:22:49 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id y8axtOaXuCDXWtrc for
	<xfs@oss.sgi.com>; Sun, 24 Oct 2010 11:22:49 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS use within multi-threaded apps
Date: Sun, 24 Oct 2010 20:22:46 +0200
References: <AANLkTi=w1o8EF6-M7o8Qi9VpY-10m+MCR8U+K1_Aze=g@mail.gmail.com>
	<AANLkTikcgqA_cPLyMOXkgbu_PLkZRQ7qmch+LZdp_L6H@mail.gmail.com>
	<AANLkTi=RZ=qf5xqMQNZjZaikAdw12PzbzD3vo-hZfNHT@mail.gmail.com>
In-Reply-To: <AANLkTi=RZ=qf5xqMQNZjZaikAdw12PzbzD3vo-hZfNHT@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201010242022.46693@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5404774446461160786=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Angelo McComis <angelo@mccomis.com>

--===============5404774446461160786==
Content-Type: multipart/signed;
  boundary="nextPart2290361.hddsnaoA1n";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2290361.hddsnaoA1n
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Samstag, 23. Oktober 2010 Angelo McComis wrote:
> They quoted having 10+TB databases running OLTP on EXT3 with
> 4-5GB/sec sustained throughput (not XFS).

Which servers and storage are these? This is nothing you can do with=20
"normal" storages. Using 8Gb/s Fibre Channel gives 1GB/s, if you can do=20
full speed I/O. So you'd need at least 5 parallel Fibre Channel storages=20
running without any overhead. Also, a single server can't do that high=20
rates, so there must be several front-end servers. That again means=20
their database must be especially organised for that type of load=20
(shared nothing or so).

On the other hand, if they have these performance numbers on 100 shared=20
serves, it only needs 51MB/s per server of I/O to get 5GB/s total=20
throughput. So that is a number without a lot of meaning, as long as you=20
don't know which hardware is used.

And: how high would be their throughput when using XFS instead EXT3? ;-)

One question comes to my mind: if they do direct I/O, would there still=20
be a lot of difference between XFS and EXT3, performance wise?

And how many companies run around telling which filesystem they use for=20
their performance critical business application? Normally they do this=20
only for marketing, so they get paid or special prices if they say "with=20
this product we are sooo happy".

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Radiointerview zum Thema Spam ******
http://www.it-podcast.at/archiv.html#podcast-100716

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2290361.hddsnaoA1n
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzEeXYACgkQzhSR9xwSCbSVUACfYnRioogg1CHego2mFUW9mf8h
nJgAn0qqjq4m2ruiJE3ZRXYabTVP37He
=+trC
-----END PGP SIGNATURE-----

--nextPart2290361.hddsnaoA1n--


--===============5404774446461160786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5404774446461160786==--
