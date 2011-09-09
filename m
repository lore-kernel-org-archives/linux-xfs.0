Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89C1a5X038562 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 07:01:36 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2F6319AAAD8
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2011 05:01:34 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id QOCC06aZrnhCh05A for
	<xfs@oss.sgi.com>; Fri, 09 Sep 2011 05:01:34 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs_repair segfaut in stage 6
Date: Fri, 9 Sep 2011 14:01:29 +0200
References: <4E69D1B9.8070201@nasza-klasa.pl>
In-Reply-To: <4E69D1B9.8070201@nasza-klasa.pl>
MIME-Version: 1.0
Message-Id: <201109091401.31422@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1893782197357241172=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Bartosz Cisek <bartosz.cisek@nasza-klasa.pl>

--===============1893782197357241172==
Content-Type: multipart/signed;
  boundary="nextPart2144949.NHM0dsYjkF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2144949.NHM0dsYjkF
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Freitag, 9. September 2011 Bartosz Cisek wrote:
> Distro (Debian 5.0) version of xfs_repair finished with segfault.
> Same with compiled from git. I filled bug report [1]. Can someone
> possibly look into it? As it's hadoop heavy replicated partition I
> keep it only to provide additional information to resolve this
> segfault. I would be happy to provide as much detailed info as
> required, but I need to know what :)

Can you provide a metadump of that partition? By this, the devs can=20
reproduce the bug on their machine, and resolve issues much quicker.

Which kernel and architecture are you on?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart2144949.NHM0dsYjkF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk5qABsACgkQzhSR9xwSCbTy8ACeM4FgdV6a12+zPmfln+HjksCc
JlUAoNyfyAaIY+2N/LEFsnMpNsulIXee
=BLrY
-----END PGP SIGNATURE-----

--nextPart2144949.NHM0dsYjkF--


--===============1893782197357241172==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1893782197357241172==--
