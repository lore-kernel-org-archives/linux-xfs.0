Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5GAMHKa125541 for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 05:22:18 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC9E61599060
	for <xfs@oss.sgi.com>; Wed, 16 Jun 2010 03:28:31 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id hbDn8MH2Syu5FEBX for
	<xfs@oss.sgi.com>; Wed, 16 Jun 2010 03:28:31 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS stack corruption: BUG: unable to handle kernel paging request
Date: Wed, 16 Jun 2010 12:24:50 +0200
References: <201006160810.33045@zmi.at> <20100616094112.GA16216@infradead.org>
In-Reply-To: <20100616094112.GA16216@infradead.org>
MIME-Version: 1.0
Message-Id: <201006161224.50941@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1352013355171651312=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

--===============1352013355171651312==
Content-Type: multipart/signed;
  boundary="nextPart2774406.fudCLS3Rcd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2774406.fudCLS3Rcd
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 16. Juni 2010 Christoph Hellwig wrote:
> This might as well be another stack overflow.  You don't happen to
>  have more lines of the stack trace?  I fear this might be another
>  case of direct reclaim hitting you.

Sorry, no. I thought it looks like it stuck, but that were the last=20
lines, and the VM didn't react anymore, I had to "force shutdown" it.
=20
> Try backporting commit 070ecdca54dde9577d2697088e74e45568f48efb
> "xfs: skip writeback from reclaim context", that should get rid of
> places calling into ->writepage with already deep stack usage.
=20
As I use a standard openSUSE 11.2 kernel, I'll report a bug at Novell=20
and they must fix it. Thank you!

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2774406.fudCLS3Rcd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwYpnIACgkQzhSR9xwSCbQfawCePkqLGluD0PEgRVF1e34hmkvt
u70AoLl9thJplcX370o8ZVc3T2SUXi4A
=sZoH
-----END PGP SIGNATURE-----

--nextPart2774406.fudCLS3Rcd--


--===============1352013355171651312==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1352013355171651312==--
