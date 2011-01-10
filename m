Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0A7tmHR220814 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 01:55:49 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 80B9624DCCB
	for <xfs@oss.sgi.com>; Sun,  9 Jan 2011 23:57:56 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id fGeIiEhRMPaWbkfT for
	<xfs@oss.sgi.com>; Sun, 09 Jan 2011 23:57:56 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] xfs_repair: multithread phase 2
Date: Mon, 10 Jan 2011 08:57:52 +0100
References: <1294620248-17098-1-git-send-email-david@fromorbit.com>
In-Reply-To: <1294620248-17098-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Message-Id: <201101100857.53421@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1903184001540898707=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1903184001540898707==
Content-Type: multipart/signed;
  boundary="nextPart1393371.eMgovlejhY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1393371.eMgovlejhY
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Montag, 10. Januar 2011 Dave Chinner wrote:
> This patch uses 32-way threading which results in no noticable
> slowdown on single SATA drives with NCQ, but results in ~10x
> reduction in runtime on a 12 disk RAID-0 array.

Is the fixed 32-way number reasonable, or shouldn't that be "number of=20
available cpu cores"-way? Why threading when you have a single core cpu?

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

--nextPart1393371.eMgovlejhY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk0qvAEACgkQzhSR9xwSCbSGcgCgtQLXXb4XdpC1eBk+KQMa+/mS
yZsAn2ZatSYoDhRY7os3SPS5acA3nOFx
=W/PX
-----END PGP SIGNATURE-----

--nextPart1393371.eMgovlejhY--


--===============1903184001540898707==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1903184001540898707==--
