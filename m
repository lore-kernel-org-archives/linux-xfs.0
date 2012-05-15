Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4F1DSQ8141479 for <xfs@oss.sgi.com>; Mon, 14 May 2012 20:13:29 -0500
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id eFWMzRF3bFi47Ae8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 May 2012 18:13:25 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106014.dyn.cm.kabsi.at [81.217.106.14])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 454D61822433
	for <xfs@oss.sgi.com>; Tue, 15 May 2012 03:13:24 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	by mailsrv.i.zmi.at (Postfix) with ESMTP id B0397CD7C8C
	for <xfs@oss.sgi.com>; Tue, 15 May 2012 03:13:51 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: badly destroyed XFS (on LVM) - how to repair?
Date: Tue, 15 May 2012 03:13:18 +0200
Message-ID: <5127277.p0pxig2sml@saturn>
In-Reply-To: <4FB120DE.4030703@sandeen.net>
References: <1763478.Vy9F5bcWiZ@saturn> <4FB120DE.4030703@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4642161038670440348=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4642161038670440348==
Content-Type: multipart/signed; boundary="nextPart267413382.xEmT7aCZpT"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable


--nextPart267413382.xEmT7aCZpT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Am Montag, 14. Mai 2012, 10:12:30 schrieb Eric Sandeen:
> Anything in dmesg?

No, nothing. Not for lvm, not for xfs.

> You have to mdrestore the metadump before you can point repair it it,=

> so that's not a valid operation.  No=20

Ah, silly me. Right, will try.

> Considering that the problem began when the block device got
> repartitioned etc, I don't see how this can be an XFS problem...

The problem is that xfs_repair does not at all complain, but when I=20
mount it nothing is correct. I cannot even get those data which is at=20=

least displayed normally. xfs_repair doesn't find a problem - that's th=
e=20
problem.

All data should be there. As I understand it, partitioning a disk write=
s=20
to the partition table (sector 0?), the partition created should have=20=

started at sector 63 or 2048, and the "mkswap" will have written only a=
=20
very small amount too. I guess that a very bad block has been hit, but=20=

is really everything lost now?

--=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=C3=A9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

--nextPart267413382.xEmT7aCZpT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+xrbMACgkQzhSR9xwSCbS72QCgm6Low414GttW0ozN18iutbs1
stEAn0+V/tooz1rovo1fmXKdjefAjRYo
=X+F0
-----END PGP SIGNATURE-----

--nextPart267413382.xEmT7aCZpT--


--===============4642161038670440348==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4642161038670440348==--
