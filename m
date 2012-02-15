Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FBd2J0171666 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 05:39:02 -0600
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 6hXATCOuWCWxlgTP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 03:38:59 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: File system remain unresponsive until the system is rebooted.
Date: Wed, 15 Feb 2012 12:38:52 +0100
Message-ID: <1851847.umXsU4b99o@saturn>
In-Reply-To: <20267.5137.85650.499331@tree.ty.sabi.co.UK>
References: <CANs4eSBWLc4HxAbPZ8kOVOdJ7RKiA+-ai3Q2J+FAyuzHtUqfdg@mail.gmail.com>
	<20265.9379.139218.148520@tree.ty.sabi.co.UK>
	<20267.5137.85650.499331@tree.ty.sabi.co.UK>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8898089946839186363=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============8898089946839186363==
Content-Type: multipart/signed; boundary="nextPart2689817.rsmQsc8qEe"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart2689817.rsmQsc8qEe
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Donnerstag, 2. Februar 2012, 22:54:09 schrieb Peter Grandi:
> This then the argument that on platforms with bad latency that
> decision works still works well because then you might as well go
> for throughput.

Hi, I just took these lines to reply to your whole mail. I guess that=20=

the advantage of XFS will grow on a shared storage type like you=20
typically have on a VM environment. The aggregation XFS does can result=
=20
in a more bursty type of I/O, with larger I/Os happening at once. That=20=

always is better for RAID storage - which you normally have in a VM=20
environment. Also, all better RAID controllers, and especially=20
enterprise RAIDs, have large write buffers, so even more aggregation=20=

occurs at the storage itself, helping throughput maximisation.

I don't know of any scientific investigation of "which filesystem is=20=

better in a VM environment" that could be referenced in a generic way,=20=

mostly because there are so many variables there that it doesn't=20
neccessarily fit your own use case. Maybe someone can point me to such=20=

research material.
My hope is - and that is what Dave is arguing - that minimising I/O=20
"disturbances" by metadata work like log file handling helps keeping=20=

overall throughput on a shared storage type in a VM environment high.=20=

And that seems very reasonable.=20
I don't really understand your argument about delay for a single thread=
=20
fsync. First, XFS should do this quicker by "batching" transactions, an=
d=20
second, overall storage throughput is usually much more important than=20=

that of a single server performance - at least in a VM environment. I=20=

need to run 50 servers on a storage with acceptable performance, and if=
=20
one server needs more performance than is available, you need to do=20
something else - there are lots of options then.

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart2689817.rsmQsc8qEe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk87mVAACgkQzhSR9xwSCbRYFACfVgpqGfkwJJQnzBqb8oJRJuw9
HKkAnivoTJfhPsKKfbIw/hTIlvHfOgce
=rMpR
-----END PGP SIGNATURE-----

--nextPart2689817.rsmQsc8qEe--


--===============8898089946839186363==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8898089946839186363==--
