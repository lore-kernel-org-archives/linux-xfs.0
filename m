Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6O8lPqV199827 for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 03:47:26 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 92D98914BA
	for <xfs@oss.sgi.com>; Sun, 24 Jul 2011 01:47:22 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 6mM3y5y0K0DnRvtW for
	<xfs@oss.sgi.com>; Sun, 24 Jul 2011 01:47:22 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 30 TB RAID6 + XFS slow write performance
Date: Sun, 24 Jul 2011 10:47:14 +0200
References: <4E24907F.6020903@johnbokma.com> <20110722231040.GD13963@dastard>
	<4E2BB859.1050200@hardwarefreak.com>
In-Reply-To: <4E2BB859.1050200@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201107241047.19745@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9088312199819216526=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Stan Hoeppner <stan@hardwarefreak.com>, John Bokma <contact@johnbokma.com>

--===============9088312199819216526==
Content-Type: multipart/signed;
  boundary="nextPart11608949.DTXs0jgHZ8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart11608949.DTXs0jgHZ8
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sonntag, 24. Juli 2011 Stan Hoeppner wrote:
> Is the NetApp FC/iSCSI attachment performance still competitive for
> large file/streaming IO, given that one can't optimize XFS stripe
> alignment, and with no indication of where the file fragments are
> actually written on the media?  Or does it lag behind something like
> a roughly equivalent class Infinite Storage array, or IBM DS?

I can't tell about performance difference. But I'd like to explain two=20
fundamental differences to all other storages:

1) WAFL *never* overwrites an existing block. Whenver there's a write to=20
an existing block, that block is instead written to a new location,=20
afterwards the old block mapped to the new one. This is a key factor to=20
keeping performance up when using snapshots and deduplication.

2) WAFL never does small or random writes. All writes are collected in=20
NVRAM, and then written as one large sequential write, always one full=20
stripe is written.

That means for workloads with lots of small random writes, NetApp=20
storages beat the hell out of the disks, compared to other storages.
I can't tell for large seq. writes, though, I don't have such workload.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart11608949.DTXs0jgHZ8
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk4r3BcACgkQzhSR9xwSCbRVyACcCpU4gtuSkBzlG03EvgBpNQEa
ftAAoOKdKHdugUNpvfMoRsKfunJzaApS
=kyZP
-----END PGP SIGNATURE-----

--nextPart11608949.DTXs0jgHZ8--


--===============9088312199819216526==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9088312199819216526==--
