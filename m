Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7E19V8B063464 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 20:09:47 -0500
Received: from mailsrv1.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 97F183CB055
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:10:06 -0700 (PDT)
Received: from mailsrv1.zmi.at (mailsrv1.zmi.at [212.69.162.198]) by
	cuda.sgi.com with ESMTP id StQ6E9yN1xtWaJNG for
	<xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:10:06 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Resizing XFS on GPT partition
Date: Fri, 14 Aug 2009 03:09:29 +0200
References: <200908140148.28810@zmi.at> <4A84AF6C.3010801@sandeen.net>
In-Reply-To: <4A84AF6C.3010801@sandeen.net>
MIME-Version: 1.0
Message-Id: <200908140309.34058@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1562202076616467498=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>

--===============1562202076616467498==
Content-Type: multipart/signed;
  boundary="nextPart37899587.xJ3sraQm2n";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart37899587.xJ3sraQm2n
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Freitag 14 August 2009 Eric Sandeen wrote:
> File a bug against parted. =A0:)

You think that's easy? I went there:
http://parted.alioth.debian.org/cgi-bin/trac.cgi/newticket#preview
And always got this:
500 Internal Server Error (Submission rejected as potential spam)

After creating an account the text was accepted:
http://parted.alioth.debian.org/cgi-bin/trac.cgi/ticket/222

> I agree, parted should just resize the partition as you asked and
> shut up about anything else. =A0I'm surprised that it can't - even if
> the fs is unmounted?

Yes, unmounted, of course. They are strange. They know xfs does this=20
only when online. I wonder what they will write about my report.

> I have no idea what happened to "do one thing and do it well." =A0:)

Yes, KISS (keep it small and simple).

mfg zmi
=2D-=20
// Michael Monnerie, Ing.BSc    -----      http://it-management.at
// Tel: 0660 / 415 65 31                      .network.your.ideas.
// PGP Key:         "curl -s http://zmi.at/zmi.asc | gpg --import"
// Fingerprint: AC19 F9D5 36ED CD8A EF38  500E CE14 91F7 1C12 09B4
// Keyserver: wwwkeys.eu.pgp.net                  Key-ID: 1C1209B4


--nextPart37899587.xJ3sraQm2n
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkqEuU0ACgkQzhSR9xwSCbTY7QCeLf+WHU33ihfcBXvXUmo5Flbj
RdAAoON65huS32JgjlJ39LSIHn+Bz8tT
=ZxAD
-----END PGP SIGNATURE-----

--nextPart37899587.xJ3sraQm2n--


--===============1562202076616467498==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1562202076616467498==--
