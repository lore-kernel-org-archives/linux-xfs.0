Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1NEikw8096283 for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 08:44:47 -0600
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCA3F141708
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2009 06:44:14 -0800 (PST)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id iV6ABYT7Sr3lNbqf for
	<xfs@oss.sgi.com>; Mon, 23 Feb 2009 06:44:14 -0800 (PST)
From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [patch] fix tolower issue in xfsprogs
Date: Mon, 23 Feb 2009 09:43:39 -0500
References: <200902221355.44626.vapier@gentoo.org>
	<20090223133109.GB15948@infradead.org>
In-Reply-To: <20090223133109.GB15948@infradead.org>
MIME-Version: 1.0
Message-Id: <200902230943.40061.vapier@gentoo.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0614096910545888747=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

--===============0614096910545888747==
Content-Type: multipart/signed;
  boundary="nextPart1869133.IAJ13hG650";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1869133.IAJ13hG650
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 23 February 2009 08:31:09 Christoph Hellwig wrote:
> On Sun, Feb 22, 2009 at 01:55:40PM -0500, Mike Frysinger wrote:
> > the xfsprogs uses tolower() in xfs_dir2.c but doesnt include ctype.h for
> > the definition
>
> In 3.0.0 and current git <ctype.h> is include in platform_defs.h, so it
> should also be around in xfs_dir2.c.
>
> What xfsprogs tree and what glibc/gcc combination do you see this with?

i forward ported it from the last version.  i didnt expect it to be fixed i=
n a=20
different way ;).  so disregard.
=2Dmike

--nextPart1869133.IAJ13hG650
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iQIcBAABAgAGBQJJorYcAAoJEEFjO5/oN/WBNtYP/R0RcUBdpKrTGf6C2yf/ouIw
9RTs3qD1flEs4RjCNNcP+MIcxGIz8XghJ+gl7Pe/gADV23dokutNbIRqDgfWRMKO
ARKtLosm/cUuGEJNR9/gWZgwDEJa/Q9kzZh4E2qOt4F2sCFlyRwiKCUXL+GPC3B4
L4YiuiqXHUr2z6okgxaYjjuEd67DvG/C2iBaUp5Pu2842/FIAvYwkWMTpEd72H9r
6sMuMuffJdsjR9uKxKABblma3MhoYuUALCvPuGvTVAZkGRBTzY4kp5pYj9jo3syS
Ld7qamUGvD+Eju3qwNyq96ucDYCl6RP49zEehYU4Wuup3mnG6XxB7sPpj7Sg2ojy
PnBcWRFNSzutEJZssWDLasIM4N117qDfrELopnJuzBAo+C7KFVcKrGszqFH4rstt
QcLokcgxLEnN3wptsFAM8CMdYJlel+soCftuWR5s5X2oJP06VgIXGLMLUvJAWxrM
Zvwn/VHGCsYFzgzL41J5BGo2zDyI5lSOkC9wa81XGNLVJdygnW/F83CsTwPinWIs
vc8cmNNMemfwoGN1+fgXx+WdABcPBZrLGRVkgDx+tWmlPqoR2+AQ5ge/4gKQ6JMF
spKsH1Sn90FuANVLUS0MNWlbRN3CXKCsg7xcuvOIaFdiVBKqEACfom9QoYh43wbF
/z/nvZPLyp4eAAivERHK
=3NR/
-----END PGP SIGNATURE-----

--nextPart1869133.IAJ13hG650--


--===============0614096910545888747==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0614096910545888747==--
