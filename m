Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4T6aw1g036501 for <xfs@oss.sgi.com>; Fri, 29 May 2009 01:37:00 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 880C71300EBF
	for <xfs@oss.sgi.com>; Thu, 28 May 2009 23:43:17 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id bxng5C8rDYfxewP1 for
	<xfs@oss.sgi.com>; Thu, 28 May 2009 23:43:17 -0700 (PDT)
Received: from mailsrv2.i.zmi.at (h081217106033.dyn.cm.kabsi.at
	[81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv1.zmi.at (Postfix) with ESMTP id 51EEE10D1
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 08:37:11 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.0.0.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv2.i.zmi.at (Postfix) with ESMTPSA id 7AEC540DC06
	for <xfs@oss.sgi.com>; Fri, 29 May 2009 08:37:11 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH, RFC] xfsprogs: add xfs_reno(8)
Date: Fri, 29 May 2009 08:37:06 +0200
References: <20090528151804.GA31976@infradead.org>
In-Reply-To: <20090528151804.GA31976@infradead.org>
MIME-Version: 1.0
Message-Id: <200905290837.11098@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0756524896186902661=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0756524896186902661==
Content-Type: multipart/signed;
  boundary="nextPart1395188.s3BalkoJBi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1395188.s3BalkoJBi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Donnerstag 28 Mai 2009 Christoph Hellwig wrote:
> The Linux port of xfs_reno

When used, does it move inodes on disk, or just change the numbers?

Because there seems to be still danger on inode64, would it be worth to=20
sometimes run xfs_reno to get most files back to inode32, but still=20
mount with inode64? I know this would create big inodes again, but at=20
least old data would be safe.

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart1395188.s3BalkoJBi
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkofgpcACgkQzhSR9xwSCbSsowCgw5cWr/ZSqv8FtG7z7hEieLBQ
1mAAn37xVA+EfhR5PKj/58lgOWtnCDYI
=pX1q
-----END PGP SIGNATURE-----

--nextPart1395188.s3BalkoJBi--


--===============0756524896186902661==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0756524896186902661==--
