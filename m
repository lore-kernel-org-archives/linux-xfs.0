Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7JCiuqm171589 for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 07:44:56 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DFC2E1E4C4B4
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 05:45:24 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id ha9hV9Oz40dGKela for
	<xfs@oss.sgi.com>; Thu, 19 Aug 2010 05:45:24 -0700 (PDT)
Received: from mailsrv.i.zmi.at (h081217106033.dyn.cm.kabsi.at [81.217.106.33])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(Client CN "mailsrv2.i.zmi.at", Issuer "power4u.zmi.at" (not verified))
	by mailsrv14.zmi.at (Postfix) with ESMTPSA id 69432701
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 14:45:23 +0200 (CEST)
Received: from saturn.localnet (saturn.i.zmi.at [10.72.27.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	by mailsrv.i.zmi.at (Postfix) with ESMTPSA id 08DFB401C3A
	for <xfs@oss.sgi.com>; Thu, 19 Aug 2010 14:45:23 +0200 (CEST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Date: Thu, 19 Aug 2010 14:45:22 +0200
References: <201008191312.49346@zmi.at> <20100819120512.GB9358@infradead.org>
In-Reply-To: <20100819120512.GB9358@infradead.org>
MIME-Version: 1.0
Message-Id: <201008191445.22568@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2249586217027161232=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============2249586217027161232==
Content-Type: multipart/signed;
  boundary="nextPart4567438.0lh2FLJA9i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4567438.0lh2FLJA9i
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Donnerstag, 19. August 2010 Christoph Hellwig wrote:
> The creation and deletion performance is a known issue, and too a
>  large extent fixes by the new delaylog code.  We're not quite as
>  fast as ext4 yet, but it's getting close.
>=20
> The repair result looks a lot like the pre-3.1.0 xfsprogs repair.
=20
Yes I know. I thought some XFS dev might contact the Author to do some=20
re-testing, as a reputation is quickly destroyed by such articles and=20
takes long to be returned. Just this week I had a friend in a FS=20
discussion saying "ins't XFS destroying/zeroing files on power=20
failure?". That information is ancient, but things like that stay in=20
peoples brain for(almost)ever.


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

--nextPart4567438.0lh2FLJA9i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkxtJ2IACgkQzhSR9xwSCbRPMACeJWWNXtfwlOOjKobwjYGf0jjh
En0AniDOxAhKYoN693iSBTc6GGNO51lH
=OU1R
-----END PGP SIGNATURE-----

--nextPart4567438.0lh2FLJA9i--


--===============2249586217027161232==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2249586217027161232==--
