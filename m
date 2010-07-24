Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6OMWQbH025581 for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 17:32:27 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CF9D046F4D4
	for <xfs@oss.sgi.com>; Sat, 24 Jul 2010 15:35:28 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id 0cQpmiRCAnjl58qj for
	<xfs@oss.sgi.com>; Sat, 24 Jul 2010 15:35:28 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: 4k sector drives
Date: Sun, 25 Jul 2010 00:35:21 +0200
References: <201007211333.48363.eye.of.the.8eholder@gmail.com>
	<20100724084751.GA32006@infradead.org>
	<4C4B55F7.2090501@sandeen.net>
In-Reply-To: <4C4B55F7.2090501@sandeen.net>
MIME-Version: 1.0
Message-Id: <201007250035.25946@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3085511271583519852=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>

--===============3085511271583519852==
Content-Type: multipart/signed;
  boundary="nextPart1832371.Z87ZipIt1g";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1832371.Z87ZipIt1g
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Samstag, 24. Juli 2010 Eric Sandeen wrote:
> > If it really is one using -s size=3D4096 is the right thing to do.
>=20
> Haven't read the whole thread so maybe this is redundant, but make
> sure all partitions (if any) are 4k aligned as well (unless it has
> the secret-handshake sector 63 offset...)
=20
Thank you Christoph for clarification, also thanks to Eric - I've been=20
aligning all partitions to a multiple of 512 sectors since a long time,=20
which fits all stripe set sizes up to 256k. Too bad that even Linux=20
fdisk and parted still don't do something like that, today I setup a=20
Novell SLES 11 with XEN VM, and everywhere parted would align the first=20
partition (when using GPT) to sector 34.. what a number.. Good that 4K=20
sector drives arrive now, so the tools will hopefully change for a=20
better default.

BTW: AFAIK SSD drives have a (sometimes very large) internal alignment=20
of bytes which should be used as a "stripe size" to meet the optimal I/O=20
size. Is there a way to find out how big that is yet?

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

--nextPart1832371.Z87ZipIt1g
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxLaq0ACgkQzhSR9xwSCbSJhgCgsYvNMpqo3p5A+aoFROUo027A
lc4AnjmhF0uJH4Fo5gn5FIwakNzSWzdH
=6tU4
-----END PGP SIGNATURE-----

--nextPart1832371.Z87ZipIt1g--


--===============3085511271583519852==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3085511271583519852==--
