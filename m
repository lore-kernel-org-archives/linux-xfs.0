Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o822FCNJ176846 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 21:15:13 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 113B043768
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 19:15:50 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id GRPbr8YTZw3BQC7H for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 19:15:50 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: deleting 2TB lots of files with delaylog: sync helps?
Date: Thu, 2 Sep 2010 04:15:47 +0200
References: <201009010130.41500@zmi.at> <201009010945.59204@zmi.at>
	<20100902011744.GS705@dastard>
In-Reply-To: <20100902011744.GS705@dastard>
MIME-Version: 1.0
Message-Id: <201009020415.47780@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8257227342136485997=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============8257227342136485997==
Content-Type: multipart/signed;
  boundary="nextPart4293878.8aUhJjGV4m";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4293878.8aUhJjGV4m
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 2. September 2010 Dave Chinner wrote:
> 	-> free block

Is the SSD-needed "trim" belonging into here?

> In contrast, XFS CPU consumption increases per-operation in a
> predictable fashion - O(log n) where n is the number of directory
> entries. e.g for 4k directory blocks it increases by ~2x from 100k
> entries to 1m entries, and another 2x from 1M entries to 10M entries
> and so on, but the result is that the IO patterns are rarely enough
> to cause operations to become seek bound.

Now I understand, thanks again for that great explanation.

> > Maybe there should be an extra SSE4 assembler instruction "rm on
> > XFS" so we can delete files faster? ;-)
>=20
> You'd need an entire ASIC, not an instruction ;)

Time to invent the "XFS rm co-processor". Should be multi-core so it=20
scales better. Maybe someone writes a graphics cards plugin for XFS?=20
Then we'd see an increase of servers with fast GFX cards "because we=20
need to delete files quickly". And at times no users are deleting files,=20
the admins can play Doom on the servers. ;-)

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

--nextPart4293878.8aUhJjGV4m
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkx/CNMACgkQzhSR9xwSCbSAzACfcMyI/4C7W9sKoRDcQ2A7hWTW
1yUAoPXrRMm5lMTR2kXhqbSt9n2TgMvK
=t/OO
-----END PGP SIGNATURE-----

--nextPart4293878.8aUhJjGV4m--


--===============8257227342136485997==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8257227342136485997==--
