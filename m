Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p595nola151643 for <xfs@oss.sgi.com>; Thu, 9 Jun 2011 00:49:50 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 790B316CB394
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2011 22:49:39 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 259Zl9RZxEUgwYDK for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2011 22:49:39 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Defragging XFS File Systems
Date: Thu, 9 Jun 2011 07:49:36 +0200
References: <BANLkTi=40mmE+DCbLcSWBwNQtWpP=N=tXw@mail.gmail.com>
	<BANLkTikBSL8-eTAbF7a94ckLuZNyWCM=Eg@mail.gmail.com>
	<4DEFE2E6.9010206@hardwarefreak.com>
In-Reply-To: <4DEFE2E6.9010206@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201106090749.37745@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7789818342367594217=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Kenneth Emerson <kenneth.emerson@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>

--===============7789818342367594217==
Content-Type: multipart/signed;
  boundary="nextPart6522634.uoPHKelKRm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart6522634.uoPHKelKRm
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 8. Juni 2011 Kenneth wrote:
> > After that, I will make
> > a cron job to run on a regular basis to keep the volume from
> > getting so fragmented again.

How will you do that? Running xfs_fsr on a regular basis is *not*=20
recommended, as it will age your filesystem and defrag free space. In=20
the beginning, and as long as your filesystem is maybe 50% full it will=20
be fine, but there's a point where it starts to get worse - much worse.=20
Just run a recent kernel, it has all the naughty stuff to help keep the=20
performance high.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart6522634.uoPHKelKRm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk3wXvEACgkQzhSR9xwSCbRiAgCgwfIVBex3a+dVhzWrRsbE6bbC
ghUAoIvCX1eZ0UsvsD3EhopnJ2Wx5KIW
=z12n
-----END PGP SIGNATURE-----

--nextPart6522634.uoPHKelKRm--


--===============7789818342367594217==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7789818342367594217==--
