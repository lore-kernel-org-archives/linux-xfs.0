Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8NN9sa6169224 for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 18:09:55 -0500
Received: from mailsrv14.zmi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 98EC7160C6B8
	for <xfs@oss.sgi.com>; Fri, 23 Sep 2011 16:15:25 -0700 (PDT)
Received: from mailsrv14.zmi.at (mailsrv14.zmi.at [212.69.164.54]) by
	cuda.sgi.com with ESMTP id JBwEoUu5IWLLObIL for
	<xfs@oss.sgi.com>; Fri, 23 Sep 2011 16:15:25 -0700 (PDT)
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Subject: Re: Directory fsync
Date: Sat, 24 Sep 2011 01:09:44 +0200
References: <CAF7KpS8h2KDsLVzwAj=5ig-yuuiCwjQSVk0Nfy9UJ0qiyAqeCQ@mail.gmail.com>
	<20110923163354.GA24319@infradead.org>
In-Reply-To: <20110923163354.GA24319@infradead.org>
MIME-Version: 1.0
Message-Id: <201109240109.45532@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2315389955827944305=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Zhu Han <schumi.han@gmail.com>

--===============2315389955827944305==
Content-Type: multipart/signed;
  boundary="nextPart5489381.krzLeBB12H";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit

--nextPart5489381.krzLeBB12H
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Freitag, 23. September 2011 Christoph Hellwig wrote:
> As far as standards are concerned it is.  As far as the current XFS
> implementation is concerned you don't need it as the file fsync will
> also force out all transactions that belong to the create.

Aren't you giving O_PONIES to the users? ;-)

I understand your description, but we should always tell people to use a=20
directory fsync to be sure. Their applications might run on other=20
filesystems, or run for 10 years, and maybe XFS's implementation changes=20
in between. And maybe in historical kernels even XFS's implementation=20
wasn't like it's now?

@schumi: If your application should be able to run in a safe way on=20
other filesystems, or other kernel releases, or other unixes, it's best=20
to fsync the directory inode too. It's better to use it always, then=20
nothing won't break.

=2D-=20
mit freundlichen Gr=FCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services: Prot=E9ger
http://proteger.at [gesprochen: Prot-e-schee]
Tel: +43 660 / 415 6531

// Haus zu verkaufen: http://zmi.at/langegg/

--nextPart5489381.krzLeBB12H
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEABECAAYFAk59EbkACgkQzhSR9xwSCbTzNACdHH7qhuzth6Fl7rVazl6/TrXH
G4EAnR7wue/rrP95qyxRheH68eGRmBVf
=BuTy
-----END PGP SIGNATURE-----

--nextPart5489381.krzLeBB12H--


--===============2315389955827944305==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2315389955827944305==--
