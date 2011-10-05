Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p957YXSB098439 for <xfs@oss.sgi.com>; Wed, 5 Oct 2011 02:34:33 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 59B281AA73E
	for <xfs@oss.sgi.com>; Wed,  5 Oct 2011 00:34:30 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id vKhYzfo7ifJ0ZvT7 for
	<xfs@oss.sgi.com>; Wed, 05 Oct 2011 00:34:30 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: SEEK_DATA/SEEK_HOLE support
Date: Wed, 5 Oct 2011 09:34:26 +0200
References: <4E887D7F.2010306@oracle.com>
	<20111004130208.GA19263@infradead.org>
	<20111005043659.GO3159@dastard>
In-Reply-To: <20111005043659.GO3159@dastard>
MIME-Version: 1.0
Message-Id: <201110050934.28021@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1899291915723994964=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Liu <jeff.liu@oracle.com>

--===============1899291915723994964==
Content-Type: multipart/signed;
  boundary="nextPart2149952.jUjddvHKbl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2149952.jUjddvHKbl
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 5. Oktober 2011 Dave Chinner wrote:
> That will only work if you can prevent concurrent unwritten extent
> conversion from happening while we do the separate tag lookups on
> the range because it requires two radix tree tag lookups rather than
> just one index lookup. i.e. miss the dirty page because it went
> dirty->writeback during the dirty tag search, and miss the same page
> when doing the writeback lookup because it went writeback->clean
> very quickly due to IO completion.
>=20
> So to stop that from happening, it requires that filesystems can
> exclude unwritten extent conversion from happening while a
> SEEK_HOLE/SEEK_DATA operation is in progress, and that the
> filesystem can safely do mapping tree lookups while providing that
> extent tree exclusion.  I know that XFS has no problems here, but
> filesystems that use i_mutex for everything might be in trouble.
>=20
> Besides, if we just look for pages in the cache over unwritten
> extents (i.e. someone has treated it as data already), then it can
> be done locklessly without having to worry about page state changes
> occurring concurrently...

I'd like to understand why it's important to care about locking here. As=20
I understand it, SEEK_* is used for example to copy a file efficiently.=20
If that is performed on a file that is currently being written to, the=20
resulting copy will probably be bogus anyway, even without SEEK_* usage.

There might be a case where it is important, but I can't see that atm.=20

If I understand it correctly, then if we do not lock during SEEK_*=20
operations, a part of the file might be missed to copy, but that's only=20
for cases where the source file is being written to. If that file is=20
100GB size (to be extreme), and we copy it while it's modified, we will=20
almost for sure have a copy that is partly modified, partly not,=20
depending on which area was modified before read and which not. So=20
where's the point?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2149952.jUjddvHKbl
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk6MCIMACgkQzhSR9xwSCbRXhQCgzvMDozhlHhnq4IxOBunAu5ZC
H+UAn2MYpU9Q+cGXX8tWxGJhQh8ElbK+
=8VT5
-----END PGP SIGNATURE-----

--nextPart2149952.jUjddvHKbl--


--===============1899291915723994964==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1899291915723994964==--
