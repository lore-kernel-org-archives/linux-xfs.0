Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oANKQ6YF002758 for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 14:26:07 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0B95719F66B
	for <xfs@oss.sgi.com>; Tue, 23 Nov 2010 12:27:41 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Z9WgQOSnRRmCnUoo for
	<xfs@oss.sgi.com>; Tue, 23 Nov 2010 12:27:41 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Improving XFS file system inode performance
Date: Tue, 23 Nov 2010 21:27:36 +0100
References: <4CEAE7D7.6050401@ssec.wisc.edu> <20101122234419.GK13830@dastard>
	<4CEBD47F.1040004@ssec.wisc.edu>
In-Reply-To: <4CEBD47F.1040004@ssec.wisc.edu>
MIME-Version: 1.0
Message-Id: <201011232127.37796@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4321460958974544281=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jesse Stroik <jstroik@ssec.wisc.edu>

--===============4321460958974544281==
Content-Type: multipart/signed;
  boundary="nextPart3146334.4FdljxVhAf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart3146334.4FdljxVhAf
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 23. November 2010 Jesse Stroik wrote:
> As this file system is likely to continue to increase in number of
> files  at a fairly rapid rate, we're going to need a long term
> strategy.  I suspect it may be necessary in the near future to
> double or quadruple the memory to 32GB or 64GB, but the uncertainty
> in the formula makes me nervous.

Using tools like "munin" helps you see the problem in graphs, so you can=20
easily check what's going on. Munin draws graphs from a lot of=20
parameters of a system, and helped me find problems that you couldn't=20
find otherwise.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// ****** Radiointerview zum Thema Spam ******
// http://www.it-podcast.at/archiv.html#podcast-100716
//=20
// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart3146334.4FdljxVhAf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzsI7kACgkQzhSR9xwSCbQM1ACgv6O6JkxK7RWu32wC9MBY29e+
pQIAn0QCzW+U8YR+ev+ZGx4+jntF8cxa
=hrW1
-----END PGP SIGNATURE-----

--nextPart3146334.4FdljxVhAf--


--===============4321460958974544281==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4321460958974544281==--
