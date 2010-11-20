Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAK8Rc3m216282 for <xfs@oss.sgi.com>; Sat, 20 Nov 2010 02:27:39 -0600
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 120301C5D979
	for <xfs@oss.sgi.com>; Sat, 20 Nov 2010 00:29:11 -0800 (PST)
Received: from mailsrv14.zmi.at (mailsrv1.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id SVjcfiDJfFRN3NW8 for
	<xfs@oss.sgi.com>; Sat, 20 Nov 2010 00:29:11 -0800 (PST)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: [PATCH] xfs: fix exporting with left over 64-bit inodes
Date: Sat, 20 Nov 2010 09:29:06 +0100
References: <20101119133848.GA5471@infradead.org>
In-Reply-To: <20101119133848.GA5471@infradead.org>
MIME-Version: 1.0
Message-Id: <201011200929.08113@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4319996739810552517=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Samuel Kvasnica <samuel.kvasnica@ims.co.at>

--===============4319996739810552517==
Content-Type: multipart/signed;
  boundary="nextPart1766995.hMHhR4G3Qy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart1766995.hMHhR4G3Qy
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 19. November 2010 Christoph Hellwig wrote:
> We now support mounting and using filesystems with 64-bit inodes even
> when not mounted with the inode64 option (which now only controls if
> we allocate new inodes in that space or not).  Make sure we always
> use large NFS file handles when exporting a filesystem that may
> contain 64-bit inodes.  Note that this only affects newly generated
> file handles, any outstanding 32-bit file handle is still accepted.

Could that help with the problem of not being able to mount an NFS share=20
when the top shared dir itself is a 64bit inode?

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

--nextPart1766995.hMHhR4G3Qy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkznhtMACgkQzhSR9xwSCbSviQCfcA4UsdxoNp9PaB51eIVPeAAN
KQwAn1q9uPD46toN0xfBiAUbfz+swWVG
=xbly
-----END PGP SIGNATURE-----

--nextPart1766995.hMHhR4G3Qy--


--===============4319996739810552517==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4319996739810552517==--
