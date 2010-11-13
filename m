Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oADF502v009227 for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 09:05:00 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 019B61C3C74D
	for <xfs@oss.sgi.com>; Sat, 13 Nov 2010 07:06:28 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id MnQDi8fPwlr2GON9 for
	<xfs@oss.sgi.com>; Sat, 13 Nov 2010 07:06:28 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: reducing imaxpct on linux
Date: Sat, 13 Nov 2010 16:06:20 +0100
References: <1289561141.20961.24.camel@sekli> <201011121618.09040@zmi.at>
	<4CDDC2E0.3060000@sandeen.net>
In-Reply-To: <4CDDC2E0.3060000@sandeen.net>
MIME-Version: 1.0
Message-Id: <201011131606.24781@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0459016129001741077=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: "CZEH, Istvan" <iczeh@virusbuster.hu>, Eric Sandeen <sandeen@sandeen.net>

--===============0459016129001741077==
Content-Type: multipart/signed;
  boundary="nextPart1948835.AmDSFuf4nf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1948835.AmDSFuf4nf
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 12. November 2010 Eric Sandeen wrote:
> I don't think that follows; when you mount with inode64, inodes can
> be allocated anywhere.  Even if you previously mounted without it.
>=20
> What is required, though, is some contiguous space to allocate an
> inode cluster into.  That could be the problem.

In his first mail, the OP said there are 9TB free space. I can't believe=20
that space would be so scattered that you can't find a free space for=20
new inodes.

BTW: What size requirement is there for contig. inode space?

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

--nextPart1948835.AmDSFuf4nf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkzeqXAACgkQzhSR9xwSCbSihwCgx3YaRl3Q+O7M7S/fWwQTeq1e
LwsAmwQR8xBV7YkKNH9f3Fp2IzXpMlPT
=es/D
-----END PGP SIGNATURE-----

--nextPart1948835.AmDSFuf4nf--


--===============0459016129001741077==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0459016129001741077==--
