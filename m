Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o86NVC5E206879 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 18:31:12 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63ABAD91637
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 16:42:56 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id kFBJeHB2HJ0El6IX for
	<xfs@oss.sgi.com>; Mon, 06 Sep 2010 16:42:56 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 7EEC817C
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 01:31:50 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 41DF9401C2E
	for <xfs@oss.sgi.com>; Tue,  7 Sep 2010 01:31:50 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: xfs mount/create options (was: XFS status update for August 2010)
Date: Tue, 7 Sep 2010 01:31:49 +0200
References: <4C857152.4060904@sauce.co.nz>
In-Reply-To: <4C857152.4060904@sauce.co.nz>
MIME-Version: 1.0
Message-Id: <201009070131.49759@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1765158231152777363=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============1765158231152777363==
Content-Type: multipart/signed;
  boundary="nextPart1949719.AnnigDAlMv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1949719.AnnigDAlMv
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Dienstag, 7. September 2010 Richard Scobie wrote:
> > When I defined su/sw on mkfs, is it enough, or would I always have
> > to specify sunit/swidth with every mount too?
>=20
> Yes. sunit/swidth only needs to be added to your fstab if you either
>  got  the calculation wrong when you initially created the fs and
>  wish to correct it, or if you grow the fs later over more drives.

Thank you.
=20
> Note that with recent kernels, mkfs.xfs will choose the optimal=20
> sunit/swidth for you if you are using md RAID or LVM (I believe the=20
> latter is correct).

I don't use software RAID, but thanks for clarification.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=E4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart1949719.AnnigDAlMv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyFeeUACgkQzhSR9xwSCbTgewCdHvpKaE5eWW7X3Av8Xjvzb9L3
AwgAniqEVRSpBVUVqxrU7FWq6pruU5O3
=CPtp
-----END PGP SIGNATURE-----

--nextPart1949719.AnnigDAlMv--


--===============1765158231152777363==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1765158231152777363==--
