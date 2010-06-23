Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5NADesW018807 for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 05:13:40 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A07114AE620
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 03:20:36 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id nAFXF54qEU2CXcRF for
	<xfs@oss.sgi.com>; Wed, 23 Jun 2010 03:20:36 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 3756D17E
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 12:16:19 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id E53A083C828
	for <xfs@oss.sgi.com>; Wed, 23 Jun 2010 12:15:56 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: XFS peculiar behavior
Date: Wed, 23 Jun 2010 12:16:18 +0200
References: <4C21B9AF.9010307@ics.forth.gr>
In-Reply-To: <4C21B9AF.9010307@ics.forth.gr>
MIME-Version: 1.0
Message-Id: <201006231216.18514@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1697247889793324755=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1697247889793324755==
Content-Type: multipart/signed;
  boundary="nextPart2530792.x7bXYLASVb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart2530792.x7bXYLASVb
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Mittwoch, 23. Juni 2010 Yannis Klonatos wrote:
> The problem is that i have noticed that XFS may - not all times=20
> - split a table over a large disk distance.
=20
Interesting. I have no idea why this happens and would be interested in=20
investigation too.

As a quick help, maybe using allocsize=3D1G in the xfs mount options would=
=20
help?

How many AGs does the filesystem have?=20
And which version of mkfs.xfs do you use?
Newer xfsprogs create the disk with 4 AGs per default, maybe that=20
influences the allocation order?

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart2530792.x7bXYLASVb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkwh3vIACgkQzhSR9xwSCbRWOQCcCcwPVMcTPkN6Jf8QIO8qL9bp
7K4AnijlonxfWFryde24uKG6WXtPzpWJ
=Q0eC
-----END PGP SIGNATURE-----

--nextPart2530792.x7bXYLASVb--


--===============1697247889793324755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1697247889793324755==--
