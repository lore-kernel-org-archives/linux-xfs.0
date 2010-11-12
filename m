Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACD0RD5123238 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 07:00:28 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA63B152301A
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 05:01:55 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id AMKR5klH06ZzeRMX for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 05:01:55 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: reducing imaxpct on linux
Date: Fri, 12 Nov 2010 14:01:47 +0100
References: <1289561141.20961.24.camel@sekli>
In-Reply-To: <1289561141.20961.24.camel@sekli>
MIME-Version: 1.0
Message-Id: <201011121401.52477@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4504760376938640696=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "CZEH, Istvan" <iczeh@virusbuster.hu>

--===============4504760376938640696==
Content-Type: multipart/signed;
  boundary="nextPart4671278.T55hgOVRqF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart4671278.T55hgOVRqF
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 12. November 2010 CZEH, Istvan wrote:
> What could happen if I reduce imaxpct? Is it safe or painful?=20
> What is really a chance that the 25% value is causing the error?

I don't believe reducing imaxpct results in more free space, because=20
that's the *maximum* Inodes can have.

I'm not a dev, but AFAIK the "no free space" problem comes when the=20
space in the first TeraByte is completely filled. I don't remember=20
exactly, either the FAQ tells you or look in the mailinglist archive.=20
The question about "no free space despite enough free" comes rather=20
often.

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

--nextPart4671278.T55hgOVRqF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzdOsAACgkQzhSR9xwSCbSkngCeIE0FwTiAw7WWoagNyRZv8yJ/
qy4AnA/kgoNaLGf7aYoZdAyPv+C+C554
=DRWF
-----END PGP SIGNATURE-----

--nextPart4671278.T55hgOVRqF--


--===============4504760376938640696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4504760376938640696==--
