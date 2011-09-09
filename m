Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p897KDgC024931 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 02:20:13 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74BDA14953E
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 00:19:58 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id Ei0eUGaofQYXEXQX for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2011 00:19:58 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: ENOSPC and filesystem shutdowns
Date: Fri, 9 Sep 2011 09:19:54 +0200
References: <CAKxAxjFgBd0Vt02m7FJKq_ZWNBBJ5B=N4u7kS69FKtOKT4UowA@mail.gmail.com>
	<20110905074734.GA18504@infradead.org>
	<CAKxAxjFUMrQpb5kQUdpRdt2wx83oKxaLZPTVTR_j43dkhcOyyw@mail.gmail.com>
In-Reply-To: <CAKxAxjFUMrQpb5kQUdpRdt2wx83oKxaLZPTVTR_j43dkhcOyyw@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201109090919.56571@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0045772589955353804=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Bernard Chan <bernard@goanimate.com>

--===============0045772589955353804==
Content-Type: multipart/signed;
  boundary="nextPart1391161.n0aCtLg6df";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1391161.n0aCtLg6df
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 8. September 2011 Bernard Chan wrote:
> ENOSPC

There have been some "optimizations" for NFS in earlier kernel, leading=20
to large space reservation per open file. Marc Lehman yelled at that=20
early August in thread "frequent kernel BUG and lockups - 2.6.39 +=20
xfs_fsr". Maybe that's your problem too? Do you use "allocsize=3D" mount=20
option? It could be your new kernel version fixed that, but I can't=20
tell, as I'm not a dev.

inode64 helps in case there is no more space in the area <1TB. As you=20
have "only" 4TB, chances are it wouldn't make a difference for you.=20
Somebody once posted a [perl?] script on this list to find out how much=20
space is left at <1TB, maybe that can be of help.

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart1391161.n0aCtLg6df
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk5pvhwACgkQzhSR9xwSCbQPHACeN/2OUmNaZbeoBexGY8BfmBCz
jxkAmwd9pEz1F42F0KKGhLW0Cp+LePkc
=+GxI
-----END PGP SIGNATURE-----

--nextPart1391161.n0aCtLg6df--


--===============0045772589955353804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0045772589955353804==--
